#############################################################################
## Complete the numbered family presentations and replay coordinate witnesses.
## Run from the repository root after the manuscript metadata/display audits.
## No representation enumeration or embedding search is performed here.
#############################################################################

Read("gap_classification/gap_functions.g");
Read("gap_classification/gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g");
Read("gap_classification/gap_saturation/gap_saturation_input.g");
Read("gap_classification/gap_saturation/gap_equal_dimension_saturation.out");
Read("gap_classification/gap_coordinate_presentation/gap_coordinate_presentation.out");
Read("gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("gap_classification/gap_manuscript_validation/gap_validation_functions.g");
Read("gap_classification/gap_manuscript_validation/gap_manuscript_input.g");
Read("gap_classification/gap_manuscript_validation/gap_manuscript_metadata_audit.out");
Read("gap_classification/gap_manuscript_validation/gap_fourfold_manuscript_audit.out");
Read("gap_classification/gap_manuscript_validation/manuscript_component_coordinates.g");

CF_OC_Directory := "gap_classification/gap_manuscript_validation/";

CF_OC_Write := function(file, name, value)
    local stream;
    stream := OutputTextFile(Concatenation(CF_OC_Directory, file), false);
    if stream = fail then Error("Cannot write the ordered catalogue result."); fi;
    SetPrintFormattingStatus(stream, false);
    AppendTo(stream, name, " := ", value, ";\n");
    CloseStream(stream);
end;

## Both generator containments establish equality without a character search.
## Convention: P^-1 * source * P = target.
CF_OC_VerifyEquality := function(sourceGenerators, targetGenerators, P)
    local source, target, inverse, images;
    if P = fail or IsZero(DeterminantMat(P)) then return false; fi;
    inverse := P^-1;
    images := List(sourceGenerators, g -> inverse * g * P);
    # Reordering generators or replacing them by inverses is an exact shortcut.
    if ForAll(images, g -> g in targetGenerators or g^-1 in targetGenerators)
       and ForAll(targetGenerators, g -> g in images or g^-1 in images) then
        return true;
    fi;
    source := Group(sourceGenerators);
    target := Group(targetGenerators);
    return ForAll(sourceGenerators, g -> inverse * g * P in target)
       and ForAll(targetGenerators, g -> P * g * inverse in source);
end;

CF_OC_Run := function()
    local numbers, audit, catalogue, log, started, input, saved, standard,
          model, display, frozen, candidate, matches, pair, generators,
          symplectic, generic, extra, D, S, R, Q, invariant, basis, exponents,
          centralizer, entry, row, checks, metadata, key, printedBasis,
          changedNumbers, markdown, name;
    numbers := [1 .. 156];
    if EqualDimensionSaturationAudit.status <> "completed"
       or EqualDimensionSaturationAudit.survivorCount <> 156
       or CoordinatePresentationAudit.status <> "verified_unique"
       or ManuscriptMetadataAudit.verifiedCount <> 156
       or ManuscriptMetadataAudit.failures <> []
       or FourfoldManuscriptAudit.status <> "completed"
       or FourfoldManuscriptAudit.failures <> [] then
        Error("Completed saturation and coordinate/display certificates are required.");
    fi;
    if List(ManuscriptValidationInput, r -> r.number) <> numbers
       or List(CanonicalFamilyMatrixGroups, r -> r.number) <> numbers
       or List(Families, r -> r.number) <> numbers
       or Set(List(CanonicalFamilyMatrixGroups, r -> r.sourceKey))
          <> Set(EqualDimensionSaturationAudit.survivorKeys)
       or Length(Set(EqualDimensionSaturationAudit.survivorKeys)) <> 156 then
        Error("The complete family numbering or survivor-key correspondence failed.");
    fi;
    started := Runtime();
    log := OutputTextFile(Concatenation(CF_OC_Directory,
        "gap_family_correspondence.log"), false);
    if log = fail then Error("Cannot open the coordinate transcript."); fi;
    SetPrintFormattingStatus(log, false);
    AppendTo(log, "Ordered family coordinate verification\nGAP ",
        GAPInfo.Version, "\n\n");
    audit := rec(status := "running", gapVersion := GAPInfo.Version,
        recordCount := 156, rows := [], manuscriptSource := ManuscriptValidationSource,
        survivorFile := "gap_classification/gap_saturation/gap_equal_dimension_saturation.out",
        computationalCatalogueFile := "gap_classification/gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g",
        crossDimensionInputFile := "gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g",
        presentationFile := Concatenation(CF_OC_Directory, "gap_family_catalogue.g"));
    catalogue := [];
    exponents := CF_DegreeThreeExponentVectors(6);
    for input in ManuscriptValidationInput do
        saved := CanonicalFamilyMatrixGroups[input.number];
        standard := CanonicalKoikeStandardGroups[saved.standardPosition];
        frozen := Families[input.number];
        display := FourfoldManuscriptAudit.rows[input.number];
        metadata := ManuscriptMetadataAudit.rows[input.number];
        if input.errors <> [] or not metadata.passed
           or input.number <> display.number
           or CoordinatePresentationAudit.computedCatalogue[input.number].sourceKey
              <> saved.sourceKey then
            Error("The numbered source correspondence failed at ", input.number);
        fi;
        matches := Filtered(SaturationInputCandidates,
            r -> r.sourceKey = saved.sourceKey);
        if Length(matches) <> 1 then Error("A survivor key is not unique."); fi;
        candidate := matches[1];
        matches := Filtered(CoordinatePresentationAudit.pairResults,
            r -> r.computedPosition = input.number
              and r.presentationPosition = input.number
              and r.status = "equivalent");
        if Length(matches) <> 1 then Error("A saved coordinate witness is missing."); fi;
        pair := matches[1];
        S := pair.P;
        symplectic := standard.symplecticGenerators;
        generic := standard.genericFullGenerators;
        model := First(ManuscriptComponentCoordinates,
            r -> r.standardPosition = saved.standardPosition);
        if model <> fail then
            symplectic := model.symplecticGenerators;
            generic := model.genericFullGenerators;
        fi;
        extra := fail;
        if input.hasDisplayedExtra then
            extra := input.extraGenerator;
            generators := Concatenation(symplectic, [extra]);
            if not display.groupChecked or not display.allChecksPassed then
                Error("An explicit group display is unverified.");
            fi;
            D := display.conjugacy.P;
        elif input.displayedBasis <> fail then
            generators := generic;
            if not display.groupChecked or not display.allChecksPassed then
                Error("A recalled family display is unverified.");
            fi;
            D := display.conjugacy.P;
            extra := saved.extraGenerator;
        elif input.componentBasis <> fail then
            if saved.genericIndex <> 1 or saved.fullIndex <> 1
               or not display.allChecksPassed then
                Error("A component-only row needs its own full-group model.");
            fi;
            generators := generic;
            D := IdentityMat(6);
            if model <> fail then D := model.displayedToCanonicalMatrix; fi;
        else
            # Citation-only rows keep the explicit saved representative.
            generators := saved.matrixGenerators;
            extra := saved.extraGenerator;
            D := IdentityMat(6);
        fi;
        if D = fail then Error("A presentation coordinate matrix is missing."); fi;
        Q := D^-1;
        R := S * Q;
        checks := rec(
            frozenGenerators := frozen.generators = saved.matrixGenerators,
            frozenMetadata := frozen.familyDimension = saved.familyDimension
                and frozen.linearGroupId = saved.linearGroupId
                and frozen.projectiveGroupId = saved.projectiveGroupId,
            survivorMetadata := candidate.rankS = saved.rankS
                and candidate.symplecticPart = saved.symplecticPart
                and candidate.fullIndex = saved.fullIndex
                and candidate.familyDimension = saved.familyDimension
                and candidate.linearGroupId = saved.linearGroupId
                and candidate.projectiveGroupId = saved.projectiveGroupId,
            computedToSaved := CF_OC_VerifyEquality(
                candidate.matrixGenerators, saved.matrixGenerators, S),
            savedToPresentation := CF_OC_VerifyEquality(
                saved.matrixGenerators, generators, Q),
            computedToPresentation := CF_OC_VerifyEquality(
                candidate.matrixGenerators, generators, R),
            symplecticCorrespondence := CF_OC_VerifyEquality(
                standard.symplecticGenerators, symplectic, Q),
            genericFullCorrespondence := CF_OC_VerifyEquality(
                standard.genericFullGenerators, generic, Q),
            componentGenericIndex := input.table.genericIndex = saved.genericIndex
                and standard.genericFullLinearOrder
                    = saved.genericIndex * standard.symplecticLinearOrder);
        invariant := CF_CubicInvariantBasis(generators,
            rec(buildPolynomialObjects := false, buildStrings := false));
        centralizer := CF_CentralizerAlgebraBasis(generators, false);
        basis := invariant.coefficientBasis;
        printedBasis := input.displayedBasis <> fail;
        if printedBasis then
            basis := List(input.displayedBasis,
                terms -> CF_MV_SparseVector(terms, exponents));
        elif input.componentBasis <> fail and saved.fullIndex = 1 then
            basis := List(input.componentBasis,
                terms -> CF_MV_SparseVector(terms, exponents));
            printedBasis := true;
        fi;
        checks.basisComplete := CF_MV_SameSpan(basis, invariant.coefficientBasis)
            and RankMat(basis) = Length(basis);
        checks.dimension := invariant.invariantDimension - centralizer.dimension
            = saved.familyDimension;
        entry := rec(number := input.number, sourceKey := saved.sourceKey,
            symplecticPart := saved.symplecticPart, rankS := saved.rankS,
            genericIndex := saved.genericIndex, fullIndex := saved.fullIndex,
            familyDimension := saved.familyDimension,
            linearGroupId := saved.linearGroupId,
            projectiveGroupId := saved.projectiveGroupId,
            standardPosition := saved.standardPosition,
            symplecticGenerators := symplectic, genericFullGenerators := generic,
            extraGenerator := extra, matrixGenerators := generators,
            cubicExponents := exponents, coefficientBasis := basis,
            invariantDimension := invariant.invariantDimension,
            centralizerDimension := centralizer.dimension,
            basisFromDisplay := printedBasis, displayKind := input.kind,
            sourceLine := input.sourceLine, koikeReference := standard.koikeReference,
            isLiftable := input.table.liftable, isFLiftable := input.table.fLiftable,
            isActionMaximal := input.table.aMaximal,
            fullGroupVerified := saved.fullGroupVerified,
            determinantKernelVerified := saved.determinantKernelVerified);
        row := rec(number := input.number, sourceKey := saved.sourceKey,
            saturationSurvivorPosition := Position(
                EqualDimensionSaturationAudit.survivorKeys, saved.sourceKey),
            computationalNumber := saved.number, crossDimensionNumber := frozen.number,
            sourceGenericIndexMetadata := candidate.genericIndex,
            componentGenericIndex := saved.genericIndex,
            checks := checks, computedToSavedMatrix := S,
            savedToPresentationMatrix := Q, computedToPresentationMatrix := R,
            literalGroupEquality := CF_OC_VerifyEquality(
                saved.matrixGenerators, generators, IdentityMat(6)),
            passed := ForAll(RecNames(checks), name -> checks.(name)));
        Add(audit.rows, row);
        if not row.passed then
            CF_OC_Write("gap_family_correspondence.out", "FamilyCoordinateAudit", audit);
            Error("Ordered family verification failed at ", input.number,
                "; checks = ", checks);
        fi;
        Add(catalogue, entry);
        Print(input.number, ". Family coordinates: verified\n");
        AppendTo(log, input.number, ". Family coordinates: verified\n");
    od;
    changedNumbers := List(Filtered(audit.rows,
        r -> not r.literalGroupEquality), r -> r.number);
    audit.status := "completed";
    audit.verifiedCount := Length(catalogue);
    audit.failures := [];
    audit.coordinateChangedNumbers := changedNumbers;
    audit.displayedBasisCount := Number(catalogue, r -> r.basisFromDisplay);
    audit.completedBasisCount := 156 - audit.displayedBasisCount;
    audit.runtimeMilliseconds := Runtime() - started;
    CF_OC_Write("gap_family_catalogue.g", "CubicFourfoldFamilyCatalogue", catalogue);
    CF_OC_Write("gap_family_correspondence.out", "FamilyCoordinateAudit", audit);
    markdown := OutputTextFile(Concatenation(CF_OC_Directory,
        "gap_family_correspondence.md"), false);
    SetPrintFormattingStatus(markdown, false);
    AppendTo(markdown, "# Ordered family coordinates\n\n",
        "GAP ", GAPInfo.Version, "; verified families: 156; failures: none.\n\n",
        "[The complete catalogue](gap_family_catalogue.g) follows the numbered ",
        "family table exactly. Explicit matrices and bases use the displayed ",
        "coordinates. Citation-only rows retain their saved explicit ",
        "representatives; missing bases are completed by exact invariant-space ",
        "calculation. All 156 bases and family dimensions are checked.\n\n",
        "All 156 representatives are linearly equivalent to the computed ",
        "survivors. Their numbering agrees with the fixed containment input. ",
        "The exact conjugating matrices and the original survivor numbering ",
        "are stored in [the GAP result](gap_family_correspondence.out). ",
        "Symplectic and generic full groups are checked separately.\n\n",
        Length(changedNumbers), " rows use conjugate matrix presentations: `", changedNumbers,
        "`. The other ", 156 - Length(changedNumbers), " full groups are literally equal to their ",
        "computational representatives.\n\n",
        "These coordinate changes preserve the saturation, self-conjugacy, ",
        "containment, and threefold-extraction conclusions. Saved numerical ",
        "matrices remain in their original coordinates and must be transformed ",
        "before application to the displayed matrices. No classification or ",
        "embedding search is repeated. The coordinate conventions are given ",
        "in [the script description](gap_manuscript_validation_script.md).\n\n",
        "| No. | Symplectic part | Index | Dimension | GL ID | PGL ID | Verified |\n",
        "| ---: | --- | ---: | ---: | --- | --- | --- |\n");
    for entry in catalogue do
        AppendTo(markdown, "| ", entry.number, " | ", entry.symplecticPart,
            " | ", entry.fullIndex, " | ", entry.familyDimension,
            " | ", entry.linearGroupId, " | ", entry.projectiveGroupId,
            " | yes |\n");
    od;
    CloseStream(markdown);
    AppendTo(log, "\nVerified 156 families; coordinate changes: ", changedNumbers,
        "; runtime: ", audit.runtimeMilliseconds, " ms\n",
        "VALIDATION_COMPLETE ordered family catalogue\n");
    CloseStream(log);
    Print("VALIDATION_COMPLETE ordered family catalogue; verified = 156; ",
        "coordinate changes = ", changedNumbers, "\n");
    return audit;
end;

FamilyCoordinateAudit := CF_OC_Run();
QUIT_GAP(0);
