#############################################################################
##
## gap_small_nonabelian_7212_special.g
##
## Exact specialized calculation for
##     G_s = C3,  G = SmallGroup(72,12) = C3 x (C3 : C8).
##
## The general central-extension traversal is unnecessary in this case.
## The proof of liftability reduces the two C3 components to their irreducible
## weight patterns.  This file enumerates those patterns exactly, constructs
## the unique smooth action, verifies an explicit smooth member with Singular,
## and applies SearchEmbeddingStrict to its S3 x C24 overgroup.
##
## Run from the gap_small_nonabelian directory.
##
#############################################################################

CF_SN_AUTO_RUN := false;;
CF_SN_SHOW_PROGRESS := false;;
CF_SN_ENGINE_DETAILS := false;;
CF_SN_SHOW_GENERIC_FILTER_PROGRESS := false;;
CF_SN_APPLY_GONZALEZ := true;;

if not IsBoundGlobal("CF_7212_SPECIAL_AUTO_RUN") then
    CF_7212_SPECIAL_AUTO_RUN := true;;
fi;
if not IsBoundGlobal("CF_7212_SPECIAL_DATA_FILE") then
    CF_7212_SPECIAL_DATA_FILE :=
        Filename(
            DirectoryCurrent(),
            "gap_small_nonabelian_7212_special_data.g"
        );;
fi;
if not IsBoundGlobal("CF_7212_SPECIAL_REPORT_FILE") then
    CF_7212_SPECIAL_REPORT_FILE :=
        Filename(
            DirectoryCurrent(),
            "gap_small_nonabelian_7212_special_report.md"
        );;
fi;
if not IsBoundGlobal("CF_7212_SPECIAL_LOG_FILE") then
    CF_7212_SPECIAL_LOG_FILE :=
        Filename(
            DirectoryCurrent(),
            "gap_small_nonabelian_7212_special.log"
        );;
fi;

Read("gap_small_nonabelian.g");


#############################################################################
## 1. Exact normalized weight enumeration
#############################################################################

CF_7212_SortedWeights := function(weights)
    local answer;
    answer := List(weights, ShallowCopy);
    Sort(answer, function(first, second)
        if first[1] <> second[1] then
            return first[1] < second[1];
        fi;
        return first[2] < second[2];
    end);
    return answer;
end;


CF_7212_ArrowWeight := function(weight)
    return [(-2 * weight[1]) mod 3, (-2 * weight[2]) mod 8];
end;


CF_7212_HasSquareMonomialForEveryLinearCoordinate := function(weights)
    return ForAll(
        weights,
        weight -> Position(weights, CF_7212_ArrowWeight(weight)) <> fail
    );
end;


CF_7212_HodgeCharacterIsFaithful := function(weights)
    # After twisting, W_{u,r}=W_{0,0} and the cubic character is trivial.
    # The determinant on a is nontrivial precisely when sum(alpha_i) != 0,
    # and its exponent on t is odd precisely when sum(beta_i) is odd.
    return Sum(List(weights, weight -> weight[1])) mod 3 <> 0
           and Sum(List(weights, weight -> weight[2])) mod 2 = 1;
end;


CF_7212_WeightOrbit := function(weights)
    local orbit, sign, unit, transformed;
    orbit := [];
    for sign in [1, 2] do
        for unit in [1, 3, 5, 7] do
            transformed := CF_7212_SortedWeights(List(
                weights,
                weight -> [
                    (sign * weight[1]) mod 3,
                    (unit * weight[2]) mod 8
                ]
            ));
            AddSet(orbit, transformed);
        od;
    od;
    return orbit;
end;


CF_7212_CanonicalWeightRepresentative := function(weights)
    local orbit, representative, item;
    orbit := CF_7212_WeightOrbit(weights);
    representative := orbit[1];
    for item in orbit do
        if item < representative then
            representative := item;
        fi;
    od;
    return representative;
end;


CF_7212_EnumerateFourOneDimensionalWeights := function()
    local allWeights, tested, retained, orbitRepresentatives,
          i1, i2, i3, i4, weights, representative;

    allWeights := [];
    for i1 in [0 .. 2] do
        for i2 in [0 .. 7] do
            Add(allWeights, [i1, i2]);
        od;
    od;

    tested := 0;
    retained := [];
    orbitRepresentatives := [];
    for i1 in [1 .. Length(allWeights)] do
        for i2 in [i1 .. Length(allWeights)] do
            for i3 in [i2 .. Length(allWeights)] do
                for i4 in [i3 .. Length(allWeights)] do
                    tested := tested + 1;
                    weights := [
                        allWeights[i1], allWeights[i2],
                        allWeights[i3], allWeights[i4]
                    ];
                    if CF_7212_HodgeCharacterIsFaithful(weights)
                       and CF_7212_HasSquareMonomialForEveryLinearCoordinate(
                           weights
                       ) then
                        Add(retained, weights);
                        representative :=
                            CF_7212_CanonicalWeightRepresentative(weights);
                        AddSet(orbitRepresentatives, representative);
                    fi;
                od;
            od;
        od;
    od;

    if tested <> 17550 then
        Error("The four-weight multiset enumeration is incomplete.");
    fi;
    if Length(retained) <> 8 or Length(orbitRepresentatives) <> 1 then
        Error("The normalized (4,1,1) weight calculation changed.");
    fi;
    if orbitRepresentatives[1]
       <> [[1,0], [1,1], [1,4], [1,6]] then
        Error("The canonical (4,1,1) weight representative changed.");
    fi;

    return rec(
        allWeightCount := Length(allWeights),
        testedMultisetCount := tested,
        retainedMultisets := retained,
        retainedMultisetCount := Length(retained),
        orbitRepresentatives := orbitRepresentatives,
        orbitCount := Length(orbitRepresentatives)
    );
end;


CF_7212_EnumerateTwoTwoTwoParityObstruction := function()
    local squareCompatible, faithfulC8Count, v1, v2, d, r1, r2,
          squareCondition, kappaExponent;

    squareCompatible := 0;
    faithfulC8Count := 0;
    for v1 in [0 .. 7] do
        for v2 in [0 .. 7] do
            for d in [0 .. 7] do
                squareCondition :=
                    ForAny([v1, v2], w -> (2*v1 + w - d) mod 8 = 0)
                    and
                    ForAny([v1, v2], w -> (2*v2 + w - d) mod 8 = 0);
                if squareCondition then
                    for r1 in [0 .. 3] do
                        for r2 in [0 .. 3] do
                            squareCompatible := squareCompatible + 1;
                            # Each two-dimensional summand contributes the
                            # even exponent 4+2r.  The two 4's cancel mod 8.
                            kappaExponent :=
                                (2*r1 + 2*r2 + v1 + v2 - 2*d) mod 8;
                            if kappaExponent mod 2 = 1 then
                                faithfulC8Count := faithfulC8Count + 1;
                            fi;
                        od;
                    od;
                fi;
            od;
        od;
    od;

    if faithfulC8Count <> 0 then
        Error("The (2,2,2) determinant-parity obstruction failed.");
    fi;
    return rec(
        squareCompatibleParameterCount := squareCompatible,
        faithfulC8ParameterCount := faithfulC8Count
    );
end;


#############################################################################
## 2. The unique normalized matrix action and its invariant cubic space
#############################################################################

CF_7212_DiagonalMatrix := function(entries)
    local matrix, i;
    matrix := List(
        [1 .. Length(entries)],
        i -> List([1 .. Length(entries)], j -> 0)
    );
    for i in [1 .. Length(entries)] do
        matrix[i][i] := entries[i];
    od;
    return Immutable(matrix);
end;


CF_7212_BuildUniqueAction := function(weights)
    local omega, zeta8, scalar, A, B, T, projectiveLift,
          projectiveData, strictGroup, strictData, determinantKernel,
          expectedKernel, cubic, centralizer, family, smoothness,
          gonzalez, i;

    if weights <> [[1,0], [1,1], [1,4], [1,6]] then
        Error("The matrix constructor expects the canonical weight orbit.");
    fi;

    omega := E(3);
    zeta8 := E(8);
    scalar := omega * IdentityMat(6);
    A := CF_7212_DiagonalMatrix(Concatenation(
        [1, 1],
        List(weights, weight -> omega^weight[1])
    ));
    B := CF_7212_DiagonalMatrix([omega, omega^2, 1, 1, 1, 1]);
    T := List([1 .. 6], i -> List([1 .. 6], j -> 0));
    T[1][2] := 1;
    T[2][1] := 1;
    for i in [1 .. 4] do
        T[i+2][i+2] := zeta8^weights[i][2];
    od;
    T := Immutable(T);

    if A^3 <> IdentityMat(6)
       or B^3 <> IdentityMat(6)
       or T^8 <> IdentityMat(6)
       or A*B <> B*A
       or A*T <> T*A
       or T*B*T^-1 <> B^-1 then
        Error("The specialized matrices do not satisfy the presentation.");
    fi;

    projectiveLift := Group([A, B, T]);
    projectiveData := CF_SN_LinearAndProjectiveGroupData(projectiveLift);
    if projectiveData.linearGroupData.id <> [72,12]
       or projectiveData.scalarSubgroupOrder <> 1
       or projectiveData.projectiveGroupData.id <> [72,12] then
        Error("The normalized matrices do not realize SmallGroup(72,12).");
    fi;

    strictGroup := Group([A, B, T, scalar]);
    strictData := CF_SN_LinearAndProjectiveGroupData(strictGroup);
    if strictData.linearGroupData.id <> [216,82]
       or strictData.linearGroupData.order <> 216
       or strictData.scalarSubgroupOrder <> 3
       or strictData.projectiveGroupData.id <> [72,12]
       or strictData.determinantImageOrder <> 24 then
        Error("The strict lift has incorrect group data.");
    fi;

    determinantKernel := Group(Filtered(
        Elements(strictGroup),
        element -> DeterminantMat(element) = 1
    ));
    expectedKernel := Group([B, scalar]);
    if not CF_SameSubgroup(determinantKernel, expectedKernel)
       or Size(determinantKernel) <> 9 then
        Error("The determinant kernel is not the prescribed strict C3 lift.");
    fi;

    cubic := CF_CubicInvariantBasis(
        [A, B, T, scalar],
        rec(buildPolynomialObjects := false, buildStrings := true)
    );
    centralizer := CF_CentralizerAlgebraBasis([A, B, T, scalar], false);
    if cubic.invariantDimension <> 5 or centralizer.dimension <> 5 then
        Error("The unique action should have dim(W_H)=c(H)=5.");
    fi;

    family := rec(
        matrixGenerators := [A, B, T, scalar],
        linearGroupId := strictData.linearGroupData.id,
        linearOrder := strictData.linearGroupData.order,
        projectiveGroupId := strictData.projectiveGroupData.id,
        projectiveOrder := strictData.projectiveGroupData.order,
        symplecticProjectiveGroupId := [3,1],
        determinantKernelOrder := Size(determinantKernel),
        determinantImageOrder := strictData.determinantImageOrder,
        cubicMonomialExponents := cubic.monomialExponents,
        cubicInvariantBasisVectors := cubic.coefficientBasis,
        cubicInvariantBasisStrings := cubic.polynomialStrings,
        cubicInvariantDimension := cubic.invariantDimension,
        centralizerDimension := centralizer.dimension,
        familyDimension := cubic.invariantDimension - centralizer.dimension,
        smoothWitnessCoefficients := [1,1,1,1,1]
    );

    smoothness := CF_S4_TestExactMember(
        family,
        family.smoothWitnessCoefficients,
        rec(exactGroebnerTimeoutSeconds := 120)
    );
    if smoothness.status <> "exact_smooth" then
        Error(
            "Singular did not certify the normalized member as smooth: ",
            smoothness.status, "."
        );
    fi;

    gonzalez := CF_SN_GonzalezInvariantLinearGroupRestriction(strictGroup);
    if not gonzalez.ok then
        Error("The unique smooth action failed the prime-order restriction.");
    fi;

    return rec(
        weights := List(weights, ShallowCopy),
        projectiveLiftGenerators := [A, B, T],
        strictGenerators := [A, B, T, scalar],
        projectiveLiftData := projectiveData,
        strictData := strictData,
        determinantKernelId := CF_GroupIdentificationData(
            determinantKernel
        ).id,
        family := family,
        exactSmoothness := smoothness,
        gonzalezAudit := gonzalez
    );
end;


#############################################################################
## 3. Saturation by the known S3 x C24 action
#############################################################################

CF_7212_SaturateUniqueFamily := function(action)
    local target, sourceInfo, targetInfo, embedding, sourceDimension,
          targetDimension, properIndex, verifiedWitness;

    target := CF_SN_S3C24Example();
    sourceInfo := PreprocessMatrixGroupStrict(
        action.strictGenerators,
        action.strictData.linearGroupData.order,
        action.strictData.linearGroupData.id
    );
    targetInfo := PreprocessMatrixGroupStrict(
        target.fullStrictPreimageGenerators,
        target.fullStrictPreimageData.order,
        target.fullStrictPreimageData.id
    );
    embedding := SearchEmbeddingStrict(
        sourceInfo,
        targetInfo,
        rec(
            stop_first := true,
            construct_witness := true,
            try_literal_inclusion := true,
            use_fingerprints := true
        )
    );
    if embedding.status <> "embedded" then
        Error(
            "The strict lift of the unique projective G=[72,12] action ",
            "was not embedded in the strict lift of S3 x C24."
        );
    fi;

    sourceDimension := action.family.familyDimension;
    targetDimension := target.familyDimension;
    properIndex := targetInfo.order / sourceInfo.order;
    if sourceDimension <> 0
       or targetDimension <> 0
       or properIndex <> 2 then
        Error("The proposed saturation does not preserve the family dimension.");
    fi;

    verifiedWitness := fail;
    if embedding.P <> fail then
        verifiedWitness := ForAll(
            sourceInfo.gens,
            element -> embedding.P^-1 * element * embedding.P
                       in targetInfo.G
        );
        if not verifiedWitness then
            Error("The returned strict embedding matrix failed verification.");
        fi;
    fi;

    return rec(
        sourceStrictId := sourceInfo.h_id,
        sourceStrictOrder := sourceInfo.order,
        sourceProjectiveId := [72,12],
        sourceFamilyDimension := sourceDimension,
        targetStrictId := targetInfo.h_id,
        targetStrictOrder := targetInfo.order,
        targetProjectiveId := target.projectiveGroupData.id,
        targetFamilyDimension := targetDimension,
        targetLabel := target.label,
        properIndex := properIndex,
        status := embedding.status,
        method := embedding.method,
        reason := embedding.reason,
        conjugatingMatrix := embedding.P,
        witnessVerified := verifiedWitness,
        sourceImages := embedding.images,
        saturatedAway := embedding.status = "embedded"
                         and properIndex > 1
                         and sourceDimension = targetDimension
    );
end;


#############################################################################
## 4. Output
#############################################################################

CF_7212_WriteData := function(result)
    local family, saturation, stream;
    family := result.uniqueAction.family;
    saturation := result.saturation;
    stream := OutputTextFile(CF_7212_SPECIAL_DATA_FILE, false);
    if stream = fail then
        Error("Cannot open the specialized [72,12] data file.");
    fi;
    SetPrintFormattingStatus(stream, false);
    PrintTo(
        stream,
        "CF_7212_SpecialData := rec(\n",
        "    projectiveGroupId := [72,12],\n",
        "    symplecticGroupId := [3,1],\n",
        "    testedWeightMultisets := ",
        result.component411.testedMultisetCount, ",\n",
        "    retainedWeightMultisets := ",
        result.component411.retainedMultisets, ",\n",
        "    weightOrbitRepresentatives := ",
        result.component411.orbitRepresentatives, ",\n",
        "    component222FaithfulCount := ",
        result.component222.faithfulC8ParameterCount, ",\n",
        "    smoothFamilyCount := ", result.smoothFamilyCount, ",\n",
        "    strictGroupId := ",
        result.uniqueAction.strictData.linearGroupData.id, ",\n",
        "    strictGroupOrder := ",
        result.uniqueAction.strictData.linearGroupData.order, ",\n",
        "    matrixGenerators := ",
        result.uniqueAction.strictGenerators, ",\n",
        "    invariantBasis := ",
        family.cubicInvariantBasisStrings, ",\n",
        "    invariantBasisVectors := ",
        family.cubicInvariantBasisVectors, ",\n",
        "    monomialExponents := ",
        family.cubicMonomialExponents, ",\n",
        "    invariantDimension := ", family.cubicInvariantDimension, ",\n",
        "    centralizerDimension := ", family.centralizerDimension, ",\n",
        "    familyDimension := ", family.familyDimension, ",\n",
        "    smoothWitnessCoefficients := ",
        family.smoothWitnessCoefficients, ",\n",
        "    smoothnessStatus := \"", result.smoothnessStatus, "\",\n",
        "    saturationTargetProjectiveId := ",
        saturation.targetProjectiveId, ",\n",
        "    saturationTargetStrictId := ",
        saturation.targetStrictId, ",\n",
        "    saturationIndex := ", saturation.properIndex, ",\n",
        "    saturationStatus := \"", saturation.status, "\",\n",
        "    saturationMethod := \"", saturation.method, "\",\n",
        "    conjugatingMatrix := ",
        saturation.conjugatingMatrix, ",\n",
        "    witnessVerified := ", saturation.witnessVerified, ",\n",
        "    saturatedAway := ", saturation.saturatedAway, "\n",
        ");\n"
    );
    CloseStream(stream);
end;


CF_7212_WriteReport := function(result)
    local family, saturation, basisElement, weights, stream;
    family := result.uniqueAction.family;
    saturation := result.saturation;
    stream := OutputTextFile(CF_7212_SPECIAL_REPORT_FILE, false);
    if stream = fail then
        Error("Cannot open the specialized [72,12] report file.");
    fi;
    SetPrintFormattingStatus(stream, false);
    PrintTo(
        stream,
        "# Specialized `G_s=C3`, `G=[72,12]` calculation\n\n",
        "## Exact enumeration\n\n",
        "- Four-weight multisets tested: `",
        result.component411.testedMultisetCount, "`.\n",
        "- Multisets satisfying the Hodge-character and square-monomial ",
        "conditions: `", result.component411.retainedMultisetCount, "`.\n",
        "- Orbits under `a -> a^+-1` and `t -> t^v` for odd `v`: `",
        result.component411.orbitCount, "`.\n",
        "- `(2,2,2)` parameters with faithful `C8` Hodge character: `",
        result.component222.faithfulC8ParameterCount, "`.\n\n",
        "The retained normalized weight multisets are:\n\n"
    );
    for weights in result.component411.retainedMultisets do
        PrintTo(stream, "- `", weights, "`\n");
    od;
    PrintTo(
        stream,
        "\nTheir unique orbit representative is `",
        result.component411.orbitRepresentatives[1], "`.\n\n",
        "## Unique smooth family\n\n",
        "- Projective group `G`: `[72,12]`.\n",
        "- Strict lift `H`: `",
        result.uniqueAction.strictData.linearGroupData.id,
        "`, of order `", result.uniqueAction.strictData.linearGroupData.order,
        "`.\n",
        "- Determinant kernel: `",
        result.uniqueAction.determinantKernelId, "`, of order `9`.\n",
        "- `dim W_H = ", family.cubicInvariantDimension,
        "`, `dim C_GL6(H) = ", family.centralizerDimension,
        "`, and `m = ", family.familyDimension, "`.\n",
        "- Exact smoothness status: `", result.smoothnessStatus, "`.\n\n",
        "Compact strict generators, with `zeta_n=E(n)`, are\n\n",
        "- `A=diag(1,1,zeta_3,zeta_3,zeta_3,zeta_3)`,\n",
        "- `B=diag(zeta_3,zeta_3^2,1,1,1,1)`,\n",
        "- `T=P_(12) diag(1,1,1,zeta_8,-1,-zeta_4)`,\n",
        "- `Z=zeta_3 I_6`.\n\n",
        "An invariant basis is\n\n"
    );
    for basisElement in family.cubicInvariantBasisStrings do
        PrintTo(
            stream,
            "- `$", basisElement, "$`\n"
        );
    od;
    PrintTo(
        stream,
        "\nAll five coefficients equal to one give the exact smooth ",
        "witness certified by Singular.\n\n",
        "## Saturation\n\n",
        "The strict lift of the projective group `G=[72,12]` embeds in ",
        "the strict lift of the projective group `S3 x C24` ",
        "of projective ID `", saturation.targetProjectiveId, "` with index `",
        saturation.properIndex, "`.  Both families have `m=0`.\n\n",
        "- Strict containment status: `", saturation.status, "`.\n",
        "- Method: `", saturation.method, "`.\n",
        "- Explicit conjugating matrix verified: `",
        saturation.witnessVerified, "`.\n",
        "- Conjugating matrix: `", saturation.conjugatingMatrix, "`.\n",
        "- Removed by saturation: `", saturation.saturatedAway, "`.\n"
    );
    CloseStream(stream);
end;


CF_7212_SpecialRun := function()
    local start, component411, component222, uniqueAction, saturation,
          result, logStream;

    start := Runtime();
    component411 := CF_7212_EnumerateFourOneDimensionalWeights();
    component222 := CF_7212_EnumerateTwoTwoTwoParityObstruction();
    uniqueAction := CF_7212_BuildUniqueAction(
        component411.orbitRepresentatives[1]
    );
    saturation := CF_7212_SaturateUniqueFamily(uniqueAction);
    if not saturation.saturatedAway then
        Error(
            "The unique smooth family with projective G=[72,12] was not ",
            "saturated away."
        );
    fi;

    result := rec(
        component411 := component411,
        component222 := component222,
        uniqueAction := uniqueAction,
        smoothFamilyCount := 1,
        smoothnessStatus := uniqueAction.exactSmoothness.status,
        saturation := saturation,
        runtimeMilliseconds := Runtime() - start
    );
    CF_7212_WriteData(result);
    CF_7212_WriteReport(result);
    logStream := OutputTextFile(CF_7212_SPECIAL_LOG_FILE, false);
    if logStream = fail then
        Error("Cannot open the specialized [72,12] log file.");
    fi;
    SetPrintFormattingStatus(logStream, false);
    PrintTo(
        logStream,
        "SPECIAL_7212_COMPLETED\n",
        "tested_weight_multisets=",
        component411.testedMultisetCount, "\n",
        "retained_weight_multisets=",
        component411.retainedMultisetCount, "\n",
        "weight_orbits=", component411.orbitCount, "\n",
        "smooth_families=", result.smoothFamilyCount, "\n",
        "smoothness_status=", result.smoothnessStatus, "\n",
        "saturation_status=", saturation.status, "\n",
        "saturation_index=", saturation.properIndex, "\n",
        "saturation_witness_verified=", saturation.witnessVerified, "\n",
        "saturated_away=", saturation.saturatedAway, "\n",
        "runtime_ms=", result.runtimeMilliseconds, "\n"
    );
    CloseStream(logStream);
    return result;
end;


if CF_7212_SPECIAL_AUTO_RUN then
    CF_7212_SpecialResult := CF_7212_SpecialRun();;
    Print(
        "SPECIAL_7212_COMPLETED smooth_families=",
        CF_7212_SpecialResult.smoothFamilyCount,
        " saturated_away=",
        CF_7212_SpecialResult.saturation.saturatedAway,
        " runtime_ms=", CF_7212_SpecialResult.runtimeMilliseconds,
        "\n"
    );
fi;
