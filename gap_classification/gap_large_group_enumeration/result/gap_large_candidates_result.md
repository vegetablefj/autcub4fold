# Large-group candidate enumeration results

## Recorded run

The recorded enumeration and smoothness calculation yields 42 smooth
candidates. Their equal-dimensional comparison is recorded in
[gap_large_saturation_result.md](gap_large_saturation_result.md).

- Status: `completed`.
- GAP version: `4.16.0`.
- Exact smooth-candidate data: [gap_large_smooth_candidates.g](gap_large_smooth_candidates.g).
- Calculation sources and task inputs: [module guide](../README.md).

## Source and scope

The projective groups are the selected inputs in
[`gap_large_tasks.g`](../input/gap_large_tasks.g). For each connected
symplectic family, `K+` is the determinant kernel of its stored strict
generic full group; its embedded matrices are retained. There are 18 fixed
`K+` inputs and 28 `(K+,G)` pairs, processed in 29 branches.

The tasks omit symplectic part `3^{1+4}:2`, groups containing an order-7
automorphism, and connected symplectic families with no proper subfamily
having a larger automorphism group. Expected dimensions were comparison data,
not candidate filters.

The source keys and the matrix and basis coordinates follow the recorded
calculation. The engines enumerate linear images, compute invariant cubic
spaces, and test smoothness in that order.

## Summary

| stage | count |
|---|---|
| enumeration branches | 29 |
| raw matrix-image candidates | 747 |
| negative-dimensional images dropped before S4 | 3 |
| singular at S4 | 696 |
| supplementary exact singularity certificates | 6 |
| total singular | 705 |
| smooth candidates for the next stage | 42 |
| unresolved | 0 |

The disjoint count is `747 = 3 + 696 + 6 + 42`. The 641 negative-dimensional images overlap the singular counts and must not be added again.

## Liftability routing

23 inputs use the liftable branch only, four use the nonliftable branch only, and one uses both: 24 liftable runs and five nonliftable runs. The both-branch input is `G=[36,11]` over generic No. 65. Its nonliftable pencil is entirely singular.

A nonliftable fixed symplectic action forces the nonliftable branch. Cyclic 3-Sylow groups and vanishing 3-primary Schur multipliers give the liftable-only routes. The full-group small-subgroup criterion is not applied to arbitrary candidate actions.

| task | generic No. | G_s | generic index | G-ID | branch | reason |
|---|---|---|---|---|---|---|
| 1 | 17 | $M_9$ | $1$ | `[ 216, 153 ]` | nonliftable | fixed Kbar is nonliftable |
| 2 | 25 | $A_{4,3}$ | $1$ | `[ 144, 189 ]` | nonliftable | fixed Kbar is nonliftable |
| 3 | 27 | $A_{4,3}$ | $2$ | `[ 432, 745 ]` | liftable | 3-primary Schur multiplier vanishes; the cubic projective obstruction is trivial |
| 4 | 29 | $A_5$ | $1$ | `[ 180, 19 ]` | liftable | 3-primary Schur multiplier vanishes; the cubic projective obstruction is trivial |
| 5 | 31 | $A_5$ | $2$ | `[ 360, 119 ]` | liftable | 3-primary Schur multiplier vanishes; the cubic projective obstruction is trivial |
| 6 | 35 | $S_{3,3}$ | $2$ | `[ 216, 170 ]` | liftable | 3-primary Schur multiplier vanishes; the cubic projective obstruction is trivial |
| 7 | 37 | $S_{3,3}$ | $2$ | `[ 216, 157 ]` | liftable | 3-primary Schur multiplier vanishes; the cubic projective obstruction is trivial |
| 8 | 43 | $\mathrm{QD}_{16}$ | $1$ | `[ 32, 42 ]` | liftable | cyclic 3-Sylow; Sylow criterion |
| 9 | 45 | $S_4$ | $1$ | `[ 48, 48 ]` | liftable | cyclic 3-Sylow; Sylow criterion |
| 10 | 48 | $Q_8$ | $1$ | `[ 16, 13 ]` | liftable | cyclic 3-Sylow; Sylow criterion |
| 11 | 48 | $Q_8$ | $1$ | `[ 24, 3 ]` | liftable | cyclic 3-Sylow; Sylow criterion |
| 12 | 48 | $Q_8$ | $1$ | `[ 32, 11 ]` | liftable | cyclic 3-Sylow; Sylow criterion |
| 13 | 52 | $A_{3,3}$ | $1$ | `[ 36, 13 ]` | nonliftable | fixed Kbar is nonliftable |
| 14 | 52 | $A_{3,3}$ | $1$ | `[ 54, 5 ]` | nonliftable | fixed Kbar is nonliftable |
| 15 | 55 | $A_{3,3}$ | $2$ | `[ 108, 38 ]` | liftable | 3-primary Schur multiplier vanishes; the cubic projective obstruction is trivial |
| 16 | 58 | $D_{12}$ | $1$ | `[ 24, 8 ]` | liftable | cyclic 3-Sylow; Sylow criterion |
| 17 | 58 | $D_{12}$ | $1$ | `[ 24, 14 ]` | liftable | cyclic 3-Sylow; Sylow criterion |
| 18 | 58 | $D_{12}$ | $1$ | `[ 36, 12 ]` | liftable | 3-primary Schur multiplier vanishes; the cubic projective obstruction is trivial |
| 19 | 58 | $D_{12}$ | $1$ | `[ 72, 30 ]` | liftable | 3-primary Schur multiplier vanishes; the cubic projective obstruction is trivial |
| 20 | 63 | $D_{12}$ | $2$ | `[ 72, 48 ]` | liftable | 3-primary Schur multiplier vanishes; the cubic projective obstruction is trivial |
| 21 | 65 | $A_4$ | $1$ | `[ 24, 13 ]` | liftable | cyclic 3-Sylow; Sylow criterion |
| 22 | 65 | $A_4$ | $1$ | `[ 36, 11 ]` | liftable | not decided from fixed Kbar and Sylow data; enumerate both |
| 22 | 65 | $A_4$ | $1$ | `[ 36, 11 ]` | nonliftable | not decided from fixed Kbar and Sylow data; enumerate both |
| 23 | 68 | $A_4$ | $2$ | `[ 72, 42 ]` | liftable | 3-primary Schur multiplier vanishes; the cubic projective obstruction is trivial |
| 24 | 70 | $D_{10}$ | $1$ | `[ 20, 4 ]` | liftable | cyclic 3-Sylow; Sylow criterion |
| 25 | 70 | $D_{10}$ | $1$ | `[ 30, 2 ]` | liftable | cyclic 3-Sylow; Sylow criterion |
| 26 | 73 | $D_8$ | $1$ | `[ 16, 11 ]` | liftable | cyclic 3-Sylow; Sylow criterion |
| 27 | 73 | $D_8$ | $1$ | `[ 16, 13 ]` | liftable | cyclic 3-Sylow; Sylow criterion |
| 28 | 73 | $D_8$ | $1$ | `[ 16, 7 ]` | liftable | cyclic 3-Sylow; Sylow criterion |

## Results by input

| source job | generic No. | G-ID | raw | singular | smooth candidates |
|---|---|---|---|---|---|
| `job01_nonliftable` | 17 | `[ 216, 153 ]` | 2 | 1 | 1 |
| `job02_nonliftable` | 25 | `[ 144, 189 ]` | 2 | 1 | 1 |
| `job03_liftable` | 27 | `[ 432, 745 ]` | 32 | 31 | 1 |
| `job04_liftable` | 29 | `[ 180, 19 ]` | 2 | 1 | 1 |
| `job05_liftable` | 31 | `[ 360, 119 ]` | 20 | 18 | 2 |
| `job06_liftable` | 35 | `[ 216, 170 ]` | 120 | 118 | 2 |
| `job07_liftable` | 37 | `[ 216, 157 ]` | 20 | 18 | 2 |
| `job08_liftable` | 43 | `[ 32, 42 ]` | 4 | 3 | 1 |
| `job09_liftable` | 45 | `[ 48, 48 ]` | 4 | 3 | 1 |
| `job10_liftable` | 48 | `[ 16, 13 ]` | 4 | 3 | 1 |
| `job11_liftable` | 48 | `[ 24, 3 ]` | 3 | 2 | 1 |
| `job12_liftable` | 48 | `[ 32, 11 ]` | 16 | 15 | 1 |
| `job13_nonliftable` | 52 | `[ 36, 13 ]` | 1 | 0 | 1 |
| `job14_nonliftable` | 52 | `[ 54, 5 ]` | 4 | 2 | 2 |
| `job15_liftable` | 55 | `[ 108, 38 ]` | 86 | 81 | 5 |
| `job16_liftable` | 58 | `[ 24, 8 ]` | 4 | 3 | 1 |
| `job17_liftable` | 58 | `[ 24, 14 ]` | 2 | 1 | 1 |
| `job18_liftable` | 58 | `[ 36, 12 ]` | 17 | 15 | 2 |
| `job19_liftable` | 58 | `[ 72, 30 ]` | 68 | 66 | 2 |
| `job20_liftable` | 63 | `[ 72, 48 ]` | 246 | 244 | 2 |
| `job21_liftable` | 65 | `[ 24, 13 ]` | 4 | 3 | 1 |
| `job22_liftable` | 65 | `[ 36, 11 ]` | 9 | 7 | 2 |
| `job22_nonliftable` | 65 | `[ 36, 11 ]` | 1 | 1 | 0 |
| `job23_liftable` | 68 | `[ 72, 42 ]` | 52 | 50 | 2 |
| `job24_liftable` | 70 | `[ 20, 4 ]` | 3 | 2 | 1 |
| `job25_liftable` | 70 | `[ 30, 2 ]` | 11 | 9 | 2 |
| `job26_liftable` | 73 | `[ 16, 11 ]` | 4 | 3 | 1 |
| `job27_liftable` | 73 | `[ 16, 13 ]` | 5 | 4 | 1 |
| `job28_liftable` | 73 | `[ 16, 7 ]` | 1 | 0 | 1 |

## Candidate table

Candidate identifiers preserve the original job and S4 family number. `dim V3 - dim C = D3`. The generic catalogue number identifies the fixed symplectic component; it is not a final classification label for the candidate.

| source key | generic No. | G-ID | H-ID | order | dim V3 | dim C | D3 |
|---|---|---|---|---|---|---|---|
| `job01_nonliftable_f1` | 17 | `[ 216, 153 ]` | `[ 648, 533 ]` | 648 | 1 | 1 | 0 |
| `job02_nonliftable_f1` | 25 | `[ 144, 189 ]` | `[ 432, 538 ]` | 432 | 3 | 2 | 1 |
| `job03_liftable_f10` | 27 | `[ 432, 745 ]` | `[ 1296, 3545 ]` | 1296 | 4 | 3 | 1 |
| `job04_liftable_f1` | 29 | `[ 180, 19 ]` | `[ 540, 88 ]` | 540 | 3 | 2 | 1 |
| `job05_liftable_f1` | 31 | `[ 360, 119 ]` | `[ 1080, 490 ]` | 1080 | 5 | 5 | 0 |
| `job05_liftable_f5` | 31 | `[ 360, 119 ]` | `[ 1080, 490 ]` | 1080 | 4 | 3 | 1 |
| `job06_liftable_f11` | 35 | `[ 216, 170 ]` | `[ 648, 746 ]` | 648 | 5 | 4 | 1 |
| `job06_liftable_f14` | 35 | `[ 216, 170 ]` | `[ 648, 746 ]` | 648 | 4 | 4 | 0 |
| `job07_liftable_f4` | 37 | `[ 216, 157 ]` | `[ 648, 718 ]` | 648 | 5 | 5 | 0 |
| `job07_liftable_f8` | 37 | `[ 216, 157 ]` | `[ 648, 718 ]` | 648 | 4 | 3 | 1 |
| `job08_liftable_f3` | 43 | `[ 32, 42 ]` | `[ 96, 182 ]` | 96 | 5 | 4 | 1 |
| `job09_liftable_f4` | 45 | `[ 48, 48 ]` | `[ 144, 188 ]` | 144 | 5 | 3 | 2 |
| `job10_liftable_f3` | 48 | `[ 16, 13 ]` | `[ 48, 47 ]` | 48 | 7 | 5 | 2 |
| `job11_liftable_f1` | 48 | `[ 24, 3 ]` | `[ 72, 25 ]` | 72 | 4 | 3 | 1 |
| `job12_liftable_f13` | 48 | `[ 32, 11 ]` | `[ 96, 54 ]` | 96 | 5 | 4 | 1 |
| `job13_nonliftable_f1` | 52 | `[ 36, 13 ]` | `[ 108, 28 ]` | 108 | 4 | 2 | 2 |
| `job14_nonliftable_f1` | 52 | `[ 54, 5 ]` | `[ 162, 10 ]` | 162 | 4 | 4 | 0 |
| `job14_nonliftable_f2` | 52 | `[ 54, 5 ]` | `[ 162, 10 ]` | 162 | 3 | 2 | 1 |
| `job15_liftable_f11` | 55 | `[ 108, 38 ]` | `[ 324, 165 ]` | 324 | 8 | 6 | 2 |
| `job15_liftable_f14` | 55 | `[ 108, 38 ]` | `[ 324, 165 ]` | 324 | 6 | 6 | 0 |
| `job15_liftable_f26` | 55 | `[ 108, 38 ]` | `[ 324, 165 ]` | 324 | 6 | 4 | 2 |
| `job15_liftable_f28` | 55 | `[ 108, 38 ]` | `[ 324, 165 ]` | 324 | 5 | 4 | 1 |
| `job15_liftable_f29` | 55 | `[ 108, 38 ]` | `[ 324, 165 ]` | 324 | 3 | 3 | 0 |
| `job16_liftable_f4` | 58 | `[ 24, 8 ]` | `[ 72, 30 ]` | 72 | 8 | 6 | 2 |
| `job17_liftable_f2` | 58 | `[ 24, 14 ]` | `[ 72, 48 ]` | 72 | 6 | 4 | 2 |
| `job18_liftable_f3` | 58 | `[ 36, 12 ]` | `[ 108, 42 ]` | 108 | 6 | 6 | 0 |
| `job18_liftable_f4` | 58 | `[ 36, 12 ]` | `[ 108, 42 ]` | 108 | 6 | 4 | 2 |
| `job19_liftable_f12` | 58 | `[ 72, 30 ]` | `[ 216, 139 ]` | 216 | 6 | 6 | 0 |
| `job19_liftable_f21` | 58 | `[ 72, 30 ]` | `[ 216, 139 ]` | 216 | 5 | 4 | 1 |
| `job20_liftable_f6` | 63 | `[ 72, 48 ]` | `[ 216, 174 ]` | 216 | 9 | 7 | 2 |
| `job20_liftable_f54` | 63 | `[ 72, 48 ]` | `[ 216, 174 ]` | 216 | 6 | 5 | 1 |
| `job21_liftable_f4` | 65 | `[ 24, 13 ]` | `[ 72, 47 ]` | 72 | 7 | 4 | 3 |
| `job22_liftable_f1` | 65 | `[ 36, 11 ]` | `[ 108, 41 ]` | 108 | 6 | 4 | 2 |
| `job22_liftable_f2` | 65 | `[ 36, 11 ]` | `[ 108, 41 ]` | 108 | 5 | 4 | 1 |
| `job23_liftable_f16` | 68 | `[ 72, 42 ]` | `[ 216, 163 ]` | 216 | 8 | 6 | 2 |
| `job23_liftable_f17` | 68 | `[ 72, 42 ]` | `[ 216, 163 ]` | 216 | 7 | 6 | 1 |
| `job24_liftable_f3` | 70 | `[ 20, 4 ]` | `[ 60, 10 ]` | 60 | 6 | 4 | 2 |
| `job25_liftable_f2` | 70 | `[ 30, 2 ]` | `[ 90, 5 ]` | 90 | 6 | 6 | 0 |
| `job25_liftable_f3` | 70 | `[ 30, 2 ]` | `[ 90, 5 ]` | 90 | 6 | 4 | 2 |
| `job26_liftable_f4` | 73 | `[ 16, 11 ]` | `[ 48, 45 ]` | 48 | 11 | 7 | 4 |
| `job27_liftable_f4` | 73 | `[ 16, 13 ]` | `[ 48, 47 ]` | 48 | 10 | 7 | 3 |
| `job28_liftable_f1` | 73 | `[ 16, 7 ]` | `[ 48, 25 ]` | 48 | 6 | 4 | 2 |

## Supplementary singularity certificates

Five remaining cases have a coordinate projective line on which every invariant cubic vanishes and the entire restricted gradient has constant coefficient rank one. Thus the singularity equations there reduce to at most one homogeneous binary quadratic, which has a projective zero over the complex numbers. This proves every member singular.

| source key | free coordinates | restricted gradient rank |
|---|---|---|
| `job26_liftable_f2` | [1, 3] | 1 |
| `job27_liftable_f3` | [1, 3] | 1 |
| `job20_liftable_f4` | [1, 2] | 1 |
| `job20_liftable_f50` | [1, 2] | 1 |
| `job20_liftable_f52` | [1, 2] | 1 |

For the remaining pencil `job22_nonliftable_f1`, let `B1,B2` be its ordered invariant basis displayed below. Set

```text
a = 3*(r^2-1),  b = r^2-9,
p(r) = [1+r,1-r,1+r,1-r,1,1].
```

All six partial derivatives of `a*B1+b*B2` vanish at `p(r)` identically. Every parameter ratio with `a != 3*b` occurs, since `r^2=(9*a-3*b)/(a-3*b)`. At the remaining ratio `[a:b]=[3:1]`, the point `[1,-1,0,0,0,0]` is singular. Strict invariance and completeness of the two-dimensional basis were also checked.

## Output recovery

Five initial nonliftable jobs reached the end of S4 but their summary driver expected different result fields. Complete S4 logs and saved S3 data were used to normalize those outputs, checking every family status. Liftable S4 files written after Singular changed the working directory were recovered unchanged. The initial error logs are preserved; the successful normalizations supersede their incomplete labels.

## Detailed smooth candidates

### Candidate job01_nonliftable_f1 | nonabelian

- G_s / symplectic: `M_9`
- generic No.: `17`; generic index: `1`; index: `3`; m: `0`
- G_id: `[ 216, 153 ]`; H_id: `[ 648, 533 ]`; order: `648`
- source: `job01_nonliftable_f1`; liftable: `nonliftable`
- status: `smooth_candidate`; dim V3: `1`; dim C: `1`
- n_gens: 7; n_basis: 1

- smooth witness prime: `13`; coefficients in the displayed basis: `[ 1 ]`

**Generators**

```gap
g1 := [ [ -1/2*E(12)^8+1/2*E(12)^11, 0, 0, 1/2+1/2*E(4), 0, 0 ], [ 0, -1/2*E(12)^4+1/2*E(12)^7, 0, 0, 1/2*E(12)^8+1/2*E(12)^11, 0 ], [ 0, 0, -1/2*E(12)^4+1/2*E(12)^7, 0, 0, 1/2*E(12)^8+1/2*E(12)^11 ], [ -1/2*E(12)^4+1/2*E(12)^7, 0, 0, -1/2*E(12)^8-1/2*E(12)^11, 0, 0 ], [ 0, -1/2+1/2*E(4), 0, 0, -1/2*E(12)^4-1/2*E(12)^7, 0 ], [ 0, 0, -1/2+1/2*E(4), 0, 0, -1/2*E(12)^4-1/2*E(12)^7 ] ];
g2 := [ [ -1/3*E(12)^7+1/3*E(12)^11, 2/3*E(12)^7+1/3*E(12)^11, -1/3*E(12)^7-2/3*E(12)^11, 0, 0, 0 ], [ -1/3*E(12)^7-2/3*E(12)^11, -1/3*E(12)^7-2/3*E(12)^11, -1/3*E(12)^7-2/3*E(12)^11, 0, 0, 0 ], [ 2/3*E(12)^7+1/3*E(12)^11, -1/3*E(12)^7+1/3*E(12)^11, -1/3*E(12)^7-2/3*E(12)^11, 0, 0, 0 ], [ 0, 0, 0, 1/3*E(12)^7-1/3*E(12)^11, -2/3*E(12)^7-1/3*E(12)^11, 1/3*E(12)^7+2/3*E(12)^11 ], [ 0, 0, 0, 1/3*E(12)^7+2/3*E(12)^11, 1/3*E(12)^7+2/3*E(12)^11, 1/3*E(12)^7+2/3*E(12)^11 ], [ 0, 0, 0, -2/3*E(12)^7-1/3*E(12)^11, 1/3*E(12)^7-1/3*E(12)^11, 1/3*E(12)^7+2/3*E(12)^11 ] ];
g3 := [ [ 0, 0, 0, -1/3*E(3)-2/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)-2/3*E(3)^2 ], [ 0, 0, 0, -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2 ], [ 0, 0, 0, -1/3*E(3)-2/3*E(3)^2, -1/3*E(3)-2/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2 ], [ -2/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, -2/3*E(3)-1/3*E(3)^2, 0, 0, 0 ], [ 1/3*E(3)+2/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 0, 0, 0 ], [ -2/3*E(3)-1/3*E(3)^2, -2/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 0, 0, 0 ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ], [ 0, 0, 0, 0, E(3), 0 ] ];
g5 := [ [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, E(3)^2, 0, 0 ] ];
g6 := [ [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, E(3) ], [ 0, 0, 0, E(3)^2, 0, 0 ] ];
g7 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ];
```

**Invariant basis**

```text
(-E(12)^7+E(12)^8)*x6^3 + (-E(12)^7+E(12)^8)*x5^3 + (-3+3*E(4))*x4*x5*x6 + (-E(12)^7+E(12)^8)*x4^3 + (E(3)+2*E(3)^2)*x3*x6^2 + (-E(12)^4+3*E(12)^7-2*E(12)^8)*x3*x4*x5 + (E(12)^4-E(12)^7+2*E(12)^8+E(12)^11)*x3^2*x6 + x3^3 + (E(3)+2*E(3)^2)*x2*x5^2 + (-E(12)^4+3*E(12)^7-2*E(12)^8)*x2*x4*x6 + (2*E(12)^4-2*E(12)^7+E(12)^8-E(12)^11)*x2*x3*x4 + (E(12)^4-E(12)^7+2*E(12)^8+E(12)^11)*x2^2*x5 + x2^3 + (-E(12)^4+3*E(12)^7-2*E(12)^8)*x1*x5*x6 + (E(3)+2*E(3)^2)*x1*x4^2 + (2*E(12)^4-2*E(12)^7+E(12)^8-E(12)^11)*x1*x3*x5 + (2*E(12)^4-2*E(12)^7+E(12)^8-E(12)^11)*x1*x2*x6 + (3*E(12)^4-3*E(12)^7+3*E(12)^8+3*E(12)^11)*x1*x2*x3 + (E(12)^4-E(12)^7+2*E(12)^8+E(12)^11)*x1^2*x4 + x1^3
```

### Candidate job02_nonliftable_f1 | nonabelian

- G_s / symplectic: `A_{4,3}`
- generic No.: `25`; generic index: `1`; index: `2`; m: `1`
- G_id: `[ 144, 189 ]`; H_id: `[ 432, 538 ]`; order: `432`
- source: `job02_nonliftable_f1`; liftable: `nonliftable`
- status: `smooth_candidate`; dim V3: `3`; dim C: `2`
- n_gens: 7; n_basis: 3

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 0, 2 ]`

**Generators**

```gap
g1 := [ [ -1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 2/3*E(3), 0, -2/3*E(3)-1/3*E(3)^2, -1/3*E(3) ], [ 2/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2, -1/3*E(3), 0, 1/3*E(3)+2/3*E(3)^2, -1/3*E(3) ], [ 2/3*E(3)^2, 0, -1/3, 0, 0, 2/3*E(3) ], [ -1/3*E(3)^2, 0, 2/3, 1, 0, -1/3*E(3) ], [ -1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)^2, 0, 2/3*E(3)+1/3*E(3)^2, 2/3*E(3) ], [ -1/3*E(3)^2, -1/3*E(3)-2/3*E(3)^2, 2/3*E(3)^2, 0, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3) ] ];
g2 := [ [ 0, -1/3, -1/3*E(3)^2, 0, 2/3*E(3), E(3) ], [ 0, 2/3, 2/3*E(3)^2, 0, -1/3*E(3), 0 ], [ 0, 2/3*E(3), -1/3, 0, 2/3*E(3)^2, 0 ], [ 0, -1/3*E(3), 2/3, 1, -1/3*E(3)^2, 0 ], [ 0, -1/3*E(3)^2, 2/3*E(3), 0, 2/3, 0 ], [ E(3)^2, 2/3*E(3)^2, -1/3*E(3), 0, -1/3, 0 ] ];
g3 := [ [ -1/3, -1/3, -1/3*E(3)^2, -1/3*E(3)^2, 1/3*E(3), E(3) ], [ 2/3, 2/3, 2/3*E(3)^2, 2/3*E(3)^2, 1/3*E(3), 0 ], [ -1/3, 2/3*E(3), -1/3, 2/3*E(3)^2, 1/3, 0 ], [ 2/3, -1/3*E(3), 2/3, -1/3*E(3)^2, 1/3, 0 ], [ 2/3, -1/3*E(3)^2, 2/3*E(3), -1/3*E(3)^2, 1/3*E(3)^2, 0 ], [ -1/3, 2/3*E(3)^2, -1/3*E(3), 2/3*E(3)^2, 1/3*E(3)^2, 0 ] ];
g4 := [ [ 0, 2/3*E(3)^2, 0, 2/3*E(3)^2, 0, -1/3*E(3)^2 ], [ 0, -1/3*E(3)^2, 0, -1/3*E(3)^2, E(3)^2, 2/3*E(3)^2 ], [ 0, -1/3*E(3)^2, E(3)^2, 2/3*E(3)^2, 0, -1/3*E(3)^2 ], [ 0, 2/3*E(3)^2, 0, -1/3*E(3)^2, 0, 2/3*E(3)^2 ], [ 0, -1/3*E(3)^2, 0, 2/3*E(3)^2, 0, 2/3*E(3)^2 ], [ E(3)^2, 2/3*E(3)^2, 0, -1/3*E(3)^2, 0, -1/3*E(3)^2 ] ];
g5 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ];
g6 := [ [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ] ];
g7 := [ [ -1/3*E(3), 2/3*E(3)^2, 1/3, 0, -1/3*E(3)^2, 2/3*E(3) ], [ 2/3*E(3), -1/3*E(3)^2, 1/3, 0, 2/3*E(3)^2, -1/3*E(3) ], [ 2/3, 2/3, 1/3, 0, 2/3, 2/3 ], [ -1/3, -1/3, 1/3, 1, -1/3, -1/3 ], [ -1/3*E(3)^2, 2/3*E(3), 1/3, 0, -1/3*E(3), 2/3*E(3)^2 ], [ 2/3*E(3)^2, -1/3*E(3), 1/3, 0, 2/3*E(3), -1/3*E(3)^2 ] ];
```

**Invariant basis**

```text
x4*x6^2 + (-5/2)*x4*x5*x6 + x4*x5^2 + (1/2)*x4^2*x6 + (1/2)*x4^2*x5 + (-1/2)*x4^3 + -x3*x4*x6 + -x3*x4*x5 + (2)*x3*x4^2 + (-2)*x3^2*x4 + (2)*x2*x4*x6 + (-5/2)*x2*x4*x5 + (1/2)*x2*x4^2 + -x2*x3*x4 + x2^2*x4 + (-5/2)*x1*x4*x6 + (2)*x1*x4*x5 + (1/2)*x1*x4^2 + -x1*x3*x4 + (-5/2)*x1*x2*x4 + x1^2*x4,
x5*x6^2 + x5^2*x6 + (4)*x4*x5*x6 + (-14/3)*x4^2*x6 + (-14/3)*x4^2*x5 + (-14/3)*x4^3 + (-12)*x3*x6^2 + (22)*x3*x5*x6 + (-12)*x3*x5^2 + (38/3)*x3*x4*x6 + (38/3)*x3*x4*x5 + (-21)*x3*x4^2 + (-20/3)*x3^2*x6 + (-20/3)*x3^2*x5 + (23)*x3^2*x4 + (-8/3)*x3^3 + (-28/3)*x2*x6^2 + (34/3)*x2*x5*x6 + (-4/3)*x2*x5^2 + (-28/3)*x2*x4*x6 + (68/3)*x2*x4*x5 + (-14/3)*x2*x4^2 + (-58/3)*x2*x3*x6 + (38/3)*x2*x3*x5 + (38/3)*x2*x3*x4 + (-20/3)*x2*x3^2 + (-28/3)*x2^2*x6 + (-4/3)*x2^2*x5 + (-12)*x2^2*x3 + (-4/3)*x1*x6^2 + (34/3)*x1*x5*x6 + (-28/3)*x1*x5^2 + (68/3)*x1*x4*x6 + (-28/3)*x1*x4*x5 + (-14/3)*x1*x4^2 + (38/3)*x1*x3*x6 + (-58/3)*x1*x3*x5 + (38/3)*x1*x3*x4 + (-20/3)*x1*x3^2 + (34/3)*x1*x2*x6 + (34/3)*x1*x2*x5 + (4)*x1*x2*x4 + (22)*x1*x2*x3 + x1*x2^2 + (-4/3)*x1^2*x6 + (-28/3)*x1^2*x5 + (-12)*x1^2*x3 + x1^2*x2,
x6^3 + x5^3 + (3/2)*x4*x5*x6 + (-5/2)*x4^2*x6 + (-5/2)*x4^2*x5 + (-3/2)*x4^3 + (-6)*x3*x6^2 + (12)*x3*x5*x6 + (-6)*x3*x5^2 + (7)*x3*x4*x6 + (7)*x3*x4*x5 + (-12)*x3*x4^2 + (-4)*x3^2*x6 + (-4)*x3^2*x5 + (12)*x3^2*x4 + (-5)*x2*x6^2 + (8)*x2*x5*x6 + (-2)*x2*x5^2 + (-8)*x2*x4*x6 + (35/2)*x2*x4*x5 + (-5/2)*x2*x4^2 + (-8)*x2*x3*x6 + (4)*x2*x3*x5 + (7)*x2*x3*x4 + (-4)*x2*x3^2 + (-5)*x2^2*x6 + (-2)*x2^2*x5 + (-6)*x2^2*x3 + x2^3 + (-2)*x1*x6^2 + (8)*x1*x5*x6 + (-5)*x1*x5^2 + (35/2)*x1*x4*x6 + (-8)*x1*x4*x5 + (-5/2)*x1*x4^2 + (4)*x1*x3*x6 + (-8)*x1*x3*x5 + (7)*x1*x3*x4 + (-4)*x1*x3^2 + (8)*x1*x2*x6 + (8)*x1*x2*x5 + (3/2)*x1*x2*x4 + (12)*x1*x2*x3 + (-2)*x1^2*x6 + (-5)*x1^2*x5 + (-6)*x1^2*x3 + x1^3
```

### Candidate job03_liftable_f10 | nonabelian

- G_s / symplectic: `A_{4,3}`
- generic No.: `27`; generic index: `2`; index: `6`; m: `1`
- G_id: `[ 432, 745 ]`; H_id: `[ 1296, 3545 ]`; order: `1296`
- source: `job03_liftable_f10`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `4`; dim C: `3`
- n_gens: 8; n_basis: 4

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, -1, 0 ], [ 0, 1, 0, 0, -1, 0 ], [ 0, 0, 1, 0, -1, 0 ], [ 0, 0, 0, 1, -1, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, -1, 1 ] ];
g2 := [ [ 0, 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ E(3)^2, 0, 0, 0, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2 ], [ 0, E(3)^2, 0, 0, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2 ], [ 0, 0, E(3)^2, 0, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2 ], [ 0, 0, 0, E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
g4 := [ [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g5 := [ [ 1, 0, 0, 0, 0, -1 ], [ 0, 1, 0, 0, 0, -1 ], [ 0, 0, 1, 0, 0, -1 ], [ 0, 0, 0, 1, 0, -1 ], [ 0, 0, 0, 0, 0, -1 ], [ 0, 0, 0, 0, 1, -1 ] ];
g6 := [ [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g7 := [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g8 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x2*x3*x4 + x1*x3*x4 + x1*x2*x4 + x1*x2*x3,
(3)*x5*x6^2 + (3)*x5^2*x6 + x4*x6^2 + (4)*x4*x5*x6 + x4*x5^2 + x4^2*x6 + x4^2*x5 + x3*x6^2 + (4)*x3*x5*x6 + x3*x5^2 + (2)*x3*x4*x6 + (2)*x3*x4*x5 + x3^2*x6 + x3^2*x5 + x2*x6^2 + (4)*x2*x5*x6 + x2*x5^2 + (2)*x2*x4*x6 + (2)*x2*x4*x5 + (2)*x2*x3*x6 + (2)*x2*x3*x5 + x2^2*x6 + x2^2*x5 + x1*x6^2 + (4)*x1*x5*x6 + x1*x5^2 + (2)*x1*x4*x6 + (2)*x1*x4*x5 + (2)*x1*x3*x6 + (2)*x1*x3*x5 + (2)*x1*x2*x6 + (2)*x1*x2*x5 + x1^2*x6 + x1^2*x5,
x3*x4^2 + x3^2*x4 + x2*x4^2 + x2*x3^2 + x2^2*x4 + x2^2*x3 + x1*x4^2 + x1*x3^2 + x1*x2^2 + x1^2*x4 + x1^2*x3 + x1^2*x2,
x4^3 + x3^3 + x2^3 + x1^3
```

### Candidate job04_liftable_f1 | nonabelian

- G_s / symplectic: `A_5`
- generic No.: `29`; generic index: `1`; index: `3`; m: `1`
- G_id: `[ 180, 19 ]`; H_id: `[ 540, 88 ]`; order: `540`
- source: `job04_liftable_f1`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `3`; dim C: `2`
- n_gens: 3; n_basis: 3

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ -1/6*E(3)+1/6*E(3)^2, 5/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2 ], [ -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, 5/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2 ], [ 5/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2 ], [ -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, 5/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2 ], [ -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, 5/6*E(3)+1/6*E(3)^2 ], [ -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, 5/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2, -1/6*E(3)+1/6*E(3)^2 ] ];
g2 := [ [ 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)+5/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2 ], [ 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)+5/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2 ], [ 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)+5/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2 ], [ 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)+5/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2 ], [ 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)+5/6*E(3)^2 ], [ 1/6*E(3)+5/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2, 1/6*E(3)-1/6*E(3)^2 ] ];
g3 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
-x4*x5*x6 + x3*x5*x6 + -x3*x4*x6 + x3*x4*x5 + x2*x5*x6 + x2*x4*x6 + -x2*x4*x5 + -x2*x3*x6 + -x2*x3*x5 + x2*x3*x4 + -x1*x5*x6 + x1*x4*x6 + x1*x4*x5 + x1*x3*x6 + -x1*x3*x5 + -x1*x3*x4 + -x1*x2*x6 + x1*x2*x5 + -x1*x2*x4 + x1*x2*x3,
x5*x6^2 + x5^2*x6 + x4*x6^2 + (3)*x4*x5*x6 + x4*x5^2 + x4^2*x6 + x4^2*x5 + x3*x6^2 + x3*x5^2 + (3)*x3*x4*x6 + x3*x4^2 + x3^2*x6 + x3^2*x5 + x3^2*x4 + x2*x6^2 + x2*x5^2 + (3)*x2*x4*x5 + x2*x4^2 + (3)*x2*x3*x6 + (3)*x2*x3*x5 + x2*x3^2 + x2^2*x6 + x2^2*x5 + x2^2*x4 + x2^2*x3 + x1*x6^2 + (3)*x1*x5*x6 + x1*x5^2 + x1*x4^2 + (3)*x1*x3*x5 + (3)*x1*x3*x4 + x1*x3^2 + (3)*x1*x2*x6 + (3)*x1*x2*x4 + x1*x2^2 + x1^2*x6 + x1^2*x5 + x1^2*x4 + x1^2*x3 + x1^2*x2,
x6^3 + x5^3 + (3)*x4*x5*x6 + x4^3 + (3)*x3*x4*x6 + x3^3 + (3)*x2*x4*x5 + (3)*x2*x3*x6 + (3)*x2*x3*x5 + x2^3 + (3)*x1*x5*x6 + (3)*x1*x3*x5 + (3)*x1*x3*x4 + (3)*x1*x2*x6 + (3)*x1*x2*x4 + x1^3
```

### Candidate job05_liftable_f1 | nonabelian

- G_s / symplectic: `A_5`
- generic No.: `31`; generic index: `2`; index: `6`; m: `0`
- G_id: `[ 360, 119 ]`; H_id: `[ 1080, 490 ]`; order: `1080`
- source: `job05_liftable_f1`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `5`; dim C: `5`
- n_gens: 3; n_basis: 5

- smooth witness prime: `7`; coefficients in the displayed basis: `[ 1, 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)+4/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 0 ], [ 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)+4/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 0 ], [ 1/5*E(3)+4/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 0 ], [ 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)+4/5*E(3)^2, 0 ], [ 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)+4/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 1/5*E(3)-1/5*E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
g2 := [ [ 0, 0, 0, 1, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3,
x5*x6^2 + x4*x6^2 + x3*x6^2 + x2*x6^2 + x1*x6^2,
x5^2*x6 + (2)*x4*x5*x6 + x4^2*x6 + (2)*x3*x5*x6 + (2)*x3*x4*x6 + x3^2*x6 + (2)*x2*x5*x6 + (2)*x2*x4*x6 + (2)*x2*x3*x6 + x2^2*x6 + (2)*x1*x5*x6 + (2)*x1*x4*x6 + (2)*x1*x3*x6 + (2)*x1*x2*x6 + x1^2*x6,
x4*x5^2 + x4^2*x5 + x3*x5^2 + (4/3)*x3*x4*x5 + x3*x4^2 + x3^2*x5 + x3^2*x4 + x2*x5^2 + (4/3)*x2*x4*x5 + x2*x4^2 + (4/3)*x2*x3*x5 + (4/3)*x2*x3*x4 + x2*x3^2 + x2^2*x5 + x2^2*x4 + x2^2*x3 + x1*x5^2 + (4/3)*x1*x4*x5 + x1*x4^2 + (4/3)*x1*x3*x5 + (4/3)*x1*x3*x4 + x1*x3^2 + (4/3)*x1*x2*x5 + (4/3)*x1*x2*x4 + (4/3)*x1*x2*x3 + x1*x2^2 + x1^2*x5 + x1^2*x4 + x1^2*x3 + x1^2*x2,
x5^3 + x4^3 + (2)*x3*x4*x5 + x3^3 + (2)*x2*x4*x5 + (2)*x2*x3*x5 + (2)*x2*x3*x4 + x2^3 + (2)*x1*x4*x5 + (2)*x1*x3*x5 + (2)*x1*x3*x4 + (2)*x1*x2*x5 + (2)*x1*x2*x4 + (2)*x1*x2*x3 + x1^3
```

### Candidate job05_liftable_f5 | nonabelian

- G_s / symplectic: `A_5`
- generic No.: `31`; generic index: `2`; index: `6`; m: `1`
- G_id: `[ 360, 119 ]`; H_id: `[ 1080, 490 ]`; order: `1080`
- source: `job05_liftable_f5`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `4`; dim C: `3`
- n_gens: 3; n_basis: 4

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, -2, 3, -4 ]`

**Generators**

```gap
g1 := [ [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ E(3), 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ -E(3)+E(3)^2, -E(3)+E(3)^2, -E(3)+E(3)^2, -E(3)+E(3)^2, -E(3)+E(3)^2, E(3)^2 ] ];
g2 := [ [ 0, 0, 0, 1, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3,
(6)*x5*x6^2 + (6)*x4*x6^2 + (-3)*x4*x5*x6 + (6)*x3*x6^2 + (-3)*x3*x5*x6 + (-3)*x3*x4*x6 + x3*x4*x5 + (6)*x2*x6^2 + (-3)*x2*x5*x6 + (-3)*x2*x4*x6 + x2*x4*x5 + (-3)*x2*x3*x6 + x2*x3*x5 + x2*x3*x4 + (6)*x1*x6^2 + (-3)*x1*x5*x6 + (-3)*x1*x4*x6 + x1*x4*x5 + (-3)*x1*x3*x6 + x1*x3*x5 + x1*x3*x4 + (-3)*x1*x2*x6 + x1*x2*x5 + x1*x2*x4 + x1*x2*x3,
(12)*x5*x6^2 + (-4)*x5^2*x6 + (12)*x4*x6^2 + (-4)*x4*x5*x6 + x4*x5^2 + (-4)*x4^2*x6 + x4^2*x5 + (12)*x3*x6^2 + (-4)*x3*x5*x6 + x3*x5^2 + (-4)*x3*x4*x6 + x3*x4^2 + (-4)*x3^2*x6 + x3^2*x5 + x3^2*x4 + (12)*x2*x6^2 + (-4)*x2*x5*x6 + x2*x5^2 + (-4)*x2*x4*x6 + x2*x4^2 + (-4)*x2*x3*x6 + x2*x3^2 + (-4)*x2^2*x6 + x2^2*x5 + x2^2*x4 + x2^2*x3 + (12)*x1*x6^2 + (-4)*x1*x5*x6 + x1*x5^2 + (-4)*x1*x4*x6 + x1*x4^2 + (-4)*x1*x3*x6 + x1*x3^2 + (-4)*x1*x2*x6 + x1*x2^2 + (-4)*x1^2*x6 + x1^2*x5 + x1^2*x4 + x1^2*x3 + x1^2*x2,
(3)*x5*x6^2 + (-3)*x5^2*x6 + x5^3 + (3)*x4*x6^2 + (-3)*x4^2*x6 + x4^3 + (3)*x3*x6^2 + (-3)*x3^2*x6 + x3^3 + (3)*x2*x6^2 + (-3)*x2^2*x6 + x2^3 + (3)*x1*x6^2 + (-3)*x1^2*x6 + x1^3
```

### Candidate job06_liftable_f11 | nonabelian

- G_s / symplectic: `S_{3,3}`
- generic No.: `35`; generic index: `2`; index: `6`; m: `1`
- G_id: `[ 216, 170 ]`; H_id: `[ 648, 746 ]`; order: `648`
- source: `job06_liftable_f11`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `5`; dim C: `4`
- n_gens: 7; n_basis: 5

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 0, -1, 0, 3 ]`

**Generators**

```gap
g1 := [ [ 1/3, -2/3, -2/3, 0, 0, 0 ], [ -2/3, 1/3, -2/3, 0, 0, 0 ], [ -2/3, -2/3, 1/3, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g2 := [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ 1/3, -2/3, -2/3, 0, 0, 0 ], [ -2/3, 1/3, -2/3, 0, 0, 0 ], [ -2/3, -2/3, 1/3, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g4 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, 0, -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, 0, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2 ] ];
g5 := [ [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g6 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 1, 0, 0 ] ];
g7 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x5*x6^2 + x5^2*x6 + x4*x6^2 + x4*x5^2 + x4^2*x6 + x4^2*x5,
x6^3 + x5^3 + (6)*x4*x5*x6 + x4^3,
x2*x3*x6 + x2*x3*x5 + x2*x3*x4 + x1*x3*x6 + x1*x3*x5 + x1*x3*x4 + x1*x2*x6 + x1*x2*x5 + x1*x2*x4,
x3^2*x6 + x3^2*x5 + x3^2*x4 + x2^2*x6 + x2^2*x5 + x2^2*x4 + x1^2*x6 + x1^2*x5 + x1^2*x4,
x3^3 + (-3/2)*x2*x3^2 + (-3/2)*x2^2*x3 + x2^3 + (-3/2)*x1*x3^2 + (6)*x1*x2*x3 + (-3/2)*x1*x2^2 + (-3/2)*x1^2*x3 + (-3/2)*x1^2*x2 + x1^3
```

### Candidate job06_liftable_f14 | nonabelian

- G_s / symplectic: `S_{3,3}`
- generic No.: `35`; generic index: `2`; index: `6`; m: `0`
- G_id: `[ 216, 170 ]`; H_id: `[ 648, 746 ]`; order: `648`
- source: `job06_liftable_f14`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `4`; dim C: `4`
- n_gens: 7; n_basis: 4

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, -2, 3, -4 ]`

**Generators**

```gap
g1 := [ [ 1/3, -2/3, -2/3, 0, 0, 0 ], [ -2/3, 1/3, -2/3, 0, 0, 0 ], [ -2/3, -2/3, 1/3, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g2 := [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ 1/3, -2/3, -2/3, 0, 0, 0 ], [ -2/3, 1/3, -2/3, 0, 0, 0 ], [ -2/3, -2/3, 1/3, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g4 := [ [ 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 0, 0, 0 ], [ -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 0, 0, 0 ], [ -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, 0, 0, 0 ], [ 0, 0, 0, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, 0, -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, 0, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2 ] ];
g5 := [ [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g6 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 1, 0, 0 ] ];
g7 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x5*x6^2 + x5^2*x6 + x4*x6^2 + x4*x5^2 + x4^2*x6 + x4^2*x5,
x6^3 + x5^3 + (6)*x4*x5*x6 + x4^3,
x3^2*x6 + x3^2*x5 + x3^2*x4 + (2)*x2*x3*x6 + (2)*x2*x3*x5 + (2)*x2*x3*x4 + x2^2*x6 + x2^2*x5 + x2^2*x4 + (2)*x1*x3*x6 + (2)*x1*x3*x5 + (2)*x1*x3*x4 + (2)*x1*x2*x6 + (2)*x1*x2*x5 + (2)*x1*x2*x4 + x1^2*x6 + x1^2*x5 + x1^2*x4,
x3^3 + (-3/2)*x2*x3^2 + (-3/2)*x2^2*x3 + x2^3 + (-3/2)*x1*x3^2 + (6)*x1*x2*x3 + (-3/2)*x1*x2^2 + (-3/2)*x1^2*x3 + (-3/2)*x1^2*x2 + x1^3
```

### Candidate job07_liftable_f4 | nonabelian

- G_s / symplectic: `S_{3,3}`
- generic No.: `37`; generic index: `2`; index: `6`; m: `0`
- G_id: `[ 216, 157 ]`; H_id: `[ 648, 718 ]`; order: `648`
- source: `job07_liftable_f4`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `5`; dim C: `5`
- n_gens: 7; n_basis: 5

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, -1, 1 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 1, -1, 0, 0 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, -1 ], [ 0, 0, 0, 0, 0, -1 ] ];
g5 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 1, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 0, 0, -1 ], [ 0, 0, 0, 0, 1, -1 ] ];
g6 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 1, -1, 0, 0 ], [ 0, 0, 0, 0, 0, -1 ], [ 0, 0, 0, 0, 1, -1 ] ];
g7 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x5*x6^2 + x5^2*x6 + x3*x4^2 + x3^2*x4,
x2^3,
x1*x2^2,
x1^2*x2,
x1^3
```

### Candidate job07_liftable_f8 | nonabelian

- G_s / symplectic: `S_{3,3}`
- generic No.: `37`; generic index: `2`; index: `6`; m: `1`
- G_id: `[ 216, 157 ]`; H_id: `[ 648, 718 ]`; order: `648`
- source: `job07_liftable_f8`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `4`; dim C: `3`
- n_gens: 7; n_basis: 4

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, -1, 1 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 1, -1, 0, 0 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ E(3)-E(3)^2, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, -1 ], [ 0, 0, 0, 0, 0, -1 ] ];
g5 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 1, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 0, 0, -1 ], [ 0, 0, 0, 0, 1, -1 ] ];
g6 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 1, -1, 0, 0 ], [ 0, 0, 0, 0, 0, -1 ], [ 0, 0, 0, 0, 1, -1 ] ];
g7 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x5*x6^2 + x5^2*x6 + x3*x4^2 + x3^2*x4,
x2^3,
-x2*x6^2 + -x2*x5*x6 + -x2*x5^2 + -x2*x4^2 + -x2*x3*x4 + -x2*x3^2 + x1*x6^2 + x1*x5*x6 + x1*x5^2 + x1*x4^2 + x1*x3*x4 + x1*x3^2,
(3)*x1*x2^2 + (-3)*x1^2*x2 + x1^3
```

### Candidate job08_liftable_f3 | nonabelian

- G_s / symplectic: `\mathrm{QD}_{16}`
- generic No.: `43`; generic index: `1`; index: `2`; m: `1`
- G_id: `[ 32, 42 ]`; H_id: `[ 96, 182 ]`; order: `96`
- source: `job08_liftable_f3`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `5`; dim C: `4`
- n_gens: 6; n_basis: 5

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 8, -7, -8, -6, 8 ]`

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 0, 0, -E(4) ], [ 0, 0, 0, 0, E(4), 0 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 0, E(4), 0, 0 ], [ 0, 0, -E(4), 0, 0, 0 ], [ 0, 0, 0, 0, 0, E(8) ], [ 0, 0, 0, 0, -E(8)^3, 0 ] ];
g3 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, E(4), 0 ], [ 0, 0, 0, 0, 0, E(4) ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, -E(4), 0 ], [ 0, 0, 0, 0, 0, E(4) ] ];
g5 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, -1 ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x4*x5^2 + x3*x6^2,
x2*x4^2 + x2*x3^2,
x1*x3*x4,
x1*x2^2,
x1^3
```

### Candidate job09_liftable_f4 | nonabelian

- G_s / symplectic: `S_4`
- generic No.: `45`; generic index: `1`; index: `2`; m: `2`
- G_id: `[ 48, 48 ]`; H_id: `[ 144, 188 ]`; order: `144`
- source: `job09_liftable_f4`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `5`; dim C: `3`
- n_gens: 6; n_basis: 5

- smooth witness prime: `7`; coefficients in the displayed basis: `[ 1, 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 0, 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, -E(3)^2 ], [ 0, 0, 0, 0, -E(3), 0 ] ];
g2 := [ [ -1/2, 1/2, 1/2, 1/2, 0, 0 ], [ 1/2, -1/2, 1/2, 1/2, 0, 0 ], [ 1/2, 1/2, -1/2, 1/2, 0, 0 ], [ 1/2, 1/2, 1/2, -1/2, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ];
g4 := [ [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g5 := [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
-x6^3 + x5^3,
x4*x5*x6 + x3*x5*x6 + x2*x5*x6 + x1*x5*x6,
(-E(3)^2)*x3*x4*x6 + x3*x4*x5 + -x2*x4*x6 + (E(3)^2)*x2*x4*x5 + (-E(3))*x2*x3*x6 + (E(3))*x2*x3*x5 + (-E(3))*x1*x4*x6 + (E(3))*x1*x4*x5 + -x1*x3*x6 + (E(3)^2)*x1*x3*x5 + (-E(3)^2)*x1*x2*x6 + x1*x2*x5,
x3*x4^2 + x3^2*x4 + x2*x4^2 + (3)*x2*x3*x4 + x2*x3^2 + x2^2*x4 + x2^2*x3 + x1*x4^2 + (3)*x1*x3*x4 + x1*x3^2 + (3)*x1*x2*x4 + (3)*x1*x2*x3 + x1*x2^2 + x1^2*x4 + x1^2*x3 + x1^2*x2,
x4^3 + x3^3 + (-3)*x2*x3*x4 + x2^3 + (-3)*x1*x3*x4 + (-3)*x1*x2*x4 + (-3)*x1*x2*x3 + x1^3
```

### Candidate job10_liftable_f3 | nonabelian

- G_s / symplectic: `Q_8`
- generic No.: `48`; generic index: `1`; index: `2`; m: `2`
- G_id: `[ 16, 13 ]`; H_id: `[ 48, 47 ]`; order: `48`
- source: `job10_liftable_f3`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `7`; dim C: `5`
- n_gens: 5; n_basis: 7

- smooth witness prime: `5`; coefficients in the displayed basis: `[ -2, -2, 6, -11, 2, 2, 4 ]`

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, -E(4) ], [ 0, 0, 0, 0, E(4), 0 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g3 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, -E(4), 0 ], [ 0, 0, 0, 0, 0, -E(4) ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, -1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
-x4*x6^2 + x4*x5^2,
x3*x6^2 + x3*x5^2,
x2*x3*x4,
x1*x4^2,
x1*x3^2,
x1*x2^2,
x1^3
```

### Candidate job11_liftable_f1 | nonabelian

- G_s / symplectic: `Q_8`
- generic No.: `48`; generic index: `1`; index: `3`; m: `1`
- G_id: `[ 24, 3 ]`; H_id: `[ 72, 25 ]`; order: `72`
- source: `job11_liftable_f1`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `4`; dim C: `3`
- n_gens: 5; n_basis: 4

- smooth witness prime: `13`; coefficients in the displayed basis: `[ 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, -1/2+1/2*E(4), 1/2+1/2*E(4) ], [ 0, 0, 0, 0, -1/2+1/2*E(4), -1/2-1/2*E(4) ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, -1, 0 ] ];
g3 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, E(4) ], [ 0, 0, 0, 0, E(4), 0 ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, -1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
(-1/2)*x4*x6^2 + (1/2)*x4*x5^2 + (1/2*E(4))*x3*x6^2 + (1/2*E(4))*x3*x5^2 + x2*x5*x6,
x2*x3*x4,
(E(3)^2)*x1*x4^2 + (E(3))*x1*x3^2 + x1*x2^2,
x1^3
```

### Candidate job12_liftable_f13 | nonabelian

- G_s / symplectic: `Q_8`
- generic No.: `48`; generic index: `1`; index: `4`; m: `1`
- G_id: `[ 32, 11 ]`; H_id: `[ 96, 54 ]`; order: `96`
- source: `job12_liftable_f13`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `5`; dim C: `4`
- n_gens: 6; n_basis: 5

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 8, -7, -8, -6, 8 ]`

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, E(4), 0 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, E(4) ], [ 0, 0, 0, 0, -E(4), 0 ] ];
g3 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, -E(4), 0 ], [ 0, 0, 0, 0, 0, E(4) ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, E(4), 0 ], [ 0, 0, 0, 0, 0, E(4) ] ];
g5 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, -1 ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
-x4*x6^2 + x4*x5^2 + x3*x6^2 + x3*x5^2,
x2*x3*x4,
x1*x4^2 + x1*x3^2,
x1*x2^2,
x1^3
```

### Candidate job13_nonliftable_f1 | nonabelian

- G_s / symplectic: `A_{3,3}`
- generic No.: `52`; generic index: `1`; index: `2`; m: `2`
- G_id: `[ 36, 13 ]`; H_id: `[ 108, 28 ]`; order: `108`
- source: `job13_nonliftable_f1`; liftable: `nonliftable`
- status: `smooth_candidate`; dim V3: `4`; dim C: `2`
- n_gens: 5; n_basis: 4

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 2, 3, 4 ]`

**Generators**

```gap
g1 := [ [ -1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 2, 0, 0, 1, 0, 0 ], [ 0, 2, 0, 0, 1, 0 ], [ 0, 0, 2, 0, 0, 1 ] ];
g2 := [ [ 0, E(3), 0, 0, 0, 0 ], [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ E(3), 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ], [ 0, 0, 0, E(3), 0, 0 ] ];
g4 := [ [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, E(3)^2, 0, 0 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x4*x5*x6,
x6^3 + x5^3 + x4^3,
(-2)*x3*x4*x5 + (-2)*x2*x4*x6 + x2*x3*x4 + (-2)*x1*x5*x6 + x1*x3*x5 + x1*x2*x6,
(-2)*x3*x6^2 + x3^2*x6 + (-2)*x2*x5^2 + x2^2*x5 + (-2)*x1*x4^2 + x1^2*x4
```

### Candidate job14_nonliftable_f1 | nonabelian

- G_s / symplectic: `A_{3,3}`
- generic No.: `52`; generic index: `1`; index: `3`; m: `0`
- G_id: `[ 54, 5 ]`; H_id: `[ 162, 10 ]`; order: `162`
- source: `job14_nonliftable_f1`; liftable: `nonliftable`
- status: `smooth_candidate`; dim V3: `4`; dim C: `4`
- n_gens: 5; n_basis: 4

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 0, 0, 2 ]`

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g2 := [ [ 1/3*E(3)+2/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 0, 0, 0 ], [ 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 0, 0, 0 ], [ 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2, 0, 0, 0 ], [ 0, 0, 0, 1/3*E(3)+2/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2 ], [ 0, 0, 0, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2 ], [ 0, 0, 0, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2 ] ];
g3 := [ [ 0, 0, E(3)^2, 0, 0, 0 ], [ E(3), 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, 1, 0 ] ];
g4 := [ [ 0, 0, E(3)^2, 0, 0, 0 ], [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ], [ 0, 0, 0, E(3)^2, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3 + x5^3 + (6)*x4*x5*x6 + x4^3,
x3*x6^2 + (2)*x3*x4*x5 + x2*x5^2 + (2)*x2*x4*x6 + (2)*x1*x5*x6 + x1*x4^2,
x3^2*x6 + (2)*x2*x3*x4 + x2^2*x5 + (2)*x1*x3*x5 + (2)*x1*x2*x6 + x1^2*x4,
x3^3 + x2^3 + (6)*x1*x2*x3 + x1^3
```

### Candidate job14_nonliftable_f2 | nonabelian

- G_s / symplectic: `A_{3,3}`
- generic No.: `52`; generic index: `1`; index: `3`; m: `1`
- G_id: `[ 54, 5 ]`; H_id: `[ 162, 10 ]`; order: `162`
- source: `job14_nonliftable_f2`; liftable: `nonliftable`
- status: `smooth_candidate`; dim V3: `3`; dim C: `2`
- n_gens: 5; n_basis: 3

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 2, 3 ]`

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g2 := [ [ 1/3*E(3)+2/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 0, 0, 0 ], [ 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 0, 0, 0 ], [ 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2, 0, 0, 0 ], [ -E(3)^2, -E(3), -E(3), 1/3*E(3)-1/3*E(3)^2, -2/3*E(3)-1/3*E(3)^2, -2/3*E(3)-1/3*E(3)^2 ], [ -E(3), -E(3)^2, -E(3), -2/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, -2/3*E(3)-1/3*E(3)^2 ], [ -E(3), -E(3), -E(3)^2, -2/3*E(3)-1/3*E(3)^2, -2/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2 ] ];
g3 := [ [ 0, 0, E(3)^2, 0, 0, 0 ], [ E(3), 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, 1, 0 ] ];
g4 := [ [ 0, 0, E(3)^2, 0, 0, 0 ], [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ], [ 0, 0, 0, E(3)^2, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3 + x5^3 + (6)*x4*x5*x6 + x4^3,
(9)*x4*x5*x6 + x3*x6^2 + -x3*x4*x5 + x2*x5^2 + -x2*x4*x6 + -x1*x5*x6 + x1*x4^2,
(-27)*x4*x5*x6 + (9)*x3*x4*x5 + (-3)*x3^2*x6 + x3^3 + (9)*x2*x4*x6 + (-6)*x2*x3*x4 + (-3)*x2^2*x5 + x2^3 + (9)*x1*x5*x6 + (-6)*x1*x3*x5 + (-6)*x1*x2*x6 + (6)*x1*x2*x3 + (-3)*x1^2*x4 + x1^3
```

### Candidate job15_liftable_f11 | nonabelian

- G_s / symplectic: `A_{3,3}`
- generic No.: `55`; generic index: `2`; index: `6`; m: `2`
- G_id: `[ 108, 38 ]`; H_id: `[ 324, 165 ]`; order: `324`
- source: `job15_liftable_f11`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `8`; dim C: `6`
- n_gens: 6; n_basis: 8

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 2, 3, 4, 5, 6, 7, 8 ]`

**Generators**

```gap
g1 := [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g3 := [ [ 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 0, 0, 0 ], [ -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 0, 0, 0 ], [ -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 1, 0, 0 ] ];
g5 := [ [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x4*x5*x6,
x5*x6^2 + x5^2*x6 + x4*x6^2 + x4*x5^2 + x4^2*x6 + x4^2*x5,
x6^3 + x5^3 + x4^3,
x3*x5*x6 + x3*x4*x6 + x3*x4*x5 + x2*x5*x6 + x2*x4*x6 + x2*x4*x5 + x1*x5*x6 + x1*x4*x6 + x1*x4*x5,
x3*x6^2 + x3*x5^2 + x3*x4^2 + x2*x6^2 + x2*x5^2 + x2*x4^2 + x1*x6^2 + x1*x5^2 + x1*x4^2,
x3^2*x6 + x3^2*x5 + x3^2*x4 + (2)*x2*x3*x6 + (2)*x2*x3*x5 + (2)*x2*x3*x4 + x2^2*x6 + x2^2*x5 + x2^2*x4 + (2)*x1*x3*x6 + (2)*x1*x3*x5 + (2)*x1*x3*x4 + (2)*x1*x2*x6 + (2)*x1*x2*x5 + (2)*x1*x2*x4 + x1^2*x6 + x1^2*x5 + x1^2*x4,
x2*x3^2 + x2^2*x3 + x1*x3^2 + x1*x2^2 + x1^2*x3 + x1^2*x2,
x3^3 + x2^3 + (6)*x1*x2*x3 + x1^3
```

### Candidate job15_liftable_f14 | nonabelian

- G_s / symplectic: `A_{3,3}`
- generic No.: `55`; generic index: `2`; index: `6`; m: `0`
- G_id: `[ 108, 38 ]`; H_id: `[ 324, 165 ]`; order: `324`
- source: `job15_liftable_f14`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `6`; dim C: `6`
- n_gens: 6; n_basis: 6

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 1, 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g3 := [ [ 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 0, 0, 0 ], [ -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 0, 0, 0 ], [ -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, 0, 0, 0 ], [ 0, 0, 0, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, 0, -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, 0, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2 ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 1, 0, 0 ] ];
g5 := [ [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x5*x6^2 + x5^2*x6 + x4*x6^2 + x4*x5^2 + x4^2*x6 + x4^2*x5,
x6^3 + x5^3 + (6)*x4*x5*x6 + x4^3,
x3*x6^2 + (2)*x3*x5*x6 + x3*x5^2 + (2)*x3*x4*x6 + (2)*x3*x4*x5 + x3*x4^2 + x2*x6^2 + (2)*x2*x5*x6 + x2*x5^2 + (2)*x2*x4*x6 + (2)*x2*x4*x5 + x2*x4^2 + x1*x6^2 + (2)*x1*x5*x6 + x1*x5^2 + (2)*x1*x4*x6 + (2)*x1*x4*x5 + x1*x4^2,
x3^2*x6 + x3^2*x5 + x3^2*x4 + (2)*x2*x3*x6 + (2)*x2*x3*x5 + (2)*x2*x3*x4 + x2^2*x6 + x2^2*x5 + x2^2*x4 + (2)*x1*x3*x6 + (2)*x1*x3*x5 + (2)*x1*x3*x4 + (2)*x1*x2*x6 + (2)*x1*x2*x5 + (2)*x1*x2*x4 + x1^2*x6 + x1^2*x5 + x1^2*x4,
x2*x3^2 + x2^2*x3 + x1*x3^2 + x1*x2^2 + x1^2*x3 + x1^2*x2,
x3^3 + x2^3 + (6)*x1*x2*x3 + x1^3
```

### Candidate job15_liftable_f26 | nonabelian

- G_s / symplectic: `A_{3,3}`
- generic No.: `55`; generic index: `2`; index: `6`; m: `2`
- G_id: `[ 108, 38 ]`; H_id: `[ 324, 165 ]`; order: `324`
- source: `job15_liftable_f26`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `6`; dim C: `4`
- n_gens: 6; n_basis: 6

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 0, -1, 0, 0, 3 ]`

**Generators**

```gap
g1 := [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g3 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2 ], [ 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2 ], [ 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2 ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 1, 0, 0 ] ];
g5 := [ [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x5*x6^2 + x5^2*x6 + x4*x6^2 + x4*x5^2 + x4^2*x6 + x4^2*x5,
x6^3 + x5^3 + (6)*x4*x5*x6 + x4^3,
(9)*x4*x5*x6 + x3*x6^2 + -x3*x5*x6 + x3*x5^2 + -x3*x4*x6 + -x3*x4*x5 + x3*x4^2 + x2*x6^2 + -x2*x5*x6 + x2*x5^2 + -x2*x4*x6 + -x2*x4*x5 + x2*x4^2 + x1*x6^2 + -x1*x5*x6 + x1*x5^2 + -x1*x4*x6 + -x1*x4*x5 + x1*x4^2,
-x4*x5*x6 + (1/3)*x3*x5*x6 + (1/3)*x3*x4*x6 + (1/3)*x3*x4*x5 + (1/3)*x2*x5*x6 + (1/3)*x2*x4*x6 + (1/3)*x2*x4*x5 + (-1/3)*x2*x3*x6 + (-1/3)*x2*x3*x5 + (-1/3)*x2*x3*x4 + (1/3)*x1*x5*x6 + (1/3)*x1*x4*x6 + (1/3)*x1*x4*x5 + (-1/3)*x1*x3*x6 + (-1/3)*x1*x3*x5 + (-1/3)*x1*x3*x4 + (-1/3)*x1*x2*x6 + (-1/3)*x1*x2*x5 + (-1/3)*x1*x2*x4 + x1*x2*x3,
(-6)*x4*x5*x6 + (2)*x3*x5*x6 + (2)*x3*x4*x6 + (2)*x3*x4*x5 + (-2/3)*x3^2*x6 + (-2/3)*x3^2*x5 + (-2/3)*x3^2*x4 + (2)*x2*x5*x6 + (2)*x2*x4*x6 + (2)*x2*x4*x5 + (-4/3)*x2*x3*x6 + (-4/3)*x2*x3*x5 + (-4/3)*x2*x3*x4 + x2*x3^2 + (-2/3)*x2^2*x6 + (-2/3)*x2^2*x5 + (-2/3)*x2^2*x4 + x2^2*x3 + (2)*x1*x5*x6 + (2)*x1*x4*x6 + (2)*x1*x4*x5 + (-4/3)*x1*x3*x6 + (-4/3)*x1*x3*x5 + (-4/3)*x1*x3*x4 + x1*x3^2 + (-4/3)*x1*x2*x6 + (-4/3)*x1*x2*x5 + (-4/3)*x1*x2*x4 + x1*x2^2 + (-2/3)*x1^2*x6 + (-2/3)*x1^2*x5 + (-2/3)*x1^2*x4 + x1^2*x3 + x1^2*x2,
(-3)*x4*x5*x6 + x3*x5*x6 + x3*x4*x6 + x3*x4*x5 + -x3^2*x6 + -x3^2*x5 + -x3^2*x4 + x3^3 + x2*x5*x6 + x2*x4*x6 + x2*x4*x5 + -x2^2*x6 + -x2^2*x5 + -x2^2*x4 + x2^3 + x1*x5*x6 + x1*x4*x6 + x1*x4*x5 + -x1^2*x6 + -x1^2*x5 + -x1^2*x4 + x1^3
```

### Candidate job15_liftable_f28 | nonabelian

- G_s / symplectic: `A_{3,3}`
- generic No.: `55`; generic index: `2`; index: `6`; m: `1`
- G_id: `[ 108, 38 ]`; H_id: `[ 324, 165 ]`; order: `324`
- source: `job15_liftable_f28`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `5`; dim C: `4`
- n_gens: 6; n_basis: 5

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 2, 3, 4, 5 ]`

**Generators**

```gap
g1 := [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g3 := [ [ -2/3*E(3)-1/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2, 0, 0, 0 ], [ 1/3*E(3)+2/3*E(3)^2, -2/3*E(3)-1/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2, 0, 0, 0 ], [ 1/3*E(3)+2/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2, -2/3*E(3)-1/3*E(3)^2, 0, 0, 0 ], [ 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2 ], [ 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2 ], [ 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)-1/3*E(3)^2, 1/3*E(3)+2/3*E(3)^2 ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 1, 0, 0 ] ];
g5 := [ [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x5*x6^2 + x5^2*x6 + x4*x6^2 + x4*x5^2 + x4^2*x6 + x4^2*x5,
x6^3 + x5^3 + (6)*x4*x5*x6 + x4^3,
(9)*x4*x5*x6 + x3*x6^2 + -x3*x5*x6 + x3*x5^2 + -x3*x4*x6 + -x3*x4*x5 + x3*x4^2 + x2*x6^2 + -x2*x5*x6 + x2*x5^2 + -x2*x4*x6 + -x2*x4*x5 + x2*x4^2 + x1*x6^2 + -x1*x5*x6 + x1*x5^2 + -x1*x4*x6 + -x1*x4*x5 + x1*x4^2,
(-6)*x4*x5*x6 + (2)*x3*x5*x6 + (2)*x3*x4*x6 + (2)*x3*x4*x5 + (-2/3)*x3^2*x6 + (-2/3)*x3^2*x5 + (-2/3)*x3^2*x4 + (2)*x2*x5*x6 + (2)*x2*x4*x6 + (2)*x2*x4*x5 + (-4/3)*x2*x3*x6 + (-4/3)*x2*x3*x5 + (-4/3)*x2*x3*x4 + x2*x3^2 + (-2/3)*x2^2*x6 + (-2/3)*x2^2*x5 + (-2/3)*x2^2*x4 + x2^2*x3 + (2)*x1*x5*x6 + (2)*x1*x4*x6 + (2)*x1*x4*x5 + (-4/3)*x1*x3*x6 + (-4/3)*x1*x3*x5 + (-4/3)*x1*x3*x4 + x1*x3^2 + (-4/3)*x1*x2*x6 + (-4/3)*x1*x2*x5 + (-4/3)*x1*x2*x4 + x1*x2^2 + (-2/3)*x1^2*x6 + (-2/3)*x1^2*x5 + (-2/3)*x1^2*x4 + x1^2*x3 + x1^2*x2,
(-9)*x4*x5*x6 + (3)*x3*x5*x6 + (3)*x3*x4*x6 + (3)*x3*x4*x5 + -x3^2*x6 + -x3^2*x5 + -x3^2*x4 + x3^3 + (3)*x2*x5*x6 + (3)*x2*x4*x6 + (3)*x2*x4*x5 + (-2)*x2*x3*x6 + (-2)*x2*x3*x5 + (-2)*x2*x3*x4 + -x2^2*x6 + -x2^2*x5 + -x2^2*x4 + x2^3 + (3)*x1*x5*x6 + (3)*x1*x4*x6 + (3)*x1*x4*x5 + (-2)*x1*x3*x6 + (-2)*x1*x3*x5 + (-2)*x1*x3*x4 + (-2)*x1*x2*x6 + (-2)*x1*x2*x5 + (-2)*x1*x2*x4 + (6)*x1*x2*x3 + -x1^2*x6 + -x1^2*x5 + -x1^2*x4 + x1^3
```

### Candidate job15_liftable_f29 | nonabelian

- G_s / symplectic: `A_{3,3}`
- generic No.: `55`; generic index: `2`; index: `6`; m: `0`
- G_id: `[ 108, 38 ]`; H_id: `[ 324, 165 ]`; order: `324`
- source: `job15_liftable_f29`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `3`; dim C: `3`
- n_gens: 6; n_basis: 3

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ -1/3, -1/3, -1/3, -1/3, 2/3, -1/3 ], [ -1/3, -1/3, -1/3, -1/3, -1/3, 2/3 ], [ -1/3, -1/3, -1/3, 2/3, -1/3, -1/3 ], [ 1/3, 1/3, 4/3, 1/3, 1/3, 1/3 ], [ 4/3, 1/3, 1/3, 1/3, 1/3, 1/3 ], [ 1/3, 4/3, 1/3, 1/3, 1/3, 1/3 ] ];
g2 := [ [ -1/3, -1/3, -1/3, -1/3, -1/3, 2/3 ], [ -1/3, -1/3, -1/3, -1/3, 2/3, -1/3 ], [ -1/3, -1/3, -1/3, 2/3, -1/3, -1/3 ], [ 1/3, 1/3, 4/3, 1/3, 1/3, 1/3 ], [ 1/3, 4/3, 1/3, 1/3, 1/3, 1/3 ], [ 4/3, 1/3, 1/3, 1/3, 1/3, 1/3 ] ];
g3 := [ [ 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 0, 0, 0 ], [ -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 0, 0, 0 ], [ -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, 0, 0, 0 ], [ 0, 0, 0, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, 0, -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2 ], [ 0, 0, 0, -1/3*E(3)+1/3*E(3)^2, -1/3*E(3)+1/3*E(3)^2, 2/3*E(3)+1/3*E(3)^2 ] ];
g4 := [ [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 1, 0, 0 ] ];
g5 := [ [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 1, 0, 0 ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3 + (3)*x5*x6^2 + (3)*x5^2*x6 + x5^3 + (3)*x4*x6^2 + (6)*x4*x5*x6 + (3)*x4*x5^2 + (3)*x4^2*x6 + (3)*x4^2*x5 + x4^3,
(-2)*x3*x6^2 + (-4)*x3*x5*x6 + (-2)*x3*x5^2 + (-4)*x3*x4*x6 + (-4)*x3*x4*x5 + (-2)*x3*x4^2 + x3^2*x6 + x3^2*x5 + x3^2*x4 + (-2)*x2*x6^2 + (-4)*x2*x5*x6 + (-2)*x2*x5^2 + (-4)*x2*x4*x6 + (-4)*x2*x4*x5 + (-2)*x2*x4^2 + (2)*x2*x3*x6 + (2)*x2*x3*x5 + (2)*x2*x3*x4 + x2^2*x6 + x2^2*x5 + x2^2*x4 + (-2)*x1*x6^2 + (-4)*x1*x5*x6 + (-2)*x1*x5^2 + (-4)*x1*x4*x6 + (-4)*x1*x4*x5 + (-2)*x1*x4^2 + (2)*x1*x3*x6 + (2)*x1*x3*x5 + (2)*x1*x3*x4 + (2)*x1*x2*x6 + (2)*x1*x2*x5 + (2)*x1*x2*x4 + x1^2*x6 + x1^2*x5 + x1^2*x4,
(-9/2)*x5*x6^2 + (-9/2)*x5^2*x6 + (-9/2)*x4*x6^2 + (-9/2)*x4*x5^2 + (-9/2)*x4^2*x6 + (-9/2)*x4^2*x5 + x3^3 + (-3/2)*x2*x3^2 + (-3/2)*x2^2*x3 + x2^3 + (-3/2)*x1*x3^2 + (6)*x1*x2*x3 + (-3/2)*x1*x2^2 + (-3/2)*x1^2*x3 + (-3/2)*x1^2*x2 + x1^3
```

### Candidate job16_liftable_f4 | nonabelian

- G_s / symplectic: `D_{12}`
- generic No.: `58`; generic index: `1`; index: `2`; m: `2`
- G_id: `[ 24, 8 ]`; H_id: `[ 72, 30 ]`; order: `72`
- source: `job16_liftable_f4`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `8`; dim C: `6`
- n_gens: 5; n_basis: 8

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 1, 1, 1, 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g4 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3,
x5*x6^2,
x5^2*x6,
x5^3,
x1*x3*x6,
x1*x3*x5,
x3*x4^2 + x1*x2^2,
x3^3 + x1^3
```

### Candidate job17_liftable_f2 | nonabelian

- G_s / symplectic: `D_{12}`
- generic No.: `58`; generic index: `1`; index: `2`; m: `2`
- G_id: `[ 24, 14 ]`; H_id: `[ 72, 48 ]`; order: `72`
- source: `job17_liftable_f2`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `6`; dim C: `4`
- n_gens: 5; n_basis: 6

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 3, -9, 6, 7, -6, -4 ]`

**Generators**

```gap
g1 := [ [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, -E(3)^2, 0, 0 ], [ E(3), 0, 0, 0, 0, 0 ], [ 0, -E(3), 0, 0, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 2, 1 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 2, 1 ] ];
g4 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3,
(-2)*x5*x6^2 + x5^2*x6,
x2*x4*x6,
x1*x3*x6,
x3*x4^2 + x1*x2^2,
x3^3 + x1^3
```

### Candidate job18_liftable_f3 | nonabelian

- G_s / symplectic: `D_{12}`
- generic No.: `58`; generic index: `1`; index: `3`; m: `0`
- G_id: `[ 36, 12 ]`; H_id: `[ 108, 42 ]`; order: `108`
- source: `job18_liftable_f3`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `6`; dim C: `6`
- n_gens: 5; n_basis: 6

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 1, 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ];
g4 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3,
x5*x6^2,
x5^2*x6,
x5^3,
x3*x4^2 + x1*x2^2,
x3^3 + x1^3
```

### Candidate job18_liftable_f4 | nonabelian

- G_s / symplectic: `D_{12}`
- generic No.: `58`; generic index: `1`; index: `3`; m: `2`
- G_id: `[ 36, 12 ]`; H_id: `[ 108, 42 ]`; order: `108`
- source: `job18_liftable_f4`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `6`; dim C: `4`
- n_gens: 5; n_basis: 6

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 1, 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, E(3)-E(3)^2, E(3) ] ];
g4 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3,
(3)*x5*x6^2 + (-3)*x5^2*x6 + x5^3,
-x2*x4*x6 + x2*x4*x5,
-x1*x3*x6 + x1*x3*x5,
x3*x4^2 + x1*x2^2,
x3^3 + x1^3
```

### Candidate job19_liftable_f12 | nonabelian

- G_s / symplectic: `D_{12}`
- generic No.: `58`; generic index: `1`; index: `6`; m: `0`
- G_id: `[ 72, 30 ]`; H_id: `[ 216, 139 ]`; order: `216`
- source: `job19_liftable_f12`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `6`; dim C: `6`
- n_gens: 6; n_basis: 6

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 1, 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3,
x5*x6^2,
x5^2*x6,
x5^3,
x3*x4^2 + x1*x2^2,
x3^3 + x1^3
```

### Candidate job19_liftable_f21 | nonabelian

- G_s / symplectic: `D_{12}`
- generic No.: `58`; generic index: `1`; index: `6`; m: `1`
- G_id: `[ 72, 30 ]`; H_id: `[ 216, 139 ]`; order: `216`
- source: `job19_liftable_f21`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `5`; dim C: `4`
- n_gens: 6; n_basis: 5

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, E(3)-E(3)^2, E(3) ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3,
(3)*x5*x6^2 + (-3)*x5^2*x6 + x5^3,
-x1*x3*x6 + x1*x3*x5,
x3*x4^2 + x1*x2^2,
x3^3 + x1^3
```

### Candidate job20_liftable_f6 | nonabelian

- G_s / symplectic: `D_{12}`
- generic No.: `63`; generic index: `2`; index: `6`; m: `2`
- G_id: `[ 72, 48 ]`; H_id: `[ 216, 174 ]`; order: `216`
- source: `job20_liftable_f6`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `9`; dim C: `7`
- n_gens: 6; n_basis: 9

- smooth witness prime: `5`; coefficients in the displayed basis: `[ -6, -8, 8, -9, 2, 5, -2, -3, -2 ]`

**Generators**

```gap
g1 := [ [ 0, -1, 0, 0, 0, 0 ], [ -1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g2 := [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ -1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g4 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
g5 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3 + x5^3,
x4^3,
x3*x4^2,
x3^2*x4,
x3^3,
x1*x2*x4,
x1*x2*x3,
x2^2*x4 + x1^2*x4,
x2^2*x3 + x1^2*x3
```

### Candidate job20_liftable_f54 | nonabelian

- G_s / symplectic: `D_{12}`
- generic No.: `63`; generic index: `2`; index: `6`; m: `1`
- G_id: `[ 72, 48 ]`; H_id: `[ 216, 174 ]`; order: `216`
- source: `job20_liftable_f54`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `6`; dim C: `5`
- n_gens: 6; n_basis: 6

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 1, 1, 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 0, -1, 0, 0, 0, 0 ], [ -1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g2 := [ [ 0, -1, 0, 0, 0, 0 ], [ -1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ -1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g4 := [ [ -1/2, 1/2*E(3)-1/2*E(3)^2, 0, 0, 0, 0 ], [ 1/2*E(3)-1/2*E(3)^2, -1/2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, E(3)-E(3)^2, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ];
g5 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3 + x5^3,
x4^3,
-x4*x5*x6 + x3*x5*x6,
(3)*x3*x4^2 + (-3)*x3^2*x4 + x3^3,
x2^2*x4 + (2)*x1*x2*x4 + x1^2*x4,
x2^2*x3 + (4)*x1*x2*x4 + (-2)*x1*x2*x3 + x1^2*x3
```

### Candidate job21_liftable_f4 | nonabelian

- G_s / symplectic: `A_4`
- generic No.: `65`; generic index: `1`; index: `2`; m: `3`
- G_id: `[ 24, 13 ]`; H_id: `[ 72, 47 ]`; order: `72`
- source: `job21_liftable_f4`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `7`; dim C: `4`
- n_gens: 5; n_basis: 7

- smooth witness prime: `7`; coefficients in the displayed basis: `[ 1, 1, 1, 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ -1/2, 1/2, 1/2, 1/2, 0, 0 ], [ 1/2, -1/2, 1/2, 1/2, 0, 0 ], [ 1/2, 1/2, -1/2, 1/2, 0, 0 ], [ 1/2, 1/2, 1/2, -1/2, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g2 := [ [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ E(3), 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g4 := [ [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3,
x5^3,
x4*x5*x6 + x3*x5*x6 + x2*x5*x6 + x1*x5*x6,
x3*x4*x6 + (E(3))*x2*x4*x6 + (E(3)^2)*x2*x3*x6 + (E(3)^2)*x1*x4*x6 + (E(3))*x1*x3*x6 + x1*x2*x6,
x3*x4*x5 + (E(3)^2)*x2*x4*x5 + (E(3))*x2*x3*x5 + (E(3))*x1*x4*x5 + (E(3)^2)*x1*x3*x5 + x1*x2*x5,
x3*x4^2 + x3^2*x4 + x2*x4^2 + (3)*x2*x3*x4 + x2*x3^2 + x2^2*x4 + x2^2*x3 + x1*x4^2 + (3)*x1*x3*x4 + x1*x3^2 + (3)*x1*x2*x4 + (3)*x1*x2*x3 + x1*x2^2 + x1^2*x4 + x1^2*x3 + x1^2*x2,
x4^3 + x3^3 + (-3)*x2*x3*x4 + x2^3 + (-3)*x1*x3*x4 + (-3)*x1*x2*x4 + (-3)*x1*x2*x3 + x1^3
```

### Candidate job22_liftable_f1 | nonabelian

- G_s / symplectic: `A_4`
- generic No.: `65`; generic index: `1`; index: `3`; m: `2`
- G_id: `[ 36, 11 ]`; H_id: `[ 108, 41 ]`; order: `108`
- source: `job22_liftable_f1`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `6`; dim C: `4`
- n_gens: 5; n_basis: 6

- smooth witness prime: `7`; coefficients in the displayed basis: `[ 1, -2, 3, -4, 5, -6 ]`

**Generators**

```gap
g1 := [ [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ];
g2 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
g3 := [ [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g4 := [ [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3,
x5^3,
x3*x4*x5 + (E(3)^2)*x2*x4*x5 + (E(3))*x2*x3*x5 + (E(3))*x1*x4*x5 + (E(3)^2)*x1*x3*x5 + x1*x2*x5,
x2*x3*x4 + x1*x3*x4 + x1*x2*x4 + x1*x2*x3,
x3*x4^2 + x3^2*x4 + x2*x4^2 + x2*x3^2 + x2^2*x4 + x2^2*x3 + x1*x4^2 + x1*x3^2 + x1*x2^2 + x1^2*x4 + x1^2*x3 + x1^2*x2,
x4^3 + x3^3 + x2^3 + x1^3
```

### Candidate job22_liftable_f2 | nonabelian

- G_s / symplectic: `A_4`
- generic No.: `65`; generic index: `1`; index: `3`; m: `1`
- G_id: `[ 36, 11 ]`; H_id: `[ 108, 41 ]`; order: `108`
- source: `job22_liftable_f2`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `5`; dim C: `4`
- n_gens: 5; n_basis: 5

- smooth witness prime: `7`; coefficients in the displayed basis: `[ 1, 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ];
g2 := [ [ 3/4*E(3)+1/4*E(3)^2, -1/4*E(3)+1/4*E(3)^2, -1/4*E(3)+1/4*E(3)^2, -1/4*E(3)+1/4*E(3)^2, 0, 0 ], [ -1/4*E(3)+1/4*E(3)^2, 3/4*E(3)+1/4*E(3)^2, -1/4*E(3)+1/4*E(3)^2, -1/4*E(3)+1/4*E(3)^2, 0, 0 ], [ -1/4*E(3)+1/4*E(3)^2, -1/4*E(3)+1/4*E(3)^2, 3/4*E(3)+1/4*E(3)^2, -1/4*E(3)+1/4*E(3)^2, 0, 0 ], [ -1/4*E(3)+1/4*E(3)^2, -1/4*E(3)+1/4*E(3)^2, -1/4*E(3)+1/4*E(3)^2, 3/4*E(3)+1/4*E(3)^2, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
g3 := [ [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g4 := [ [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3,
x5^3,
x3*x4*x6 + (E(3))*x2*x4*x6 + (E(3)^2)*x2*x3*x6 + (E(3)^2)*x1*x4*x6 + (E(3))*x1*x3*x6 + x1*x2*x6,
x3*x4^2 + x3^2*x4 + x2*x4^2 + x2*x3*x4 + x2*x3^2 + x2^2*x4 + x2^2*x3 + x1*x4^2 + x1*x3*x4 + x1*x3^2 + x1*x2*x4 + x1*x2*x3 + x1*x2^2 + x1^2*x4 + x1^2*x3 + x1^2*x2,
x4^3 + x3^3 + (3)*x2*x3*x4 + x2^3 + (3)*x1*x3*x4 + (3)*x1*x2*x4 + (3)*x1*x2*x3 + x1^3
```

### Candidate job23_liftable_f16 | nonabelian

- G_s / symplectic: `A_4`
- generic No.: `68`; generic index: `2`; index: `6`; m: `2`
- G_id: `[ 72, 42 ]`; H_id: `[ 216, 163 ]`; order: `216`
- source: `job23_liftable_f16`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `8`; dim C: `6`
- n_gens: 6; n_basis: 8

- smooth witness prime: `11`; coefficients in the displayed basis: `[ 1, 1, 1, 1, 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 0, 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g2 := [ [ 57/140*E(3)+83/140*E(3)^2, 57/140*E(3)-57/140*E(3)^2, 57/140*E(3)-57/140*E(3)^2, 57/140*E(3)-57/140*E(3)^2, 27/70*E(3)-27/70*E(3)^2, 3/20*E(3)-3/20*E(3)^2 ], [ 57/140*E(3)-57/140*E(3)^2, 57/140*E(3)+83/140*E(3)^2, 57/140*E(3)-57/140*E(3)^2, 57/140*E(3)-57/140*E(3)^2, 27/70*E(3)-27/70*E(3)^2, 3/20*E(3)-3/20*E(3)^2 ], [ 57/140*E(3)-57/140*E(3)^2, 57/140*E(3)-57/140*E(3)^2, 57/140*E(3)+83/140*E(3)^2, 57/140*E(3)-57/140*E(3)^2, 27/70*E(3)-27/70*E(3)^2, 3/20*E(3)-3/20*E(3)^2 ], [ 57/140*E(3)-57/140*E(3)^2, 57/140*E(3)-57/140*E(3)^2, 57/140*E(3)-57/140*E(3)^2, 57/140*E(3)+83/140*E(3)^2, 27/70*E(3)-27/70*E(3)^2, 3/20*E(3)-3/20*E(3)^2 ], [ -19/140*E(3)+19/140*E(3)^2, -19/140*E(3)+19/140*E(3)^2, -19/140*E(3)+19/140*E(3)^2, -19/140*E(3)+19/140*E(3)^2, -9/70*E(3)+79/70*E(3)^2, -1/20*E(3)+1/20*E(3)^2 ], [ -19/14*E(3)+19/14*E(3)^2, -19/14*E(3)+19/14*E(3)^2, -19/14*E(3)+19/14*E(3)^2, -19/14*E(3)+19/14*E(3)^2, -9/7*E(3)+9/7*E(3)^2, -1/2*E(3)+3/2*E(3)^2 ] ];
g3 := [ [ 0, 0, 0, 1, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g4 := [ [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g5 := [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
(-5832/343)*x6^3 + (972/49)*x5*x6^2 + (-54/7)*x5^2*x6 + x5^3,
(-24624/343)*x6^3 + (2736/49)*x5*x6^2 + (-76/7)*x5^2*x6 + (324/49)*x4*x6^2 + (-36/7)*x4*x5*x6 + x4*x5^2 + (324/49)*x3*x6^2 + (-36/7)*x3*x5*x6 + x3*x5^2 + (324/49)*x2*x6^2 + (-36/7)*x2*x5*x6 + x2*x5^2 + (324/49)*x1*x6^2 + (-36/7)*x1*x5*x6 + x1*x5^2,
(-38988/343)*x6^3 + (2166/49)*x5*x6^2 + (1026/49)*x4*x6^2 + (-57/7)*x4*x5*x6 + (1026/49)*x3*x6^2 + (-57/7)*x3*x5*x6 + (-18/7)*x3*x4*x6 + x3*x4*x5 + (1026/49)*x2*x6^2 + (-57/7)*x2*x5*x6 + (-18/7)*x2*x4*x6 + x2*x4*x5 + (-18/7)*x2*x3*x6 + x2*x3*x5 + (1026/49)*x1*x6^2 + (-57/7)*x1*x5*x6 + (-18/7)*x1*x4*x6 + x1*x4*x5 + (-18/7)*x1*x3*x6 + x1*x3*x5 + (-18/7)*x1*x2*x6 + x1*x2*x5,
(-27436/343)*x6^3 + (1083/49)*x4*x6^2 + (1083/49)*x3*x6^2 + (-38/7)*x3*x4*x6 + (1083/49)*x2*x6^2 + (-38/7)*x2*x4*x6 + (-38/7)*x2*x3*x6 + x2*x3*x4 + (1083/49)*x1*x6^2 + (-38/7)*x1*x4*x6 + (-38/7)*x1*x3*x6 + x1*x3*x4 + (-38/7)*x1*x2*x6 + x1*x2*x4 + x1*x2*x3,
(1300/27)*x6^3 + (40/9)*x5*x6^2 + (1/9)*x5^2*x6 + (-40/3)*x4*x6^2 + (-2/3)*x4*x5*x6 + x4^2*x6 + (-40/3)*x3*x6^2 + (-2/3)*x3*x5*x6 + (2)*x3*x4*x6 + x3^2*x6 + (-40/3)*x2*x6^2 + (-2/3)*x2*x5*x6 + (2)*x2*x4*x6 + (2)*x2*x3*x6 + x2^2*x6 + (-40/3)*x1*x6^2 + (-2/3)*x1*x5*x6 + (2)*x1*x4*x6 + (2)*x1*x3*x6 + (2)*x1*x2*x6 + x1^2*x6,
(49424/1029)*x6^3 + (2004/49)*x5*x6^2 + (2/7)*x5^2*x6 + (-996/49)*x4*x6^2 + (-50/7)*x4*x5*x6 + x4^2*x5 + (-996/49)*x3*x6^2 + (-50/7)*x3*x5*x6 + (36/7)*x3*x4*x6 + x3^2*x5 + (-996/49)*x2*x6^2 + (-50/7)*x2*x5*x6 + (36/7)*x2*x4*x6 + (36/7)*x2*x3*x6 + x2^2*x5 + (-996/49)*x1*x6^2 + (-50/7)*x1*x5*x6 + (36/7)*x1*x4*x6 + (36/7)*x1*x3*x6 + (36/7)*x1*x2*x6 + x1^2*x5,
(469528/3087)*x6^3 + (760/21)*x5*x6^2 + (19/21)*x5^2*x6 + (-2071/49)*x4*x6^2 + (-38/7)*x4*x5*x6 + (-2071/49)*x3*x6^2 + (-38/7)*x3*x5*x6 + (38/7)*x3*x4*x6 + x3*x4^2 + x3^2*x4 + (-2071/49)*x2*x6^2 + (-38/7)*x2*x5*x6 + (38/7)*x2*x4*x6 + x2*x4^2 + (38/7)*x2*x3*x6 + x2*x3^2 + x2^2*x4 + x2^2*x3 + (-2071/49)*x1*x6^2 + (-38/7)*x1*x5*x6 + (38/7)*x1*x4*x6 + x1*x4^2 + (38/7)*x1*x3*x6 + x1*x3^2 + (38/7)*x1*x2*x6 + x1*x2^2 + x1^2*x4 + x1^2*x3 + x1^2*x2,
(963376/3087)*x6^3 + (760/21)*x5*x6^2 + (19/21)*x5^2*x6 + (-4237/49)*x4*x6^2 + (-38/7)*x4*x5*x6 + x4^3 + (-4237/49)*x3*x6^2 + (-38/7)*x3*x5*x6 + (114/7)*x3*x4*x6 + x3^3 + (-4237/49)*x2*x6^2 + (-38/7)*x2*x5*x6 + (114/7)*x2*x4*x6 + (114/7)*x2*x3*x6 + x2^3 + (-4237/49)*x1*x6^2 + (-38/7)*x1*x5*x6 + (114/7)*x1*x4*x6 + (114/7)*x1*x3*x6 + (114/7)*x1*x2*x6 + x1^3
```

### Candidate job23_liftable_f17 | nonabelian

- G_s / symplectic: `A_4`
- generic No.: `68`; generic index: `2`; index: `6`; m: `1`
- G_id: `[ 72, 42 ]`; H_id: `[ 216, 163 ]`; order: `216`
- source: `job23_liftable_f17`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `7`; dim C: `6`
- n_gens: 6; n_basis: 7

- smooth witness prime: `11`; coefficients in the displayed basis: `[ 1, -2, 3, -4, 5, -6, 7 ]`

**Generators**

```gap
g1 := [ [ 0, 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g2 := [ [ 81/70*E(3)-11/70*E(3)^2, 11/70*E(3)-11/70*E(3)^2, 11/70*E(3)-11/70*E(3)^2, 11/70*E(3)-11/70*E(3)^2, 27/70*E(3)-27/70*E(3)^2, 3/20*E(3)-3/20*E(3)^2 ], [ 11/70*E(3)-11/70*E(3)^2, 81/70*E(3)-11/70*E(3)^2, 11/70*E(3)-11/70*E(3)^2, 11/70*E(3)-11/70*E(3)^2, 27/70*E(3)-27/70*E(3)^2, 3/20*E(3)-3/20*E(3)^2 ], [ 11/70*E(3)-11/70*E(3)^2, 11/70*E(3)-11/70*E(3)^2, 81/70*E(3)-11/70*E(3)^2, 11/70*E(3)-11/70*E(3)^2, 27/70*E(3)-27/70*E(3)^2, 3/20*E(3)-3/20*E(3)^2 ], [ 11/70*E(3)-11/70*E(3)^2, 11/70*E(3)-11/70*E(3)^2, 11/70*E(3)-11/70*E(3)^2, 81/70*E(3)-11/70*E(3)^2, 27/70*E(3)-27/70*E(3)^2, 3/20*E(3)-3/20*E(3)^2 ], [ -19/140*E(3)+19/140*E(3)^2, -19/140*E(3)+19/140*E(3)^2, -19/140*E(3)+19/140*E(3)^2, -19/140*E(3)+19/140*E(3)^2, -9/70*E(3)+79/70*E(3)^2, -1/20*E(3)+1/20*E(3)^2 ], [ -19/14*E(3)+19/14*E(3)^2, -19/14*E(3)+19/14*E(3)^2, -19/14*E(3)+19/14*E(3)^2, -19/14*E(3)+19/14*E(3)^2, -9/7*E(3)+9/7*E(3)^2, -1/2*E(3)+3/2*E(3)^2 ] ];
g3 := [ [ 0, 0, 0, 1, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g4 := [ [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g5 := [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
(-5832/343)*x6^3 + (972/49)*x5*x6^2 + (-54/7)*x5^2*x6 + x5^3,
(-24624/343)*x6^3 + (2736/49)*x5*x6^2 + (-76/7)*x5^2*x6 + (324/49)*x4*x6^2 + (-36/7)*x4*x5*x6 + x4*x5^2 + (324/49)*x3*x6^2 + (-36/7)*x3*x5*x6 + x3*x5^2 + (324/49)*x2*x6^2 + (-36/7)*x2*x5*x6 + x2*x5^2 + (324/49)*x1*x6^2 + (-36/7)*x1*x5*x6 + x1*x5^2,
(-7951/9261)*x6^3 + (-799/441)*x5*x6^2 + (5/36)*x5^2*x6 + (286/147)*x4*x6^2 + (11/21)*x4*x5*x6 + (286/147)*x3*x6^2 + (11/21)*x3*x5*x6 + (-5/3)*x3*x4*x6 + (-1/6)*x3*x4*x5 + (286/147)*x2*x6^2 + (11/21)*x2*x5*x6 + (-5/3)*x2*x4*x6 + (-1/6)*x2*x4*x5 + (-5/3)*x2*x3*x6 + (-1/6)*x2*x3*x5 + x2*x3*x4 + (286/147)*x1*x6^2 + (11/21)*x1*x5*x6 + (-5/3)*x1*x4*x6 + (-1/6)*x1*x4*x5 + (-5/3)*x1*x3*x6 + (-1/6)*x1*x3*x5 + x1*x3*x4 + (-5/3)*x1*x2*x6 + (-1/6)*x1*x2*x5 + x1*x2*x4 + x1*x2*x3,
(1300/27)*x6^3 + (40/9)*x5*x6^2 + (1/9)*x5^2*x6 + (-40/3)*x4*x6^2 + (-2/3)*x4*x5*x6 + x4^2*x6 + (-40/3)*x3*x6^2 + (-2/3)*x3*x5*x6 + (2)*x3*x4*x6 + x3^2*x6 + (-40/3)*x2*x6^2 + (-2/3)*x2*x5*x6 + (2)*x2*x4*x6 + (2)*x2*x3*x6 + x2^2*x6 + (-40/3)*x1*x6^2 + (-2/3)*x1*x5*x6 + (2)*x1*x4*x6 + (2)*x1*x3*x6 + (2)*x1*x2*x6 + x1^2*x6,
(-184504/1029)*x6^3 + (6336/49)*x5*x6^2 + (2/7)*x5^2*x6 + (1056/49)*x4*x6^2 + (-164/7)*x4*x5*x6 + x4^2*x5 + (1056/49)*x3*x6^2 + (-164/7)*x3*x5*x6 + (2)*x3*x4*x5 + x3^2*x5 + (1056/49)*x2*x6^2 + (-164/7)*x2*x5*x6 + (2)*x2*x4*x5 + (2)*x2*x3*x5 + x2^2*x5 + (1056/49)*x1*x6^2 + (-164/7)*x1*x5*x6 + (2)*x1*x4*x5 + (2)*x1*x3*x5 + (2)*x1*x2*x5 + x1^2*x5,
(675763/9261)*x6^3 + (16759/441)*x5*x6^2 + (193/252)*x5^2*x6 + (-3250/147)*x4*x6^2 + (-125/21)*x4*x5*x6 + (-3250/147)*x3*x6^2 + (-125/21)*x3*x5*x6 + (5/3)*x3*x4*x6 + (1/6)*x3*x4*x5 + x3*x4^2 + x3^2*x4 + (-3250/147)*x2*x6^2 + (-125/21)*x2*x5*x6 + (5/3)*x2*x4*x6 + (1/6)*x2*x4*x5 + x2*x4^2 + (5/3)*x2*x3*x6 + (1/6)*x2*x3*x5 + x2*x3^2 + x2^2*x4 + x2^2*x3 + (-3250/147)*x1*x6^2 + (-125/21)*x1*x5*x6 + (5/3)*x1*x4*x6 + (1/6)*x1*x4*x5 + x1*x4^2 + (5/3)*x1*x3*x6 + (1/6)*x1*x3*x5 + x1*x3^2 + (5/3)*x1*x2*x6 + (1/6)*x1*x2*x5 + x1*x2^2 + x1^2*x4 + x1^2*x3 + x1^2*x2,
(230555/3087)*x6^3 + (6119/147)*x5*x6^2 + (41/84)*x5^2*x6 + (-26)*x4*x6^2 + (-7)*x4*x5*x6 + x4^3 + (-26)*x3*x6^2 + (-7)*x3*x5*x6 + (5)*x3*x4*x6 + (1/2)*x3*x4*x5 + x3^3 + (-26)*x2*x6^2 + (-7)*x2*x5*x6 + (5)*x2*x4*x6 + (1/2)*x2*x4*x5 + (5)*x2*x3*x6 + (1/2)*x2*x3*x5 + x2^3 + (-26)*x1*x6^2 + (-7)*x1*x5*x6 + (5)*x1*x4*x6 + (1/2)*x1*x4*x5 + (5)*x1*x3*x6 + (1/2)*x1*x3*x5 + (5)*x1*x2*x6 + (1/2)*x1*x2*x5 + x1^3
```

### Candidate job24_liftable_f3 | nonabelian

- G_s / symplectic: `D_{10}`
- generic No.: `70`; generic index: `1`; index: `2`; m: `2`
- G_id: `[ 20, 4 ]`; H_id: `[ 60, 10 ]`; order: `60`
- source: `job24_liftable_f3`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `6`; dim C: `4`
- n_gens: 4; n_basis: 6

- smooth witness prime: `7`; coefficients in the displayed basis: `[ 1, 2, 3, 4, 5, 6 ]`

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ] ];
g2 := [ [ -1, 0, 0, 0, 0, 0 ], [ 2, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, E(5), 0, 0, 0 ], [ 0, 0, 0, E(5)^2, 0, 0 ], [ 0, 0, 0, 0, E(5)^3, 0 ], [ 0, 0, 0, 0, 0, E(5)^4 ] ];
g4 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x5^2*x6 + x3*x4^2,
x4*x6^2 + x3^2*x5,
x2*x4*x5,
x2*x3*x6,
x2^3,
(-2)*x1*x2^2 + x1^2*x2
```

### Candidate job25_liftable_f2 | nonabelian

- G_s / symplectic: `D_{10}`
- generic No.: `70`; generic index: `1`; index: `3`; m: `0`
- G_id: `[ 30, 2 ]`; H_id: `[ 90, 5 ]`; order: `90`
- source: `job25_liftable_f2`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `6`; dim C: `6`
- n_gens: 4; n_basis: 6

- smooth witness prime: `7`; coefficients in the displayed basis: `[ 1, 1, 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ] ];
g2 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
g3 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, E(5), 0, 0, 0 ], [ 0, 0, 0, E(5)^2, 0, 0 ], [ 0, 0, 0, 0, E(5)^3, 0 ], [ 0, 0, 0, 0, 0, E(5)^4 ] ];
g4 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x5^2*x6 + x3*x4^2,
x4*x6^2 + x3^2*x5,
x2^3,
x1*x2^2,
x1^2*x2,
x1^3
```

### Candidate job25_liftable_f3 | nonabelian

- G_s / symplectic: `D_{10}`
- generic No.: `70`; generic index: `1`; index: `3`; m: `2`
- G_id: `[ 30, 2 ]`; H_id: `[ 90, 5 ]`; order: `90`
- source: `job25_liftable_f3`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `6`; dim C: `4`
- n_gens: 4; n_basis: 6

- smooth witness prime: `7`; coefficients in the displayed basis: `[ 1, 1, 1, 1, 1, 1 ]`

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ] ];
g2 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ E(3)-E(3)^2, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ];
g3 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, E(5), 0, 0, 0 ], [ 0, 0, 0, E(5)^2, 0, 0 ], [ 0, 0, 0, 0, E(5)^3, 0 ], [ 0, 0, 0, 0, 0, E(5)^4 ] ];
g4 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x5^2*x6 + x3*x4^2,
x4*x6^2 + x3^2*x5,
x2^3,
-x2*x4*x5 + x1*x4*x5,
-x2*x3*x6 + x1*x3*x6,
(3)*x1*x2^2 + (-3)*x1^2*x2 + x1^3
```

### Candidate job26_liftable_f4 | nonabelian

- G_s / symplectic: `D_8`
- generic No.: `73`; generic index: `1`; index: `2`; m: `4`
- G_id: `[ 16, 11 ]`; H_id: `[ 48, 45 ]`; order: `48`
- source: `job26_liftable_f4`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `11`; dim C: `7`
- n_gens: 5; n_basis: 11

- smooth witness prime: `5`; coefficients in the displayed basis: `[ 4, -7, -10, -3, -1, 10, 2, 8, -1, 3, -7 ]`

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, -E(4) ], [ 0, 0, 0, 0, E(4), 0 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 0, -1 ], [ 0, 0, 0, 0, -1, 0 ] ];
g3 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, -1 ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, -1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
-x4*x6^2 + x4*x5^2,
x2*x5*x6,
x2*x4^2,
x2*x3^2,
x2^3,
x1*x5*x6,
x1*x4^2,
x1*x3^2,
x1*x2^2,
x1^2*x2,
x1^3
```

### Candidate job27_liftable_f4 | nonabelian

- G_s / symplectic: `D_8`
- generic No.: `73`; generic index: `1`; index: `2`; m: `3`
- G_id: `[ 16, 13 ]`; H_id: `[ 48, 47 ]`; order: `48`
- source: `job27_liftable_f4`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `10`; dim C: `7`
- n_gens: 5; n_basis: 10

- smooth witness prime: `5`; coefficients in the displayed basis: `[ -9, 4, -7, -9, 1, 8, 8, 2, 5, -2 ]`

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, -E(4) ], [ 0, 0, 0, 0, E(4), 0 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g3 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, -E(4), 0 ], [ 0, 0, 0, 0, 0, -E(4) ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, -1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
-x4*x6^2 + x4*x5^2,
x3*x6^2 + x3*x5^2,
x2*x4^2,
x2*x3^2,
x2^3,
x1*x4^2,
x1*x3^2,
x1*x2^2,
x1^2*x2,
x1^3
```

### Candidate job28_liftable_f1 | nonabelian

- G_s / symplectic: `D_8`
- generic No.: `73`; generic index: `1`; index: `2`; m: `2`
- G_id: `[ 16, 7 ]`; H_id: `[ 48, 25 ]`; order: `48`
- source: `job28_liftable_f1`; liftable: `liftable`
- status: `smooth_candidate`; dim V3: `6`; dim C: `4`
- n_gens: 5; n_basis: 6

- smooth witness prime: `13`; coefficients in the displayed basis: `[ 1, 2, 3, 4, 5, 6 ]`

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g2 := [ [ -1, 0, 0, 0, 0, 0 ], [ 2, 1, 0, 0, 0, 0 ], [ 0, 0, 0, -E(3), 0, 0 ], [ 0, 0, -E(3)^2, 0, 0, 0 ], [ 0, 0, 0, 0, 0, E(8)^3 ], [ 0, 0, 0, 0, -E(8), 0 ] ];
g3 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, -E(4), 0 ], [ 0, 0, 0, 0, 0, E(4) ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, -1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
(-E(12)^11)*x4*x6^2 + (E(12)^11)*x4*x5^2 + x3*x6^2 + x3*x5^2,
x2*x5*x6,
(E(3))*x2*x4^2 + x2*x3^2,
x2^3,
(2*E(3))*x2*x4^2 + (-E(3))*x1*x4^2 + x1*x3^2,
(-2)*x1*x2^2 + x1^2*x2
```

## Initially undecided candidates proved singular

### Candidate job20_liftable_f4 | nonabelian

- G_s / symplectic: `D_{12}`
- generic No.: `63`; generic index: `2`; index: `6`; m: `0`
- G_id: `[ 72, 48 ]`; H_id: `[ 216, 174 ]`; order: `216`
- source: `job20_liftable_f4`; liftable: `liftable`
- status: `singular`; dim V3: `5`; dim C: `5`
- n_gens: 6; n_basis: 5

**Generators**

```gap
g1 := [ [ 0, -1, 0, 0, 0, 0 ], [ -1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g2 := [ [ -1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 2, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ -1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g4 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
g5 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3 + x5^3,
x4^3,
(-2)*x3*x4^2 + x3^2*x4,
x1*x2*x4,
x2^2*x4 + x1^2*x4
```

### Candidate job20_liftable_f50 | nonabelian

- G_s / symplectic: `D_{12}`
- generic No.: `63`; generic index: `2`; index: `6`; m: `1`
- G_id: `[ 72, 48 ]`; H_id: `[ 216, 174 ]`; order: `216`
- source: `job20_liftable_f50`; liftable: `liftable`
- status: `singular`; dim V3: `6`; dim C: `5`
- n_gens: 6; n_basis: 6

**Generators**

```gap
g1 := [ [ 0, -1, 0, 0, 0, 0 ], [ -1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g2 := [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ -1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g4 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, E(3)-E(3)^2, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ];
g5 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3 + x5^3,
x4^3,
-x4*x5*x6 + x3*x5*x6,
(3)*x3*x4^2 + (-3)*x3^2*x4 + x3^3,
-x1*x2*x4 + x1*x2*x3,
-x2^2*x4 + x2^2*x3 + -x1^2*x4 + x1^2*x3
```

### Candidate job20_liftable_f52 | nonabelian

- G_s / symplectic: `D_{12}`
- generic No.: `63`; generic index: `2`; index: `6`; m: `0`
- G_id: `[ 72, 48 ]`; H_id: `[ 216, 174 ]`; order: `216`
- source: `job20_liftable_f52`; liftable: `liftable`
- status: `singular`; dim V3: `5`; dim C: `5`
- n_gens: 6; n_basis: 5

**Generators**

```gap
g1 := [ [ 0, -1, 0, 0, 0, 0 ], [ -1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g2 := [ [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g3 := [ [ -1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g4 := [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, E(3)-E(3)^2, E(3), 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g5 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
g6 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
x6^3 + x5^3,
x4^3,
(3)*x3*x4^2 + (-3)*x3^2*x4 + x3^3,
-x1*x2*x4 + x1*x2*x3,
-x2^2*x4 + x2^2*x3 + -x1^2*x4 + x1^2*x3
```

### Candidate job22_nonliftable_f1 | nonabelian

- G_s / symplectic: `A_4`
- generic No.: `65`; generic index: `1`; index: `3`; m: `0`
- G_id: `[ 36, 11 ]`; H_id: `[ 108, 19 ]`; order: `108`
- source: `job22_nonliftable_f1`; liftable: `nonliftable`
- status: `singular`; dim V3: `2`; dim C: `2`
- n_gens: 5; n_basis: 2

**Generators**

```gap
g1 := [ [ 0, 1/2*E(9)^4, -1/2*E(9)^4-1/2*E(9)^7, 1/2*E(9)^7, -1/4*E(9)^4-1/4*E(9)^7, 0 ], [ 1/2*E(9)^4, 0, 1/2*E(9)^7, -1/2*E(9)^4-1/2*E(9)^7, -1/4*E(9)^4-1/4*E(9)^7, 0 ], [ -1/2*E(9)^4-1/2*E(9)^7, 1/2*E(9)^7, 0, 1/2*E(9)^4, -1/4*E(9)^4-1/4*E(9)^7, 0 ], [ 1/2*E(9)^7, -1/2*E(9)^4-1/2*E(9)^7, 1/2*E(9)^4, 0, -1/4*E(9)^4-1/4*E(9)^7, 0 ], [ 0, 0, 0, 0, 0, -E(9)^4-E(9)^7 ], [ -E(9)^4-E(9)^7, -E(9)^4-E(9)^7, -E(9)^4-E(9)^7, -E(9)^4-E(9)^7, 0, 0 ] ];
g2 := [ [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
g3 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
g4 := [ [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
g5 := [ [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ];
```

**Invariant basis**

```text
(24*E(3))*x6^3 + (24*E(3)^2)*x5^3 + (-2)*x3*x4*x6 + (-2)*x3*x4*x5 + x3*x4^2 + x3^2*x4 + (-2*E(3))*x2*x4*x6 + (-2*E(3)^2)*x2*x4*x5 + x2*x4^2 + (-2*E(3)^2)*x2*x3*x6 + (-2*E(3))*x2*x3*x5 + (3)*x2*x3*x4 + x2*x3^2 + x2^2*x4 + x2^2*x3 + (-2*E(3)^2)*x1*x4*x6 + (-2*E(3))*x1*x4*x5 + x1*x4^2 + (-2*E(3))*x1*x3*x6 + (-2*E(3)^2)*x1*x3*x5 + (3)*x1*x3*x4 + x1*x3^2 + (-2)*x1*x2*x6 + (-2)*x1*x2*x5 + (3)*x1*x2*x4 + (3)*x1*x2*x3 + x1*x2^2 + x1^2*x4 + x1^2*x3 + x1^2*x2,
(-8*E(3))*x6^3 + (-8*E(3)^2)*x5^3 + x4^3 + (6)*x3*x4*x6 + (6)*x3*x4*x5 + x3^3 + (6*E(3))*x2*x4*x6 + (6*E(3)^2)*x2*x4*x5 + (6*E(3)^2)*x2*x3*x6 + (6*E(3))*x2*x3*x5 + (-3)*x2*x3*x4 + x2^3 + (6*E(3)^2)*x1*x4*x6 + (6*E(3))*x1*x4*x5 + (6*E(3))*x1*x3*x6 + (6*E(3)^2)*x1*x3*x5 + (-3)*x1*x3*x4 + (6)*x1*x2*x6 + (6)*x1*x2*x5 + (-3)*x1*x2*x4 + (-3)*x1*x2*x3 + x1^3
```

### Candidate job26_liftable_f2 | nonabelian

- G_s / symplectic: `D_8`
- generic No.: `73`; generic index: `1`; index: `2`; m: `2`
- G_id: `[ 16, 11 ]`; H_id: `[ 48, 45 ]`; order: `48`
- source: `job26_liftable_f2`; liftable: `liftable`
- status: `singular`; dim V3: `7`; dim C: `5`
- n_gens: 5; n_basis: 7

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, -E(4) ], [ 0, 0, 0, 0, E(4), 0 ] ];
g2 := [ [ -1, 0, 0, 0, 0, 0 ], [ 2, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 0, -1 ], [ 0, 0, 0, 0, -1, 0 ] ];
g3 := [ [ -1, 0, 0, 0, 0, 0 ], [ 2, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, -1 ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, -1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
-x4*x6^2 + x4*x5^2,
x3*x6^2 + x3*x5^2,
x2*x5*x6,
x2*x4^2,
x2*x3^2,
x2^3,
(-2)*x1*x2^2 + x1^2*x2
```

### Candidate job27_liftable_f3 | nonabelian

- G_s / symplectic: `D_8`
- generic No.: `73`; generic index: `1`; index: `2`; m: `1`
- G_id: `[ 16, 13 ]`; H_id: `[ 48, 47 ]`; order: `48`
- source: `job27_liftable_f3`; liftable: `liftable`
- status: `singular`; dim V3: `6`; dim C: `5`
- n_gens: 5; n_basis: 6

**Generators**

```gap
g1 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, -E(4) ], [ 0, 0, 0, 0, E(4), 0 ] ];
g2 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 0, 1 ], [ 0, 0, 0, 0, 1, 0 ] ];
g3 := [ [ -1, 0, 0, 0, 0, 0 ], [ 2, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, -E(4), 0 ], [ 0, 0, 0, 0, 0, -E(4) ] ];
g4 := [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, -1 ] ];
g5 := [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ];
```

**Invariant basis**

```text
-x4*x6^2 + x4*x5^2,
x2*x4^2,
x2*x3^2,
x2^3,
-x2*x5*x6 + x1*x5*x6,
(-2)*x1*x2^2 + x1^2*x2
```

## References

- Fu–Zheng, [Automorphism Groups of Smooth Cubic Fourfolds through Lattice Theory](https://arxiv.org/html/2609.06683v1), Table 1.
- Xie–Zheng, [Sylow Criteria for Liftability of Automorphism Groups of Smooth Hypersurfaces](https://arxiv.org/html/2607.23465v1), Theorems 1.1 and 1.3.
- Xie–Zheng, [Small-Subgroup Criteria for Liftability of Automorphism Groups of Smooth Hypersurfaces](https://arxiv.org/html/2609.15613v1), Theorem 1.4; its full-group hypothesis is retained.
