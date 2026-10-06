# No. 87 from the saved No. 18 action

No. 87 has symplectic group $S_3$, generic index 1, actual index 3,
family dimension 2, and projective group ID `[18,3]`. Its strict matrix
group has a direct edge to No. 18. The calculation uses the already saved
full No. 18 lattice action, without enumerating new ambient isometries or
recomputing $O(S)$.

`restriction_87_geometric_character.g` checks the saved strict GL(6)
conjugating witness and computes the `(order, trace)` histogram on
primitive $H^4$ for all 18 projective group elements. Its output
`restriction_87_geometric_character.tsv` has `(order, trace, count)` bins
`(1,22,1)`, `(2,6,3)`, `(3,-2,6)`, `(3,4,2)`, and `(6,0,6)`.

`restriction_87_from_18.jl` enumerates every $S_3$ subgroup $A$ of the
order-72 symplectic kernel of No. 18. For each $A$, it tests all 72 lifts
in the first coset of the order-three quotient. Exact normalization,
closure, subgroup ID `[18,3]`, parent conjugacy, and the histogram
select the candidate classes. For each matching class, the
fixed lattice of the two $S_3$ generators gives $T$, and its orthogonal
complement gives $S$. The extra lift acts on $T$ with order three; the
code constructs complete embedded $S,T,P,K$ data, checks expected ranks
and signatures, the period dimension 2, and roots.

The script stages are `preflight`, `groups`, `lattices`, and `verify`, each
with distinct, non-overwriting output files. Run the GAP certificate from
this directory with `gap -q -b < restriction_87_geometric_character.g`;
then call `julia --project=<environment> restriction_87_from_18.jl` with
each stage name in order in an OSCAR 1.8 environment. Input checks cover
the parent cache, GAP family and witness files, character certificate, and
implementation sources.

The finite subgroup search is exhaustive only inside the saved No. 18
full group. A root-free output does not independently establish child
symplectic saturation or uniqueness among actions outside that parent.
The 156-row catalogue is not edited by these stages.
