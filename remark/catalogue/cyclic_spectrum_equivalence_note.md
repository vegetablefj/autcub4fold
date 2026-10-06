# Geometric criterion for duplicate cyclic lattice actions

The No. 24 restriction file has three parent-conjugacy classes with the No. 136 primitive-cohomology character and three with the No. 141 character. The analogous No. 41 search has three matching classes for each of Nos. 140 and 143. Parent conjugacy and character equality alone do not decide whether the rank-22 integral lattice actions are equivalent. The argument below gives a conditional equivalence proof for all four cases; it does not assert that the geometric hypothesis has already been checked for every saved lattice candidate.

## Realization hypothesis

Each candidate \(A=n f^q\) in a saved parent lattice group must be the marked action on \(H^4_{\mathrm{prim}}(X,\mathbb Z)\) of an actual projective automorphism \(g\) of one smooth parent cubic \(X\). The traces of all powers of \(A\) must agree with those of that automorphism. This requires a checked identification of the saved lattice group with the geometric parent group, or an applicable Torelli and saturation argument. The MRDI file and its internal group checks do not, on their own, provide that identification.

Under this hypothesis, the three actions for each numbered family are integrally conjugate, including their recorded generator choices. The proof uses the projective spectrum of a form-fixing linear lift and a connected family of smooth invariant cubics. The needed trace fingerprints are those of No. 136 (order 3: \(-2\)), No. 141 (orders \(6,3,2\): \((2,-2,-10)\)), No. 140 (order 3: \(1\)), and No. 143 (orders \(6,3,2\): \((1,1,-2)\)). The last two fingerprints must be checked against the No. 41 candidate log when this criterion is applied there.

## Exact spectrum calculation

Put \(\omega=e^{2\pi i/3}\). A linear lift \(g\) fixing the cubic form exactly has \(g^m\in\mu_3 I_6\) when its projective order is \(m\). Chenevert's primitive-cohomology trace formula, used in the local cyclic character script, is

\[
\operatorname{tr}(g\mid H^4_{\mathrm{prim}})
=\frac{1}{3}\sum_{\alpha^3=1}(-2)^{\dim E_\alpha(g)}.
\]

If \(g^m\ne I\), none of its eigenvalues is a cube root of unity, so its trace is \(1\). An order-three strict lift cannot have trace \(1\): no nonnegative triple \(a+b+c=6\) satisfies \((-2)^a+(-2)^b+(-2)^c=3\). The finite enumerations below are checked by [cyclic_spectrum_check.py](cyclic_spectrum_check.py).

| Family | Consequence |
| --- | --- |
| 136 | Trace \(-2\) forces \(g^3=I\). The multiplicities of \(1,\omega,\omega^2\) are a permutation of \((1,2,3)\). Cube-root scalar shifts and inversion act transitively on these six permutations, so there is one projective cyclic subgroup type. |
| 141 | Trace \(2\) forces \(g^6=I\). Write \(n_j=\dim E_{\zeta_6^j}(g)\), with \(\zeta_6=e^{\pi i/3}\). The traces of \(g,g^2,g^3\) give six solutions for \((n_0,\ldots,n_5)\); all form one orbit under cube-root scalar shifts and inversion, containing \((1,0,2,0,2,1)\). This is the spectrum of the listed diagonal matrix \(\operatorname{diag}(-\omega,\omega,\omega,1,\omega^2,\omega^2)\). |
| 140 | Trace \(1\) excludes \(g^3=I\). Up to inversion, \(g^3=\omega I\). Its three eigenvalues are \(\zeta_9\omega^j\), and smoothness forces their multiplicities to be \((2,2,2)\), matching the listed coordinate action. |
| 143 | The fingerprint \((1,1,-2)\) cannot occur for any strict order-six lift, so \(g^6\ne I\). Up to inversion, \(g^6=\omega I\). Smoothness forces each of \(+\zeta_9^2\omega^j\) and \(-\zeta_9^2\omega^j\) to occur once for \(j=0,1,2\). This is the listed spectrum: \(\zeta_9^2+\zeta_9^5=-\zeta_9^8\). |

For No. 140, let \(V_j\) be the eigenspace of \(\zeta_9\omega^j\), with dimension \(a_j\). An invariant cubic vanishes on \(\mathbb P(V_j)\), since a pure cubic there has eigenvalue \(\omega\). At a point of this projective space, only partial derivatives in \(V_{j+2}\) can be nonzero, and these are \(a_{j+2}\) quadrics. Fewer than \(a_j\) homogeneous quadrics on \(\mathbb P^{a_j-1}\) have a common zero, producing a singular point. Smoothness therefore gives \(a_{j+2}\ge a_j\) for every \(j\). These cyclic inequalities and \(\sum a_j=6\) imply \(a_j=2\).

For No. 143, write \(p_j,q_j\) for the multiplicities of \(+\zeta_9^2\omega^j\) and \(-\zeta_9^2\omega^j\). The trace \(-2\) of the order-two power gives \(\sum p_j=\sum q_j=3\). On either pure weight space of index \(j\), only derivatives in the positive weight space of index \(j+1\) can be nonzero. Smoothness gives \(p_{j+1}\ge p_j\) and \(p_{j+1}\ge q_j\). The first cyclic inequalities force \(p_j=1\); the second and \(\sum q_j=3\) force \(q_j=1\).

## From projective spectra to integral conjugacy

Finite-order complex matrices with the same eigenvalue multiplicities are linearly conjugate. A cube-root scalar does not change the projective action or the invariant cubic space. For a fixed diagonal representative \(g\), smooth cubics in its fixed-form vector space constitute a nonempty Zariski-open subset, hence a connected complex space. An equivariant smooth trivialization along a path in that space identifies primitive integral cohomology, its intersection form, and the \(g\)-action. Therefore projectively conjugate cyclic actions with the same form-fixing spectrum have integrally conjugate rank-22 actions.

Inversion does not create a second integral class here. Each diagonal representative has unit-modulus eigenvalues, so \(\bar g=g^{-1}\). Its invariant cubic space is stable under complex conjugation and has a smooth real member: the nonempty smooth open set meets the real points of this real linear space. Complex conjugation on that cubic acts integrally on primitive \(H^4\), preserves the intersection form, and conjugates \(g\) to \(g^{-1}\). The generators of \(C_3\) and \(C_6\) differ only by inversion, so the recorded generator power does not affect the conclusion.

This criterion still needs the geometric realization check above. A separate lattice-only certificate would be an integral matrix \(U\) for each pair satisfying \(U A_i=A_j U\), \(U G U^{\mathsf T}=G\), and \(\det U=\pm1\). OSCAR's type and discriminant-module comparisons are necessary filters; they are not substitutes for such a witness or an equivariant gluing classification.

## Application to No. 143

For the retained No. 41 output (case 16, result 3 of
`../../oscar/oscar_script_data.mrdi`), the original search keeps only stable
extensions after checking the signature and excluding both kinds of roots in
the associated `K`; see `lattice_data_after_root_and_symplectic_tests` and
`lattice_data_for_T_action` in `../../oscar/oscar_script.jl`. The
period-map and Torelli realization criterion therefore realizes the saved `f`
and every element of the reconstructed `N=\widetilde O(S)` simultaneously
on a smooth cubic. The exhaustive No. 41 restriction file checks the
22-dimensional lifts and their extension relations. This discharges the
realization hypothesis for its three order-six classes.

The independent GAP containment audit verifies that the No. 143 source
cyclic action embeds into No. 41, and the geometric character and smoothness
checks give the No. 143 fingerprint and a smooth representative. All three
No. 41 classes have that fingerprint. The No. 143 spectrum calculation above
shows that their geometric projective actions are conjugate up to inversion.
Equivariant connectedness, and the real-member argument for inversion, show
that their ordinary integral lattice actions are conjugate. Thus the pure
power of the saved No. 41 extra generator may represent the numbered
No. 143 lattice action. This conclusion concerns ordinary integral
conjugacy; it does not by itself fix a Hodge orientation or give an explicit
22-dimensional conjugating matrix.
