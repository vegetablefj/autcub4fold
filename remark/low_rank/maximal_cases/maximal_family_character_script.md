# Exact character calculation

## Convention

Let

```text
A = diag(zeta_m^a1, ..., zeta_m^a6)
```

act by substitution `x -> A*x`, and choose the strict lift so that
`A^*F = F`.  The recorded cohomological action is pullback.  Replacing
pullback by the inverse convention negates all root exponents; it does not
change the rational characteristic polynomials or signatures below.

For a smooth invariant cubic, the equivariant Hilbert series of its Jacobian
ring is

```text
product_i (1 - zeta_m^(-ai) t^2) / (1 - zeta_m^(ai) t).
```

Primitive fourth cohomology is obtained from degrees `0`, `3`, and `6`, with
the common determinant twist:

```text
H^4_prim(X) = det(A) tensor (R_0 + R_3 + R_6)
```

at the level of characters.  The script performs this calculation in the
finite character group using integer multiplicities only.  It then checks
Galois multiplicities before grouping eigenvalues into cyclotomic factors.
The output concerns `H^4_prim`, of rank 22.  The characteristic polynomial
on all of `H^4` has one additional `Phi1` factor from the square of the
hyperplane class.

## Recovering `S` and `T`

- For No. 127, the script keeps the simultaneous `C4 x C2` character.  The
  `+1` eigenspace of the symplectic involution is `T`, and the `-1`
  eigenspace is `S`.
- For No. 96, the full character is computed from the displayed order-24
  lift.  The period eigenvalue is primitive of order 24.  Since `T` is a
  rational rank-eight lattice and `phi(24)=8`, it follows that
  `chi(A|T)=Phi24`; the complementary factors give `chi(A|S)`.
- For Nos. 152, 154, 155, and 156, the symplectic group is trivial, so
  `S=0` and `T=H^4_prim`.

## Signature rule

The primitive cubic-fourfold lattice has signature `(20,2)`, while `S` is
positive definite.  The rational cyclotomic block containing
`H^(3,1) + H^(1,3)` therefore has two negative directions.  Every other
cyclotomic block is of Hodge type `(2,2)` and is positive definite.  When a
cyclotomic factor occurs twice, the result records the signature of the
whole rational isotypic block; it does not assert a canonical orthogonal
splitting into two copies.

## Automatic checks

`compute_hodge_characters.jl` verifies all of the following:

1. the displayed diagonal weights fix the listed monomial spaces;
2. for No. 96, intersecting diagonal invariants with the `(5 6)`-fixed
   space gives the recorded five-dimensional basis;
3. for No. 127, filtering the standard `C2` basis reproduces the twelve local
   `P_i` indices in the article;
4. each primitive cohomology spectrum has total rank 22 and has equal
   Galois multiplicities;
5. the computed full, `S`, and `T` characteristic polynomials agree and
   have the required ranks;
6. the determinant character has the stated non-symplectic order;
7. the primitive period eigenspace has complex dimension equal to the
   family dimension plus one;
8. the signature blocks recover positive-definite `S` and signature
   `(rank(T)-2,2)` on `T`.

These checks determine the rational/Hodge input for an optimized OSCAR run.
They do not enumerate integral genera, primitive gluings, or `O(T)`-conjugacy
classes.  Those are the remaining lattice tasks.
