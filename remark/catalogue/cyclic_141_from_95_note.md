# No. 141 cyclic restriction inside the saved No. 95 action

`enumerate_cyclic_141_from_95.jl` is a separate, staged exact computation. Its input is the No. 95 record uniquely identified by the No. 24 restriction's full-group primitive character, `restriction_candidates_94_95_from_24.direct_lattices.mrdi`. The record contains two symplectic generators on the full rank-22 primitive lattice and an extra generator whose action on the rank-8 invariant lattice has order 12.

The `groups` stage uses the existing `direct_context` routine to enumerate the six-element symplectic kernel, verify the extension relation and compute every element `b=n f^2` with `b^6=1`. Since the image of `b` in the parent quotient has order six, this is exactly the order-six condition and its cyclic subgroup has trivial symplectic intersection. Conjugation by the kernel generators and by `f` partitions all such generators into full-parent conjugacy classes. For each class it computes the complete rank-22 trace histogram of its six powers and compares that histogram with the exact geometric No. 141 TSV at `../gap_checks/cyclic_141_150/primitive_cyclic_141_150_summary.tsv`.

The `lattices` stage reconstructs every surviving rank-zero cyclic action, checks order and stable discriminant action, and saves its integral `T=Lambda0`, `P`, `K`, period dimension and full generator matrix. It does not create a zero-dimensional `S` object. It does not independently retest roots. Its output records `unique_character_match_within_parent` separately from `numbered_integral_assignment_verified=false`, because the computation itself does not contain the separate geometric-containment certificate. The numbered assignment uses the exact No. 141 → No. 95 containment in the cross-dimensional GAP audit and the root-free smooth parent supplied by the saved No. 95 construction.

Both stages were run under a 4 GiB memory cap. There are six exact order-six generators in three full-parent conjugacy classes, of sizes 2, 1, and 3. Only class 1 matches the No. 141 geometric character. Its cyclotomic period lattice has rank 12, its orthogonal complement rank 10, and its period dimension is 5. The other two classes each have period dimension 7. The saved group and lattice MRDI files were reloaded successfully; the No. 141 action is attached to the side-by-side 156-row catalogue by its builder.

Run under the established memory/time cap, one stage at a time:

```text
julia remark/catalogue/enumerate_cyclic_141_from_95.jl groups
julia remark/catalogue/enumerate_cyclic_141_from_95.jl lattices
```

These reproduce `cyclic_141_from_95.groups.mrdi` and `cyclic_141_from_95.lattices.mrdi`; the staged computation itself does not modify a numbered catalogue.
