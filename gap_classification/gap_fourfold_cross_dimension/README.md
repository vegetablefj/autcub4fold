# Containment of cubic-fourfold families

This folder determines containment between the 156 saturated cubic-fourfold
families of different dimensions. Family numbers follow the stored catalogue,
in the order 1–156.

The final relation uses the groups in
[the family catalogue](../gap_manuscript_validation/gap_family_catalogue.g).
For a positive record, `P^-1 * H_source * P <= H_target`.
Thus `i -> j` means geometrically that family `j` is contained in family
`i`. The saved decisions give 1793 positive relations, 4775 negative
decisions, 433 covers, and 21 action-maximal families.

See the [result tables](result/gap_fourfold_cross_dimension_result.md) and
[script explanation](gap_fourfold_cross_dimension_script.md).

## Folder structure

| File or folder | Purpose |
| --- | --- |
| `input/` | Fixed search representatives, the small/large schedule, and complete saved pair decisions before changing coordinates |
| `audit/` | Intermediate coverage, positive-witness and transitivity checks |
| `output/` | Per-row and per-target GAP outputs and logs |
| `result/` | Final relation in displayed coordinates, covers, maximal-action data and readable tables |
| `gap_prepare_input.g` | Validate the fixed search catalogue and prepare 142 small rows and 14 large targets |
| `gap_run_small_row.g` | Compare one small source with eligible small targets |
| `gap_aggregate_small.g` | Check and combine the small-row decisions |
| `gap_large_embedding.g` | Exact subgroup-and-character search for a large target |
| `gap_run_large_target.g` | Treat one large target, including verified propagation of positive relations |
| `gap_restore_large_prefix.g` | Restore a completed initial segment for an explicitly requested recovery |
| `gap_cross_dimension_common.g` | Common input, serialization and explicit-witness checks |
| `gap_test_large_embedding.g` | Small independent tests of the large-target functions |
| `gap_finalize.g` | Audit all search decisions and save `input/fourfold_computed_pairs.g` |
| `gap_coordinate_containment.g` | Convert and check every positive matrix in the displayed coordinates, without searching for embeddings |
| `gap_family_poset_functions.g` | Validate saved pairs, compute covers, and find all reachable action-maximal rows |
| `gap_fourfold_maximal.g` | Generate the fourfold result tables and maximal-action data |
| `run_cross_dimension.py` | Schedule a complete Windows GAP run |
| `run_large_targets.py` | Reaudit the saved small rows and run the large targets serially |

The 40 extracted threefold families are treated by an independent direct
five-dimensional calculation in [the threefold module](../gap_threefold/README.md).
Its complete relation is also compared pair by pair with the restriction of
the fourfold relation, and its covers are recomputed in the threefold order.
The [threefold result tables](../gap_threefold/result/gap_threefold_result.md)
use increasing fourfold-source order.

## Reading or checking the saved result

Run GAP from this folder. To recheck the explicit matrices and regenerate
the fourfold tables without repeating any embedding search, read these
files in separate GAP sessions:

```gap
Read("gap_coordinate_containment.g");
Read("gap_fourfold_maximal.g");
```

These entry points replace their own outputs. Their completion markers are
`FOURFOLD_COORDINATE_CONTAINMENT_COMPLETED` and
`FOURFOLD_MAXIMAL_COMPLETED`. The coordinate log reports progress through
156 group identifications and 1793 containment matrices.

Final matrices, not the intermediate search-coordinate matrices, should be
used with the displayed catalogue. Negative decisions are unchanged under
conjugacy of both groups.

## Recomputing the searches

The supplied Windows launchers use GAP 4.15.1 under `D:\GAP` by default,
with its bundled Bash runtime and GAP's `-r` option. Another installation
can be selected with `--bash` and `--gap`.

```text
python run_cross_dimension.py --workers 6
python run_large_targets.py
```

The first command recomputes all small rows and then the large targets.
The second reuses and reaudits the supplied small rows, but recomputes all
14 large targets. Both finish with the coordinate and maximality checks.
No saturation computation is repeated.

For recovery only, `--resume-small` on the first launcher or
`--resume-prefix N` on the second requests reuse of completed work.
Use these options only after confirming that the frozen input and
mathematical algorithms have not changed. Positive witnesses and coverage
are rechecked; recovery does not reprove old negative decisions.
