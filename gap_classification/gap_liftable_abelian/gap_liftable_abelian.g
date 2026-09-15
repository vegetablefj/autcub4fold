#############################################################################
## Liftable abelian candidates for cubic fourfolds
##
## This file is the compatibility and output wrapper around the frozen
## computational core in gap_liftable_abelian_original.g.
## The core's dangerous-spectrum exclusions concern abelian full projective
## stabilizers, not smoothness of arbitrary finite linear-group actions.
## Equal-dimensional containment pruning is local to each maximal source.
## The retained records remain candidates for the common saturation step.
## Source types and their K/T/Y labels are preserved.  A complete run writes
## the GAP-readable data file, the readable output, and the progress log
## documented in README.md.  Run this entry point from its module directory.
#############################################################################

if LoadPackage("smallgrp") = fail then
    Error("The GAP package smallgrp is required.");
fi;

Read("gap_liftable_abelian_original.g");

if not IsBoundGlobal("LAM_SHOW_PROGRESS") then
    LAM_SHOW_PROGRESS := true;
fi;
if not IsBoundGlobal("LAM_AUTO_RUN") then
    LAM_AUTO_RUN := true;
fi;
if not IsBoundGlobal("LAM_OUTPUT_FILE") then
    LAM_OUTPUT_FILE := "gap_liftable_abelian.out";
fi;
if not IsBoundGlobal("LAM_LOG_FILE") then
    LAM_LOG_FILE := "gap_liftable_abelian.log";
fi;
if not IsBoundGlobal("LAM_DATA_FILE") then
    LAM_DATA_FILE := "gap_liftable_abelian_data.g";
fi;

LAM_ArchiveSourceRecord := rec(
    originalSource := "gap_liftable_abelian_original.g",
    maximalClassification :=
        "Peng--Zheng, Abelian automorphism groups of quartic surfaces and cubic fourfolds, Theorem 4.2",
    specialExamples :=
        "Yang--Yu--Zhu, Examples 6.1 (5), 6.1 (8), and 6.11"
);

LAM_ArchiveRunStart := Runtime();


LAM_ArchiveProgress := function(arg)
    local item;

    if LAM_SHOW_PROGRESS then
        Print("# [LAM] ");
        for item in arg do
            Print(item);
        od;
        Print("\n");
    fi;

    AppendTo(
        LAM_LOG_FILE,
        "[", Runtime() - LAM_ArchiveRunStart, " ms] "
    );
    for item in arg do
        AppendTo(LAM_LOG_FILE, item);
    od;
    AppendTo(LAM_LOG_FILE, "\n");
end;


LAM_ArchiveGroupData := function(group)
    local identifier, invariants;

    identifier := fail;
    if IdGroupsAvailable(Size(group)) then
        identifier := IdGroup(group);
    fi;

    invariants := fail;
    if IsAbelian(group) then
        invariants := AbelianInvariants(group);
    fi;

    return rec(
        order := Size(group),
        id := identifier,
        structure := StructureDescription(group),
        abelianInvariants := invariants
    );
end;


# Record H and its projective quotient H/mu_3.
LAM_ArchiveProjectiveData := function(linearGroup)
    local scalar, scalarSubgroup, quotientMap, projectiveGroup;

    scalar := E(3) * IdentityMat(6);
    if not scalar in linearGroup then
        Error("The linear group does not contain E(3)I_6.");
    fi;

    scalarSubgroup := Subgroup(linearGroup, [scalar]);
    if Size(scalarSubgroup) <> 3
       or not IsSubgroup(Centre(linearGroup), scalarSubgroup) then
        Error("The cubic scalar subgroup is not central C3.");
    fi;

    quotientMap := NaturalHomomorphismByNormalSubgroup(
        linearGroup,
        scalarSubgroup
    );
    projectiveGroup := Image(quotientMap);

    return rec(
        linear := LAM_ArchiveGroupData(linearGroup),
        projective := LAM_ArchiveGroupData(projectiveGroup),
        projectiveGroup := projectiveGroup
    );
end;


LAM_ArchiveAttachMetadata := function(entry)
    local result, groupData;

    result := ShallowCopy(entry);
    groupData := LAM_ArchiveProjectiveData(entry.group);

    result.generators := GeneratorsOfGroup(entry.group);
    result.linearOrder := groupData.linear.order;
    result.projectiveOrder := groupData.projective.order;
    result.GLId := groupData.linear.id;
    result.PGLId := groupData.projective.id;
    result.GLStructure := groupData.linear.structure;
    result.PGLStructure := groupData.projective.structure;
    result.GLAbelianInvariants := groupData.linear.abelianInvariants;
    result.PGLAbelianInvariants :=
        groupData.projective.abelianInvariants;
    result.invariantCubicBasisStrings :=
        InvariantCubicMonomialBasis(entry.group);
    if not IsBound(result.determinantOneSubgroupSize) then
        result.determinantOneSubgroupSize :=
            LAM_DeterminantOneSubgroupSize(entry.group);
    fi;

    if not IsBound(result.combinationNames) then
        result.combinationNames := ShallowCopy(result.sourceNames);
    fi;
    if not IsBound(result.source) then
        result.source := "Peng--Zheng Theorem 4.2 maximal types";
    fi;
    if not IsBound(result.sourceReferences) then
        result.sourceReferences := [];
    fi;
    if not IsBound(result.isSpecialYYZExample) then
        result.isSpecialYYZExample := false;
    fi;

    return result;
end;


LAM_ArchiveSpecialBaseRecord := function(
    group,
    sourceName,
    source,
    references
)
    local moduliData;

    moduliData := CubicDiagonalModuliData(group);
    return rec(
        group := group,
        order := Size(group),
        projectiveOrder := Size(group) / 3,
        familyDimension := moduliData.moduliDimension,
        invariantCubicDimension :=
            moduliData.invariantCubicDimension,
        centralizerGLDimension :=
            moduliData.centralizerGLDimension,
        centralizerPGLDimension :=
            moduliData.centralizerPGLDimension,
        centralizerBlocks := moduliData.centralizerBlocks,
        sourceIndex := fail,
        sourceName := sourceName,
        sourceIndices := [],
        sourceNames := [sourceName],
        combinationNames := [sourceName],
        equivalenceClassSize := 1,
        source := source,
        sourceReferences := references,
        isSpecialYYZExample := true
    );
end;


# Construct the two cyclic actions and verify their invariant monomial bases.
LAM_ArchiveSpecialYYZExamples := function()
    local scalar, groupC48, groupC32, resultC48, resultC32,
          expectedBasisC48, expectedBasisC32;

    scalar := E(3) * IdentityMat(6);
    groupC48 := Group([
        DiagonalMat([
            E(16), E(8)^7, E(4), -1, 1, E(3)
        ]),
        scalar
    ]);
    groupC32 := Group([
        DiagonalMat([
            E(32), E(32)^30, E(32)^4,
            E(32)^24, E(32)^16, 1
        ]),
        scalar
    ]);

    resultC48 := LAM_ArchiveAttachMetadata(
        LAM_ArchiveSpecialBaseRecord(
            groupC48,
            "YYZ-X5-prime-C48",
            "Yang--Yu--Zhu Examples 6.1 (5) and 6.11",
            [
                "Yang--Yu--Zhu, Example 6.1 (5)",
                "Yang--Yu--Zhu, Example 6.11"
            ]
        )
    );
    resultC32 := LAM_ArchiveAttachMetadata(
        LAM_ArchiveSpecialBaseRecord(
            groupC32,
            "YYZ-X8-prime-C32",
            "Yang--Yu--Zhu Example 6.1 (8)",
            [
                "Yang--Yu--Zhu, Example 6.1 (8)"
            ]
        )
    );

    if resultC48.linearOrder <> 144
       or resultC48.projectiveOrder <> 48
       or resultC48.PGLStructure <> "C48" then
        Error("Unexpected GL/PGL data for the special C48 example.");
    fi;
    if resultC32.linearOrder <> 96
       or resultC32.projectiveOrder <> 32
       or resultC32.PGLStructure <> "C32" then
        Error("Unexpected GL/PGL data for the special C32 example.");
    fi;

    expectedBasisC48 := [
        "x1^2*x2", "x2^2*x3", "x3^2*x4",
        "x4^2*x5", "x5^3", "x6^3"
    ];
    expectedBasisC32 := [
        "x1^2*x2", "x2^2*x3", "x3^2*x4",
        "x4^2*x5", "x5^2*x6", "x6^3"
    ];
    if Set(resultC48.invariantCubicBasisStrings)
       <> Set(expectedBasisC48) then
        Error("Unexpected invariant basis for the special C48 example.");
    fi;
    if Set(resultC32.invariantCubicBasisStrings)
       <> Set(expectedBasisC32) then
        Error("Unexpected invariant basis for the special C32 example.");
    fi;

    return [resultC48, resultC32];
end;


LAM_ArchiveThreeDigitString := function(number)
    if number < 10 then
        return Concatenation("00", String(number));
    elif number < 100 then
        return Concatenation("0", String(number));
    fi;
    return String(number);
end;


# Preserve the ordinary core order, then prepend C48 and C32.
LAM_ArchiveRunPipeline := function(verbose)
    local pooled, deduplicated, restricted, ordinaryCandidates,
          specialCandidates, candidates, i;

    VerifyLiftableAbelianMaximalList();

    LAM_ArchiveProgress("frozen-core enumeration started");
    pooled := CollectLiftableAbelianEssentialCandidates(verbose);
    LAM_ArchiveProgress(
        "order-filtered pool complete: ", pooled.numberOfCandidates
    );

    deduplicated := DeduplicateLiftableAbelianEssentialCandidates(
        pooled,
        verbose
    );
    LAM_ArchiveProgress(
        "equivalence deduplication complete: ",
        deduplicated.numberOfSurvivors
    );

    restricted := ApplyFinalRestrictionsToDedup(deduplicated);
    LAM_ArchiveProgress(
        "final restrictions complete: ", restricted.numberOfSurvivors
    );

    ordinaryCandidates := List(
        restricted.survivors,
        LAM_ArchiveAttachMetadata
    );
    specialCandidates := LAM_ArchiveSpecialYYZExamples();
    candidates := Concatenation(
        specialCandidates,
        ordinaryCandidates
    );

    for i in [1 .. Length(candidates)] do
        candidates[i].label := Concatenation(
            "LA-",
            LAM_ArchiveThreeDigitString(i)
        );
    od;

    return rec(
        sourceRecord := LAM_ArchiveSourceRecord,
        pooled := pooled,
        deduplicated := deduplicated,
        restricted := restricted,
        ordinaryCandidates := ordinaryCandidates,
        specialCandidates := specialCandidates,
        candidates := candidates,
        numberOfOrdinaryCandidates := Length(ordinaryCandidates),
        numberOfSpecialCandidates := Length(specialCandidates),
        numberOfCandidates := Length(candidates),
        ordinaryCountMatchesReference :=
            Length(ordinaryCandidates) = 51,
        totalCountMatchesReference := Length(candidates) = 53
    );
end;


LAM_ArchiveGapQuotedString := function(string)
    return Concatenation("\"", string, "\"");
end;


LAM_ArchiveWriteHumanOutput := function(filename, run)
    local summary, candidate;

    PrintTo(
        filename,
        "LIFTABLE ABELIAN CANDIDATES FOR CUBIC FOURFOLDS\n",
        "=================================================\n\n",
        "GAP version: ", GAPInfo.Version, "\n",
        "Computational core: ", run.sourceRecord.originalSource, "\n",
        "Maximal classification: ",
        run.sourceRecord.maximalClassification, "\n",
        "Special examples: ", run.sourceRecord.specialExamples, "\n\n",
        "The frozen computational core is used without modification.\n",
        "Its stage order is local reduction, order filtering, strong-key\n",
        "diagonal equivalence, and final geometric restrictions.\n\n",
        "RUN SUMMARY\n",
        "-----------\n",
        "Order-filtered pool: ", run.pooled.numberOfCandidates, "\n",
        "After equivalence deduplication: ",
        run.deduplicated.numberOfSurvivors, "\n",
        "After final restrictions: ",
        run.numberOfOrdinaryCandidates, "\n",
        "Special YYZ examples: ", run.numberOfSpecialCandidates, "\n",
        "Total candidates: ", run.numberOfCandidates, "\n",
        "Reference ordinary count 51 matched: ",
        run.ordinaryCountMatchesReference, "\n",
        "Reference total count 53 matched: ",
        run.totalCountMatchesReference, "\n\n",
        "SOURCE SUMMARY\n",
        "--------------\n"
    );

    for summary in run.pooled.sourceSummaries do
        AppendTo(
            filename,
            "[", summary.sourceIndex, "] ", summary.sourceName,
            " | ambient order ", summary.ambientOrder,
            " | subgroups containing mu3 ",
            summary.allSubgroupsContainingMu3,
            " | essential ", summary.essentialSubgroups,
            " | retained ", summary.retainedByOrderFilter, "\n"
        );
    od;

    AppendTo(filename, "\nCANDIDATES\n", "----------\n");
    for candidate in run.candidates do
        AppendTo(
            filename,
            "\n[", candidate.label, "]",
            " special YYZ example: ",
            candidate.isSpecialYYZExample, "\n",
            "source: ", candidate.source, "\n",
            "combination/source names: ", candidate.sourceNames, "\n",
            "references: ", candidate.sourceReferences, "\n",
            "GL order: ", candidate.linearOrder,
            " | GL ID: ", candidate.GLId,
            " | GL structure: ", candidate.GLStructure,
            " | GL abelian invariants: ",
            candidate.GLAbelianInvariants, "\n",
            "PGL order: ", candidate.projectiveOrder,
            " | PGL ID: ", candidate.PGLId,
            " | PGL structure: ", candidate.PGLStructure,
            " | PGL abelian invariants: ",
            candidate.PGLAbelianInvariants, "\n",
            "invariant cubic dimension: ",
            candidate.invariantCubicDimension,
            " | centralizer GL dimension: ",
            candidate.centralizerGLDimension,
            " | family dimension: ", candidate.familyDimension, "\n",
            "determinant-one subgroup order: ",
            candidate.determinantOneSubgroupSize, "\n",
            "sources merged: ", candidate.equivalenceClassSize, "\n",
            "generators: ", candidate.generators, "\n",
            "invariant cubic basis: ",
            candidate.invariantCubicBasisStrings, "\n"
        );
    od;
end;


LAM_ArchiveWriteDataRecord := function(filename, candidate, isLast)
    local suffix;

    if isLast then
        suffix := "\n";
    else
        suffix := ",\n";
    fi;

    AppendTo(
        filename,
        "  rec(\n",
        "    label := ",
        LAM_ArchiveGapQuotedString(candidate.label), ",\n",
        "    group := Group(", candidate.generators, "),\n",
        "    generators := ", candidate.generators, ",\n",
        "    isSpecialYYZExample := ",
        candidate.isSpecialYYZExample, ",\n",
        "    source := ",
        LAM_ArchiveGapQuotedString(candidate.source), ",\n",
        "    sourceIndices := ", candidate.sourceIndices, ",\n",
        "    sourceNames := ", candidate.sourceNames, ",\n",
        "    combinationNames := ", candidate.combinationNames, ",\n",
        "    sourceReferences := ", candidate.sourceReferences, ",\n",
        "    equivalenceClassSize := ",
        candidate.equivalenceClassSize, ",\n",
        "    linearOrder := ", candidate.linearOrder, ",\n",
        "    projectiveOrder := ", candidate.projectiveOrder, ",\n",
        "    GLId := ", candidate.GLId, ",\n",
        "    PGLId := ", candidate.PGLId, ",\n",
        "    GLStructure := ",
        LAM_ArchiveGapQuotedString(candidate.GLStructure), ",\n",
        "    PGLStructure := ",
        LAM_ArchiveGapQuotedString(candidate.PGLStructure), ",\n",
        "    GLAbelianInvariants := ",
        candidate.GLAbelianInvariants, ",\n",
        "    PGLAbelianInvariants := ",
        candidate.PGLAbelianInvariants, ",\n",
        "    familyDimension := ", candidate.familyDimension, ",\n",
        "    invariantCubicDimension := ",
        candidate.invariantCubicDimension, ",\n",
        "    centralizerGLDimension := ",
        candidate.centralizerGLDimension, ",\n",
        "    centralizerPGLDimension := ",
        candidate.centralizerPGLDimension, ",\n",
        "    centralizerBlocks := ", candidate.centralizerBlocks, ",\n",
        "    determinantOneSubgroupSize := ",
        candidate.determinantOneSubgroupSize, ",\n",
        "    invariantCubicBasisStrings := ",
        candidate.invariantCubicBasisStrings, "\n",
        "  )", suffix
    );
end;


LAM_ArchiveWriteMachineData := function(filename, run)
    local i;

    PrintTo(
        filename,
        "# Generated by gap_liftable_abelian.g.\n",
        "# Read this file to define LiftableAbelianCandidates.\n\n",
        "LiftableAbelianSourceRecord := ",
        run.sourceRecord, ";\n\n",
        "LiftableAbelianCandidates := [\n"
    );
    for i in [1 .. Length(run.candidates)] do
        LAM_ArchiveWriteDataRecord(
            filename,
            run.candidates[i],
            i = Length(run.candidates)
        );
    od;
    AppendTo(
        filename,
        "];\n\n",
        "FinalLiftableAbelianCandidates := ",
        "LiftableAbelianCandidates;\n",
        "LiftableAbelianResultSummary := rec(\n",
        "  ordinaryCount := ", run.numberOfOrdinaryCandidates, ",\n",
        "  specialCount := ", run.numberOfSpecialCandidates, ",\n",
        "  totalCount := ", run.numberOfCandidates, ",\n",
        "  ordinaryCountMatchesReference := ",
        run.ordinaryCountMatchesReference, ",\n",
        "  totalCountMatchesReference := ",
        run.totalCountMatchesReference, "\n",
        ");\n"
    );
end;


LAM_ArchiveRunAndWriteFiles := function(verbose)
    local run;

    LAM_ArchiveRunStart := Runtime();
    PrintTo(
        LAM_LOG_FILE,
        "Liftable abelian calculation log\n",
        "=================================\n",
        "GAP version: ", GAPInfo.Version, "\n",
        "Computational core: ",
        LAM_ArchiveSourceRecord.originalSource, "\n",
        "Output file: ", LAM_OUTPUT_FILE, "\n",
        "Data file: ", LAM_DATA_FILE, "\n",
        "Log file: ", LAM_LOG_FILE, "\n\n"
    );

    run := LAM_ArchiveRunPipeline(verbose);
    LAM_ArchiveWriteHumanOutput(LAM_OUTPUT_FILE, run);
    LAM_ArchiveWriteMachineData(LAM_DATA_FILE, run);

    AppendTo(
        LAM_LOG_FILE,
        "\nFINAL SUMMARY\n",
        "-------------\n",
        "Ordinary candidates: ", run.numberOfOrdinaryCandidates, "\n",
        "Special YYZ candidates: ",
        run.numberOfSpecialCandidates, "\n",
        "Total candidates: ", run.numberOfCandidates, "\n",
        "Ordinary reference count matched: ",
        run.ordinaryCountMatchesReference, "\n",
        "Total reference count matched: ",
        run.totalCountMatchesReference, "\n",
        "Runtime(ms): ", Runtime() - LAM_ArchiveRunStart, "\n"
    );

    LAM_ArchiveProgress("output written to ", LAM_OUTPUT_FILE);
    LAM_ArchiveProgress("machine data written to ", LAM_DATA_FILE);
    return run;
end;


if LAM_AUTO_RUN then
    LiftableAbelianRun :=
        LAM_ArchiveRunAndWriteFiles(LAM_SHOW_PROGRESS);
    LiftableAbelianCandidates := LiftableAbelianRun.candidates;
    FinalLiftableAbelianCandidates := LiftableAbelianCandidates;
fi;
