#!/usr/bin/env python3
"""Run a manuscript validation stage with the Windows GAP runtime."""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
from pathlib import Path
import shlex
import subprocess
import time


BASE = Path(__file__).resolve().parent
REPOSITORY = BASE.parent.parent


def cygwin_path(path: Path) -> str:
    resolved = path.resolve()
    if not resolved.drive:
        raise ValueError("A Windows drive path is required.")
    return "/cygdrive/" + resolved.drive[0].lower() + resolved.as_posix()[2:]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("script", help="GAP driver within this folder")
    parser.add_argument("--bash", default=r"D:\GAP\runtime\bin\bash.exe")
    parser.add_argument("--gap", default="/opt/gap-4.15.1/gap.exe")
    args = parser.parse_args()
    script = (BASE / args.script).resolve()
    if script.parent != BASE or script.suffix != ".g" or not script.is_file():
        parser.error("Choose an existing GAP driver in this folder.")
    command = (
        f"cd {shlex.quote(cygwin_path(REPOSITORY))} && "
        f"{shlex.quote(args.gap)} -r -q -b "
        f"{shlex.quote(cygwin_path(script))}"
    )
    log = script.with_suffix(".raw.log")
    print(f"Started {script.name}; transcript: {log.name}", flush=True)
    started_utc = datetime.now(timezone.utc).isoformat()
    started = time.monotonic()
    with log.open("w", encoding="utf-8", newline="") as stream:
        process = subprocess.Popen(
            [args.bash, "-lc", command], stdout=stream,
            stderr=subprocess.STDOUT, stdin=subprocess.DEVNULL,
        )
        try:
            returncode = process.wait()
        except KeyboardInterrupt:
            # Stop this launcher's process tree, not unrelated GAP sessions.
            subprocess.run(
                ["taskkill", "/PID", str(process.pid), "/T", "/F"],
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=False,
            )
            process.wait()
            return 130
    elapsed = time.monotonic() - started
    transcript = log.read_text(encoding="utf-8", errors="replace")
    metadata = script.with_suffix(".runtime.txt")
    relative_script = script.relative_to(REPOSITORY).as_posix()
    metadata.write_text(
        f"script = {script.name}\n"
        f"started_utc = {started_utc}\n"
        "working_directory = repository root\n"
        f"invocation = GAP -r -q -b {relative_script}\n"
        "command = [local absolute paths omitted from this runtime record]\n"
        f"exit_code = {returncode}\n"
        f"elapsed_seconds = {elapsed:.3f}\n",
        encoding="utf-8",
    )
    print(transcript[-4000:], end="", flush=True)
    print(f"Elapsed {elapsed:.1f} s; exit code {returncode}")
    # GAP may enter its break loop and subsequently exit zero on EOF.
    if returncode or "Error," in transcript or "Syntax error" in transcript:
        return 1
    if "VALIDATION_COMPLETE" not in transcript:
        print("Missing validation completion marker.")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
