# Uniformization of the small symplectic families

The generic full linear group is moved to the displayed Koike coordinates.
The last column records the source of the single additional generator when
the family is special.

| No. | Source | Standard form | Change of coordinates | Generic index | Full index | Relative quotient | Additional generator |
|---:|---|---|---|---:|---:|---:|---|
| 1 | `liftable-abelian-1-PGL-1-1-index-1-dimension-20` | trivial symplectic group | `generic_full_literal_inclusion` | 1 | 1 | 1 | `not_needed` |
| 2 | `liftable-abelian-C2-PGL-2-1-index-1-dimension-12` | C2, Koike (3.1) | `generic_full_coordinate_permutation_inclusion` | 1 | 1 | 1 | `not_needed` |
| 3 | `liftable-abelian-C2^2-PGL-4-2-index-1-dimension-8` | C2^2, Koike (3.2) | `generic_full_coordinate_permutation_inclusion` | 1 | 1 | 1 | `not_needed` |
| 4 | `liftable-abelian-C3-PGL-3-1-index-1-dimension-8` | C3, Koike (3.4) | `generic_full_coordinate_permutation_inclusion` | 1 | 1 | 1 | `not_needed` |
| 5 | `liftable-abelian-C4-PGL-4-1-index-1-dimension-6` | C4, Koike (3.5) | `generic_full_coordinate_permutation_inclusion` | 1 | 1 | 1 | `not_needed` |
| 6 | `small-nonabelian-C3-PGL-6-1-index-2-dimension-8` | C3, Koike (3.3) | `generic_full_linear_embedding` | 2 | 2 | 1 | `not_needed` |
| 7 | `small-nonabelian-S3-PGL-6-1-index-1-dimension-6` | S3, Koike (3.6) | `generic_full_literal_inclusion` | 1 | 1 | 1 | `not_needed` |
| 8 | `small-nonabelian-S3-PGL-12-4-index-2-dimension-6` | S3, corrigendum (0.1) | `generic_full_literal_inclusion` | 2 | 2 | 1 | `not_needed` |

Every row passed three exact checks: the transformed determinant kernel equals
the recorded standard strict lift; the transformed full group contains the
standard generic full group; and that generic group, together with the
additional generator, recovers the full transformed matrix group. The
matrices themselves are stored in `gap_uniformization.out`.
