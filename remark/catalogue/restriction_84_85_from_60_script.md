# Nos. 84 and 85 inside the saved No. 60 full lattice action

`restriction_84_85_geometric_characters.g` reads the frozen GAP family
matrices and positive strict-containment witnesses. For each of Nos. 84 and
85 it verifies the linear group of order 36, the scalar kernel of order 3,
and its direct strict embedding into the No. 60 linear group of order 72.
It then writes the complete twelve-element projective `(order, primitive-H⁴
trace)` histogram to `restriction_84_85_geometric_characters.tsv`. It
refuses to overwrite an existing TSV. Both scripts pin the expected complete
characters from the displayed S₃ action: No. 84 has bins
`(1,22):1, (2,-2):4, (2,6):3, (3,4):2, (6,-2):2`; No. 85 has
`(1,22):1, (2,-10):1, (2,-2):3, (2,6):3, (3,4):2, (6,2):2`.

`restriction_84_85_from_60.jl` reads the verified
`source_60_full_lattice_group.mrdi` cache and original OSCAR case 24,
result 1. It does not recompute `O(S)` or modify No. 107 outputs. The cached
No. 60 projective group has a normal symplectic kernel of order 12, a
quotient of order 2, and a full order of 24.

From `remark/catalogue`, in the existing GAP and OSCAR
environments, run one stage at a time:

```text
gap -q -b < restriction_84_85_geometric_characters.g
julia --project=<existing OSCAR environment> restriction_84_85_from_60.jl preflight
julia --project=<existing OSCAR environment> restriction_84_85_from_60.jl groups
julia --project=<existing OSCAR environment> restriction_84_85_from_60.jl lattices
julia --project=<existing OSCAR environment> restriction_84_85_from_60.jl verify
```

Run the OSCAR stages with one Julia thread. Each output stage refuses to
overwrite an existing file, records its source inputs, and
reloads its own output. The default outputs are
`restriction_84_85_from_60.groups.mrdi`,
`restriction_84_85_from_60.lattices.mrdi`, and
`restriction_84_85_from_60.verified.mrdi`; a distinct output path may be
passed after each stage name.

The `groups` stage enumerates **all** S₃ subgroups of the order-12 kernel
and all lifts from the other No. 60 coset. It deduplicates the resulting
S₃-by-C₂ subgroups, partitions them under conjugacy by the **entire** No.
60 group, and saves every class with its SmallGroup ID, orbit size, exact
rank-22 matrices, and full `(order, trace)` histogram. The `[12,4]` ID is
only one filter: the two numbered families are compared separately against
their GAP geometric histograms. A class matching both remains associated
with both numbers, and multiple classes matching either number are kept.

The `lattices` stage examines every character-matching `[12,4]` class. It
constructs the embedded common S₃ invariant lattice `T`, its orthogonal
coinvariant lattice `S`, and the period/complement lattices `P,K`. It checks
rank `S=14`, rank `T=8`, quotient action order 2, rank `P=5`, rank `K=17`,
and period dimension 3. The `verify` stage independently reconstructs the
saved subgroup and its integral lattice data and tests the cubic-fourfold
root obstruction in `K`. All surviving classes are recorded separately.

The 2026-10-04 run completed all four stages. It found four parent-conjugacy
classes, all of type `[12,4]`: classes 2 and 4 match No. 84, while classes
1 and 3 match No. 85. All four have the required lattice ranks and period
dimension and are root-free. The separate geometric normalizer audit in
`no107_geometric_normalizer_audit.md` shows that the two restrictions for
each numbered family are integrally equivalent, subject to the verified
identification of the No. 60 parent action; it does not label an OSCAR class
by the strict GAP witness. Accordingly, the side-by-side catalogue keeps
both complete candidates and leaves the row-wise action unassigned.

The search is exhaustive **inside the saved No. 60 parent action**. It does
not independently recompute the child's symplectic saturation or assert
global uniqueness outside that parent.
