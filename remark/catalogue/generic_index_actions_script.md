# Generic full-group actions on the abstract period lattice

The independently verified catalogue
`lattice_156_with_generic_actions_v3_20261004.mrdi` extends
`lattice_156_with_no60_representatives_v2_20261004.mrdi` without changing it.
All 156 numbered rows now have an abstract `T_input` and a
`T_extra_action`; this statement concerns the action on `T`, **not** a
chosen extension to the cubic-fourfold primitive lattice or a primitive
embedding for every row.

The new entries are Nos. 9, 11, 16, 19, 20, 21, 27, 31, 34, 35, 37,
47, 55, 63, and 68. The full-period scalar-action criterion implies that
every generic-index-two
positive-dimensional family has extra action `-Id` on its whole `T`:
the family dimension is `rank(T)-2`, so a proper eigenspace cannot contain
its full-dimensional period locus. Fourteen of the new rows are of this
type. No. 20 has index one and hence identity action on `T`.

Nos. 11 and 20 were omitted from the 29 search inputs because their generic
indices already met their bounds. Their abstract `S` inputs use entries
`#8` and `#13` of `../../oscar/list_S.txt`. Their `T` Gram matrices are the
separately supplied inputs, checked against their classified finite
quadratic forms:

| Row | `T` Gram matrix | `|det T|` | Action |
| ---: | --- | ---: | --- |
| 11 | `diag(20, [[-2,-1],[-1,-2]])` | 60 | `-Id` |
| 20 | `diag([[-16,-8],[-8,-16]], 6)` | 1152 | `Id` |

The rank-19 check verifies signatures, determinants, Smith invariants,
selected finite-form generator norms, and necessary gluing indices. It does
not independently construct or classify the primitive embeddings.
The other thirteen rows keep their original `S_input` and `T_input` exactly.
Nos. 35 and 37 retain one common abstract `T` input and two unassigned
component embeddings. For Nos. 55, 63, and 68, the `-Id` answer also agrees
with the cube of the saved order-six action in same-symplectic-part parents.

The three read-only checks in this earlier stage were
`verify_rank19_easy_sources.jl`,
`check_rank18_generic_index2_inputs.jl`, and
`audit_generic_index2_full_period_47_55_63_68.jl`. All three passed under
the local WSL OSCAR environment on 4 October 2026. The side-by-side builder
and independent field-level verifier are
`build_lattice_156_generic_actions.jl` and
`verify_lattice_156_generic_actions.jl`. Only the first check is retained
as source here; the other stage scripts are not part of this repository.
The latter passed: only the 15
intended rows changed, all 156 `T` actions reloaded correctly, and no
`T_in_ambient`, `saved_result`, or primitive embedding was inferred.
The source catalogue was unchanged.

The earlier files without `_v3_` predate corrections to the independent
verifier and the default output path.
Use only the `_v3_` file above. The separate
No. 102 cross-parent comparison, the strict class-label assignments for
Nos. 84/85/107, and missing ambient actions/embeddings are not resolved by
this abstract-`T` step.
