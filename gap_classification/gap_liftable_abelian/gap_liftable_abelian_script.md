# Liftable abelian calculation

## Task and mathematical input

The calculation enumerates diagonal candidates for liftable abelian full
projective automorphism groups of smooth cubic fourfolds. Write `H` for a
linear group containing `mu_3 = <E(3)I_6>`, and `G = H/mu_3` for its
projective image. In the preserved core, some variables named `G` denote
linear groups; the exported GL/PGL fields distinguish the two.

[Peng--Zheng, Theorem 4.2](../../REFERENCES.md#abelian-actions) supplies the
maximal liftable diagonal models. The source list retains its 24 simple
`K/T/Y` combinations and eight non-simple types. Every subgroup enumerated
inside a strict maximal model preserves its smooth defining cubic.
Consequently, its invariant cubic space has a nonempty smooth locus; no
additional smoothness exclusion is needed here.

The projective actions `C48` and `C32` are added separately, using `X'_5`
and `X'_8` from
[Yang--Yu--Zhu, Example 6.1](../../REFERENCES.md#symplectic-actions-and-maximal-groups).
Their linear groups have orders 144 and 96. The entry point verifies the
linear/projective orders, projective structures, and six expected invariant
monomials for each action.

## Computation order

`gap_liftable_abelian_original.g` contains the preserved diagonal core.
`gap_liftable_abelian.g` adds metadata and output without changing the
ordinary enumeration. The specialized routines are retained rather than
replaced with general matrix-group routines.

The ordinary calculation follows this order:

1. Verify the 32 maximal linear source groups, their orders, and their scalar subgroups.
2. For each source `M`, enumerate all subgroups of `M/mu_3` in a pc-group model and pull them back to `M`.
3. Compute each subgroup's invariant cubic monomials and centralizer dimensions.
4. Process larger groups first. Discard a subgroup if a retained strictly larger subgroup in the same source contains it and has the same family dimension.
5. Retain the surviving subgroups whose linear orders divide at least one of 48, 72, and 108, then combine the sources.
6. Deduplicate diagonal groups by exact coordinate-permutation conjugacy, using inexpensive invariants and element spectra to restrict the searches. Merge source labels and occurrence counts.
7. Apply the abelian-full-group spectral exclusions and the bound `|H intersect SL(6)| <= 12`.
8. Attach GL/PGL metadata, prepend `C48` and `C32`, number the records, and write the output files.

Compact pseudocode for the ordinary core:

```text
pool := []
for M in the preserved maximal source list:
    entries := preimages of all subgroups of M/mu_3
    compute invariant bases and family dimensions
    sort entries by decreasing linear order
    retained := []
    for H in entries:
        if no retained larger group contains H with the same dimension:
            append H to retained
    append order-filtered retained entries to pool
deduplicate pool by exact coordinate-permutation conjugacy
apply the spectral and determinant-one restrictions
```

The local containment test is literal containment inside a fixed diagonal
source. It is not the later conjugate-embedding test between arbitrary linear
groups. Cross-source deduplication identifies equivalent representations; it
does not certify saturation.

For a diagonal action, a cubic monomial `x_i x_j x_k` is invariant precisely
when its weight is 1 on every selected generator. If the distinct coordinate
characters have multiplicities `m_r`, the GL centralizer has dimension
`sum(m_r^2)`. The recorded family dimension is
`invariantCubicDimension - centralizerGLDimension`.

The spectral keys are only preliminary invariants for group equivalence;
agreement of keys alone is not accepted as a proof of equivalence. The exact
coordinate-permutation search decides conjugacy of the diagonal groups.

The patterns in `DangerousPatterns` are expanded by units modulo the root
order and by scalar powers `E(3)^j`. These exclusions concern an **abelian
full projective stabilizer**: the relevant spectra force additional
non-abelian symmetry. They are not general smoothness obstructions for
subgroup actions. In particular, `DangerousElementData` is not a
singularity test.

## Main functions

| Function | Purpose |
|---|---|
| `LAM_TBlock`, `LAM_KBlock`, `LAM_YBlock` | Construct the diagonal cubic block groups. |
| `LAM_DiagonalGroupFromBlocks` | Embed and combine blocks in six coordinates. |
| `VerifyLiftableAbelianMaximalList` | Check the maximal source list and scalar inclusion. |
| `CubicDiagonalModuliData` | Compute invariant exponent vectors, character multiplicities, and dimensions. |
| `EssentialCubicSubgroupsContainingMu3` | Enumerate scalar-containing subgroups and perform local equal-dimensional pruning. |
| `CollectLiftableAbelianEssentialCandidates` | Combine the order-filtered source results. |
| `LAM_FastDiagonalEquivalenceData` | Decide diagonal group equivalence by constrained permutation search. |
| `DeduplicateLiftableAbelianEssentialCandidates` | Deduplicate candidates and merge their source information. |
| `DangerousElementData` | Detect the specified abelian-full-group spectra. |
| `LAM_DeterminantOneSubgroupSize` | Compute the kernel size of the determinant character. |
| `ApplyFinalRestrictionsToDedup` | Apply the spectral and determinant-one restrictions. |
| `InvariantCubicMonomialBasis` | Convert invariant exponent vectors to monomial strings. |
| `LAM_ArchiveSpecialYYZExamples` | Construct and check the two special cyclic actions. |
| `LAM_ArchiveAttachMetadata` | Attach linear/projective group metadata and invariant bases. |
| `LAM_ArchiveRunAndWriteFiles` | Run the entry point and write the three generated files. |

## Saved record fields

| Fields | Meaning |
|---|---|
| `label`, `group`, `generators` | Local candidate number and its exact linear matrix group. |
| `linearOrder`, `projectiveOrder` | Orders of `H` and `H/mu_3`; the former is three times the latter. |
| `GLId`, `PGLId` | GAP `IdGroup` values for these abstract finite groups, or `fail` when unavailable. They do not identify representations. |
| `GLStructure`, `PGLStructure`, `GLAbelianInvariants`, `PGLAbelianInvariants` | Abstract group descriptions. |
| `familyDimension`, `invariantCubicDimension` | Moduli dimension and vector-space dimension of invariant cubics. |
| `centralizerGLDimension`, `centralizerPGLDimension`, `centralizerBlocks` | Centralizer dimensions and coordinate-character multiplicities. |
| `determinantOneSubgroupSize` | Order of `H intersect SL(6)`. |
| `invariantCubicBasisStrings` | Complete invariant cubic monomial basis, stored as strings. |
| `sourceIndices`, `sourceNames`, `combinationNames` | Maximal sources and their preserved combination labels. |
| `equivalenceClassSize` | Number of merged candidate occurrences, not the number of distinct source types. |
| `source`, `sourceReferences`, `isSpecialYYZExample` | Mathematical source information and special-example flag. |

The order is `C48`, `C32`, then the ordinary candidates in the order
returned by the core. Labels `LA-001` through `LA-053` are local to this
output and are not global family numbers.

## Loading functions without enumeration

For the saved candidate list and normal running instructions, see
[README.md](README.md). To load only the core and entry-point functions:

```gap
LAM_AUTO_RUN := false;
Read("gap_liftable_abelian.g");
```

A deliberate entry-point run overwrites the `.out`, `.log`, and
`_data.g` files. Default output filenames are relative to the current
directory; the generated files do not record its absolute path.

The two reference booleans check only the expected counts, 51 ordinary and
53 total. A count discrepancy is recorded rather than silently discarded.
These checks are not a substitute for comparing individual representations.
The saved run, preserved source, full records, and historical comparison checks
are documented in
[gap_liftable_abelian_results.md](gap_liftable_abelian_results.md).
