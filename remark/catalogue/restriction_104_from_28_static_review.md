# No. 104 from No. 28: pre-run static review

`restriction_104_from_28.jl` has four separate stages: `preflight`, `groups`,
`lattices`, and `verify`. This document records the static review made before
execution; all stages subsequently completed on 2026-10-04. Every stage
requires `source_28_full_lattice_group.mrdi` and checks it with
`no28_verify_cache()` before doing the relevant mathematical calculation.
The No. 28 cache was produced and checked by the separate preparation
script. Existing source data and result files were not changed. Actual
results and cache provenance are recorded in `restriction_104_from_28_script.md`.

## Finite-group argument

Write the verified full No. 28 group as `G = {n f^k : n in N, 0 <= k < 6}`,
where `|N|=72`, `c=f^6` belongs to `N`, and `phi(n)=f n f^{-1}`. Multiplication
uses `(n,k)(m,l)=(n phi^k(m) c^floor((k+l)/6), (k+l) mod 6)`. In particular,
the code does not assume that `c` is central or that `phi^6` is the identity.
The finite-group part uses these formulas and the verified 18- and
22-dimensional relations, not a generic enumeration of subgroups of the
order-432 parent.

The target has `H intersect N` isomorphic to `V4` and surjects onto `G/N=C6`.
The script enumerates every `V4` subgroup `A` of `N` and every `n f^k` with
`k=1,5`, retaining the lift when it normalizes `A` and has sixth power in
`A`. Then `H=<A,n f^k>` has exactly 24 elements. Conversely every subgroup
with this intersection and quotient occurs. The `k=1` pass is already
complete; the `k=5` pass provides an independent equality check on the sets
of resulting subgroups. Deduplication compares all 24 elements, and orbit
search uses generators of the *full* parent group. The abstract group ID
`[24,13]` and the complete independently computed geometric character are
separate filters. Every matching class is retained; no uniqueness is assumed.

## Lattice stage

The symplectic intersection is noncyclic, so a cyclic-restriction helper is
not used. The common invariant lattice of two generators of `V4` yields the
candidate `T`, and its orthogonal complement yields `S`. The expected checks
are `rank(S)=12`, `rank(T)=10`, quotient index six, period dimension two,
`rank(P)=6`, `rank(K)=16`, signatures `(4,0,2)` and `(16,0,0)` for `P` and
`K`, and compatibility of the ambient action. The final stage recomputes the
candidate data, tests the root obstruction, and checks that the lattice-stage
class-number sets contain every character match exactly once. Saturation or
global uniqueness is **not** asserted by this restriction computation.

## Execution checks identified by this review

1. Finish the No. 28 cache preparation. In particular, actually verify that
   the stable discriminant kernel has order 72, that all generators extend to
   `Lambda0`, and that the 432 claimed full matrices are distinct.
2. Run the four stages in order, one memory-protected heavy process at a
   time. The first run is also a syntax/API check; this static review did not
   execute Julia or OSCAR.
3. Inspect the number and IDs of full-parent conjugacy classes, the exact
   character matches, the lattice and root outcomes, and the saved MRDI
   reloads. If more than one class survives, preserve them for a separate
   geometric or integral identification rather than selecting one by order.

These checks were subsequently completed: 10 kernel `V4` subgroups, 36
order-24 candidates, six parent-conjugacy classes, and one root-free exact
character match. The corresponding staged MRDIs are retained. The rank-18
`O(S)` cache construction was the potentially expensive part; the finite
search used exact formulas. This review remains as a record of the
pre-execution design, not as a statement that computation is still pending.
