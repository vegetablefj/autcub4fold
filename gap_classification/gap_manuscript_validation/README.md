# Family coordinates and correspondence

This directory records the family representatives in table order and checks
their linear equivalence with the computed families. `gap_family_catalogue.g`
gives the final coordinates. Conjugating matrices are stored in
`gap_family_correspondence.out`.

No representation enumeration, saturation, smoothness screening, or
cross-dimensional embedding search is repeated by this module. The cubic
basis check recomputes invariant spaces and centralizer dimensions exactly.

The comparison drivers read the supplied
[fixed computational input](../gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g).
The result-presentation directory `gap_result/` is not used as input.

| Files | Purpose |
| --- | --- |
| `gap_family_catalogue.g` | Complete 156-family catalogue, in the exact numbered table order, with full matrix groups and cubic bases |
| `gap_ordered_family_catalogue.g` | Catalogue construction and verification of the corresponding conjugating matrices |
| `gap_family_correspondence.out/.log/.md` | Conjugating matrices, computation log, and ordered result report |
| `gap_manuscript_input.g` | Saved exact matrices, cubic terms, and numbered display data for all 156 rows |
| `gap_manuscript_metadata_audit.g/.out` | Verification of all 156 table rows against saved classification properties |
| `gap_fourfold_manuscript_audit.g/.out/.log/.md` | Verification of displayed full groups, component bases, and family bases |
| `gap_display_basis_audit.g/.out/.log/.md` | Fresh exact invariant-space and family-dimension checks for all 156 fourfold and 40 threefold rows |
| `gap_validation_functions.g` | Shared exact group-conjugacy and cubic-space checks |
| `gap_stored_coordinate_witnesses.g`, `manuscript_component_coordinates.g`, `special_coordinate_audit.*` | Explicit coordinate certificates and retained symplectic/generic group models; the special audit contains its own transcribed display snapshot |
| `run_validation.py`, `*.raw.log`, `*.runtime.txt` | Windows GAP launcher, raw transcripts, and runtime information |

The display input is a fixed transcription: these checks do not read TeX.
Its source-line numbers refer only to the version transcribed.

The saved `*.runtime.txt` files retain the script, process status, and timing.
Historical local absolute paths in their command fields are explicitly redacted;
the displayed invocation is a summary, not the literal historical shell command.
The launcher likewise records repository-relative script names rather than local
absolute paths in future runtime files.

Read [the script description](gap_manuscript_validation_script.md) for the
verification conventions and [the result summary](gap_manuscript_validation_result.md)
for the completed checks. The ordered report is
[gap_family_correspondence.md](gap_family_correspondence.md).

Threefold extraction, five-dimensional coordinates and their
correspondence with this catalogue are checked in
[the threefold module](../gap_threefold/README.md). The saved five-variable
GAP input there is used for its coordinate checks.

From the repository root:

```text
python gap_classification/gap_manuscript_validation/run_validation.py gap_ordered_family_catalogue.g
```

The saved coordinate inputs and display audits are required. The driver
checks the corresponding matrices without repeating the pairwise comparisons
already used to distinguish the families. A deliberate run replaces its catalogue and reports.
It exits GAP when complete. The launcher checks the process status and the
`VALIDATION_COMPLETE` marker; the mathematical result must also report no failures.

For the separate basis and dimension check, read in GAP from the repository root:

```gap
Read("gap_classification/gap_manuscript_validation/gap_display_basis_audit.g");
```

Its [result summary](gap_display_basis_audit.md) describes the checks and
the `DISPLAY_BASIS_AUDIT_SUCCESS` completion marker.

The installed Windows runtime is GAP 4.15.1, launched through its bundled
login shell with `-r -q -b`. The `-r` option disables user startup files.
Singular is not required. The launcher accepts `--bash` and `--gap` for a
different installation.
