#############################################################################
## Maximal full fourfold actions from the completed containment relation.
## No representation or embedding search is repeated.
#############################################################################

Read("gap_family_poset_functions.g");

CF_FM_Run := function()
    local log, data, poset, records, target, family, output, markdown, number,
          oldExtrema;
    log := CF_FP_StartLog("output/gap_fourfold_maximal.log",
        "Maximal full cubic-fourfold actions");
    CF_FP_TestPosetHelpers();
    data := CF_FP_LoadFourfold();
    CF_FP_Log(log, Concatenation("Input verified: 156 families, ",
        String(Length(data.pairs)), " pair decisions"));
    poset := CF_FP_Poset([1 .. 156], data.positivePairs);
    oldExtrema := CF_FP_ReadGlobal(
        "result/gap_fourfold_cross_dimension_extrema.g",
        "FourfoldCrossDimensionExtrema");
    if poset.maximalNumbers <>
       oldExtrema.geometricMinimalFamilyNumbers then
        Error("Action maxima disagree with the saved geometric minima.");
    fi;
    records := [];
    for target in poset.familyTargets do
        family := data.catalogue[target.number];
        Add(records, rec(number := family.number, sourceKey := family.sourceKey,
            familyDimension := family.familyDimension,
            symplecticPart := family.symplecticPart,
            fullIndex := family.fullIndex, linearGroupId := family.linearGroupId,
            projectiveGroupId := family.projectiveGroupId,
            immediateSpecializations := List(Filtered(poset.coverPairs,
                edge -> edge[1] = family.number), edge -> edge[2]),
            isActionMaximal := target.isMaximal,
            actionMaximalTargets := target.maximalTargets,
            pathsToActionMaximal := target.pathsToMaximal));
    od;
    output := rec(schemaVersion := 2, status := "completed",
        gapVersion := GAPInfo.Version,
        meaning := "maximal full strict actions under GL-conjugate containment",
        inputCatalogue := "../gap_manuscript_validation/gap_family_catalogue.g",
        inputRelation := "result/gap_fourfold_cross_dimension_all_pairs.g",
        inputCatalogueMatched := true, inputPairCoverageVerified := true,
        positiveWitnessPolicy := "explicit witnesses verified in the displayed coordinates",
        families := records,
        actionMaximalNumbers := poset.maximalNumbers,
        actionMaximalCount := Length(poset.maximalNumbers),
        positivePairs := poset.positivePairs, coverPairs := poset.coverPairs,
        transitiveClosureVerified := poset.transitiveClosureVerified,
        coverClosureVerified := poset.coverClosureVerified,
        runtimeMilliseconds := Runtime() - log.started);
    CF_FP_Write("result/gap_fourfold_maximal.out", "FourfoldMaximalAudit", output);
    markdown := OutputTextFile("result/gap_fourfold_cross_dimension_result.md", false);
    SetPrintFormattingStatus(markdown, false);
    AppendTo(markdown, "# Containment of cubic-fourfold families\n\n",
        "The 156 families are numbered in stored catalogue order. ",
        "Their groups are the representatives in ",
        "[the family catalogue](../../gap_manuscript_validation/gap_family_catalogue.g). ",
        "All rows are saturated. This calculation determines containment ",
        "between families of different dimensions and the action-maximal rows.\n\n",
        "A relation `i -> j` means that `H_i` is linearly conjugate to a ",
        "subgroup of `H_j`. The corresponding geometric inclusion is ",
        "`Z_j subset Z_i`: family `j` is a specialization inside family `i`. ",
        "An action-maximal family has no outgoing strict group-containment ",
        "relation. It is not a geometrically maximal family.\n\n",
        "## Summary\n\n",
        "| Quantity | Count |\n| --- | ---: |\n",
        "| Families | 156 |\n| Eligible pairs | 6568 |\n",
        "| Positive relations | 1793 |\n| Negative decisions | 4775 |\n",
        "| Undecided pairs | 0 |\n| Cover relations | 433 |\n",
        "| Action-maximal families | 21 |\n\n",
        "The complete saved decisions are retained without repeating an ",
        "embedding search. All 1793 positive matrices have been expressed ",
        "in the displayed coordinates and checked on every source generator. ",
        "The 4775 negative decisions are unchanged under conjugacy of both ",
        "groups. Complete pair coverage, the full positive relation, all ",
        "433 covers, and all 21 action-maximal numbers agree with the saved ",
        "calculation; the cover relation recovers the complete positive ",
        "relation by transitive closure.\n\n",
        "## Action-maximal families\n\n",
        "These rows are maximal for strict matrix-group containment, ",
        "not only for abstract-group containment.\n\n",
        "| No. | Dimension | Symplectic part | Index | GL ID | PGL ID |\n",
        "| ---: | ---: | --- | ---: | --- | --- |\n");
    for number in poset.maximalNumbers do
        family := records[number];
        AppendTo(markdown, "| ", number, " | ", family.familyDimension,
            " | `", family.symplecticPart, "` | ", family.fullIndex, " | `",
            CF_FP_GroupIdText(family.linearGroupId), "` | `",
            CF_FP_GroupIdText(family.projectiveGroupId), "` |\n");
    od;
    AppendTo(markdown, "\n`[order, --]` means no SmallGroups ID is supplied.\n\n",
        "## All families and their specializations\n\n",
        "The rows remain in classification-table order. Immediate ",
        "specializations list exactly the cover targets: no classified family ",
        "lies strictly between the two rows. Together these lists give all ",
        "433 cover relations. Action-maximal specializations list every ",
        "reachable action-maximal row, not just one chosen target. An ",
        "action-maximal row lists itself in the last column and has no ",
        "immediate specialization.\n\n",
        "| No. | Dimension | GL ID | PGL ID | Immediate specializations | Action-maximal specializations |\n",
        "| ---: | ---: | --- | --- | --- | --- |\n");
    for family in records do
        AppendTo(markdown, "| ", family.number, " | ", family.familyDimension,
            " | `", CF_FP_GroupIdText(family.linearGroupId), "` | `",
            CF_FP_GroupIdText(family.projectiveGroupId), "` | ",
            family.immediateSpecializations, " | ",
            family.actionMaximalTargets, " |\n");
    od;
    AppendTo(markdown, "\nThe only geometrically maximal classified family is No. 132. ",
        "The 21 action-maximal rows are the geometrically minimal rows in this order.\n\n",
        "## Result files\n\n",
        "- [All pair decisions](gap_fourfold_cross_dimension_all_pairs.tsv): ",
        "6568 pairs, with dimensions, group orders, status and reason.\n",
        "- [All positive matrices](gap_fourfold_cross_dimension_positive_edges.g): ",
        "1793 GAP-readable witnesses in the displayed coordinates.\n",
        "- [Cover relations](gap_fourfold_cross_dimension_geometric_covers.tsv): ",
        "433 immediate geometric inclusions, with the group direction recorded separately.\n",
        "- [Maximal-action data](gap_fourfold_maximal.out): all reachable ",
        "action-maximal rows and explicit paths along covers.\n",
        "- [Coordinate audit](gap_fourfold_coordinate_audit.out): exact ",
        "matrix conversion and checks. No new embedding search is performed.\n\n",
        "For a positive record, `P^-1 * H_source * P <= H_target`. ",
        "`classification`, `direct` and `viaNumber` record how the original ",
        "search obtained the relation; they do not distinguish cover relations ",
        "from non-cover relations.\n");
    CloseStream(markdown);
    CF_FP_Log(log, Concatenation("Completed: maximal actions = ",
        String(output.actionMaximalCount), "; covers = ",
        String(Length(poset.coverPairs))));
    AppendTo(log.stream, "FOURFOLD_MAXIMAL_COMPLETED\n");
    Print("FOURFOLD_MAXIMAL_COMPLETED\n");
    CloseStream(log.stream);
    return output;
end;

FourfoldMaximalAudit := CF_FM_Run();
