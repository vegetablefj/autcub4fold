# Family 156: exact-character integral-lattice search

Order 48; characteristic polynomial `Phi3 Phi12 Phi48`; minimal polynomial `Phi3 Phi12 Phi48`.
Block constraints (cyclotomic index, multiplicity, positive rank, negative rank): `((3, 1, 2, 0), (12, 1, 4, 0), (48, 1, 14, 2))`.
The input is the rank-22 primitive cubic-fourfold lattice. Since S=0, the entire action is enumerated on this ambient lattice. The geometric filters test the stable discriminant action, roots in the positive complement, and its stable orthogonal kernel.

Enumerated generator-action classes: 16.
Retained outputs: 8.
Rejected: non-stable=0, roots=8, nontrivial stable kernel=0.

| Output | Source action | rank(P) | rank(K) | Dimension | Stable kernel order |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 1 | 16 | 6 | 0 | 1 |
| 2 | 2 | 16 | 6 | 0 | 1 |
| 3 | 3 | 16 | 6 | 0 | 1 |
| 4 | 4 | 16 | 6 | 0 | 1 |
| 5 | 5 | 16 | 6 | 0 | 1 |
| 6 | 6 | 16 | 6 | 0 | 1 |
| 7 | 7 | 16 | 6 | 0 | 1 |
| 8 | 8 | 16 | 6 | 0 | 1 |

The displayed cubic generator has period eigenvalue `zeta_48^1` by the independent character calculation. A coprime power of an enumerated generator may be needed to match it. These outputs count generator actions; a separate power-orbit comparison is needed to count cyclic-group actions or geometric families.

Julia 1.12.4; OSCAR 1.8.2. Completed 2026-10-05T03:06:15.235; elapsed before saving 2906.24 seconds.
Cgroup memory ceiling 17179869184 bytes; charged peak 10480627712 bytes.
