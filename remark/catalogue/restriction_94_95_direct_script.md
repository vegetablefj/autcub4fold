# No. 24 to No. 94/95: direct group-stage restriction

`enumerate_restrictions_94_95_direct.jl` is an alternative to the general
normalizer/quotient script. It uses the checked No. 24 cache
`source_24_full_lattice_group.mrdi` and only enumerates matrices on its
rank-18 coinvariant lattice. It does **not** compute the order or subgroup
classes of a rank-22 matrix group.

Write \(N=\widetilde O(S)\), of order 486, and let \(f\) be the saved extra
isometry. Its image generates the order-12 quotient of the full lattice group
by \(N\). Any desired subgroup \(B\) has \(A=B\cap N\cong S_3\) and
\(B/A\cong C_{12}\). Thus one may choose \(b=nf\) for some \(n\in N\).
The script enumerates every \(S_3\) subgroup \(A\) of \(N\), tests
\(bAb^{-1}=A\) and \(b^{12}\in A\), and records \(B=\langle A,b\rangle\).
The two tests are sufficient: the image of \(b\) has order 12, so
\(|B|=72\) and \(B\cap N=A\). It removes duplicate \(B\)'s by the
conjugation actions of generators of \(N\) and of \(f\), then identifies
the remaining abstract groups using their degree-72 regular permutation
actions in GAP. The target ID is `[72,27]`.

The finite multiplication table is constructed by breadth-first traversal
of the 486 elements. Products thereafter use recorded generator words, not
repeated 18-by-18 matrix multiplication. Before saving, the script checks
that the rank-18 generators match their rank-22 lifts, that \(f^{12}\)
matches the lift of its \(N\)-component, and that conjugation by \(f\)
matches on both sides. The original saved \(T\)-action certifies that the
coset of \(f\) really has order 12, even if its rank-18 matrix image alone
does not detect this.

The output is `restriction_candidates_94_95_from_24.direct_groups.mrdi`.
It stores the raw and conjugacy-class counts, group-ID histogram, and both
rank-18 and rank-22 generators for every retained class. The classes remain
unassigned **at this group stage**. The separate evaluator assigns them using
the geometric cohomology characters and saves their full integral actions;
see `restriction_94_95_from_24_result.md`.

For a tiny API and completeness smoke test, set `NO24_DIRECT_SMOKE=1`.
This runs only an \(S_3\times C_2\) example on four coordinates; it neither
loads the No. 24 cache nor runs any expensive lattice calculation. That
smoke test passed under Julia 1.10.11 and OSCAR 1.8.2. The full No. 24 run
also completed under those versions: 1080 `S3` subgroups, 81 raw target
subgroups and three parent-conjugacy classes with ID `[72,27]`.
