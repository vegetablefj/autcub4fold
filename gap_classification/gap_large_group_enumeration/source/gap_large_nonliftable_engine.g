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

#############################################################################
# CUBIC FOURFOLD AUTOMORPHISM SEARCH: FULL H^2(G,C3), NON-LIFTABLE KPLUS FILTER + SMOOTHNESS VERSION 7
#
# Purpose
# -------
# Given
#   * gid   = [n,k], the GAP SmallGroup ID of the proposed projective group G;
#   * Kgens = generators of any fixed 6-dimensional matrix subgroup K0.
#             K0 may omit E(3)*IdentityMat(6), and no determinant condition is
#             imposed on K0.
#
# the program first forms the internal strict subgroup
#
#       Kplus = < K0, E(3)*IdentityMat(6) >,
#
# and then performs four steps:
#
#   S1 := S_1(gid, Kgens);
#      Prepare G, K0 and Kplus, compute dim H^2(G,C3), the 3-part of the Schur
#      multiplier, and the normal copies of Kplus/mu_3 in G.
#
#   S2 := S_2(S1);
#      Enumerate every nonzero class in H^2(G,C3), retain exactly the
#      C3-central extensions whose distinguished kernel lies in the derived
#      subgroup (the C3-stem classes), find all faithful 6-dimensional
#      representations containing the aligned Kplus, require every element of
#      H outside Kplus to be nonsymplectic, and remove GL(6)-conjugate matrix
#      images.
#
#   S3 := S_3(S2);
#      Compute the strict cubic invariant space, the matrix centralizer
#      dimension, and
#          family dimension = dim V_3(H) - dim C_GL6(H)
#      for every surviving matrix-image class.
#
#   S4 := S_4(S3);
#      First reject every negative-dimensional family dim V_3(H)<dim C_GL6(H)
#      by the exact centralizer-orbit obstruction.  Then try bounded finite-field
#      Groebner tests on several varied members per prime.  Every external
#      Singular call has a hard operating-system timeout.  If no smooth witness
#      is found, apply further quick exact sufficient tests proving that every
#      member is singular; otherwise return "unknown".
#
# Required GAP packages
# ---------------------
#   cohomolo
#   repsn
#
# Optional for Step 4 (strongly recommended)
# ------------------------------------------
#   a working external Singular executable, together with GNU timeout
#   (or gtimeout).  No GAP singular-package call is made by Step 4.
#
# Mathematical convention in Step 3
# ---------------------------------
# Vectors of variables are row vectors and A acts by x |-> x*A.  Thus the
# invariant condition is F(x*A)=F(x).
#
# Important
# ---------
# 1. K0 may or may not contain mu_3.  The program always works internally with
#
#       Kplus=<K0,mu_3>.
#
#    It rejects the input only if Kplus contains scalar matrices beyond mu_3,
#    since such additional scalars cannot strictly fix a nonzero cubic.
# 2. No determinant condition is imposed on K0 or Kplus.  A candidate H is
#    retained exactly when
#
#       Ker(det|H) <= Kplus.
#
#    Equivalently, every element of H outside <K0,mu_3> is nonsymplectic.
# 3. Step 2 enumerates one representative of each pair {v,-v} of nonzero
#    H^2 classes.  Inverting the labelled kernel C3 sends v to -v.  Since the
#    representation search tests both scalar actions E(3) and E(3)^2, the two
#    classes give the same possible matrix images and strict cubic families.
# 4. A nonzero H^2 class is retained in Step 2 only when its distinguished
#    kernel C3 lies in [H,H].  This is the intrinsic non-liftable/stem test.
#############################################################################

if LoadPackage("cohomolo") <> true then
    Error("The GAP package 'cohomolo' is required.");
fi;

if LoadPackage("repsn") <> true then
    Error("The GAP package 'repsn' is required.");
fi;


#############################################################################
# 0. BASIC UTILITIES
#############################################################################

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


# The rows in 'equations' are coefficient rows r with r*x^T=0.
# GAP's NullspaceMat gives row vectors v satisfying v*M=0, hence the transpose.
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


CF_FindInvertibleCombination := function(basis, n)
    local d, b, M, tuples, coeffs, v, i, j, attempts;

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

    for attempts in [1 .. 500] do
        coeffs := List([1 .. d], i -> Random([-5 .. 5]));

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

    return fail;
end;


# Find P satisfying B_i*P=P*A_i for every i.  Then P^-1*B_i*P=A_i.
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
    P := CF_FindInvertibleCombination(basis, n);

    if P = fail then
        return fail;
    fi;

    for t in [1 .. Length(Bgens)] do
        if Bgens[t] * P <> P * Agens[t] then
            Error("Internal error: the computed intertwiner does not intertwine.");
        fi;
    od;

    return P;
end;


#############################################################################
# 1. PREPARE INPUT K0 AND INTERNAL KPLUS
#############################################################################

CF_PrepareInputMatrixGroup := function(Kgens)
    local A, entries, K0mat, Kmat, zmat, inputAlreadyContainsMu3,
          scalarElementsK, isoK, K, rhoK, classesK, values, chiK,
          zK, ZK, qK, Kbar, gensK, generatorMatrices,
          originalDeterminantValues, originalDeterminantIsTrivial,
          splitComplements, isSplitCentralLift, KId;

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

    K0mat := Group(Kgens);

    if not IsFinite(K0mat) then
        Error("The matrix group generated by Kgens is not finite.");
    fi;

    zmat := E(3) * IdentityMat(6);
    inputAlreadyContainsMu3 := zmat in K0mat;

    # The internal strict subgroup always contains the cubic scalar mu_3.
    Kmat := Group(Concatenation(Kgens, [zmat]));

    if not IsFinite(Kmat) then
        Error("Kplus=<K0,E(3)I_6> is not finite.");
    fi;

    scalarElementsK := Filtered(
        Elements(Centre(Kmat)),
        CF_IsScalarMatrix
    );

    if Length(scalarElementsK) <> 3 then
        Error(
            "Kplus=<K0,E(3)I_6> contains scalar matrices outside mu_3. ",
            "A strict cubic lift cannot contain any additional scalar matrices."
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

    originalDeterminantValues := List(Kgens, DeterminantMat);
    originalDeterminantIsTrivial :=
        ForAll(originalDeterminantValues, d -> d = 1);

    classesK := ConjugacyClasses(K);
    values := List(
        classesK,
        C -> TraceMat(Image(rhoK, Representative(C)))
    );
    chiK := Character(K, values);

    if not IsCharacter(chiK) or DegreeOfCharacter(chiK) <> 6 then
        Error("The natural character of Kplus was not recognized as degree 6.");
    fi;

    zK := Image(isoK, zmat);
    ZK := Subgroup(K, [zK]);

    if Size(ZK) <> 3 or not IsSubgroup(Centre(K), ZK) then
        Error("The adjoined scalar subgroup is not a central C3 in Kplus.");
    fi;

    qK := NaturalHomomorphismByNormalSubgroup(K, ZK);
    Kbar := Image(qK);

    # Detect whether Kplus is split over its distinguished central C3.  This is
    # only a safe early rejection test for restrictions of H^2 classes.
    splitComplements := [];
    isSplitCentralLift := false;
    if IsSolvableGroup(K) then
        splitComplements := ComplementClassesRepresentatives(K, ZK);
        isSplitCentralLift := Length(splitComplements) > 0;
    fi;

    return rec(
        inputGenerators  := Kgens,
        originalKGenerators := Kgens,
        originalKmatrix  := K0mat,
        originalKOrder   := Size(K0mat),
        originalKContainsMu3 := inputAlreadyContainsMu3,
        Kmatrix          := Kmat,
        K                := K,
        abstractId       := KId,
        isoMatrixToPerm  := isoK,
        representation   := rhoK,
        character        := chiK,
        irreducibles     := Irr(UnderlyingCharacterTable(chiK)),
        generators       := gensK,
        generatorMatrices := generatorMatrices,
        determinantGeneratorValues := originalDeterminantValues,
        determinantIsTrivial := originalDeterminantIsTrivial,
        wholeInputProjectiveGroupSymplectic :=
            originalDeterminantIsTrivial,
        scalarMatrix     := zmat,
        scalarGenerator  := zK,
        scalarSubgroup   := ZK,
        scalarElements   := scalarElementsK,
        quotientMap      := qK,
        Kbar             := Kbar,
        isSplitCentralLift := isSplitCentralLift,
        splitComplements := splitComplements,
        automorphismGroupCache := fail,
        automorphismElementsCache := fail,
        scalarCharacterOrbitCache := fail
    );
end;


#############################################################################
# 2. COHOMOLOGY RECORD FOR THE TRIVIAL C3-MODULE
#############################################################################

CF_TrivialC3CohomologyRecord := function(G)
    local gensG, isoFp, F, one, mats, chr;

    if not IsPermGroup(G) then
        Error("cohomolo requires G to be a permutation group.");
    fi;

    gensG := GeneratorsOfGroup(G);
    isoFp := IsomorphismFpGroupByGenerators(G, gensG);

    if isoFp = fail then
        Error("Could not construct a compatible finitely presented group for G.");
    fi;

    F := Image(isoFp);
    one := One(GF(3));
    mats := List(gensG, g -> [[one]]);
    chr := CHR(G, 3, F, mats);

    if chr = fail then
        Error("cohomolo failed to construct the H^2 record.");
    fi;

    return rec(
        group          := G,
        generators     := gensG,
        fpIsomorphism  := isoFp,
        fpGroup        := F,
        matrices       := mats,
        chr            := chr
    );
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


#############################################################################
# S_1: INPUT, H^2 DIMENSION, MULTIPLIER 3-PART, AND KPLUS/MU3 COPIES
#############################################################################

S_1 := function(gid, Kgens)
    local G0, isoG, G, input, normalKbars, coh, multiplier3, warmup, h2dim, abinv, homMultiplierDimension, extAbelianizationDimension, expectedStemClassCount, expectedStemLineCount, indices, S;

    CF_CheckSmallGroupId(gid);

    CF_SPrint("\n============================================================\n");
    CF_SPrint("S_1: INPUT AND COHOMOLOGY DATA\n");
    CF_SPrint("============================================================\n");

    G0 := SmallGroup(gid[1], gid[2]);
    isoG := IsomorphismPermGroup(G0);

    if isoG = fail then
        Error("Could not convert G to a permutation group.");
    fi;

    G := Image(isoG);
    input := CF_PrepareInputMatrixGroup(Kgens);
    normalKbars := CF_NormalCopiesOfKbar(G, input.Kbar);
    coh := CF_TrivialC3CohomologyRecord(G);
    multiplier3 := SchurMultiplier(coh.chr);

    if Length(multiplier3) > 0 then
        warmup := NonsplitExtension(coh.chr);
        if warmup = fail then
            Error("cohomolo failed while initializing the nonsplit extensions.");
        fi;
    fi;

    h2dim := SecondCohomologyDimension(coh.chr);
    abinv := AbelianInvariants(G / DerivedSubgroup(G));
    homMultiplierDimension := Length(multiplier3);
    extAbelianizationDimension := Number(abinv, n -> n mod 3 = 0);
    expectedStemClassCount :=
        (3 ^ homMultiplierDimension - 1)
        * 3 ^ extAbelianizationDimension;
    expectedStemLineCount := expectedStemClassCount / 2;
    indices := List(normalKbars, S -> Index(G, S));

    CF_SPrint("G = SmallGroup(", gid[1], ",", gid[2], ")\n");
    CF_SPrint("|G| = ", Size(G), "\n");
    CF_SPrint("|input K0| = ", input.originalKOrder, "\n");
    CF_SPrint(
        "input K0 already contains mu_3 = ",
        input.originalKContainsMu3,
        "\n"
    );
    CF_SPrint("|Kplus=<K0,mu_3>| = ", Size(input.K), "\n");
    CF_SPrint("|Kplus/mu_3| = ", Size(input.Kbar), "\n");
    CF_SPrint(
        "determinant values on input K0 generators = ",
        input.determinantGeneratorValues,
        "\n"
    );
    CF_SPrint(
        "input K0 is determinant-one/symplectic = ",
        input.determinantIsTrivial,
        " (informational only; never used as a rejection condition)\n"
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
    CF_SPrint("number of nonzero H^2 vectors = ", 3 ^ h2dim - 1, "\n");
    CF_SPrint(
        "expected number of labelled C3-stem H^2 classes = ",
        expectedStemClassCount,
        "\n"
    );
    CF_SPrint(
        "expected number after identifying v with -v = ",
        expectedStemLineCount,
        "\n"
    );
    CF_SPrint(
        "Kplus is a detected split C3-extension = ",
        input.isSplitCentralLift,
        "\n"
    );
    CF_SPrint("normal copies of Kplus/mu_3 in G = ", Length(normalKbars), "\n");
    CF_SPrint("their indices in G = ", indices, "\n");

    if h2dim <> homMultiplierDimension + extAbelianizationDimension then
        CF_SPrint(
            "WARNING: the computed H^2 dimension does not match the ",
            "universal-coefficient dimension check.\n"
        );
    fi;

    if Length(multiplier3) = 0 then
        CF_SPrint("No C3-stem extension can occur: the multiplier 3-part is trivial.\n");
    fi;

    if Length(normalKbars) = 0 then
        CF_SPrint("No normal subgroup of G is isomorphic to Kplus/mu_3.\n");
    fi;

    for S in normalKbars do
        if Index(G, S) mod 3 = 0 then
            CF_SPrint("Index ", Index(G, S), " is divisible by 3.\n");
        else
            CF_SPrint("WARNING: index ", Index(G, S), " is not divisible by 3.\n");
        fi;
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
        ExpectedStemClassCount := expectedStemClassCount,
        ExpectedStemLineCount := expectedStemLineCount,
        cohomology          := coh
    );
end;


#############################################################################
# 3. CONSTRUCT ONE H^2 EXTENSION CLASS
#############################################################################

CF_ForEachH2LineRepresentative := function(d, callback)
    local v, fillTail, searchFirst;

    if d = 0 then
        return;
    fi;

    v := List([1 .. d], i -> 0);

    # Once the first nonzero coordinate has been normalized to 1, all later
    # coordinates are free.  This gives exactly one representative of {v,-v}.
    fillTail := function(pos)
        local a;

        if pos > d then
            callback(ShallowCopy(v));
            return;
        fi;

        for a in [0, 1, 2] do
            v[pos] := a;
            fillTail(pos + 1);
        od;

        v[pos] := 0;
    end;

    searchFirst := function(pos)
        if pos > d then
            return;
        fi;

        # Try the earliest possible first nonzero coordinate first.  Thus
        # [1,0,...,0] (the class returned by the default NonsplitExtension)
        # is processed before the remaining H^2 lines.
        v[pos] := 1;
        fillTail(pos + 1);
        v[pos] := 0;

        searchFirst(pos + 1);
    end;

    searchFirst(1);
end;


CF_OneH2Extension := function(S1, vec)
    local G, gensG, Efp, egens, nbase, isoE, H, hgens, z, Z, imagesG, epi, ker, stem;

    G := S1.G;
    gensG := S1.cohomology.generators;
    nbase := Length(gensG);
    Efp := NonsplitExtension(S1.cohomology.chr, vec);

    if Efp = fail then
        Error("NonsplitExtension failed for H^2 vector ", vec, ".");
    fi;

    egens := GeneratorsOfGroup(Efp);

    if Length(egens) <> nbase + 1 then
        Error(
            "Unexpected generator count in the cohomology extension: expected ",
            nbase + 1, ", got ", Length(egens), "."
        );
    fi;

    # For solvable G, every central C3-extension is solvable.  A pc-group
    # conversion is normally much faster than a permutation conversion for
    # the order-1944 and larger groups occurring here.
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

    stem := IsSubgroup(DerivedSubgroup(H), Z);

    # Do not call IdGroup here.  On groups of order 1944 and above this can
    # dominate the running time, and almost all H^2 classes are discarded
    # before any representation survives.  Identification is postponed until
    # a genuine degree-6 solution has been found.
    return rec(
        H2Vector            := ShallowCopy(vec),
        H                   := H,
        HId                 := fail,
        extensionGenerators := hgens,
        quotientMap         := epi,
        centralKernel       := Z,
        centralGenerator    := z,
        isStem              := stem,
        preimageData        := []
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

            # For split K=C3 x G_s, reject nonsplit restrictions before any
            # abstract isomorphism computation.
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

                # In the non-liftable-K cases the preimage P can be large.
                # Comparing SmallGroup IDs is normally much cheaper than a
                # blind IsomorphismGroups(K,P) call and rejects almost all
                # incompatible H^2 classes immediately.
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

#############################################################################
# 4. REPRESENTATION RESTRICTION TO THE FIXED K
#############################################################################

CF_EmbeddingIntoH := function(K, H, isoKP)
    local gensK, images, emb;

    gensK := GeneratorsOfGroup(K);
    images := List(gensK, g -> Image(isoKP, g));
    emb := GroupHomomorphismByImages(K, H, gensK, images);

    if emb = fail then
        Error("Could not regard an isomorphism K -> P as an embedding K -> H.");
    fi;

    return emb;
end;


# Re-express a class function on a specified character-table object.
# GAP's two-argument ScalarProduct requires the two class functions to carry
# the same underlying character table.  RestrictedClassFunction may create a
# fresh table for PreImage(hom), even when that group is abstractly the same K.
# Transfer values through the actual class fusion and rebuild the class
# function on the canonical table used by Irr(K).
CF_RebaseClassFunction := function(cf, targetTable)
    local sourceTable, fusion, inverseFusion, i, j, vals;

    sourceTable := UnderlyingCharacterTable(cf);

    if IsIdenticalObj(sourceTable, targetTable) then
        return cf;
    fi;

    fusion := FusionConjugacyClasses(sourceTable, targetTable);
    if fusion = fail then
        Error(
            "Could not fuse the source character table to the canonical ",
            "character table of K."
        );
    fi;

    if Length(fusion) <> NrConjugacyClasses(targetTable) then
        Error("The two character tables of K have different class counts.");
    fi;

    inverseFusion := List([1 .. NrConjugacyClasses(targetTable)], i -> 0);
    for i in [1 .. Length(fusion)] do
        j := fusion[i];
        if j < 1 or j > Length(inverseFusion) or inverseFusion[j] <> 0 then
            Error("The class fusion between the two copies of K is not bijective.");
        fi;
        inverseFusion[j] := i;
    od;

    if 0 in inverseFusion then
        Error("The class fusion between the two copies of K is not surjective.");
    fi;

    vals := ValuesOfClassFunction(cf){inverseFusion};

    if IsCharacter(cf) then
        return Character(targetTable, vals);
    elif IsVirtualCharacter(cf) then
        return VirtualCharacter(targetTable, vals);
    else
        return ClassFunction(targetTable, vals);
    fi;
end;


# For a fixed isomorphism isoKP:K->P, collect the target characters on the
# base embedding K->P->H that correspond to isomorphisms sending the
# distinguished scalar C3 of K onto the extension kernel C3.
CF_PrepareScalarCharacterOrbitRecords := function(S1)
    local K, gensK, chiK, ZK, autK, autGens, steps, records, pos,
          current, alpha, beta, newImages, newAlpha, invAlpha,
          target, scalarSubgroup, existing;

    if S1.input.scalarCharacterOrbitCache <> fail then
        return S1.input.scalarCharacterOrbitCache;
    fi;

    K := S1.input.K;
    gensK := S1.input.generators;
    chiK := S1.input.character;
    ZK := S1.input.scalarSubgroup;

    if S1.input.automorphismGroupCache = fail then
        CF_SPrint("Computing generators of Aut(K); no enumeration of Aut(K) elements...\n");
        S1.input.automorphismGroupCache := AutomorphismGroup(K);
    fi;

    autK := S1.input.automorphismGroupCache;
    autGens := GeneratorsOfGroup(autK);
    CF_SPrint("number of generators of Aut(K) = ", Length(autGens), "\n");
    steps := Concatenation(
        autGens,
        List(autGens, a -> InverseGeneralMapping(a))
    );

    alpha := IdentityMapping(K);
    records := [
        rec(
            targetCharacter := chiK,
            scalarSubgroup  := ZK,
            automorphism    := alpha
        )
    ];
    pos := 1;

    # Explore only the orbit of the pair
    #     (natural degree-6 character of K, distinguished scalar C3)
    # under Aut(K).  The old code enumerated every element of Aut(K), which is
    # prohibitive for non-liftable groups such as 3^(1+4):2.  Distinct
    # automorphisms giving the same pair are irrelevant for the restriction
    # character test and have identical future transitions under generators.
    while pos <= Length(records) do
        current := records[pos];
        alpha := current.automorphism;

        for beta in steps do
            # newAlpha = beta o alpha
            newImages := List(
                gensK,
                g -> Image(beta, Image(alpha, g))
            );
            newAlpha := GroupHomomorphismByImages(
                K,
                K,
                gensK,
                newImages
            );

            if newAlpha = fail then
                Error("Could not compose automorphisms of the fixed lift K.");
            fi;

            invAlpha := InverseGeneralMapping(newAlpha);
            target := CF_RebaseClassFunction(
                RestrictedClassFunction(chiK, invAlpha),
                UnderlyingCharacterTable(chiK)
            );
            scalarSubgroup := Image(newAlpha, ZK);

            existing := PositionProperty(
                records,
                r -> r.targetCharacter = target
                     and CF_SameSubgroup(r.scalarSubgroup, scalarSubgroup)
            );

            if existing = fail then
                Add(
                    records,
                    rec(
                        targetCharacter := target,
                        scalarSubgroup  := scalarSubgroup,
                        automorphism    := newAlpha
                    )
                );
            fi;
        od;

        pos := pos + 1;
    od;

    S1.input.scalarCharacterOrbitCache := records;

    CF_SPrint(
        "Aut(K)-orbit size of (degree-6 character, scalar C3) = ",
        Length(records),
        "\n"
    );

    return records;
end;


# For a fixed isomorphism isoKP:K->P, collect only the distinct target
# characters arising from automorphisms that send the distinguished scalar C3
# of K onto the extension kernel C3.  This uses the small orbit above, never
# Elements(AutomorphismGroup(K)).
CF_ScalarCompatibleTargetRecords := function(S1, ext, preimageRecord)
    local K, H, isoKP, emb0, orbitRecords, orbitRecord, imageScalarSubgroup,
          target, targets, pos, alpha, alignedImages, alignedEmbedding;

    K := S1.input.K;
    H := ext.H;
    isoKP := preimageRecord.isomorphismKToPreimage;
    emb0 := CF_EmbeddingIntoH(K, H, isoKP);
    orbitRecords := CF_PrepareScalarCharacterOrbitRecords(S1);
    targets := [];

    for orbitRecord in orbitRecords do
        imageScalarSubgroup := Image(
            isoKP,
            orbitRecord.scalarSubgroup
        );

        if CF_SameSubgroup(imageScalarSubgroup, ext.centralKernel) then
            target := orbitRecord.targetCharacter;
            pos := Position(List(targets, r -> r.targetCharacter), target);

            if pos = fail then
                alpha := orbitRecord.automorphism;
                alignedImages := List(
                    S1.input.generators,
                    g -> Image(isoKP, Image(alpha, g))
                );
                alignedEmbedding := GroupHomomorphismByImages(
                    K,
                    H,
                    S1.input.generators,
                    alignedImages
                );

                if alignedEmbedding = fail then
                    Error("Could not build a scalar-compatible embedding K -> H.");
                fi;

                Add(
                    targets,
                    rec(
                        baseEmbedding     := emb0,
                        automorphism      := alpha,
                        alignedEmbedding := alignedEmbedding,
                        targetCharacter   := target
                    )
                );
            fi;
        fi;
    od;

    return targets;
end;

CF_RestrictionMultiplicitySolutions := function(irrH, eligibleIndices, embedding, irrK, targetRecords)
    local canonicalTable, restricted, columns, answer, targetRecord,
          targetCharacter, targetVector, goodPositions, goodIndices,
          goodColumns, partialSolutions, partial, full, i, j, existing;

    answer := [];

    if Length(eligibleIndices) = 0 then
        return answer;
    fi;

    if Length(irrK) = 0 then
        Error("The irreducible character list of K is empty.");
    fi;

    canonicalTable := UnderlyingCharacterTable(irrK[1]);

    restricted := List(
        eligibleIndices,
        i -> CF_RebaseClassFunction(
            RestrictedClassFunction(irrH[i], embedding),
            canonicalTable
        )
    );

    columns := List(
        restricted,
        res -> List(irrK, psi -> ScalarProduct(res, psi))
    );

    for targetRecord in targetRecords do
        targetCharacter := CF_RebaseClassFunction(
            targetRecord.targetCharacter,
            canonicalTable
        );

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

            existing := PositionProperty(
                answer,
                r -> r.multiplicities = full
            );

            if existing = fail then
                Add(
                    answer,
                    rec(
                        multiplicities := full,
                        targetRecord   := targetRecord
                    )
                );
            fi;
        od;
    od;

    return answer;
end;

CF_BuildMatrixRepresentation := function(H, irrH, multiplicities, repCache)
    local componentMaps, i, j, rep, hgens, matrices, imageGroup, rho;

    componentMaps := [];

    for i in [1 .. Length(irrH)] do
        if multiplicities[i] > 0 then
            if repCache[i] = fail then
                repCache[i] := IrreducibleAffordingRepresentation(irrH[i]);
            fi;

            rep := repCache[i];

            if rep = fail then
                return fail;
            fi;

            for j in [1 .. multiplicities[i]] do
                Add(componentMaps, rep);
            od;
        fi;
    od;

    hgens := GeneratorsOfGroup(H);
    matrices := List(
        hgens,
        h -> CF_BlockDiagonalMatrixList(
            List(componentMaps, rep -> Image(rep, h))
        )
    );
    imageGroup := Group(matrices);
    rho := GroupHomomorphismByImages(H, imageGroup, hgens, matrices);

    if rho = fail then
        return fail;
    fi;

    return rec(
        representation := rho,
        generators     := hgens,
        matrices       := matrices,
        imageGroup     := imageGroup
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


CF_SolutionsForOneExtension := function(S1, ext)
    local H, z, irrH, classesH, posz, scalar, eligible, preimageRecord, targetRecords, candidates, c, allCandidates, existing, repCache, built, chiH, centralImage, scalarElements, Bgens, P, Pinv, alignedMatrices, alignedGroup, rhoAligned, answer, hgens, i;

    H := ext.H;
    z := ext.centralGenerator;
    irrH := Irr(H);
    classesH := ConjugacyClasses(H);
    posz := Position(List(classesH, Representative), z);

    if posz = fail then
        Error("Could not locate the central generator in the character table classes.");
    fi;

    allCandidates := [];

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
                    targetRecords[1].baseEmbedding,
                    S1.input.irreducibles,
                    targetRecords
                );

                for c in candidates do
                    existing := PositionProperty(
                        allCandidates,
                        r -> r.scalar = scalar
                             and r.multiplicities = c.multiplicities
                    );

                    if existing = fail then
                        Add(
                            allCandidates,
                            rec(
                                scalar         := scalar,
                                multiplicities := c.multiplicities,
                                targetRecord   := c.targetRecord,
                                preimageRecord := preimageRecord
                            )
                        );
                    fi;
                od;
            fi;
        od;
    od;

    repCache := List([1 .. Length(irrH)], i -> fail);
    answer := [];

    for c in allCandidates do
        chiH := CF_CharacterFromMultiplicities(irrH, c.multiplicities);

        if DegreeOfCharacter(chiH) <> 6 then
            Error("Internal error: a candidate character does not have degree 6.");
        fi;

        built := CF_BuildMatrixRepresentation(
            H,
            irrH,
            c.multiplicities,
            repCache
        );

        if built <> fail then
            # First require a faithful linear representation of H.  Below we
            # separately require that the only scalar matrices in its image
            # are the distinguished central C3; together these conditions give
            # a faithful projective action of G=H/C3.
            if Size(built.imageGroup) = Size(H) then
                centralImage := Image(built.representation, z);
                scalarElements := Filtered(
                    Elements(Centre(built.imageGroup)),
                    CF_IsScalarMatrix
                );

                # Projective faithfulness requires the full scalar subgroup
                # of the image to be exactly the distinguished mu_3.
                if Length(scalarElements) = 3
                   and CF_IsScalarWithValue(centralImage, c.scalar) then
                    Bgens := List(
                        S1.input.generators,
                        k -> Image(
                            built.representation,
                            Image(c.targetRecord.alignedEmbedding, k)
                        )
                    );

                    P := CF_Intertwiner(
                        Bgens,
                        S1.input.generatorMatrices
                    );

                    if P <> fail then
                        Pinv := P^-1;
                        alignedMatrices := List(
                            built.matrices,
                            A -> Pinv * A * P
                        );
                        alignedGroup := Group(alignedMatrices);

                        if IsSubgroup(alignedGroup, S1.input.Kmatrix) then
                            hgens := built.generators;
                            rhoAligned := GroupHomomorphismByImages(
                                H,
                                alignedGroup,
                                hgens,
                                alignedMatrices
                            );

                            if rhoAligned = fail then
                                Error("Could not build the aligned representation map.");
                            fi;

                            Add(
                                answer,
                                rec(
                                    H2Vector        := ShallowCopy(ext.H2Vector),
                                    HId             := ext.HId,
                                    H               := H,
                                    quotientMap     := ext.quotientMap,
                                    centralKernel   := ext.centralKernel,
                                    centralGenerator := ext.centralGenerator,
                                    HGenerators     := hgens,
                                    character       := chiH,
                                    multiplicities  := c.multiplicities,
                                    centralScalar   := c.scalar,
                                    representation  := rhoAligned,
                                    matrixGenerators := alignedMatrices,
                                    matrixImage     := alignedGroup,
                                    intertwiner     := P,
                                    KEmbedding      := c.targetRecord.alignedEmbedding,
                                    quotientKbarSubgroup := c.preimageRecord.quotientSubgroup
                                )
                            );
                        fi;
                    fi;
                fi;
            fi;
        fi;
    od;

    return answer;
end;


#############################################################################
# 5. GL(6)-CONJUGACY DEDUPLICATION OF MATRIX IMAGES
#############################################################################

CF_NaturalCharacterOfMatrixGroup := function(M)
    local isoM, P, rho, classes, values, chi;

    isoM := IsomorphismPermGroup(M);

    if isoM = fail then
        Error("Could not convert a matrix image to a permutation group.");
    fi;

    P := Image(isoM);
    rho := InverseGeneralMapping(isoM);
    classes := ConjugacyClasses(P);
    values := List(classes, C -> TraceMat(Image(rho, Representative(C))));
    chi := Character(P, values);

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
    local tbl, autG, autGens, orbit, pos, current, alpha, twisted;

    # All characters in the orbit must live on one and the same GAP
    # character-table object.  Without this rebasing, mathematically equal
    # characters attached to different table objects can compare unequal.
    tbl := UnderlyingCharacterTable(chi);
    autG := AutomorphismGroup(G);
    autGens := GeneratorsOfGroup(autG);

    chi := CF_RebaseClassFunction(chi, tbl);
    orbit := [chi];
    pos := 1;

    while pos <= Length(orbit) do
        current := orbit[pos];

        for alpha in autGens do
            twisted := RestrictedClassFunction(current, alpha);
            twisted := CF_RebaseClassFunction(twisted, tbl);

            if Position(orbit, twisted) = fail then
                Add(orbit, twisted);
            fi;
        od;

        pos := pos + 1;
    od;

    return orbit;
end;


CF_StandardMatrixImageDataCached := function(solution, standardCache)
    local natural, P, pid, pos, cacheRecord, Pstd, tblStd,
          isoStdToP, chiStd;

    natural := CF_NaturalCharacterOfMatrixGroup(solution.matrixImage);
    P := natural.permutationGroup;

    if IdGroupsAvailable(Size(P)) then
        pid := IdGroup(P);

        # Use one canonical SmallGroup object and one canonical character
        # table for every group ID throughout the whole deduplication pass.
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

        chiStd := RestrictedClassFunction(
            natural.character,
            isoStdToP
        );
        chiStd := CF_RebaseClassFunction(chiStd, tblStd);

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
        # Do not risk a false positive when a common canonical SmallGroup
        # representative is unavailable.
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

    chi2 := CF_RebaseClassFunction(data2.character, data1.table);

    orbit := CF_CharacterOrbitUnderAutomorphisms(
        data1.group,
        data1.character
    );

    return Position(orbit, chi2) <> fail;
end;


CF_DeduplicateConjugateMatrixImages := function(rawSolutions)
    local kept, keptData, standardCache, sol, data, pos, i;

    kept := [];
    keptData := [];
    standardCache := [];

    for sol in rawSolutions do
        pos := fail;

        # First perform the cheapest and strongest test: literal equality of
        # the two matrix subgroups.  This catches, in particular, character
        # twists by mu_3 when the faithful image already contains mu_3 I_6.
        for i in [1 .. Length(kept)] do
            if CF_SameSubgroup(
                kept[i].matrixImage,
                sol.matrixImage
            ) then
                pos := i;
                break;
            fi;
        od;

        if pos = fail then
            data := CF_StandardMatrixImageDataCached(
                sol,
                standardCache
            );

            for i in [1 .. Length(kept)] do
                if CF_AreConjugateMatrixImages(
                    keptData[i],
                    data
                ) then
                    pos := i;
                    break;
                fi;
            od;
        else
            data := fail;
        fi;

        if pos = fail then
            sol.matrixImageData := data;
            sol.mergedH2Vectors := [ShallowCopy(sol.H2Vector)];
            sol.mergedRawSolutionCount := 1;

            Add(kept, sol);
            Add(keptData, data);
        else
            if Position(
                kept[pos].mergedH2Vectors,
                sol.H2Vector
            ) = fail then
                Add(
                    kept[pos].mergedH2Vectors,
                    ShallowCopy(sol.H2Vector)
                );
            fi;

            if not IsBound(kept[pos].mergedRawSolutionCount) then
                kept[pos].mergedRawSolutionCount := 1;
            fi;

            kept[pos].mergedRawSolutionCount :=
                kept[pos].mergedRawSolutionCount + 1;
        fi;
    od;

    return kept;
end;


#############################################################################
# 5A. OUTSIDE-KPLUS SYMPLECTIC FILTER
#############################################################################

# Under the strict-invariance convention F(x*A)=F(x), the action on the
# one-dimensional H^{3,1} line is given by determinant, up to inversion.
# Hence the symplectic subgroup of the strict lift H is
#
#     H_s = Ker(det : H -> C^*).
#
# The supplied matrix group K0 is allowed to contain symplectic as well as
# nonsymplectic elements and may omit mu_3.  Internally it has been replaced by
#
#     Kplus=<K0,mu_3>.
#
# We impose no determinant condition on K0 or Kplus.  The requested condition
# is that every element of H outside Kplus be nonsymplectic.  Since Kplus has
# already been aligned as an actual subgroup of H, this is equivalent to
#
#     Ker(det|_H) <= Kplus.
#
# Thus the code does not enumerate H\Kplus element by element.

CF_DeterminantGeneratorValues := function(sol)
    return List(
        sol.matrixGenerators,
        A -> DeterminantMat(A)
    );
end;


CF_AttachOutsideKSymplecticData := function(sol)
    local H, generators, determinantValues, determinantMatrices,
          determinantImage, determinantMap, symplecticKernel,
          abstractKplus, kernelContainedInKplus;

    # Work in the abstract finite group H rather than in the matrix group.
    H := sol.H;
    generators := sol.HGenerators;
    abstractKplus := Image(sol.KEmbedding);

    determinantValues := List(sol.matrixGenerators, DeterminantMat);
    determinantMatrices := List(
        determinantValues,
        d -> [[d]]
    );
    determinantImage := Group(determinantMatrices);

    determinantMap := GroupHomomorphismByImages(
        H,
        determinantImage,
        generators,
        determinantMatrices
    );

    if determinantMap = fail then
        Error("Could not construct the determinant homomorphism of H.");
    fi;

    symplecticKernel := Kernel(determinantMap);
    kernelContainedInKplus := IsSubgroup(abstractKplus, symplecticKernel);

    sol.determinantGeneratorValues := determinantValues;
    sol.determinantImageOrder := Size(determinantImage);
    sol.determinantIsTrivial := Size(symplecticKernel) = Size(H);
    sol.wholeProjectiveGroupSymplectic := sol.determinantIsTrivial;
    sol.symplecticKernel := symplecticKernel;
    sol.symplecticKernelOrder := Size(symplecticKernel);
    sol.symplecticKernelContainedInInputKMu3 := kernelContainedInKplus;
    sol.allElementsOutsideInputKMu3AreNonsymplectic := kernelContainedInKplus;

    # Backward-compatible aliases: in this version "input K" means Kplus.
    sol.symplecticKernelContainedInInputK := kernelContainedInKplus;
    sol.allElementsOutsideInputKAreNonsymplectic := kernelContainedInKplus;

    return sol;
end;


CF_AcceptOutsideKNonSymplecticSolution := function(sol)
    CF_AttachOutsideKSymplecticData(sol);
    return sol.allElementsOutsideInputKAreNonsymplectic;
end;


#############################################################################
# S_2: ENUMERATE ALL STEM H^2 CLASSES AND THEIR 6-DIMENSIONAL LIFTS
#############################################################################

S_2 := function(arg)
    local S1, targetHIds, totalLineRepresentatives, progressStep, processed,
          stemCount, compatibleStemCount, stemH2Vectors,
          compatibleH2Vectors, solutionExtensions, rawSolutions,
          rawSolutionsBeforeOutsideKFilter,
          outsideKSymplecticRejectedRawCount,
          processVector, ext, localSolutions, sol, solutions;

    if Length(arg) < 1 or Length(arg) > 2 then
        Error("Use S_2(S1) or S_2(S1, [[order,id],...]).");
    fi;

    S1 := arg[1];
    targetHIds := [];
    if Length(arg) = 2 then
        targetHIds := arg[2];
        if not IsList(targetHIds) then
            Error("The optional second argument must be a list of SmallGroup IDs.");
        fi;
    fi;

    if not IsRecord(S1) or not IsBound(S1.H2Dimension) then
        Error("S_2 expects the record returned by S_1.");
    fi;

    CF_SPrint("\n============================================================\n");
    CF_SPrint("S_2: STREAMED H^2(G,C3) STEM LINES AND LINEAR LIFTS\n");
    CF_SPrint("============================================================\n");

    if Length(targetHIds) > 0 then
        CF_SPrint("target middle-group IDs = ", targetHIds, "\n");
        CF_SPrint("Only matching H will enter the expensive Irr(H) stage.\n");
    fi;

    if Length(S1.multiplier3Invariants) = 0 then
        CF_SPrint("The multiplier 3-part is trivial, so there are no C3-stem classes.\n");
        return rec(
            step1                    := S1,
            H2LineRepresentativeCount := 0,
            stemClassCount           := 0,
            compatibleStemClassCount := 0,
            stemH2Vectors            := [],
            compatibleH2Vectors      := [],
            solutionExtensions       := [],
            rawSolutions             := [],
            solutions                := []
        );
    fi;

    if Length(S1.normalKbarSubgroups) = 0 then
        CF_SPrint("There is no normal copy of K/C3 in G.\n");
        return rec(
            step1                    := S1,
            H2LineRepresentativeCount := 0,
            stemClassCount           := 0,
            compatibleStemClassCount := 0,
            stemH2Vectors            := [],
            compatibleH2Vectors      := [],
            solutionExtensions       := [],
            rawSolutions             := [],
            solutions                := []
        );
    fi;

    totalLineRepresentatives := (3 ^ S1.H2Dimension - 1) / 2;
    progressStep := Maximum(1, QuoInt(totalLineRepresentatives, 100));
    processed := 0;
    stemCount := 0;
    compatibleStemCount := 0;
    stemH2Vectors := [];
    compatibleH2Vectors := [];
    solutionExtensions := [];
    rawSolutions := [];

    CF_SPrint(
        "H^2 line representatives to construct after v~-v = ",
        totalLineRepresentatives,
        "\n"
    );
    CF_SPrint(
        "IdGroup is postponed until a degree-6 solution survives. ",
        "Rejected extension groups are not stored.\n"
    );

    processVector := function(vec)
        local extLocal, localSolutionsLocal, solLocal, summary;

        processed := processed + 1;

        if processed = 1
           or processed mod progressStep = 0
           or processed = totalLineRepresentatives then
            CF_SPrint(
                "  H^2 progress ", processed, "/",
                totalLineRepresentatives,
                "; stem=", stemCount,
                "; K-compatible=", compatibleStemCount,
                "; raw solutions=", Length(rawSolutions),
                "\n"
            );
        fi;

        extLocal := CF_OneH2Extension(S1, vec);

        if not extLocal.isStem then
            return;
        fi;

        stemCount := stemCount + 1;
        Add(stemH2Vectors, ShallowCopy(vec));

        # This is the decisive early compatibility filter for the internal Kplus.
        # If K -> K/C3 splits, it first tests whether the restricted H^2
        # class splits, before attempting a full isomorphism.  This does not
        # impose any determinant or symplectic condition on K.
        CF_AttachKPreimages(extLocal, S1);

        if Length(extLocal.preimageData) = 0 then
            return;
        fi;

        compatibleStemCount := compatibleStemCount + 1;
        Add(compatibleH2Vectors, ShallowCopy(vec));

        if Length(targetHIds) > 0 then
            if not IdGroupsAvailable(Size(extLocal.H)) then
                Error(
                    "Target-H filtering requires IdGroup at order ",
                    Size(extLocal.H), "."
                );
            fi;

            extLocal.HId := IdGroup(extLocal.H);
            if Position(targetHIds, extLocal.HId) = fail then
                return;
            fi;
        fi;

        CF_SPrint(
            "    compatible H^2 line ", vec,
            ": computing degree-6 character restrictions...\n"
        );
        localSolutionsLocal := CF_SolutionsForOneExtension(S1, extLocal);

        if Length(localSolutionsLocal) = 0 then
            return;
        fi;

        # Only now identify the middle group.  This avoids calling IdGroup on
        # every order-3|G| extension, which was the main slowdown for the
        # family with middle group [1944,3493].
        if extLocal.HId = fail and IdGroupsAvailable(Size(extLocal.H)) then
            extLocal.HId := IdGroup(extLocal.H);
        fi;

        for solLocal in localSolutionsLocal do
            solLocal.HId := extLocal.HId;
        od;

        Add(solutionExtensions, extLocal);
        Append(rawSolutions, localSolutionsLocal);

        if extLocal.HId = fail then
            CF_SPrint(
                "    surviving extension |H|=", Size(extLocal.H),
                ", degree-6 solutions=", Length(localSolutionsLocal),
                "\n"
            );
        else
            CF_SPrint(
                "    surviving extension H=SmallGroup(",
                extLocal.HId[1], ",", extLocal.HId[2],
                "), degree-6 solutions=", Length(localSolutionsLocal),
                "\n"
            );
        fi;
    end;

    CF_ForEachH2LineRepresentative(S1.H2Dimension, processVector);

    CF_SPrint("\nH^2 line representatives processed = ", processed, "\n");
    CF_SPrint("C3-stem lines retained = ", stemCount, "\n");
    CF_SPrint("Stem lines with a compatible Kplus preimage = ", compatibleStemCount, "\n");

    if stemCount <> S1.ExpectedStemLineCount then
        CF_SPrint(
            "WARNING: intrinsic stem-line count differs from the ",
            "universal-coefficient prediction ",
            S1.ExpectedStemLineCount,
            ".\n"
        );
    fi;

    CF_SPrint("Raw faithful degree-6 solutions before outside-Kplus filter = ",
          Length(rawSolutions), "\n");

    rawSolutionsBeforeOutsideKFilter := rawSolutions;
    rawSolutions := Filtered(
        rawSolutionsBeforeOutsideKFilter,
        CF_AcceptOutsideKNonSymplecticSolution
    );
    outsideKSymplecticRejectedRawCount :=
        Length(rawSolutionsBeforeOutsideKFilter) - Length(rawSolutions);

    CF_SPrint(
        "Outside-Kplus symplectic filter: rejected ",
        outsideKSymplecticRejectedRawCount,
        " raw solutions for which Ker(det|H) is not contained in Kplus=<K0,mu_3>; retained ",
        Length(rawSolutions), ".\n"
    );

    solutions := CF_DeduplicateConjugateMatrixImages(rawSolutions);

    CF_SPrint(
        "GL(6)-conjugacy classes satisfying Ker(det|H) <= <K0,mu_3> = ",
        Length(solutions), "\n"
    );

    return rec(
        step1                    := S1,
        H2LineRepresentativeCount := processed,
        stemClassCount           := stemCount,
        compatibleStemClassCount := compatibleStemCount,
        stemH2Vectors            := stemH2Vectors,
        compatibleH2Vectors      := compatibleH2Vectors,
        solutionExtensions       := solutionExtensions,
        rawSolutionsBeforeOutsideKFilter :=
            rawSolutionsBeforeOutsideKFilter,
        # Compatibility aliases retained for older downstream scripts.
        rawSolutionsBeforeDeterminantFilter :=
            rawSolutionsBeforeOutsideKFilter,
        rawSolutions             := rawSolutions,
        outsideKSymplecticFilterMode :=
            "require Ker(det|H) <= <input K0,mu_3>",
        determinantFilterMode    :=
            "require Ker(det|H) <= <input K0,mu_3>",
        outsideKSymplecticRejectedRawCount :=
            outsideKSymplecticRejectedRawCount,
        determinantRejectedRawCount :=
            outsideKSymplecticRejectedRawCount,
        solutions                := solutions
    );
end;


#############################################################################
# 6. DEGREE-3 MONOMIALS AND STRICT CUBIC INVARIANTS
#############################################################################

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


# Image of x^exponent under x |-> x*A, returned in the fixed monomial basis.
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


CF_CubicInvariantBasis := function(matrixGenerators)
    local exponentBasis, equations, A, columns, i, j, row, basis, ring, variables, monomials, polynomials, strings;

    exponentBasis := CF_DegreeThreeExponentVectors6();

    if Length(exponentBasis) <> 56 then
        Error("The cubic monomial basis should have dimension 56.");
    fi;

    equations := [];

    for A in matrixGenerators do
        if DimensionsMat(A) <> [6, 6] then
            Error("Step 3 received a matrix that is not 6 by 6.");
        fi;

        columns := List(
            exponentBasis,
            e -> CF_MonomialImageVector(e, A, exponentBasis)
        );

        for i in [1 .. 56] do
            row := List([1 .. 56], j -> columns[j][i]);
            row[i] := row[i] - 1;
            Add(equations, row);
        od;
    od;

    basis := CF_NullspaceOfEquationRows(equations, 56);
    ring := PolynomialRing(
        Cyclotomics,
        ["x1", "x2", "x3", "x4", "x5", "x6"]
    );
    variables := IndeterminatesOfPolynomialRing(ring);
    monomials := List(
        exponentBasis,
        e -> CF_MonomialFromExponent(variables, e, ring)
    );
    polynomials := List(
        basis,
        v -> CF_CoefficientVectorToPolynomial(v, monomials, ring)
    );
    strings := List(
        basis,
        v -> CF_CoefficientVectorToPolynomialString(v, exponentBasis)
    );

    return rec(
        polynomialRing     := ring,
        variables          := variables,
        monomialExponents  := exponentBasis,
        monomialBasis      := monomials,
        coefficientBasis   := basis,
        polynomialBasis    := polynomials,
        polynomialStrings  := strings,
        invariantDimension := Length(basis)
    );
end;


#############################################################################
# 7. CENTRALIZER DIMENSION
#############################################################################

CF_CentralizerAlgebraBasis := function(matrixGenerators)
    local n, equations, A, i, j, k, row, idx, basis;

    if Length(matrixGenerators) = 0 then
        return rec(
            basis := IdentityMat(36),
            dimension := 36
        );
    fi;

    n := Length(matrixGenerators[1]);
    equations := [];

    for A in matrixGenerators do
        if DimensionsMat(A) <> [n, n] then
            Error("Centralizer matrices have incompatible dimensions.");
        fi;

        # X*A-A*X=0.
        for i in [1 .. n] do
            for j in [1 .. n] do
                row := List([1 .. n * n], k -> 0);

                for k in [1 .. n] do
                    idx := (i - 1) * n + k;
                    row[idx] := row[idx] + A[k][j];

                    idx := (k - 1) * n + j;
                    row[idx] := row[idx] - A[i][k];
                od;

                Add(equations, row);
            od;
        od;
    od;

    basis := CF_NullspaceOfEquationRows(equations, n * n);

    return rec(
        basis := basis,
        matrixBasis := List(basis, v -> CF_VectorToSquareMatrix(v, n)),
        dimension := Length(basis)
    );
end;


#############################################################################
# S_3: STRICT CUBIC FAMILIES AND DIMENSIONS
#############################################################################

S_3 := function(S2)
    local final, sol, cubic, centralizer, familyDimension, item, polynomial, i;

    if not IsRecord(S2) or not IsBound(S2.solutions) then
        Error("S_3 expects the record returned by S_2.");
    fi;

    CF_SPrint("\n============================================================\n");
    CF_SPrint("S_3: STRICT CUBIC INVARIANTS AND FAMILY DIMENSIONS\n");
    CF_SPrint("============================================================\n");

    final := [];

    for i in [1 .. Length(S2.solutions)] do
        sol := S2.solutions[i];
        cubic := CF_CubicInvariantBasis(sol.matrixGenerators);
        centralizer := CF_CentralizerAlgebraBasis(sol.matrixGenerators);
        familyDimension :=
            cubic.invariantDimension - centralizer.dimension;

        item := rec(
            solutionNumber        := i,
            HId                   := sol.HId,
            H2Vector              := sol.H2Vector,
            mergedH2Vectors       := sol.mergedH2Vectors,
            matrixGenerators      := sol.matrixGenerators,
            matrixImageOrder      := Size(sol.matrixImage),
            determinantGeneratorValues :=
                sol.determinantGeneratorValues,
            determinantImageOrder := sol.determinantImageOrder,
            determinantIsTrivial  := sol.determinantIsTrivial,
            symplecticKernelOrder := sol.symplecticKernelOrder,
            symplecticKernelContainedInInputKMu3 :=
                sol.symplecticKernelContainedInInputKMu3,
            allElementsOutsideInputKMu3AreNonsymplectic :=
                sol.allElementsOutsideInputKMu3AreNonsymplectic,
            symplecticKernelContainedInInputK :=
                sol.symplecticKernelContainedInInputK,
            allElementsOutsideInputKAreNonsymplectic :=
                sol.allElementsOutsideInputKAreNonsymplectic,
            cubicMonomialExponents := cubic.monomialExponents,
            cubicInvariantBasisVectors := cubic.coefficientBasis,
            polynomialRing        := cubic.polynomialRing,
            variables             := cubic.variables,
            cubicInvariantBasis   := cubic.polynomialBasis,
            cubicInvariantBasisStrings := cubic.polynomialStrings,
            cubicInvariantDimension := cubic.invariantDimension,
            centralizerBasis      := centralizer.matrixBasis,
            centralizerDimension  := centralizer.dimension,
            familyDimension       := familyDimension
        );

        Add(final, item);

        CF_SPrint("\nSolution ", i, "\n");
        CF_SPrint("  H ID = ", sol.HId, "\n");
        CF_SPrint("  represented H^2 vectors = ", sol.mergedH2Vectors, "\n");
        CF_SPrint("  matrix image order = ", Size(sol.matrixImage), "\n");
        CF_SPrint("  determinant values on stored generators = ",
              sol.determinantGeneratorValues, "\n");
        CF_SPrint("  symplectic kernel order = ",
              sol.symplecticKernelOrder, "\n");
        CF_SPrint("  Ker(det|H) contained in <input K0,mu_3> = ",
              sol.symplecticKernelContainedInInputK, "\n");
        CF_SPrint("  dim strict cubic invariants = ", cubic.invariantDimension, "\n");
        CF_SPrint("  dim matrix centralizer = ", centralizer.dimension, "\n");
        CF_SPrint("  family dimension = ", familyDimension, "\n");
        CF_SPrint("  cubic invariant basis:\n");

        for polynomial in cubic.polynomialBasis do
            CF_SPrint("    ", polynomial, "\n");
        od;
    od;

    return rec(
        step2    := S2,
        families := final
    );
end;




#############################################################################
# 8. BOUNDED GENERIC SMOOTHNESS TESTS
#############################################################################

# Philosophy
# ----------
# This step returns exactly one of:
#
#   "generically smooth"
#       A concrete family member has smooth reduction at a good split prime.
#
#   "all members singular"
#       A quick exact obstruction valid for the whole invariant vector space
#       was found.
#
#   "unknown"
#       No certificate was found within the deliberately small time budget.
#
# Runtime control
# ---------------
# For each selected prime, several candidate members are tested in ONE
# Singular process.  The whole batch has a hard wall-clock timeout.  Thus the
# default cost is bounded by
#
#       maxSmoothTrials * groebnerTimeoutSeconds
#
# per family, up to a small process-start overhead.
#
# Finite-field certificate
# ------------------------
# Let J be the homogeneous Jacobian ideal generated by the six first
# derivatives of a cubic F over GF(p), with p > 3.  If dim(J)=0, then the
# affine zero set of J is only the origin: any nonzero homogeneous zero would
# generate an entire affine line and force dimension at least one.  Hence F
# has no projective singular point.  This gives a rigorous smoothness
# certificate using only ONE Groebner basis per candidate, rather than six
# separate affine-chart computations.
#############################################################################


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
    local candidates, vector, i, attempt, middle;

    candidates := [];

    if dimension <= 0 or maxCandidates <= 0 then
        return candidates;
    fi;

    if dimension = 1 then
        return [[1]];
    fi;

    # Sparse witnesses are often much easier for Groebner bases and frequently
    # expose a smooth member immediately.  In particular, [1,0,...,0,2] fixes
    # the family that motivated this revision.
    vector := List([1 .. dimension], i -> 0);
    vector[1] := 1;
    vector[dimension] := 2;
    CF_S4_AddUniqueCoefficientVector(candidates, vector);

    vector := List([1 .. dimension], i -> 0);
    vector[1] := 1;
    vector[2] := 2;
    CF_S4_AddUniqueCoefficientVector(candidates, vector);

    vector := List([1 .. dimension], i -> 1);
    CF_S4_AddUniqueCoefficientVector(candidates, vector);

    vector := List([1 .. dimension], i -> i);
    CF_S4_AddUniqueCoefficientVector(candidates, vector);

    vector := List(
        [1 .. dimension],
        i -> (-1) ^ (i - 1) * i
    );
    CF_S4_AddUniqueCoefficientVector(candidates, vector);

    middle := QuoInt(dimension + 1, 2);
    vector := List([1 .. dimension], i -> 0);
    vector[1] := 1;
    vector[middle] := -1;
    vector[dimension] := 3;
    CF_S4_AddUniqueCoefficientVector(candidates, vector);

    attempt := 1;
    while Length(candidates) < maxCandidates
          and attempt <= 5 * maxCandidates + 50 do
        vector := CF_IrregularCoefficientVector(dimension, attempt);
        CF_S4_AddUniqueCoefficientVector(candidates, vector);
        attempt := attempt + 1;
    od;

    if Length(candidates) > maxCandidates then
        return candidates{[1 .. maxCandidates]};
    fi;

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
    Add(lines, "quit;");

    return CF_JoinStrings(lines, "\n");
end;


CF_S4_RunBoundedSingularScript := function(
    script,
    tools,
    timeoutSeconds
)
    local tempDirectory, inputFile, outputFile, outputStream,
          exitCode, output;

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

    if PositionSublist(output, "CF_SMOOTH_MEMBER_") <> fail then
        return rec(
            status := "smooth",
            output := output,
            exitCode := exitCode
        );
    fi;

    if PositionSublist(output, "CF_NO_SMOOTH_MEMBER") <> fail then
        return rec(
            status := "no_smooth_in_batch",
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

    return run;
end;


#############################################################################
# Exact quick obstructions for the whole family
#############################################################################

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




#############################################################################
# Evaluate one partial derivative of a cubic represented by its coefficient
# vector in the stored monomial basis.
#
# This helper was accidentally omitted from VERSION 2, although the bounded
# common-singular-point search still called it.
#############################################################################

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


CF_DefaultSmoothnessOptions := function()
    return rec(
        # Number of good primes tested.  Each prime uses one bounded Singular
        # process containing several candidate members.
        maxSmoothTrials := 2,

        # Number of candidate members tested inside each prime batch.
        maxMembersPerPrime := 10,

        # Candidate split primes are searched only up to this bound.
        maxSplitPrimes := 4,
        maxPrime := 2000,

        # Hard wall-clock limit for each entire prime batch.
        groebnerTimeoutSeconds := 4,

        # Cheap exact fixed-point search limits.
        maxCommonPointSupport := 3,
        maxCommonPointChecks := 600
    );
end;


CF_MergeSmoothnessOptions := function(options)
    local merged;

    merged := CF_DefaultSmoothnessOptions();

    if IsBound(options.maxSmoothTrials) then
        merged.maxSmoothTrials := options.maxSmoothTrials;
    fi;

    if IsBound(options.maxMembersPerPrime) then
        merged.maxMembersPerPrime := options.maxMembersPerPrime;
    fi;

    if IsBound(options.maxSplitPrimes) then
        merged.maxSplitPrimes := options.maxSplitPrimes;
    fi;

    if IsBound(options.maxPrime) then
        merged.maxPrime := options.maxPrime;
    fi;

    if IsBound(options.groebnerTimeoutSeconds) then
        merged.groebnerTimeoutSeconds :=
            options.groebnerTimeoutSeconds;
    fi;

    if IsBound(options.maxCommonPointSupport) then
        merged.maxCommonPointSupport :=
            options.maxCommonPointSupport;
    fi;

    if IsBound(options.maxCommonPointChecks) then
        merged.maxCommonPointChecks :=
            options.maxCommonPointChecks;
    fi;

    return merged;
end;


#############################################################################
# S_4: BOUNDED GENERIC SMOOTHNESS CLASSIFICATION
#############################################################################

S_4 := function(arg)
    local S3, options, tools, externalReady, results, family,
          primeData, coefficientCandidates, trials, numberOfCalls,
          attempt, p, smoothTest, witnessRecord, commonFactor,
          linearVariable, commonPointData, commonPoint, result, i,
          j, GId, matrixImage;

    if Length(arg) < 1 or Length(arg) > 2 then
        Error("Use S_4(S3) or S_4(S3, optionsRecord).");
    fi;

    S3 := arg[1];
    if not IsRecord(S3) or not IsBound(S3.families) then
        Error("S_4 expects the record returned by S_3.");
    fi;

    GId := fail;
    if IsBound(S3.step2)
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

    CF_SPrint("\n============================================================\n");
    CF_SPrint("S_4: BOUNDED GENERIC SMOOTHNESS TESTS, VERSION 6\n");
    CF_SPrint("============================================================\n");

    if externalReady then
        CF_SPrint("Singular executable = ", tools.singular, "\n");
        CF_SPrint("timeout executable = ", tools.timeout, "\n");
        CF_SPrint(
            "Hard timeout per prime batch = ",
            options.groebnerTimeoutSeconds,
            " seconds.\n"
        );
        CF_SPrint(
            "Maximum candidate members per prime = ",
            options.maxMembersPerPrime,
            "\n"
        );
    else
        CF_SPrint(
            "Singular or timeout is unavailable.  External Groebner tests ",
            "are skipped; Step 4 will use only bounded exact obstructions.\n"
        );
    fi;

    results := [];

    for i in [1 .. Length(S3.families)] do
        family := S3.families[i];
        trials := [];
        result := fail;
        commonPointData := fail;

        CF_SPrint("\nFamily ", i, " (H ID = ", family.HId, ")\n");

        #####################################################################
        # 1. Dimension obstruction.
        #
        # If a smooth cubic F existed, the projectivized matrix centralizer
        # would have a finite stabilizer at [F].  Its orbit would therefore
        # have dimension dim(C)-1 inside P(W), whose dimension is dim(W)-1.
        # Hence smoothness forces dim(W) >= dim(C).  A strict inequality in
        # the opposite direction proves that every member is singular.
        #####################################################################

        if family.cubicInvariantDimension
           < family.centralizerDimension then

            result := rec(
                familyNumber := i,
                HId := family.HId,
                status := "all members singular",
                proofType :=
                    "dimension obstruction: invariant cubic dimension is smaller than matrix centralizer dimension",
                invariantDimension := family.cubicInvariantDimension,
                centralizerDimension := family.centralizerDimension,
                familyDimension := family.familyDimension,
                trials := trials,
                externalGroebnerAvailable := externalReady
            );

            CF_SPrint(
                "  dimension obstruction: ",
                family.cubicInvariantDimension,
                " < ",
                family.centralizerDimension,
                "\n"
            );
        fi;

        #####################################################################
        # 2. Test several varied members in each bounded finite-field batch.
        #####################################################################

        if result = fail then
            primeData := CF_S4_AdmissibleSplitPrimes(
                family,
                options.maxSplitPrimes,
                options.maxPrime
            );

            coefficientCandidates := CF_S4_CandidateCoefficientVectors(
                family.cubicInvariantDimension,
                options.maxMembersPerPrime
            );

            CF_SPrint(
                "  coefficient-field conductor = ",
                primeData.conductor,
                "\n"
            );
            CF_SPrint("  admissible split primes = ", primeData.primes, "\n");
            CF_SPrint(
                "  coefficient candidates = ",
                coefficientCandidates,
                "\n"
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

                    CF_SPrint(
                        "  prime batch ", attempt,
                        ": prime ", p,
                        ", members prepared = ",
                        Length(smoothTest.memberRecords),
                        ", status = ", smoothTest.status,
                        "\n"
                    );

                    if smoothTest.status = "smooth"
                       and smoothTest.witnessIndex <> fail then

                        witnessRecord :=
                            smoothTest.memberRecords[
                                smoothTest.witnessIndex
                            ];

                        result := rec(
                            familyNumber := i,
                            HId := family.HId,
                            status := "generically smooth",
                            proofType :=
                                "explicit member has zero-dimensional homogeneous Jacobian ideal after good finite-field reduction",
                            witnessCoefficients :=
                                witnessRecord.coefficients,
                            witnessPrime := p,
                            coefficientFieldConductor :=
                                primeData.conductor,
                            trials := trials,
                            externalGroebnerAvailable := true
                        );
                        break;
                    fi;
                od;
            fi;
        fi;

        #####################################################################
        # 3. Exact common monomial factor.
        #####################################################################

        if result = fail then
            commonFactor := CF_S4_CommonMonomialFactor(family);

            if commonFactor <> fail then
                result := rec(
                    familyNumber := i,
                    HId := family.HId,
                    status := "all members singular",
                    proofType := "nonconstant common monomial factor",
                    commonFactorExponents := commonFactor.exponents,
                    commonFactor := commonFactor.factorString,
                    trials := trials,
                    externalGroebnerAvailable := externalReady
                );
            fi;
        fi;

        #####################################################################
        # 4. A variable has exponent at most one throughout the family.
        #####################################################################

        if result = fail then
            linearVariable := CF_VariableLinearInWholeFamily(family);

            if linearVariable <> fail then
                commonPoint := [0, 0, 0, 0, 0, 0];
                commonPoint[linearVariable] := 1;

                result := rec(
                    familyNumber := i,
                    HId := family.HId,
                    status := "all members singular",
                    proofType :=
                        "one variable has exponent at most one throughout the family",
                    variableIndex := linearVariable,
                    commonSingularPoint := commonPoint,
                    trials := trials,
                    externalGroebnerAvailable := externalReady
                );
            fi;
        fi;

        #####################################################################
        # 5. Bounded exact search for a fixed common singular point.
        #####################################################################

        if result = fail then
            commonPointData :=
                CF_S4_FindSmallCommonSingularPointBounded(
                    family,
                    options.maxCommonPointSupport,
                    options.maxCommonPointChecks
                );

            if commonPointData.point <> fail then
                result := rec(
                    familyNumber := i,
                    HId := family.HId,
                    status := "all members singular",
                    proofType := "fixed common singular point found",
                    commonSingularPoint := commonPointData.point,
                    commonPointChecks := commonPointData.checks,
                    trials := trials,
                    externalGroebnerAvailable := externalReady
                );
            fi;
        fi;

        #####################################################################
        # 6. Conservative fallback.
        #####################################################################

        if result = fail then
            result := rec(
                familyNumber := i,
                HId := family.HId,
                status := "unknown",
                proofType :=
                    "no certificate found within the bounded time and search limits",
                coefficientFieldConductor := primeData.conductor,
                admissibleSplitPrimes := primeData.primes,
                coefficientCandidates := coefficientCandidates,
                trials := trials,
                externalGroebnerAvailable := externalReady,
                commonPointChecks := commonPointData.checks,
                commonPointLimitReached :=
                    commonPointData.limitReached
            );
        fi;

        # Attach the complete family and matrix-group data to every S_4
        # record.  The detailed data are printed below for smooth and unknown
        # families, and remain programmatically available for all statuses.
        matrixImage := Group(family.matrixGenerators);

        result.GId := GId;
        result.HId := family.HId;
        result.H2Vector := family.H2Vector;
        result.mergedH2Vectors := family.mergedH2Vectors;
        result.matrixImage := matrixImage;
        result.matrixImageOrder := family.matrixImageOrder;
        result.matrixGenerators := family.matrixGenerators;
        result.determinantGeneratorValues :=
            family.determinantGeneratorValues;
        result.determinantImageOrder := family.determinantImageOrder;
        result.symplecticKernelOrder := family.symplecticKernelOrder;
        result.symplecticKernelContainedInInputKMu3 :=
            family.symplecticKernelContainedInInputKMu3;
        result.allElementsOutsideInputKMu3AreNonsymplectic :=
            family.allElementsOutsideInputKMu3AreNonsymplectic;
        result.symplecticKernelContainedInInputK :=
            family.symplecticKernelContainedInInputK;
        result.allElementsOutsideInputKAreNonsymplectic :=
            family.allElementsOutsideInputKAreNonsymplectic;
        result.cubicInvariantDimension :=
            family.cubicInvariantDimension;
        result.cubicInvariantBasis :=
            family.cubicInvariantBasis;
        result.cubicInvariantBasisStrings :=
            family.cubicInvariantBasisStrings;
        result.centralizerDimension := family.centralizerDimension;
        result.familyDimension := family.familyDimension;

        Add(results, result);

        CF_SPrint("  status = ", result.status, "\n");
        CF_SPrint("  reason = ", result.proofType, "\n");

        if IsBound(result.witnessCoefficients) then
            CF_SPrint(
                "  smooth witness coefficients = ",
                result.witnessCoefficients,
                "\n"
            );
            CF_SPrint("  good reduction prime = ", result.witnessPrime, "\n");
        fi;

        if IsBound(result.commonFactor) then
            CF_SPrint("  common factor = ", result.commonFactor, "\n");
        fi;

        if IsBound(result.commonSingularPoint) then
            CF_SPrint(
                "  common singular point = ",
                result.commonSingularPoint,
                "\n"
            );
        fi;

        #####################################################################
        # Detailed output requested for families that survive the automatic
        # singularity rejection: generically smooth or unknown.
        #####################################################################

        if result.status = "generically smooth"
           or result.status = "unknown" then

            CF_SPrint(
                "  ------------------------------------------------------------\n"
            );
            CF_SPrint(
                "  FULL DATA FOR STATUS = ", result.status, "\n"
            );
            CF_SPrint("  G ID = ", GId, "\n");
            CF_SPrint("  H ID = ", family.HId, "\n");
            CF_SPrint(
                "  represented H^2 vectors = ",
                family.mergedH2Vectors,
                "\n"
            );
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
                "  Ker(det|H) contained in <input K0,mu_3> = ",
                family.symplecticKernelContainedInInputK,
                "\n"
            );
            CF_SPrint(
                "  number of stored H matrix generators = ",
                Length(family.matrixGenerators),
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
                "  family dimension = ",
                family.familyDimension,
                "\n"
            );
            CF_SPrint("  cubic invariant equation basis:\n");

            for j in [1 .. Length(family.cubicInvariantBasis)] do
                CF_SPrint(
                    "    basis[", j, "] = ",
                    family.cubicInvariantBasis[j],
                    "\n"
                );
            od;

            CF_SPrint(
                "  ------------------------------------------------------------\n"
            );
        fi;
    od;

    return rec(
        step3 := S3,
        options := options,
        externalTools := tools,
        externalGroebnerAvailable := externalReady,
        families := results
    );
end;


#############################################################################
# Reprint full data for all generically smooth and unknown S_4 families.
#############################################################################

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
            CF_SPrint("represented H^2 vectors = ",
                  result.mergedH2Vectors, "\n");
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
            for j in [1 .. Length(result.cubicInvariantBasis)] do
                CF_SPrint("  basis[", j, "] = ",
                      result.cubicInvariantBasis[j], "\n");
            od;
        fi;
    od;
end;


#############################################################################
# 9. BACKWARD-COMPATIBLE WRAPPERS AND STANDARD USAGE
#############################################################################

Step1_Schur3Part := S_1;

Step2_FindLinearLifts := function(gid, Kgens)
    local S1;

    S1 := S_1(gid, Kgens);
    return S_2(S1);
end;

Step3_CubicInvariantBasis := CF_CubicInvariantBasis;
Step3_AddCubicsToAllSolutions := S_3;
Step4_TestGenericSmoothness := S_4;


#############################################################################
# STANDARD FOUR-STEP WORKFLOW
#
#   Read("CubicFourfold_H2_Universal_S1_S2_S3_S4_nontrivial_det_bounded_ff_smoothness_v4.txt");;
#
#   S1 := S_1(gid, Kgens);;
#   S2 := S_2(S1);;   # automatically excludes det|_H = 1
#   S3 := S_3(S2);;
#   S4 := S_4(S3);;
#
# Conservative default: at most 2 external prime batches per family, each
# testing up to 10 members and forcibly killed after 4 seconds.  A stricter
# budget is, for example,
#
#   S4 := S_4(S3, rec(
#       maxSmoothTrials := 1,
#       maxMembersPerPrime := 6,
#       groebnerTimeoutSeconds := 2,
#       maxCommonPointSupport := 2,
#       maxCommonPointChecks := 200
#   ));;
#
# A somewhat stronger, still bounded run is
#
#   S4 := S_4(S3, rec(
#       maxSmoothTrials := 4,
#       maxMembersPerPrime := 16,
#       maxSplitPrimes := 6,
#       maxPrime := 5000,
#       groebnerTimeoutSeconds := 8,
#       maxCommonPointSupport := 4,
#       maxCommonPointChecks := 2000
#   ));;
#############################################################################

#############################################################################
# AUDIT PATCH FOR
# CubicFourfold_H2_Universal_S1_S2_S3_S4_nonliftable_Kplus_dimension_v7.txt
#
# Load the original v7 file first, then Read this patch.
#
# Changes:
#   1. Allow K0 to be symplectic or non-symplectic.  Internally use
#      Kplus=<K0,mu_3>, exactly as in the original non-liftable program.
#   2. Enumerate every nonzero labelled H^2 vector; do not identify v with -v.
#   3. Preserve all Kplus alignments until the determinant-kernel containment
#      test.
#   4. Require Ker(det|H) <= aligned Kplus, equivalently every element of H
#      outside Kplus is non-symplectic.  Equality is recorded but not required.
#   5. Replace bounded random intertwiner search by an exact deterministic
#      witness search.
#   6. Do not silently discard a character when GAP fails to construct an
#      irreducible representation; use fallbacks and stop on genuine failure.
#   7. Deduplicate only at the end by the full Aut(H)-orbit of the faithful
#      character multiplicity vector.
#   8. S_3 discards negative-dimensional families before printing/storing.
#   9. S_4 uses unambiguous witness markers, strict process-completion checks,
#      and an independent one-member verification of every reported witness.
#############################################################################

if not IsBound(CF_PrepareInputMatrixGroup)
   or not IsBound(S_1)
   or not IsBound(S_2)
   or not IsBound(S_3)
   or not IsBound(S_4) then
    Error(
        "Load CubicFourfold_H2_Universal_S1_S2_S3_S4_",
        "nonliftable_Kplus_dimension_v7.txt before this patch."
    );
fi;

if not IsBound(CF_NL_V7_OriginalPrepareInputMatrixGroup) then
    CF_NL_V7_OriginalPrepareInputMatrixGroup := CF_PrepareInputMatrixGroup;
fi;

if not IsBound(CF_NL_V7_OriginalS1) then
    CF_NL_V7_OriginalS1 := S_1;
fi;

#############################################################################
# 1. AUDITED INPUT SEMANTICS: K0 MAY BE NON-SYMPLECTIC
#############################################################################

CF_PrepareInputMatrixGroup := function(Kgens)
    local data;

    data := CF_NL_V7_OriginalPrepareInputMatrixGroup(Kgens);

    # K0 is deliberately allowed to contain determinant-nontrivial elements.
    # The classification condition is imposed later on the full lift H:
    # Ker(det|H) must be contained in the aligned Kplus=<K0,mu_3>.
    data.inputKMayBeNonSymplectic := true;
    data.strictExactSymplecticKernelRequired := false;
    data.outsideKNonSymplecticConditionRequired := true;
    return data;
end;


S_1 := function(gid, Kgens)
    local S1, expectedStemVectorCount;

    S1 := CF_NL_V7_OriginalS1(gid, Kgens);

    if IsBound(S1.CohomologyDimensionCheckPassed)
       and not S1.CohomologyDimensionCheckPassed then
        Error(
            "The H^2 dimension does not match the universal-coefficient ",
            "dimension check.  Completeness cannot be certified."
        );
    fi;

    if S1.H2Dimension
       <> S1.HomMultiplierDimension + S1.ExtAbelianizationDimension then
        Error(
            "The H^2 dimension does not match the universal-coefficient ",
            "dimension check.  Completeness cannot be certified."
        );
    fi;

    expectedStemVectorCount :=
        (3 ^ S1.HomMultiplierDimension - 1)
        * 3 ^ S1.ExtAbelianizationDimension;

    S1.ExpectedStemClassCount := expectedStemVectorCount;
    S1.ExpectedStemVectorCount := expectedStemVectorCount;
    S1.LegacyExpectedStemLineCount := S1.ExpectedStemLineCount;
    S1.ExpectedStemLineCount := expectedStemVectorCount;
    S1.kernelInversionReductionUsed := false;

    CF_SPrint(
        "AUDITED OVERRIDE: all nonzero labelled H^2 vectors are retained; ",
        "v and -v are not identified before final Aut(H) deduplication.\n"
    );
    CF_SPrint(
        "Expected labelled C3-stem vectors = ",
        expectedStemVectorCount,
        ".\n"
    );
    CF_SPrint(
        "K0 may be symplectic or non-symplectic.  The retained-lift ",
        "condition is Ker(det|H) <= Kplus=<K0,mu_3>.\n"
    );

    return S1;
end;

#############################################################################
# 2. EXACT DETERMINISTIC INTERTWINER WITNESS
#############################################################################

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
                    newBoundary := reachesBoundary
                        or AbsInt(value) = level;
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

        if DimensionsMat(B) <> [n, n]
           or DimensionsMat(A) <> [n, n] then
            Error(
                "Intertwiner input matrices have incompatible dimensions."
            );
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
            "but the exact intertwiner space is zero."
        );
    fi;

    P := CF_FindInvertibleCombination(basis, n);

    if P = fail then
        Error(
            "Internal error: an equivalent-module intertwiner space did not ",
            "yield an invertible matrix."
        );
    fi;

    for t in [1 .. Length(Bgens)] do
        if Bgens[t] * P <> P * Agens[t] then
            Error(
                "Internal error: the computed intertwiner does not ",
                "intertwine."
            );
        fi;
    od;

    return P;
end;

#############################################################################
# 3. REPRESENTATION CONSTRUCTION WITH NON-SILENT FALLBACKS
#############################################################################

CF_BlockImageOfComponents := function(componentMaps, element)
    return CF_BlockDiagonalMatrixList(
        List(componentMaps, rep -> Image(rep, element))
    );
end;


CF_BuildMatrixRepresentation := function(H, irrH, multiplicities, repCache)
    local componentMaps, i, j, rep, hgens, matrices, imageGroup,
          candidate;

    componentMaps := [];

    for i in [1 .. Length(irrH)] do
        if multiplicities[i] > 0 then
            if repCache.byIndex[i] = fail then
                rep := IrreducibleRepresentationsDixon(H, irrH[i]);

                if rep = fail then
                    if repCache.allRepresentations = fail then
                        repCache.allRepresentations :=
                            IrreducibleRepresentations(H);

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
                        "GAP could not construct an irreducible ",
                        "representation affording a required character.  ",
                        "The candidate is not silently discarded."
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
    imageGroup := Group(matrices);

    return rec(
        componentMaps := componentMaps,
        generators := hgens,
        matrices := matrices,
        imageGroup := imageGroup
    );
end;

#############################################################################
# 4. KEEP ALL KPLUS ALIGNMENTS UNTIL KERNEL CONTAINMENT IS KNOWN
#############################################################################

CF_SolutionsForOneExtension := function(S1, ext)
    local H, z, irrH, tblH, classesH, posz, scalar, eligible,
          preimageRecord, targetRecords, candidates, c,
          characterCandidates, existing, alignment, repCache, built,
          chiH, determinantCharacter, symplecticKernel,
          compatibleAlignments, rejectedAlignmentCount,
          charCandidate, centralImage, scalarElements, chosenAlignment,
          Bgens, P, Pinv, alignedMatrices, alignedGroup, rhoAligned,
          hgens, determinantValues, answer, i, generatorIndex,
          faithfulCharacterCount, kernelCompatibleCharacterCount,
          totalAlignmentCount;

    H := ext.H;
    z := ext.centralGenerator;
    irrH := Irr(H);
    tblH := UnderlyingCharacterTable(irrH[1]);
    classesH := ConjugacyClasses(tblH);
    posz := PositionProperty(classesH, C -> z in C);

    if posz = fail then
        Error(
            "Could not locate the central generator in table-ordered ",
            "classes."
        );
    fi;

    characterCandidates := [];

    for scalar in [E(3), E(3)^2] do
        eligible := Filtered(
            [1 .. Length(irrH)],
            i -> DegreeOfCharacter(irrH[i]) <= 6
                 and irrH[i][posz]
                     = scalar * DegreeOfCharacter(irrH[i])
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
                    targetRecords[1].baseEmbedding,
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
                        Add(
                            characterCandidates[existing].alignments,
                            alignment
                        );
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
    rejectedAlignmentCount := 0;
    faithfulCharacterCount := 0;
    kernelCompatibleCharacterCount := 0;

    for charCandidate in characterCandidates do
        chiH := CF_CharacterFromMultiplicities(
            irrH,
            charCandidate.multiplicities
        );

        if DegreeOfCharacter(chiH) <> 6 then
            Error(
                "Internal error: a candidate character does not have ",
                "degree 6."
            );
        fi;

        if Size(KernelOfCharacter(chiH)) = 1 then
            faithfulCharacterCount := faithfulCharacterCount + 1;
            determinantCharacter := DeterminantOfCharacter(chiH);
            symplecticKernel := KernelOfCharacter(determinantCharacter);

            compatibleAlignments := Filtered(
                charCandidate.alignments,
                a -> IsSubgroup(
                    Image(a.targetRecord.alignedEmbedding),
                    symplecticKernel
                )
            );

            rejectedAlignmentCount := rejectedAlignmentCount
                + Length(charCandidate.alignments)
                - Length(compatibleAlignments);

            if Length(compatibleAlignments) > 0 then
                kernelCompatibleCharacterCount :=
                    kernelCompatibleCharacterCount + 1;

                built := CF_BuildMatrixRepresentation(
                    H,
                    irrH,
                    charCandidate.multiplicities,
                    repCache
                );

                if Size(built.imageGroup) <> Size(H) then
                    Error(
                        "A character proved faithful, but the constructed ",
                        "matrix image has smaller order."
                    );
                fi;

                centralImage := CF_BlockImageOfComponents(
                    built.componentMaps,
                    z
                );
                scalarElements := Filtered(
                    Elements(Centre(built.imageGroup)),
                    CF_IsScalarMatrix
                );

                if Length(scalarElements) = 3
                   and CF_IsScalarWithValue(
                       centralImage,
                       charCandidate.scalar
                   ) then

                    chosenAlignment := fail;

                    for alignment in compatibleAlignments do
                        Bgens := List(
                            S1.input.generators,
                            k -> CF_BlockImageOfComponents(
                                built.componentMaps,
                                Image(
                                    alignment.targetRecord.alignedEmbedding,
                                    k
                                )
                            )
                        );

                        P := CF_Intertwiner(
                            Bgens,
                            S1.input.generatorMatrices
                        );
                        Pinv := P^-1;

                        for generatorIndex in [1 .. Length(Bgens)] do
                            if Pinv * Bgens[generatorIndex] * P
                               <> S1.input.generatorMatrices[
                                   generatorIndex
                               ] then
                                Error(
                                    "Internal error: an aligned Kplus ",
                                    "generator does not equal the fixed ",
                                    "input generator."
                                );
                            fi;
                        od;

                        alignedMatrices := List(
                            built.matrices,
                            A -> Pinv * A * P
                        );
                        alignedGroup := Group(alignedMatrices);

                        if not IsSubgroup(
                            alignedGroup,
                            S1.input.Kmatrix
                        ) then
                            Error(
                                "The aligned matrix image does not contain ",
                                "the fixed Kplus matrix subgroup."
                            );
                        fi;

                        hgens := built.generators;
                        rhoAligned := GroupHomomorphismByImages(
                            H,
                            alignedGroup,
                            hgens,
                            alignedMatrices
                        );

                        if rhoAligned = fail then
                            Error(
                                "Could not build the aligned faithful ",
                                "representation map."
                            );
                        fi;

                        if Size(alignedGroup) <> Size(H) then
                            Error(
                                "The aligned representation is not faithful."
                            );
                        fi;

                        determinantValues := List(
                            alignedMatrices,
                            DeterminantMat
                        );

                        Add(
                            answer,
                            rec(
                                H2Vector := ShallowCopy(ext.H2Vector),
                                ExtVector := ShallowCopy(ext.H2Vector),
                                HId := ext.HId,
                                H := H,
                                quotientMap := ext.quotientMap,
                                centralKernel := ext.centralKernel,
                                centralGenerator :=
                                    ext.centralGenerator,
                                HGenerators := hgens,
                                character := chiH,
                                multiplicities :=
                                    charCandidate.multiplicities,
                                centralizerDimensionByCharacter :=
                                    Sum(
                                        charCandidate.multiplicities,
                                        m -> m * m
                                    ),
                                centralScalar :=
                                    charCandidate.scalar,
                                representation := rhoAligned,
                                matrixGenerators :=
                                    alignedMatrices,
                                matrixImage := alignedGroup,
                                matrixImageOrder := Size(alignedGroup),
                                intertwiner := P,
                                KEmbedding :=
                                    alignment.targetRecord.alignedEmbedding,
                                alignedKplusSubgroup := Image(
                                    alignment.targetRecord.alignedEmbedding
                                ),
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
                                symplecticKernel :=
                                    symplecticKernel,
                                symplecticKernelOrder :=
                                    Size(symplecticKernel),
                                symplecticKernelContainedInInputKMu3 :=
                                    true,
                                symplecticKernelContainedInInputK :=
                                    true,
                                symplecticKernelEqualsInputKMu3 :=
                                    CF_SameSubgroup(
                                        Image(
                                            alignment.targetRecord.alignedEmbedding
                                        ),
                                        symplecticKernel
                                    ),
                                symplecticKernelEqualsInputK :=
                                    CF_SameSubgroup(
                                        Image(
                                            alignment.targetRecord.alignedEmbedding
                                        ),
                                        symplecticKernel
                                    ),
                                allElementsOutsideInputKMu3AreNonsymplectic :=
                                    true,
                                allElementsOutsideInputKAreNonsymplectic :=
                                    true,
                                retainedKernelCompatibleAlignmentCount :=
                                    Length(compatibleAlignments)
                            )
                        );

                        chosenAlignment := alignment;
                        break;
                    od;

                    if chosenAlignment = fail then
                        Error(
                            "A kernel-compatible character had no ",
                            "usable Kplus alignment."
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
        outsideKSymplecticRejectedAlignmentCount :=
            rejectedAlignmentCount,
        kernelCompatibleCharacterCount :=
            kernelCompatibleCharacterCount,
        # Backward-compatible aliases for scripts written against the first
        # audited draft.  These now refer to containment, not equality.
        exactKernelRejectedAlignmentCount :=
            rejectedAlignmentCount,
        exactKernelCompatibleCharacterCount :=
            kernelCompatibleCharacterCount
    );
end;

#############################################################################
# 5. INDEPENDENT OUTSIDE-KPLUS NON-SYMPLECTIC AUDIT
#############################################################################

CF_AttachOutsideKSymplecticData := function(sol)
    local H, generators, determinantValues, determinantMatrices,
          determinantImage, determinantMap, symplecticKernel,
          abstractKplus, kernelContainedInKplus, kernelEqualsKplus;

    H := sol.H;
    generators := sol.HGenerators;
    abstractKplus := Image(sol.KEmbedding);

    determinantValues := List(sol.matrixGenerators, DeterminantMat);
    determinantMatrices := List(determinantValues, d -> [[d]]);
    determinantImage := Group(determinantMatrices);

    determinantMap := GroupHomomorphismByImages(
        H,
        determinantImage,
        generators,
        determinantMatrices
    );

    if determinantMap = fail then
        Error("Could not construct the determinant homomorphism of H.");
    fi;

    symplecticKernel := Kernel(determinantMap);
    kernelContainedInKplus := IsSubgroup(
        abstractKplus,
        symplecticKernel
    );
    kernelEqualsKplus := CF_SameSubgroup(
        abstractKplus,
        symplecticKernel
    );

    sol.determinantGeneratorValues := determinantValues;
    sol.determinantImageOrder := Size(determinantImage);
    sol.determinantIsTrivial := Size(symplecticKernel) = Size(H);
    sol.wholeProjectiveGroupSymplectic := sol.determinantIsTrivial;
    sol.symplecticKernel := symplecticKernel;
    sol.symplecticKernelOrder := Size(symplecticKernel);
    sol.symplecticKernelContainedInInputKMu3 :=
        kernelContainedInKplus;
    sol.symplecticKernelContainedInInputK :=
        kernelContainedInKplus;
    sol.symplecticKernelEqualsInputKMu3 := kernelEqualsKplus;
    sol.symplecticKernelEqualsInputK := kernelEqualsKplus;
    sol.allElementsOutsideInputKMu3AreNonsymplectic :=
        kernelContainedInKplus;
    sol.allElementsOutsideInputKAreNonsymplectic :=
        kernelContainedInKplus;

    return sol;
end;


CF_AcceptOutsideKNonSymplecticSolution := function(sol)
    CF_AttachOutsideKSymplecticData(sol);
    return sol.symplecticKernelContainedInInputKMu3;
end;

#############################################################################
# 6. FULL LABELLED H^2 ENUMERATION
#############################################################################

CF_ForEachNonzeroH2Vector := function(d, callback)
    local v, stopped, search;

    if d = 0 then
        return false;
    fi;

    v := List([1 .. d], i -> 0);
    stopped := false;

    search := function(pos)
        local a;

        if stopped then
            return;
        fi;

        if pos > d then
            if ForAny(v, a -> a <> 0) then
                if callback(ShallowCopy(v)) = true then
                    stopped := true;
                fi;
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

#############################################################################
# 7. CACHED FULL Aut(H) CHARACTER-ORBIT DEDUPLICATION
#############################################################################

CF_ApplyIndexPermutationToMultiplicityVector := function(vec, indexImages)
    local answer, i;

    answer := List([1 .. Length(vec)], i -> 0);

    for i in [1 .. Length(vec)] do
        answer[indexImages[i]] := vec[i];
    od;

    return answer;
end;


CF_FastDedupGroupCache := function(sol, groupCaches)
    local pid, pos, Gstd, tbl, irr, autG, autGens,
          irreducibleActions, alpha, action, i, twisted, imageIndex;

    pid := sol.HId;

    if pid = fail then
        if not IdGroupsAvailable(Size(sol.H)) then
            return fail;
        fi;
        pid := IdGroup(sol.H);
        sol.HId := pid;
    fi;

    pos := PositionProperty(groupCaches, r -> r.groupId = pid);
    if pos <> fail then
        return groupCaches[pos];
    fi;

    CF_SPrint(
        "  exact dedup: preparing SmallGroup(",
        pid[1],
        ",",
        pid[2],
        ") and the full Aut(H)-action on Irr(H)...\n"
    );

    Gstd := SmallGroup(pid[1], pid[2]);
    tbl := CharacterTable(Gstd);
    irr := Irr(Gstd);
    autG := AutomorphismGroup(Gstd);
    autGens := GeneratorsOfGroup(autG);
    irreducibleActions := [];

    for alpha in autGens do
        action := [];

        for i in [1 .. Length(irr)] do
            twisted := RestrictedClassFunction(irr[i], alpha);
            twisted := CF_RebaseClassFunction(twisted, tbl);
            imageIndex := Position(irr, twisted);

            if imageIndex = fail then
                Error(
                    "An automorphism did not permute Irr(H) as expected."
                );
            fi;

            Add(action, imageIndex);
        od;

        Add(irreducibleActions, action);
    od;

    Add(
        groupCaches,
        rec(
            groupId := pid,
            group := Gstd,
            table := tbl,
            irreducibles := irr,
            automorphismGroup := autG,
            irreducibleActions := irreducibleActions,
            cachedVectors := [],
            cachedKeys := []
        )
    );

    return groupCaches[Length(groupCaches)];
end;


CF_FastDedupSourceCache := function(sol, groupCache, sourceCaches)
    local pos, isoStdToSource, sourceIrr, sourceToStandard,
          i, transported, imageIndex;

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
            "SmallGroup representative during exact deduplication."
        );
    fi;

    sourceIrr := Irr(sol.H);
    sourceToStandard := [];

    for i in [1 .. Length(sourceIrr)] do
        transported := RestrictedClassFunction(
            sourceIrr[i],
            isoStdToSource
        );
        transported := CF_RebaseClassFunction(
            transported,
            groupCache.table
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
            "exact deduplication."
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


CF_DeduplicateConjugateMatrixImages := function(rawSolutions)
    local kept, keptKeys, groupCaches, sourceCaches, total, counter,
          progressStep, sol, groupCache, sourceCache, standardVector,
          orbitKey, fullKey, pos;

    kept := [];
    keptKeys := [];
    groupCaches := [];
    sourceCaches := [];
    total := Length(rawSolutions);

    if total = 0 then
        return [];
    fi;

    CF_SPrint(
        "Exact unmarked GL(6)-conjugacy deduplication by full ",
        "Aut(H)-orbits of faithful character multiplicities...\n"
    );

    progressStep := Maximum(1, QuoInt(total, 20));
    counter := 0;

    for sol in rawSolutions do
        counter := counter + 1;
        groupCache := CF_FastDedupGroupCache(sol, groupCaches);

        if groupCache = fail then
            standardVector := [];
            fullKey := Concatenation("NO_ID:", String(counter));
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
            orbitKey := CF_CanonicalMultiplicityOrbitKey(
                standardVector,
                groupCache
            );
            fullKey := Concatenation(
                String(groupCache.groupId),
                ":AUT:",
                orbitKey
            );
        fi;

        pos := Position(keptKeys, fullKey);

        if pos = fail then
            sol.matrixImageData := rec(
                fastCharacterOrbitKey := fullKey,
                deduplicationMode := "full Aut(H) character orbit",
                standardMultiplicityVector :=
                    ShallowCopy(standardVector)
            );
            sol.mergedExtVectors := [ShallowCopy(sol.ExtVector)];
            sol.mergedH2Vectors := sol.mergedExtVectors;
            sol.mergedRawSolutionCount := 1;

            Add(kept, sol);
            Add(keptKeys, fullKey);
        else
            if Position(
                kept[pos].mergedExtVectors,
                sol.ExtVector
            ) = fail then
                Add(
                    kept[pos].mergedExtVectors,
                    ShallowCopy(sol.ExtVector)
                );
            fi;

            kept[pos].mergedH2Vectors :=
                kept[pos].mergedExtVectors;
            kept[pos].mergedRawSolutionCount :=
                kept[pos].mergedRawSolutionCount + 1;
        fi;

        if counter mod progressStep = 0 or counter = total then
            CF_SPrint(
                "  exact dedup progress ",
                counter,
                "/",
                total,
                "; classes so far=",
                Length(kept),
                "\n"
            );
        fi;
    od;

    return kept;
end;

#############################################################################
# 8. AUDITED S_2
#############################################################################

S_2 := function(arg)
    local S1, targetHIds, totalVectorCount, progressStep, processed,
          stemCount, compatibleStemCount, stemH2Vectors,
          compatibleH2Vectors, solutionExtensions, rawSolutions,
          rawSolutionsBeforeOutsideKFilter,
          outsideKSymplecticRejectedRawCount, processVector, solutions;

    if Length(arg) < 1 or Length(arg) > 2 then
        Error("Use S_2(S1) or S_2(S1, [[order,id],...]).");
    fi;

    S1 := arg[1];
    targetHIds := [];

    if Length(arg) = 2 then
        targetHIds := arg[2];
        if not IsList(targetHIds) then
            Error(
                "The optional second argument must be a list of ",
                "SmallGroup IDs."
            );
        fi;
    fi;

    if not IsRecord(S1) or not IsBound(S1.H2Dimension) then
        Error("S_2 expects the audited record returned by S_1.");
    fi;

    CF_SPrint("\n============================================================\n");
    CF_SPrint("S_2: AUDITED LABELLED STEM H^2 VECTORS AND EXACT LIFTS\n");
    CF_SPrint("============================================================\n");
    CF_SPrint(
        "No v~-v identification is made before final full Aut(H) ",
        "deduplication.\n"
    );
    CF_SPrint(
        "All Kplus alignments are retained until ",
        "Ker(det|H) <= Kplus is checked.\n"
    );

    if Length(targetHIds) > 0 then
        CF_SPrint("target middle-group IDs = ", targetHIds, "\n");
    fi;

    if Length(S1.multiplier3Invariants) = 0 then
        CF_SPrint(
            "The multiplier 3-part is trivial, so there are no ",
            "C3-stem classes.\n"
        );
        return rec(
            step1 := S1,
            H2VectorCount := 0,
            H2LineRepresentativeCount := 0,
            stemClassCount := 0,
            compatibleStemClassCount := 0,
            stemH2Vectors := [],
            compatibleH2Vectors := [],
            solutionExtensions := [],
            rawSolutionsBeforeOutsideKFilter := [],
            rawSolutions := [],
            solutions := []
        );
    fi;

    if Length(S1.normalKbarSubgroups) = 0 then
        CF_SPrint("There is no normal copy of Kplus/mu_3 in G.\n");
        return rec(
            step1 := S1,
            H2VectorCount := 0,
            H2LineRepresentativeCount := 0,
            stemClassCount := 0,
            compatibleStemClassCount := 0,
            stemH2Vectors := [],
            compatibleH2Vectors := [],
            solutionExtensions := [],
            rawSolutionsBeforeOutsideKFilter := [],
            rawSolutions := [],
            solutions := []
        );
    fi;

    totalVectorCount := 3 ^ S1.H2Dimension - 1;
    progressStep := Maximum(1, QuoInt(totalVectorCount, 100));
    processed := 0;
    stemCount := 0;
    compatibleStemCount := 0;
    stemH2Vectors := [];
    compatibleH2Vectors := [];
    solutionExtensions := [];
    rawSolutions := [];

    CF_SPrint(
        "Nonzero labelled H^2 vectors to construct = ",
        totalVectorCount,
        "\n"
    );

    processVector := function(vec)
        local extLocal, searchResult, localSolutionsLocal, solLocal;

        processed := processed + 1;

        if processed = 1
           or processed mod progressStep = 0
           or processed = totalVectorCount then
            CF_SPrint(
                "  H^2 progress ",
                processed,
                "/",
                totalVectorCount,
                "; stem=",
                stemCount,
                "; K-compatible=",
                compatibleStemCount,
                "; kernel-compatible solutions=",
                Length(rawSolutions),
                "\n"
            );
        fi;

        extLocal := CF_OneH2Extension(S1, vec);

        if not extLocal.isStem then
            return false;
        fi;

        stemCount := stemCount + 1;
        Add(stemH2Vectors, ShallowCopy(vec));

        CF_AttachKPreimages(extLocal, S1);

        if Length(extLocal.preimageData) = 0 then
            return false;
        fi;

        compatibleStemCount := compatibleStemCount + 1;
        Add(compatibleH2Vectors, ShallowCopy(vec));

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
                return false;
            fi;
        fi;

        CF_SPrint(
            "    compatible labelled H^2 vector ",
            vec,
            ": computing exact degree-6 character restrictions...\n"
        );

        searchResult := CF_SolutionsForOneExtension(S1, extLocal);
        localSolutionsLocal := searchResult.solutions;

        CF_SPrint(
            "    alignments before determinant-kernel containment = ",
            searchResult.totalAlignmentCount,
            "; rejected by containment test = ",
            searchResult.outsideKSymplecticRejectedAlignmentCount,
            "; retained faithful character images = ",
            Length(localSolutionsLocal),
            "\n"
        );

        if Length(localSolutionsLocal) = 0 then
            return false;
        fi;

        if extLocal.HId = fail and IdGroupsAvailable(Size(extLocal.H)) then
            extLocal.HId := IdGroup(extLocal.H);
        fi;

        for solLocal in localSolutionsLocal do
            solLocal.HId := extLocal.HId;
            solLocal.ExtVector := ShallowCopy(vec);
            solLocal.H2Vector := ShallowCopy(vec);
        od;

        Add(solutionExtensions, extLocal);
        Append(rawSolutions, localSolutionsLocal);

        if extLocal.HId = fail then
            CF_SPrint(
                "    surviving extension |H|=",
                Size(extLocal.H),
                "; kernel-compatible solutions=",
                Length(localSolutionsLocal),
                "\n"
            );
        else
            CF_SPrint(
                "    surviving extension H=SmallGroup(",
                extLocal.HId[1],
                ",",
                extLocal.HId[2],
                "); kernel-compatible solutions=",
                Length(localSolutionsLocal),
                "\n"
            );
        fi;

        return false;
    end;

    CF_ForEachNonzeroH2Vector(S1.H2Dimension, processVector);

    CF_SPrint("\nLabelled H^2 vectors processed = ", processed, "\n");
    CF_SPrint("Labelled C3-stem vectors retained = ", stemCount, "\n");
    CF_SPrint(
        "Stem vectors with a compatible Kplus preimage = ",
        compatibleStemCount,
        "\n"
    );

    if processed <> totalVectorCount then
        Error("Not all nonzero labelled H^2 vectors were processed.");
    fi;

    if stemCount <> S1.ExpectedStemVectorCount then
        Error(
            "The intrinsic labelled stem-vector count differs from the ",
            "universal-coefficient prediction ",
            S1.ExpectedStemVectorCount,
            "."
        );
    fi;

    rawSolutionsBeforeOutsideKFilter := ShallowCopy(rawSolutions);
    rawSolutions := Filtered(
        rawSolutionsBeforeOutsideKFilter,
        CF_AcceptOutsideKNonSymplecticSolution
    );
    outsideKSymplecticRejectedRawCount :=
        Length(rawSolutionsBeforeOutsideKFilter)
        - Length(rawSolutions);

    if outsideKSymplecticRejectedRawCount <> 0 then
        Error(
            "Internal audit failure: a solution passed the early kernel-",
            "containment test but failed the independent determinant audit."
        );
    fi;

    CF_SPrint(
        "Faithful matrix solutions satisfying ",
        "Ker(det|H) <= Kplus before GL(6) dedup = ",
        Length(rawSolutions),
        "\n"
    );

    solutions := CF_DeduplicateConjugateMatrixImages(rawSolutions);

    CF_SPrint(
        "Exact unmarked GL(6)-conjugacy classes satisfying ",
        "Ker(det|H) <= Kplus = ",
        Length(solutions),
        "\n"
    );

    return rec(
        step1 := S1,
        labelledH2Enumeration := true,
        kernelInversionReductionUsed := false,
        H2VectorCount := processed,
        H2LineRepresentativeCount := processed,
        stemClassCount := stemCount,
        compatibleStemClassCount := compatibleStemCount,
        stemH2Vectors := stemH2Vectors,
        compatibleH2Vectors := compatibleH2Vectors,
        solutionExtensions := solutionExtensions,
        rawSolutionsBeforeOutsideKFilter :=
            rawSolutionsBeforeOutsideKFilter,
        rawSolutionsBeforeDeterminantFilter :=
            rawSolutionsBeforeOutsideKFilter,
        outsideKSymplecticContainmentFilterMode :=
            "require Ker(det|H) <= <input K0,mu_3>",
        outsideKSymplecticFilterMode :=
            "require Ker(det|H) <= <input K0,mu_3>",
        determinantFilterMode :=
            "require Ker(det|H) <= <input K0,mu_3>",
        outsideKSymplecticRejectedRawCount :=
            outsideKSymplecticRejectedRawCount,
        determinantRejectedRawCount :=
            outsideKSymplecticRejectedRawCount,
        # Compatibility aliases from the equality-requiring draft.
        exactKernelRejectedRawCount :=
            outsideKSymplecticRejectedRawCount,
        rawSolutions := rawSolutions,
        solutions := solutions
    );
end;

#############################################################################
# 9. S_3 DROPS NEGATIVE-DIMENSIONAL FAMILIES
#############################################################################

S_3 := function(S2)
    local final, sol, cubic, centralizer, familyDimension, item,
          polynomial, i, discardedCount, GId;

    if not IsRecord(S2) or not IsBound(S2.solutions) then
        Error("S_3 expects the record returned by S_2.");
    fi;

    CF_SPrint("\n============================================================\n");
    CF_SPrint("S_3: STRICT CUBIC FAMILIES, NEGATIVE DIMENSIONS DISCARDED\n");
    CF_SPrint("============================================================\n");

    final := [];
    discardedCount := 0;
    GId := fail;

    if IsBound(S2.step1) and IsBound(S2.step1.quotientId) then
        GId := ShallowCopy(S2.step1.quotientId);
    fi;

    for i in [1 .. Length(S2.solutions)] do
        sol := S2.solutions[i];
        cubic := CF_CubicInvariantBasis(sol.matrixGenerators);
        centralizer := CF_CentralizerAlgebraBasis(sol.matrixGenerators);
        familyDimension :=
            cubic.invariantDimension - centralizer.dimension;

        if familyDimension < 0 then
            discardedCount := discardedCount + 1;
        else
            item := rec(
                solutionNumber := i,
                HId := sol.HId,
                H2Vector := sol.H2Vector,
                ExtVector := sol.H2Vector,
                mergedH2Vectors := sol.mergedH2Vectors,
                mergedExtVectors := sol.mergedH2Vectors,
                kernelDerivedIntersectionOrder := 3,
                isLiftableType := false,
                matrixGenerators := sol.matrixGenerators,
                matrixImageOrder := Size(sol.matrixImage),
                determinantGeneratorValues :=
                    sol.determinantGeneratorValues,
                determinantImageOrder :=
                    sol.determinantImageOrder,
                determinantIsTrivial :=
                    sol.determinantIsTrivial,
                symplecticKernelOrder :=
                    sol.symplecticKernelOrder,
                symplecticKernelContainedInInputKMu3 :=
                    sol.symplecticKernelContainedInInputKMu3,
                symplecticKernelContainedInInputK :=
                    sol.symplecticKernelContainedInInputK,
                symplecticKernelEqualsInputKMu3 :=
                    sol.symplecticKernelEqualsInputKMu3,
                symplecticKernelEqualsInputK :=
                    sol.symplecticKernelEqualsInputK,
                allElementsOutsideInputKMu3AreNonsymplectic :=
                    sol.allElementsOutsideInputKMu3AreNonsymplectic,
                allElementsOutsideInputKAreNonsymplectic :=
                    sol.allElementsOutsideInputKAreNonsymplectic,
                cubicMonomialExponents :=
                    cubic.monomialExponents,
                cubicInvariantBasisVectors :=
                    cubic.coefficientBasis,
                polynomialRing := cubic.polynomialRing,
                variables := cubic.variables,
                cubicInvariantBasis := cubic.polynomialBasis,
                cubicInvariantBasisStrings :=
                    cubic.polynomialStrings,
                cubicInvariantDimension :=
                    cubic.invariantDimension,
                centralizerBasis := centralizer.matrixBasis,
                centralizerDimension := centralizer.dimension,
                expectedModuliDimension := familyDimension,
                familyDimension := familyDimension
            );

            Add(final, item);

            CF_SPrint("\nRetained solution ", i, "\n");
            CF_SPrint("  H ID = ", sol.HId, "\n");
            CF_SPrint(
                "  represented labelled H^2 vectors = ",
                sol.mergedH2Vectors,
                "\n"
            );
            CF_SPrint(
                "  matrix image order = ",
                Size(sol.matrixImage),
                "\n"
            );
            CF_SPrint(
                "  Ker(det|H) equals <input K0,mu_3> = ",
                sol.symplecticKernelEqualsInputKMu3,
                "\n"
            );
            CF_SPrint(
                "  dim strict cubic invariants = ",
                cubic.invariantDimension,
                "\n"
            );
            CF_SPrint(
                "  dim matrix centralizer = ",
                centralizer.dimension,
                "\n"
            );
            CF_SPrint("  family dimension = ", familyDimension, "\n");
            CF_SPrint("  cubic invariant basis:\n");

            for polynomial in cubic.polynomialBasis do
                CF_SPrint("    ", polynomial, "\n");
            od;
        fi;
    od;

    CF_SPrint(
        "\nNegative-dimensional families discarded without storage = ",
        discardedCount,
        "\n"
    );
    CF_SPrint(
        "Nonnegative-dimensional families retained = ",
        Length(final),
        "\n"
    );

    return rec(
        GId := GId,
        step2 := S2,
        inputSolutionCount := Length(S2.solutions),
        negativeDimensionDiscardedCount := discardedCount,
        families := final
    );
end;

#############################################################################
# 10. STRICT S_4 WITNESS BINDING AND PROCESS AUDIT
#############################################################################

CF_S4_SingularBatchSmoothnessScript := function(
    memberRecords,
    exponentBasis,
    p
)
    local lines, memberIndex, derivatives, variableIndex, prefix;

    lines := [
        Concatenation(
            "ring r=",
            String(p),
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
                    "poly ",
                    prefix,
                    "d",
                    String(variableIndex),
                    "=",
                    derivatives[variableIndex],
                    ";"
                )
            );
        od;

        Add(
            lines,
            Concatenation(
                "ideal ",
                prefix,
                "J=",
                prefix,
                "d1,",
                prefix,
                "d2,",
                prefix,
                "d3,",
                prefix,
                "d4,",
                prefix,
                "d5,",
                prefix,
                "d6;"
            )
        );
        Add(
            lines,
            Concatenation(
                "ideal ",
                prefix,
                "B=std(",
                prefix,
                "J);"
            )
        );
        Add(
            lines,
            Concatenation("if (dim(", prefix, "B)==0)")
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


CF_S4_OutputHasErrorMarker := function(output)
    return PositionSublist(output, "? error occurred") <> fail
        or PositionSublist(output, "ERROR") <> fail
        or PositionSublist(output, "Error:") <> fail
        or PositionSublist(output, "error:") <> fail;
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
       and PositionSublist(
           output,
           "CF_SCRIPT_COMPLETED_OK"
       ) <> fail
       and PositionSublist(
           output,
           "CF_SMOOTH_MEMBER_"
       ) <> fail then
        return rec(
            status := "smooth",
            output := output,
            exitCode := exitCode
        );
    fi;

    if exitCode = 0
       and not outputHasError
       and PositionSublist(
           output,
           "CF_SCRIPT_COMPLETED_OK"
       ) <> fail
       and PositionSublist(
           output,
           "CF_NO_SMOOTH_MEMBER_END"
       ) <> fail then
        return rec(
            status := "no_smooth_in_batch",
            output := output,
            exitCode := exitCode
        );
    fi;

    if exitCode = 0
       and not outputHasError
       and PositionSublist(
           output,
           "CF_SCRIPT_COMPLETED_OK"
       ) <> fail then
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


CF_S4_TestCandidateBatchAtPrime := function(
    family,
    coefficientCandidates,
    conductor,
    p,
    tools,
    timeoutSeconds
)
    local memberRecords, script, run, witnessIndex,
          verificationScript, verificationRun;

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
            witnessVerifiedIndependently := false,
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

    witnessIndex := fail;

    if run.status = "smooth" then
        witnessIndex := CF_S4_FindSmoothMemberIndexInOutput(
            run.output,
            Length(memberRecords)
        );

        if witnessIndex = fail then
            Error(
                "Singular reported a smooth batch but no exact witness ",
                "marker could be parsed."
            );
        fi;

        verificationScript := CF_S4_SingularBatchSmoothnessScript(
            [memberRecords[witnessIndex]],
            family.cubicMonomialExponents,
            p
        );
        verificationRun := CF_S4_RunBoundedSingularScript(
            verificationScript,
            tools,
            timeoutSeconds
        );

        if verificationRun.status <> "smooth"
           or CF_S4_FindSmoothMemberIndexInOutput(
               verificationRun.output,
               1
           ) <> 1 then
            Error(
                "The selected smooth witness failed its independent ",
                "one-member Singular verification."
            );
        fi;

        run.witnessVerifiedIndependently := true;
        run.verificationOutput := verificationRun.output;
        run.verificationExitCode := verificationRun.exitCode;
    else
        run.witnessVerifiedIndependently := false;
    fi;

    run.prime := p;
    run.memberRecords := memberRecords;
    run.witnessIndex := witnessIndex;
    run.inputScript := script;

    return run;
end;

CF_SPrint("Loaded audited non-liftable v7 patch (K0 may be non-symplectic).\n");
CF_SPrint("Use the usual four steps S1, S2, S3, S4.\n");


#############################################################################
# NON-LIFTABLE LARGE-H EXACT CONJUGACY PATCH, VERSION 8.2.1
#
# Load this file AFTER:
#   CubicFourfold_H2_Universal_nonliftable_audited_K_arbitrary_v8_1.txt
#
# Problem repaired
# ----------------
# The old exact character-orbit deduplication required a SmallGroup ID.  If
# IdGroupsAvailable(Size(H)) was false, it assigned every solution a unique
# fallback key.  Thus no conjugate representations were merged for large H.
#
# This patch removes that fallback.  When no SmallGroup ID exists, it:
#   * groups extension groups by an exact IsomorphismGroups test;
#   * chooses one actual extension group as the canonical representative;
#   * computes Aut(H) and its induced permutation action on Irr(H);
#   * transports every source multiplicity vector to the canonical group;
#   * takes the full Aut(H)-orbit canonical key;
#   * merges across different labelled H^2 vectors whenever the resulting
#     faithful matrix images are GL(6)-conjugate.
#
# No expected number of classes is hard-coded.
#############################################################################

if not IsBound(CF_FastDedupGroupCache) then
    Error("Load the audited non-liftable v8.1 file before this patch.");
fi;

if not IsBound(CF_FastDedupSourceCache) then
    Error("The base file is missing CF_FastDedupSourceCache.");
fi;

if not IsBound(CF_StandardMultiplicityVector) then
    Error("The base file is missing CF_StandardMultiplicityVector.");
fi;

if not IsBound(CF_CanonicalMultiplicityOrbitKey) then
    Error("The base file is missing CF_CanonicalMultiplicityOrbitKey.");
fi;

if not IsBound(CF_NL_V81_FastDedupGroupCache) then
    CF_NL_V81_FastDedupGroupCache := CF_FastDedupGroupCache;
fi;


#############################################################################
# Character-table fusion helpers
#
# The audited non-liftable v8.1 base does not define these two helpers.
# They must be installed before the large-H Aut(H)-orbit routines are parsed
# and executed.  Define them conditionally to avoid changing a newer base.
#############################################################################

if not IsBound(CF_ClassPositionContainingElement) then
    CF_ClassPositionContainingElement := function(classes, element)
        return PositionProperty(classes, C -> element in C);
    end;
fi;

if not IsBound(CF_ClassFusionByImageFunction) then
    CF_ClassFusionByImageFunction := function(
        sourceTable,
        targetTable,
        imageFunction
    )
        local sourceClasses, targetClasses, fusion, C, image, pos;

        sourceClasses := ConjugacyClasses(sourceTable);
        targetClasses := ConjugacyClasses(targetTable);
        fusion := [];

        for C in sourceClasses do
            image := imageFunction(Representative(C));
            pos := CF_ClassPositionContainingElement(targetClasses, image);

            if pos = fail then
                Error(
                    "Could not locate an image in the target character-table ",
                    "classes."
                );
            fi;

            Add(fusion, pos);
        od;

        return fusion;
    end;
fi;

if not IsBound(CF_PullbackClassFunctionByFusion) then
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
fi;


#############################################################################
# Metadata helpers
#############################################################################

CF_NL_SolutionLabelVectors := function(sol)
    local answer, v;

    answer := [];

    if IsBound(sol.mergedH2Vectors) and IsList(sol.mergedH2Vectors) then
        for v in sol.mergedH2Vectors do
            if Position(answer, v) = fail then
                Add(answer, ShallowCopy(v));
            fi;
        od;
    fi;

    if IsBound(sol.mergedExtVectors) and IsList(sol.mergedExtVectors) then
        for v in sol.mergedExtVectors do
            if Position(answer, v) = fail then
                Add(answer, ShallowCopy(v));
            fi;
        od;
    fi;

    if IsBound(sol.H2Vector) then
        if Position(answer, sol.H2Vector) = fail then
            Add(answer, ShallowCopy(sol.H2Vector));
        fi;
    elif IsBound(sol.ExtVector) then
        if Position(answer, sol.ExtVector) = fail then
            Add(answer, ShallowCopy(sol.ExtVector));
        fi;
    fi;

    return answer;
end;


CF_NL_AppendUniqueVectors := function(target, source)
    local v;

    for v in source do
        if Position(target, v) = fail then
            Add(target, ShallowCopy(v));
        fi;
    od;
end;


#############################################################################
# Build the exact Aut(H) action for a cache whose canonical representative is
# an actual large extension group rather than a SmallGroup-library object.
#############################################################################

CF_NL_PrepareAutActionsForCache := function(cache, needAutomorphisms)
    local autH, autGens, actions, alpha, action, fusion,
          i, twisted, imageIndex;

    if needAutomorphisms <> true and needAutomorphisms <> false then
        Error("The deduplication automorphism flag must be boolean.");
    fi;

    if not IsBound(cache.automorphismsPrepared) then
        cache.automorphismsPrepared := false;
    fi;

    if not IsBound(cache.irreducibleActions) then
        cache.irreducibleActions := [];
    fi;

    if not IsBound(cache.cachedVectors) then
        cache.cachedVectors := [];
    fi;

    if not IsBound(cache.cachedKeys) then
        cache.cachedKeys := [];
    fi;

    if needAutomorphisms and not cache.automorphismsPrepared then
        CF_SPrint(
            "  large-H dedup: computing Aut(H)-action on Irr(H) for ",
            cache.cacheKey,
            "; |H|=", Size(cache.group), "...\n"
        );

        autH := AutomorphismGroup(cache.group);
        autGens := GeneratorsOfGroup(autH);
        actions := [];

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
                        "An automorphism of a large extension group did not ",
                        "permute Irr(H) as expected."
                    );
                fi;

                Add(action, imageIndex);
            od;

            if Position(actions, action) = fail then
                Add(actions, action);
            fi;
        od;

        cache.irreducibleActions := actions;
        cache.automorphismGeneratorCount := Length(autGens);
        cache.automorphismsPrepared := true;

        autH := fail;
        GASMAN("collect");

        CF_SPrint(
            "  large-H dedup: nonredundant induced Irr(H) actions = ",
            Length(actions), "\n"
        );
    fi;

    return cache;
end;


#############################################################################
# Exact isomorphism-type cache for groups without SmallGroup IDs.
#############################################################################

CF_NL_NoIdGroupCache := function(sol, groupCaches, needAutomorphisms)
    local cache, pos, sourcePos, iso, tbl, irr, noIdNumber;

    # First use object identity.  All solutions produced by one H^2 vector
    # normally share exactly the same H object, so this is the fast path.
    for pos in [1 .. Length(groupCaches)] do
        cache := groupCaches[pos];

        if IsBound(cache.groupId)
           and cache.groupId = fail
           and IsBound(cache.sourceRecords) then
            sourcePos := PositionProperty(
                cache.sourceRecords,
                r -> IsIdenticalObj(r.sourceGroup, sol.H)
            );

            if sourcePos <> fail then
                return CF_NL_PrepareAutActionsForCache(
                    cache,
                    needAutomorphisms
                );
            fi;
        fi;
    od;

    # Next compare exact abstract group isomorphism types.  This is the step
    # that allows v and -v, or two other labelled H^2 classes, to merge only
    # when their actual middle groups and characters justify it.
    for pos in [1 .. Length(groupCaches)] do
        cache := groupCaches[pos];

        if IsBound(cache.groupId)
           and cache.groupId = fail
           and Size(cache.group) = Size(sol.H) then
            CF_SPrint(
                "  large-H dedup: testing whether a new extension group is ",
                "isomorphic to ", cache.cacheKey, "...\n"
            );

            iso := IsomorphismGroups(cache.group, sol.H);

            if iso <> fail then
                Add(
                    cache.sourceRecords,
                    rec(
                        sourceGroup := sol.H,
                        isoCanonicalToSource := iso
                    )
                );

                return CF_NL_PrepareAutActionsForCache(
                    cache,
                    needAutomorphisms
                );
            fi;
        fi;
    od;

    # No existing isomorphism type matched.  The current H itself becomes an
    # exact canonical representative for this deduplication pass.
    noIdNumber := 1 + Length(
        Filtered(
            groupCaches,
            r -> IsBound(r.groupId) and r.groupId = fail
        )
    );

    tbl := CharacterTable(sol.H);
    irr := Irr(sol.H);

    cache := rec(
        groupId := fail,
        cacheKey := Concatenation(
            "NO_SMALLGROUP_ID_TYPE_",
            String(noIdNumber)
        ),
        group := sol.H,
        table := tbl,
        irreducibles := irr,
        automorphismsPrepared := false,
        automorphismGroup := fail,
        irreducibleActions := [],
        cachedVectors := [],
        cachedKeys := [],
        sourceRecords := [
            rec(
                sourceGroup := sol.H,
                isoCanonicalToSource := IdentityMapping(sol.H)
            )
        ]
    );

    Add(groupCaches, cache);

    CF_SPrint(
        "  large-H dedup: created exact no-ID isomorphism cache ",
        cache.cacheKey,
        "; |H|=", Size(sol.H),
        "; number of Irr(H)=", Length(irr), "\n"
    );

    return CF_NL_PrepareAutActionsForCache(cache, needAutomorphisms);
end;


#############################################################################
# Override the old cache function.  SmallGroup-library orders continue to use
# the original implementation.  Only its previous fail branch is replaced.
#############################################################################

CF_FastDedupGroupCache := function(sol, groupCaches, needAutomorphisms)
    local pid, pos, cache, Gstd, tbl, irr;

    if needAutomorphisms <> true and needAutomorphisms <> false then
        Error("The deduplication automorphism flag must be boolean.");
    fi;

    pid := sol.HId;

    if pid = fail and IdGroupsAvailable(Size(sol.H)) then
        pid := IdGroup(sol.H);
        sol.HId := pid;
    fi;

    if pid = fail then
        return CF_NL_NoIdGroupCache(
            sol,
            groupCaches,
            needAutomorphisms
        );
    fi;

    pos := PositionProperty(
        groupCaches,
        r -> IsBound(r.groupId) and r.groupId = pid
    );

    if pos = fail then
        CF_SPrint(
            "  dedup: preparing canonical SmallGroup(",
            pid[1], ",", pid[2], ") and Irr(H).\n"
        );

        Gstd := SmallGroup(pid[1], pid[2]);
        tbl := CharacterTable(Gstd);
        irr := Irr(Gstd);

        cache := rec(
            groupId := pid,
            cacheKey := Concatenation(
                "SMALLGROUP_",
                String(pid)
            ),
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
    return CF_NL_PrepareAutActionsForCache(cache, needAutomorphisms);
end;


#############################################################################
# Transport source Irr(H) to the selected canonical representative.  The
# source-to-canonical map is cached once for each actual H object.
#############################################################################

CF_NL_FastDedupSourceCache := function(sol, groupCache, sourceCaches)
    local pos, sourceRecordPos, isoCanonicalToSource, sourceIrr,
          sourceTable, sourceToStandard, fusion, i, transported, imageIndex;

    pos := PositionProperty(
        sourceCaches,
        r -> IsIdenticalObj(r.sourceGroup, sol.H)
             and IsIdenticalObj(r.groupCache, groupCache)
    );

    if pos <> fail then
        return sourceCaches[pos];
    fi;

    isoCanonicalToSource := fail;

    if IsBound(groupCache.sourceRecords) then
        sourceRecordPos := PositionProperty(
            groupCache.sourceRecords,
            r -> IsIdenticalObj(r.sourceGroup, sol.H)
        );

        if sourceRecordPos <> fail then
            isoCanonicalToSource :=
                groupCache.sourceRecords[sourceRecordPos].isoCanonicalToSource;
        fi;
    fi;

    if isoCanonicalToSource = fail then
        if IsIdenticalObj(groupCache.group, sol.H) then
            isoCanonicalToSource := IdentityMapping(sol.H);
        else
            isoCanonicalToSource := IsomorphismGroups(
                groupCache.group,
                sol.H
            );
        fi;
    fi;

    if isoCanonicalToSource = fail then
        Error(
            "Could not identify a source extension group with the exact ",
            "canonical isomorphism type during large-H deduplication."
        );
    fi;

    sourceIrr := Irr(sol.H);
    sourceTable := UnderlyingCharacterTable(sourceIrr[1]);
    fusion := CF_ClassFusionByImageFunction(
        groupCache.table,
        sourceTable,
        g -> Image(isoCanonicalToSource, g)
    );

    sourceToStandard := [];

    for i in [1 .. Length(sourceIrr)] do
        transported := CF_PullbackClassFunctionByFusion(
            sourceIrr[i],
            groupCache.table,
            fusion
        );
        imageIndex := Position(groupCache.irreducibles, transported);

        if imageIndex = fail then
            Error(
                "Could not match a source irreducible character with the ",
                "canonical large-H character table."
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


#############################################################################
# Exact deduplication for both SmallGroup-ID and no-ID middle groups.
#############################################################################

CF_DeduplicateConjugateMatrixImages := function(arg)
    local rawSolutions, groupCaches, dedupMode, needAutomorphisms,
          kept, keptKeys, sourceCaches, total, counter, progressStep,
          sol, groupCache, sourceCache, standardVector, orbitKey,
          fullKey, pos, vectorsToMerge, rawCountToMerge;

    if Length(arg) < 1 or Length(arg) > 3 then
        Error(
            "Use CF_DeduplicateConjugateMatrixImages(solutions), optionally ",
            "adding a shared cache and a deduplication mode."
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
            "Exact unmarked GL(6)-conjugacy deduplication, including ",
            "large H without SmallGroup IDs...\n"
        );
    else
        CF_SPrint(
            "Conservative identical-character deduplication, including ",
            "large H without SmallGroup IDs.\n"
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

        sourceCache := CF_NL_FastDedupSourceCache(
            sol,
            groupCache,
            sourceCaches
        );

        standardVector := CF_StandardMultiplicityVector(sol, sourceCache);

        if needAutomorphisms then
            orbitKey := CF_CanonicalMultiplicityOrbitKey(
                standardVector,
                groupCache
            );
            fullKey := Concatenation(
                groupCache.cacheKey,
                ":AUT:",
                orbitKey
            );
        else
            fullKey := Concatenation(
                groupCache.cacheKey,
                ":CHAR:",
                String(standardVector)
            );
        fi;

        pos := Position(keptKeys, fullKey);
        vectorsToMerge := CF_NL_SolutionLabelVectors(sol);

        if IsBound(sol.mergedRawSolutionCount) then
            rawCountToMerge := sol.mergedRawSolutionCount;
        else
            rawCountToMerge := 1;
        fi;

        if pos = fail then
            if not IsBound(sol.matrixImageData)
               or not IsRecord(sol.matrixImageData) then
                sol.matrixImageData := rec();
            fi;

            sol.matrixImageData.fastCharacterOrbitKey := fullKey;
            sol.matrixImageData.standardMultiplicityVector :=
                ShallowCopy(standardVector);
            sol.matrixImageData.abstractIsomorphismTypeKey :=
                groupCache.cacheKey;

            sol.mergedH2Vectors := [];
            CF_NL_AppendUniqueVectors(
                sol.mergedH2Vectors,
                vectorsToMerge
            );
            sol.mergedExtVectors := List(
                sol.mergedH2Vectors,
                ShallowCopy
            );
            sol.mergedRawSolutionCount := rawCountToMerge;

            Add(kept, sol);
            Add(keptKeys, fullKey);
        else
            CF_NL_AppendUniqueVectors(
                kept[pos].mergedH2Vectors,
                vectorsToMerge
            );
            kept[pos].mergedExtVectors := List(
                kept[pos].mergedH2Vectors,
                ShallowCopy
            );
            kept[pos].mergedRawSolutionCount :=
                kept[pos].mergedRawSolutionCount + rawCountToMerge;
        fi;

        if counter mod progressStep = 0 or counter = total then
            CF_SPrint(
                "  exact large-H-aware dedup progress ",
                counter, "/", total,
                "; classes so far=", Length(kept), "\n"
            );
        fi;
    od;

    CF_SPrint(
        "Exact isomorphism types encountered during deduplication = ",
        Length(groupCaches), "\n"
    );

    return kept;
end;


#############################################################################
# Repair an S2 record that has already been computed with the old fallback.
# This avoids repeating S1 and the expensive character-restriction search,
# provided S2.rawSolutions is still present.
#############################################################################

CF_NL_RededuplicateExistingS2 := function(S2)
    local raw, fixed, oldCount, newCount;

    if not IsRecord(S2) or not IsBound(S2.solutions) then
        Error("Expected the record returned by the non-liftable S_2.");
    fi;

    if IsBound(S2.rawSolutions)
       and IsList(S2.rawSolutions)
       and S2.rawSolutions <> fail then
        raw := S2.rawSolutions;
    else
        Error(
            "This S2 record no longer contains rawSolutions.  Reload the ",
            "patch and rerun S_2(S1)."
        );
    fi;

    oldCount := Length(S2.solutions);
    fixed := ShallowCopy(S2);
    fixed.solutions := CF_DeduplicateConjugateMatrixImages(raw);
    newCount := Length(fixed.solutions);
    fixed.largeHExactDedupPatchVersion := "8.2";
    fixed.preLargeHRepairSolutionCount := oldCount;
    fixed.postLargeHRepairSolutionCount := newCount;

    CF_SPrint(
        "Existing S2 re-deduplicated: ",
        oldCount, " -> ", newCount,
        " exact unmarked GL(6)-conjugacy classes.\n"
    );

    return fixed;
end;


CF_SPrint(
    "NON-LIFTABLE LARGE-H EXACT CONJUGACY PATCH V8.2.1 LOADED OK\n"
);
CF_SPrint(
    "Large middle groups with HId=fail now use exact group isomorphism and ",
    "full Aut(H)-character orbits; unique fallback keys are disabled.\n"
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
