# No. 83 from the saved No. 18 action

No. 83 has symplectic group $S_3$, generic and actual index 1, and family
dimension 6. The saved strict matrix-group relation is the direct edge
No. 83 → No. 18. This calculation searches inside the already cached full
No. 18 lattice action; it does not enumerate new ambient lattice actions.

`restriction_83_geometric_character.g` checks the saved strict GL(6)
conjugating witness and computes the `(order, trace)` histogram of all
projective elements on primitive $H^4$. Its generated
`restriction_83_geometric_character.tsv` has bins
`(order, trace, count)` equal to `(1,22,1)`, `(2,6,3)`, and `(3,4,2)`.
These are counts of all six projective group elements, not just generators.

`restriction_83_from_18.jl` reuses the independently checked full No. 18
group cache and its 216-element finite multiplication table. It exhausts
all pairs consisting of an involution and a noncommuting element of order
three in the order-72 symplectic kernel. Exact subgroup closure selects
the six-element $S_3$ subgroups; full No. 18 conjugation removes duplicate
embeddings. This histogram is then compared for every class.
For each matching class, the fixed lattice of both $S_3$ generators gives
$T$, with $S=T^\perp$. As the index is 1, the extra action is the
identity; the code constructs the complete embedded $S,T,P,K$ data and
checks ranks, signatures, period dimension, and roots. The stages are
`preflight`, `groups`, `lattices`, and `verify`, with separate MRDI files.

Run GAP from this directory using `gap -q -b < restriction_83_geometric_character.g`.
Then, in an OSCAR 1.8 environment, run
`julia --project=<environment> restriction_83_from_18.jl preflight`, followed
by the `groups`, `lattices`, and `verify` stages in that order. Each output
path is refused if it already exists. The Julia script checks the frozen
sources, parent cache, strict-containment table and witnesses, character
certificate, and implementation sources.

The finite search is exhaustive *within the saved No. 18 full action*.
The one root-free class and its catalogue import passed all four OSCAR
stages and the separate catalogue verification; see
`restriction_83_from_18_result.md`. This does not independently establish
global integral uniqueness or symplectic saturation.
