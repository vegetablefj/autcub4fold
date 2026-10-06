# Strict No. 107 restriction of the saved No. 60 action

`restriction_107_from_60.jl` reads the verified
`source_60_full_lattice_group.mrdi` cache and original OSCAR case 24,
result 1. It does not recompute `O(S)` or edit a numbered lattice catalogue.
The cached No. 60 projective action has a normal symplectic kernel of order
12, a quotient of order 2, and a full group of order 24.

First run `restriction_107_geometric_character.g` in GAP. It checks the
frozen direct strict No. 107 → No. 60 witness and writes the six-element
projective primitive-H⁴ `(order, trace)` histogram to
`restriction_107_geometric_character.tsv`, refusing to overwrite it.

From `remark/catalogue`, in the existing GAP and OSCAR
environments, run the stages in order:

```text
gap -q -b < restriction_107_geometric_character.g
julia --project=<existing OSCAR environment> restriction_107_from_60.jl preflight
julia --project=<existing OSCAR environment> restriction_107_from_60.jl groups
julia --project=<existing OSCAR environment> restriction_107_from_60.jl lattices
julia --project=<existing OSCAR environment> restriction_107_from_60.jl verify
```

The `groups` stage constructs all 24 exact rank-22 matrices, tests every
order-three kernel generator and every lift in the outer coset, and keeps
precisely the order-six subgroups with `C3` kernel intersection and
SmallGroup ID `[6,1]`. It partitions them by conjugacy under the **entire**
No. 60 parent, explicitly requiring the two nonconjugate `[6,1]` classes.
It saves both classes, their full geometric characters, and the character
match flags. Thus the `[6,1]` ID alone never assigns No. 107.

The `lattices` stage processes all character-matching classes. It constructs
embedded integral `S,T,P,K`, checks rank `S=12`, the order-two action on `T`,
signatures, and period dimension 4. The `verify` stage rechecks each saved
subgroup and geometric character, reconstructs the integral data, and tests
the root obstruction in `K`. It records every surviving class separately.

The three default outputs are
`restriction_107_from_60.groups.mrdi`,
`restriction_107_from_60.lattices.mrdi`, and
`restriction_107_from_60.verified.mrdi`. Every stage refuses to overwrite an
existing output, records its source inputs, and reloads its own file.
Custom paths are accepted after the stage name; `lattices` also accepts a
fourth argument to select one class. Run lattice stages with one Julia thread.

The 2026-10-04 run completed all stages. Exactly two parent-conjugacy classes
match the full geometric character. Both have the required lattice ranks,
index, and dimension and are root-free. The separate audit
`no107_geometric_normalizer_audit.md` proves that their geometric
restrictions are integrally equivalent via a normalizer of the No. 60 linear
group, using the classified unique No. 60 parent lattice class. It does not
identify either saved class number with the particular strict GAP witness.
Both complete candidates are retained in the side-by-side catalogue, where
the row-wise action remains unassigned.

The direct computation establishes the complete restriction search **inside
the saved No. 60 parent action**. It does not independently recompute the
child's symplectic saturation or assert global uniqueness outside that
parent.
