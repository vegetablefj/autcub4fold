# Low-rank lattice actions

This module supplies lattice inputs and saved actions for the six low-rank
action-maximal fourfold families outside the original rank-at-least-15
OSCAR search. Start with the [six-case guide](maximal_cases/README.md),
the [action summary](maximal_cases/maximal_lattice_actions.md), and the
[machine-readable index](maximal_cases/maximal_lattice_action_index.json).
The index names the selected sources and outputs; output numbers are local
to a run, not canonical geometric class labels.

## Selected sources

| No. | Group | Saved source | Scope |
| ---: | --- | --- | --- |
| 96 | `S3 x C24` | [MRDI](maximal_cases/family_096_phi24_oscar18.mrdi), [report](maximal_cases/family_096_phi24_oscar18_result.md) | Complete exact-character action and primitive-extension search. |
| 127 | `C4 x C2` | [Full-lattice witness](maximal_cases/family_127_g13_full_finite_glue_preflight.json), [construction notes](maximal_cases/family_127_progress_20260929.md) | Constructed, checked, and saturated witness; not exhaustive direct integral-action enumeration. |
| 152 | `C16` | [Brown MRDI](maximal_cases/brown_results/family_152_phi16_brown_oscar18.mrdi), [report](maximal_cases/brown_results/family_152_phi16_brown_oscar18_result.md) | Complete exact-character search. |
| 154 | `C24` | [Brown MRDI](maximal_cases/brown_results/family_154_phi24_brown_oscar18.mrdi), [report](maximal_cases/brown_results/family_154_phi24_brown_oscar18_result.md) | Complete exact-character search. |
| 155 | `C32` | [MRDI](maximal_cases/family_155_phi32_oscar18.mrdi), [report](maximal_cases/family_155_phi32_oscar18_result.md) | Complete exact-character search. |
| 156 | `C48` | [Brown MRDI](maximal_cases/brown_results/family_156_phi48_brown_oscar18.mrdi), [report](maximal_cases/brown_results/family_156_phi48_brown_oscar18_result.md) | Complete exact-character search. |

The four cyclic cases have one retained coprime-power orbit each, as explained
in the action summary. Matching the unordered negative eigenvalue pair does
not choose an oriented Hodge line or exhibit a direct cohomology conjugacy
with the displayed cubic. The [exact negative-eigenpair audit](maximal_cases/check_maximal_negative_eigenpairs.py)
and its [saved output](maximal_cases/maximal_negative_eigenpairs.out) record
this comparison without rerunning OSCAR.

No. 127's smooth, generically full and saturated constructed family is
identified through the completed family classification. This identification
does not claim an exhaustive search of all integral actions or an explicit
full-`H^4` action/gluing conjugacy to the displayed equation. Its finite
gluing and orbit certificates have the individual scopes stated in the
construction notes.

## Inputs, checks, and catalogue use

[input_original.jl.txt](input_original.jl.txt) preserves the older 37-pair
lattice input. [input.jl](input.jl) parses numeric Gram entries and candidate
orders without evaluating that preserved text. The six cases use only the
labels `S_3 generic 2`, `2 generic 1`, and `1 generic 1`.

[compute_hodge_characters.jl](maximal_cases/compute_hodge_characters.jl)
computes the equation-side character exactly; the
[character result](maximal_cases/maximal_family_character_result.md)
is independent of the integral action search. Search scripts, reload checks,
resource wrappers, and posterior lattice certificates are listed in the
six-case guide. The local No. 96/155 reports record Julia 1.10.11; the
imported Brown No. 152/154/156 reports record Julia 1.12.4, all with OSCAR
1.8.2. Use the environment of the relevant source rather than inferring one
version for every saved run.

The [Brown result directory](maximal_cases/brown_results/) preserves the
completed MRDI files together with their original reports, logs, status
files, and Slurm console output. Older local status or lock files are run
provenance, not evidence that a job is currently running. The separate
[Brown rerun instructions](../enumeration/BROWN_RUN.txt) describe another
workflow; its job-specific outputs do not replace these selected records
without a separate postcheck and source-index update.

For the common ambient field scheme, use
[maximal_six_standard.mrdi](../catalogue/maximal_six_standard.mrdi)
and its [normalization builder](../catalogue/build_maximal_six_standard.jl).
The [numbered catalogue guide](../catalogue/README.md) points
to the selected complete 156-row catalogue and its current provenance table.
Its final structural audit is not a substitute for these source-specific
root, saturation, enumeration, or geometric-identification arguments.
