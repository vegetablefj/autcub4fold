#############################################################################
## Containment and maximal actions for the 40 final threefold families.
## Verify the direct five-dimensional pair results and recompute covers.
## The induced fourfold relation is used only as an independent comparison.
## See gap_threefold_script.md. This reporting file performs no search.
#############################################################################

CF_TC_Paths := function()
    local self, sibling;
    if IsExistingFile("gap_threefold_containment.g") then
        self := ""; sibling := "../";
    elif IsExistingFile("gap_threefold/gap_threefold_containment.g") then
        self := "gap_threefold/"; sibling := "";
    elif IsExistingFile(
        "gap_classification/gap_threefold/gap_threefold_containment.g") then
        self := "gap_classification/gap_threefold/";
        sibling := "gap_classification/";
    else
        Error("Run from the repository root, gap_classification, or ",
            "gap_classification/gap_threefold.");
    fi;
    return rec(selfDirectory := self,
        posetFile := Concatenation(sibling,
            "gap_fourfold_cross_dimension/gap_family_poset_functions.g"),
        fourfoldCatalogueFile := Concatenation(sibling,
            "gap_manuscript_validation/gap_family_catalogue.g"),
        fourfoldRelationFile := Concatenation(sibling,
            "gap_fourfold_cross_dimension/result/",
            "gap_fourfold_cross_dimension_all_pairs.g"),
        fourfoldAuditFile := Concatenation(sibling,
            "gap_fourfold_cross_dimension/result/",
            "gap_fourfold_coordinate_audit.out"),
        catalogueFile := Concatenation(self,"result/gap_threefold_families.g"),
        extractedFile := Concatenation(self,"result/gap_threefold_extracted_families.g"),
        directPairsFile := Concatenation(self,
            "result/gap_threefold_cross_dimension_all_pairs.g"),
        directManifestFile := Concatenation(self,
            "result/gap_threefold_cross_dimension_manifest.g"),
        auditFile := Concatenation(self,"result/gap_threefold_coordinate_audit.out"));
end;

CF_TC_PathRecord := CF_TC_Paths();
Read(CF_TC_PathRecord.posetFile);

CF_TC_BlockLift := function(matrix)
    local result, i;
    result := IdentityMat(6);
    for i in [1 .. 5] do result[i]{[1 .. 5]} := matrix[i]; od;
    return result;
end;

## Display labels only; the group data are verified separately.
CF_TC_ProjectiveNames := [
    [1,"(C3^4):S5"], [7,"L2(11)"], [8,"S5 x C3"],
    [23,"S3 x ((C3^2:C3):C2)"], [24,"S3 x ((C3^2:C3):C4)"],
    [28,"S4 x C3"], [30,"A5"], [32,"S5"], [36,"S3 x C6"],
    [38,"(S3 x S3):C2"], [56,"S3 x C3"], [57,"S3 x S3"],
    [61,"D12"], [62,"(C6 x C2):C2"], [64,"C6 x C2"],
    [67,"A4"], [69,"S4"], [72,"D10"], [86,"S3"], [90,"C6"],
    [91,"D12"], [94,"C12"], [95,"S3 x C4"], [96,"C24"],
    [101,"C2^2"], [103,"D8"], [110,"C3"], [113,"C6"],
    [116,"C3"], [117,"S3"], [123,"C2"], [125,"C2^2"],
    [130,"C4 x C2"], [135,"1"], [139,"C2"], [147,"C4"],
    [148,"C4"], [153,"C8"], [154,"C8"], [156,"C16"]
];

CF_TC_GroupName := function(sourceNumber)
    local position;
    position := Position(List(CF_TC_ProjectiveNames,r->r[1]),sourceNumber);
    if position = fail then Error("Missing threefold display label."); fi;
    return CF_TC_ProjectiveNames[position][2];
end;

CF_TC_BraceList := function(numbers)
    return Concatenation("{",
        JoinStringsWithSeparator(List(numbers,String),", "),"}");
end;

CF_TC_WriteMarkdown := function(output, poset)
    local stream, family, number, coverTargets, geometricParents, dimension;
    stream := OutputTextFile(Concatenation(CF_TC_PathRecord.selfDirectory,
        "result/gap_threefold_result.md"),false);
    if stream = fail then Error("Cannot write the threefold report."); fi;
    SetPrintFormattingStatus(stream,false);
    AppendTo(stream,
        "# Cubic-threefold families and containment\n\n",
        "The 40 families are numbered by increasing source fourfold number. ",
        "Their five-dimensional strict groups and complete cubic bases are ",
        "in [the final catalogue](gap_threefold_families.g). The ",
        "[coordinate verification](gap_threefold_coordinate_audit.out) ",
        "identifies them with [the extracted groups](gap_threefold_extracted_families.g).\n\n",
        "A group relation `i -> j` means that `H_i` is linearly conjugate ",
        "to a proper subgroup of `H_j`. The geometric inclusion is ",
        "`Z_j subset Z_i`. An action-maximal row has no outgoing group ",
        "relation; it is not a geometrically maximal family.\n\n",
        "## Summary\n\n| Quantity | Count |\n| --- | ---: |\n",
        "| Fourfold sources selected | 63 |\n",
        "| Sources with a Fermat summand | 40 |\n",
        "| Sources without a Fermat summand | 23 |\n",
        "| Threefold families | ",output.familyCount," |\n",
        "| Ordered distinct pairs | ",output.orderedDistinctPairCount," |\n",
        "| Eligible pairs | ",output.eligiblePairCount," |\n",
        "| Pairs excluded by dimension or order | ",output.excludedPairCount," |\n",
        "| Positive relations | ",output.positivePairCount," |\n",
        "| Negative eligible decisions | ",output.negativePairCount," |\n",
        "| Undecided pairs | 0 |\n",
        "| Cover relations | ",output.coverCount," |\n",
        "| Action-maximal families | ",output.actionMaximalCount," |\n\n",
        "The relation comes from the direct five-dimensional calculation. ",
        "All positive `5 x 5` matrices have been checked on every source ",
        "generator. Every eligible pair has a resolved decision, and all ",
        "ordered distinct pairs are recorded. Independently, the complete ",
        "relation agrees pair by pair with the relation induced from the ",
        "completed fourfold calculation. The transitive closure of the ",
        "covers recovers the full positive relation. The saved decisions ",
        "and matrices are in [the direct pair result](gap_threefold_cross_dimension_all_pairs.g) ",
        "and [the containment audit](gap_threefold_containment.out).\n\n",
        "## Action-maximal families\n\n",
        "| No. | Source fourfold | Projective group | Dimension | GL order | ",
        "PGL order | GL ID | PGL ID |\n",
        "| ---: | ---: | --- | ---: | ---: | ---: | --- | --- |\n");
    for number in output.actionMaximalNumbers do
        family := output.families[number];
        AppendTo(stream,"| ",number," | ",family.sourceFourfoldNumber,
            " | `",CF_TC_GroupName(family.sourceFourfoldNumber),"` | ",
            family.familyDimension," | ",family.strictOrder," | ",
            family.projectiveOrder," | `",CF_FP_GroupIdText(family.linearGroupId),
            "` | `",CF_FP_GroupIdText(family.projectiveGroupId),"` |\n");
    od;
    AppendTo(stream,
        "\n## All 40 families\n\n",
        "Here `dim W` is the dimension of the complete invariant cubic ",
        "space, `dim C` is the dimension of its linear centralizer, and ",
        "the family dimension is `dim W - dim C`. In `[order, --]`, the ",
        "order is known but the installed SmallGroups library has no ID. ",
        "Identical abstract group data do not identify a matrix action.\n\n",
        "| No. | Source fourfold | Projective group | Dimension | Fermat rank | ",
        "dim W | dim C | GL order | PGL order | GL ID | PGL ID |\n",
        "| ---: | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |\n");
    for family in output.families do
        AppendTo(stream,"| ",family.number," | ",family.sourceFourfoldNumber,
            " | `",CF_TC_GroupName(family.sourceFourfoldNumber),"` | ",
            family.familyDimension," | ",family.threefoldFermatRank," | ",
            family.invariantDimension," | ",family.centralizerDimension," | ",
            family.strictOrder," | ",family.projectiveOrder," | `",
            CF_FP_GroupIdText(family.linearGroupId),"` | `",
            CF_FP_GroupIdText(family.projectiveGroupId),"` |\n");
    od;
    AppendTo(stream,
        "\n## Group covers and action-maximal targets\n\n",
        "Cover targets use the group direction `i -> j`, so `Z_j subset Z_i`. ",
        "All reachable action-maximal targets are listed; an action-maximal ",
        "row lists itself. Paths are retained in the GAP-readable audit.\n\n",
        "| No. | Group cover targets | All action-maximal targets |\n",
        "| ---: | --- | --- |\n");
    for family in output.families do
        coverTargets := List(Filtered(poset.coverPairs,
            edge->edge[1]=family.number),edge->edge[2]);
        AppendTo(stream,"| ",family.number," | `",CF_TC_BraceList(coverTargets),
            "` | `",CF_TC_BraceList(family.actionMaximalTargets),"` |\n");
    od;
    AppendTo(stream,
        "\n## Geometric family incidence\n\n",
        "`#i: {j, ...}` lists the classified families `Z_j` that properly ",
        "contain `Z_i`, with no classified family strictly between them. ",
        "This reverses group containment. `{}` means that no classified ",
        "family properly contains `Z_i`. These 40 lines contain all ",
        output.coverCount," adjacent incidences.\n\n```text\n");
    for number in [1 .. 40] do
        geometricParents := List(Filtered(poset.coverPairs,
            edge->edge[2]=number),edge->edge[1]);
        AppendTo(stream,"#",number,": ",CF_TC_BraceList(geometricParents),"\n");
    od;
    AppendTo(stream,"```\n\n## Family dimensions\n\n",
        "| Dimension | Families |\n| ---: | ---: |\n");
    for dimension in Set(List(output.families,r->r.familyDimension)) do
        AppendTo(stream,"| ",dimension," | ",
            Number(output.families,r->r.familyDimension=dimension)," |\n");
    od;
    CloseStream(stream);
end;

CF_TC_AuditDirectPairs := function(catalogue, pairs, manifest, log)
    local matrix, groups, positive, eligibleCount, negativeCount,
          orientationCount, orderCount, witnessCount, row, source, target,
          i, j, orientation, eligible, binding, images;
    if manifest.status <> "completed" or manifest.pairCoverageVerified <> true
       or manifest.allEligiblePairsDirect <> true or manifest.undecidedCount <> 0
       or manifest.pairCount <> 40*39 or Length(pairs) <> 40*39
       or manifest.catalogueGenerators <> List(catalogue,r->r.matrixGenerators)
       or Length(manifest.catalogueBinding) <> 40 then
        Error("The direct threefold calculation is incomplete or uses other groups.");
    fi;
    for i in [1 .. 40] do
        source := catalogue[i]; binding := manifest.catalogueBinding[i];
        if binding.number <> i or binding.sourceFourfoldNumber <> source.sourceFourfoldNumber
           or binding.sourceKey <> source.sourceKey
           or binding.familyDimension <> source.familyDimension
           or binding.strictOrder <> source.strictOrder
           or binding.projectiveOrder <> source.projectiveOrder
           or binding.matrixGenerators <> source.matrixGenerators then
            Error("The direct input binding differs at threefold ",i);
        fi;
    od;
    matrix := List([1 .. 40],i->List([1 .. 40],j->fail));
    groups := List([1 .. 40],i->fail);
    positive := []; eligibleCount := 0; negativeCount := 0;
    orientationCount := 0; orderCount := 0; witnessCount := 0;
    for row in pairs do
        i := row.sourceNumber; j := row.targetNumber;
        if not i in [1 .. 40] or not j in [1 .. 40] or i=j then
            Error("Invalid direct threefold pair number.");
        fi;
        if matrix[i][j] <> fail then Error("Repeated direct threefold pair."); fi;
        source := catalogue[i]; target := catalogue[j];
        orientation := source.familyDimension > target.familyDimension;
        eligible := orientation and target.strictOrder mod source.strictOrder = 0;
        if row.sourcePosition <> i or row.targetPosition <> j
           or row.sourceFourfoldNumber <> source.sourceFourfoldNumber
           or row.targetFourfoldNumber <> target.sourceFourfoldNumber
           or row.sourceDimension <> source.familyDimension
           or row.targetDimension <> target.familyDimension
           or row.sourceOrder <> source.strictOrder or row.targetOrder <> target.strictOrder
           or row.eligible <> eligible or row.direct <> true
           or row.classification <> "direct" or row.viaNumber <> fail then
            Error("Direct threefold pair metadata differs at ",[i,j]);
        fi;
        if not orientation then
            orientationCount := orientationCount+1;
            if row.status <> "not_compared" or row.ok <> fail or row.P <> fail
               or row.reason <> "dimension_orientation" then
                Error("An excluded dimension orientation has an invalid claim.");
            fi;
        elif not eligible then
            orderCount := orderCount+1;
            if row.status <> "no_embedding" or row.ok <> false or row.P <> fail
               or row.reason <> "order_divisibility" then
                Error("Invalid order-divisibility exclusion.");
            fi;
        else
            eligibleCount := eligibleCount+1;
            if row.status="embedded" and row.ok=true then
                if source.strictOrder>=target.strictOrder
                   or row.P=fail or Length(row.P)<>5
                   or not ForAll(row.P,r->Length(r)=5)
                   or IsZero(DeterminantMat(row.P))
                   or row.witnessVerified<>true or row.characterEmbeddingProved<>true then
                    Error("Missing verified five-dimensional witness at ",[i,j]);
                fi;
                if groups[j]=fail then groups[j]:=Group(target.matrixGenerators); fi;
                images := List(source.matrixGenerators,g->row.P^-1*g*row.P);
                if not ForAll(images,g->g in groups[j]) then
                    Error("A direct five-dimensional witness fails at ",[i,j]);
                fi;
                witnessCount := witnessCount+1; Add(positive,[i,j]);
                CF_FP_Log(log,Concatenation("Verified five-dimensional pair ",
                    String(i)," -> ",String(j)));
            elif row.status="no_embedding" and row.ok=false and row.P=fail then
                negativeCount := negativeCount+1;
            else
                Error("An eligible direct threefold pair remains undecided at ",[i,j]);
            fi;
        fi;
        matrix[i][j] := row;
    od;
    for i in [1 .. 40] do
        for j in [1 .. 40] do
            if i<>j and matrix[i][j]=fail then Error("Missing direct threefold pair."); fi;
        od;
    od;
    if eligibleCount<>manifest.eligiblePairCount
       or negativeCount<>manifest.eligibleNegativeCount
       or Length(positive)<>manifest.positiveCount
       or orientationCount<>manifest.orientationExcludedCount
       or orderCount<>manifest.orderExcludedCount
       or eligibleCount+orientationCount+orderCount<>40*39
       or witnessCount<>Length(positive) then
        Error("Direct pair counts or complete coverage differ from the manifest.");
    fi;
    return rec(pairMatrix:=matrix,positivePairs:=Set(positive),
        eligiblePairCount:=eligibleCount,negativePairCount:=negativeCount,
        orientationExcludedCount:=orientationCount,orderExcludedCount:=orderCount,
        verifiedWitnessCount:=witnessCount,pairCoverageVerified:=true);
end;

CF_TC_Run := function()
    local log, data, catalogue, extracted, audit, fourfoldCatalogue, fourfoldPairs,
          fourfoldAudit, fourfoldPoset, sourceNumbers, induced,
          pair, i, j, families, entry, canonical, targetInfo, output,
          number, check, lifts, basis, directPairs, manifest, direct,
          directPoset, original, metadata, name, requiredChecks;
    log := CF_FP_StartLog(Concatenation(CF_TC_PathRecord.selfDirectory,
        "output/gap_threefold_containment.log"),
        "Containment and maximal full cubic-threefold actions");
    CF_FP_TestPosetHelpers();
    fourfoldCatalogue := CF_FP_ReadGlobal(CF_TC_PathRecord.fourfoldCatalogueFile,
        "CubicFourfoldFamilyCatalogue");
    fourfoldPairs := CF_FP_ReadGlobal(CF_TC_PathRecord.fourfoldRelationFile,
        "FourfoldCrossDimensionAllPairs");
    fourfoldAudit := CF_FP_ReadGlobal(CF_TC_PathRecord.fourfoldAuditFile,
        "FourfoldContainmentCoordinateAudit");
    catalogue := CF_FP_ReadGlobal(CF_TC_PathRecord.catalogueFile,
        "CubicThreefoldFamilyCatalogue");
    extracted := CF_FP_ReadGlobal(CF_TC_PathRecord.extractedFile,
        "CubicThreefoldExtractedCatalogue");
    audit := CF_FP_ReadGlobal(CF_TC_PathRecord.auditFile,
        "CubicThreefoldCoordinateAudit");
    directPairs := CF_FP_ReadGlobal(CF_TC_PathRecord.directPairsFile,
        "ThreefoldCrossDimensionAllPairs");
    manifest := CF_FP_ReadGlobal(CF_TC_PathRecord.directManifestFile,
        "ThreefoldCrossDimensionManifest");
    data := CF_FP_AuditPairs(fourfoldCatalogue, fourfoldPairs);
    fourfoldPoset := CF_FP_Poset([1 .. 156], data.positivePairs);
    if fourfoldAudit.status <> "completed"
       or fourfoldAudit.verifiedPositiveCount <> 1793
       or fourfoldAudit.pairCoverageVerified <> true
       or fourfoldAudit.positiveRelationsUnchanged <> true
       or List(fourfoldCatalogue,r->r.matrixGenerators)
          <> fourfoldAudit.catalogueGenerators
       or Set(fourfoldPoset.coverPairs) <> Set(fourfoldAudit.coverPairs)
       or fourfoldPoset.maximalNumbers <> fourfoldAudit.actionMaximalNumbers then
        Error("The complete formal fourfold relation lacks its coordinate audit.");
    fi;
    sourceNumbers := List(catalogue, r -> r.sourceFourfoldNumber);
    if audit.status <> "completed" or audit.familyCount <> 40
       or audit.verifiedCount <> 40 or audit.allPrintedIdsVerified <> true
       or audit.selectedSourceCount <> 63 or audit.extractedSourceCount <> 40
       or audit.skippedSourceCount <> 23 or Length(audit.rows) <> 40
       or List(catalogue,r->r.number) <> [1 .. 40]
       or List(extracted,r->r.number) <> [1 .. 40]
       or audit.extractedGenerators <> List(extracted,r->r.matrixGenerators)
       or audit.presentationGenerators <> List(catalogue,r->r.matrixGenerators)
       or audit.extractedBases <> List(extracted,r->r.coefficientBasis)
       or audit.presentationBases <> List(catalogue,r->r.coefficientBasis)
       or Length(Set(sourceNumbers)) <> 40
       or sourceNumbers <> SortedList(sourceNumbers)
       or sourceNumbers <> audit.sourceNumbers then
        Error("The final threefold catalogue or its coordinate audit is incomplete.");
    fi;
    CF_FP_Log(log, "Inputs verified: 156 formal fourfolds and 40 final threefolds");

    requiredChecks := ["sourceMetadata","fiveDimensionalGroup","invariantBasis",
        "familyDimension","abstractGroupIds","FermatSplit","fullCentralizer",
        "restrictionKernel","formalCubicRestriction","extractedFamilyMetadata",
        "extractedInvariantBasis","extractedFormalRestriction",
        "displayedGeneratorsComplete"];
    families := [];
    for i in [1 .. 40] do
        entry := catalogue[i]; check := audit.rows[i]; original := extracted[i];
        canonical := data.catalogue[entry.sourceFourfoldNumber];
        if entry.sourceKey <> canonical.sourceKey
           or entry.familyDimension <> canonical.familyDimension
           or entry.sourceFullIndex <> canonical.fullIndex
           or entry.symplecticPart <> canonical.symplecticPart
           or entry.fullGroupVerified <> true
           or entry.familyDimensionVerified <> true
           or entry.invariantDimension-entry.centralizerDimension
                <> entry.familyDimension
           or Length(entry.matrixGenerators) = 0
           or ForAny(entry.matrixGenerators,
                g -> Length(g) <> 5 or not ForAll(g,r->Length(r)=5))
           or entry.linearGroupId[1] <> entry.strictOrder
           or entry.projectiveGroupId[1] <> entry.projectiveOrder then
            Error("Threefold/canonical metadata mismatch at source ",
                entry.sourceFourfoldNumber);
        fi;
        metadata := ShallowCopy(original);
        for name in ["matrixGenerators","coefficientBasis",
            "fourfoldToAdaptedBasis","fixedSpaceBasis"] do
            metadata.(name) := entry.(name);
        od;
        if metadata<>entry then
            Error("Extracted/final threefold metadata differ at ",i);
        fi;
        if original.sourceFourfoldNumber<>entry.sourceFourfoldNumber
           or original.sourceKey<>entry.sourceKey
           or original.familyDimension<>entry.familyDimension
           or original.strictOrder<>entry.strictOrder
           or original.projectiveOrder<>entry.projectiveOrder
           or original.linearGroupId<>entry.linearGroupId
           or original.projectiveGroupId<>entry.projectiveGroupId
           or original.invariantDimension<>entry.invariantDimension
           or original.centralizerDimension<>entry.centralizerDimension
           or check.extractedToAdaptedBasis<>original.fourfoldToAdaptedBasis
           or check.extractedToPresentationMatrix<>check.savedToPrintedMatrix
           or Length(check.extractedToPresentationMatrix)<>5
           or not ForAll(check.extractedToPresentationMatrix,r->Length(r)=5)
           or IsZero(DeterminantMat(check.extractedToPresentationMatrix))
           or original.fourfoldToAdaptedBasis
                *CF_TC_BlockLift(check.extractedToPresentationMatrix)
                    <> entry.fourfoldToAdaptedBasis
           or TransposedMat(original.fourfoldToAdaptedBasis){[1 .. 5]}
                <> original.fixedSpaceBasis
           or Length(original.coefficientBasis)<>entry.invariantDimension
           or RankMat(original.coefficientBasis)<>entry.invariantDimension then
            Error("The extracted and final threefold records differ at ",i);
        fi;
        if entry.strictOrder <> entry.projectiveOrder * 3 then
            Error("Threefold strict order mismatch at source ",
                entry.sourceFourfoldNumber);
        fi;
        lifts := List(entry.matrixGenerators, g -> entry.fourfoldToAdaptedBasis
            * CF_TC_BlockLift(g) * entry.fourfoldToAdaptedBasis^-1);
        basis := check.projectedCubicBasis;
        if check.number <> i or check.sourceFourfoldNumber <> entry.sourceFourfoldNumber
           or check.sourceKey <> entry.sourceKey or check.passed <> true
           or not ForAll(requiredChecks,
                name->IsBound(check.checks.(name)) and check.checks.(name)=true)
           or not ForAll(RecNames(check.checks),name->check.checks.(name)=true)
           or check.fermatElement <> entry.fermatElement
           or check.fourfoldToAdaptedBasis <> entry.fourfoldToAdaptedBasis
           or check.centralizerGenerators <> Concatenation(lifts,[entry.fermatElement])
           or check.centralizerOrder <> 3*entry.strictOrder
           or check.restrictionKernelOrder <> 3
           or Length(entry.coefficientBasis) <> entry.invariantDimension
           or RankMat(entry.coefficientBasis) <> entry.invariantDimension
           or RankMat(basis) <> entry.invariantDimension
           or RankMat(Concatenation(basis,entry.coefficientBasis))
                <> entry.invariantDimension then
            Error("The exact threefold coordinate certificate differs at row ", i);
        fi;
        Add(families, rec(number := i,
            sourceFourfoldNumber := entry.sourceFourfoldNumber,
            sourceKey := entry.sourceKey,
            familyDimension := entry.familyDimension,
            symplecticPart := canonical.symplecticPart,
            sourceFullIndex := canonical.fullIndex,
            strictOrder := entry.strictOrder,
            projectiveOrder := entry.projectiveOrder,
            linearGroupId := entry.linearGroupId,
            projectiveGroupId := entry.projectiveGroupId,
            invariantDimension := entry.invariantDimension,
            centralizerDimension := entry.centralizerDimension,
            threefoldFermatRank := entry.threefoldFermatRank,
            fourfoldFermatRank := entry.fourfoldFermatRank,
            coordinateCertificateReused := true));
        CF_FP_Log(log, Concatenation("Prepared threefold ", String(i),
            " from fourfold ", String(entry.sourceFourfoldNumber)));
    od;

    direct := CF_TC_AuditDirectPairs(catalogue,directPairs,manifest,log);
    directPoset := CF_FP_Poset([1 .. 40],direct.positivePairs);
    induced := [];
    for pair in data.positivePairs do
        i := Position(sourceNumbers, pair[1]);
        j := Position(sourceNumbers, pair[2]);
        if i <> fail and j <> fail then Add(induced, [i,j]); fi;
    od;
    if Set(induced)<>directPoset.positivePairs then
        Error("The direct five-dimensional relation differs from the fourfold comparison.");
    fi;
    if Length(directPoset.positivePairs) <> 260
       or Length(directPoset.coverPairs) <> 83
       or directPoset.maximalNumbers <> [1,2,3,5,24,39,40] then
        Error("Unexpected direct threefold-poset counts.");
    fi;
    CF_FP_Log(log,"Direct five-dimensional relation agrees with the complete fourfold comparison");

    for i in [1 .. 40] do
        targetInfo := directPoset.familyTargets[i];
        if catalogue[i].isActionMaximal <> targetInfo.isMaximal then
            Error("An action-maximal catalogue flag differs at threefold ", i);
        fi;
        families[i].isActionMaximal := targetInfo.isMaximal;
        families[i].actionMaximalTargets := targetInfo.maximalTargets;
        families[i].actionMaximalFourfoldTargets := List(
            targetInfo.maximalTargets, number -> families[number].sourceFourfoldNumber);
        families[i].pathsToActionMaximal := targetInfo.pathsToMaximal;
    od;
    output := rec(schemaVersion := 4, status := "completed",
        gapVersion := GAPInfo.Version,
        meaning := "threefold action containment from direct five-dimensional pair decisions",
        mathematicalInterface := "gap_threefold_script.md",
        numbering := "increasing source fourfold number",
        inputCatalogue := "result/gap_threefold_families.g",
        inputCoordinateAudit := "result/gap_threefold_coordinate_audit.out",
        inputExtractedCatalogue := "result/gap_threefold_extracted_families.g",
        inputDirectPairs := "result/gap_threefold_cross_dimension_all_pairs.g",
        inputDirectManifest := "result/gap_threefold_cross_dimension_manifest.g",
        inputFourfoldRelation :=
          "../gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_all_pairs.g",
        sourceCatalogueMatched := true, coordinateMetadataVerified := true,
        coordinateCertificatesReused := true,
        familyCount := 40, families := families,
        orderedDistinctPairCount := Length(directPairs),
        eligiblePairCount := direct.eligiblePairCount,
        negativePairCount := direct.negativePairCount,
        orientationExcludedCount := direct.orientationExcludedCount,
        orderExcludedCount := direct.orderExcludedCount,
        excludedPairCount := direct.orientationExcludedCount+direct.orderExcludedCount,
        undecidedPairCount := 0,
        pairResults := directPairs,
        positivePairs := directPoset.positivePairs,
        positivePairCount := Length(directPoset.positivePairs),
        verifiedPositiveMatrixCount := direct.verifiedWitnessCount,
        pairCoverageVerified := true, allPositiveMatricesVerified := true,
        catalogueGenerators := List(catalogue,r->r.matrixGenerators),
        coverPairs := directPoset.coverPairs,
        coverCount := Length(directPoset.coverPairs),
        actionMaximalNumbers := directPoset.maximalNumbers,
        actionMaximalFourfoldNumbers := List(directPoset.maximalNumbers,
            number -> families[number].sourceFourfoldNumber),
        actionMaximalCount := Length(directPoset.maximalNumbers),
        transitiveClosureVerified := directPoset.transitiveClosureVerified,
        coverClosureVerified := directPoset.coverClosureVerified,
        relationObtainedByDirectFiveDimensionalSearch := true,
        fourfoldInducedRelation := Set(induced),
        fourfoldComparisonVerified := true,
        newEmbeddingSearchPerformedByReport := false,
        runtimeMilliseconds := Runtime() - log.started);
    CF_FP_Write(Concatenation(CF_TC_PathRecord.selfDirectory,
        "result/gap_threefold_containment.out"),
        "ThreefoldContainmentAudit", output);

    CF_TC_WriteMarkdown(output,directPoset);
    CF_FP_Log(log, Concatenation("Completed: maximal actions = ",
        String(output.actionMaximalCount)));
    AppendTo(log.stream, "THREEFOLD_CONTAINMENT_COMPLETED\n");
    Print("THREEFOLD_CONTAINMENT_COMPLETED\n");
    CloseStream(log.stream);
    return output;
end;

if not IsBound(CF_TC_DEFINE_ONLY) or CF_TC_DEFINE_ONLY<>true then
    ThreefoldContainmentAudit := CF_TC_Run();
fi;
