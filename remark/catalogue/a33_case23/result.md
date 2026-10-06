# The two A_{3,3} index-six lattice actions

The saved OSCAR case 23 has two full-action outputs. Comparing the complete
18-element primitive index-six coset with the final Koike-aligned geometric
actions gives the following numbered assignment.

| Saved OSCAR output | Family | Primitive trace-pair distribution `((tr g, tr g²), count)` |
| --- | --- | --- |
| 1 | No. 56 | `((-1, 7), 3)`, `((2, -2), 6)`, `((5, -11), 6)`, `((5, 7), 3)` |
| 2 | No. 57 | `((2, -2), 12)`, `((5, -11), 6)` |

Here the traces are on primitive fourth cohomology. For each output,
`compare_case23_cosets.jl` reconstructs the discriminant kernel
`K = ker(O(S) -> O(q_S))` (order 18), checks that adjoining the saved extra
isometry gives a projective group of order 108, and evaluates both traces on
every element of the coset `fK`. The geometric distributions are computed
independently from the frozen form-fixing matrices for Nos. 56 and 57 by
`verify_geometric_cosets.g`, using Chenevert's trace formula. The GAP check
and the OSCAR comparison both completed successfully on 2 October 2026.

The comparison is of the whole coset, not just a selected generator: trace
`2` occurs in both geometric groups. The two distributions are distinct, and
each of the two complete saved actions matches exactly one numbered family.
This identifies the two lattice-action records without repeating the
original lattice enumeration.

The OSCAR run used Julia 1.10.11 and OSCAR 1.8.2 under WSL. Its final
`case23_full_coset_comparison.mrdi` was saved and reloaded successfully.
The frozen source was `oscar_script_data.mrdi`.
Neither frozen source nor the existing 156-row catalogue was modified by
this computation.
