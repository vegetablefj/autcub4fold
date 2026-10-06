# Computational materials for cubic threefolds and fourfolds

This repository collects code, saved outputs, and readable results for
computations concerning automorphism groups of smooth cubic threefolds and
fourfolds. The main entry points are:

| Directory | Contents |
| --- | --- |
| [`gap_yyz_bounds/`](gap_yyz_bounds/README.md) | Abstract group-theoretic bounds and their GAP record. |
| [`oscar/`](oscar/README.md) | Lattice calculations, saved OSCAR objects, and their interpretation. |
| [`gap_classification/`](gap_classification/README.md) | Representation enumeration, smoothness, liftability, conjugacy, and containment checks. |
| [`gap_result/`](gap_result/README.md) | Ordered fourfold and threefold catalogues and their containment relations. |
| [`remark/`](remark/README.md) | Lattice actions for all 156 fourfold families, restrictions, and generic algebraic lattices. |

The catalogues contain 156 cubic-fourfold families and 40
cubic-threefold families. The [fourfold result](gap_result/fourfold_result.md)
and [threefold result](gap_result/threefold_result.md) are readable without
running the calculations. Their corresponding GAP files retain the exact
matrix groups and relation data. Family numbers follow the ordered fourfold
catalogue; threefold numbers use increasing source-fourfold order.

The [156-row ambient catalogue](remark/catalogue/assembly/README.md)
stores one selected compatible embedded action for each numbered fourfold
family. Its [manifest](remark/catalogue/assembly/manifest.jl) selects
the saved lattice record for each row; the earlier
[source table](remark/catalogue/ambient_completion/sources/family_156_sources_current.md)
retains detailed geometric qualifications. The saved structural audit checks
all 156 rows, while geometric identifications and
root and saturation claims rely on their source-specific arguments and
records. The [lattice result](remark/catalogue/lattice_remarks_result.md)
and [low-rank case guide](remark/low_rank/maximal_cases/README.md) explain that
evidence, including the constructive status of No. 127. Counts of retained
generator actions in the cyclic cases are not counts of geometric families.
The [Gram export](remark/catalogue/assembly/lattice_156_gram_matrices.txt)
records the period, primitive algebraic, and generic full algebraic lattices,
including the discriminant-form symbols of the first two.

The module guides identify current scripts and saved results. Some retained
development notes describe earlier stages whose intermediate files are not
part of this repository. The [environment guide](ENVIRONMENT.md) records the
versions used for each saved run: the original OSCAR search used 1.7.3,
whereas later lattice computations used 1.8.2. These are not a uniform
upgrade of the original search. The [references](REFERENCES.md) list
mathematical literature and software. Reading the saved results does not
require rerunning the enumerations.

Original source programs are available under the [MIT License](LICENSE-CODE);
saved results and explanatory
documents are available under [CC BY 4.0](LICENSE-RESULTS). The [license
overview](LICENSE) explains the boundary between the two.

The machine-readable [citation file](CITATION.cff) describes the repository.
Once a released archive has a DOI, cite that specific version
rather than an unversioned repository state.
