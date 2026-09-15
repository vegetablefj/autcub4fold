# Cubic-threefold families and containment

The 40 families are numbered by increasing source fourfold number. Their five-dimensional strict groups and complete cubic bases are in [the final catalogue](gap_threefold_families.g). The [coordinate verification](gap_threefold_coordinate_audit.out) identifies them with [the extracted groups](gap_threefold_extracted_families.g).

A group relation `i -> j` means that `H_i` is linearly conjugate to a proper subgroup of `H_j`. The geometric inclusion is `Z_j subset Z_i`. An action-maximal row has no outgoing group relation; it is not a geometrically maximal family.

## Summary

| Quantity | Count |
| --- | ---: |
| Fourfold sources selected | 63 |
| Sources with a Fermat summand | 40 |
| Sources without a Fermat summand | 23 |
| Threefold families | 40 |
| Ordered distinct pairs | 1560 |
| Eligible pairs | 493 |
| Pairs excluded by dimension or order | 1067 |
| Positive relations | 260 |
| Negative eligible decisions | 233 |
| Undecided pairs | 0 |
| Cover relations | 83 |
| Action-maximal families | 7 |

The relation comes from the direct five-dimensional calculation. All positive `5 x 5` matrices have been checked on every source generator. Every eligible pair has a resolved decision, and all ordered distinct pairs are recorded. Independently, the complete relation agrees pair by pair with the relation induced from the completed fourfold calculation. The transitive closure of the covers recovers the full positive relation. The saved decisions and matrices are in [the direct pair result](gap_threefold_cross_dimension_all_pairs.g) and [the containment audit](gap_threefold_containment.out).

## Action-maximal families

| No. | Source fourfold | Projective group | Dimension | GL order | PGL order | GL ID | PGL ID |
| ---: | ---: | --- | ---: | ---: | ---: | --- | --- |
| 1 | 1 | `(C3^4):S5` | 0 | 29160 | 9720 | `[29160, --]` | `[9720, --]` |
| 2 | 7 | `L2(11)` | 0 | 1980 | 660 | `[ 1980, 57 ]` | `[ 660, 13 ]` |
| 3 | 8 | `S5 x C3` | 0 | 1080 | 360 | `[ 1080, 490 ]` | `[ 360, 119 ]` |
| 5 | 24 | `S3 x ((C3^2:C3):C4)` | 0 | 1944 | 648 | `[ 1944, 3483 ]` | `[ 648, 541 ]` |
| 24 | 96 | `C24` | 0 | 72 | 24 | `[ 72, 14 ]` | `[ 24, 2 ]` |
| 39 | 154 | `C8` | 1 | 24 | 8 | `[ 24, 2 ]` | `[ 8, 1 ]` |
| 40 | 156 | `C16` | 0 | 48 | 16 | `[ 48, 2 ]` | `[ 16, 1 ]` |

## All 40 families

Here `dim W` is the dimension of the complete invariant cubic space, `dim C` is the dimension of its linear centralizer, and the family dimension is `dim W - dim C`. In `[order, --]`, the order is known but the installed SmallGroups library has no ID. Identical abstract group data do not identify a matrix action.

| No. | Source fourfold | Projective group | Dimension | Fermat rank | dim W | dim C | GL order | PGL order | GL ID | PGL ID |
| ---: | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |
| 1 | 1 | `(C3^4):S5` | 0 | 5 | 1 | 1 | 29160 | 9720 | `[29160, --]` | `[9720, --]` |
| 2 | 7 | `L2(11)` | 0 | 0 | 1 | 1 | 1980 | 660 | `[ 1980, 57 ]` | `[ 660, 13 ]` |
| 3 | 8 | `S5 x C3` | 0 | 1 | 2 | 2 | 1080 | 360 | `[ 1080, 490 ]` | `[ 360, 119 ]` |
| 4 | 23 | `S3 x ((C3^2:C3):C2)` | 1 | 2 | 3 | 2 | 972 | 324 | `[ 972, 791 ]` | `[ 324, 122 ]` |
| 5 | 24 | `S3 x ((C3^2:C3):C4)` | 0 | 2 | 2 | 2 | 1944 | 648 | `[ 1944, 3483 ]` | `[ 648, 541 ]` |
| 6 | 28 | `S4 x C3` | 1 | 1 | 4 | 3 | 216 | 72 | `[ 216, 163 ]` | `[ 72, 42 ]` |
| 7 | 30 | `A5` | 1 | 0 | 2 | 1 | 180 | 60 | `[ 180, 19 ]` | `[ 60, 5 ]` |
| 8 | 32 | `S5` | 1 | 0 | 3 | 2 | 360 | 120 | `[ 360, 119 ]` | `[ 120, 34 ]` |
| 9 | 36 | `S3 x C6` | 1 | 1 | 5 | 4 | 108 | 36 | `[ 108, 42 ]` | `[ 36, 12 ]` |
| 10 | 38 | `(S3 x S3):C2` | 1 | 0 | 3 | 2 | 216 | 72 | `[ 216, 157 ]` | `[ 72, 40 ]` |
| 11 | 56 | `S3 x C3` | 2 | 1 | 8 | 6 | 54 | 18 | `[ 54, 12 ]` | `[ 18, 3 ]` |
| 12 | 57 | `S3 x S3` | 2 | 0 | 5 | 3 | 108 | 36 | `[ 108, 38 ]` | `[ 36, 10 ]` |
| 13 | 61 | `D12` | 2 | 0 | 5 | 3 | 36 | 12 | `[ 36, 12 ]` | `[ 12, 4 ]` |
| 14 | 62 | `(C6 x C2):C2` | 1 | 0 | 4 | 3 | 72 | 24 | `[ 72, 30 ]` | `[ 24, 8 ]` |
| 15 | 64 | `C6 x C2` | 2 | 1 | 9 | 7 | 36 | 12 | `[ 36, 14 ]` | `[ 12, 5 ]` |
| 16 | 67 | `A4` | 2 | 0 | 5 | 3 | 36 | 12 | `[ 36, 11 ]` | `[ 12, 3 ]` |
| 17 | 69 | `S4` | 2 | 0 | 7 | 5 | 72 | 24 | `[ 72, 42 ]` | `[ 24, 12 ]` |
| 18 | 72 | `D10` | 2 | 0 | 5 | 3 | 30 | 10 | `[ 30, 2 ]` | `[ 10, 1 ]` |
| 19 | 86 | `S3` | 3 | 0 | 8 | 5 | 18 | 6 | `[ 18, 3 ]` | `[ 6, 1 ]` |
| 20 | 90 | `C6` | 3 | 1 | 14 | 11 | 18 | 6 | `[ 18, 5 ]` | `[ 6, 2 ]` |
| 21 | 91 | `D12` | 3 | 0 | 9 | 6 | 36 | 12 | `[ 36, 12 ]` | `[ 12, 4 ]` |
| 22 | 94 | `C12` | 1 | 1 | 8 | 7 | 36 | 12 | `[ 36, 8 ]` | `[ 12, 2 ]` |
| 23 | 95 | `S3 x C4` | 1 | 0 | 5 | 4 | 72 | 24 | `[ 72, 27 ]` | `[ 24, 5 ]` |
| 24 | 96 | `C24` | 0 | 1 | 5 | 5 | 72 | 24 | `[ 72, 14 ]` | `[ 24, 2 ]` |
| 25 | 101 | `C2^2` | 4 | 0 | 11 | 7 | 12 | 4 | `[ 12, 5 ]` | `[ 4, 2 ]` |
| 26 | 103 | `D8` | 3 | 0 | 9 | 6 | 24 | 8 | `[ 24, 10 ]` | `[ 8, 3 ]` |
| 27 | 110 | `C3` | 4 | 0 | 13 | 9 | 9 | 3 | `[ 9, 2 ]` | `[ 3, 1 ]` |
| 28 | 113 | `C6` | 2 | 0 | 9 | 7 | 18 | 6 | `[ 18, 5 ]` | `[ 6, 2 ]` |
| 29 | 116 | `C3` | 4 | 1 | 21 | 17 | 9 | 3 | `[ 9, 2 ]` | `[ 3, 1 ]` |
| 30 | 117 | `S3` | 4 | 0 | 14 | 10 | 18 | 6 | `[ 18, 3 ]` | `[ 6, 1 ]` |
| 31 | 123 | `C2` | 6 | 0 | 19 | 13 | 6 | 2 | `[ 6, 2 ]` | `[ 2, 1 ]` |
| 32 | 125 | `C2^2` | 5 | 0 | 16 | 11 | 12 | 4 | `[ 12, 5 ]` | `[ 4, 2 ]` |
| 33 | 130 | `C4 x C2` | 2 | 0 | 9 | 7 | 24 | 8 | `[ 24, 9 ]` | `[ 8, 2 ]` |
| 34 | 135 | `1` | 10 | 0 | 35 | 25 | 3 | 1 | `[ 3, 1 ]` | `[ 1, 1 ]` |
| 35 | 139 | `C2` | 7 | 0 | 24 | 17 | 6 | 2 | `[ 6, 2 ]` | `[ 2, 1 ]` |
| 36 | 147 | `C4` | 3 | 0 | 14 | 11 | 12 | 4 | `[ 12, 2 ]` | `[ 4, 1 ]` |
| 37 | 148 | `C4` | 3 | 0 | 12 | 9 | 12 | 4 | `[ 12, 2 ]` | `[ 4, 1 ]` |
| 38 | 153 | `C8` | 1 | 0 | 8 | 7 | 24 | 8 | `[ 24, 2 ]` | `[ 8, 1 ]` |
| 39 | 154 | `C8` | 1 | 0 | 6 | 5 | 24 | 8 | `[ 24, 2 ]` | `[ 8, 1 ]` |
| 40 | 156 | `C16` | 0 | 0 | 5 | 5 | 48 | 16 | `[ 48, 2 ]` | `[ 16, 1 ]` |

## Group covers and action-maximal targets

Cover targets use the group direction `i -> j`, so `Z_j subset Z_i`. All reachable action-maximal targets are listed; an action-maximal row lists itself. Paths are retained in the GAP-readable audit.

| No. | Group cover targets | All action-maximal targets |
| ---: | --- | --- |
| 1 | `{}` | `{1}` |
| 2 | `{}` | `{2}` |
| 3 | `{}` | `{3}` |
| 4 | `{1, 5}` | `{1, 5}` |
| 5 | `{}` | `{5}` |
| 6 | `{1, 3}` | `{1, 3}` |
| 7 | `{1, 2}` | `{1, 2}` |
| 8 | `{1, 3}` | `{1, 3}` |
| 9 | `{1, 3}` | `{1, 3}` |
| 10 | `{1}` | `{1}` |
| 11 | `{4, 6, 9}` | `{1, 3, 5}` |
| 12 | `{4, 10}` | `{1, 5}` |
| 13 | `{2, 10, 14}` | `{1, 2}` |
| 14 | `{1}` | `{1}` |
| 15 | `{6, 9}` | `{1, 3}` |
| 16 | `{6, 7}` | `{1, 2, 3}` |
| 17 | `{6, 8}` | `{1, 3}` |
| 18 | `{7, 8}` | `{1, 2, 3}` |
| 19 | `{7, 12, 13}` | `{1, 2, 5}` |
| 20 | `{11, 15, 22}` | `{1, 3, 5, 24}` |
| 21 | `{8, 9, 12, 23}` | `{1, 3, 5}` |
| 22 | `{5, 24}` | `{5, 24}` |
| 23 | `{5}` | `{5}` |
| 24 | `{}` | `{24}` |
| 25 | `{13, 16, 26}` | `{1, 2, 3}` |
| 26 | `{10, 14, 17}` | `{1, 3}` |
| 27 | `{11, 16, 19, 28}` | `{1, 2, 3, 5}` |
| 28 | `{9, 14}` | `{1, 3}` |
| 29 | `{20}` | `{1, 3, 5, 24}` |
| 30 | `{11, 17, 21}` | `{1, 3, 5}` |
| 31 | `{18, 19, 25, 32}` | `{1, 2, 3, 5}` |
| 32 | `{15, 21, 26, 33}` | `{1, 3, 5}` |
| 33 | `{23}` | `{5}` |
| 34 | `{27, 29, 31, 35}` | `{1, 2, 3, 5, 24, 39, 40}` |
| 35 | `{20, 28, 30, 32, 36, 37}` | `{1, 3, 5, 24, 39, 40}` |
| 36 | `{22, 33, 38}` | `{5, 24, 40}` |
| 37 | `{33, 39}` | `{5, 39}` |
| 38 | `{24, 40}` | `{24, 40}` |
| 39 | `{}` | `{39}` |
| 40 | `{}` | `{40}` |

## Geometric family incidence

`#i: {j, ...}` lists the classified families `Z_j` that properly contain `Z_i`, with no classified family strictly between them. This reverses group containment. `{}` means that no classified family properly contains `Z_i`. These 40 lines contain all 83 adjacent incidences.

```text
#1: {4, 6, 7, 8, 9, 10, 14}
#2: {7, 13}
#3: {6, 8, 9}
#4: {11, 12}
#5: {4, 22, 23}
#6: {11, 15, 16, 17}
#7: {16, 18, 19}
#8: {17, 18, 21}
#9: {11, 15, 21, 28}
#10: {12, 13, 26}
#11: {20, 27, 30}
#12: {19, 21}
#13: {19, 25}
#14: {13, 26, 28}
#15: {20, 32}
#16: {25, 27}
#17: {26, 30}
#18: {31}
#19: {27, 31}
#20: {29, 35}
#21: {30, 32}
#22: {20, 36}
#23: {21, 33}
#24: {22, 38}
#25: {31}
#26: {25, 32}
#27: {34}
#28: {27, 35}
#29: {34}
#30: {35}
#31: {34}
#32: {31, 35}
#33: {32, 36, 37}
#34: {}
#35: {34}
#36: {35}
#37: {35}
#38: {36}
#39: {37}
#40: {38}
```

## Family dimensions

| Dimension | Families |
| ---: | ---: |
| 0 | 6 |
| 1 | 11 |
| 2 | 9 |
| 3 | 6 |
| 4 | 4 |
| 5 | 1 |
| 6 | 1 |
| 7 | 1 |
| 10 | 1 |
