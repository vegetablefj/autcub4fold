# Cubic-threefold extraction and verification

## Mathematical reduction

Let `Fhat` define a smooth cubic fourfold and let `Hhat = Aut(Fhat)` be
its full strict linear stabilizer. Write `omega = E(3)`. An element `delta`
of order three with trace `5 + omega` has eigenvalues `(1,1,1,1,1,omega)`.
In an adapted basis, invariance under `delta` forces
`Fhat = F(x1,...,x5) + c*x6^3`. Smoothness implies `c <> 0` and that `F`
is smooth. Thus `delta` singles out a one-dimensional Fermat summand.

The centralizer `C_Hhat(delta)` preserves the five-dimensional fixed space
`V = Ker(delta-I)` and the removed line. Restriction to `V` has image
`H = Aut(F)` and kernel `<delta>`, of order three. Indeed, a centralizing
automorphism acts block diagonally and preserves the two summands separately.
Conversely, every strict automorphism of `F` extends by the identity on the
removed line, belongs to the full group `Hhat`, and centralizes `delta`.
This proves that the extracted group is the full stabilizer, not a candidate
subgroup. Fullness of `Hhat` is essential to this argument.

Uniqueness of the maximal additive splitting, including its variable
subspaces, is supplied by Harrison's decomposition theorem or
Huang–Lu–Ye–Zhang, Proposition 2.1(1)–(3); see the
[reference guide](../../REFERENCES.md#additive-splittings). Smooth cubics
use all their variables essentially, so the nondegeneracy hypothesis holds.
Adjoining a cube is injective on linear-equivalence classes: an equivalence
between `F + x6^3` and `F' + x6^3` identifies their one-dimensional
summands, and deleting any one of these summands gives equivalent
five-variable cubics. The full group permutes equal Fermat summands
transitively. Consequently, all Fermat elements of one source belong to
one conjugacy class, and distinct saturated fourfold source families give
distinct saturated threefold families. No further deduplication,
smoothness search, or threefold saturation calculation is required.

## Extraction algorithm

The catalogue wrappers in [gap_threefold_functions.g](gap_threefold_functions.g)
accept the fixed fourfold search records, which contain `standardPosition`
and `extraGenerator`. They do not accept final five-dimensional catalogue
rows. The input is
[fourfold_search_catalogue.g](../gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g),
with variable `CanonicalFamilyMatrixGroups`.

The batch [gap_threefold_index_three.g](gap_threefold_index_three.g) performs
the following operations, using exact cyclotomic arithmetic:

```text
For each selected fourfold source Hhat with 3 dividing its index:
    Find the order-three elements of trace 5 + omega, up to conjugacy.
    If none exist, retain the source with status no_Fermat_summand.
    Otherwise choose a representative delta and compute C_Hhat(delta).
    Choose bases of Ker(delta-I) and Ker(delta-omega*I).
    Restrict the centralizer generators to the first five coordinates.
    Check that the image has order |C_Hhat(delta)|/3 and contains omega*I5.
    Form the projective quotient by <omega*I5>.
    Compute the complete invariant cubic space and centralizer algebra.
    Check the inherited family dimension and retain the exact result.
```

A certified full source with a central Fermat generator is restricted
directly. For groups of order at most 400, the functions enumerate all
matrices by breadth-first search and determine the centralizer exactly.
Otherwise, they use a faithful permutation model and its conjugacy classes.
The direct enumeration also checks that the number of Fermat elements
equals the selected conjugacy-class size. Each successful route verifies
the eigenspace dimensions, block decomposition, centralizer order,
restriction kernel, and cubic scalar subgroup.

The main functions are:

| Function | Purpose |
| --- | --- |
| `CF_TF_StrictGroupFromCatalogueEntry` | Rebuild a strict fourfold source group. |
| `CF_TF_FermatClassData` | Find and count Fermat conjugacy classes in a prepared permutation model. |
| `CF_TF_RestrictCentralizer` | Restrict a centralizer to its fixed five-space and verify the kernel. |
| `CF_TF_ExtractCatalogueFamily` | Extract one source, optionally including its complete invariant basis. |
| `CF_TF_ExtractCatalogue` | Apply the extraction to a list, retaining negative decisions when requested. |

Use `rec(computeInvariantBasis := true)` for the complete cubic basis and
dimension calculation. The batch saves
[gap_threefold_extraction.g](input/gap_threefold_extraction.g), with variable
`CubicThreefoldIndexThreeAudit`: 63 selected sources, 40 extractions, and
23 sources without a Fermat summand. All 40 dimensions agree with the
independent five-variable computation. The source Fermat rank `r` is the
conjugacy-class size, and the extracted rank is `r-1`.

## Exact verification in the final coordinates

[gap_threefold_display_input.g](input/gap_threefold_display_input.g) retains
the exact five-variable matrices and cubic bases for all 40 numbered rows,
including roots of unity and orbit coefficients. It is saved formula input,
not an independent classification calculation.

[gap_threefold_verify_coordinates.g](gap_threefold_verify_coordinates.g)
uses the saved extraction and exact coordinate matrices to check each
source in the final coordinates. It verifies the source identity, orders,
IDs, index, Fermat rank, and family dimension. The 23 negative Fermat
decisions are preserved under the verified fourfold conjugations. No new
Fermat-class search is performed.

For every positive row, the verifier checks the following:

- The five-dimensional displayed generators themselves generate exactly
  the conjugated saved group: all generators belong to it, and their
  subgroup has the full saved order. A redundant explicit `omega*I5` is
  added to the catalogue only after this check.
- The displayed cubic basis is independent, fixed by every generator,
  and spans the complete invariant cubic space computed in dimension five.
  The centralizer algebra is computed independently, and the family
  dimension equals `dim W_H - dim C_GL(5)(H)`.
- The strict group and its quotient by `<omega*I5>` have the stated orders
  and GAP IDs wherever the installed SmallGroups library provides them.
  An ID `[order,0]` denotes an unavailable library ID, not a distinct group.
- The transported `delta` lies in the final fourfold group and has the
  required eigenspace decomposition. Each five-dimensional generator
  extends into this source group and centralizes `delta`. These extensions
  together with `delta` give the full centralizer: their restriction is the
  full verified five-dimensional group, the kernel has order three, and
  their order is `3*|H| = |Hhat|/r`, as required by the saved class size.
- The complete final six-variable invariant basis is taken to the adapted
  coordinates. Its completeness comes from the completed fourfold
  `FamilyCoordinateAudit`; independence and invariance are checked again.
  Every mixed term involving `x6` to degree one or two vanishes, some cubic
  has nonzero `x6^3` coefficient, and projection onto the first five
  variables spans exactly the verified five-variable invariant space.

The last projection has a one-dimensional kernel when the source has
exactly one Fermat summand. When it has several, the full group permutes
them and ties the removed cube coefficient to the others; the projection
is then injective. The verifier checks both cases. Thus the coefficient
space and family dimension are not confused with one another.

Two lists are saved, both numbered by increasing source fourfold number:

- [gap_threefold_extracted_families.g](result/gap_threefold_extracted_families.g),
  with variable `CubicThreefoldExtractedCatalogue`, retains the original
  extracted five-dimensional matrix groups and complete cubic bases.
- [gap_threefold_families.g](result/gap_threefold_families.g), with variable
  `CubicThreefoldFamilyCatalogue`, gives their final coordinate presentations.

The verifier binds both lists' exact generators and cubic bases to
[gap_threefold_coordinate_audit.out](result/gap_threefold_coordinate_audit.out),
with variable `CubicThreefoldCoordinateAudit`. Each row records the exact
five-dimensional coordinate comparison and both adapted six-dimensional
bases. All non-coordinate metadata, complete polynomial spaces, and family
dimensions are checked. The raw five-variable groups are unchanged by
transporting their adapted six-dimensional bases to the final fourfold
coordinates. The saved formula input is not a third independently maintained
catalogue.

## Direct containment and action-maximal families

For saturated families, inclusion of unmarked family loci is equivalent
to containment of their full strict groups up to linear conjugacy.
Inclusion applied to a generic member gives group containment; conversely,
a fixed group embedding gives inclusion of the invariant cubic spaces.
This generic-stabilizer argument applies in five variables as well as six.
[gap_threefold_cross_dimension.g](gap_threefold_cross_dimension.g) computes
the relation directly on the final five-dimensional groups. It uses
`PreprocessMatrixGroupStrict` and `SearchEmbeddingStrict` from
[gap_functions.g](../gap_functions.g). Every eligible pair is tested
independently, without fourfold decisions, transitive shortcuts, or
dynamic deletion:

```text
For every ordered pair i != j:
    If dim Z_i <= dim Z_j, record not_compared (dimension orientation).
    Otherwise, if |H_i| does not divide |H_j|, record no_embedding (order).
    Otherwise run the exhaustive strict linear-embedding test in dimension 5.
    If an embedding is proved, construct an invertible 5 x 5 matrix P
        and verify P^-1 * g * P belongs to H_j for every generator g of H_i.
    Record embedded only after this matrix verification succeeds.
    Record no_embedding only after an exhaustive negative result.
    Retain computation or witness-construction failures as undecided.
```

The dimension orientation follows from saturation: group containment gives
family inclusion, and distinct saturated actions cannot have a proper
same-dimensional inclusion. A dimension exclusion is therefore recorded
as a comparison not made, not as an arbitrary abstract nonembedding claim.
The 40 rows give 1,560 ordered distinct pairs, of which 493 pass both
dimension and order tests.

The underlying strict search considers subgroup images up to target
conjugacy and source outer-automorphism twists. It compares the exact
characters on conjugacy-class representatives; equality is the criterion
for equivalence of finite-dimensional complex representations. Inner
automorphism twists need not be enumerated separately, since group
matrices already realize them by linear conjugation. Literal inclusion
and the common certified fast paths may give an earlier positive result;
only an exhaustive search gives a negative one. There are no search caps,
and the optional characteristic-polynomial fingerprint filter is disabled.
Equality of characters proves that an invertible intertwiner exists,
but failure of the finite matrix-construction search is still retained as
`undecided`, never as `no_embedding`.

The direct batch binds all 40 exact generator lists and source metadata in
`result/gap_threefold_cross_dimension_manifest.g`, with variable
`ThreefoldCrossDimensionManifest`. Its complete decisions are written to
`result/gap_threefold_cross_dimension_all_pairs.g`, with variable
`ThreefoldCrossDimensionAllPairs`. Every positive row contains an invertible
five-dimensional `P`, using the convention `P^-1 H_i P <= H_j`.
Partial runs retain completed pair prefixes in `output/`; they do not
replace the full result. [run_threefold.py](run_threefold.py) launches one
GAP process without a time limit. Explicit `--resume` requires unchanged
input, algorithm, and GAP version and rechecks saved positive matrices; it does not
reuse undecided pairs as decisions.

[gap_threefold_containment.g](gap_threefold_containment.g) verifies the
exact input binding, both coordinate catalogues and their audit, every
ordered pair's metadata and status, and each positive matrix on all source
generators. A final report requires complete coverage and no undecided
eligible pair. The full positive relation determines its covers and
action-maximal rows; the transitive closure of the covers is checked
against the complete relation.

Independently, adjoining a cube and uniqueness of additive splittings
identify threefold family inclusion with inclusion of the corresponding
fourfold families. The report compares the direct relation pair by pair
with the full fourfold relation restricted to the 40 source rows. It does
not try to restrict a six-dimensional embedding matrix to a selected
five-space: the removed Fermat lines need not match. Nor does it simply
retain fourfold covers, since intermediate fourfold rows may be absent
from the threefold sources. The direct result has 260 positive relations,
83 covers, and action-maximal Nos. 1, 2, 3, 5, 24, 39, and 40; the report
checks that the two independent calculations agree.

An ordered group pair `i -> j` means `H_i` is contained up to linear
conjugacy in `H_j`, so `Z_j` is contained in `Z_i`. The result tables list
group cover targets and all reachable action-maximal targets. Separately,
the geometric adjacency `#i: {j, ...}` lists families `Z_j` that properly
contain `Z_i` with no classified family between them. It reverses group
containment and contains the same 83 covers. The report also gives all
40 group names, orders and IDs, invariant and centralizer dimensions,
Fermat ranks, source numbers, and the family-dimension histogram.

Finally, [gap_threefold_table_data.g](gap_threefold_table_data.g) verifies
the final group and quotient orders and exports compact table data to
[gap_threefold_table_data.out](result/gap_threefold_table_data.out), with
its log in `output/gap_threefold_table_data.log`. It reads the action-maximal flags
from the containment result. All final results use increasing source
fourfold order; the source number is recorded explicitly in each row.
See [gap_threefold_result.md](result/gap_threefold_result.md) for the
tables and complete containment summary.
