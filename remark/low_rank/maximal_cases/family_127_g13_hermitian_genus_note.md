# No. 127: uniqueness inside the saved Hermitian genus

This note concerns the rank-five Hermitian lattice over
\(E=\mathbb Q(i)\) whose trace lattice and order-four action were
saved in `family_127_g13_global_preflight.mrdi`. It is not a uniqueness
claim about embeddings of \(A\) into the geometric \(Q\), or about
the displayed cubic equation.

The local calculation identifies its Hermitian genus as #13 in the
recorded list of 19 genera. It has Hermitian signature \((4,1)\), since
the trace lattice has signature \((8,2)\). Its ring of integers is
\(\mathbb Z[i]\), which has class number one. The script constructs
\(E\) as the fourth cyclotomic field, uses `maximal_order(E)`, and
asserts `genus(H)==gene[13]` after creating the representative. In
[Hecke's Hermitian-genus documentation](https://docs.hecke.thofma.com/v0.39/manual/quad_forms/genusherm),
this object is a global genus symbol of integral Hermitian lattices,
not merely the rational Hermitian space.

[Kirschmer, Theorem 3.7](https://www.math.rwth-aachen.de/~Markus.Kirschmer/papers/det.pdf)
states that the determinant group of the automorphism group of a local
Hermitian lattice is the full local norm-one unit group except in a
specified ramified, even-rank case. Rank five excludes that exception
at every finite place; no unimodularity or maximality assumption is
needed. Thus the exceptional-place set \(P(\mathcal L)\) in the paper's
Section 4 is empty, and its groups \(E(\mathcal L)\) and
\(R(\mathcal L)\) are trivial. The Gaussian class group is also
trivial. [Lemma 4.6](https://www.math.rwth-aachen.de/~Markus.Kirschmer/papers/det.pdf)
therefore gives exactly one special genus in this genus. Because the
Hermitian space is indefinite, [Remark 4.8(2)](https://www.math.rwth-aachen.de/~Markus.Kirschmer/papers/det.pdf)
and strong approximation give exactly one integral isometry class in
that special genus. Consequently the saved global representative is
the **only Hermitian lattice class in genus #13**. Here Hermitian
isometry means an integral trace-lattice isometry commuting with the
order-four complex structure \(J\).

Combined with the exact integral orbit certificates
`verify_family_127_g13_k_v_orbit.py` and
`verify_family_127_g13_phi_orbits.py`, this removes both the
global-Hermitian-class and the 6,144-map N-gluing ambiguity **within
the chosen genus #13 and chosen geometric \(A\hookrightarrow Q\)
setting, with the fixed canonical \(M,J_M\)**. The E-side plane-fixed
96-map orbit then gives one plane-decorated full-lattice action class
for these fixed inputs and the fixed E-side action.
Other primitive embeddings of \(A\) into the geometric \(Q\), or a
direct integral comparison with the specified coordinate cubic's
full \(H^4\) action, are not settled here.

The qualification about embeddings is substantive. In
\(Q=U\oplus\langle2\rangle\oplus\langle-2\rangle\oplus E_8(2)\),
two orthogonal roots of the \(E_8\) factor span a primitive
\(A\cong\langle4\rangle^2\). Primitivity follows since a possible
index-two saturation would contain a half-root or half-sum of these
roots, contrary to evenness of \(E_8\). Its complement is
\(U\oplus\langle2\rangle\oplus\langle-2\rangle\oplus D_6(2)\) and
has \(\delta=1\), whereas the chosen embedding's complement has
\(\delta=0\). Hence the *bare* primitive embeddings are not all
\(O(Q)\)-equivalent. We have not determined which additional
embeddings are compatible with the required \(g,s\), plane, and
full-cohomology gluing data. The displayed \(\delta=1\) embedding
itself is ruled out by the required equivariant index-64
\(D_6(2)\oplus K\to N\) glue: the \(J+I\)-rank on the
integral-quadratic-value hyperplane of \(A_K[2]\) is two, while the
\(D_6(2)\) side requires at least three. The argument is in
`family_127_local_module_criterion.md`. This exclusion does not
prove uniqueness of the remaining embeddings, even before adding
the \(g,s\) and plane decorations: the bare \(\delta=0\) orbit
question has not been checked.
