# Family 152: exact `Phi1^2 Phi2^2 Phi4 Phi16^2` lattice search

Julia 1.12.4; OSCAR 1.8.2.

The enumeration fixed order 16, characteristic polynomial Phi1^2 Phi2^2 Phi4 Phi16^2, minimal polynomial Phi1 Phi2 Phi4 Phi16, block ranks 2/2/2/16, and block signatures (2,0)/(2,0)/(2,0)/(14,2). These constraints distinguish this one-dimensional family from the other C16 family.
OSCAR enumerates isometry classes in the genus of the input lattice. The rank-22 even lattice of signature (20,2) with the cubic-fourfold primitive discriminant form has a unique class. Since S=0, the checks act directly on this ambient lattice: stable discriminant action, no short or long roots in K, and trivial stable orthogonal kernel of K.

Enumerated action classes: 24.
Retained geometric lattice outputs: 4.
Rejected for non-stable discriminant action: 12.
Rejected for roots: 8.
Rejected for a nontrivial stable symplectic kernel: 0.

| Output | rank(P) | rank(K) | Dimension | Stable kernel order | Cyclic group |
| ---: | ---: | ---: | ---: | ---: | --- |
| 1 | 16 | 6 | 1 | 1 | `C16 = [16,1]` |
| 2 | 16 | 6 | 1 | 1 | `C16 = [16,1]` |
| 3 | 16 | 6 | 1 | 1 | `C16 = [16,1]` |
| 4 | 16 | 6 | 1 | 1 | `C16 = [16,1]` |

The cubic equation independently gives the rational Hodge character in `maximal_family_character_result.md`. The signature of the full Phi16-isotypic block does not select a primitive eigenvalue on the negative complex line. A power of the lattice generator coprime to 16 may be required to match the displayed geometric generator, whose period character is zeta_16^7. Distinct retained generator actions need not give distinct cyclic group actions or geometric families.

Completed: 2026-09-27T08:33:48.800. Elapsed before saving: 35098.43 seconds.
Memory allocation/limit: 17179869184 bytes; charged peak: 6131093504 bytes.
