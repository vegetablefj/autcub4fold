# Large-group conjugacy and saturation matrices

## Source and scope

This file accompanies
[gap_large_saturation_result.md](gap_large_saturation_result.md) and the
[GAP-readable catalogue matches](gap_large_catalogue_matches.g). It uses the
same source keys and current catalogue numbers. Entries are the exact GAP
output, not numerical approximations or newly simplified matrices.

- Catalogue conjugacies: **29**.
- Strict larger-group inclusion matrices: **6**.
- Additive coordinate changes for the Fermat cases: **7**.
- Verification: **all passed**.

## Convention

`E(n)` is GAP's primitive n-th root of unity. For each catalogue or inclusion matrix `P`, the direction is

```gap
P^-1 * H_source * P = H_catalogue     # catalogue match
P^-1 * H_source * P <= H_target       # strict larger-group inclusion
```

These are conjugacies of strict matrix groups, not complex-conjugation tests.
The row-vector convention is unchanged. `P` is not transposed. Source
generators are in the corresponding detailed record of the result file. For
a target `known_N`, its generators are in the ordered
[fourfold matrix catalogue](../../gap_manuscript_validation/gap_family_catalogue.g).

The Fermat certificates use a different matrix `Q`: the exact polynomial substitution is `F(x * TransposedMat(Q))`. These `Q` matrices split the invariant space into additive blocks; they are not asserted to be a uniform conjugacy of the whole group into the stored Fermat group. The subsequent normalization of a smooth binary cubic to a sum of two cubes may depend on its coefficients.

## Catalogue correspondence

| No. | source key | H-ID | order | dimension | status |
|---|---|---|---|---|---|
| [18](#matrix-18) | `job01_nonliftable_f1` | `[ 648, 533 ]` | 648 | 0 | verified_unique |
| [26](#matrix-26) | `job02_nonliftable_f1` | `[ 432, 538 ]` | 432 | 1 | verified_unique |
| [28](#matrix-28) | `job03_liftable_f10` | `[ 1296, 3545 ]` | 1296 | 1 | verified_unique |
| [30](#matrix-30) | `job04_liftable_f1` | `[ 540, 88 ]` | 540 | 1 | verified_unique |
| [32](#matrix-32) | `job05_liftable_f5` | `[ 1080, 490 ]` | 1080 | 1 | verified_unique |
| [36](#matrix-36) | `job06_liftable_f11` | `[ 648, 746 ]` | 648 | 1 | verified_unique |
| [38](#matrix-38) | `job07_liftable_f8` | `[ 648, 718 ]` | 648 | 1 | verified_unique |
| [44](#matrix-44) | `job08_liftable_f3` | `[ 96, 182 ]` | 96 | 1 | verified_unique |
| [46](#matrix-46) | `job09_liftable_f4` | `[ 144, 188 ]` | 144 | 2 | verified_unique |
| [49](#matrix-49) | `job10_liftable_f3` | `[ 48, 47 ]` | 48 | 2 | verified_unique |
| [50](#matrix-50) | `job11_liftable_f1` | `[ 72, 25 ]` | 72 | 1 | verified_unique |
| [51](#matrix-51) | `job12_liftable_f13` | `[ 96, 54 ]` | 96 | 1 | verified_unique |
| [53](#matrix-53) | `job13_nonliftable_f1` | `[ 108, 28 ]` | 108 | 2 | verified_unique |
| [54](#matrix-54) | `job14_nonliftable_f2` | `[ 162, 10 ]` | 162 | 1 | verified_unique |
| [56](#matrix-56) | `job15_liftable_f11` | `[ 324, 165 ]` | 324 | 2 | verified_unique |
| [57](#matrix-57) | `job15_liftable_f26` | `[ 324, 165 ]` | 324 | 2 | verified_unique |
| [59](#matrix-59) | `job16_liftable_f4` | `[ 72, 30 ]` | 72 | 2 | verified_unique |
| [60](#matrix-60) | `job17_liftable_f2` | `[ 72, 48 ]` | 72 | 2 | verified_unique |
| [61](#matrix-61) | `job18_liftable_f4` | `[ 108, 42 ]` | 108 | 2 | verified_unique |
| [62](#matrix-62) | `job19_liftable_f21` | `[ 216, 139 ]` | 216 | 1 | verified_unique |
| [64](#matrix-64) | `job20_liftable_f6` | `[ 216, 174 ]` | 216 | 2 | verified_unique |
| [66](#matrix-66) | `job21_liftable_f4` | `[ 72, 47 ]` | 72 | 3 | verified_unique |
| [67](#matrix-67) | `job22_liftable_f1` | `[ 108, 41 ]` | 108 | 2 | verified_unique |
| [69](#matrix-69) | `job23_liftable_f16` | `[ 216, 163 ]` | 216 | 2 | verified_unique |
| [71](#matrix-71) | `job24_liftable_f3` | `[ 60, 10 ]` | 60 | 2 | verified_unique |
| [72](#matrix-72) | `job25_liftable_f3` | `[ 90, 5 ]` | 90 | 2 | verified_unique |
| [74](#matrix-74) | `job26_liftable_f4` | `[ 48, 45 ]` | 48 | 4 | verified_unique |
| [75](#matrix-75) | `job27_liftable_f4` | `[ 48, 47 ]` | 48 | 3 | verified_unique |
| [76](#matrix-76) | `job28_liftable_f1` | `[ 48, 25 ]` | 48 | 2 | verified_unique |


## Detailed catalogue conjugacies

<a id="matrix-18"></a>

### No.18

- source: `job01_nonliftable_f1`
- target: `Families[18]`
- H_id: `[ 648, 533 ]`; order: `648`; m: `0`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-26"></a>

### No.26

- source: `job02_nonliftable_f1`
- target: `Families[26]`
- H_id: `[ 432, 538 ]`; order: `432`; m: `1`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-28"></a>

### No.28

- source: `job03_liftable_f10`
- target: `Families[28]`
- H_id: `[ 1296, 3545 ]`; order: `1296`; m: `1`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-30"></a>

### No.30

- source: `job04_liftable_f1`
- target: `Families[30]`
- H_id: `[ 540, 88 ]`; order: `540`; m: `1`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-32"></a>

### No.32

- source: `job05_liftable_f5`
- target: `Families[32]`
- H_id: `[ 1080, 490 ]`; order: `1080`; m: `1`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-36"></a>

### No.36

- source: `job06_liftable_f11`
- target: `Families[36]`
- H_id: `[ 648, 746 ]`; order: `648`; m: `1`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-38"></a>

### No.38

- source: `job07_liftable_f8`
- target: `Families[38]`
- H_id: `[ 648, 718 ]`; order: `648`; m: `1`
- determinant: `-120`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 6, -3, 0, 0, 0, 0 ],
  [ -11/2, 4, 0, 0, 0, 0 ],
  [ 0, 0, -2, 2, 0, 0 ],
  [ 0, 0, -2, 0, 0, 0 ],
  [ 0, 0, 0, 0, 2, -2 ],
  [ 0, 0, 0, 0, 0, -2 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-44"></a>

### No.44

- source: `job08_liftable_f3`
- target: `Families[44]`
- H_id: `[ 96, 182 ]`; order: `96`; m: `1`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-46"></a>

### No.46

- source: `job09_liftable_f4`
- target: `Families[46]`
- H_id: `[ 144, 188 ]`; order: `144`; m: `2`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-49"></a>

### No.49

- source: `job10_liftable_f3`
- target: `Families[49]`
- H_id: `[ 48, 47 ]`; order: `48`; m: `2`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-50"></a>

### No.50

- source: `job11_liftable_f1`
- target: `Families[50]`
- H_id: `[ 72, 25 ]`; order: `72`; m: `1`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-51"></a>

### No.51

- source: `job12_liftable_f13`
- target: `Families[51]`
- H_id: `[ 96, 54 ]`; order: `96`; m: `1`
- determinant: `-144*E(4)`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ -4, 0, 0, 0, 0, 0 ],
  [ 0, 4, 0, 0, 0, 0 ],
  [ 0, 0, 3*E(4), 0, 0, 0 ],
  [ 0, 0, 0, -3, 0, 0 ],
  [ 0, 0, 0, 0, -1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-53"></a>

### No.53

- source: `job13_nonliftable_f1`
- target: `Families[53]`
- H_id: `[ 108, 28 ]`; order: `108`; m: `2`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-54"></a>

### No.54

- source: `job14_nonliftable_f2`
- target: `Families[54]`
- H_id: `[ 162, 10 ]`; order: `162`; m: `1`
- determinant: `-27`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ E(3), E(3), E(3), 0, 0, 0 ],
  [ 1, E(3), E(3)^2, 0, 0, 0 ],
  [ E(3)^2, E(3), 1, 0, 0, 0 ],
  [ 0, 0, 0, E(3), E(3), E(3) ],
  [ 0, 0, 0, 1, E(3), E(3)^2 ],
  [ 0, 0, 0, E(3)^2, E(3), 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-56"></a>

### No.56

- source: `job15_liftable_f11`
- target: `Families[56]`
- H_id: `[ 324, 165 ]`; order: `324`; m: `2`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-57"></a>

### No.57

- source: `job15_liftable_f26`
- target: `Families[57]`
- H_id: `[ 324, 165 ]`; order: `324`; m: `2`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-59"></a>

### No.59

- source: `job16_liftable_f4`
- target: `Families[59]`
- H_id: `[ 72, 30 ]`; order: `72`; m: `2`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-60"></a>

### No.60

- source: `job17_liftable_f2`
- target: `Families[60]`
- H_id: `[ 72, 48 ]`; order: `72`; m: `2`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-61"></a>

### No.61

- source: `job18_liftable_f4`
- target: `Families[61]`
- H_id: `[ 108, 42 ]`; order: `108`; m: `2`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-62"></a>

### No.62

- source: `job19_liftable_f21`
- target: `Families[62]`
- H_id: `[ 216, 139 ]`; order: `216`; m: `1`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-64"></a>

### No.64

- source: `job20_liftable_f6`
- target: `Families[64]`
- H_id: `[ 216, 174 ]`; order: `216`; m: `2`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-66"></a>

### No.66

- source: `job21_liftable_f4`
- target: `Families[66]`
- H_id: `[ 72, 47 ]`; order: `72`; m: `3`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-67"></a>

### No.67

- source: `job22_liftable_f1`
- target: `Families[67]`
- H_id: `[ 108, 41 ]`; order: `108`; m: `2`
- determinant: `32768`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ -4*E(3)^2, -4*E(3), -4, 0, 0, -4 ],
  [ -4, 0, -4*E(3)^2, -4*E(3), 0, -4 ],
  [ 0, -4, -4*E(3), -4*E(3)^2, 0, -4 ],
  [ -4*E(3), -4*E(3)^2, 0, -4, 0, -4 ],
  [ 1, 1, 1, 1, 0, 0 ],
  [ 0, 0, 0, 0, 4, 0 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-69"></a>

### No.69

- source: `job23_liftable_f16`
- target: `Families[69]`
- H_id: `[ 216, 163 ]`; order: `216`; m: `2`
- determinant: `30612578427/24445368828125`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 0, 723/3325, 723/3325, 723/3325, -3/38, 0 ],
  [ 723/3325, 723/3325, 0, 723/3325, -3/38, 0 ],
  [ 723/3325, 0, 723/3325, 723/3325, -3/38, 0 ],
  [ 723/3325, 723/3325, 723/3325, 0, -3/38, 0 ],
  [ -377/700, -377/700, -377/700, -377/700, 0, 1 ],
  [ -27/70, -27/70, -27/70, -27/70, 0, 0 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-71"></a>

### No.71

- source: `job24_liftable_f3`
- target: `Families[71]`
- H_id: `[ 60, 10 ]`; order: `60`; m: `2`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-72"></a>

### No.72

- source: `job25_liftable_f3`
- target: `Families[72]`
- H_id: `[ 90, 5 ]`; order: `90`; m: `2`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-74"></a>

### No.74

- source: `job26_liftable_f4`
- target: `Families[74]`
- H_id: `[ 48, 45 ]`; order: `48`; m: `4`
- determinant: `540*E(4)`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ -1, 1, 0, 0, 0, 0 ],
  [ 2, 3, 0, 0, 0, 0 ],
  [ 0, 0, 0, 4, 0, 0 ],
  [ 0, 0, 3, 0, 0, 0 ],
  [ 0, 0, 0, 0, 3*E(4), 0 ],
  [ 0, 0, 0, 0, 0, 3 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-75"></a>

### No.75

- source: `job27_liftable_f4`
- target: `Families[75]`
- H_id: `[ 48, 47 ]`; order: `48`; m: `3`
- determinant: `1`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.

<a id="matrix-76"></a>

### No.76

- source: `job28_liftable_f1`
- target: `Families[76]`
- H_id: `[ 48, 25 ]`; order: `48`; m: `2`
- determinant: `-192*E(3)`
- status: `verified_unique`

**Conjugating matrix**

```gap
P := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ -4, -3, 0, 0, 0, 0 ],
  [ 0, 0, -4*E(3), 0, 0, 0 ],
  [ 0, 0, 0, 4, 0, 0 ],
  [ 0, 0, 0, 0, 0, -2 ],
  [ 0, 0, 0, 0, -2, 0 ]
];
```

Every source generator satisfies `P^-1*g*P in H_target`; the two group orders agree.


## Strict larger-group inclusions

Each matrix below has nonzero determinant, was checked on every source generator, and maps into a strictly larger smooth target of the same family dimension.

### job05_liftable_f1

- source: `job05_liftable_f1`
- target: No. 8
- source order: `1080`; target order: `6480`; m: `0`
- determinant: `-2430`
- status: `embedded`

**Conjugating matrix**

```gap
P := [
  [ 2, -2, 0, 3, 0, 0 ],
  [ 2, -2, 0, 0, 0, 3 ],
  [ 2, -2, -3, -3, -3, -3 ],
  [ 2, -2, 0, 0, 3, 0 ],
  [ 2, -2, 3, 0, 0, 0 ],
  [ -1, -2, 0, 0, 0, 0 ]
];
```

### job15_liftable_f28

- source: `job15_liftable_f28`
- target: No. 23
- source order: `324`; target order: `8748`; m: `1`
- determinant: `-66*E(3)-33*E(3)^2`
- status: `embedded`

**Conjugating matrix**

```gap
P := [
  [ 11/3*E(3), 11/3*E(3)^2, 11/3, 0, -E(3), -E(3) ],
  [ 11/3*E(3), 11/3*E(3)^2, 11/3, 0, -1, -E(3)^2 ],
  [ 11/3*E(3), 11/3*E(3)^2, 11/3, 0, -E(3)^2, -1 ],
  [ -4*E(3), -3*E(3)^2, -4, -1, 0, 0 ],
  [ -3*E(3), -4*E(3)^2, -4, -1, 0, 0 ],
  [ -4*E(3), -4*E(3)^2, -3, -1, 0, 0 ]
];
```

### job20_liftable_f54

- source: `job20_liftable_f54`
- target: `job06_liftable_f11` (No. 36)
- source order: `216`; target order: `648`; m: `1`
- determinant: `-10368*E(3)+10368*E(3)^2`
- status: `embedded`

**Conjugating matrix**

```gap
P := [
  [ 2, 2, 2, 0, -2, 2 ],
  [ -2, -2, -2, 0, -2, 2 ],
  [ 0, 0, 0, 3, 3, 3 ],
  [ 0, 0, 0, -15, 3, 3 ],
  [ 2*E(3), 2*E(3)^2, 2, 0, 0, 0 ],
  [ 2*E(3)^2, 2*E(3), 2, 0, 0, 0 ]
];
```

### job22_liftable_f2

- source: `job22_liftable_f2`
- target: `job03_liftable_f10` (No. 28)
- source order: `108`; target order: `1296`; m: `1`
- determinant: `-36864*E(3)+36864*E(3)^2`
- status: `embedded`

**Conjugating matrix**

```gap
P := [
  [ -4, 0, -4*E(3)^2, -4*E(3), -2*E(3), -2 ],
  [ 0, -4, -4*E(3), -4*E(3)^2, -2*E(3), -2 ],
  [ -4*E(3), -4*E(3)^2, 0, -4, -2*E(3), -2 ],
  [ -4*E(3)^2, -4*E(3), -4, 0, -2*E(3), -2 ],
  [ 0, 0, 0, 0, -3*E(3)^2, -3 ],
  [ -3, -3, -3, -3, 4, 4 ]
];
```

### job23_liftable_f17

- source: `job23_liftable_f17`
- target: `job03_liftable_f10` (No. 28)
- source order: `216`; target order: `1296`; m: `1`
- determinant: `-129140163/91238000`
- status: `embedded`

**Conjugating matrix**

```gap
P := [
  [ -81/70, 0, 0, 0, 9/38, 0 ],
  [ 0, 0, -81/70, 0, 9/38, 0 ],
  [ 0, 0, 0, -81/70, 9/38, 0 ],
  [ 0, -81/70, 0, 0, 9/38, 0 ],
  [ 27/280, 27/280, 27/280, 27/280, 0, 1 ],
  [ 27/28, 27/28, 27/28, 27/28, 0, 0 ]
];
```

### job25_liftable_f2

- source: `job25_liftable_f2`
- target: `job05_liftable_f1`
- source order: `90`; target order: `1080`; m: `0`
- determinant: `17100*E(5)+34200*E(5)^3+34200*E(5)^4`
- status: `embedded`

**Conjugating matrix**

```gap
P := [
  [ -4, -4, -4, -4, -4, 1 ],
  [ 3, 3, 3, 3, 3, 4 ],
  [ -2*E(5), -2*E(5)^3, -2*E(5)^4, -2, -2*E(5)^2, 0 ],
  [ 3*E(5)^2, 3*E(5), 3*E(5)^3, 3, 3*E(5)^4, 0 ],
  [ 3*E(5)^2, 3*E(5)^3, 3*E(5), 3*E(5)^4, 3, 0 ],
  [ -2*E(5), -2*E(5)^4, -2*E(5)^3, -2*E(5)^2, -2, 0 ]
];
```


## Fermat coordinate changes

All seven sources have certified smooth members and dimension zero. After the displayed substitution, every invariant basis polynomial is a sum of polynomials on the indicated consecutive disjoint coordinate blocks. Since each block has at most two variables, every smooth member is projectively equivalent to the Fermat cubic. Its full group is strictly larger than the source group.

### job06_liftable_f14

- source: `job06_liftable_f14`
- target family: `No.1`
- source order: `648`; m: `0`
- block dimensions: `[ 2, 1, 1, 1, 1 ]`
- determinant: `27`
- status: `verified_additive_splitting`

**Coordinate matrix**

```gap
Q := [
  [ 1, 0, 0, 0, E(3)^2, E(3) ],
  [ 1, 0, 0, 0, E(3), E(3)^2 ],
  [ 1, 0, 0, 0, 1, 1 ],
  [ 0, 1, E(3), E(3)^2, 0, 0 ],
  [ 0, 1, E(3)^2, E(3), 0, 0 ],
  [ 0, 1, 1, 1, 0, 0 ]
];
```


**Transformed invariant basis**

```text
6*x2^3-3*x3^3-3*x4^3,
9*x2^3+9*x3^3+9*x4^3,
27*x1^2*x2,
27/2*x5^3+27/2*x6^3
```

### job07_liftable_f4

- source: `job07_liftable_f4`
- target family: `No.1`
- source order: `648`; m: `0`
- block dimensions: `[ 2, 1, 1, 1, 1 ]`
- determinant: `3`
- status: `verified_additive_splitting`

**Coordinate matrix**

```gap
Q := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 0, E(3)^2, 0, E(3) ],
  [ 0, 0, 0, 1, 0, 1 ],
  [ 0, 0, E(3)^2, 0, E(3), 0 ],
  [ 0, 0, 1, 0, 1, 0 ]
];
```


**Transformed invariant basis**

```text
-x3^3-x4^3-x5^3-x6^3,
x2^3,
x1*x2^2,
x1^2*x2,
x1^3
```

### job14_nonliftable_f1

- source: `job14_nonliftable_f1`
- target family: `No.1`
- source order: `162`; m: `0`
- block dimensions: `[ 2, 2, 2 ]`
- determinant: `27`
- status: `verified_additive_splitting`

**Coordinate matrix**

```gap
Q := [
  [ 1, 0, E(3), 0, E(3)^2, 0 ],
  [ 1, 0, E(3)^2, 0, E(3), 0 ],
  [ 1, 0, 1, 0, 1, 0 ],
  [ 0, 1, 0, E(3), 0, E(3)^2 ],
  [ 0, 1, 0, E(3)^2, 0, E(3) ],
  [ 0, 1, 0, 1, 0, 1 ]
];
```


**Transformed invariant basis**

```text
9*x2^3+9*x4^3+9*x6^3,
9*x1*x2^2+9*x3*x4^2+9*x5*x6^2,
9*x1^2*x2+9*x3^2*x4+9*x5^2*x6,
9*x1^3+9*x3^3+9*x5^3
```

### job15_liftable_f14

- source: `job15_liftable_f14`
- target family: `No.1`
- source order: `324`; m: `0`
- block dimensions: `[ 2, 1, 1, 1, 1 ]`
- determinant: `27`
- status: `verified_additive_splitting`

**Coordinate matrix**

```gap
Q := [
  [ 1, 0, 0, 0, E(3)^2, E(3) ],
  [ 1, 0, 0, 0, E(3), E(3)^2 ],
  [ 1, 0, 0, 0, 1, 1 ],
  [ 0, 1, E(3), E(3)^2, 0, 0 ],
  [ 0, 1, E(3)^2, E(3), 0, 0 ],
  [ 0, 1, 1, 1, 0, 0 ]
];
```


**Transformed invariant basis**

```text
6*x2^3-3*x3^3-3*x4^3,
9*x2^3+9*x3^3+9*x4^3,
27*x1*x2^2,
27*x1^2*x2,
6*x1^3-3*x5^3-3*x6^3,
9*x1^3+9*x5^3+9*x6^3
```

### job15_liftable_f29

- source: `job15_liftable_f29`
- target family: `No.1`
- source order: `324`; m: `0`
- block dimensions: `[ 2, 1, 1, 1, 1 ]`
- determinant: `27`
- status: `verified_additive_splitting`

**Coordinate matrix**

```gap
Q := [
  [ 1, 0, 0, 0, E(3)^2, E(3) ],
  [ 1, 0, 0, 0, E(3), E(3)^2 ],
  [ 1, 0, 0, 0, 1, 1 ],
  [ 0, 1, E(3), E(3)^2, 0, 0 ],
  [ 0, 1, E(3)^2, E(3), 0, 0 ],
  [ 0, 1, 1, 1, 0, 0 ]
];
```


**Transformed invariant basis**

```text
27*x2^3,
27*x1^2*x2-54*x1*x2^2,
-27*x2^3+27/2*x3^3+27/2*x4^3+27/2*x5^3+27/2*x6^3
```

### job18_liftable_f3

- source: `job18_liftable_f3`
- target family: `No.1`
- source order: `108`; m: `0`
- block dimensions: `[ 2, 2, 2 ]`
- determinant: `1`
- status: `verified_additive_splitting`

**Coordinate matrix**

```gap
Q := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```


**Transformed invariant basis**

```text
x6^3,
x5*x6^2,
x5^2*x6,
x5^3,
x1*x2^2+x3*x4^2,
x1^3+x3^3
```

### job19_liftable_f12

- source: `job19_liftable_f12`
- target family: `No.1`
- source order: `216`; m: `0`
- block dimensions: `[ 2, 2, 2 ]`
- determinant: `1`
- status: `verified_additive_splitting`

**Coordinate matrix**

```gap
Q := [
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ]
];
```


**Transformed invariant basis**

```text
x6^3,
x5*x6^2,
x5^2*x6,
x5^3,
x1*x2^2+x3*x4^2,
x1^3+x3^3
```
