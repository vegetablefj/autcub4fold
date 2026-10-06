# Exact character calculation for the six-edge No. 105 action on the
# Fermat cubic. The Jacobian ring is squarefree; primitive H^4 is its
# graded pieces of degrees 0, 3 and 6. All matrices preserve the cubic.

No105MonomialMatrix := function(perm, coeff)
    local mat, i;
    mat := List([1 .. 6], i -> List([1 .. 6], j -> 0));
    for i in [1 .. 6] do
        mat[i][perm[i]] := coeff[i];
    od;
    return mat;
end;

No105PrimitiveTrace := function(mat)
    local perm, coeff, i, j, d, subset, contribution, trace;
    perm := [];
    coeff := [];
    for i in [1 .. 6] do
        j := PositionProperty([1 .. 6], j -> mat[i][j] <> 0);
        if j = fail then Error("matrix is not monomial"); fi;
        Add(perm, j);
        Add(coeff, mat[i][j]);
    od;
    trace := 0;
    for d in [0, 3, 6] do
        for subset in Combinations([1 .. 6], d) do
            if Set(List(subset, i -> perm[i])) = Set(subset) then
                contribution := Product(List(subset, i -> coeff[i]));
                trace := trace + contribution;
            fi;
        od;
    od;
    return DeterminantMat(mat) * trace;
end;

No105I := No105MonomialMatrix([1 .. 6], [1, 1, 1, 1, 1, 1]);
No105a := No105MonomialMatrix([2, 1, 4, 3, 5, 6], [1, 1, 1, 1, 1, 1]);
No105b := No105MonomialMatrix([2, 1, 3, 4, 6, 5], [1, 1, 1, 1, 1, 1]);
No105t := No105MonomialMatrix([3, 4, 5, 6, 2, 1],
    [E(3)^2, E(3)^2, 1, 1, 1, 1]);
No105V4 := [No105I, No105a, No105b, No105a * No105b];
No105H := Group(No105a, No105b, No105t);
No105Scalars := Group(No105t^6);
if No105t^6 <> E(3) * No105I then
    Error("unexpected scalar sixth power");
fi;
if Size(No105H) <> 72 or Size(No105Scalars) <> 3 or
   IdGroup(FactorGroup(No105H, No105Scalars)) <> [24, 13] then
    Error("unexpected linear or projective group for No. 105");
fi;

No105Traces := List([0 .. 5], k ->
    Sum(No105V4, h -> No105PrimitiveTrace(No105t^k * h)) / 4);
No105FullTraces := List([0 .. 5], k -> No105PrimitiveTrace(No105t^k));
No105STraces := No105FullTraces - No105Traces;
if No105Traces <> [10, 1, 1, -8, 1, 1] then
    Error("unexpected No. 105 invariant-cohomology character");
fi;
if No105FullTraces <> [22, 1, 1, -2, 1, 1] or
   No105STraces <> [12, 0, 0, 6, 0, 0] then
    Error("unexpected full or coinvariant character");
fi;
if DeterminantMat(No105t) <> -E(3) then
    Error("unexpected Hodge character");
fi;
Print("No. 105 traces on V4-invariant primitive H^4: ", No105Traces, "\n");
Print("Linear group order 72; projective group IdGroup [24,13]\n");
Print("The displayed order-six projective generator has sixth power E(3)I\n");
Print("Characteristic polynomial: Phi_1 * Phi_2^3 * Phi_6^3\n");
Print("No. 105 traces on V4-coinvariant S: ", No105STraces, "\n");
Print("S characteristic polynomial: Phi_1^3 * Phi_2 * Phi_3^3 * Phi_6\n");
