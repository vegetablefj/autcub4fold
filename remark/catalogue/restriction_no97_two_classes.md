# The two No. 97 restrictions inside No. 74

The No. 97 subgroup search yields two classes that are not conjugate within
the No. 74 projective group. Both have the required primitive-cohomology
character. This note shows that their **ordinary integral group actions**
are nevertheless equivalent. It does not identify their saved lattice
matrices literally or assert conjugacy by an automorphism of a generic
No. 74 cubic.

## Exact linear certificate

The reproducible check is `restriction_no97_two_classes.g`, run from this
directory in WSL GAP with
`gap -q -b -c 'Read("restriction_no97_two_classes.g");'`.
It reads the frozen list `fourfold_156.g` and changes no source data.

Write `A,B,ωI` for the first three frozen generators of No. 74; they generate
the frozen No. 73 symplectic kernel. Put `z=B²`. The two strict subgroups are
`H₁=⟨ωI,BA,z⟩` and `H₂=⟨ωI,A,z⟩`. The script passes to a permutation copy of
the 48-element parent only to enumerate its subgroups; it maps the two
eligible subgroups back to the original six-dimensional matrices. It checks
that `H₁,H₂` are exactly these two subgroups, distinct and normal in the
parent. Therefore they are not parent-conjugate.

Let `i=E(4)`, `P₃₄` exchange coordinates 3 and 4, and set
`Q=P₃₄·diag(1,1,1,1,−i,1)`. With the convention `g↦Q⁻¹gQ`, the script checks
the **matrix equalities** `Q⁻¹(BA)Q=A` and `Q⁻¹zQ=z`. Hence `Q⁻¹H₁Q=H₂`,
including the central scalar `ωI`. Next, with
`R=I₄⊕[[1,1],[1,−1]]`, it checks `R⁻¹H₂R=H₉₇`, the frozen strict No. 97
group. These are explicit `GL₆` conjugacies, not just agreement of traces.
As an independent character check, the 2-Sylow `C₂²` in each of the three
groups has degree-six traces `6,2,2,2`; its representation is
`1³⊕χ₁⊕χ₂⊕χ₃`.

## Integral conclusion and scope

A smooth No. 74 cubic is invariant under each subgroup; existence was
checked in `../../gap_classification/gap_smoothness/gap_large_abelian_smoothness.log`
(entry `large-74`). After either explicit coordinate conjugacy, its equation
lies in the smooth locus of the No. 97 invariant linear system. That locus
is a nonempty Zariski-open subset of a vector space, hence connected.
Equivariant parallel transport along it identifies the integral primitive
cohomology representations with the generic No. 97 representation. Thus the
two No. 74 restrictions yield the same ordinary integral No. 97 action,
with the group marking determined by `Q` (and by `R` when compared to the
frozen No. 97 group).

The two lattice candidate paths should both be retained as provenance;
either may serve as a representative after its separate integral/root
checks. The argument does not supply a parent-group conjugator, an equality
of stored matrices, or a Hodge isometry between arbitrary smooth members.
