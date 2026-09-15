# Small non-abelian computations

This directory contains the small non-abelian representation enumeration
and the independent multiplier audit that establishes its extension scope.
The four symplectic parts are processed in the order `C3`, `C2^2`, `C4`,
`S3`.

For the 16 distinct projective targets and the separate `S3 x C24`
example, the multiplier 3-part vanishes. Every central extension by
`C3` is therefore in the `Ext^1` part traversed by the engine. No additional
non-liftable branch is needed for this list. Liftable does not mean
F-liftable: nonzero Ext classes are included.

## Files

```text
gap_small_nonabelian/
|-- README.md
|-- gap_small_nonabelian_script.md
|-- gap_small_nonabelian_result.md
|-- gap_multiplier_audit.g
|-- gap_multiplier_audit.out
|-- gap_multiplier_audit.log
|-- gap_small_nonabelian.g
|-- gap_small_nonabelian_functions.g
|-- gap_small_nonabelian_liftable_engine.g
|-- gap_small_nonabelian_c3.g
|-- gap_small_nonabelian_c2_2.g
|-- gap_small_nonabelian_c4.g
|-- gap_small_nonabelian_s3.g
|-- gap_small_nonabelian_data.g
|-- gap_small_nonabelian.log
|-- gap_small_nonabelian.out
|-- README_7212.md
|-- gap_small_nonabelian_7212.g
|-- gap_small_nonabelian_7212_special.g
|-- gap_small_nonabelian_7212_special_data.g
|-- gap_small_nonabelian_7212_special.log
`-- gap_small_nonabelian_7212_special_report.md
```

| File or group | Purpose |
|---|---|
| [gap_small_nonabelian_script.md](gap_small_nonabelian_script.md) | Scope, ordered cases, algorithms, completeness conditions, and running instructions for the audit and enumeration. |
| [gap_small_nonabelian_result.md](gap_small_nonabelian_result.md) | Saved enumeration statistics and multiplier-audit tables. |
| `gap_multiplier_audit.g` | Audit the multiplier 3-part and universal-coefficient dimensions for the targets, direct example, and separate controls. Does not enumerate representations or cubics. |
| `gap_multiplier_audit.out`, `.log` | GAP-readable cohomology records and progress transcript. Controls are not candidates. |
| `gap_small_nonabelian.g` | Serial entry point; collect four cases, apply the final necessary restriction, and write the enumeration outputs. |
| `gap_small_nonabelian_functions.g` | Shared target lists, validation, traversal, containment, metadata, and González-Aguilera–Liendo restrictions. |
| `gap_small_nonabelian_liftable_engine.g` | Audited extension, representation, and internal deduplication engine. |
| `gap_small_nonabelian_c3.g` | The two `C3` components. |
| `gap_small_nonabelian_c2_2.g`, `gap_small_nonabelian_c4.g` | The `C2^2` and `C4` components. |
| `gap_small_nonabelian_s3.g` | The two `S3` components, the exact `[72,27]` treatment, and the direct `S3 x C24` example. |
| `gap_small_nonabelian_data.g` | Saved retained and rejected candidates and summary; downstream calculations read this file. |
| `gap_small_nonabelian.log`, `.out` | Numbered progress and complete readable candidate records. |
| `*_7212*`, [README_7212.md](README_7212.md) | Independent supplementary checks for projective `[72,12]`; not called by the main enumeration. |

The entry point performs representation enumeration and necessary filters
only. Smoothness is handled in `../gap_smoothness`, saturation in
`../gap_saturation`; both consume saved candidates. Unused downstream
routines retained in the engine are not called.

Internal names such as `S_1`, `S_2`, and `S_3` are implementation names,
not public case labels.

## Loading saved results

Start GAP in this directory:

```gap
Read("gap_small_nonabelian_data.g");
Read("gap_multiplier_audit.out");
```

These commands load the saved records without repeating either calculation.
No input is read from a result-display directory or the liftability module.

## Running

The saved runs used Windows GAP `4.15.1` with `smallgrp` and `cohomolo`.
Both entry points must be run from this directory. They are independent.

To load enumeration definitions only:

```gap
CF_SN_AUTO_RUN := false;;
Read("gap_small_nonabelian.g");
```

To deliberately repeat the multiplier audit:

```gap
Read("gap_multiplier_audit.g");
```

It replaces the audit `.out` and `.log`, updates only the audit section
of the shared result document, and exits GAP. The supplied log's
standalone-report filename predates this integration; its numerical records
and completion checks are unchanged.

To deliberately repeat the enumeration in a fresh session:

```gap
Read("gap_small_nonabelian.g");
```

This replaces the enumeration `_data.g`, `.log`, and `.out`.
If `CF_SN_AUTO_RUN` was previously set to `false`, explicitly set it to
`true` first. The saved enumeration took approximately 2 hours 27 minutes;
this is a recorded runtime, not a performance guarantee.

Mathematical sources and the historical order-5 qualification are collected
in [the reference guide](../../REFERENCES.md#prime-order-restriction).
