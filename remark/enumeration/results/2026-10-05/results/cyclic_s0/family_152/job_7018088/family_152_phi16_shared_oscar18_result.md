# Family 152: exact-character integral-lattice search

Order 16; characteristic polynomial `Phi1^2 Phi2^2 Phi4 Phi16^2`; minimal polynomial `Phi1 Phi2 Phi4 Phi16`.
Block constraints (cyclotomic index, multiplicity, positive rank, negative rank): `((1, 2, 2, 0), (2, 2, 2, 0), (4, 1, 2, 0), (16, 2, 14, 2))`.
The input is the rank-22 primitive cubic-fourfold lattice. Since S=0, the entire action is enumerated on this ambient lattice. The geometric filters test the stable discriminant action, roots in the positive complement, and its stable orthogonal kernel.

Enumerated generator-action classes: 24.
Retained outputs: 4.
Rejected: non-stable=12, roots=8, nontrivial stable kernel=0.

| Output | Source action | rank(P) | rank(K) | Dimension | Stable kernel order |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 1 | 16 | 6 | 1 | 1 |
| 2 | 2 | 16 | 6 | 1 | 1 |
| 3 | 5 | 16 | 6 | 1 | 1 |
| 4 | 6 | 16 | 6 | 1 | 1 |

The displayed cubic generator has period eigenvalue `zeta_16^7` by the independent character calculation. A coprime power of an enumerated generator may be needed to match it. These outputs count generator actions; a separate power-orbit comparison is needed to count cyclic-group actions or geometric families.

Julia 1.12.4; OSCAR 1.8.2. Completed 2026-10-05T03:02:04.012; elapsed before saving 4450.31 seconds.
Cgroup memory ceiling 17179869184 bytes; charged peak 10590674944 bytes.
