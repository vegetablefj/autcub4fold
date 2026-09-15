#!/usr/bin/env python3
"""Run the independent five-dimensional GAP containment computation.

Python starts one GAP process, captures its progress, and checks completion.
Pair decisions, exact input bindings, and all witness checks are made in GAP.
No time limit is imposed. Resuming a previous run must be requested explicitly.
"""

from __future__ import annotations

import argparse
import os
from pathlib import Path
import shlex
import subprocess
import sys
import time


BASE = Path(__file__).resolve().parent
DEFAULT_BASH = Path(r"D:\GAP\runtime\bin\bash.exe")
DEFAULT_GAP = "/opt/gap-4.15.1/gap.exe"
SOURCE = BASE / "result" / "gap_threefold_families.g"


def cygwin_path(path: Path) -> str:
    resolved = path.resolve()
    drive, tail = os.path.splitdrive(str(resolved))
    if not drive:
        raise ValueError(f"Expected an absolute Windows path: {resolved}")
    relative = tail.lstrip("\\/").replace("\\", "/")
    return f"/cygdrive/{drive[0].lower()}/{relative}"


def gap_command(script: str, arguments: list[int], executable: str) -> str:
    command = (
        f"cd {shlex.quote(cygwin_path(BASE))} && "
        f"{shlex.quote(executable)} -r -q -b {shlex.quote(script)}"
    )
    if arguments:
        command += " " + " ".join(str(value) for value in arguments)
    return command


def run_gap(bash: Path, executable: str, script: str, arguments: list[int],
            log: Path, marker: str) -> str:
    started = time.monotonic()
    log.parent.mkdir(parents=True, exist_ok=True)
    print(f"Running {script}; progress: {log}", flush=True)
    with log.open("w", encoding="utf-8", newline="") as stream:
        process = subprocess.Popen(
            [str(bash), "-lc", gap_command(script, arguments, executable)],
            stdout=stream, stderr=subprocess.STDOUT, stdin=subprocess.DEVNULL,
        )
        try:
            returncode = process.wait()
        except KeyboardInterrupt:
            # Stop only this launcher's process tree, never other GAP jobs.
            subprocess.run(
                ["taskkill", "/PID", str(process.pid), "/T", "/F"],
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=False,
            )
            process.wait()
            raise
    text = log.read_text(encoding="utf-8", errors="replace")
    if returncode != 0 or marker not in text or any(
        problem in text for problem in ("Error,", "Syntax error", "Syntax warning")
    ):
        tail = " | ".join(line.strip() for line in text.splitlines()[-12:])
        raise RuntimeError(
            f"{script} did not finish cleanly (rc={returncode}): {tail}"
        )
    print(f"{marker}; elapsed {time.monotonic()-started:.1f}s", flush=True)
    return text


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--bash", type=Path,
                        default=Path(os.environ.get("GAP_BASH", DEFAULT_BASH)))
    parser.add_argument("--gap", default=os.environ.get("GAP_EXECUTABLE", DEFAULT_GAP))
    parser.add_argument(
        "--resume", action="store_true",
        help=("explicitly reuse completed pair prefixes only after confirming "
              "that the shared GAP algorithm has not changed; GAP compares "
              "all 40 exact generator/metadata bindings and rechecks saved P"),
    )
    parser.add_argument("--first-row", type=int, default=1)
    parser.add_argument("--last-row", type=int, default=40)
    parser.add_argument("--self-test", action="store_true",
                        help="run only independent positive/negative five-dimensional regressions")
    parser.add_argument(
        "--no-report", action="store_true",
        help="save direct pair results without running the cheap containment report",
    )
    args = parser.parse_args()
    if not 1 <= args.first_row <= args.last_row <= 40:
        parser.error("row bounds must satisfy 1 <= first <= last <= 40")
    if not args.bash.exists():
        parser.error(f"Windows GAP runtime was not found: {args.bash}")
    if not SOURCE.exists():
        parser.error(f"Final presentation catalogue was not found: {SOURCE}")
    shared = BASE.parent / "gap_functions.g"
    if not shared.exists():
        parser.error(f"Shared GAP functions were not found: {shared}")
    if args.resume:
        print("Explicit resume: exact catalogue bindings will be checked in GAP; "
              "this option confirms the shared algorithm is unchanged.", flush=True)
    full = args.first_row == 1 and args.last_row == 40
    if args.self_test:
        marker = "THREEFOLD_CROSS_DIMENSION_SELF_TEST_COMPLETED"
        log_name = "gap_threefold_cross_dimension_self_test.log"
    else:
        marker = ("THREEFOLD_CROSS_DIMENSION_COMPLETED" if full
                  else "THREEFOLD_CROSS_DIMENSION_ROWS_COMPLETED")
        log_name = "gap_threefold_cross_dimension_stdout.log"
    watched = [SOURCE, shared, BASE / "gap_threefold_cross_dimension.g"]
    frozen = [path.read_bytes() for path in watched]
    try:
        text = run_gap(args.bash, args.gap, "gap_threefold_cross_dimension.g",
                       [int(args.resume), args.first_row, args.last_row,
                        int(args.self_test)], BASE / "output" / log_name, marker)
        if any(path.read_bytes() != data for path, data in zip(watched, frozen)):
            raise RuntimeError("An input/algorithm file changed while GAP was running; "
                               "the saved run must not be accepted as a final certificate.")
        if not args.self_test and full:
            if "THREEFOLD_CROSS_DIMENSION_COMPLETED undecided=0" not in text:
                print("Unresolved pairs remain; they are not negative results. "
                      "The final containment report was not run.", flush=True)
                return 2
            for name in ("gap_threefold_cross_dimension_all_pairs.g",
                         "gap_threefold_cross_dimension_manifest.g"):
                if not (BASE / "result" / name).exists():
                    raise RuntimeError(f"Missing direct result: {name}")
            if not args.no_report:
                run_gap(args.bash, args.gap, "gap_threefold_containment.g", [],
                        BASE / "output" / "gap_threefold_containment_stdout.log",
                        "THREEFOLD_CONTAINMENT_COMPLETED")
    except KeyboardInterrupt:
        print("Stopped. Completed pair prefixes remain in output/threefold_direct_row_*.g.",
              file=sys.stderr)
        return 130
    except (OSError, RuntimeError, ValueError) as error:
        print(f"Run failed: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
