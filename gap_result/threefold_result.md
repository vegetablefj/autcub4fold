# Cubic-threefold results

The numbered representatives, complete invariant cubic bases, and metadata are in [the family data](threefold_families.g). The complete saved relation and its covers are in [the relation data](threefold_relations.g). These files are display-only exports.

The 40 rows are ordered by increasing source fourfold number. `H` is the strict five-dimensional group and `G = H / <omega I5>` is its projective quotient. Fermat rank refers to the threefold, not to its six-variable suspension. All threefold actions are liftable and F-liftable by the coprime criterion: the cubic degree 3 is coprime to the number of variables 5. These flags are not inherited from the source fourfold.

For both tables, `m = W - C`, where `W` is the dimension of the complete invariant cubic space and `C` is the dimension of the linear centralizer. Every row is saturated. `[order, --]` records a known order without a supplied SmallGroups identifier. Equal abstract group identifiers do not identify matrix actions.

A group relation `i -> j` means a proper embedding up to linear conjugacy. Its geometric direction is reversed: `Z_j subset Z_i`. An action-maximal row has no outgoing group relation; it is geometrically minimal, not geometrically maximal. Covers omit relations with an intermediate classified family.

## Summary

| Quantity | Count |
| --- | ---: |
| Families | 40 |
| Ordered distinct pairs | 1560 |
| Eligible pairs | 493 |
| Excluded by dimension or order | 1067 |
| Positive relations | 260 |
| Direct positive decisions | 260 |
| Positive decisions obtained by transitivity | 0 |
| Negative eligible decisions | 233 |
| Unknown eligible decisions | 0 |
| Covers | 83 |
| Action-maximal families | 7 |
| Liftable families | 40 |
| F-liftable families | 40 |

Excluded pairs were ruled out by the static dimension/order restrictions; they are not additional negative search decisions. Unknowns are recorded separately and are never counted as negatives. The positive relation includes both direct and transitive decisions. Explicit matrix certificates remain in the source calculation modules.

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

## All families

| No. | Source fourfold | Projective group G | Fermat rank | m | W | C | H ID | G ID | Liftable | F-liftable | Action-maximal |
| ---: | ---: | --- | ---: | ---: | ---: | ---: | --- | --- | --- | --- | --- |
| 1 | 1 | $C_3^4:S_5$ | 5 | 0 | 1 | 1 | `[29160, --]` | `[9720, --]` | Yes | Yes | Yes |
| 2 | 7 | $L_2(11)$ | 0 | 0 | 1 | 1 | `[ 1980, 57 ]` | `[ 660, 13 ]` | Yes | Yes | Yes |
| 3 | 8 | $S_5\times C_3$ | 1 | 0 | 2 | 2 | `[ 1080, 490 ]` | `[ 360, 119 ]` | Yes | Yes | Yes |
| 4 | 23 | $S_3\times((C_3^2:C_3):C_2)$ | 2 | 1 | 3 | 2 | `[ 972, 791 ]` | `[ 324, 122 ]` | Yes | Yes | No |
| 5 | 24 | $S_3\times((C_3^2:C_3):C_4)$ | 2 | 0 | 2 | 2 | `[ 1944, 3483 ]` | `[ 648, 541 ]` | Yes | Yes | Yes |
| 6 | 28 | $S_4\times C_3$ | 1 | 1 | 4 | 3 | `[ 216, 163 ]` | `[ 72, 42 ]` | Yes | Yes | No |
| 7 | 30 | $A_5$ | 0 | 1 | 2 | 1 | `[ 180, 19 ]` | `[ 60, 5 ]` | Yes | Yes | No |
| 8 | 32 | $S_5$ | 0 | 1 | 3 | 2 | `[ 360, 119 ]` | `[ 120, 34 ]` | Yes | Yes | No |
| 9 | 36 | $S_3\times C_6$ | 1 | 1 | 5 | 4 | `[ 108, 42 ]` | `[ 36, 12 ]` | Yes | Yes | No |
| 10 | 38 | $(S_3\times S_3):C_2$ | 0 | 1 | 3 | 2 | `[ 216, 157 ]` | `[ 72, 40 ]` | Yes | Yes | No |
| 11 | 56 | $S_3\times C_3$ | 1 | 2 | 8 | 6 | `[ 54, 12 ]` | `[ 18, 3 ]` | Yes | Yes | No |
| 12 | 57 | $S_3\times S_3$ | 0 | 2 | 5 | 3 | `[ 108, 38 ]` | `[ 36, 10 ]` | Yes | Yes | No |
| 13 | 61 | $D_{12}$ | 0 | 2 | 5 | 3 | `[ 36, 12 ]` | `[ 12, 4 ]` | Yes | Yes | No |
| 14 | 62 | $(C_6\times C_2):C_2$ | 0 | 1 | 4 | 3 | `[ 72, 30 ]` | `[ 24, 8 ]` | Yes | Yes | No |
| 15 | 64 | $C_6\times C_2$ | 1 | 2 | 9 | 7 | `[ 36, 14 ]` | `[ 12, 5 ]` | Yes | Yes | No |
| 16 | 67 | $A_4$ | 0 | 2 | 5 | 3 | `[ 36, 11 ]` | `[ 12, 3 ]` | Yes | Yes | No |
| 17 | 69 | $S_4$ | 0 | 2 | 7 | 5 | `[ 72, 42 ]` | `[ 24, 12 ]` | Yes | Yes | No |
| 18 | 72 | $D_{10}$ | 0 | 2 | 5 | 3 | `[ 30, 2 ]` | `[ 10, 1 ]` | Yes | Yes | No |
| 19 | 86 | $S_3$ | 0 | 3 | 8 | 5 | `[ 18, 3 ]` | `[ 6, 1 ]` | Yes | Yes | No |
| 20 | 90 | $C_6$ | 1 | 3 | 14 | 11 | `[ 18, 5 ]` | `[ 6, 2 ]` | Yes | Yes | No |
| 21 | 91 | $D_{12}$ | 0 | 3 | 9 | 6 | `[ 36, 12 ]` | `[ 12, 4 ]` | Yes | Yes | No |
| 22 | 94 | $C_{12}$ | 1 | 1 | 8 | 7 | `[ 36, 8 ]` | `[ 12, 2 ]` | Yes | Yes | No |
| 23 | 95 | $S_3\times C_4$ | 0 | 1 | 5 | 4 | `[ 72, 27 ]` | `[ 24, 5 ]` | Yes | Yes | No |
| 24 | 96 | $C_{24}$ | 1 | 0 | 5 | 5 | `[ 72, 14 ]` | `[ 24, 2 ]` | Yes | Yes | Yes |
| 25 | 101 | $C_2^2$ | 0 | 4 | 11 | 7 | `[ 12, 5 ]` | `[ 4, 2 ]` | Yes | Yes | No |
| 26 | 103 | $D_8$ | 0 | 3 | 9 | 6 | `[ 24, 10 ]` | `[ 8, 3 ]` | Yes | Yes | No |
| 27 | 110 | $C_3$ | 0 | 4 | 13 | 9 | `[ 9, 2 ]` | `[ 3, 1 ]` | Yes | Yes | No |
| 28 | 113 | $C_6$ | 0 | 2 | 9 | 7 | `[ 18, 5 ]` | `[ 6, 2 ]` | Yes | Yes | No |
| 29 | 116 | $C_3$ | 1 | 4 | 21 | 17 | `[ 9, 2 ]` | `[ 3, 1 ]` | Yes | Yes | No |
| 30 | 117 | $S_3$ | 0 | 4 | 14 | 10 | `[ 18, 3 ]` | `[ 6, 1 ]` | Yes | Yes | No |
| 31 | 123 | $C_2$ | 0 | 6 | 19 | 13 | `[ 6, 2 ]` | `[ 2, 1 ]` | Yes | Yes | No |
| 32 | 125 | $C_2^2$ | 0 | 5 | 16 | 11 | `[ 12, 5 ]` | `[ 4, 2 ]` | Yes | Yes | No |
| 33 | 130 | $C_4\times C_2$ | 0 | 2 | 9 | 7 | `[ 24, 9 ]` | `[ 8, 2 ]` | Yes | Yes | No |
| 34 | 135 | $1$ | 0 | 10 | 35 | 25 | `[ 3, 1 ]` | `[ 1, 1 ]` | Yes | Yes | No |
| 35 | 139 | $C_2$ | 0 | 7 | 24 | 17 | `[ 6, 2 ]` | `[ 2, 1 ]` | Yes | Yes | No |
| 36 | 147 | $C_4$ | 0 | 3 | 14 | 11 | `[ 12, 2 ]` | `[ 4, 1 ]` | Yes | Yes | No |
| 37 | 148 | $C_4$ | 0 | 3 | 12 | 9 | `[ 12, 2 ]` | `[ 4, 1 ]` | Yes | Yes | No |
| 38 | 153 | $C_8$ | 0 | 1 | 8 | 7 | `[ 24, 2 ]` | `[ 8, 1 ]` | Yes | Yes | No |
| 39 | 154 | $C_8$ | 0 | 1 | 6 | 5 | `[ 24, 2 ]` | `[ 8, 1 ]` | Yes | Yes | Yes |
| 40 | 156 | $C_{16}$ | 0 | 0 | 5 | 5 | `[ 48, 2 ]` | `[ 16, 1 ]` | Yes | Yes | Yes |

## Extremal rows

Action-maximal (geometrically minimal): `{1, 2, 3, 5, 24, 39, 40}`.

Geometrically maximal: `{34}`.

## Complete relation, covers, and action-maximal targets

The second column lists the full positive relation, including transitive pairs. The third lists only covers. All reachable action-maximal targets appear in the fourth; an action-maximal row lists itself there.

| No. | All positive group targets | Cover targets | Action-maximal targets |
| ---: | --- | --- | --- |
| 1 | `{}` | `{}` | `{1}` |
| 2 | `{}` | `{}` | `{2}` |
| 3 | `{}` | `{}` | `{3}` |
| 4 | `{1, 5}` | `{1, 5}` | `{1, 5}` |
| 5 | `{}` | `{}` | `{5}` |
| 6 | `{1, 3}` | `{1, 3}` | `{1, 3}` |
| 7 | `{1, 2}` | `{1, 2}` | `{1, 2}` |
| 8 | `{1, 3}` | `{1, 3}` | `{1, 3}` |
| 9 | `{1, 3}` | `{1, 3}` | `{1, 3}` |
| 10 | `{1}` | `{1}` | `{1}` |
| 11 | `{1, 3, 4, 5, 6, 9}` | `{4, 6, 9}` | `{1, 3, 5}` |
| 12 | `{1, 4, 5, 10}` | `{4, 10}` | `{1, 5}` |
| 13 | `{1, 2, 10, 14}` | `{2, 10, 14}` | `{1, 2}` |
| 14 | `{1}` | `{1}` | `{1}` |
| 15 | `{1, 3, 6, 9}` | `{6, 9}` | `{1, 3}` |
| 16 | `{1, 2, 3, 6, 7}` | `{6, 7}` | `{1, 2, 3}` |
| 17 | `{1, 3, 6, 8}` | `{6, 8}` | `{1, 3}` |
| 18 | `{1, 2, 3, 7, 8}` | `{7, 8}` | `{1, 2, 3}` |
| 19 | `{1, 2, 4, 5, 7, 10, 12, 13, 14}` | `{7, 12, 13}` | `{1, 2, 5}` |
| 20 | `{1, 3, 4, 5, 6, 9, 11, 15, 22, 24}` | `{11, 15, 22}` | `{1, 3, 5, 24}` |
| 21 | `{1, 3, 4, 5, 8, 9, 10, 12, 23}` | `{8, 9, 12, 23}` | `{1, 3, 5}` |
| 22 | `{5, 24}` | `{5, 24}` | `{5, 24}` |
| 23 | `{5}` | `{5}` | `{5}` |
| 24 | `{}` | `{}` | `{24}` |
| 25 | `{1, 2, 3, 6, 7, 8, 10, 13, 14, 16, 17, 26}` | `{13, 16, 26}` | `{1, 2, 3}` |
| 26 | `{1, 3, 6, 8, 10, 14, 17}` | `{10, 14, 17}` | `{1, 3}` |
| 27 | `{1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 16, 19, 28}` | `{11, 16, 19, 28}` | `{1, 2, 3, 5}` |
| 28 | `{1, 3, 9, 14}` | `{9, 14}` | `{1, 3}` |
| 29 | `{1, 3, 4, 5, 6, 9, 11, 15, 20, 22, 24}` | `{20}` | `{1, 3, 5, 24}` |
| 30 | `{1, 3, 4, 5, 6, 8, 9, 10, 11, 12, 17, 21, 23}` | `{11, 17, 21}` | `{1, 3, 5}` |
| 31 | `{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 25, 26, 32, 33}` | `{18, 19, 25, 32}` | `{1, 2, 3, 5}` |
| 32 | `{1, 3, 4, 5, 6, 8, 9, 10, 12, 14, 15, 17, 21, 23, 26, 33}` | `{15, 21, 26, 33}` | `{1, 3, 5}` |
| 33 | `{5, 23}` | `{23}` | `{5}` |
| 34 | `{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39, 40}` | `{27, 29, 31, 35}` | `{1, 2, 3, 5, 24, 39, 40}` |
| 35 | `{1, 3, 4, 5, 6, 8, 9, 10, 11, 12, 14, 15, 17, 20, 21, 22, 23, 24, 26, 28, 30, 32, 33, 36, 37, 38, 39, 40}` | `{20, 28, 30, 32, 36, 37}` | `{1, 3, 5, 24, 39, 40}` |
| 36 | `{5, 22, 23, 24, 33, 38, 40}` | `{22, 33, 38}` | `{5, 24, 40}` |
| 37 | `{5, 23, 33, 39}` | `{33, 39}` | `{5, 39}` |
| 38 | `{24, 40}` | `{24, 40}` | `{24, 40}` |
| 39 | `{}` | `{}` | `{39}` |
| 40 | `{}` | `{}` | `{40}` |
