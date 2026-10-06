# Family 154: exact `Phi3 Phi12 Phi24^2` lattice search

Julia 1.12.4; OSCAR 1.8.2.

The enumeration fixed order 24, characteristic polynomial `Phi3 Phi12 Phi24^2`, minimal polynomial `Phi3 Phi12 Phi24`, ranks 2/4/16, and block signatures (2,0)/(4,0)/(14,2). No generator-root shortcut was used.
The input is the rank-22 primitive cubic-fourfold lattice with signature (20,2) and discriminant 3. Its genus has one isometry class. Since S=0, no gluing step is needed. Each action is tested for stable discriminant action, absence of short and long roots in the positive complement, and trivial stable kernel on that complement.

Enumerated action classes: 8.
Retained geometric lattice outputs: 4.
Rejections: non-stable=0, roots=4, nontrivial symplectic kernel=0.

| Output | Source action | rank(P) | rank(K) | Dimension | Stable kernel order |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 1 | 16 | 6 | 1 | 1 |
| 2 | 2 | 16 | 6 | 1 | 1 |
| 3 | 3 | 16 | 6 | 1 | 1 |
| 4 | 4 | 16 | 6 | 1 | 1 |

The displayed cubic equation gives Hodge eigenvalue `zeta24^19` independently (see `maximal_family_character_result.md`). The rational block signature does not choose a particular primitive 24th root on the negative complex line. A coprime power of a retained lattice generator may be needed to match that geometric generator. Retained generator classes need not be distinct cyclic-group actions; this run does not claim uniqueness without a separate power-orbit comparison.

Completed: 2026-09-27T00:49:21.371. Elapsed before saving: 7228.19 seconds.
Memory ceiling: 17179869184 bytes; charged peak: 5884669952 bytes.
