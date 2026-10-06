# Exact comparison of the No. 104 and No. 105 order-six characters.
# The generators are the displayed matrices in the frozen coordinate-action list.
# For No. 105 we use its conjugate six-edge Fermat presentation, as in
# verify_no105_character.g. Both presentations define the recorded groups.
#
# For an invariant smooth cubic, the equivariant Jacobian ring is the
# complete intersection of six quadrics. If g acts on coordinates, its
# graded character is det(I - z^2*g^(-1))/det(I - z*g). The primitive-H^4
# trace is det(g) times the sum of its degree 0, 3 and 6 coefficients.
# Newton identities below evaluate these coefficients exactly in GAP.

NoFamilyMonomialMatrix := function(perm, coeff)
    local mat, i;
    mat := NullMat(6, 6);
    for i in [1 .. 6] do
        mat[i][perm[i]] := coeff[i];
    od;
    return mat;
end;;

NoFamilyPrimitiveTrace := function(g)
    local p, q, h, e, n, j, r3, r6;
    p := List([1 .. 6], k -> TraceMat(g^k));
    q := List([1 .. 3], k -> TraceMat(g^(-k)));
    h := [1];
    for n in [1 .. 6] do
        Add(h, Sum([1 .. n], k -> p[k] * h[n-k+1]) / n);
    od;
    e := [1];
    for j in [1 .. 3] do
        Add(e, Sum([1 .. j], k -> (-1)^(k-1) * q[k] * e[j-k+1]) / j);
    od;
    r3 := h[4] - e[2] * h[2];
    r6 := h[7] - e[2] * h[5] + e[3] * h[3] - e[4];
    return DeterminantMat(g) * (1 + r3 + r6);
end;;

NoFamilyI := IdentityMat(6);;
No104a := DiagonalMat([1, 1, 1, 1, -1, -1]);;
No104b := DiagonalMat([1, 1, 1, -1, -1, 1]);;
No104t := NoFamilyMonomialMatrix([1, 2, 3, 6, 4, 5],
    [1, E(3)^2, -1, 1, 1, 1]);;
No104V4 := [NoFamilyI, No104a, No104b, No104a * No104b];;
No104Traces := List([0 .. 5], k ->
    Sum(No104V4, h -> NoFamilyPrimitiveTrace(No104t^k * h)) / 4);;
No104FullTraces := List([0 .. 5], k -> NoFamilyPrimitiveTrace(No104t^k));;
No104STraces := No104FullTraces - No104Traces;;
if No104Traces <> [10, 2, -2, -4, -2, 2] or
   No104FullTraces <> [22, 2, -2, -10, -2, 2] or
   No104STraces <> [12, 0, 0, -6, 0, 0] or
   IdGroup(Group(E(3) * NoFamilyI, No104a, No104b, No104t)) <>
       [72, 47] then
    Error("No. 104 character or linear group does not match");
fi;

No105a := NoFamilyMonomialMatrix([2, 1, 4, 3, 5, 6],
    [1, 1, 1, 1, 1, 1]);;
No105b := NoFamilyMonomialMatrix([2, 1, 3, 4, 6, 5],
    [1, 1, 1, 1, 1, 1]);;
No105t := NoFamilyMonomialMatrix([3, 4, 5, 6, 2, 1],
    [E(3)^2, E(3)^2, 1, 1, 1, 1]);;
No105V4 := [NoFamilyI, No105a, No105b, No105a * No105b];;
No105Traces := List([0 .. 5], k ->
    Sum(No105V4, h -> NoFamilyPrimitiveTrace(No105t^k * h)) / 4);;
No105FullTraces := List([0 .. 5], k -> NoFamilyPrimitiveTrace(No105t^k));;
No105STraces := No105FullTraces - No105Traces;;
if No105Traces <> [10, 1, 1, -8, 1, 1] or
   No105FullTraces <> [22, 1, 1, -2, 1, 1] or
   No105STraces <> [12, 0, 0, 6, 0, 0] or
   IdGroup(Group(E(3) * NoFamilyI, No105a, No105b, No105t)) <>
       [72, 16] then
    Error("No. 105 character or linear group does not match");
fi;

if No104t^6 <> NoFamilyI or No105t^6 <> E(3) * NoFamilyI then
    Error("unexpected sixth powers of the chosen lifts");
fi;

# Explicitly identify the Fermat presentation with the displayed No. 105
# matrices. Simultaneously diagonalize the three pair sums, and order the
# three nontrivial V4-character lines as d56, d12, -d34.
No105z := E(9);;
No105w := E(3);;
No105e := IdentityMat(6);;
No105s12 := No105e[1] + No105e[2];;
No105s34 := No105e[3] + No105e[4];;
No105s56 := No105e[5] + No105e[6];;
No105d12 := No105e[1] - No105e[2];;
No105d34 := No105e[3] - No105e[4];;
No105d56 := No105e[5] - No105e[6];;
No105P := TransposedMat(Concatenation(
    List([No105z^2, No105z^5, No105z^8], lambda ->
        No105s12 + (lambda * No105w) * No105s34 +
        (lambda^2 * No105w) * No105s56),
    [No105d56, No105d12, -No105d34]));;
No105ManuscriptT := NoFamilyMonomialMatrix([1, 2, 3, 5, 6, 4],
    [No105z^2, No105z^5, -No105z^2-No105z^5,
     -1, -No105w^2, -1]);;
if DeterminantMat(No105P) = 0 or
   No105P^-1 * No105a * No105P <> No104a or
   No105P^-1 * No105b * No105P <> No104b or
   No105P^-1 * No105t * No105P <> No105ManuscriptT then
    Error("the Fermat and listed coordinate No. 105 representations differ");
fi;

Print("No. 104: T traces ", No104Traces,
    "; characteristic polynomial Phi_1 * Phi_2 * Phi_3 * Phi_6^3\n");
Print("         S traces ", No104STraces,
    "; characteristic polynomial Phi_1 * Phi_2^3 * Phi_3 * Phi_6^3\n");
Print("No. 105: T traces ", No105Traces,
    "; characteristic polynomial Phi_1 * Phi_2^3 * Phi_6^3\n");
Print("         S traces ", No105STraces,
    "; characteristic polynomial Phi_1^3 * Phi_2 * Phi_3^3 * Phi_6\n");
Print("No. 105 Fermat and listed coordinate generators are linearly conjugate\n");
