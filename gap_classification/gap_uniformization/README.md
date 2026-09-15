# Uniformization

This directory puts a matrix-group family into fixed coordinates for the
generic full linear group of its symplectic component. The current standard
list consists of the eight rank-below-15 symplectic families in Koike's
coordinates, including the relevant corrections from the corrigendum.
The sources are listed in the
[reference guide](../../REFERENCES.md#symplectic-actions-and-maximal-groups).

## Files

- `gap_uniformization_standard_groups.g` records the eight strict symplectic
  lifts and their generic full linear groups. The latter already contain the
  natural non-symplectic involution for the generic index-two `C3` and `S3`
  components.
- `gap_uniformization_functions.g` contains the general uniformization
  functions.
- `gap_uniformization.g` verifies the procedure on the eight symplectic
  family records and writes `gap_uniformization.out` and
  `gap_uniformization_result.md`.
- The [fixed computational catalogue](../gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g)
  supplies the 156 saved presentations and their standard symplectic and
  generic full groups. It is an exact input snapshot, not a file reconstructed
  by a public catalogue builder. The final display coordinates are recorded
  separately in [the ordered catalogue](../gap_manuscript_validation/gap_family_catalogue.g).
- `gap_generic_full_group_audit.g` checks literal containment of the fixed
  symplectic and generic full groups in all 156 saved presentations. It writes
  the GAP-readable certificate `gap_generic_full_group_audit.out` and the
  concise summary `gap_generic_full_group_audit.md`.
- `gap_generator_optimization_audit.g` performs an exact primitive-coset
  search inside a selected list of unchanged full matrix groups. The saved
  `gap_generator_optimization_audit.out` records the exact checks. Running
  the script also generates a Markdown summary. It is not a normalizer search.

## Main function

```gap
result := CF_UNI_UniformizeFamily(candidate);
```

The input record must contain `matrixGenerators` (or `generators` or
`linearGenerators`). Supplying `symplecticPart` makes standard-form
selection faster.

The function first computes the determinant-one kernel and uses it to select
the possible symplectic components. It then embeds the corresponding Koike
generic full linear group into the candidate, first by literal containment,
then by a coordinate permutation, and finally by the exact linear-conjugacy
routine. If `P` satisfies

```text
P^-1 * (standard generic group) * P <= source full group,
```

then the whole source group is transported by `g -> P*g*P^-1`.

The standard generic group contains the complete determinant-one kernel. The
remaining quotient is therefore cyclic. If it is nontrivial, the function
chooses one element whose determinant generates the full determinant image
and verifies that this element together with the standard generic generators
recovers the transformed full group. A transformed input generator is tried
first, followed by an element of the transformed group.

The returned `extraGenerator` is therefore mathematically sufficient, but it
is not claimed to be the simplest representative of its coset. Multiplying
it by an element of the standard generic group, or changing the conjugacy
witness by an element of the normalizer of that group, may give a more
convenient matrix later.

The fixed computational catalogue was prepared by searching primitive
determinant cosets over the fixed symplectic lift. Replacements were retained
only when they improved the matrix support or decreased the printed
coefficient length by at least one quarter. The supplied generic-group and
generator-optimization audits retain the exact checks of these presentations.
The historical construction script is not a runtime dependency.

## Running the audit

Run the audit from the repository root:

```gap
Read("gap_classification/gap_uniformization/gap_uniformization.g");
```

The function file itself can also be read from the uniformization directory
when the caller supplies an already loaded family record. The audit driver
is stored in this directory but is run from the repository root to read the
unified saturation input.

The completed input is supplied directly. Reading it only defines the
saved catalogue and performs no classification or saturation calculation. The
[coordinate-presentation audit](../gap_coordinate_presentation/README.md)
checks the saved catalogue against the computed groups without repeating
saturation.

To check the fixed generic groups and the selected additional generators
against the fixed input, run from the repository root:

```gap
Read("gap_classification/gap_uniformization/gap_generic_full_group_audit.g");
Read("gap_classification/gap_uniformization/gap_generator_optimization_audit.g");
```
