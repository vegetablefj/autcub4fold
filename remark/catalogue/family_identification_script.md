# Identifying the four ambiguous high-rank family blocks

This note connects four geometric family labels to the saved integral
lattice actions used by the numbered catalogue. It states the mathematical
criteria alongside the exact computational checks. The source table is in
`ambient_completion/sources/family_156_sources_current.md`.
Here `No.` refers to the 156-family numbering in
`../input/family_numbering.md`; `case/output` refers to the frozen
`../../oscar/oscar_script_data.mrdi`. An abstract group ID, a generic index,
or the trace of one selected generator can fail to distinguish two rows.

| Geometric numbers | Saved action or embedding | Decisive comparison |
| --- | --- | --- |
| `M10`: 5, 6 | Two primitive gluings in `m10_gluings.mrdi` | Residual lines \(\langle e_1/3\rangle\), \(\langle e_2/3\rangle\); the norm-\(-12\) vector has ambient divisibility 3, 1. Equation signs require the real-pencil argument below. |
| `L_2(7):2`: 13, 14 | OSCAR case 3 / outputs 1, 2 | Saturated negative eigensublattices \(\langle-2\rangle\oplus\langle-28\rangle\), \(\langle-4\rangle\oplus\langle-14\rangle\); the Clebsch real structure assigns the two equation signs. |
| `S_3,3`: 35–38 | Case 15 / output 2 is 36; output 1 is 38. Cubing the extra actions of Nos. 36 and 38 gives 35 and 37. | The two index-six full groups have IDs `[216,170]` and `[216,157]`; their index-two component groups have IDs `[72,46]` and `[72,40]`. |
| `A_3,3`: 56, 57 | Case 23 / outputs 1, 2 | The **whole** 18-element primitive Hodge-character coset has distinct \((\operatorname{tr}g,\operatorname{tr}g^2)\) histograms. |

The current, structurally checked 156-row ambient file is
`ambient_completion/lattice_156_standard_ambient_20261004.mrdi`. It is a
compiled catalogue, not the raw enumeration. The historical
`lattice_156_with_105_pairs_20261002.mrdi` made a provisional case-3
row assignment; the later correction retained both candidates until the
equation-sign proof was supplied. In the current source table, Nos. 13 and
14 are paired by the **actual saturated negative eigenlattice** of each
saved action and the real-structure criterion below. Earlier source
tables or checkpoint notes that say “unassigned” describe that earlier
state. The source table's status is an audit of provenance, not a rerun of
the original search.

## M10: embeddings and equation signs

The common lattice is \(T=\langle-12\rangle\oplus\langle-30\rangle\)
with basis \(e_1,e_2\). `verify_m10_gluings.jl` tests the index-three
submodules on the \(T\)-discriminant side. Two admit the required
anti-isometry to \(A_S\); the resulting ambient lattices are even of
signature \((20,2)\) and determinant 3, with primitive orthogonal copies
of \(S,T\). Their residual lines give the divisibility split in the
table above. The two explicit gluings and their reload check are in
[`m10_gluings.md`](m10_gluings.md) and `m10_gluings.mrdi`.
Completeness of the two primitive-embedding classes uses Laza–Zheng's
classification; enumerating those two submodules alone is not a new
completeness proof.

`verify_m10_lz_koike_conjugacy.g` checks all 56 coefficients of an
invertible change of coordinates. It sends the corrected Koike \(F_+\)
to Laza–Zheng's \(X^1(M_{10})\), No. 5, and \(F_-\) to its specified
Galois conjugate, No. 6. The word *corrected* matters: the printed plus
signs on three blocks of the arXiv version of Koike's auxiliary cubic
fail invariance under its stated matrices. `m10_check_invariant_cubics.g`
and the conjugacy script check the corrected form.

The coordinate identities label the equations but do not select a
primitive gluing. The latter is assigned by the real-pencil criterion:
for \(F_t=f-tg_*\),
`m10_surface_slope_exact.sing` and `m10_projective_subgroups.g`
exclude singular fibers on \(7-3\sqrt6\leq t\leq0\). At \(t=0\),
the classified non-Clebsch \(A_7\) lattice and its 7-primary gluing
give a conjugation-fixed line of norm \(-30\). Equivariant transport to
\(F_-\) retains that line, so \(F_-\) has residual
\(\langle e_2/3\rangle\); \(F_+\) has \(\langle e_1/3\rangle\).
The exact scripts check the finite algebra and singular-parameter
claims. The conjugation and transport step is the mathematical argument
stated here; it is not a field stored in the MRDI file.

## L2(7):2: the two integral involutions

The common rank-three \(T\) has Gram matrix
\(\left(\begin{smallmatrix}-2&1&0\\1&10&0\\0&0&-28\end{smallmatrix}\right)\).
For \(v_1=(1,2,0)\) and \(v_2=(7,-7,3)\), the map
\(x\mapsto(x,v_j)v_j/21-x\) is an integral involution. Both fixed
lines have norm 42, but the saturated negative eigensublattices in the
table are nonisometric. `verify_l27_split.jl --check-saved` checks the
unique \(T\)-side index-three gluing, the two involutions, the residual
3-torsion extension condition, and the two original case-3 ambient
records. No action enumeration is repeated.

The geometric sign assignment uses the real
Clebsch–Segre cubic at \(P=0\), the classified transcendental lattice,
and the smooth real path to \(P+(3\sqrt2/2)Q\). Its real outer
normalizer commutes with the transported real structure; the latter
selects the branch whose negative eigensublattice contains a
square-\(-2\) vector. Thus the plus cubic is No. 13 / case-3 output 1;
the minus cubic is No. 14 / output 2. The small exact-integer part of
this argument is independently checked by `verify_l27_real_structure.py`.
The smoothness and normalizer inputs are taken from the cited geometric
work, rather than proved by that Python script.

## S3,3: identify the component before taking powers

The case-15 search retained two index-six outputs of the same order and
dimension. [`../../oscar/oscar_result.md`](../../oscar/oscar_result.md) records
output 1 as `[216,157]` and output 2 as `[216,170]`. The geometric
component list in `../../gap_classification/gap_saturation/gap_large_family_candidates.md`
places `[216,170]` with the Koike component and its generic-index-two
group `[72,46]` (Nos. 36 and 35). It places `[216,157]` with the
corrigendum component and `[72,40]` (Nos. 38 and 37). The frozen
numbering and literal containment were checked in the saved rank-18
restriction; see [`ambient_completion/rank18_16/README.md`](ambient_completion/rank18_16/README.md).

On each **identified parent ambient lattice**, the full child group is
the inverse image of the unique order-two subgroup of the cyclic
index-six quotient. Its extra ambient action is therefore the cube of
the parent's action. The restriction results are saved in
`ambient_completion/rank18_16/rank18_samepart_powers.restricted.mrdi`;
the verification reconstructs the embedded \(S,T,P,K\), tests gluing
compatibility and roots, and keeps the two component paths separate.
The common abstract \(T\) action of Nos. 35 and 37 alone does not
identify their primitive embeddings. A Hodge-character order of two
also does not imply that the selected full ambient isometry has order
two.

## A3,3: compare a complete coset

For the two generic-index-two, index-six subfamilies, the order,
dimension, group ID `[108,38]`, and selected-generator trace do not
give a safe assignment. `a33_case23/verify_geometric_cosets.g` obtains
the exact geometric trace-pair histograms from the frozen strict
matrices for Nos. 56 and 57. `a33_case23/compare_case23_cosets.jl`
loads both frozen case-23 outputs, reconstructs the order-18 stable
symplectic kernel and order-108 full group, and compares every element
of one primitive coset \(fN\). The matching pairs are:

| Number / saved output | \((\operatorname{tr}g,\operatorname{tr}g^2)\) with multiplicity |
| --- | --- |
| 56 / 1 | \((-1,7)^3,(2,-2)^6,(5,-11)^6,(5,7)^3\) |
| 57 / 2 | \((2,-2)^{12},(5,-11)^6\) |

The geometric trace is computed from form-fixing coordinate matrices
using Chenevert's formula. The OSCAR side calculates traces on the
full primitive rank-22 lattice. The histograms uniquely match the
two saved outputs; `a33_case23/result.md` explains the comparison and
`a33_case23/case23_full_coset_comparison.mrdi` retains the reload-checked
result. Comparing only a chosen generator would be inconclusive:
trace 2 occurs in both geometric groups.

## Rechecking the saved evidence

Use the project root as working directory for the following GAP read;
the script resolves a frozen family source relative to that directory.
An asserted GAP success ends with `PASS`:

```gap
Read("remark/catalogue/verify_m10_lz_koike_conjugacy.g");
```

From `remark/catalogue`, use an existing environment
with OSCAR installed. The two Julia commands construct the small
finite-gluing checks and compare the frozen data; they do not replace
the saved MRDI outputs:

```bash
julia --project=/path/to/existing/oscar-project verify_m10_gluings.jl --check-saved
julia --project=/path/to/existing/oscar-project verify_l27_split.jl --check-saved
python verify_l27_real_structure.py
```

The M10 smoothness certificates can be read independently in Singular
and GAP; their asserted logs are
`m10_surface_slope_asserted_20261002.log` and
`m10_projective_subgroups_asserted_20261002.log`.
From `remark/catalogue`, run the Singular file directly;
the GAP file can be read in a fresh GAP session from the same directory.
Both should end with their own `PASS` line.

```bash
Singular m10_surface_slope_exact.sing
```

```gap
Read("m10_projective_subgroups.g");
```

The rank-18 power restriction is saved in
[`ambient_completion/rank18_16/rank18_samepart_powers.restricted.mrdi`](ambient_completion/rank18_16/rank18_samepart_powers.restricted.mrdi).

From `remark/catalogue/a33_case23`, the geometric
GAP check prints both exact histograms. The OSCAR preflight reads and
checks the frozen case-23 source without computing `O(S)`. Its
full comparison is already saved, so repeat that substantial calculation
only if the source or algorithm changes; see `a33_case23/README.md`.
The environment-variable syntax below is for Bash or WSL.

```gap
Read("verify_geometric_cosets.g");
```

```bash
A33_CASE23_PREFLIGHT=1 julia --startup-file=no --compile=min -O0 \
  --project=/path/to/existing/oscar-project compare_case23_cosets.jl
```

For the current result, the original search and large full-group
reconstructions need no rerun. A changed frozen source, failed
reloaded comparison, or a changed geometric equation would be a
specific reason to repeat the relevant stage. A catalogue-wide
structural receipt alone does not certify those identifications or
repeat the root and saturation tests.
