# Family 154: exact-character integral-lattice search

Order 24; characteristic polynomial `Phi3 Phi12 Phi24^2`; minimal polynomial `Phi3 Phi12 Phi24`.
Block constraints (cyclotomic index, multiplicity, positive rank, negative rank): `((3, 1, 2, 0), (12, 1, 4, 0), (24, 2, 14, 2))`.
The input is the rank-22 primitive cubic-fourfold lattice. Since S=0, the entire action is enumerated on this ambient lattice. The geometric filters test the stable discriminant action, roots in the positive complement, and its stable orthogonal kernel.

Enumerated generator-action classes: 8.
Retained outputs: 4.
Rejected: non-stable=0, roots=4, nontrivial stable kernel=0.

| Output | Source action | rank(P) | rank(K) | Dimension | Stable kernel order |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 1 | 16 | 6 | 1 | 1 |
| 2 | 2 | 16 | 6 | 1 | 1 |
| 3 | 3 | 16 | 6 | 1 | 1 |
| 4 | 4 | 16 | 6 | 1 | 1 |

The displayed cubic generator has period eigenvalue `zeta_24^19` by the independent character calculation. A coprime power of an enumerated generator may be needed to match it. These outputs count generator actions; a separate power-orbit comparison is needed to count cyclic-group actions or geometric families.

Julia 1.12.4; OSCAR 1.8.2. Completed 2026-10-05T02:11:52.990; elapsed before saving 951.79 seconds.
Cgroup memory ceiling 17179869184 bytes; charged peak 10828709888 bytes.
