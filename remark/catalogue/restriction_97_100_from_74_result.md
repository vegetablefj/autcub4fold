# Nos. 97–100 from the saved No. 74 action

`restriction_97_100_from_74.jl` uses the cached full rank-22 action of No. 74. It enumerates all 35 subgroups of the 16-element parent, rather than assuming that every subgroup has two generators. For each numbered target, it tests the abstract group, the order-four symplectic intersection, the exact primitive-cohomology character, quotient index, period dimension and root obstruction. The geometric characters were computed separately by `restriction_97_100_geometric_characters.g`.

| Family | Matching No. 74 classes | Group ID | rank `S` | rank `T` | rank `P` | rank `K` | Index | Dimension |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 97 | 1, 2 | `[4,2]` | 12 | 10 | 10 | 12 | 1 | 8 |
| 98 | 2 | `[8,5]` | 12 | 10 | 9 | 13 | 2 | 7 |
| 99 | 1 | `[8,3]` | 12 | 10 | 8 | 14 | 2 | 6 |
| 100 | 1 | `[8,5]` | 12 | 10 | 7 | 15 | 2 | 5 |

The groups stage stores every eligible parent-conjugacy class in `restriction_97_100_from_74.groups.mrdi`. The lattice stage builds the complete embedded `S`, `T`, `P`, `K` data and `T` action in `restriction_97_100_from_74.lattices.mrdi`. An independent verification stage reconstructs all five character- and period-matched paths, checks each extracted group ID and the absence of roots, and saves/reloads `restriction_97_100_from_74.verified.mrdi`. All three stages completed successfully. The 156-row catalogue retains both No. 97 paths and selects class 1 only as its displayed representative.

The two No. 97 classes are not conjugate *inside* No. 74. [The separate certificate](restriction_no97_two_classes.md) gives an explicit `GL_6` conjugacy of their strict source groups and uses connectedness of the smooth No. 97 invariant-cubic locus to identify the resulting ordinary integral group actions. This does not assert literal equality of their saved matrices, a conjugacy within No. 74, or a Hodge isometry between arbitrary members. These restrictions do not rerun the global isometry enumeration or establish a new symplectic-saturation theorem.
