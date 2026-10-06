# Family No. 127: finite E6(2)-side involution check

`verify_family_127_e6_involution.jl` checks the **finite** part of the
Marquand-based construction. It uses the E6 Dynkin basis already stored in
`family_127_eckardt_glue-first_manual.mrdi`, but does not load that file or
repeat its gluing. The order-four generator acts on this rank-six lattice as
minus the diagram involution. The vector
`(1,2,0,-2,-1,0)` is the rank-six coordinate of the invariant plane class
`3[Pi]-h^2`; its norm in E6(2) is 24. Its divisibility 3 in the full
primitive lattice was checked separately against the saved MRDI result.

The required symplectic involution must commute with the order-four action,
fix the plane class, and have traces 2 and -2 for itself and its product
with the order-four action on E6(2). These traces also follow from the
fixed loci of the displayed coordinate action. The script constructs the
72 E6 roots, the folded Weyl centralizer of order 1152, and its plane
stabilizer of order 384. The standard root-system identification
`C_{W(E6)}(diagram) = W(F4)` shows that the folded generators exhaust the
Weyl centralizer. Together with the diagram coset, they exhaust the
centralizer in `O(E6)`.

The script asserts that exactly four matrices meet the conditions. It prints
all four, exhibits each as a product of reflections in two orthogonal
roots, and verifies that the plane stabilizer conjugates the selected seed
`r_1 r_5` to every other candidate. Thus the E6(2)-side involution is
unique up to isometry preserving both the order-four action and the
specified plane class, although its literal matrix is not unique.

The four products can be represented by the following root pairs in the
displayed E6 basis (changing the sign of either root leaves the reflection
unchanged):

| Candidate | First root | Second root |
| --- | --- | --- |
| 1, selected seed | `(1,0,0,0,0,0)` | `(0,0,0,0,1,0)` |
| 2 | `(1,1,1,1,0,1)` | `(0,1,1,1,1,1)` |
| 3 | `(1,1,1,1,0,0)` | `(0,1,1,1,1,0)` |
| 4 | `(1,1,2,1,0,1)` | `(0,1,2,1,1,1)` |

Run with Julia and OSCAR 1.8.2 from this directory:

```bash
julia --startup-file=no --project=/path/to/oscar-project verify_family_127_e6_involution.jl
```

The exact matrices and conjugating witnesses appear on screen and in
`family_127_e6_involution.out`. A repeat run checks that the saved output
agrees instead of overwriting a differing file. This is a small finite
verification; it does **not** find the involution on
`U^2 + D4^3`, check preservation of the index-64 gluing, or identify the
full lattice action with No. 127.

The local WSL test on 2026-09-29 completed with Julia 1.10.11 and OSCAR
1.8.2 under a three-minute limit, `MemoryHigh=2 GiB`, `MemoryMax=3 GiB`,
and no swap. It generated and checked the saved `.out` file. No other
OSCAR lattice enumeration was launched by this test.
