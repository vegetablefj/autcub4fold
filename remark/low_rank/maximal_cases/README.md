# Six low-rank action-maximal cases

This directory records Nos. 96, 127, 152, 154, 155, and 156. The
[module guide](../README.md) identifies the selected saved source for each
case. Their common normalized records are in
[`maximal_six_standard.mrdi`](../../catalogue/maximal_six_standard.mrdi);
the numbered ambient catalogue and its provenance remain in
[`catalogue/`](../../catalogue/README.md).

| Files | Purpose |
| --- | --- |
| [`maximal_family_data.jl`](maximal_family_data.jl), [`compute_hodge_characters.jl`](compute_hodge_characters.jl) | Coordinate actions, invariant cubics, and exact equation-side characters. |
| [`maximal_family_character_result.md`](maximal_family_character_result.md) | Saved six-case character and dimension summary. |
| [`maximal_lattice_actions.md`](maximal_lattice_actions.md), [`maximal_lattice_action_index.json`](maximal_lattice_action_index.json) | Result interpretation and selected source/output index. |
| [`family_096_phi24_oscar18.mrdi`](family_096_phi24_oscar18.mrdi), [`family_155_phi32_oscar18.mrdi`](family_155_phi32_oscar18.mrdi) | Reload-checked local exact-character searches. |
| [`brown_results/`](brown_results/) | Earlier Brown searches for Nos. 152, 154, and 156, including MRDI files and run records. |
| [`family_127_progress_20260929.md`](family_127_progress_20260929.md), [`family_127_g13_full_l_postcheck.md`](family_127_g13_full_l_postcheck.md) | No. 127 construction and its verification scope. |

The OSCAR searches for Nos. 96, 152, 154, 155, and 156 use the order,
characteristic polynomial, minimal polynomial, and cyclotomic signatures
computed from the displayed equation. The cyclic cases have one retained
coprime-power orbit each. Their raw output counts are labelled generator
actions, not numbers of geometric families. The source MRDI and report for
each case are linked in the [module guide](../README.md).

No. 127 uses an explicit equivariant-gluing construction and geometric
identification through the completed fourfold classification. Its saved
action is checked to be smooth, generically full, and saturated; it is not
presented as the outcome of an exhaustive rank-14 isometry search or as a
direct full-cohomology conjugacy to the displayed equation. The No. 127
files named `run_family_127_g13_*` and `verify_family_127_*` record the
separate finite, lattice, period, and saturation checks. Their precise
scope is stated in the linked construction notes.

The six input pairs come from three labels in [`input.jl`](../input.jl):
`S_3 generic 2` for No. 96, `2 generic 1` for No. 127, and
`1 generic 1` for Nos. 152, 154, 155, and 156. The original pair list is
preserved as [`input_original.jl.txt`](../input_original.jl.txt).
The exact character check can be run without OSCAR from this directory:

```text
julia --startup-file=no compute_hodge_characters.jl
```

Use the software versions in [`ENVIRONMENT.md`](../../../ENVIRONMENT.md) for
the corresponding saved run. The newer independent Brown reruns are under
[`enumeration/results/2026-10-05/`](../../enumeration/results/2026-10-05/README.md);
they do not replace the source MRDI files indexed here.
