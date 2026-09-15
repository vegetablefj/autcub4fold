# Non-liftable abelian results

The two supplied candidates have the following saved data. Here `H` is the
strict linear group, `G = H/mu_3`, and the centralizer dimension is in GL.
Both projective actions are non-liftable.

| Candidate | Linear group / GAP ID | Projective group / GAP ID | Symplectic part | Full index | Invariant dimension | Centralizer dimension | Family dimension |
|---|---|---|---|---:|---:|---:|---:|
| `NLA-001` | `C9 : C3` / `[27,4]` | `C3 x C3` / `[9,2]` | `C3` | 3 | 6 | 4 | 2 |
| `NLA-002` | `C2 x (C9 : C3)` / `[54,11]` | `C6 x C3` / `[18,5]` | `C3` | 6 | 3 | 2 | 1 |

For both records, the scalar subgroup has order 3 and the determinant-one
subgroup has order 9. The projective symplectic subgroup has GAP ID `[3,1]`
and coinvariant rank 12. Both records have `genericIndex = 1`; the
full-index column corresponds to the separate field `fullIndex`. See the
[field conventions](gap_nonliftable_abelian_script.md#record-fields).

## Invariant bases

Generators `P`, `D`, and `T` are defined in
[gap_nonliftable_abelian_data.g](gap_nonliftable_abelian_data.g).
All bases below retain the order in that file.

### NLA-001

The linear group is `<P,D>`. Its invariant basis `F_1,...,F_6` is:

```text
x5*x6^2 + x4*x5^2 + x4^2*x6
x3*x4^2 + x2*x6^2 + x1*x5^2
x3*x5*x6 + x2*x4*x5 + x1*x4*x6
x2*x3*x6 + x1*x3*x4 + x1*x2*x5
x3^2*x5 + x2^2*x4 + x1^2*x6
x2*x3^2 + x1*x2^2 + x1^2*x3
```

### NLA-002

The linear group is `<P,D,T>`. Its invariant basis `F_1,F_2,F_3` is:

```text
x3*x4^2 + x2*x6^2 + x1*x5^2
x3*x5*x6 + x2*x4*x5 + x1*x4*x6
x2*x3^2 + x1*x2^2 + x1^2*x3
```

## Saved smoothness verification

The existing exact characteristic-zero computations in
[gap_large_abelian_smoothness.out](../gap_smoothness/gap_large_abelian_smoothness.out)
verify the following smooth members `sum(c_i F_i)`, using the basis
orders above:

| Candidate | Coefficients | Saved status |
|---|---|---|
| `NLA-001` | `[2,5,10,17,26,37]` | `exact_smooth` |
| `NLA-002` | `[2,5,10]` | `exact_smooth` |

In both cases the projective Jacobian locus is empty. The same saved run
independently verifies invariant dimensions 6 and 3, GL centralizer
dimensions 4 and 2, and family dimensions 2 and 1. It used GAP `4.12.1`
and Singular in WSL (Ubuntu). These certificates have not been rerun as
part of this documentation cleanup.

A lightweight exact audit also confirms the matrix-group orders, scalar
and determinant kernels, invariant monomial orbit sums, and centralizer
dimensions. A separate Windows GAP `4.15.1` input audit rechecks both
linear and projective GAP IDs and the determinant indices after separating
`genericIndex` from `fullIndex`.

Comparing the former and corrected index metadata in memory leaves all
184 normalized records' operational fields and the input summary unchanged:
source keys, matrix generators, dimensions, and saturation tags agree.
No enumeration, smoothness test, or containment search was repeated, and
the existing result files and runtime logs required no changes.
