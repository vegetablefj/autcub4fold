#############################################################################
## Express the completed containment relation in the displayed coordinates.
## Only explicit matrix witnesses are checked; no embedding search is run.
#############################################################################

Read("gap_family_poset_functions.g");

CF_CC_Run := function()
    local log, computed, catalogue, correspondence, matrices, inverseMatrices,
          oldGroups, newGroups, oldKnown, newKnown, contains, i, q, row, family,
          generators, old, positive, pairs, copy, p, count, directCount, via,
          before, after, covers, geometricCovers, extrema, geometricMaxima,
          audit, stream;
    log := CF_FP_StartLog("output/gap_coordinate_containment.log",
        "Fourfold containment in the displayed coordinates");
    computed := CF_FP_LoadComputedFourfold();
    catalogue := CF_FP_ReadGlobal(
        "../gap_manuscript_validation/gap_family_catalogue.g",
        "CubicFourfoldFamilyCatalogue");
    correspondence := CF_FP_ReadGlobal(
        "../gap_manuscript_validation/gap_family_correspondence.out",
        "FamilyCoordinateAudit");
    if Length(catalogue) <> 156
       or List(catalogue, r -> r.number) <> [1 .. 156]
       or correspondence.status <> "completed"
       or correspondence.recordCount <> 156
       or correspondence.failures <> []
       or List(correspondence.rows, r -> r.number) <> [1 .. 156] then
        Error("Expected the completed numbered coordinate correspondence.");
    fi;
    matrices := []; inverseMatrices := [];
    oldGroups := List([1 .. 156], i -> fail);
    newGroups := List([1 .. 156], i -> fail);
    oldKnown := []; newKnown := [];
    for i in [1 .. 156] do
        generators := computed.catalogue[i].matrixGenerators;
        Add(oldKnown, Set(Concatenation(generators,
            List(generators, g -> g^-1), [IdentityMat(6)])));
        generators := catalogue[i].matrixGenerators;
        Add(newKnown, Set(Concatenation(generators,
            List(generators, g -> g^-1), [IdentityMat(6)])));
    od;
    ## Obvious memberships need no group model; other memberships remain exact.
    contains := function(groups, known, families, number, matrix)
        if matrix in known[number] then return true; fi;
        if groups[number] = fail then
            groups[number] := Group(families[number].matrixGenerators);
        fi;
        return matrix in groups[number];
    end;
    for i in [1 .. 156] do
        family := catalogue[i]; old := computed.catalogue[i];
        row := correspondence.rows[i]; q := row.savedToPresentationMatrix;
        if row.number <> i or row.computationalNumber <> i
           or row.crossDimensionNumber <> i or row.passed <> true
           or not ForAll(RecNames(row.checks), n -> row.checks.(n) = true)
           or row.sourceKey <> old.sourceKey
           or family.sourceKey <> old.sourceKey
           or family.familyDimension <> old.familyDimension
           or family.linearGroupId <> old.linearGroupId
           or family.projectiveGroupId <> old.projectiveGroupId
           or family.fullIndex <> old.fullIndex
           or family.fullGroupVerified <> true
           or family.determinantKernelVerified <> true
           or Length(q) <> 6 or not ForAll(q, r -> Length(r) = 6)
           or IsZero(DeterminantMat(q)) then
            Error("Coordinate metadata mismatch at family ", i);
        fi;
        Add(matrices, q); Add(inverseMatrices, q^-1);
        if not ForAll(old.matrixGenerators,
            g -> contains(newGroups, newKnown, catalogue, i, q^-1*g*q))
           or not ForAll(family.matrixGenerators,
            g -> contains(oldGroups, oldKnown, computed.catalogue, i, q*g*q^-1)) then
            Error("Coordinate matrix does not identify both groups at ", i);
        fi;
        if i mod 20 = 0 or i = 156 then
            CF_FP_Log(log, Concatenation("Coordinate groups verified: ",
                String(i), "/156"));
        fi;
    od;
    before := CF_FP_Poset([1 .. 156], computed.positivePairs);
    pairs := []; count := 0; directCount := 0;
    for row in computed.pairs do
        copy := ShallowCopy(row);
        if row.ok then
            p := inverseMatrices[row.sourceNumber] * row.P
                * matrices[row.targetNumber];
            if IsZero(DeterminantMat(p)) or not ForAll(
                catalogue[row.sourceNumber].matrixGenerators,
                g -> contains(newGroups, newKnown, catalogue,
                    row.targetNumber, p^-1*g*p)) then
                Error("Invalid displayed-coordinate witness at ",
                    [row.sourceNumber,row.targetNumber]);
            fi;
            if row.direct then
                directCount := directCount + 1;
            else
                via := row.viaNumber;
                if not via in [1 .. 156]
                   or computed.pairMatrix[row.sourceNumber][via] = fail
                   or computed.pairMatrix[via][row.targetNumber] = fail
                   or not computed.pairMatrix[row.sourceNumber][via].ok
                   or not computed.pairMatrix[via][row.targetNumber].ok then
                    Error("Missing positive intermediate edges.");
                fi;
            fi;
            copy.P := p; count := count + 1;
            if count mod 100 = 0 or count = 1793 then
                CF_FP_Log(log, Concatenation("Containment matrices verified: ",
                    String(count), "/1793"));
            fi;
        elif copy <> row then
            Error("A negative decision was changed.");
        fi;
        Add(pairs, copy);
    od;
    Sort(pairs, function(a,b)
        if a.sourceNumber <> b.sourceNumber then
            return a.sourceNumber < b.sourceNumber;
        fi;
        return a.targetNumber < b.targetNumber;
    end);
    old := CF_FP_AuditPairs(catalogue, pairs);
    after := CF_FP_Poset([1 .. 156], old.positivePairs);
    if count <> 1793 or Length(pairs) - count <> 4775
       or directCount <> 1387
       or after.positivePairs <> before.positivePairs
       or Set(after.coverPairs) <> Set(before.coverPairs)
       or Length(after.coverPairs) <> 433
       or Length(after.maximalNumbers) <> 21
       or after.maximalNumbers <> before.maximalNumbers
       or after.maximalNumbers <> List(Filtered(catalogue,
            r -> r.isActionMaximal), r -> r.number) then
        Error("The saved relation, covers, or action maxima changed.");
    fi;
    positive := Filtered(pairs, r -> r.ok);
    covers := List(after.coverPairs, edge ->
        old.pairMatrix[edge[1]][edge[2]]);
    geometricCovers := List(covers, r -> rec(
        smallerFamilyNumber := r.targetNumber,
        largerFamilyNumber := r.sourceNumber,
        groupSourceNumber := r.sourceNumber,
        groupTargetNumber := r.targetNumber,
        classification := r.classification, P := r.P));
    geometricMaxima := Filtered([1 .. 156], i ->
        not ForAny(positive, r -> r.targetNumber = i));
    if geometricMaxima <> [132] then
        Error("The geometrically maximal family changed.");
    fi;
    extrema := rec(geometricMaximalFamilyNumbers := geometricMaxima,
        geometricMinimalFamilyNumbers := after.maximalNumbers);
    CF_FP_Write("result/gap_fourfold_cross_dimension_all_pairs.g",
        "FourfoldCrossDimensionAllPairs", pairs);
    CF_FP_Write("result/gap_fourfold_cross_dimension_positive_edges.g",
        "FourfoldCrossDimensionPositiveEdges", positive);
    CF_FP_Write("result/gap_fourfold_cross_dimension_cover_edges.g",
        "FourfoldCrossDimensionGroupEmbeddingCovers", covers);
    CF_FP_Write("result/gap_fourfold_cross_dimension_geometric_covers.g",
        "FourfoldCrossDimensionGeometricCovers", geometricCovers);
    CF_FP_Write("result/gap_fourfold_cross_dimension_extrema.g",
        "FourfoldCrossDimensionExtrema", extrema);
    audit := rec(status := "completed", gapVersion := GAPInfo.Version,
        familyCount := 156, pairCount := Length(pairs),
        verifiedPositiveCount := count, reusedNegativeCount := 4775,
        directPositiveCount := directCount,
        transitivePositiveCount := count - directCount,
        pairCoverageVerified := true, positiveRelationsUnchanged := true,
        coverRelationsUnchanged := true, actionMaximaUnchanged := true,
        transitiveClosureVerified := after.transitiveClosureVerified,
        coverClosureVerified := after.coverClosureVerified,
        coverPairs := after.coverPairs,
        actionMaximalNumbers := after.maximalNumbers,
        coordinateMatrices := matrices,
        inputGenerators := List(computed.catalogue, r -> r.matrixGenerators),
        catalogueGenerators := List(catalogue, r -> r.matrixGenerators),
        coordinateConvention := "Q^-1 H_computed Q = H_displayed",
        witnessConvention := "P_displayed = Q_source^-1 P_computed Q_target",
        negativeDecisionPolicy := "unchanged under conjugacy of both groups",
        embeddingSearchRepeated := false,
        runtimeMilliseconds := Runtime() - log.started);
    CF_FP_Write("result/gap_fourfold_coordinate_audit.out",
        "FourfoldContainmentCoordinateAudit", audit);
    stream := OutputTextFile("result/gap_fourfold_cross_dimension_all_pairs.tsv", false);
    SetPrintFormattingStatus(stream, false);
    AppendTo(stream, "group_source_family\tgroup_target_family\tsource_dimension\t",
        "target_dimension\tsource_order\ttarget_order\tstatus\t",
        "classification\tdirect\tvia_family\treason\tmethod\n");
    for row in pairs do
        AppendTo(stream, row.sourceNumber, "\t", row.targetNumber, "\t",
            row.sourceDimension, "\t", row.targetDimension, "\t",
            row.sourceOrder, "\t", row.targetOrder, "\t", row.status, "\t",
            row.classification, "\t", row.direct, "\t", row.viaNumber, "\t",
            row.reason, "\t", row.method, "\n");
    od;
    CloseStream(stream);
    stream := OutputTextFile("result/gap_fourfold_cross_dimension_geometric_covers.tsv", false);
    SetPrintFormattingStatus(stream, false);
    AppendTo(stream, "smaller_family\tlarger_family\tgroup_embedding\n");
    for row in covers do
        AppendTo(stream, row.targetNumber, "\t", row.sourceNumber, "\t",
            row.sourceNumber, "->", row.targetNumber, "\n");
    od;
    CloseStream(stream);
    PrintTo("result/gap_fourfold_cross_dimension_summary.txt",
        "input_families=156\neligible_cross_dimension_pairs=6568\n",
        "classified_pairs=6568\nembedded_pairs=1793\nno_embedding_pairs=4775\n",
        "undecided_pairs=0\ndirect_positive_pairs=1387\ntransitive_positive_pairs=406\n",
        "verified_positive_witnesses=1793\ngroup_embedding_cover_edges=433\n",
        "geometric_cover_edges=433\ngeometric_maximal_family_count=1\n",
        "geometric_minimal_family_count=21\npair_coverage=complete\n",
        "displayed_coordinates_audit=passed\ntransitive_closure_audit=passed\n");
    CF_FP_Log(log, "Completed: 1793 witnesses verified; 4775 negative decisions retained; 433 covers unchanged");
    AppendTo(log.stream, "FOURFOLD_COORDINATE_CONTAINMENT_COMPLETED\n");
    CloseStream(log.stream);
    Print("FOURFOLD_COORDINATE_CONTAINMENT_COMPLETED\n");
    return audit;
end;

FourfoldContainmentCoordinateAudit := CF_CC_Run();
