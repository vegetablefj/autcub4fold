# Staged No. 101/102 restrictions inside No. 67

Historical stage note: its import status and two-class ambiguity below refer
to the 2026-10-01 intermediate catalogue. The current selected sources for
Nos. 101 and 102 are recorded in the [156-row source table](ambient_completion/sources/family_156_sources_current.md).

All stages below were run on 2026-10-01. At that stage the numbered
catalogue builder and verifier had not imported these results. See
`restriction_101_102_from_67_result.md` for the stage outcomes and the two
No. 67 candidates for No. 102.

The frozen No. 67 parent is case 26, result 2 of
`../../oscar/oscar_script_data.mrdi`: primitive-lattice rank 22, symplectic
coinvariant rank 16, abstract full PGL group `[36,11]`, symplectic kernel
`A4` of order 12, nonsymplectic index 3, period dimension 2. The parent
action's single nonsymplectic generator is saved, but a complete rank-22
generator set for its symplectic kernel was initially **not** cached. The separate
`prepare` stage computes the discriminant kernel of `O(S)`, checks that its
order is 12, extends every generator to the frozen rank-22 lattice, and
saves/reloads a new, no-overwrite cache. The run produced
`source_67_full_lattice_group_restriction_101_102.mrdi`.

The frozen strict GAP containment table has one direct `A_strict` edge for
each of No. 101 and No. 102 into No. 67. Both targets have symplectic kernel
`C2^2`, rank 12, index 3, and full order 12. No. 101 has group `[12,5]`,
dimension 4 and expected period rank 10; No. 102 has group `[12,3]`,
dimension 3 and expected period rank 8. The companion GAP script independently
checks the saved direct conjugation witnesses and freezes the exact
projective primitive-H4 characters. It refuses to overwrite its TSV.

Run from `remark/catalogue` in the tested GAP/OSCAR
environment, in this order:

```text
gap -q -b < restriction_101_102_geometric_characters.g
julia restriction_101_102_from_67.jl prepare
julia restriction_101_102_from_67.jl preflight
julia restriction_101_102_from_67.jl groups
julia restriction_101_102_from_67.jl lattices
julia restriction_101_102_from_67.jl verify
```

The finite stage reconstructs all 36 parent elements from the saved A4
generator matrices and one quotient lift. It checks the full group's
`[36,11]` ID, enumerates every `C2^2` subgroup of A4 and every one of the
12 lifts above the quotient generator, forms all eligible order-12
subgroups, tests each target SmallGroup ID and frozen character, and
partitions by conjugacy in the **full saved No. 67 parent**. Each matching
class is retained. The lattice stage takes the common fixed lattice of two
symplectic generators (not a single involution), computes its orthogonal
coinvariant, checks index, signatures, period rank and dimension, and saves
all passing classes. The last stage reconstructs each subgroup and lattice
independently and checks roots, retaining root-free and obstructed classes
separately.

Every output stage checks the frozen OSCAR source, the GAP family
and direct-witness source files, the companion script and other preparation
inputs. Later stages also check the cache and character TSV. Outputs never
overwrite existing paths. A changed input after `prepare` intentionally
invalidates its cache.

The exhaustiveness claim is only for `C2^2`-by-`C3` subgroups in this saved
No. 67 lattice action. Character, lattice and root matching do not by
themselves prove a unique numbered-family assignment or symplectic
saturation in the full cubic-fourfold automorphism group. Those claims are
explicitly left false in saved records. The order-12 discriminant kernel and
resulting full `[36,11]` action passed their run-time checks; this is still
not an independent global uniqueness or saturation proof.
