# Restricting the lattice action of No. 51 to No. 82

This pilot changes the symplectic part. No. 51 has symplectic group Q8, full projective group `[32,11]`, and rank(S) = 17. No. 82 has symplectic group C4, full projective group `[16,6]`, and rank(S) = 14. A strict linear inclusion is recorded in `gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_cover_edges.g`.

The GAP precheck `restriction_pilot_82_from_51.g` verifies that `[32,11]` has a unique normal Q8 subgroup and a unique normal `[16,6]` subgroup. Their intersection is C4. Thus the relevant subgroup of the parent group has no abstract group-theoretic ambiguity.

The OSCAR script `restriction_pilot_82_from_51.jl` reads case 21, result 3 of `oscar/oscar_script_data.mrdi`, the saved ambient extension assigned to No. 51 by the current `assembly/manifest.jl`. The saved record contains the extra ambient isometry but not generators of the full stable discriminant kernel of S_51. The script computes that kernel for the embedded S_51 once, extends its generators by the identity on the rational orthogonal complement, and adjoins the saved extra isometry. It then selects `[16,6]` and forms the invariant and coinvariant lattices of its symplectic C4.

The bounded WSL run used Julia 1.10.11 and OSCAR 1.8.2, with `MemoryHigh=4 GiB`, `MemoryMax=6 GiB`, no swap, and a 20-minute timeout. It finished in about 302 seconds and verified:

| Check | Result |
| --- | --- |
| Parent symplectic kernel | order 8, SmallGroups ID `[8,4]` |
| Recovered full parent lattice group | order 32, ID `[32,11]` |
| Selected child group and intersection | order 16, ID `[16,6]`; intersection C4 |
| Restricted lattices | rank(S_82) = 14; rank(T_82) = 8 |
| T_82 | signature (6,2); determinant 3072 |
| Extra action on T_82 | order 4; characteristic polynomial `(x^2+1)^3 (x^2-1)` |

The Phi4 part has rank 6, giving period dimension `6/2 - 1 = 2`, as in No. 82. The script saved and reloaded the lattices and one extra-action representative in `restriction_pilot_82_from_51.mrdi`.

The extra generator was chosen as an element whose coset generates the quotient of `[16,6]` by its symplectic C4. Its inverse or another generator can yield a different matrix for the same group action. The later `complete_restriction_82_from_51.jl` run checked the root condition and group ID, then saved and reloaded `restriction_complete_82_from_51.mrdi` with ambient `S`, `T`, `P`, `K`, both induced actions, and provenance. This representative has been attached to row 82 of the numbered lattice catalogue. Matching its matrix literally to a particular equation-level generator remains optional; the catalogue records the subgroup action, not a distinguished coordinate matrix. The pilot alone does not settle other subgroup-derived rows.
