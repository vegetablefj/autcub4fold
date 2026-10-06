# Selected OSCAR reruns

This directory contains two uniform rerun paths for integral lattice actions:

| Path | Cases | Calculation |
| --- | --- | --- |
| [`highrank/`](highrank/specs.jl) | 1, 3, 4, 7, 8, 9, 11, 16, 19, 34 | Prescribed-action ambient extensions and full-group checks. |
| [`maximal/`](maximal/cyclic_s0_specs.jl) | 152, 154, 155, 156 | Exact-character searches on the rank-22 primitive lattice, followed by geometric lattice filters. |

The Brown submission instructions are in [`BROWN_RUN.txt`](BROWN_RUN.txt).
`remaining_brown_array.sbatch` runs the twelve cases other than the separately
submitted Nos. 9 and 155. The scripts use repository-relative shared inputs
in [`oscar/`](../../oscar/README.md) and [`input/`](../input/family_numbering.md);
a fresh run writes to `results/` under its
submission directory and refuses to overwrite an existing job result.

The high-rank reruns use a helper from the original `oscar/` search. That
helper was tested here with OSCAR 1.8.2 for these specified cases; the
original search remains a separate OSCAR 1.7.3 run.

The completed 2026-10-05 batch is preserved separately in
[`results/2026-10-05/`](results/2026-10-05/README.md). Its output files remain
separate from the earlier records. The four cyclic
cases retain 4, 4, 8, and 8 **generator-action classes**, respectively;
these numbers are not counts of geometric families. The coprime-power
comparison is recorded with the earlier [low-rank results](../low_rank/README.md).
[`verify_imported_rerun.py`](verify_imported_rerun.py) checks the expected
saved files and statuses without loading OSCAR.
