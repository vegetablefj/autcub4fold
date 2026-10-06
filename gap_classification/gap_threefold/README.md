# Cubic threefolds

This directory records 40 saturated cubic-threefold families obtained by
removing one Fermat summand from the saved cubic-fourfold families. They are
numbered by increasing source-fourfold number.

The saved extraction examines 63 fourfold families whose non-symplectic
index is divisible by three. Forty have a Fermat summand; the remaining 23
have none. All 40 extracted groups, complete invariant cubic bases, family
dimensions, and available GAP IDs have been checked in the final coordinates.
The direct containment calculation gives 260 strict relations, 83 covers,
and seven action-maximal families: Nos. 1, 2, 3, 5, 24, 39, and 40.
It agrees with the independent relation induced from the fourfold families.
For saturated families, containment of full strict groups up to linear
conjugacy is equivalent to inclusion of their unmarked family loci; the
generic-stabilizer argument applies in five variables as well as six.

## Files

| File or directory | Purpose |
| --- | --- |
| [gap_threefold_script.md](gap_threefold_script.md) | Mathematical reduction, algorithms, and verification details. |
| [gap_threefold_functions.g](gap_threefold_functions.g) | Fermat-element search and centralizer restriction functions; loading it does not start a run. |
| [gap_threefold_functions_test.g](gap_threefold_functions_test.g) | Exact tests for a source without a Fermat summand, the generic threefold, and the Fermat threefold. |
| [gap_threefold_index_three.g](gap_threefold_index_three.g) | Original extraction of the 63 selected fourfold sources. |
| [input/gap_threefold_display_input.g](input/gap_threefold_display_input.g) | Saved exact five-variable matrices and cubic bases used in the coordinate check. |
| [gap_threefold_verify_coordinates.g](gap_threefold_verify_coordinates.g) | Verification of the saved extraction in the final fourfold and threefold coordinates. |
| [gap_threefold_cross_dimension.g](gap_threefold_cross_dimension.g) | Independent five-dimensional group-containment tests for all eligible ordered pairs. |
| [run_threefold.py](run_threefold.py) | Single-process launcher for the direct calculation; runs the report after a complete result with no undecided pairs. |
| [gap_threefold_containment.g](gap_threefold_containment.g) | Verification of the direct decisions and matrices, cover computation, and comparison with the fourfold relation. |
| [gap_threefold_table_data.g](gap_threefold_table_data.g) | Verification and export of compact group and dimension data. |
| `input/` | Saved extraction, exact coordinate matrices, and five-variable formula input. |
| `output/` | Run logs; the direct batch also writes temporary completed-pair prefixes here. |
| `result/` | Final family catalogue, verification records, and containment results. |

Two lists record the same 40 families in the same order:

- [gap_threefold_extracted_families.g](result/gap_threefold_extracted_families.g),
  with variable `CubicThreefoldExtractedCatalogue`, retains the original
  extracted five-dimensional coordinates.
- [gap_threefold_families.g](result/gap_threefold_families.g), with variable
  `CubicThreefoldFamilyCatalogue`, gives the final coordinate presentations.

Each list records the complete matrix generators and invariant cubic bases;
the coordinate audit verifies their equality up to linear conjugacy,
including their polynomial spaces and dimensions. The saved 63-source
extraction audit includes the 23 negative Fermat decisions; it is not a
third independently maintained list of 40 families. The saved formula input
records the displayed matrices and bases in GAP form; no TeX is read.

The final GAP-readable catalogue is
[gap_threefold_families.g](result/gap_threefold_families.g), with variable
`CubicThreefoldFamilyCatalogue`. Each row contains the five-dimensional
matrix generators, complete cubic coefficient basis, strict and projective
group IDs and orders, family dimension, Fermat rank, source fourfold number,
and action-maximal flag. The strict group includes `E(3)*IdentityMat(5)`;
its quotient by this scalar group is the projective automorphism group.

The exact checks are saved in
[gap_threefold_coordinate_audit.out](result/gap_threefold_coordinate_audit.out).
The direct pair decisions are written to
`result/gap_threefold_cross_dimension_all_pairs.g`, and their exact input
binding and coverage counts to `result/gap_threefold_cross_dimension_manifest.g`.
The verified full relation is saved in
[gap_threefold_containment.out](result/gap_threefold_containment.out), and
[gap_threefold_result.md](result/gap_threefold_result.md) displays the results.
The compact group and dimension data are saved in
[gap_threefold_table_data.out](result/gap_threefold_table_data.out).

## Running the checks

Use GAP with the `smallgrp` package. Python 3 is used by the optional launcher.
See [ENVIRONMENT.md](../../ENVIRONMENT.md) for the recorded environments.
No Singular calculation or external formula source is needed here.

First verify the two lists in GAP:

```gap
Read("gap_threefold_verify_coordinates.g");
```

Then launch the independent five-dimensional calculation:

```text
python run_threefold.py
```

The launcher uses the recorded Windows GAP runtime; `--bash` and `--gap`
select another installation. It has no time limit and starts one GAP process.
Progress is written to `output/gap_threefold_cross_dimension_stdout.log`;
the GAP log is `output/gap_threefold_cross_dimension.log`. A completed
full run prints `THREEFOLD_CROSS_DIMENSION_COMPLETED undecided=0` before
automatically producing the verified containment report. An undecided
pair remains undecided and prevents a final report; it is never changed
to a negative decision. `--resume` explicitly reuses completed prefixes
only with unchanged exact input, algorithm, and GAP version; saved positive matrices
are checked again. `--self-test` runs only the small independent tests.
Temporary pair prefixes are needed only for an interrupted run; the complete
result files contain all decisions and verified positive matrices.

With another GAP installation, the direct script can be run from this
directory without the launcher:

```text
gap -r -q -b gap_threefold_cross_dimension.g 0 1 40 0
```

After a complete direct result, the report can also be regenerated in GAP:

```gap
Read("gap_threefold_containment.g");
```

Finally, verify and export the compact table data in a separate GAP session:

```gap
Read("gap_threefold_table_data.g");
```

The coordinate and reporting scripts reuse the completed extraction. They
do not repeat the representation enumeration, Fermat-class search, or
saturation. The direct script tests each of the 493 eligible pairs in
dimension five, without fourfold decisions or transitive shortcuts.
The report checks its positive matrices on every source generator, complete
pair coverage, and agreement with the induced fourfold relation before
recomputing covers. The other completion markers are
`THREEFOLD_COORDINATES_VERIFIED`, `THREEFOLD_CONTAINMENT_COMPLETED`, and
`THREEFOLD_TABLE_DATA_COMPLETED`.

For a deliberate recomputation of the extraction, run
`Read("gap_threefold_index_three.g");`. This replaces the saved extraction
in `input/` and its log; rerun the coordinate and containment checks afterwards.
