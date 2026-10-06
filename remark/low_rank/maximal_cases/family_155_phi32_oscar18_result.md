# Family 155: exact `Phi1 Phi2 Phi8 Phi32` lattice search

Julia 1.10.11; OSCAR 1.8.2.

The enumeration fixed order 32, the complete characteristic and minimal polynomials, the ranks 1/1/4/16, and block signatures (1,0)/(1,0)/(4,0)/(14,2). No generator-root shortcut was used.
OSCAR enumerates isometry classes in the genus of the input lattice. Here the rank-22 even lattice of signature (20,2) and discriminant form of the cubic-fourfold primitive lattice has a unique class, so the returned lattices represent the required ambient lattice. Since S=0, each action is tested directly. The checks require stable discriminant action, no short or long roots in K, and |tilde O(K)|=1.

Enumerated action classes: 48.
Retained geometric lattice outputs: 8.
Rejected for non-stable discriminant action: 24.
Rejected for roots: 16.
Rejected for a nontrivial stable symplectic group: 0.

| Output | rank(P) | rank(K) | Dimension | Stable kernel order | Cyclic group |
| ---: | ---: | ---: | ---: | ---: | --- |
| 1 | 16 | 6 | 0 | 1 | `C32 = [32,1]` |
| 2 | 16 | 6 | 0 | 1 | `C32 = [32,1]` |
| 3 | 16 | 6 | 0 | 1 | `C32 = [32,1]` |
| 4 | 16 | 6 | 0 | 1 | `C32 = [32,1]` |
| 5 | 16 | 6 | 0 | 1 | `C32 = [32,1]` |
| 6 | 16 | 6 | 0 | 1 | `C32 = [32,1]` |
| 7 | 16 | 6 | 0 | 1 | `C32 = [32,1]` |
| 8 | 16 | 6 | 0 | 1 | `C32 = [32,1]` |

The cubic equation independently supplies the rational Hodge character in `maximal_family_character_result.md`. The block signature does not distinguish the primitive 32nd root assigned to the negative complex line; an odd power of the lattice generator may be needed to match the displayed geometric generator (whose character is zeta_32^11). This integral calculation does not itself identify which retained class is realized by that equation if more than one class survives.

Completed: 2026-09-26T02:56:11.283. Elapsed before saving: 3080.01 seconds.
Memory ceiling: 6442450944 bytes; charged peak: 4031815680 bytes.
