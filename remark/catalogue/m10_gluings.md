# The two \(M_{10}\) lattice gluings

This check uses the rank-20 \(S\) matrix assigned to both \(M_{10}\) rows of
`lattice_156.mrdi` (entry 4 of `../../oscar/list_S.txt`) and
\(T=\langle-12\rangle\oplus\langle-30\rangle\). It does not use a cubic
equation. The calculation was run with OSCAR 1.8.2.

Let \(e_1,e_2\) be the displayed basis of \(T\). For each of the two residual
subgroups \(R=\langle e_j/3\rangle\subset A_T\), the script takes
\(H_T=R^\perp\), constructs an anti-isometry \(A_S\to H_T\), and calls
`Hecke.primitive_extension`. Of the four index-three subgroups of \(A_T\),
exactly two have a discriminant form anti-isometric to \(A_S\).

| Equation and catalogue row | Residual subgroup \(R\) | \(\operatorname{div}_{\Lambda_0}(e_1)\) | \(|\det(e_1^\perp\cap\Lambda_0)|\) |
| --- | --- | ---: | ---: |
| Laza--Zheng \(X^1(M_{10})\), corrected Koike \(F_+\), No. 5 | \(\langle e_1/3\rangle\) | 3 | 4 |
| Laza--Zheng \(X^2(M_{10})\), corrected Koike \(F_-\), No. 6 | \(\langle e_2/3\rangle\) | 1 | 36 |

For both constructions, the script checks that \(\Lambda_0\) is even of rank 22,
signature \((20,2)\), determinant \(3\), and discriminant form \(q_{A_2}\);
the copies of \(S\) and \(T\) are orthogonal and primitive. It also checks
that \(e_1\) is primitive. Thus the two embeddings cannot be conjugate in
\(O(\Lambda_0)\), since ambient divisibility is preserved. The finite-module
calculation produces these two representatives; the completeness statement
for primitive embeddings uses [Laza–Zheng, §4.5, Lemma 4.25 and the proof of
Theorem 1.8](https://link.springer.com/article/10.1007/s00209-021-02810-x).

`verify_m10_gluings.jl` reproduces the lattice checks. `m10_gluings.mrdi`
stores the two ambient lattices, embedded copies of \(S,T\), and the vectors
\(e_1\). Run the script with `--check-saved` to reload them. The MRDI records
are identified by their residual subgroup; the equation labels in the table
come from separate geometric checks, not from the MRDI file.

`verify_m10_lz_koike_conjugacy.g` gives an invertible coordinate matrix \(B\) and checks
all 56 cubic coefficients in
\(F_+(By)=-54(8+3\sqrt6)F_{\mathrm{LZ}}(y)\) and
\(F_-(By)=-54(8-3\sqrt6)F_{\mathrm{LZ}}^{\sigma}(y)\), where
\(\sigma(\zeta_{24})=\zeta_{24}^7\). The latter equation is catalogue No. 6.
Run this GAP script from the workspace root, because it reads the numbered
family source by a workspace-relative path. The
[asserted run](m10_lz_koike_conjugacy_asserted_20261002.log) ends in `PASS`;
that final line, rather than GAP's process exit code alone, is the success
condition.
These identities use the \(3.A_6\)-invariant cubic
\(g=3\mathcal A-4\mathcal B-5\mathcal C-8\mathcal D\), with
\(\mathcal A,\mathcal B,\mathcal C,\mathcal D\) the four monomial sums in
Koike (2.8). The plus signs on the last three blocks in the local arXiv
copy fail invariance under its stated matrices.

To identify the gluing, take the real pencil \(F_t=f-tg\). The scripts
`m10_surface_slope_exact.sing` and `m10_projective_subgroups.g` together
certify that \(F_t\) stays smooth for \(7-3\sqrt6\leq t\leq0\). The first
excludes positive-dimensional singular loci for every real \(t\): a fixed
hyperplane meets no singular point, because elimination in all six charts
gives \(8t^2+5t+5\), which has no real root. Isolated singular points, if
present, number at most \(2^5=32\) by a generic intersection of five
partial-derivative quadrics. The second script checks the common eigenlines
of all \(A_6\) subgroup classes of index at most 32; the only possible real
singular parameters are \(-1,1/4,7\), outside this interval.
The [asserted Singular rerun](m10_surface_slope_asserted_20261002.log)
checks the initial Jacobian dimension and the elimination ideal in each chart;
its final `PASS` line is reached only when all six checks succeed.
The subgroup script's [asserted rerun](m10_projective_subgroups_asserted_20261002.log) checks
all nine relevant subgroup classes and ten common eigenlines. Every nonempty
common eigenspace is one-dimensional; a higher-dimensional eigenspace or an
unexpected finite singular parameter now stops the script with an error.

At \(t=0\), \(f\) is the non-Clebsch \(A_7\) cubic, with transcendental
lattice \(K\cong-\left(\begin{smallmatrix}18&3\\3&18\end{smallmatrix}\right)\).
Complex conjugation fixes the primitive norm-\(-30\) vector in \(K\): its
class divided by 3 is the unique residual discriminant line of quadratic
value \(2/3\), and conjugation fixes the ambient discriminant group. It
negates the orthogonal norm-\(-42\) direction. Let \(L_{A_6}\) be the
rank-three \(A_6\)-invariant lattice, of determinant 540, and let
\(U=K^\perp\cap L_{A_6}\). If \(m=[L_{A_6}:K\oplus U]\), then \(U\) has
norm \(12m^2/7\), so \(7\mid m\).
The nontrivial 7-primary gluing is on the norm-\(-42\) direction and forces
conjugation to negate \(U\). Equivariant Gauss--Manin transport along the
smooth real path therefore keeps \(L_{A_6}^c\cong\langle-30\rangle\).
At \(F_-\), the positive rank-one
orthogonal complement of its transcendental lattice in \(L_{A_6}\) is
conjugation-stable but cannot be fixed, so its negative-definite rank-two
transcendental lattice contains the fixed norm-\(-30\) line. Of the two primitive
gluings above, exactly \(R=\langle e_2/3\rangle\) has this property. The
remaining \(F_+\) model therefore has \(R=\langle e_1/3\rangle\).
