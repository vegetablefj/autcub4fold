# Liftability scripts

## Strict extensions

For a smooth cubic fourfold defined by F, a strict lift H of a projective
subgroup G contains exactly the scalar group Z = <omega I6>, of order three.
Thus G = H/Z. Ordinary liftability asks for a linear lift of this projective
action. F-liftability asks for a lift preserving F, or equivalently a
complement to Z in H. Neither property is determined by the abstract group
name G alone.

`CF_LI_TestStrictExtension(H)` applies two purely group-theoretic tests:

- G is liftable exactly when Z intersects [H,H] trivially.
- G is F-liftable exactly when Z has a nonzero image in H_ab/3H_ab,
  equivalently when Z intersects [H,H]H^3 trivially.

The first follows by extending the scalar character of Z to H and twisting
the given representation. For the second, a nonzero image of Z in the
elementary abelian quotient H_ab/3H_ab gives a homomorphism H -> C3 which
is an isomorphism on Z. Its kernel is a complement. Conversely, a complement
gives that homomorphism because Z is central.

The code forms [H,H]H^3 from generators of [H,H] and the cubes of generators
of H. This is sufficient because the quotient by [H,H] is abelian. It is
not the generally incorrect shortcut of generating H^3 from those cubes
without adjoining the derived subgroup.

These tests apply to any strict subgroup action, not just the full
automorphism group. `CF_LI_ScalarSubgroup` checks the matrix dimension,
centrality, and that all scalar matrices in the finite group are exactly Z.
Smoothness and the interpretation of H as a strict invariant extension are
geometric hypotheses; these group functions do not prove them.

## Small-subgroup criterion

`CF_LI_TestFullAutomorphismGroup(H)` applies the small-subgroup criterion
when H = Aut(F), so that G is the automorphism group of a smooth cubic
fourfold. It must not be used to infer the same conclusion for an arbitrary
subgroup solely from its small-subgroup tests.

The public Xie--Zheng preprint gives the general Sylow criteria:
[arXiv:2607.23465v1](https://arxiv.org/html/2607.23465v1),
Theorems 1.1(2) and 1.3. Their subsequent paper
[arXiv:2609.15613v1](https://arxiv.org/abs/2609.15613), Theorem 1.4,
shows that the automorphism group of a smooth cubic fourfold is liftable
exactly when its $C_3^2$ subgroups are liftable, and is F-liftable exactly
when this holds and its order-three elements are F-liftable. This theorem
concerns H = Aut(F). Its proof can introduce automorphisms of additive
summands which need not belong to a prescribed subgroup. The two inputs are
therefore kept distinct; see
[the reference guide](../../REFERENCES.md#liftability).

The algorithm is:

1. Form G = H/Z and a permutation model of G.
2. Use `IsomorphicSubgroups` to enumerate all G-conjugacy classes of
   subgroups C3, C9, and C3 x C3. No first-match option is used.
3. Take each full inverse image E in H and inspect its exponent and its
   derived subgroup's intersection with Z.
4. Combine all local decisions using the full-group detection theorem.

The C9 inverse images are retained as direct splitting checks and to give a
uniform account of all subgroups of order at most nine. They add no further
hypothesis to the cited criterion in the smooth cubic-fourfold case.

No GL6-conjugacy search against an obstruction matrix is needed for these
yes/no decisions. Once the quotient type and distinguished kernel are
fixed, the small central-extension types give exact splitting tests:

| Projective subgroup | Ordinary liftability | F-liftability |
|---|---|---|
| C3 | Always | E = C3^2, rather than C9. |
| C9 | Always | E = C9 x C3, rather than C27. |
| C3 x C3 | E is abelian | E = C3^3. |

The cyclic order-27 inverse image over C9 is impossible for a smooth cubic
fourfold; encountering it in the batch stops the calculation. For the
elementary abelian quotient, the other abelian extension is C9 x C3 and
the nonabelian extensions have exponents three or nine.

The abstract group E alone is insufficient without the quotient and kernel.
For example C9 x C3 can be split over a C9 quotient but nonsplit over a
C3 x C3 quotient. The code always constructs the actual inverse image
with its specified scalar kernel before classifying it.

## Complete-family audit

`gap_liftability_all.g` reads the
[complete ordered catalogue](../gap_manuscript_validation/gap_family_catalogue.g)
and checks the saved coordinate correspondence. It retains the 48 generic
symplectic reference rows, in Koike order, with liftability values from
Fu--Wang--Zheng, [arXiv:2606.11754](https://arxiv.org/abs/2606.11754),
the main symplectic-family table, and Koike's coordinate models. For these
48 generic full families the two liftability values agree; this is also
verified directly on their final strict groups.

A negative symplectic subgroup obstructs ordinary liftability of every
supergroup action, since a lifting restricts to a lifting of the subgroup.
It also obstructs F-liftability. For the seven inherited rows the code checks
actual matrix subgroup inclusion and the ordinary obstruction. Equality of
abstract names or a shared component number is not used as an inclusion proof.
The remaining 101 rows use the small-subgroup criterion.

Independently, all 156 final groups are tested by the two distinguished-kernel
tests above. Group orders, the full scalar kernel, and both liftability
values are checked. Only after the decisions are obtained are the existing
catalogue labels compared. The output binds each number and source key to
the exact final matrix generators, and retains the local inverse-image
records for the 101 small-subgroup computations.

`gap_liftability_test.g` checks the four obstruction models plus split and
nonsplit cyclic-order-nine extensions. It also verifies the example of the
same abstract C9 x C3 group with different quotient/kernel splitting results.
The nonsplit C9 example is deliberately not asserted to admit a smooth cubic.

Run with GAP 4.15.1; no Singular or cohomolo package is required. The batch
log is incremental, the `.out` and result Markdown are written at completion,
and `LIFTABILITY_COMPLETED` marks successful termination. Definitions of the
saved decisions and counts are in [the result](gap_liftability_result.md).
