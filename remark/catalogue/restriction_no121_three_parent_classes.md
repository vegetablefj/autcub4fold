# The three No. 121 restrictions inside No. 74

This note resolves the three surviving parent-conjugacy classes in the
No. 121 pilot without identifying a preferred embedding inside No. 74. It
proves equivalence of the **ordinary integral group actions**, up to the
natural identification of the abstract No. 121 group. It does not assert
that the three subgroups are conjugate *inside* the No. 74 group or that
their saved matrices are equal.

## Inputs and finite check

Run `gap -q -b < restriction_no121_three_parent_classes.g` from this
directory. The script reads the frozen numbered generators in
`../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g`
and the strict linear containment witness in
`../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g`.
It does not alter either input.

The frozen No. 74 strict group has order 48. Quotienting by the scalar
cube roots gives the projective group `[16,11]`; the distinguished
symplectic subgroup, represented by frozen No. 73, is a normal `D_8` of
order 8. In the abstract `[16,11]`, all four normal `D_8` subgroups form
one orbit under its automorphism group. Hence an abstract identification
of the saved lattice parent with the geometric parent can align their
distinguished symplectic subgroups.

There are seven conjugacy classes of projective subgroups `B` with
`B ≅ C_2^2` and `|B ∩ D_8| = 2`. Precisely three have the No. 121
primitive-`H^4` character, whose `(element order, trace)` multiset is
`(1,22), (2,-10), (2,-2), (2,6)`. Their parent-conjugacy orbit sizes
are `2, 2, 1`. The recorded direct strict containment witness puts
frozen No. 121 in one of the orbit-size-two classes.

For **each** of the three classes, the full inverse image of `B` in the
strict linear group is the abelian group `[12,5]`. Its 2-Sylow subgroup
is `C_2^2` and acts on the six-dimensional variable space with trace
multiset `[0,2,4,6]`, exactly as in frozen No. 121. The three nonidentity
elements have distinct traces, so matching traces identifies the abstract
`C_2^2` unambiguously. The complete six-dimensional characters then
agree. Semisimplicity gives a complex linear conjugacy of each strict
2-Sylow representation with the frozen one. The central `C_3` consists
of scalar cube roots, so the conjugacy extends to the entire strict
linear group. This is stronger than agreement of the primitive-
cohomology histogram alone.

The accompanying pilot files
`restriction_pilot_80_121.groups.mrdi` and
`restriction_pilot_80_121.lattices.mrdi` retain the corresponding three
No. 121 candidates as lattice parent classes `3, 5, 6`, with orbit sizes
`1, 2, 2`. Their individual correspondence to the three *geometric*
parent classes depends on a choice of isomorphism of the parent groups;
it is unnecessary for the unlabelled No. 121 action.

## Passage to integral cohomology

Fix one of these strict No. 121 subgroups after the linear conjugacy.
Its invariant cubic forms constitute a vector space. The smooth locus is
a nonempty Zariski-open subset: a smooth member of the No. 74 family is
invariant under the subgroup. This smooth locus is connected. Therefore
equivariant parallel transport in the smooth No. 121 family identifies
the integral primitive-cohomology actions at the No. 74 member and at a
generic No. 121 member. Repeating for the other two classes proves that
the three restrictions yield the same ordinary integral action up to
the trace-determined group identification.

This argument does not give a literal equality of the three saved
`Lambda0` matrices, a conjugating element of the No. 74 group, or a
Hodge isometry between arbitrary members of the No. 121 family. A
catalogue may choose any one verified path as representative while
preserving all three paths and the parent-class labels as provenance.
