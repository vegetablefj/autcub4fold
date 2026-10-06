# Numbered lattice catalogue

This module assembles saved integral lattice actions in the numbering of the
[156-family fourfold table](../input/family_numbering.md). The
[direct-source manifest](assembly/manifest.jl) selects one record per family
from the original [OSCAR search](../../oscar/README.md),
[low-rank maximal records](../low_rank/README.md), and verified
ambient restrictions and extensions. Reading the selected data does not
require repeating those searches.

## Current records

| File | Purpose |
| --- | --- |
| [Direct-source standard MRDI](assembly/lattice_156_from_sources_standard.mrdi) | Current 156-row catalogue, with a compatible ambient extra action in every numbered row. |
| [Direct-source raw MRDI](assembly/lattice_156_from_sources_raw.mrdi) | Assembly output before mechanical normalization of twelve rank-zero records. |
| [Assembly guide](assembly/README.md) and [manifest](assembly/manifest.jl) | Reproduction commands and the selected saved source for each numbered row. |
| [Structural receipt](assembly/lattice_156_from_sources_structural.txt) and [MRDI receipt](assembly/lattice_156_from_sources_structural.mrdi) | Structural audit of the direct-source standard MRDI: 156/156 rows passed, input unchanged. |
| [Normalization receipt](assembly/lattice_156_from_sources_standard.mrdi.receipt.txt) | Checks twelve filled rank-zero records and 144 unchanged rows. |
| [Algebraic MRDI](assembly/lattice_156_with_algebraic.mrdi) and [Gram export](assembly/lattice_156_gram_matrices.txt) | Completed very general algebraic lattices, Gram matrices, and `q_P`, `q_K` symbols for all 156 families. |
| [Earlier ambient catalogue](ambient_completion/README.md) and [its source table](ambient_completion/sources/family_156_sources_current.md) | Preserved assembly checkpoint and detailed row-by-row provenance for that stage. |
| [Six maximal records](maximal_six_standard.mrdi) | Normalized low-rank source actions for Nos. 96, 127, 152, 154, 155, and 156. |

The standard ambient record contains `order`, `dimension`, embedded
`S_in_Lambda0`, `T_in_Lambda0`, `P_in_Lambda0`, `K_in_Lambda0`, their
`T_action` and `P_action`, and `Lambda0`. The quotient order need not equal
the order of the selected ambient lift. Source records and alternative
candidates are retained rather than silently replaced.

A saved ambient extension specifies the distinguished extra generator and
its compatible primitive embedding. It does not assert that rank-22
matrices for every symplectic group generator are stored. To restrict by a
power, power the ambient action and then restrict both lattice actions;
an abstract `T` matrix alone does not determine the compatible `S` action
or gluing.

## Scripts and verification scope

| Script or guide | Purpose |
| --- | --- |
| [Structural verifier](ambient_completion/sources/verify_complete_156_ambient.jl) | Reloads an explicitly selected catalogue and checks embeddings, actual action restrictions, stability, exact orders, cyclotomic periods, and dimensions. |
| [Direct-source builder](assembly/build_156.jl) | Reads the manifest and individually saved source records, then writes raw and standardized catalogues without rerunning enumerations. |
| [Final normalization](ambient_completion/sources/normalize_rank0_ambient_fields.jl) | Fills rank-zero aliases using the same saved actions and checks integral basis transports; invoked by the direct-source builder. |
| [Algebraic-lattice enrichment](assembly/add_algebraic_lattices.jl) and [full-cohomology functions](full_h4_lattice_functions.jl) | Compute the very general algebraic lattice from each saved embedded `P` and `K`, and export compact Gram data. |
| [Source-table generator](ambient_completion/sources/generate_family_sources.jl) | Generates a provenance table for an explicitly selected catalogue; its default input is historical. |
| [Six-case builder](build_maximal_six_standard.jl) | Normalizes existing maximal outputs and the constructive No. 127 witness; performs no new action enumeration. |
| [Family-identification notes](family_identification_script.md) | Separate numbered assignments and their evidence. |
| [No. 60 geometric certificate](no60_geometric_normalizer_certificate.md) | Exact normalizer check for the paired restrictions to Nos. 84, 85, and 107. |
| [Earlier construction guide](lattice_156_script.md) | Historical abstract-action catalogue and source-stage assembly notes. |

The direct-source structural receipt does not repeat root tests, symplectic
saturation, orthogonal-group enumeration, or geometric family identification.
Those claims must be read with the source-specific certificates and
qualifications in the saved sources and earlier source table. In particular,
No. 127 remains a theorem-identified constructive witness, not an exhaustive
integral-action search or a direct full-cohomology conjugacy certificate to
its displayed equation.

The `source_*_full_lattice_group.mrdi` caches and the matching
`*.groups.mrdi` and `*.lattices.mrdi` files belong to the staged restriction
calculations. They are retained so that later stages can be checked without
repeating their earlier, sometimes expensive, group calculations; they are
not additional numbered catalogue rows.

The completed algebraic workflow constructs the odd unimodular full `H4`,
with `h^2` of square three, and `A_gen = P^perp` in `H4` for all 156 rows.
The enriched MRDI passed a semantic reload check; the text export uses
`A_gen = <3> ⊕ K` for index-one split cases and prints an `A_gen` Gram
matrix for index-three cases. Earlier `with_*` catalogues and the preceding
complete-ambient file are preserved assembly checkpoints. Their coverage
counts and older status notes are historical. MRDI is OSCAR's
native serialization format; omitted dictionary keys with value `nothing`
should be read with `get(row, key, nothing)`, not interpreted as zero lattices.

Use a compatible existing Julia/OSCAR environment and inspect each script's
header before running it. This directory supplies no Julia project; do not
assume `--project=.` selects the recorded installation. The
[assembly guide](assembly/README.md) gives the direct-source and algebraic
commands. Scripts that write output refuse existing paths.
