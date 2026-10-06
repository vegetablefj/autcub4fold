# Rank-20 and rank-19 ambient-action completion

This selected repository retains the completed sidecars and seven independent
verification receipts, but not the full development-stage source tree needed
to rerun every construction below. The current 156-row file and its runnable
structural check are described in the [ambient guide](../README.md).
Files and commands in the historical audit below are retained as provenance;
some named stage inputs and scripts are not supplied here.

## Current completion

The four rank-19 generic-index-two targets, Nos. 9, 11, 16, and 19, have
independently verified complete ambient records. Nos. 10, 12, 15, and 20
are assigned using classified primitive-embedding equivalence, not raw candidate
counts. Nos. 13/14 are assigned by the real-structure criterion and their integral
negative eigenlattices; both original candidates remain saved. Nos. 2, 5,
6, and 127 have been normalized to the standard nine-field record format.
These stages gave the 149-record checkpoint
`../lattice_156_normalized_existing_20261004.mrdi`.

The remaining Nos. 1, 3, 4, 7, 8, 34, and 42 now each have one saved
construction and a matching independent `.verified.txt` receipt. The
seven-row import and independent reload have passed, giving all 156
ambient actions in `../lattice_156_complete_ambient_20261004.mrdi`.
The final `../lattice_156_standard_ambient_20261004.mrdi` mechanically
normalizes 12 legacy rank-zero records into the nine-field scheme, retains
their old data, and preserves the other 144 rows.
The separate `../sources/complete_156_ambient_structural_v3_20261004.txt`
and `.mrdi` receipts record 156/156 passing structural checks. These do
not repeat roots, saturation, or family identification.
See `remaining_classified_ambient_script.md` for the fixed actions,
kernel orders, verification scope, and batch optimization.

For No. 127, the stable root-free action and generic-period criterion identify
the constructed action with its numbered family. Its source remains nonexhaustive; this is not an
unresolved family label or a claim of exhaustive integral enumeration.
Full rank-22 matrices for every symplectic generator are not asserted by
the standard extra-generator record format.

## Historical finite gluing audit

The following audit records the earlier inputs, missing fields, and
planning stages. Its statements that ambient records or sign assignments
were not yet recorded are historical, superseded by the current completion
above. The raw sidecars and old combined catalogues are retained.

This audit uses the numbered order in
`../../../input/family_numbering.md`. The original independently
verified rank-19 index-one side-by-side catalogue is
`lattice_156_with_rank20_19_indexone_v2_20261004.mrdi`.
The later independently verified catalogue
`lattice_156_with_no2_unique_embedding_20261004.mrdi`
also records No. 2's unique primitive gluing orbit and leaves the
No. 13/14 equation-sign pairing unassigned. The current
`../sources/family_156_sources_current.md` now describes the standard
catalogue at the top of this document. The historical rank-18–15 baseline was
`../rank18_16/lattice_156_with_rank18_15_ambient_20261004.mrdi`.
An abstract action on `T` is not an action on the primitive cubic lattice
`Lambda0`: its action on `S` and the discriminant gluing must also be fixed.
Here a "complete ambient action" refers to the compatible lift of the
*extra/non-symplectic generator* recorded by the catalogue, including the
index-one identity case.  It does not, by itself, store a rank-22 integer
matrix for every generator of the symplectic subgroup.

The exact finite-discriminant calculation is implemented by
`complete_index_one.jl`.  It writes new sidecars only in this directory.  Its
`parents` stage reads the original saved search output and creates the
identity ambient action in each of the two saved case-3 candidate records
for No. 12, and the selected No. 18 embedding for No. 17.  The direct strict
containments `12 -> 13`, `12 -> 14`, and `17 -> 18` are recorded in
`../../../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_all_pairs.tsv`.
No. 12 has the same symplectic group as both possible parents, and No. 17
has the same symplectic group as No. 18; each child has index one.  Thus the
full child group is the corresponding parent's symplectic kernel.  The
extra generator acts as the identity on the entire ambient lattice, hence on
both `S` and `T`; `P=T` and `K=S` are embedded in the parent's `Lambda0`.
This constructs a compatible extra action and primitive embedding, while
the nontrivial symplectic generators remain referenced through the parent
record rather than recopied into this sidecar.  The pinned v3 catalogue
retains the two case-3 candidates without a verified numbered sign pairing;
this computation does not pair either saved result to No. 13 or No. 14.

The `gluings` stage constructs primitive embeddings for index-one Nos. 10,
15, and 20 using every index-three subgroup `H_T` of `A_T` for which
`A_S` and `H_T` are anti-isometric.  It checks the resulting rank-22 even
lattice has signature `(20,2)`, determinant `3`, discriminant form `q_A2`,
and primitive orthogonal copies of the stated `S` and `T`.  The ambient
extra action is exactly the identity, so its restrictions to `S`, `T`,
`P=T`, and `K=S` are compatible by construction.  The short and long root
obstruction is checked in `K`.  Several raw finite-module candidates can
represent the same integral embedding; no component label is attached solely
from their count.

| No. | Symplectic family | Source of `S,T` | Source of current `T` extra action | Full ambient/embedding status |
| ---: | --- | --- | --- | --- |
| 1 | `3^4:A6` | `oscar/list_S.txt` #1; Laza–Zheng Thm. 1.8 | rank-two order-six model in `build_lattice_156.jl` | Ambient extension and embedding not recorded. |
| 2 | `A7` | `list_S.txt` #2; Laza–Zheng Thm. 1.8 | identity | Eight raw root-free gluings form one integral orbit; its unique primitive embedding and compatible identity extra action are now saved. Full symplectic matrices are not saved. |
| 3 | `A7` | `list_S.txt` #2; Laza–Zheng Thm. 1.8 | rank-two `-I` model | Ambient extension and embedding not recorded. |
| 4 | `3^{1+4}:2.2^2` | `list_S.txt` #3; Laza–Zheng Thm. 1.8 | rank-two order-four model | Ambient extension and embedding not recorded. |
| 5 | `M10` | `list_S.txt` #4; Laza–Zheng Thm. 1.8 | identity | Distinct primitive gluing already in `m10_gluings.mrdi`, residual line `<e1/3>`; no symplectic matrices recopied. |
| 6 | `M10` | Same as No. 5 | identity | Distinct primitive gluing already in `m10_gluings.mrdi`, residual line `<e2/3>`. |
| 7 | `L2(11)` | `list_S.txt` #5; Laza–Zheng Thm. 1.8 | rank-two order-three model | Ambient extension and embedding not recorded. |
| 8 | `A3,5` | `list_S.txt` #6; Laza–Zheng Thm. 1.8 | rank-two order-six model | Ambient extension and embedding not recorded. |
| 9 | `3^{1+4}:2.2` | `oscar/input.jl` case 1 | generic index-two, `-I_T` from full-period lemma | Ambient extension and embedding not recorded. |
| 10 | `A6` | `oscar/input.jl` case 2 | identity | Three complete, unassigned raw primitive-gluing candidates saved and independently verified; do not assign a numbered embedding from count alone. |
| 11 | `A6` | `list_S.txt` #8; supplied ternary `T` in `verify_rank19_easy_sources.jl` | generic index-two, `-I_T` | Ambient extension and embedding not recorded. |
| 12 | `PSL(2,7)` | `oscar/input.jl` case 3 | identity | Both complete case-3 parent restrictions saved and independently verified; no case-3 result is paired to a numbered parent sign. |
| 13 | `PSL(2,7)` | `oscar/input.jl` case 3 | two saved case-3 outputs, row-wise action unassigned | Both complete saved candidates are retained; the newer corrected catalogue does not claim an equation-sign pairing. |
| 14 | `PSL(2,7)` | `oscar/input.jl` case 3 | two saved case-3 outputs, row-wise action unassigned | Both complete saved candidates are retained; the two negative eigenlattices distinguish integral action types without assigning numbered signs. |
| 15 | `S5` | `oscar/input.jl` case 4 | identity | One complete, unassigned raw primitive-gluing candidate saved and independently verified; one raw candidate does not prove uniqueness over all anti-isometries. |
| 16 | `S5` | `oscar/input.jl` case 5 | generic index-two, `-I_T` | Ambient extension and embedding not recorded. |
| 17 | `M9` | `oscar/input.jl` case 6 | identity | Complete index-one restriction from saved No. 18 saved and independently verified; direct strict inclusion checked in GAP table. |
| 18 | `M9` | `oscar/input.jl` case 6 | `oscar_script_data.mrdi` case 6/result 1 | Full saved ambient action and embedding; both original auxiliary candidates retained in numbered row. |
| 19 | `N72` | `oscar/input.jl` case 7 | generic index-two, `-I_T` | Ambient extension and embedding not recorded. |
| 20 | `T48` | `list_S.txt` #13; supplied ternary `T` in `verify_rank19_easy_sources.jl` | identity | Two complete, unassigned raw primitive-gluing candidates saved and independently verified; do not assign a numbered embedding from count alone. |

The independently reloaded and verified gluing sidecar is
`index_one_gluings_20261004.mrdi`:
No. 10 has three, No. 15 has one, and No. 20 has two raw candidates.  The
verified parent-restriction sidecar is
`index_one_parent_restrictions_20261004.mrdi`:
it has two unassigned No. 12 paths and one No. 17 path.  The procedure deliberately
does not infer an ambient extension of the index-two `-I_T` actions: for
Nos. 9, 11, 16, and 19, the compatible action on `S` is additional data.

The v2 catalogue imports only Nos. 10, 12, 15, 17 and 20 and independently
verifies that all other 151 numbered rows are unchanged.  No. 17 has an
assigned `saved_result` inherited through the strict same-part No. 18
containment.  Nos. 10, 12, 15 and 20 instead have
`candidate_ambient_embeddings` tuples of lengths `3, 2, 1, 2`, respectively;
they retain no assigned `saved_result` or `T_in_ambient`.  In particular,
the single raw No. 15 gluing does not establish uniqueness across all
anti-isometries, and the two No. 12 paths remain unpaired with the numbered
No. 13/14 equation signs.

For comparison, the necessary primitive gluing indices for the eight
rank-20 rows, obtained exactly from
`[Lambda0:S+T]^2 = |det S| |det T| / 3`, are respectively
`27, 105, 35, 36, 120, 120, 121, 75`.
This determinant check does not select a gluing or lift the nontrivial
rank-two actions to `Lambda0`.

The static source audit confirms that `build_lattice_156.jl` loads only the
six rank-20 `S` Gram matrices from `oscar/list_S.txt` and the abstract rank-2
`T` models for Nos. 1--4 and 7--8.  Its only imported rank-20 primitive
embeddings are the separate M10 Nos. 5/6 records in `m10_gluings.mrdi`.
The matrices in `remark/input/family_generators.g` act on cubic variables,
not integrally on rank-22 primitive cohomology; the Fermat-plane approach
for No. 1 is proposed but not implemented in `no105/process.md`.
Thus there is no saved complete rank-20 parent action to restrict to
Nos. 9, 11, 16 or 19.

The remaining rank-20 computations are to enumerate anti-isometric discriminant
gluings for the five rows at indices `27, 35, 36, 121, 75`,
verify the resulting primitive `S,T` in an even signature `(20,2)` lattice
of determinant three with the cubic discriminant form and no root
obstruction, and retain all unpaired embeddings. For Nos. 1, 3, 4, 7 and 8 one must
add an `S` isometry that pairs with the recorded `T` generator, stabilizes
the gluing, and induces the identity on the residual order-three
discriminant, before extending it to a 22-dimensional integral matrix.
Geometric character and component checks are still needed to label the
numbered family.  A representation of the *entire* automorphism group
further requires integral matrices for its symplectic generators and a
check of their relations; the extra-generator lift alone does not supply
those matrices.

For No. 2, `enumerate_no2_index_one_gluings.jl` and its companion
`no2_index_one_gluings_README.md` now document a completed exhaustive
finite-map calculation, primitive/root checks, and integral double-coset
audit. The 8 raw gluings form exactly one root-free integral orbit. Its
primitive `S/T` embedding and compatible identity extra action are
imported by `merge_no2_unique_embedding.jl` and independently checked by
`verify_no2_unique_embedding_catalogue.jl`.

The strict linear-containment table does supply geometric routes from the
four rank-19 generic index-two groups to rank-20 groups:

| Child | Checked containing rank-20 families | Why this is not yet an ambient restriction |
| ---: | --- | --- |
| 9 | 1, 4 | Neither containing row has a saved full `Lambda0` group action. |
| 11 | 1, 3 | Neither containing row has a saved full `Lambda0` group action. |
| 16 | 3, 8 | Neither containing row has a saved full `Lambda0` group action. |
| 19 | 1 | The containing row has no saved full `Lambda0` group action. |

Each edge is marked `embedded` in the checked GAP table.  An abstract
`-I_T` does not determine an integral involution on `S`: the latter must
stabilize the gluing subgroup and act trivially on the residual
`A_{Lambda0}` of order three.  Thus even these strict geometric edges
cannot yet be used to take powers of a known ambient matrix.

For Nos. 9, 16 and 19, the original `oscar/input.jl` provides their
rank-19 `S,T` Gram matrices (cases 1, 5 and 7), but the corresponding
`oscar/oscar_result.md` entries report `Any[]` only for the *tested order-six*
extension.  They do not supply the generic order-two ambient involution.
No. 11 was omitted from the 29 search inputs as a separate bound-two case;
its `S,T` forms come from `list_S.txt` #8 and
`verify_rank19_easy_sources.jl`.  The generic full-period argument supplies
only `-I_T` (`generic_index_actions_functions.jl`), not an embedded `S`
involution.  Hence no existing result in these four paths is a full parent
ambient action that can simply be restricted.

A direct next computation is to run the existing
`lattice_data_for_T_action(S, Tf, 2)` path in `oscar/oscar_script.jl` with
`Tf=-I_T` for each of the four rows, bounded one row at a time.  It computes
equivariant primitive extensions of index `54, 60, 100, 108` respectively,
filters the short/long roots and symplectic saturation, then refines the
surviving fitting involution to a stable action on the *same* `Lambda0`.
The output must be checked against the numbered group and geometric
embedding; the search retains one fitting `S` isometry per extension class,
so a raw output count alone is not a uniqueness or component-assignment
proof.  An alternative parent route requires first constructing and
certifying complete actions for the containing rank-20 rows listed above.
