# Shared GAP functions

This document records the scope, sources, and interfaces of
[`gap_functions.g`](gap_functions.g). Existing function names and record
fields are retained for compatibility with the recorded computations.

## Current status

The shared file is used by the current small-group wrappers, smoothness,
containment, coordinate-presentation, and threefold modules. The liftable
abelian calculation deliberately keeps its unchanged diagonal core instead
of replacing its specialized routines with the general functions.

The recorded GAP versions and completed checks belong to the individual
run reports. The checklist below is a procedure for future changes, not a
claim that current computations have never been run. Loading this file only
defines functions; it does not start a catalogue calculation.

## Source versions

The following files were compared. A file may contain several definitions of the same function. In that case, the last definition is the one used by GAP.

| Historical source | Role in the shared file |
|---|---|
| `cubic_fourfold_liftable_V26_audited_integrated_S_ASSIGNMENT_SAFE.txt` | Basic helpers, exact deterministic intertwiner, and the optimized cubic-invariant calculation |
| `CubicFourfold_nonliftable_v8_2_1_integrated_S_ASSIGNMENT_SAFE.txt` | Character-table rebasing and the later non-liftable compatibility patches |
| `CubicFourfold_V26_Koike_S3_family1_fast_S2_all_72_96_144_combined.txt` | Compared for dependencies; its model enumeration remains specialized |
| `strict_embedding/catalogue_search.g`, updated 22 August 2026 | Fingerprints, abstract subgroup filters, and conjugating-matrix witnesses |
| `strict_embedding/strict_embedding.g`, updated 22 August 2026 | Exact conjugacy-embedding search, including exhaustive subgroup images and automorphism twists |

These names describe the historical extraction sources. They are not paths
that the public scripts read. The shared implementation and the preserved
module-specific cores contain the required functions; no unarchived working
directory is a runtime dependency.

## Functions placed in the shared file

### Basic utilities

| Functions | Use |
|---|---|
| `CF_SPrint` | Controlled output used by the integrated programs |
| `CF_CheckSmallGroupId` | Validate a Small Groups Library identifier |
| `CF_SameSubgroup` | Test equality of two subgroups without relying on object identity |
| `CF_JoinStrings` | Stable string joining for reports and certificates |
| `CF_SquareMatrixDimension`, `CF_MatrixListDimension` | Read and validate matrix dimensions |
| `CF_IsScalarMatrix`, `CF_IsScalarWithValue`, `CF_ScalarMultipleRatio` | Exact tests for scalar and projectively equal matrices |
| `CF_BlockDiagonalMatrixList` | Construct a block-diagonal matrix from arbitrary square blocks |

### Finite groups and characters

| Functions | Use |
|---|---|
| `CF_CharacterFromMultiplicities` | Construct a character from irreducible multiplicities |
| `CF_ClassPositionContainingElement`, `CF_ClassFusionByImageFunction`, `CF_PullbackClassFunctionByFusion` | Transfer class functions through a specified map of conjugacy classes |
| `CF_RebaseClassFunction` | Put equal class functions on the same character-table object |
| `CF_NaturalCharacterOfMatrixGroup` | Compute the natural character of a finite matrix group through a permutation model |
| `CF_CharacterOrbitUnderAutomorphisms` | Compute the full character orbit under abstract group automorphisms |
| `CF_EmbeddingIntoH` | Convert an isomorphism onto a subgroup into an explicit embedding |
| `CF_NormalCopiesOfKbar` | Enumerate normal subgroups isomorphic to a fixed group |
| `CF_BlockImageOfComponents`, `CF_ScalarImagesOfAbstractCentre` | Evaluate a direct sum of representation components and record the central elements with scalar image |
| `CF_ApplyIndexPermutationToMultiplicityVector` | Apply an automorphism-induced permutation to multiplicity data |
| `CF_GroupIdentificationData` | Record order, SmallGroup ID when available, structure description, and abelian invariants |
| `CF_DeterminantImageOrder`, `CF_DeterminantKernelSize` | Compute the determinant image and determinant-one subgroup orders of a finite matrix group |

### Exact linear algebra

| Functions | Use |
|---|---|
| `CF_NonnegativeColumnSolutions` | Solve a nonnegative integral multiplicity equation |
| `CF_NullspaceOfEquationRows` | Compute solutions of equations recorded as coefficient rows |
| `CF_VectorToSquareMatrix` | Row-major vector-to-matrix conversion used by the integrated programs |
| `CF_ForEachSparseIntegerVectorAtLevel`, `CF_FindInvertibleCombination` | Deterministic search for an invertible element of a matrix subspace |
| `CF_Intertwiner` | Produce an exact matrix intertwining two ordered generator lists |
| `CF_LinearCombinationOfVectors` | Form exact linear combinations of coefficient vectors |

### Matrix-group comparison

| Functions | Use |
|---|---|
| `FingerprintWeak`, `FingerprintStrong` | Exact element fingerprints used as necessary embedding tests |
| `MultisetFromList`, `IsSubmultiset`, `MergeWeighted`, `IsSubmultisetWeighted` | Multiplicity-aware comparison of fingerprint data |
| `ConjugacyFingerprintMultisets`, `DerivedSeriesOrders`, `AbstractEmbedsById` | Abstract and representation-theoretic necessary conditions for embeddings |
| `MatFromVec` | Column-major conversion used by the Kronecker-product intertwiner equations |
| `IntertwinerSpace`, `AveragedIntertwiner`, `IntertwinerSeedMaps`, `FindInvertibleIntertwiner` | Construct a conjugating matrix for a positive representation match |
| `VerifyConjugation` | Check the conjugating matrix and target-group membership exactly |
| `MatToGapString` | Print a matrix as reusable GAP input |
| `CF_PermuteDiagonalMatrix`, `CF_SearchDiagonalConjugacyEmbedding` | Exact coordinate-permutation backend for conjugacy embeddings between finite diagonal groups |

`CF_VectorToSquareMatrix` and `MatFromVec` intentionally use different vectorization conventions. They must not be merged without changing the corresponding systems of linear equations.

For finite diagonal source and target groups, a linear-conjugacy embedding can be checked by `CF_SearchDiagonalConjugacyEmbedding`. If an arbitrary linear conjugacy sends the source into the diagonal target, equality of the corresponding sums of one-dimensional characters provides a coordinate permutation with the same property. The function exhausts all coordinate permutations and therefore returns an exact positive or negative answer without constructing a general intertwiner.

### Strict conjugacy embedding

| Functions | Use |
|---|---|
| `PreprocessMatrixGroupStrict` | Validate a finite matrix group, infer its dimension, and construct a faithful permutation model |
| `StrictEnsureFingerprints`, `StrictEnsureDerived`, `StrictEnsureSourceCharacterData`, `StrictEnsureSmallGeneratingSet`, `NecessaryFiltersStrict` | Cache and apply intrinsic necessary conditions, source-side character data, and backend-selection data |
| `StrictAutGroup`, `StrictAutList` | Construct and cache the full automorphism group; the list wrapper is retained for compatibility |
| `StrictOuterAutRepresentatives` | Construct and cache one representative of each coset in `Aut(H)/Inn(H)`; a user-supplied cap gives an explicit inconclusive result |
| `StrictTraceAllClasses`, `IsoTraceTable`, `IsoTraceOf` | Check equality of natural characters on every conjugacy class, with cached target traces |
| `AlgorithmAStrict` | Enumerate target-conjugacy classes of source images with `IsomorphicSubgroups`, then test the required outer-automorphism twists |
| `StrictVerifyCandidates` | Try to attach an explicit conjugating matrix to a character-theoretically valid embedding |
| `SearchEmbeddingStrict` | Main three-valued entry point: `embedded`, `no_embedding`, or `undecided` |
| `SearchEmbeddingStrictViaSubgroup` | Search through a specified intermediate subgroup without promoting an incomplete negative result to a global one |
| `ComposeEmbeddingWitness` | Compose two explicit conjugating matrices in a layered containment proof |

For finite groups over characteristic zero, an injective homomorphism whose pulled-back natural character equals the source natural character gives an equivalence of representations. Hence it proves the required linear-conjugacy embedding even if the optional explicit intertwiner search returns `fail`. For a fixed subgroup image, twists by inner automorphisms of the source differ only by conjugation inside the target. They have identical target traces and are omitted. The strict search tests one representative of every coset in `Aut(H)/Inn(H)`, including the identity case, so the reduction is exhaustive. A negative answer is returned only after the abstract subgroup images and all required outer-automorphism twists have been exhausted. Failures of permutation conversion, automorphism construction, or a user-supplied search cap return `undecided` instead.

The existing `max_aut` option still caps the size of the full automorphism group. The optional `max_outer_aut` option caps the number of outer-automorphism cosets. Exceeding either cap returns `undecided`, never `no_embedding`.

For equal source and target orders, `AlgorithmAStrict` calls `IsomorphismGroups` directly because the only possible image is the whole target. For a proper embedding it normally calls `IsomorphicSubgroups(target, source)`, which returns representatives of the target-conjugacy classes of isomorphic image subgroups. The small-source `p`-group branch retains the exhaustive Sylow-subgroup method recommended for this case. The remaining backend choice is described below.

The bulk version also caches the source automorphism group, outer-automorphism
transversal, conjugacy-class representatives, and natural-character values.
It tests literal containment in the supplied matrix coordinates before any
fingerprint computation. Failure of this fast path has no mathematical
meaning and falls through to the complete strict search. Derived-series
orders are tested before the more expensive full fingerprint multisets. The
latter are optional necessary filters: setting `use_fingerprints := false`
skips them without changing the exhaustive subgroup-and-character test.

The proper-subgroup backend is hybrid. It normally uses
`IsomorphicSubgroups(target, source)`. If a compact source generating set
still has more than two generators and the target order is at most 2000, it
uses the complete `ConjugacyClassesSubgroups(target)` backend instead and
caches that class list. This is the case for which GAP itself warns that
`IsomorphicSubgroups` may perform poorly. Both branches are exhaustive; the
choice affects only runtime.

The minimal calling pattern for both liftable-abelian containment and the later conjugacy/saturation computation is:

```gap
sourceInfo := PreprocessMatrixGroupStrict(sourceGenerators, fail, fail);
targetInfo := PreprocessMatrixGroupStrict(targetGenerators, fail, fail);
result := SearchEmbeddingStrict(sourceInfo, targetInfo);
```

The optional second and third preprocessing arguments are a reported group order and a documentary group identifier. Neither is used to prove a negative result. The caller must inspect `result.status`, rather than treating `result.ok <> true` as non-embedding. In particular, `undecided` must be retained for further computation.

For bulk containment or conjugacy checks that do not need an explicit matrix certificate, use

```gap
result := SearchEmbeddingStrict(
    sourceInfo,
    targetInfo,
    rec(construct_witness := false)
);
```

This still performs the complete abstract embedding and all-class character test. It only skips the final optional intertwiner construction.

### Invariant cubics and centralizers

| Functions | Use |
|---|---|
| `CF_DegreeThreeExponentVectors`, `CF_DegreeThreeExponentVectors6` | Enumerate degree-three monomials; the second is the retained six-variable entry point |
| `CF_DiagonalCubicModuliData` | Exact fast computation of invariant cubic monomials and centralizer dimensions for a diagonal action |
| `CF_MultiplyTermsByLinearForm`, `CF_MonomialImageVector` | Compute the action of a matrix on cubic monomials |
| `CF_MonomialString`, `CF_CoefficientVectorToPolynomialString` | Produce readable invariant cubics |
| `CF_MonomialFromExponent`, `CF_CoefficientVectorToPolynomial` | Construct GAP polynomial objects |
| `CF_ReduceGeneratorsForCubicInvariants` | Remove scalar and projectively redundant equations without changing the invariant cubic space |
| `CF_ReduceGeneratorsForCentralizer` | Remove scalar and projectively redundant centralizer equations |
| `CF_RestrictRowBasisByEquationRows` | Intersect a row space with additional exact linear equations |
| `CF_PrepareCubicPolynomialContext`, `CF_CubicInvariantBasis` | Compute the invariant cubic space and optional polynomial basis |
| `CF_CentralizerAlgebraBasis` | Compute the commuting matrix algebra |

The polynomial degree remains fixed at three. This matches every current classification computation.

For a diagonal action, every degree-three monomial is a simultaneous eigenvector. Hence `CF_DiagonalCubicModuliData` tests its generator weights directly. Two coordinate lines belong to the same centralizer block exactly when their diagonal characters agree on every generator, so the centralizer dimension is the sum of the squares of the block sizes. This is an exact specialization of the general invariant-space and centralizer computations, not a heuristic filter.

## Dimension generalization

The existing programs were written for matrices in `GL(6)`. The following changes make their low-level linear algebra usable in other dimensions while preserving the six-dimensional calls:

- Matrix dimensions are inferred from nonempty generator lists.
- `PreprocessMatrixGroupStrict` and the strict conjugacy-embedding search now work in an inferred common matrix dimension. Inputs in different dimensions are rejected by an intrinsic dimension filter.
- `CF_Intertwiner`, `IntertwinerSpace`, and `FindInvertibleIntertwiner` accept an optional dimension when both generator lists are empty. Their compatibility default remains `6`.
- `CF_CentralizerAlgebraBasis` infers the dimension before removing scalar generators. For a genuinely empty list, an optional third argument specifies the dimension; the compatibility default remains `6`.
- `CF_CubicInvariantBasis` infers the number of variables from its matrices. For an empty list, `rec(ambientDimension := n)` can be supplied. The compatibility default remains six variables.
- The monomial functions work in any number of variables, but always in degree three.

For six variables, the recursive loop agrees with the original six nested loops:
both produce the same 56 exponent vectors in the same order. Preserving this
order is part of the regression contract because saved coefficient vectors
are interpreted against it.

## Functions deliberately left in individual computations

The following functions remain in their individual modules:

- `S_1`, `S_2`, `S_3`, `S_4`, `CF_OneStepS`, and all complete-pipeline drivers;
- cohomology and central-extension enumeration functions whose liftable and non-liftable versions have different record contracts;
- `CF_BuildMatrixRepresentation`, because the current versions return different record fields;
- fast deduplication caches and batch filters, because they depend on the exact record layout of one computation;
- all `LAM_...` functions tied to the diagonal liftable-abelian models;
- all `CF_KF1_...` functions tied to the specialized Koike `S3` model;
- smoothness batch drivers and external Singular scripts;
- catalogue-wide preprocessing, transitive-closure bookkeeping, and saturation batch drivers.

This separation is intentional. The exact embedding test is shared;
operations tied to the layout and traversal of a particular catalogue remain
in its individual computation.

## Loading order

From the repository root, load the shared functions with

```gap
Read("gap_classification/gap_functions.g");
```

The preserved integrated engines define some of the same global names. GAP
uses the last definition read. Use the documented module entry point and its
loading order in a fresh session; do not freely mix a frozen integrated
program with current wrappers. The small non-abelian wrapper loads the
shared functions, its workflow helpers, the fixed engine, and the case files
in that order.

## Regression checklist

Before changing a shared implementation or switching a preserved core to
it, compare the affected program with its reference run on the same GAP
installation. This checklist does not request a rerun for documentation-only
edits.

1. Confirm that `CF_DegreeThreeExponentVectors6()` gives exactly the retained
   ordered list of 56 vectors.
2. Compare `CF_CubicInvariantBasis` coefficient spaces for representative diagonal, reducible, and irreducible matrix groups.
3. Compare centralizer dimensions and matrix bases, including a group generated only by scalars.
4. Compare the exact matrices returned by `CF_Intertwiner` when the original search is deterministic.
5. Compare character orbits and every representation-deduplication count.
6. Compare every positive, negative, and undecided strict-embedding result. For positive cases, compare the character-matching images and verify every displayed conjugating matrix. For negative cases, confirm that the shared version reports an exhaustive search rather than a resource failure.
7. For an algorithmic change, compare the affected pipeline's survivor
   labels, dimensions, group identifiers, and invariant coefficient spaces.
   The general non-liftable non-abelian representation pipeline is retained as
   pseudocode because the current target groups have trivial multiplier
   3-part. Its standalone `gap_multiplier_audit.g` verifies this reduction to
   the already packaged `Ext^1` enumeration.

Byte-for-byte output equality is desirable for deterministic sections. For sections that use random intertwiner seeds, compare the mathematical certificate and final classification data rather than the literal matrix chosen.

The character criterion used here is equality on every conjugacy class,
after an injective abstract homomorphism is fixed. It is not a comparison of
generator traces alone. Neither optional fingerprint rejection nor failure
to find an explicit intertwiner replaces the exhaustive character test.
For linear groups, projective quotients, and geometric families, see the
[repository conventions](../README.md).
