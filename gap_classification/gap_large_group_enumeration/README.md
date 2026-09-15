# Large-group equation candidates

This module records the representation calculations for selected cubic
fourfold families with symplectic rank at least 15. The connected symplectic
models come from Koike and its corrigendum. The saved computation treats 29
proper rows of the large-family catalogue; the remaining seven proper rows
have separate rank-19, additive, or order-7 descriptions.

The calculation starts from 28 projective-group tasks over 18 fixed
symplectic actions. The liftable and nonliftable engines produce exact
degree-six linear actions and invariant cubic spaces, and test their
smoothness. The recorded run has 747 raw images and 42 smooth candidates.
The subsequent equal-dimensional comparison removes 13 candidates. Its 29
retained families agree with the numbered fourfold catalogue.

## Files

- `input/gap_large_tasks.g`, `gap_large_routing.g`, and
  `gap_large_kplus_inputs.g` give the task list, branch choices, and fixed
  symplectic matrix groups.
- `source/gap_large_liftable_engine.g` and
  `source/gap_large_nonliftable_engine.g` are the original GAP calculation
  cores, copied without changing their computational logic.
- `gap_large_group_case.g` is a small one-case entry point. Each branch
  should be run in a fresh GAP session.
- `result/gap_large_candidates_result.md` records the candidate-stage
  counts and explicit families.
- `result/gap_large_smooth_candidates.g` is the GAP-readable list of 42
  smooth candidates.
- `result/gap_large_saturation_result.md` records the equal-dimensional
  comparison and the correspondence with the numbered catalogue.
- `result/gap_large_saturation_conjugacy.md` displays its exact coordinate
  matrices. The accompanying `.g` files contain the recorded checks,
  additive-block certificates, catalogue matches, and survivor keys.

The final large-family input is
[`gap_large_koike_families.g`](../gap_saturation/gap_large_koike_families.g),
and the ordered fourfold result is in
[`gap_result/fourfold_result.md`](../../gap_result/fourfold_result.md).
This module preserves the source keys used during enumeration; catalogue
numbers are supplied by the recorded correspondence.

## Running one task

Start GAP in this directory, then run, for example:

```gap
Read("gap_large_group_case.g");
RunLargeGroupCase(1, "nonliftable");;
CF_LAST_S_RESULT;
```

The permitted branch for each task is listed in
`input/gap_large_routing.g`. The engines were used with GAP 4.16.0,
`cohomolo` (and `repsn` for nonliftable branches), Singular, and GNU
`timeout`. Their smoothness tests create temporary Singular input internally.
For demanding liftable tasks the engine also supplies
`CF_RunMemorySafe` and resource profiles. The saved results can be inspected
without running a task again by reading the `.g` files in `result/`.
