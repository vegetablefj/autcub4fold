# No. 105 computation

## Mathematical input

The symplectic subgroup is `C2^2`. We take the verified primitive pair
`S ⊕ T ↪ Lambda0` from No. 97, class 1, rather than deriving a new pair from
the equation. No. 105 is a proper subfamily of No. 97 with this same
symplectic subgroup; equivariant transport in the smooth No. 97 family
therefore identifies their embedded symplectic pair. The two No. 97
parent-relative classes give equivalent ordinary integral actions by
the separate coordinate-conjugacy and connectedness certificate in
[`../restriction_no97_two_classes.md`](../restriction_no97_two_classes.md).
This input choice is not a claim that all abstract `C2^2` actions have a
unique embedded pair. The ranks are `(12,10)` and the absolute discriminants are
`(1024,3072)`. Since `|A_Lambda0|=3`, a primitive extension has glue order
`sqrt(1024·3072/3)=1024`.

The chosen geometric order-six quotient generator has characteristic
polynomials `Phi1 Phi2^3 Phi6^3` on `T` and
`Phi1^3 Phi2 Phi3^3 Phi6` on `S`. Its three rational `T` blocks have
positive/negative signatures `(1,0)`, `(3,0)`, and `(4,2)`; the last block
contains the period. These are computed from the strict coordinate action
by the equivariant Jacobian-ring character formula. The complete exact
geometric certificate is `verify_no104_no105_character.g`.

Nos. 104 and 105 share the abstract full group `[24,13]`, quotient index 6,
symplectic rank 12, and dimension 2. Their order-six `T` characters differ:
No. 104 has `Phi1 Phi2 Phi3 Phi6^3`, while No. 105 has
`Phi1 Phi2^3 Phi6^3`. The same GAP certificate supplies an explicit
invertible change of coordinates from the six-edge Fermat presentation to
the displayed No. 105 generators. The character and this conjugacy are
used for the final numbered assignment.

## Search and completeness

1. `run_no105_T_enumeration.jl` enumerates order-six isometry classes in
   the genus of the exact input `T`, with characteristic and minimal
   polynomials, cyclotomic block ranks, and signatures fixed. It checks
   each returned underlying lattice against the input `T` and saves all
   26 exact-input actions. The genus search alone makes no geometric
   family assignment.
2. `check_no105_discriminant3.jl` checks the residual order-three part
   of `A_T` for all 26 actions. The glue is 2-primary, so an ambient
   action fixing `A_Lambda0` must fix this residual part. Exactly the
   action indices `1,2,10,13,14,20` pass this necessary filter.
3. `run_no105_extensions.jl` computes all fitting primitive extensions
   for those six actions. In particular it uses
   `first_fitting_isometry=false`: different fitting lifts can have
   different `S` characters. Each extension is checked for the required
   stable ambient action, full `S` character, root-free period
   complement, symplectic saturation, period dimension, and group ID.
   The 20 fitting extensions split into 18 with the wrong `S` character,
   one with a forbidden root, and one retained result.
4. The geometric identification uses the independent GAP certificate,
   the exhaustive integral search under these necessary constraints,
   and connectedness of the smooth invariant cubic locus. The saved raw
   MRDI has `numbered_assignment_claimed=false`, since this last step was
   proved separately. The generic full group is taken from the cubic
   family classification, not inferred from the rank-12 lattice search.

The unique retained result has `(rank S,rank T,rank P,rank K)=(12,10,6,16)`
and a period dimension of two. The source and final MRDI files record
their inputs. The completed read-only audit and independent
root/group recomputation are described in [no105_result.md](no105_result.md).

## Reproducing the checks

Run the light geometric certificate with GAP from this directory:

```sh
gap -q verify_no104_no105_character.g
```

It must reach the final Fermat-to-listed-coordinate conjugacy line; GAP's process
exit status alone is not the success marker. With OSCAR 1.8.x in the
selected Julia project, the saved lattice data can be inspected without
repeating the isometry enumeration:

```sh
julia --startup-file=no --project=/path/to/oscar-project audit_no105_extensions.jl
julia --startup-file=no --project=/path/to/oscar-project audit_no105_recompute.jl
```

The second Julia audit recomputes the expensive root and finite-group
checks on the one saved action. Full reproduction begins with
`run_no105_T_enumeration.jl`, followed by `run_no105_extensions.jl`.
These scripts use fixed output names and per-action checkpoints. Run a
fresh reproduction in an isolated copy containing the compact No. 97 source
and `../../../oscar/oscar_script.jl`, so the preserved MRDI results and logs
remain available for comparison. The original guarded shell launchers
record the WSL paths and memory limits of the completed run; they are not
portable configuration files.
