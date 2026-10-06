# Selecting lattice representatives for Nos. 84, 85, and 107

Historical planning note: the representative selection described below
has since been incorporated into the
[current ambient catalogue](ambient_completion/README.md). The two
complete root-free No. 60 candidates for each numbered family remain
in `restriction_84_85_from_60.verified.mrdi` and
`restriction_107_from_60.verified.mrdi`. The numerical parent-class
labels are internal to the saved OSCAR action; they have not been
matched to the frozen GAP strict embeddings.

## Geometric equivalence of each pair

Let `L` be the frozen No. 60 subgroup of `GL(6,C)`, including the central
scalar `E(3) I_6`, and let `V` be its invariant space of cubic forms. The
repository-local GAP certificate in `no60_geometric_normalizer_certificate.g` verifies the
invertible rational matrix

```text
M = [ [-1, 0, 0, 0, 0, 0],
      [ 0, 1, 0, 0, 0, 0],
      [ 0, 0,-1, 0, 0, 0],
      [ 0, 0, 0,-1, 0, 0],
      [ 0, 0, 0, 0, 2, 0],
      [ 0, 0, 0, 0,-1, 1] ].
```

The certificate uses three frozen strict witnesses in the same original
coordinates as `Families` in `fourfold_156.g`. It independently rechecks
their subgroup inclusions, rather than combining that input with the public
positive-edge file, whose witnesses have been converted to the displayed
coordinates. The two coordinate conventions describe the same containments;
this local choice leaves the public edge results unchanged.

It checks the exact linear equalities `M L M^{-1}=L` and, for the lifted
No. 107 subgroup `H` selected by the strict GAP witness,
`M H M^{-1}=H'`, where `H'` is the other eligible projective `S3`
subgroup. The same `M` swaps the two eligible geometric `D12` subgroups
for No. 84 and swaps the two for No. 85. The two numbered `D12` types are
kept separate by their different complete `(projective order,
primitive-H^4 trace)` characters. The check works with the actual linear
group, not only its projective image; in particular, it fixes the central
scalar and does not leave an unexamined semi-invariant twist. The value
`det(M)=-2` is harmless: a projective coordinate change need only lie in
`GL(6,C)`, not `GL(6,Z)`.

Conjugation by `M` preserves `V`. The smooth cubics form a nonempty
Zariski-open subset `U` of its projectivization: nonemptiness follows from
the smooth No. 60 family, and a nonempty open subset of a complex
projective space is connected. Hence `U` is path connected. For a smooth
`L`-invariant cubic `X`, the coordinate transformation `M` maps `X` to
another member of `U`. Choose a smooth path there from `M(X)` back to
`X`. The primitive integral fourth cohomology is a local system over this
smooth family. Parallel transport commutes with the *fixed, labeled* `L`
action and preserves the cup-product form and the hyperplane-square
class. Composing it with the cohomology isomorphism induced by `M` gives
an integral isometry of the primitive lattice that exchanges the two
restricted subgroup actions. This establishes existence of an integral
intertwiner; it does not produce its `22 x 22` matrix in an OSCAR basis.

This comparison takes place on the No. 60 subfamily, but it also describes
the action of each numbered child family. For every lifted child subgroup
`H`, its invariant cubic space is a vector space containing the relevant
smooth No. 60 cubic. Its nonempty smooth locus is connected. The labeled
`H` action on integral cohomology is therefore locally constant up to
parallel-transport conjugacy as one moves from that special No. 60 member
to a general member of the child family. The strict GAP edge supplies the
required conjugacy of the frozen child representation into `L`. No claim
that `M` fixes an individual cubic, or that it preserves every point of a
child's parameter space, is needed. It maps a child representation to a
linearly conjugate one and preserves the common No. 60 smooth subsystem.

## Passage to the saved OSCAR candidates

The preceding argument concerns the geometric No. 60 action. To identify
it with the saved case-24/result-1 action, one uses the lattice-theoretic
classification of integral actions, together with the No. 60
geometric identification: the
`(D12, generic index 1, index 2, GAP ID (24,14), dimension 2)` row has a
unique relevant lattice-theoretic parent class. This is a statement about
the *whole parent action*, not merely matching its group ID or a trace
histogram. The equivalence includes an abstract group isomorphism
preserving the non-symplectic character and an integral isometry
intertwining all group elements. Consequently, it carries the eligible
geometric subgroup pair to the corresponding saved subgroup pair.
The complete subgroup searches inside the saved parent find exactly two
character-matched, root-free candidates for No. 107 and exactly two for
each of Nos. 84 and 85. The geometric exchange therefore proves that the
two saved candidates *within each numbered row* are lattice-theoretically
equivalent. It does not equate a No. 84 candidate with a No. 85 candidate.

All three child indices are `2`. Since their symplectic subgroup acts
trivially on its invariant lattice `T`, every lift of the nontrivial
quotient element has the same induced `T` action within a fixed complete
candidate. Thus selecting a complete candidate also gives a coherent
representative `T_extra_action`; there is no separate choice of an extra
generator on `T` to reconcile. A full saved result, its embedded `S,T`
and `T` action must nevertheless always come from the *same* candidate.

The conclusion is **an integral lattice-equivalence class**, not literal
equality of the candidates' matrices or embedded lattices in their saved
bases. It is enough to use either complete candidate as a row-wise
representative *up to lattice-theoretic equivalence*. It is not enough to
say that that candidate has been identified with the particular strict
GAP witness, to assign a witness-to-OSCAR class-number correspondence, or
to claim a new independent proof of symplectic saturation or global
integral-action uniqueness for the child. The parent identification is an
essential mathematical input; matching `(order, trace)` histograms or
reading `number_of_data=1` alone would not supply it. The distinction
between lattice-theoretic and geometric equivalence, including the possible
two type-IV components at index `2`, applies here. The geometric
normalizer here supplies an actual complex-linear exchange of the two
parent subgroup realizations, so that component issue does not obstruct
the stated equivalence of their restricted *integral* actions.

A selected representative is safe for reporting this child's integral
action class. It is **not**, by itself, a labeled model for a subsequent
restriction along a particular frozen GAP edge from another family. Such a
calculation must either identify the generator correspondence or enumerate
and compare the relevant embeddings in the selected abstract lattice
action. Keeping both original parent paths makes that distinction visible.

## Future side-by-side catalogue import (not yet implemented)

1. Start from the newest independently verified 156-row side-by-side MRDI,
   verify that Nos. 84, 85, and 107 still contain the
   same two complete candidates and paths as in the existing partial
   catalogue. Do not edit any baseline or restriction MRDI.
2. Use a deterministic rule, such as the candidate with the smaller saved
   parent class number, **only to choose a coordinate representative**.
   Write a field such as `representative_choice` recording the candidate
   position, the deterministic rule, and
   `strict_witness_class_identified = false`. Leave
   `selected_no60_parent_class` unassigned if that field denotes a match to
   the strict GAP embedding. The note and status must say “representative
   of the proved lattice-equivalence class,” not “identified OSCAR class.”
3. Populate `S_input`, `T_input`, `T_in_ambient`, `T_extra_action`, and
   `saved_result` consistently from that one complete candidate. No. 107
   already has common embedded `S,T` in the partial row; check these against
   the chosen result. For Nos. 84 and 85, filling the fields from a chosen
   result changes their basis-dependent row model and must be labeled as a
   representative, since the two candidate embeddings are not literally
   the same. Preserve `candidate_saved_results` and `no60_parent_paths`
   exactly, including both candidates' original class numbers and sources.
4. Independently verify the new file: all 156 keys and unrelated rows are
   unchanged; the frozen baseline, both partial-result stages, the
   normalizer certificate, this proof note, and the importer are checked;
   each new row's fields agree *literally* with its recorded chosen
   candidate; the other candidate remains complete and root-verified;
   none of the new metadata asserts strict-witness class identification.
   The expected coverage change is `known_T + 2` and assigned `T` actions
   `+ 3`, because No. 107 already has a common `T` but none of the three
   has a row-wise extra action. The count of `pending_lattice_data` rows is
   unchanged. Publish to a new filename only after reloading the staging
   file and passing the independent verifier.

The normalizer certificate is now stored in this directory. The earlier
`../../tmp/no107_abstract_probe.g` remains only an exploratory derivation
of the explicit matrix and is not needed to rerun the archived check.
