#############################################################################
##
## gap_threefold_index_three.g
##
## Extract cubic-threefold matrix groups from the fixed cubic-fourfold
## search catalogue. Only non-symplectic source families whose actual index is
## divisible by three are inspected.  The source family dimension is
## inherited and independently checked from the extracted five-dimensional
## representation. The saved GAP record retains both extracted and
## no-Fermat-summand source rows in increasing fourfold-source order.
##
#############################################################################


#############################################################################
## 1. Paths and input
#############################################################################

CF_TFB_Paths := function()
    if IsExistingFile("gap_threefold_index_three.g") then
        return rec(
            selfDirectory := "",
            functionsFile := "../gap_functions.g",
            catalogueFile := Concatenation(
                "../gap_fourfold_cross_dimension/input/",
                "fourfold_search_catalogue.g"
            ),
            extractionFile := "gap_threefold_functions.g"
        );
    fi;
    if IsExistingFile(
        "gap_classification/gap_threefold/gap_threefold_index_three.g"
    ) then
        return rec(
            selfDirectory := "gap_classification/gap_threefold/",
            functionsFile := "gap_classification/gap_functions.g",
            catalogueFile := Concatenation(
                "gap_classification/gap_fourfold_cross_dimension/input/",
                "fourfold_search_catalogue.g"
            ),
            extractionFile := Concatenation(
                "gap_classification/gap_threefold/",
                "gap_threefold_functions.g"
            )
        );
    fi;
    if IsExistingFile("gap_threefold/gap_threefold_index_three.g") then
        return rec(
            selfDirectory := "gap_threefold/",
            functionsFile := "gap_functions.g",
            catalogueFile := Concatenation(
                "gap_fourfold_cross_dimension/input/",
                "fourfold_search_catalogue.g"
            ),
            extractionFile := "gap_threefold/gap_threefold_functions.g"
        );
    fi;
    Error(
        "Run from the repository root, gap_classification, or ",
        "gap_classification/gap_threefold."
    );
end;


CF_TFB_PathRecord := CF_TFB_Paths();

if not IsBound(CF_CubicInvariantBasis) then
    Read(CF_TFB_PathRecord.functionsFile);
fi;
if not IsBound(CanonicalFamilyMatrixGroups) then
    Read(CF_TFB_PathRecord.catalogueFile);
fi;
if not IsBound(CF_TF_ExtractCatalogueFamily) then
    Read(CF_TFB_PathRecord.extractionFile);
fi;


if not IsBound(CF_TFB_PRINT_PROGRESS) then
    CF_TFB_PRINT_PROGRESS := true;
fi;
if not IsBound(CF_TFB_COMPUTE_INVARIANTS) then
    CF_TFB_COMPUTE_INVARIANTS := true;
fi;
if not IsBound(CF_TFB_LOG_FILE) then
    CF_TFB_LOG_FILE := Concatenation(
        CF_TFB_PathRecord.selfDirectory,
        "output/gap_threefold_index_three.log"
    );
fi;
if not IsBound(CF_TFB_RESULT_FILE) then
    CF_TFB_RESULT_FILE := Concatenation(
        CF_TFB_PathRecord.selfDirectory,
        "input/gap_threefold_extraction.g"
    );
fi;


CF_TFB_Log := function(arg)
    local item;

    for item in arg do
        if CF_TFB_PRINT_PROGRESS then
            Print(item);
        fi;
        AppendTo(CF_TFB_LOG_FILE, item);
    od;
end;


CF_TFB_ValidateCatalogue := function()
    local numbers;

    if Length(CanonicalKoikeStandardGroups) <> 48 then
        Error("Expected 48 standard symplectic families.");
    fi;
    if Length(CanonicalFamilyMatrixGroups) <> 156 then
        Error("Expected the fixed search catalogue of 156 families.");
    fi;

    numbers := List(CanonicalFamilyMatrixGroups, family -> family.number);
    if numbers <> [1 .. 156] then
        Error("The search family numbering is not 1 through 156.");
    fi;
    if not ForAll(
        CanonicalFamilyMatrixGroups,
        family -> family.fullGroupVerified = true
            and family.determinantKernelVerified = true
    ) then
        Error("The search catalogue contains an unaudited matrix group.");
    fi;
end;


## The actual index is used here.  The generic index belongs to the connected
## symplectic family and need not equal the index of a special member.
CF_TFB_IsSelectedSource := function(family)
    return family.extraGenerator <> fail
        and IsInt(family.fullIndex)
        and family.fullIndex mod 3 = 0;
end;


#############################################################################
## 2. Compact, GAP-readable records
#############################################################################

CF_TFB_SourceMetadata := function(family)
    return rec(
        sourceFamilyNumber := family.number,
        sourceKey := family.sourceKey,
        sourceCategory := family.sourceCategory,
        sourceStandardFamilyNumber := family.standardFamilyNumber,
        sourceStandardPosition := family.standardPosition,
        sourceSymplecticPart := family.symplecticPart,
        sourceRankS := family.rankS,
        sourceGenericIndex := family.genericIndex,
        sourceFullIndex := family.fullIndex,
        sourceFamilyDimension := family.familyDimension,
        sourceLinearGroupId := family.linearGroupId,
        sourceProjectiveGroupId := family.projectiveGroupId
    );
end;


CF_TFB_CompactResult := function(family, extraction)
    local result, fermatClass, computedDimension;

    result := CF_TFB_SourceMetadata(family);
    result.status := extraction.status;
    result.producesThreefold := extraction.producesThreefold;
    result.fermatSearchMethod := extraction.fermatSearchMethod;
    result.sourceStrictOrder := extraction.sourceStrictOrder;
    result.fourfoldFermatRank := extraction.fourfoldFermatRank;

    if not extraction.producesThreefold then
        result.fermatClassCount := extraction.fermatClassData.classCount;
        result.familyDimension := family.familyDimension;
        result.dimensionMethod := "inherited_from_fourfold_family";
        return result;
    fi;

    fermatClass := extraction.fermatClassData.classes[1];
    result.threefoldFermatRank := extraction.threefoldFermatRank;
    result.fermatClassCount := extraction.fermatClassData.classCount;
    result.fermatClassSize := fermatClass.classSize;
    result.fermatElement := extraction.fermatElement;
    result.fixedSpaceBasis := extraction.fixedSpaceBasis;
    result.sourceToAdaptedBasis := extraction.sourceToAdaptedBasis;
    result.strictGenerators := extraction.strictGenerators;
    result.strictOrder := extraction.strictOrder;
    result.projectiveOrder := extraction.projectiveOrder;

    ## The inherited value is the catalogue dimension used downstream.
    result.familyDimension := family.familyDimension;
    result.dimensionMethod := "inherited_from_fourfold_family";

    if CF_TFB_COMPUTE_INVARIANTS then
        computedDimension := extraction.familyDimension;
        result.cubicMonomialExponents :=
            extraction.cubicInvariantData.monomialExponents;
        result.cubicInvariantBasisVectors :=
            extraction.cubicInvariantBasisVectors;
        result.cubicInvariantBasisStrings :=
            extraction.cubicInvariantBasisStrings;
        result.cubicInvariantDimension :=
            extraction.cubicInvariantDimension;
        result.centralizerAlgebraDimension :=
            extraction.centralizerAlgebraDimension;
        result.computedFamilyDimension := computedDimension;
        result.dimensionVerified :=
            computedDimension = family.familyDimension;
    else
        result.cubicMonomialExponents := fail;
        result.cubicInvariantBasisVectors := fail;
        result.cubicInvariantBasisStrings := fail;
        result.cubicInvariantDimension := fail;
        result.centralizerAlgebraDimension := fail;
        result.computedFamilyDimension := fail;
        result.dimensionVerified := fail;
    fi;

    return result;
end;


#############################################################################
## 3. GAP-readable output
#############################################################################


CF_TFB_WriteGapResult := function(audit)
    local stream;

    stream := OutputTextFile(CF_TFB_RESULT_FILE, false);
    if stream = fail then
        Error("Could not open the GAP-readable result file.");
    fi;
    SetPrintFormattingStatus(stream, false);
    AppendTo(
        stream,
        "CubicThreefoldIndexThreeAudit := ",
        audit,
        ";\n"
    );
    CloseStream(stream);
end;


#############################################################################
## 4. Run
#############################################################################

CF_TFB_ValidateCatalogue();
CF_TFB_SelectedSources := Filtered(
    CanonicalFamilyMatrixGroups,
    CF_TFB_IsSelectedSource
);

PrintTo(CF_TFB_LOG_FILE, "");
CF_TFB_Log(
    "============================================================\n",
    "Cubic-threefold extraction from index-three sources\n",
    "============================================================\n",
    "Fixed cubic-fourfold search catalogue: ",
    Length(CanonicalFamilyMatrixGroups), " families\n",
    "Selected non-symplectic sources with 3 dividing the index: ",
    Length(CF_TFB_SelectedSources), "\n",
    "Invariant bases: ", CF_TFB_COMPUTE_INVARIANTS, "\n\n"
);

CF_TFB_Results := [];
CF_TFB_StartTime := Runtime();

for CF_TFB_Position in [1 .. Length(CF_TFB_SelectedSources)] do
    CF_TFB_Source := CF_TFB_SelectedSources[CF_TFB_Position];
    CF_TFB_ItemStart := Runtime();
    CF_TFB_Log(
        CF_TFB_Position, "/", Length(CF_TFB_SelectedSources),
        ": source family ", CF_TFB_Source.number,
        ", dimension ", CF_TFB_Source.familyDimension,
        ", index ", CF_TFB_Source.fullIndex, "\n"
    );

    CF_TFB_Extraction := CF_TF_ExtractCatalogueFamily(
        CF_TFB_Source,
        rec(
            computeInvariantBasis := CF_TFB_COMPUTE_INVARIANTS,
            buildPolynomialObjects := false,
            buildPolynomialStrings := CF_TFB_COMPUTE_INVARIANTS,
            computeGroupDescriptions := false,
            directEnumerationBound := 400,
            retainNoFermatSources := true,
            printProgress := false
        )
    );
    CF_TFB_Result := CF_TFB_CompactResult(
        CF_TFB_Source,
        CF_TFB_Extraction
    );
    CF_TFB_Result.runtimeMilliseconds := Runtime() - CF_TFB_ItemStart;
    Add(CF_TFB_Results, CF_TFB_Result);

    if CF_TFB_Result.producesThreefold then
        CF_TFB_Log(
            "    extracted: r=", CF_TFB_Result.fourfoldFermatRank,
            " -> ", CF_TFB_Result.threefoldFermatRank,
            ", strict/projective orders=", CF_TFB_Result.strictOrder,
            "/", CF_TFB_Result.projectiveOrder,
            ", dimension=", CF_TFB_Result.familyDimension,
            ", verified=", CF_TFB_Result.dimensionVerified,
            ", method=", CF_TFB_Result.fermatSearchMethod,
            ", elapsed=", CF_TFB_Result.runtimeMilliseconds, " ms\n"
        );
    else
        CF_TFB_Log(
            "    skipped: no Fermat summand, elapsed=",
            CF_TFB_Result.runtimeMilliseconds,
            " ms, method=", CF_TFB_Result.fermatSearchMethod, "\n"
        );
    fi;
od;

CF_TFB_ExtractedResults := Filtered(
    CF_TFB_Results,
    result -> result.producesThreefold
);
CF_TFB_SkippedResults := Filtered(
    CF_TFB_Results,
    result -> not result.producesThreefold
);

CF_TFB_Audit := rec(
    schemaVersion := 1,
    status := "completed",
    gapVersion := GAPInfo.Version,
    sourceCatalogueFile := Concatenation(
        "gap_classification/gap_fourfold_cross_dimension/input/",
        "fourfold_search_catalogue.g"
    ),
    sourceCatalogueCount := Length(CanonicalFamilyMatrixGroups),
    selection :=
        "extraGenerator <> fail and fullIndex divisible by three",
    selectedSourceNumbers := List(
        CF_TFB_SelectedSources,
        family -> family.number
    ),
    selectedSourceCount := Length(CF_TFB_SelectedSources),
    extractedSourceCount := Length(CF_TFB_ExtractedResults),
    skippedSourceCount := Length(CF_TFB_SkippedResults),
    dimensionVerifiedCount := Number(
        CF_TFB_ExtractedResults,
        result -> result.dimensionVerified = true
    ),
    invariantBasesComputed := CF_TFB_COMPUTE_INVARIANTS,
    runtimeMilliseconds := Runtime() - CF_TFB_StartTime,
    results := CF_TFB_Results
);

if CF_TFB_COMPUTE_INVARIANTS
   and CF_TFB_Audit.dimensionVerifiedCount
       <> CF_TFB_Audit.extractedSourceCount then
    Error("At least one inherited family dimension failed verification.");
fi;

CF_TFB_WriteGapResult(CF_TFB_Audit);

CF_TFB_Log(
    "\nCompleted.\n",
    "Extracted sources: ", CF_TFB_Audit.extractedSourceCount, "\n",
    "Skipped sources: ", CF_TFB_Audit.skippedSourceCount, "\n",
    "Verified inherited dimensions: ",
    CF_TFB_Audit.dimensionVerifiedCount, "/",
    CF_TFB_Audit.extractedSourceCount, "\n",
    "Runtime: ", CF_TFB_Audit.runtimeMilliseconds, " ms\n",
    "GAP-readable result: ", CF_TFB_RESULT_FILE, "\n"
);
