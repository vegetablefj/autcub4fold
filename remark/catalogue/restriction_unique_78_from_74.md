# Restricting the No. 74 lattice action to No. 78

The numbered catalogue assigns `oscar/oscar_script_data.mrdi` case 29,
result 1 to No. 74 (`assembly/manifest.jl`). The saved result has symplectic
part `D_8`, rank `S = 15`, full projective group `[16,11]`, quotient index 2,
and period dimension 4. The catalogue lists No. 78 with symplectic part
`C4`, rank `S = 14`, full projective group `[8,3]`, quotient index 2, and
period dimension 5. The existing
`gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_cover_edges.g`
certificate records the strict linear-group embedding `78 -> 74`; the
corresponding geometric inclusion runs from family 74 into family 78.
Its record has `ok := true`, `method := "A_strict"`, source dimension 5,
target dimension 4, and linear group orders 24 and 48 respectively.

`restriction_unique_78_from_74.g` checks the finite-group step. For every
normal `D_8` in `SmallGroup(16,11)`, it tests that there is exactly one
`[8,3]` subgroup whose intersection with that chosen parent `D_8` is its
unique `C4`. The ambient OSCAR calculation chooses the actual parent
symplectic subgroup, then repeats this uniqueness test using its matrices.
The abstract GAP script completed successfully (exit code 0) with the
expected uniqueness line and no warnings.

`compute_unique_restriction_78_from_74.jl` reads the saved No. 74 result,
recovers the stable discriminant kernel of its embedded `S`, and extends its
generators into the saved rank-22 lattice. It adjoins the saved extra
isometry and checks the resulting group is `[16,11]`. It then extracts the
unique child `[8,3]`, using its `C4` rotation and an involution outside the
parent symplectic group. The restriction helper constructs the complete
ambient `S`, `T`, `P`, `K`, `P_action`, `T_action`, and `Lambda0` fields, along
with group and provenance fields. The expected ranks are `S = 14`, `T = 8`,
`P = 7`, and `K = 15`; the new period dimension is 5.

The first run saves verified parent generators in
`source_74_full_lattice_group.mrdi` for reuse. It also saves a complete
structural precheck in `restriction_complete_78_from_74.precheck.mrdi`.
By default, it then verifies the root obstruction and independently
recomputes the child group ID before saving
`restriction_complete_78_from_74.mrdi`. Equality of the stable
discriminant-kernel orders of `K` and `S` is not required for this
restriction: the generic-family assignment uses the previously established
cubic-family classification and the unique embedding above. Set
`RESTRICTION_VERIFY_FULL=0` only to stop after the precheck. The bounded
OSCAR run completed in about 366 seconds, saved and reloaded the full result,
and passed the root and group-ID checks. It is attached to row 78 of the
numbered catalogue; the previous catalogue remains available separately.

The restricted extra generator is a chosen involution in the unique child
group. Different involutions may give different matrices for the same
group action. Matching this representative literally to a selected cubic
equation remains optional and is not asserted by the lattice record.
