# Cubic bases and family dimensions

The exact check in [gap_display_basis_audit.g](gap_display_basis_audit.g)
passes for all 156 fourfold and 40 threefold rows, in their final order.
The machine-readable checks are in
[gap_display_basis_audit.out](gap_display_basis_audit.out), with progress in
[gap_display_basis_audit.log](gap_display_basis_audit.log).

For every row, the recorded coefficient vectors are linearly independent,
fixed by every matrix generator, and span a freshly computed full cubic
invariant space. The centralizer algebra is also computed anew. Its
dimension and the invariant-space dimension agree with the catalogue, as
does their difference, the family dimension.

The fourfold check additionally verifies all 111 explicitly selected bases
and 15 component-only bases. Component bases are checked against their
symplectic lift; 27 distinct component checks suffice for the 126 usages.
Every explicit extra matrix agrees with the final catalogue. All 40
threefold generating sets agree with their final catalogue and explicitly
include `E(3)*IdentityMat(5)`.

The run uses Windows GAP 4.15.1 and exact rational/cyclotomic arithmetic.
There are no failed rows. It does not enumerate group representations,
search for embeddings, or repeat saturation or smoothness tests.

From the repository root, run in GAP:

```gap
Read("gap_classification/gap_manuscript_validation/gap_display_basis_audit.g");
```

Alternatively, from this module directory, read
`gap_display_basis_audit.g`. The supplied formula inputs must first be
regenerated with the documented extractors if the displayed expressions
change. A deliberate run replaces this check's `.out` and `.log` files and
exits GAP after printing `DISPLAY_BASIS_AUDIT_SUCCESS` when all rows pass.
