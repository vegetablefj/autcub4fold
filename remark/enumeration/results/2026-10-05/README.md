# Brown rerun, 2026-10-05

This directory preserves the output of fourteen selected OSCAR 1.8.2 runs
with Julia 1.12.4. `results/` retains the original job-specific output
tree; `slurm/` contains each job's console output and error stream. The
scripts that produced them are described in the [rerun guide](../../README.md).

| Cases | Job IDs | Saved outcome |
| --- | --- | --- |
| High rank 1, 3, 4, 7, 8 | 7017745, 7017746, 7017825, 7017833, 7017916 | One compatible ambient witness per case. |
| High rank 9, 11, 16, 19, 34 | 7017668, 7017919, 7017964, 7017970, 7018083 | One compatible ambient witness per case. |
| Cyclic 152, 154 | 7018088, 7018186 | Four retained generator-action classes per case. |
| Cyclic 155, 156 | 7017669, 7017743 | Eight retained generator-action classes per case. |

Each of the fourteen output directories contains a nonempty MRDI file, a
run log, a Julia status of `COMPLETED`, and `postcheck.status.txt` containing
`PASSED`. The postchecks reload the saved data and apply the case-specific
checks; the console records also identify the corresponding job and saved
file. The error streams contain only the Julia environment initialization
notice. The downloaded bundle did not include a `sacct` export, so the
Slurm scheduler's final state is not independently recorded here.
The read-only [file-integrity check](../../verify_imported_rerun.py) can be
run with Python from any working directory.

These are independent reruns. Earlier MRDI files in
[`low_rank/`](../../../low_rank/README.md) and
[`catalogue/`](../../../catalogue/README.md) were not overwritten or identified by bytewise
equality. The 156-row standard ambient catalogue continues to name its
selected sources. The cyclic counts above are counts of labelled generator
actions, not distinct cyclic-group actions or geometric families.
