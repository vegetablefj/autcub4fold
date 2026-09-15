# Family coordinate verification results

The numbered family table, fixed computational catalogue, and final
coordinate presentations agree one to one. Verification uses Windows GAP
4.15.1 with exact rational/cyclotomic arithmetic.

## Complete fourfold catalogue

[`gap_family_catalogue.g`](gap_family_catalogue.g) contains
`CubicFourfoldFamilyCatalogue`, with exactly 156 records numbered 1–156 in
the table order. Every record contains its full strict matrix group,
symplectic and generic full groups, group identifiers, indices, family
dimension, and a complete cubic invariant basis.

All 156 representatives are linearly equivalent to the computed survivors,
in the same numbered table order. Conjugating matrices are verified by
generator containment in both directions; the symplectic and generic full
groups are checked separately. The exact matrices and the correspondence
with the original survivor numbering are stored in
`gap_family_correspondence.out`.

There are 112 literally equal full groups and 44 conjugate matrix
presentations. Complete bases and family dimensions pass for every row.
The catalogue retains 126 displayed bases, including the 15
generic-index-one component bases; the other 30 bases are computed exactly
in their recorded coordinates. Citation-only presentations keep the
explicit saved representative, rather than claiming reconstruction from
the cited text.

Generic indices agree with the numbered table and with the orders of the
standard symplectic and generic full groups.

See [the ordered report](gap_family_correspondence.md),
[the exact matrices and row checks](gap_family_correspondence.out), and
[the progress transcript](gap_family_correspondence.log).

## Table and explicit displays

All 156 table rows agree with the saved rank, group orders and available
IDs, generic/full index, dimension, liftability, and action-maximal data.
The totals remain 134 liftable, 131 F-liftable, and 21 action-maximal.
[The metadata audit](gap_manuscript_metadata_audit.out) is a comparison
with saved results, not a new liftability or containment calculation.

The [display audit](gap_fourfold_manuscript_audit.md) verifies 117 full
groups, 111 complete family bases, and 15 component-only rows, with no
failures. Twenty-four rows only give citations; their complete matrix
and basis data are supplied by the ordered catalogue construction.

The separate [joint basis check](gap_display_basis_audit.md) passes for all
156 fourfold and 40 threefold rows in the current formula inputs and final
catalogues. Every stored basis is independent, strictly invariant and
complete; all invariant-space, centralizer and family dimensions agree.
The printed fourfold extra matrices and all threefold generating sets also
agree with the final catalogues. These are fresh exact polynomial and
linear-algebra checks, not repeated representation or embedding searches.

## Existing downstream results

The saved self-conjugacy tests use the computed survivor coordinates.
The fourfold containment and threefold-extraction computations use the
fixed computational catalogue. The verified coordinate identifications
transfer their mathematical conclusions to the final presentations.
Numerical witness matrices retain their original coordinates and must be
transported before direct application to the final matrices.

The two forty-record threefold lists and their coordinate and containment
checks are retained in [the threefold module](../gap_threefold/README.md).
Its coordinate matrices identify the extracted and final presentations;
its containment matrices are verified in the final five-dimensional
coordinates.

Coordinate and cubic-space verification does not repeat representation
enumeration, saturation, smoothness, self-conjugacy, or cross-dimensional
embedding searches. The classification results and numbered family loci
are unchanged by the choices of coordinates and bases.
