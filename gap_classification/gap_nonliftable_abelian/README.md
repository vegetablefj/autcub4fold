# Non-liftable abelian candidates

This directory supplies the two non-liftable abelian projective actions
`C3 x C3` and `C6 x C3` as exact candidate data. It is a data module,
not an enumeration driver: loading it performs no search or geometric test.

## Files

| File | Purpose |
|---|---|
| [gap_nonliftable_abelian_data.g](gap_nonliftable_abelian_data.g) | Exact generators, invariant cubic bases, group metadata, and dimensions. |
| [gap_nonliftable_abelian_script.md](gap_nonliftable_abelian_script.md) | Action conventions, data fields, and theoretical scope. |
| [gap_nonliftable_abelian_results.md](gap_nonliftable_abelian_results.md) | The two candidate records and their saved smoothness witnesses. |

## Loading

Start GAP in this directory and read:

```gap
Read("gap_nonliftable_abelian_data.g");
Length(FinalNonliftableAbelianCandidates);
```

The two globals `NonliftableAbelianCandidates` and
`FinalNonliftableAbelianCandidates` refer to the same two-record list.
To construct one of its linear groups:

```gap
H := Group(FinalNonliftableAbelianCandidates[1].matrixGenerators);
```

There is no separate `.log` or `.out` here, since loading the data file
does not run a computation.
The exact smooth-member tests and dimension checks are saved in
[`gap_smoothness`](../gap_smoothness/README.md). No input is read from a
result-display directory.
