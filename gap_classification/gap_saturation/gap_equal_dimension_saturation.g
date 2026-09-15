#############################################################################
## Traceable equal-dimensional saturation search.
##
## The 177 certified-smooth families are loaded from gap_saturation_input.g.
## The seven unresolved small non-abelian families are excluded.  Records
## tagged known_saturated remain permanent targets and are never proper-order
## sources.  The tag is mathematical input, not a conclusion of this driver.
##
## Output:
##   gap_equal_dimension_saturation.log  incremental readable transcript;
##   gap_equal_dimension_saturation.out  GAP-readable final audit record.
## A deliberate run replaces both files.
#############################################################################

CF_EQSAT_Paths := function()
    if IsExistingFile("gap_equal_dimension_saturation.g") then
        return rec(
            saturationDirectory := "",
            outputFile := "gap_equal_dimension_saturation.out",
            logFile := "gap_equal_dimension_saturation.log"
        );
    fi;
    if IsExistingFile(Concatenation(
        "gap_classification/gap_saturation/",
        "gap_equal_dimension_saturation.g"
    )) then
        return rec(
            saturationDirectory := "gap_classification/gap_saturation/",
            outputFile := Concatenation(
                "gap_classification/gap_saturation/",
                "gap_equal_dimension_saturation.out"
            ),
            logFile := Concatenation(
                "gap_classification/gap_saturation/",
                "gap_equal_dimension_saturation.log"
            )
        );
    fi;
    Error("Run from the repository root or gap_classification/gap_saturation.");
end;


CF_EQSAT_PathRecord := CF_EQSAT_Paths();
if IsBound(CF_EQSAT_OUTPUT_FILE_OVERRIDE) then
    CF_EQSAT_PathRecord.outputFile := CF_EQSAT_OUTPUT_FILE_OVERRIDE;
fi;
if IsBound(CF_EQSAT_LOG_FILE_OVERRIDE) then
    CF_EQSAT_PathRecord.logFile := CF_EQSAT_LOG_FILE_OVERRIDE;
fi;

Read(Concatenation(
    CF_EQSAT_PathRecord.saturationDirectory,
    "gap_saturation_input.g"
));
Read(Concatenation(
    CF_EQSAT_PathRecord.saturationDirectory,
    "gap_containment_functions.g"
));


CF_EQSAT_Candidates := Filtered(
    SaturationInputCandidates,
    record -> record.smoothnessStatus <> "unresolved"
);
CF_EQSAT_KnownSaturated := Filtered(
    CF_EQSAT_Candidates,
    record -> record.saturationTag = "known_saturated"
);
CF_EQSAT_Sources := Filtered(
    CF_EQSAT_Candidates,
    record -> record.eligibleForSaturation = true
);

if Length(CF_EQSAT_Candidates) <> 177
   or Length(CF_EQSAT_KnownSaturated) <> 60
   or Length(CF_EQSAT_Sources) <> 117
   or Length(SaturationInputSmallNonabelianUnresolved) <> 7 then
    Error("The equal-dimensional saturation input failed its audit.");
fi;


CF_EQSAT_CompactPair := function(pair)
    return rec(
        sourcePosition := pair.sourcePosition,
        targetPosition := pair.targetPosition,
        sourceKey := pair.sourceKey,
        targetKey := pair.targetKey,
        sourceOrder := pair.sourceOrder,
        targetOrder := pair.targetOrder,
        familyDimension := pair.sourceFamilyDimension,
        status := pair.status,
        method := pair.method,
        reason := pair.reason
    );
end;


CF_EQSAT_CompactEdge := function(edgeNumber, certificate)
    local result, search;

    search := certificate.edge.embeddingResult;
    result := rec(
        edgeNumber := edgeNumber,
        kind := certificate.kind,
        sourcePosition := certificate.edge.sourcePosition,
        targetPosition := certificate.edge.targetPosition,
        sourceKey := certificate.edge.sourceKey,
        targetKey := certificate.edge.targetKey,
        sourceOrder := certificate.edge.sourceOrder,
        targetOrder := certificate.edge.targetOrder,
        familyDimension := certificate.edge.sourceFamilyDimension,
        method := certificate.edge.method,
        reason := certificate.edge.reason,
        images := fail,
        conjugatingMatrix := fail
    );
    if IsBound(search.images) then
        result.images := search.images;
    fi;
    if IsBound(search.P) then
        result.conjugatingMatrix := search.P;
    fi;
    return result;
end;


CF_EQSAT_FamilyResult := function(position, trace)
    local candidate;

    candidate := CF_EQSAT_Candidates[position];
    return rec(
        inputPosition := position,
        key := candidate.sourceKey,
        sourceCategory := candidate.sourceCategory,
        symplecticPart := candidate.symplecticPart,
        projectiveGroupId := candidate.projectiveGroupId,
        linearGroupId := candidate.linearGroupId,
        fullIndex := candidate.fullIndex,
        familyDimension := candidate.familyDimension,
        groupOrder := trace.groupOrder,
        inputSaturationTag := candidate.saturationTag,
        disposition := trace.disposition,
        directTargetPosition := trace.directTargetPosition,
        directTargetKey := trace.directTargetKey,
        finalTargetPosition := trace.finalTargetPosition,
        finalTargetKey := trace.finalTargetKey,
        finalStatus := trace.finalStatus,
        containmentPathPositions := trace.pathPositions,
        containmentPathKeys := trace.pathKeys,
        containmentPathEdgeNumbers := trace.pathEdgeNumbers,
        sourceUndecidedCount := trace.sourceUndecidedCount,
        pathUndecidedCount := trace.pathUndecidedCount
    );
end;


## Use an explicit stream so that a deliberate rerun replaces the preceding
## transcript instead of stopping because the log file already exists.
CF_EQSAT_LogStream := OutputTextFile(
    CF_EQSAT_PathRecord.logFile,
    false
);
LogTo(CF_EQSAT_LogStream);
PrintTo(
    CF_EQSAT_PathRecord.outputFile,
    "EqualDimensionSaturationAudit := rec(",
    "status := \"running\", inputCount := 177);\n"
);
Print("============================================================\n");
Print("Traceable equal-dimensional saturation search\n");
Print("============================================================\n");
Print("Certified-smooth input: 177\n");
Print("Known saturated permanent targets: 60\n");
Print("Candidates requiring comparison: 117\n");
Print("Unresolved smoothness records excluded: 7\n");
Print("Dimension-zero input: ", Number(
    CF_EQSAT_Candidates,
    record -> record.familyDimension = 0
), "\n\n");

CF_EQSAT_Headers := CF_PrepareContainmentRecordHeaders(
    CF_EQSAT_Candidates
);
CF_EQSAT_Result := CF_TraceEqualDimensionSaturationLazy(
    CF_EQSAT_Headers,
    rec(
        stop_first := true,
        construct_witness := false,
        try_literal_inclusion := true,
        use_abstract_id_filter := true,
        pair_progress := true,
        progress_interval := 5
    )
);


CF_EQSAT_DirectEdges := [];
for CF_EQSAT_Number in [ 1 .. Length(CF_EQSAT_Result.directEdges) ] do
    Add(
        CF_EQSAT_DirectEdges,
        CF_EQSAT_CompactEdge(
            CF_EQSAT_Number,
            CF_EQSAT_Result.directEdges[CF_EQSAT_Number]
        )
    );
od;

CF_EQSAT_NoEmbeddingPairs := List(
    CF_EQSAT_Result.noEmbeddingPairs,
    CF_EQSAT_CompactPair
);
CF_EQSAT_UndecidedPairs := List(
    CF_EQSAT_Result.undecidedPairs,
    CF_EQSAT_CompactPair
);

CF_EQSAT_FamilyResults := [];
for CF_EQSAT_Number in [ 1 .. Length(CF_EQSAT_Candidates) ] do
    Add(
        CF_EQSAT_FamilyResults,
        CF_EQSAT_FamilyResult(
            CF_EQSAT_Number,
            CF_EQSAT_Result.familyTraces[CF_EQSAT_Number]
        )
    );
od;

CF_EQSAT_SaturationClasses := [];
for CF_EQSAT_Number in [ 1 .. Length(CF_EQSAT_Result.saturationClasses) ] do
    CF_EQSAT_Class := CF_EQSAT_Result.saturationClasses[CF_EQSAT_Number];
    Add(CF_EQSAT_SaturationClasses, rec(
        classNumber := CF_EQSAT_Number,
        finalTargetPosition := CF_EQSAT_Class.finalTargetPosition,
        finalTargetKey := CF_EQSAT_Class.finalTargetKey,
        finalStatus := CF_EQSAT_Class.finalStatus,
        familyDimension := CF_EQSAT_Class.familyDimension,
        groupOrder := CF_EQSAT_Class.groupOrder,
        memberCount := CF_EQSAT_Class.memberCount,
        memberPositions := CF_EQSAT_Class.memberPositions,
        memberKeys := CF_EQSAT_Class.memberKeys
    ));
od;

CF_EQSAT_Dimensions := Set(List(
    CF_EQSAT_Candidates,
    record -> record.familyDimension
));
CF_EQSAT_DimensionSummary := List(
    CF_EQSAT_Dimensions,
    dimension -> rec(
        familyDimension := dimension,
        inputCount := Number(
            CF_EQSAT_FamilyResults,
            result -> result.familyDimension = dimension
        ),
        removedCount := Number(
            CF_EQSAT_FamilyResults,
            result -> result.familyDimension = dimension
                      and result.directTargetPosition <> fail
        ),
        survivorCount := Number(
            CF_EQSAT_FamilyResults,
            result -> result.familyDimension = dimension
                      and result.directTargetPosition = fail
        ),
        knownSaturatedSurvivorCount := Number(
            CF_EQSAT_FamilyResults,
            result -> result.familyDimension = dimension
                      and result.directTargetPosition = fail
                      and result.finalStatus = "known_saturated"
        ),
        computedSaturatedSurvivorCount := Number(
            CF_EQSAT_FamilyResults,
            result -> result.familyDimension = dimension
                      and result.directTargetPosition = fail
                      and result.finalStatus = "computed_saturated"
        ),
        unresolvedSurvivorCount := Number(
            CF_EQSAT_FamilyResults,
            result -> result.familyDimension = dimension
                      and result.directTargetPosition = fail
                      and result.finalStatus = "unresolved"
        )
    )
);

CF_EQSAT_Audit := rec(
    schemaVersion := 2,
    status := "completed",
    algorithm := rec(
        equalOrderFirst := true,
        sourceOrder := "ascending within each dimension",
        targetOrder := "ascending group order",
        targetPool := "all equal-dimensional representatives",
        stopAtFirstProperOvergroup := true,
        parentChainsResolvedToFinalTargets := true
    ),
    inputAudit := rec(
        certifiedSmoothCount := Length(CF_EQSAT_Candidates),
        knownSaturatedCount := Length(CF_EQSAT_KnownSaturated),
        comparisonSourceCount := Length(CF_EQSAT_Sources),
        unresolvedExcludedCount :=
            Length(SaturationInputSmallNonabelianUnresolved),
        dimensionZeroCount := Number(
            CF_EQSAT_Candidates,
            record -> record.familyDimension = 0
        )
    ),
    testedPairCount := CF_EQSAT_Result.testedPairCount,
    strictTestCount := CF_EQSAT_Result.strictTestCount,
    cheapRejectedCount := CF_EQSAT_Result.cheapRejectedCount,
    abstractRejectedCount := CF_EQSAT_Result.abstractRejectedCount,
    abstractUnknownCount := CF_EQSAT_Result.abstractUnknownCount,
    abstractCacheEntryCount := CF_EQSAT_Result.abstractCacheEntryCount,
    preprocessedRecordCount := CF_EQSAT_Result.preprocessedRecordCount,
    equalOrderDuplicateCount := Number(
        CF_EQSAT_DirectEdges,
        edge -> edge.kind = "equal_order_equivalence"
    ),
    properRemovalCount := Number(
        CF_EQSAT_DirectEdges,
        edge -> edge.kind = "proper_equal_dimension_overgroup"
    ),
    removedCount := CF_EQSAT_Result.removedCount,
    survivorCount := CF_EQSAT_Result.remainingCount,
    knownSaturatedSurvivorCount := Length(
        CF_EQSAT_Result.knownSaturatedSurvivorPositions
    ),
    computedSaturatedSurvivorCount := Length(
        CF_EQSAT_Result.computedSaturatedPositions
    ),
    unresolvedSurvivorCount := Length(
        CF_EQSAT_Result.unresolvedSurvivorPositions
    ),
    undecidedCount := CF_EQSAT_Result.undecidedCount,
    maximaComplete := CF_EQSAT_Result.maximaComplete,
    runtimeMilliseconds := CF_EQSAT_Result.runtimeMilliseconds,
    dimensionSummary := CF_EQSAT_DimensionSummary,
    survivorKeys := List(
        CF_EQSAT_Result.keptPositions,
        position -> CF_EQSAT_Candidates[position].sourceKey
    ),
    removedKeys := List(
        CF_EQSAT_Result.removedPositions,
        position -> CF_EQSAT_Candidates[position].sourceKey
    ),
    directEdges := CF_EQSAT_DirectEdges,
    noEmbeddingPairs := CF_EQSAT_NoEmbeddingPairs,
    undecidedPairs := CF_EQSAT_UndecidedPairs,
    familyResults := CF_EQSAT_FamilyResults,
    saturationClasses := CF_EQSAT_SaturationClasses
);

PrintTo(
    CF_EQSAT_PathRecord.outputFile,
    "EqualDimensionSaturationAudit := ",
    CF_EQSAT_Audit,
    ";\n"
);

Print("\n============================================================\n");
Print("Equal-dimensional saturation search completed\n");
Print("============================================================\n");
Print("Tested pairs: ", CF_EQSAT_Audit.testedPairCount, "\n");
Print("Strict embedding tests: ", CF_EQSAT_Audit.strictTestCount, "\n");
Print("Equal-order duplicates: ",
      CF_EQSAT_Audit.equalOrderDuplicateCount, "\n");
Print("Proper-order removals: ",
      CF_EQSAT_Audit.properRemovalCount, "\n");
Print("Surviving families: ", CF_EQSAT_Audit.survivorCount, "\n");
Print("Unresolved surviving families: ",
      CF_EQSAT_Audit.unresolvedSurvivorCount, "\n");
Print("Undecided pairs: ", CF_EQSAT_Audit.undecidedCount, "\n");
Print("Complete: ", CF_EQSAT_Audit.maximaComplete, "\n");
Print("Runtime: ", CF_EQSAT_Audit.runtimeMilliseconds, " ms\n");
Print("Output: ", CF_EQSAT_PathRecord.outputFile, "\n");
Print("Log: ", CF_EQSAT_PathRecord.logFile, "\n");
LogTo();
CloseStream(CF_EQSAT_LogStream);

Unbind(CF_EQSAT_Number);
Unbind(CF_EQSAT_LogStream);
if IsBound(CF_EQSAT_Class) then
    Unbind(CF_EQSAT_Class);
fi;
