# Liftable abelian candidates

This directory enumerates diagonal candidates for liftable abelian full
projective automorphism groups of smooth cubic fourfolds. The saved calculation
contains 51 ordinary candidates and the two special cyclic actions `C48` and
`C32`. These are candidates for the subsequent saturation calculation, not
53 certified saturated families.

## Files

| File | Purpose |
|---|---|
| [gap_liftable_abelian.g](gap_liftable_abelian.g) | Entry point; runs the diagonal core, adds the two cyclic actions, and exports metadata. |
| [gap_liftable_abelian_original.g](gap_liftable_abelian_original.g) | Preserved computational core, including the maximal sources and specialized diagonal routines. |
| [gap_liftable_abelian_data.g](gap_liftable_abelian_data.g) | Saved candidate records for further GAP computations. |
| [gap_liftable_abelian.out](gap_liftable_abelian.out) | Saved groups, invariant bases, dimensions, and source counts. |
| [gap_liftable_abelian.log](gap_liftable_abelian.log) | Original stage counts, runtime, and completion summary. |
| [gap_liftable_abelian_script.md](gap_liftable_abelian_script.md) | Mathematical scope, computation order, functions, and output fields. |
| [gap_liftable_abelian_results.md](gap_liftable_abelian_results.md) | Summary tables and all 53 candidate records, in saved output order. |

The entry point uses the core's diagonal equivalence and containment routines;
it does not require `../gap_functions.g`, Singular, or cohomolo. The saved run
used GAP `4.15.1` with `smallgrp`.

## Loading the saved results

Start GAP in this directory and read:

```gap
Read("gap_liftable_abelian_data.g");
Length(FinalLiftableAbelianCandidates);
```

This loads the 53 saved records without repeating the enumeration.
`LiftableAbelianCandidates` and `FinalLiftableAbelianCandidates` refer to the
same list.

## Repeating the calculation

Only when a new run is intended:

```gap
Read("gap_liftable_abelian.g");
```

The entry point runs automatically and replaces the `.out`, `.log`, and
`_data.g` files. It does not regenerate the Markdown reports. Completion is
indicated by `FINAL SUMMARY` in the log, the two final file-written messages,
and the return of the GAP prompt.

The original core is retained byte-for-byte for reproducibility. Its older
comments and standalone examples are historical; the commands above are the
current entry points. See the script description for the scope of the
abelian-full-group spectral exclusions.
