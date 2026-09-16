# Computational materials for cubic threefolds and fourfolds

This repository collects code, saved outputs, and readable results for
computations concerning automorphism groups of smooth cubic threefolds and
fourfolds. The four principal directories are:

| Directory | Contents |
| --- | --- |
| [`gap_yyz_bounds/`](gap_yyz_bounds/README.md) | Abstract group-theoretic bounds and their GAP record. |
| [`oscar/`](oscar/README.md) | Lattice calculations, saved OSCAR objects, and their interpretation. |
| [`gap_classification/`](gap_classification/README.md) | Representation enumeration, smoothness, liftability, conjugacy, and containment checks. |
| [`gap_result/`](gap_result/README.md) | Ordered fourfold and threefold catalogues and their containment relations. |

The catalogues contain 156 cubic-fourfold families and 40
cubic-threefold families. The [fourfold result](gap_result/fourfold_result.md)
and [threefold result](gap_result/threefold_result.md) are readable without
running the calculations. Their corresponding GAP files retain the exact
matrix groups and relation data. Family numbers follow the ordered fourfold
catalogue; threefold numbers use increasing source-fourfold order.

Each module README identifies its executable files, saved inputs, outputs,
and working directory. The [environment guide](ENVIRONMENT.md) records the
software versions used for the saved runs; the [references](REFERENCES.md)
list mathematical literature and software. Reading the saved results does not
require rerunning the enumerations.

The four directories listed above contain the current computational records.

Jie Fu and Shihao Wang (both at Qiuzhen College, Tsinghua University) and
Zhiwei Zheng (Yau Mathematical Sciences Center, Tsinghua University) are equal
contributors and joint copyright holders. Original source programs are
available under the [MIT License](LICENSE-CODE); saved results and explanatory
documents are available under [CC BY 4.0](LICENSE-RESULTS). The [license
overview](LICENSE) explains the boundary between the two.

To cite these materials, credit all three authors equally. The
machine-readable [citation file](CITATION.cff) supplies their names and ORCID
identifiers. Once a released archive has a DOI, cite that specific version
rather than an unversioned repository state.
