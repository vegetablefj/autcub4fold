# Nos. 102 and 103 inside the saved No. 69 action

GAP verified direct strict linear-conjugacy containments into No. 69 for
both numbered families and computed their complete projective
primitive-cohomology characters. OSCAR reconstructed the rank-22 action of
the full No. 69 group `[72,42]`, including its order-12 symplectic kernel.
It then exhaustively enumerated eligible `C2^2`-kernel subgroups and the
required quotient lifts, up to conjugacy in this saved parent.

| Row | Projective group | Index | Matching parent classes | Class orbit size | Lattice/period passes | Root-free |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| No. 102 | `[12,3]` | 3 | 1 | 2 | 1 | 1 |
| No. 103 | `[24,10]` | 6 | 1 | 3 | 1 | 1 |

Both restrictions have `rank(S)=12`, `rank(T)=10`, `rank(P)=8`, `rank(K)=14`,
and period dimension 3. Each final record was independently reconstructed,
root-checked, saved in `restriction_102_103_from_69.verified.mrdi`, and
reloaded. The resulting uniqueness is **within the saved No. 69 action**;
it is not an independent global classification or symplectic-saturation
check.

No. 102 also has two exact-character, root-free classes inside the
independently saved No. 67 action. Those two records remain distinct, and
no integral equivalence with the No. 69 restriction is asserted here.
The No. 69 route nevertheless identifies a numbered-family action, not just
an abstract subgroup candidate. The strict GL(6) witnesses place a smooth
No. 69 cubic in each of the fixed No. 102 and No. 103 linear-representation
families. The saved No. 69 action is the sole case-27 output in
`../../oscar/oscar_result.md` (group `[72,42]`), and the self-conjugacy check
for that group is recorded in
`../../gap_classification/gap_self_conjugacy/gap_self_conjugacy.md`. Among its
subgroups, the checks above leave one relevant class for each row. For a
fixed linear representation, the smooth invariant cubics form a nonempty
Zariski-open subset of a projective linear system, hence a connected family;
the integral cohomology representation of its fixed finite group is locally
constant up to integral conjugacy. Thus the restriction at the No. 69
specialization determines the ordinary integral action along each such
family. This argument relies on the saved No. 69 classification and does
not compare the two No. 67 candidate actions. Keep those candidates for
provenance until their cross-parent relation is explicitly resolved.
