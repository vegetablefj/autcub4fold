# Coordinate verification procedure

All group and polynomial checks use exact rational or cyclotomic arithmetic
in GAP. Python only launches the saved GAP checks.

## Input and order

`gap_manuscript_input.g` retains the exact displayed matrices and cubic
exponent/coefficient records in numbered table order, from 1 to 156. This
saved input is checked against the catalogue and classification data; the
current checks do not require an external manuscript source file.

Permutation matrices have a 1 in row `i`, column `sigma(i)`. Cubics transform
by `F(x) -> F(x*A)` with `x` a row vector. Every strict lift contains the cubic
scalar, whether explicitly listed or already generated.

The metadata audit compares rank, symplectic order, generic/full index,
dimension, available projective IDs, liftability flags, and action-maximal
flags with the saved results. It does not recompute these properties.

## Display checks

For an explicit extension `H=<K,T>`, the driver checks that `T` normalizes the
finite symplectic lift `K` and that `T^n` belongs to `K`, with `n` the full
index. These conditions prove finiteness before matrix-group enumeration.
Literal equality and stored exact coordinate matrices precede any general
conjugacy search. Every accepted matrix is checked anew.

A displayed basis must be independent and span the entire cubic invariant
space. The family dimension is independently checked as the invariant-space
dimension minus the centralizer-algebra dimension. Component bases are
checked against the symplectic lift, not against a proper full-group subspace.

`gap_display_basis_audit.g` checks the current formula inputs and final
catalogues together. For all 156 fourfold and 40 threefold rows it computes
the full invariant space and centralizer algebra anew, tests invariance on
every generator, and verifies independence, completeness and dimensions.
It also checks the explicitly selected and component-only fourfold bases,
all printed extra matrices, and all threefold generating sets. This check
does not search for a new coordinate identification.

## Complete ordered catalogue

`gap_ordered_family_catalogue.g` writes `CubicFourfoldFamilyCatalogue` in
`gap_family_catalogue.g`. It follows the numbered table exactly. Explicit
displays use their printed coordinates. Generic-index-one component-only
rows use the corresponding generic full group. Citation-only rows retain
the explicit saved representative; they are not claimed to have been
reconstructed from the citation. Missing cubic bases are computed exactly.
Each record identifies whether its basis came from a display.

Every saturation survivor is recovered by a unique `sourceKey`. The set of
these keys must equal the saved 156 survivor keys. The designated matrices
from the completed coordinate-presentation calculation are checked again,
including the matches among families with the same group data. Their
pairwise comparisons are not repeated.
The fixed cross-dimensional input must agree literally with the computational
catalogue in both generators and metadata.
The computational catalogue is supplied in
[`fourfold_search_catalogue.g`](../gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g);
none of these drivers reads the result-presentation directory.

Write `H_computed`, `H_saved`, and `H_presentation` for the corresponding
strict matrix groups. The output records `S` and `Q` satisfying
`S^-1 H_computed S = H_saved` and
`Q^-1 H_saved Q = H_presentation`. The composite `S*Q` is also verified
directly. Equality is certified by conjugating the generators in both
directions. Symplectic and generic full groups are checked separately.
Group IDs and dimensions alone never certify a match.

The component generic index comes from the standard generic full group and
the numbered table, with their order ratio checked. It is not copied from
the local candidate `genericIndex` field. Both values are recorded in the correspondence
output without changing the saved candidate data.

The final basis is checked against a newly computed invariant space for
every row, including completed references. An unavailable SmallGroups ID
is not fabricated: `[order,0]` retains the independently verified order.

## Existing certificates

Self-conjugacy certificates refer to the computed survivors. Fourfold
containment and threefold-extraction certificates refer to the fixed
computational catalogue. Coordinate equivalence transfers their mathematical
conclusions, but their numerical matrices must be transported before reuse
in the presentation coordinates.

If `Q_i^-1 H_i Q_i = H'_i` and an old embedding certificate satisfies
`P_ij^-1 H_i P_ij <= H_j`, its new matrix is
`Q_i^-1 P_ij Q_j`. Directly conjugating every source generator into the new
target verifies it. Negative decisions are invariant under coordinate
conjugacy and require no new search. This module supplies the coordinate
matrices; it does not rewrite the existing downstream certificates.

## Running

From the repository root, run the saved checks:

```text
python gap_classification/gap_manuscript_validation/run_validation.py gap_manuscript_metadata_audit.g
python gap_classification/gap_manuscript_validation/run_validation.py gap_fourfold_manuscript_audit.g
python gap_classification/gap_manuscript_validation/run_validation.py gap_ordered_family_catalogue.g
```

With the saved fourfold and threefold formula inputs, run the joint basis
and dimension check in GAP from the repository root:

```gap
Read("gap_classification/gap_manuscript_validation/gap_display_basis_audit.g");
```

It replaces only `gap_display_basis_audit.out` and `.log`. Successful
completion prints `DISPLAY_BASIS_AUDIT_SUCCESS` and exits GAP.

GAP 4.15.1 is launched in the Windows bundled login-shell environment using
`-r -q -b`. Saved mathematical inputs use relative repository paths.
Runtime records retain actual commands and elapsed times, not portability
requirements. A deliberate run replaces only the reports produced by that
driver. Threefold coordinate and extraction checks are described separately in
[the threefold script explanation](../gap_threefold/gap_threefold_script.md).
