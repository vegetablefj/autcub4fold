# Coordinate checks for Records 78 and 127

All checks passed with Windows GAP 4.15.1 on 2026-09-13. The checked display
snapshot is transcribed explicitly in `special_coordinate_audit.g`, including
its matrices and ordered monomials. No external historical TeX file is
required; this script does not parse arbitrary TeX or replace the complete
manuscript-extraction audit. It reads, but does not modify, the
[fixed computational catalogue](../gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g).

| Record | Linear ID | Projective ID | Invariant-space dimension | Centralizer dimension | Family dimension |
| --- | --- | --- | --- | --- | --- |
| 78 | `[24,10]` | `[8,3]` | 14 | 9 | 5 |
| 127 | `[24,9]` | `[8,2]` | 12 | 8 | 4 |

For each record, the scalar subgroup has order 3. The projective ID is
computed from the quotient by that subgroup, not inferred from the linear ID.
The displayed cubics are linearly independent and span the entire fixed
space computed by the shared exact cubic-invariant function. The family
dimension is the invariant-space dimension minus the centralizer dimension;
these are already known smooth families, not new smoothness tests.

## Record 78

Write `G^D = D^-1 G D` for matrix conjugation. The canonical group is
conjugated to the displayed group by
`D = diag(1,1,1,1,-3/4,1)`. This changes the canonical final block
`[[0,-3/4],[-4/3,0]]` into `[[0,1],[1,0]]`. The symplectic generators are
fixed pointwise. The fixed generic full group is also preserved and remains
literally contained in the displayed group.

The preceding TeX display with block `[[0,3/2],[2/3,0]]` is conjugated to the
same displayed group by `diag(1,1,1,1,3/2,1)`. Polynomial pullback is
`f(x) -> f(x*D^-1)`, with `x` a row vector. It takes the preceding basis
`P_1,...,P_12`, `P_13-(4/9)P_14`, `P_15-(4/9)P_16` to the new basis span
`P_1,...,P_12`, `P_13-P_14`, `P_15-P_16`. The canonical computed basis has
the same pullback span. These are exact coefficient-vector comparisons.

## Record 127

The new extra generator `diag(i,-1,1,1,1,-1)` is already literally the
canonical extra generator. The new selected indices
`{2,15,16,21,23,24,25,26,28,29,30,32}` give exactly its cubic fixed space.

The preceding choice `diag(1,1,-1,-i,1,-1)` gives the same family after
conjugation by the permutation matrix whose nonzero entries are
`(1,3)`, `(2,4)`, `(3,2)`, `(4,1)`, `(5,5)`, `(6,6)`. The script finds this
among the 24 permutations of the first four coordinates and verifies the
result on every group generator. It fixes the symplectic lift pointwise
and preserves the fixed generic full group. Pullback of the preceding
selected basis `{1,2,5,8,11,13,14,17,20,22,25,27}` gives exactly the new
selected basis span.

## Reproduction and output

From this folder, run
`python run_validation.py special_coordinate_audit.g` with the shared
launcher, adjusting its `--bash` and `--gap` arguments when needed. GAP is
started with `-r -q -b`; `-r` avoids loading a personal `gaprc`. The working
directory is the repository root.

`special_coordinate_audit.out` stores the GAP-readable record
`SpecialCoordinateAudit`, including the exact witness matrices and all
checks. The shared launcher records the transcript and execution metadata.
Any failed Boolean check raises an error; successful completion prints
`VALIDATION_COMPLETE`. No classification or saturation calculation is rerun.
