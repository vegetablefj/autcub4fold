# Nos. 94 and 95 from the No. 24 integral action

The completed 2026-10-01 run identifies the two numbered lattice actions by restricting the saved No. 24 action. It does not rerun the ambient-lattice catalogue's lattice enumeration. The verified parent generator cache is `source_24_full_lattice_group.mrdi`; the exact subgroup classes and their integral restrictions are saved in `restriction_candidates_94_95_from_24.direct_groups.mrdi` and `restriction_candidates_94_95_from_24.direct_lattices.mrdi`.

The parent discriminant kernel has order 486. Its generators were extended from the rank-18 coinvariant lattice to the primitive cohomology lattice. The parent extra action has order 12 on the rank-4 invariant lattice. The direct subgroup script verifies that its twelfth power belongs to the explicit kernel and that this relation agrees after the 22-dimensional extension. Consequently the generated parent group has order `486 * 12 = 5832`.

For a subgroup with symplectic intersection `A ≅ S3` and image `C12` in the quotient, the script enumerates every `A ≤ N` and every compatible coset generator `b = n f`. It checks normalization and `b^12 ∈ A`, then takes conjugacy orbits under the whole parent group. This gave 1080 distinct `S3` subgroups of `N`, 81 raw target subgroups, and **three** parent-conjugacy classes of abstract type `[72,27]`. Each of the three orbits has size 27.

The saved geometric representatives of Nos. 94 and 95 act on the common smooth No. 24 cubic. Their exact primitive-cohomology character data are in `../gap_checks/cross_symplectic_95/pilot_94_95_primitive_character_summary.tsv`. For each lattice-side class, the evaluator computes the multiset of `(projective element order, primitive H4 trace)` using the rank-18 action on `S` and the rank-4 parent action on `T`. The quotient exponent is retained even when the `S` representation alone does not detect it. The comparison is exhaustive within the verified parent group:

| Parent-conjugacy class | Character match | Lattice result |
|---|---|---|
| 1 | No. 94 only | `rank(S)=14`, `rank(T)=8`, index 12, period dimension 1 |
| 2 | No. 95 only | `rank(S)=14`, `rank(T)=8`, index 12, period dimension 1 |
| 3 | neither | excluded by the geometric character |

For both retained classes, `T` has signature `(6,2)` and determinant of absolute value 324. In the saved basis the two `T` Gram matrices are literally equal, and the extra actions have characteristic polynomial `Φ12(x)^2 = (x^4-x^2+1)^2`. Their saved extra-action matrices differ; the full group-character test, not these coarse `T` invariants, assigns the two labels. The MRDI stores each full 22-dimensional extra action, its two symplectic generators, the embedded `S` and `T`, and the induced action on `T`.

As a separate consistency check, the No. 94 restriction obtained by squaring the saved No. 96 extra action agrees with the No. 24-derived No. 94 record in `rank(T)`, discriminant order, action order, and characteristic polynomial. This is not asserted to be an independent integral-conjugacy test.

The evaluator saves and reloads its MRDI output and sets `character_assignment_verified=true` with assigned classes 1 and 2. Its role is to determine the **restricted integral action**. It does not independently recalculate roots of `S` or prove that the displayed `S3` is the entire discriminant kernel of the child `S`; those assertions belong to the existing geometric classification and saturation argument, not to this restriction script.

The saved parent cache, group classes, and labelled lattice restrictions are
`source_24_full_lattice_group.mrdi`,
`restriction_candidates_94_95_from_24.direct_groups.mrdi`, and
`restriction_candidates_94_95_from_24.direct_lattices.mrdi`. The corresponding
group and lattice stages are `enumerate_restrictions_94_95_direct.jl` and
`evaluate_restrictions_94_95_from_24_direct.jl`. The current
`assembly/manifest.jl` selects classes 1 and 2 for Nos. 94 and 95.
