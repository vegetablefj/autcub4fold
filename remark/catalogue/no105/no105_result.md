# No. 105: integral lattice action

The displayed No. 105 action is linearly conjugate to an action on the Fermat
cubic. It has projective group `[24,13]`, generic symplectic subgroup `C2^2`,
and index six. The exact Jacobian-ring certificate
[verify_no104_no105_character.g](verify_no104_no105_character.g)
computes the characteristic polynomials of the chosen order-six generator:
`Phi_1 Phi_2^3 Phi_6^3` on rank-ten `T` and
`Phi_1^3 Phi_2 Phi_3^3 Phi_6` on rank-twelve `S`. It also gives an explicit
linear conjugacy between the six-edge Fermat generators used for the
character calculation and the listed coordinate matrices for No. 105.
The same certificate distinguishes the No. 104 character.

The [T-action enumeration](no105_T_enumeration.mrdi) produced 26 exact-lattice
order-six classes with this `T` character. The residual order-three part of
`A_T` must be fixed by an ambient stable action; the exact
[discriminant check](check_no105_discriminant3.jl) leaves indices
`1, 2, 10, 13, 14, 20`. The six actions yield 20 fitting primitive
extensions. Eighteen fail the required `S` character, one has a root
obstruction, and precisely one survives all tests. No extension is rejected
for nonstable ambient action, failed saturation, or wrong projective group.

The unique [saved result](no105_extensions.mrdi) is source `T`-action 1,
extension 1, with group `[24,13]`, period dimension two, and ranks
`(S,T,P,K,Lambda_0)=(12,10,6,16,22)`. Its absolute discriminants are
`|A_S|=1024`, `|A_T|=3072`, and `|A_Lambda_0|=3`; the glue order is 1024.
The saved root and symplectic-saturation tests both pass. The separate
[basis audit](audit_no105_bases.jl) confirms that the original search input
`T` and the enumerated `T` action are isometric but have different displayed
Gram matrices. The action and the embedded `T` image have matching Gram
matrices. The numbered catalogue therefore stores the original search input
separately as `T_search_input`, while `T_input` uses the action's basis.
The separate
[read-only audit](audit_no105_extensions.jl) reloads the MRDI, checks input
inputs, counts, lattice invariants, isometry orders and characters, stable
discriminant action, and the stored group and verification flags. A second
[read-only recomputation](audit_no105_recompute.jl) independently confirms
the absence of short and long roots, discriminant-kernel orders `4` for both
`S` and `K`, and projective group ID `[24,13]`; its
[log](no105_audit_recompute.log) records a successful exit.

The raw MRDI intentionally has `numbered_assignment_claimed=false`: its
search is lattice-theoretic and does not itself compare equations. The
independent exact Fermat-to-listed-coordinate conjugacy certificate supplies that
geometric identification, while the unique surviving integral action gives
the corresponding lattice datum. The Fermat cubic is smooth, and the smooth
locus in the No. 105 invariant linear system is a nonempty connected open
subset. Parallel transport there preserves the displayed group action up to
integral conjugacy, so this identifies its action on the whole family.
This does not by itself determine a
larger generic automorphism group: `rank(S)=12`, so the
group-recovery lemma for `rank(S)>=13` does not apply here. The full generic
group is handled by the separate cubic-family classification. The bounded
attempts, corrections, and
resource settings are recorded in [process.md](process.md).
