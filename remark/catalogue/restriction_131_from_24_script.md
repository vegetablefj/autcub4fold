# No. 131 from the cached No. 24 integral action

This is a staged, bounded restriction computation. It reads
`source_24_full_lattice_group.mrdi` and the original OSCAR case 8/result 3;
it never recomputes the rank-18 discriminant kernel or changes existing
catalogues. The saved parent has kernel order 486, cyclic quotient order 12,
and projective order 5832. The numbered No. 131 row has rank `S=8`,
generic index 1, full index 12, dimension 1, and projective ID `[24,9]`.

`restriction_131_geometric_character.g` verifies the direct strict
No. 131 → No. 24 witness in the frozen positive-edge table, then computes
the projective `(order, primitive-H4 trace)` histogram from the displayed
No. 131 matrices. It writes
`restriction_131_geometric_character.tsv` only if absent. If present, it
checks every line against the exact recomputation and prints `PASS` only
when they agree. The current TSV has 11 bins summing to 24 elements.

Run from this directory in the existing GAP and OSCAR environments:

```text
gap -q -b < restriction_131_geometric_character.g
julia --project=<existing OSCAR environment> restriction_131_from_24.jl preflight
julia --project=<existing OSCAR environment> restriction_131_from_24.jl groups
julia --project=<existing OSCAR environment> restriction_131_from_24.jl lattices
julia --project=<existing OSCAR environment> restriction_131_from_24.jl verify
```

`groups` enumerates every involution `t` in the 486-element kernel and each
coset lift `n f`, retaining exactly those with `(n f) t (n f)^{-1}=t` and
`(n f)^12 ∈ <t>`. These conditions imply the candidate group has kernel
intersection `C2` and quotient `C12`. It removes duplicate `n f` choices
modulo `<t>`, then partitions candidates under the full parent conjugation
action. For every resulting class it checks the SmallGroup ID by the regular
action. Only `[24,9]` classes are saved, each with full rank-22 generators
and its exact primitive character. The group stage works in the rank-18
kernel action; it does not construct a rank-22 matrix group of order 5832.

`lattices` constructs the embedded rank-22 `S,T,P,K` and extra action for
character-matched classes that pass rank, signature, index, and dimension
filters. `verify` rebuilds the group context from the frozen parent, checks
the saved subgroup, character and integral data, and tests roots in `K`.
Its output is a restriction *inside the saved parent*. A unique matching
root-free class there does not itself prove global integral uniqueness or
independently recompute the child's symplectic saturation.

The default outputs are
`restriction_131_from_24.groups.mrdi`,
`restriction_131_from_24.lattices.mrdi`, and
`restriction_131_from_24.verified.mrdi`. Every stage refuses to replace an
existing output, records its source inputs, and reloads what it
saves. Paths can be passed explicitly to use another output name; see the
stage argument checks at the bottom of the Julia script.
