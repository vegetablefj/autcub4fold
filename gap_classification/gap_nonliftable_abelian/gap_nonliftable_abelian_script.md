# Non-liftable abelian data

## Task and action convention

The module records two explicit non-liftable abelian projective actions.
The two possibilities are supplied by theoretical classification, not by
representation enumeration in this directory. See the
[mathematical references](../../REFERENCES.md#classification-papers) for
that input. Verifying the supplied models is distinct from proving the
classification complete.

Write `H` for the strict linear group and `G = H/mu_3` for its projective
image, where `mu_3 = <E(3)I_6>`. The generators are:

- `P = NonliftableAbelianPermutation`, representing `(123)(456)`;
- `D = NonliftableAbelianNinthRootDiagonal`, with diagonal entries
  `[E(9), E(9)^4, E(9)^7, E(9), E(9)^4, E(9)^7]`;
- `T = NonliftableAbelianInvolution`, with diagonal entries
  `[1, 1, 1, -1, -1, -1]`.

The first record has `H = <P,D>`; the second has `H = <P,D,T>`.
The permutation uses row-action convention: its entry `(i,sigma(i))`
is 1. Since `D^3 = E(3)I_6`, no additional scalar generator is needed.

Both projective groups are abelian although their strict linear groups are
not. Indeed, `P D P^-1 D^-1 = E(3)I_6`, while `T` commutes with
`P` and `D`. Multiplying lifts by scalars cannot remove this nontrivial
commutator, so these projective actions do not admit commuting linear lifts.

## Record fields

| Fields | Meaning |
|---|---|
| `label` | Local identifier, `NLA-001` or `NLA-002`. |
| `matrixGenerators` | Exact generators of the six-dimensional strict linear group. |
| `linearGroupId`, `linearGroupStructure`, `linearOrder` | Abstract linear group metadata. |
| `projectiveGroupId`, `projectiveGroupStructure` | Abstract metadata of the quotient by `mu_3`. These do not identify representations. |
| `symplecticPart`, `symplecticGId`, `rankS` | Projective symplectic subgroup and its coinvariant-lattice rank. |
| `determinantOneSubgroupSize` | Order of `H intersect SL(6)`, including `mu_3`. |
| `genericIndex` | Generic non-symplectic index of the ambient connected symplectic family, 1 for both records. |
| `fullIndex` | Non-symplectic index `[G:G_s]` of the candidate's full projective group, 3 or 6. |
| `liftable` | `false` for both projective actions. |
| `cubicInvariantDimension`, `cubicInvariantBasisStrings` | Dimension and complete basis of the strict invariant cubic space. |
| `centralizerDimension`, `familyDimension` | GL centralizer dimension and invariant dimension minus centralizer dimension. |
| `source`, `smoothnessStatus` | Input provenance; loading the file does not run a new smoothness test. |

Both candidates lie in the connected `C3` symplectic family with
generic index 1. Their full indices are 3 and 6; these are distinct
from the generic index and are stored separately.

## Checks and downstream use

The saved groups have orders 27 and 54, scalar subgroup order 3, and
determinant-one subgroup order 9. Their projective symplectic subgroups
therefore have order 3. The invariant and GL centralizer dimensions are
`6/4` and `3/2`, giving family dimensions 2 and 1.

All matrices, basis entries, IDs, dimensions, and record order are retained
from the existing data. The two index fields now have the same meanings as
in the other modules. The source fields describe the model and its
theoretical provenance.

The data file is self-contained. Smoothness and saturation computations
load it as candidate input. The saturation loader checks `fullIndex`
against the determinant image order; the smoothness test does not use
either index field. This module does not load their outputs or a final
result-display catalogue. Loading commands are given in
[README.md](README.md), and the records and existing smoothness certificates
are summarized in
[gap_nonliftable_abelian_results.md](gap_nonliftable_abelian_results.md).
