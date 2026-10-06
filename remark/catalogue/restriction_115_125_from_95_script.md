# Nos. 115 and 125 inside the saved No. 95 action

`restriction_115_125_geometric_characters.g` reads the frozen numbered linear groups, checks the two direct strict GL(6) containment witnesses, and writes the exact projective primitive-
\(H^4\) character table `restriction_115_125_geometric_characters.tsv`. Its completed GAP run gave the following bins, written as `(element order, trace): count`:

| Family | Character bins |
|---|---|
| No. 115 | `(1,22):1`, `(2,-10):3`, `(3,4):2` |
| No. 125 | `(1,22):1`, `(2,-10):2`, `(2,6):1`, `(3,-11):2`, `(6,-3):2`, `(6,5):4` |

The saved No. 95 lattice action has an explicit normal symplectic subgroup \(N\cong S_3\) of order six and cyclic quotient of order 12. `restriction_115_125_from_95.jl` checks the 72 distinct normal-form elements \(nf^k\), their multiplication table, and the exact ambient matrices. For No. 115, it takes the unique \(C_3\) in \(N\) and every involution above the order-two quotient element \(f^6N\). These generate all possible \(S_3\) subgroups of the required kernel and quotient type. For No. 125, it takes each of the three order-two subgroups of \(N\) and every lift above \(f^2N\), retaining precisely those subgroups of order 12, intersection order two, and abstract type `[12,5]`. Every subgroup with the required cyclic quotient has such a lift; no assumption that the entire subgroup is cyclic or that one fixed pair of parent generators suffices is made.

The `groups` stage removes duplicate subgroups and takes conjugacy orbits under the full saved No. 95 group. It records every class and its full primitive-cohomology character. The geometric character is only a filter, not an identification by itself. The `lattices` stage then computes the exact embedded \(S,T,P,K\), the action on \(T\), the index, and the period dimension for every matching class. The `verify` stage reconstructs each retained restriction and checks the root obstruction. All matching parent classes remain separate if the available invariants do not distinguish them; the script does not assert their integral conjugacy or symplectic saturation.

Run the stages in this order from `remark/catalogue`:

```text
GAP:   Read("restriction_115_125_geometric_characters.g");
Julia: restriction_115_125_from_95.jl preflight
Julia: restriction_115_125_from_95.jl groups
Julia: restriction_115_125_from_95.jl lattices
Julia: restriction_115_125_from_95.jl verify
```

For a smaller lattice smoke test, the `lattices` stage accepts a separate output path, its groups path, and `115:class` or `125:class`. Each stage refuses to overwrite an existing output. The completed files are `restriction_115_125_from_95.groups.mrdi`, `.lattices.mrdi`, and `.verified.mrdi`; their run logs are `restriction_115_125_groups_20261001.log`, `restriction_115_125_lattices_20261001.log`, and `restriction_115_125_verify_20261001.log`.

| Family | No. 95 class | Conjugacy orbit | `rank(S)` | `rank(T)` | `rank(P)` | `rank(K)` | Quotient index | Period dimension |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| No. 115 | 1 | 1 | 12 | 10 | 10 | 12 | 2 | 8 |
| No. 125 | 1 | 3 | 8 | 14 | 12 | 10 | 6 | 5 |

Each target has exactly one parent-conjugacy class with the required abstract group and exact geometric character. Both classes pass the full embedded lattice, quotient-action, period-dimension, and root-obstruction checks. The final record saves and reloads two root-verified paths with match counts `[1,1]`; it checks the No. 95 parent lattice record, numbering table, strict-containment table, and both geometric-character files. These results identify the two restrictions *within the saved No. 95 action*. They do not independently recompute the full group ID from the discriminant kernel, prove symplectic saturation, or enumerate every possible integral action outside that parent.
