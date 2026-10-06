# Family 156: exact `Phi3 Phi12 Phi48` lattice search

Julia 1.12.4; OSCAR 1.8.2.

The enumeration fixed order 48, the complete characteristic and minimal polynomials, the ranks 2/4/16, and block signatures (2,0)/(4,0)/(14,2). No generator-root shortcut was used.
OSCAR enumerates isometry classes in the genus of the input lattice. Here the rank-22 even lattice of signature (20,2) and discriminant form of the cubic-fourfold primitive lattice has a unique class, so the returned lattices represent the required ambient lattice. Since S=0, each action is tested directly. The checks require stable discriminant action, no short or long roots in K, and |tilde O(K)|=1.

Enumerated action classes: 16.
Retained geometric lattice outputs: 8.
Rejected for non-stable discriminant action: 0.
Rejected for roots: 8.
Rejected for a nontrivial stable symplectic group: 0.

| Output | rank(P) | rank(K) | Dimension | Stable kernel order | Cyclic group |
| ---: | ---: | ---: | ---: | ---: | --- |
| 1 | 16 | 6 | 0 | 1 | `C48 = [48,2]` |
| 2 | 16 | 6 | 0 | 1 | `C48 = [48,2]` |
| 3 | 16 | 6 | 0 | 1 | `C48 = [48,2]` |
| 4 | 16 | 6 | 0 | 1 | `C48 = [48,2]` |
| 5 | 16 | 6 | 0 | 1 | `C48 = [48,2]` |
| 6 | 16 | 6 | 0 | 1 | `C48 = [48,2]` |
| 7 | 16 | 6 | 0 | 1 | `C48 = [48,2]` |
| 8 | 16 | 6 | 0 | 1 | `C48 = [48,2]` |

The cubic equation independently supplies the Hodge character in `maximal_family_character_result.md`. The block signature does not distinguish the primitive 48th root assigned to the negative complex line; a power coprime to 48 of the lattice generator may be needed to match the displayed geometric generator (whose character is zeta_48). This integral calculation does not itself identify which retained class is realized by that equation if more than one class survives.

Completed: 2026-09-26T20:50:26.553. Elapsed before saving: 10991.2 seconds.
Memory ceiling: 17179869184 bytes; charged peak: 10245787648 bytes.
