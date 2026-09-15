# Self-conjugacy of families

This directory contains reusable exact self-conjugacy functions and the
uniform audit of the final 156 cubic-fourfold families. Self-conjugacy is
kept separate from smoothness and saturation.

For a finite matrix group `H`, self-conjugacy means that `H` is linearly
conjugate to its coefficientwise complex conjugate. An abstract group
isomorphism alone is insufficient. The family test checks an exact
conjugating matrix and its induced invertible map on the complete invariant
cubic space. It identifies the family with its conjugate; it does not assert
that every individual member is isomorphic to its complex conjugate.

The functions use exact cyclotomic arithmetic. A successful family
certificate records the matrix, the images of the chosen generators, and
the induced identification of the cubic bases.

## Functions

`gap_self_conjugacy_functions.g` provides two public entry points:

- `CF_SC_TestLinearGroupSelfConjugacy(generators[, options])`;
- `CF_SC_TestFamilySelfConjugacy(generators, cubicBasis,
  exponentBasis[, options])`.

The search first tests equality with the conjugate group in the stored
coordinates. Otherwise it constructs a faithful permutation model and
searches all abstract automorphisms. Scalar and natural-character tests are
exact. A positive matrix certificate is rechecked generator by generator.
The family version also records the induced invertible map between the cubic
basis and its coefficientwise conjugate.

Unless the user sets `maximumAutomorphisms`, the automorphism search is
exhaustive. A cap without a character match gives `unknown`. If a complete
character match is found but the explicit matrix is not recovered, the
status is `character_certified_no_matrix`; the linear equivalence follows
from the character criterion, but the requested matrix certificate is absent.
A negative result requires an exhaustive automorphism search with no match.
The batch audit requires the full matrix and cubic-space certificates for
its computed positive records.

## Catalogue audit

`gap_self_conjugacy.g` is the catalogue entry point. It reads the 156
survivor keys from `../gap_saturation/gap_equal_dimension_saturation.out`
and recovers the corresponding matrix records from
`../gap_saturation/gap_saturation_input.g`. It does not repeat the following
theoretical cases:

- connected symplectic families;
- families with rank of `S` at least 19;
- families whose projective group order is divisible by 7;
- families with symplectic part `3^{1+4}:2`.

Every remaining family is checked with exact cyclotomic arithmetic. The run
writes an incremental transcript to `gap_self_conjugacy.log`, a GAP-readable
certificate record to `gap_self_conjugacy.out`, and a readable summary to
`gap_self_conjugacy.md`. A deliberate rerun replaces these three files.

The saved run contains 56 theoretical exemptions and 100 successful exact
family tests. The exemption counts overlap, and exempt rows are not
additional computational certificates. The theoretical cases rely on the
[symplectic and maximal-group results](../../REFERENCES.md#symplectic-actions-and-maximal-groups)
and [additive-splitting input](../../REFERENCES.md#additive-splittings).

This batch checks every non-exempt survivor, not only index-two families.
For the large families, the index-two checks are the ones
needed to identify the two conjugate period-domain components. The saved
`run no.` follows the saturation-survivor order, not the numbered catalogue
order. Use `sourceKey` to compare the two catalogues.

The final coordinate catalogue is
[`gap_family_catalogue.g`](../gap_manuscript_validation/gap_family_catalogue.g).
The [conjugating matrices](../gap_manuscript_validation/gap_family_correspondence.out)
identify these representatives with the computed survivors. Self-conjugacy is
unchanged by linear equivalence. The stored matrices must be transformed
accordingly before use in the displayed coordinates.

From the repository root, run

```gap
Read("gap_classification/gap_self_conjugacy/gap_self_conjugacy.g");
```
