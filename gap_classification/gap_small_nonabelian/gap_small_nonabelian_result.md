# Small non-abelian computation results

## Recorded run

The completed serial run used GAP 4.15.1 and the audited liftable engine
`gap_small_nonabelian_liftable_engine.g`.

The projective candidate groups were selected from the Yang–Yu–Zhu bounds,
with the ordered IDs recorded in
[gap_small_nonabelian_script.md](gap_small_nonabelian_script.md). The calculation used the final
non-abelian target lists, the generic-index divisibility condition, the exact
strict generic-full-group containment condition, and the invariant version of
the González--Aguilera--Liendo necessary restriction. The projective group
`[72,12]` in the `C3` case was omitted by a separate mathematical exclusion,
not by this enumeration. Smoothness and saturation were not tested in this run.

The four cases were processed in the order `C3`, `C2^2`, `C4`, `S3`. The
enumeration produced 201 families. The known `S3 x C24` action was then
appended directly, giving 202 candidates before the González restriction.
The restriction retained 182 candidates and rejected 20.

## Summary

The “Rejected by generic containment” column counts deduplicated
representations rejected before the final candidate list was formed. The
González columns concern the
202 candidates that survived all preceding representation and containment
conditions.

| Symplectic part | Projective inputs | Enumerated families | Direct cases | Rejected by generic containment | Before González | Retained | Rejected |
|---|---:|---:|---:|---:|---:|---:|---:|
| `C3` | 10 | 33 | 0 | 883 | 33 | 29 | 4 |
| `C2^2` | 5 | 37 | 0 | 0 | 37 | 30 | 7 |
| `C4` | 4 | 26 | 0 | 0 | 26 | 24 | 2 |
| `S3` | 12 | 105 | 1 | 1294 | 106 | 99 | 7 |
| **Total** | **31** | **201** | **1** | **2177** | **202** | **182** | **20** |

Candidate numbers refer to the 202-record order before the González
restriction. The retained records keep these numbers, so gaps in the retained
list correspond exactly to the rejected records listed below.

## Results by input

### `C3`

| Component | Projective group | Before González | Retained | Rejected |
|---|---|---:|---:|---:|
| Koike (3.4), generic index 1 | `[18,3]` | 7 | 6 | 1 |
|  | `[6,1]` | 1 | 1 | 0 |
|  | `[12,1]` | 4 | 4 | 0 |
|  | `[36,6]` | 8 | 7 | 1 |
|  | `[24,1]` | 5 | 5 | 0 |
| Koike (3.3), generic index 2 | `[18,3]` | 7 | 5 | 2 |
|  | `[6,1]` | 1 | 1 | 0 |
|  | `[12,1]` | 0 | 0 | 0 |
|  | `[36,6]` | 0 | 0 | 0 |
|  | `[24,1]` | 0 | 0 | 0 |
| **Total** |  | **33** | **29** | **4** |

The zero rows in the index-two component are outputs of the even-index and
strict generic-`S3` containment conditions. They are not missing
computations. The separately excluded projective group `[72,12]` was not an
enumeration input.

### `C2^2`

| Projective group | Before González | Retained | Rejected |
|---|---:|---:|---:|
| `[12,3]` | 3 | 2 | 1 |
| `[8,3]` | 3 | 3 | 0 |
| `[16,6]` | 5 | 5 | 0 |
| `[24,13]` | 7 | 5 | 2 |
| `[24,10]` | 19 | 15 | 4 |
| **Total** | **37** | **30** | **7** |

### `C4`

| Projective group | Before González | Retained | Rejected |
|---|---:|---:|---:|
| `[8,4]` | 2 | 2 | 0 |
| `[8,3]` | 2 | 2 | 0 |
| `[24,10]` | 14 | 12 | 2 |
| `[16,6]` | 8 | 8 | 0 |
| **Total** | **26** | **24** | **2** |

### `S3`

| Component | Projective group | Before González | Retained | Rejected |
|---|---|---:|---:|---:|
| Koike (3.6), generic index 1 | `[6,1]` | 1 | 1 | 0 |
|  | `[12,4]` | 2 | 2 | 0 |
|  | `[18,3]` | 6 | 4 | 2 |
|  | `[24,5]` | 7 | 7 | 0 |
|  | `[36,12]` | 13 | 12 | 1 |
|  | `[48,4]` | 4 | 4 | 0 |
|  | `[72,27]` | 7 | 6 | 1 |
| Corrigendum component, generic index 2 | `[12,4]` | 1 | 1 | 0 |
|  | `[24,5]` | 6 | 6 | 0 |
|  | `[36,12]` | 12 | 9 | 3 |
|  | `[48,4]` | 15 | 15 | 0 |
|  | `[72,27]` | 31 | 31 | 0 |
| Direct known case | `S3 x C24`, projective `[144,69]` | 1 | 1 | 0 |
| **Total** |  | **106** | **99** | **7** |

The `[72,27] = S3 x C12` rows use the exact specialized enumeration. No
`S3 x C16` or `S3 x C24` extension branch is run. The actual `S3 x C24`
action is appended directly; its projective and strict linear IDs are
`[144,69]` and `[432,464]`.

## Family dimensions

| Expected moduli dimension | Before González | Retained | Rejected |
|---:|---:|---:|---:|
| 0 | 104 | 86 | 18 |
| 1 | 44 | 42 | 2 |
| 2 | 30 | 30 | 0 |
| 3 | 15 | 15 | 0 |
| 4 | 4 | 4 | 0 |
| 5 | 1 | 1 | 0 |
| 6 | 3 | 3 | 0 |
| 8 | 1 | 1 | 0 |
| **Total** | **202** | **182** | **20** |

Thus the González restriction rejects 18 zero-dimensional records and two
one-dimensional records. It does not remove a record of dimension at least
two.

## Rejected candidates

| Candidate | Component | Projective ID | Strict linear ID | Dimension |
|---:|---|---|---|---:|
| 7 | `C3`, Koike (3.4) | `[18,3]` | `[54,4]` | 0 |
| 20 | `C3`, Koike (3.4) | `[36,6]` | `[108,7]` | 0 |
| 31 | `C3`, Koike (3.3) | `[18,3]` | `[54,4]` | 0 |
| 32 | `C3`, Koike (3.3) | `[18,3]` | `[54,4]` | 1 |
| 35 | `C2^2` | `[12,3]` | `[36,3]` | 0 |
| 48 | `C2^2` | `[24,13]` | `[72,16]` | 0 |
| 49 | `C2^2` | `[24,13]` | `[72,16]` | 0 |
| 67 | `C2^2` | `[24,10]` | `[72,10]` | 0 |
| 68 | `C2^2` | `[24,10]` | `[72,10]` | 0 |
| 69 | `C2^2` | `[24,10]` | `[72,10]` | 0 |
| 70 | `C2^2` | `[24,10]` | `[72,10]` | 1 |
| 87 | `C4` | `[24,10]` | `[72,10]` | 0 |
| 88 | `C4` | `[24,10]` | `[72,10]` | 0 |
| 104 | `S3`, Koike (3.6) | `[18,3]` | `[54,4]` | 0 |
| 105 | `S3`, Koike (3.6) | `[18,3]` | `[54,4]` | 0 |
| 125 | `S3`, Koike (3.6) | `[36,12]` | `[108,24]` | 0 |
| 136 | `S3`, Koike (3.6) | `[72,27]` | `[216,47]` | 0 |
| 153 | `S3`, corrigendum | `[36,12]` | `[108,24]` | 0 |
| 154 | `S3`, corrigendum | `[36,12]` | `[108,24]` | 0 |
| 155 | `S3`, corrigendum | `[36,12]` | `[108,24]` | 0 |

Each rejection has the recorded status
`forbidden_strict_invariant_spectrum`. The retained and rejected records,
including their complete invariant cubic bases, remain available in the
machine-readable output.

## Runtime

The compact log records the following elapsed times. Case times below are
obtained by subtracting consecutive cumulative times.

| Stage | Time |
|---|---:|
| `C3` | 3,874,860 ms |
| `C2^2` | 68,218 ms |
| `C4` | 48,391 ms |
| `S3` | 4,788,516 ms |
| González restriction | 15,609 ms |
| **Complete run** | **8,795,610 ms** |

The complete run took approximately 2 hours, 26 minutes, and 36 seconds.

## Output files

- `gap_small_nonabelian.out` contains all 202 human-readable candidate
  records, including matrix generators and invariant cubic bases.
- `gap_small_nonabelian_data.g` contains the 182 retained records in
  `SmallNonabelianCandidates`, the 20 rejected records in
  `SmallNonabelianRejectedCandidates`, and the final summary. It loads the
  saved data without repeating the enumeration.
- `gap_small_nonabelian.log` records the environment, numbered progress,
  case counts, filters, and runtime.

The machine-readable summary has `smoothnessTested := false`. Smoothness is a
separate downstream calculation in `../gap_smoothness`, and saturation is a
separate calculation in `../gap_saturation`. Neither stage is included in
the counts reported here.

<!-- multiplier-audit:start -->
## Multiplier audit

The audit reads the small non-abelian target IDs from the corresponding
functions, retaining first-occurrence order. All 16 distinct targets and the
separate `S3 x C24` example have trivial Schur multiplier 3-part.
Consequently, their `H^2(G,C3)` is the Ext part already covered by the
small non-abelian enumeration. The conclusion is restricted to these targets.

### Run information

- GAP version: `4.15.1`.
- Distinct targets: 16; direct example: 1; controls: 5.
- Universal-coefficient dimension checks: passed for all 22 records.
- GAP-readable data: [gap_multiplier_audit.out](gap_multiplier_audit.out).
- Runtime log: [gap_multiplier_audit.log](gap_multiplier_audit.log).
- Criterion and scope: [gap_small_nonabelian_script.md#multiplier-audit-and-extension-completeness](gap_small_nonabelian_script.md#multiplier-audit-and-extension-completeness).

All dimensions below are over `GF(3)`; `[]` means trivial multiplier 3-part.

### Target groups

| GAP ID | Structure | Sylow 3-subgroup | Ext dimension | H2 dimension | Multiplier 3-part |
| --- | --- | --- | ---: | ---: | --- |
| `[ 18, 3 ]` | `C3 x S3` | `C3 x C3` | 1 | 1 | `[  ]` |
| `[ 6, 1 ]` | `S3` | `C3` | 0 | 0 | `[  ]` |
| `[ 12, 1 ]` | `C3 : C4` | `C3` | 0 | 0 | `[  ]` |
| `[ 36, 6 ]` | `C3 x (C3 : C4)` | `C3 x C3` | 1 | 1 | `[  ]` |
| `[ 24, 1 ]` | `C3 : C8` | `C3` | 0 | 0 | `[  ]` |
| `[ 12, 3 ]` | `A4` | `C3` | 1 | 1 | `[  ]` |
| `[ 8, 3 ]` | `D8` | `1` | 0 | 0 | `[  ]` |
| `[ 16, 6 ]` | `C8 : C2` | `1` | 0 | 0 | `[  ]` |
| `[ 24, 13 ]` | `C2 x A4` | `C3` | 1 | 1 | `[  ]` |
| `[ 24, 10 ]` | `C3 x D8` | `C3` | 1 | 1 | `[  ]` |
| `[ 8, 4 ]` | `Q8` | `1` | 0 | 0 | `[  ]` |
| `[ 12, 4 ]` | `D12` | `C3` | 0 | 0 | `[  ]` |
| `[ 24, 5 ]` | `C4 x S3` | `C3` | 0 | 0 | `[  ]` |
| `[ 36, 12 ]` | `C6 x S3` | `C3 x C3` | 1 | 1 | `[  ]` |
| `[ 48, 4 ]` | `C8 x S3` | `C3` | 0 | 0 | `[  ]` |
| `[ 72, 27 ]` | `C12 x S3` | `C3 x C3` | 1 | 1 | `[  ]` |

### Direct example

| GAP ID | Structure | Sylow 3-subgroup | Ext dimension | H2 dimension | Multiplier 3-part |
| --- | --- | --- | ---: | ---: | --- |
| `[ 144, 69 ]` | `C24 x S3` | `C3 x C3` | 1 | 1 | `[  ]` |

### Controls

These records are not classification inputs. The excluded target
`[72,12]` is a zero-value control; the four abelian groups are nonzero-value
controls. These roles describe the saved values, not additional assertions
enforced by the script.

| GAP ID | Structure | Ext dimension | H2 dimension | Multiplier 3-part | Role |
| --- | --- | ---: | ---: | --- | --- |
| `[ 72, 12 ]` | `C3 x (C3 : C8)` | 1 | 1 | `[  ]` | zero-value control |
| `[ 9, 2 ]` | `C3 x C3` | 2 | 3 | `[ 3 ]` | nonzero-value control |
| `[ 18, 5 ]` | `C6 x C3` | 2 | 3 | `[ 3 ]` | nonzero-value control |
| `[ 36, 8 ]` | `C12 x C3` | 2 | 3 | `[ 3 ]` | nonzero-value control |
| `[ 72, 14 ]` | `C24 x C3` | 2 | 3 | `[ 3 ]` | nonzero-value control |

### Interpretation

7 target groups have Ext and H2 dimension 1; 9 have dimension 0.
The direct example has dimension 1. A vanishing multiplier 3-part removes
the non-liftable branch, but does not force every extension to split:
nonzero Ext classes can still be liftable without being F-liftable.
This audit does not establish geometric realizability or smoothness.
<!-- multiplier-audit:end -->
