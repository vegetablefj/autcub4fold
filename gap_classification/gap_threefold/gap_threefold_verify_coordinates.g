#############################################################################
## Check the saved extraction in the final fourfold and threefold coordinates.
## No Fermat-class, representation, saturation or embedding search is run.
## Run from this folder with the saved five-variable display input.
#############################################################################

Read("../gap_functions.g");
Read("../gap_manuscript_validation/gap_validation_functions.g");
Read("../gap_fourfold_cross_dimension/gap_family_poset_functions.g");
if LoadPackage("smallgrp") = fail then Error("The smallgrp package is required."); fi;

CF_TV_BlockLift := function(matrix)
    local result, i;
    result := IdentityMat(6);
    for i in [1 .. 5] do result[i]{[1 .. 5]} := matrix[i]; od;
    return result;
end;

CF_TV_Run := function()
    local log, oldCatalogue, formal, correspondence, extraction, witnesses,
          display, sourceNumbers, selected, extracted, results, checks,
          exponents5, exponents6, fivePositions, mixedPositions,
          i, number, source, old, entry, witness, row, q, p, oldGroup,
          generators, images, imageGroup, strictOrder, basis, invariants,
          centralizer, scalarGroup, quotient, linearId, projectiveId,
          adapted, delta, lifts, targetGroup, targetKnown, contains,
          adaptedCubics, complementaryCubics, cubeKernelDimension,
          record, catalogue, audit, fourfoldAudit, fourfoldPairs, fourfoldData,
          fourfoldPoset, positive, poset, edge, first, second, negative,
          cubePosition, extractedCatalogue, extractedGenerators, extractedAdapted,
          extractedBasis, extractedLifts, extractedCubics, presentationRecord,
          extractedRecord;
    log := CF_FP_StartLog("output/gap_threefold_verify_coordinates.log",
        "Threefold extraction and final coordinate checks");
    oldCatalogue := CF_FP_ReadGlobal(
        "../gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g",
        "CanonicalFamilyMatrixGroups");
    formal := CF_FP_ReadGlobal(
        "../gap_manuscript_validation/gap_family_catalogue.g",
        "CubicFourfoldFamilyCatalogue");
    correspondence := CF_FP_ReadGlobal(
        "../gap_manuscript_validation/gap_family_correspondence.out",
        "FamilyCoordinateAudit");
    extraction := CF_FP_ReadGlobal("input/gap_threefold_extraction.g",
        "CubicThreefoldIndexThreeAudit");
    witnesses := CF_FP_ReadGlobal("input/gap_threefold_coordinate_witnesses.g",
        "ThreefoldCoordinateWitnesses");
    display := CF_FP_ReadGlobal("input/gap_threefold_display_input.g",
        "ThreefoldManuscriptInput");
    fourfoldAudit := CF_FP_ReadGlobal(
        "../gap_fourfold_cross_dimension/result/gap_fourfold_coordinate_audit.out",
        "FourfoldContainmentCoordinateAudit");
    fourfoldPairs := CF_FP_ReadGlobal(
        "../gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_all_pairs.g",
        "FourfoldCrossDimensionAllPairs");
    if extraction.status <> "completed" or extraction.sourceCatalogueCount <> 156
       or extraction.selectedSourceCount <> 63 or extraction.extractedSourceCount <> 40
       or extraction.skippedSourceCount <> 23 or extraction.dimensionVerifiedCount <> 40
       or correspondence.status <> "completed" or correspondence.failures <> []
       or Length(correspondence.rows) <> 156
       or List(oldCatalogue, r -> r.number) <> [1 .. 156]
       or List(formal, r -> r.number) <> [1 .. 156]
       or List(display, r -> r.number) <> [1 .. 40]
       or Length(witnesses) <> 40 then
        Error("Incomplete numbered extraction or coordinate input.");
    fi;
    if fourfoldAudit.status <> "completed"
       or fourfoldAudit.verifiedPositiveCount <> 1793
       or List(oldCatalogue,r->r.matrixGenerators) <> fourfoldAudit.inputGenerators
       or List(formal,r->r.matrixGenerators) <> fourfoldAudit.catalogueGenerators
       or List(correspondence.rows,r->r.savedToPresentationMatrix)
           <> fourfoldAudit.coordinateMatrices then
        Error("The completed fourfold coordinate check does not match these sources.");
    fi;
    fourfoldData := CF_FP_AuditPairs(formal,fourfoldPairs);
    fourfoldPoset := CF_FP_Poset([1 .. 156],fourfoldData.positivePairs);
    if Length(fourfoldData.positivePairs) <> 1793
       or Set(fourfoldPoset.coverPairs) <> Set(fourfoldAudit.coverPairs)
       or fourfoldPoset.maximalNumbers <> fourfoldAudit.actionMaximalNumbers then
        Error("The saved fourfold relation does not match its coordinate check.");
    fi;
    selected := Filtered(oldCatalogue,
        r -> r.extraGenerator <> fail and r.fullIndex mod 3 = 0);
    if Length(selected) <> 63
       or List(selected, r -> r.number) <> extraction.selectedSourceNumbers
       or Set(extraction.selectedSourceNumbers)
           <> Set(List(extraction.results, r -> r.sourceFamilyNumber))
       or Length(extraction.results) <> 63 then
        Error("Incomplete index-three source coverage.");
    fi;
    extracted := Filtered(extraction.results, r -> r.producesThreefold);
    negative := Filtered(extraction.results, r -> not r.producesThreefold);
    if Length(extracted) <> 40 or Length(negative) <> 23 then
        Error("The saved extraction counts differ.");
    fi;
    for record in negative do
        i := record.sourceFamilyNumber; source := formal[i]; old := oldCatalogue[i];
        if record.status <> "no_Fermat_summand"
           or record.fourfoldFermatRank <> 0 or record.fermatClassCount <> 0
           or record.sourceKey <> old.sourceKey or source.sourceKey <> old.sourceKey
           or record.sourceStrictOrder <> source.linearGroupId[1]
           or record.sourceLinearGroupId <> source.linearGroupId
           or record.sourceProjectiveGroupId <> source.projectiveGroupId
           or record.sourceFullIndex <> source.fullIndex then
            Error("A saved no-Fermat decision does not match its source.");
        fi;
    od;
    sourceNumbers := List(display, r -> r.sourceFourfoldNumber);
    if sourceNumbers <> SortedList(sourceNumbers)
       or Length(Set(sourceNumbers)) <> 40
       or Set(sourceNumbers) <> Set(List(extracted, r -> r.sourceFamilyNumber)) then
        Error("The threefold order must follow the fourfold source order.");
    fi;
    positive := [];
    for edge in fourfoldData.positivePairs do
        first := Position(sourceNumbers,edge[1]);
        second := Position(sourceNumbers,edge[2]);
        if first <> fail and second <> fail then Add(positive,[first,second]); fi;
    od;
    poset := CF_FP_Poset([1 .. 40],positive);
    if Length(poset.positivePairs) <> 260 or Length(poset.coverPairs) <> 83
       or Length(poset.maximalNumbers) <> 7 then
        Error("The induced threefold relation changed.");
    fi;
    exponents5 := CF_DegreeThreeExponentVectors(5);
    exponents6 := CF_DegreeThreeExponentVectors(6);
    cubePosition := Position(exponents6,[0,0,0,0,0,3]);
    fivePositions := List(exponents5,
        e -> Position(exponents6, Concatenation(e,[0])));
    mixedPositions := Filtered([1 .. Length(exponents6)],
        i -> exponents6[i][6] in [1,2]);
    results := []; catalogue := []; extractedCatalogue := [];
    for entry in display do
        number := entry.number; i := entry.sourceFourfoldNumber;
        source := formal[i]; old := oldCatalogue[i];
        row := correspondence.rows[i]; q := row.savedToPresentationMatrix;
        record := First(extracted, r -> r.sourceFamilyNumber = i);
        witness := First(witnesses, r -> r.sourceFourfoldNumber = i);
        if entry.errors <> [] or record = fail or witness = fail
           or row.number <> i or row.computationalNumber <> i
           or row.crossDimensionNumber <> i or row.passed <> true
           or not ForAll(RecNames(row.checks), n -> row.checks.(n) = true)
           or source.sourceKey <> old.sourceKey or row.sourceKey <> old.sourceKey
           or record.sourceKey <> old.sourceKey or witness.sourceKey <> old.sourceKey
           or record.familyDimension <> source.familyDimension
           or entry.familyDimension <> source.familyDimension
           or record.sourceStrictOrder <> source.linearGroupId[1]
           or record.sourceLinearGroupId <> source.linearGroupId
           or record.sourceProjectiveGroupId <> source.projectiveGroupId
           or record.sourceFullIndex <> source.fullIndex
           or source.fullGroupVerified <> true or source.determinantKernelVerified <> true
           or record.fermatClassCount <> 1
           or record.fermatClassSize <> record.fourfoldFermatRank
           or record.threefoldFermatRank <> record.fourfoldFermatRank - 1
           or record.sourceStrictOrder <>
                3 * record.fermatClassSize * record.strictOrder
           or record.cubicMonomialExponents <> exponents5
           or DeterminantMat(q) = 0 then
            Error("Source metadata mismatch at threefold ", number);
        fi;
        CF_FP_Log(log, Concatenation("Threefold ", String(number),
            "; fourfold source ", String(i), ": started"));
        p := witness.matrix;
        if p = fail or DeterminantMat(p) = 0 then Error("Invalid saved five-dimensional matrix."); fi;
        if DeterminantMat(record.sourceToAdaptedBasis) = 0
           or TransposedMat(record.sourceToAdaptedBasis){[1 .. 5]}
                <> record.fixedSpaceBasis
           or record.sourceToAdaptedBasis^-1*record.fermatElement*
                record.sourceToAdaptedBasis <> DiagonalMat([1,1,1,1,1,E(3)]) then
            Error("The saved eigenspace basis does not match the Fermat element.");
        fi;
        oldGroup := Group(record.strictGenerators);
        strictOrder := Size(oldGroup);
        if witness.strictOrder <> strictOrder
           or witness.familyDimension <> entry.familyDimension
           or not ForAll(witness.sourceGenerators,g -> g in oldGroup)
           or Size(Subgroup(oldGroup,witness.sourceGenerators)) <> strictOrder
           or not CF_MV_SameSpan(witness.sourceBasis,record.cubicInvariantBasisVectors) then
            Error("The coordinate witness source does not match the extracted family.");
        fi;
        generators := ShallowCopy(entry.displayedGenerators);
        images := List(generators, g -> p^-1*g*p);
        if not ForAll(images, g -> g in oldGroup) then
            Error("Printed generators do not lie in the conjugated saved group.");
        fi;
        imageGroup := Subgroup(oldGroup, images);
        if strictOrder <> record.strictOrder or Size(imageGroup) <> strictOrder
           or strictOrder <> entry.linearGroupId[1]
           or strictOrder <> 3*entry.projectiveGroupId[1] then
            Error("The five-dimensional groups are not equal up to conjugacy.");
        fi;
        ## The displayed list itself generates the full strict group.
        ## Add an explicit scalar only after checking that list's full order.
        if not E(3)*IdentityMat(5) in generators then Add(generators,E(3)*IdentityMat(5)); fi;
        basis := List(entry.displayedBasis, terms -> CF_MV_SparseVector(terms, exponents5));
        invariants := CF_CubicInvariantBasis(generators,
            rec(ambientDimension := 5, buildPolynomialObjects := false, buildStrings := false));
        centralizer := CF_CentralizerAlgebraBasis(generators, false, 5);
        if RankMat(basis) <> Length(basis)
           or not CF_MV_SameSpan(basis, invariants.coefficientBasis)
           or not ForAll(generators,
                g -> CF_MV_TransformVectors(basis,g,exponents5) = basis)
           or invariants.invariantDimension <> entry.invariantDimension
           or centralizer.dimension <> entry.centralizerDimension
           or invariants.invariantDimension - centralizer.dimension <> entry.familyDimension
           or not CF_MV_SameSpan(
                CF_MV_TransformVectors(basis,p^-1,exponents5),
                record.cubicInvariantBasisVectors) then
            Error("The five-dimensional invariant family or dimension differs.");
        fi;
        scalarGroup := Group([E(3)*IdentityMat(5)]);
        if not IsSubgroup(oldGroup,scalarGroup) then Error("Missing cubic scalars."); fi;
        quotient := Image(NaturalHomomorphismByNormalSubgroup(oldGroup,scalarGroup));
        linearId := [strictOrder,0]; projectiveId := [Size(quotient),0];
        if IdGroupsAvailable(strictOrder) then linearId := IdGroup(oldGroup); fi;
        if IdGroupsAvailable(Size(quotient)) then projectiveId := IdGroup(quotient); fi;
        if linearId <> entry.linearGroupId or projectiveId <> entry.projectiveGroupId then
            Error("A printed abstract group identifier differs at threefold ", number,
                ": computed ", [linearId,projectiveId],
                "; printed ", [entry.linearGroupId,entry.projectiveGroupId]);
        fi;
        extractedGenerators := ShallowCopy(record.strictGenerators);
        if not E(3)*IdentityMat(5) in extractedGenerators then
            Add(extractedGenerators,E(3)*IdentityMat(5));
        fi;
        extractedBasis := record.cubicInvariantBasisVectors;
        if RankMat(extractedBasis) <> Length(extractedBasis)
           or not ForAll(extractedGenerators,
                g -> CF_MV_TransformVectors(extractedBasis,g,exponents5) = extractedBasis)
           or not CF_MV_SameSpan(
                CF_MV_TransformVectors(extractedBasis,p,exponents5),basis) then
            Error("The extracted cubic space does not match its presentation.");
        fi;
        ## The saved five-space is taken to the printed one by p^-1.
        extractedAdapted := q^-1 * record.sourceToAdaptedBasis;
        adapted := extractedAdapted * CF_TV_BlockLift(p^-1);
        delta := q^-1 * record.fermatElement * q;
        if DeterminantMat(adapted) = 0 or Order(delta) <> 3
           or TraceMat(delta) <> 5+E(3)
           or adapted^-1*delta*adapted <> DiagonalMat([1,1,1,1,1,E(3)]) then
            Error("The transported Fermat split differs.");
        fi;
        targetGroup := fail;
        targetKnown := Set(Concatenation(source.matrixGenerators,
            List(source.matrixGenerators,g->g^-1),[IdentityMat(6)]));
        contains := function(matrix)
            if matrix in targetKnown then return true; fi;
            if targetGroup = fail then targetGroup := Group(source.matrixGenerators); fi;
            return matrix in targetGroup;
        end;
        if not contains(delta)
           or not ForAll(old.matrixGenerators, g -> contains(q^-1*g*q)) then
            Error("The transported source groups differ.");
        fi;
        lifts := List(generators, g -> adapted*CF_TV_BlockLift(g)*adapted^-1);
        if not ForAll(lifts, g -> contains(g) and g*delta=delta*g) then
            Error("A full five-dimensional generator does not extend to the source.");
        fi;
        extractedLifts := List(extractedGenerators,
            g -> extractedAdapted*CF_TV_BlockLift(g)*extractedAdapted^-1);
        extractedCubics := CF_MV_TransformVectors(
            source.coefficientBasis,extractedAdapted^-1,exponents6);
        if not ForAll(extractedLifts,g -> contains(g) and g*delta=delta*g)
           or not CF_MV_SameSpan(List(extractedCubics,v->v{fivePositions}),extractedBasis)
           or not ForAll(extractedCubics,
                v -> ForAll(mixedPositions,j -> v[j] = 0)) then
            Error("The extracted family does not come from the final fourfold coordinates.");
        fi;
        adaptedCubics := CF_MV_TransformVectors(source.coefficientBasis, adapted^-1, exponents6);
        complementaryCubics := List(adaptedCubics, v -> v{fivePositions});
        cubeKernelDimension := Length(source.coefficientBasis) - RankMat(complementaryCubics);
        if RankMat(source.coefficientBasis) <> Length(source.coefficientBasis)
           or not ForAll(source.matrixGenerators,
                g -> CF_MV_TransformVectors(source.coefficientBasis,g,exponents6)
                        = source.coefficientBasis)
           or not ForAny(adaptedCubics,v -> v[cubePosition] <> 0)
           or not ForAll(adaptedCubics,
                v -> ForAll(mixedPositions, j -> v[j] = 0))
           or not CF_MV_SameSpan(complementaryCubics,basis)
           or (record.fourfoldFermatRank = 1 and cubeKernelDimension <> 1)
           or (record.fourfoldFermatRank > 1 and cubeKernelDimension <> 0) then
            Error("The formal fourfold cubics do not give the printed complementary family.");
        fi;
        checks := rec(sourceMetadata := true, fiveDimensionalGroup := true,
            invariantBasis := true, familyDimension := true, abstractGroupIds := true,
            FermatSplit := true, fullCentralizer := true,
            restrictionKernel := true, formalCubicRestriction := true,
            displayedGeneratorsComplete := true,
            extractedFamilyMetadata := true, extractedInvariantBasis := true,
            extractedFormalRestriction := true);
        Add(results, rec(number := number, sourceFourfoldNumber := i,
            sourceKey := source.sourceKey, passed := true, checks := checks,
            savedToPrintedMatrix := p^-1, fourfoldToAdaptedBasis := adapted,
            extractedToPresentationMatrix := p^-1,
            extractedToAdaptedBasis := extractedAdapted,
            fermatElement := delta, centralizerGenerators := Concatenation(lifts,[delta]),
            centralizerOrder := 3*strictOrder, restrictionKernelOrder := 3,
            projectedCubicBasis := complementaryCubics,
            cubeProjectionKernelDimension := cubeKernelDimension));
        presentationRecord := rec(number := number, sourceFourfoldNumber := i,
            sourceKey := source.sourceKey, familyDimension := entry.familyDimension,
            symplecticPart := source.symplecticPart, sourceFullIndex := source.fullIndex,
            threefoldFermatRank := record.threefoldFermatRank,
            fourfoldFermatRank := record.fourfoldFermatRank,
            matrixGenerators := generators, cubicExponents := exponents5,
            coefficientBasis := basis, invariantDimension := invariants.invariantDimension,
            centralizerDimension := centralizer.dimension,
            linearGroupId := linearId, projectiveGroupId := projectiveId,
            strictOrder := strictOrder, projectiveOrder := Size(quotient),
            fermatElement := delta, fourfoldToAdaptedBasis := adapted,
            fixedSpaceBasis := TransposedMat(adapted){[1 .. 5]},
            fullGroupVerified := true, familyDimensionVerified := true,
            isActionMaximal := poset.familyTargets[number].isMaximal);
        Add(catalogue,presentationRecord);
        extractedRecord := ShallowCopy(presentationRecord);
        extractedRecord.matrixGenerators := extractedGenerators;
        extractedRecord.coefficientBasis := extractedBasis;
        extractedRecord.fourfoldToAdaptedBasis := extractedAdapted;
        extractedRecord.fixedSpaceBasis := TransposedMat(extractedAdapted){[1 .. 5]};
        Add(extractedCatalogue,extractedRecord);
        CF_FP_Log(log, Concatenation("Threefold ", String(number), ": verified"));
    od;
    audit := rec(status := "completed", gapVersion := GAPInfo.Version,
        familyCount := 40, verifiedCount := 40, rows := results,
        selectedSourceCount := 63, extractedSourceCount := 40, skippedSourceCount := 23,
        sourceNumbers := sourceNumbers,
        extractedGenerators := List(extractedCatalogue,r->r.matrixGenerators),
        presentationGenerators := List(catalogue,r->r.matrixGenerators),
        extractedBases := List(extractedCatalogue,r->r.coefficientBasis),
        presentationBases := List(catalogue,r->r.coefficientBasis),
        numbering := "increasing source fourfold number",
        noFermatDecisionsReusedUnderConjugacy := true,
        newExtractionSearchPerformed := false, newEmbeddingSearchPerformed := false,
        allPrintedIdsVerified := true, runtimeMilliseconds := Runtime()-log.started);
    CF_FP_Write("result/gap_threefold_coordinate_audit.out", "CubicThreefoldCoordinateAudit",audit);
    CF_FP_Write("result/gap_threefold_families.g", "CubicThreefoldFamilyCatalogue",catalogue);
    CF_FP_Write("result/gap_threefold_extracted_families.g",
        "CubicThreefoldExtractedCatalogue",extractedCatalogue);
    CF_FP_Log(log,"Completed: all 40 groups, cubic spaces, splits, dimensions and IDs verified");
    AppendTo(log.stream,"THREEFOLD_COORDINATES_VERIFIED\n");
    CloseStream(log.stream);
    Print("THREEFOLD_COORDINATES_VERIFIED\n");
    return audit;
end;

CubicThreefoldCoordinateAudit := CF_TV_Run();
