# GAP calculation of the YYZ group-theoretic bounds

This calculation searches the 15 maximal groups of Yang–Yu–Zhu for candidate full groups containing one of the 34 Laza–Zheng symplectic groups as a normal subgroup with cyclic quotient.

The admissible index is required to have the form

\[m=2^a\quad\text{or}\quad m=3\cdot 2^a.\]

The output is group-theoretic: it gives necessary candidates inside the Yang–Yu–Zhu maximal groups, not a geometric realizability statement for every row.

The group labels and names below follow the terminology of the two source articles: the symplectic groups are ordered as in Table 3 of Fu–Wang–Zheng, while the maximal source groups are ordered as in Theorem 1.2 of Yang–Yu–Zhu.

## Files and execution

Run:

```bash
gap -q gap_yyz_bounds.g
```

Set `YYZ_SHOW_PROGRESS := false;` near the beginning of the script to suppress progress messages.

The recorded run found 2,649 successful subgroup occurrences before final deduplication and produced 218 output records.

## Output format

Each entry of `YYZResults` has the form

```gap
[ "G_i", index, full_group_id, full_group_description, sources ]
```

- `G_i` is the Laza–Zheng label of the symplectic group.
- `full_group_id` is the GAP SmallGroup ID when available; otherwise it is `fail`.
- `sources` records the Yang–Yu–Zhu maximal groups in which the candidate occurs.

### Article notation for the symplectic groups

The labels `G_i` follow Table 3 of Fu–Wang–Zheng.  Here `G_i` denotes the full symplectic automorphism group $\operatorname{Aut}^s(X)$, and $r(S)$ is the rank of its coinvariant lattice.  We retain the group names used in that table; the GAP descriptions in the result tables give concrete abstract structures when available.

| Label | Article notation | Order | $r(S)$ |
|---|---|---:|---:|
| `G_1` | $3^4:A_6$ | 29160 | 20 |
| `G_2` | $A_7$ | 2520 | 20 |
| `G_3` | $3^{1+4}:2.2^2$ | 1944 | 20 |
| `G_4` | $M_{10}$ | 720 | 20 |
| `G_5` | $L_2(11)$ | 660 | 20 |
| `G_6` | $A_{3,5}$ | 360 | 20 |
| `G_7` | $3^{1+4}:2.2$ | 972 | 19 |
| `G_8` | $A_6$ | 360 | 19 |
| `G_9` | $L_2(7)$ | 168 | 19 |
| `G_10` | $S_5$ | 120 | 19 |
| `G_11` | $M_9$ | 72 | 19 |
| `G_12` | $N_{72}$ | 72 | 19 |
| `G_13` | $T_{48}$ | 48 | 19 |
| `G_14` | $3^{1+4}:2$ | 486 | 18 |
| `G_15` | $A_{4,3}$ | 72 | 18 |
| `G_16` | $A_5$ | 60 | 18 |
| `G_17` | $3^2.4$ | 36 | 18 |
| `G_18` | $S_{3,3}$ | 36 | 18 |
| `G_19` | $F_{21}$ | 21 | 18 |
| `G_20` | $\operatorname{Hol}(5)$ | 20 | 18 |
| `G_21` | $QD_{16}$ | 16 | 18 |
| `G_22` | $S_4$ | 24 | 17 |
| `G_23` | $Q_8$ | 8 | 17 |
| `G_24` | $A_{3,3}$ | 18 | 16 |
| `G_25` | $D_{12}$ | 12 | 16 |
| `G_26` | $A_4$ | 12 | 16 |
| `G_27` | $D_{10}$ | 10 | 16 |
| `G_28` | $D_8$ | 8 | 15 |
| `G_29` | $C_4$ | 4 | 14 |
| `G_30` | $S_3$ | 6 | 14 |
| `G_31` | $C_2^2$ | 4 | 12 |
| `G_32` | $C_3$ | 3 | 12 |
| `G_33` | $C_2$ | 2 | 8 |
| `G_34` | $1$ | 1 | 0 |

The notation $L_2(q)$ means $\operatorname{PSL}_2(\mathbf F_q)$.  Symbols such as $A_{3,5}$, $A_{4,3}$, $A_{3,3}$, $S_{3,3}$, $M_9$, $N_{72}$, and $T_{48}$ are the names used in the Laza–Zheng classification and retained in the index paper.

### Special treatment of `G_14`

Here `G_14` is the group $3^{1+4}:2$ of order 486.  Full groups above `G_14` are deliberately not identified, because the corresponding abstract-group identification is comparatively expensive. Successful occurrences are merged only by index, and their source sets are united. Thus a `G_14` row has the form

```gap
[ "G_14", index, fail, fail, sources ]
```

A single such row may therefore represent more than one non-isomorphic full group with the same index.

## Yang–Yu–Zhu maximal-group sources

The labels `M_i` follow Theorem 1.2 of Yang–Yu–Zhu.  Their theorem says that a finite group acts faithfully on a smooth cubic fourfold if and only if it is isomorphic to a subgroup of one of these 15 groups.  The “YYZ notation” column follows the article; the last column is GAP's `StructureDescription`, which can look different even for an isomorphic group.

| Source | YYZ notation | Order | GAP ID | GAP structure description |
|---|---|---:|---:|---|
| `M_1` | $C_3^5 \rtimes S_6$ | 174960 | — | `((C3 x C3 x C3 x C3) : A6) : C6` |
| `M_2` | $((C_3\times(C_3^3\rtimes C_3))\rtimes C_3)\rtimes(C_4\times C_2)$ | 5832 | — | `((C3 x ((C3 x C3 x C3) : C3)) : C3) : (C4 x C2)` |
| `M_3` | $C_8\times(C_3^2\rtimes C_2)$ | 144 | `[144,69]` | `C24 x S3` |
| `M_4` | $S_5\times(C_3^2\rtimes C_2)$ | 2160 | — | `C3 x S3 x S5` |
| `M_5` | $C_{48}$ | 48 | `[48,2]` | `C48` |
| `M_6` | $\operatorname{PSL}(2,11)\times C_3$ | 1980 | `[1980,57]` | `C3 x PSL(2,11)` |
| `M_7` | $((C_3\times(C_3^2\rtimes C_3))\rtimes C_3)\rtimes(C_4^2\rtimes C_2)$ | 7776 | — | `((C3 x ((C3 x C3) : C3)) : C3) : ((C4 x C4) : C2)` |
| `M_8` | $C_{32}$ | 32 | `[32,1]` | `C32` |
| `M_9` | $C_{21}\rtimes C_6$ | 126 | `[126,7]` | `C3 x (C7 : C6)` |
| `M_10` | $M_{10}$ | 720 | `[720,765]` | `A6 . C2` |
| `M_11` | $S_7$ | 5040 | — | `S7` |
| `M_12` | $(C_8\times C_2)\rtimes C_2$ | 32 | `[32,42]` | `(C8 x C2) : C2` |
| `M_13` | $\operatorname{PSL}(3,2)\rtimes C_2$ | 336 | `[336,208]` | `PSL(3,2) : C2` |
| `M_14` | $\operatorname{GL}(2,3)$ | 48 | `[48,29]` | `GL(2,3)` |
| `M_15` | $(C_3^2\rtimes Q_8)\rtimes C_3$ | 216 | `[216,153]` | `((C3 x C3) : Q8) : C3` |

## Results

### `G_1`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | — | `(C3 x C3 x C3 x C3) : A6` | `M_1` |
| 2 | — | `(C3 x C3 x C3 x C3) : S6` | `M_1` |
| 3 | — | `((C3 x C3 x C3 x C3) : A6) : C3` | `M_1` |
| 6 | — | `((C3 x C3 x C3 x C3) : A6) : C6` | `M_1` |

### `G_2`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | — | `A7` | `M_11` |
| 2 | — | `S7` | `M_11` |

### `G_3`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[1944,3559]` | `((C3 x ((C3 x C3) : C3)) : C3) : Q8` | `M_7` |
| 2 | — | `((C3 x ((C3 x C3) : C3)) : C3) : ((C4 x C2) : C2)` | `M_7` |
| 4 | — | `((C3 x ((C3 x C3) : C3)) : C3) : ((C4 x C4) : C2)` | `M_7` |

### `G_4`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[720,765]` | `A6 . C2` | `M_10` |

### `G_5`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[660,13]` | `PSL(2,11)` | `M_6` |
| 3 | `[1980,57]` | `C3 x PSL(2,11)` | `M_6` |

### `G_6`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[360,120]` | `A5 : S3` | `M_4` |
| 2 | `[720,767]` | `S5 x S3` | `M_4` |
| 3 | `[1080,489]` | `C3 x (A5 : S3)` | `M_4` |
| 6 | — | `C3 x S3 x S5` | `M_4` |

### `G_7`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[972,776]` | `((C3 x ((C3 x C3) : C3)) : C3) : C4` | `M_1`, `M_7` |
| 2 | `[1944,3498]` | `((C3 x ((C3 x C3) : C3)) : C3) : (C4 x C2)` | `M_7` |
| 2 | `[1944,3536]` | `((C3 x ((C3 x C3) : C3)) : C3) : D8` | `M_1`, `M_7` |
| 2 | `[1944,3559]` | `((C3 x ((C3 x C3) : C3)) : C3) : Q8` | `M_7` |
| 3 | — | `((C3 x ((C3 x C3 x C3) : C3)) : C3) : C4` | `M_1` |
| 6 | — | `((C3 x ((C3 x C3 x C3) : C3)) : C3) : D8` | `M_1` |

### `G_8`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[360,118]` | `A6` | `M_1`, `M_10`, `M_11` |
| 2 | `[720,763]` | `S6` | `M_1`, `M_11` |
| 2 | `[720,765]` | `A6 . C2` | `M_10` |

### `G_9`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[168,42]` | `PSL(3,2)` | `M_11`, `M_13` |
| 2 | `[336,208]` | `PSL(3,2) : C2` | `M_13` |

### `G_10`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[120,34]` | `S5` | `M_1`, `M_4`, `M_11` |
| 2 | `[240,189]` | `C2 x S5` | `M_4`, `M_11` |
| 3 | `[360,119]` | `C3 x S5` | `M_1`, `M_4` |
| 6 | `[720,769]` | `C6 x S5` | `M_4` |

### `G_11`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[72,41]` | `(C3 x C3) : Q8` | `M_7`, `M_10`, `M_15` |
| 3 | `[216,153]` | `((C3 x C3) : Q8) : C3` | `M_15` |

### `G_12`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[72,40]` | `(S3 x S3) : C2` | `M_1`, `M_7`, `M_11` |
| 2 | `[144,186]` | `C2 x ((S3 x S3) : C2)` | `M_1` |
| 3 | `[216,157]` | `C3 x ((S3 x S3) : C2)` | `M_1` |
| 6 | `[432,754]` | `C6 x ((S3 x S3) : C2)` | `M_1` |

### `G_13`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[48,29]` | `GL(2,3)` | `M_14` |

### `G_14`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | — | — | `M_1`, `M_2`, `M_7` |
| 2 | — | — | `M_1`, `M_2`, `M_7` |
| 3 | — | — | `M_1`, `M_2` |
| 4 | — | — | `M_2`, `M_7` |
| 6 | — | — | `M_1`, `M_2` |
| 12 | — | — | `M_2` |

### `G_15`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[72,43]` | `(C3 x A4) : C2` | `M_1`, `M_4`, `M_11` |
| 2 | `[144,183]` | `S3 x S4` | `M_1`, `M_4`, `M_11` |
| 2 | `[144,189]` | `C2 x ((C3 x A4) : C2)` | `M_1` |
| 3 | `[216,92]` | `((C3 x A4) : C2) : C3` | `M_1` |
| 3 | `[216,164]` | `C3 x ((C3 x A4) : C2)` | `M_1`, `M_4` |
| 6 | `[432,535]` | `C2 x (((C3 x A4) : C2) : C3)` | `M_1` |
| 6 | `[432,745]` | `C3 x S3 x S4` | `M_1`, `M_4` |

### `G_16`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[60,5]` | `A5` | `M_1`, `M_4`, `M_6`, `M_10`, `M_11` |
| 2 | `[120,34]` | `S5` | `M_1`, `M_4`, `M_11` |
| 2 | `[120,35]` | `C2 x A5` | `M_4`, `M_11` |
| 3 | `[180,19]` | `GL(2,4)` | `M_1`, `M_4`, `M_6` |
| 6 | `[360,119]` | `C3 x S5` | `M_1`, `M_4` |
| 6 | `[360,122]` | `C6 x A5` | `M_4` |

### `G_17`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[36,9]` | `(C3 x C3) : C4` | `M_1`, `M_7`, `M_10`, `M_11`, `M_15` |
| 2 | `[72,40]` | `(S3 x S3) : C2` | `M_1`, `M_7`, `M_11` |
| 2 | `[72,41]` | `(C3 x C3) : Q8` | `M_7`, `M_10`, `M_15` |
| 2 | `[72,45]` | `C2 x ((C3 x C3) : C4)` | `M_1`, `M_7` |
| 3 | `[108,36]` | `C3 x ((C3 x C3) : C4)` | `M_1`, `M_7` |
| 6 | `[216,157]` | `C3 x ((S3 x S3) : C2)` | `M_1` |
| 6 | `[216,168]` | `C6 x ((C3 x C3) : C4)` | `M_1` |

### `G_18`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[36,10]` | `S3 x S3` | `M_1`, `M_2`, `M_4`, `M_7`, `M_11` |
| 2 | `[72,40]` | `(S3 x S3) : C2` | `M_1`, `M_7`, `M_11` |
| 2 | `[72,46]` | `C2 x S3 x S3` | `M_1`, `M_4` |
| 3 | `[108,38]` | `C3 x S3 x S3` | `M_1`, `M_2`, `M_4`, `M_7` |
| 6 | `[216,157]` | `C3 x ((S3 x S3) : C2)` | `M_1` |
| 6 | `[216,170]` | `C6 x S3 x S3` | `M_1`, `M_4` |

### `G_19`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[21,1]` | `C7 : C3` | `M_9`, `M_11`, `M_13` |
| 2 | `[42,1]` | `C7 : C6` | `M_9`, `M_11`, `M_13` |
| 3 | `[63,3]` | `C3 x (C7 : C3)` | `M_9` |
| 6 | `[126,7]` | `C3 x (C7 : C6)` | `M_9` |

### `G_20`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[20,3]` | `C5 : C4` | `M_1`, `M_4`, `M_10`, `M_11` |
| 2 | `[40,12]` | `C2 x (C5 : C4)` | `M_4`, `M_11` |
| 3 | `[60,6]` | `C3 x (C5 : C4)` | `M_1`, `M_4` |
| 6 | `[120,40]` | `C6 x (C5 : C4)` | `M_4` |

### `G_21`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[16,8]` | `QD16` | `M_10`, `M_12`, `M_14` |
| 2 | `[32,42]` | `(C8 x C2) : C2` | `M_12` |

### `G_22`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[24,12]` | `S4` | `M_1`, `M_4`, `M_10`, `M_11`, `M_13` |
| 2 | `[48,48]` | `C2 x S4` | `M_1`, `M_4`, `M_11` |
| 3 | `[72,42]` | `C3 x S4` | `M_1`, `M_4`, `M_11` |
| 6 | `[144,188]` | `C6 x S4` | `M_1`, `M_4` |

### `G_23`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[8,4]` | `Q8` | `M_7`, `M_10`, `M_12`, `M_14`, `M_15` |
| 2 | `[16,8]` | `QD16` | `M_10`, `M_12`, `M_14` |
| 2 | `[16,9]` | `Q16` | `M_12` |
| 2 | `[16,13]` | `(C4 x C2) : C2` | `M_7`, `M_12` |
| 3 | `[24,3]` | `SL(2,3)` | `M_14`, `M_15` |
| 4 | `[32,11]` | `(C4 x C4) : C2` | `M_7` |

### `G_24`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[18,4]` | `(C3 x C3) : C2` | `M_1`, `M_2`, `M_4`, `M_7`, `M_10`, `M_11`, `M_15` |
| 2 | `[36,9]` | `(C3 x C3) : C4` | `M_1`, `M_7`, `M_10`, `M_11`, `M_15` |
| 2 | `[36,10]` | `S3 x S3` | `M_1`, `M_2`, `M_4`, `M_7`, `M_11` |
| 2 | `[36,13]` | `C2 x ((C3 x C3) : C2)` | `M_1`, `M_4`, `M_7` |
| 3 | `[54,5]` | `(C3 x C3) : C6` | `M_1`, `M_7`, `M_15` |
| 3 | `[54,13]` | `C3 x ((C3 x C3) : C2)` | `M_1`, `M_2`, `M_4`, `M_7` |
| 4 | `[72,45]` | `C2 x ((C3 x C3) : C4)` | `M_1`, `M_7` |
| 6 | `[108,25]` | `C2 x ((C3 x C3) : C6)` | `M_1` |
| 6 | `[108,36]` | `C3 x ((C3 x C3) : C4)` | `M_1`, `M_7` |
| 6 | `[108,38]` | `C3 x S3 x S3` | `M_1`, `M_2`, `M_4`, `M_7` |
| 6 | `[108,43]` | `C6 x ((C3 x C3) : C2)` | `M_1`, `M_4` |
| 12 | `[216,168]` | `C6 x ((C3 x C3) : C4)` | `M_1` |

### `G_25`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[12,4]` | `D12` | `M_1`, `M_2`, `M_3`, `M_4`, `M_6`, `M_7`, `M_11`, `M_13`, `M_14` |
| 2 | `[24,5]` | `C4 x S3` | `M_1`, `M_2`, `M_3`, `M_4`, `M_7`, `M_11` |
| 2 | `[24,6]` | `D24` | `M_1`, `M_4`, `M_7`, `M_11` |
| 2 | `[24,8]` | `(C6 x C2) : C2` | `M_1`, `M_4`, `M_7`, `M_11` |
| 2 | `[24,14]` | `C2 x C2 x S3` | `M_1`, `M_4`, `M_11` |
| 3 | `[36,12]` | `C6 x S3` | `M_1`, `M_2`, `M_3`, `M_4`, `M_6`, `M_7` |
| 4 | `[48,4]` | `C8 x S3` | `M_3` |
| 6 | `[72,27]` | `C12 x S3` | `M_1`, `M_2`, `M_3`, `M_4`, `M_7` |
| 6 | `[72,28]` | `C3 x D24` | `M_1`, `M_4` |
| 6 | `[72,30]` | `C3 x ((C6 x C2) : C2)` | `M_1`, `M_4` |
| 6 | `[72,48]` | `C2 x C6 x S3` | `M_1`, `M_4` |
| 12 | `[144,69]` | `C24 x S3` | `M_3` |

### `G_26`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[12,3]` | `A4` | `M_1`, `M_4`, `M_6`, `M_10`, `M_11`, `M_13` |
| 2 | `[24,12]` | `S4` | `M_1`, `M_4`, `M_10`, `M_11`, `M_13` |
| 2 | `[24,13]` | `C2 x A4` | `M_1`, `M_4`, `M_11` |
| 3 | `[36,11]` | `C3 x A4` | `M_1`, `M_4`, `M_6`, `M_11` |
| 6 | `[72,42]` | `C3 x S4` | `M_1`, `M_4`, `M_11` |
| 6 | `[72,47]` | `C6 x A4` | `M_1`, `M_4` |

### `G_27`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[10,1]` | `D10` | `M_1`, `M_4`, `M_6`, `M_10`, `M_11` |
| 2 | `[20,3]` | `C5 : C4` | `M_1`, `M_4`, `M_10`, `M_11` |
| 2 | `[20,4]` | `D20` | `M_4`, `M_11` |
| 3 | `[30,2]` | `C3 x D10` | `M_1`, `M_4`, `M_6` |
| 4 | `[40,12]` | `C2 x (C5 : C4)` | `M_4`, `M_11` |
| 6 | `[60,6]` | `C3 x (C5 : C4)` | `M_1`, `M_4` |
| 6 | `[60,10]` | `C6 x D10` | `M_4` |
| 12 | `[120,40]` | `C6 x (C5 : C4)` | `M_4` |

### `G_28`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[8,3]` | `D8` | `M_1`, `M_4`, `M_7`, `M_10`, `M_11`, `M_12`, `M_13`, `M_14` |
| 2 | `[16,7]` | `D16` | `M_12`, `M_13` |
| 2 | `[16,8]` | `QD16` | `M_10`, `M_12`, `M_14` |
| 2 | `[16,11]` | `C2 x D8` | `M_1`, `M_4`, `M_11` |
| 2 | `[16,13]` | `(C4 x C2) : C2` | `M_7`, `M_12` |
| 3 | `[24,10]` | `C3 x D8` | `M_1`, `M_4`, `M_11` |
| 4 | `[32,11]` | `(C4 x C4) : C2` | `M_7` |
| 6 | `[48,45]` | `C6 x D8` | `M_1`, `M_4` |

### `G_29`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[4,1]` | `C4` | `M_1`, `M_2`, `M_3`, `M_4`, `M_5`, `M_7`, `M_8`, `M_10`, `M_11`, `M_12`, `M_13`, `M_14`, `M_15` |
| 2 | `[8,1]` | `C8` | `M_3`, `M_5`, `M_7`, `M_8`, `M_10`, `M_12`, `M_13`, `M_14` |
| 2 | `[8,2]` | `C4 x C2` | `M_1`, `M_2`, `M_3`, `M_4`, `M_7`, `M_11`, `M_12` |
| 2 | `[8,3]` | `D8` | `M_1`, `M_4`, `M_7`, `M_10`, `M_11`, `M_12`, `M_13`, `M_14` |
| 2 | `[8,4]` | `Q8` | `M_7`, `M_10`, `M_12`, `M_14`, `M_15` |
| 3 | `[12,2]` | `C12` | `M_1`, `M_2`, `M_3`, `M_4`, `M_5`, `M_7`, `M_11` |
| 4 | `[16,1]` | `C16` | `M_5`, `M_8` |
| 4 | `[16,2]` | `C4 x C4` | `M_7` |
| 4 | `[16,5]` | `C8 x C2` | `M_3`, `M_12` |
| 4 | `[16,6]` | `C8 : C2` | `M_7` |
| 6 | `[24,2]` | `C24` | `M_3`, `M_5` |
| 6 | `[24,9]` | `C12 x C2` | `M_1`, `M_2`, `M_3`, `M_4`, `M_7` |
| 6 | `[24,10]` | `C3 x D8` | `M_1`, `M_4`, `M_11` |
| 8 | `[32,1]` | `C32` | `M_8` |
| 12 | `[48,2]` | `C48` | `M_5` |
| 12 | `[48,20]` | `C12 x C4` | `M_7` |
| 12 | `[48,23]` | `C24 x C2` | `M_3` |

### `G_30`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[6,1]` | `S3` | `M_1`, `M_2`, `M_3`, `M_4`, `M_6`, `M_7`, `M_10`, `M_11`, `M_13`, `M_14`, `M_15` |
| 2 | `[12,4]` | `D12` | `M_1`, `M_2`, `M_3`, `M_4`, `M_6`, `M_7`, `M_11`, `M_13`, `M_14` |
| 3 | `[18,3]` | `C3 x S3` | `M_1`, `M_2`, `M_3`, `M_4`, `M_6`, `M_7`, `M_11`, `M_15` |
| 4 | `[24,5]` | `C4 x S3` | `M_1`, `M_2`, `M_3`, `M_4`, `M_7`, `M_11` |
| 6 | `[36,12]` | `C6 x S3` | `M_1`, `M_2`, `M_3`, `M_4`, `M_6`, `M_7` |
| 8 | `[48,4]` | `C8 x S3` | `M_3` |
| 12 | `[72,27]` | `C12 x S3` | `M_1`, `M_2`, `M_3`, `M_4`, `M_7` |
| 24 | `[144,69]` | `C24 x S3` | `M_3` |

### `G_31`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[4,2]` | `C2 x C2` | `M_1`, `M_2`, `M_3`, `M_4`, `M_6`, `M_7`, `M_10`, `M_11`, `M_12`, `M_13`, `M_14` |
| 2 | `[8,2]` | `C4 x C2` | `M_1`, `M_2`, `M_3`, `M_4`, `M_7`, `M_11`, `M_12` |
| 2 | `[8,3]` | `D8` | `M_1`, `M_4`, `M_7`, `M_10`, `M_11`, `M_12`, `M_13`, `M_14` |
| 2 | `[8,5]` | `C2 x C2 x C2` | `M_1`, `M_4`, `M_11` |
| 3 | `[12,3]` | `A4` | `M_1`, `M_4`, `M_6`, `M_10`, `M_11`, `M_13` |
| 3 | `[12,5]` | `C6 x C2` | `M_1`, `M_2`, `M_3`, `M_4`, `M_6`, `M_7`, `M_11` |
| 4 | `[16,5]` | `C8 x C2` | `M_3`, `M_12` |
| 4 | `[16,6]` | `C8 : C2` | `M_7` |
| 6 | `[24,9]` | `C12 x C2` | `M_1`, `M_2`, `M_3`, `M_4`, `M_7` |
| 6 | `[24,10]` | `C3 x D8` | `M_1`, `M_4`, `M_11` |
| 6 | `[24,13]` | `C2 x A4` | `M_1`, `M_4`, `M_11` |
| 6 | `[24,15]` | `C6 x C2 x C2` | `M_1`, `M_4` |
| 12 | `[48,23]` | `C24 x C2` | `M_3` |

### `G_32`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[3,1]` | `C3` | `M_1`, `M_2`, `M_3`, `M_4`, `M_5`, `M_6`, `M_7`, `M_9`, `M_10`, `M_11`, `M_13`, `M_14`, `M_15` |
| 2 | `[6,1]` | `S3` | `M_1`, `M_2`, `M_3`, `M_4`, `M_6`, `M_7`, `M_10`, `M_11`, `M_13`, `M_14`, `M_15` |
| 2 | `[6,2]` | `C6` | `M_1`, `M_2`, `M_3`, `M_4`, `M_5`, `M_6`, `M_7`, `M_9`, `M_11`, `M_13`, `M_14`, `M_15` |
| 3 | `[9,1]` | `C9` | `M_1`, `M_2` |
| 3 | `[9,2]` | `C3 x C3` | `M_1`, `M_2`, `M_3`, `M_4`, `M_6`, `M_7`, `M_9`, `M_10`, `M_11`, `M_15` |
| 4 | `[12,1]` | `C3 : C4` | `M_1`, `M_2`, `M_3`, `M_4`, `M_7`, `M_11` |
| 4 | `[12,2]` | `C12` | `M_1`, `M_2`, `M_3`, `M_4`, `M_5`, `M_7`, `M_11` |
| 6 | `[18,2]` | `C18` | `M_1`, `M_2` |
| 6 | `[18,3]` | `C3 x S3` | `M_1`, `M_2`, `M_3`, `M_4`, `M_6`, `M_7`, `M_11`, `M_15` |
| 6 | `[18,5]` | `C6 x C3` | `M_1`, `M_2`, `M_3`, `M_4`, `M_6`, `M_7`, `M_9` |
| 8 | `[24,1]` | `C3 : C8` | `M_3`, `M_7` |
| 8 | `[24,2]` | `C24` | `M_3`, `M_5` |
| 12 | `[36,2]` | `C36` | `M_2` |
| 12 | `[36,6]` | `C3 x (C3 : C4)` | `M_1`, `M_2`, `M_3`, `M_4`, `M_7` |
| 12 | `[36,8]` | `C12 x C3` | `M_1`, `M_2`, `M_3`, `M_4`, `M_7` |
| 16 | `[48,2]` | `C48` | `M_5` |
| 24 | `[72,12]` | `C3 x (C3 : C8)` | `M_3` |
| 24 | `[72,14]` | `C24 x C3` | `M_3` |

### `G_33`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[2,1]` | `C2` | `M_1`, `M_2`, `M_3`, `M_4`, `M_5`, `M_6`, `M_7`, `M_8`, `M_9`, `M_10`, `M_11`, `M_12`, `M_13`, `M_14`, `M_15` |
| 2 | `[4,1]` | `C4` | `M_1`, `M_2`, `M_3`, `M_4`, `M_5`, `M_7`, `M_8`, `M_10`, `M_11`, `M_12`, `M_13`, `M_14`, `M_15` |
| 2 | `[4,2]` | `C2 x C2` | `M_1`, `M_2`, `M_3`, `M_4`, `M_6`, `M_7`, `M_10`, `M_11`, `M_12`, `M_13`, `M_14` |
| 3 | `[6,2]` | `C6` | `M_1`, `M_2`, `M_3`, `M_4`, `M_5`, `M_6`, `M_7`, `M_9`, `M_11`, `M_13`, `M_14`, `M_15` |
| 4 | `[8,1]` | `C8` | `M_3`, `M_5`, `M_7`, `M_8`, `M_10`, `M_12`, `M_13`, `M_14` |
| 4 | `[8,2]` | `C4 x C2` | `M_1`, `M_2`, `M_3`, `M_4`, `M_7`, `M_11`, `M_12` |
| 6 | `[12,2]` | `C12` | `M_1`, `M_2`, `M_3`, `M_4`, `M_5`, `M_7`, `M_11` |
| 6 | `[12,5]` | `C6 x C2` | `M_1`, `M_2`, `M_3`, `M_4`, `M_6`, `M_7`, `M_11` |
| 8 | `[16,1]` | `C16` | `M_5`, `M_8` |
| 8 | `[16,5]` | `C8 x C2` | `M_3`, `M_12` |
| 12 | `[24,2]` | `C24` | `M_3`, `M_5` |
| 12 | `[24,9]` | `C12 x C2` | `M_1`, `M_2`, `M_3`, `M_4`, `M_7` |
| 16 | `[32,1]` | `C32` | `M_8` |
| 24 | `[48,2]` | `C48` | `M_5` |
| 24 | `[48,23]` | `C24 x C2` | `M_3` |

### `G_34`

| Index | Full group ID | Full group description | Sources |
|---:|---:|---|---|
| 1 | `[1,1]` | `1` | `M_1`, `M_2`, `M_3`, `M_4`, `M_5`, `M_6`, `M_7`, `M_8`, `M_9`, `M_10`, `M_11`, `M_12`, `M_13`, `M_14`, `M_15` |
| 2 | `[2,1]` | `C2` | `M_1`, `M_2`, `M_3`, `M_4`, `M_5`, `M_6`, `M_7`, `M_8`, `M_9`, `M_10`, `M_11`, `M_12`, `M_13`, `M_14`, `M_15` |
| 3 | `[3,1]` | `C3` | `M_1`, `M_2`, `M_3`, `M_4`, `M_5`, `M_6`, `M_7`, `M_9`, `M_10`, `M_11`, `M_13`, `M_14`, `M_15` |
| 4 | `[4,1]` | `C4` | `M_1`, `M_2`, `M_3`, `M_4`, `M_5`, `M_7`, `M_8`, `M_10`, `M_11`, `M_12`, `M_13`, `M_14`, `M_15` |
| 6 | `[6,2]` | `C6` | `M_1`, `M_2`, `M_3`, `M_4`, `M_5`, `M_6`, `M_7`, `M_9`, `M_11`, `M_13`, `M_14`, `M_15` |
| 8 | `[8,1]` | `C8` | `M_3`, `M_5`, `M_7`, `M_8`, `M_10`, `M_12`, `M_13`, `M_14` |
| 12 | `[12,2]` | `C12` | `M_1`, `M_2`, `M_3`, `M_4`, `M_5`, `M_7`, `M_11` |
| 16 | `[16,1]` | `C16` | `M_5`, `M_8` |
| 24 | `[24,2]` | `C24` | `M_3`, `M_5` |
| 32 | `[32,1]` | `C32` | `M_8` |
| 48 | `[48,2]` | `C48` | `M_5` |
