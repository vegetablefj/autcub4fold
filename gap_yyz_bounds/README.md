# YYZ group-theoretic bounds

This module compares the 34 symplectic groups with the 15 maximal fourfold
groups of Yang–Yu–Zhu. A retained abstract full group has the prescribed
normal symplectic subgroup and cyclic quotient of an admissible order.
This is a necessary group-theoretic bound, not a list of realized matrix
actions or saturated geometric families. Mathematical sources are listed in
the [references](../REFERENCES.md).

## Files

- [`gap_yyz_bounds.g`](gap_yyz_bounds.g): executable calculation.
- [`gap_yyz_bounds.md`](gap_yyz_bounds.md): the unchanged readable result.
- [`gap_yyz_bounds_output.txt`](gap_yyz_bounds_output.txt): detailed audit output.
- [`gap_yyz_bounds_log.txt`](gap_yyz_bounds_log.txt): progress and recorded environment.

The saved GAP 4.15.1 run has 2,649 successful subgroup occurrences and 218
deduplicated abstract records. The distinction between occurrences and
records is essential; neither count is the final number of cubic families.
The `H_i` notation in the readable report labels the abstract YYZ source
groups and should not be confused with a strict linear group in later modules.

## Running

Use a fresh GAP session with this directory as the current directory:

```gap
Read("gap_yyz_bounds.g");
```

This repeats the calculation and replaces its runtime outputs. Reading the
saved reports is sufficient for inspecting the existing result.
