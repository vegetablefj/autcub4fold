# Liftability of the 156 cubic-fourfold families

The input is the [complete family catalogue](../gap_manuscript_validation/gap_family_catalogue.g), numbered 1--156. The 48 reference families and inherited obstructions are retained; the other 101 rows use all conjugacy classes of projective subgroups `C3`, `C9`, and `C3 x C3`. In addition, every row is independently tested using its distinguished scalar kernel in `H_ab` and `H_ab/3H_ab`. All 156 ordinary and F-liftability decisions agree, and every inherited symplectic subgroup is checked as an actual matrix subgroup. The saved catalogue labels are compared only after the decisions are computed.

Definitions and hypotheses are explained in [the script guide](gap_liftability_script.md). The [GAP result](gap_liftability.out) binds each number and source key to its exact input matrices; the [log](gap_liftability.log) ends with `LIFTABILITY_COMPLETED`. The input's smoothness and saturation are mathematical prerequisites, not conclusions of this test.

The run used GAP 4.15.1 and took 79781 ms. It processed 156 families: 134 are liftable and 131 are F-liftable. The three decision routes account for 48 reference rows, 7 inherited obstructions, and 101 computed rows.

## Complete table

| No. | Symplectic family | PGL ID | Index | Dimension | Liftable | F-liftable | Decision |
|---:|---|---:|---:|---:|:---:|:---:|---|
| 1 | `3^4:A_6` | `[174960, --]` | 6 | 0 | no | no | reference |
| 2 | `A_7` | `[2520, --]` | 1 | 0 | no | no | reference |
| 3 | `A_7` | `[5040, --]` | 2 | 0 | yes | yes | reference |
| 4 | `3^{1+4}:2.2^2` | `[7776, --]` | 4 | 0 | no | no | reference |
| 5 | `M_10` | `[720, --]` | 1 | 0 | no | no | reference |
| 6 | `M_10` | `[720, --]` | 1 | 0 | no | no | reference |
| 7 | `L_2(11)` | `[1980, --]` | 3 | 0 | yes | yes | reference |
| 8 | `A_3,5` | `[2160, --]` | 6 | 0 | yes | yes | reference |
| 9 | `3^{1+4}:2.2` | `[1944, --]` | 2 | 1 | no | no | reference |
| 10 | `A_6` | `[360, --]` | 1 | 1 | no | no | reference |
| 11 | `A_6` | `[720, --]` | 2 | 1 | yes | yes | reference |
| 12 | `PSL(2,7)` | `[168, --]` | 1 | 1 | yes | yes | reference |
| 13 | `PSL(2,7)` | `[336, --]` | 2 | 0 | yes | yes | small 3-subgroups |
| 14 | `PSL(2,7)` | `[336, --]` | 2 | 0 | yes | yes | small 3-subgroups |
| 15 | `S_5` | `[120, --]` | 1 | 1 | yes | yes | reference |
| 16 | `S_5` | `[240, --]` | 2 | 1 | yes | yes | reference |
| 17 | `M_9` | `[72, 41]` | 1 | 1 | no | no | reference |
| 18 | `M_9` | `[216, --]` | 3 | 0 | no | no | inherited obstruction |
| 19 | `N_72` | `[144, 186]` | 2 | 1 | yes | yes | reference |
| 20 | `T_48` | `[48, --]` | 1 | 1 | yes | yes | reference |
| 21 | `3^{1+4}:2` | `[972, --]` | 2 | 2 | no | no | reference |
| 22 | `3^{1+4}:2` | `[1944, 3493]` | 4 | 1 | no | no | inherited obstruction |
| 23 | `3^{1+4}:2` | `[2916, --]` | 6 | 1 | no | no | inherited obstruction |
| 24 | `3^{1+4}:2` | `[5832, --]` | 12 | 0 | no | no | inherited obstruction |
| 25 | `A_4,3` | `[72, 43]` | 1 | 2 | no | no | reference |
| 26 | `A_4,3` | `[144, 189]` | 2 | 1 | no | no | inherited obstruction |
| 27 | `A_4,3` | `[144, --]` | 2 | 2 | yes | yes | reference |
| 28 | `A_4,3` | `[432, 745]` | 6 | 1 | yes | yes | small 3-subgroups |
| 29 | `A_5` | `[60, --]` | 1 | 2 | yes | yes | reference |
| 30 | `A_5` | `[180, 19]` | 3 | 1 | yes | yes | small 3-subgroups |
| 31 | `A_5` | `[120, --]` | 2 | 2 | yes | yes | reference |
| 32 | `A_5` | `[360, 119]` | 6 | 1 | yes | yes | small 3-subgroups |
| 33 | `3^2.4` | `[36, --]` | 1 | 2 | no | no | reference |
| 34 | `3^2.4` | `[72, 40]` | 2 | 2 | yes | yes | reference |
| 35 | `S_3,3` | `[72, 46]` | 2 | 2 | yes | yes | reference |
| 36 | `S_3,3` | `[216, 170]` | 6 | 1 | yes | yes | small 3-subgroups |
| 37 | `S_3,3` | `[72, 40]` | 2 | 2 | yes | yes | reference |
| 38 | `S_3,3` | `[216, 157]` | 6 | 1 | yes | yes | small 3-subgroups |
| 39 | `F_21` | `[21, --]` | 1 | 2 | yes | yes | reference |
| 40 | `F_21` | `[42, --]` | 2 | 1 | yes | yes | small 3-subgroups |
| 41 | `F_21` | `[126, --]` | 6 | 0 | no | no | small 3-subgroups |
| 42 | `Hol_5` | `[20, --]` | 1 | 2 | yes | yes | reference |
| 43 | `QD_16` | `[16, --]` | 1 | 2 | yes | yes | reference |
| 44 | `QD_16` | `[32, 42]` | 2 | 1 | yes | yes | small 3-subgroups |
| 45 | `S_4` | `[24, --]` | 1 | 3 | yes | yes | reference |
| 46 | `S_4` | `[48, 48]` | 2 | 2 | yes | yes | small 3-subgroups |
| 47 | `S_4` | `[48, --]` | 2 | 3 | yes | yes | reference |
| 48 | `Q_8` | `[8, --]` | 1 | 3 | yes | yes | reference |
| 49 | `Q_8` | `[16, 13]` | 2 | 2 | yes | yes | small 3-subgroups |
| 50 | `Q_8` | `[24, 3]` | 3 | 1 | yes | yes | small 3-subgroups |
| 51 | `Q_8` | `[32, 11]` | 4 | 1 | yes | yes | small 3-subgroups |
| 52 | `A_3,3` | `[18, --]` | 1 | 4 | no | no | reference |
| 53 | `A_3,3` | `[36, 13]` | 2 | 2 | no | no | inherited obstruction |
| 54 | `A_3,3` | `[54, 5]` | 3 | 1 | no | no | inherited obstruction |
| 55 | `A_3,3` | `[36, --]` | 2 | 4 | yes | yes | reference |
| 56 | `A_3,3` | `[108, 38]` | 6 | 2 | yes | yes | small 3-subgroups |
| 57 | `A_3,3` | `[108, 38]` | 6 | 2 | yes | yes | small 3-subgroups |
| 58 | `D_12` | `[12, --]` | 1 | 4 | yes | yes | reference |
| 59 | `D_12` | `[24, 8]` | 2 | 2 | yes | yes | small 3-subgroups |
| 60 | `D_12` | `[24, 14]` | 2 | 2 | yes | yes | small 3-subgroups |
| 61 | `D_12` | `[36, 12]` | 3 | 2 | yes | yes | small 3-subgroups |
| 62 | `D_12` | `[72, 30]` | 6 | 1 | yes | yes | small 3-subgroups |
| 63 | `D_12` | `[24, 14]` | 2 | 4 | yes | yes | reference |
| 64 | `D_12` | `[72, 48]` | 6 | 2 | yes | yes | small 3-subgroups |
| 65 | `A_4` | `[12, --]` | 1 | 4 | yes | yes | reference |
| 66 | `A_4` | `[24, 13]` | 2 | 3 | yes | yes | small 3-subgroups |
| 67 | `A_4` | `[36, 11]` | 3 | 2 | yes | yes | small 3-subgroups |
| 68 | `A_4` | `[24, --]` | 2 | 4 | yes | yes | reference |
| 69 | `A_4` | `[72, 42]` | 6 | 2 | yes | yes | small 3-subgroups |
| 70 | `D_10` | `[10, --]` | 1 | 4 | yes | yes | reference |
| 71 | `D_10` | `[20, 4]` | 2 | 2 | yes | yes | small 3-subgroups |
| 72 | `D_10` | `[30, 2]` | 3 | 2 | yes | yes | small 3-subgroups |
| 73 | `D_8` | `[8, --]` | 1 | 5 | yes | yes | reference |
| 74 | `D_8` | `[16, 11]` | 2 | 4 | yes | yes | small 3-subgroups |
| 75 | `D_8` | `[16, 13]` | 2 | 3 | yes | yes | small 3-subgroups |
| 76 | `D_8` | `[16, 7]` | 2 | 2 | yes | yes | small 3-subgroups |
| 77 | `C4` | `[4, 1]` | 1 | 6 | yes | yes | reference |
| 78 | `C4` | `[8, 3]` | 2 | 5 | yes | yes | small 3-subgroups |
| 79 | `C4` | `[8, 2]` | 2 | 4 | yes | yes | small 3-subgroups |
| 80 | `C4` | `[8, 3]` | 2 | 3 | yes | yes | small 3-subgroups |
| 81 | `C4` | `[16, 2]` | 4 | 2 | yes | yes | small 3-subgroups |
| 82 | `C4` | `[16, 6]` | 4 | 2 | yes | yes | small 3-subgroups |
| 83 | `S3` | `[6, 1]` | 1 | 6 | yes | yes | reference |
| 84 | `S3` | `[12, 4]` | 2 | 3 | yes | yes | small 3-subgroups |
| 85 | `S3` | `[12, 4]` | 2 | 3 | yes | yes | small 3-subgroups |
| 86 | `S3` | `[18, 3]` | 3 | 3 | yes | yes | small 3-subgroups |
| 87 | `S3` | `[18, 3]` | 3 | 2 | yes | yes | small 3-subgroups |
| 88 | `S3` | `[12, 4]` | 2 | 6 | yes | yes | reference |
| 89 | `S3` | `[24, 5]` | 4 | 3 | yes | yes | small 3-subgroups |
| 90 | `S3` | `[36, 12]` | 6 | 3 | yes | yes | small 3-subgroups |
| 91 | `S3` | `[36, 12]` | 6 | 3 | yes | yes | small 3-subgroups |
| 92 | `S3` | `[36, 12]` | 6 | 2 | yes | yes | small 3-subgroups |
| 93 | `S3` | `[48, 4]` | 8 | 1 | yes | yes | small 3-subgroups |
| 94 | `S3` | `[72, 27]` | 12 | 1 | yes | yes | small 3-subgroups |
| 95 | `S3` | `[72, 27]` | 12 | 1 | yes | yes | small 3-subgroups |
| 96 | `S3` | `[144, 69]` | 24 | 0 | yes | yes | small 3-subgroups |
| 97 | `C2^2` | `[4, 2]` | 1 | 8 | yes | yes | reference |
| 98 | `C2^2` | `[8, 5]` | 2 | 7 | yes | yes | small 3-subgroups |
| 99 | `C2^2` | `[8, 3]` | 2 | 6 | yes | yes | small 3-subgroups |
| 100 | `C2^2` | `[8, 5]` | 2 | 5 | yes | yes | small 3-subgroups |
| 101 | `C2^2` | `[12, 5]` | 3 | 4 | yes | yes | small 3-subgroups |
| 102 | `C2^2` | `[12, 3]` | 3 | 3 | yes | yes | small 3-subgroups |
| 103 | `C2^2` | `[24, 10]` | 6 | 3 | yes | yes | small 3-subgroups |
| 104 | `C2^2` | `[24, 13]` | 6 | 2 | yes | yes | small 3-subgroups |
| 105 | `C2^2` | `[24, 13]` | 6 | 2 | yes | no | small 3-subgroups |
| 106 | `C3` | `[3, 1]` | 1 | 8 | yes | yes | reference |
| 107 | `C3` | `[6, 1]` | 2 | 4 | yes | yes | small 3-subgroups |
| 108 | `C3` | `[6, 2]` | 2 | 4 | yes | yes | small 3-subgroups |
| 109 | `C3` | `[6, 2]` | 2 | 4 | yes | yes | small 3-subgroups |
| 110 | `C3` | `[9, 2]` | 3 | 4 | yes | yes | small 3-subgroups |
| 111 | `C3` | `[9, 2]` | 3 | 3 | yes | yes | small 3-subgroups |
| 112 | `C3` | `[9, 2]` | 3 | 2 | no | no | small 3-subgroups |
| 113 | `C3` | `[18, 5]` | 6 | 2 | yes | yes | small 3-subgroups |
| 114 | `C3` | `[18, 5]` | 6 | 1 | no | no | small 3-subgroups |
| 115 | `C3` | `[6, 1]` | 2 | 8 | yes | yes | reference |
| 116 | `C3` | `[18, 3]` | 6 | 4 | yes | yes | small 3-subgroups |
| 117 | `C3` | `[18, 3]` | 6 | 4 | yes | yes | small 3-subgroups |
| 118 | `C3` | `[18, 3]` | 6 | 3 | yes | yes | small 3-subgroups |
| 119 | `C2` | `[2, 1]` | 1 | 12 | yes | yes | reference |
| 120 | `C2` | `[4, 2]` | 2 | 10 | yes | yes | small 3-subgroups |
| 121 | `C2` | `[4, 2]` | 2 | 8 | yes | yes | small 3-subgroups |
| 122 | `C2` | `[4, 2]` | 2 | 6 | yes | yes | small 3-subgroups |
| 123 | `C2` | `[6, 2]` | 3 | 6 | yes | yes | small 3-subgroups |
| 124 | `C2` | `[8, 2]` | 4 | 5 | yes | yes | small 3-subgroups |
| 125 | `C2` | `[12, 5]` | 6 | 5 | yes | yes | small 3-subgroups |
| 126 | `C2` | `[6, 2]` | 3 | 4 | yes | yes | small 3-subgroups |
| 127 | `C2` | `[8, 2]` | 4 | 4 | yes | yes | small 3-subgroups |
| 128 | `C2` | `[12, 5]` | 6 | 3 | yes | yes | small 3-subgroups |
| 129 | `C2` | `[16, 5]` | 8 | 2 | yes | yes | small 3-subgroups |
| 130 | `C2` | `[24, 9]` | 12 | 2 | yes | yes | small 3-subgroups |
| 131 | `C2` | `[24, 9]` | 12 | 1 | yes | yes | small 3-subgroups |
| 132 | `1` | `[1, 1]` | 1 | 20 | yes | yes | reference |
| 133 | `1` | `[2, 1]` | 2 | 14 | yes | yes | small 3-subgroups |
| 134 | `1` | `[2, 1]` | 2 | 10 | yes | yes | small 3-subgroups |
| 135 | `1` | `[3, 1]` | 3 | 10 | yes | yes | small 3-subgroups |
| 136 | `1` | `[3, 1]` | 3 | 7 | yes | yes | small 3-subgroups |
| 137 | `1` | `[4, 1]` | 4 | 7 | yes | yes | small 3-subgroups |
| 138 | `1` | `[4, 1]` | 4 | 7 | yes | yes | small 3-subgroups |
| 139 | `1` | `[6, 2]` | 6 | 7 | yes | yes | small 3-subgroups |
| 140 | `1` | `[3, 1]` | 3 | 6 | yes | no | small 3-subgroups |
| 141 | `1` | `[6, 2]` | 6 | 5 | yes | yes | small 3-subgroups |
| 142 | `1` | `[6, 2]` | 6 | 4 | yes | yes | small 3-subgroups |
| 143 | `1` | `[6, 2]` | 6 | 3 | yes | no | small 3-subgroups |
| 144 | `1` | `[8, 1]` | 8 | 3 | yes | yes | small 3-subgroups |
| 145 | `1` | `[8, 1]` | 8 | 3 | yes | yes | small 3-subgroups |
| 146 | `1` | `[8, 1]` | 8 | 3 | yes | yes | small 3-subgroups |
| 147 | `1` | `[12, 2]` | 12 | 3 | yes | yes | small 3-subgroups |
| 148 | `1` | `[12, 2]` | 12 | 3 | yes | yes | small 3-subgroups |
| 149 | `1` | `[12, 2]` | 12 | 2 | yes | yes | small 3-subgroups |
| 150 | `1` | `[12, 2]` | 12 | 2 | yes | yes | small 3-subgroups |
| 151 | `1` | `[16, 1]` | 16 | 1 | yes | yes | small 3-subgroups |
| 152 | `1` | `[16, 1]` | 16 | 1 | yes | yes | small 3-subgroups |
| 153 | `1` | `[24, 2]` | 24 | 1 | yes | yes | small 3-subgroups |
| 154 | `1` | `[24, 2]` | 24 | 1 | yes | yes | small 3-subgroups |
| 155 | `1` | `[32, 1]` | 32 | 0 | yes | yes | small 3-subgroups |
| 156 | `1` | `[48, 2]` | 48 | 0 | yes | yes | small 3-subgroups |

## Negative and intermediate cases

The non-liftable family numbers are `1, 2, 4, 5, 6, 9, 10, 17, 18, 21, 22, 23, 24, 25, 26, 33, 41, 52, 53, 54, 112, 114`.

The liftable but non-F-liftable family numbers are `105, 140, 143`.

### Computed obstructions

These are the rows whose negative conclusion is obtained from an explicit strict inverse image, rather than from the reference table or the inheritance shortcut.

| No. | PGL ID | Liftable | F-liftable | Detected obstruction |
|---:|---:|:---:|:---:|---|
| 41 | `[126, --]` | no | no | `C3_non_F_liftable; C3xC3_non_liftable_exponent_9` |
| 105 | `[24, 13]` | yes | no | `C3_non_F_liftable` |
| 112 | `[9, 2]` | no | no | `C3_non_F_liftable; C3xC3_non_liftable_exponent_9` |
| 114 | `[18, 5]` | no | no | `C3_non_F_liftable; C3xC3_non_liftable_exponent_9` |
| 140 | `[3, 1]` | yes | no | `C3_non_F_liftable` |
| 143 | `[6, 2]` | yes | no | `C3_non_F_liftable` |
