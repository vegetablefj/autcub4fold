# No. 101 and No. 102 inside the saved No. 67 action

The companion GAP calculation verified both strict direct containments and
the complete primitive-cohomology characters of the two numbered families.
The OSCAR preparation recovered the order-12 symplectic kernel of No. 67 on
the rank-22 primitive lattice and checked its full projective group ID
`[36,11]`. The finite stage enumerated all three eligible order-12 subgroups
containing the common `C2^2` kernel, up to conjugacy in this saved parent.

| Row | Full group | Parent classes passing the exact character | Passing lattice and period checks | Root-free classes |
| --- | --- | ---: | ---: | ---: |
| No. 101 | `[12,5]` | 1 | 1 | 1 |
| No. 102 | `[12,3]` | 2 | 2 | 2 |

All three retained classes have `rank(S)=12`, `rank(T)=10`, index 3 and the
required period dimension. No. 101 has `rank(P)=10`, dimension 4 and
characteristic polynomial `Phi3^5` on `T`. Its unique class *within No. 67*
may be used as a restriction result. The two No. 102 classes both have
`rank(P)=8`, dimension 3 and characteristic polynomial `Phi1^2 Phi3^4` on
`T`; both have `det(P)=2304` and `det(K)=768`. Their displayed `T` action
matrices differ. Equality of their integral action classes has **not** been
established, so neither one is selected for the numbered row. Their fixed
rank-two lattices have determinant 12 and visibly isometric displayed Gram
forms; OSCAR's `is_of_same_type` also returns `true`. These are necessary
comparisons, not an integral conjugacy certificate.

The full outputs are `restriction_101_102_from_67.groups.mrdi`,
`restriction_101_102_from_67.lattices.mrdi`, and
`restriction_101_102_from_67.verified.mrdi`; the final file was reloaded
successfully. `summarize_101_102_candidates_20261001.log` records the
candidate matrices and elementary invariants;
`summarize_101_102_eigensublattices_20261001.log` and
`compare_102_action_types_20261001.log` record the further comparisons.
The enumeration claim is exhaustive only inside this saved No. 67 lattice
action. It does not establish global
integral uniqueness, a geometric pairing for the two No. 102 classes, or
symplectic saturation.
