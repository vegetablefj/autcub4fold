# No. 127: the geometric action on the phi_3 fixed lattice

`verify_family_127_phi3_plane_action.py` is a short, exact arithmetic check
of the order-four generator on the positive-definite lattice fixed by
`q = A^2 s`. It uses only the Python standard library and writes
`family_127_phi3_plane_action.out`. Run it from any directory with
`python verify_family_127_phi3_plane_action.py` (or give its full path).
It also writes `family_127_phi3_plane_action.json` with the exact Gram
and pushforward-action matrices for reuse.
The old seed-comparison programs discussed later in this note are exploratory
and are not included here; the geometric action check and the selected
full-lattice comparison are retained.
The script does not construct the action on the full cubic cohomology.
It records the action on plane classes by geometric image (pushforward).
For a convention using cohomological pullback by the displayed coordinate
matrix `A`, use the inverse of the printed order-four matrix.

In the No. 127 coordinates, write `u=x2`, `v=x3`, `w=x4`. A general
invariant cubic has the form

`F = x1^2*u + lambda*u*x5*x6 + u^2*l(v,w) + c(v,w)
     + l5(v,w)*x5^2 + l6(v,w)*x6^2`,

where `l`, `l5`, and `l6` are linear and `c` is cubic. The coordinate
involution `q=diag(-1,1,1,1,-1,-1)` fixes the plane
`Pi=P(x1,x5,x6)` pointwise. Projection from `Pi` is the quadric
fibration of [Marquand, Section 3.2](https://arxiv.org/pdf/2202.13213).
Its discriminant sextic in the base `P(u,v,w)` is `C*D`, where

`C = u^2*l(v,w)+c(v,w)`,
`D = u*(l5(v,w)*l6(v,w)-lambda^2*u^2/4)`.

For a general smooth member with `lambda != 0` and transverse
intersections, `C` meets `u=0` in three points and the conic factor
of `D` in six points. Since `A` acts on the base by `u -> -u`, the first
three points are fixed and the last six form three two-point orbits.
On a fixed-line fiber the residual quadratic factors in `x5,x6`;
`A` changes the sign of `x6` and exchanges its two planes. On a conic
fiber `u != 0`, `h=A^2` changes the sign of `x1` and exchanges its two
planes. Consequently `A` gives a four-cycle on the four planes over
each two-point conic orbit. The smooth invariant cubics form a connected
open in a projective linear system, so this integral action type also
applies to other smooth members of the same family.

Marquand's Proposition 3.5 and Section 5 give classes `eta`, `Pi`,
and nine pairs `Fi,Fi'` of residual planes, with
`Fi+Fi'=eta-Pi`. Choose one plane from each pair so that
`y=(Pi+sum(Fi))/2` is integral. The component choices can be normalized
to have `A(Fi)=Fi'` for `i=1,2,3`, and the cycles
`F4 -> F5 -> F4' -> F5' -> F4`, similarly for `(F6,F7)` and
`(F8,F9)`. If a normalization changes the parity of the choices,
switching one fixed-line component restores integrality of `y` without
changing these cycle rules.

The script forms the rank-eleven Gram matrix in the basis
`eta,y,F1,...,F9` from Marquand's plane intersections, and then uses
her primitive basis `x,alpha1,...,alpha9`, where
`x=-y+F1+F3+F5+F7+F9`, `alpha_i=Fi-Fi+1` for `1<=i<=8`, and
`alpha9=Pi+F8+F9-eta`. It checks the integral action, its order and
isometry property. The primitive fixed lattice `P=L^q` has determinant
`3*2^10`; its Gram matrix is even. Therefore its entire 2-primary
discriminant group is `(1/2)P/P`, and the induced action is simply the
printed integral matrix reduced modulo two.

The output gives `chi(A|P)=Phi1*Phi2^3*Phi4^3` and the mod-two Jordan
partition `4+2+2+1+1`. Via the ambient discriminant anti-isometry,
this is the required conjugacy class of the action on the
2-elementary discriminant group of `Q=L^{-q}`. It is a stronger finite
filter than the rank-three condition on a proposed fixed lattice `K`,
but it neither supplies a canonical matrix in the saved `Q` basis nor
lifts the finite action to an order-four integral isometry of `Q`.

## Earlier filter for a proposed `Q` action

The earlier `compare_family_127_phi3_finite_action.py` accepted a JSON file containing
the candidate's 12-by-12 integer `gram` and `action` arrays in the same
basis. It checked the Gram, determinant, order-four action, and
2-elementary discriminant size before comparison. This exploratory
program is not included in the repository; its finite test is described below.

The underlying finite computation is:

1. Represent each discriminant class of a rank-12, 2-elementary `Q`
   by `v/2`, where `v` runs through the 1024 solutions of
   `G_Q*v=0 (mod 2)` in `F_2^12`.
2. Compute `4*q_Q(v/2)=v^t G_Q v (mod 8)` and the orbit under the
   proposed action. Reverse the sign of `q_Q` to compare against the
   geometric `P` action. Group orbits by length and quadratic value.
3. As a stronger necessary fingerprint, evaluate the quadratic form
   on all binary sums of each orbit's vectors. Canonicalize this short
   value list under cyclic re-start and reversal, then compare the
   multisets of decorated orbit spans.

Both fingerprints are invariant under a change of discriminant basis
and under replacing the action by its inverse. A mismatch rigorously
excludes the candidate; a match is **not** an equivariant anti-isometry.

## Check on two earlier Q-side seeds

An earlier check extracted two proposed `Q` actions and applied this
finite test. Both failed the necessary condition. The exploratory inputs
and programs are not retained here; the selected full-lattice comparison
is described in the [case guide](README.md).

Both records have a Q lattice abstractly isometric to the target and
2-elementary discriminant form with delta one, but both fail even the coarse
geometric action fingerprint. For example, among fixed discriminant classes,
the target has 8 classes with `4q=0 (mod 8)` and 24 with `4q=4`, whereas
either old action has 16 and 16. Thus the finite action test distinguishes
data that the abstract Q isometry test does not. These two old seeds also
failed a separate N-side test. Their rejection says nothing by itself about
new global representatives or whether a valid No. 127 action exists.
For a conclusive finite match one must exhibit an invertible `F_2`
matrix `B` satisfying `B*A_P=A_Q*B` (or the inverse convention) and
`q_Q(Bv)=-q_P(v)` for every `v`. Even that finite match would still need
an integral extension and the geometric lattice checks.

## Independent check on the new genus-13 Q graphs

The separate OSCAR export `family_127_g13_q_graph_preflight.json` contains
two new Q graphs built from one global representative of Hermitian genus 13.
Its `g` fields are row-action matrices. An independent check with this
Python script uses:

```text
python compare_family_127_phi3_finite_action.py family_127_g13_q_graph_preflight.json --record 1 --row-action
python compare_family_127_phi3_finite_action.py family_127_g13_q_graph_preflight.json --record 2 --row-action
```

For both records, the coarse orbit/q fingerprint and the refined
orbit-span quadratic fingerprint match the geometric P action. The precise
console result is in `family_127_phi3_g13_graph_comparison.out`. This is an
independent necessary-condition check. It does not construct an equivariant
anti-isometry of finite quadratic modules, prove that the two graphs give
distinct actions, or establish a full cubic-lattice extension.
