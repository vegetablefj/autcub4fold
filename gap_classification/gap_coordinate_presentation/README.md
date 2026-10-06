# Computational coordinate correspondence

This module verifies the one-to-one agreement between the matrix groups
retained by saturation and the fixed computational coordinate catalogue in
[`fourfold_search_catalogue.g`](../gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g).
Coordinates are chosen to make the symplectic lift and at most one additional
generator convenient to read. This does not repeat classification,
smoothness screening, or saturation.

| File | Purpose |
| --- | --- |
| `gap_coordinate_presentation_functions.g` | Catalogue recovery, metadata partitions, and exact linear-conjugacy checks |
| `gap_coordinate_presentation.g` | Full correspondence audit driver |
| `gap_coordinate_presentation.out` | Match lists and exact conjugating matrices |
| `gap_coordinate_presentation.log` | Comparison transcript |
| `gap_coordinate_presentation_result.md` | Completed result summary |

Elementary metadata only partition the possible matches. Every pair in a
repeated block is checked by exact linear equivalence. The completed audit
contains 156 matches and 34 nonmatches, with no undecided or ambiguous
matches. Group identifiers alone never establish conjugacy.

The complete final coordinate catalogue is
[`gap_family_catalogue.g`](../gap_manuscript_validation/gap_family_catalogue.g).
It follows the same numbered table order and retains the displayed matrices
and bases. Its
[ordered verification](../gap_manuscript_validation/gap_family_correspondence.md)
checks the 156 corresponding matrices from this module and verifies the
additional coordinate identifications. It does not repeat the internal
pairwise comparisons used to distinguish the families.

The fixed computational catalogue remains the source of the saved fourfold
containment and threefold-extraction certificates. The final presentations
and computational coordinates describe the same classified families; their
numerical witness matrices must be transported before changing inputs.

The saved audit uses Windows GAP 4.15.1. From the repository root:

```gap
Read("gap_classification/gap_coordinate_presentation/gap_coordinate_presentation.g");
```

A deliberate rerun replaces this audit's outputs and repeats its block
comparisons. For ordinary final-coordinate verification, use
`gap_classification/gap_manuscript_validation/gap_ordered_family_catalogue.g` instead.
