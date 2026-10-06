# Exact cyclic powers of maximal Nos. 152, 154, 155 and 156

The four source actions are selected outputs of complete exact-character searches.
Every parent path below is an embedded pair in the pinned verified containment table,
and every saved full action passed exact order, lattice, period, and reload checks.
No. 132 is the identity action and is constructed directly on each source lattice.
Multiple paths are retained separately; matching cyclic characters do not alone prove integral conjugacy.

| Child | Order | Dimension | Parent powers | rank P | rank K | Cyclic order:trace histogram |
| ---: | ---: | ---: | --- | ---: | ---: | --- |
| 132 | 1 | 20 | `152^16, 154^24, 155^32, 156^48` | 22 | 0 | `1:22 (1)` |
| 133 | 2 | 14 | `152^8, 154^12, 155^16, 156^24` | 16 | 6 | `1:22 (1), 2:-10 (1)` |
| 135 | 3 | 10 | `154^8, 156^16` | 22 | 0 | `1:22 (1), 3:-11 (2)` |
| 137 | 4 | 7 | `152^4, 155^8, 156^12` | 16 | 6 | `1:22 (1), 2:-10 (1), 4:6 (2)` |
| 138 | 4 | 7 | `154^6` | 16 | 6 | `1:22 (1), 2:-10 (1), 4:-2 (2)` |
| 139 | 6 | 7 | `154^4, 156^8` | 16 | 6 | `1:22 (1), 2:-10 (1), 3:-11 (2), 6:5 (2)` |
| 144 | 8 | 3 | `155^4, 156^6` | 16 | 6 | `1:22 (1), 2:-10 (1), 4:6 (2), 8:-2 (4)` |
| 145 | 8 | 3 | `152^2` | 16 | 6 | `1:22 (1), 2:-10 (1), 4:6 (2), 8:2 (4)` |
| 146 | 8 | 3 | `154^3` | 16 | 6 | `1:22 (1), 2:-10 (1), 4:-2 (2), 8:2 (4)` |
| 147 | 12 | 3 | `156^4` | 16 | 6 | `1:22 (1), 2:-10 (1), 3:-11 (2), 4:6 (2), 6:5 (2), 12:-3 (4)` |
| 148 | 12 | 3 | `154^2` | 16 | 6 | `1:22 (1), 2:-10 (1), 3:-11 (2), 4:-2 (2), 6:5 (2), 12:1 (4)` |
| 151 | 16 | 1 | `155^2, 156^3` | 16 | 6 | `1:22 (1), 2:-10 (1), 4:6 (2), 8:-2 (4), 16:2 (8)` |
| 153 | 24 | 1 | `156^2` | 16 | 6 | `1:22 (1), 2:-10 (1), 3:-11 (2), 4:6 (2), 6:5 (2), 8:-2 (4), 12:-3 (4), 24:1 (8)` |

## Provenance

- Numbered index and dimension: `remark/input/family_numbering.md`.
- Verified direct containment: `gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_all_pairs.tsv`.
- Selected-output index: `remark/low_rank/maximal_cases/maximal_lattice_action_index.json`.
- No. 152: `remark/low_rank/maximal_cases/brown_results/family_152_phi16_brown_oscar18.mrdi`, output 1, source action 1.
- No. 154: `remark/low_rank/maximal_cases/brown_results/family_154_phi24_brown_oscar18.mrdi`, output 4, source action 4.
- No. 155: `remark/low_rank/maximal_cases/family_155_phi32_oscar18.mrdi`, output 7, source action 13.
- No. 156: `remark/low_rank/maximal_cases/brown_results/family_156_phi48_brown_oscar18.mrdi`, output 2, source action 2.

The MRDI stores `paths["NNN"]["PPP"].data` for every checked child/parent path,
including `S_in_Lambda0`, `T_in_Lambda0`, `T_action`, `P_in_Lambda0`,
`P_action`, `K_in_Lambda0`, and `Lambda0`. Each path also stores its source
and containment provenance. The source's negative eigenvalue pair is known only
up to inversion; this result does not choose an oriented Hodge line or prove
integral conjugacy of actions obtained through different parents.
