#############################################################################
# REENTRANCY FIX: no CallFuncList is used by the one-step output layer.
# The same loaded file can be used for multiple consecutive S(gid,Kgens) runs.
#############################################################################

#############################################################################
# INTEGRATED ONE-STEP DRIVER
#
# Output discipline:
#   * all internal Print(...) calls are routed through CF_SPrint(...);
#   * S_1, S_2, S_3 run with CF_S_PRINT_ENABLED := false;
#   * S_4 runs with CF_S_PRINT_ENABLED := true;
#   * S(gid,Kgens) ALWAYS RETURNS the S_4 record (so it is safe in assignments);
#   * use S(gid,Kgens);; to suppress GAP's automatic display of the returned record.
#
# The full returned S_4 record is also stored in CF_LAST_S_RESULT.
#############################################################################

CF_S_PRINT_ENABLED := false;;
CF_SPrint := function(arg)
    local item;

    # Do not use CallFuncList(Print,...).  Repeated one-step runs in the same
    # GAP session can otherwise hit method-dispatch problems.  Printing each
    # variadic argument directly is equivalent for our output and is reentrant.
    if CF_S_PRINT_ENABLED then
        for item in arg do
            Print(item);
        od;
    fi;

    return true;
end;;

# Preserved V26 streaming engine; the wrapper records the actual GAP version.
# IMPORTANT: restart GAP first. Paste ONE CHUNK AT A TIME in order.
# Wait for CHUNK n OK before pasting the next chunk.
# Do not paste the whole file at once.
# After all chunks load, extreme run example:
# S4 := CF_RunMemorySafe([144,69], Kgens, CF_ExtremeResourceProfile());;

# ==================== CHUNK 01/17 START ====================
if LoadPackage("cohomolo") <> true then
    Error("The GAP package 'cohomolo' is required.");
fi;
CF_CheckSmallGroupId := function(gid)
    local n, k;
    if not IsList(gid) or Length(gid) <> 2 then
        Error("The group ID must be a list [n,k].");
    fi;
    n := gid[1];
    k := gid[2];
    if not IsInt(n) or not IsInt(k) then
        Error("The entries of [n,k] must be integers.");
    fi;
    if not SmallGroupsAvailable(n) then
        Error("The Small Groups Library is unavailable for order ", n, ".");
    fi;
    if k < 1 or k > NumberSmallGroups(n) then
        Error("Invalid SmallGroup ID: ", gid, ".");
    fi;
end;
CF_SameSubgroup := function(A, B)
    if Size(A) <> Size(B) then
        return false;
    fi;
    return IsSubgroup(A, B) and IsSubgroup(B, A);
end;
CF_IsScalarMatrix := function(A)
    local n, s, i, j;
    if not IsList(A) or Length(A) = 0 then
        return false;
    fi;
    n := Length(A);
    if DimensionsMat(A) <> [n, n] then
        return false;
    fi;
    s := A[1][1];
    for i in [1 .. n] do
        if A[i][i] <> s then
            return false;
        fi;
        for j in [1 .. n] do
            if i <> j and A[i][j] <> 0 then
                return false;
            fi;
        od;
    od;
    return true;
end;
CF_JoinStrings := function(strings, separator)
    local answer, i;
    if Length(strings) = 0 then
        return "";
    fi;
    answer := strings[1];
    for i in [2 .. Length(strings)] do
        answer := Concatenation(answer, separator, strings[i]);
    od;
    return answer;
end;
CF_BlockDiagonalMatrixList := function(blocks)
    local total, M, offset, B, i, j;
    if Length(blocks) = 0 then
        Error("At least one matrix block is required.");
    fi;
    total := Sum(List(blocks, Length));
    M := List([1 .. total], i -> List([1 .. total], j -> 0));
    offset := 0;
    for B in blocks do
        if DimensionsMat(B) <> [Length(B), Length(B)] then
            Error("A block is not square.");
        fi;
        for i in [1 .. Length(B)] do
            for j in [1 .. Length(B)] do
                M[offset + i][offset + j] := B[i][j];
            od;
        od;
        offset := offset + Length(B);
    od;
    return Immutable(M);
end;
CF_CharacterFromMultiplicities := function(irr, multiplicities)
    local chi, i;
    if Length(irr) <> Length(multiplicities) then
        Error("Character and multiplicity lists have different lengths.");
    fi;
    chi := 0 * irr[1];
    for i in [1 .. Length(irr)] do
        chi := chi + multiplicities[i] * irr[i];
    od;
    return chi;
end;
CF_NonnegativeColumnSolutions := function(columns, target)
    local answers, search;
    answers := [];
    if Length(columns) = 0 then
        if ForAll(target, x -> x = 0) then
            return [[]];
        fi;
        return [];
    fi;
    search := function(pos, remaining, current)
        local col, bounds, maxm, j, m, next;
        if pos > Length(columns) then
            if ForAll(remaining, x -> x = 0) then
                Add(answers, ShallowCopy(current));
            fi;
            return;
        fi;
        col := columns[pos];
        bounds := [];
        for j in [1 .. Length(target)] do
            if col[j] > 0 then
                Add(bounds, QuoInt(remaining[j], col[j]));
            fi;
        od;
        if Length(bounds) = 0 then
            maxm := 0;
        else
            maxm := Minimum(bounds);
        fi;
        for m in [0 .. maxm] do
            next := List(
                [1 .. Length(target)],
                j -> remaining[j] - m * col[j]
            );
            if ForAll(next, x -> x >= 0) then
                current[pos] := m;
                search(pos + 1, next, current);
            fi;
        od;
    end;
    search(1, ShallowCopy(target), []);
    return answers;
end;
CF_NullspaceOfEquationRows := function(equations, numberOfUnknowns)
    if Length(equations) = 0 then
        return IdentityMat(numberOfUnknowns);
    fi;
    return NullspaceMat(TransposedMat(equations));
end;
CF_VectorToSquareMatrix := function(v, n)
    local M, i;
    if Length(v) <> n * n then
        Error("The vector length is not n^2.");
    fi;
    M := [];
    for i in [1 .. n] do
        Add(M, v{[(i - 1) * n + 1 .. i * n]});
    od;
    return M;
end;
CF_ForEachSparseIntegerVectorAtLevel := function(
    dimension,
    level,
    callback
)
    local maximumSupport, supportSize, supports, support, values,
          coefficients, stopped, searchValues, index;
    if dimension < 1 or level < 1 then
        return false;
    fi;
    maximumSupport := Minimum(dimension, level);
    values := Concatenation([-level .. -1], [1 .. level]);
    coefficients := List([1 .. dimension], i -> 0);
    stopped := false;
    for supportSize in [1 .. maximumSupport] do
        supports := Combinations([1 .. dimension], supportSize);
        for support in supports do
            searchValues := function(position, reachesBoundary)
                local value, newBoundary;
                if stopped then
                    return;
                fi;
                if position > supportSize then
                    if reachesBoundary or supportSize = level then
                        if callback(ShallowCopy(coefficients)) = true then
                            stopped := true;
                        fi;
                    fi;
                    return;
                fi;
                for value in values do
                    coefficients[support[position]] := value;
                    newBoundary := reachesBoundary or AbsInt(value) = level;
                    searchValues(position + 1, newBoundary);
                    if stopped then
                        return;
                    fi;
                od;
                coefficients[support[position]] := 0;
            end;
            searchValues(1, false);
            for index in support do
                coefficients[index] := 0;
            od;
            if stopped then
                return true;
            fi;
        od;
    od;
    return false;
end;
CF_FindInvertibleCombination := function(basis, n)
    local d, b, M, tuples, coeffs, v, i, j, attempt, seed, value,
          level, found;
    d := Length(basis);
    if d = 0 then
        return fail;
    fi;
    for b in basis do
        M := CF_VectorToSquareMatrix(b, n);
        if DeterminantMat(M) <> 0 then
            return M;
        fi;
    od;
    if d <= 8 then
        tuples := Tuples([-1, 0, 1], d);
        for coeffs in tuples do
            if ForAny(coeffs, x -> x <> 0) then
                v := List(
                    [1 .. n * n],
                    j -> Sum([1 .. d], i -> coeffs[i] * basis[i][j])
                );
                M := CF_VectorToSquareMatrix(v, n);
                if DeterminantMat(M) <> 0 then
                    return M;
                fi;
            fi;
        od;
    fi;
    seed := 104729 + 1009 * d + 9176 * n;
    for attempt in [1 .. 20000] do
        coeffs := [];
        for i in [1 .. d] do
            seed := (1103515245 * seed + 12345) mod 2147483647;
            value := (seed mod 41) - 20;
            if value = 0 then
                value := ((i + 3 * attempt) mod 11) + 1;
            fi;
            Add(coeffs, value);
        od;
        v := List(
            [1 .. n * n],
            j -> Sum([1 .. d], i -> coeffs[i] * basis[i][j])
        );
        M := CF_VectorToSquareMatrix(v, n);
        if DeterminantMat(M) <> 0 then
            return M;
        fi;
    od;
    level := 1;
    while true do
        found := fail;
        CF_ForEachSparseIntegerVectorAtLevel(
            d,
            level,
            function(candidateCoefficients)
                local candidateVector, candidateMatrix;
                candidateVector := List(
                    [1 .. n * n],
                    j -> Sum(
                        [1 .. d],
                        i -> candidateCoefficients[i] * basis[i][j]
                    )
                );
                candidateMatrix := CF_VectorToSquareMatrix(
                    candidateVector,
                    n
                );
                if DeterminantMat(candidateMatrix) <> 0 then
                    found := candidateMatrix;
                    return true;
                fi;
                return false;
            end
        );
        if found <> fail then
            return found;
        fi;
        if level mod 2 = 0 then
            CF_SPrint(
                "    exact intertwiner witness search reached level ",
                level,
                ".\n"
            );
        fi;
        level := level + 1;
    od;
end;
CF_Intertwiner := function(Bgens, Agens)
    local n, equations, A, B, row, i, j, k, idx, basis, P, t;
    if Length(Bgens) <> Length(Agens) then
        Error("The two generator lists have different lengths.");
    fi;
    if Length(Bgens) = 0 then
        return IdentityMat(6);
    fi;
    n := Length(Bgens[1]);
    equations := [];
    for t in [1 .. Length(Bgens)] do
        B := Bgens[t];
        A := Agens[t];
        if DimensionsMat(B) <> [n, n] or DimensionsMat(A) <> [n, n] then
            Error("Intertwiner input matrices have incompatible dimensions.");
        fi;
        for i in [1 .. n] do
            for j in [1 .. n] do
                row := List([1 .. n * n], k -> 0);
                for k in [1 .. n] do
                    idx := (k - 1) * n + j;
                    row[idx] := row[idx] + B[i][k];
                    idx := (i - 1) * n + k;
                    row[idx] := row[idx] - A[k][j];
                od;
                Add(equations, row);
            od;
        od;
    od;
    basis := CF_NullspaceOfEquationRows(equations, n * n);
    if Length(basis) = 0 then
        Error(
            "The character restriction predicted equivalent Kplus modules, ",
            "but the exact intertwiner space is zero.  The computation is ",
            "stopped instead of silently discarding the candidate."
        );
    fi;
    P := CF_FindInvertibleCombination(basis, n);
    if P = fail then
        Error(
            "Internal error: a nonzero equivalent-module intertwiner space ",
            "did not yield an invertible matrix."
        );
    fi;
    for t in [1 .. Length(Bgens)] do
        if Bgens[t] * P <> P * Agens[t] then
            Error("Internal error: the computed intertwiner does not intertwine.");
        fi;
    od;
    return P;
end;
CF_SPrint("CHUNK 01/17 OK\n");
# ===================== CHUNK 01/17 END =====================

# ==================== CHUNK 02/17 START ====================
CF_PrepareInputMatrixGroup := function(Kgens)
    local A, entries, KinputMat, Kmat, zmat, identity6,
          scalarElementsInput, scalarElementsK, inputContainsMu3,
          isoK, K, rhoK, classesK, values, chiK, zK, ZK, qK, Kbar,
          gensK, generatorMatrices, inputDeterminantValues,
          strictDeterminantValues, inputDeterminantIsTrivial,
          splitComplements, isSplitCentralLift, splitCentralLiftStatus, KId,
          kernelDerivedIntersection, projectiveLiftableType;
    if not IsList(Kgens) or Length(Kgens) = 0 then
        Error("Kgens must be a nonempty list of 6 by 6 matrices.");
    fi;
    for A in Kgens do
        if DimensionsMat(A) <> [6, 6] then
            Error("Every generator in Kgens must be 6 by 6.");
        fi;
        entries := Concatenation(A);
        if not ForAll(entries, IsCyclotomic) then
            Error("All matrix entries must be exact cyclotomic numbers.");
        fi;
    od;
    KinputMat := Group(Kgens);
    if not IsFinite(KinputMat) then
        Error("The matrix group generated by Kgens is not finite.");
    fi;
    identity6 := IdentityMat(6);
    zmat := E(3) * identity6;
    inputContainsMu3 := zmat in KinputMat;
    scalarElementsInput := Filtered(
        Elements(Centre(KinputMat)),
        CF_IsScalarMatrix
    );
    if not ForAll(
        scalarElementsInput,
        A -> A = identity6 or A = zmat or A = zmat^2
    ) then
        Error(
            "The supplied K0 contains scalar matrices outside mu_3. ",
            "Such scalars cannot act trivially on a nonzero cubic."
        );
    fi;
    Kmat := Group(Concatenation(Kgens, [zmat]));
    scalarElementsK := Filtered(
        Elements(Centre(Kmat)),
        CF_IsScalarMatrix
    );
    if Length(scalarElementsK) <> 3 then
        Error(
            "After adjoining E(3)I_6, the scalar subgroup must be exactly mu_3."
        );
    fi;
    isoK := IsomorphismPermGroup(Kmat);
    if isoK = fail then
        Error("Could not convert Kplus=<K0,mu_3> to a permutation group.");
    fi;
    K := Image(isoK);
    KId := fail;
    if IdGroupsAvailable(Size(K)) then
        KId := IdGroup(K);
    fi;
    rhoK := InverseGeneralMapping(isoK);
    gensK := GeneratorsOfGroup(K);
    generatorMatrices := List(gensK, g -> Image(rhoK, g));
    inputDeterminantValues := List(Kgens, DeterminantMat);
    strictDeterminantValues := List(generatorMatrices, DeterminantMat);
    inputDeterminantIsTrivial :=
        ForAll(inputDeterminantValues, d -> d = 1);
    chiK := NaturalCharacter(rhoK);
    if not IsCharacter(chiK) or DegreeOfCharacter(chiK) <> 6 then
        Error("The natural character of Kplus was not recognized as degree 6.");
    fi;
    zK := Image(isoK, zmat);
    ZK := Subgroup(K, [zK]);
    if Size(ZK) <> 3 or not IsSubgroup(Centre(K), ZK) then
        Error("The adjoined scalar subgroup is not a central C3.");
    fi;
    kernelDerivedIntersection := Intersection(
        ZK,
        DerivedSubgroup(K)
    );
    projectiveLiftableType := Size(kernelDerivedIntersection) = 1;
    qK := NaturalHomomorphismByNormalSubgroup(K, ZK);
    Kbar := Image(qK);
    splitComplements := [];
    if not inputContainsMu3 then
        isSplitCentralLift := true;
        splitCentralLiftStatus := "proved_split";
    elif IsSolvableGroup(K) then
        splitComplements := ComplementClassesRepresentatives(K, ZK);
        isSplitCentralLift := Length(splitComplements) > 0;
        if isSplitCentralLift then
            splitCentralLiftStatus := "proved_split";
        else
            splitCentralLiftStatus := "proved_nonsplit";
        fi;
    else
        isSplitCentralLift := false;
        splitCentralLiftStatus := "unknown";
    fi;
    return rec(
        inputGenerators := Kgens,
        originalKmatrix := KinputMat,
        originalKOrder := Size(KinputMat),
        inputAlreadyContainsMu3 := inputContainsMu3,
        Kmatrix := Kmat,
        allowedStrictMatrixGroup := Kmat,
        K := K,
        abstractId := KId,
        isoMatrixToPerm := isoK,
        representation := rhoK,
        character := chiK,
        irreducibles := Irr(UnderlyingCharacterTable(chiK)),
        generators := gensK,
        generatorMatrices := generatorMatrices,
        determinantGeneratorValues := inputDeterminantValues,
        strictDeterminantGeneratorValues := strictDeterminantValues,
        determinantIsTrivial := inputDeterminantIsTrivial,
        wholeInputProjectiveGroupSymplectic := inputDeterminantIsTrivial,
        scalarMatrix := zmat,
        scalarGenerator := zK,
        scalarSubgroup := ZK,
        scalarElements := scalarElementsK,
        kernelDerivedIntersection := kernelDerivedIntersection,
        kernelDerivedIntersectionOrder := Size(kernelDerivedIntersection),
        projectiveLiftableType := projectiveLiftableType,
        quotientMap := qK,
        Kbar := Kbar,
        isSplitCentralLift := isSplitCentralLift,
        splitCentralLiftStatus := splitCentralLiftStatus,
        splitComplements := splitComplements,
        automorphismGroupCache := fail,
        scalarCompatibleOrbitCache := []
    );
end;
CF_TrivialC3CohomologyRecord := function(G)
    local gensG, one, mats, chr;
    if not IsPermGroup(G) then
        Error("cohomolo requires G to be a permutation group.");
    fi;
    gensG := GeneratorsOfGroup(G);
    one := One(GF(3));
    mats := List(gensG, g -> [[one]]);
    chr := CHR(G, 3, 0, mats);
    if chr = fail then
        Error("cohomolo failed to construct the H^2 record.");
    fi;
    return rec(
        group          := G,
        generators     := gensG,
        fpIsomorphism  := fail,
        fpGroup        := 0,
        presentationMode := "deferred: CalcPres(chr) only if required",
        matrices       := mats,
        chr            := chr
    );
end;
CF_EnsureCohomologyPresentation := function(coh)
    local F;
    if not IsRecord(coh) or not IsBound(coh.chr) or coh.chr = fail then
        Error("No cohomolo CHR record is available for presentation construction.");
    fi;
    if IsBound(coh.chr.fpgp) and coh.chr.fpgp <> 0 then
        coh.fpGroup := coh.chr.fpgp;
        return coh.fpGroup;
    fi;
    F := CalcPres(coh.chr);
    if F = fail then
        Error(
            "cohomolo CalcPres failed to construct a presentation on the ",
            "stored permutation generators."
        );
    fi;
    coh.fpGroup := F;
    coh.presentationMode := "computed lazily by CalcPres(chr)";
    return F;
end;
CF_NormalCopiesOfKbar := function(G, Kbar)
    local targetOrder, answer, S;
    targetOrder := Size(Kbar);
    answer := [];
    for S in NormalSubgroups(G) do
        if Size(S) = targetOrder and IsomorphismGroups(Kbar, S) <> fail then
            Add(answer, S);
        fi;
    od;
    return answer;
end;
CF_PrepareExtCharacterData := function(G, abinv)
    local derived, qAb, A, Astd, isoA, exponentA, CN, generatorCN,
          factorPositions, gensAstd, nFactor;
    derived := DerivedSubgroup(G);
    qAb := NaturalHomomorphismByNormalSubgroup(G, derived);
    A := Image(qAb);
    if Length(abinv) = 0 then
        Astd := TrivialGroup(IsPermGroup);
    else
        Astd := AbelianGroup(IsPermGroup, abinv);
    fi;
    isoA := IsomorphismGroups(A, Astd);
    if isoA = fail then
        Error("Could not identify G_ab with its standard invariant-factor group.");
    fi;
    exponentA := 1;
    for nFactor in abinv do
        exponentA := Lcm(exponentA, nFactor);
    od;
    CN := CyclicGroup(IsPermGroup, exponentA);
    if exponentA = 1 then
        generatorCN := One(CN);
    else
        generatorCN := GeneratorsOfGroup(CN)[1];
    fi;
    gensAstd := GeneratorsOfGroup(Astd);
    if Length(gensAstd) <> Length(abinv) then
        Error("Unexpected generator count for the standard abelianization.");
    fi;
    if List(gensAstd, Order) <> abinv then
        Error(
            "The standard abelian generators do not occur in the stored ",
            "invariant-factor order.  Ext coordinates would be ambiguous."
        );
    fi;
    factorPositions := Filtered(
        [1 .. Length(abinv)],
        i -> abinv[i] mod 3 = 0
    );
    return rec(
        abelianizationMap := qAb,
        abelianization := A,
        standardAbelianization := Astd,
        isomorphismToStandard := isoA,
        invariantFactors := ShallowCopy(abinv),
        exponent := exponentA,
        characterTarget := CN,
        characterTargetGenerator := generatorCN,
        standardGenerators := gensAstd,
        extFactorPositions := factorPositions,
        dimension := Length(factorPositions)
    );
end;
CF_SPrint("CHUNK 02/17 OK\n");
# ===================== CHUNK 02/17 END =====================

# ==================== CHUNK 03/17 START ====================
S_1 := function(gid, Kgens)
    local G0, isoG, G, input, normalKbars, coh, multiplier3,
          h2dim, abinv, homMultiplierDimension,
          extAbelianizationDimension, expectedLiftableClassCount,
          expectedLiftableRepresentativeCount, extCharacterData, indices, S,
          cohomologySkippedByCoprimeOrder;
    CF_CheckSmallGroupId(gid);
    CF_SPrint("\n============================================================\n");
    CF_SPrint("S_1: LIFTABLE INPUT AND COHOMOLOGY DATA\n");
    CF_SPrint("============================================================\n");
    G0 := SmallGroup(gid[1], gid[2]);
    isoG := IsomorphismPermGroup(G0);
    if isoG = fail then
        Error("Could not convert G to a permutation group.");
    fi;
    G := Image(isoG);
    input := CF_PrepareInputMatrixGroup(Kgens);
    if not input.determinantIsTrivial then
        Error(
            "The input K0 is not symplectic: a supplied generator has ",
            "determinant different from 1.  This program now classifies only ",
            "actions whose full symplectic subgroup is exactly K0."
        );
    fi;
    normalKbars := CF_NormalCopiesOfKbar(G, input.Kbar);
    cohomologySkippedByCoprimeOrder := Size(G) mod 3 <> 0;
    if cohomologySkippedByCoprimeOrder then
        coh := rec(
            group := G,
            generators := GeneratorsOfGroup(G),
            chr := fail,
            trivialByCoprimeOrder := true
        );
        multiplier3 := [];
        h2dim := 0;
    else
        coh := CF_TrivialC3CohomologyRecord(G);
        multiplier3 := SchurMultiplier(coh.chr);
        h2dim := SecondCohomologyDimension(coh.chr);
    fi;
    abinv := AbelianInvariants(G / DerivedSubgroup(G));
    homMultiplierDimension := Length(multiplier3);
    extAbelianizationDimension := Number(abinv, n -> n mod 3 = 0);
    extCharacterData := CF_PrepareExtCharacterData(G, abinv);
    if extCharacterData.dimension <> extAbelianizationDimension then
        Error("Internal Ext-coordinate dimension mismatch.");
    fi;
    expectedLiftableClassCount :=
        3 ^ extAbelianizationDimension;
    expectedLiftableRepresentativeCount := expectedLiftableClassCount;
    indices := List(normalKbars, S -> Index(G, S));
    CF_SPrint("G = SmallGroup(", gid[1], ",", gid[2], ")\n");
    CF_SPrint("|G| = ", Size(G), "\n");
    if cohomologySkippedByCoprimeOrder then
        CF_SPrint(
            "3 does not divide |G|: H^i(G,C3)=0 for i>0; ",
            "the cohomolo computation was skipped.\n"
        );
    else
        CF_SPrint(
            "cohomolo presentation mode = CHR(G,3,0,mats); ",
            "no fp presentation is built in S_1.\n"
        );
    fi;
    CF_SPrint("|input K0| = ", input.originalKOrder, "\n");
    CF_SPrint(
        "input K0 already contains mu_3 = ",
        input.inputAlreadyContainsMu3,
        "\n"
    );
    CF_SPrint("|Kplus=<K0,mu_3>| = ", Size(input.K), "\n");
    CF_SPrint("|Kplus/mu_3| = ", Size(input.Kbar), "\n");
    CF_SPrint(
        "determinant values on supplied K0 generators = ",
        input.determinantGeneratorValues,
        "\n"
    );
    CF_SPrint(
        "input K0 is determinant-one/symplectic = ",
        input.determinantIsTrivial,
        " (required for exact symplectic-kernel classification)\n"
    );
    CF_SPrint(
        "|mu_3 intersection [Kplus,Kplus]| = ",
        input.kernelDerivedIntersectionOrder,
        "\n"
    );
    CF_SPrint(
        "Kplus is compatible with a liftable projective action = ",
        input.projectiveLiftableType,
        "\n"
    );
    CF_SPrint("G_ab invariants = ", abinv, "\n");
    CF_SPrint("3-primary Schur multiplier invariants = ", multiplier3, "\n");
    CF_SPrint(
        "dim_GF(3) Hom(M(G),C3) = ",
        homMultiplierDimension,
        "\n"
    );
    CF_SPrint(
        "dim_GF(3) Ext^1(G_ab,C3) = ",
        extAbelianizationDimension,
        "\n"
    );
    CF_SPrint("dim_GF(3) H^2(G,C3) = ", h2dim, "\n");
    CF_SPrint("number of all H^2 classes = ", 3 ^ h2dim, "\n");
    CF_SPrint(
        "number of labelled liftable C3-extension classes, including split = ",
        expectedLiftableClassCount,
        "\n"
    );
    CF_SPrint(
        "number of labelled liftable Ext representatives to construct = ",
        expectedLiftableRepresentativeCount,
        "\n"
    );
    CF_SPrint(
        "Kplus central-extension split status = ",
        input.splitCentralLiftStatus,
        "\n"
    );
    CF_SPrint("normal copies of Kplus/mu_3 in G = ", Length(normalKbars), "\n");
    CF_SPrint("their indices in G = ", indices, "\n");
    if h2dim <> homMultiplierDimension + extAbelianizationDimension then
        Error(
            "The computed H^2 dimension does not match the universal-",
            "coefficient dimension check.  Completeness cannot be certified."
        );
    fi;
    if extAbelianizationDimension = 0 then
        CF_SPrint(
            "Ext^1(G_ab,C3) is trivial: only the split liftable extension ",
            "G x C3 can occur.\n"
        );
    fi;
    if not input.projectiveLiftableType then
        CF_SPrint(
            "WARNING: mu_3 intersects [Kplus,Kplus] nontrivially.  ",
            "Kplus cannot embed in a liftable extension retained by S_2.\n"
        );
    fi;
    if Length(normalKbars) = 0 then
        CF_SPrint("No normal subgroup of G is isomorphic to Kplus/mu_3.\n");
    fi;
    for S in normalKbars do
        CF_SPrint(
            "normal Kplus/mu_3 copy has index ",
            Index(G, S),
            " in G.\n"
        );
    od;
    return rec(
        quotientId          := ShallowCopy(gid),
        originalG           := G0,
        isoGToPerm          := isoG,
        G                    := G,
        input                := input,
        normalKbarSubgroups := normalKbars,
        quotientIndices     := indices,
        abelianInvariants   := abinv,
        multiplier3Invariants := multiplier3,
        HomMultiplierDimension := homMultiplierDimension,
        ExtAbelianizationDimension := extAbelianizationDimension,
        H2Dimension         := h2dim,
        H2ClassCount        := 3 ^ h2dim,
        ExpectedLiftableClassCount := expectedLiftableClassCount,
        ExpectedLiftableRepresentativeCount :=
            expectedLiftableRepresentativeCount,
        kernelInversionReductionUsed := false,
        CohomologyDimensionCheckPassed :=
            h2dim = homMultiplierDimension + extAbelianizationDimension,
        cohomologySkippedByCoprimeOrder :=
            cohomologySkippedByCoprimeOrder,
        extCharacterData := extCharacterData,
        cohomology := coh
    );
end;
CF_ForEachExtVector := function(d, callback)
    local v, search, stopped;
    v := List([1 .. d], i -> 0);
    stopped := false;
    search := function(pos)
        local a;
        if stopped then
            return;
        fi;
        if pos > d then
            if callback(ShallowCopy(v)) = true then
                stopped := true;
            fi;
            return;
        fi;
        for a in [0, 1, 2] do
            v[pos] := a;
            search(pos + 1);
            if stopped then
                return;
            fi;
        od;
    end;
    search(1);
    return stopped;
end;
if not IsBound(CF_OneLiftableExtensionFromExtVector) then
    CF_OneLiftableExtensionFromExtVector := fail;
fi;
CF_OneH2Extension := function(S1, vec)
    local G, gensG, Efp, egens, nbase, isoE, H, hgens, z, Z,
          imagesG, epi, ker, isZeroClass, derivedIntersection,
          liftableType, stem;
    G := S1.G;
    if IsBound(S1.cohomology.trivialByCoprimeOrder)
       and S1.cohomology.trivialByCoprimeOrder then
        if Length(vec) <> 0 then
            Error(
                "When 3 does not divide |G|, the only H^2 vector is []."
            );
        fi;
        return CF_OneLiftableExtensionFromExtVector(S1, []);
    fi;
    CF_EnsureCohomologyPresentation(S1.cohomology);
    gensG := S1.cohomology.generators;
    nbase := Length(gensG);
    isZeroClass := ForAll(vec, a -> a = 0);
    if isZeroClass then
        Efp := SplitExtensionCHR(S1.cohomology.chr);
    else
        Efp := NonsplitExtension(S1.cohomology.chr, vec);
    fi;
    if Efp = fail then
        Error("Extension construction failed for H^2 vector ", vec, ".");
    fi;
    egens := GeneratorsOfGroup(Efp);
    if Length(egens) <> nbase + 1 then
        Error(
            "Unexpected generator count in the cohomology extension: expected ",
            nbase + 1, ", got ", Length(egens), "."
        );
    fi;
    isoE := fail;
    if IsSolvableGroup(G) then
        isoE := IsomorphismPcGroup(Efp);
    fi;
    if isoE = fail then
        isoE := IsomorphismPermGroup(Efp);
    fi;
    if isoE = fail then
        Error("Could not convert an H^2 extension to a finite group.");
    fi;
    H := Image(isoE);
    hgens := List(egens, x -> Image(isoE, x));
    z := hgens[nbase + 1];
    Z := Subgroup(H, [z]);
    if Size(Z) <> 3 then
        Error("The distinguished module generator does not generate C3.");
    fi;
    imagesG := Concatenation(gensG, [One(G)]);
    epi := GroupHomomorphismByImages(H, G, hgens, imagesG);
    if epi = fail or Size(Image(epi)) <> Size(G) then
        Error("Could not construct the quotient map H -> G.");
    fi;
    ker := Kernel(epi);
    if Size(ker) <> 3 or not CF_SameSubgroup(ker, Z) then
        Error("The kernel of H -> G is not the distinguished C3.");
    fi;
    if not IsSubgroup(Centre(H), Z) then
        Error("The trivial-module construction did not produce a central kernel.");
    fi;
    if Size(H) <> 3 * Size(G) then
        Error("The extension group does not have order 3|G|.");
    fi;
    derivedIntersection := Intersection(Z, DerivedSubgroup(H));
    liftableType := Size(derivedIntersection) = 1;
    stem := Size(derivedIntersection) = 3;
    return rec(
        H2Vector            := ShallowCopy(vec),
        isZeroH2Class       := isZeroClass,
        H                   := H,
        HId                 := fail,
        extensionGenerators := hgens,
        quotientMap         := epi,
        centralKernel       := Z,
        centralGenerator    := z,
        kernelDerivedIntersection := derivedIntersection,
        kernelDerivedIntersectionOrder := Size(derivedIntersection),
        isLiftableType      := liftableType,
        isStem              := stem,
        preimageData        := []
    );
end;
CF_SPrint("CHUNK 03/17 OK\n");
# ===================== CHUNK 03/17 END =====================

# ==================== CHUNK 04/17 START ====================
CF_OneLiftableExtensionFromExtVector := function(S1, vec)
    local G, gensG, data, e, coeffByFactor, j, i, n, N, CN, t,
          Astd, gensAstd, imagesStd, homStd, chiImages, C3N, u, pi,
          D, embG, embC, liftedGens, c, z, hgens, H, epi, ker, Z,
          derivedIntersection, isZeroClass;
    G := S1.G;
    gensG := GeneratorsOfGroup(G);
    data := S1.extCharacterData;
    e := data.dimension;
    if Length(vec) <> e or not ForAll(vec, a -> a in [0,1,2]) then
        Error("Invalid Ext-coordinate vector ", vec, ".");
    fi;
    coeffByFactor := List(data.invariantFactors, x -> 0);
    j := 1;
    for i in data.extFactorPositions do
        coeffByFactor[i] := vec[j];
        j := j + 1;
    od;
    N := data.exponent;
    CN := data.characterTarget;
    t := data.characterTargetGenerator;
    Astd := data.standardAbelianization;
    gensAstd := data.standardGenerators;
    if N = 1 then
        chiImages := List(gensG, g -> One(CN));
    else
        imagesStd := [];
        for i in [1 .. Length(data.invariantFactors)] do
            n := data.invariantFactors[i];
            Add(
                imagesStd,
                t ^ (QuoInt(N, n) * coeffByFactor[i])
            );
        od;
        homStd := GroupHomomorphismByImages(
            Astd,
            CN,
            gensAstd,
            imagesStd
        );
        if homStd = fail then
            Error("Could not construct the abelianization character.");
        fi;
        chiImages := List(
            gensG,
            g -> Image(
                homStd,
                Image(
                    data.isomorphismToStandard,
                    Image(data.abelianizationMap, g)
                )
            )
        );
    fi;
    C3N := CyclicGroup(IsPermGroup, 3 * N);
    u := GeneratorsOfGroup(C3N)[1];
    pi := GroupHomomorphismByImages(
        C3N,
        CN,
        [u],
        [t]
    );
    if pi = fail then
        Error("Could not construct C_{3N}->C_N.");
    fi;
    D := DirectProduct(G, C3N);
    embG := Embedding(D, 1);
    embC := Embedding(D, 2);
    liftedGens := [];
    for i in [1 .. Length(gensG)] do
        c := PreImagesRepresentative(pi, chiImages[i]^-1);
        if c = fail then
            Error("Could not lift an abelianization-character value to C_{3N}.");
        fi;
        Add(
            liftedGens,
            Image(embG, gensG[i]) * Image(embC, c)
        );
    od;
    z := Image(embC, u^N);
    hgens := Concatenation(liftedGens, [z]);
    H := Group(hgens);
    Z := Subgroup(H, [z]);
    epi := GroupHomomorphismByImages(
        H,
        G,
        hgens,
        Concatenation(gensG, [One(G)])
    );
    if epi = fail or Size(Image(epi)) <> Size(G) then
        Error("Could not construct the quotient map of a direct Ext pullback.");
    fi;
    ker := Kernel(epi);
    if Size(H) <> 3 * Size(G)
       or Size(ker) <> 3
       or not CF_SameSubgroup(ker, Z)
       or not IsSubgroup(Centre(H), Z) then
        Error("The direct Ext pullback failed its central-extension checks.");
    fi;
    derivedIntersection := Intersection(Z, DerivedSubgroup(H));
    if Size(derivedIntersection) <> 1 then
        Error("A directly constructed Ext class unexpectedly has multiplier part.");
    fi;
    isZeroClass := ForAll(vec, a -> a = 0);
    return rec(
        H2Vector := ShallowCopy(vec),
        ExtVector := ShallowCopy(vec),
        extensionCoordinateType :=
            "Ext^1 coordinates from abelian invariant factors modulo cubes",
        isZeroH2Class := isZeroClass,
        H := H,
        HId := fail,
        extensionGenerators := hgens,
        quotientMap := epi,
        centralKernel := Z,
        centralGenerator := z,
        kernelDerivedIntersection := derivedIntersection,
        kernelDerivedIntersectionOrder := 1,
        isLiftableType := true,
        isStem := false,
        constructionMode := "direct Ext pullback",
        extensionCharacterImages := chiImages,
        preimageData := []
    );
end;
CF_AttachKPreimages := function(ext, S1)
    local S, P, isoKP, complements, passesSplitTest, passesIdTest, PId;
    ext.preimageData := [];
    ext.splitRestrictionRejects := 0;
    ext.abstractIdRejects := 0;
    for S in S1.normalKbarSubgroups do
        P := PreImage(ext.quotientMap, S);
        if Size(P) = Size(S1.input.K) then
            passesSplitTest := true;
            if S1.input.isSplitCentralLift and IsSolvableGroup(P) then
                complements := ComplementClassesRepresentatives(
                    P,
                    ext.centralKernel
                );
                if Length(complements) = 0 then
                    passesSplitTest := false;
                    ext.splitRestrictionRejects :=
                        ext.splitRestrictionRejects + 1;
                fi;
            fi;
            if passesSplitTest then
                passesIdTest := true;
                if S1.input.abstractId <> fail
                   and IdGroupsAvailable(Size(P)) then
                    PId := IdGroup(P);
                    if PId <> S1.input.abstractId then
                        passesIdTest := false;
                        ext.abstractIdRejects :=
                            ext.abstractIdRejects + 1;
                    fi;
                fi;
                if passesIdTest then
                    isoKP := IsomorphismGroups(S1.input.K, P);
                    if isoKP <> fail then
                        Add(
                            ext.preimageData,
                            rec(
                                quotientSubgroup := S,
                                preimage         := P,
                                isomorphismKToPreimage := isoKP
                            )
                        );
                    fi;
                fi;
            fi;
        fi;
    od;
end;
CF_ClassPositionContainingElement := function(classes, element)
    return PositionProperty(classes, C -> element in C);
end;
CF_ClassFusionByImageFunction := function(sourceTable, targetTable, imageFunction)
    local sourceClasses, targetClasses, fusion, C, image, pos;
    sourceClasses := ConjugacyClasses(sourceTable);
    targetClasses := ConjugacyClasses(targetTable);
    fusion := [];
    for C in sourceClasses do
        image := imageFunction(Representative(C));
        pos := CF_ClassPositionContainingElement(targetClasses, image);
        if pos = fail then
            Error("Could not locate an image in the target character-table classes.");
        fi;
        Add(fusion, pos);
    od;
    return fusion;
end;
CF_PullbackClassFunctionByFusion := function(cf, sourceTable, fusion)
    local values;
    if Length(fusion) <> NrConjugacyClasses(sourceTable) then
        Error("A class-fusion list has the wrong length.");
    fi;
    values := ValuesOfClassFunction(cf){fusion};
    if IsCharacter(cf) then
        return Character(sourceTable, values);
    elif IsVirtualCharacter(cf) then
        return VirtualCharacter(sourceTable, values);
    else
        return ClassFunction(sourceTable, values);
    fi;
end;
CF_PrepareScalarCharacterOrbitRecordsForTarget := function(
    S1,
    targetScalarSubgroup
)
    local K, gensK, chiK, ZK, tblK, cacheEntry, autK, action,
          transporter, stabilizer, stabGens, steps, records, pos,
          current, alpha, beta, newAlpha, invAlpha,
          fusion, target, existing;
    K := S1.input.K;
    gensK := S1.input.generators;
    chiK := S1.input.character;
    tblK := UnderlyingCharacterTable(chiK);
    ZK := S1.input.scalarSubgroup;
    for cacheEntry in S1.input.scalarCompatibleOrbitCache do
        if CF_SameSubgroup(
            cacheEntry.targetScalarSubgroup,
            targetScalarSubgroup
        ) then
            return cacheEntry.records;
        fi;
    od;
    if S1.input.automorphismGroupCache = fail then
        CF_SPrint(
            "Computing Aut(Kplus) once; subsequent scalar-compatible ",
            "orbits use transporter-stabilizer reduction...\n"
        );
        S1.input.automorphismGroupCache := AutomorphismGroup(K);
    fi;
    autK := S1.input.automorphismGroupCache;
    action := function(S, a)
        return Image(a, S);
    end;
    transporter := RepresentativeAction(
        autK,
        ZK,
        targetScalarSubgroup,
        action
    );
    if transporter = fail then
        Add(
            S1.input.scalarCompatibleOrbitCache,
            rec(
                targetScalarSubgroup := targetScalarSubgroup,
                records := []
            )
        );
        return [];
    fi;
    stabilizer := Stabilizer(
        autK,
        targetScalarSubgroup,
        action
    );
    stabGens := GeneratorsOfGroup(stabilizer);
    steps := Concatenation(
        stabGens,
        List(stabGens, a -> InverseGeneralMapping(a))
    );
    alpha := transporter;
    invAlpha := InverseGeneralMapping(alpha);
    fusion := CF_ClassFusionByImageFunction(
        tblK,
        tblK,
        g -> Image(invAlpha, g)
    );
    target := CF_PullbackClassFunctionByFusion(chiK, tblK, fusion);
    records := [
        rec(
            targetCharacter := target,
            scalarSubgroup := targetScalarSubgroup,
            automorphism := alpha
        )
    ];
    pos := 1;
    while pos <= Length(records) do
        current := records[pos];
        alpha := current.automorphism;
        for beta in steps do
            newAlpha := alpha * beta;
            invAlpha := InverseGeneralMapping(newAlpha);
            fusion := CF_ClassFusionByImageFunction(
                tblK,
                tblK,
                g -> Image(invAlpha, g)
            );
            target := CF_PullbackClassFunctionByFusion(
                chiK,
                tblK,
                fusion
            );
            existing := PositionProperty(
                records,
                r -> r.targetCharacter = target
            );
            if existing = fail then
                Add(
                    records,
                    rec(
                        targetCharacter := target,
                        scalarSubgroup := targetScalarSubgroup,
                        automorphism := newAlpha
                    )
                );
            fi;
        od;
        pos := pos + 1;
    od;
    Add(
        S1.input.scalarCompatibleOrbitCache,
        rec(
            targetScalarSubgroup := targetScalarSubgroup,
            records := records
        )
    );
    CF_SPrint(
        "scalar-compatible character orbit size for one target C3 = ",
        Length(records),
        "\n"
    );
    return records;
end;
CF_ScalarCompatibleTargetRecords := function(S1, ext, preimageRecord)
    local K, isoKP, targetScalarSubgroup, orbitRecords,
          orbitRecord, target, targets, pos, alpha, alignedImages,
          alignedSubgroup, tblK, tblH, baseFusion;
    K := S1.input.K;
    isoKP := preimageRecord.isomorphismKToPreimage;
    tblK := UnderlyingCharacterTable(S1.input.character);
    tblH := CharacterTable(ext.H);
    targetScalarSubgroup := Image(
        InverseGeneralMapping(isoKP),
        ext.centralKernel
    );
    if Size(targetScalarSubgroup) <> 3 then
        Error("The preimage of the extension kernel in Kplus is not C3.");
    fi;
    baseFusion := CF_ClassFusionByImageFunction(
        tblK,
        tblH,
        g -> Image(isoKP, g)
    );
    orbitRecords := CF_PrepareScalarCharacterOrbitRecordsForTarget(
        S1,
        targetScalarSubgroup
    );
    targets := [];
    for orbitRecord in orbitRecords do
        target := orbitRecord.targetCharacter;
        pos := PositionProperty(
            targets,
            r -> r.targetCharacter = target
        );
        if pos = fail then
            alpha := orbitRecord.automorphism;
            alignedImages := List(
                S1.input.generators,
                g -> Image(isoKP, Image(alpha, g))
            );
            alignedSubgroup := Subgroup(ext.H, alignedImages);
            if Size(alignedSubgroup) <> Size(K) then
                Error("A scalar-compatible Kplus image has the wrong order.");
            fi;
            Add(
                targets,
                rec(
                    baseClassFusion := ShallowCopy(baseFusion),
                    automorphism := alpha,
                    alignedGeneratorImages := alignedImages,
                    alignedSubgroup := alignedSubgroup,
                    targetCharacter := target
                )
            );
        fi;
    od;
    return targets;
end;
CF_SPrint("CHUNK 04/17 OK\n");
# ===================== CHUNK 04/17 END =====================

# ==================== CHUNK 05/17 START ====================
CF_RestrictionMultiplicitySolutions := function(
    irrH,
    eligibleIndices,
    baseClassFusion,
    irrK,
    targetRecords
)
    local canonicalTable, columns, answer, targetRecord,
          targetCharacter, targetVector, goodPositions, goodIndices,
          goodColumns, partialSolutions, partial, full, i, j, res;
    answer := [];
    if Length(eligibleIndices) = 0 then
        return answer;
    fi;
    if Length(irrK) = 0 then
        Error("The irreducible character list of K is empty.");
    fi;
    canonicalTable := UnderlyingCharacterTable(irrK[1]);
    columns := [];
    for i in eligibleIndices do
        res := CF_PullbackClassFunctionByFusion(
            irrH[i],
            canonicalTable,
            baseClassFusion
        );
        Add(columns, List(irrK, psi -> ScalarProduct(res, psi)));
    od;
    for targetRecord in targetRecords do
        targetCharacter := targetRecord.targetCharacter;
        if not IsIdenticalObj(
            UnderlyingCharacterTable(targetCharacter),
            canonicalTable
        ) then
            Error("A target character is not attached to the canonical K table.");
        fi;
        targetVector := List(
            irrK,
            psi -> ScalarProduct(targetCharacter, psi)
        );
        goodPositions := Filtered(
            [1 .. Length(columns)],
            i -> ForAll(
                [1 .. Length(targetVector)],
                j -> columns[i][j] <= targetVector[j]
            )
        );
        goodIndices := eligibleIndices{goodPositions};
        goodColumns := columns{goodPositions};
        partialSolutions := CF_NonnegativeColumnSolutions(
            goodColumns,
            targetVector
        );
        for partial in partialSolutions do
            full := List([1 .. Length(irrH)], i -> 0);
            for j in [1 .. Length(goodIndices)] do
                full[goodIndices[j]] := partial[j];
            od;
            Add(
                answer,
                rec(
                    multiplicities := full,
                    targetRecord   := targetRecord
                )
            );
        od;
    od;
    return answer;
end;
CF_BlockImageOfComponents := function(componentMaps, element)
    return CF_BlockDiagonalMatrixList(
        List(componentMaps, rep -> Image(rep, element))
    );
end;
CF_BuildMatrixRepresentation := function(H, irrH, multiplicities, repCache)
    local componentMaps, i, j, rep, hgens, matrices, candidate;
    componentMaps := [];
    for i in [1 .. Length(irrH)] do
        if multiplicities[i] > 0 then
            if repCache.byIndex[i] = fail then
                rep := IrreducibleRepresentationsDixon(H, irrH[i]);
                if rep = fail then
                    if repCache.allRepresentations = fail then
                        repCache.allRepresentations := IrreducibleRepresentations(H);
                        if repCache.allRepresentations = fail then
                            Error(
                                "GAP could not construct the full list of ",
                                "irreducible complex representations of H."
                            );
                        fi;
                    fi;
                    rep := fail;
                    for candidate in repCache.allRepresentations do
                        if NaturalCharacter(candidate) = irrH[i] then
                            rep := candidate;
                            break;
                        fi;
                    od;
                fi;
                if rep = fail then
                    Error(
                        "GAP could not construct an irreducible representation ",
                        "affording a required character.  The candidate is not ",
                        "discarded; the computation is stopped."
                    );
                fi;
                repCache.byIndex[i] := rep;
            fi;
            rep := repCache.byIndex[i];
            for j in [1 .. multiplicities[i]] do
                Add(componentMaps, rep);
            od;
        fi;
    od;
    hgens := GeneratorsOfGroup(H);
    matrices := List(
        hgens,
        h -> CF_BlockImageOfComponents(componentMaps, h)
    );
    return rec(
        componentMaps := componentMaps,
        generators     := hgens,
        matrices       := matrices
    );
end;
CF_IsScalarWithValue := function(A, scalar)
    local n, i, j;
    if not CF_IsScalarMatrix(A) then
        return false;
    fi;
    n := Length(A);
    for i in [1 .. n] do
        if A[i][i] <> scalar then
            return false;
        fi;
        for j in [1 .. n] do
            if i <> j and A[i][j] <> 0 then
                return false;
            fi;
        od;
    od;
    return true;
end;
CF_ScalarImagesOfAbstractCentre := function(H, componentMaps)
    local answer, h, A;
    answer := [];
    for h in Elements(Centre(H)) do
        A := CF_BlockImageOfComponents(componentMaps, h);
        if CF_IsScalarMatrix(A) then
            Add(answer, rec(element := h, matrix := A));
        fi;
    od;
    return answer;
end;
CF_SPrint("CHUNK 05/17 OK\n");
# ===================== CHUNK 05/17 END =====================

# ==================== CHUNK 06/17 START ====================
CF_SolutionsForOneExtension := function(S1, ext)
    local H, z, irrH, tblH, classesH, posz, scalar, eligible,
          preimageRecord, targetRecords, candidates, c, characterCandidates,
          existing, alignment, repCache, built, chiH, centralImage,
          scalarImages, Bgens, P, Pinv, alignedMatrices,
          answer, hgens, i, charCandidate, determinantCharacter,
          symplecticKernel, determinantValues, determinantCompatibleAlignments,
          determinantRejectedAlignmentCount, totalAlignmentCount,
          faithfulCharacterCount, determinantCompatibleCharacterCount,
          alignmentSucceeded, generatorIndex;
    H := ext.H;
    z := ext.centralGenerator;
    irrH := Irr(H);
    tblH := UnderlyingCharacterTable(irrH[1]);
    classesH := ConjugacyClasses(tblH);
    posz := PositionProperty(classesH, C -> z in C);
    if posz = fail then
        Error("Could not locate the central generator in table-ordered classes.");
    fi;
    characterCandidates := [];
    for scalar in [E(3), E(3)^2] do
        eligible := Filtered(
            [1 .. Length(irrH)],
            i -> DegreeOfCharacter(irrH[i]) <= 6
                 and irrH[i][posz] = scalar * DegreeOfCharacter(irrH[i])
        );
        for preimageRecord in ext.preimageData do
            targetRecords := CF_ScalarCompatibleTargetRecords(
                S1,
                ext,
                preimageRecord
            );
            if Length(targetRecords) > 0 then
                candidates := CF_RestrictionMultiplicitySolutions(
                    irrH,
                    eligible,
                    targetRecords[1].baseClassFusion,
                    S1.input.irreducibles,
                    targetRecords
                );
                for c in candidates do
                    existing := PositionProperty(
                        characterCandidates,
                        r -> r.scalar = scalar
                             and r.multiplicities = c.multiplicities
                    );
                    alignment := rec(
                        targetRecord := c.targetRecord,
                        preimageRecord := preimageRecord
                    );
                    if existing = fail then
                        Add(
                            characterCandidates,
                            rec(
                                scalar := scalar,
                                multiplicities := c.multiplicities,
                                alignments := [alignment]
                            )
                        );
                    else
                        Add(characterCandidates[existing].alignments, alignment);
                    fi;
                od;
            fi;
        od;
    od;
    totalAlignmentCount := Sum(
        List(characterCandidates, r -> Length(r.alignments))
    );
    CF_SPrint(
        "    distinct degree-6 characters = ",
        Length(characterCandidates),
        "; retained Kplus alignments = ",
        totalAlignmentCount,
        "\n"
    );
    repCache := rec(
        byIndex := List([1 .. Length(irrH)], i -> fail),
        allRepresentations := fail
    );
    answer := [];
    determinantRejectedAlignmentCount := 0;
    faithfulCharacterCount := 0;
    determinantCompatibleCharacterCount := 0;
    for charCandidate in characterCandidates do
        chiH := CF_CharacterFromMultiplicities(
            irrH,
            charCandidate.multiplicities
        );
        if DegreeOfCharacter(chiH) <> 6 then
            Error("Internal error: a candidate character does not have degree 6.");
        fi;
        if ClassPositionsOfKernel(chiH) = [1] then
            faithfulCharacterCount := faithfulCharacterCount + 1;
            determinantCharacter := DeterminantOfCharacter(chiH);
            symplecticKernel := KernelOfCharacter(determinantCharacter);
            determinantCompatibleAlignments := Filtered(
                charCandidate.alignments,
                a -> CF_SameSubgroup(
                    a.targetRecord.alignedSubgroup,
                    symplecticKernel
                )
            );
            determinantRejectedAlignmentCount :=
                determinantRejectedAlignmentCount
                + Length(charCandidate.alignments)
                - Length(determinantCompatibleAlignments);
            if Length(determinantCompatibleAlignments) > 0 then
                determinantCompatibleCharacterCount :=
                    determinantCompatibleCharacterCount + 1;
                built := CF_BuildMatrixRepresentation(
                    H,
                    irrH,
                    charCandidate.multiplicities,
                    repCache
                );
                centralImage := CF_BlockImageOfComponents(
                    built.componentMaps,
                    z
                );
                scalarImages := CF_ScalarImagesOfAbstractCentre(
                    H,
                    built.componentMaps
                );
                if Length(scalarImages) = 3
                   and CF_IsScalarWithValue(
                       centralImage,
                       charCandidate.scalar
                   ) then
                    alignmentSucceeded := false;
                    for alignment in determinantCompatibleAlignments do
                        Bgens := List(
                            alignment.targetRecord.alignedGeneratorImages,
                            h -> CF_BlockImageOfComponents(
                                built.componentMaps,
                                h
                            )
                        );
                        P := CF_Intertwiner(
                            Bgens,
                            S1.input.generatorMatrices
                        );
                        Pinv := P^-1;
                        for generatorIndex in [1 .. Length(Bgens)] do
                            if Pinv * Bgens[generatorIndex] * P
                               <> S1.input.generatorMatrices[generatorIndex] then
                                Error(
                                    "Internal error: the aligned Kplus generator ",
                                    "does not equal the fixed input generator."
                                );
                            fi;
                        od;
                        alignedMatrices := List(
                            built.matrices,
                            A -> Pinv * A * P
                        );
                        hgens := built.generators;
                        determinantValues := List(
                            hgens,
                            g -> g ^ determinantCharacter
                        );
                        Add(
                            answer,
                            rec(
                                H2Vector := ShallowCopy(ext.H2Vector),
                                HId := ext.HId,
                                H := H,
                                HGenerators := hgens,
                                character := chiH,
                                multiplicities :=
                                    charCandidate.multiplicities,
                                centralizerDimensionByCharacter :=
                                    Sum(
                                        charCandidate.multiplicities,
                                        m -> m * m
                                    ),
                                centralScalar := charCandidate.scalar,
                                matrixGenerators := alignedMatrices,
                                matrixImageOrder := Size(H),
                                alignedKplusSubgroup :=
                                    alignment.targetRecord.alignedSubgroup,
                                quotientKbarSubgroup :=
                                    alignment.preimageRecord.quotientSubgroup,
                                determinantGeneratorValues :=
                                    determinantValues,
                                determinantImageOrder :=
                                    Order(determinantCharacter),
                                determinantIsTrivial :=
                                    Size(symplecticKernel) = Size(H),
                                wholeProjectiveGroupSymplectic :=
                                    Size(symplecticKernel) = Size(H),
                                symplecticKernel := symplecticKernel,
                                symplecticKernelOrder :=
                                    Size(symplecticKernel),
                                symplecticKernelContainedInInputKMu3 := true,
                                symplecticKernelContainedInInputK := true,
                                symplecticKernelEqualsInputKMu3 := true,
                                symplecticKernelEqualsInputK := true,
                                allElementsOutsideInputKMu3AreNonsymplectic :=
                                    true,
                                allElementsOutsideInputKAreNonsymplectic :=
                                    true
                            )
                        );
                        alignmentSucceeded := true;
                        break;
                    od;
                    if not alignmentSucceeded then
                        Error(
                            "A determinant-compatible character had no usable ",
                            "Kplus alignment."
                        );
                    fi;
                fi;
            fi;
        fi;
    od;
    return rec(
        solutions := answer,
        distinctCharacterCount := Length(characterCandidates),
        totalAlignmentCount := totalAlignmentCount,
        faithfulCharacterCount := faithfulCharacterCount,
        determinantRejectedAlignmentCount :=
            determinantRejectedAlignmentCount,
        determinantCompatibleCharacterCount :=
            determinantCompatibleCharacterCount
    );
end;
CF_NaturalCharacterOfMatrixGroup := function(M)
    local isoM, P, rho, classes, values, chi;
    isoM := IsomorphismPermGroup(M);
    if isoM = fail then
        Error("Could not convert a matrix image to a permutation group.");
    fi;
    P := Image(isoM);
    rho := InverseGeneralMapping(isoM);
    chi := NaturalCharacter(rho);
    if not IsCharacter(chi) then
        Error("The natural character of a matrix image was not recognized.");
    fi;
    return rec(
        permutationGroup := P,
        isoMatrixToPerm  := isoM,
        character        := chi
    );
end;
CF_CharacterOrbitUnderAutomorphisms := function(G, chi)
    local tbl, autG, autGens, orbit, pos, current, alpha, twisted, fusion;
    tbl := UnderlyingCharacterTable(chi);
    autG := AutomorphismGroup(G);
    autGens := GeneratorsOfGroup(autG);
    orbit := [chi];
    pos := 1;
    while pos <= Length(orbit) do
        current := orbit[pos];
        for alpha in autGens do
            fusion := CF_ClassFusionByImageFunction(
                tbl,
                tbl,
                g -> Image(alpha, g)
            );
            twisted := CF_PullbackClassFunctionByFusion(
                current,
                tbl,
                fusion
            );
            if Position(orbit, twisted) = fail then
                Add(orbit, twisted);
            fi;
        od;
        pos := pos + 1;
    od;
    return orbit;
end;
CF_SPrint("CHUNK 06/17 OK\n");
# ===================== CHUNK 06/17 END =====================

# ==================== CHUNK 07/17 START ====================
CF_StandardMatrixImageDataCached := function(solution, standardCache)
    local natural, P, pid, pos, cacheRecord, Pstd, tblStd,
          isoStdToP, chiStd;
    natural := CF_NaturalCharacterOfMatrixGroup(solution.matrixImage);
    P := natural.permutationGroup;
    if IdGroupsAvailable(Size(P)) then
        pid := IdGroup(P);
        pos := PositionProperty(
            standardCache,
            r -> r.groupId = pid
        );
        if pos = fail then
            Pstd := SmallGroup(pid[1], pid[2]);
            tblStd := CharacterTable(Pstd);
            cacheRecord := rec(
                groupId := pid,
                group   := Pstd,
                table   := tblStd
            );
            Add(standardCache, cacheRecord);
        else
            cacheRecord := standardCache[pos];
            Pstd := cacheRecord.group;
            tblStd := cacheRecord.table;
        fi;
        isoStdToP := IsomorphismGroups(Pstd, P);
        if isoStdToP = fail then
            Error(
                "Could not identify a matrix image with the cached ",
                "SmallGroup representative ", pid, "."
            );
        fi;
        chiStd := CF_PullbackClassFunctionByFusion(
            natural.character,
            tblStd,
            CF_ClassFusionByImageFunction(
                tblStd,
                UnderlyingCharacterTable(natural.character),
                g -> Image(isoStdToP, g)
            )
        );
        return rec(
            hasId      := true,
            groupId    := pid,
            group      := Pstd,
            table      := tblStd,
            character  := chiStd,
            order      := Size(P)
        );
    fi;
    return rec(
        hasId      := false,
        groupId    := fail,
        group      := P,
        table      := UnderlyingCharacterTable(natural.character),
        character  := natural.character,
        order      := Size(P)
    );
end;
CF_AreConjugateMatrixImages := function(data1, data2)
    local orbit, chi2;
    if data1.order <> data2.order then
        return false;
    fi;
    if not data1.hasId or not data2.hasId then
        return false;
    fi;
    if data1.groupId <> data2.groupId then
        return false;
    fi;
    if not IsIdenticalObj(data1.group, data2.group) then
        Error(
            "Internal deduplication error: equal SmallGroup IDs were ",
            "represented by different canonical group objects."
        );
    fi;
    chi2 := data2.character;
    orbit := CF_CharacterOrbitUnderAutomorphisms(
        data1.group,
        data1.character
    );
    return Position(orbit, chi2) <> fail;
end;
CF_ApplyIndexPermutationToMultiplicityVector := function(vec, indexImages)
    local answer, i;
    answer := List([1 .. Length(vec)], i -> 0);
    for i in [1 .. Length(vec)] do
        answer[indexImages[i]] := vec[i];
    od;
    return answer;
end;
CF_FastDedupGroupCache := function(sol, groupCaches, needAutomorphisms)
    local pid, pos, cache, Gstd, tbl, irr, autG, autGens,
          irreducibleActions, alpha, action, i, twisted, imageIndex, fusion;
    if needAutomorphisms <> true and needAutomorphisms <> false then
        Error("The deduplication automorphism flag must be boolean.");
    fi;
    pid := sol.HId;
    if pid = fail then
        if not IdGroupsAvailable(Size(sol.H)) then
            return fail;
        fi;
        pid := IdGroup(sol.H);
        sol.HId := pid;
    fi;
    pos := PositionProperty(groupCaches, r -> r.groupId = pid);
    if pos = fail then
        CF_SPrint(
            "  dedup: preparing canonical SmallGroup(", pid[1], ",", pid[2],
            ") and Irr(H)...\n"
        );
        Gstd := SmallGroup(pid[1], pid[2]);
        tbl := CharacterTable(Gstd);
        irr := Irr(Gstd);
        cache := rec(
            groupId := pid,
            group := Gstd,
            table := tbl,
            irreducibles := irr,
            automorphismsPrepared := false,
            automorphismGroup := fail,
            irreducibleActions := [],
            cachedVectors := [],
            cachedKeys := []
        );
        Add(groupCaches, cache);
        pos := Length(groupCaches);
    fi;
    cache := groupCaches[pos];
    if needAutomorphisms and not cache.automorphismsPrepared then
        CF_SPrint(
            "  dedup: computing Aut(H)-action on Irr(H) for SmallGroup(",
            pid[1], ",", pid[2], ")...\n"
        );
        autG := AutomorphismGroup(cache.group);
        autGens := GeneratorsOfGroup(autG);
        irreducibleActions := [];
        for alpha in autGens do
            action := [];
            fusion := CF_ClassFusionByImageFunction(
                cache.table,
                cache.table,
                g -> Image(alpha, g)
            );
            for i in [1 .. Length(cache.irreducibles)] do
                twisted := CF_PullbackClassFunctionByFusion(
                    cache.irreducibles[i],
                    cache.table,
                    fusion
                );
                imageIndex := Position(cache.irreducibles, twisted);
                if imageIndex = fail then
                    Error(
                        "An automorphism did not permute Irr(H) as expected."
                    );
                fi;
                Add(action, imageIndex);
            od;
            Add(irreducibleActions, action);
        od;
        cache.automorphismGroup := autG;
        cache.irreducibleActions := irreducibleActions;
        cache.automorphismsPrepared := true;
    fi;
    return cache;
end;
CF_FastDedupSourceCache := function(sol, groupCache, sourceCaches)
    local pos, isoStdToSource, sourceIrr, sourceTable, sourceToStandard,
          i, transported, imageIndex, fusion;
    pos := PositionProperty(
        sourceCaches,
        r -> IsIdenticalObj(r.sourceGroup, sol.H)
    );
    if pos <> fail then
        return sourceCaches[pos];
    fi;
    isoStdToSource := IsomorphismGroups(groupCache.group, sol.H);
    if isoStdToSource = fail then
        Error(
            "Could not identify an extension group with its canonical ",
            "SmallGroup representative during fast deduplication."
        );
    fi;
    sourceIrr := Irr(sol.H);
    sourceTable := UnderlyingCharacterTable(sourceIrr[1]);
    sourceToStandard := [];
    fusion := CF_ClassFusionByImageFunction(
        groupCache.table,
        sourceTable,
        g -> Image(isoStdToSource, g)
    );
    for i in [1 .. Length(sourceIrr)] do
        transported := CF_PullbackClassFunctionByFusion(
            sourceIrr[i],
            groupCache.table,
            fusion
        );
        imageIndex := Position(groupCache.irreducibles, transported);
        if imageIndex = fail then
            Error(
                "Could not match an irreducible character with the ",
                "canonical SmallGroup character table."
            );
        fi;
        Add(sourceToStandard, imageIndex);
    od;
    Add(
        sourceCaches,
        rec(
            sourceGroup := sol.H,
            groupCache := groupCache,
            sourceToStandard := sourceToStandard
        )
    );
    return sourceCaches[Length(sourceCaches)];
end;
CF_StandardMultiplicityVector := function(sol, sourceCache)
    local answer, i;
    if Length(sol.multiplicities)
       <> Length(sourceCache.sourceToStandard) then
        Error(
            "The stored multiplicity vector has the wrong length during ",
            "fast deduplication."
        );
    fi;
    answer := List(
        [1 .. Length(sourceCache.groupCache.irreducibles)],
        i -> 0
    );
    for i in [1 .. Length(sol.multiplicities)] do
        answer[sourceCache.sourceToStandard[i]] :=
            answer[sourceCache.sourceToStandard[i]]
            + sol.multiplicities[i];
    od;
    return answer;
end;
CF_CanonicalMultiplicityOrbitKey := function(vec, groupCache)
    local cachedPosition, orbit, position, current, action, image,
          canonicalString, imageString, v, pos;
    cachedPosition := Position(groupCache.cachedVectors, vec);
    if cachedPosition <> fail then
        return groupCache.cachedKeys[cachedPosition];
    fi;
    orbit := [ShallowCopy(vec)];
    position := 1;
    canonicalString := String(vec);
    while position <= Length(orbit) do
        current := orbit[position];
        for action in groupCache.irreducibleActions do
            image := CF_ApplyIndexPermutationToMultiplicityVector(
                current,
                action
            );
            if Position(orbit, image) = fail then
                Add(orbit, image);
                imageString := String(image);
                if imageString < canonicalString then
                    canonicalString := imageString;
                fi;
            fi;
        od;
        position := position + 1;
    od;
    for v in orbit do
        pos := Position(groupCache.cachedVectors, v);
        if pos = fail then
            Add(groupCache.cachedVectors, ShallowCopy(v));
            Add(groupCache.cachedKeys, canonicalString);
        fi;
    od;
    return canonicalString;
end;
CF_SPrint("CHUNK 07/17 OK\n");
# ===================== CHUNK 07/17 END =====================

# ==================== CHUNK 08/17 START ====================
CF_DeduplicateConjugateMatrixImages := function(arg)
    local rawSolutions, kept, keptKeys, groupCaches, sourceCaches, total,
          counter, progressStep, sol, groupCache, sourceCache, standardVector,
          orbitKey, fullKey, pos, vectorsToMerge, vectorToMerge,
          rawCountToMerge, dedupMode, needAutomorphisms;
    if Length(arg) < 1 or Length(arg) > 3 then
        Error(
            "Use CF_DeduplicateConjugateMatrixImages(solutions), optionally ",
            "adding a canonical-group cache and a deduplication mode."
        );
    fi;
    rawSolutions := arg[1];
    if Length(arg) >= 2 then
        groupCaches := arg[2];
        if not IsList(groupCaches) then
            Error("The shared deduplication cache must be a list.");
        fi;
    else
        groupCaches := [];
    fi;
    if Length(arg) = 3 then
        dedupMode := arg[3];
    else
        dedupMode := "automorphism-orbit";
    fi;
    if not dedupMode in ["automorphism-orbit", "exact-character"] then
        Error(
            "The deduplication mode must be automorphism-orbit or ",
            "exact-character."
        );
    fi;
    needAutomorphisms := dedupMode = "automorphism-orbit";
    kept := [];
    keptKeys := [];
    sourceCaches := [];
    total := Length(rawSolutions);
    if total = 0 then
        return [];
    fi;
    if needAutomorphisms then
        CF_SPrint(
            "Exact GL(6)-conjugacy deduplication by Aut(H)-orbits of ",
            "character multiplicities...\n"
        );
    else
        CF_SPrint(
            "Conservative deduplication by identical canonical characters; ",
            "Aut(H) is not computed.\n"
        );
    fi;
    progressStep := Maximum(1, QuoInt(total, 20));
    counter := 0;
    for sol in rawSolutions do
        counter := counter + 1;
        groupCache := CF_FastDedupGroupCache(
            sol,
            groupCaches,
            needAutomorphisms
        );
        if groupCache = fail then
            standardVector := [];
            fullKey := Concatenation(
                "NO_ID_EXT:",
                String(sol.ExtVector),
                ":LOCAL:",
                String(counter)
            );
        else
            sourceCache := CF_FastDedupSourceCache(
                sol,
                groupCache,
                sourceCaches
            );
            standardVector := CF_StandardMultiplicityVector(
                sol,
                sourceCache
            );
            if needAutomorphisms then
                orbitKey := CF_CanonicalMultiplicityOrbitKey(
                    standardVector,
                    groupCache
                );
                fullKey := Concatenation(
                    String(groupCache.groupId),
                    ":AUT:",
                    orbitKey
                );
            else
                fullKey := Concatenation(
                    String(groupCache.groupId),
                    ":CHAR:",
                    String(standardVector)
                );
            fi;
        fi;
        if IsBound(sol.mergedExtVectors) then
            vectorsToMerge := List(sol.mergedExtVectors, ShallowCopy);
        else
            vectorsToMerge := [ShallowCopy(sol.ExtVector)];
        fi;
        if IsBound(sol.mergedRawSolutionCount) then
            rawCountToMerge := sol.mergedRawSolutionCount;
        else
            rawCountToMerge := 1;
        fi;
        pos := Position(keptKeys, fullKey);
        if pos = fail then
            sol.matrixImageData := rec(
                fastCharacterOrbitKey := fullKey,
                deduplicationMode := dedupMode,
                standardMultiplicityVector :=
                    ShallowCopy(standardVector)
            );
            sol.mergedExtVectors := vectorsToMerge;
            sol.mergedH2Vectors := sol.mergedExtVectors;
            sol.mergedRawSolutionCount := rawCountToMerge;
            Add(kept, sol);
            Add(keptKeys, fullKey);
        else
            for vectorToMerge in vectorsToMerge do
                if Position(
                    kept[pos].mergedExtVectors,
                    vectorToMerge
                ) = fail then
                    Add(
                        kept[pos].mergedExtVectors,
                        ShallowCopy(vectorToMerge)
                    );
                fi;
            od;
            kept[pos].mergedH2Vectors := kept[pos].mergedExtVectors;
            kept[pos].mergedRawSolutionCount :=
                kept[pos].mergedRawSolutionCount + rawCountToMerge;
        fi;
        if counter mod progressStep = 0 or counter = total then
            CF_SPrint(
                "  dedup progress ", counter, "/", total,
                "; classes so far=", Length(kept), "\n"
            );
        fi;
    od;
    return kept;
end;
CF_DeterminantGeneratorValues := function(sol)
    return List(
        sol.matrixGenerators,
        A -> DeterminantMat(A)
    );
end;
CF_AttachOutsideKSymplecticData := function(sol)
    local H, generators, determinantCharacter, determinantValues,
          symplecticKernel, allowedKplus, kernelContainedInKplus;
    H := sol.H;
    generators := sol.HGenerators;
    allowedKplus := sol.alignedKplusSubgroup;
    determinantCharacter := DeterminantOfCharacter(sol.character);
    determinantValues := List(
        generators,
        g -> g ^ determinantCharacter
    );
    symplecticKernel := KernelOfCharacter(determinantCharacter);
    kernelContainedInKplus := IsSubgroup(allowedKplus, symplecticKernel);
    sol.determinantGeneratorValues := determinantValues;
    sol.determinantImageOrder := Order(determinantCharacter);
    sol.determinantIsTrivial := Size(symplecticKernel) = Size(H);
    sol.wholeProjectiveGroupSymplectic := sol.determinantIsTrivial;
    sol.symplecticKernel := symplecticKernel;
    sol.symplecticKernelOrder := Size(symplecticKernel);
    sol.symplecticKernelContainedInInputKMu3 := kernelContainedInKplus;
    sol.symplecticKernelContainedInInputK := kernelContainedInKplus;
    sol.allElementsOutsideInputKMu3AreNonsymplectic := kernelContainedInKplus;
    sol.allElementsOutsideInputKAreNonsymplectic := kernelContainedInKplus;
    return sol;
end;
CF_AcceptOutsideKNonSymplecticSolution := function(sol)
    CF_AttachOutsideKSymplecticData(sol);
    return sol.allElementsOutsideInputKAreNonsymplectic;
end;
CF_FilterOutsideKForOneExtension := function(localSolutions)
    local retained, cache, sol, determinantValues, pos, entry;
    retained := [];
    cache := [];
    for sol in localSolutions do
        determinantValues := List(
            sol.matrixGenerators,
            DeterminantMat
        );
        pos := PositionProperty(
            cache,
            r -> IsIdenticalObj(
                     r.quotientKbarSubgroup,
                     sol.quotientKbarSubgroup
                 )
                 and r.determinantValues = determinantValues
        );
        if pos = fail then
            CF_AttachOutsideKSymplecticData(sol);
            entry := rec(
                quotientKbarSubgroup := sol.quotientKbarSubgroup,
                determinantValues := ShallowCopy(determinantValues),
                determinantImageOrder := sol.determinantImageOrder,
                determinantIsTrivial := sol.determinantIsTrivial,
                wholeProjectiveGroupSymplectic :=
                    sol.wholeProjectiveGroupSymplectic,
                symplecticKernel := sol.symplecticKernel,
                symplecticKernelOrder := sol.symplecticKernelOrder,
                kernelContainedInKplus :=
                    sol.symplecticKernelContainedInInputKMu3
            );
            Add(cache, entry);
        else
            entry := cache[pos];
            sol.determinantGeneratorValues :=
                ShallowCopy(entry.determinantValues);
            sol.determinantImageOrder := entry.determinantImageOrder;
            sol.determinantIsTrivial := entry.determinantIsTrivial;
            sol.wholeProjectiveGroupSymplectic :=
                entry.wholeProjectiveGroupSymplectic;
            sol.symplecticKernel := entry.symplecticKernel;
            sol.symplecticKernelOrder := entry.symplecticKernelOrder;
            sol.symplecticKernelContainedInInputKMu3 :=
                entry.kernelContainedInKplus;
            sol.symplecticKernelContainedInInputK :=
                entry.kernelContainedInKplus;
            sol.allElementsOutsideInputKMu3AreNonsymplectic :=
                entry.kernelContainedInKplus;
            sol.allElementsOutsideInputKAreNonsymplectic :=
                entry.kernelContainedInKplus;
        fi;
        if sol.allElementsOutsideInputKAreNonsymplectic then
            Add(retained, sol);
        fi;
    od;
    return rec(
        retained := retained,
        rejectedCount := Length(localSolutions) - Length(retained),
        determinantCacheSize := Length(cache)
    );
end;
CF_CompactPerExtensionSolution := function(sol)
    local vectors, rawCount;
    if IsBound(sol.mergedExtVectors) then
        vectors := List(sol.mergedExtVectors, ShallowCopy);
    else
        vectors := [ShallowCopy(sol.ExtVector)];
    fi;
    if IsBound(sol.mergedRawSolutionCount) then
        rawCount := sol.mergedRawSolutionCount;
    else
        rawCount := 1;
    fi;
    return rec(
        HId := sol.HId,
        ExtVector := ShallowCopy(sol.ExtVector),
        H2Vector := ShallowCopy(sol.ExtVector),
        mergedExtVectors := vectors,
        mergedH2Vectors := List(vectors, ShallowCopy),
        mergedRawSolutionCount := rawCount,
        isZeroH2Class := sol.isZeroH2Class,
        kernelDerivedIntersectionOrder := 1,
        isLiftableType := true,
        matrixGenerators := sol.matrixGenerators,
        matrixImageOrder := sol.matrixImageOrder,
        centralizerDimensionByCharacter :=
            sol.centralizerDimensionByCharacter,
        determinantGeneratorValues :=
            ShallowCopy(sol.determinantGeneratorValues),
        determinantImageOrder := sol.determinantImageOrder,
        determinantIsTrivial := sol.determinantIsTrivial,
        wholeProjectiveGroupSymplectic :=
            sol.wholeProjectiveGroupSymplectic,
        symplecticKernelOrder := sol.symplecticKernelOrder,
        symplecticKernelContainedInInputKMu3 :=
            sol.symplecticKernelContainedInInputKMu3,
        symplecticKernelContainedInInputK :=
            sol.symplecticKernelContainedInInputKMu3,
        symplecticKernelEqualsInputKMu3 :=
            sol.symplecticKernelEqualsInputKMu3,
        symplecticKernelEqualsInputK :=
            sol.symplecticKernelEqualsInputKMu3,
        allElementsOutsideInputKMu3AreNonsymplectic :=
            sol.allElementsOutsideInputKMu3AreNonsymplectic,
        allElementsOutsideInputKAreNonsymplectic :=
            sol.allElementsOutsideInputKMu3AreNonsymplectic,
        matrixImageData := rec(
            fastCharacterOrbitKey :=
                sol.matrixImageData.fastCharacterOrbitKey,
            standardMultiplicityVector := ShallowCopy(
                sol.matrixImageData.standardMultiplicityVector
            )
        )
    );
end;
CF_DeduplicateByStoredFastKey := function(compactSolutions)
    local kept, keys, sol, key, pos, v;
    kept := [];
    keys := [];
    for sol in compactSolutions do
        key := sol.matrixImageData.fastCharacterOrbitKey;
        pos := Position(keys, key);
        if pos = fail then
            Add(kept, sol);
            Add(keys, key);
        else
            for v in sol.mergedExtVectors do
                if Position(kept[pos].mergedExtVectors, v) = fail then
                    Add(kept[pos].mergedExtVectors, ShallowCopy(v));
                fi;
            od;
            kept[pos].mergedH2Vectors := kept[pos].mergedExtVectors;
            kept[pos].mergedRawSolutionCount :=
                kept[pos].mergedRawSolutionCount
                + sol.mergedRawSolutionCount;
        fi;
    od;
    return kept;
end;
CF_SPrint("CHUNK 08/17 OK\n");
# ===================== CHUNK 08/17 END =====================

# ==================== CHUNK 09/17 START ====================
CF_CompactFinalSolution := function(sol)
    return rec(
        HId := sol.HId,
        ExtVector := ShallowCopy(sol.ExtVector),
        H2Vector := ShallowCopy(sol.ExtVector),
        mergedExtVectors := List(sol.mergedExtVectors, ShallowCopy),
        mergedH2Vectors := List(sol.mergedExtVectors, ShallowCopy),
        mergedRawSolutionCount := sol.mergedRawSolutionCount,
        kernelDerivedIntersectionOrder := 1,
        isLiftableType := true,
        matrixGenerators := sol.matrixGenerators,
        matrixImageOrder := sol.matrixImageOrder,
        centralizerDimensionByCharacter :=
            sol.centralizerDimensionByCharacter,
        determinantGeneratorValues :=
            ShallowCopy(sol.determinantGeneratorValues),
        determinantImageOrder := sol.determinantImageOrder,
        determinantIsTrivial := sol.determinantIsTrivial,
        wholeProjectiveGroupSymplectic :=
            sol.wholeProjectiveGroupSymplectic,
        symplecticKernelOrder := sol.symplecticKernelOrder,
        symplecticKernelContainedInInputKMu3 :=
            sol.symplecticKernelContainedInInputKMu3,
        symplecticKernelContainedInInputK :=
            sol.symplecticKernelContainedInInputKMu3,
        symplecticKernelEqualsInputKMu3 :=
            sol.symplecticKernelEqualsInputKMu3,
        symplecticKernelEqualsInputK :=
            sol.symplecticKernelEqualsInputKMu3,
        allElementsOutsideInputKMu3AreNonsymplectic :=
            sol.allElementsOutsideInputKMu3AreNonsymplectic,
        allElementsOutsideInputKAreNonsymplectic :=
            sol.allElementsOutsideInputKMu3AreNonsymplectic,
        matrixImageData := sol.matrixImageData
    );
end;
CF_DefaultStep2Options := function()
    return rec(
        dedupMode := "automorphism-orbit",
        shareCanonicalGroupCacheAcrossExt := true,
        solutionCallback := fail,
        retainSolutions := true,
        retainEnumerationMetadata := true
    );
end;
CF_MergeStep2Options := function(options)
    local merged, name;
    merged := CF_DefaultStep2Options();
    for name in RecNames(options) do
        if not name in RecNames(merged) then
            Error("Unknown S_2 option: ", name, ".");
        fi;
        merged.(name) := options.(name);
    od;
    if not merged.dedupMode in ["automorphism-orbit", "exact-character"] then
        Error(
            "S_2 option dedupMode must be automorphism-orbit or ",
            "exact-character."
        );
    fi;
    if merged.shareCanonicalGroupCacheAcrossExt <> true
       and merged.shareCanonicalGroupCacheAcrossExt <> false then
        Error(
            "S_2 option shareCanonicalGroupCacheAcrossExt must be boolean."
        );
    fi;
    if merged.retainSolutions <> true and merged.retainSolutions <> false then
        Error("S_2 option retainSolutions must be boolean.");
    fi;
    if merged.retainEnumerationMetadata <> true
       and merged.retainEnumerationMetadata <> false then
        Error("S_2 option retainEnumerationMetadata must be boolean.");
    fi;
    if merged.solutionCallback <> fail
       and not IsFunction(merged.solutionCallback) then
        Error("S_2 option solutionCallback must be a function or fail.");
    fi;
    if not merged.retainSolutions and merged.solutionCallback = fail then
        Error(
            "S_2 cannot discard solutions unless a solutionCallback is supplied."
        );
    fi;
    return merged;
end;
CF_SPrint("CHUNK 09/17 OK\n");
# ===================== CHUNK 09/17 END =====================

# ==================== CHUNK 10/17 START ====================
S_2 := function(arg)
    local S1, targetHIds, options, extDimension, totalRepresentativeCount,
          progressStep, processed, compatibleLiftableCount,
          liftableExtVectors, compatibleExtVectors, solutionExtensions,
          retainedPerExtensionSolutions, dedupGroupCaches,
          processedSolutionClassCount,
          rawSolutionCountBeforeOutsideKFilter,
          outsideKSymplecticRejectedRawCount,
          retainedRawSolutionCountAfterOutsideKFilter,
          processVector, solutionsHeavy, solutions;
    if Length(arg) < 1 or Length(arg) > 3 then
        Error(
            "Use S_2(S1), S_2(S1, targetHIds), or add an options record."
        );
    fi;
    S1 := arg[1];
    targetHIds := [];
    options := CF_DefaultStep2Options();
    if Length(arg) >= 2 then
        targetHIds := arg[2];
        if not IsList(targetHIds) then
            Error(
                "The optional second argument must be a list of SmallGroup IDs."
            );
        fi;
    fi;
    if Length(arg) = 3 then
        if not IsRecord(arg[3]) then
            Error("The optional third S_2 argument must be an options record.");
        fi;
        options := CF_MergeStep2Options(arg[3]);
    fi;
    if not IsRecord(S1) or not IsBound(S1.extCharacterData) then
        Error("S_2 expects the audited record returned by S_1.");
    fi;
    CF_SPrint("\n============================================================\n");
    CF_SPrint("S_2: MEMORY-SAFE DIRECT Ext^1 ENUMERATION AND LINEAR LIFTS\n");
    CF_SPrint("============================================================\n");
    CF_SPrint(
        "Only Ext^1(G_ab,C3) is enumerated; multiplier/stem classes are ",
        "never constructed.\n"
    );
    CF_SPrint(
        "Each Ext class is filtered and deduplicated before the next ",
        "Ext class is constructed.\n"
    );
    if Length(targetHIds) > 0 then
        CF_SPrint("target middle-group IDs = ", targetHIds, "\n");
        CF_SPrint("Only matching H will enter the expensive Irr(H) stage.\n");
    fi;
    CF_SPrint(
        "S_2 deduplication mode = ", options.dedupMode,
        "; share canonical cache across Ext = ",
        options.shareCanonicalGroupCacheAcrossExt,
        "; retain final S_2 solutions = ", options.retainSolutions,
        "; retain enumeration metadata = ",
        options.retainEnumerationMetadata,
        ".\n"
    );
    if not S1.input.projectiveLiftableType then
        CF_SPrint(
            "The adjoined mu_3 intersects [Kplus,Kplus] nontrivially, ",
            "so Kplus cannot embed in a retained liftable H.\n"
        );
        return rec(
            step1 := S1,
            memorySafePerExtensionProcessing := true,
            ExtRepresentativeCount := 0,
            H2RepresentativeCount := 0,
            liftableRepresentativeCount := 0,
            compatibleLiftableRepresentativeCount := 0,
            liftableExtVectors := [],
            liftableH2Vectors := [],
            compatibleExtVectors := [],
            compatibleH2Vectors := [],
            solutionExtensions := [],
            rawSolutionsBeforeOutsideKFilter := fail,
            rawSolutionsBeforeOutsideKFilterStored := false,
            rawSolutionCountBeforeOutsideKFilter := 0,
            outsideKSymplecticRejectedRawCount := 0,
            retainedRawSolutionCountAfterOutsideKFilter := 0,
            rawSolutions := [],
            solutions := []
        );
    fi;
    if Length(S1.normalKbarSubgroups) = 0 then
        CF_SPrint("There is no normal copy of Kplus/mu_3 in G.\n");
        return rec(
            step1 := S1,
            memorySafePerExtensionProcessing := true,
            ExtRepresentativeCount := 0,
            H2RepresentativeCount := 0,
            liftableRepresentativeCount := 0,
            compatibleLiftableRepresentativeCount := 0,
            liftableExtVectors := [],
            liftableH2Vectors := [],
            compatibleExtVectors := [],
            compatibleH2Vectors := [],
            solutionExtensions := [],
            rawSolutionsBeforeOutsideKFilter := fail,
            rawSolutionsBeforeOutsideKFilterStored := false,
            rawSolutionCountBeforeOutsideKFilter := 0,
            outsideKSymplecticRejectedRawCount := 0,
            retainedRawSolutionCountAfterOutsideKFilter := 0,
            rawSolutions := [],
            solutions := []
        );
    fi;
    extDimension := S1.extCharacterData.dimension;
    totalRepresentativeCount := 3^extDimension;
    progressStep := Maximum(1, QuoInt(totalRepresentativeCount, 100));
    processed := 0;
    compatibleLiftableCount := 0;
    liftableExtVectors := [];
    compatibleExtVectors := [];
    solutionExtensions := [];
    retainedPerExtensionSolutions := [];
    processedSolutionClassCount := 0;
    dedupGroupCaches := [];
    rawSolutionCountBeforeOutsideKFilter := 0;
    outsideKSymplecticRejectedRawCount := 0;
    retainedRawSolutionCountAfterOutsideKFilter := 0;
    CF_SPrint("Ext dimension = ", extDimension, "\n");
    CF_SPrint(
        "Labelled Ext representatives to construct, including zero = ",
        totalRepresentativeCount,
        "\n"
    );
    CF_SPrint(
        "IdGroup is postponed until Kplus compatibility or a degree-6 ",
        "solution makes it useful.\n"
    );
    processVector := function(vec)
        local extLocal, searchResult, localSolutions,
              localDeduplicated, localDedupCaches, callbackSolutions,
              solLocal, rawLocalCount,
              rejectedLocalCount, retainedLocalCount,
              deduplicatedLocalCount;
        processed := processed + 1;
        if options.retainEnumerationMetadata then
            Add(liftableExtVectors, ShallowCopy(vec));
        fi;
        if processed = 1
           or processed mod progressStep = 0
           or processed = totalRepresentativeCount then
            CF_SPrint(
                "  Ext progress ", processed, "/", totalRepresentativeCount,
                "; Kplus-compatible=", compatibleLiftableCount,
                "; processed per-Ext classes=",
                processedSolutionClassCount,
                "\n"
            );
        fi;
        extLocal := CF_OneLiftableExtensionFromExtVector(S1, vec);
        CF_AttachKPreimages(extLocal, S1);
        if Length(extLocal.preimageData) = 0 then
            extLocal := fail;
            GASMAN("collect");
            return false;
        fi;
        compatibleLiftableCount := compatibleLiftableCount + 1;
        if options.retainEnumerationMetadata then
            Add(compatibleExtVectors, ShallowCopy(vec));
        fi;
        if Length(targetHIds) > 0 then
            if not IdGroupsAvailable(Size(extLocal.H)) then
                Error(
                    "Target-H filtering requires IdGroup at order ",
                    Size(extLocal.H),
                    "."
                );
            fi;
            extLocal.HId := IdGroup(extLocal.H);
            if Position(targetHIds, extLocal.HId) = fail then
                extLocal := fail;
                GASMAN("collect");
                return false;
            fi;
        fi;
        CF_SPrint(
            "    compatible Ext representative ", vec,
            ": computing degree-6 character restrictions...\n"
        );
        searchResult := CF_SolutionsForOneExtension(S1, extLocal);
        localSolutions := searchResult.solutions;
        rawLocalCount := searchResult.totalAlignmentCount;
        rejectedLocalCount :=
            searchResult.determinantRejectedAlignmentCount;
        retainedLocalCount := Length(localSolutions);
        rawSolutionCountBeforeOutsideKFilter :=
            rawSolutionCountBeforeOutsideKFilter + rawLocalCount;
        outsideKSymplecticRejectedRawCount :=
            outsideKSymplecticRejectedRawCount + rejectedLocalCount;
        retainedRawSolutionCountAfterOutsideKFilter :=
            retainedRawSolutionCountAfterOutsideKFilter + retainedLocalCount;
        if retainedLocalCount = 0 then
            if options.retainEnumerationMetadata then
                Add(
                    solutionExtensions,
                    rec(
                        ExtVector := ShallowCopy(vec),
                        HId := extLocal.HId,
                        HOrder := Size(extLocal.H),
                        compatibleKplusPreimages := Length(extLocal.preimageData),
                        rawAlignedSolutions := rawLocalCount,
                        determinantRejectedAlignments := rejectedLocalCount,
                        determinantCompatibleSolutions := 0
                    )
                );
            fi;
            localSolutions := [];
            searchResult := fail;
            extLocal := fail;
            GASMAN("collect");
            return false;
        fi;
        if extLocal.HId = fail and IdGroupsAvailable(Size(extLocal.H)) then
            extLocal.HId := IdGroup(extLocal.H);
        fi;
        for solLocal in localSolutions do
            solLocal.HId := extLocal.HId;
            solLocal.ExtVector := ShallowCopy(vec);
            solLocal.H2Vector := ShallowCopy(vec);
            solLocal.isZeroH2Class := extLocal.isZeroH2Class;
            solLocal.kernelDerivedIntersectionOrder := 1;
            solLocal.isLiftableType := true;
        od;
        if options.retainEnumerationMetadata then
            Add(
                solutionExtensions,
                rec(
                    ExtVector := ShallowCopy(vec),
                    HId := extLocal.HId,
                    HOrder := Size(extLocal.H),
                    compatibleKplusPreimages := Length(extLocal.preimageData),
                    rawAlignedSolutions := rawLocalCount,
                    determinantRejectedAlignments := rejectedLocalCount,
                    determinantCompatibleSolutions := retainedLocalCount
                )
            );
        fi;
        CF_SPrint(
            "    applying per-Ext GL(6)-conjugacy deduplication to ",
            retainedLocalCount,
            " determinant-compatible character images...\n"
        );
        if options.shareCanonicalGroupCacheAcrossExt then
            localDedupCaches := dedupGroupCaches;
        else
            localDedupCaches := [];
        fi;
        localDeduplicated :=
            CF_DeduplicateConjugateMatrixImages(
                localSolutions,
                localDedupCaches,
                options.dedupMode
            );
        if not options.shareCanonicalGroupCacheAcrossExt then
            localDedupCaches := [];
            GASMAN("collect");
        fi;
        deduplicatedLocalCount := Length(localDeduplicated);
        localDeduplicated := List(
            localDeduplicated,
            CF_CompactPerExtensionSolution
        );
        processedSolutionClassCount :=
            processedSolutionClassCount + Length(localDeduplicated);
        if options.retainSolutions then
            Append(retainedPerExtensionSolutions, localDeduplicated);
        fi;
        if options.solutionCallback <> fail then
            callbackSolutions := ShallowCopy(localDeduplicated);
        else
            callbackSolutions := [];
        fi;
        if extLocal.HId = fail then
            CF_SPrint(
                "    surviving extension |H|=", Size(extLocal.H),
                ": retained alignments before determinant=", rawLocalCount,
                ", determinant-rejected alignments=", rejectedLocalCount,
                ", determinant-compatible character images=",
                retainedLocalCount,
                ", per-Ext classes=", deduplicatedLocalCount,
                "\n"
            );
        else
            CF_SPrint(
                "    surviving extension H=SmallGroup(",
                extLocal.HId[1], ",", extLocal.HId[2],
                "): retained alignments before determinant=", rawLocalCount,
                ", determinant-rejected alignments=", rejectedLocalCount,
                ", determinant-compatible character images=",
                retainedLocalCount,
                ", per-Ext classes=", deduplicatedLocalCount,
                "\n"
            );
        fi;
        localSolutions := [];
        localDeduplicated := [];
        searchResult := fail;
        extLocal := fail;
        GASMAN("collect");
        for solLocal in callbackSolutions do
            options.solutionCallback(solLocal);
        od;
        callbackSolutions := [];
        GASMAN("collect");
        return false;
    end;
    CF_ForEachExtVector(extDimension, processVector);
    CF_SPrint("\nExt representatives constructed = ", processed, "\n");
    CF_SPrint(
        "Liftable representatives with a compatible Kplus preimage = ",
        compatibleLiftableCount,
        "\n"
    );
    if processed <> S1.ExpectedLiftableRepresentativeCount then
        Error(
            "Direct Ext enumeration count does not match the theoretical count."
        );
    fi;
    CF_SPrint(
        "Character-compatible Kplus alignments before determinant = ",
        rawSolutionCountBeforeOutsideKFilter,
        "\n"
    );
    CF_SPrint(
        "Early abstract determinant filter: rejected alignments ",
        outsideKSymplecticRejectedRawCount,
        "; determinant-compatible character images ",
        retainedRawSolutionCountAfterOutsideKFilter,
        ".\n"
    );
    CF_SPrint(
        "Per-Ext solution classes processed = ",
        processedSolutionClassCount,
        "\n"
    );
    GASMAN("collect");
    if options.retainSolutions then
        CF_SPrint(
            "Final cross-Ext GL(6)-conjugacy deduplication by stored keys...\n"
        );
        solutionsHeavy := CF_DeduplicateByStoredFastKey(
            retainedPerExtensionSolutions
        );
        solutions := List(solutionsHeavy, CF_CompactFinalSolution);
        solutionsHeavy := [];
        retainedPerExtensionSolutions := [];
    else
        CF_SPrint(
            "Final S_2 matrix solutions were streamed to the callback and ",
            "were not retained.\n"
        );
        solutions := [];
        retainedPerExtensionSolutions := [];
    fi;
    GASMAN("collect");
    if options.retainSolutions then
        CF_SPrint(
            "GL(6)-conjugacy classes satisfying Ker(det|H) = <K0,mu_3> = ",
            Length(solutions),
            "\n"
        );
    else
        CF_SPrint(
            "S_2 streamed ", processedSolutionClassCount,
            " per-Ext classes to the end-to-end classifier.\n"
        );
    fi;
    return rec(
        step1 := S1,
        options := options,
        deduplicationMode := options.dedupMode,
        extensionEnumerationMode :=
            "direct Ext pullbacks from abelianization characters modulo cubes",
        memorySafePerExtensionProcessing := true,
        ExtRepresentativeCount := processed,
        H2RepresentativeCount := processed,
        liftableRepresentativeCount := processed,
        compatibleLiftableRepresentativeCount := compatibleLiftableCount,
        liftableExtVectors := liftableExtVectors,
        liftableH2Vectors := liftableExtVectors,
        compatibleExtVectors := compatibleExtVectors,
        compatibleH2Vectors := compatibleExtVectors,
        solutionExtensions := solutionExtensions,
        rawSolutionsBeforeOutsideKFilter := fail,
        rawSolutionsBeforeOutsideKFilterStored := false,
        rawSolutionCountBeforeOutsideKFilter :=
            rawSolutionCountBeforeOutsideKFilter,
        outsideKSymplecticFilterMode :=
            "require Ker(det|H) = <input K0,mu_3>",
        outsideKSymplecticRejectedRawCount :=
            outsideKSymplecticRejectedRawCount,
        retainedRawSolutionCountAfterOutsideKFilter :=
            retainedRawSolutionCountAfterOutsideKFilter,
        extensionFilterMode :=
            "construct only Ext^1(G_ab,C3) by direct pullback",
        rawSolutionsStorageMode := "not stored; compact final solutions only",
        rawSolutionsStored := false,
        rawSolutions := fail,
        solutionsStreamedToCallback := options.solutionCallback <> fail,
        processedPerExtensionSolutionClassCount :=
            processedSolutionClassCount,
        finalSolutionsRetained := options.retainSolutions,
        solutions := solutions
    );
end;
CF_SPrint("CHUNK 10/17 OK\n");
# ===================== CHUNK 10/17 END =====================

# ==================== CHUNK 11/17 START ====================
CF_DegreeThreeExponentVectors6 := function()
    local answer, a1, a2, a3, a4, a5, a6;
    answer := [];
    for a1 in [0 .. 3] do
        for a2 in [0 .. 3 - a1] do
            for a3 in [0 .. 3 - a1 - a2] do
                for a4 in [0 .. 3 - a1 - a2 - a3] do
                    for a5 in [0 .. 3 - a1 - a2 - a3 - a4] do
                        a6 := 3 - a1 - a2 - a3 - a4 - a5;
                        Add(answer, [a1, a2, a3, a4, a5, a6]);
                    od;
                od;
            od;
        od;
    od;
    return answer;
end;
CF_MultiplyTermsByLinearForm := function(terms, coefficients)
    local newTerms, term, i, newExponent, pos;
    newTerms := [];
    for term in terms do
        for i in [1 .. 6] do
            if coefficients[i] <> 0 then
                newExponent := ShallowCopy(term.exponent);
                newExponent[i] := newExponent[i] + 1;
                pos := Position(
                    List(newTerms, r -> r.exponent),
                    newExponent
                );
                if pos = fail then
                    Add(
                        newTerms,
                        rec(
                            exponent := newExponent,
                            coefficient := term.coefficient * coefficients[i]
                        )
                    );
                else
                    newTerms[pos].coefficient :=
                        newTerms[pos].coefficient
                        + term.coefficient * coefficients[i];
                fi;
            fi;
        od;
    od;
    return Filtered(newTerms, r -> r.coefficient <> 0);
end;
CF_MonomialImageVector := function(exponent, A, exponentBasis)
    local terms, j, powerIndex, coefficients, vector, term, pos;
    terms := [
        rec(
            exponent := [0, 0, 0, 0, 0, 0],
            coefficient := 1
        )
    ];
    for j in [1 .. 6] do
        coefficients := List([1 .. 6], i -> A[i][j]);
        for powerIndex in [1 .. exponent[j]] do
            terms := CF_MultiplyTermsByLinearForm(terms, coefficients);
        od;
    od;
    vector := List([1 .. Length(exponentBasis)], i -> 0);
    for term in terms do
        pos := Position(exponentBasis, term.exponent);
        if pos = fail then
            Error("A transformed cubic term left the degree-3 monomial basis.");
        fi;
        vector[pos] := vector[pos] + term.coefficient;
    od;
    return vector;
end;
CF_MonomialString := function(exponent)
    local factors, i;
    factors := [];
    for i in [1 .. 6] do
        if exponent[i] = 1 then
            Add(factors, Concatenation("x", String(i)));
        elif exponent[i] > 1 then
            Add(
                factors,
                Concatenation(
                    "x", String(i), "^", String(exponent[i])
                )
            );
        fi;
    od;
    if Length(factors) = 0 then
        return "1";
    fi;
    return CF_JoinStrings(factors, "*");
end;
CF_CoefficientVectorToPolynomialString := function(vector, exponentBasis)
    local terms, i, c, monomial;
    terms := [];
    for i in [1 .. Length(vector)] do
        c := vector[i];
        if c <> 0 then
            monomial := CF_MonomialString(exponentBasis[i]);
            if c = 1 then
                Add(terms, monomial);
            elif c = -1 then
                Add(terms, Concatenation("-", monomial));
            else
                Add(
                    terms,
                    Concatenation("(", String(c), ")*", monomial)
                );
            fi;
        fi;
    od;
    if Length(terms) = 0 then
        return "0";
    fi;
    return CF_JoinStrings(terms, " + ");
end;
CF_MonomialFromExponent := function(variables, exponent, ring)
    local monomial, i;
    monomial := One(ring);
    for i in [1 .. Length(exponent)] do
        if exponent[i] > 0 then
            monomial := monomial * variables[i] ^ exponent[i];
        fi;
    od;
    return monomial;
end;
CF_CoefficientVectorToPolynomial := function(vector, monomials, ring)
    local polynomial, i;
    if Length(vector) <> Length(monomials) then
        Error("Coefficient and monomial lists have different lengths.");
    fi;
    polynomial := Zero(ring);
    for i in [1 .. Length(vector)] do
        if vector[i] <> 0 then
            polynomial := polynomial + vector[i] * monomials[i];
        fi;
    od;
    return polynomial;
end;
CF_ScalarMultipleRatio := function(A, B)
    local n, i, j, ratio;
    if DimensionsMat(A) <> DimensionsMat(B) then
        return fail;
    fi;
    n := Length(A);
    ratio := fail;
    for i in [1 .. n] do
        for j in [1 .. n] do
            if B[i][j] <> 0 then
                ratio := A[i][j] / B[i][j];
                break;
            elif A[i][j] <> 0 then
                return fail;
            fi;
        od;
        if ratio <> fail then
            break;
        fi;
    od;
    if ratio = fail then
        return fail;
    fi;
    for i in [1 .. n] do
        for j in [1 .. n] do
            if A[i][j] <> ratio * B[i][j] then
                return fail;
            fi;
        od;
    od;
    return ratio;
end;
CF_ReduceGeneratorsForCubicInvariants := function(matrixGenerators)
    local kept, A, B, ratio, duplicate, scalarValue;
    kept := [];
    for A in matrixGenerators do
        if DimensionsMat(A) <> [6, 6] then
            Error("Step 3 received a matrix that is not 6 by 6.");
        fi;
        if CF_IsScalarMatrix(A) then
            scalarValue := A[1][1];
            if scalarValue^3 <> 1 then
                Error(
                    "A scalar generator outside mu_3 cannot act trivially on cubics."
                );
            fi;
        else
            duplicate := false;
            for B in kept do
                ratio := CF_ScalarMultipleRatio(A, B);
                if ratio <> fail and ratio^3 = 1 then
                    duplicate := true;
                    break;
                fi;
            od;
            if not duplicate then
                Add(kept, A);
            fi;
        fi;
    od;
    return kept;
end;
CF_ReduceGeneratorsForCentralizer := function(matrixGenerators)
    local kept, A, B, duplicate;
    kept := [];
    for A in matrixGenerators do
        if CF_IsScalarMatrix(A) then
        else
            duplicate := ForAny(
                kept,
                B -> CF_ScalarMultipleRatio(A, B) <> fail
            );
            if not duplicate then
                Add(kept, A);
            fi;
        fi;
    od;
    return kept;
end;
CF_RestrictRowBasisByEquationRows := function(basis, equations)
    local reducedEquations, coefficientBasis, newBasis, row, coeff,
          i, j, ambientDimension;
    if Length(basis) = 0 or Length(equations) = 0 then
        return basis;
    fi;
    ambientDimension := Length(basis[1]);
    reducedEquations := List(
        equations,
        row -> List(
            [1 .. Length(basis)],
            i -> Sum(
                [1 .. ambientDimension],
                j -> row[j] * basis[i][j]
            )
        )
    );
    reducedEquations := Filtered(
        reducedEquations,
        row -> ForAny(row, x -> x <> 0)
    );
    if Length(reducedEquations) = 0 then
        return basis;
    fi;
    coefficientBasis := CF_NullspaceOfEquationRows(
        reducedEquations,
        Length(basis)
    );
    newBasis := List(
        coefficientBasis,
        coeff -> List(
            [1 .. ambientDimension],
            j -> Sum(
                [1 .. Length(basis)],
                i -> coeff[i] * basis[i][j]
            )
        )
    );
    return newBasis;
end;
CF_PrepareCubicPolynomialContext := function()
    local exponentBasis, ring, variables, monomials;
    exponentBasis := CF_DegreeThreeExponentVectors6();
    ring := PolynomialRing(
        Cyclotomics,
        ["x1", "x2", "x3", "x4", "x5", "x6"]
    );
    variables := IndeterminatesOfPolynomialRing(ring);
    monomials := List(
        exponentBasis,
        e -> CF_MonomialFromExponent(variables, e, ring)
    );
    return rec(
        exponentBasis := exponentBasis,
        polynomialRing := ring,
        variables := variables,
        monomials := monomials
    );
end;
CF_CubicInvariantBasis := function(arg)
    local matrixGenerators, options, buildPolynomialObjects, buildStrings,
          polynomialContext, exponentBasis, reducedGenerators, basis, A,
          columns, equations, i, j, row, ring, variables, monomials,
          polynomials, strings, initialGeneratorCount;
    if Length(arg) < 1 or Length(arg) > 2 then
        Error(
            "Use CF_CubicInvariantBasis(matrixGenerators) or add an options record."
        );
    fi;
    matrixGenerators := arg[1];
    buildPolynomialObjects := true;
    buildStrings := true;
    polynomialContext := fail;
    if Length(arg) = 2 then
        options := arg[2];
        if not IsRecord(options) then
            Error("The cubic-invariant options must be a record.");
        fi;
        if IsBound(options.buildPolynomialObjects) then
            buildPolynomialObjects := options.buildPolynomialObjects;
        fi;
        if IsBound(options.buildStrings) then
            buildStrings := options.buildStrings;
        fi;
        if IsBound(options.polynomialContext) then
            polynomialContext := options.polynomialContext;
        fi;
    fi;
    exponentBasis := CF_DegreeThreeExponentVectors6();
    if Length(exponentBasis) <> 56 then
        Error("The cubic monomial basis should have dimension 56.");
    fi;
    initialGeneratorCount := Length(matrixGenerators);
    reducedGenerators := CF_ReduceGeneratorsForCubicInvariants(
        matrixGenerators
    );
    basis := IdentityMat(56);
    for A in reducedGenerators do
        columns := List(
            exponentBasis,
            e -> CF_MonomialImageVector(e, A, exponentBasis)
        );
        equations := [];
        for i in [1 .. 56] do
            row := List([1 .. 56], j -> columns[j][i]);
            row[i] := row[i] - 1;
            if ForAny(row, x -> x <> 0) then
                Add(equations, row);
            fi;
        od;
        basis := CF_RestrictRowBasisByEquationRows(basis, equations);
        columns := fail;
        equations := fail;
        if Length(basis) = 0 then
            break;
        fi;
    od;
    ring := fail;
    variables := fail;
    monomials := fail;
    polynomials := fail;
    if buildPolynomialObjects then
        if polynomialContext = fail then
            polynomialContext := CF_PrepareCubicPolynomialContext();
        fi;
        ring := polynomialContext.polynomialRing;
        variables := polynomialContext.variables;
        monomials := polynomialContext.monomials;
        polynomials := List(
            basis,
            v -> CF_CoefficientVectorToPolynomial(v, monomials, ring)
        );
    fi;
    if buildStrings then
        strings := List(
            basis,
            v -> CF_CoefficientVectorToPolynomialString(v, exponentBasis)
        );
    else
        strings := fail;
    fi;
    return rec(
        polynomialRing     := ring,
        variables          := variables,
        monomialExponents  := exponentBasis,
        monomialBasis      := monomials,
        coefficientBasis   := basis,
        polynomialBasis    := polynomials,
        polynomialStrings  := strings,
        invariantDimension := Length(basis),
        inputGeneratorCount := initialGeneratorCount,
        effectiveGeneratorCount := Length(reducedGenerators)
    );
end;
CF_SPrint("CHUNK 11/17 OK\n");
# ===================== CHUNK 11/17 END =====================

# ==================== CHUNK 12/17 START ====================
CF_CentralizerAlgebraBasis := function(arg)
    local matrixGenerators, retainMatrixBasis, reducedGenerators, n,
          equations, A, i, j, k, row, idx, basis, matrixBasis;
    if Length(arg) < 1 or Length(arg) > 2 then
        Error(
            "Use CF_CentralizerAlgebraBasis(matrixGenerators) or add a ",
            "retain-basis boolean."
        );
    fi;
    matrixGenerators := arg[1];
    retainMatrixBasis := true;
    if Length(arg) = 2 then
        retainMatrixBasis := arg[2];
        if retainMatrixBasis <> true and retainMatrixBasis <> false then
            Error("The centralizer retain-basis option must be boolean.");
        fi;
    fi;
    reducedGenerators := CF_ReduceGeneratorsForCentralizer(matrixGenerators);
    if Length(reducedGenerators) = 0 then
        basis := IdentityMat(36);
    else
        n := Length(reducedGenerators[1]);
        equations := [];
        for A in reducedGenerators do
            if DimensionsMat(A) <> [n, n] then
                Error("Centralizer matrices have incompatible dimensions.");
            fi;
            for i in [1 .. n] do
                for j in [1 .. n] do
                    row := List([1 .. n * n], k -> 0);
                    for k in [1 .. n] do
                        idx := (i - 1) * n + k;
                        row[idx] := row[idx] + A[k][j];
                        idx := (k - 1) * n + j;
                        row[idx] := row[idx] - A[i][k];
                    od;
                    if ForAny(row, x -> x <> 0) then
                        Add(equations, row);
                    fi;
                od;
            od;
        od;
        basis := CF_NullspaceOfEquationRows(equations, n * n);
    fi;
    if retainMatrixBasis then
        matrixBasis := List(
            basis,
            v -> CF_VectorToSquareMatrix(v, 6)
        );
    else
        matrixBasis := fail;
    fi;
    return rec(
        basis := basis,
        matrixBasis := matrixBasis,
        dimension := Length(basis),
        effectiveGeneratorCount := Length(reducedGenerators)
    );
end;
CF_DefaultStep3Options := function()
    return rec(
        buildPolynomialObjects := false,
        buildPolynomialStrings := false,
        printPolynomialBasis := false,
        retainCentralizerBasis := false,
        retainStep2 := false,
        garbageCollectEachFamily := true
    );
end;
CF_MergeStep3Options := function(options)
    local merged, name, booleanNames;
    merged := CF_DefaultStep3Options();
    for name in RecNames(options) do
        if not name in RecNames(merged) then
            Error("Unknown S_3 option: ", name, ".");
        fi;
        merged.(name) := options.(name);
    od;
    booleanNames := RecNames(merged);
    for name in booleanNames do
        if merged.(name) <> true and merged.(name) <> false then
            Error("S_3 option ", name, " must be true or false.");
        fi;
    od;
    return merged;
end;
CF_Step3FamilyFromSolution := function(
    sol,
    solutionNumber,
    options,
    polynomialContext
)
    local cubic, centralizer, characterCentralizerDimension,
          familyDimension, includesZeroH2Class;
    cubic := CF_CubicInvariantBasis(
        sol.matrixGenerators,
        rec(
            buildPolynomialObjects := options.buildPolynomialObjects,
            buildStrings := options.buildPolynomialStrings,
            polynomialContext := polynomialContext
        )
    );
    if not IsBound(sol.centralizerDimensionByCharacter) then
        Error(
            "An S_2 solution lacks the character centralizer dimension."
        );
    fi;
    characterCentralizerDimension :=
        sol.centralizerDimensionByCharacter;
    if options.retainCentralizerBasis then
        centralizer := CF_CentralizerAlgebraBasis(
            sol.matrixGenerators,
            true
        );
        if centralizer.dimension <> characterCentralizerDimension then
            Error(
                "Character and matrix centralizer dimensions disagree."
            );
        fi;
    else
        centralizer := rec(
            matrixBasis := fail,
            dimension := characterCentralizerDimension,
            effectiveGeneratorCount := fail
        );
    fi;
    familyDimension :=
        cubic.invariantDimension - characterCentralizerDimension;
    includesZeroH2Class := ForAny(
        sol.mergedExtVectors,
        v -> ForAll(v, a -> a = 0)
    );
    return rec(
        solutionNumber        := solutionNumber,
        HId                   := sol.HId,
        ExtVector             := sol.ExtVector,
        mergedExtVectors      := sol.mergedExtVectors,
        H2Vector              := sol.ExtVector,
        mergedH2Vectors       := sol.mergedExtVectors,
        includesZeroH2Class   := includesZeroH2Class,
        kernelDerivedIntersectionOrder := 1,
        isLiftableType        := true,
        matrixGenerators      := sol.matrixGenerators,
        matrixImageOrder      := sol.matrixImageOrder,
        determinantGeneratorValues :=
            sol.determinantGeneratorValues,
        determinantImageOrder := sol.determinantImageOrder,
        determinantIsTrivial  := sol.determinantIsTrivial,
        symplecticKernelOrder := sol.symplecticKernelOrder,
        symplecticKernelContainedInInputKMu3 :=
            sol.symplecticKernelContainedInInputKMu3,
        symplecticKernelContainedInInputK :=
            sol.symplecticKernelContainedInInputKMu3,
        symplecticKernelEqualsInputKMu3 :=
            sol.symplecticKernelEqualsInputKMu3,
        symplecticKernelEqualsInputK :=
            sol.symplecticKernelEqualsInputKMu3,
        allElementsOutsideInputKMu3AreNonsymplectic :=
            sol.allElementsOutsideInputKMu3AreNonsymplectic,
        allElementsOutsideInputKAreNonsymplectic :=
            sol.allElementsOutsideInputKMu3AreNonsymplectic,
        cubicMonomialExponents := cubic.monomialExponents,
        cubicInvariantBasisVectors := cubic.coefficientBasis,
        polynomialRing        := cubic.polynomialRing,
        variables             := cubic.variables,
        cubicInvariantBasis   := cubic.polynomialBasis,
        cubicInvariantBasisStrings := cubic.polynomialStrings,
        cubicInvariantDimension := cubic.invariantDimension,
        cubicInputGeneratorCount := cubic.inputGeneratorCount,
        cubicEffectiveGeneratorCount :=
            cubic.effectiveGeneratorCount,
        centralizerBasis      := centralizer.matrixBasis,
        centralizerDimension  := characterCentralizerDimension,
        centralizerDimensionSource :=
            "sum of squares of irreducible character multiplicities",
        centralizerEffectiveGeneratorCount :=
            centralizer.effectiveGeneratorCount,
        expectedModuliDimension := familyDimension,
        familyDimension       := familyDimension
    );
end;
S_3 := function(arg)
    local S2, options, final, sol, item, i, polynomialContext, GId,
          retainedStep2, basisString;
    if Length(arg) < 1 or Length(arg) > 2 then
        Error("Use S_3(S2) or S_3(S2, optionsRecord).");
    fi;
    S2 := arg[1];
    if not IsRecord(S2) or not IsBound(S2.solutions) then
        Error("S_3 expects the record returned by S_2.");
    fi;
    if Length(arg) = 2 then
        if not IsRecord(arg[2]) then
            Error("The optional S_3 argument must be an options record.");
        fi;
        options := CF_MergeStep3Options(arg[2]);
    else
        options := CF_DefaultStep3Options();
    fi;
    GId := fail;
    if IsBound(S2.step1) and IsBound(S2.step1.quotientId) then
        GId := ShallowCopy(S2.step1.quotientId);
    fi;
    CF_SPrint("\n============================================================\n");
    CF_SPrint("S_3: OPTIMIZED STRICT CUBIC INVARIANTS AND DIMENSIONS\n");
    CF_SPrint("============================================================\n");
    CF_SPrint(
        "Polynomial objects = ", options.buildPolynomialObjects,
        "; print full bases = ", options.printPolynomialBasis,
        "; retain centralizer bases = ", options.retainCentralizerBasis,
        ".\n"
    );
    CF_SPrint(
        "Centralizer dimensions are computed from character multiplicities.\n"
    );
    polynomialContext := fail;
    if options.buildPolynomialObjects then
        polynomialContext := CF_PrepareCubicPolynomialContext();
    fi;
    final := [];
    for i in [1 .. Length(S2.solutions)] do
        sol := S2.solutions[i];
        item := CF_Step3FamilyFromSolution(
            sol,
            i,
            options,
            polynomialContext
        );
        Add(final, item);
        CF_SPrint("\nSolution ", i, "/", Length(S2.solutions), "\n");
        CF_SPrint("  H ID = ", sol.HId, "\n");
        CF_SPrint("  represented Ext^1 vectors = ", sol.mergedExtVectors, "\n");
        CF_SPrint("  matrix image order = ", sol.matrixImageOrder, "\n");
        CF_SPrint(
            "  cubic generators: stored=", item.cubicInputGeneratorCount,
            ", effective=", item.cubicEffectiveGeneratorCount, "\n"
        );
        CF_SPrint(
            "  dim strict cubic invariants = ",
            item.cubicInvariantDimension,
            "\n"
        );
        CF_SPrint(
            "  dim matrix centralizer = ",
            item.centralizerDimension,
            "\n"
        );
        CF_SPrint(
            "  expected moduli dimension = ",
            item.expectedModuliDimension,
            "\n"
        );
        if options.printPolynomialBasis then
            CF_SPrint("  cubic invariant basis:\n");
            if item.cubicInvariantBasisStrings = fail then
                Error(
                    "printPolynomialBasis=true requires ",
                    "buildPolynomialStrings=true."
                );
            fi;
            for basisString in item.cubicInvariantBasisStrings do
                CF_SPrint("    ", basisString, "\n");
            od;
        fi;
        item := fail;
        if options.garbageCollectEachFamily then
            GASMAN("collect");
        fi;
    od;
    if options.retainStep2 then
        retainedStep2 := S2;
    else
        retainedStep2 := fail;
    fi;
    return rec(
        GId := GId,
        step2 := retainedStep2,
        step2Retained := options.retainStep2,
        options := options,
        families := final
    );
end;
CF_S4_FindSystemProgram := function(names)
    local name, path;
    for name in names do
        path := Filename(DirectoriesSystemPrograms(), name);
        if path <> fail and IsExecutableFile(path) then
            return path;
        fi;
    od;
    return fail;
end;
CF_S4_ExternalTools := function()
    return rec(
        singular := CF_S4_FindSystemProgram(["Singular", "singular"]),
        timeout  := CF_S4_FindSystemProgram(["timeout", "gtimeout"])
    );
end;
CF_S4_FamilyConductor := function(family)
    local conductor, vector, coefficient;
    conductor := 1;
    for vector in family.cubicInvariantBasisVectors do
        for coefficient in vector do
            if coefficient <> 0 then
                conductor := Lcm(conductor, Conductor(coefficient));
            fi;
        od;
    od;
    return conductor;
end;
CF_S4_RationalToPrimeField := function(q, p, field)
    local numerator, denominator;
    numerator := NumeratorRat(q) mod p;
    denominator := DenominatorRat(q) mod p;
    if denominator = 0 then
        return fail;
    fi;
    return (numerator * One(field)) / (denominator * One(field));
end;
CF_S4_CyclotomicToResidue := function(c, conductor, p)
    local field, root, coefficients, value, i, term;
    if c = 0 then
        return 0;
    fi;
    if (p - 1) mod conductor <> 0 then
        return fail;
    fi;
    field := GF(p);
    if conductor = 1 then
        root := One(field);
    else
        root := Z(p) ^ ((p - 1) / conductor);
    fi;
    coefficients := CoeffsCyc(c, conductor);
    value := Zero(field);
    for i in [1 .. Length(coefficients)] do
        term := CF_S4_RationalToPrimeField(
            coefficients[i],
            p,
            field
        );
        if term = fail then
            return fail;
        fi;
        value := value + term * root ^ (i - 1);
    od;
    return IntFFE(value);
end;
CF_S4_FamilyReducesAtPrime := function(family, conductor, p)
    local vector, coefficient;
    for vector in family.cubicInvariantBasisVectors do
        for coefficient in vector do
            if CF_S4_CyclotomicToResidue(
                coefficient,
                conductor,
                p
            ) = fail then
                return false;
            fi;
        od;
    od;
    return true;
end;
CF_SPrint("CHUNK 12/17 OK\n");
# ===================== CHUNK 12/17 END =====================

# ==================== CHUNK 13/17 START ====================
CF_S4_AdmissibleSplitPrimes := function(family, maxPrimes, maxPrime)
    local conductor, answer, p;
    conductor := CF_S4_FamilyConductor(family);
    answer := [];
    p := 3;
    while Length(answer) < maxPrimes do
        p := NextPrimeInt(p);
        if p > maxPrime then
            break;
        fi;
        if (p - 1) mod conductor = 0
           and CF_S4_FamilyReducesAtPrime(
               family,
               conductor,
               p
           ) then
            Add(answer, p);
        fi;
    od;
    return rec(
        conductor := conductor,
        primes := answer
    );
end;
CF_IrregularCoefficientVector := function(dimension, attempt)
    return List(
        [1 .. dimension],
        function(i)
            local value;
            value :=
                ((i * i + (2 * attempt + 3) * i
                  + 5 * attempt * attempt + 7) mod 29) - 14;
            if value = 0 then
                value := i + 2 * attempt + 1;
            fi;
            return value;
        end
    );
end;
CF_S4_AddUniqueCoefficientVector := function(candidates, vector)
    if Length(vector) = 0 or ForAll(vector, x -> x = 0) then
        return;
    fi;
    if Position(candidates, vector) = fail then
        Add(candidates, vector);
    fi;
end;
CF_S4_CandidateCoefficientVectors := function(dimension, maxCandidates)
    local candidates, vector, i, j, attempt, middle, seed, value;
    candidates := [];
    if dimension <= 0 or maxCandidates <= 0 then
        return candidates;
    fi;
    if dimension = 1 then
        return [[1]];
    fi;
    CF_S4_AddUniqueCoefficientVector(
        candidates,
        List([1 .. dimension], i -> 1)
    );
    CF_S4_AddUniqueCoefficientVector(
        candidates,
        List([1 .. dimension], i -> i)
    );
    CF_S4_AddUniqueCoefficientVector(
        candidates,
        List([1 .. dimension], i -> (-1) ^ (i - 1) * i)
    );
    middle := QuoInt(dimension + 1, 2);
    vector := List([1 .. dimension], i -> 0);
    vector[1] := 1;
    vector[middle] := -1;
    vector[dimension] := 3;
    CF_S4_AddUniqueCoefficientVector(candidates, vector);
    seed := 104729 + 97 * dimension;
    attempt := 1;
    while Length(candidates) < maxCandidates
          and attempt <= 20 * maxCandidates + 200 do
        vector := [];
        for i in [1 .. dimension] do
            seed := (1103515245 * seed + 12345) mod 2147483647;
            value := (seed mod 23) - 11;
            if value = 0 then
                value := ((i + attempt) mod 7) + 1;
            fi;
            Add(vector, value);
        od;
        CF_S4_AddUniqueCoefficientVector(candidates, vector);
        attempt := attempt + 1;
    od;
    for i in [1 .. dimension] do
        for j in [i + 1 .. dimension] do
            vector := List([1 .. dimension], k -> 0);
            vector[i] := 1;
            vector[j] := 1;
            CF_S4_AddUniqueCoefficientVector(candidates, vector);
            if Length(candidates) >= maxCandidates then
                return candidates{[1 .. maxCandidates]};
            fi;
            vector[j] := -1;
            CF_S4_AddUniqueCoefficientVector(candidates, vector);
            if Length(candidates) >= maxCandidates then
                return candidates{[1 .. maxCandidates]};
            fi;
        od;
    od;
    for i in [1 .. dimension] do
        vector := List([1 .. dimension], j -> 0);
        vector[i] := 1;
        CF_S4_AddUniqueCoefficientVector(candidates, vector);
        if Length(candidates) >= maxCandidates then
            return candidates{[1 .. maxCandidates]};
        fi;
    od;
    return candidates;
end;
CF_LinearCombinationOfVectors := function(basis, coefficients)
    local answer, i, j;
    if Length(basis) <> Length(coefficients) then
        Error("The basis and coefficient list have different lengths.");
    fi;
    if Length(basis) = 0 then
        return [];
    fi;
    answer := List([1 .. Length(basis[1])], j -> 0);
    for i in [1 .. Length(basis)] do
        for j in [1 .. Length(answer)] do
            answer[j] := answer[j] + coefficients[i] * basis[i][j];
        od;
    od;
    return answer;
end;
CF_S4_ReduceCoefficientVector := function(vector, conductor, p)
    local answer, coefficient, residue;
    answer := [];
    for coefficient in vector do
        residue := CF_S4_CyclotomicToResidue(
            coefficient,
            conductor,
            p
        );
        if residue = fail then
            return fail;
        fi;
        Add(answer, residue);
    od;
    return answer;
end;
CF_S4_PrepareCandidateMembersAtPrime := function(
    family,
    coefficientCandidates,
    conductor,
    p
)
    local records, coefficients, memberVector, reducedVector;
    records := [];
    for coefficients in coefficientCandidates do
        memberVector := CF_LinearCombinationOfVectors(
            family.cubicInvariantBasisVectors,
            coefficients
        );
        reducedVector := CF_S4_ReduceCoefficientVector(
            memberVector,
            conductor,
            p
        );
        if reducedVector <> fail
           and not ForAll(reducedVector, x -> x = 0)
           and PositionProperty(
               records,
               r -> r.reducedVector = reducedVector
           ) = fail then
            Add(
                records,
                rec(
                    coefficients := ShallowCopy(coefficients),
                    memberVector := ShallowCopy(memberVector),
                    reducedVector := reducedVector
                )
            );
        fi;
    od;
    return records;
end;
CF_S4_MonomialString := function(exponent)
    local factors, i;
    factors := [];
    for i in [1 .. 6] do
        if exponent[i] = 1 then
            Add(factors, Concatenation("x", String(i)));
        elif exponent[i] > 1 then
            Add(
                factors,
                Concatenation(
                    "x", String(i), "^", String(exponent[i])
                )
            );
        fi;
    od;
    if Length(factors) = 0 then
        return "1";
    fi;
    return CF_JoinStrings(factors, "*");
end;
CF_S4_DerivativeString := function(
    reducedVector,
    exponentBasis,
    variableIndex,
    p
)
    local terms, j, exponent, derivativeExponent, coefficient,
          monomial;
    terms := [];
    for j in [1 .. Length(reducedVector)] do
        exponent := exponentBasis[j];
        if reducedVector[j] <> 0
           and exponent[variableIndex] > 0 then
            coefficient :=
                (reducedVector[j] * exponent[variableIndex]) mod p;
            if coefficient <> 0 then
                derivativeExponent := ShallowCopy(exponent);
                derivativeExponent[variableIndex] :=
                    derivativeExponent[variableIndex] - 1;
                monomial := CF_S4_MonomialString(
                    derivativeExponent
                );
                Add(
                    terms,
                    Concatenation(
                        String(coefficient),
                        "*",
                        monomial
                    )
                );
            fi;
        fi;
    od;
    if Length(terms) = 0 then
        return "0";
    fi;
    return CF_JoinStrings(terms, "+");
end;
CF_S4_SingularBatchSmoothnessScript := function(
    memberRecords,
    exponentBasis,
    p
)
    local lines, memberIndex, derivatives, variableIndex, prefix;
    lines := [
        Concatenation(
            "ring r=", String(p),
            ",(x1,x2,x3,x4,x5,x6),dp;"
        ),
        "option(redSB);",
        "int cf_found=0;"
    ];
    for memberIndex in [1 .. Length(memberRecords)] do
        derivatives := List(
            [1 .. 6],
            variableIndex -> CF_S4_DerivativeString(
                memberRecords[memberIndex].reducedVector,
                exponentBasis,
                variableIndex,
                p
            )
        );
        prefix := Concatenation("m", String(memberIndex), "_");
        Add(lines, "if (cf_found==0)");
        Add(lines, "{");
        for variableIndex in [1 .. 6] do
            Add(
                lines,
                Concatenation(
                    "poly ", prefix, "d", String(variableIndex),
                    "=", derivatives[variableIndex], ";"
                )
            );
        od;
        Add(
            lines,
            Concatenation(
                "ideal ", prefix, "J=",
                prefix, "d1,", prefix, "d2,", prefix, "d3,",
                prefix, "d4,", prefix, "d5,", prefix, "d6;"
            )
        );
        Add(
            lines,
            Concatenation(
                "ideal ", prefix, "B=std(", prefix, "J);"
            )
        );
        Add(
            lines,
            Concatenation(
                "if (dim(", prefix, "B)==0)"
            )
        );
        Add(lines, "{");
        Add(
            lines,
            Concatenation(
                "print(\"CF_SMOOTH_MEMBER_", String(memberIndex),
                "\");"
            )
        );
        Add(lines, Concatenation("cf_found=", String(memberIndex), ";"));
        Add(lines, "}");
        Add(lines, "else");
        Add(lines, "{");
        Add(
            lines,
            Concatenation(
                "print(\"CF_SINGULAR_MEMBER_", String(memberIndex),
                "\");"
            )
        );
        Add(lines, "}");
        Add(lines, "}");
    od;
    Add(lines, "if (cf_found==0)");
    Add(lines, "{");
    Add(lines, "print(\"CF_NO_SMOOTH_MEMBER\");");
    Add(lines, "}");
    Add(lines, "print(\"CF_SCRIPT_COMPLETED_OK\");");
    Add(lines, "quit;");
    return CF_JoinStrings(lines, "\n");
end;
CF_S4_OutputHasErrorMarker := function(output)
    return PositionSublist(output, "? error occurred") <> fail
        or PositionSublist(output, "syntax error") <> fail
        or PositionSublist(output, "ERROR") <> fail
        or PositionSublist(output, "Error:") <> fail;
end;
CF_S4_RunBoundedSingularScript := function(
    script,
    tools,
    timeoutSeconds
)
    local tempDirectory, inputFile, outputFile, outputStream,
          exitCode, output, outputHasError;
    if tools.singular = fail or tools.timeout = fail then
        return rec(
            status := "unavailable",
            output := "",
            exitCode := fail
        );
    fi;
    tempDirectory := DirectoryTemporary("cf_s4");
    if tempDirectory = fail then
        return rec(
            status := "temporary_directory_error",
            output := "",
            exitCode := fail
        );
    fi;
    inputFile := Filename(tempDirectory, "input.sing");
    outputFile := Filename(tempDirectory, "output.txt");
    PrintTo(inputFile, script);
    outputStream := OutputTextFile(outputFile, false);
    if outputStream = fail then
        return rec(
            status := "output_file_error",
            output := "",
            exitCode := fail
        );
    fi;
    SetPrintFormattingStatus(outputStream, false);
    exitCode := Process(
        tempDirectory,
        tools.timeout,
        InputTextNone(),
        outputStream,
        [
            "-k",
            "1s",
            Concatenation(String(timeoutSeconds), "s"),
            tools.singular,
            "-q",
            inputFile
        ]
    );
    CloseStream(outputStream);
    if IsExistingFile(outputFile) then
        output := StringFile(outputFile);
    else
        output := "";
    fi;
    outputHasError := CF_S4_OutputHasErrorMarker(output);
    if exitCode = 0
       and not outputHasError
       and PositionSublist(output, "CF_SCRIPT_COMPLETED_OK") <> fail
       and PositionSublist(output, "CF_SMOOTH_MEMBER_") <> fail then
        return rec(
            status := "smooth",
            output := output,
            exitCode := exitCode
        );
    fi;
    if exitCode = 0
       and not outputHasError
       and PositionSublist(output, "CF_SCRIPT_COMPLETED_OK") <> fail
       and PositionSublist(output, "CF_NO_SMOOTH_MEMBER") <> fail then
        return rec(
            status := "no_smooth_in_batch",
            output := output,
            exitCode := exitCode
        );
    fi;
    if exitCode = 0
       and not outputHasError
       and PositionSublist(output, "CF_SCRIPT_COMPLETED_OK") <> fail then
        return rec(
            status := "completed",
            output := output,
            exitCode := exitCode
        );
    fi;
    return rec(
        status := "timeout_or_error",
        output := output,
        exitCode := exitCode
    );
end;
CF_S4_FindSmoothMemberIndexInOutput := function(output, count)
    local i, marker;
    for i in [1 .. count] do
        marker := Concatenation("CF_SMOOTH_MEMBER_", String(i));
        if PositionSublist(output, marker) <> fail then
            return i;
        fi;
    od;
    return fail;
end;
CF_SPrint("CHUNK 13/17 OK\n");
# ===================== CHUNK 13/17 END =====================

# ==================== CHUNK 14/17 START ====================
CF_S4_TestCandidateBatchAtPrime := function(
    family,
    coefficientCandidates,
    conductor,
    p,
    tools,
    timeoutSeconds
)
    local memberRecords, script, run, witnessIndex;
    memberRecords := CF_S4_PrepareCandidateMembersAtPrime(
        family,
        coefficientCandidates,
        conductor,
        p
    );
    if Length(memberRecords) = 0 then
        return rec(
            status := "no_nonzero_reductions",
            prime := p,
            memberRecords := [],
            witnessIndex := fail,
            output := "",
            exitCode := fail
        );
    fi;
    script := CF_S4_SingularBatchSmoothnessScript(
        memberRecords,
        family.cubicMonomialExponents,
        p
    );
    run := CF_S4_RunBoundedSingularScript(
        script,
        tools,
        timeoutSeconds
    );
    witnessIndex := CF_S4_FindSmoothMemberIndexInOutput(
        run.output,
        Length(memberRecords)
    );
    run.prime := p;
    run.memberRecords := memberRecords;
    run.witnessIndex := witnessIndex;
    run.inputScript := script;
    return run;
end;
CF_S4_CommonMonomialFactor := function(family)
    local minimumExponents, foundTerm, vector, j, exponent, i,
          factorString;
    minimumExponents := [3, 3, 3, 3, 3, 3];
    foundTerm := false;
    for vector in family.cubicInvariantBasisVectors do
        for j in [1 .. Length(vector)] do
            if vector[j] <> 0 then
                foundTerm := true;
                exponent := family.cubicMonomialExponents[j];
                for i in [1 .. 6] do
                    minimumExponents[i] := Minimum(
                        minimumExponents[i],
                        exponent[i]
                    );
                od;
            fi;
        od;
    od;
    if not foundTerm or Sum(minimumExponents) = 0 then
        return fail;
    fi;
    factorString := CF_S4_MonomialString(minimumExponents);
    return rec(
        exponents := minimumExponents,
        factorString := factorString
    );
end;
CF_VariableLinearInWholeFamily := function(family)
    local i, vector, j, exponent, maximumExponent;
    for i in [1 .. 6] do
        maximumExponent := 0;
        for vector in family.cubicInvariantBasisVectors do
            for j in [1 .. Length(vector)] do
                if vector[j] <> 0 then
                    exponent := family.cubicMonomialExponents[j];
                    maximumExponent := Maximum(
                        maximumExponent,
                        exponent[i]
                    );
                fi;
            od;
        od;
        if maximumExponent <= 1 then
            return i;
        fi;
    od;
    return fail;
end;
CF_EvaluateCubicPartialAtPoint := function(
    coefficientVector,
    exponentBasis,
    variableIndex,
    point
)
    local answer, monomialIndex, exponent, j, term;
    answer := 0;
    for monomialIndex in [1 .. Length(coefficientVector)] do
        if coefficientVector[monomialIndex] <> 0
           and exponentBasis[monomialIndex][variableIndex] > 0 then
            exponent := exponentBasis[monomialIndex];
            term := coefficientVector[monomialIndex]
                * exponent[variableIndex];
            for j in [1 .. 6] do
                if j = variableIndex then
                    if exponent[j] > 1 then
                        term := term
                            * point[j] ^ (exponent[j] - 1);
                    fi;
                elif exponent[j] > 0 then
                    term := term * point[j] ^ exponent[j];
                fi;
            od;
            answer := answer + term;
        fi;
    od;
    return answer;
end;
CF_PointIsCommonSingularPoint := function(family, point)
    local basisVector, variableIndex;
    for basisVector in family.cubicInvariantBasisVectors do
        for variableIndex in [1 .. 6] do
            if CF_EvaluateCubicPartialAtPoint(
                basisVector,
                family.cubicMonomialExponents,
                variableIndex,
                point
            ) <> 0 then
                return false;
            fi;
        od;
    od;
    return true;
end;
CF_S4_FindSmallCommonSingularPointBounded := function(
    family,
    maxSupport,
    maxChecks
)
    local values, checks, found, supportSize, supports, support,
          point, searchTail;
    values := [1, -1, 2, -2, E(3), E(3)^2];
    checks := 0;
    found := fail;
    maxSupport := Minimum(maxSupport, 6);
    for supportSize in [1 .. maxSupport] do
        supports := Combinations([1 .. 6], supportSize);
        for support in supports do
            point := [0, 0, 0, 0, 0, 0];
            point[support[1]] := 1;
            searchTail := function(position)
                local value;
                if found <> fail or checks >= maxChecks then
                    return;
                fi;
                if position > supportSize then
                    checks := checks + 1;
                    if CF_PointIsCommonSingularPoint(
                        family,
                        point
                    ) then
                        found := ShallowCopy(point);
                    fi;
                    return;
                fi;
                for value in values do
                    point[support[position]] := value;
                    searchTail(position + 1);
                    if found <> fail or checks >= maxChecks then
                        return;
                    fi;
                od;
                point[support[position]] := 0;
            end;
            searchTail(2);
            if found <> fail or checks >= maxChecks then
                break;
            fi;
        od;
        if found <> fail or checks >= maxChecks then
            break;
        fi;
    od;
    return rec(
        point := found,
        checks := checks,
        limitReached := checks >= maxChecks and found = fail
    );
end;
CF_S4_TrimPolynomialCoefficients := function(coefficients)
    local answer;
    answer := ShallowCopy(coefficients);
    while Length(answer) > 1
          and answer[Length(answer)] = 0 do
        Remove(answer, Length(answer));
    od;
    return answer;
end;
CF_S4_ExactPolynomialQuotient := function(dividend, divisor)
    local remainder, quotient, shift, factor, i;
    dividend := CF_S4_TrimPolynomialCoefficients(dividend);
    divisor := CF_S4_TrimPolynomialCoefficients(divisor);
    if Length(divisor) = 1 and divisor[1] = 0 then
        Error("Polynomial division by zero.");
    fi;
    remainder := ShallowCopy(dividend);
    quotient := List(
        [1 .. Maximum(1, Length(dividend) - Length(divisor) + 1)],
        i -> 0
    );
    while not (Length(remainder) = 1 and remainder[1] = 0)
          and Length(remainder) >= Length(divisor) do
        shift := Length(remainder) - Length(divisor);
        factor := remainder[Length(remainder)]
            / divisor[Length(divisor)];
        quotient[shift + 1] := quotient[shift + 1] + factor;
        for i in [1 .. Length(divisor)] do
            remainder[shift + i] := remainder[shift + i]
                - factor * divisor[i];
        od;
        remainder := CF_S4_TrimPolynomialCoefficients(remainder);
    od;
    if not (Length(remainder) = 1 and remainder[1] = 0) then
        Error("Expected an exact polynomial quotient.");
    fi;
    return CF_S4_TrimPolynomialCoefficients(quotient);
end;
CF_S4_CyclotomicPolynomialCache := [];
CF_S4_CyclotomicPolynomialCoefficients := function(n)
    local polynomial, properDivisors, d;
    if not IsInt(n) or n < 1 then
        Error("The cyclotomic conductor must be a positive integer.");
    fi;
    if IsBound(CF_S4_CyclotomicPolynomialCache[n]) then
        return ShallowCopy(CF_S4_CyclotomicPolynomialCache[n]);
    fi;
    polynomial := Concatenation(
        [-1],
        List([1 .. n - 1], i -> 0),
        [1]
    );
    properDivisors := Filtered(DivisorsInt(n), d -> d < n);
    for d in properDivisors do
        polynomial := CF_S4_ExactPolynomialQuotient(
            polynomial,
            CF_S4_CyclotomicPolynomialCoefficients(d)
        );
    od;
    CF_S4_CyclotomicPolynomialCache[n] := ShallowCopy(polynomial);
    return polynomial;
end;
CF_S4_PolynomialString := function(coefficients, variableName)
    local terms, i, coefficient, monomial;
    terms := [];
    for i in [1 .. Length(coefficients)] do
        coefficient := coefficients[i];
        if coefficient <> 0 then
            if i = 1 then
                monomial := "1";
            elif i = 2 then
                monomial := variableName;
            else
                monomial := Concatenation(
                    variableName,
                    "^",
                    String(i - 1)
                );
            fi;
            Add(
                terms,
                Concatenation(
                    "(", String(coefficient), ")*", monomial
                )
            );
        fi;
    od;
    if Length(terms) = 0 then
        return "0";
    fi;
    return CF_JoinStrings(terms, "+");
end;
CF_S4_CyclotomicCoefficientString := function(coefficient, conductor)
    local coefficients;
    if coefficient = 0 then
        return "0";
    fi;
    if conductor = 1 then
        return String(coefficient);
    fi;
    coefficients := CoeffsCyc(coefficient, conductor);
    return CF_S4_PolynomialString(coefficients, "a");
end;
CF_S4_ExactDerivativeString := function(
    coefficientVector,
    exponentBasis,
    variableIndex,
    conductor
)
    local terms, j, exponent, derivativeExponent, coefficient,
          coefficientString, monomial;
    terms := [];
    for j in [1 .. Length(coefficientVector)] do
        exponent := exponentBasis[j];
        if coefficientVector[j] <> 0
           and exponent[variableIndex] > 0 then
            coefficient := coefficientVector[j]
                * exponent[variableIndex];
            coefficientString := CF_S4_CyclotomicCoefficientString(
                coefficient,
                conductor
            );
            derivativeExponent := ShallowCopy(exponent);
            derivativeExponent[variableIndex] :=
                derivativeExponent[variableIndex] - 1;
            monomial := CF_S4_MonomialString(derivativeExponent);
            Add(
                terms,
                Concatenation(
                    "(", coefficientString, ")*", monomial
                )
            );
        fi;
    od;
    if Length(terms) = 0 then
        return "0";
    fi;
    return CF_JoinStrings(terms, "+");
end;
CF_S4_ExactRingLines := function(conductor)
    local minpoly;
    if conductor = 1 then
        return [
            "ring r=0,(x1,x2,x3,x4,x5,x6),dp;",
            "option(redSB);"
        ];
    fi;
    minpoly := CF_S4_PolynomialString(
        CF_S4_CyclotomicPolynomialCoefficients(conductor),
        "a"
    );
    return [
        "ring r=(0,a),(x1,x2,x3,x4,x5,x6),dp;",
        Concatenation("minpoly=", minpoly, ";"),
        "option(redSB);"
    ];
end;
CF_SPrint("CHUNK 14/17 OK\n");
# ===================== CHUNK 14/17 END =====================

# ==================== CHUNK 15/17 START ====================
CF_S4_ExactMemberSmoothnessScript := function(
    memberVector,
    exponentBasis,
    conductor
)
    local lines, derivatives, variableIndex, chartIndex, prefix;
    lines := CF_S4_ExactRingLines(conductor);
    derivatives := List(
        [1 .. 6],
        variableIndex -> CF_S4_ExactDerivativeString(
            memberVector,
            exponentBasis,
            variableIndex,
            conductor
        )
    );
    for variableIndex in [1 .. 6] do
        Add(
            lines,
            Concatenation(
                "poly d", String(variableIndex), "=",
                derivatives[variableIndex], ";"
            )
        );
    od;
    Add(lines, "int cf_singular_chart=0;");
    for chartIndex in [1 .. 6] do
        prefix := Concatenation("c", String(chartIndex), "_");
        Add(lines, "if (cf_singular_chart==0)");
        Add(lines, "{");
        Add(
            lines,
            Concatenation(
                "ideal ", prefix, "J=d1,d2,d3,d4,d5,d6,x",
                String(chartIndex), "-1;"
            )
        );
        Add(
            lines,
            Concatenation(
                "ideal ", prefix, "B=std(", prefix, "J);"
            )
        );
        Add(
            lines,
            Concatenation(
                "poly ", prefix, "n=reduce(1,", prefix, "B);"
            )
        );
        Add(lines, Concatenation("if (", prefix, "n!=0)"));
        Add(lines, "{");
        Add(
            lines,
            Concatenation(
                "print(\"CF_EXACT_SINGULAR_CHART_",
                String(chartIndex), "\");"
            )
        );
        Add(
            lines,
            Concatenation(
                "cf_singular_chart=", String(chartIndex), ";"
            )
        );
        Add(lines, "}");
        Add(lines, "}");
    od;
    Add(lines, "if (cf_singular_chart==0)");
    Add(lines, "{");
    Add(lines, "print(\"CF_EXACT_SMOOTH\");");
    Add(lines, "}");
    Add(lines, "else");
    Add(lines, "{");
    Add(lines, "print(\"CF_EXACT_SINGULAR\");");
    Add(lines, "}");
    Add(lines, "print(\"CF_SCRIPT_COMPLETED_OK\");");
    Add(lines, "quit;");
    return CF_JoinStrings(lines, "\n");
end;
CF_S4_FindExactSingularChartInOutput := function(output)
    local i, marker;
    for i in [1 .. 6] do
        marker := Concatenation(
            "CF_EXACT_SINGULAR_CHART_",
            String(i)
        );
        if PositionSublist(output, marker) <> fail then
            return i;
        fi;
    od;
    return fail;
end;
CF_S4_RunExactMemberTest := function(
    family,
    coefficients,
    tools,
    timeoutSeconds
)
    local conductor, memberVector, script, run, chart;
    if Length(coefficients) <> family.cubicInvariantDimension then
        Error(
            "The exact-test coefficient vector has the wrong length."
        );
    fi;
    if ForAll(coefficients, x -> x = 0) then
        Error("The zero cubic cannot be tested for smoothness.");
    fi;
    conductor := CF_S4_FamilyConductor(family);
    memberVector := CF_LinearCombinationOfVectors(
        family.cubicInvariantBasisVectors,
        coefficients
    );
    script := CF_S4_ExactMemberSmoothnessScript(
        memberVector,
        family.cubicMonomialExponents,
        conductor
    );
    run := CF_S4_RunBoundedSingularScript(
        script,
        tools,
        timeoutSeconds
    );
    chart := CF_S4_FindExactSingularChartInOutput(run.output);
    if run.status = "completed"
       and PositionSublist(run.output, "CF_EXACT_SMOOTH") <> fail then
        run.status := "exact_smooth";
    elif run.status = "completed"
         and PositionSublist(run.output, "CF_EXACT_SINGULAR") <> fail then
        run.status := "exact_singular";
    else
        run.status := "timeout_or_error";
    fi;
    run.coefficients := ShallowCopy(coefficients);
    run.memberVector := ShallowCopy(memberVector);
    run.inputScript := script;
    run.conductor := conductor;
    run.singularChart := chart;
    return run;
end;
if not IsBound(CF_DefaultSmoothnessOptions) then
    CF_DefaultSmoothnessOptions := fail;
fi;
if not IsBound(CF_MergeSmoothnessOptions) then
    CF_MergeSmoothnessOptions := fail;
fi;
CF_S4_TestExactMember := function(arg)
    local family, coefficients, options, tools;
    if Length(arg) < 2 or Length(arg) > 3 then
        Error(
            "Use CF_S4_TestExactMember(family, coefficients) or add an options record."
        );
    fi;
    family := arg[1];
    coefficients := arg[2];
    if Length(arg) = 3 then
        options := CF_MergeSmoothnessOptions(arg[3]);
    else
        options := CF_DefaultSmoothnessOptions();
    fi;
    tools := CF_S4_ExternalTools();
    if tools.singular = fail or tools.timeout = fail then
        return rec(
            status := "unavailable",
            coefficients := ShallowCopy(coefficients),
            output := "",
            exitCode := fail
        );
    fi;
    return CF_S4_RunExactMemberTest(
        family,
        coefficients,
        tools,
        options.exactGroebnerTimeoutSeconds
    );
end;
CF_S4_ExactCommonSingularLocusScript := function(family, conductor)
    local lines, derivativeNames, basisIndex, variableIndex,
          derivativeName, derivativeString, chartIndex, prefix;
    lines := CF_S4_ExactRingLines(conductor);
    derivativeNames := [];
    for basisIndex in [1 .. Length(family.cubicInvariantBasisVectors)] do
        for variableIndex in [1 .. 6] do
            derivativeName := Concatenation(
                "b", String(basisIndex), "d", String(variableIndex)
            );
            derivativeString := CF_S4_ExactDerivativeString(
                family.cubicInvariantBasisVectors[basisIndex],
                family.cubicMonomialExponents,
                variableIndex,
                conductor
            );
            Add(
                lines,
                Concatenation(
                    "poly ", derivativeName, "=",
                    derivativeString, ";"
                )
            );
            Add(derivativeNames, derivativeName);
        od;
    od;
    Add(lines, "int cf_common_chart=0;");
    for chartIndex in [1 .. 6] do
        prefix := Concatenation("q", String(chartIndex), "_");
        Add(lines, "if (cf_common_chart==0)");
        Add(lines, "{");
        Add(
            lines,
            Concatenation(
                "ideal ", prefix, "J=",
                CF_JoinStrings(derivativeNames, ","),
                ",x", String(chartIndex), "-1;"
            )
        );
        Add(
            lines,
            Concatenation(
                "ideal ", prefix, "B=std(", prefix, "J);"
            )
        );
        Add(
            lines,
            Concatenation(
                "poly ", prefix, "n=reduce(1,", prefix, "B);"
            )
        );
        Add(lines, Concatenation("if (", prefix, "n!=0)"));
        Add(lines, "{");
        Add(
            lines,
            Concatenation(
                "print(\"CF_EXACT_COMMON_SINGULAR_CHART_",
                String(chartIndex), "\");"
            )
        );
        Add(
            lines,
            Concatenation(
                "cf_common_chart=", String(chartIndex), ";"
            )
        );
        Add(lines, "}");
        Add(lines, "}");
    od;
    Add(lines, "if (cf_common_chart==0)");
    Add(lines, "{");
    Add(lines, "print(\"CF_NO_COMMON_SINGULAR_POINT\");");
    Add(lines, "}");
    Add(lines, "else");
    Add(lines, "{");
    Add(lines, "print(\"CF_EXACT_COMMON_SINGULAR_POINT\");");
    Add(lines, "}");
    Add(lines, "print(\"CF_SCRIPT_COMPLETED_OK\");");
    Add(lines, "quit;");
    return CF_JoinStrings(lines, "\n");
end;
CF_S4_FindExactCommonSingularChartInOutput := function(output)
    local i, marker;
    for i in [1 .. 6] do
        marker := Concatenation(
            "CF_EXACT_COMMON_SINGULAR_CHART_",
            String(i)
        );
        if PositionSublist(output, marker) <> fail then
            return i;
        fi;
    od;
    return fail;
end;
CF_S4_RunExactCommonSingularLocusTest := function(
    family,
    tools,
    timeoutSeconds
)
    local conductor, script, run, chart;
    conductor := CF_S4_FamilyConductor(family);
    script := CF_S4_ExactCommonSingularLocusScript(
        family,
        conductor
    );
    run := CF_S4_RunBoundedSingularScript(
        script,
        tools,
        timeoutSeconds
    );
    chart := fail;
    if run.status = "completed"
       and PositionSublist(
        run.output,
        "CF_EXACT_COMMON_SINGULAR_POINT"
    ) <> fail then
        run.status := "common_singular_point_exists";
        chart := CF_S4_FindExactCommonSingularChartInOutput(
            run.output
        );
    elif run.status = "completed"
         and PositionSublist(
        run.output,
        "CF_NO_COMMON_SINGULAR_POINT"
    ) <> fail then
        run.status := "no_common_singular_point";
    else
        run.status := "timeout_or_error";
    fi;
    run.conductor := conductor;
    run.singularChart := chart;
    return run;
end;
CF_DefaultSmoothnessOptions := function()
    return rec(
        maxSmoothTrials := 4,
        maxMembersPerPrime := 24,
        maxSplitPrimes := 8,
        maxPrime := 10000,
        groebnerTimeoutSeconds := 10,
        useExactCharacteristicZeroTests := true,
        maxExactMembers := 6,
        exactGroebnerTimeoutSeconds := 30,
        useExactCommonSingularLocusTest := true,
        commonLocusTimeoutSeconds := 30,
        maxCommonPointSupport := 4,
        maxCommonPointChecks := 4000,
        retainStep3 := false,
        printFullFamilyData := true,
        releaseInputFamiliesAsProcessed := false,
        printHeader := true,
        printSummary := true
    );
end;
CF_MergeSmoothnessOptions := function(options)
    local merged, name, integerNames, booleanNames;
    merged := CF_DefaultSmoothnessOptions();
    for name in RecNames(options) do
        if not name in RecNames(merged) then
            Error("Unknown S_4 option: ", name, ".");
        fi;
        merged.(name) := options.(name);
    od;
    integerNames := [
        "maxSmoothTrials",
        "maxMembersPerPrime",
        "maxSplitPrimes",
        "maxPrime",
        "groebnerTimeoutSeconds",
        "maxExactMembers",
        "exactGroebnerTimeoutSeconds",
        "commonLocusTimeoutSeconds",
        "maxCommonPointSupport",
        "maxCommonPointChecks"
    ];
    booleanNames := [
        "useExactCharacteristicZeroTests",
        "useExactCommonSingularLocusTest",
        "retainStep3",
        "printFullFamilyData",
        "releaseInputFamiliesAsProcessed",
        "printHeader",
        "printSummary"
    ];
    for name in integerNames do
        if not IsInt(merged.(name)) or merged.(name) < 0 then
            Error("S_4 option ", name, " must be a nonnegative integer.");
        fi;
    od;
    if merged.maxPrime < 5 then
        Error("S_4 option maxPrime must be at least 5.");
    fi;
    for name in booleanNames do
        if merged.(name) <> true and merged.(name) <> false then
            Error("S_4 option ", name, " must be true or false.");
        fi;
    od;
    if merged.retainStep3 and merged.releaseInputFamiliesAsProcessed then
        Error(
            "S_4 cannot retain S_3 while destructively releasing its families."
        );
    fi;
    return merged;
end;
CF_SPrint("CHUNK 15/17 OK\n");
# ===================== CHUNK 15/17 END =====================

# ==================== CHUNK 16/17 START ====================
S_4 := function(arg)
    local S3, options, tools, externalReady, results, family,
          primeData, coefficientCandidates, trials, exactTrials,
          numberOfCalls, attempt, p, smoothTest, witnessRecord,
          exactTest, commonLocusTest, commonFactor, linearVariable,
          commonPointData, commonPoint, result, i, j, GId, familyNumber,
          exactCount, singularCount, inputFamilyCount,
          singularFamilyNumbers, retainedStep3;
    if Length(arg) < 1 or Length(arg) > 2 then
        Error("Use S_4(S3) or S_4(S3, optionsRecord).");
    fi;
    S3 := arg[1];
    if not IsRecord(S3) or not IsBound(S3.families) then
        Error("S_4 expects the record returned by S_3.");
    fi;
    GId := fail;
    if IsBound(S3.GId) and S3.GId <> fail then
        GId := ShallowCopy(S3.GId);
    elif IsBound(S3.step2)
       and S3.step2 <> fail
       and IsBound(S3.step2.step1)
       and IsBound(S3.step2.step1.quotientId) then
        GId := ShallowCopy(S3.step2.step1.quotientId);
    fi;
    if Length(arg) = 2 then
        if not IsRecord(arg[2]) then
            Error("The optional second argument must be an options record.");
        fi;
        options := CF_MergeSmoothnessOptions(arg[2]);
    else
        options := CF_DefaultSmoothnessOptions();
    fi;
    tools := CF_S4_ExternalTools();
    externalReady := tools.singular <> fail and tools.timeout <> fail;
    if options.printHeader then
        CF_SPrint("\n============================================================\n");
        CF_SPrint("S_4: STRICT SMOOTHNESS TESTS, VERSION 26\n");
        CF_SPrint(
            "Only generically smooth and unknown families are printed and returned.\n"
        );
        CF_SPrint("============================================================\n");
    fi;
    if options.printHeader and externalReady then
        CF_SPrint("Singular executable = ", tools.singular, "\n");
        CF_SPrint("timeout executable = ", tools.timeout, "\n");
        CF_SPrint(
            "Finite-field timeout per prime batch = ",
            options.groebnerTimeoutSeconds,
            " seconds.\n"
        );
        CF_SPrint(
            "Exact characteristic-zero timeout per member = ",
            options.exactGroebnerTimeoutSeconds,
            " seconds.\n"
        );
    elif options.printHeader then
        CF_SPrint(
            "Singular or timeout is unavailable. External Groebner tests ",
            "are skipped.\n"
        );
    fi;
    results := [];
    singularCount := 0;
    singularFamilyNumbers := [];
    inputFamilyCount := Length(S3.families);
    for i in [1 .. inputFamilyCount] do
        family := S3.families[i];
        if IsBound(family.solutionNumber) then
            familyNumber := family.solutionNumber;
        else
            familyNumber := i;
        fi;
        trials := [];
        exactTrials := [];
        result := fail;
        commonPointData := rec(
            point := fail,
            checks := 0,
            limitReached := false
        );
        commonLocusTest := fail;
        primeData := rec(
            conductor := CF_S4_FamilyConductor(family),
            primes := []
        );
        coefficientCandidates := CF_S4_CandidateCoefficientVectors(
            family.cubicInvariantDimension,
            options.maxMembersPerPrime
        );
        if family.cubicInvariantDimension
           < family.centralizerDimension then
            result := rec(
                familyNumber := familyNumber,
                HId := family.HId,
                status := "all members singular",
                proofType :=
                    "dimension obstruction: invariant cubic dimension is smaller than matrix centralizer dimension",
                invariantDimension := family.cubicInvariantDimension,
                centralizerDimension := family.centralizerDimension,
                familyDimension := family.familyDimension,
                trials := trials,
                exactTrials := exactTrials,
                externalGroebnerAvailable := externalReady
            );
        fi;
        if result = fail then
            commonFactor := CF_S4_CommonMonomialFactor(family);
            if commonFactor <> fail then
                result := rec(
                    familyNumber := familyNumber,
                    HId := family.HId,
                    status := "all members singular",
                    proofType := "nonconstant common monomial factor",
                    commonFactorExponents := commonFactor.exponents,
                    commonFactor := commonFactor.factorString,
                    trials := trials,
                    exactTrials := exactTrials,
                    externalGroebnerAvailable := externalReady
                );
            fi;
        fi;
        if result = fail then
            linearVariable := CF_VariableLinearInWholeFamily(family);
            if linearVariable <> fail then
                commonPoint := [0, 0, 0, 0, 0, 0];
                commonPoint[linearVariable] := 1;
                result := rec(
                    familyNumber := familyNumber,
                    HId := family.HId,
                    status := "all members singular",
                    proofType :=
                        "one variable has exponent at most one throughout the family",
                    variableIndex := linearVariable,
                    commonSingularPoint := commonPoint,
                    trials := trials,
                    exactTrials := exactTrials,
                    externalGroebnerAvailable := externalReady
                );
            fi;
        fi;
        if result = fail then
            primeData := CF_S4_AdmissibleSplitPrimes(
                family,
                options.maxSplitPrimes,
                options.maxPrime
            );
            if externalReady and Length(primeData.primes) > 0 then
                numberOfCalls := Minimum(
                    options.maxSmoothTrials,
                    Length(primeData.primes)
                );
                for attempt in [1 .. numberOfCalls] do
                    p := primeData.primes[attempt];
                    smoothTest := CF_S4_TestCandidateBatchAtPrime(
                        family,
                        coefficientCandidates,
                        primeData.conductor,
                        p,
                        tools,
                        options.groebnerTimeoutSeconds
                    );
                    Add(
                        trials,
                        rec(
                            prime := p,
                            status := smoothTest.status,
                            numberOfMembersTested :=
                                Length(smoothTest.memberRecords),
                            witnessIndex := smoothTest.witnessIndex
                        )
                    );
                    if smoothTest.status = "smooth"
                       and smoothTest.witnessIndex <> fail then
                        witnessRecord := smoothTest.memberRecords[
                            smoothTest.witnessIndex
                        ];
                        result := rec(
                            familyNumber := familyNumber,
                            HId := family.HId,
                            status := "generically smooth",
                            proofType :=
                                "explicit member has smooth reduction at a good split prime; hence the characteristic-zero member is smooth",
                            witnessCoefficients :=
                                witnessRecord.coefficients,
                            witnessMonomialCoefficients :=
                                witnessRecord.memberVector,
                            witnessReducedMonomialCoefficients :=
                                witnessRecord.reducedVector,
                            witnessPolynomialString :=
                                CF_CoefficientVectorToPolynomialString(
                                    witnessRecord.memberVector,
                                    family.cubicMonomialExponents
                                ),
                            witnessGroebnerExitCode := smoothTest.exitCode,
                            witnessGroebnerOutput := smoothTest.output,
                            singularInputScript := smoothTest.inputScript,
                            witnessPrime := p,
                            coefficientFieldConductor :=
                                primeData.conductor,
                            trials := trials,
                            exactTrials := exactTrials,
                            externalGroebnerAvailable := true
                        );
                        break;
                    fi;
                od;
            fi;
        fi;
        if result = fail
           and externalReady
           and options.useExactCharacteristicZeroTests then
            exactCount := Minimum(
                options.maxExactMembers,
                Length(coefficientCandidates)
            );
            for attempt in [1 .. exactCount] do
                exactTest := CF_S4_RunExactMemberTest(
                    family,
                    coefficientCandidates[attempt],
                    tools,
                    options.exactGroebnerTimeoutSeconds
                );
                Add(
                    exactTrials,
                    rec(
                        coefficients :=
                            ShallowCopy(coefficientCandidates[attempt]),
                        status := exactTest.status,
                        singularChart := exactTest.singularChart
                    )
                );
                if exactTest.status = "exact_smooth" then
                    result := rec(
                        familyNumber := familyNumber,
                        HId := family.HId,
                        status := "generically smooth",
                        proofType :=
                            "exact characteristic-zero six-chart Jacobian Groebner certificate for an explicit member",
                        witnessCoefficients :=
                            ShallowCopy(coefficientCandidates[attempt]),
                        witnessMonomialCoefficients :=
                            ShallowCopy(exactTest.memberVector),
                        witnessPolynomialString :=
                            CF_CoefficientVectorToPolynomialString(
                                exactTest.memberVector,
                                family.cubicMonomialExponents
                            ),
                        witnessGroebnerExitCode := exactTest.exitCode,
                        witnessGroebnerOutput := exactTest.output,
                        singularInputScript := exactTest.inputScript,
                        coefficientFieldConductor := exactTest.conductor,
                        trials := trials,
                        exactTrials := exactTrials,
                        externalGroebnerAvailable := true
                    );
                    break;
                fi;
            od;
        fi;
        if result = fail
           and externalReady
           and options.useExactCommonSingularLocusTest then
            commonLocusTest := CF_S4_RunExactCommonSingularLocusTest(
                family,
                tools,
                options.commonLocusTimeoutSeconds
            );
            if commonLocusTest.status
               = "common_singular_point_exists" then
                result := rec(
                    familyNumber := familyNumber,
                    HId := family.HId,
                    status := "all members singular",
                    proofType :=
                        "exact characteristic-zero Groebner certificate: the basis cubics have a common projective critical point",
                    commonSingularChart :=
                        commonLocusTest.singularChart,
                    coefficientFieldConductor :=
                        commonLocusTest.conductor,
                    trials := trials,
                    exactTrials := exactTrials,
                    externalGroebnerAvailable := true
                );
            fi;
        fi;
        if result = fail then
            commonPointData := CF_S4_FindSmallCommonSingularPointBounded(
                family,
                options.maxCommonPointSupport,
                options.maxCommonPointChecks
            );
            if commonPointData.point <> fail then
                result := rec(
                    familyNumber := familyNumber,
                    HId := family.HId,
                    status := "all members singular",
                    proofType := "fixed common singular point found exactly",
                    commonSingularPoint := commonPointData.point,
                    commonPointChecks := commonPointData.checks,
                    trials := trials,
                    exactTrials := exactTrials,
                    externalGroebnerAvailable := externalReady
                );
            fi;
        fi;
        if result = fail then
            result := rec(
                familyNumber := familyNumber,
                HId := family.HId,
                status := "unknown",
                proofType :=
                    "no smooth witness and no family-wide singularity certificate completed within the configured bounds",
                coefficientFieldConductor := primeData.conductor,
                admissibleSplitPrimes := primeData.primes,
                coefficientCandidates := coefficientCandidates,
                trials := trials,
                exactTrials := exactTrials,
                exactCommonLocusStatus := "see exactCommonLocusTest field",
                exactCommonLocusTest := commonLocusTest,
                externalGroebnerAvailable := externalReady,
                commonPointChecks := commonPointData.checks,
                commonPointLimitReached :=
                    commonPointData.limitReached
            );
        fi;
        if result.status = "all members singular" then
            singularCount := singularCount + 1;
            Add(singularFamilyNumbers, familyNumber);
        else
            result.GId := GId;
            result.HId := family.HId;
            result.ExtVector := family.ExtVector;
            result.mergedExtVectors := family.mergedExtVectors;
            result.H2Vector := family.ExtVector;
            result.mergedH2Vectors := family.mergedExtVectors;
            result.includesZeroH2Class := family.includesZeroH2Class;
            result.kernelDerivedIntersectionOrder :=
                family.kernelDerivedIntersectionOrder;
            result.isLiftableType := family.isLiftableType;
            result.matrixImageOrder := family.matrixImageOrder;
            result.matrixGenerators := family.matrixGenerators;
            result.determinantGeneratorValues :=
                family.determinantGeneratorValues;
            result.determinantImageOrder := family.determinantImageOrder;
            result.symplecticKernelOrder := family.symplecticKernelOrder;
            result.symplecticKernelContainedInInputKMu3 :=
                family.symplecticKernelContainedInInputKMu3;
            result.symplecticKernelContainedInInputK :=
                family.symplecticKernelContainedInInputKMu3;
            result.symplecticKernelEqualsInputKMu3 :=
                family.symplecticKernelEqualsInputKMu3;
            result.symplecticKernelEqualsInputK :=
                family.symplecticKernelEqualsInputKMu3;
            result.allElementsOutsideInputKMu3AreNonsymplectic :=
                family.allElementsOutsideInputKMu3AreNonsymplectic;
            result.allElementsOutsideInputKAreNonsymplectic :=
                family.allElementsOutsideInputKMu3AreNonsymplectic;
            result.cubicInvariantDimension := family.cubicInvariantDimension;
            result.cubicMonomialExponents :=
                family.cubicMonomialExponents;
            result.cubicInvariantBasisVectors :=
                family.cubicInvariantBasisVectors;
            result.cubicInvariantBasis := family.cubicInvariantBasis;
            result.cubicInvariantBasisStrings :=
                family.cubicInvariantBasisStrings;
            result.centralizerDimension := family.centralizerDimension;
            result.expectedModuliDimension :=
                family.expectedModuliDimension;
            result.familyDimension := family.familyDimension;
            Add(results, result);
            CF_SPrint("\nFamily ", familyNumber, " (H ID = ", family.HId, ")\n");
            CF_SPrint("  status = ", result.status, "\n");
            CF_SPrint("  reason = ", result.proofType, "\n");
            if IsBound(result.witnessCoefficients) then
                CF_SPrint(
                    "  smooth witness coefficients = ",
                    result.witnessCoefficients,
                    "\n"
                );
            fi;
            if IsBound(result.witnessPrime) then
                CF_SPrint("  good reduction prime = ", result.witnessPrime, "\n");
            fi;
            if options.printFullFamilyData then
                CF_SPrint(
                    "  ------------------------------------------------------------\n"
                );
                CF_SPrint("  FULL DATA FOR STATUS = ", result.status, "\n");
                CF_SPrint("  G ID = ", GId, "\n");
                CF_SPrint("  H ID = ", family.HId, "\n");
                CF_SPrint(
                    "  represented Ext^1 vectors = ",
                    family.mergedExtVectors,
                    "\n"
                );
                CF_SPrint(
                    "  includes split zero class = ",
                    family.includesZeroH2Class,
                    "\n"
                );
                CF_SPrint("  |Z intersection [H,H]| = 1\n");
                CF_SPrint("  projective action type = liftable\n");
                CF_SPrint(
                    "  H matrix image order = ",
                    family.matrixImageOrder,
                    "\n"
                );
                CF_SPrint(
                    "  determinant values on H generators = ",
                    family.determinantGeneratorValues,
                    "\n"
                );
                CF_SPrint(
                    "  symplectic kernel order = ",
                    family.symplecticKernelOrder,
                    "\n"
                );
                CF_SPrint(
                    "  Ker(det|H) equals <input K0,mu_3> = ",
                    family.symplecticKernelEqualsInputK,
                    "\n"
                );
                CF_SPrint("  H matrix generators:\n");
                for j in [1 .. Length(family.matrixGenerators)] do
                    CF_SPrint(
                        "    generator ", j, " = ",
                        family.matrixGenerators[j],
                        "\n"
                    );
                od;
                CF_SPrint(
                    "  dim strict cubic invariants = ",
                    family.cubicInvariantDimension,
                    "\n"
                );
                CF_SPrint(
                    "  dim matrix centralizer = ",
                    family.centralizerDimension,
                    "\n"
                );
                CF_SPrint(
                    "  expected moduli dimension = ",
                    family.expectedModuliDimension,
                    "\n"
                );
                CF_SPrint("  cubic invariant equation basis:\n");
                if family.cubicInvariantBasisStrings <> fail then
                    for j in [1 .. Length(family.cubicInvariantBasisStrings)] do
                        CF_SPrint(
                            "    basis[", j, "] = ",
                            family.cubicInvariantBasisStrings[j],
                            "\n"
                        );
                    od;
                else
                    CF_SPrint("    [polynomial strings were not retained in S_3]\n");
                fi;
                CF_SPrint(
                    "  ------------------------------------------------------------\n"
                );
            fi;
        fi;
        family := fail;
        coefficientCandidates := fail;
        trials := fail;
        exactTrials := fail;
        commonLocusTest := fail;
        commonPointData := fail;
        if options.releaseInputFamiliesAsProcessed then
            S3.families[i] := fail;
            GASMAN("collect");
        fi;
    od;
    if options.printSummary then
        CF_SPrint("\nS_4 classification summary\n");
        CF_SPrint("  input families = ", inputFamilyCount, "\n");
        CF_SPrint(
            "  retained generically smooth or unknown families = ",
            Length(results),
            "\n"
        );
        CF_SPrint(
            "  singular families suppressed = ",
            singularCount,
            "\n"
        );
    fi;
    if options.retainStep3 then
        retainedStep3 := S3;
    else
        retainedStep3 := fail;
    fi;
    return rec(
        GId := GId,
        step3 := retainedStep3,
        step3Retained := options.retainStep3,
        options := options,
        externalTools := tools,
        externalGroebnerAvailable := externalReady,
        outputFilter :=
            "only generically smooth and unknown families are returned",
        inputFamilyCount := inputFamilyCount,
        singularFamilyCount := singularCount,
        suppressedSingularFamilyNumbers := singularFamilyNumbers,
        families := results
    );
end;
CF_SPrint("CHUNK 16/17 OK\n");
# ===================== CHUNK 16/17 END =====================

# ==================== CHUNK 17/17 START ====================
CF_S4_PrintSmoothAndUnknownFamilyData := function(S4)
    local result, j;
    if not IsRecord(S4) or not IsBound(S4.families) then
        Error("Expected the record returned by S_4.");
    fi;
    for result in S4.families do
        if result.status = "generically smooth"
           or result.status = "unknown" then
            CF_SPrint("\n============================================================\n");
            CF_SPrint("Family ", result.familyNumber,
                  ": ", result.status, "\n");
            CF_SPrint("G ID = ", result.GId, "\n");
            CF_SPrint("H ID = ", result.HId, "\n");
            CF_SPrint("represented Ext^1 vectors = ",
                  result.mergedExtVectors, "\n");
            CF_SPrint("includes split zero class = ",
                  result.includesZeroH2Class, "\n");
            CF_SPrint("|Z intersection [H,H]| = 1\n");
            CF_SPrint("projective action type = liftable\n");
            CF_SPrint("H matrix image order = ",
                  result.matrixImageOrder, "\n");
            CF_SPrint("determinant values on H generators = ",
                  result.determinantGeneratorValues, "\n");
            CF_SPrint("H matrix generators:\n");
            for j in [1 .. Length(result.matrixGenerators)] do
                CF_SPrint("  generator ", j, " = ",
                      result.matrixGenerators[j], "\n");
            od;
            CF_SPrint("cubic invariant equation basis:\n");
            if result.cubicInvariantBasisStrings <> fail then
                for j in [1 .. Length(result.cubicInvariantBasisStrings)] do
                    CF_SPrint("  basis[", j, "] = ",
                          result.cubicInvariantBasisStrings[j], "\n");
                od;
            elif IsBound(result.cubicInvariantBasisVectors)
                 and IsBound(result.cubicMonomialExponents) then
                for j in [1 .. Length(result.cubicInvariantBasisVectors)] do
                    CF_SPrint(
                        "  basis[", j, "] = ",
                        CF_CoefficientVectorToPolynomialString(
                            result.cubicInvariantBasisVectors[j],
                            result.cubicMonomialExponents
                        ),
                        "\n"
                    );
                od;
            else
                CF_SPrint("  [coefficient basis was not retained]\n");
            fi;
        fi;
    od;
end;
CF_ExtremeResourceProfile := function()
    return rec(
        step2Options := rec(
            dedupMode := "exact-character",
            shareCanonicalGroupCacheAcrossExt := false,
            retainEnumerationMetadata := false
        ),
        step3Options := rec(
            buildPolynomialObjects := false,
            buildPolynomialStrings := false,
            printPolynomialBasis := false,
            retainCentralizerBasis := false,
            retainStep2 := false,
            garbageCollectEachFamily := true
        ),
        step4Options := rec(
            maxSmoothTrials := 2,
            maxMembersPerPrime := 12,
            maxSplitPrimes := 4,
            maxPrime := 10000,
            groebnerTimeoutSeconds := 6,
            useExactCharacteristicZeroTests := true,
            maxExactMembers := 2,
            exactGroebnerTimeoutSeconds := 15,
            useExactCommonSingularLocusTest := false,
            commonLocusTimeoutSeconds := 10,
            maxCommonPointSupport := 3,
            maxCommonPointChecks := 1000,
            retainStep3 := false,
            printFullFamilyData := false,
            releaseInputFamiliesAsProcessed := true,
            printHeader := false,
            printSummary := false
        )
    );
end;
CF_RunMemorySafe := function(arg)
    local gid, Kgens, runOptions, targetHIds, step2Options, step3Options,
          step4Options, S1local, S2local, streamCallback, finalResults,
          singularFamilyNumbers, singularCount, familyCounter,
          seenKeys, seenResultPositions, polynomialContext, GId,
          tools, externalReady, S4local;
    if Length(arg) < 2 or Length(arg) > 3 then
        Error(
            "Use CF_RunMemorySafe(gid, Kgens) or add an options record."
        );
    fi;
    gid := arg[1];
    Kgens := arg[2];
    targetHIds := [];
    step2Options := rec();
    step3Options := rec();
    step4Options := rec();
    if Length(arg) = 3 then
        runOptions := arg[3];
        if not IsRecord(runOptions) then
            Error("The runner options must be a record.");
        fi;
        if IsBound(runOptions.targetHIds) then
            targetHIds := runOptions.targetHIds;
        fi;
        if IsBound(runOptions.step2Options) then
            step2Options := ShallowCopy(runOptions.step2Options);
        fi;
        if IsBound(runOptions.step3Options) then
            step3Options := ShallowCopy(runOptions.step3Options);
        fi;
        if IsBound(runOptions.step4Options) then
            step4Options := ShallowCopy(runOptions.step4Options);
        fi;
        if ForAny(
            RecNames(runOptions),
            n -> not n in [
                "targetHIds",
                "step2Options",
                "step3Options",
                "step4Options"
            ]
        ) then
            Error("Unknown CF_RunMemorySafe option.");
        fi;
    fi;
    step2Options := CF_MergeStep2Options(step2Options);
    step3Options := CF_MergeStep3Options(step3Options);
    step4Options := CF_MergeSmoothnessOptions(step4Options);
    step3Options.retainStep2 := false;
    step4Options.retainStep3 := false;
    step4Options.releaseInputFamiliesAsProcessed := true;
    step4Options.printHeader := false;
    step4Options.printSummary := false;
    GId := ShallowCopy(gid);
    tools := CF_S4_ExternalTools();
    externalReady := tools.singular <> fail and tools.timeout <> fail;
    CF_SPrint("\n============================================================\n");
    CF_SPrint("END-TO-END STREAMING S_2 -> S_3 -> S_4 CLASSIFICATION\n");
    CF_SPrint("============================================================\n");
    CF_SPrint(
        "Each new canonical S_2 character key is classified immediately; ",
        "suppressed singular families are released before the next key.\n"
    );
    CF_SPrint(
        "S_2 deduplication mode = ", step2Options.dedupMode, ".\n"
    );
    if externalReady then
        CF_SPrint("Singular executable = ", tools.singular, "\n");
        CF_SPrint("timeout executable = ", tools.timeout, "\n");
    else
        CF_SPrint(
            "Singular or timeout is unavailable. External Groebner tests ",
            "are skipped.\n"
        );
    fi;
    polynomialContext := fail;
    if step3Options.buildPolynomialObjects then
        polynomialContext := CF_PrepareCubicPolynomialContext();
    fi;
    finalResults := [];
    singularFamilyNumbers := [];
    singularCount := 0;
    familyCounter := 0;
    seenKeys := [];
    seenResultPositions := [];
    streamCallback := function(sol)
        local key, seenPosition, resultPosition, family, oneS3, oneS4,
              vector;
        key := sol.matrixImageData.fastCharacterOrbitKey;
        seenPosition := Position(seenKeys, key);
        if seenPosition <> fail then
            resultPosition := seenResultPositions[seenPosition];
            if resultPosition > 0 then
                for vector in sol.mergedExtVectors do
                    if Position(
                        finalResults[resultPosition].mergedExtVectors,
                        vector
                    ) = fail then
                        Add(
                            finalResults[resultPosition].mergedExtVectors,
                            ShallowCopy(vector)
                        );
                    fi;
                od;
                finalResults[resultPosition].mergedH2Vectors :=
                    finalResults[resultPosition].mergedExtVectors;
            fi;
            return;
        fi;
        familyCounter := familyCounter + 1;
        Add(seenKeys, key);
        CF_SPrint(
            "\nStreaming new matrix-image key ", familyCounter,
            " through S_3 and S_4...\n"
        );
        family := CF_Step3FamilyFromSolution(
            sol,
            familyCounter,
            step3Options,
            polynomialContext
        );
        CF_SPrint(
            "  dim invariants=", family.cubicInvariantDimension,
            ", dim centralizer=", family.centralizerDimension,
            ", expected moduli dimension=", family.expectedModuliDimension,
            "\n"
        );
        oneS3 := rec(
            GId := GId,
            step2 := fail,
            step2Retained := false,
            options := step3Options,
            families := [family]
        );
        oneS4 := S_4(oneS3, step4Options);
        if oneS4.singularFamilyCount = 1 then
            singularCount := singularCount + 1;
            Add(singularFamilyNumbers, familyCounter);
            Add(seenResultPositions, 0);
        else
            Append(finalResults, oneS4.families);
            Add(seenResultPositions, Length(finalResults));
        fi;
        family := fail;
        oneS3 := fail;
        oneS4 := fail;
        GASMAN("collect");
    end;
    step2Options.solutionCallback := streamCallback;
    step2Options.retainSolutions := false;
    step2Options.retainEnumerationMetadata := false;
    S1local := S_1(gid, Kgens);
    S2local := S_2(S1local, targetHIds, step2Options);
    S1local := fail;
    S2local := fail;
    step2Options.solutionCallback := fail;
    streamCallback := fail;
    polynomialContext := fail;
    seenKeys := [];
    seenResultPositions := [];
    GASMAN("collect");
    CF_SPrint("\nEnd-to-end streaming classification summary\n");
    CF_SPrint("  distinct matrix-image keys classified = ", familyCounter, "\n");
    CF_SPrint(
        "  retained generically smooth or unknown families = ",
        Length(finalResults),
        "\n"
    );
    CF_SPrint("  singular families suppressed = ", singularCount, "\n");
    S4local := rec(
        GId := GId,
        step3 := fail,
        step3Retained := false,
        options := step4Options,
        step2Options := step2Options,
        step3Options := step3Options,
        externalTools := tools,
        externalGroebnerAvailable := externalReady,
        outputFilter :=
            "only generically smooth and unknown families are returned",
        processingMode :=
            "stream each new S_2 character key immediately through S_3 and S_4",
        inputFamilyCount := familyCounter,
        singularFamilyCount := singularCount,
        suppressedSingularFamilyNumbers := singularFamilyNumbers,
        families := finalResults
    );
    return S4local;
end;
Step1_Schur3Part := S_1;
Step2_FindLinearLifts := function(gid, Kgens)
    local S1;
    S1 := S_1(gid, Kgens);
    return S_2(S1);
end;
Step3_CubicInvariantBasis := CF_CubicInvariantBasis;
Step3_AddCubicsToAllSolutions := S_3;
Step4_TestGenericSmoothness := S_4;
CF_SPrint("Loaded CubicFourfold universal VERSION 26 optimized: ",
      "early determinant filtering, optional conservative S_2 deduplication, ",
      "character centralizer dimensions, true streaming S_3-to-S_4, ",
      "and strict Singular validation.\n");
CF_SPrint("Loaded cubic-fourfold search code, optimized version 26.\n");
CF_SPrint("CHUNK 17/17 OK\n");
# ===================== CHUNK 17/17 END =====================

CF_SPrint("V26 STREAMING CONSOLE-PASTE CODE LOADED OK\n");


#############################################################################
# 1. ALWAYS RETAIN POLYNOMIAL OBJECTS AND STRINGS IN S_3
#############################################################################

CF_DefaultStep3Options := function()
    return rec(
        buildPolynomialObjects := true,
        buildPolynomialStrings := true,
        printPolynomialBasis := false,
        retainCentralizerBasis := false,
        retainStep2 := false,
        garbageCollectEachFamily := true
    );
end;

CF_MergeStep3Options := function(options)
    local merged, name, booleanNames;

    if not IsRecord(options) then
        Error("The S_3 options argument must be a record.");
    fi;

    merged := CF_DefaultStep3Options();

    for name in RecNames(options) do
        if not name in RecNames(merged) then
            Error("Unknown S_3 option: ", name, ".");
        fi;
        merged.(name) := options.(name);
    od;

    booleanNames := RecNames(merged);
    for name in booleanNames do
        if merged.(name) <> true and merged.(name) <> false then
            Error("S_3 option ", name, " must be true or false.");
        fi;
    od;

    # This audited V26 deliberately overrides false values.  S_4 must always
    # receive actual polynomial objects and readable polynomial strings.
    merged.buildPolynomialObjects := true;
    merged.buildPolynomialStrings := true;

    return merged;
end;

# The extreme streaming profile used to switch polynomial construction off.
# Preserve every other resource setting, but force the two S_3 fields on.
if IsBound(CF_ExtremeResourceProfile) then
    CF_V26_ExtremeResourceProfileBeforeS4Audit :=
        CF_ExtremeResourceProfile;

    CF_ExtremeResourceProfile := function()
        local profile;

        profile := CF_V26_ExtremeResourceProfileBeforeS4Audit();

        if not IsBound(profile.step3Options) then
            profile.step3Options := rec();
        fi;

        profile.step3Options.buildPolynomialObjects := true;
        profile.step3Options.buildPolynomialStrings := true;

        return profile;
    end;
fi;

#############################################################################
# 2. STORE THE EXACT CHARACTERISTIC-ZERO MEMBER VECTOR FOR EVERY CANDIDATE
#############################################################################

CF_S4_PrepareCandidateMembersAtPrime := function(
    family,
    coefficientCandidates,
    conductor,
    p
)
    local records, coefficients, memberVector, reducedVector;

    records := [];

    for coefficients in coefficientCandidates do
        memberVector := CF_LinearCombinationOfVectors(
            family.cubicInvariantBasisVectors,
            coefficients
        );

        reducedVector := CF_S4_ReduceCoefficientVector(
            memberVector,
            conductor,
            p
        );

        if reducedVector <> fail
           and not ForAll(reducedVector, x -> x = 0)
           and PositionProperty(
               records,
               r -> r.reducedVector = reducedVector
           ) = fail then
            Add(
                records,
                rec(
                    coefficients := ShallowCopy(coefficients),
                    memberVector := ShallowCopy(memberVector),
                    reducedVector := ShallowCopy(reducedVector)
                )
            );
        fi;
    od;

    return records;
end;

#############################################################################
# 3. EXACT, NON-PREFIX SMOOTH-MEMBER MARKERS
#############################################################################

CF_S4_SingularBatchSmoothnessScript := function(
    memberRecords,
    exponentBasis,
    p
)
    local lines, memberIndex, derivatives, variableIndex, prefix;

    lines := [
        Concatenation(
            "ring r=", String(p),
            ",(x1,x2,x3,x4,x5,x6),dp;"
        ),
        "option(redSB);",
        "int cf_found=0;"
    ];

    for memberIndex in [1 .. Length(memberRecords)] do
        derivatives := List(
            [1 .. 6],
            variableIndex -> CF_S4_DerivativeString(
                memberRecords[memberIndex].reducedVector,
                exponentBasis,
                variableIndex,
                p
            )
        );

        prefix := Concatenation("m", String(memberIndex), "_");

        Add(lines, "if (cf_found==0)");
        Add(lines, "{");

        for variableIndex in [1 .. 6] do
            Add(
                lines,
                Concatenation(
                    "poly ", prefix, "d", String(variableIndex),
                    "=", derivatives[variableIndex], ";"
                )
            );
        od;

        Add(
            lines,
            Concatenation(
                "ideal ", prefix, "J=",
                prefix, "d1,", prefix, "d2,", prefix, "d3,",
                prefix, "d4,", prefix, "d5,", prefix, "d6;"
            )
        );
        Add(
            lines,
            Concatenation(
                "ideal ", prefix, "B=std(", prefix, "J);"
            )
        );
        Add(
            lines,
            Concatenation(
                "if (dim(", prefix, "B)==0)"
            )
        );
        Add(lines, "{");
        Add(
            lines,
            Concatenation(
                "print(\"CF_SMOOTH_MEMBER_",
                String(memberIndex),
                "_END\");"
            )
        );
        Add(lines, Concatenation("cf_found=", String(memberIndex), ";"));
        Add(lines, "}");
        Add(lines, "else");
        Add(lines, "{");
        Add(
            lines,
            Concatenation(
                "print(\"CF_SINGULAR_MEMBER_",
                String(memberIndex),
                "_END\");"
            )
        );
        Add(lines, "}");
        Add(lines, "}");
    od;

    Add(lines, "if (cf_found==0)");
    Add(lines, "{");
    Add(lines, "print(\"CF_NO_SMOOTH_MEMBER_END\");");
    Add(lines, "}");
    Add(lines, "print(\"CF_SCRIPT_COMPLETED_OK\");");
    Add(lines, "quit;");

    return CF_JoinStrings(lines, "\n");
end;

CF_S4_FindSmoothMemberIndexInOutput := function(output, count)
    local i, marker;

    for i in [1 .. count] do
        marker := Concatenation(
            "CF_SMOOTH_MEMBER_",
            String(i),
            "_END"
        );

        if PositionSublist(output, marker) <> fail then
            return i;
        fi;
    od;

    return fail;
end;

#############################################################################
# 4. INDEPENDENT SINGLE-MEMBER RECHECK OF EVERY FINITE-FIELD WITNESS
#############################################################################

CF_S4_TestCandidateBatchAtPrime := function(
    family,
    coefficientCandidates,
    conductor,
    p,
    tools,
    timeoutSeconds
)
    local memberRecords, script, run, witnessIndex, witnessRecord,
          verificationScript, verificationRun, verificationIndex,
          witnessPolynomialString;

    memberRecords := CF_S4_PrepareCandidateMembersAtPrime(
        family,
        coefficientCandidates,
        conductor,
        p
    );

    if Length(memberRecords) = 0 then
        return rec(
            status := "no_nonzero_reductions",
            prime := p,
            memberRecords := [],
            witnessIndex := fail,
            witnessVerificationPassed := false,
            output := "",
            exitCode := fail,
            inputScript := ""
        );
    fi;

    script := CF_S4_SingularBatchSmoothnessScript(
        memberRecords,
        family.cubicMonomialExponents,
        p
    );

    run := CF_S4_RunBoundedSingularScript(
        script,
        tools,
        timeoutSeconds
    );

    witnessIndex := CF_S4_FindSmoothMemberIndexInOutput(
        run.output,
        Length(memberRecords)
    );

    run.prime := p;
    run.memberRecords := memberRecords;
    run.witnessIndex := witnessIndex;
    run.inputScript := script;
    run.witnessVerificationPassed := false;

    if run.status = "smooth" then
        if witnessIndex = fail then
            Error(
                "Singular reported a smooth batch member, but no exact ",
                "CF_SMOOTH_MEMBER_i_END marker could be parsed."
            );
        fi;

        witnessRecord := memberRecords[witnessIndex];

        verificationScript := CF_S4_SingularBatchSmoothnessScript(
            [witnessRecord],
            family.cubicMonomialExponents,
            p
        );

        verificationRun := CF_S4_RunBoundedSingularScript(
            verificationScript,
            tools,
            timeoutSeconds
        );

        verificationIndex := CF_S4_FindSmoothMemberIndexInOutput(
            verificationRun.output,
            1
        );

        if verificationRun.status <> "smooth"
           or verificationIndex <> 1 then
            Error(
                "The batch smooth witness failed its independent single-",
                "member verification at prime ", p, "."
            );
        fi;

        witnessPolynomialString :=
            CF_CoefficientVectorToPolynomialString(
                witnessRecord.memberVector,
                family.cubicMonomialExponents
            );

        run.witnessVerificationPassed := true;
        run.witnessRecord := witnessRecord;
        run.witnessCoefficients :=
            ShallowCopy(witnessRecord.coefficients);
        run.witnessMonomialCoefficients :=
            ShallowCopy(witnessRecord.memberVector);
        run.witnessReducedMonomialCoefficients :=
            ShallowCopy(witnessRecord.reducedVector);
        run.witnessPolynomialString := witnessPolynomialString;
        run.verificationOutput := verificationRun.output;
        run.verificationExitCode := verificationRun.exitCode;
        run.verificationInputScript := verificationScript;

        CF_SPrint("    audited smooth witness batch index = ", witnessIndex, "\n");
        CF_SPrint(
            "    audited smooth witness basis coefficients = ",
            witnessRecord.coefficients,
            "\n"
        );
        CF_SPrint(
            "    audited smooth witness polynomial = ",
            witnessPolynomialString,
            "\n"
        );
        CF_SPrint(
            "    independent one-member verification at prime ",
            p,
            " = passed\n"
        );
    elif witnessIndex <> fail then
        Error(
            "An exact smooth-member marker was present, but the bounded ",
            "Singular run did not have status smooth."
        );
    fi;

    return run;
end;

#############################################################################
# 5. ENRICH THE FINAL S_4 RECORDS AND PRINT A COMPACT AUDIT SUMMARY
#############################################################################

CF_V26_S4_BeforeWitnessAudit := S_4;

S_4 := function(arg)
    local answer, result, memberVector, polynomialString, auditMode;

    # Avoid CallFuncList here as well.  The audited wrapper has only the two
    # supported S_4 arities, so dispatch them explicitly.  This is safe across
    # repeated S(gid,Kgens) calls in one GAP session.
    if Length(arg) = 1 then
        answer := CF_V26_S4_BeforeWitnessAudit(arg[1]);
    elif Length(arg) = 2 then
        answer := CF_V26_S4_BeforeWitnessAudit(arg[1], arg[2]);
    else
        Error("Use S_4(S3) or S_4(S3,options).");
    fi;

    if not IsRecord(answer) or not IsBound(answer.families) then
        return answer;
    fi;

    CF_SPrint("\n============================================================\n");
    CF_SPrint("S_4 AUDITED SMOOTH-WITNESS SUMMARY\n");
    CF_SPrint("============================================================\n");

    for result in answer.families do
        if IsBound(result.status)
           and result.status = "generically smooth"
           and IsBound(result.witnessCoefficients) then

            if IsBound(result.witnessMonomialCoefficients) then
                memberVector :=
                    ShallowCopy(result.witnessMonomialCoefficients);
            elif IsBound(result.cubicInvariantBasisVectors) then
                memberVector := CF_LinearCombinationOfVectors(
                    result.cubicInvariantBasisVectors,
                    result.witnessCoefficients
                );
                result.witnessMonomialCoefficients :=
                    ShallowCopy(memberVector);
            else
                memberVector := fail;
            fi;

            if memberVector <> fail
               and IsBound(result.cubicMonomialExponents) then
                polynomialString :=
                    CF_CoefficientVectorToPolynomialString(
                        memberVector,
                        result.cubicMonomialExponents
                    );
                result.witnessPolynomialString := polynomialString;
            elif IsBound(result.witnessPolynomialString) then
                polynomialString := result.witnessPolynomialString;
            else
                polynomialString := fail;
            fi;

            if IsBound(result.witnessPrime) then
                auditMode :=
                    "exact marker plus independent one-member finite-field rerun";
            else
                auditMode :=
                    "exact characteristic-zero member test";
            fi;

            result.witnessAuditMode := auditMode;
            result.witnessAuditVerified := true;

            CF_SPrint("Family ", result.familyNumber, ":\n");
            CF_SPrint(
                "  verified basis coefficients = ",
                result.witnessCoefficients,
                "\n"
            );
            if IsBound(result.witnessPrime) then
                CF_SPrint("  verified good prime = ", result.witnessPrime, "\n");
            fi;
            CF_SPrint("  audit mode = ", auditMode, "\n");
            if polynomialString <> fail then
                CF_SPrint("  verified witness polynomial = ", polynomialString, "\n");
            fi;
        fi;
    od;

    return answer;
end;

# Compatibility alias used by some older driver scripts.
Step4_TestGenericSmoothness := S_4;

CF_SPrint(
    "Loaded V26 with audited S4 witness binding and always-on cubic ",
    "polynomial bases.\n"
);
CF_SPrint(
    "Use this file instead of reading the original V26 directly.\n"
);


#############################################################################
# ONE-STEP PUBLIC ENTRY POINT -- ASSIGNMENT-SAFE
#
# Safe forms:
#     S(gid, Kgens);;
#     S := S(gid, Kgens);;
#
# The second form is supported deliberately.  S returns the public driver
# function itself, so assigning the return value back to S does NOT overwrite
# S by the result record.  The actual S_4 result is always stored in
# CF_LAST_S_RESULT.
#############################################################################
CF_S_PRINT_ENABLED := true;;
CF_LAST_S_RESULT := fail;;

CF_OneStepS := function(arg)
    local gid, Kgens, s4Options, S1local, S2local, S3local, S4local;

    if Length(arg) < 2 or Length(arg) > 3 then
        Error("Use S(gid,Kgens) or S(gid,Kgens,S4options).");
    fi;

    gid := arg[1];
    Kgens := arg[2];
    CF_LAST_S_RESULT := fail;
    s4Options := fail;

    if Length(arg) = 3 then
        s4Options := arg[3];
        if not IsRecord(s4Options) then
            Error("The optional third argument must be an S_4 options record.");
        fi;
    fi;

    # S1--S3 are deliberately silent.  Errors are NOT suppressed.
    CF_S_PRINT_ENABLED := false;
    S1local := S_1(gid, Kgens);
    S2local := S_2(S1local);
    S3local := S_3(S2local);

    # Only Step 4 is visible.
    CF_S_PRINT_ENABLED := true;
    if s4Options = fail then
        S4local := S_4(S3local);
    else
        S4local := S_4(S3local, s4Options);
    fi;

    if not IsRecord(S4local) then
        Error("Internal one-step driver error: S_4 did not return a record.");
    fi;

    CF_LAST_S_RESULT := S4local;
    CF_S_PRINT_ENABLED := true;

    # IMPORTANT: return the driver itself, not the result record.
    # Thus even the historical usage S := S(gid,Kgens);; leaves S callable.
    return CF_OneStepS;
end;;

S := CF_OneStepS;;

# Recommended use:
#     S(gid, Kgens);;
# Historical assignment style is also safe:
#     S := S(gid, Kgens);;
# Read the complete latest S_4 result from:
#     CF_LAST_S_RESULT;
#############################################################################
