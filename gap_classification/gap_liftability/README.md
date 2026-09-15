# Liftability

This directory determines ordinary liftability and F-liftability of the
156 cubic-fourfold projective actions in their final coordinates.

| File | Purpose |
|---|---|
| [gap_liftability.g](gap_liftability.g) | Strict-extension and small-subgroup functions. |
| [gap_liftability_all.g](gap_liftability_all.g) | Complete 156-family audit. |
| [gap_liftability_test.g](gap_liftability_test.g) | Six independent small-extension tests, without catalogue input. |
| [gap_liftability_script.md](gap_liftability_script.md) | Definitions, hypotheses, and algorithms. |
| [gap_liftability_result.md](gap_liftability_result.md) | Complete table and obstruction summary. |
| [gap_liftability.out](gap_liftability.out) | GAP-readable decisions, local extension types, and exact matrix bindings. |
| [gap_liftability.log](gap_liftability.log) | Incremental batch log; completion marker `LIFTABILITY_COMPLETED`. |
| [gap_liftability_test.log](gap_liftability_test.log) | Independent test log. |

The input is the [complete family catalogue](../gap_manuscript_validation/gap_family_catalogue.g),
with its [saved coordinate correspondence](../gap_manuscript_validation/gap_family_correspondence.out).
The audit reads the actual final `matrixGenerators`, not an earlier
presentation reconstructed from extra generators. It does not repeat
representation enumeration, smoothness, or saturation.

From the repository root, `gap_classification`, or this directory, run
the corresponding relative path to `gap_liftability_all.g`. For example,
from the repository root with GAP 4.15.1:

```gap
Read("gap_classification/gap_liftability/gap_liftability_test.g");
Read("gap_classification/gap_liftability/gap_liftability_all.g");
```

A deliberate rerun replaces the result and log files. The saved result has
134 liftable and 131 F-liftable families; Nos. 105, 140, and 143 are liftable
but not F-liftable. Every decision is checked independently using the
distinguished scalar kernel. See [the result](gap_liftability_result.md).
