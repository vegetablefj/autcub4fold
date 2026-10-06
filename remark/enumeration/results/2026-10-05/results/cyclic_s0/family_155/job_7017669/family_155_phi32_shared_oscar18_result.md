# Family 155: exact-character integral-lattice search

Order 32; characteristic polynomial `Phi1 Phi2 Phi8 Phi32`; minimal polynomial `Phi1 Phi2 Phi8 Phi32`.
Block constraints (cyclotomic index, multiplicity, positive rank, negative rank): `((1, 1, 1, 0), (2, 1, 1, 0), (8, 1, 4, 0), (32, 1, 14, 2))`.
The input is the rank-22 primitive cubic-fourfold lattice. Since S=0, the entire action is enumerated on this ambient lattice. The geometric filters test the stable discriminant action, roots in the positive complement, and its stable orthogonal kernel.

Enumerated generator-action classes: 48.
Retained outputs: 8.
Rejected: non-stable=24, roots=16, nontrivial stable kernel=0.

| Output | Source action | rank(P) | rank(K) | Dimension | Stable kernel order |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 1 | 16 | 6 | 0 | 1 |
| 2 | 2 | 16 | 6 | 0 | 1 |
| 3 | 5 | 16 | 6 | 0 | 1 |
| 4 | 6 | 16 | 6 | 0 | 1 |
| 5 | 9 | 16 | 6 | 0 | 1 |
| 6 | 10 | 16 | 6 | 0 | 1 |
| 7 | 13 | 16 | 6 | 0 | 1 |
| 8 | 14 | 16 | 6 | 0 | 1 |

The displayed cubic generator has period eigenvalue `zeta_32^11` by the independent character calculation. A coprime power of an enumerated generator may be needed to match it. These outputs count generator actions; a separate power-orbit comparison is needed to count cyclic-group actions or geometric families.

Julia 1.12.4; OSCAR 1.8.2. Completed 2026-10-05T01:18:10.822; elapsed before saving 1131.31 seconds.
Cgroup memory ceiling 17179869184 bytes; charged peak 7922057216 bytes.
