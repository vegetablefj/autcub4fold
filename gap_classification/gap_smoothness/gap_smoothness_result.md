# Smoothness results

## Scope

This document summarizes the recorded smoothness calculations for three
classes of candidate families. Their roles are different.

- The rank-at-least-15 calculation is a verification. Its supplied list
  contains 76 candidate records;
  the computation supplies an explicit smooth member for each one.
- The abelian calculation is also a verification. The theoretical
  classification supplies the 53 liftable and two non-liftable families; the
  computation supplies an explicit smooth member for each one.
- The small non-abelian calculation is a screening. It separates the retained
  representation-theoretic candidates into generically smooth families,
  invariant spaces that are entirely singular, and unresolved cases.

These calculations do not test equivalence, containment, saturation, or complex self-conjugacy.

## Summary

| Class | Role | Input | `smooth` | `singular` | `unknown` |
|---|---|---:|---:|---:|---:|
| Rank at least 15 | verification | 76 | 76 | 0 | 0 |
| Abelian | verification | 55 | 55 | 0 | 0 |
| Small non-abelian | screening | 182 | 46 | 129 | 7 |

Thus 177 candidate records have a recorded smooth-member certificate.
These are counts before equivalence and saturation reduction, not counts
of distinct final families. The seven unresolved small non-abelian records
are not included in this number.

Here `smooth` means that an explicit smooth cubic was found in the invariant vector space. It follows that a nonempty Zariski-open subset of that family is smooth. For the small non-abelian screening, `singular` is recorded only when one certificate proves that every member of the invariant vector space is singular. The status `unknown` is retained when neither conclusion is certified.

## Rank-at-least-15 families

The input consists of the 76 records in `../gap_saturation/gap_large_koike_families.g`. For every record, the script reconstructs the invariant cubic space and the matrix centralizer from the strict linear generators. It verifies the stored invariant-space, centralizer, and family dimensions before testing a member.

All 76 dimension audits pass. All 76 families have an explicit characteristic-zero smooth member. No family is removed by this calculation.

| Family dimension | Number verified smooth |
|---:|---:|
| 0 | 13 |
| 1 | 23 |
| 2 | 26 |
| 3 | 5 |
| 4 | 8 |
| 5 | 1 |
| **Total** | **76** |

The computation verifies geometric realizability of the stored families. Their saturation and complex self-conjugacy properties are handled separately.

## Abelian families

The abelian input contains 53 liftable families and two non-liftable families. The liftable records come from `../gap_liftable_abelian/gap_liftable_abelian_data.g`. The non-liftable records come from `../gap_nonliftable_abelian/gap_nonliftable_abelian_data.g`.

The script reconstructs the invariant cubic space and centralizer for each record. All 55 dimension audits pass, and every family has an explicit characteristic-zero smooth member. This calculation confirms the theoretically obtained list; it does not filter it.

| Family dimension | Liftable | Non-liftable | Total verified smooth |
|---:|---:|---:|---:|
| 0 | 2 | 0 | 2 |
| 1 | 5 | 1 | 6 |
| 2 | 7 | 1 | 8 |
| 3 | 8 | 0 | 8 |
| 4 | 9 | 0 | 9 |
| 5 | 4 | 0 | 4 |
| 6 | 4 | 0 | 4 |
| 7 | 5 | 0 | 5 |
| 8 | 3 | 0 | 3 |
| 10 | 3 | 0 | 3 |
| 12 | 1 | 0 | 1 |
| 14 | 1 | 0 | 1 |
| 20 | 1 | 0 | 1 |
| **Total** | **53** | **2** | **55** |

## Small non-abelian families

The representation enumeration first produces 202 raw candidates. The González restriction removes 20 of them. The smoothness script reads the remaining 182 records in their stored order. It does not repeat the representation enumeration or the González test.

The final screening gives 46 generically smooth families, 129 entirely singular invariant spaces, and seven unresolved records.

### Results by symplectic part

| Symplectic part | Tested | `smooth` | `singular` | `unknown` |
|---|---:|---:|---:|---:|
| `C3` | 29 | 9 | 20 | 0 |
| `C2^2` | 30 | 9 | 18 | 3 |
| `C4` | 24 | 5 | 17 | 2 |
| `S3` | 99 | 23 | 74 | 2 |
| **Total** | **182** | **46** | **129** | **7** |

### Results by family dimension

| Expected family dimension | `smooth` | `singular` | `unknown` | Total |
|---:|---:|---:|---:|---:|
| 0 | 6 | 79 | 1 | 86 |
| 1 | 11 | 26 | 5 | 42 |
| 2 | 9 | 20 | 1 | 30 |
| 3 | 11 | 4 | 0 | 15 |
| 4 | 4 | 0 | 0 | 4 |
| 5 | 1 | 0 | 0 | 1 |
| 6 | 3 | 0 | 0 | 3 |
| 8 | 1 | 0 | 0 | 1 |
| **Total** | **46** | **129** | **7** | **182** |

### Recorded certificates

| Result or certificate | Count |
|---|---:|
| Explicit smooth member | 46 |
| Nonempty exact common projective Jacobian locus | 48 |
| A variable has exponent at most one throughout the family | 53 |
| Exact common singular point for the invariant basis | 28 |
| No completed certificate | 7 |

The three singularity-certificate counts add to 129. A singular test member
is never used as a family-wide certificate. The 48 common-locus certificates
record a nonempty projective chart over the algebraic closure, not
necessarily explicit point coordinates.

All 46 small non-abelian smooth witnesses were certified by smooth reduction
at a good split prime and successfully rechecked individually. The large
and abelian witnesses, by contrast, were tested directly in characteristic
zero.

The unresolved records are:

| Candidate | Symplectic part | Expected dimension | Projective ID | Strict linear ID |
|---:|---|---:|---|---|
| 37 | `C2^2` | 2 | `[8,3]` | `[24,10]` |
| 42 | `C2^2` | 1 | `[16,6]` | `[48,24]` |
| 59 | `C2^2` | 1 | `[24,10]` | `[72,37]` |
| 71 | `C4` | 1 | `[8,4]` | `[24,11]` |
| 80 | `C4` | 1 | `[24,10]` | `[72,37]` |
| 139 | `S3` | 1 | `[24,5]` | `[72,27]` |
| 200 | `S3` | 0 | `[72,27]` | `[216,136]` |

These records remain `unknown` in the machine-readable output. All seven
systems are proved singular by the exact arguments in
the accompanying paper's Appendix A; these arguments do not change the automatic
counts. The dimensions of singular and unresolved
invariant spaces are expected dimensions, not dimensions of nonempty
smooth moduli families.

For all seven, the exact common-locus test completed with
`no_common_singular_point`. This does not prove smoothness: singular points
may depend on the member. The unresolved status is not a timeout-based
singularity claim.

### Saved-certificate consistency checks

A separate GAP-only audit loaded the saved inputs and results without
calling Singular. All 46 small-group witness coefficient vectors reproduce
their recorded polynomials. All 81 explicit common points, including the
53 coordinate points, are nonzero and annihilate every basis partial.
The 48 common-locus records retain successful exit and completion metadata.
All small-group IDs, dimensions, candidate orders, and status-summary lists
agree with the saved inputs. This consistency audit used Windows GAP
`4.15.1`; it did not repeat the WSL Gröbner-basis calculations.

## Recorded files

The large and abelian verification is recorded in:

- [`gap_large_abelian_smoothness.log`](gap_large_abelian_smoothness.log), containing the dimension audits, progress, and runtime;
- [`gap_large_abelian_smoothness.out`](gap_large_abelian_smoothness.out), containing GAP-readable certificates and explicit smooth cubics.

The small non-abelian screening is recorded in:

- [`gap_small_nonabelian_smoothness.log`](gap_small_nonabelian_smoothness.log), containing the numbered screening and proof-type totals;
- [`gap_small_nonabelian_smoothness.out`](gap_small_nonabelian_smoothness.out), containing every status and its certificate data in GAP-readable form.

Both recorded runs used WSL (Ubuntu), GAP `4.12.1`,
`/usr/bin/Singular`, and GNU `/usr/bin/timeout`.
The recorded `Runtime()` values are 9,866 ms for the large/abelian
verification and 5,094 ms for the small screening; they are not portable
wall-clock performance estimates.

Certificates are matched to the saved inputs by source category and
position, or by the enumeration candidate number. Those numbers are not
final-table row numbers. The output files do not duplicate every input
matrix group and invariant basis.

Standalone Singular input and transcript files are not included in the
repository. They are created in GAP-managed temporary directories, for
which cleanup is attempted at GAP exit. Relevant output text is retained
inside screening result records. See
[gap_smoothness_script.md](gap_smoothness_script.md) for the exact criteria,
options, and temporary-file behavior.
