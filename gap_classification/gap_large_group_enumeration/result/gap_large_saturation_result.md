# Large-group equal-dimensional saturation results

## Recorded run

This comparison starts from the 42 smooth candidates recorded in
[gap_large_candidates_result.md](gap_large_candidates_result.md).

- Status: `completed`.
- GAP version: `4.16.0`.
- Exact candidate data: [gap_large_smooth_candidates.g](gap_large_smooth_candidates.g).
- Matrices: [gap_large_saturation_conjugacy.md](gap_large_saturation_conjugacy.md).
- Input smooth candidates: 42.
- Removed: 13.
- Retained: 29.
- Undecided: 0.

## Source and scope

The target pool consists of the 42 smooth candidates and the 127 other
catalogue records. The 29 catalogue models corresponding to the new rows are
used for final coordinate comparison, not as larger targets. No candidate is
rejected for disagreeing with its expected dimension.

All comparisons use strict groups containing `Z=<E(3) I6>`. A positive matrix witness satisfies `P^-1 H_source P <= H_target`; the target has strictly larger order and the same family dimension. Additive Fermat certificates are distinguished from matrix inclusions.

## Summary

| item | count |
|---|---|
| smooth sources | 42 |
| known comparison targets | 127 |
| recorded decisions | 159 |
| positive decisions | 13 |
| negative decisions | 146 |
| undecided decisions | 0 |
| retained sources | 29 |
| unique catalogue matches | 29 |
| strict inclusion matrices | 6 |
| Fermat coordinate changes | 7 |

## Input candidates

| source key | H-ID | order | dimension | status |
|---|---|---|---|---|
| `job01_nonliftable_f1` | `[ 648, 533 ]` | 648 | 0 | certified smooth |
| `job02_nonliftable_f1` | `[ 432, 538 ]` | 432 | 1 | certified smooth |
| `job03_liftable_f10` | `[ 1296, 3545 ]` | 1296 | 1 | certified smooth |
| `job04_liftable_f1` | `[ 540, 88 ]` | 540 | 1 | certified smooth |
| `job05_liftable_f1` | `[ 1080, 490 ]` | 1080 | 0 | certified smooth |
| `job05_liftable_f5` | `[ 1080, 490 ]` | 1080 | 1 | certified smooth |
| `job06_liftable_f11` | `[ 648, 746 ]` | 648 | 1 | certified smooth |
| `job06_liftable_f14` | `[ 648, 746 ]` | 648 | 0 | certified smooth |
| `job07_liftable_f4` | `[ 648, 718 ]` | 648 | 0 | certified smooth |
| `job07_liftable_f8` | `[ 648, 718 ]` | 648 | 1 | certified smooth |
| `job08_liftable_f3` | `[ 96, 182 ]` | 96 | 1 | certified smooth |
| `job09_liftable_f4` | `[ 144, 188 ]` | 144 | 2 | certified smooth |
| `job10_liftable_f3` | `[ 48, 47 ]` | 48 | 2 | certified smooth |
| `job11_liftable_f1` | `[ 72, 25 ]` | 72 | 1 | certified smooth |
| `job12_liftable_f13` | `[ 96, 54 ]` | 96 | 1 | certified smooth |
| `job13_nonliftable_f1` | `[ 108, 28 ]` | 108 | 2 | certified smooth |
| `job14_nonliftable_f1` | `[ 162, 10 ]` | 162 | 0 | certified smooth |
| `job14_nonliftable_f2` | `[ 162, 10 ]` | 162 | 1 | certified smooth |
| `job15_liftable_f11` | `[ 324, 165 ]` | 324 | 2 | certified smooth |
| `job15_liftable_f14` | `[ 324, 165 ]` | 324 | 0 | certified smooth |
| `job15_liftable_f26` | `[ 324, 165 ]` | 324 | 2 | certified smooth |
| `job15_liftable_f28` | `[ 324, 165 ]` | 324 | 1 | certified smooth |
| `job15_liftable_f29` | `[ 324, 165 ]` | 324 | 0 | certified smooth |
| `job16_liftable_f4` | `[ 72, 30 ]` | 72 | 2 | certified smooth |
| `job17_liftable_f2` | `[ 72, 48 ]` | 72 | 2 | certified smooth |
| `job18_liftable_f3` | `[ 108, 42 ]` | 108 | 0 | certified smooth |
| `job18_liftable_f4` | `[ 108, 42 ]` | 108 | 2 | certified smooth |
| `job19_liftable_f12` | `[ 216, 139 ]` | 216 | 0 | certified smooth |
| `job19_liftable_f21` | `[ 216, 139 ]` | 216 | 1 | certified smooth |
| `job20_liftable_f6` | `[ 216, 174 ]` | 216 | 2 | certified smooth |
| `job20_liftable_f54` | `[ 216, 174 ]` | 216 | 1 | certified smooth |
| `job21_liftable_f4` | `[ 72, 47 ]` | 72 | 3 | certified smooth |
| `job22_liftable_f1` | `[ 108, 41 ]` | 108 | 2 | certified smooth |
| `job22_liftable_f2` | `[ 108, 41 ]` | 108 | 1 | certified smooth |
| `job23_liftable_f16` | `[ 216, 163 ]` | 216 | 2 | certified smooth |
| `job23_liftable_f17` | `[ 216, 163 ]` | 216 | 1 | certified smooth |
| `job24_liftable_f3` | `[ 60, 10 ]` | 60 | 2 | certified smooth |
| `job25_liftable_f2` | `[ 90, 5 ]` | 90 | 0 | certified smooth |
| `job25_liftable_f3` | `[ 90, 5 ]` | 90 | 2 | certified smooth |
| `job26_liftable_f4` | `[ 48, 45 ]` | 48 | 4 | certified smooth |
| `job27_liftable_f4` | `[ 48, 47 ]` | 48 | 3 | certified smooth |
| `job28_liftable_f1` | `[ 48, 25 ]` | 48 | 2 | certified smooth |

## Saturation audit

There are 159 recorded decisions: 13 positive and 146 negative, with none undecided. A source is removed after its first positive certificate; retained sources were checked against every eligible larger-order, equal-dimensional target in the comparison pool. Six removals have explicit matrix inclusions; seven have exact additive coordinate changes showing that all smooth members are Fermat. These two proof types are kept separate.

| source key | D3 | larger target | certificate |
|---|---|---|---|
| `job05_liftable_f1` | 0 | No. 8 | exact matrix inclusion |
| `job15_liftable_f28` | 1 | No. 23 | exact matrix inclusion |
| `job20_liftable_f54` | 1 | `job06_liftable_f11` (No. 36) | exact matrix inclusion |
| `job22_liftable_f2` | 1 | `job03_liftable_f10` (No. 28) | exact matrix inclusion |
| `job23_liftable_f17` | 1 | `job03_liftable_f10` (No. 28) | exact matrix inclusion |
| `job25_liftable_f2` | 0 | `job05_liftable_f1` | exact matrix inclusion |
| `job06_liftable_f14` | 0 | No. 1 (Fermat) | additive blocks [2, 1, 1, 1, 1] |
| `job07_liftable_f4` | 0 | No. 1 (Fermat) | additive blocks [2, 1, 1, 1, 1] |
| `job14_nonliftable_f1` | 0 | No. 1 (Fermat) | additive blocks [2, 2, 2] |
| `job15_liftable_f14` | 0 | No. 1 (Fermat) | additive blocks [2, 1, 1, 1, 1] |
| `job15_liftable_f29` | 0 | No. 1 (Fermat) | additive blocks [2, 1, 1, 1, 1] |
| `job18_liftable_f3` | 0 | No. 1 (Fermat) | additive blocks [2, 2, 2] |
| `job19_liftable_f12` | 0 | No. 1 (Fermat) | additive blocks [2, 2, 2] |

The inclusion for `job15_liftable_f28` used an older witness as a search hint, then composed it with a newly computed conjugacy and directly checked every freshly enumerated generator. It is not an imported old Boolean decision.

## Retained-family correspondence

Here `dim V3 = dim W_H`, `dim C = dim C_GL(6)(H)`, and `D3 = dim V3 - dim C`. The strict group contains `Z=<E(3) I6>`; hence its projective order is `|H|/3`.

| No. | source key | G_s | index | G-ID | H-ID | order | dim V3 | dim C | D3 |
|---|---|---|---|---|---|---|---|---|---|
| [18](#record-18) | `job01_nonliftable_f1` | $M_9$ | $3$ | `[ 216, 153 ]` | `[ 648, 533 ]` | 648 | 1 | 1 | 0 |
| [26](#record-26) | `job02_nonliftable_f1` | $A_{4,3}$ | $2$ | `[ 144, 189 ]` | `[ 432, 538 ]` | 432 | 3 | 2 | 1 |
| [28](#record-28) | `job03_liftable_f10` | $A_{4,3}$ | $6$ | `[ 432, 745 ]` | `[ 1296, 3545 ]` | 1296 | 4 | 3 | 1 |
| [30](#record-30) | `job04_liftable_f1` | $A_5$ | $3$ | `[ 180, 19 ]` | `[ 540, 88 ]` | 540 | 3 | 2 | 1 |
| [32](#record-32) | `job05_liftable_f5` | $A_5$ | $6$ | `[ 360, 119 ]` | `[ 1080, 490 ]` | 1080 | 4 | 3 | 1 |
| [36](#record-36) | `job06_liftable_f11` | $S_{3,3}$ | $6$ | `[ 216, 170 ]` | `[ 648, 746 ]` | 648 | 5 | 4 | 1 |
| [38](#record-38) | `job07_liftable_f8` | $S_{3,3}$ | $6$ | `[ 216, 157 ]` | `[ 648, 718 ]` | 648 | 4 | 3 | 1 |
| [44](#record-44) | `job08_liftable_f3` | $\mathrm{QD}_{16}$ | $2$ | `[ 32, 42 ]` | `[ 96, 182 ]` | 96 | 5 | 4 | 1 |
| [46](#record-46) | `job09_liftable_f4` | $S_4$ | $2$ | `[ 48, 48 ]` | `[ 144, 188 ]` | 144 | 5 | 3 | 2 |
| [49](#record-49) | `job10_liftable_f3` | $Q_8$ | $2$ | `[ 16, 13 ]` | `[ 48, 47 ]` | 48 | 7 | 5 | 2 |
| [50](#record-50) | `job11_liftable_f1` | $Q_8$ | $3$ | `[ 24, 3 ]` | `[ 72, 25 ]` | 72 | 4 | 3 | 1 |
| [51](#record-51) | `job12_liftable_f13` | $Q_8$ | $4$ | `[ 32, 11 ]` | `[ 96, 54 ]` | 96 | 5 | 4 | 1 |
| [53](#record-53) | `job13_nonliftable_f1` | $A_{3,3}$ | $2$ | `[ 36, 13 ]` | `[ 108, 28 ]` | 108 | 4 | 2 | 2 |
| [54](#record-54) | `job14_nonliftable_f2` | $A_{3,3}$ | $3$ | `[ 54, 5 ]` | `[ 162, 10 ]` | 162 | 3 | 2 | 1 |
| [56](#record-56) | `job15_liftable_f11` | $A_{3,3}$ | $6$ | `[ 108, 38 ]` | `[ 324, 165 ]` | 324 | 8 | 6 | 2 |
| [57](#record-57) | `job15_liftable_f26` | $A_{3,3}$ | $6$ | `[ 108, 38 ]` | `[ 324, 165 ]` | 324 | 6 | 4 | 2 |
| [59](#record-59) | `job16_liftable_f4` | $D_{12}$ | $2$ | `[ 24, 8 ]` | `[ 72, 30 ]` | 72 | 8 | 6 | 2 |
| [60](#record-60) | `job17_liftable_f2` | $D_{12}$ | $2$ | `[ 24, 14 ]` | `[ 72, 48 ]` | 72 | 6 | 4 | 2 |
| [61](#record-61) | `job18_liftable_f4` | $D_{12}$ | $3$ | `[ 36, 12 ]` | `[ 108, 42 ]` | 108 | 6 | 4 | 2 |
| [62](#record-62) | `job19_liftable_f21` | $D_{12}$ | $6$ | `[ 72, 30 ]` | `[ 216, 139 ]` | 216 | 5 | 4 | 1 |
| [64](#record-64) | `job20_liftable_f6` | $D_{12}$ | $6$ | `[ 72, 48 ]` | `[ 216, 174 ]` | 216 | 9 | 7 | 2 |
| [66](#record-66) | `job21_liftable_f4` | $A_4$ | $2$ | `[ 24, 13 ]` | `[ 72, 47 ]` | 72 | 7 | 4 | 3 |
| [67](#record-67) | `job22_liftable_f1` | $A_4$ | $3$ | `[ 36, 11 ]` | `[ 108, 41 ]` | 108 | 6 | 4 | 2 |
| [69](#record-69) | `job23_liftable_f16` | $A_4$ | $6$ | `[ 72, 42 ]` | `[ 216, 163 ]` | 216 | 8 | 6 | 2 |
| [71](#record-71) | `job24_liftable_f3` | $D_{10}$ | $2$ | `[ 20, 4 ]` | `[ 60, 10 ]` | 60 | 6 | 4 | 2 |
| [72](#record-72) | `job25_liftable_f3` | $D_{10}$ | $3$ | `[ 30, 2 ]` | `[ 90, 5 ]` | 90 | 6 | 4 | 2 |
| [74](#record-74) | `job26_liftable_f4` | $D_8$ | $2$ | `[ 16, 11 ]` | `[ 48, 45 ]` | 48 | 11 | 7 | 4 |
| [75](#record-75) | `job27_liftable_f4` | $D_8$ | $2$ | `[ 16, 13 ]` | `[ 48, 47 ]` | 48 | 10 | 7 | 3 |
| [76](#record-76) | `job28_liftable_f1` | $D_8$ | $2$ | `[ 16, 7 ]` | `[ 48, 25 ]` | 48 | 6 | 4 | 2 |

## Verification

For each retained source every eligible larger-order, equal-dimensional target in the pool was checked. After a positive certificate a removed source needs no further targets. The 13 positive certificates were independently verified, including exact generator inclusion and all additive polynomial identities. Every retained source has one distinct catalogue match with an explicit invertible conjugating matrix. No unresolved decision is counted as negative.

The GAP-readable files beside this report retain the 42 inputs, comparison
checks, additive certificates, catalogue matches, and survivor keys.

## Detailed retained records

<a id="record-18"></a>

### No.18 | nonabelian

- G_s / symplectic: `M_9`
- generic index: `1`; index: `3`; m: `0`
- G_id: `[ 216, 153 ]`; H_id: `[ 648, 533 ]`; order: `648`
- source: `job01_nonliftable_f1`; liftable: `nonliftable`
- status: `retained`; dim V3: `1`; dim C: `1`
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

<a id="record-26"></a>

### No.26 | nonabelian

- G_s / symplectic: `A_{4,3}`
- generic index: `1`; index: `2`; m: `1`
- G_id: `[ 144, 189 ]`; H_id: `[ 432, 538 ]`; order: `432`
- source: `job02_nonliftable_f1`; liftable: `nonliftable`
- status: `retained`; dim V3: `3`; dim C: `2`
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

<a id="record-28"></a>

### No.28 | nonabelian

- G_s / symplectic: `A_{4,3}`
- generic index: `2`; index: `6`; m: `1`
- G_id: `[ 432, 745 ]`; H_id: `[ 1296, 3545 ]`; order: `1296`
- source: `job03_liftable_f10`; liftable: `liftable`
- status: `retained`; dim V3: `4`; dim C: `3`
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

<a id="record-30"></a>

### No.30 | nonabelian

- G_s / symplectic: `A_5`
- generic index: `1`; index: `3`; m: `1`
- G_id: `[ 180, 19 ]`; H_id: `[ 540, 88 ]`; order: `540`
- source: `job04_liftable_f1`; liftable: `liftable`
- status: `retained`; dim V3: `3`; dim C: `2`
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

<a id="record-32"></a>

### No.32 | nonabelian

- G_s / symplectic: `A_5`
- generic index: `2`; index: `6`; m: `1`
- G_id: `[ 360, 119 ]`; H_id: `[ 1080, 490 ]`; order: `1080`
- source: `job05_liftable_f5`; liftable: `liftable`
- status: `retained`; dim V3: `4`; dim C: `3`
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

<a id="record-36"></a>

### No.36 | nonabelian

- G_s / symplectic: `S_{3,3}`
- generic index: `2`; index: `6`; m: `1`
- G_id: `[ 216, 170 ]`; H_id: `[ 648, 746 ]`; order: `648`
- source: `job06_liftable_f11`; liftable: `liftable`
- status: `retained`; dim V3: `5`; dim C: `4`
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

<a id="record-38"></a>

### No.38 | nonabelian

- G_s / symplectic: `S_{3,3}`
- generic index: `2`; index: `6`; m: `1`
- G_id: `[ 216, 157 ]`; H_id: `[ 648, 718 ]`; order: `648`
- source: `job07_liftable_f8`; liftable: `liftable`
- status: `retained`; dim V3: `4`; dim C: `3`
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

<a id="record-44"></a>

### No.44 | nonabelian

- G_s / symplectic: `\mathrm{QD}_{16}`
- generic index: `1`; index: `2`; m: `1`
- G_id: `[ 32, 42 ]`; H_id: `[ 96, 182 ]`; order: `96`
- source: `job08_liftable_f3`; liftable: `liftable`
- status: `retained`; dim V3: `5`; dim C: `4`
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

<a id="record-46"></a>

### No.46 | nonabelian

- G_s / symplectic: `S_4`
- generic index: `1`; index: `2`; m: `2`
- G_id: `[ 48, 48 ]`; H_id: `[ 144, 188 ]`; order: `144`
- source: `job09_liftable_f4`; liftable: `liftable`
- status: `retained`; dim V3: `5`; dim C: `3`
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

<a id="record-49"></a>

### No.49 | nonabelian

- G_s / symplectic: `Q_8`
- generic index: `1`; index: `2`; m: `2`
- G_id: `[ 16, 13 ]`; H_id: `[ 48, 47 ]`; order: `48`
- source: `job10_liftable_f3`; liftable: `liftable`
- status: `retained`; dim V3: `7`; dim C: `5`
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

<a id="record-50"></a>

### No.50 | nonabelian

- G_s / symplectic: `Q_8`
- generic index: `1`; index: `3`; m: `1`
- G_id: `[ 24, 3 ]`; H_id: `[ 72, 25 ]`; order: `72`
- source: `job11_liftable_f1`; liftable: `liftable`
- status: `retained`; dim V3: `4`; dim C: `3`
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

<a id="record-51"></a>

### No.51 | nonabelian

- G_s / symplectic: `Q_8`
- generic index: `1`; index: `4`; m: `1`
- G_id: `[ 32, 11 ]`; H_id: `[ 96, 54 ]`; order: `96`
- source: `job12_liftable_f13`; liftable: `liftable`
- status: `retained`; dim V3: `5`; dim C: `4`
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

<a id="record-53"></a>

### No.53 | nonabelian

- G_s / symplectic: `A_{3,3}`
- generic index: `1`; index: `2`; m: `2`
- G_id: `[ 36, 13 ]`; H_id: `[ 108, 28 ]`; order: `108`
- source: `job13_nonliftable_f1`; liftable: `nonliftable`
- status: `retained`; dim V3: `4`; dim C: `2`
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

<a id="record-54"></a>

### No.54 | nonabelian

- G_s / symplectic: `A_{3,3}`
- generic index: `1`; index: `3`; m: `1`
- G_id: `[ 54, 5 ]`; H_id: `[ 162, 10 ]`; order: `162`
- source: `job14_nonliftable_f2`; liftable: `nonliftable`
- status: `retained`; dim V3: `3`; dim C: `2`
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

<a id="record-56"></a>

### No.56 | nonabelian

- G_s / symplectic: `A_{3,3}`
- generic index: `2`; index: `6`; m: `2`
- G_id: `[ 108, 38 ]`; H_id: `[ 324, 165 ]`; order: `324`
- source: `job15_liftable_f11`; liftable: `liftable`
- status: `retained`; dim V3: `8`; dim C: `6`
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

<a id="record-57"></a>

### No.57 | nonabelian

- G_s / symplectic: `A_{3,3}`
- generic index: `2`; index: `6`; m: `2`
- G_id: `[ 108, 38 ]`; H_id: `[ 324, 165 ]`; order: `324`
- source: `job15_liftable_f26`; liftable: `liftable`
- status: `retained`; dim V3: `6`; dim C: `4`
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

<a id="record-59"></a>

### No.59 | nonabelian

- G_s / symplectic: `D_{12}`
- generic index: `1`; index: `2`; m: `2`
- G_id: `[ 24, 8 ]`; H_id: `[ 72, 30 ]`; order: `72`
- source: `job16_liftable_f4`; liftable: `liftable`
- status: `retained`; dim V3: `8`; dim C: `6`
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

<a id="record-60"></a>

### No.60 | nonabelian

- G_s / symplectic: `D_{12}`
- generic index: `1`; index: `2`; m: `2`
- G_id: `[ 24, 14 ]`; H_id: `[ 72, 48 ]`; order: `72`
- source: `job17_liftable_f2`; liftable: `liftable`
- status: `retained`; dim V3: `6`; dim C: `4`
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

<a id="record-61"></a>

### No.61 | nonabelian

- G_s / symplectic: `D_{12}`
- generic index: `1`; index: `3`; m: `2`
- G_id: `[ 36, 12 ]`; H_id: `[ 108, 42 ]`; order: `108`
- source: `job18_liftable_f4`; liftable: `liftable`
- status: `retained`; dim V3: `6`; dim C: `4`
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

<a id="record-62"></a>

### No.62 | nonabelian

- G_s / symplectic: `D_{12}`
- generic index: `1`; index: `6`; m: `1`
- G_id: `[ 72, 30 ]`; H_id: `[ 216, 139 ]`; order: `216`
- source: `job19_liftable_f21`; liftable: `liftable`
- status: `retained`; dim V3: `5`; dim C: `4`
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

<a id="record-64"></a>

### No.64 | nonabelian

- G_s / symplectic: `D_{12}`
- generic index: `2`; index: `6`; m: `2`
- G_id: `[ 72, 48 ]`; H_id: `[ 216, 174 ]`; order: `216`
- source: `job20_liftable_f6`; liftable: `liftable`
- status: `retained`; dim V3: `9`; dim C: `7`
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

<a id="record-66"></a>

### No.66 | nonabelian

- G_s / symplectic: `A_4`
- generic index: `1`; index: `2`; m: `3`
- G_id: `[ 24, 13 ]`; H_id: `[ 72, 47 ]`; order: `72`
- source: `job21_liftable_f4`; liftable: `liftable`
- status: `retained`; dim V3: `7`; dim C: `4`
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

<a id="record-67"></a>

### No.67 | nonabelian

- G_s / symplectic: `A_4`
- generic index: `1`; index: `3`; m: `2`
- G_id: `[ 36, 11 ]`; H_id: `[ 108, 41 ]`; order: `108`
- source: `job22_liftable_f1`; liftable: `liftable`
- status: `retained`; dim V3: `6`; dim C: `4`
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

<a id="record-69"></a>

### No.69 | nonabelian

- G_s / symplectic: `A_4`
- generic index: `2`; index: `6`; m: `2`
- G_id: `[ 72, 42 ]`; H_id: `[ 216, 163 ]`; order: `216`
- source: `job23_liftable_f16`; liftable: `liftable`
- status: `retained`; dim V3: `8`; dim C: `6`
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

<a id="record-71"></a>

### No.71 | nonabelian

- G_s / symplectic: `D_{10}`
- generic index: `1`; index: `2`; m: `2`
- G_id: `[ 20, 4 ]`; H_id: `[ 60, 10 ]`; order: `60`
- source: `job24_liftable_f3`; liftable: `liftable`
- status: `retained`; dim V3: `6`; dim C: `4`
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

<a id="record-72"></a>

### No.72 | nonabelian

- G_s / symplectic: `D_{10}`
- generic index: `1`; index: `3`; m: `2`
- G_id: `[ 30, 2 ]`; H_id: `[ 90, 5 ]`; order: `90`
- source: `job25_liftable_f3`; liftable: `liftable`
- status: `retained`; dim V3: `6`; dim C: `4`
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

<a id="record-74"></a>

### No.74 | nonabelian

- G_s / symplectic: `D_8`
- generic index: `1`; index: `2`; m: `4`
- G_id: `[ 16, 11 ]`; H_id: `[ 48, 45 ]`; order: `48`
- source: `job26_liftable_f4`; liftable: `liftable`
- status: `retained`; dim V3: `11`; dim C: `7`
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

<a id="record-75"></a>

### No.75 | nonabelian

- G_s / symplectic: `D_8`
- generic index: `1`; index: `2`; m: `3`
- G_id: `[ 16, 13 ]`; H_id: `[ 48, 47 ]`; order: `48`
- source: `job27_liftable_f4`; liftable: `liftable`
- status: `retained`; dim V3: `10`; dim C: `7`
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

<a id="record-76"></a>

### No.76 | nonabelian

- G_s / symplectic: `D_8`
- generic index: `1`; index: `2`; m: `2`
- G_id: `[ 16, 7 ]`; H_id: `[ 48, 25 ]`; order: `48`
- source: `job28_liftable_f1`; liftable: `liftable`
- status: `retained`; dim V3: `6`; dim C: `4`
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

## Smooth candidates removed by saturation

### Candidate job05_liftable_f1 | nonabelian

- G_s / symplectic: `A_5`
- generic index: `2`; index: `6`; m: `0`
- G_id: `[ 360, 119 ]`; H_id: `[ 1080, 490 ]`; order: `1080`
- source: `job05_liftable_f1`; liftable: `liftable`
- status: `saturated_out`; dim V3: `5`; dim C: `5`
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

### Candidate job06_liftable_f14 | nonabelian

- G_s / symplectic: `S_{3,3}`
- generic index: `2`; index: `6`; m: `0`
- G_id: `[ 216, 170 ]`; H_id: `[ 648, 746 ]`; order: `648`
- source: `job06_liftable_f14`; liftable: `liftable`
- status: `saturated_out`; dim V3: `4`; dim C: `4`
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
- generic index: `2`; index: `6`; m: `0`
- G_id: `[ 216, 157 ]`; H_id: `[ 648, 718 ]`; order: `648`
- source: `job07_liftable_f4`; liftable: `liftable`
- status: `saturated_out`; dim V3: `5`; dim C: `5`
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

### Candidate job14_nonliftable_f1 | nonabelian

- G_s / symplectic: `A_{3,3}`
- generic index: `1`; index: `3`; m: `0`
- G_id: `[ 54, 5 ]`; H_id: `[ 162, 10 ]`; order: `162`
- source: `job14_nonliftable_f1`; liftable: `nonliftable`
- status: `saturated_out`; dim V3: `4`; dim C: `4`
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

### Candidate job15_liftable_f14 | nonabelian

- G_s / symplectic: `A_{3,3}`
- generic index: `2`; index: `6`; m: `0`
- G_id: `[ 108, 38 ]`; H_id: `[ 324, 165 ]`; order: `324`
- source: `job15_liftable_f14`; liftable: `liftable`
- status: `saturated_out`; dim V3: `6`; dim C: `6`
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

### Candidate job15_liftable_f28 | nonabelian

- G_s / symplectic: `A_{3,3}`
- generic index: `2`; index: `6`; m: `1`
- G_id: `[ 108, 38 ]`; H_id: `[ 324, 165 ]`; order: `324`
- source: `job15_liftable_f28`; liftable: `liftable`
- status: `saturated_out`; dim V3: `5`; dim C: `4`
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
- generic index: `2`; index: `6`; m: `0`
- G_id: `[ 108, 38 ]`; H_id: `[ 324, 165 ]`; order: `324`
- source: `job15_liftable_f29`; liftable: `liftable`
- status: `saturated_out`; dim V3: `3`; dim C: `3`
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

### Candidate job18_liftable_f3 | nonabelian

- G_s / symplectic: `D_{12}`
- generic index: `1`; index: `3`; m: `0`
- G_id: `[ 36, 12 ]`; H_id: `[ 108, 42 ]`; order: `108`
- source: `job18_liftable_f3`; liftable: `liftable`
- status: `saturated_out`; dim V3: `6`; dim C: `6`
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

### Candidate job19_liftable_f12 | nonabelian

- G_s / symplectic: `D_{12}`
- generic index: `1`; index: `6`; m: `0`
- G_id: `[ 72, 30 ]`; H_id: `[ 216, 139 ]`; order: `216`
- source: `job19_liftable_f12`; liftable: `liftable`
- status: `saturated_out`; dim V3: `6`; dim C: `6`
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

### Candidate job20_liftable_f54 | nonabelian

- G_s / symplectic: `D_{12}`
- generic index: `2`; index: `6`; m: `1`
- G_id: `[ 72, 48 ]`; H_id: `[ 216, 174 ]`; order: `216`
- source: `job20_liftable_f54`; liftable: `liftable`
- status: `saturated_out`; dim V3: `6`; dim C: `5`
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

### Candidate job22_liftable_f2 | nonabelian

- G_s / symplectic: `A_4`
- generic index: `1`; index: `3`; m: `1`
- G_id: `[ 36, 11 ]`; H_id: `[ 108, 41 ]`; order: `108`
- source: `job22_liftable_f2`; liftable: `liftable`
- status: `saturated_out`; dim V3: `5`; dim C: `4`
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

### Candidate job23_liftable_f17 | nonabelian

- G_s / symplectic: `A_4`
- generic index: `2`; index: `6`; m: `1`
- G_id: `[ 72, 42 ]`; H_id: `[ 216, 163 ]`; order: `216`
- source: `job23_liftable_f17`; liftable: `liftable`
- status: `saturated_out`; dim V3: `7`; dim C: `6`
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

### Candidate job25_liftable_f2 | nonabelian

- G_s / symplectic: `D_{10}`
- generic index: `1`; index: `3`; m: `0`
- G_id: `[ 30, 2 ]`; H_id: `[ 90, 5 ]`; order: `90`
- source: `job25_liftable_f2`; liftable: `liftable`
- status: `saturated_out`; dim V3: `6`; dim C: `6`
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
