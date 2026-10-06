# Cyclic restrictions of the saved No. 24 lattice action

The saved No. 24 full action has a symplectic kernel of order 486 and cyclic
quotient of order 12. `enumerate_cyclic_restrictions_from_24.jl` constructs
every element `n*f^(12/m)` of exact order `m`, for `m=3,6,12`, with `n` in
the kernel. Its order test includes the nontrivial factor `f^12`. It then
classifies the candidates by conjugation in the full saved parent group,
retaining a 22-dimensional integral matrix for each class. The script checks
that the relevant 18- and 22-dimensional lifts agree and that all resulting
cyclic actions have the asserted exact order. It saves and reloads
`cyclic_restrictions_from_24.groups.mrdi`.

| Order | Candidate elements | Parent-conjugacy classes |
| ---: | ---: | ---: |
| 3 | 81 | 5 |
| 6 | 324 | 8 |
| 12 | 324 | 6 |

The source cubics and the containment witnesses for Nos. 141, 142, 149, and
150 are checked independently in
`../gap_checks/cyclic_141_150/`. In particular,
the source groups fix a smooth member of the No. 24 family. The exact
primitive-cohomology character includes the trace and element order of every
power, not just that of one chosen generator. Comparing these characters to
the exhaustive integral candidates gives:

| Family | Order | Matching parent classes | Assignment |
| ---: | ---: | --- | --- |
| 141 | 6 | 2, 4, 5 | Not unique inside No. 24; resolved separately inside No. 95 |
| 142 | 6 | 6 | Unique |
| 149 | 12 | 6 | Unique |
| 150 | 12 | 2 | Unique |

`evaluate_cyclic_restrictions_from_24.jl` saves the three uniquely matched
complete rank-22 actions to
`restriction_cyclic_141_142_149_150_from_24.mrdi`. It checks their orders,
trivial action on the ambient discriminant, saturated cyclotomic period
lattices, positive-definite orthogonal complements, and period dimensions.
The results are:

| Family | Period rank | Dimension | Orthogonal-complement rank |
| ---: | ---: | ---: | ---: |
| 142 | 10 | 4 | 12 |
| 149 | 12 | 2 | 10 |
| 150 | 12 | 2 | 10 |

The distinct characters identify the three integral restrictions because every
geometric source action embeds into the checked No. 24 group, and each of the
three rows has just one matching parent-conjugacy class. The smooth locus of
each linear invariant family is connected, so this also fixes the generic
lattice-action class. The No. 24 calculation deliberately does not assign
No. 141 from its three same-character classes. A separate exhaustive
restriction inside the smaller No. 95 group has exactly one matching class;
see `cyclic_141_from_95_note.md` and `cyclic_141_from_95.lattices.mrdi`.
No separate root or saturation test is claimed
for these rank-zero restrictions.

The three assigned rows are included in the side-by-side
`lattice_156_with_cyclic_restrictions.mrdi`. Both its builder and the
independent reload verifier passed: 156 rows, 88 rows with `T`, and 71 rows
with an extra `T` action. The original `lattice_156.mrdi` was not replaced.
