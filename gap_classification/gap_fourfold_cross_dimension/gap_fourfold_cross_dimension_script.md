# Cross-dimensional containment: scripts and checks

## Objects and direction

Each numbered row consists of a finite strict linear group `H_i` in
`GL(6)` and the dimension `d_i` of its saturated invariant family `Z_i`.
The cubic scalar matrices are included. Numbers are always those of the
stored 156-family catalogue; small-row positions are only working indices.

The comparison asks whether some invertible matrix `P` satisfies
`P^-1 * H_i * P <= H_j`. This gives `Z_j subset Z_i`, up to the same
coordinate change. The group direction and the geometric direction are
opposite. Only pairs with `d_i > d_j` occur here; equal-dimensional
comparisons were handled in the saturation calculation. Lagrange's theorem
also requires `|H_i|` to divide `|H_j|`. There are exactly 6568 eligible pairs.

## Exact embedding searches

The search uses the fixed representatives in
`input/fourfold_search_catalogue.g`. `gap_prepare_input.g` validates them
and constructs `fourfold_156.g`, `fourfold_small.g`, and the large-target
schedule. The split at order 2000 is computational only: there are 142
small rows and 14 large targets.

For each small source, `gap_run_small_row.g` scans eligible small targets
in input order. A literal generator inclusion is accepted with the identity
matrix. When both verified SmallGroups IDs are available, an exhaustive
abstract-subgroup check can reject a pair. An abstract embedding alone is
not sufficient for acceptance. All other pairs use `SearchEmbeddingStrict`
from `../gap_functions.g`, followed by an explicit-matrix check.

The large-target function `CFCD_SearchLargeEmbedding` first applies exact
necessary filters and tries literal matrix inclusion. Its remaining search
has the following form:

```text
For each conjugacy-class representative K of subgroups of the target:
    If |K| equals the source order, try an isomorphism source -> K.
Keep one isomorphism for each isomorphic subgroup representative.
For each kept isomorphism:
    Try the identity source automorphism, then all source automorphisms.
    Reject quickly if a generator trace differs.
    Compare traces on every source conjugacy-class representative.
    If the characters agree, construct an invertible intertwiner.
    Check that conjugating every source generator puts it in the target.
    Return a positive result with that matrix.
If all subgroup representatives and automorphisms are exhausted:
    Return a negative result.
If required infrastructure is unavailable or fails:
    Return undecided, not a negative result.
```

`ConjugacyClassesSubgroups` supplies the large-target subgroup
representatives. Every image subgroup is target-conjugate to one of them.
Every isomorphism to a fixed representative differs from a chosen
isomorphism by a source automorphism. These two finite searches therefore
cover all embeddings up to linear conjugacy. The small-stage shared
functions may use `IsomorphicSubgroups` to select the relevant subgroup
classes; the large stage retains the full subgroup-class scan.

For finite complex representations, equality of characters is equivalent
to linear equivalence. Traces on generators alone do not prove this:
the accepting comparison checks every conjugacy class. An invertible
intertwiner is then independently verified on every source generator.
Necessary filters, subgroup data and character data may be cached, but the
subgroup and automorphism scan order is unchanged.

`gap_run_large_target.g` also propagates proved positive relations.
If `P_ik` and `P_kj` are valid matrices, their product is a witness for
`i -> j`. The product is checked before acceptance. The fields `direct`,
`classification` and `viaNumber` record this distinction; they do not
describe whether a relation is a cover.

## Complete decisions and displayed coordinates

`gap_aggregate_small.g` checks the small layer. `gap_finalize.g` combines
all layers, checks every eligible pair exactly once, verifies all positive
matrices and transitivity, and saves `input/fourfold_computed_pairs.g`.
There are 1387 directly obtained positives, 406 propagated positives and
4775 directly decided negatives. None is undecided.

The coordinate correspondence is read from
`../gap_manuscript_validation/gap_family_correspondence.out`. For each row,
its matrix `Q_i` identifies the search group with the displayed group:
`Q_i^-1 * H_computed,i * Q_i = H_displayed,i`.

`gap_coordinate_containment.g` does the following, without calling an
embedding-search function:

```text
Check numbers, source keys, dimensions, group IDs and full indices.
For each i, check Q_i is invertible and both group inclusions above.
For each saved positive pair (i,j):
    Set P_displayed = Q_i^-1 * P_computed * Q_j.
    Check its invertibility and every displayed source generator
    after conjugation against the displayed target group.
Keep every saved negative record unchanged.
Check complete pair coverage and equality of the positive-pair sets.
Recompute covers and action maxima and compare their complete sets.
Write the final relation in displayed coordinates.
```

Both-endpoint conjugacy preserves existence and nonexistence of embeddings,
so the saved negative decisions remain valid. The 1793 positive matrices
are checked anew. `CF_FP_LoadFourfold` binds later reports to the actual
displayed generators and transported records, not just to matching counts.
No classification or saturation decision changes.

## Covers and action-maximal rows

`CF_FP_Poset` checks that the full positive relation is strict and
transitive. A positive pair `(i,j)` is a cover precisely when there is no
number `k` with `i -> k -> j`. It computes all 433 covers and verifies that
their transitive closure recovers all 1793 positive pairs.

An action-maximal row has no outgoing strict relation. A breadth-first
search along covers finds every reachable action-maximal row and one
explicit cover path to each of them. The 21 maxima are checked against
the classification-table flags. Two small regression tests check multiple
maximal targets and an isolated maximal row.

`gap_fourfold_maximal.g` writes the readable result in classification-table
order and the GAP-readable maximal-action records. Every row lists all its
immediate specializations and all reachable action-maximal specializations.
The 21 action-maximal rows are geometrically minimal in this order;
the unique geometrically maximal classified family is No. 132.

The supplied Python files only schedule GAP processes and check successful
completion. They make no mathematical decisions. All result records and
matrix checks are produced by GAP.
