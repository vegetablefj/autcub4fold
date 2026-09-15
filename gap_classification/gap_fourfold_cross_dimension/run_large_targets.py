"""Serial large-target rerun, reusing and auditing our completed small rows.

All large layers are recomputed by default. An explicit --resume-prefix N
request confirms that the frozen input and algorithm have not changed.
GAP checks coverage and positive witnesses before restoring that prefix;
saved negative decisions are not recomputed during recovery.
All mathematical checks run in GAP.
"""
from __future__ import annotations

import argparse
from datetime import datetime
from pathlib import Path
import re
import sys
import time

from run_cross_dimension import BASE, SOURCE, DEFAULT_BASH, DEFAULT_GAP, read_large_schedule, run_gap


def write_timing_report(records: list[dict], final_audit_seconds: float,
                        resumed_prefix: int) -> None:
    """Describe saved measurements; this does not make containment decisions."""
    lines = ["# Large-target run timings", "",
             "Windows GAP; one serial worker. Wall times include process startup,",
             "preprocessing, exact decisions, witness construction, propagation, and output.", "",
             "The 142 saved small rows were reused and reaudited, not re-enumerated.", "",
             "A resumed layer has no newly measured wall time; its GAP CPU times",
             "remain in its original log. A dash denotes an unmeasured wall time.", "",
             "| Layer | Target family | Pairs | Direct | Inferred | Wall seconds | Target preparation CPU seconds |",
             "|---:|---:|---:|---:|---:|---:|---:|"]
    pairs = []
    for record in records:
        text = (BASE/f"output/large_targets/layer_{record['layer']}_family_{record['family']}.log").read_text()
        done = next(line for line in text.splitlines() if line.startswith("LARGE_TARGET_DONE"))
        counts = dict(re.findall(r"(\w+)=(\S+)",done))
        prepared = next(line for line in text.splitlines() if line.startswith("LARGE_TARGET_PREPARED"))
        preparation = int(dict(re.findall(r"(\w+)=(\S+)",prepared))["cpu_ms"])/1000
        if int(counts["direct"]) + int(counts["inferred"]) != int(counts["candidates"]):
            raise RuntimeError("Inconsistent timing-log pair counts.")
        wall = ("--" if record['elapsed_seconds'] is None
                else f"{record['elapsed_seconds']:.3f}")
        lines.append(f"| {record['layer']} | {record['family']} | {counts['candidates']} | "
                     f"{counts['direct']} | {counts['inferred']} | {wall} | {preparation:.3f} |")
        pairs.extend(dict(re.findall(r"(\w+)=(\S+)",line)) for line in text.splitlines()
                     if line.startswith("LARGE_PAIR_DONE"))
    measured = [r['elapsed_seconds'] for r in records if r['elapsed_seconds'] is not None]
    lines += ["",f"Measured large-layer wall time in this invocation: {sum(measured):.3f} seconds.",
              f"Recovered prefix layers: {resumed_prefix}.",
              f"Final all-pairs audit: {final_audit_seconds:.3f} seconds.","",
              "## Slowest direct pairs", "",
              "These CPU times include source preprocessing, the search, and witness recovery;",
              "they exclude the subsequent propagation to other sources. They are not wall times.","",
              "| Source family | Target family | CPU seconds | Status | Reason |",
              "|---:|---:|---:|---|---|"]
    for pair in sorted(pairs,key=lambda p:int(p["cpu_ms"]),reverse=True)[:15]:
        lines.append(f"| {pair['source']} | {pair['target']} | {int(pair['cpu_ms'])/1000:.3f} | "
                     f"{pair['status']} | `{pair['reason']}` |")
    lines += ["", "## Interpretation", "",
              "Family 23 uses target subgroup conjugacy classes instead of the previous generic",
              "isomorphic-subgroup backend; its measured time is listed above.", "",
              "Some slow negative pairs involve diagonal sources 151 and 152. An exponent rejection",
              "is checked immediately after source preprocessing, so these times are not subgroup",
              "enumeration times. Target preparation is measured separately in the first table.", "",
              "The serial baseline is retained without mid-run algorithm changes. Faster diagonal",
              "preprocessing or earlier generator-order filters are possible future optimizations;",
              "they are not assumptions used to obtain the present results.", ""]
    (BASE/"result/gap_fourfold_cross_dimension_timing.md").write_text("\n".join(lines),encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--bash", type=Path, default=DEFAULT_BASH)
    parser.add_argument("--gap", default=DEFAULT_GAP)
    parser.add_argument("--resume-prefix", type=int, default=0,
                        help=("recover exactly N completed large layers only after "
                              "confirming the same frozen input and algorithm; "
                              "saved negatives are not recomputed (default: 0)"))
    args = parser.parse_args()
    if not 0 <= args.resume_prefix <= 14:
        parser.error("--resume-prefix must be between 0 and 14")
    if not args.bash.exists():
        parser.error(f"Windows GAP runtime was not found: {args.bash}")
    if not SOURCE.exists():
        parser.error(f"Final 156-family input was not found: {SOURCE}")
    schedule = read_large_schedule()
    started = time.monotonic()
    records = []

    def stage(script: str, arguments: list[int], log: Path, marker: str) -> tuple[float,str]:
        rc, elapsed, text = run_gap(args.bash,args.gap,script,arguments,log)
        if rc != 0 or marker not in text or "Error," in text:
            raise RuntimeError(f"{script}: rc={rc}; log={log}\n{text[-2500:]}")
        return elapsed,text

    print("LARGE_RERUN_START workers=1 backend=subgroup_classes_full_aut",flush=True)
    elapsed,_ = stage("gap_test_large_embedding.g",[],BASE/"output/test_large_embedding.log",
                      "LARGE_EMBEDDING_TESTS_DONE")
    print(f"REGRESSION_TESTS_DONE elapsed={elapsed:.3f}s",flush=True)
    elapsed,_ = stage("gap_aggregate_small.g",[],BASE/"output/aggregate_small.log",
                      "SMALL_AGGREGATION_DONE")
    print(f"SMALL_RESULTS_REAUDITED elapsed={elapsed:.3f}s",flush=True)

    prefix = args.resume_prefix
    if prefix:
        print("LARGE_RESUME_REQUESTED: the caller confirms the frozen input and "
              "algorithm are unchanged; saved negatives will not be recomputed.",
              flush=True)
    for layer,number in schedule[:prefix]:
        stem = BASE / f"output/large_targets/layer_{layer}_family_{number}"
        if not stem.with_suffix(".g").exists() or not stem.with_suffix(".log").exists():
            raise RuntimeError(f"Missing completed layer {layer}; refusing reuse.")
        text = stem.with_suffix(".log").read_text(encoding="utf-8",errors="replace")
        if ("LARGE_TARGET_DONE" not in text or "undecided=0" not in text
            or "coverage=complete" not in text or "Error," in text):
            raise RuntimeError(f"Invalid completion log for layer {layer}; refusing reuse.")
        records.append({"layer":layer,"family":number,"elapsed_seconds":None})
    stage("gap_restore_large_prefix.g",[prefix],BASE/"output/restore_large_prefix.log",
          "LARGE_PREFIX_RESTORED")
    print(f"LARGE_PREFIX_RESTORED layers={prefix}",flush=True)

    for layer,number in schedule[prefix:]:
        stem = BASE / f"output/large_targets/layer_{layer}_family_{number}"
        print(f"LARGE_TARGET_START layer={layer} family={number}",flush=True)
        wall_start = datetime.now().astimezone().isoformat()
        elapsed,text = stage("gap_run_large_target.g",[layer,number],stem.with_suffix(".log"),
                             "LARGE_TARGET_DONE")
        if "undecided=0" not in text or "coverage=complete" not in text:
            raise RuntimeError(f"Layer {layer} has no complete certificate.")
        records.append({"layer":layer,"family":number,"started_at":wall_start,
                        "elapsed_seconds":elapsed})
        marker = next(line for line in text.splitlines() if "LARGE_TARGET_DONE" in line)
        print(f"{marker} wall_seconds={elapsed:.3f}",flush=True)

    elapsed,text = stage("gap_finalize.g",[],BASE/"output/finalize.log",
                         "FOURFOLD_CROSS_DIMENSION_DONE")
    print(text.strip(),flush=True)
    final_audit_seconds = elapsed
    elapsed,text = stage("gap_coordinate_containment.g",[],
                         BASE/"output/coordinate_containment.log",
                         "FOURFOLD_COORDINATE_CONTAINMENT_COMPLETED")
    print(text.strip(),flush=True)
    elapsed,text = stage("gap_fourfold_maximal.g",[],
                         BASE/"output/fourfold_maximal_console.log",
                         "FOURFOLD_MAXIMAL_COMPLETED")
    print(text.strip(),flush=True)
    write_timing_report(records, final_audit_seconds, prefix)
    print(f"LARGE_RERUN_DONE elapsed={time.monotonic()-started:.3f}s",flush=True)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (RuntimeError,OSError,ValueError) as error:
        print(f"ABORT: {error}",file=sys.stderr,flush=True)
        raise SystemExit(1)
