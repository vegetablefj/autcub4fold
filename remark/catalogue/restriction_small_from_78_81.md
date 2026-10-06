# Small subgroup restrictions of Nos. 78 and 81

`restriction_small_from_78_81.jl` uses the already verified complete rank-22
actions in `restriction_complete_78_from_74.mrdi` and
`restriction_complete_81_from_51.mrdi`. It enumerates every eligible subgroup
of those *saved* groups, then compares the exact projective order/primitive
\(H^4\) trace histogram with the strict geometric group before constructing
the ambient \(S,T,P,K\) restriction through `restriction_functions.jl`.
It never recomputes the full stable discriminant kernel of a new \(S\).

The GAP precursor `restriction_small_78_81_geometric_characters.g` reads the
frozen 156 geometric groups, verifies each of the six direct strict linear
containment matrices, and writes
`restriction_small_78_81_geometric_characters.tsv`. It checks that Chenevert's
trace is independent of the central cubic scalar. The Julia `preflight` checks
the six table rows, exact direct-containment metadata, all character totals,
and both saved parent group IDs. `groups` enumerates exact subgroups and
parent-conjugacy classes, `lattices` computes the full ambient prechecks, and
`verify` tests root-freeness. Every Julia stage refuses to overwrite its
output and checks source records before producing later outputs.

Run from this directory, in the tested GAP and OSCAR environments:

```text
gap -q restriction_small_78_81_geometric_characters.g
julia restriction_small_from_78_81.jl preflight
julia restriction_small_from_78_81.jl groups
julia restriction_small_from_78_81.jl lattices
julia restriction_small_from_78_81.jl verify
```

For a single-class lattice smoke, supply a fresh output filename, the groups
file and `parent:class`, for example
`julia restriction_small_from_78_81.jl lattices smoke.mrdi restriction_small_78_81.groups.mrdi 78:3`.
The tested WSL runs used one Julia thread, no swap, `MemoryHigh=3 GiB`,
`MemoryMax=4 GiB`, and an external timeout.

| Child | Parent/class | Extracted group | Symplectic intersection | Quotient | Rank \(S\) | Rank \(P\) | Dimension | Exact character |
| ---: | --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| 77 | 78/2 | `[4,1]` | `C4` | 1 | 14 | 8 | 6 | unique |
| 119 | 78/1 | `[2,1]` | `C2` | 1 | 8 | 14 | 12 | unique |
| 120 | 78/4 | `[4,2]` | `C2` | 2 | 8 | 12 | 10 | unique |
| 122 | 78/3 | `[4,2]` | `C2` | 2 | 8 | 8 | 6 | unique |
| 79 | 81/1 | `[8,2]` | `C4` | 2 | 14 | 6 | 4 | unique |
| 124 | 81/2, 81/3 | `[8,2]` | `C2` | 4 | 8 | 12 | 5 | both match |

The `lattices` output saved and reloaded all seven records. Its match counts,
in target order 77, 119, 120, 122, 79, 124, are `[1,1,1,1,1,2]`.
The subsequent `verify` output
`restriction_small_78_81.verified.mrdi` passed and reloaded with the
root obstruction excluded for every class, including both No. 124 paths.
The checked extracted subgroup IDs are the IDs in the table; the helper's
optional full-stable-kernel group ID was intentionally not computed.

The two \(V_4\) subgroups in the saved No. 78 `D8` are separate classes.
The No. 120 character has two trace \(-10\) involutions; the No. 122 character
has two trace \(-2\) involutions. Their period dimensions independently differ
by 10 versus 6. Group ID alone would not distinguish them.

The two No. 124 classes in the saved No. 81 `C4 x C4` are not conjugate
*inside* that group, and both pass the character and period-dimension tests.
The GAP precursor also checks the explicit LA-044/LA-022 source model. Put
\(A=\mathrm{diag}(1,1,1,-i,-1,1)\),
\(C=\mathrm{diag}(-i,-1,1,1,1,1)\), and let \(P=(1\ 4)(2\ 5)(3\ 6)\).
The frozen `gap_liftable_abelian_data.g` records identify LA-044 with
\(\langle\omega I,A,C\rangle\) and LA-022 with
\(H_A=\langle\omega I,A^2,C\rangle\). The script verifies
\(P^{-1}H_A P=H_C=\langle\omega I,A,C^2\rangle\). It separately checks that
the `sourceToStandardMatrix` fields for numbered Nos. 81 and 124 in
`remark/input/family_generators.g` carry these source groups into the
canonical geometric groups. The block cubic
\(F_0=x_1^2x_2+x_2^2x_3+x_3^3+x_4^2x_5+x_5^2x_6+x_6^3\) is fixed by
\(A,C,P\). Each ternary block is smooth: its three derivatives
\(2uv,u^2+2vw,v^2+3w^2\) have only the zero common affine solution.
Thus \(P\) is an actual automorphism at \(F_0\) and induces an integral
conjugacy between the two subgroup actions there. Connectedness of the smooth
No. 81 invariant-cubic locus transports this unlabelled action class to
generic members. This does not assert that \(P\) acts on every generic cubic,
or identify a particular labelled generator in the two lattice records.

The MRDI files intentionally set `numbered_assignment_claimed=false` and
retain both No. 124 candidates. Strict containment and the character/dimension
filters give candidate identifications within a classified geometric parent.
There is no explicit 6-by-6 to 22-by-22 intertwiner identifying the saved
parent group with the chosen geometric matrix model, and no new global
lattice-action enumeration or symplectic-saturation claim. The `verify` stage
checks the extracted subgroup ID directly from its rank-22 generators and
the root obstruction; it does not conflate that ID with the full stable
kernel of \(S\).
