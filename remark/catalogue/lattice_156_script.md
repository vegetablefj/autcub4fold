# Construction and interpretation

This guide describes the earlier abstract-action catalogue and its
side-by-side build stages. Its intermediate coverage statements are
historical. The selected complete ambient catalogue and current
row-by-row provenance are in
[ambient_completion/README.md](ambient_completion/README.md) and
[ambient_completion/sources/family_156_sources_current.md](ambient_completion/sources/family_156_sources_current.md).
For the current workflow, start with [README.md](README.md).

The builder follows the numbering in `../input/family_numbering.md`.
It reads existing data only; it does not repeat the 29-case lattice search or
any low-rank maximal search. The output is saved with OSCAR's `save`, loaded
again, and checked for 156 numbered slots and the orders of all stored
`T_extra_action` objects.

The dedicated-verifier-passing
`lattice_156_with_generic_actions_v3_20261004.mrdi` side-by-side build has
156 rows with an abstract `T` lattice and 156 with an abstract `T` action.
The last 15 actions follow from the generic full-period argument; Nos. 11
and 20 use the separately checked ternary Gram inputs. See
`generic_index_actions_script.md`. Nos. 84, 85, and 107 retain both complete
No. 60 parent candidates and a numbered coordinate representative. Its
saved class number is not matched to the strict GAP witness; these rows are
not labeled parents for further strict restrictions without an embedding
comparison. No subgroup action has been inferred solely from abstract group
membership. The earlier canonical
`lattice_156.mrdi` is retained unchanged for comparison (83 `T` lattices
and 66 actions).
At that stage, the latest side-by-side build retained the verified Case 23
pairing, the two rank-20 primitive-embedding records, the case-3 pair, and
No. 105, and added the root-checked No. 131 restriction from the saved
No. 24 action, Nos.
86 and 113 from the distinct saved No. 62 action, the subsequent No. 104,
92, 118, 108, and 128 restrictions, and the five same-`S3` actions from
Nos. 94–96; the
earlier canonical and side-by-side MRDI files have not been overwritten.

Each slot contains its table number, `rank_S`, generic index, full index,
dimension, a status, and lattice fields. `S_input` and `T_input` are the
input lattices when known. `T_extra_action` is a `ZZLatWithIsom` for the
chosen extra generator; `T_in_ambient` and `saved_result` preserve the
larger integral-extension data when available. OSCAR omits dictionary keys
whose value is `nothing` on save, so use `get(entry, key, nothing)` for
unfilled fields. An omitted field is not a zero lattice or a trivial action.
Nos. 5–6 store their plain ambient gluing records under `primitive_embedding`
instead of `saved_result`. For No. 105, `T_input` is the lattice on which
`T_extra_action` is written; `T_search_input` preserves the isometric
original search input in a different integral basis. `source` and `note`
give the provenance and any qualification of the row.

## Included sources

- Nos. 1–8: the rank-two `T` Gram matrices of Laza–Zheng, Theorem 1.8.
  The extra-action matrices are explicit rank-two models inferred from the
  theorem's quotient indices; they are checked as integral isometries with
  the stated orders. The `S` Gram matrices come from the first six entries
  of `../../oscar/list_S.txt`. Nos. 5 and 6 remain distinct despite sharing
  the same `S`, `T`, and trivial action: their two ambient primitive
  embeddings are retained under `primitive_embedding`, sourced from
  `m10_gluings.mrdi`. Their numbered equation assignment also uses the
  real-pencil criterion in `family_identification_script.md`; see also `m10_gluings.md`.
- Generic rows supplied by the 29 cases of `../../oscar/input.jl`: their
  `S` and `T` inputs are retained even if the old search has no non-generic
  outputs. Index-one generic rows additionally carry the identity action.
- Non-generic rank-at-least-15 rows: full retained results from
  `../../oscar/oscar_script_data.mrdi`, matched to the 156-number table by
  index, dimension, and the recorded group/family data.
- Nos. 13–14: case-3 saved outputs 1 and 2 are distinguished by the
  negative eigensublattices `⟨−2⟩ ⊕ ⟨−28⟩` and `⟨−4⟩ ⊕ ⟨−14⟩`. The complete
  selected result and both original candidates remain in each row.
  The real-structure criterion in `family_identification_script.md` supplies
  the geometric sign assignment; `verify_l27_split.jl` checks the integral models.
- No. 105: the unique retained result of the separate rank-12 extension
  search is imported from `no105/no105_extensions.mrdi`. The raw search did
  not claim a numbered equation; `no105/verify_no104_no105_character.g`
  separately checks the Fermat-to-listed-coordinate conjugacy and the character
  distinguishing it from No. 104. The original search input and action
  lattice use different bases, as checked in `no105/audit_no105_bases.jl`.
- Nos. 56–57 (`A_{3,3}`): the complete primitive-coset comparison in
  `a33_case23/case23_full_coset_comparison.mrdi` assigns saved Case 23
  output 1 to No. 56 and output 2 to No. 57. The builder checks its source
  record, group metadata, and trace histograms, then retains both original
  candidates alongside each selected complete ambient result.
- Maximal low-rank Nos. 96, 152, 154, 155, and 156: the selected full
  results in `../low_rank/maximal_cases/` are retained. Their saved
  action is the chosen generator class; the Hodge-line orientation need not
  be fixed by that choice.
- Nos. 78, 81, and 82: complete ambient records are obtained by restricting
  the saved actions of classified Nos. 74 and 51 to unique subgroups. Separate
  GAP certificates establish the subgroup identifications. The OSCAR runs
  check the root condition and group ID; no new enumeration of lattice-action
  classes, and no separate comparison of the two stable discriminant-kernel
  orders, is claimed. Their complete `S`, `T`, `P`, `K`, actions, and ambient
  lattice are kept in each row's `saved_result`.
- Nos. 94 and 95: the verified No. 24 integral action was restricted to all
  relevant `S3`-by-`C12` subgroups of abstract type `[72,27]`. Three
  parent-conjugacy classes occur; the exact geometric primitive-cohomology
  characters uniquely assign classes 1 and 2 to Nos. 94 and 95. Both full
  ambient restrictions and their `T` actions are retained. This calculation
  does not independently retest roots or symplectic saturation; see
  `restriction_94_95_from_24_result.md`.
- Nos. 142, 149, and 150: all relevant cyclic restrictions of the saved
  No. 24 group were enumerated. The exact primitive-cohomology characters
  of the source cubics uniquely identify one parent-conjugacy class for each
  row. The complete rank-22 ambient actions, cyclotomic period lattices and
  orthogonal complements are saved; see `restriction_cyclic_from_24_result.md`.
- No. 141: the three No. 24 character-matched classes are not identified by
  that comparison. A separate exhaustive computation within the smaller
  classified No. 95 parent has one matching order-six class; its complete
  ambient restriction is saved in `cyclic_141_from_95.lattices.mrdi`.
- Nos. 134, 136, and 140: exhaustive small-parent cyclic-class searches
  give unique exact geometric-character matches within the chosen No. 18 or
  No. 41 parent. No. 44 gives an independent No. 134 character match. The
  complete selected restrictions are in
  `restriction_rank0_134_136_140_from_parents.mrdi`.
- No. 143: the three No. 41 order-six classes share its character. The
  spectrum and connectedness proof in `cyclic_spectrum_equivalence_note.md`
  identifies their ordinary integral action up to conjugacy; one pure-power
  representative is saved in `restriction_rank0_143_from_41.mrdi`. This does
  not fix an oriented Hodge line or produce a conjugating matrix.
- Nos. 132, 133, 135, 137–139, 144–148, 151, and 153: exact powers of the
  four saved cyclic maximal actions. `cyclic_maximal_power_restrictions.mrdi`
  retains all 25 checked parent paths, with complete ambient `S`, `T`, `P`,
  `K` and action data. For a row with several parents, the catalogue selects
  the smallest parent number for its primary `T_extra_action` and keeps all
  alternatives in `cyclic_power_paths`. The source script checks each exact
  matrix power, period data and character; direct cross-parent integral
  conjugacy is not claimed.
- Nos. 77, 79, 119, 120, 122, and 124: exact subgroups of the saved full
  No. 78 and No. 81 integral actions are compared with the numbered geometric
  groups by abstract type, symplectic intersection, quotient order, primitive
  cohomology character, and period dimension. The complete ambient
  restrictions are then constructed and their root obstructions excluded.
  One parent class remains for each row except No. 124, which retains both
  No. 81 classes 2 and 3 under `small_parent_paths`. Its selected class 2
  supplies a concrete representative. The block-swap argument in
  `restriction_small_from_78_81.md` identifies their ordinary integral
  action, not their labelled matrices. The optional full stable-kernel group
  ID and symplectic-saturation equality are not recomputed.
- Nos. 80 and 121: the cached full No. 51 and No. 74 actions respectively
  supply exact subgroup restrictions. The analogous character, period, group
  and root checks leave No. 51 class 1 for No. 80 and No. 74 classes 3, 5,
  and 6 for No. 121. All four paths are stored under `cached_parent_paths`;
  No. 121 class 3 is the selected representative. The strict source-character
  and smooth-family connectedness argument in
  `restriction_no121_three_parent_classes.md` identifies the three No. 121
  paths as ordinary integral actions. It does not equate their labelled
  matrices or establish a new symplectic-saturation result. See also
  `restriction_pilot_80_121_result.md`.
- Nos. 123 and 126: the saved full No. 95 and No. 50 actions respectively
  contain a unique parent-conjugacy class of C6 subgroups with the exact
  numbered geometric character. No. 50's Q8 symplectic action is transported
  through the common `S` lattice with No. 51, with integrality checked in
  No. 50's own ambient lattice. Both restrictions have rank-8 `S`, rank-14
  `T`, index 3, and verified group and root conditions; their period
  dimensions are 6 and 4. The complete records are saved in
  `restriction_pilot_123_126.verified.mrdi` and copied to the catalogue under
  `cyclic_small_parent_paths`. No independent symplectic-saturation result is
  claimed.
- Nos. 115 and 125: exhaustive subgroup searches inside the saved full
  No. 95 action leave one parent-conjugacy class per exact geometric
  character. No. 115 has `S` rank 12, `T` and `P` rank 10, index 2 and
  period dimension 8. No. 125 has `S` rank 8, `T` rank 14, `P` rank 12,
  index 6 and period dimension 5. Their complete embedded restrictions
  and root checks are in `restriction_115_125_from_95.verified.mrdi` and
  retained under `no95_parent_paths`. The abstract subgroup IDs are
  checked inside the saved parent group; an independent full
  discriminant-kernel group calculation and symplectic-saturation test
  are not claimed. See `restriction_115_125_from_95_script.md`.
- Nos. 117 and 130: the same saved No. 95 action has one parent-conjugacy
  class per exact geometric character. No. 117 has `S` rank 12, `T` and
  `P` rank 10, index 6 and period dimension 4. No. 130 has `S` rank 8,
  `T` rank 14, `P` rank 12, index 12 and period dimension 2. Both complete
  restrictions pass the lattice and root tests, with zero root-obstructed
  classes in `restriction_117_130_from_95.verified.mrdi`. Their paths are
  retained under `no95_parent_paths`. The abstract subgroup IDs are checked
  inside the saved No. 95 group; no independent discriminant-kernel group
  calculation or symplectic-saturation test is claimed. See
  `restriction_117_130_from_95_script.md`.
- No. 111: all eligible `[9,2]` subgroups in the saved No. 18 full action
  are compared with its exact geometric character. One parent-conjugacy
  class, of orbit size four, passes the character, lattice, period, and root
  checks. Its `S`, `T`, `P`, `K` ranks are 12, 10, 8, 14; the quotient index
  is 3 and period dimension is 3. The complete path is retained under
  `no18_parent_paths` from `restriction_111_from_18.verified.mrdi`.
- No. 116: its direct strict containment in No. 94 and exact geometric
  character select one class in the saved 72-element No. 94 action. The
  exhaustive search tries the C3 kernel and every lift over `f²N`; the
  matching class has orbit size one. Its complete restriction passes the
  lattice, index-six, period-dimension-four, and root checks, with ranks
  `(S,T,P,K)=(12,10,10,12)`. The path is retained under
  `no94_parent_paths` from `restriction_116_from_94.verified.mrdi`.
- No. 129: the missing S3 kernel generators of the saved No. 96 action are
  reconstructed on the full ambient lattice. Exhaustive `[16,5]` subgroup
  search and exact character comparison select one parent-conjugacy class,
  of orbit size three. Its complete restriction passes the lattice,
  index-eight, period-dimension-two, and root checks, with ranks
  `(S,T,P,K)=(8,14,12,10)`. The path is retained under
  `no96_parent_paths` from `restriction_129_from_96.verified.mrdi`.
- Nos. 109, 112 and 114: exhaustive subgroup searches inside the saved full
  No. 41 action give one exact-character matching parent-conjugacy class per
  family, each with orbit size seven. All have `S` rank 12 and `T` rank 10.
  Their `P` ranks are respectively 6, 6 and 4; their quotient indices are
  2, 3 and 6; their period dimensions are 4, 2 and 1. The abstract subgroup
  IDs `[6,2]`, `[9,2]` and `[18,5]` were checked inside the parent group.
  Each complete restriction passed its lattice and root checks, leaving one
  root-free path per family and no root-obstructed class in
  `restriction_109_112_114_from_41.verified.mrdi`. The paths are retained
  under `no41_parent_paths`. This gives uniqueness within the saved No. 41
  parent class; no independent symplectic-saturation or wider integral
  uniqueness result is claimed. See
  `restriction_109_112_114_from_41_script.md`.
- Nos. 97–100: every subgroup of the saved full No. 74 group is considered,
  including the three-generated `C2^3` cases. Exact geometric characters,
  index, period dimension, group ID, and roots give one matching parent class
  each for Nos. 98–100 and two for No. 97. Their rank-12 `S` and rank-10 `T`
  data, complete ambient actions, and both No. 97 paths are retained in
  `restriction_97_100_from_74.verified.mrdi` and under `v4_parent_paths`.
  No. 97 class 1 is a stored representative. The explicit linear-conjugacy
  and smooth-family connectedness argument in
  `restriction_no97_two_classes.md` identifies its two paths as ordinary
  integral actions; it does not equate their labelled matrices or compute
  symplectic saturation. See `restriction_97_100_from_74_result.md`.
- No. 127: the verified full-lattice witness is read from
  `family_127_g13_full_finite_glue_preflight.json`, and its order-four action
  is restricted to the invariant `T` lattice of the symplectic involution.
  This is a constructed witness, not an exhaustive search result.
- No. 131: the exact geometric character selects class 3 among three
  `[24,9]` subgroup classes of the saved No. 24 action. Its embedded
  `(S,T,P,K)` ranks are `(8,14,8,14)`, index 12, and period dimension 1.
  The root-free restriction is retained under `no24_parent_paths` from
  `restriction_131_from_24.verified.mrdi`. This is unique inside the saved
  parent; global integral uniqueness and independent symplectic saturation
  are not claimed.
- Nos. 86 and 113: the full projective primitive-`H4` characters and
  strict linear-containment witnesses are checked in GAP. Within the
  independently reconstructed No. 62 full action, each has one matching
  parent-conjugacy class, which passes the embedded-lattice and root checks.
  Their `(S,T,P,K)` ranks are `(14,8,8,14)` and `(12,10,6,16)`; their
  quotient indices are 3 and 6 and their period dimensions are 3 and 2.
  The complete results are retained under `no62_parent_paths` from
  `restriction_86_113_from_62.verified.mrdi`. This is uniqueness inside
  the saved parent, not an independent global integral-uniqueness or
  symplectic-saturation calculation.
- No. 104: one exact-character, embedded-lattice-compatible, root-free
  class in the independently prepared No. 28 action. Nos. 92 and 118:
  one such class each in the independently prepared No. 36 action.
  These parent-specific results are imported with staged source checks;
  see `restriction_104_from_28_script.md` and
  `restriction_92_118_from_36_script.md`.
- Nos. 108 and 128: same-symplectic-part quotient-preimage restrictions
  from saved Nos. 113 and 131. Strict geometric inclusions, exact
  characters, full embedded lattice data, and roots were checked. See
  `restriction_same_part_108_128_script.md`; these parent-specific
  calculations do not independently reprove symplectic saturation.
- Nos. 88–91 and 93: full same-`S3` quotient-preimage restrictions from
  saved Nos. 94, 95, and 96. The five primary paths and the No. 95
  cross-check paths for Nos. 88 and 89 pass strict inclusion, exact
  character, embedded-lattice, and root checks. In the common ambient
  basis, both dual-parent pairs have literally equal full subgroups and
  embedded actions. The catalogue retains the No. 94 path for Nos. 88
  and 89 as primary and the No. 95 path in
  `same_part_parent_cross_check`; see
  `lattice_156_with_samepart_s3_script.md`. No separate global integral
  uniqueness or symplectic-saturation calculation is claimed.

For Nos. 111, 116, and 129, uniqueness is within their specified saved parent
actions. The child discriminant-kernel group and symplectic saturation were
not independently recomputed, and wider integral uniqueness is not claimed.

Nos. 101 and 110 each have one root-free exact-character class inside the
saved No. 67 action. Their complete ambient restrictions are stored in
`restriction_101_102_from_67.verified.mrdi` and
`restriction_110_from_67.verified.mrdi`, and imported with source
and matrix checks. No. 102 has two root-free No. 67 classes with different
displayed `T` actions. Independently, Nos. 102 and 103 each have one
root-free exact-character class inside the saved No. 69 action. The strict
linear inclusions give geometric specializations of the numbered families;
the smooth members of each fixed invariant linear system form a connected
open set, so the resulting integral action is constant along that family.
The No. 69 actions are recorded in their numbered rows with complete ambient
data. Both No. 67 paths for No. 102 remain separately saved. No integral
equivalence between either of those paths and the No. 69 action has been
proved; OSCAR's same-type test alone does not establish it.

Nos. 83 and 87 each have one compatible parent-conjugacy class in the saved
No. 18 action, and No. 106 has one in the saved No. 67 action. Their strict
linear containment certificates and exact `(order, trace)` histograms are
checked separately. Each complete integral restriction passes the rank,
period, and root checks; the full records are in
`restriction_83_from_18.verified.mrdi`,
`restriction_87_from_18.verified.mrdi`, and
`restriction_106_from_67.verified.mrdi`. The catalogue imports all three
with source and matrix comparisons. These are exhaustive subgroup
computations inside the specified saved parent actions, not independent
global integral-uniqueness or symplectic-saturation computations.

## Assignments left open

- In the newer, independently verified
  `lattice_156_with_generic_actions_v3_20261004.mrdi`, every row has an
  abstract `T` lattice and `T_extra_action`. The 15 generic rows added there
  use the full-period scalar-action criterion, not a new isometry
  enumeration; see `generic_index_actions_script.md`. This does not supply
  a complete ambient action for those rows.
- Nos. 35 and 37 still have separate, unassigned primitive embeddings and
  component matching. Their common abstract `T` and forced `-Id` action
  do not identify the two embedded lattice data.
- The original `lattice_156.mrdi` and several intermediate sidecars retain
  `pending_lattice_data` for Nos. 11 and 20. Those abstract `S/T` inputs
  are supplied only in the newer generic-action sidecar.
- The several No. 24 classes with the No. 141 character remain distinct
  within that parent comparison; the No. 141 row uses the independent No. 95
  assignment. Character equality is not being treated as integral
  equivalence.

The two saved results for No. 18 (`M_9`) are retained together because the
existing auxiliary equivalence check puts them in one lattice-theoretic
class. The order-three output of original case 16 with GAP ID `(63,3)`
is not a row of the final table; it is stored separately under
`unassigned_search_outputs` rather than forced into a family slot.

The earlier `build_lattice_156.jl` used the full development tree and is not
part of this curated repository. Its intermediate builds, including
`lattice_156_with_105_pairs_20261002.mrdi`, are historical records rather
than instructions for rebuilding the current standard catalogue. This
repository supports a fresh structural audit of the selected 156-row MRDI with
`ambient_completion/sources/verify_complete_156_ambient.jl`. It also
supports repeating the final standard-field normalization from the saved
`ambient_completion/lattice_156_complete_ambient_20261004.mrdi` with
`ambient_completion/sources/normalize_rank0_ambient_fields.jl`, using a
new output path. The earlier complete-ambient assembly is not claimed to
be reproducible from this selected subset; see
[ambient_completion/README.md](ambient_completion/README.md) for the exact
scope of the saved receipts.
