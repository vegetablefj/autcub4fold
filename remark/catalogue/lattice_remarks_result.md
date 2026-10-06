# Numbered integral-action result

The current [direct-source standard catalogue](assembly/lattice_156_from_sources_standard.mrdi)
has one selected compatible embedded representative for each of the 156
numbered cubic-fourfold families.
The [source manifest](assembly/manifest.jl) names the saved record and selector
for every row. The [earlier row-by-row source table](ambient_completion/sources/family_156_sources_current.md)
retains geometric citations and qualifications for the preceding standard
catalogue. The [direct-source structural receipt](assembly/lattice_156_from_sources_structural.txt)
reports `PASS: 156/156 rows structurally checked` and `input unchanged=true`.
The [normalization receipt](assembly/lattice_156_from_sources_standard.mrdi.receipt.txt)
reports twelve standardized rank-zero rows and 144 unchanged rows.

| Construction category in the earlier source breakdown | Families |
| --- | ---: |
| Retained outputs of the earlier lattice search | 36 |
| Supplementary classified-pair and No. 105 records | 18 |
| Restrictions keeping the symplectic subgroup | 43 |
| Restrictions changing the symplectic subgroup | 53 |
| Six remaining action-maximal records | 6 |
| Total | 156 |

These mutually exclusive counts come from the earlier source breakdown of
the numbered representatives; they are not counts of separate geometric
proofs or script folders. The direct-source manifest fixes the exact
record now selected for each row. In particular, Nos. 77 and
79 keep the symplectic subgroup although their records come from a
general subgroup-search script. The earlier search had 38 raw records
but contributes 36 retained numbered rows after its equivalence and
saturation analysis. For the proof logic and exact scripts, see
[lattice_remarks_script.md](lattice_remarks_script.md).

The family identifications that require a separate comparison are:

| Rows | Distinguishing certificate |
| --- | --- |
| Nos. 5 and 6 | Two `M10` primitive embeddings, distinguished by the residual order-three gluing and the divisibility of a norm `-12` vector; the geometric comparison supplies the equation pairing. |
| Nos. 13 and 14 | Two complete `L2(7):2` outputs with different negative eigensublattices; the real-structure comparison pairs them with the two equation signs. |
| Nos. 35 and 37 | Separate index-two restrictions of the identified Nos. 36 and 38, obtained by cubing the appropriate ambient extra isometry. |
| Nos. 56 and 57 | Distinct trace-pair distributions on the complete 18-element primitive Hodge-character cosets. |
| No. 105 | One retained compatible primitive extension; a separate exact conjugacy between the Fermat and displayed coordinates, together with the character comparison, distinguishes it from No. 104. |

The six low-rank action-maximal rows are Nos. 96, 127, 152, 154, 155,
and 156. Nos. 96, 152, 154, 155, and 156 come from exact-character
isometry searches. No. 127 comes from an explicit equivariant gluing
construction and its period and generic-group checks; its rank-fourteen
isometry search was not exhaustively completed and is not used as its proof.

The direct-source 156-row receipt checks primitive ambient `S,T,P,K`, a
compatible stable extra isometry and its restrictions, the cyclotomic period
lattice, and the dimension formula. Geometric numbering, roots, and symplectic saturation
are supported by the corresponding source-specific arguments and records.
The data file stores the selected extra action; it is not a list of all
symplectic group generator matrices.

The [algebraic-lattice workflow](assembly/README.md) uses the embedded
period lattice `P` and its complement `K` to reconstruct full odd `H4` and
compute `A_gen = P^perp` there. Its completed
[enriched MRDI](assembly/lattice_156_with_algebraic.mrdi) contains all 156
algebraic records and passed a semantic reload check. The
[Gram export](assembly/lattice_156_gram_matrices.txt) lists the Gram matrices
and Conway--Sloane symbols of `q_P` and `q_K` for each row; it writes
`A_gen = <3> ⊕ K` for the 41 split index-one cases
and an `A_gen` Gram matrix for the 115 index-three cases.

A read-only packaging audit on 2026-10-04 reconfirmed the earlier catalogue
file, exactly one source-table row for every number from 1 to 156,
and the local links in the proof and result guides. This did not rerun the
isometry or extension enumerations; their exact saved outputs and separate
certificates remain the computational evidence.
The small exact-integer `L_2(7):2` real-structure check was rerun and
reported `PASS` for the norm-`-2` branch only.
