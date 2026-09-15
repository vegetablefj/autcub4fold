# Coordinate-presentation audit

This audit compares the computed matrix groups with the canonical
presentations used for the fixed computational catalogue. The change is only a coordinate
normalization intended to make the matrices easier to read; no classification
or saturation computation is repeated.

- Status: `verified_unique`
- Computed families: 156
- Canonical presentations: 156
- Coarse metadata blocks: 140
- Repeated coarse blocks checked pairwise: 15
- Exact pairs tested: 190
- Equivalent pairs: 156
- Non-equivalent pairs: 34
- Undecided pairs: 0
- Ambiguous computed entries: 0

Every computed family has exactly one canonical presentation, and all 156
intended correspondences were verified. The fixed computational catalogue
is used by the saved containment and threefold-extraction calculations.
The final coordinate data are in
[`gap_family_catalogue.g`](../gap_manuscript_validation/gap_family_catalogue.g);
[the ordered correspondence](../gap_manuscript_validation/gap_family_correspondence.md)
replays the designated witnesses and identifies the final presentations.
