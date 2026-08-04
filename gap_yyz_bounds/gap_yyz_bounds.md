# GAP calculation of YYZ bounds

This directory contains a cleaned GAP script and the recorded output of the computation used for the group-theoretic YYZ bounds in the paper:

- Jie Fu, Shihao Wang, and Zhiwei Zheng, *Non-Symplectic Indices of Automorphism Groups of Smooth Cubic Fourfolds*, arXiv:2606.11754v1 [math.AG], 10 June 2026.

The calculation is discussed in Section 5.1 of the paper. Proposition 5.1 states that, after fixing the symplectic automorphism group, the non-symplectic index must divide one of the YYZ bounds in Table 3.

The two classification results used as input are:

- Radu Laza and Zhiwei Zheng, *Automorphisms and periods of cubic fourfolds*, Mathematische Zeitschrift 300 (2022), 1455-1507. This gives the 34 possible symplectic automorphism groups.
- Song Yang, Xun Yu, and Zigang Zhu, *Automorphism groups of cubic fivefolds and fourfolds*, Journal of the London Mathematical Society 110 (2024), Paper e12997. This gives the 15 maximal groups that contain every finite group acting faithfully on a smooth cubic fourfold.

The paper cites GAP 4.15.1. The script also uses the Small Groups Library.

## Purpose of the calculation

Let X be a smooth cubic fourfold. Write

```text
G = Aut^s(X),    G_tilde = Aut(X),    m = [G_tilde : G].
```

The symplectic group G is normal in the full automorphism group G_tilde, and the quotient G_tilde/G is cyclic of order m. Proposition 4.1 of the paper restricts m to the form

```text
m = 2^a  or  m = 3 * 2^a,    a >= 0.
```

For each of the 34 possible groups G, the script performs the following necessary group-theoretic test:

1. Enumerate subgroup isomorphism classes inside each of the 15 Yang-Yu-Zhu maximal groups.
2. For every candidate group H, test whether H contains a normal subgroup isomorphic to G.
3. Test whether H/G is cyclic.
4. Keep the index [H:G] only when it has the allowed form above.

This test gives necessary bounds, not a realizability theorem. A candidate index can survive the GAP calculation without being realized by a smooth cubic fourfold. The paper combines these bounds with lattice theory, GIT calculations, moduli arguments, and explicit geometry.

## Files

- `gap_yyz_bounds.g`: executable GAP code. It contains no pasted terminal output.
- `gap_yyz_bounds.md`: this explanation and the output recorded in the original source file.

The cleaned script caches subgroup data and computes normal subgroups lazily. This avoids repeating the same expensive `NormalSubgroups` computation for every symplectic group.

## Running the script

From a shell with GAP available:

```text
gap -q gap_yyz_bounds.g
```

To save the output:

```text
gap -q gap_yyz_bounds.g > gap_yyz_bounds.out
```

At the beginning of the script, the following flags control the printed output:

```text
PRINT_INDEX_SUMMARY := true;
PRINT_CANDIDATE_GROUPS := true;
RUN_AUXILIARY_PRODUCT_CALCULATION := false;
```

The auxiliary data section also contains:

```text
AuxiliaryBaseGroups := MaximalCubicThreefoldGroups;
```

The auxiliary product calculation is disabled by default because the original file contained its output but did not include the exact command that produced it. Both the cubic-threefold list and the cubic-surface list from the original file are retained. Change `AuxiliaryBaseGroups` to select the list before enabling the calculation.

## Labels for the 34 symplectic groups

The label `G_i` is the position of the group in `SymplecticGroups`. It follows the order used in Table 3 of the paper.

| Label | Group | rank(S) | Order | GAP representation |
|---:|---|---:|---:|---|
| G_1 | `3^4 : A6` | 20 | 29160 | `matrix quotient (G1)` |
| G_2 | `A7` | 20 | 2520 | `AlternatingGroup(7)` |
| G_3 | `3^(1+4) : 2.2^2` | 20 | 1944 | `[1944,3559]` |
| G_4 | `M10` | 20 | 720 | `[720,765]` |
| G_5 | `L2(11)` | 20 | 660 | `[660,13]` |
| G_6 | `A3,5` | 20 | 360 | `[360,120]` |
| G_7 | `3^(1+4) : 2.2` | 19 | 972 | `[972,776]` |
| G_8 | `A6` | 19 | 360 | `[360,118]` |
| G_9 | `L2(7)` | 19 | 168 | `[168,42]` |
| G_10 | `S5` | 19 | 120 | `[120,34]` |
| G_11 | `M9` | 19 | 72 | `[72,41]` |
| G_12 | `N72` | 19 | 72 | `[72,40]` |
| G_13 | `T48` | 19 | 48 | `[48,29]` |
| G_14 | `3^(1+4) : 2` | 18 | 486 | `[486,249]` |
| G_15 | `A4,3` | 18 | 72 | `[72,43]` |
| G_16 | `A5` | 18 | 60 | `[60,5]` |
| G_17 | `3^2.4` | 18 | 36 | `[36,9]` |
| G_18 | `S3,3` | 18 | 36 | `[36,10]` |
| G_19 | `F21` | 18 | 21 | `[21,1]` |
| G_20 | `Hol(5)` | 18 | 20 | `[20,3]` |
| G_21 | `QD16` | 18 | 16 | `[16,8]` |
| G_22 | `S4` | 17 | 24 | `[24,12]` |
| G_23 | `Q8` | 17 | 8 | `[8,4]` |
| G_24 | `A3,3` | 16 | 18 | `[18,4]` |
| G_25 | `D12` | 16 | 12 | `[12,4]` |
| G_26 | `A4` | 16 | 12 | `[12,3]` |
| G_27 | `D10` | 16 | 10 | `[10,1]` |
| G_28 | `D8` | 15 | 8 | `[8,3]` |
| G_29 | `C4` | 14 | 4 | `[4,1]` |
| G_30 | `S3` | 14 | 6 | `[6,1]` |
| G_31 | `C2^2` | 12 | 4 | `[4,2]` |
| G_32 | `C3` | 12 | 3 | `[3,1]` |
| G_33 | `C2` | 8 | 2 | `[2,1]` |
| G_34 | `1` | 0 | 1 | `[1,1]` |

## Summary of candidate indices and YYZ bounds

The candidate-index column lists every index that survives the GAP test. The YYZ-bound column keeps only the divisibility-maximal values. Thus every candidate index divides at least one value in the YYZ-bound column.

| Label | Group | Candidate indices | YYZ bound(s) |
|---:|---|---|---|
| G_1 | `3^4 : A6` | 1, 2, 3, 6 | 6 |
| G_2 | `A7` | 1, 2 | 2 |
| G_3 | `3^(1+4) : 2.2^2` | 1, 2, 4 | 4 |
| G_4 | `M10` | 1 | 1 |
| G_5 | `L2(11)` | 1, 3 | 3 |
| G_6 | `A3,5` | 1, 2, 3, 6 | 6 |
| G_7 | `3^(1+4) : 2.2` | 1, 2, 3, 6 | 6 |
| G_8 | `A6` | 1, 2 | 2 |
| G_9 | `L2(7)` | 1, 2 | 2 |
| G_10 | `S5` | 1, 2, 3, 6 | 6 |
| G_11 | `M9` | 1, 3 | 3 |
| G_12 | `N72` | 1, 2, 3, 6 | 6 |
| G_13 | `T48` | 1 | 1 |
| G_14 | `3^(1+4) : 2` | 1, 2, 3, 4, 6, 12 | 12 |
| G_15 | `A4,3` | 1, 2, 3, 6 | 6 |
| G_16 | `A5` | 1, 2, 3, 6 | 6 |
| G_17 | `3^2.4` | 1, 2, 3, 6 | 6 |
| G_18 | `S3,3` | 1, 2, 3, 6 | 6 |
| G_19 | `F21` | 1, 2, 3, 6 | 6 |
| G_20 | `Hol(5)` | 1, 2, 3, 6 | 6 |
| G_21 | `QD16` | 1, 2 | 2 |
| G_22 | `S4` | 1, 2, 3, 6 | 6 |
| G_23 | `Q8` | 1, 2, 3, 4 | 3, 4 |
| G_24 | `A3,3` | 1, 2, 3, 4, 6, 12 | 12 |
| G_25 | `D12` | 1, 2, 3, 4, 6, 12 | 12 |
| G_26 | `A4` | 1, 2, 3, 6 | 6 |
| G_27 | `D10` | 1, 2, 3, 4, 6, 12 | 12 |
| G_28 | `D8` | 1, 2, 3, 4, 6 | 4, 6 |
| G_29 | `C4` | 1, 2, 3, 4, 6, 8, 12 | 8, 12 |
| G_30 | `S3` | 1, 2, 3, 4, 6, 8, 12, 24 | 24 |
| G_31 | `C2^2` | 1, 2, 3, 4, 6, 12 | 12 |
| G_32 | `C3` | 1, 2, 3, 4, 6, 8, 12, 16, 24 | 16, 24 |
| G_33 | `C2` | 1, 2, 3, 4, 6, 8, 12, 16, 24 | 16, 24 |
| G_34 | `1` | 1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 48 | 32, 48 |

## Candidate full groups

The following is the detailed output corresponding to `DisplayList(TotalListOfFour, 2)` in the original file. For groups of order at most 2000, except order 1024, the output uses the SmallGroup identifier `[order,id]`. Otherwise it uses `StructureDescription`.

A warning from the original code remains relevant: two non-isomorphic groups can have the same `StructureDescription`, so deduplication by description can hide multiplicity.

### G_1 = 3^4 : A6

- Index 1: `(C3 x C3 x C3 x C3) : A6`
- Index 2: `(C3 x C3 x C3 x C3) : S6`
- Index 3: `((C3 x C3 x C3 x C3) : A6) : C3`
- Index 6: `((C3 x C3 x C3 x C3) : A6) : C6`

### G_2 = A7

- Index 1: `A7`
- Index 2: `S7`

### G_3 = 3^(1+4) : 2.2^2

- Index 1: `[1944,3559]`
- Index 2: `((C3 x ((C3 x C3) : C3)) : C3) : ((C4 x C2) : C2)`
- Index 4: `((C3 x ((C3 x C3) : C3)) : C3) : ((C4 x C4) : C2)`

### G_4 = M10

- Index 1: `[720,765]`

### G_5 = L2(11)

- Index 1: `[660,13]`
- Index 3: `[1980,57]`

### G_6 = A3,5

- Index 1: `[360,120]`
- Index 2: `[720,767]`
- Index 3: `[1080,489]`
- Index 6: `C3 x S3 x S5`

### G_7 = 3^(1+4) : 2.2

- Index 1: `[972,776]`
- Index 2:
  - `[1944,3536]`
  - `[1944,3559]`
  - `[1944,3498]`
- Index 3: `((C3 x ((C3 x C3 x C3) : C3)) : C3) : C4`
- Index 6: `((C3 x ((C3 x C3 x C3) : C3)) : C3) : D8`

### G_8 = A6

- Index 1: `[360,118]`
- Index 2:
  - `[720,763]`
  - `[720,765]`

### G_9 = L2(7)

- Index 1: `[168,42]`
- Index 2: `[336,208]`

### G_10 = S5

- Index 1: `[120,34]`
- Index 2: `[240,189]`
- Index 3: `[360,119]`
- Index 6: `[720,769]`

### G_11 = M9

- Index 1: `[72,41]`
- Index 3: `[216,153]`

### G_12 = N72

- Index 1: `[72,40]`
- Index 2: `[144,186]`
- Index 3: `[216,157]`
- Index 6: `[432,754]`

### G_13 = T48

- Index 1: `[48,29]`

### G_14 = 3^(1+4) : 2

- Index 1: `[486,249]`
- Index 2:
  - `[972,812]`
  - `[972,776]`
  - `[972,811]`
  - `[972,777]`
- Index 3:
  - `[1458,1179]`
  - `[1458,1229]`
  - `[1458,1720]`
- Index 4:
  - `[1944,3493]`
  - `[1944,3478]`
- Index 6:
  - `((C3 x ((C3 x C3 x C3) : C3)) : C3) : (C2 x C2)`
  - `(((C3 x ((C3 x C3) : C3)) : C3) : C3) : (C2 x C2)`
  - `((C3 x ((C3 x C3 x C3) : C3)) : C3) : C4`
- Index 12: `((C3 x ((C3 x C3 x C3) : C3)) : C3) : (C4 x C2)`

### G_15 = A4,3

- Index 1: `[72,43]`
- Index 2:
  - `[144,189]`
  - `[144,183]`
- Index 3:
  - `[216,92]`
  - `[216,164]`
- Index 6:
  - `[432,535]`
  - `[432,745]`

### G_16 = A5

- Index 1: `[60,5]`
- Index 2:
  - `[120,34]`
  - `[120,35]`
- Index 3: `[180,19]`
- Index 6:
  - `[360,119]`
  - `[360,122]`

### G_17 = 3^2.4

- Index 1: `[36,9]`
- Index 2:
  - `[72,40]`
  - `[72,45]`
  - `[72,41]`
- Index 3: `[108,36]`
- Index 6:
  - `[216,157]`
  - `[216,168]`

### G_18 = S3,3

- Index 1: `[36,10]`
- Index 2:
  - `[72,46]`
  - `[72,40]`
- Index 3: `[108,38]`
- Index 6:
  - `[216,157]`
  - `[216,170]`

### G_19 = F21

- Index 1: `[21,1]`
- Index 2: `[42,1]`
- Index 3: `[63,3]`
- Index 6: `[126,7]`

### G_20 = Hol(5)

- Index 1: `[20,3]`
- Index 2: `[40,12]`
- Index 3: `[60,6]`
- Index 6: `[120,40]`

### G_21 = QD16

- Index 1: `[16,8]`
- Index 2: `[32,42]`

### G_22 = S4

- Index 1: `[24,12]`
- Index 2: `[48,48]`
- Index 3: `[72,42]`
- Index 6: `[144,188]`

### G_23 = Q8

- Index 1: `[8,4]`
- Index 2:
  - `[16,13]`
  - `[16,8]`
  - `[16,9]`
- Index 3: `[24,3]`
- Index 4: `[32,11]`

### G_24 = A3,3

- Index 1: `[18,4]`
- Index 2:
  - `[36,10]`
  - `[36,13]`
  - `[36,9]`
- Index 3:
  - `[54,13]`
  - `[54,5]`
- Index 4: `[72,45]`
- Index 6:
  - `[108,38]`
  - `[108,36]`
  - `[108,43]`
  - `[108,25]`
- Index 12: `[216,168]`

### G_25 = D12

- Index 1: `[12,4]`
- Index 2:
  - `[24,14]`
  - `[24,8]`
  - `[24,5]`
  - `[24,6]`
- Index 3: `[36,12]`
- Index 4: `[48,4]`
- Index 6:
  - `[72,30]`
  - `[72,48]`
  - `[72,28]`
  - `[72,27]`
- Index 12: `[144,69]`

### G_26 = A4

- Index 1: `[12,3]`
- Index 2:
  - `[24,12]`
  - `[24,13]`
- Index 3: `[36,11]`
- Index 6:
  - `[72,47]`
  - `[72,42]`

### G_27 = D10

- Index 1: `[10,1]`
- Index 2:
  - `[20,3]`
  - `[20,4]`
- Index 3: `[30,2]`
- Index 4: `[40,12]`
- Index 6:
  - `[60,6]`
  - `[60,10]`
- Index 12: `[120,40]`

### G_28 = D8

- Index 1: `[8,3]`
- Index 2:
  - `[16,11]`
  - `[16,13]`
  - `[16,8]`
  - `[16,7]`
- Index 3: `[24,10]`
- Index 4: `[32,11]`
- Index 6: `[48,45]`

### G_29 = C4

- Index 1: `[4,1]`
- Index 2:
  - `[8,3]`
  - `[8,2]`
  - `[8,1]`
  - `[8,4]`
- Index 3: `[12,2]`
- Index 4:
  - `[16,5]`
  - `[16,1]`
  - `[16,2]`
  - `[16,6]`
- Index 6:
  - `[24,10]`
  - `[24,9]`
  - `[24,2]`
- Index 8: `[32,1]`
- Index 12:
  - `[48,23]`
  - `[48,2]`
  - `[48,20]`

### G_30 = S3

- Index 1: `[6,1]`
- Index 2: `[12,4]`
- Index 3: `[18,3]`
- Index 4: `[24,5]`
- Index 6: `[36,12]`
- Index 8: `[48,4]`
- Index 12: `[72,27]`
- Index 24: `[144,69]`

### G_31 = C2^2

- Index 1: `[4,2]`
- Index 2:
  - `[8,5]`
  - `[8,3]`
  - `[8,2]`
- Index 3:
  - `[12,5]`
  - `[12,3]`
- Index 4:
  - `[16,5]`
  - `[16,6]`
- Index 6:
  - `[24,15]`
  - `[24,13]`
  - `[24,10]`
  - `[24,9]`
- Index 12: `[48,23]`

### G_32 = C3

- Index 1: `[3,1]`
- Index 2:
  - `[6,1]`
  - `[6,2]`
- Index 3:
  - `[9,2]`
  - `[9,1]`
- Index 4:
  - `[12,1]`
  - `[12,2]`
- Index 6:
  - `[18,3]`
  - `[18,5]`
  - `[18,2]`
- Index 8:
  - `[24,2]`
  - `[24,1]`
- Index 12:
  - `[36,6]`
  - `[36,8]`
  - `[36,2]`
- Index 16: `[48,2]`
- Index 24:
  - `[72,14]`
  - `[72,12]`

### G_33 = C2

- Index 1: `[2,1]`
- Index 2:
  - `[4,2]`
  - `[4,1]`
- Index 3: `[6,2]`
- Index 4:
  - `[8,2]`
  - `[8,1]`
- Index 6:
  - `[12,5]`
  - `[12,2]`
- Index 8:
  - `[16,5]`
  - `[16,1]`
- Index 12:
  - `[24,9]`
  - `[24,2]`
- Index 16: `[32,1]`
- Index 24:
  - `[48,23]`
  - `[48,2]`

### G_34 = 1

- Index 1: `[1,1]`
- Index 2: `[2,1]`
- Index 3: `[3,1]`
- Index 4: `[4,1]`
- Index 6: `[6,2]`
- Index 8: `[8,1]`
- Index 12: `[12,2]`
- Index 16: `[16,1]`
- Index 24: `[24,2]`
- Index 32: `[32,1]`
- Index 48: `[48,2]`

## Supplementary output preserved from the original file

The final block of the original `.g` file was not part of the main call shown there. It appears to come from the auxiliary functions `CyclicQuotientPairing`, `ListOfSubgroupProducted`, and `DisplayTriples`, and concerns cyclic quotients whose order is divisible by 3. The exact invocation was absent, so this block should be treated as supplementary recorded output rather than part of Proposition 5.1.

Repeated identical pairs in the pasted output have been collapsed below.

### 1

- `(C3, 3)`
- `(C6, 6)`
- `(C12, 12)`
- `(C24, 24)`
- `(C48, 48)`

### C3

- `(C3 x C3, 3)`
- `(C3 x S3, 6)`
- `(C6 x C3, 6)`
- `(C12 x C3, 12)`
- `(C3 x (C3 : C4), 12)`
- `(C24 x C3, 24)`

### S3

- `(C3 x S3, 3)`
- `(C6 x S3, 6)`
- `(C12 x S3, 12)`

### A5

- `(GL(2,4), 3)`
- `(C3 x S5, 6)`

### S5

- `(C3 x S5, 3)`

### PSL(2,11)

- `(C3 x PSL(2,11), 3)`

### (S3 x S3) : C2

- `(C3 x ((S3 x S3) : C2), 3)`

### (C3 x C3) : C4

- `(C3 x ((C3 x C3) : C4), 3)`
- `(C3 x ((S3 x S3) : C2), 6)`
- `(C6 x ((C3 x C3) : C4), 6)`

### S3 x S3

- `(C3 x S3 x S3, 3)`
- `(C3 x ((S3 x S3) : C2), 6)`

### C5 : C4

- `(C3 x (C5 : C4), 3)`

### S4

- `(C3 x S4, 3)`

### (C3 x C3) : C2

- `(C3 x ((C3 x C3) : C2), 3)`
- `(C3 x ((C3 x C3) : C4), 6)`
- `(C3 x S3 x S3, 6)`
- `(C6 x ((C3 x C3) : C2), 6)`
- `(C6 x ((C3 x C3) : C4), 12)`

### D12

- `(C6 x S3, 3)`
- `(C12 x S3, 6)`
- `(C3 x ((C6 x C2) : C2), 6)`

### A4

- `(C3 x A4, 3)`
- `(C3 x S4, 6)`

### D10

- `(C3 x D10, 3)`
- `(C3 x (C5 : C4), 6)`

### D8

- `(C3 x D8, 3)`

### C4

- `(C12, 3)`
- `(C12 x C2, 6)`
- `(C24, 6)`
- `(C3 x D8, 6)`
- `(C48, 12)`

### C2 x C2

- `(C6 x C2, 3)`
- `(C12 x C2, 6)`
- `(C3 x D8, 6)`

### C2

- `(C6, 3)`
- `(C12, 6)`
- `(C6 x C2, 6)`
- `(C12 x C2, 12)`
- `(C24, 12)`
- `(C48, 24)`

## Interpretation and limitations

- The calculation is purely group-theoretic. It does not test whether a candidate action preserves a smooth cubic equation.
- It does not determine the embedding of a group into `PGL(6,C)`, the character on the defining cubic, or the action on the cubic lattice.
- Different candidate full groups can have the same index.
- The compact YYZ bounds are divisibility bounds. They should not be read as a list of realized indices.
- The more precise conclusions in the paper require the additional arguments developed in Sections 3-8.

## Changes from the original mixed code/output file

- Removed all pasted GAP prompts and terminal output from the `.g` file.
- Moved the recorded results to this Markdown file.
- Replaced the repeated index test by one named predicate, `IsAllowedYYZIndex`.
- Cached subgroup representatives and lazily cached normal subgroups.
- Separated the main YYZ-bound calculation from auxiliary product calculations.
- Renamed the main lists and functions to make their roles explicit.
- Changed the phrase “all possible indices” in the presentation to “candidate indices” where appropriate, because the GAP test gives necessary conditions only.
