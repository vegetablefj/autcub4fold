# Cubic-fourfold lattice actions

This directory contains lattice actions for the 156 fourfold families,
their restrictions, and their very general algebraic lattices.
Family numbers follow [the fixed input table](input/family_numbering.md).

| Directory | Contents |
| --- | --- |
| [`input/`](input/README.md) | Family numbering and coordinate matrix groups. |
| [`enumeration/`](enumeration/README.md) | Common high-rank and cyclic searches, saved runs, and postchecks. |
| [`low_rank/`](low_rank/README.md) | The six low-rank maximal cases, including the order-four construction. |
| [`catalogue/`](catalogue/README.md) | Family comparisons, restrictions, assembly, and algebraic lattices. |
| [`gap_checks/`](gap_checks/README.md) | Character summaries for the supporting subgroup comparisons. |

The final [MRDI](catalogue/assembly/lattice_156_with_algebraic.mrdi)
contains a compatible embedded action and the generic algebraic lattice
for every family. The [Gram export](catalogue/assembly/lattice_156_gram_matrices.txt)
lists the period and primitive algebraic lattices, their discriminant forms,
and the generic full algebraic lattice.
The [result guide](catalogue/lattice_remarks_result.md) and
[assembly guide](catalogue/assembly/README.md) explain the sources and checks.

Computations use OSCAR 1.8.2. The saved Brown runs use Julia 1.12.4;
the local catalogue assembly uses Julia 1.10.11.
Some subgroup and coordinate comparisons use GAP.
The original OSCAR 1.7.3 inputs and results are read from
[`../oscar/`](../oscar/README.md); existing group computations are read from
[`../gap_classification/`](../gap_classification/README.md).
See [the environment guide](../ENVIRONMENT.md) for dependencies.
