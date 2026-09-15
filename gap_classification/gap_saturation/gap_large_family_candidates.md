# Large-family candidates and saturation input

## Purpose

This note describes the 76 explicit rank-at-least-15 families in
`gap_large_koike_families.g` and the other four classes entering the common
saturation input. References are collected in
[`../../REFERENCES.md`](../../REFERENCES.md). The order here follows the
lattice case list; use source keys, not these row positions, to compare it
with the 156-family catalogue.

The large-family list is obtained from lattice-theoretic constraints. Its
records are separated by connected symplectic family and give the possible
non-symplectic index, generic automorphism group, and family dimension.
The explicit projective models have two sources:

- 40 connected symplectic families read from Koike's classification and its
  corrigendum;
- 36 proper subfamilies constructed using representation calculations.

The 40 connected-family records store the full stabilizer of a general
member, not only its symplectic kernel, and are therefore already saturated.
Five proper families are covered by the rank-19 or order-7 classifications.
The index-4, index-6, and index-12 extensions of `3^{1+4}:2` and the index-2
QD16 family have separate theoretical arguments. The current smoothness run
nevertheless verifies all 76 large records. Fifteen proper index-2 records
require a conjugate-component comparison for the lattice-to-family passage.
Twelve are checked by exact self-conjugacy certificates; the two `L2(7)`
points and the index-2 `F21` family are covered by the explicit order-7
models. Finally, 27 records enter the saturation search as sources.

## Saturation of the protected large records

The 49 protected large records have the following sources.

- The 40 connected-family records are the generic full groups determined by
  the generic stabilizer and generic index of the corresponding connected
  symplectic family. This uses Laza–Zheng, Koike and the corrigendum, and the
  non-symplectic-index and lattice-classification papers.
- The two `F21` proper rows and the two `L2(7)` proper rows are full groups by
  the order-7 classification. The `M9` proper row is full by the rank-19
  classification in the first non-symplectic-index paper.
- The index-2 `QD16` row contains Yang–Yu–Zhu's cubic `X'_12`. They compute
  its full group as `(C8 x C2):C2` of order 32 and its symplectic group as
  `QD16`. The displayed order-32 group acts on the whole row, while
  stabilizer order can only jump on a proper closed locus. This exact member
  therefore shows that the general stabilizer also has order 32. The ambient
  QD16 normal form and its generic symplectic stabilizer are given by
  Laza–Zheng.
- The three proper `3^{1+4}:2` rows follow from the
  [unique maximal additive splitting](../../REFERENCES.md#additive-splittings)
  and Yang–Yu–Zhu, Lemma 3.12, on linear stabilizers of smooth plane
  cubics. In the four rows of indices 2, 4, 6 and 12, the two plane-cubic
  blocks are respectively `(general, general)`, `(j=1728, general)`,
  `(Fermat, general)`, and `(Fermat, j=1728)`. Their strict stabilizer orders
  are 54, 108 and 162. The resulting projective orders are
  `54^2/3=972`, `108*54/3=1944`, `162*54/3=2916`, and
  `162*108/3=5832`, exactly the stored full-group orders.

The common saturation calculation tests the other 27 large records and
removes none of them. The self-conjugacy calculation was run later. This is
logically harmless: complex conjugation preserves group containment and
family dimension, and no large record was deleted. The later calculation
only identifies the two possible type-IV components as one equation family.

## Counts

| rank of `S` | table rows | symplectic families | proper families |
|---:|---:|---:|---:|
| 15 | 4 | 1 | 3 |
| 16 | 21 | 7 | 14 |
| 17 | 7 | 3 | 4 |
| 18 | 24 | 12 | 12 |
| 19 | 12 | 9 | 3 |
| 20 | 8 | 8 | 0 |
| **total** | **76** | **40** | **36** |

Each item below has the form `index / dimension, full projective group
[GAP ID]`. The word `symplectic` marks the connected symplectic-family row.

## Ordered large-family records

### Rank 15

| connected symplectic family | explicit rows |
|---|---|
| `(D8, 1)` | symplectic: `1 / 5`, `D8` `[8,3]`; `2 / 4`, `D8 x C2` `[16,11]`; `2 / 3`, `(C4 x C2):C2` `[16,13]`; `2 / 2`, `D16` `[16,7]` |

### Rank 16

| connected symplectic family | explicit rows |
|---|---|
| `(D10, 1)` | symplectic: `1 / 4`, `D10` `[10,1]`; `2 / 2`, `D20` `[20,4]`; `3 / 2`, `D10 x C3` `[30,2]` |
| `(A4, 1)` | symplectic: `1 / 4`, `A4` `[12,3]`; `2 / 3`, `A4 x C2` `[24,13]`; `3 / 2`, `A4 x C3` `[36,11]` |
| `(A4, 2)` | symplectic: `2 / 4`, `S4` `[24,12]`; `6 / 2`, `S4 x C3` `[72,42]` |
| `(D12, 1)` | symplectic: `1 / 4`, `D12` `[12,4]`; `2 / 2`, `D12 x C2` `[24,14]`; `2 / 2`, `(C6 x C2):C2` `[24,8]`; `3 / 2`, `D12 x C3` `[36,12]`; `6 / 1`, `((C6 x C2):C2) x C3` `[72,30]` |
| `(D12, 2)` | symplectic: `2 / 4`, `D12 x C2` `[24,14]`; `6 / 2`, `S3 x C6 x C2` `[72,48]` |
| `(A3,3, 1)` | symplectic: `1 / 4`, `A3,3` `[18,4]`; `2 / 2`, `A3,3 x C2` `[36,13]`; `3 / 1`, `C3^2:C6` `[54,5]` |
| `(A3,3, 2)` | symplectic: `2 / 4`, `S3,3` `[36,10]`; two inequivalent rows `6 / 2`, `S3,3 x C3` `[108,38]` |

### Rank 17

| connected symplectic family | explicit rows |
|---|---|
| `(Q8, 1)` | symplectic: `1 / 3`, `Q8` `[8,4]`; `2 / 2`, `(C4 x C2):C2` `[16,13]`; `3 / 1`, `SL(2,3)` `[24,3]`; `4 / 1`, `C4^2:C2` `[32,11]` |
| `(S4, 1)` | symplectic: `1 / 3`, `S4` `[24,12]`; `2 / 2`, `S4 x C2` `[48,48]` |
| `(S4, 2)` | symplectic: `2 / 3`, `S4 x C2` `[48,48]` |

### Rank 18

| connected symplectic family | explicit rows |
|---|---|
| `(QD16, 1)` | symplectic: `1 / 2`, `QD16` `[16,8]`; known saturated: `2 / 1`, `(C8 x C2):C2` `[32,42]` |
| `(Hol(5), 1)` | symplectic: `1 / 2`, `Hol(5)` `[20,3]` |
| `(F21, 1)` | symplectic: `1 / 2`, `F21` `[21,1]`; known saturated: `2 / 1`, `C7:C6` `[42,1]`; known saturated: `6 / 0`, `(C7:C6) x C3` `[126,7]` |
| `(S3,3, 2)`, Koike component | symplectic: `2 / 2`, `S3,3 x C2` `[72,46]`; `6 / 1`, `S3,3 x C6` `[216,170]` |
| `(S3,3, 2)`, corrigendum component | symplectic: `2 / 2`, `N72` `[72,40]`; `6 / 1`, `N72 x C3` `[216,157]` |
| `(C3^2.C4, 1)` | symplectic: `1 / 2`, `C3^2.C4` `[36,9]` |
| `(C3^2.C4, 2)` | symplectic: `2 / 2`, `N72` `[72,40]` |
| `(A5, 1)` | symplectic: `1 / 2`, `A5` `[60,5]`; `3 / 1`, `A5 x C3 = GL(2,4)` `[180,19]` |
| `(A5, 2)` | symplectic: `2 / 2`, `S5` `[120,34]`; `6 / 1`, `S5 x C3` `[360,119]` |
| `(A4,3, 1)` | symplectic: `1 / 2`, `A4,3` `[72,43]`; `2 / 1`, `A4,3 x C2` `[144,189]` |
| `(A4,3, 2)` | symplectic: `2 / 2`, `S4,3` `[144,183]`; `6 / 1`, `S4,3 x C3` `[432,745]` |
| `(3^(1+4):C2, 2)` | symplectic: `2 / 2`, `3^(1+4):C2^2` `[972,812]`; known saturated: `4 / 1`, `3^(1+4):(C4 x C2)` `[1944,3493]`; known saturated: `6 / 1`, order `2916`; known saturated: `12 / 0`, order `5832` |

### Rank 19

| connected symplectic family | explicit rows |
|---|---|
| `(T48, 1)` | symplectic: `1 / 1`, `T48` `[48,29]` |
| `(N72, 2)` | symplectic: `2 / 1`, `N72 x C2` `[144,186]` |
| `(M9, 1)` | symplectic: `1 / 1`, `M9` `[72,41]`; known saturated: `3 / 0`, `M9:C3` `[216,153]` |
| `(S5, 1)` | symplectic: `1 / 1`, `S5` `[120,34]` |
| `(S5, 2)` | symplectic: `2 / 1`, `S5 x C2` `[240,189]` |
| `(L2(7), 1)` | symplectic: `1 / 1`, `L2(7)` `[168,42]`; two known saturated rows `2 / 0`, `L2(7):C2` `[336,208]` |
| `(A6, 1)` | symplectic: `1 / 1`, `A6` `[360,118]` |
| `(A6, 2)` | symplectic: `2 / 1`, `S6` `[720,763]` |
| `(3^(1+4):C2.C2, 2)` | symplectic: `2 / 1`, `3^(1+4):D8`, order `1944` |

### Rank 20

All eight rows are zero-dimensional symplectic families.

| connected symplectic family | explicit row |
|---|---|
| `(A3,5, 6)` | `6 / 0`, `S3,5 x C3`, order `2160` |
| `(L2(11), 3)` | `3 / 0`, `L2(11) x C3` `[1980,57]` |
| the two `(M10, 1)` families | two inequivalent rows `1 / 0`, `M10` `[720,765]` |
| `(3^(1+4):C2.C2^2, 4)` | `4 / 0`, `3^(1+4):(C4^2:C2)`, order `7776` |
| `(A7, 1)` | `1 / 0`, `A7`, order `2520` |
| `(A7, 2)` | `2 / 0`, `S7`, order `5040` |
| `(C3^4:A6, 6)` | `6 / 0`, `C3^5:S6`, order `174960` |

## Component audit

The determinant-one linear kernels, after quotienting by `mu_3`, give the
projective symplectic groups. These quotients resolve the potentially
ambiguous group types:

- the two `[108,38]` families have projective symplectic group `[18,4] = A3,3` and
  belong to rank 16;
- the two generic `S3,3` components have full groups `[72,46]` and
  `[72,40]`, with respective index-6 subfamilies `[216,170]` and
  `[216,157]`;
- the generic-index-2 `C3^2.C4` component has projective symplectic group `[36,9]`,
  full group `[72,40]`, and dimension 2.

## Explicit smoothness verification

`../gap_smoothness/gap_large_abelian_smoothness.g` is the unified exact
verification entry point. It reconstructs the invariant cubic spaces and
centralizers for all 76 large-family records, audits the stored dimensions,
and records an explicit smooth member for each family. The same run also
treats the liftable and non-liftable abelian candidate lists. Its persistent
certificates are written to
`../gap_smoothness/gap_large_abelian_smoothness.out`.

Complex self-conjugacy is a separate calculation in
`../gap_self_conjugacy` and is not part of the smoothness script.

## Other four candidate classes

| candidate class | count | source and status |
|---|---:|---|
| liftable abelian | 53 | `../gap_liftable_abelian/gap_liftable_abelian_data.g`; 51 enumerated records and the two explicit Yang--Yu--Zhu examples; smoothness follows from the liftable-abelian theory |
| non-liftable abelian | 2 | `../gap_nonliftable_abelian/gap_nonliftable_abelian_data.g`; the two exhaustive cases retained by the theoretical classification |
| small non-abelian, smooth | 46 | `gap_small_nonabelian_saturation_data.g`; exact smooth-member certificates recorded |
| small non-abelian, unresolved | 7 | the same data file; retained provisionally and excluded from confirmed-smooth containment computations |
| **subtotal** | **108** | |

### Rank-below-15 symplectic families

These eight records are marked directly and require no saturation test.

| symplectic family | generic full PGL | rank of `S` | dimension |
|---|---|---:|---:|
| trivial group | `[1,1]` | 0 | 20 |
| `C2` | `[2,1]` | 8 | 12 |
| `C2^2` | `[4,2]` | 12 | 8 |
| `C3`, first component | `[3,1]` | 12 | 8 |
| `C3`, second component | `[6,1]` | 12 | 8 |
| `C4` | `[4,1]` | 14 | 6 |
| `S3`, first component | `[6,1]` | 14 | 6 |
| `S3`, second component | `[12,4]` | 14 | 6 |

### Special saturated families

| family | GL ID | PGL ID | saturation status |
|---|---|---|---|
| `C48` | `[144,30]` | `[48,2]` | no saturation test |
| `C32` | `[96,2]` | `[32,1]` | no saturation test |
| `S3 x C24` | `[432,464]` | `[144,69]` | no saturation test |

Together, the five candidate classes contain 184 records. The seven unresolved
small non-abelian records are excluded from the confirmed-smooth run. Of the
remaining 177 records, 60 are known saturated. The other 117 records enter
the saturation search.
