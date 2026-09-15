# Equivalence, containment, and saturation

This directory prepares the family data and the strict linear-conjugacy
embedding tools used by the equal-dimensional saturation calculation.

- `gap_large_koike_families.g` stores the 76 rank-at-least-15 families.
- `gap_prepare_small_nonabelian_input.g` selects the recorded 46 smooth and 7
  unresolved small non-abelian families.
- `gap_small_nonabelian_saturation_data.g` is the generated selection; the
  129 certified singular families are absent.
- `gap_saturation_input.g` normalizes all 184 records and assigns the simple
  saturation tags documented in `gap_saturation_input.md`.
- `gap_containment_functions.g` contains the strict containment routines.
- `gap_equal_dimension_saturation.g` runs the traceable equal-dimensional
  saturation search and writes a readable log and a GAP-readable audit file.
- `gap_nonlarge_symplectic_alignment.g` assigns the non-large records to the
  eight rank-below-15 symplectic families and tests literal containment of
  the corresponding determinant-one matrix group. Its readable result is
  `gap_nonlarge_symplectic_alignment.md`.

## Reading data and running the calculation

Start GAP from the repository root or from this directory. From this
directory, the saved inputs can be loaded without repeating the embedding
search:

```gap
Read("gap_saturation_input.g");
Read("gap_equal_dimension_saturation.out");
```

This binds `SaturationInputCandidates`, the source-specific lists, and
`SaturationInputSummary`, followed by the saved
`EqualDimensionSaturationAudit`. From the repository root, prefix each path
with `gap_classification/gap_saturation/`. The readable transcript is in
`gap_equal_dimension_saturation.log`.

To repeat the calculation deliberately, start a fresh GAP session in this
directory and run:

```gap
Read("gap_equal_dimension_saturation.g");
```

From the repository root, read
`gap_classification/gap_saturation/gap_equal_dimension_saturation.g` instead.
The driver loads its inputs and containment functions itself, then replaces
the `.out` and `.log` files. Repeating it is not needed to inspect the saved
result.

There are 177 certified-smooth records. Of these, 60 are tagged
`known_saturated`, including the five rank/order cases and the index-2 `QD16`
family. The remaining 117 smooth records are eligible for the saturation
search. Seven unresolved small non-abelian records are retained for
traceability but excluded from that search.

The saturation driver first merges proved equal-order copies. It then
processes the remaining comparison sources from smaller to larger group
order. Targets are drawn from the complete representative list, so a removed
intermediate family can still certify a direct containment. Every direct
edge, final target, and full containment path is retained in
`gap_equal_dimension_saturation.out` for later construction of the final
family table. The corresponding incremental transcript is
`gap_equal_dimension_saturation.log`. A deliberate rerun replaces both
files.

The completed run has 156 smooth survivors. This equal-dimensional reduction
is distinct from the separate cross-dimensional containment calculation. The
seven computationally unresolved records are handled by the singular-family
appendix of the classification manuscript and remain excluded here.

The final numbered presentations are stored in
[`gap_family_catalogue.g`](../gap_manuscript_validation/gap_family_catalogue.g).
The [coordinate correspondence](../gap_manuscript_validation/gap_family_correspondence.md)
verifies that these representatives are linearly equivalent to the computed
survivors, in the numbered table order. Conjugating matrices and the original
survivor numbering are stored in the GAP output.
Coordinate verification does not rerun this saturation calculation.

For the direction of containment, the two list-removal modes, and the
difference between the earlier dynamic helper and the current traceable
driver, see [`gap_containment_functions.md`](gap_containment_functions.md).
For references concerning families already known to be saturated, see
[`gap_large_family_candidates.md`](gap_large_family_candidates.md) and the
[reference guide](../../REFERENCES.md).
