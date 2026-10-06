"""Check the saved Brown rerun files without loading OSCAR.

This checks expected files, recorded statuses, and MRDI hashes against the
captured console output. It does not repeat the mathematical postchecks or
query the Slurm scheduler.
"""

from __future__ import annotations

import hashlib
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parent / "results" / "2026-10-05"
HIGH_RANK = (
    (1, 7017745, 0),
    (3, 7017746, 1),
    (4, 7017825, 2),
    (7, 7017833, 3),
    (8, 7017916, 4),
    (9, 7017668, None),
    (11, 7017919, 5),
    (16, 7017964, 6),
    (19, 7017970, 7),
    (34, 7018083, 8),
)
CYCLIC = (
    (152, 16, 7018088, 9, 4),
    (154, 24, 7018186, 10, 4),
    (155, 32, 7017669, None, 8),
    (156, 48, 7017743, 11, 8),
)


def require(ok: bool, message: str) -> None:
    if not ok:
        raise SystemExit(f"FAIL: {message}")


def text(path: Path) -> str:
    require(path.is_file(), f"missing {path}")
    return path.read_text(encoding="utf-8")


def digest(path: Path) -> str:
    require(path.is_file() and path.stat().st_size > 0, f"missing or empty {path}")
    sha = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            sha.update(chunk)
    return sha.hexdigest()


def console(job: int, task: int | None, kind: str) -> str:
    name = (
        f"remark-rerun-7017743_{task}.out"
        if task is not None
        else f"{kind}-{job}.out"
    )
    output = text(ROOT / "slurm" / name)
    require((ROOT / "slurm" / name.replace(".out", ".err")).is_file(),
            f"missing stderr for {job}")
    return output


def check_status(folder: Path, stem: str) -> None:
    require(text(folder / f"{stem}.status.txt").startswith("COMPLETED"),
            f"incomplete Julia status for {stem}")
    require(text(folder / "postcheck.status.txt").strip() == "PASSED",
            f"postcheck not passed for {stem}")


def high_rank() -> None:
    for number, job, task in HIGH_RANK:
        stem = f"family_{number:03d}"
        folder = ROOT / "results" / "highrank" / f"job_{job}"
        check_status(folder, stem)
        require(f"PASS No. {number}: saved 1 ambient witnesses" in
                text(folder / f"{stem}.log"), f"unexpected result for No. {number}")
        output = console(job, task, "highrank")
        match = re.search(r"sidecar_sha256=([0-9a-f]{64})", output)
        require(match is not None, f"no console hash for No. {number}")
        require(digest(folder / f"{stem}.mrdi") == match.group(1),
                f"MRDI hash mismatch for No. {number}")
        require(f"family={number} verified=" in output,
                f"no final verification line for No. {number}")


def cyclic() -> None:
    for number, order, job, task, retained in CYCLIC:
        stem = f"family_{number}_phi{order}_shared_oscar18"
        folder = ROOT / "results" / "cyclic_s0" / f"family_{number}" / f"job_{job}"
        check_status(folder, stem)
        require("Completed; MRDI reload and post-checks passed" in
                text(folder / f"{stem}.log"), f"no reload check for No. {number}")
        require(f"Retained outputs: {retained}." in
                text(folder / f"{stem}_result.md"),
                f"unexpected retained count for No. {number}")
        output = console(job, task, "cyclic-s0")
        match = re.search(rf"{number}: MRDI SHA256 ([0-9a-f]{{64}})", output)
        require(match is not None, f"no console hash for No. {number}")
        require(digest(folder / f"{stem}.mrdi") == match.group(1),
                f"MRDI hash mismatch for No. {number}")
        require(f"{number}: all {retained} primitive root pairs occur exactly once"
                in output, f"incomplete eigenpair check for No. {number}")
        require(f"family={number} verified=" in output,
                f"no final verification line for No. {number}")


if __name__ == "__main__":
    high_rank()
    cyclic()
    print("PASS: 14 saved MRDI files, statuses, postchecks, and console hashes agree")
    print("Scope: saved-file consistency only; no OSCAR or Slurm rerun")
