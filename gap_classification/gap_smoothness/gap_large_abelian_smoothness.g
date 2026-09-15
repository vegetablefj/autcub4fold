#############################################################################
##
## gap_large_abelian_smoothness.g
##
## Exact smooth-member verification for the rank-at-least-15, liftable
## abelian, and non-liftable abelian candidate lists (131 records in total).
##
## Every invariant cubic space is reconstructed from its strict linear
## generators.  The stored invariant, centralizer, and family dimensions are
## audited before Singular is called.  A family is marked smooth only after
## an explicit member has empty projective Jacobian locus in characteristic
## zero.
##
## All 76 large-group records and all abelian records are checked
## computationally.  The recorded execution environment is WSL GAP 4.12.1
## with the system Singular and GNU timeout.  This entry point writes the
## module's large/abelian .log and GAP-readable .out files.
##
#############################################################################

CF_LAS_Paths := function()
    if IsExistingFile("gap_large_abelian_smoothness.g") then
        return rec(
            classificationDirectory := "../",
            smoothnessDirectory := "",
            saturationDirectory := "../gap_saturation/",
            liftableDirectory := "../gap_liftable_abelian/",
            nonliftableDirectory := "../gap_nonliftable_abelian/"
        );
    fi;
    if IsExistingFile(
        Concatenation(
            "gap_classification/gap_smoothness/",
            "gap_large_abelian_smoothness.g"
        )
    ) then
        return rec(
            classificationDirectory := "gap_classification/",
            smoothnessDirectory := "gap_classification/gap_smoothness/",
            saturationDirectory := "gap_classification/gap_saturation/",
            liftableDirectory :=
                "gap_classification/gap_liftable_abelian/",
            nonliftableDirectory :=
                "gap_classification/gap_nonliftable_abelian/"
        );
    fi;
    if IsExistingFile(
        "gap_smoothness/gap_large_abelian_smoothness.g"
    ) then
        return rec(
            classificationDirectory := "",
            smoothnessDirectory := "gap_smoothness/",
            saturationDirectory := "gap_saturation/",
            liftableDirectory := "gap_liftable_abelian/",
            nonliftableDirectory := "gap_nonliftable_abelian/"
        );
    fi;
    Error(
        "Run from the repository root, gap_classification, or ",
        "gap_classification/gap_smoothness."
    );
end;


CF_LAS_PathRecord := CF_LAS_Paths();

if not IsBound(CF_CubicInvariantBasis)
   or not IsBound(CF_CentralizerAlgebraBasis) then
    Read(Concatenation(
        CF_LAS_PathRecord.classificationDirectory,
        "gap_functions.g"
    ));
fi;
if not IsBound(CF_SMOOTH_FindExactSmoothMember) then
    Read(Concatenation(
        CF_LAS_PathRecord.smoothnessDirectory,
        "gap_smoothness_functions.g"
    ));
fi;
if not IsBound(LargeKoikeFamilies) then
    Read(Concatenation(
        CF_LAS_PathRecord.saturationDirectory,
        "gap_large_koike_families.g"
    ));
fi;
if not IsBound(FinalLiftableAbelianCandidates) then
    Read(Concatenation(
        CF_LAS_PathRecord.liftableDirectory,
        "gap_liftable_abelian_data.g"
    ));
fi;
if not IsBound(FinalNonliftableAbelianCandidates) then
    Read(Concatenation(
        CF_LAS_PathRecord.nonliftableDirectory,
        "gap_nonliftable_abelian_data.g"
    ));
fi;


#############################################################################
## Options and output
#############################################################################

if not IsBound(CF_LAS_AUTO_RUN) then
    CF_LAS_AUTO_RUN := true;
fi;
if not IsBound(CF_LAS_MAX_MEMBER_TRIALS) then
    CF_LAS_MAX_MEMBER_TRIALS := 12;
fi;
if not IsBound(CF_LAS_MEMBER_TIMEOUT_SECONDS) then
    CF_LAS_MEMBER_TIMEOUT_SECONDS := 120;
fi;
if not IsBound(CF_LAS_PRINT_PROGRESS) then
    CF_LAS_PRINT_PROGRESS := true;
fi;
if not IsBound(CF_LAS_LOG_FILE) then
    CF_LAS_LOG_FILE := Concatenation(
        CF_LAS_PathRecord.smoothnessDirectory,
        "gap_large_abelian_smoothness.log"
    );
fi;
if not IsBound(CF_LAS_OUTPUT_FILE) then
    CF_LAS_OUTPUT_FILE := Concatenation(
        CF_LAS_PathRecord.smoothnessDirectory,
        "gap_large_abelian_smoothness.out"
    );
fi;


CF_LAS_Log := function(arg)
    local item;
    for item in arg do
        if CF_LAS_PRINT_PROGRESS then
            Print(item);
        fi;
        AppendTo(CF_LAS_LOG_FILE, item);
    od;
end;


CF_LAS_ResolveTools := function()
    local tools;
    tools := CF_SNS_ExternalTools();
    if IsBoundGlobal("CF_LAS_SINGULAR_EXECUTABLE") then
        tools.singular := ValueGlobal("CF_LAS_SINGULAR_EXECUTABLE");
    fi;
    if IsBoundGlobal("CF_LAS_TIMEOUT_EXECUTABLE") then
        tools.timeout := ValueGlobal("CF_LAS_TIMEOUT_EXECUTABLE");
    fi;
    return tools;
end;


#############################################################################
## Uniform input records
#############################################################################

CF_LAS_InputRecord := function(sourceCategory, sourcePosition, record)
    local input;

    input := rec(
        sourceCategory := sourceCategory,
        sourcePosition := sourcePosition,
        sourceRecord := record
    );

    if sourceCategory = "rank_at_least_15" then
        input.label := Concatenation("large-", String(sourcePosition));
        input.matrixGenerators := record.matrixGenerators;
        input.projectiveGroupId := ShallowCopy(record.projectiveGroupId);
        input.linearGroupId := ShallowCopy(record.linearGroupId);
        input.symplecticPart := record.symplecticPart;
        input.rankS := record.rankS;
        input.storedInvariantDimension := record.cubicInvariantDimension;
        input.storedCentralizerDimension :=
            record.cubicInvariantDimension - record.familyDimension;
        input.storedFamilyDimension := record.familyDimension;
        input.theoreticalSource := record.reference;
    elif sourceCategory = "liftable_abelian" then
        input.label := record.label;
        input.matrixGenerators := record.generators;
        input.projectiveGroupId := ShallowCopy(record.PGLId);
        input.linearGroupId := ShallowCopy(record.GLId);
        input.symplecticPart := "abelian";
        input.rankS := fail;
        input.storedInvariantDimension := record.invariantCubicDimension;
        input.storedCentralizerDimension := record.centralizerGLDimension;
        input.storedFamilyDimension := record.familyDimension;
        input.theoreticalSource :=
            "Peng--Zheng maximal liftable types and their subgroups";
    elif sourceCategory = "nonliftable_abelian" then
        input.label := record.label;
        input.matrixGenerators := record.matrixGenerators;
        input.projectiveGroupId := ShallowCopy(record.projectiveGroupId);
        input.linearGroupId := ShallowCopy(record.linearGroupId);
        input.symplecticPart := record.symplecticPart;
        input.rankS := record.rankS;
        input.storedInvariantDimension := record.cubicInvariantDimension;
        input.storedCentralizerDimension := record.centralizerDimension;
        input.storedFamilyDimension := record.familyDimension;
        input.theoreticalSource := record.smoothnessStatus;
    else
        Error("Unknown smoothness source category: ", sourceCategory, ".");
    fi;

    return input;
end;


CF_LAS_AllInputs := function()
    local inputs, position, record;

    if Length(LargeKoikeFamilies) <> 76 then
        Error("Expected 76 rank-at-least-15 candidate records.");
    fi;
    if Length(FinalLiftableAbelianCandidates) <> 53 then
        Error("Expected 53 liftable abelian candidate records.");
    fi;
    if Length(FinalNonliftableAbelianCandidates) <> 2 then
        Error("Expected two non-liftable abelian candidate records.");
    fi;

    inputs := [];
    position := 0;
    for record in LargeKoikeFamilies do
        position := position + 1;
        Add(inputs, CF_LAS_InputRecord(
            "rank_at_least_15",
            position,
            record
        ));
    od;
    position := 0;
    for record in FinalLiftableAbelianCandidates do
        position := position + 1;
        Add(inputs, CF_LAS_InputRecord(
            "liftable_abelian",
            position,
            record
        ));
    od;
    position := 0;
    for record in FinalNonliftableAbelianCandidates do
        position := position + 1;
        Add(inputs, CF_LAS_InputRecord(
            "nonliftable_abelian",
            position,
            record
        ));
    od;
    return inputs;
end;


# Reconstruct the basis and centralizer; compare dimensions, not basis order
# or group IDs. Witness coefficients refer to this reconstructed basis.
CF_LAS_PrepareCandidate := function(input)
    local cubic, centralizer, computedFamilyDimension, audit, candidate;

    cubic := CF_CubicInvariantBasis(
        input.matrixGenerators,
        rec(buildPolynomialObjects := false, buildStrings := true)
    );
    centralizer := CF_CentralizerAlgebraBasis(
        input.matrixGenerators,
        false,
        6
    );
    computedFamilyDimension :=
        cubic.invariantDimension - centralizer.dimension;

    audit := rec(
        storedInvariantDimension := input.storedInvariantDimension,
        computedInvariantDimension := cubic.invariantDimension,
        storedCentralizerDimension := input.storedCentralizerDimension,
        computedCentralizerDimension := centralizer.dimension,
        storedFamilyDimension := input.storedFamilyDimension,
        computedFamilyDimension := computedFamilyDimension
    );
    audit.verified :=
        audit.storedInvariantDimension = audit.computedInvariantDimension
        and audit.storedCentralizerDimension
            = audit.computedCentralizerDimension
        and audit.storedFamilyDimension = audit.computedFamilyDimension;

    candidate := rec(
        cubicInvariantDimension := cubic.invariantDimension,
        cubicInvariantBasisVectors := cubic.coefficientBasis,
        cubicInvariantBasisStrings := cubic.polynomialStrings,
        cubicMonomialExponents := cubic.monomialExponents
    );
    return rec(candidate := candidate, audit := audit);
end;


CF_LAS_SourceCount := function(results, category, status)
    return Number(
        results,
        result -> result.sourceCategory = category
                  and (status = fail or result.status = status)
    );
end;


#############################################################################
## Main verification
#############################################################################

CF_LAS_Run := function()
    local tools, inputs, results, startTime, position, input,
          candidateStartTime, prepared, witness, result,
          dimensionAuditCount, dimensionFailureCount, smoothCount,
          computationalSmoothCount, unknownCount, run, outputStream;

    if not IsInt(CF_LAS_MAX_MEMBER_TRIALS)
       or CF_LAS_MAX_MEMBER_TRIALS < 1 then
        Error("CF_LAS_MAX_MEMBER_TRIALS must be a positive integer.");
    fi;
    if not IsInt(CF_LAS_MEMBER_TIMEOUT_SECONDS)
       or CF_LAS_MEMBER_TIMEOUT_SECONDS < 1 then
        Error("CF_LAS_MEMBER_TIMEOUT_SECONDS must be a positive integer.");
    fi;

    tools := CF_LAS_ResolveTools();
    if tools.singular = fail or tools.timeout = fail then
        Error("Singular and GNU timeout are required for this verification.");
    fi;
    inputs := CF_LAS_AllInputs();
    results := [];
    startTime := Runtime();

    PrintTo(
        CF_LAS_LOG_FILE,
        "Large and abelian smoothness verification log\n\n",
        "Environment: WSL (Ubuntu)\n",
        "GAP version: ", GAPInfo.Version, "\n",
        "Rank-at-least-15 candidates: 76\n",
        "Large candidates checked computationally: 76\n",
        "Liftable abelian candidates: 53\n",
        "Non-liftable abelian candidates: 2\n",
        "Maximum exact members per family: ",
        CF_LAS_MAX_MEMBER_TRIALS, "\n",
        "Timeout per member: ", CF_LAS_MEMBER_TIMEOUT_SECONDS, " s\n",
        "Singular: ", tools.singular, "\n",
        "GNU timeout: ", tools.timeout, "\n\n",
        "Progress\n"
    );

    for position in [1 .. Length(inputs)] do
        input := inputs[position];
        candidateStartTime := Runtime();
        prepared := CF_LAS_PrepareCandidate(input);
        if not prepared.audit.verified then
            Error(
                "Dimension audit failed for ", input.label,
                " from ", input.sourceCategory, "."
            );
        fi;
        witness := CF_SMOOTH_FindExactSmoothMember(
            prepared.candidate,
            tools,
            CF_LAS_MAX_MEMBER_TRIALS,
            CF_LAS_MEMBER_TIMEOUT_SECONDS
        );
        result := rec(
            number := position,
            sourceCategory := input.sourceCategory,
            sourcePosition := input.sourcePosition,
            label := input.label,
            symplecticPart := input.symplecticPart,
            rankS := input.rankS,
            projectiveGroupId := input.projectiveGroupId,
            linearGroupId := input.linearGroupId,
            verificationMode := "exact_computation",
            dimensionAudit := prepared.audit,
            theoreticalSource := input.theoreticalSource,
            status := witness.status,
            proofType := witness.proofType,
            trials := witness.trials,
            runtimeMilliseconds := Runtime() - candidateStartTime
        );
        if witness.status = "smooth" then
            result.coefficients := witness.coefficients;
            result.smoothPolynomial := witness.polynomial;
        fi;
        CF_LAS_Log(
            position, ". ", input.sourceCategory, " ", input.label,
            ": ", result.status,
            "; exact computation; dimensions = ",
            prepared.audit.computedInvariantDimension, "/",
            prepared.audit.computedCentralizerDimension, "/",
            prepared.audit.computedFamilyDimension,
            "; elapsed ", result.runtimeMilliseconds, " ms\n"
        );
        Add(results, result);
    od;

    dimensionAuditCount := Number(
        results,
        result -> result.dimensionAudit <> fail
    );
    dimensionFailureCount := Number(
        results,
        result -> result.dimensionAudit <> fail
                  and not result.dimensionAudit.verified
    );
    smoothCount := Number(results, result -> result.status = "smooth");
    computationalSmoothCount := Number(
        results,
        result -> result.status = "smooth"
                  and result.verificationMode = "exact_computation"
    );
    unknownCount := Number(results, result -> result.status = "unknown");

    run := rec(
        schemaVersion := 1,
        sourceFiles := [
            "gap_saturation/gap_large_koike_families.g",
            "gap_liftable_abelian/gap_liftable_abelian_data.g",
            "gap_nonliftable_abelian/gap_nonliftable_abelian_data.g"
        ],
        numberOfCandidates := Length(results),
        rankAtLeast15Count :=
            CF_LAS_SourceCount(results, "rank_at_least_15", fail),
        liftableAbelianCount :=
            CF_LAS_SourceCount(results, "liftable_abelian", fail),
        nonliftableAbelianCount :=
            CF_LAS_SourceCount(results, "nonliftable_abelian", fail),
        dimensionAuditCount := dimensionAuditCount,
        dimensionFailureCount := dimensionFailureCount,
        smoothCount := smoothCount,
        computationalSmoothCount := computationalSmoothCount,
        unknownCount := unknownCount,
        allDimensionsVerified := dimensionFailureCount = 0,
        allFamiliesSmooth := smoothCount = Length(results),
        maximumMemberTrials := CF_LAS_MAX_MEMBER_TRIALS,
        memberTimeoutSeconds := CF_LAS_MEMBER_TIMEOUT_SECONDS,
        externalTools := rec(
            environment := "WSL (Ubuntu)",
            gapVersion := GAPInfo.Version,
            singular := tools.singular,
            timeout := tools.timeout
        ),
        runtimeMilliseconds := Runtime() - startTime,
        results := results
    );

    outputStream := OutputTextFile(CF_LAS_OUTPUT_FILE, false);
    if outputStream = fail then
        Error("Cannot create ", CF_LAS_OUTPUT_FILE, ".");
    fi;
    SetPrintFormattingStatus(outputStream, false);
    PrintTo(
        outputStream,
        "# Generated by gap_large_abelian_smoothness.g.\n",
        "# GAP-readable exact smoothness certificates.\n\n",
        "LargeAbelianSmoothnessRun := ", run, ";\n",
        "LargeAbelianSmoothnessResults := ",
        "LargeAbelianSmoothnessRun.results;\n"
    );
    CloseStream(outputStream);

    CF_LAS_Log(
        "\nSummary\n",
        "dimension audits passed = ",
        dimensionAuditCount - dimensionFailureCount, "/",
        dimensionAuditCount, " computational checks\n",
        "smooth = ", smoothCount, "/", Length(results), "\n",
        "  exact computational certificates = ",
        computationalSmoothCount, "\n",
        "unknown = ", unknownCount, "\n",
        "runtime = ", run.runtimeMilliseconds, " ms\n",
        "output = ", CF_LAS_OUTPUT_FILE, "\n"
    );
    return run;
end;


if CF_LAS_AUTO_RUN then
    CF_LAS_LAST_RUN := CF_LAS_Run();
fi;
