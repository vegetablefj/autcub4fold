#############################################################################
## Unified data loader for equivalence, containment, and saturation checks.
##
## This file normalizes 177 smooth records and retains seven unresolved
## records for traceability.  It does not run a classification, smoothness
## test, embedding search, or saturation calculation.  The public lists and
## saturation-tag rules are documented in gap_saturation_input.md.
#############################################################################

CF_SAT_InputPaths := function()
    if IsExistingFile("gap_large_koike_families.g") then
        return rec(
            saturationDirectory := "",
            classificationDirectory := "../"
        );
    fi;

    if IsExistingFile(
        "gap_classification/gap_saturation/gap_large_koike_families.g"
    ) then
        return rec(
            saturationDirectory := "gap_classification/gap_saturation/",
            classificationDirectory := "gap_classification/"
        );
    fi;

    Error("Run from the repository root or gap_classification/gap_saturation.");
end;

CF_SAT_SmallRank := function(symplecticPart)
    if symplecticPart = "C3" or symplecticPart = "C2^2" then
        return 12;
    elif symplecticPart = "C4" or symplecticPart = "S3" then
        return 14;
    fi;
    Error("Unexpected small symplectic part: ", symplecticPart, ".");
end;


## The strict lifts contain the scalar cube roots of unity, whose determinant
## is one in dimension six.  Hence the determinant image order is exactly the
## projective index [G:G_s].
CF_SAT_DeterminantImageOrder := function(generators)
    local determinantOrders;

    determinantOrders := List(generators, matrix -> Order(DeterminantMat(matrix)));
    if ForAny(determinantOrders, order -> order = infinity) then
        Error("The determinant image is not finite.");
    fi;
    return Lcm(determinantOrders);
end;


CF_SAT_GroupIdKey := function(groupId)
    if groupId = fail then
        return "not-recorded";
    fi;
    return Concatenation(String(groupId[1]), "-", String(groupId[2]));
end;


CF_SAT_SourceKeyBase := function(
    category,
    symplecticPart,
    projectiveGroupId,
    fullIndex,
    familyDimension
)
    return Concatenation(
        category,
        "-", symplecticPart,
        "-PGL-", CF_SAT_GroupIdKey(projectiveGroupId),
        "-index-", String(fullIndex),
        "-dimension-", String(familyDimension)
    );
end;


CF_SAT_UniqueSourceKey := function(base, usedBases)
    local occurrence;

    occurrence := Number(usedBases, key -> key = base) + 1;
    Add(usedBases, base);
    if occurrence = 1 then
        return base;
    fi;
    return Concatenation(
        base,
        "-representation-", String(occurrence)
    );
end;


## Every family receives exactly one simple saturation tag:
##   "known_saturated"  no containment test is needed;
##   "check"            include it in the equal-dimensional search once smooth.
CF_SAT_SetSaturationTag := function(input, tag, reason)
    if not tag in [ "known_saturated", "check" ] then
        Error("Unexpected saturation tag: ", tag, ".");
    fi;
    if tag <> "check" and reason = fail then
        Error("A saturation exemption must have a recorded reason.");
    fi;

    input.saturationTag := tag;
    input.saturationReason := reason;
    input.knownSaturated := tag = "known_saturated";
    input.isKnownSaturatedFamily := input.knownSaturated;

    # Compatibility with the containment code: known saturated records are
    # permanent targets, never removable sources.
    input.initiallySaturated := tag <> "check";
    input.initialSaturationReason := reason;
    return input;
end;


CF_SAT_AttachInitialSaturation := function(
    input,
    genericIndex,
    isSymplecticFamily,
    specialReason
)
    input.fullIndex := CF_SAT_DeterminantImageOrder(input.matrixGenerators);
    input.genericIndex := genericIndex;
    input.isSymplecticFamily := isSymplecticFamily;
    input.isSpecialSaturationExempt := specialReason <> fail;

    if isSymplecticFamily then
        input := CF_SAT_SetSaturationTag(
            input,
            "known_saturated",
            "connected symplectic family"
        );
    elif specialReason <> fail then
        input := CF_SAT_SetSaturationTag(
            input,
            "known_saturated",
            specialReason
        );
    else
        input := CF_SAT_SetSaturationTag(input, "check", fail);
    fi;

    return input;
end;

CF_SAT_LiftableSymplecticData := function(record)
    local quotientId, quotientSize, label, rank, scalarSubgroup,
          hasOrderFourCoset;

    # The liftable-abelian data already records the order of the determinant
    # kernel.  Its scalar subgroup is mu_3, so this determines the order of
    # the symplectic projective quotient.  Only order four needs a structural
    # check: C4 has a coset whose square is non-scalar, whereas C2^2 does not.
    quotientSize := record.determinantOneSubgroupSize / 3;

    if quotientSize = 1 then
        quotientId := [ 1, 1 ];
        label := "1";
        rank := 0;
    elif quotientSize = 2 then
        quotientId := [ 2, 1 ];
        label := "C2";
        rank := 8;
    elif quotientSize = 3 then
        quotientId := [ 3, 1 ];
        label := "C3";
        rank := 12;
    elif quotientSize = 4 then
        scalarSubgroup := Group(E(3) * IdentityMat(6));
        hasOrderFourCoset := ForAny(
            Elements(record.group),
            g -> DeterminantMat(g) = 1 and not g^2 in scalarSubgroup
        );
        if hasOrderFourCoset then
            quotientId := [ 4, 1 ];
            label := "C4";
            rank := 14;
        else
            quotientId := [ 4, 2 ];
            label := "C2^2";
            rank := 12;
        fi;
    else
        Error(
            "Unexpected liftable abelian symplectic quotient order for ",
            "PGL ", record.PGLId, ": ", quotientSize, "."
        );
    fi;

    return rec(
        label := label,
        groupId := quotientId,
        rankS := rank,
        determinantKernelSize := record.determinantOneSubgroupSize
    );
end;

CF_SAT_InputPathRecord := CF_SAT_InputPaths();

if not IsBound(LargeKoikeFamilies) then
    Read(Concatenation(
        CF_SAT_InputPathRecord.saturationDirectory,
        "gap_large_koike_families.g"
    ));
fi;
if not IsBound(FinalLiftableAbelianCandidates) then
    Read(Concatenation(
        CF_SAT_InputPathRecord.classificationDirectory,
        "gap_liftable_abelian/gap_liftable_abelian_data.g"
    ));
fi;
if not IsBound(FinalNonliftableAbelianCandidates) then
    Read(Concatenation(
        CF_SAT_InputPathRecord.classificationDirectory,
        "gap_nonliftable_abelian/gap_nonliftable_abelian_data.g"
    ));
fi;
if not IsBound(SmallNonabelianSaturationCandidates) then
    Read(Concatenation(
        CF_SAT_InputPathRecord.saturationDirectory,
        "gap_small_nonabelian_saturation_data.g"
    ));
fi;

# Bind the public output names before compiling the builder.  Besides making
# repeated reads harmless, this prevents GAP from reporting them as unbound
# globals while the function is parsed.
SaturationInputLargeFamilies := [];
SaturationInputLiftableAbelian := [];
SaturationInputNonliftableAbelian := [];
SaturationInputSmallNonabelianSmooth := [];
SaturationInputSmallNonabelianUnresolved := [];
SaturationInputSmallNonabelian := [];
SaturationInputSpecialNoSaturation := [];
SaturationInputRankBelow15SymplecticFamilies := [];
SaturationInputKnownSaturated := [];
SaturationInputForSaturationCheck := [];
SaturationInputCandidates := [];
SaturationInputSummary := rec();

CF_SAT_BuildInput := function()
    local record, symplectic, input, number, specialReason,
          sourceKeyBase, usedSourceKeyBases, isSymplecticFamily, fullIndex;

    usedSourceKeyBases := [];

    SaturationInputLargeFamilies := [];
    for record in LargeKoikeFamilies do
        fullIndex := CF_SAT_DeterminantImageOrder(record.matrixGenerators);
        sourceKeyBase := CF_SAT_SourceKeyBase(
            "rank-at-least-15",
            record.symplecticPart,
            record.projectiveGroupId,
            fullIndex,
            record.familyDimension
        );
        input := rec(
            sourceCategory := "rank_at_least_15",
            sourceKey := CF_SAT_UniqueSourceKey(
                sourceKeyBase,
                usedSourceKeyBases
            ),
            sourceRecord := record,
            smoothnessStatus := "known_smooth",
            requiresSmoothnessProof := false,
            symplecticPart := record.symplecticPart,
            rankS := record.rankS,
            genericIndex := record.genericIndex,
            isSymplecticFamily := record.isSymplecticFamily,
            isHighRankVerificationExempt :=
                record.isHighRankVerificationExempt,
            isSevenDivisibleVerificationExempt :=
                record.isSevenDivisibleVerificationExempt,
            isTheoryVerificationExempt := record.isTheoryVerificationExempt,
            isKnownSaturatedFamily := record.isKnownSaturatedFamily,
            requiresSmoothnessCheck := record.requiresSmoothnessCheck,
            requiresSelfConjugacyCheck := record.requiresSelfConjugacyCheck,
            requiresSaturationCheck := record.requiresSaturationCheck,
            isSpecialSaturationExempt := false,
            projectiveGroupId := record.projectiveGroupId,
            linearGroupId := record.linearGroupId,
            familyDimension := record.familyDimension,
            matrixGenerators := record.matrixGenerators,
            cubicInvariantBasisStrings := record.cubicInvariantBasisStrings
        );
        input.fullIndex := fullIndex;
        if record.isSymplecticFamily
           or record.isKnownSaturatedFamily
           or record.isTheoryVerificationExempt then
            input := CF_SAT_SetSaturationTag(
                input,
                "known_saturated",
                record.saturationExemptionReason
            );
        else
            input := CF_SAT_SetSaturationTag(input, "check", fail);
        fi;
        Add(SaturationInputLargeFamilies, input);
    od;

    SaturationInputLiftableAbelian := [];
    for record in FinalLiftableAbelianCandidates do
        symplectic := CF_SAT_LiftableSymplecticData(record);
        isSymplecticFamily :=
            record.familyDimension = 20 - symplectic.rankS;
        sourceKeyBase := CF_SAT_SourceKeyBase(
            "liftable-abelian",
            symplectic.label,
            record.PGLId,
            record.linearOrder / record.determinantOneSubgroupSize,
            record.familyDimension
        );
        input := rec(
            sourceCategory := "liftable_abelian",
            sourceKey := CF_SAT_UniqueSourceKey(
                sourceKeyBase,
                usedSourceKeyBases
            ),
            sourceRecord := record,
            smoothnessStatus := "theoretical_smooth",
            requiresSmoothnessProof := false,
            symplecticPart := symplectic.label,
            symplecticGroupId := symplectic.groupId,
            rankS := symplectic.rankS,
            genericIndex := 1,
            projectiveGroupId := record.PGLId,
            linearGroupId := record.GLId,
            familyDimension := record.familyDimension,
            matrixGenerators := record.generators,
            cubicInvariantBasisStrings := record.invariantCubicBasisStrings
        );
        specialReason := fail;
        if IsBound(record.isSpecialYYZExample)
           and record.isSpecialYYZExample = true
           and (record.PGLStructure = "C32"
                or record.PGLStructure = "C48") then
            specialReason := Concatenation(
                "special Yang--Yu--Zhu saturated family: ",
                record.PGLStructure
            );
        fi;
        input := CF_SAT_AttachInitialSaturation(
            input,
            1,
            isSymplecticFamily,
            specialReason
        );
        if input.fullIndex
           <> record.linearOrder / record.determinantOneSubgroupSize then
            Error("Liftable-abelian determinant-index mismatch for ",
                  input.sourceKey, ".");
        fi;
        Add(SaturationInputLiftableAbelian, input);
    od;

    SaturationInputNonliftableAbelian := [];
    for record in FinalNonliftableAbelianCandidates do
        sourceKeyBase := CF_SAT_SourceKeyBase(
            "nonliftable-abelian",
            record.symplecticPart,
            record.projectiveGroupId,
            CF_SAT_DeterminantImageOrder(record.matrixGenerators),
            record.familyDimension
        );
        input := rec(
            sourceCategory := "nonliftable_abelian",
            sourceKey := CF_SAT_UniqueSourceKey(
                sourceKeyBase,
                usedSourceKeyBases
            ),
            sourceRecord := record,
            smoothnessStatus := "theoretical_smooth",
            requiresSmoothnessProof := false,
            symplecticPart := record.symplecticPart,
            symplecticGroupId := record.symplecticGId,
            rankS := record.rankS,
            genericIndex := record.genericIndex,
            projectiveGroupId := record.projectiveGroupId,
            linearGroupId := record.linearGroupId,
            familyDimension := record.familyDimension,
            matrixGenerators := record.matrixGenerators,
            cubicInvariantBasisStrings := record.cubicInvariantBasisStrings
        );
        input := CF_SAT_AttachInitialSaturation(
            input,
            record.genericIndex,
            false,
            fail
        );
        if input.fullIndex <> record.fullIndex then
            Error("Non-liftable abelian full-index mismatch for ",
                  input.sourceKey, ".");
        fi;
        Add(SaturationInputNonliftableAbelian, input);
    od;

    SaturationInputSmallNonabelianSmooth := [];
    SaturationInputSmallNonabelianUnresolved := [];
    for record in SmallNonabelianSaturationCandidates do
        sourceKeyBase := CF_SAT_SourceKeyBase(
            "small-nonabelian",
            record.symplecticPart,
            record.projectiveGId,
            record.determinantImageOrder,
            record.expectedModuliDimension
        );
        input := rec(
            sourceCategory := "small_nonabelian",
            sourceKey := CF_SAT_UniqueSourceKey(
                sourceKeyBase,
                usedSourceKeyBases
            ),
            sourceRecord := record,
            smoothnessStatus := record.smoothnessStatus,
            smoothnessProofType := record.smoothnessProofType,
            requiresSmoothnessProof := record.requiresSmoothnessProof,
            symplecticPart := record.symplecticPart,
            symplecticGroupId := record.symplecticGId,
            rankS := CF_SAT_SmallRank(record.symplecticPart),
            genericIndex := record.genericIndex,
            projectiveGroupId := record.projectiveGId,
            linearGroupId := record.linearGId,
            familyDimension := record.expectedModuliDimension,
            matrixGenerators := record.matrixGenerators,
            cubicInvariantBasisStrings := record.cubicInvariantBasisStrings
        );
        specialReason := fail;
        if IsBound(record.isDirectKnownCase)
           and record.isDirectKnownCase = true then
            specialReason :=
                "direct known saturated family: S3 x C24";
        fi;
        input := CF_SAT_AttachInitialSaturation(
            input,
            record.genericIndex,
            record.isSymplecticFamily,
            specialReason
        );
        if input.fullIndex <> record.determinantImageOrder then
            Error(
                "Small non-abelian determinant-index mismatch for ",
                input.sourceKey, "."
            );
        fi;

        if record.smoothnessStatus = "smooth" then
            input.smoothnessStatus := "explicit_smooth";
            input.smoothnessCoefficients := record.smoothnessCoefficients;
            input.smoothPolynomial := record.smoothPolynomial;
            Add(SaturationInputSmallNonabelianSmooth, input);
        elif record.smoothnessStatus = "unknown" then
            input.smoothnessStatus := "unresolved";
            Add(SaturationInputSmallNonabelianUnresolved, input);
        else
            Error(
                "A singular small family entered the saturation data: ",
                input.sourceKey, "."
            );
        fi;
    od;

    SaturationInputSmallNonabelian := Concatenation(
        SaturationInputSmallNonabelianSmooth,
        SaturationInputSmallNonabelianUnresolved
    );

    SaturationInputCandidates := Concatenation(
        SaturationInputLargeFamilies,
        SaturationInputLiftableAbelian,
        SaturationInputNonliftableAbelian,
        SaturationInputSmallNonabelian
    );
    SaturationInputSpecialNoSaturation := Filtered(
        SaturationInputCandidates,
        candidate -> candidate.isSpecialSaturationExempt = true
    );
    SaturationInputRankBelow15SymplecticFamilies := Filtered(
        SaturationInputCandidates,
        candidate -> candidate.sourceCategory <> "rank_at_least_15"
                     and candidate.isSymplecticFamily = true
    );

    for number in [ 1 .. Length(SaturationInputCandidates) ] do
        SaturationInputCandidates[number].inputNumber := number;
        SaturationInputCandidates[number].requiresSaturationCheck :=
            SaturationInputCandidates[number].saturationTag = "check";
        SaturationInputCandidates[number].eligibleForSaturation :=
            SaturationInputCandidates[number].requiresSaturationCheck
            and SaturationInputCandidates[number].smoothnessStatus
                <> "unresolved";
    od;

    SaturationInputKnownSaturated := Filtered(
        SaturationInputCandidates,
        candidate -> candidate.saturationTag = "known_saturated"
    );
    SaturationInputForSaturationCheck := Filtered(
        SaturationInputCandidates,
        candidate -> candidate.eligibleForSaturation = true
    );

    if Length(SaturationInputLargeFamilies) <> 76
       or Length(SaturationInputLiftableAbelian) <> 53
       or Length(SaturationInputNonliftableAbelian) <> 2
       or Length(SaturationInputSmallNonabelianSmooth) <> 46
       or Length(SaturationInputSmallNonabelianUnresolved) <> 7
       or Length(SaturationInputSpecialNoSaturation) <> 3
       or Length(SaturationInputRankBelow15SymplecticFamilies) <> 8
       or Length(SaturationInputKnownSaturated) <> 60
       or Number(
           SaturationInputLargeFamilies,
           r -> r.symplecticPart = "QD_16"
                and r.fullIndex = 2
                and r.saturationTag = "known_saturated"
       ) <> 1
       or ForAny(
           SaturationInputRankBelow15SymplecticFamilies,
           r -> r.familyDimension <> 20 - r.rankS
       )
       or Length(SaturationInputCandidates) <> 184 then
        Error("The unified saturation input counts do not match the audit.");
    fi;

    SaturationInputSummary := rec(
        largeRankAtLeast15 := 76,
        largeKnownSaturatedFamiliesNoSaturationCheck := 49,
        largeFamiliesForSmoothnessCheck := 31,
        largeFamiliesForSelfConjugacyCheck :=
            LargeKoikeFamilySourceRecord.selfConjugacyCheckCount,
        largeProperFamiliesForSaturationCheck := 27,
        rankBelow15SymplecticFamiliesNoSaturationCheck := 8,
        rankBelow15SymplecticFamilySourceKeys := List(
            SaturationInputRankBelow15SymplecticFamilies,
            record -> record.sourceKey
        ),
        liftableAbelian := 53,
        nonliftableAbelian := 2,
        smallNonabelianSmooth := 46,
        smallNonabelianUnresolved := 7,
        smallNonabelianExcludedSingular := 129,
        specialFamiliesNoSaturationCheck := 3,
        specialNoSaturationSourceKeys :=
            List(SaturationInputSpecialNoSaturation, r -> r.sourceKey),
        knownSaturatedTotal := Length(SaturationInputKnownSaturated),
        permanentTargetTotal := Number(
            SaturationInputCandidates,
            r -> r.initiallySaturated = true
        ),
        saturationCheckEligibleTotal :=
            Length(SaturationInputForSaturationCheck),
        totalIncluded := 184,
        unresolvedIncluded := true,
        singularIncluded := false
    );

    return SaturationInputSummary;
end;

SaturationInputBuildResult := CF_SAT_BuildInput();
