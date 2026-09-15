# References and their roles

This guide distinguishes external mathematical input from the computations
in this repository. It does not replace the accompanying papers' proofs.
References to a published theorem use the published numbering; an arXiv
version may have different numbering.

## Classification papers

- Jie Fu, Shihao Wang, and Zhiwei Zheng, *Non-symplectic Indices of
  Automorphism Groups of Smooth Cubic Fourfolds*,
  [arXiv:2606.11754](https://arxiv.org/abs/2606.11754).
  This supplies the non-symplectic-index restrictions, generic indices,
  and reference data used with the YYZ bounds.
- Jie Fu and Zhiwei Zheng, *Automorphism groups of smooth cubic fourfolds
  through lattice theory*, [arXiv:2609.06683](https://arxiv.org/abs/2609.06683).
  Its main table is the reference for the 76 large-family
  records. The OSCAR computation concerns lattice equivalence; explicit
  geometric realization and the relevant conjugate-component comparison
  are separate steps.
- Jie Fu, Shihao Wang, and Zhiwei Zheng, *Classification of Automorphism
  Groups of Smooth Cubic Threefolds and Fourfolds*, accompanying
  classification manuscript. Its extension/liftability arguments,
  non-liftable abelian classification, and appendix on the seven singular
  small-group families are mathematical input to the final classification.
  The appendix does not change the seven `unknown` statuses in the saved
  automatic smoothness output.

The code and saved results in this repository accompany the classification
article.

## Symplectic actions and maximal groups

- Radu Laza and Zhiwei Zheng, *Automorphisms and periods of cubic
  fourfolds*, Mathematische Zeitschrift **300** (2022), 1455–1507.
  [Published article](https://doi.org/10.1007/s00209-021-02810-x).
  This gives the symplectic-group and lattice classification.
- Kenji Koike, *Cubic fourfolds with symplectic automorphisms*, Journal of
  Algebra **680** (2025), 12–57.
  [Published article](https://doi.org/10.1016/j.jalgebra.2025.04.037).
  Read it together with the
  [corrigendum](https://doi.org/10.1016/j.jalgebra.2026.05.021).
  These provide the coordinate models and distinguish components that have
  the same abstract symplectic group.
- Song Yang, Xun Yu, and Zigang Zhu, *Automorphism groups of cubic
  fivefolds and fourfolds*, Journal of the London Mathematical Society
  **110** (2024), e12997.
  [Published article](https://doi.org/10.1112/jlms.12997);
  [arXiv version and ancillary material](https://arxiv.org/abs/2308.07186).
  The fourfold maximal groups supply the abstract YYZ bound. Example 6.1
  supplies the `C48`, `C32`, `S3 x C24`, and `QD16`-extension examples;
  Lemma 3.12 gives the linear stabilizers of smooth plane cubics.
- Xuancong He, Yi Li, Shihao Wang, and Zhiwei Zheng, *Cubic Fourfolds with
  an Order-7 Automorphism*,
  [arXiv:2509.26359](https://arxiv.org/abs/2509.26359).
  This supplies the separate order-7 classification used by the protected
  saturation records.
- Li Wei and Xun Yu, *Automorphism groups of smooth cubic threefolds*,
  Journal of the Mathematical Society of Japan **72** (2020), 1327–1343.
  [Published article](https://doi.org/10.2969/jmsj/83088308).
  Theorem 1.1 classifies the six maximal abstract groups, realized by
  Example 3.1(1)–(6). They occur in threefold Nos. 1, 2, 3, 5, 24, and 40.
  Maximality of the linear actions is finer: No. 39 also gives an
  action-maximal family, although its abstract group `C8` is a subgroup
  of `C16`.
- Chenglong Yu and Zhiwei Zheng, *Moduli spaces of symmetric cubic
  fourfolds and locally symmetric varieties*, Algebra & Number Theory
  **14** (2020), 2647–2683.
  [Published article](https://doi.org/10.2140/ant.2020.14.2647).
  This is a reference for the symmetric period domains. Section 6A also
  records the correction to the prime-order list described below.

## Abelian actions

Tianzhen Peng and Zhiwei Zheng, *Abelian Automorphism Groups of Quartic
Surfaces and Cubic Fourfolds*,
[arXiv:2106.14214](https://arxiv.org/abs/2106.14214), Theorem 4.2,
supplies the maximal liftable diagonal models. The implementation preserves
the 24 simple `K/T/Y` combinations and eight non-simple source labels.
Subgroups of a strict maximal model preserve its smooth defining cubic.
The further exclusions used to seek an **abelian full stabilizer** are not
general obstructions to a smooth cubic carrying the subgroup action.

## Prime-order restriction

Víctor González-Aguilera and Alvaro Liendo, *Automorphisms of prime order
of smooth cubic n-folds*, Archiv der Mathematik **97** (2011), 25–37,
[Theorem 3.8](https://doi.org/10.1007/s00013-011-0247-0), gives the
fourfold spectral list. Yu–Zheng, Section 6A, removes the second order-5
case, which has no smooth member.

The shared small-group code retains this historical order-5 pattern. Its
filter is consequently a possibly weaker necessary test, not a
realizability criterion. The current small non-abelian inputs have orders
divisible only by 2 and 3, so this extra pattern cannot affect their saved
results. Converting semi-invariant representatives to strict invariants
requires scalar normalization, including order-nine lifts at the prime 3.

## Liftability

- Baiting Xie and Zhiwei Zheng, *Sylow Criteria for Liftability of
  Automorphism Groups of Smooth Hypersurfaces*,
  [arXiv:2607.23465](https://arxiv.org/abs/2607.23465), supplies the Sylow
  criteria for finite subgroup actions.
- Baiting Xie and Zhiwei Zheng, *Small-Subgroup Criteria for Liftability of
  Automorphism Groups of Smooth Hypersurfaces*,
  [arXiv:2609.15613](https://arxiv.org/abs/2609.15613), Theorem 1.4,
  supplies the small-subgroup criteria for the automorphism group of a
  smooth cubic fourfold. The inverse-image tests used here then follow
  from the central extensions of $C_3$, $C_9$, and $C_3^2$ by $C_3$.

The program checks the relevant finite groups and inverse-image types. It
does not certify the geometric hypothesis that its input is the full strict
stabilizer of a smooth cubic; this is supplied by the classification.

## Additive splittings

- D. K. Harrison, *A Grothendieck ring of higher degree forms*, Journal of
  Algebra **35** (1975), 123–138.
  [Published article](https://doi.org/10.1016/0021-8693(75)90039-3).
- Hua-Lin Huang, Huajun Lu, Yu Ye, and Chi Zhang, *On centres and direct
  sum decompositions of higher degree forms*, Linear and Multilinear
  Algebra **70** (2022), 7290–7306,
  [Proposition 2.1(1)–(3)](https://doi.org/10.1080/03081087.2021.1985057).

For a form of degree at least three using all its variables essentially,
the maximal additive splitting and its variable subspaces are unique up to
permutation. This is the input to the plane-cubic saturation argument and
the threefold extraction. It is stronger than uniqueness of abstract
isomorphism types of summands.

## Software

The division between the recorded Windows GAP and WSL GAP--Singular runs
is summarized in [`ENVIRONMENT.md`](ENVIRONMENT.md). The lattice computation
is external to this directory.

- [GAP](https://www.gap-system.org/): exact finite groups, characters, and
  cyclotomic matrices. The saved enumeration and catalogue audits use
  GAP 4.15.1; the WSL smoothness runs use GAP 4.12.1.
- [Singular](https://www.singular.uni-kl.de/): exact polynomial ideals and
  Gröbner bases, called as an external program by the GAP smoothness helpers.
