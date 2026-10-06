# Cubic-fourfold and threefold results

This directory displays 156 cubic-fourfold and 40 cubic-threefold families. The fourfold rows use the stored order 1–156; the threefold rows use increasing source-fourfold number. The classification programs do not read these display exports. The separate numbering and generator files below supply fixed inputs to the later lattice calculations.

## Files

| File | Content |
| --- | --- |
| [fourfold_families.g](fourfold_families.g) | Full six-dimensional representatives, complete cubic bases, and metadata |
| [fourfold_relations.g](fourfold_relations.g) | Complete positive relation, eligible decisions, covers, and extremal rows |
| [fourfold_result.md](fourfold_result.md) | Fourfold tables and statistics |
| [threefold_families.g](threefold_families.g) | Final five-dimensional presentations, complete cubic bases, and metadata |
| [threefold_relations.g](threefold_relations.g) | Complete positive relation, eligible decisions, covers, and extremal rows |
| [threefold_result.md](threefold_result.md) | Threefold tables and statistics |
| [family_numbering.md](../remark/input/family_numbering.md) | Fixed fourfold numbering, rank, index, and dimension used by the lattice scripts. |
| [family_generators.g](../remark/input/family_generators.g) | Display-coordinate fourfold generators used for character and geometric identification checks. |

## Data conventions

`H` is the strict linear group; its projective quotient is `G = H / <omega I_n>`. Matrices act on row variables by `x -> x*g`. The rows of `coefficientBasis` give the complete invariant cubics in the monomial order `cubicExponents`. `familyDimension = invariantDimension - centralizerDimension`. An identifier `[order,0]` in GAP means that the order is supplied but no SmallGroups ID is supplied.

A positive pair `[i,j]` means a proper GL-conjugate embedding `H_i` into `H_j`; the family inclusion is `Z_j subset Z_i`. `positivePairs` is the full strict relation, not only its covers. `coverPairs` has no intermediate classified row. `negativePairs` contains only resolved eligible negative decisions; excluded pairs and unknowns are separate. An action-maximal row is geometrically minimal, not geometrically maximal.

All threefold liftability flags follow from coprimality of 3 and 5. Fourfold flags come from the [liftability audit](../gap_classification/gap_liftability/README.md). Source-fourfold rank and index fields in the threefold data describe the source, not the threefold action.

## Sources and regeneration

The full [fourfold catalogue and coordinate correspondence](../gap_classification/gap_manuscript_validation/README.md), [fourfold relation](../gap_classification/gap_fourfold_cross_dimension/README.md), and [threefold extraction and direct relation](../gap_classification/gap_threefold/README.md) remain in their computation modules with the proof certificates. The separately extracted threefold representatives remain in that module; they are not a second final result list here.

For mechanical regeneration, run GAP from the repository root and read [`gap_classification/export_results.g`](../gap_classification/export_results.g). Projective group labels are saved in [`result_display_labels.g`](../gap_classification/result_display_labels.g). The export checks saved metadata and coverage, then replaces the six display files above and this README. It does not rewrite the two fixed lattice-input files or perform classification, invariant-space, liftability, or embedding calculations.
