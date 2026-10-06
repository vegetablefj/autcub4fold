# No. 110 as a restriction of No. 67

No. 110 has symplectic part $C_3$, rank-12 coinvariant lattice,
projective group `[9,2]`, index 3, and family dimension 4. Its
different-symplectic-part containment in No. 67 (symplectic part $A_4$,
projective group `[36,11]`) is recorded as a direct strict linear-conjugacy
edge. The saved No. 67 integral action is `oscar/oscar_script_data.mrdi` case
26, result 2; its full 36-element ambient group and rank-22 symplectic lifts
were already reconstructed in
`source_67_full_lattice_group_restriction_101_102.mrdi`.

`restriction_110_geometric_character.g` checks that strict edge and computes
the exact projective primitive-$H^4$ character of the numbered No. 110
linear action. It writes `restriction_110_geometric_character.tsv` without
overwriting an existing file. The checked character bins
`(order, trace, count)` are `(1,22,1)`, `(3,-11,2)`, `(3,-2,4)`, and
`(3,4,2)`. `restriction_110_from_67.jl` includes the
No. 101/102 script solely to reuse its guarded No. 67 cache reader, finite
group table, and lattice helpers; inclusion does not start a stage.

The finite stage enumerates every $C_3$ subgroup of the $A_4$ symplectic
kernel and each of the twelve lifts in the generator coset of the order-three
quotient. It keeps precisely the order-nine subgroups with the required
kernel and quotient, checks `[9,2]`, quotients by full No. 67 conjugacy, and
compares the complete character. The lattice stage computes $S=T^\perp$,
the action on $T$, and the period and complementary lattices, checking
rank $S=12$, rank $T=10$, rank $P=10$, index 3, and period dimension
4. The final stage reconstructs each retained action and checks the root
obstruction. It retains every surviving parent-conjugacy class; it does not
silently select one if several remain.

From `remark/catalogue`, the intended sequence is:

```text
gap -q -b < restriction_110_geometric_character.g
julia --project=<OSCAR-environment> restriction_110_from_67.jl preflight
julia --project=<OSCAR-environment> restriction_110_from_67.jl groups
julia --project=<OSCAR-environment> restriction_110_from_67.jl lattices
julia --project=<OSCAR-environment> restriction_110_from_67.jl verify
```

The four Julia stages make separate `.groups.mrdi`, `.lattices.mrdi`, and
`.verified.mrdi` files, refusing to overwrite any existing output. Source
inputs and saved files are checked by later stages. No stage runs if the Julia
file is merely included. This establishes an exhaustive restriction *inside
the saved No. 67 action*; it does not separately recompute symplectic
saturation or prove uniqueness among all integral actions beyond that parent.

The GAP character/containment script and all Julia stages passed on
2026-10-01. The three MRDI outputs were reloaded after saving; the unique
parent-conjugacy class passes the lattice and root checks. See
`restriction_110_from_67_result.md` for the outcome.
