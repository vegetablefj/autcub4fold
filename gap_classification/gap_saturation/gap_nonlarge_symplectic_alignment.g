#############################################################################
## Assign every non-large candidate to one of the eight rank-below-15
## symplectic families and test literal containment of the corresponding
## determinant-one matrix group.
##
## Assignment is determined up to linear conjugacy.  Literal containment is a
## separate exact membership test in the coordinates stored in the data.
## This audit does not alter the saturation result.
#############################################################################

CF_NSA_Paths := function()
    if IsExistingFile("gap_nonlarge_symplectic_alignment.g") then
        return rec(
            saturationDirectory := "",
            classificationDirectory := "../",
            outputFile := "gap_nonlarge_symplectic_alignment.out",
            markdownFile := "gap_nonlarge_symplectic_alignment.md"
        );
    fi;
    if IsExistingFile(Concatenation(
        "gap_classification/gap_saturation/",
        "gap_nonlarge_symplectic_alignment.g"
    )) then
        return rec(
            saturationDirectory := "gap_classification/gap_saturation/",
            classificationDirectory := "gap_classification/",
            outputFile := Concatenation(
                "gap_classification/gap_saturation/",
                "gap_nonlarge_symplectic_alignment.out"
            ),
            markdownFile := Concatenation(
                "gap_classification/gap_saturation/",
                "gap_nonlarge_symplectic_alignment.md"
            )
        );
    fi;
    Error("Run from the repository root or gap_classification/gap_saturation.");
end;


CF_NSA_PathRecord := CF_NSA_Paths();
Read(Concatenation(
    CF_NSA_PathRecord.saturationDirectory,
    "gap_saturation_input.g"
));
Read(Concatenation(
    CF_NSA_PathRecord.saturationDirectory,
    "gap_equal_dimension_saturation.out"
));
if not IsBound(SearchEmbeddingStrict) then
    Read(Concatenation(
        CF_NSA_PathRecord.classificationDirectory,
        "gap_functions.g"
    ));
fi;


CF_NSA_DeterminantKernelInfo := function(matrixGenerators)
    local fullGroup, kernelElements, kernelGroup, kernelGenerators;

    fullGroup := Group(matrixGenerators);
    kernelElements := Filtered(
        Elements(fullGroup),
        matrix -> DeterminantMat(matrix) = 1
    );
    kernelGroup := Group(kernelElements);
    kernelGenerators := GeneratorsOfGroup(kernelGroup);

    return rec(
        fullGroup := fullGroup,
        fullOrder := Size(fullGroup),
        kernelGroup := kernelGroup,
        kernelOrder := Size(kernelGroup),
        kernelGenerators := kernelGenerators,
        determinantImageOrder := Size(fullGroup) / Size(kernelGroup)
    );
end;


CF_NSA_LiteralSubgroup := function(subgroup, containingGroup)
    return ForAll(
        GeneratorsOfGroup(subgroup),
        element -> element in containingGroup
    );
end;


CF_NSA_OneGeneratorExtension := function(baseKernel, candidateInfo)
    local baseGenerators, fullIndex, positions, position, element,
          generatedGroup;

    fullIndex := candidateInfo.determinantImageOrder;
    if fullIndex = 1 then
        return rec(
            status := "not_required",
            generatorPosition := fail,
            generator := fail
        );
    fi;

    baseGenerators := GeneratorsOfGroup(baseKernel);
    positions := [ 1 .. Length(candidateInfo.inputGenerators) ];
    for position in positions do
        element := candidateInfo.inputGenerators[position];
        if Order(DeterminantMat(element)) = fullIndex then
            generatedGroup := Group(Concatenation(
                baseGenerators,
                [ element ]
            ));
            if Size(generatedGroup) = candidateInfo.fullOrder then
                return rec(
                    status := "input_generator",
                    generatorPosition := position,
                    generator := element
                );
            fi;
        fi;
    od;

    for element in Elements(candidateInfo.fullGroup) do
        if Order(DeterminantMat(element)) = fullIndex then
            generatedGroup := Group(Concatenation(
                baseGenerators,
                [ element ]
            ));
            if Size(generatedGroup) = candidateInfo.fullOrder then
                return rec(
                    status := "group_element",
                    generatorPosition := fail,
                    generator := element
                );
            fi;
        fi;
    od;

    return rec(
        status := "not_found",
        generatorPosition := fail,
        generator := fail
    );
end;


CF_NSA_SymplecticBases := [];
for CF_NSA_Number in
    [ 1 .. Length(SaturationInputRankBelow15SymplecticFamilies) ] do
    CF_NSA_Candidate :=
        SaturationInputRankBelow15SymplecticFamilies[CF_NSA_Number];
    CF_NSA_GroupInfo := CF_NSA_DeterminantKernelInfo(
        CF_NSA_Candidate.matrixGenerators
    );
    Add(CF_NSA_SymplecticBases, rec(
        ownerNumber := CF_NSA_Number,
        ownerKey := CF_NSA_Candidate.sourceKey,
        symplecticPart := CF_NSA_Candidate.symplecticPart,
        sourceCategory := CF_NSA_Candidate.sourceCategory,
        projectiveGroupId := CF_NSA_Candidate.projectiveGroupId,
        linearGroupId := CF_NSA_Candidate.linearGroupId,
        genericIndex := CF_NSA_Candidate.genericIndex,
        familyDimension := CF_NSA_Candidate.familyDimension,
        fullLinearOrder := CF_NSA_GroupInfo.fullOrder,
        symplecticLiftOrder := CF_NSA_GroupInfo.kernelOrder,
        symplecticLift := CF_NSA_GroupInfo.kernelGroup,
        symplecticLiftGenerators := CF_NSA_GroupInfo.kernelGenerators,
        strictInfo := PreprocessMatrixGroupStrict(
            CF_NSA_GroupInfo.kernelGenerators,
            CF_NSA_GroupInfo.kernelOrder,
            fail
        )
    ));
od;

if Length(CF_NSA_SymplecticBases) <> 8 then
    Error("Expected eight non-large symplectic family representatives.");
fi;


CF_NSA_NonlargeCandidates := Filtered(
    SaturationInputCandidates,
    candidate -> candidate.sourceCategory <> "rank_at_least_15"
);
CF_NSA_Results := [];
CF_NSA_StartRuntime := Runtime();

Print("Non-large symplectic-family alignment\n");
Print("Candidates: ", Length(CF_NSA_NonlargeCandidates), "\n");
Print("Symplectic family representatives: ",
      Length(CF_NSA_SymplecticBases), "\n\n");

for CF_NSA_Number in [ 1 .. Length(CF_NSA_NonlargeCandidates) ] do
    CF_NSA_Candidate := CF_NSA_NonlargeCandidates[CF_NSA_Number];
    CF_NSA_GroupInfo := CF_NSA_DeterminantKernelInfo(
        CF_NSA_Candidate.matrixGenerators
    );
    CF_NSA_GroupInfo.inputGenerators := CF_NSA_Candidate.matrixGenerators;
    CF_NSA_CandidateStrictInfo := PreprocessMatrixGroupStrict(
        CF_NSA_GroupInfo.kernelGenerators,
        CF_NSA_GroupInfo.kernelOrder,
        fail
    );
    CF_NSA_MatchingBases := Filtered(
        CF_NSA_SymplecticBases,
        base -> base.symplecticPart = CF_NSA_Candidate.symplecticPart
    );
    CF_NSA_Tests := [];

    for CF_NSA_Base in CF_NSA_MatchingBases do
        CF_NSA_Literal := CF_NSA_LiteralSubgroup(
            CF_NSA_Base.symplecticLift,
            CF_NSA_GroupInfo.fullGroup
        );
        if CF_NSA_Literal then
            CF_NSA_Search := rec(
                status := "embedded",
                method := "literal_matrix_subgroup",
                reason := "the standard symplectic lift is literally contained"
            );
        else
            CF_NSA_Search := SearchEmbeddingStrict(
                CF_NSA_Base.strictInfo,
                CF_NSA_CandidateStrictInfo,
                rec(
                    stop_first := true,
                    construct_witness := false,
                    try_literal_inclusion := false
                )
            );
        fi;
        Add(CF_NSA_Tests, rec(
            ownerNumber := CF_NSA_Base.ownerNumber,
            ownerKey := CF_NSA_Base.ownerKey,
            literalContainment := CF_NSA_Literal,
            equivalenceStatus := CF_NSA_Search.status,
            equivalenceMethod := CF_NSA_Search.method,
            equivalenceReason := CF_NSA_Search.reason
        ));
    od;

    CF_NSA_PossibleOwners := Filtered(
        CF_NSA_Tests,
        test -> test.equivalenceStatus = "embedded"
    );
    if Length(CF_NSA_PossibleOwners) <> 1 then
        Error(
            "The symplectic-family ownership is not unique for ",
            CF_NSA_Candidate.sourceKey,
            ": found ", Length(CF_NSA_PossibleOwners), "."
        );
    fi;

    CF_NSA_OwnerTest := CF_NSA_PossibleOwners[1];
    CF_NSA_Owner := CF_NSA_SymplecticBases[
        CF_NSA_OwnerTest.ownerNumber
    ];
    if CF_NSA_GroupInfo.kernelOrder <> CF_NSA_Owner.symplecticLiftOrder then
        Error("Symplectic lift order mismatch for ",
              CF_NSA_Candidate.sourceKey, ".");
    fi;

    if CF_NSA_OwnerTest.literalContainment then
        CF_NSA_Extension := CF_NSA_OneGeneratorExtension(
            CF_NSA_Owner.symplecticLift,
            CF_NSA_GroupInfo
        );
    else
        CF_NSA_Extension := rec(
            status := "requires_coordinate_change",
            generatorPosition := fail,
            generator := fail
        );
    fi;

    CF_NSA_SaturationResult := First(
        EqualDimensionSaturationAudit.familyResults,
        result -> result.key = CF_NSA_Candidate.sourceKey
    );
    if CF_NSA_SaturationResult = fail then
        CF_NSA_Survives := fail;
        CF_NSA_DirectTargetKey := fail;
        CF_NSA_FinalTargetKey := fail;
    else
        CF_NSA_Survives :=
            CF_NSA_SaturationResult.directTargetPosition = fail;
        CF_NSA_DirectTargetKey :=
            CF_NSA_SaturationResult.directTargetKey;
        CF_NSA_FinalTargetKey :=
            CF_NSA_SaturationResult.finalTargetKey;
    fi;

    Add(CF_NSA_Results, rec(
        inputNumber := CF_NSA_Candidate.inputNumber,
        sourceKey := CF_NSA_Candidate.sourceKey,
        sourceCategory := CF_NSA_Candidate.sourceCategory,
        smoothnessStatus := CF_NSA_Candidate.smoothnessStatus,
        familyDimension := CF_NSA_Candidate.familyDimension,
        projectiveGroupId := CF_NSA_Candidate.projectiveGroupId,
        linearGroupId := CF_NSA_Candidate.linearGroupId,
        fullIndex := CF_NSA_Candidate.fullIndex,
        fullLinearOrder := CF_NSA_GroupInfo.fullOrder,
        symplecticLiftOrder := CF_NSA_GroupInfo.kernelOrder,
        ownerNumber := CF_NSA_Owner.ownerNumber,
        ownerKey := CF_NSA_Owner.ownerKey,
        ownerSymplecticPart := CF_NSA_Owner.symplecticPart,
        ownerProjectiveGroupId := CF_NSA_Owner.projectiveGroupId,
        ownerGenericIndex := CF_NSA_Owner.genericIndex,
        literalSymplecticLiftContainment :=
            CF_NSA_OwnerTest.literalContainment,
        ownershipMethod := CF_NSA_OwnerTest.equivalenceMethod,
        extensionGeneratorStatus := CF_NSA_Extension.status,
        extensionGeneratorPosition :=
            CF_NSA_Extension.generatorPosition,
        extensionGenerator := CF_NSA_Extension.generator,
        survivesEqualDimensionSaturation := CF_NSA_Survives,
        directSaturationTargetKey := CF_NSA_DirectTargetKey,
        finalSaturationTargetKey := CF_NSA_FinalTargetKey,
        ownershipTests := CF_NSA_Tests
    ));

    Print(
        CF_NSA_Number, "/", Length(CF_NSA_NonlargeCandidates),
        " ", CF_NSA_Candidate.sourceKey,
        ": owner=", CF_NSA_Owner.ownerNumber,
        "; literal=", CF_NSA_OwnerTest.literalContainment,
        "; extension=", CF_NSA_Extension.status,
        "\n"
    );
od;


CF_NSA_OwnerSummary := [];
for CF_NSA_Base in CF_NSA_SymplecticBases do
    CF_NSA_Owned := Filtered(
        CF_NSA_Results,
        result -> result.ownerNumber = CF_NSA_Base.ownerNumber
    );
    Add(CF_NSA_OwnerSummary, rec(
        ownerNumber := CF_NSA_Base.ownerNumber,
        ownerKey := CF_NSA_Base.ownerKey,
        symplecticPart := CF_NSA_Base.symplecticPart,
        projectiveGroupId := CF_NSA_Base.projectiveGroupId,
        linearGroupId := CF_NSA_Base.linearGroupId,
        genericIndex := CF_NSA_Base.genericIndex,
        symplecticFamilyDimension := CF_NSA_Base.familyDimension,
        allCandidateCount := Length(CF_NSA_Owned),
        smoothInputCount := Number(
            CF_NSA_Owned,
            result -> result.smoothnessStatus <> "unresolved"
        ),
        unresolvedInputCount := Number(
            CF_NSA_Owned,
            result -> result.smoothnessStatus = "unresolved"
        ),
        survivingSmoothCount := Number(
            CF_NSA_Owned,
            result -> result.survivesEqualDimensionSaturation = true
        ),
        removedSmoothCount := Number(
            CF_NSA_Owned,
            result -> result.survivesEqualDimensionSaturation = false
        ),
        literalAllCount := Number(
            CF_NSA_Owned,
            result -> result.literalSymplecticLiftContainment = true
        ),
        literalSurvivingSmoothCount := Number(
            CF_NSA_Owned,
            result -> result.survivesEqualDimensionSaturation = true
                      and result.literalSymplecticLiftContainment = true
        ),
        coordinateChangeSurvivingSmoothCount := Number(
            CF_NSA_Owned,
            result -> result.survivesEqualDimensionSaturation = true
                      and result.literalSymplecticLiftContainment = false
        ),
        inputExtensionGeneratorCount := Number(
            CF_NSA_Owned,
            result -> result.extensionGeneratorStatus = "input_generator"
        ),
        generatedExtensionElementCount := Number(
            CF_NSA_Owned,
            result -> result.extensionGeneratorStatus = "group_element"
        ),
        sourceKeys := List(CF_NSA_Owned, result -> result.sourceKey),
        literalSourceKeys := List(
            Filtered(
                CF_NSA_Owned,
                result -> result.literalSymplecticLiftContainment = true
            ),
            result -> result.sourceKey
        ),
        coordinateChangeSourceKeys := List(
            Filtered(
                CF_NSA_Owned,
                result -> result.literalSymplecticLiftContainment = false
            ),
            result -> result.sourceKey
        )
    ));
od;


CF_NSA_Audit := rec(
    schemaVersion := 1,
    status := "completed",
    scope := "all non-large candidates; large-family source omitted",
    ownershipCriterion :=
        "linear conjugacy class of the determinant-one strict lift",
    literalContainmentCriterion :=
        "exact matrix membership without a coordinate change",
    nonlargeCandidateCount := Length(CF_NSA_Results),
    smoothInputCount := Number(
        CF_NSA_Results,
        result -> result.smoothnessStatus <> "unresolved"
    ),
    unresolvedInputCount := Number(
        CF_NSA_Results,
        result -> result.smoothnessStatus = "unresolved"
    ),
    survivingSmoothCount := Number(
        CF_NSA_Results,
        result -> result.survivesEqualDimensionSaturation = true
    ),
    removedSmoothCount := Number(
        CF_NSA_Results,
        result -> result.survivesEqualDimensionSaturation = false
    ),
    literalAllCount := Number(
        CF_NSA_Results,
        result -> result.literalSymplecticLiftContainment = true
    ),
    literalSurvivingSmoothCount := Number(
        CF_NSA_Results,
        result -> result.survivesEqualDimensionSaturation = true
                  and result.literalSymplecticLiftContainment = true
    ),
    coordinateChangeSurvivingSmoothCount := Number(
        CF_NSA_Results,
        result -> result.survivesEqualDimensionSaturation = true
                  and result.literalSymplecticLiftContainment = false
    ),
    ownershipComplete := ForAll(
        CF_NSA_Results,
        result -> Length(Filtered(
            result.ownershipTests,
            test -> test.equivalenceStatus = "embedded"
        )) = 1
    ),
    oneGeneratorFailuresAfterLiteralAlignment := Filtered(
        CF_NSA_Results,
        result -> result.literalSymplecticLiftContainment = true
                  and not result.extensionGeneratorStatus in
                      [ "not_required", "input_generator", "group_element" ]
    ),
    symplecticFamilies := CF_NSA_OwnerSummary,
    familyResults := CF_NSA_Results,
    runtimeMilliseconds := Runtime() - CF_NSA_StartRuntime
);

if CF_NSA_Audit.nonlargeCandidateCount <> 108
   or CF_NSA_Audit.smoothInputCount <> 101
   or CF_NSA_Audit.unresolvedInputCount <> 7
   or CF_NSA_Audit.survivingSmoothCount <> 80
   or CF_NSA_Audit.removedSmoothCount <> 21
   or CF_NSA_Audit.ownershipComplete <> true
   or Length(CF_NSA_Audit.oneGeneratorFailuresAfterLiteralAlignment) <> 0 then
    Error("The non-large symplectic-alignment audit failed.");
fi;

PrintTo(
    CF_NSA_PathRecord.outputFile,
    "NonlargeSymplecticAlignmentAudit := ",
    CF_NSA_Audit,
    ";\n"
);


CF_NSA_WriteFamilyLine := function(stream, result)
    AppendTo(
        stream,
        "- `", result.sourceKey, "`; PGL ID `",
        String(result.projectiveGroupId), "`, index ",
        String(result.fullIndex), ", dimension ",
        String(result.familyDimension), ", extension `",
        result.extensionGeneratorStatus, "`.\n"
    );
end;


CF_NSA_MarkdownStream := OutputTextFile(
    CF_NSA_PathRecord.markdownFile,
    false
);
SetPrintFormattingStatus(CF_NSA_MarkdownStream, false);
AppendTo(
    CF_NSA_MarkdownStream,
    "# Non-large families by symplectic family\n\n",
    "The large-family source is omitted. Ownership is determined by the ",
    "linear conjugacy class of the determinant-one strict lift. Literal ",
    "containment is then tested by exact matrix membership, without a ",
    "coordinate change.\n\n",
    "There are ", String(CF_NSA_Audit.smoothInputCount),
    " smooth non-large input families and ",
    String(CF_NSA_Audit.unresolvedInputCount),
    " unresolved input families. After the equal-dimensional saturation ",
    "calculation, ", String(CF_NSA_Audit.survivingSmoothCount),
    " smooth families survive. Of these, ",
    String(CF_NSA_Audit.literalSurvivingSmoothCount),
    " already contain the corresponding standard symplectic lift ",
    "literally, while ",
    String(CF_NSA_Audit.coordinateChangeSurvivingSmoothCount),
    " require a coordinate change.\n\n",
    "For every literally aligned family of index greater than one, a single ",
    "extension element was found. Thus its present linear group is generated ",
    "by the standard symplectic lift and one element.\n\n",
    "## Summary\n\n",
    "| no. | symplectic family record | all | smooth | unresolved | ",
    "surviving smooth | removed smooth | literal among survivors | ",
    "coordinate change |\n",
    "|---:|---|---:|---:|---:|---:|---:|---:|---:|\n"
);

for CF_NSA_Summary in CF_NSA_Audit.symplecticFamilies do
    AppendTo(
        CF_NSA_MarkdownStream,
        "| ", String(CF_NSA_Summary.ownerNumber),
        " | `", CF_NSA_Summary.ownerKey,
        "` | ", String(CF_NSA_Summary.allCandidateCount),
        " | ", String(CF_NSA_Summary.smoothInputCount),
        " | ", String(CF_NSA_Summary.unresolvedInputCount),
        " | ", String(CF_NSA_Summary.survivingSmoothCount),
        " | ", String(CF_NSA_Summary.removedSmoothCount),
        " | ", String(CF_NSA_Summary.literalSurvivingSmoothCount),
        " | ",
        String(CF_NSA_Summary.coordinateChangeSurvivingSmoothCount),
        " |\n"
    );
od;

for CF_NSA_Summary in CF_NSA_Audit.symplecticFamilies do
    CF_NSA_DirectSurvivors := Filtered(
        CF_NSA_Audit.familyResults,
        result -> result.ownerNumber = CF_NSA_Summary.ownerNumber
                  and result.survivesEqualDimensionSaturation = true
                  and result.literalSymplecticLiftContainment = true
    );
    CF_NSA_ChangeSurvivors := Filtered(
        CF_NSA_Audit.familyResults,
        result -> result.ownerNumber = CF_NSA_Summary.ownerNumber
                  and result.survivesEqualDimensionSaturation = true
                  and result.literalSymplecticLiftContainment = false
    );
    CF_NSA_Unresolved := Filtered(
        CF_NSA_Audit.familyResults,
        result -> result.ownerNumber = CF_NSA_Summary.ownerNumber
                  and result.smoothnessStatus = "unresolved"
    );

    AppendTo(
        CF_NSA_MarkdownStream,
        "\n## ", String(CF_NSA_Summary.ownerNumber), ". `",
        CF_NSA_Summary.ownerKey, "`\n\n",
        "Symplectic part `", CF_NSA_Summary.symplecticPart,
        "`, PGL ID `", String(CF_NSA_Summary.projectiveGroupId),
        "`, generic index ", String(CF_NSA_Summary.genericIndex), ".\n\n",
        "### Literally aligned surviving families\n\n"
    );
    if Length(CF_NSA_DirectSurvivors) = 0 then
        AppendTo(CF_NSA_MarkdownStream, "None.\n");
    else
        for CF_NSA_Result in CF_NSA_DirectSurvivors do
            CF_NSA_WriteFamilyLine(CF_NSA_MarkdownStream, CF_NSA_Result);
        od;
    fi;

    AppendTo(
        CF_NSA_MarkdownStream,
        "\n### Surviving families requiring a coordinate change\n\n"
    );
    if Length(CF_NSA_ChangeSurvivors) = 0 then
        AppendTo(CF_NSA_MarkdownStream, "None.\n");
    else
        for CF_NSA_Result in CF_NSA_ChangeSurvivors do
            CF_NSA_WriteFamilyLine(CF_NSA_MarkdownStream, CF_NSA_Result);
        od;
    fi;

    if Length(CF_NSA_Unresolved) > 0 then
        AppendTo(
            CF_NSA_MarkdownStream,
            "\n### Smoothness-unresolved input families\n\n"
        );
        for CF_NSA_Result in CF_NSA_Unresolved do
            CF_NSA_WriteFamilyLine(CF_NSA_MarkdownStream, CF_NSA_Result);
        od;
    fi;
od;
CloseStream(CF_NSA_MarkdownStream);

Print("\nCompleted\n");
Print("Smooth input: ", CF_NSA_Audit.smoothInputCount, "\n");
Print("Surviving smooth families: ",
      CF_NSA_Audit.survivingSmoothCount, "\n");
Print("Literal alignment among survivors: ",
      CF_NSA_Audit.literalSurvivingSmoothCount, "\n");
Print("Coordinate changes needed among survivors: ",
      CF_NSA_Audit.coordinateChangeSurvivingSmoothCount, "\n");
Print("Runtime: ", CF_NSA_Audit.runtimeMilliseconds, " ms\n");
Print("Output: ", CF_NSA_PathRecord.outputFile, "\n");
Print("Markdown: ", CF_NSA_PathRecord.markdownFile, "\n");

Unbind(CF_NSA_Number);
Unbind(CF_NSA_Candidate);
Unbind(CF_NSA_GroupInfo);
Unbind(CF_NSA_CandidateStrictInfo);
Unbind(CF_NSA_MatchingBases);
Unbind(CF_NSA_Tests);
Unbind(CF_NSA_Base);
Unbind(CF_NSA_Literal);
Unbind(CF_NSA_Search);
Unbind(CF_NSA_PossibleOwners);
Unbind(CF_NSA_OwnerTest);
Unbind(CF_NSA_Owner);
Unbind(CF_NSA_Extension);
Unbind(CF_NSA_SaturationResult);
Unbind(CF_NSA_Survives);
Unbind(CF_NSA_DirectTargetKey);
Unbind(CF_NSA_FinalTargetKey);
Unbind(CF_NSA_Owned);
Unbind(CF_NSA_Summary);
Unbind(CF_NSA_DirectSurvivors);
Unbind(CF_NSA_ChangeSurvivors);
Unbind(CF_NSA_Unresolved);
Unbind(CF_NSA_Result);
Unbind(CF_NSA_MarkdownStream);
