# No. 106 from the saved No. 67 action

No. 106 has symplectic group $C_3$, generic and actual index 1, and family
dimension 8. Its strict matrix group is a direct subgroup of No. 67. This
calculation restricts the already cached full No. 67 lattice action; it
does not enumerate new ambient isometries or recompute $O(S)$.

`restriction_106_geometric_character.g` checks the saved GL(6)
conjugating witness for No. 106 → No. 67 and computes the character of all
three projective elements on primitive $H^4$. The generated
`restriction_106_geometric_character.tsv` has bins `(order, trace, count)`
equal to `(1,22,1)` and `(3,4,2)`.

`restriction_106_from_67.jl` enumerates all order-three subgroups of the
order-12 symplectic kernel $A_4$ in the No. 67 cache, checks their exact
closure and No. 67 parent-conjugacy classes, and compares the full
`(order, trace)` histogram. For each matching class, the fixed lattice gives
$T$ and the orthogonal complement gives $S$. The actual index is 1, so
the extra action is the identity. The script then constructs complete
embedded $S,T,P,K$ records and checks ranks, signatures, period dimension,
and roots. It has separate `preflight`, `groups`, `lattices`, and `verify`
stages and refuses to overwrite existing MRDI outputs. Each stage checks
source inputs and the saved parent cache.

From this directory, the GAP certificate is run with
`gap -q -b < restriction_106_geometric_character.g`. In the OSCAR 1.8
environment, call `julia --project=<environment> restriction_106_from_67.jl`
with each stage name in order. A single root-free class would give a
unique restriction *within the saved No. 67 action*. It would not by
itself establish child symplectic saturation or global integral
uniqueness. The numbered catalogue is not edited by these scripts.
