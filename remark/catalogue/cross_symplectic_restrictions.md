# Restrictions with a smaller symplectic part

This note is a reading guide for the subgroup calculations in this directory.
The numbered source table is
[`ambient_completion/sources/family_156_sources_current.md`](ambient_completion/sources/family_156_sources_current.md),
generated from `ambient_completion/lattice_156_standard_ambient_20261004.mrdi`.
The source table records where a numbered action came from; the staged
calculations below supply its mathematical checks. For restrictions that keep
the *same* symplectic part, use
[`ambient_completion/rank18_16/README.md`](ambient_completion/rank18_16/README.md)
and the `restriction_same_part_*` notes instead.

## Why a power of the parent generator is insufficient

Let the identified full parent action on the primitive cubic lattice
\(\Lambda _0\) be \(G=\langle N,f\rangle\), where \(N\) is its symplectic
subgroup and \(G/N\simeq C_m\). A geometric child gives a subgroup
\(H\leq G\), with symplectic part \(A=H\cap N\) and image of order \(i\)
in \(C_m\). When \(A=N\), the quotient has a unique order-\(i\) subgroup,
so the inverse image is obtained by powering \(f\) on the *same* ambient
lattice. When \(A<N\), there can be several embeddings of \(A\) in \(N\)
and several compatible lifts of the quotient generator. Even an abstract
group ID and an action on an abstract invariant lattice \(T\) do not select
the embedded child action.

The cross-part calculations therefore follow this chain:

1. The frozen GAP tables give a direct strict \(GL_6\) containment of the
   numbered geometric child in the chosen geometric parent. A companion
   GAP script computes the child's complete projective
   `(element order, primitive-H4 trace)` histogram, usually checking the
   defining invariant cubics as well.
2. The OSCAR parent cache extends the parent symplectic generators and its
   quotient generator to one compatible rank-22 action on \(\Lambda _0\).
   The finite stage enumerates **all eligible** \(A\leq N\) and compatible
   lifts, checks closure, intersection with \(N\), quotient image and group
   ID, and partitions the resulting subgroups by conjugacy in the *full*
   parent group. The particular exhaustive enumeration depends on the group:
   for example the No. 33 run uses every nonzero \(N_{72}\to C_2\)
   homomorphism; the No. 47 run tests every two-generated \(S_4\) subgroup
   and every lift; the Nos. 97–100 run examines all 35 subgroups of No. 74.
3. Each parent-conjugacy class is compared with the **whole** geometric
   histogram, as well as the numbered quotient index and period dimension.
   The lattice stage computes the new invariant \(T=\Lambda _0^A\), its
   orthogonal coinvariant \(S\), the induced quotient action, and the
   embedded period/complement lattices \(P,K\). It checks the relevant
   abstract lattice data and discriminant compatibility. The verification
   stage reconstructs the retained actions and, where indicated in the
   case note, excludes short and long roots in \(K\).
4. A *numbered* assignment also uses the identification of the saved parent
   with the geometric parent. For a fixed strict child representation, the
   smooth invariant cubics form a connected nonempty open set, so
   equivariant parallel transport gives one ordinary integral action along
   that family. A character match by itself does not identify unrelated
   integral parent actions or produce a literal equality of saved matrices.

Most staged scripts check source inputs, refuse to overwrite outputs, and
save/reload their `groups`, `lattices`, and `verified` records. The earlier
No. 78/81/82 and No. 94/95 jobs use different sidecar names. Their exhaustive
claim concerns subgroups of the **specified saved parent action**. A root
check and an extracted subgroup ID do not independently recompute the
child's full discriminant kernel or symplectic saturation. The individual
case notes state when such checks were omitted; the early Nos. 94/95
calculation, for example, did not rerun its root test.

## Where to inspect the evidence

| Child and saved parent | Finite and lattice calculation | Result and qualification |
| --- | --- | --- |
| 33 ← 18; 47 ← 28 | [`ambient_completion/rank18_16/README.md`](ambient_completion/rank18_16/README.md), `crosspart_33_47_pilot.jl`, `certify_crosspart_33_47.jl` in that directory | Each has three eligible raw subgroups but one full-parent conjugacy class; exact integral \(S/T\) isometry and the root check pass. The numbered certificate is `crosspart_33_47_numbered_restrictions.mrdi`, imported and independently checked in `ambient_completion/lattice_156_with_crosspart_20261004.mrdi`. |
| 78 ← 74; 81, 82 ← 51 | [`restriction_unique_78_from_74.md`](restriction_unique_78_from_74.md), [`restriction_unique_81_from_51.md`](restriction_unique_81_from_51.md), [`restriction_pilot_82_from_51.md`](restriction_pilot_82_from_51.md) | Each relevant abstract subgroup is unique in its saved parent. The completed `restriction_complete_*` records include the embedded action and passed their root and group-ID checks. |
| 94, 95 ← 24 | [`restriction_94_95_from_24_result.md`](restriction_94_95_from_24_result.md) | Three parent classes of type `[72,27]`; the full characters distinguish No. 94 class 1 and No. 95 class 2. The third is excluded. This early calculation did not independently rerun roots or saturation. |
| 77, 79, 119, 120, 122, 124 ← 78/81 | [`restriction_small_from_78_81.md`](restriction_small_from_78_81.md), `restriction_small_78_81.verified.mrdi` | One matching root-free class per row except No. 124, which retains two. |
| 80, 121 ← 51/74 | [`restriction_pilot_80_121_result.md`](restriction_pilot_80_121_result.md), `restriction_pilot_80_121.verified.mrdi` | No. 80 has one matching class; No. 121 has three root-free classes. |
| 84, 85, 107 ← 60 | [`restriction_84_85_from_60_script.md`](restriction_84_85_from_60_script.md), [`restriction_107_from_60_script.md`](restriction_107_from_60_script.md) | Two complete root-free parent classes survive **for each** numbered row. |
| 97–100 ← 74 | [`restriction_97_100_from_74_result.md`](restriction_97_100_from_74_result.md), `restriction_97_100_from_74.verified.mrdi` | One class each for Nos. 98–100; No. 97 retains two root-free classes. |
| 101, 102 ← 67; 102, 103 ← 69 | [`restriction_101_102_from_67_result.md`](restriction_101_102_from_67_result.md), [`restriction_102_103_from_69_result.md`](restriction_102_103_from_69_result.md) | No. 101 and Nos. 102/103 in No. 69 each have one matching root-free class. No. 102 also has two root-free classes in No. 67; see the unresolved comparison below. |
| Cyclic rank-zero restrictions, including 141 and 143 | [`rank0_restrictions_18_41_44.md`](rank0_restrictions_18_41_44.md), [`cyclic_141_from_95_note.md`](cyclic_141_from_95_note.md), [`cyclic_spectrum_equivalence_note.md`](cyclic_spectrum_equivalence_note.md) | No. 141 has three character-matched classes in No. 24, but the identified No. 95 parent gives one matching class. No. 143 has three No. 41 classes with the same character; its saved ordinary action uses the separate spectrum and connected-smooth-family argument. These early restrictions do not all repeat the root test. |
| Other numbered parent restrictions | [`lattice_156_script.md`](lattice_156_script.md), especially “Included sources” | The case-specific `restriction_*_script.md` notes and `.verified.mrdi` sidecars give the finite counts, integral checks, and selected paths for Nos. 83, 86–87, 92, 104, 106, 109–118, 123, 125–126, and 129–131. The source table identifies which verified file feeds each numbered row. |

The No. 33/47 proof merits a stronger statement than “one character
match.” The GAP stage checks the direct strict embeddings `33 → 18` and
`47 → 28` and the exact geometric characters. The finite stage checks all
subgroups with the specified symplectic intersection and quotient; its
three raw subgroups form **one** orbit under the full identified parent in
each case. Thus the unknown correspondence between a frozen geometric
subgroup and a saved parent generator does not create another parent-relative
integral restriction. The exact \(S/T\) isometry certificates and independent
root verification finish the ambient check. The certificate deliberately
does not assert a global classification of unrelated rank-22 parent
representations.

## Several surviving parent classes

These rows cannot be compressed to “unique by character.” The extra
argument and the remaining limit differ by case.

| Child | Surviving parent classes | What identifies the ordinary integral action |
| --- | --- | --- |
| 84, 85, 107 | Two No. 60 classes per child | [`no60_geometric_normalizer_certificate.md`](no60_geometric_normalizer_certificate.md) verifies an explicit rational \(GL_6\) normalizer exchanging the two geometric subgroups of each *same* numbered type. [`no60_normalizer_assignment_audit.md`](no60_normalizer_assignment_audit.md) uses the identified No. 60 parent and connected smooth families to identify each pair's ordinary integral action. Neither saved class number is matched to the frozen strict witness. |
| 97 | Two No. 74 classes | [`restriction_no97_two_classes.md`](restriction_no97_two_classes.md) gives explicit \(GL_6\) conjugacies of the strict child groups and a connected-family transport argument. The two groups are not conjugate *inside* No. 74. |
| 121 | No. 74 classes 3, 5, 6 | [`restriction_no121_three_parent_classes.md`](restriction_no121_three_parent_classes.md) compares their full six-dimensional strict representations, then uses connectedness of the smooth No. 121 invariant-cubic locus. The classes are kept as separate provenance. |
| 124 | No. 81 classes 2, 3 | [`restriction_small_from_78_81.md`](restriction_small_from_78_81.md) checks a block-swap on an explicit smooth cubic and uses connectedness of the No. 81 family. The saved labelled matrices are not identified literally. |
| 102 | No. 67 classes 1, 2; No. 69 class 1 | The No. 69 path identifies a numbered action through a unique parent class and connected smooth child family. [`restriction_101_102_from_67_result.md`](restriction_101_102_from_67_result.md) retains both No. 67 paths separately without deciding their equivalence. [`compare_102_cross_parent_types_20261001.log`](compare_102_cross_parent_types_20261001.log) finds the same coarse OSCAR type, which is **not** an integral conjugacy certificate between either No. 67 path and the selected No. 69 path. |

In each of the first four rows, the extra geometric argument establishes
equivalence of ordinary integral actions; it does not equate the stored
rank-22 matrices or label a particular OSCAR parent class by a particular
strict GAP witness. For No. 102 the cross-parent relation remains open in
the saved evidence, so both No. 67 paths must remain visible beside the
selected No. 69 representative.

For a quick audit, first read the row in the generated source table, then
its case note and `.verified.mrdi` sidecar, and finally the numbered import
verifier. The generated table and the final structural receipt check
provenance and record consistency; they do not replace the finite subgroup,
root, or geometric identification arguments above.
