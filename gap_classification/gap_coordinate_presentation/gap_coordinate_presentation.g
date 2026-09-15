#############################################################################
## Verify the canonical coordinate presentations of the 156 families.
##
## This audit does not repeat classification or saturation.  It checks that
## each computed matrix group is linearly conjugate to exactly one canonical
## presentation. Coarse metadata are used only to partition comparisons.
#############################################################################

if not IsExistingFile("gap_classification/gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g") then
    Error("Run this file from the repository root.");
fi;

Read("gap_classification/gap_functions.g");
Read("gap_classification/gap_saturation/gap_saturation_input.g");
Read("gap_classification/gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g");
Read(Concatenation(
    "gap_classification/gap_coordinate_presentation/",
    "gap_coordinate_presentation_functions.g"
));

CF_CP_DIRECTORY := "gap_classification/gap_coordinate_presentation/";
CF_CP_LOG_FILE := Concatenation(
    CF_CP_DIRECTORY,
    "gap_coordinate_presentation.log"
);
CF_CP_OUTPUT_FILE := Concatenation(
    CF_CP_DIRECTORY,
    "gap_coordinate_presentation.out"
);
CF_CP_MARKDOWN_FILE := Concatenation(
    CF_CP_DIRECTORY,
    "gap_coordinate_presentation_result.md"
);

PrintTo(CF_CP_LOG_FILE, "");
CF_CP_Log := function(arg)
    local item;

    for item in arg do
        Print(item);
        AppendTo(CF_CP_LOG_FILE, item);
    od;
end;


CF_CP_Computed := CF_CP_ComputedCatalogue(
    CanonicalFamilyMatrixGroups,
    SaturationInputCandidates
);
CF_CP_Presentations := CF_CP_PresentationCatalogue(
    CanonicalFamilyMatrixGroups
);

if Length(CF_CP_Computed) <> 156
   or Length(CF_CP_Presentations) <> 156 then
    Error("Both catalogues must contain 156 entries.");
fi;

CF_CP_Log(
    "GAP version: ", GAPInfo.Version, "\n",
    "Computed catalogue entries: ", Length(CF_CP_Computed), "\n",
    "Canonical presentation entries: ", Length(CF_CP_Presentations), "\n\n"
);


## Partition by elementary metadata.  Every pair in a repeated block is
## tested; the recorded source correspondence is never the only comparison.
CF_CP_Unassigned := [1 .. Length(CF_CP_Computed)];
CF_CP_Blocks := [];
while Length(CF_CP_Unassigned) > 0 do
    CF_CP_Position := CF_CP_Unassigned[1];
    CF_CP_Signature := CF_CP_CoarseSignature(
        CF_CP_Computed[CF_CP_Position]
    );
    CF_CP_ComputedPositions := CF_CP_PositionsWithSignature(
        CF_CP_Unassigned,
        CF_CP_Computed,
        CF_CP_Signature
    );
    CF_CP_PresentationPositions := CF_CP_PositionsWithSignature(
        [1 .. Length(CF_CP_Presentations)],
        CF_CP_Presentations,
        CF_CP_Signature
    );
    if Length(CF_CP_ComputedPositions)
         <> Length(CF_CP_PresentationPositions) then
        Error("The two catalogues have different coarse block sizes.");
    fi;
    Add(CF_CP_Blocks, rec(
        signature := CF_CP_Signature,
        computedPositions := CF_CP_ComputedPositions,
        presentationPositions := CF_CP_PresentationPositions
    ));
    CF_CP_Unassigned := Difference(
        CF_CP_Unassigned,
        CF_CP_ComputedPositions
    );
od;

CF_CP_RepeatedBlocks := Filtered(
    CF_CP_Blocks,
    block -> Length(block.computedPositions) > 1
);
CF_CP_Log(
    "Coarse metadata blocks: ", Length(CF_CP_Blocks), "\n",
    "Repeated coarse blocks: ", Length(CF_CP_RepeatedBlocks), "\n\n"
);


CF_CP_PairResults := [];
CF_CP_MatchLists := List(CF_CP_Computed, entry -> []);
CF_CP_UndecidedPairCount := 0;
CF_CP_BlockNumber := 0;
for CF_CP_Block in CF_CP_Blocks do
    CF_CP_BlockNumber := CF_CP_BlockNumber + 1;
    if Length(CF_CP_Block.computedPositions) > 1 then
        CF_CP_Log(
            "Repeated block ", CF_CP_BlockNumber,
            ": signature=", CF_CP_Block.signature,
            "; computed=", CF_CP_Block.computedPositions,
            "; canonical=", CF_CP_Block.presentationPositions, "\n"
        );
    fi;
    for CF_CP_ComputedPosition in CF_CP_Block.computedPositions do
        for CF_CP_PresentationPosition in
            CF_CP_Block.presentationPositions do
            CF_CP_Result := CF_CP_TestPair(
                CF_CP_Computed[CF_CP_ComputedPosition],
                CF_CP_Presentations[CF_CP_PresentationPosition]
            );
            Add(CF_CP_PairResults, CF_CP_PublicPairResult(
                CF_CP_ComputedPosition,
                CF_CP_PresentationPosition,
                CF_CP_Result
            ));
            if CF_CP_Result.status = "equivalent" then
                Add(
                    CF_CP_MatchLists[CF_CP_ComputedPosition],
                    CF_CP_PresentationPosition
                );
            elif CF_CP_Result.status = "undecided" then
                CF_CP_UndecidedPairCount :=
                    CF_CP_UndecidedPairCount + 1;
            fi;
            if Length(CF_CP_Block.computedPositions) > 1 then
                CF_CP_Log(
                    "  computed ", CF_CP_ComputedPosition,
                    " vs canonical ", CF_CP_PresentationPosition,
                    ": ", CF_CP_Result.status,
                    "; method=", CF_CP_Result.method,
                    "; reason=", CF_CP_Result.reason, "\n"
                );
            fi;
        od;
    od;
    if Length(CF_CP_Block.computedPositions) > 1 then
        CF_CP_Log("\n");
    fi;
od;


CF_CP_IntendedFailures := Filtered(
    [1 .. 156],
    position -> not position in CF_CP_MatchLists[position]
);
CF_CP_UnmatchedComputed := Filtered(
    [1 .. 156],
    position -> Length(CF_CP_MatchLists[position]) = 0
);
CF_CP_UncoveredPresentations := Filtered(
    [1 .. 156],
    presentationPosition -> not ForAny(
        CF_CP_MatchLists,
        matchList -> presentationPosition in matchList
    )
);
CF_CP_AmbiguousComputed := Filtered(
    [1 .. 156],
    position -> Length(CF_CP_MatchLists[position]) > 1
);

if Length(CF_CP_IntendedFailures) > 0
   or Length(CF_CP_UnmatchedComputed) > 0
   or Length(CF_CP_UncoveredPresentations) > 0 then
    CF_CP_Status := "failed";
elif CF_CP_UndecidedPairCount > 0 then
    CF_CP_Status := "needs_review";
elif Length(CF_CP_AmbiguousComputed) > 0 then
    CF_CP_Status := "verified_with_equivalent_cross_matches";
else
    CF_CP_Status := "verified_unique";
fi;

CF_CP_EquivalentPairCount := Number(
    CF_CP_PairResults,
    pair -> pair.status = "equivalent"
);
CF_CP_NonEquivalentPairCount := Number(
    CF_CP_PairResults,
    pair -> pair.status = "not_equivalent"
);

CF_CP_Audit := rec(
    schemaVersion := 1,
    status := CF_CP_Status,
    gapVersion := GAPInfo.Version,
    purpose := Concatenation(
        "coordinate presentation audit; the canonical catalogue uses ",
        "more convenient representatives"
    ),
    computedCount := Length(CF_CP_Computed),
    canonicalPresentationCount := Length(CF_CP_Presentations),
    coarseBlockCount := Length(CF_CP_Blocks),
    repeatedCoarseBlockCount := Length(CF_CP_RepeatedBlocks),
    testedPairCount := Length(CF_CP_PairResults),
    equivalentPairCount := CF_CP_EquivalentPairCount,
    nonEquivalentPairCount := CF_CP_NonEquivalentPairCount,
    undecidedPairCount := CF_CP_UndecidedPairCount,
    intendedFailurePositions := CF_CP_IntendedFailures,
    unmatchedComputedPositions := CF_CP_UnmatchedComputed,
    uncoveredCanonicalPositions := CF_CP_UncoveredPresentations,
    ambiguousComputedPositions := CF_CP_AmbiguousComputed,
    matchLists := CF_CP_MatchLists,
    pairResults := CF_CP_PairResults,
    computedCatalogue := CF_CP_RemoveInternalData(CF_CP_Computed),
    canonicalNumbers := List(
        CF_CP_Presentations,
        entry -> entry.number
    )
);

CF_CP_OutputStream := OutputTextFile(CF_CP_OUTPUT_FILE, false);
if CF_CP_OutputStream = fail then
    Error("Could not open the GAP output file.");
fi;
SetPrintFormattingStatus(CF_CP_OutputStream, false);
PrintTo(
    CF_CP_OutputStream,
    "CoordinatePresentationAudit := ", CF_CP_Audit, ";\n"
);
CloseStream(CF_CP_OutputStream);


CF_CP_MarkdownStream := OutputTextFile(CF_CP_MARKDOWN_FILE, false);
if CF_CP_MarkdownStream = fail then
    Error("Could not open the Markdown result file.");
fi;
SetPrintFormattingStatus(CF_CP_MarkdownStream, false);
AppendTo(
    CF_CP_MarkdownStream,
    "# Coordinate-presentation audit\n\n",
    "This audit compares the computed matrix groups with the canonical ",
    "presentations used for the final catalogue. The change is only a ",
    "coordinate normalization intended to make the matrices easier to ",
    "read; no classification or saturation computation is repeated.\n\n",
    "- Status: `", CF_CP_Status, "`\n",
    "- Computed families: ", Length(CF_CP_Computed), "\n",
    "- Canonical presentations: ", Length(CF_CP_Presentations), "\n",
    "- Coarse metadata blocks: ", Length(CF_CP_Blocks), "\n",
    "- Repeated coarse blocks checked pairwise: ",
        Length(CF_CP_RepeatedBlocks), "\n",
    "- Exact pairs tested: ", Length(CF_CP_PairResults), "\n",
    "- Equivalent pairs: ", CF_CP_EquivalentPairCount, "\n",
    "- Non-equivalent pairs: ", CF_CP_NonEquivalentPairCount, "\n",
    "- Undecided pairs: ", CF_CP_UndecidedPairCount, "\n",
    "- Ambiguous computed entries: ", Length(CF_CP_AmbiguousComputed),
        "\n\n"
);
if CF_CP_Status = "verified_unique" then
    AppendTo(
        CF_CP_MarkdownStream,
        "Every computed family has exactly one canonical presentation, ",
        "and all 156 intended correspondences were verified. This is the ",
        "fixed computational catalogue. The final coordinate presentations ",
        "and their designated witness replay are recorded in ",
        "[the ordered correspondence](../gap_manuscript_validation/",
        "gap_family_correspondence.md).\n"
    );
elif CF_CP_Status = "verified_with_equivalent_cross_matches" then
    AppendTo(
        CF_CP_MarkdownStream,
        "All intended correspondences were verified, but some entries also ",
        "have linearly equivalent cross-matches inside a repeated metadata ",
        "block. See the GAP output and log for those blocks.\n"
    );
else
    AppendTo(
        CF_CP_MarkdownStream,
        "The audit is not yet final.  See the GAP output and log for the ",
        "unmatched or undecided entries.\n"
    );
fi;
CloseStream(CF_CP_MarkdownStream);

CF_CP_Log(
    "Status: ", CF_CP_Status, "\n",
    "Pairs tested: ", Length(CF_CP_PairResults),
    "; equivalent=", CF_CP_EquivalentPairCount,
    "; non-equivalent=", CF_CP_NonEquivalentPairCount,
    "; undecided=", CF_CP_UndecidedPairCount, "\n",
    "Ambiguous computed entries: ", Length(CF_CP_AmbiguousComputed), "\n",
    "Output: ", CF_CP_OUTPUT_FILE, "\n",
    "Summary: ", CF_CP_MARKDOWN_FILE, "\n"
);

if CF_CP_Status = "failed" then
    Error("The coordinate-presentation audit failed.");
fi;
