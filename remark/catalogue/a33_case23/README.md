# Identifying the two A_{3,3} index-six actions

`compare_case23_cosets.jl` reads the frozen OSCAR search data and compares the
**whole primitive index-six coset** of each saved case-23 lattice action with
the character distributions of geometric families Nos. 56 and 57. It does
not rerun the lattice search or modify `lattice_156.mrdi`.

The selected generators alone do not suffice: case-23 output 1 has primitive
cohomology trace `-1`, while output 2 has trace `2`; trace `2` also occurs in
the geometric No. 56 group. For each saved result the script reconstructs
`O(S)`, computes the kernel of its discriminant representation, checks that
this symplectic kernel has order 18 and that the generated full group has
order 108, then records the trace pair of every element in one primitive
non-symplectic coset. The trace pair is `(tr(g|H^4_prim),
tr(g^2|H^4_prim))`. The geometric reference counts are exact projective
counts from the final Koike-aligned matrices, with the trace given by
Chenevert's formula. A successful unique assignment distinguishes the two
full actions independently of which extra generator was selected in the coordinate list.

The MRDI result stores run metadata, each complete 18-element coset
histogram, the two group-order checks, and the matching family number. The
script saves and reloads the result before exiting successfully. If the
histograms do not give a unique assignment, it preserves the computed MRDI
and exits with an error; inspect the data rather than assuming a match.

The local comparison has now completed: saved output 1 is No. 56 and saved
output 2 is No. 57. See `result.md` and the reloaded
`case23_full_coset_comparison.mrdi`.

To recompute the two geometric reference histograms from the frozen
form-fixing matrices, run `gap -q verify_geometric_cosets.g` from this folder.
The GAP script reads `../../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g`,
checks the 18 projective coset representatives and central-scalar invariance,
and prints the exact trace-pair counts without writing a file.

## Local preflight

In an existing Julia environment with OSCAR installed, run from this folder:

```bash
A33_CASE23_PREFLIGHT=1 julia --startup-file=no --compile=min -O0 \
  --project=/path/to/existing/oscar-project compare_case23_cosets.jl
```

This checks the frozen input and case metadata without computing `O(S)` or
writing a result. The full local run is the same command without
`A33_CASE23_PREFLIGHT=1`; reserve enough memory before doing that.
