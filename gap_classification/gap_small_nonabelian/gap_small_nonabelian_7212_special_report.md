# Specialized `G_s=C3`, `G=[72,12]` calculation

## Exact enumeration

- Four-weight multisets tested: `17550`.
- Multisets satisfying the Hodge-character and square-monomial conditions: `8`.
- Orbits under `a -> a^+-1` and `t -> t^v` for odd `v`: `1`.
- `(2,2,2)` parameters with faithful `C8` Hodge character: `0`.

The retained normalized weight multisets are:

- `[ [ 1, 0 ], [ 1, 1 ], [ 1, 4 ], [ 1, 6 ] ]`
- `[ [ 1, 0 ], [ 1, 2 ], [ 1, 3 ], [ 1, 4 ] ]`
- `[ [ 1, 0 ], [ 1, 2 ], [ 1, 4 ], [ 1, 7 ] ]`
- `[ [ 1, 0 ], [ 1, 4 ], [ 1, 5 ], [ 1, 6 ] ]`
- `[ [ 2, 0 ], [ 2, 1 ], [ 2, 4 ], [ 2, 6 ] ]`
- `[ [ 2, 0 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ] ]`
- `[ [ 2, 0 ], [ 2, 2 ], [ 2, 4 ], [ 2, 7 ] ]`
- `[ [ 2, 0 ], [ 2, 4 ], [ 2, 5 ], [ 2, 6 ] ]`

Their unique orbit representative is `[ [ 1, 0 ], [ 1, 1 ], [ 1, 4 ], [ 1, 6 ] ]`.

## Unique smooth family

- Projective group `G`: `[72,12]`.
- Strict lift `H`: `[ 216, 82 ]`, of order `216`.
- Determinant kernel: `[ 9, 2 ]`, of order `9`.
- `dim W_H = 5`, `dim C_GL6(H) = 5`, and `m = 0`.
- Exact smoothness status: `exact_smooth`.

Compact strict generators, with `zeta_n=E(n)`, are

- `A=diag(1,1,zeta_3,zeta_3,zeta_3,zeta_3)`,
- `B=diag(zeta_3,zeta_3^2,1,1,1,1)`,
- `T=P_(12) diag(1,1,1,zeta_8,-1,-zeta_4)`,
- `Z=zeta_3 I_6`.

An invariant basis is

- `$x5*x6^2$`
- `$x4^2*x6$`
- `$x3*x5^2$`
- `$x3^3$`
- `$x2^3 + x1^3$`

All five coefficients equal to one give the exact smooth witness certified by Singular.

## Saturation

The strict lift of the projective group `G=[72,12]` embeds in the strict lift of the projective group `S3 x C24` of projective ID `[ 144, 69 ]` with index `2`.  Both families have `m=0`.

- Strict containment status: `embedded`.
- Method: `A_strict`.
- Explicit conjugating matrix verified: `true`.
- Conjugating matrix: `[ [ 0, 0, 0, 0, -2, 0 ], [ 0, 0, 0, 0, 0, -2 ], [ 0, 0, 0, -3, 0, 0 ], [ -4, 0, 0, 0, 0, 0 ], [ 0, 0, -3, 0, 0, 0 ], [ 0, 4, 0, 0, 0, 0 ] ]`.
- Removed by saturation: `true`.
