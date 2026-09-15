#!/usr/bin/env python3
"""Run the GAP proof of all cross-dimensional fourfold containments.

Python only schedules GAP processes and checks completion markers.  Every
mathematical decision, witness verification, and completeness audit is made
inside GAP.
"""

from __future__ import annotations

import argparse
import concurrent.futures
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys
import time


BASE = Path(__file__).resolve().parent
SOURCE = BASE / "input" / "fourfold_search_catalogue.g"
DEFAULT_BASH = Path(r"D:\GAP\runtime\bin\bash.exe")
DEFAULT_GAP = "/opt/gap-4.15.1/gap.exe"


def cygwin_path(path: Path) -> str:
    resolved = path.resolve()
    drive, tail = os.path.splitdrive(str(resolved))
    if not drive:
        raise ValueError(f"Expected an absolute Windows path: {resolved}")
    relative = tail.lstrip("\\/").replace(os.sep, "/")
    return f"/cygdrive/{drive[0].lower()}/{relative}"


def gap_command(script: str, arguments: list[int], gap_executable: str) -> str:
    base = shlex.quote(cygwin_path(BASE))
    args = " ".join(str(value) for value in arguments)
    return (
        f"cd {base} && {shlex.quote(gap_executable)} -r -q -b "
        f"{shlex.quote(script)}" + (f" {args}" if args else "")
    )


def run_gap(
    bash: Path,
    gap_executable: str,
    script: str,
    arguments: list[int],
    log: Path,
) -> tuple[int, float, str]:
    started = time.monotonic()
    log.parent.mkdir(parents=True, exist_ok=True)
    with log.open("w", encoding="utf-8", newline="") as stream:
        completed = subprocess.run(
            [str(bash), "-lc", gap_command(script, arguments, gap_executable)],
            stdout=stream,
            stderr=subprocess.STDOUT,
            check=False,
        )
    elapsed = time.monotonic() - started
    text = log.read_text(encoding="utf-8", errors="replace")
    return completed.returncode, elapsed, text


def valid_log(log: Path, marker: str, output: Path) -> bool:
    if not log.exists() or not output.exists():
        return False
    text = log.read_text(encoding="utf-8", errors="replace")
    return marker in text and "undecided=0" in text and "Error," not in text


def run_small_row(
    index: int,
    bash: Path,
    gap_executable: str,
    resume: bool,
) -> tuple[int, bool, float, str]:
    output = BASE / "output" / "small_rows" / f"row_{index}.g"
    log = BASE / "output" / "small_rows" / f"row_{index}.log"
    if resume and valid_log(log, "SMALL_ROW_DONE", output):
        return index, True, 0.0, "resumed"
    returncode, elapsed, text = run_gap(
        bash,
        gap_executable,
        "gap_run_small_row.g",
        [index],
        log,
    )
    valid = (
        returncode == 0
        and output.exists()
        and "SMALL_ROW_DONE" in text
        and "undecided=0" in text
        and "Error," not in text
    )
    tail = " | ".join(line.strip() for line in text.splitlines()[-6:])
    return index, valid, elapsed, tail


def read_large_schedule() -> list[tuple[int, int]]:
    path = BASE / "input" / "large_target_schedule.g"
    text = path.read_text(encoding="utf-8")
    records = re.findall(r"rec\((.*?)\)", text, flags=re.DOTALL)
    schedule: list[tuple[int, int]] = []
    for record in records:
        layer_match = re.search(r"layer\s*:=\s*(\d+)", record)
        number_match = re.search(r"number\s*:=\s*(\d+)", record)
        if layer_match and number_match:
            schedule.append((int(layer_match.group(1)), int(number_match.group(1))))
    if len(schedule) != 14:
        raise RuntimeError(f"Expected 14 large targets, found {len(schedule)}")
    return schedule


def require_stage(
    bash: Path,
    gap_executable: str,
    script: str,
    log_name: str,
    marker: str,
) -> None:
    returncode, elapsed, text = run_gap(
        bash,
        gap_executable,
        script,
        [],
        BASE / "output" / log_name,
    )
    if returncode != 0 or marker not in text or "Error," in text:
        tail = " | ".join(line.strip() for line in text.splitlines()[-12:])
        raise RuntimeError(
            f"{script} failed after {elapsed:.1f}s (rc={returncode}): {tail}"
        )
    print(f"{marker} elapsed={elapsed:.1f}s", flush=True)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--workers",
        type=int,
        default=min(6, max(2, (os.cpu_count() or 4) // 2)),
        help="number of parallel GAP processes for the 142 small rows",
    )
    parser.add_argument(
        "--bash",
        type=Path,
        default=Path(os.environ.get("GAP_BASH", DEFAULT_BASH)),
        help="Windows GAP runtime bash.exe",
    )
    parser.add_argument(
        "--gap",
        default=os.environ.get("GAP_EXECUTABLE", DEFAULT_GAP),
        help="GAP executable path inside the GAP runtime",
    )
    recovery = parser.add_mutually_exclusive_group()
    recovery.add_argument(
        "--resume-small",
        action="store_true",
        help=("reuse completed small rows only after confirming that the algorithm "
              "has not changed; the frozen input is compared in memory"),
    )
    recovery.add_argument(
        "--overwrite-small",
        action="store_true",
        help="rerun all small rows (the default; retained for compatibility)",
    )
    args = parser.parse_args()

    if args.workers < 1:
        parser.error("--workers must be positive")
    if not args.bash.exists():
        parser.error(f"Windows GAP runtime was not found: {args.bash}")
    if not SOURCE.exists():
        parser.error(f"Final 156-family input was not found: {SOURCE}")

    for path in (
        BASE / "input",
        BASE / "output" / "small_rows",
        BASE / "output" / "large_targets",
        BASE / "audit",
        BASE / "result",
    ):
        path.mkdir(parents=True, exist_ok=True)

    frozen_paths = (
        BASE / "input" / "fourfold_156.g",
        BASE / "input" / "fourfold_small.g",
        BASE / "input" / "large_target_schedule.g",
    )
    old_input = None
    if args.resume_small:
        if not all(path.exists() for path in frozen_paths):
            print("ABORT: --resume-small requires the existing frozen input files.",
                  file=sys.stderr)
            return 2
        old_input = tuple(path.read_bytes() for path in frozen_paths)
        print("SMALL_RESUME_REQUESTED: the caller confirms the algorithm is unchanged.",
              flush=True)

    started = time.monotonic()
    print("PREPARE_INPUT_START", flush=True)
    require_stage(
        args.bash,
        args.gap,
        "gap_prepare_input.g",
        "prepare_input.log",
        "INPUT_READY",
    )
    if old_input is not None and old_input != tuple(
        path.read_bytes() for path in frozen_paths
    ):
        print("ABORT: the frozen input changed; no saved row was reused. "
              "Archive the previous outputs and restart without --resume-small.",
              file=sys.stderr)
        return 2

    print(
        f"SMALL_STAGE_START rows=142 workers={args.workers} ",
        f"resume={args.resume_small}",
        flush=True,
    )
    failures: list[tuple[int, str]] = []
    completed_count = 0
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as executor:
        futures = [
            executor.submit(
                run_small_row,
                index,
                args.bash,
                args.gap,
                args.resume_small,
            )
            for index in range(1, 143)
        ]
        for future in concurrent.futures.as_completed(futures):
            index, valid, elapsed, detail = future.result()
            completed_count += 1
            if valid:
                state = "SKIP" if detail == "resumed" else "OK"
                print(
                    f"SMALL_ROW_{state} position={index:03d} "
                    f"elapsed={elapsed:.1f}s progress={completed_count}/142",
                    flush=True,
                )
            else:
                failures.append((index, detail))
                print(
                    f"SMALL_ROW_FAIL position={index:03d} "
                    f"elapsed={elapsed:.1f}s progress={completed_count}/142 "
                    f"tail={detail}",
                    flush=True,
                )
    if failures:
        print(f"ABORT: {len(failures)} small rows failed.", file=sys.stderr)
        return 1

    require_stage(
        args.bash,
        args.gap,
        "gap_aggregate_small.g",
        "aggregate_small.log",
        "SMALL_AGGREGATION_DONE",
    )

    schedule = read_large_schedule()
    print(f"LARGE_STAGE_START layers={len(schedule)}", flush=True)
    for layer, number in schedule:
        output = BASE / "output" / "large_targets" / f"layer_{layer}_family_{number}.g"
        log = BASE / "output" / "large_targets" / f"layer_{layer}_family_{number}.log"
        returncode, elapsed, text = run_gap(
            args.bash,
            args.gap,
            "gap_run_large_target.g",
            [layer, number],
            log,
        )
        valid = (
            returncode == 0
            and output.exists()
            and "LARGE_TARGET_DONE" in text
            and "undecided=0" in text
            and "coverage=complete" in text
            and "Error," not in text
        )
        marker = next(
            (line.strip() for line in text.splitlines() if "LARGE_TARGET_DONE" in line),
            "",
        )
        if not valid:
            tail = " | ".join(line.strip() for line in text.splitlines()[-12:])
            print(
                f"LARGE_TARGET_FAIL layer={layer} family={number} "
                f"rc={returncode} elapsed={elapsed:.1f}s tail={tail}",
                file=sys.stderr,
                flush=True,
            )
            return 1
        print(f"{marker} elapsed={elapsed:.1f}s", flush=True)

    require_stage(
        args.bash,
        args.gap,
        "gap_finalize.g",
        "finalize.log",
        "FOURFOLD_CROSS_DIMENSION_DONE",
    )
    require_stage(
        args.bash,
        args.gap,
        "gap_coordinate_containment.g",
        "coordinate_containment.log",
        "FOURFOLD_COORDINATE_CONTAINMENT_COMPLETED",
    )
    require_stage(
        args.bash,
        args.gap,
        "gap_fourfold_maximal.g",
        "fourfold_maximal_console.log",
        "FOURFOLD_MAXIMAL_COMPLETED",
    )
    total = time.monotonic() - started
    print(f"CROSS_DIMENSION_RUN_DONE elapsed={total:.1f}s", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
