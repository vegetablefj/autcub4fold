# No. 111 in the saved full No. 18 action

**Completed 2026-10-01.** The GAP character and all four OSCAR stages
(`preflight`, `groups`, `lattices`, `verify`) passed. The exhaustive finite
search found two `[9,2]` conjugacy classes in the saved full No. 18 parent:
an orbit of 4 matching the No. 111 geometric character and an orbit of 8
that does not. The matching class has `rank(S)=12`, `rank(T)=10`,
`rank(P)=8`, `rank(K)=14`, index 3 and period dimension 3. Its root check
passed: **one root-free class, zero root-obstructed classes**. This is
uniqueness only within the saved No. 18 parent action.

The result was imported into
`lattice_156_with_111_116_129_20261001.mrdi`. The independent 156-row
catalogue verifier reloaded that file and verified No. 111 as the unique
root-free class within the saved No. 18 parent. The final verification log
is `verify_lattice_156_with_111_116_129_retry_20261001.log`.

The frozen numbered table gives No. 111 a symplectic kernel `C3`,
`rank(S)=12`, quotient order 3, period dimension 3, and full projective
group ID `[9,2]`. No. 18 has kernel `M_9` of order 72, quotient order 3,
and full group ID `[216,153]`. The frozen cross-dimension table records a
direct strict GL(6) containment `111 -> 18` with an `A_strict` conjugating
matrix. This supplies the geometric route for restricting the No. 18 action;
it does not itself identify a rank-22 integral action.

The selected No. 18 integral result is
`../../oscar/oscar_script_data.mrdi` case 6/result 1. Its prepared full-group
cache, `source_18_full_lattice_group_rank0.mrdi`, already contains the 72
element symplectic kernel's generators on `S` and on the rank-22 ambient
lattice, together with the extra generator on both lattices. The Julia
script checks the source and cache, the selected result,
the frozen GAP group and strict-witness files, and the direct containment
metadata. It does not recompute `O(S)` or its discriminant kernel.

`restriction_111_geometric_character.g` checks the saved strict conjugation,
the common scalar subgroup, and scalar independence of the primitive-
`H^4` trace, then writes
`restriction_111_geometric_character.tsv`. It refuses to overwrite a TSV.

`restriction_111_from_18.jl` has four stages:

1. `preflight` checks the source inputs, numbered data, direct strict edge,
   geometric character, and cached ambient generators.
2. `groups` constructs the 216-element parent from exact normal forms
   `n*f^k`. It enumerates every order-three subgroup `A` of the 72-element
   kernel and all 72 lifts in `N*f`. For each closure `B=<A,n*f>`, it
   requires `|B|=9`, `B intersect N=A`, quotient `C3`, and ID `[9,2]`.
   It then forms conjugacy orbits under the **full** parent and compares
   each class's complete primitive-cohomology character with the frozen
   No. 111 character. Every candidate class is retained.
3. `lattices` constructs embedded `S,T,P,K` and their actions for every
   character match. It checks `rank(S)=12`, `rank(T)=10`, quotient-action
   order 3, period dimension 3, and the lattice signatures. A class-specific
   smoke pass is available without overwriting the exhaustive output.
4. `verify` reconstructs each lattice restriction, rechecks its subgroup
   and character, and tests roots in `K`, recording root-free and obstructed
   classes separately.

To reproduce on a fresh copy without these output files, run from
`remark/catalogue`, in order (the existing outputs are
protected against overwriting):

```text
GAP:   Read("restriction_111_geometric_character.g");
Julia: restriction_111_from_18.jl preflight
Julia: restriction_111_from_18.jl groups
Julia: restriction_111_from_18.jl lattices
Julia: restriction_111_from_18.jl verify
```

The three OSCAR output paths are
`restriction_111_from_18.groups.mrdi`, `.lattices.mrdi`, and
`.verified.mrdi`. Each stage refuses to overwrite its output and records
its inputs for the next stage. The `lattices` stage accepts
`[output.mrdi] [groups.mrdi] [class]` for an isolated smoke pass.

The four restriction stages do not themselves edit the 156-row catalogue;
a separate guarded import produced the combined catalogue named above.
The completed restriction and independent catalogue verification identify
one root-free class **within the saved No. 18 parent action**. They do not
independently recompute the child's full discriminant-kernel group ID,
prove symplectic saturation, or establish integral uniqueness outside this
parent.
