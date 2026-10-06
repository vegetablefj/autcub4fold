# Direct-source assembly and algebraic lattices

The [manifest](manifest.jl) fixes a saved stage record, selector, and
supporting evidence for each family No. 1–156. The
[builder](build_156.jl) takes family metadata from the
[GAP numbering table](../../input/family_numbering.md), loads
those records, retains applicable alternative candidates and parent paths,
and checks the selected row's order, dimension, and lattice ranks. It
does not read a prior 156-row catalogue or rerun source enumerations.

The saved [raw catalogue](lattice_156_from_sources_raw.mrdi) is the direct
assembly output. The [standard catalogue](lattice_156_from_sources_standard.mrdi)
mechanically fills the common nine-field ambient schema for twelve
rank-zero rows. Its [normalization receipt](lattice_156_from_sources_standard.mrdi.receipt.txt)
checks those rows, retains their legacy data, and reports the other 144
rows unchanged. The [structural receipt](lattice_156_from_sources_structural.txt)
and [machine-readable receipt](lattice_156_from_sources_structural.mrdi)
report 156/156 passing standard rows and an unchanged input.
Absolute machine paths in the saved receipts record the original run;
the builder uses the repository-relative paths in the manifest.

The structural verifier checks primitive embeddings, compatible stable
ambient actions and their restrictions, exact orders, cyclotomic periods,
and dimensions. It does not repeat geometric family identification,
root-freeness, symplectic saturation, or the source enumerations. Follow
the evidence in the manifest and the
[earlier source table](../ambient_completion/sources/family_156_sources_current.md)
for those arguments. The source table is tied to the preceding standard
catalogue and remains a detailed provenance reference.

## Generic algebraic lattices

The [full-cohomology functions](../full_h4_lattice_functions.jl) construct
the odd unimodular rank-23 `H4` from the even rank-22 primitive lattice
`Lambda0`, adjoining a class `h^2` of square three by index-three gluing.
For the period lattice `P` and its primitive orthogonal complement `K`
in `Lambda0`, they compute the very general algebraic lattice
`A_gen = P^perp` in `H4`. Equivalently, `A_gen` is the primitive closure
of `<h^2> + K`; its index over that sum is one or three.

The [enrichment script](add_algebraic_lattices.jl) reads the standard
catalogue and computes this record for each numbered row. It checks
integrality, signatures, primitive complements, gluing indices, and
determinants. The completed [algebraic MRDI](lattice_156_with_algebraic.mrdi)
contains `H4`, `h^2`, `A_gen`, its basis and Gram matrix, and the
corresponding `P` and `K` Gram matrices and discriminant-form symbols
for all 156 families. The run
reloaded that MRDI and compared the saved lattice data for every row.

The [Gram export](lattice_156_gram_matrices.txt) lists `P` and `K` in
family order. Matrices use nested square brackets, with commas between
entries and rows. The `q_P` and `q_K` entries are OSCAR's canonical
Conway--Sloane symbols for the finite discriminant quadratic forms;
scale-zero unimodular blocks are omitted, and `0` means the trivial
form. They precede the Gram matrices, with OSCAR's `{3}^{1}` written
as `3^{+1}`. For 41 split
index-one cases the export states
`A_gen = <3> ⊕ K`; for the other 115 index-three cases it prints the
`A_gen` Gram matrix in its saved integral basis. The standard catalogue
remains the ambient-action input.

## Reproduction

Use a compatible Julia/OSCAR installation; this repository does not supply
a Julia project. From the repository root, substitute its project path and
fresh output names in these commands:

```text
julia --project=YOUR_OSCAR_PROJECT remark/catalogue/assembly/build_156.jl --smoke
julia --project=YOUR_OSCAR_PROJECT remark/catalogue/assembly/build_156.jl RAW.mrdi STANDARD.mrdi
julia --project=YOUR_OSCAR_PROJECT remark/catalogue/ambient_completion/sources/verify_complete_156_ambient.jl STANDARD.mrdi RECEIPT_STEM
julia --project=YOUR_OSCAR_PROJECT remark/catalogue/assembly/add_algebraic_lattices.jl --smoke STANDARD.mrdi
julia --project=YOUR_OSCAR_PROJECT remark/catalogue/assembly/add_algebraic_lattices.jl STANDARD.mrdi ENRICHED.mrdi GRAMS.txt
```

The builder's smoke mode selects all 156 sources without writing a
catalogue. The algebraic smoke mode checks Nos. 2, 96, 105, 127, and 132
without writing output. The writing commands refuse existing output paths.
The saved direct-source standard and enriched MRDIs, receipts, and Gram
export above can be inspected without repeating either computation.
