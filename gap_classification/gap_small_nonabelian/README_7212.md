# Specialized calculation for projective `G=[72,12]`

Here `[72,12]` denotes the projective group
`G=SmallGroup(72,12)`, not its strict linear lift `H`.

`gap_small_nonabelian_7212_special.g` implements the short calculation used
for this case.  It enumerates the normalized weights, constructs the unique
smooth action, verifies a smooth member exactly with Singular, and tests the
strict lift against the strict lift of the `S3 x C24` overgroup.

Run from this directory:

```text
gap -q -b -r gap_small_nonabelian_7212_special.g
```

The run writes:

- `gap_small_nonabelian_7212_special.log`, with the decisive counts;
- `gap_small_nonabelian_7212_special_report.md`, with a readable report;
- `gap_small_nonabelian_7212_special_data.g`, with the matrices, invariant
  basis, smooth witness, and saturation witness in machine-readable form.

The older `gap_small_nonabelian_7212.g` remains available as a wrapper around
the general enumeration engine.  It is substantially slower and is not the
recommended verification for this exceptional projective group.
