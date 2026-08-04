# Liftable Abelian Enumeration Results

This document presents the final restricted output of the GAP pipeline in a searchable and compact format. The summary tables are followed by one collapsible record for each equivalence class. Generator matrices are rewritten as diagonal vectors; the entries are exactly those printed by GAP.

## Source and scope

- Raw output file: `liftable abelian list full.txt`
- SHA-256: `0c269bf2621f4a2545b9c0e48105124c5412cf9ddd770f576412b4afa95eb750`
- Final equivalence classes: **51**
- Maximal-source labels represented: **32**
- Family-dimension range: **1–20**
- Linear-order range: **3–72**
- Every displayed class passes the dangerous-spectrum test and satisfies $\lvert H\cap\mathrm{SL}(6)\rvert\leq 12$.

## Notation

- $Z=\langle E(3)I_6\rangle$ is the central scalar subgroup of order three.
- `|H/Z|` is the order of the projective quotient.
- `dim V3` is the dimension of the invariant cubic space.
- `dim C` is the dimension of the centralizer in $\mathrm{GL}(6)$.
- `D3 = dim V3 - dim C` is the family dimension used by the saturation test.
- `merged` counts equivalent occurrences found in the 32 maximal source groups.
- `sources` lists the maximal block or exceptional types from which the representation was recovered.

## Distribution by family dimension

| $D_3$ | Number of classes |
|---:|---:|
| 20 | 1 |
| 14 | 1 |
| 12 | 1 |
| 10 | 3 |
| 8 | 3 |
| 7 | 5 |
| 6 | 4 |
| 5 | 4 |
| 4 | 9 |
| 3 | 8 |
| 2 | 7 |
| 1 | 5 |

## Distribution by linear order

| $\lvert H\rvert$ | Number of classes |
|---:|---:|
| 3 | 1 |
| 6 | 3 |
| 9 | 4 |
| 12 | 8 |
| 18 | 8 |
| 24 | 9 |
| 27 | 2 |
| 36 | 7 |
| 48 | 4 |
| 54 | 1 |
| 72 | 4 |

## Abstract structures

| Structure | Number of representations |
|---|---:|
| `C6 x C3` | 7 |
| `C12` | 4 |
| `C12 x C2` | 4 |
| `C12 x C3` | 4 |
| `C6 x C2` | 4 |
| `C24` | 3 |
| `C3 x C3` | 3 |
| `C6` | 3 |
| `C6 x C6` | 3 |
| `C12 x C6` | 2 |
| `C24 x C3` | 2 |
| `C3 x C3 x C3` | 2 |
| `C48` | 2 |
| `C6 x C2 x C2` | 2 |
| `C12 x C4` | 1 |
| `C18` | 1 |
| `C24 x C2` | 1 |
| `C3` | 1 |
| `C6 x C3 x C3` | 1 |
| `C9` | 1 |

## Master table

| No. | Structure | $\lvert H\rvert$ | $\lvert H/Z\rvert$ | dim $V_3$ | dim $C$ | $D_3$ | $\lvert H\cap\mathrm{SL}(6)\rvert$ | merged | sources |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|
| [1](#group-01) | `C3` | 3 | 1 | 56 | 36 | 20 | 3 | 32 | 32 |
| [2](#group-02) | `C6` | 6 | 2 | 40 | 26 | 14 | 3 | 26 | 19 |
| [3](#group-03) | `C6` | 6 | 2 | 32 | 20 | 12 | 6 | 23 | 15 |
| [4](#group-04) | `C6 x C2` | 12 | 4 | 28 | 18 | 10 | 6 | 8 | 6 |
| [5](#group-05) | `C3 x C3` | 9 | 3 | 36 | 26 | 10 | 3 | 31 | 14 |
| [6](#group-06) | `C6` | 6 | 2 | 28 | 18 | 10 | 3 | 11 | 7 |
| [7](#group-07) | `C6 x C2` | 12 | 4 | 22 | 14 | 8 | 6 | 8 | 4 |
| [8](#group-08) | `C6 x C2` | 12 | 4 | 20 | 12 | 8 | 12 | 4 | 4 |
| [9](#group-09) | `C3 x C3` | 9 | 3 | 20 | 12 | 8 | 9 | 20 | 4 |
| [10](#group-10) | `C6 x C2 x C2` | 24 | 8 | 19 | 12 | 7 | 12 | 1 | 1 |
| [11](#group-11) | `C6 x C3` | 18 | 6 | 25 | 18 | 7 | 3 | 18 | 8 |
| [12](#group-12) | `C12` | 12 | 4 | 25 | 18 | 7 | 3 | 10 | 9 |
| [13](#group-13) | `C12` | 12 | 4 | 21 | 14 | 7 | 3 | 7 | 5 |
| [14](#group-14) | `C3 x C3` | 9 | 3 | 21 | 14 | 7 | 3 | 88 | 7 |
| [15](#group-15) | `C6 x C3` | 18 | 6 | 20 | 14 | 6 | 6 | 11 | 4 |
| [16](#group-16) | `C12` | 12 | 4 | 16 | 10 | 6 | 12 | 5 | 5 |
| [17](#group-17) | `C6 x C2` | 12 | 4 | 16 | 10 | 6 | 6 | 5 | 3 |
| [18](#group-18) | `C9` | 9 | 3 | 18 | 12 | 6 | 3 | 5 | 3 |
| [19](#group-19) | `C6 x C6` | 36 | 12 | 17 | 12 | 5 | 6 | 3 | 2 |
| [20](#group-20) | `C12 x C2` | 24 | 8 | 17 | 12 | 5 | 6 | 4 | 3 |
| [21](#group-21) | `C6 x C2 x C2` | 24 | 8 | 13 | 8 | 5 | 12 | 1 | 1 |
| [22](#group-22) | `C6 x C3` | 18 | 6 | 15 | 10 | 5 | 3 | 20 | 4 |
| [23](#group-23) | `C6 x C6` | 36 | 12 | 12 | 8 | 4 | 12 | 2 | 1 |
| [24](#group-24) | `C3 x C3 x C3` | 27 | 9 | 14 | 10 | 4 | 9 | 104 | 3 |
| [25](#group-25) | `C12 x C2` | 24 | 8 | 12 | 8 | 4 | 6 | 1 | 1 |
| [26](#group-26) | `C12 x C2` | 24 | 8 | 14 | 10 | 4 | 12 | 2 | 2 |
| [27](#group-27) | `C6 x C3` | 18 | 6 | 16 | 12 | 4 | 3 | 10 | 4 |
| [28](#group-28) | `C6 x C3` | 18 | 6 | 14 | 10 | 4 | 9 | 8 | 3 |
| [29](#group-29) | `C6 x C3` | 18 | 6 | 12 | 8 | 4 | 6 | 5 | 2 |
| [30](#group-30) | `C6 x C3` | 18 | 6 | 10 | 6 | 4 | 9 | 1 | 1 |
| [31](#group-31) | `C12` | 12 | 4 | 16 | 12 | 4 | 6 | 4 | 4 |
| [32](#group-32) | `C12 x C3` | 36 | 12 | 15 | 12 | 3 | 3 | 7 | 4 |
| [33](#group-33) | `C12 x C3` | 36 | 12 | 13 | 10 | 3 | 3 | 2 | 2 |
| [34](#group-34) | `C6 x C6` | 36 | 12 | 11 | 8 | 3 | 6 | 5 | 2 |
| [35](#group-35) | `C3 x C3 x C3` | 27 | 9 | 9 | 6 | 3 | 9 | 120 | 1 |
| [36](#group-36) | `C24` | 24 | 8 | 15 | 12 | 3 | 3 | 4 | 4 |
| [37](#group-37) | `C24` | 24 | 8 | 13 | 10 | 3 | 3 | 2 | 2 |
| [38](#group-38) | `C24` | 24 | 8 | 11 | 8 | 3 | 3 | 1 | 1 |
| [39](#group-39) | `C18` | 18 | 6 | 9 | 6 | 3 | 3 | 1 | 1 |
| [40](#group-40) | `C12 x C6` | 72 | 24 | 10 | 8 | 2 | 6 | 1 | 1 |
| [41](#group-41) | `C6 x C3 x C3` | 54 | 18 | 10 | 8 | 2 | 9 | 16 | 2 |
| [42](#group-42) | `C12 x C4` | 48 | 16 | 10 | 8 | 2 | 12 | 1 | 1 |
| [43](#group-43) | `C24 x C2` | 48 | 16 | 10 | 8 | 2 | 6 | 1 | 1 |
| [44](#group-44) | `C12 x C3` | 36 | 12 | 10 | 8 | 2 | 3 | 4 | 2 |
| [45](#group-45) | `C12 x C3` | 36 | 12 | 8 | 6 | 2 | 3 | 1 | 1 |
| [46](#group-46) | `C12 x C2` | 24 | 8 | 8 | 6 | 2 | 12 | 2 | 2 |
| [47](#group-47) | `C12 x C6` | 72 | 24 | 7 | 6 | 1 | 6 | 1 | 1 |
| [48](#group-48) | `C24 x C3` | 72 | 24 | 9 | 8 | 1 | 3 | 3 | 2 |
| [49](#group-49) | `C24 x C3` | 72 | 24 | 7 | 6 | 1 | 3 | 1 | 1 |
| [50](#group-50) | `C48` | 48 | 16 | 9 | 8 | 1 | 3 | 2 | 2 |
| [51](#group-51) | `C48` | 48 | 16 | 7 | 6 | 1 | 3 | 1 | 1 |

## Detailed records

Each record is collapsed by default. The first generator is usually the scalar $E(3)I_6$. A diagonal vector `[a1, ..., a6]` denotes `DiagonalMat([a1, ..., a6])`.

<a id="group-01"></a>
<details>
<summary><strong>#1: C3</strong> — $\lvert H\rvert=3$, $\lvert H/Z\rvert=1$, $D_3=20$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 3 |
| Projective order $\lvert H/Z\rvert$ | 1 |
| Invariant cubic dimension | 56 |
| Centralizer dimension | 36 |
| Family dimension $D_3$ | 20 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 32 |

**Sources (32):** `K3+K3`, `K3+T1+T1+T1`, `K3+T2+T1`, `K3+T3`, `K4+T1+T1`, `K4+T2`, `K5+T1`, `K6`, `NonSimple-1`, `NonSimple-2`, `NonSimple-3`, `NonSimple-4`, `NonSimple-5`, `NonSimple-6`, `NonSimple-7`, `NonSimple-8`, `T1+T1+T1+T1+T1+T1`, `T2+T1+T1+T1+T1`, `T2+T2+T1+T1`, `T2+T2+T2`, `T3+T1+T1+T1`, `T3+T2+T1`, `T3+T3`, `T4+T1+T1`, `T4+T2`, `T5+T1`, `T6`, `Y11+T1+T1`, `Y11+T2`, `Y21+T1`, `Y22`, `Y31`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);
```

**Invariant cubic monomial basis (56 terms)**

```text
x1^3, x1^2*x2, x1^2*x3, x1^2*x4, x1^2*x5, x1^2*x6, x1*x2^2, x1*x2*x3, x1*x2*x4, x1*x2*x5, x1*x2*x6,
x1*x3^2, x1*x3*x4, x1*x3*x5, x1*x3*x6, x1*x4^2, x1*x4*x5, x1*x4*x6, x1*x5^2, x1*x5*x6, x1*x6^2,
x2^3, x2^2*x3, x2^2*x4, x2^2*x5, x2^2*x6, x2*x3^2, x2*x3*x4, x2*x3*x5, x2*x3*x6, x2*x4^2, x2*x4*x5,
x2*x4*x6, x2*x5^2, x2*x5*x6, x2*x6^2, x3^3, x3^2*x4, x3^2*x5, x3^2*x6, x3*x4^2, x3*x4*x5, x3*x4*x6,
x3*x5^2, x3*x5*x6, x3*x6^2, x4^3, x4^2*x5, x4^2*x6, x4*x5^2, x4*x5*x6, x4*x6^2, x5^3, x5^2*x6,
x5*x6^2, x6^3
```

</details>

<a id="group-02"></a>
<details>
<summary><strong>#2: C6</strong> — $\lvert H\rvert=6$, $\lvert H/Z\rvert=2$, $D_3=14$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 6 |
| Projective order $\lvert H/Z\rvert$ | 2 |
| Invariant cubic dimension | 40 |
| Centralizer dimension | 26 |
| Family dimension $D_3$ | 14 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 26 |

**Sources (19):** `K3+T2+T1`, `K3+T3`, `K4+T2`, `NonSimple-3`, `NonSimple-8`, `T2+T1+T1+T1+T1`, `T2+T2+T1+T1`, `T2+T2+T2`, `T3+T1+T1+T1`, `T3+T2+T1`, `T3+T3`, `T4+T1+T1`, `T4+T2`, `T5+T1`, `T6`, `Y11+T2`, `Y21+T1`, `Y22`, `Y31`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, 1, 1, -1, 1, 1
]);
```

**Invariant cubic monomial basis (40 terms)**

```text
x1^3, x1^2*x2, x1^2*x3, x1^2*x5, x1^2*x6, x1*x2^2, x1*x2*x3, x1*x2*x5, x1*x2*x6, x1*x3^2, x1*x3*x5,
x1*x3*x6, x1*x4^2, x1*x5^2, x1*x5*x6, x1*x6^2, x2^3, x2^2*x3, x2^2*x5, x2^2*x6, x2*x3^2, x2*x3*x5,
x2*x3*x6, x2*x4^2, x2*x5^2, x2*x5*x6, x2*x6^2, x3^3, x3^2*x5, x3^2*x6, x3*x4^2, x3*x5^2, x3*x5*x6,
x3*x6^2, x4^2*x5, x4^2*x6, x5^3, x5^2*x6, x5*x6^2, x6^3
```

</details>

<a id="group-03"></a>
<details>
<summary><strong>#3: C6</strong> — $\lvert H\rvert=6$, $\lvert H/Z\rvert=2$, $D_3=12$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 6 |
| Projective order $\lvert H/Z\rvert$ | 2 |
| Invariant cubic dimension | 32 |
| Centralizer dimension | 20 |
| Family dimension $D_3$ | 12 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 6 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 23 |

**Sources (15):** `NonSimple-2`, `NonSimple-3`, `NonSimple-4`, `NonSimple-5`, `NonSimple-6`, `NonSimple-7`, `NonSimple-8`, `T2+T2+T1+T1`, `T2+T2+T2`, `T3+T2+T1`, `T3+T3`, `T4+T2`, `Y11+T1+T1`, `Y11+T2`, `Y22`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -1, 1, -1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (32 terms)**

```text
x1^2*x2, x1^2*x4, x1^2*x5, x1^2*x6, x1*x2*x3, x1*x3*x4, x1*x3*x5, x1*x3*x6, x2^3, x2^2*x4, x2^2*x5,
x2^2*x6, x2*x3^2, x2*x4^2, x2*x4*x5, x2*x4*x6, x2*x5^2, x2*x5*x6, x2*x6^2, x3^2*x4, x3^2*x5,
x3^2*x6, x4^3, x4^2*x5, x4^2*x6, x4*x5^2, x4*x5*x6, x4*x6^2, x5^3, x5^2*x6, x5*x6^2, x6^3
```

</details>

<a id="group-04"></a>
<details>
<summary><strong>#4: C6 x C2</strong> — $\lvert H\rvert=12$, $\lvert H/Z\rvert=4$, $D_3=10$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 12 |
| Projective order $\lvert H/Z\rvert$ | 4 |
| Invariant cubic dimension | 28 |
| Centralizer dimension | 18 |
| Family dimension $D_3$ | 10 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 6 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 8 |

**Sources (6):** `T2+T2+T1+T1`, `T2+T2+T2`, `T3+T2+T1`, `T3+T3`, `T4+T2`, `Y22`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -1, 1, -1, 1, 1, 1
]);

g3 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (28 terms)**

```text
x1^2*x2, x1^2*x4, x1^2*x5, x1^2*x6, x2^3, x2^2*x4, x2^2*x5, x2^2*x6, x2*x3^2, x2*x4^2, x2*x4*x5,
x2*x4*x6, x2*x5^2, x2*x5*x6, x2*x6^2, x3^2*x4, x3^2*x5, x3^2*x6, x4^3, x4^2*x5, x4^2*x6, x4*x5^2,
x4*x5*x6, x4*x6^2, x5^3, x5^2*x6, x5*x6^2, x6^3
```

</details>

<a id="group-05"></a>
<details>
<summary><strong>#5: C3 x C3</strong> — $\lvert H\rvert=9$, $\lvert H/Z\rvert=3$, $D_3=10$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 9 |
| Projective order $\lvert H/Z\rvert$ | 3 |
| Invariant cubic dimension | 36 |
| Centralizer dimension | 26 |
| Family dimension $D_3$ | 10 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 31 |

**Sources (14):** `K3+T1+T1+T1`, `K3+T2+T1`, `K4+T1+T1`, `K5+T1`, `NonSimple-7`, `T1+T1+T1+T1+T1+T1`, `T2+T1+T1+T1+T1`, `T2+T2+T1+T1`, `T3+T1+T1+T1`, `T3+T2+T1`, `T4+T1+T1`, `T5+T1`, `Y11+T1+T1`, `Y21+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, 1, 1, E(3), 1, 1
]);
```

**Invariant cubic monomial basis (36 terms)**

```text
x1^3, x1^2*x2, x1^2*x3, x1^2*x5, x1^2*x6, x1*x2^2, x1*x2*x3, x1*x2*x5, x1*x2*x6, x1*x3^2, x1*x3*x5,
x1*x3*x6, x1*x5^2, x1*x5*x6, x1*x6^2, x2^3, x2^2*x3, x2^2*x5, x2^2*x6, x2*x3^2, x2*x3*x5, x2*x3*x6,
x2*x5^2, x2*x5*x6, x2*x6^2, x3^3, x3^2*x5, x3^2*x6, x3*x5^2, x3*x5*x6, x3*x6^2, x4^3, x5^3, x5^2*x6,
x5*x6^2, x6^3
```

</details>

<a id="group-06"></a>
<details>
<summary><strong>#6: C6</strong> — $\lvert H\rvert=6$, $\lvert H/Z\rvert=2$, $D_3=10$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 6 |
| Projective order $\lvert H/Z\rvert$ | 2 |
| Invariant cubic dimension | 28 |
| Centralizer dimension | 18 |
| Family dimension $D_3$ | 10 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 11 |

**Sources (7):** `NonSimple-1`, `NonSimple-3`, `NonSimple-5`, `NonSimple-6`, `NonSimple-8`, `T2+T2+T2`, `Y11+T2`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -1, 1, 1, -1, -1, 1
]);
```

**Invariant cubic monomial basis (28 terms)**

```text
x1^2*x2, x1^2*x3, x1^2*x6, x1*x2*x4, x1*x2*x5, x1*x3*x4, x1*x3*x5, x1*x4*x6, x1*x5*x6, x2^3,
x2^2*x3, x2^2*x6, x2*x3^2, x2*x3*x6, x2*x4^2, x2*x4*x5, x2*x5^2, x2*x6^2, x3^3, x3^2*x6, x3*x4^2,
x3*x4*x5, x3*x5^2, x3*x6^2, x4^2*x6, x4*x5*x6, x5^2*x6, x6^3
```

</details>

<a id="group-07"></a>
<details>
<summary><strong>#7: C6 x C2</strong> — $\lvert H\rvert=12$, $\lvert H/Z\rvert=4$, $D_3=8$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 12 |
| Projective order $\lvert H/Z\rvert$ | 4 |
| Invariant cubic dimension | 22 |
| Centralizer dimension | 14 |
| Family dimension $D_3$ | 8 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 6 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 8 |

**Sources (4):** `NonSimple-3`, `NonSimple-8`, `T2+T2+T2`, `Y11+T2`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);

g3 := DiagonalMat([
    1, 1, 1, -1, -1, 1
]);
```

**Invariant cubic monomial basis (22 terms)**

```text
x1^2*x2, x1^2*x3, x1^2*x6, x2^3, x2^2*x3, x2^2*x6, x2*x3^2, x2*x3*x6, x2*x4^2, x2*x4*x5, x2*x5^2,
x2*x6^2, x3^3, x3^2*x6, x3*x4^2, x3*x4*x5, x3*x5^2, x3*x6^2, x4^2*x6, x4*x5*x6, x5^2*x6, x6^3
```

</details>

<a id="group-08"></a>
<details>
<summary><strong>#8: C6 x C2</strong> — $\lvert H\rvert=12$, $\lvert H/Z\rvert=4$, $D_3=8$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 12 |
| Projective order $\lvert H/Z\rvert$ | 4 |
| Invariant cubic dimension | 20 |
| Centralizer dimension | 12 |
| Family dimension $D_3$ | 8 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 12 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 4 |

**Sources (4):** `NonSimple-4`, `NonSimple-7`, `NonSimple-8`, `T2+T2+T2`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -1, 1, 1, -1, 1, 1
]);

g3 := DiagonalMat([
    1, 1, 1, -1, -1, 1
]);
```

**Invariant cubic monomial basis (20 terms)**

```text
x1^2*x2, x1^2*x3, x1^2*x6, x1*x4*x5, x2^3, x2^2*x3, x2^2*x6, x2*x3^2, x2*x3*x6, x2*x4^2, x2*x5^2,
x2*x6^2, x3^3, x3^2*x6, x3*x4^2, x3*x5^2, x3*x6^2, x4^2*x6, x5^2*x6, x6^3
```

</details>

<a id="group-09"></a>
<details>
<summary><strong>#9: C3 x C3</strong> — $\lvert H\rvert=9$, $\lvert H/Z\rvert=3$, $D_3=8$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 9 |
| Projective order $\lvert H/Z\rvert$ | 3 |
| Invariant cubic dimension | 20 |
| Centralizer dimension | 12 |
| Family dimension $D_3$ | 8 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 9 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 20 |

**Sources (4):** `T1+T1+T1+T1+T1+T1`, `T2+T1+T1+T1+T1`, `T2+T2+T1+T1`, `T2+T2+T2`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    E(3)^2, E(3)^2, E(3), 1, E(3), 1
]);
```

**Invariant cubic monomial basis (20 terms)**

```text
x1^3, x1^2*x2, x1*x2^2, x1*x3*x4, x1*x3*x6, x1*x4*x5, x1*x5*x6, x2^3, x2*x3*x4, x2*x3*x6, x2*x4*x5,
x2*x5*x6, x3^3, x3^2*x5, x3*x5^2, x4^3, x4^2*x6, x4*x6^2, x5^3, x6^3
```

</details>

<a id="group-10"></a>
<details>
<summary><strong>#10: C6 x C2 x C2</strong> — $\lvert H\rvert=24$, $\lvert H/Z\rvert=8$, $D_3=7$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 24 |
| Projective order $\lvert H/Z\rvert$ | 8 |
| Invariant cubic dimension | 19 |
| Centralizer dimension | 12 |
| Family dimension $D_3$ | 7 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 12 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 1 |

**Sources (1):** `T2+T2+T2`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, 1, 1, 1, -1, 1
]);

g3 := DiagonalMat([
    1, 1, -1, 1, 1, 1
]);

g4 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (19 terms)**

```text
x1^2*x2, x1^2*x4, x1^2*x6, x2^3, x2^2*x4, x2^2*x6, x2*x3^2, x2*x4^2, x2*x4*x6, x2*x5^2, x2*x6^2,
x3^2*x4, x3^2*x6, x4^3, x4^2*x6, x4*x5^2, x4*x6^2, x5^2*x6, x6^3
```

</details>

<a id="group-11"></a>
<details>
<summary><strong>#11: C6 x C3</strong> — $\lvert H\rvert=18$, $\lvert H/Z\rvert=6$, $D_3=7$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 18 |
| Projective order $\lvert H/Z\rvert$ | 6 |
| Invariant cubic dimension | 25 |
| Centralizer dimension | 18 |
| Family dimension $D_3$ | 7 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 18 |

**Sources (8):** `K3+T2+T1`, `T2+T1+T1+T1+T1`, `T2+T2+T1+T1`, `T3+T1+T1+T1`, `T3+T2+T1`, `T4+T1+T1`, `T5+T1`, `Y21+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    E(3)^2, E(3)^2, E(3)^2, E(3)^2, 1, E(3)^2
]);

g3 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (25 terms)**

```text
x1^2*x2, x1^2*x3, x1^2*x4, x1^2*x6, x2^3, x2^2*x3, x2^2*x4, x2^2*x6, x2*x3^2, x2*x3*x4, x2*x3*x6,
x2*x4^2, x2*x4*x6, x2*x6^2, x3^3, x3^2*x4, x3^2*x6, x3*x4^2, x3*x4*x6, x3*x6^2, x4^3, x4^2*x6,
x4*x6^2, x5^3, x6^3
```

</details>

<a id="group-12"></a>
<details>
<summary><strong>#12: C12</strong> — $\lvert H\rvert=12$, $\lvert H/Z\rvert=4$, $D_3=7$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 12 |
| Projective order $\lvert H/Z\rvert$ | 4 |
| Invariant cubic dimension | 25 |
| Centralizer dimension | 18 |
| Family dimension $D_3$ | 7 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 10 |

**Sources (9):** `K3+T3`, `T3+T1+T1+T1`, `T3+T2+T1`, `T3+T3`, `T4+T1+T1`, `T4+T2`, `T5+T1`, `T6`, `Y31`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -E(4), -1, 1, 1, 1, 1
]);

g3 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (25 terms)**

```text
x1^2*x2, x2^2*x3, x2^2*x4, x2^2*x5, x2^2*x6, x3^3, x3^2*x4, x3^2*x5, x3^2*x6, x3*x4^2, x3*x4*x5,
x3*x4*x6, x3*x5^2, x3*x5*x6, x3*x6^2, x4^3, x4^2*x5, x4^2*x6, x4*x5^2, x4*x5*x6, x4*x6^2, x5^3,
x5^2*x6, x5*x6^2, x6^3
```

</details>

<a id="group-13"></a>
<details>
<summary><strong>#13: C12</strong> — $\lvert H\rvert=12$, $\lvert H/Z\rvert=4$, $D_3=7$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 12 |
| Projective order $\lvert H/Z\rvert$ | 4 |
| Invariant cubic dimension | 21 |
| Centralizer dimension | 14 |
| Family dimension $D_3$ | 7 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 7 |

**Sources (5):** `NonSimple-3`, `T3+T2+T1`, `T3+T3`, `T4+T2`, `Y21+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);

g3 := DiagonalMat([
    E(4), -1, 1, -1, 1, 1
]);
```

**Invariant cubic monomial basis (21 terms)**

```text
x1^2*x2, x1^2*x4, x2^2*x3, x2^2*x5, x2^2*x6, x2*x3*x4, x2*x4*x5, x2*x4*x6, x3^3, x3^2*x5, x3^2*x6,
x3*x4^2, x3*x5^2, x3*x5*x6, x3*x6^2, x4^2*x5, x4^2*x6, x5^3, x5^2*x6, x5*x6^2, x6^3
```

</details>

<a id="group-14"></a>
<details>
<summary><strong>#14: C3 x C3</strong> — $\lvert H\rvert=9$, $\lvert H/Z\rvert=3$, $D_3=7$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 9 |
| Projective order $\lvert H/Z\rvert$ | 3 |
| Invariant cubic dimension | 21 |
| Centralizer dimension | 14 |
| Family dimension $D_3$ | 7 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 88 |

**Sources (7):** `K3+T1+T1+T1`, `K3+T2+T1`, `T1+T1+T1+T1+T1+T1`, `T2+T1+T1+T1+T1`, `T2+T2+T1+T1`, `T3+T1+T1+T1`, `T3+T2+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, E(3)^2, 1, E(3), 1, E(3)^2
]);
```

**Invariant cubic monomial basis (21 terms)**

```text
x1^3, x1^2*x3, x1^2*x5, x1*x2*x4, x1*x3^2, x1*x3*x5, x1*x4*x6, x1*x5^2, x2^3, x2^2*x6, x2*x3*x4,
x2*x4*x5, x2*x6^2, x3^3, x3^2*x5, x3*x4*x6, x3*x5^2, x4^3, x4*x5*x6, x5^3, x6^3
```

</details>

<a id="group-15"></a>
<details>
<summary><strong>#15: C6 x C3</strong> — $\lvert H\rvert=18$, $\lvert H/Z\rvert=6$, $D_3=6$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 18 |
| Projective order $\lvert H/Z\rvert$ | 6 |
| Invariant cubic dimension | 20 |
| Centralizer dimension | 14 |
| Family dimension $D_3$ | 6 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 6 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 11 |

**Sources (4):** `NonSimple-7`, `T2+T2+T1+T1`, `T3+T2+T1`, `Y11+T1+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, 1, 1, 1, 1, E(3)
]);

g3 := DiagonalMat([
    -1, 1, -1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (20 terms)**

```text
x1^2*x2, x1^2*x4, x1^2*x5, x1*x2*x3, x1*x3*x4, x1*x3*x5, x2^3, x2^2*x4, x2^2*x5, x2*x3^2, x2*x4^2,
x2*x4*x5, x2*x5^2, x3^2*x4, x3^2*x5, x4^3, x4^2*x5, x4*x5^2, x5^3, x6^3
```

</details>

<a id="group-16"></a>
<details>
<summary><strong>#16: C12</strong> — $\lvert H\rvert=12$, $\lvert H/Z\rvert=4$, $D_3=6$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 12 |
| Projective order $\lvert H/Z\rvert$ | 4 |
| Invariant cubic dimension | 16 |
| Centralizer dimension | 10 |
| Family dimension $D_3$ | 6 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 12 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 5 |

**Sources (5):** `NonSimple-5`, `NonSimple-6`, `T3+T3`, `Y11+T2`, `Y22`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    E(4), -1, 1, -E(4), -1, 1
]);

g3 := DiagonalMat([
    -1, 1, 1, -1, 1, 1
]);
```

**Invariant cubic monomial basis (16 terms)**

```text
x1^2*x2, x1^2*x5, x1*x3*x4, x1*x4*x6, x2^2*x3, x2^2*x6, x2*x3*x5, x2*x4^2, x2*x5*x6, x3^3, x3^2*x6,
x3*x5^2, x3*x6^2, x4^2*x5, x5^2*x6, x6^3
```

</details>

<a id="group-17"></a>
<details>
<summary><strong>#17: C6 x C2</strong> — $\lvert H\rvert=12$, $\lvert H/Z\rvert=4$, $D_3=6$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 12 |
| Projective order $\lvert H/Z\rvert$ | 4 |
| Invariant cubic dimension | 16 |
| Centralizer dimension | 10 |
| Family dimension $D_3$ | 6 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 6 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 5 |

**Sources (3):** `NonSimple-5`, `NonSimple-6`, `NonSimple-8`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -1, 1, 1, -1, 1, 1
]);

g3 := DiagonalMat([
    1, 1, 1, -1, -1, -1
]);
```

**Invariant cubic monomial basis (16 terms)**

```text
x1^2*x2, x1^2*x3, x1*x4*x5, x1*x4*x6, x2^3, x2^2*x3, x2*x3^2, x2*x4^2, x2*x5^2, x2*x5*x6, x2*x6^2,
x3^3, x3*x4^2, x3*x5^2, x3*x5*x6, x3*x6^2
```

</details>

<a id="group-18"></a>
<details>
<summary><strong>#18: C9</strong> — $\lvert H\rvert=9$, $\lvert H/Z\rvert=3$, $D_3=6$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 9 |
| Projective order $\lvert H/Z\rvert$ | 3 |
| Invariant cubic dimension | 18 |
| Centralizer dimension | 12 |
| Family dimension $D_3$ | 6 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 5 |

**Sources (3):** `K3+K3`, `K6`, `NonSimple-1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    E(9)^4, -E(9)^4-E(9)^7, E(9)^7, -E(9)^4-E(9)^7, E(9)^7, E(9)^4
]);
```

**Invariant cubic monomial basis (18 terms)**

```text
x1^2*x2, x1^2*x4, x1*x2*x6, x1*x3^2, x1*x3*x5, x1*x4*x6, x1*x5^2, x2^2*x3, x2^2*x5, x2*x3*x4,
x2*x4*x5, x2*x6^2, x3^2*x6, x3*x4^2, x3*x5*x6, x4^2*x5, x4*x6^2, x5^2*x6
```

</details>

<a id="group-19"></a>
<details>
<summary><strong>#19: C6 x C6</strong> — $\lvert H\rvert=36$, $\lvert H/Z\rvert=12$, $D_3=5$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 36 |
| Projective order $\lvert H/Z\rvert$ | 12 |
| Invariant cubic dimension | 17 |
| Centralizer dimension | 12 |
| Family dimension $D_3$ | 5 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 6 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 3 |

**Sources (2):** `T2+T2+T1+T1`, `T3+T2+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, 1, 1, -1, 1, 1
]);

g3 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), 1
]);

g4 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (17 terms)**

```text
x1^2*x2, x1^2*x3, x1^2*x5, x2^3, x2^2*x3, x2^2*x5, x2*x3^2, x2*x3*x5, x2*x4^2, x2*x5^2, x3^3,
x3^2*x5, x3*x4^2, x3*x5^2, x4^2*x5, x5^3, x6^3
```

</details>

<a id="group-20"></a>
<details>
<summary><strong>#20: C12 x C2</strong> — $\lvert H\rvert=24$, $\lvert H/Z\rvert=8$, $D_3=5$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 24 |
| Projective order $\lvert H/Z\rvert$ | 8 |
| Invariant cubic dimension | 17 |
| Centralizer dimension | 12 |
| Family dimension $D_3$ | 5 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 6 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 4 |

**Sources (3):** `T3+T2+T1`, `T3+T3`, `T4+T2`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, 1, 1, -1, 1, 1
]);

g3 := DiagonalMat([
    -E(4), -1, 1, 1, 1, 1
]);

g4 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (17 terms)**

```text
x1^2*x2, x2^2*x3, x2^2*x5, x2^2*x6, x3^3, x3^2*x5, x3^2*x6, x3*x4^2, x3*x5^2, x3*x5*x6, x3*x6^2,
x4^2*x5, x4^2*x6, x5^3, x5^2*x6, x5*x6^2, x6^3
```

</details>

<a id="group-21"></a>
<details>
<summary><strong>#21: C6 x C2 x C2</strong> — $\lvert H\rvert=24$, $\lvert H/Z\rvert=8$, $D_3=5$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 24 |
| Projective order $\lvert H/Z\rvert$ | 8 |
| Invariant cubic dimension | 13 |
| Centralizer dimension | 8 |
| Family dimension $D_3$ | 5 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 12 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 1 |

**Sources (1):** `NonSimple-8`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, -1, -1, 1, 1, 1
]);

g3 := DiagonalMat([
    -1, 1, -1, 1, 1, 1
]);

g4 := DiagonalMat([
    1, 1, 1, -1, 1, 1
]);
```

**Invariant cubic monomial basis (13 terms)**

```text
x1^2*x5, x1^2*x6, x1*x2*x3, x2^2*x5, x2^2*x6, x3^2*x5, x3^2*x6, x4^2*x5, x4^2*x6, x5^3, x5^2*x6,
x5*x6^2, x6^3
```

</details>

<a id="group-22"></a>
<details>
<summary><strong>#22: C6 x C3</strong> — $\lvert H\rvert=18$, $\lvert H/Z\rvert=6$, $D_3=5$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 18 |
| Projective order $\lvert H/Z\rvert$ | 6 |
| Invariant cubic dimension | 15 |
| Centralizer dimension | 10 |
| Family dimension $D_3$ | 5 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 20 |

**Sources (4):** `T2+T1+T1+T1+T1`, `T2+T2+T1+T1`, `T3+T1+T1+T1`, `T3+T2+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    E(3), E(3), E(3), 1, E(3)^2, E(3)^2
]);

g3 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (15 terms)**

```text
x1^2*x2, x1^2*x3, x2^3, x2^2*x3, x2*x3^2, x2*x4*x5, x2*x4*x6, x3^3, x3*x4*x5, x3*x4*x6, x4^3, x5^3,
x5^2*x6, x5*x6^2, x6^3
```

</details>

<a id="group-23"></a>
<details>
<summary><strong>#23: C6 x C6</strong> — $\lvert H\rvert=36$, $\lvert H/Z\rvert=12$, $D_3=4$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 36 |
| Projective order $\lvert H/Z\rvert$ | 12 |
| Invariant cubic dimension | 12 |
| Centralizer dimension | 8 |
| Family dimension $D_3$ | 4 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 12 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 2 |

**Sources (1):** `NonSimple-7`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, -1, -1, 1, 1, 1
]);

g3 := DiagonalMat([
    -1, 1, -1, 1, 1, 1
]);

g4 := DiagonalMat([
    1, 1, 1, 1, 1, E(3)
]);
```

**Invariant cubic monomial basis (12 terms)**

```text
x1^2*x4, x1^2*x5, x1*x2*x3, x2^2*x4, x2^2*x5, x3^2*x4, x3^2*x5, x4^3, x4^2*x5, x4*x5^2, x5^3, x6^3
```

</details>

<a id="group-24"></a>
<details>
<summary><strong>#24: C3 x C3 x C3</strong> — $\lvert H\rvert=27$, $\lvert H/Z\rvert=9$, $D_3=4$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 27 |
| Projective order $\lvert H/Z\rvert$ | 9 |
| Invariant cubic dimension | 14 |
| Centralizer dimension | 10 |
| Family dimension $D_3$ | 4 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 9 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 104 |

**Sources (3):** `T1+T1+T1+T1+T1+T1`, `T2+T1+T1+T1+T1`, `T2+T2+T1+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, E(3)^2, 1, E(3), E(3)^2, E(3)
]);

g3 := DiagonalMat([
    E(3), 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (14 terms)**

```text
x1^3, x2^3, x2^2*x5, x2*x3*x4, x2*x3*x6, x2*x5^2, x3^3, x3*x4*x5, x3*x5*x6, x4^3, x4^2*x6, x4*x6^2,
x5^3, x6^3
```

</details>

<a id="group-25"></a>
<details>
<summary><strong>#25: C12 x C2</strong> — $\lvert H\rvert=24$, $\lvert H/Z\rvert=8$, $D_3=4$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 24 |
| Projective order $\lvert H/Z\rvert$ | 8 |
| Invariant cubic dimension | 12 |
| Centralizer dimension | 8 |
| Family dimension $D_3$ | 4 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 6 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 1 |

**Sources (1):** `NonSimple-3`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);

g3 := DiagonalMat([
    E(4), -1, 1, 1, -1, 1
]);

g4 := DiagonalMat([
    1, 1, 1, -1, -1, 1
]);
```

**Invariant cubic monomial basis (12 terms)**

```text
x1^2*x2, x2^2*x3, x2^2*x6, x2*x4*x5, x3^3, x3^2*x6, x3*x4^2, x3*x5^2, x3*x6^2, x4^2*x6, x5^2*x6,
x6^3
```

</details>

<a id="group-26"></a>
<details>
<summary><strong>#26: C12 x C2</strong> — $\lvert H\rvert=24$, $\lvert H/Z\rvert=8$, $D_3=4$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 24 |
| Projective order $\lvert H/Z\rvert$ | 8 |
| Invariant cubic dimension | 14 |
| Centralizer dimension | 10 |
| Family dimension $D_3$ | 4 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 12 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 2 |

**Sources (2):** `T3+T3`, `Y22`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -E(4), -1, 1, -E(4), -1, 1
]);

g3 := DiagonalMat([
    1, 1, 1, -1, 1, 1
]);

g4 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (14 terms)**

```text
x1^2*x2, x1^2*x5, x2^2*x3, x2^2*x6, x2*x3*x5, x2*x4^2, x2*x5*x6, x3^3, x3^2*x6, x3*x5^2, x3*x6^2,
x4^2*x5, x5^2*x6, x6^3
```

</details>

<a id="group-27"></a>
<details>
<summary><strong>#27: C6 x C3</strong> — $\lvert H\rvert=18$, $\lvert H/Z\rvert=6$, $D_3=4$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 18 |
| Projective order $\lvert H/Z\rvert$ | 6 |
| Invariant cubic dimension | 16 |
| Centralizer dimension | 12 |
| Family dimension $D_3$ | 4 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 10 |

**Sources (4):** `K3+T2+T1`, `T2+T1+T1+T1+T1`, `T2+T2+T1+T1`, `T3+T2+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    E(3), E(3), E(3)^2, E(3)^2, 1, E(3)^2
]);

g3 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (16 terms)**

```text
x1^2*x2, x2^3, x2*x3*x5, x2*x4*x5, x2*x5*x6, x3^3, x3^2*x4, x3^2*x6, x3*x4^2, x3*x4*x6, x3*x6^2,
x4^3, x4^2*x6, x4*x6^2, x5^3, x6^3
```

</details>

<a id="group-28"></a>
<details>
<summary><strong>#28: C6 x C3</strong> — $\lvert H\rvert=18$, $\lvert H/Z\rvert=6$, $D_3=4$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 18 |
| Projective order $\lvert H/Z\rvert$ | 6 |
| Invariant cubic dimension | 14 |
| Centralizer dimension | 10 |
| Family dimension $D_3$ | 4 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 9 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 8 |

**Sources (3):** `T2+T1+T1+T1+T1`, `T2+T2+T1+T1`, `T2+T2+T2`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    E(3), E(3), E(3)^2, 1, 1, E(3)^2
]);

g3 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (14 terms)**

```text
x1^2*x2, x2^3, x2*x3*x4, x2*x3*x5, x2*x4*x6, x2*x5*x6, x3^3, x3^2*x6, x3*x6^2, x4^3, x4^2*x5,
x4*x5^2, x5^3, x6^3
```

</details>

<a id="group-29"></a>
<details>
<summary><strong>#29: C6 x C3</strong> — $\lvert H\rvert=18$, $\lvert H/Z\rvert=6$, $D_3=4$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 18 |
| Projective order $\lvert H/Z\rvert$ | 6 |
| Invariant cubic dimension | 12 |
| Centralizer dimension | 8 |
| Family dimension $D_3$ | 4 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 6 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 5 |

**Sources (2):** `T2+T2+T1+T1`, `T3+T2+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, 1, E(3), E(3), 1, E(3)^2
]);

g3 := DiagonalMat([
    -1, 1, -1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (12 terms)**

```text
x1^2*x2, x1^2*x5, x1*x3*x6, x2^3, x2^2*x5, x2*x4*x6, x2*x5^2, x3^2*x4, x4^3, x4*x5*x6, x5^3, x6^3
```

</details>

<a id="group-30"></a>
<details>
<summary><strong>#30: C6 x C3</strong> — $\lvert H\rvert=18$, $\lvert H/Z\rvert=6$, $D_3=4$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 18 |
| Projective order $\lvert H/Z\rvert$ | 6 |
| Invariant cubic dimension | 10 |
| Centralizer dimension | 6 |
| Family dimension $D_3$ | 4 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 9 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 1 |

**Sources (1):** `T2+T2+T2`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -1, 1, -1, 1, -1, 1
]);

g3 := DiagonalMat([
    E(3), E(3), 1, 1, E(3)^2, E(3)^2
]);
```

**Invariant cubic monomial basis (10 terms)**

```text
x1^2*x2, x1*x3*x6, x1*x4*x5, x2^3, x2*x3*x5, x2*x4*x6, x3^2*x4, x4^3, x5^2*x6, x6^3
```

</details>

<a id="group-31"></a>
<details>
<summary><strong>#31: C12</strong> — $\lvert H\rvert=12$, $\lvert H/Z\rvert=4$, $D_3=4$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 12 |
| Projective order $\lvert H/Z\rvert$ | 4 |
| Invariant cubic dimension | 16 |
| Centralizer dimension | 12 |
| Family dimension $D_3$ | 4 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 6 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 4 |

**Sources (4):** `NonSimple-2`, `NonSimple-4`, `NonSimple-5`, `NonSimple-6`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -1, 1, 1, -1, 1, 1
]);

g3 := DiagonalMat([
    E(4), -1, 1, E(4), -1, 1
]);
```

**Invariant cubic monomial basis (16 terms)**

```text
x1^2*x2, x1^2*x5, x1*x2*x4, x1*x4*x5, x2^2*x3, x2^2*x6, x2*x3*x5, x2*x4^2, x2*x5*x6, x3^3, x3^2*x6,
x3*x5^2, x3*x6^2, x4^2*x5, x5^2*x6, x6^3
```

</details>

<a id="group-32"></a>
<details>
<summary><strong>#32: C12 x C3</strong> — $\lvert H\rvert=36$, $\lvert H/Z\rvert=12$, $D_3=3$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 36 |
| Projective order $\lvert H/Z\rvert$ | 12 |
| Invariant cubic dimension | 15 |
| Centralizer dimension | 12 |
| Family dimension $D_3$ | 3 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 7 |

**Sources (4):** `T3+T1+T1+T1`, `T3+T2+T1`, `T4+T1+T1`, `T5+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), 1
]);

g3 := DiagonalMat([
    -E(4), -1, 1, 1, 1, 1
]);

g4 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (15 terms)**

```text
x1^2*x2, x2^2*x3, x2^2*x4, x2^2*x5, x3^3, x3^2*x4, x3^2*x5, x3*x4^2, x3*x4*x5, x3*x5^2, x4^3,
x4^2*x5, x4*x5^2, x5^3, x6^3
```

</details>

<a id="group-33"></a>
<details>
<summary><strong>#33: C12 x C3</strong> — $\lvert H\rvert=36$, $\lvert H/Z\rvert=12$, $D_3=3$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 36 |
| Projective order $\lvert H/Z\rvert$ | 12 |
| Invariant cubic dimension | 13 |
| Centralizer dimension | 10 |
| Family dimension $D_3$ | 3 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 2 |

**Sources (2):** `T3+T2+T1`, `Y21+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -E(4), -1, 1, -1, 1, 1
]);

g3 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), 1
]);

g4 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (13 terms)**

```text
x1^2*x2, x1^2*x4, x2^2*x3, x2^2*x5, x2*x3*x4, x2*x4*x5, x3^3, x3^2*x5, x3*x4^2, x3*x5^2, x4^2*x5,
x5^3, x6^3
```

</details>

<a id="group-34"></a>
<details>
<summary><strong>#34: C6 x C6</strong> — $\lvert H\rvert=36$, $\lvert H/Z\rvert=12$, $D_3=3$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 36 |
| Projective order $\lvert H/Z\rvert$ | 12 |
| Invariant cubic dimension | 11 |
| Centralizer dimension | 8 |
| Family dimension $D_3$ | 3 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 6 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 5 |

**Sources (2):** `T2+T2+T1+T1`, `T3+T2+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, 1, 1, -1, 1, 1
]);

g3 := DiagonalMat([
    E(3)^2, E(3)^2, E(3)^2, E(3), E(3), 1
]);

g4 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (11 terms)**

```text
x1^2*x2, x1^2*x3, x2^3, x2^2*x3, x2*x3^2, x2*x5*x6, x3^3, x3*x5*x6, x4^2*x5, x5^3, x6^3
```

</details>

<a id="group-35"></a>
<details>
<summary><strong>#35: C3 x C3 x C3</strong> — $\lvert H\rvert=27$, $\lvert H/Z\rvert=9$, $D_3=3$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 27 |
| Projective order $\lvert H/Z\rvert$ | 9 |
| Invariant cubic dimension | 9 |
| Centralizer dimension | 6 |
| Family dimension $D_3$ | 3 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 9 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 120 |

**Sources (1):** `T1+T1+T1+T1+T1+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, E(3), 1, E(3)^2, E(3)^2, E(3)
]);

g3 := DiagonalMat([
    E(3), E(3)^2, 1, E(3), 1, 1
]);
```

**Invariant cubic monomial basis (9 terms)**

```text
x1^3, x1*x2*x5, x2^3, x2*x3*x4, x3^3, x3*x5*x6, x4^3, x5^3, x6^3
```

</details>

<a id="group-36"></a>
<details>
<summary><strong>#36: C24</strong> — $\lvert H\rvert=24$, $\lvert H/Z\rvert=8$, $D_3=3$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 24 |
| Projective order $\lvert H/Z\rvert$ | 8 |
| Invariant cubic dimension | 15 |
| Centralizer dimension | 12 |
| Family dimension $D_3$ | 3 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 4 |

**Sources (4):** `T4+T1+T1`, `T4+T2`, `T5+T1`, `T6`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    E(8)^3, E(4), -1, 1, 1, 1
]);

g3 := DiagonalMat([
    -E(4), -1, 1, 1, 1, 1
]);

g4 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (15 terms)**

```text
x1^2*x2, x2^2*x3, x3^2*x4, x3^2*x5, x3^2*x6, x4^3, x4^2*x5, x4^2*x6, x4*x5^2, x4*x5*x6, x4*x6^2,
x5^3, x5^2*x6, x5*x6^2, x6^3
```

</details>

<a id="group-37"></a>
<details>
<summary><strong>#37: C24</strong> — $\lvert H\rvert=24$, $\lvert H/Z\rvert=8$, $D_3=3$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 24 |
| Projective order $\lvert H/Z\rvert$ | 8 |
| Invariant cubic dimension | 13 |
| Centralizer dimension | 10 |
| Family dimension $D_3$ | 3 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 2 |

**Sources (2):** `T4+T2`, `Y31`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);

g3 := DiagonalMat([
    E(4), -1, 1, 1, 1, 1
]);

g4 := DiagonalMat([
    E(8), -E(4), -1, -1, 1, 1
]);
```

**Invariant cubic monomial basis (13 terms)**

```text
x1^2*x2, x2^2*x3, x2^2*x4, x3^2*x5, x3^2*x6, x3*x4*x5, x3*x4*x6, x4^2*x5, x4^2*x6, x5^3, x5^2*x6,
x5*x6^2, x6^3
```

</details>

<a id="group-38"></a>
<details>
<summary><strong>#38: C24</strong> — $\lvert H\rvert=24$, $\lvert H/Z\rvert=8$, $D_3=3$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 24 |
| Projective order $\lvert H/Z\rvert$ | 8 |
| Invariant cubic dimension | 11 |
| Centralizer dimension | 8 |
| Family dimension $D_3$ | 3 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 1 |

**Sources (1):** `Y21+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -E(8)^3, E(4), -E(4), -1, 1, 1
]);

g3 := DiagonalMat([
    -E(4), -1, -1, 1, 1, 1
]);

g4 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (11 terms)**

```text
x1^2*x2, x2^2*x4, x2*x3*x5, x2*x3*x6, x3^2*x4, x4^2*x5, x4^2*x6, x5^3, x5^2*x6, x5*x6^2, x6^3
```

</details>

<a id="group-39"></a>
<details>
<summary><strong>#39: C18</strong> — $\lvert H\rvert=18$, $\lvert H/Z\rvert=6$, $D_3=3$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 18 |
| Projective order $\lvert H/Z\rvert$ | 6 |
| Invariant cubic dimension | 9 |
| Centralizer dimension | 6 |
| Family dimension $D_3$ | 3 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 1 |

**Sources (1):** `NonSimple-1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    E(9)^2, E(9)^5, -E(9)^2-E(9)^5, -E(9)^2-E(9)^5, E(9)^2, E(9)^5
]);

g3 := DiagonalMat([
    1, 1, 1, -1, -1, -1
]);
```

**Invariant cubic monomial basis (9 terms)**

```text
x1^2*x2, x1*x3^2, x1*x4^2, x1*x5*x6, x2^2*x3, x2*x4*x6, x2*x5^2, x3*x4*x5, x3*x6^2
```

</details>

<a id="group-40"></a>
<details>
<summary><strong>#40: C12 x C6</strong> — $\lvert H\rvert=72$, $\lvert H/Z\rvert=24$, $D_3=2$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 72 |
| Projective order $\lvert H/Z\rvert$ | 24 |
| Invariant cubic dimension | 10 |
| Centralizer dimension | 8 |
| Family dimension $D_3$ | 2 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 6 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 1 |

**Sources (1):** `T3+T2+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, 1, 1, -1, 1, 1
]);

g3 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), 1
]);

g4 := DiagonalMat([
    -E(4), -1, 1, 1, 1, 1
]);

g5 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (10 terms)**

```text
x1^2*x2, x2^2*x3, x2^2*x5, x3^3, x3^2*x5, x3*x4^2, x3*x5^2, x4^2*x5, x5^3, x6^3
```

</details>

<a id="group-41"></a>
<details>
<summary><strong>#41: C6 x C3 x C3</strong> — $\lvert H\rvert=54$, $\lvert H/Z\rvert=18$, $D_3=2$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 54 |
| Projective order $\lvert H/Z\rvert$ | 18 |
| Invariant cubic dimension | 10 |
| Centralizer dimension | 8 |
| Family dimension $D_3$ | 2 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 9 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 16 |

**Sources (2):** `T2+T1+T1+T1+T1`, `T2+T2+T1+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, 1, 1, 1, 1, E(3)^2
]);

g3 := DiagonalMat([
    E(3), E(3), 1, 1, E(3)^2, E(3)^2
]);

g4 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (10 terms)**

```text
x1^2*x2, x2^3, x2*x3*x5, x2*x4*x5, x3^3, x3^2*x4, x3*x4^2, x4^3, x5^3, x6^3
```

</details>

<a id="group-42"></a>
<details>
<summary><strong>#42: C12 x C4</strong> — $\lvert H\rvert=48$, $\lvert H/Z\rvert=16$, $D_3=2$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 48 |
| Projective order $\lvert H/Z\rvert$ | 16 |
| Invariant cubic dimension | 10 |
| Centralizer dimension | 8 |
| Family dimension $D_3$ | 2 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 12 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 1 |

**Sources (1):** `T3+T3`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, 1, 1, -E(4), -1, 1
]);

g3 := DiagonalMat([
    1, 1, 1, -1, 1, 1
]);

g4 := DiagonalMat([
    -E(4), -1, 1, 1, 1, 1
]);

g5 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (10 terms)**

```text
x1^2*x2, x2^2*x3, x2^2*x6, x3^3, x3^2*x6, x3*x5^2, x3*x6^2, x4^2*x5, x5^2*x6, x6^3
```

</details>

<a id="group-43"></a>
<details>
<summary><strong>#43: C24 x C2</strong> — $\lvert H\rvert=48$, $\lvert H/Z\rvert=16$, $D_3=2$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 48 |
| Projective order $\lvert H/Z\rvert$ | 16 |
| Invariant cubic dimension | 10 |
| Centralizer dimension | 8 |
| Family dimension $D_3$ | 2 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 6 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 1 |

**Sources (1):** `T4+T2`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, 1, 1, 1, -1, 1
]);

g3 := DiagonalMat([
    E(8)^3, E(4), -1, 1, 1, 1
]);

g4 := DiagonalMat([
    -E(4), -1, 1, 1, 1, 1
]);

g5 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (10 terms)**

```text
x1^2*x2, x2^2*x3, x3^2*x4, x3^2*x6, x4^3, x4^2*x6, x4*x5^2, x4*x6^2, x5^2*x6, x6^3
```

</details>

<a id="group-44"></a>
<details>
<summary><strong>#44: C12 x C3</strong> — $\lvert H\rvert=36$, $\lvert H/Z\rvert=12$, $D_3=2$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 36 |
| Projective order $\lvert H/Z\rvert$ | 12 |
| Invariant cubic dimension | 10 |
| Centralizer dimension | 8 |
| Family dimension $D_3$ | 2 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 4 |

**Sources (2):** `T3+T1+T1+T1`, `T3+T2+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    E(3)^2, E(3)^2, E(3)^2, E(3), 1, 1
]);

g3 := DiagonalMat([
    -E(4), -1, 1, 1, 1, 1
]);

g4 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (10 terms)**

```text
x1^2*x2, x2^2*x3, x3^3, x3*x4*x5, x3*x4*x6, x4^3, x5^3, x5^2*x6, x5*x6^2, x6^3
```

</details>

<a id="group-45"></a>
<details>
<summary><strong>#45: C12 x C3</strong> — $\lvert H\rvert=36$, $\lvert H/Z\rvert=12$, $D_3=2$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 36 |
| Projective order $\lvert H/Z\rvert$ | 12 |
| Invariant cubic dimension | 8 |
| Centralizer dimension | 6 |
| Family dimension $D_3$ | 2 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 1 |

**Sources (1):** `T3+T2+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -E(4), -1, 1, -1, 1, 1
]);

g3 := DiagonalMat([
    E(3)^2, E(3)^2, E(3)^2, E(3), E(3), 1
]);

g4 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (8 terms)**

```text
x1^2*x2, x2^2*x3, x2*x4*x6, x3^3, x3*x5*x6, x4^2*x5, x5^3, x6^3
```

</details>

<a id="group-46"></a>
<details>
<summary><strong>#46: C12 x C2</strong> — $\lvert H\rvert=24$, $\lvert H/Z\rvert=8$, $D_3=2$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 24 |
| Projective order $\lvert H/Z\rvert$ | 8 |
| Invariant cubic dimension | 8 |
| Centralizer dimension | 6 |
| Family dimension $D_3$ | 2 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 12 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 2 |

**Sources (2):** `NonSimple-5`, `NonSimple-6`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -1, 1, 1, 1, 1, -1
]);

g3 := DiagonalMat([
    E(4), -1, 1, -1, 1, -E(4)
]);

g4 := DiagonalMat([
    1, 1, 1, -1, -1, -1
]);
```

**Invariant cubic monomial basis (8 terms)**

```text
x1^2*x2, x1*x5*x6, x2^2*x3, x2*x4*x5, x2*x6^2, x3^3, x3*x4^2, x3*x5^2
```

</details>

<a id="group-47"></a>
<details>
<summary><strong>#47: C12 x C6</strong> — $\lvert H\rvert=72$, $\lvert H/Z\rvert=24$, $D_3=1$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 72 |
| Projective order $\lvert H/Z\rvert$ | 24 |
| Invariant cubic dimension | 7 |
| Centralizer dimension | 6 |
| Family dimension $D_3$ | 1 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 6 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 1 |

**Sources (1):** `T3+T2+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    1, 1, 1, -1, 1, 1
]);

g3 := DiagonalMat([
    E(3)^2, E(3)^2, E(3)^2, E(3), E(3), 1
]);

g4 := DiagonalMat([
    -E(4), -1, 1, 1, 1, 1
]);

g5 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (7 terms)**

```text
x1^2*x2, x2^2*x3, x3^3, x3*x5*x6, x4^2*x5, x5^3, x6^3
```

</details>

<a id="group-48"></a>
<details>
<summary><strong>#48: C24 x C3</strong> — $\lvert H\rvert=72$, $\lvert H/Z\rvert=24$, $D_3=1$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 72 |
| Projective order $\lvert H/Z\rvert$ | 24 |
| Invariant cubic dimension | 9 |
| Centralizer dimension | 8 |
| Family dimension $D_3$ | 1 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 3 |

**Sources (2):** `T4+T1+T1`, `T5+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), 1
]);

g3 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);

g4 := DiagonalMat([
    -E(4), -1, 1, 1, 1, 1
]);

g5 := DiagonalMat([
    E(8)^3, E(4), -1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (9 terms)**

```text
x1^2*x2, x2^2*x3, x3^2*x4, x3^2*x5, x4^3, x4^2*x5, x4*x5^2, x5^3, x6^3
```

</details>

<a id="group-49"></a>
<details>
<summary><strong>#49: C24 x C3</strong> — $\lvert H\rvert=72$, $\lvert H/Z\rvert=24$, $D_3=1$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 72 |
| Projective order $\lvert H/Z\rvert$ | 24 |
| Invariant cubic dimension | 7 |
| Centralizer dimension | 6 |
| Family dimension $D_3$ | 1 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 1 |

**Sources (1):** `Y21+T1`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), 1
]);

g3 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);

g4 := DiagonalMat([
    -E(4), -1, -1, 1, 1, 1
]);

g5 := DiagonalMat([
    -E(8)^3, E(4), -E(4), -1, 1, 1
]);
```

**Invariant cubic monomial basis (7 terms)**

```text
x1^2*x2, x2^2*x4, x2*x3*x5, x3^2*x4, x4^2*x5, x5^3, x6^3
```

</details>

<a id="group-50"></a>
<details>
<summary><strong>#50: C48</strong> — $\lvert H\rvert=48$, $\lvert H/Z\rvert=16$, $D_3=1$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 48 |
| Projective order $\lvert H/Z\rvert$ | 16 |
| Invariant cubic dimension | 9 |
| Centralizer dimension | 8 |
| Family dimension $D_3$ | 1 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 2 |

**Sources (2):** `T5+T1`, `T6`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -E(16)^3, -E(8), -E(4), -1, 1, 1
]);

g3 := DiagonalMat([
    E(8)^3, E(4), -1, 1, 1, 1
]);

g4 := DiagonalMat([
    -E(4), -1, 1, 1, 1, 1
]);

g5 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);
```

**Invariant cubic monomial basis (9 terms)**

```text
x1^2*x2, x2^2*x3, x3^2*x4, x4^2*x5, x4^2*x6, x5^3, x5^2*x6, x5*x6^2, x6^3
```

</details>

<a id="group-51"></a>
<details>
<summary><strong>#51: C48</strong> — $\lvert H\rvert=48$, $\lvert H/Z\rvert=16$, $D_3=1$</summary>

| Field | Value |
|---|---:|
| Linear order $\lvert H\rvert$ | 48 |
| Projective order $\lvert H/Z\rvert$ | 16 |
| Invariant cubic dimension | 7 |
| Centralizer dimension | 6 |
| Family dimension $D_3$ | 1 |
| $\lvert H\cap\mathrm{SL}(6)\rvert$ | 3 |
| Dangerous element found | `false` |
| Equivalent occurrences merged | 1 |

**Sources (1):** `Y31`

**Diagonal generators**

```gap
g1 := DiagonalMat([
    E(3), E(3), E(3), E(3), E(3), E(3)
]);

g2 := DiagonalMat([
    -1, 1, 1, 1, 1, 1
]);

g3 := DiagonalMat([
    E(4), -1, 1, 1, 1, 1
]);

g4 := DiagonalMat([
    E(8), -E(4), -1, -1, 1, 1
]);

g5 := DiagonalMat([
    E(16), -E(8)^3, E(4), -E(4), -1, 1
]);
```

**Invariant cubic monomial basis (7 terms)**

```text
x1^2*x2, x2^2*x3, x3^2*x5, x3*x4*x6, x4^2*x5, x5^2*x6, x6^3
```

</details>

## Reproduction command

```gap
Read("LiftableAbelianCompletePipeline.g");
all := RunLiftableAbelianCompletePipeline(true);
final := all.restricted;
PrintLiftableAbelianFinalRestrictedResult(final, true, true);
```

The raw output is intentionally not duplicated verbatim at the end of this document: every field, generator, source label, and invariant monomial basis is already represented in the detailed records above.
