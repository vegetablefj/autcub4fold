# Abstract subgroup check for No. 51 to No. 81

Run `restriction_unique_81_from_51.g` in GAP to check the subgroup used by `compute_unique_restriction_81_from_51.jl`. The parent group is `SmallGroup(32,11)`. The script finds its unique normal Q8 subgroup and counts every conjugate of each candidate `[16,2]` subgroup. Exactly one candidate has intersection C4 with Q8 and quotient C4 by that intersection. It also checks that an element whose coset generates the quotient, together with the intersection, generates the order-16 subgroup.

The check passed in GAP 4.12.1, printing `No. 51 -> No. 81: unique normal [16,2] subgroup; Q8 intersection C4; quotient C4.`

This is an abstract group certificate. The Julia script separately constructs the subgroup in the saved No. 51 lattice action and checks the No. 81 ranks, period dimension, and lattice conditions. The catalogue lists No. 81 with group `[16,2]`, symplectic group C4, index 4, and dimension 2.

The bounded OSCAR run completed in about 653 seconds. It saved and reloaded
`restriction_complete_81_from_51.mrdi` with the ambient `S`, `T`, `P`, `K`,
the induced actions, and provenance. The root condition and independently
computed group ID passed. Its result is attached to row 81 of the numbered
catalogue. As in the other restrictions, generic-family identification uses
the established cubic-family classification; no separate equality test for
the two stable discriminant-kernel orders is claimed.
