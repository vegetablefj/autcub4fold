# No. 127: a local obstruction for the natural fixed-lattice genus

Let $K$ be an even lattice of rank $10$ with
$A_K\cong(\mathbb Z/4)^2\oplus(\mathbb Z/2)^6$, and let
$J\in O(K)$ satisfy $J^2=-I$. Put
$T_K=\{x\in A_K[2]:q_K(x)\in\mathbb Z/2\mathbb Z\}$.
This note concerns integral isometries of $K$, rather than arbitrary
automorphisms of its finite discriminant form.
Some early tests mentioned below are historical and are not included in the
release; the selected construction is checked in
`family_127_g13_full_l_postcheck.md`.

**Fixed classes have integral quadratic value.** If $x\in A_K$ is fixed
by $J$, choose $y\in K^*$ representing $x$. Then $y-Jy\in K$.
Orthogonality and $J^2=-I$ give $(y,Jy)=0$, so
$(y-Jy)^2=2y^2$. Since $K$ is even, $y^2\in\mathbb Z$.
In particular,

$$
\ker(J+I\mid A_K[2])\subseteq T_K.
$$

If $q_K$ is nonintegral on some $2$-torsion class, then $T_K$ is a
hyperplane in $A_K[2]$. Because $J^2=-I$ acts trivially there,
$(J+I)^2=0$; the preceding inclusion yields

$$
\operatorname{rank}(J+I\mid T_K)
 =\operatorname{rank}(J+I\mid A_K[2])-1.
$$

**Integral Hermitian parity.** Work over
$\mathcal O=\mathbb Z_2[i]$ with uniformizer $\pi=1+i$.
The lattice $K\otimes\mathbb Z_2$ is free of rank $5$ over
$\mathcal O$. Its integral Hermitian form can be taken as
$H(x,y)=(x,y)+i(x,Jy)$. The bilinear dual and Hermitian dual agree,
because the lattice is $J$-stable. Modulo $\pi$, conjugation is
trivial and $H(x,x)=(x,x)$ vanishes because $K$ is even. Hence
$H\bmod\pi$ is alternating and has even rank.

Let $m$ be the number of nonzero $\pi$-primary cyclic factors of
$A_K$, equivalently the number of positive $\pi$-Smith exponents of
$H$. Then $5-m$ is even. Since $A_K[2]$ has dimension $8$ over
$\mathbb F_2$, and each cyclic factor contributes at most two
dimensions, $m\ge4$. Therefore $m=5$. A factor of length one
contributes one dimension to $A_K[2]$ and zero to the rank of $J+I$;
a longer factor contributes two dimensions and rank one. It follows that

$$
\operatorname{rank}(J+I\mid A_K[2])=8-5=3.
$$

For the displayed abelian group, the only possible $\pi$-partitions
compatible with $m=5$ are $[4,2,2,1,1]$ and
$[3,3,2,1,1]$. The partitions $[4,2,2,2]$ and
$[3,3,2,2]$ would give $m=4$, hence odd rank one for
$H\bmod\pi$, and cannot come from an even integral $K$.
If the $Q=L^{-(hs)}$ glue requires $J$ to swap the two nonzero
quadratic-value-one elements of $2A_K$, then $[3,3,2,1,1]$ is also
excluded: each length-three factor contributes a one-dimensional,
$J$-fixed summand to $2A_K$. The remaining partition
$[4,2,2,1,1]$ is a necessary local condition, not a sufficient
condition for an integral isometry or any lattice glue.

For $M=D_6(2)$, the same module argument starts with
$\mathcal O$-rank $3$ and
$\dim_{\mathbb F_2}A_M[2]=6$. Thus every integral pure
order-four $J_M$ has
$\operatorname{rank}(J_M+I\mid A_M[2])=3$.
An index-$64$ graph glue $M\oplus K\to N$ identifies all of
$A_M[2]$ with a six-dimensional subspace of $A_K[2]$. Since
$q_M$ is integral on $A_M[2]$, this image must lie in $T_K$.
Consequently any such equivariant glue requires
$\operatorname{rank}(J+I\mid T_K)\ge3$.
The preceding equations rule out every $K$ with nonintegral
$q_K\mid A_K[2]$, including the natural model
$U\oplus\langle2\rangle\oplus\langle-2\rangle\oplus D_6(2)$,
for **all** integral pure order-four actions. They do not rule out a
different genus with $q_K\mid A_K[2]$ integral; for such a genus
$T_K=A_K[2]$ and this rank obstruction disappears. Compatibility
with Marquand's $Q$, the target $N$, and the full cubic lattice
remains to be checked.

## The \(Q\)-side characteristic-class test

Write
\[
Q_{\mathrm{target}}
 =U\oplus\langle2\rangle\oplus\langle-2\rangle\oplus E_8(2),
\qquad A=\langle4\rangle^2,
\]
and let \(p,n\) generate the two rank-one summands. Suppose
\(A=\mathbb Z v_1\oplus\mathbb Z v_2\) is primitive in \(Q\), the
\(v_i\) are orthogonal of norm four and divisibility two, and its
complement \(K=A^\perp_Q\) has
\(A_K\cong(\mathbb Z/4)^2\oplus(\mathbb Z/2)^6\). The index of
\(A\oplus K\) in \(Q\) is four. Since \((v_i,Q)\subseteq2\mathbb Z\),
the projection of its glue subgroup to \(A_A\) is
\(2A_A=\langle[v_1/2],[v_2/2]\rangle\); it has order four, so this
projection is exactly \(2A_A\). For every \(k\in A_K\),
nondegeneracy of the \(A_A\) pairing lets one choose \(a\in A_A\)
with \((a,k)\) orthogonal to the glue. As \(A_Q=H^\perp/H\) has
exponent two, \(2k\) lies in the other glue projection \(H_K\).
Thus \(2A_K\subseteq H_K\); both have order four, so
\(H_K=2A_K\).

Put \(w_i=[v_i/2]\in A_Q\) and \(W=\langle w_1,w_2\rangle\).
The induced embedding of \(A_K[2]\) into \(A_Q\) has image
\(B=W^\perp\): classes \((0,k)\), \(k\in A_K[2]\), are orthogonal
to the glue since \(2k=0\), giving an injective group of order
\(2^8=|W^\perp|\). The quadratic values agree under this embedding.
Because \(A_Q\) is two-elementary, \(x\mapsto q_Q(x)\bmod\mathbb Z\)
is a linear functional. Its characteristic element is
\[
c_Q=[(p+n)/2]\in A_Q,\qquad
b_Q(c_Q,x)=q_Q(x)\pmod{\mathbb Z}.
\]
Consequently
\[
\delta_K=0
\ \Longleftrightarrow\
q_K(A_K[2])\subseteq\mathbb Z/2\mathbb Z
\ \Longleftrightarrow\
c_Q\in W.
\]
Here \(q_Q(w_1)=q_Q(w_2)=1\), \(b_Q(w_1,w_2)=0\), and
\(q_Q(c_Q)=0\) with \(c_Q\ne0\); hence in this situation the
condition is precisely \(c_Q=w_1+w_2\). This is a necessary and
sufficient test for the *integral-valued two-torsion* condition in a
given primitive embedding, not a test for an order-four action or
for the \(N\)-side glue.

It is not vacuous. Choose roots \(r,t\in E_8(2)\) with
\(r^2=t^2=4\), \((r,t)=2\), and a hyperbolic basis \(e,f\) of \(U\).
Then
\[
v_1=r,\qquad
v_2=p+n+2(t+e-f)-r
\]
are orthogonal norm-four vectors of divisibility two. Their
reductions modulo two are independent, so \(A\) is primitive:
any saturation index would divide \(\sqrt{\det A}=4\), while
independence rules out an index-two enlargement. Moreover
\[
(v_1+v_2)/2=(p+n)/2+t+e-f,
\]
so \(c_Q=w_1+w_2\) and \(\delta_K=0\). The bounded exact OSCAR
calculation in `run_family_127_q_explicit_complement.jl` /
`family_127_q_explicit_complement.out` additionally verifies
\(\operatorname{sig}K=(8,2)\), \(\det K=1024\), and the required
abelian discriminant group. It does **not** construct an integral
order-four isometry of this \(K\).
An independent finite enumeration in
`verify_family_127_q_complement_integer.py` /
`family_127_q_complement_integer.out` gives the sharper
quadratic-form identification
\[
q_K\cong\langle1/4\rangle^{\oplus2}
 \oplus u(2)^{\oplus2}\oplus v(2).
\]
It finds orthogonal order-four generators of value \(1/4\);
their orthogonal complement has order \(64\), exponent two, and
\(28\) zero-value elements, hence Arf invariant one.

## Why the simple \(\delta_K=0\) model still fails on \(Q\)

Let
\[
R=\begin{pmatrix}0&1\\-1&0\end{pmatrix},\quad
C=I+R,\quad
G_4=\begin{pmatrix}0&C\\C^{\mathsf T}&0\end{pmatrix},
\quad J_4=\operatorname{diag}(R,R),
\quad K_0=G_4\oplus D_6(2).
\]
Then \(G_4\cong U\oplus U(2)\), \(J_4^2=-I\), and
\(J_4G_4J_4^{\mathsf T}=G_4\). Together with the standard pure
order-four \(J_6\) on \(D_6(2)\), this gives an integral \(J_0\)
on \(K_0\), with \(\delta_{K_0}=0\) and
\(\operatorname{rank}(J_0+I\mid A_{K_0}[2])=3\).
The subgroup \(2A_{K_0}\) is two-dimensional; its two nonzero
quadratic-value-one elements are swapped by \(J_0\). There are
exactly two quadratic-form-preserving index-four graph maps from
\(2A_A\) to \(2A_{K_0}\), and both are equivariant for the
order-two negative swap \(g|A\) and the order-four \(J_0=g|K_0\).
Only their actions on the 2-torsion glue must agree; \(g|A\) is
**not** a quarter-turn. Nonetheless,
both resulting \(Q\) discriminant forms are integral-valued on all
their two-torsion, so \(\delta_Q=0\), contrary to the target
\(\delta_{Q_{\mathrm{target}}}=1\). The exact integer verification is
`verify_family_127_k0_integer.py` /
`family_127_k0_integer.out`. Thus \(\delta_K=0\), the rank-three
condition, and the \(2A_K\) swap are not sufficient for the \(Q\)
side. The actual complement above has a different 2-adic genus from
\(K_0\); the bounded local comparison
`run_family_127_q_local_genus_compare.jl` identifies it with
Hermitian local genus #13, while \(K_0\) matches #14. Subsequently,
`run_family_127_g13_global_preflight.jl` returned one global
Hermitian representative with an integral \(J^2=-I\), saved its Gram
matrix and action, and verified that its trace lattice is isometric
to the actual complement. This proves existence of an integral
order-four action on the abstract complement. A subsequent bounded
check established both equivariant index-four \(Q\) graph gluings,
including integral \(g,h,s\), target-lattice isometry, and the coarse
geometric finite-action fingerprint; see
`family_127_g13_q_graph_preflight.out`. This does
not establish the \(N\)- or full cubic-lattice glue.

## Bounded \(N\)-side finite search

For \(M=D_6(2)\), it is enough to fix one standard integral
\(J_M^2=-I\). Indeed the full automorphism group of \(D_6\) is the
signed-permutation group on its six Euclidean coordinates. The
permutation part of such a \(J_M\) must consist of three disjoint
transpositions: a fixed coordinate would square to \(+1\), while
on each transposed pair the two signs must multiply to \(-1\).
Permuting the pairs and changing coordinate signs conjugates every
such action to three identical quarter-turn blocks. Scaling the
form by two does not change its isometry group.

For the saved genus-#13 action put
\[
T=A_K[2],\quad D=J_K+I,\quad U=D(T),\quad R_K=2A_K.
\]
Here \(\dim T=8\), \(\dim U=3\), \(\dim R_K=2\), and
\(\dim(U\cap R_K)=1\); these dimensions follow from the
\(\pi\)-partition \([4,2,2,1,1]\) and the verified swap on
\(R_K\). Consider an index-64 graph
\(H=\operatorname{graph}(\phi)\) with
\(\phi:A_M[2]\stackrel{\sim}{\longrightarrow}V\subset T\).
Equivariance makes \(V\) a free rank-three
\(\mathbb F_2[\epsilon]/(\epsilon^2)\)-module, so \(D(V)=U\) and
\(U\subseteq V\). If the resulting discriminant group
\(A_N=H^\perp/H\) has exponent two, then \(R_K\subseteq V\):
the projection \(H^\perp\to A_K\) is surjective, and doubling any
preimage must land in \(H\). Thus \(V\) contains the
four-dimensional \(U+R_K\); there are only
\({4\brack2}_2=35\) six-dimensional candidates before the
module-type and quadratic-form filters. Exactly 16 have
\(\operatorname{rank}(D|V)=3\) for the saved action.

The exponent and \(\delta_N\) tests can be done without building a
rank-16 Gram matrix for every graph. Put \(R_M=2A_M\), of order four.
The projection to the second factor gives the exact sequence
\[
0\longrightarrow R_M\longrightarrow H^\perp/H
 \longrightarrow A_K/V\longrightarrow0,
\]
where \(A_K/V\cong(\mathbb Z/2)^4\). Choose four representatives
\(k_j\) for an \(\mathbb F_2\)-basis of this quotient. The equations
\[
b_M(m_j,t)+b_K(k_j,\phi(t))=0
\quad(t\in A_M[2])
\]
determine \(m_j\in A_M/R_M\) uniquely. Since \(R_M\) has exponent
two, \(A_N\) has exponent two exactly when
\(\phi(2m_j)=2k_j\) for all four \(j\). If this holds, the
quadratic-value-modulo-\(\mathbb Z\) functional on \(A_N\) vanishes
exactly when every \(q_M(m_j)+q_K(k_j)\) is integral; it already
vanishes on \(R_M\). Only maps passing these finite tests need a
rank-16 Gram/action construction and an OSCAR posterior comparison
with \(U^2\oplus D_4^3\). This remains a necessary finite stage,
not an assertion that the full cubic-lattice extension exists.

The reproducible standard-Python implementation is
`run_family_127_g13_n_finite_preflight.py`.
It reads the saved #13 Q-side JSON, enumerates the 35 images and
the at most \(168\cdot2^9=86{,}016\) equivariant isomorphisms per
eligible image, and saves per-image counts and a first witness
for **each** successful image atomically. Its default mode examines
only 256 maps per image; an exhaustive scan requires explicit
`--full` and every image. The completed full scan
recorded 16 eligible images and 1,376,256 equivariant maps in
`family_127_g13_n_finite_full_v1-35.json`; 6,144 maps preserve
the quadratic form, and all 6,144 pass the finite exponent-two and
\(\delta_N=0\) tests. The script also constructs and exactly checks
the first rank-16 Gram/actions for every successful image. This
does not by itself certify abstract isometry with \(U^2\oplus
D_4^3\), still less the full rank-22 extension.
