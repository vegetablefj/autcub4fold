# Nos. 102 and 103 from the saved No. 69 lattice action

The GAP character stage and all OSCAR stages passed on 2026-10-01. The
canonical 156-row catalogue remains unchanged. See
`restriction_102_103_from_69_result.md` for the outcomes. The parent is the
single saved OSCAR output for case 27, result 1: symplectic group $A_4$,
rank $S=16$, generic index $2$, actual index $6$, and projective group
`[72,42]`. Its saved primitive action is an individual extra isometry, not
the full rank-22 group. The `prepare` stage reconstructed the order-12
symplectic discriminant kernel on $S$, extended its generators trivially to
$T$, and checked them on the common rank-22 lattice. The finite stage then
verified that these generators with the saved extra isometry form the
order-72 projective parent group.

The frozen cross-dimensional GAP data contain direct strict GL(6) embeddings `102 -> 69` and `103 -> 69`, with respective linear group orders `36 -> 216` and `72 -> 216`. The companion GAP script independently checks the stored conjugating matrices and computes the complete primitive-$H^4$ projective character of each target. The No. 102 character agrees exactly with the independently generated No. 67 restriction input. These are necessary filters for a lattice subgroup; they do not by themselves identify a specific subgroup of the saved parent.

For either child the symplectic kernel is $C_2^2$. No. 102 has index $3$, so its image in the parent's cyclic quotient $C_6$ is the order-three subgroup. Enumerate every $C_2^2$ in the order-12 kernel and every lift $n f^2$, where $n$ ranges over that kernel. No. 103 has index $6$: enumerate the same kernels with all lifts $n f$. In each case check normalization, the lift's relevant power, exact subgroup closure, the intersection with the symplectic kernel, the quotient image, and the GAP group ID. Only then quotient by conjugacy in the *full* parent. Compare the entire order/primitive-trace histogram with the GAP character, not just a generator trace. For each surviving class, compute the invariant and coinvariant integral sublattices, the restricted $T$-isometry, the period and complement ranks, dimension, and the root obstruction.

Files:

- `restriction_102_103_geometric_characters.g`: checks the geometric input and writes `restriction_102_103_geometric_characters.tsv` without overwriting it.
- `restriction_102_103_from_69.jl`: `source-check`, `prepare`, `preflight`, `groups`, `lattices`, and `verify` stages. Each MRDI stage refuses to overwrite an existing file and checks its inputs.
- `source_69_full_lattice_group_restriction_102_103.mrdi` and `restriction_102_103_from_69.{groups,lattices,verified}.mrdi`: completed outputs, each saved and reloaded by its stage.

Run the GAP script from this directory first. Then run the Julia stages one at a time using the same OSCAR project as the other restriction scripts, under the usual single-thread and memory guard. `source-check` is read-only and does not need the expensive parent cache. `prepare` is the potentially expensive (O(S))-kernel stage; do not run it simultaneously with another heavy OSCAR job. Inspect each log and MRDI reload before the next stage. The `groups` stage does not assign a numbered child if several parent-conjugacy classes survive. Keep all complete candidates until the lattice, root, and geometric-identification checks resolve them.

The method can establish completeness **among subgroups of the verified saved No. 69 action**. It does not independently prove symplectic saturation, equality of an extracted class with a particular equation family, or uniqueness among unrelated integral parent actions. In particular, a match for No. 102 need not equal the class found inside the saved No. 67 action without an explicit integral comparison; if the two parents yield multiple possibilities, retain that ambiguity.
