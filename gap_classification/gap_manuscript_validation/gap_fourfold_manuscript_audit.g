#############################################################################
## Compare displayed fourfold presentations with the computed catalogue.
## Run from the repository root after extracting the manuscript inputs.
## The source manuscript and canonical catalogue are read-only.
#############################################################################

Read("gap_classification/gap_functions.g");
Read("gap_classification/gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g");
Read("gap_classification/gap_manuscript_validation/gap_validation_functions.g");
Read("gap_classification/gap_manuscript_validation/gap_manuscript_input.g");
Read("gap_classification/gap_manuscript_validation/special_coordinate_audit.out");
Read("gap_classification/gap_manuscript_validation/gap_stored_coordinate_witnesses.g");
Read("gap_classification/gap_manuscript_validation/manuscript_component_coordinates.g");
CF_MV_PreviousFourfoldAudit := fail;
if IsExistingFile(
    "gap_classification/gap_manuscript_validation/gap_fourfold_manuscript_audit.out") then
    Read("gap_classification/gap_manuscript_validation/gap_fourfold_manuscript_audit.out");
    CF_MV_PreviousFourfoldAudit := FourfoldManuscriptAudit;
fi;

CF_MV_WriteFourfold := function(audit)
    local stream;
    stream := OutputTextFile(
        "gap_classification/gap_manuscript_validation/gap_fourfold_manuscript_audit.out",
        false);
    SetPrintFormattingStatus(stream, false);
    PrintTo(stream, "FourfoldManuscriptAudit := ", audit, ";\n");
    CloseStream(stream);
end;


CF_MV_RunFourfold := function()
    local audit, started, log, input, family, standard, generators,
          canonicalGroup, displayedGroup, genericGroup, candidates,
          override, special, comparison, row, basis, exponents,
          componentVectors, componentAudit, basisAudit, actualOrder,
          actualId, determinantOrder, markdown, symplecticGroup, finiteExtension,
          previous, originalStandard, componentModel, canonicalGenericGroup,
          coordinateModels;
    started := Runtime();
    audit := rec(status := "running", gapVersion := GAPInfo.Version,
        manuscriptSource := ManuscriptValidationSource,
        canonicalFile := "gap_classification/gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g",
        rows := []);
    coordinateModels := [];
    for componentModel in ManuscriptComponentCoordinates do
        originalStandard := CanonicalKoikeStandardGroups[componentModel.standardPosition];
        if not CF_MV_VerifyGroupWitness(
            Group(componentModel.symplecticGenerators),
            Group(originalStandard.symplecticGenerators),
            componentModel.displayedToCanonicalMatrix)
           or not CF_MV_VerifyGroupWitness(
            Group(componentModel.genericFullGenerators),
            Group(originalStandard.genericFullGenerators),
            componentModel.displayedToCanonicalMatrix) then
            Error("A component-coordinate certificate failed verification.");
        fi;
        Add(coordinateModels, rec(standardPosition := componentModel.standardPosition,
            componentNumbers := componentModel.componentNumbers,
            symplecticAndGenericGroupsVerified := true,
            displayedToCanonicalMatrix := componentModel.displayedToCanonicalMatrix));
    od;
    audit.componentCoordinateVerifications := coordinateModels;
    log := OutputTextFile(
        "gap_classification/gap_manuscript_validation/gap_fourfold_manuscript_audit.log",
        false);
    SetPrintFormattingStatus(log, false);
    for input in ManuscriptValidationInput do
        family := CanonicalFamilyMatrixGroups[input.number];
        originalStandard := CanonicalKoikeStandardGroups[family.standardPosition];
        standard := ShallowCopy(originalStandard);
        componentModel := First(ManuscriptComponentCoordinates,
            model -> model.standardPosition = family.standardPosition);
        if componentModel <> fail then
            standard.symplecticGenerators := componentModel.symplecticGenerators;
            standard.genericFullGenerators := componentModel.genericFullGenerators;
        fi;
        row := rec(number := input.number, sourceLine := input.sourceLine,
            symplecticPart := family.symplecticPart,
            index := family.fullIndex, familyDimension := family.familyDimension,
            linearGroupId := family.linearGroupId,
            projectiveGroupId := family.projectiveGroupId,
            extractionErrors := input.errors,
            basisChecked := false, groupChecked := false,
            allChecksPassed := false);
        row.retainedComponentCoordinates := componentModel <> fail;
        Print(input.number, ". Fourfold presentation: started\n");
        AppendTo(log, input.number, ". Fourfold presentation: started\n");
        if Length(input.errors) > 0 then
            row.status := "extraction_failed";
        elif not input.hasDisplayedExtra and input.displayedBasis = fail then
            if input.componentBasis = fail then
                row.status := "reference_only";
            else
                exponents := CF_DegreeThreeExponentVectors(6);
                componentVectors := List(input.componentBasis,
                    terms -> CF_MV_SparseVector(terms, exponents));
                componentAudit := CF_MV_BasisAudit(
                    standard.symplecticGenerators, componentVectors);
                row.componentBasisIndependent := componentAudit.independent;
                row.componentBasisComplete := componentAudit.equalsInvariantSpace;
                row.status := "component_basis_only";
                row.allChecksPassed := row.componentBasisIndependent
                    and row.componentBasisComplete;
            fi;
        else
            if input.hasDisplayedExtra then
                generators := Concatenation(standard.symplecticGenerators,
                    [input.extraGenerator]);
            else
                # For a recalled generic family use its recorded full group.
                generators := standard.genericFullGenerators;
            fi;
            displayedGroup := Group(generators);
            canonicalGroup := Group(family.matrixGenerators);
            genericGroup := Group(standard.genericFullGenerators);
            canonicalGenericGroup := Group(originalStandard.genericFullGenerators);
            symplecticGroup := Group(standard.symplecticGenerators);
            exponents := CF_DegreeThreeExponentVectors(6);
            finiteExtension := true;
            if input.hasDisplayedExtra then
                row.extraNormalizesSymplecticLift := ForAll(
                    standard.symplecticGenerators,
                    g -> input.extraGenerator^-1 * g * input.extraGenerator
                        in symplecticGroup);
                row.indexPowerInSymplecticLift := input.extraGenerator^family.fullIndex
                    in symplecticGroup;
                finiteExtension := row.extraNormalizesSymplecticLift
                    and row.indexPowerInSymplecticLift;
            fi;
            # Do not ask GAP to enumerate a potentially infinite matrix group.
            if not finiteExtension then
                row.status := "invalid_extension_in_fixed_coordinates";
            else
            actualOrder := Size(displayedGroup);
            row.actualLinearOrder := actualOrder;
            if actualOrder <> family.linearGroupId[1] then
                row.status := "group_order_mismatch";
            else
                actualId := fail;
                if IdGroupsAvailable(actualOrder) then
                    actualId := IdGroup(displayedGroup);
                fi;
                determinantOrder := CF_DeterminantImageOrder(displayedGroup);
                row.actualLinearGroupId := actualId;
                row.determinantImageOrder := determinantOrder;
                row.genericFullGroupContained := ForAll(
                    GeneratorsOfGroup(genericGroup), g -> g in displayedGroup);
                row.identifierAvailable := actualId <> fail;
                row.metadataMatched := determinantOrder = family.fullIndex
                    and (actualId = family.linearGroupId
                        or (actualId = fail and family.linearGroupId[2] = 0));
                candidates := [];
                if componentModel <> fail then
                    Add(candidates, componentModel.displayedToCanonicalMatrix);
                fi;
                for override in ManuscriptStoredCoordinateWitnesses do
                    if override.number = input.number then
                        Add(candidates, override.P);
                        Add(candidates, override.P^-1);
                    fi;
                od;
                if CF_MV_PreviousFourfoldAudit <> fail then
                    for previous in CF_MV_PreviousFourfoldAudit.rows do
                        if previous.number = input.number
                           and IsBound(previous.conjugacy)
                           and previous.conjugacy.P <> fail then
                            Add(candidates, previous.conjugacy.P);
                        fi;
                    od;
                fi;
                for special in SpecialCoordinateAudit.rows do
                    if special.number = input.number
                       and IsBound(special.canonicalToDisplayedMatrix) then
                        Add(candidates, special.canonicalToDisplayedMatrix^-1);
                    fi;
                od;
                comparison := CF_MV_CompareGroups(displayedGroup, canonicalGroup,
                    family.linearGroupId, candidates);
                row.conjugacy := comparison;
                row.groupChecked := true;
                row.status := comparison.status;
                if comparison.P <> fail then
                    row.symplecticLiftCorrespondenceVerified := ForAll(
                        standard.symplecticGenerators,
                        g -> comparison.P^-1 * g * comparison.P
                            in Group(originalStandard.symplecticGenerators));
                    row.genericFullGroupCorrespondenceVerified := ForAll(
                        standard.genericFullGenerators,
                        g -> comparison.P^-1 * g * comparison.P in canonicalGenericGroup);
                fi;
                if input.displayedBasis <> fail then
                    exponents := CF_DegreeThreeExponentVectors(6);
                    basis := List(input.displayedBasis,
                        terms -> CF_MV_SparseVector(terms, exponents));
                    basisAudit := CF_MV_BasisAudit(generators, basis);
                    row.basisAudit := basisAudit;
                    row.basisChecked := true;
                    row.dimensionMatched := basisAudit.familyDimension
                        = family.familyDimension;
                else
                    row.dimensionMatched := fail;
                fi;
                if input.componentBasis <> fail then
                    componentVectors := List(input.componentBasis,
                        terms -> CF_MV_SparseVector(terms, exponents));
                    componentAudit := CF_MV_BasisAudit(
                        standard.symplecticGenerators, componentVectors);
                    row.componentBasisIndependent := componentAudit.independent;
                    row.componentBasisComplete := componentAudit.equalsInvariantSpace;
                fi;
                row.allChecksPassed := row.metadataMatched
                    and comparison.status in ["equal", "conjugate"]
                    and row.genericFullGroupContained
                    and IsBound(row.symplecticLiftCorrespondenceVerified)
                    and row.symplecticLiftCorrespondenceVerified
                    and IsBound(row.genericFullGroupCorrespondenceVerified)
                    and row.genericFullGroupCorrespondenceVerified;
                if row.basisChecked then
                    row.allChecksPassed := row.allChecksPassed
                        and row.basisAudit.independent
                        and row.basisAudit.equalsInvariantSpace
                        and row.dimensionMatched;
                fi;
                if IsBound(row.componentBasisComplete) then
                    row.allChecksPassed := row.allChecksPassed
                        and row.componentBasisComplete
                        and row.componentBasisIndependent;
                fi;
            fi;
            fi;
        fi;
        Add(audit.rows, row);
        audit.runtimeMilliseconds := Runtime() - started;
        CF_MV_WriteFourfold(audit);
        Print(input.number, ". Fourfold presentation: ", row.status,
            "; passed = ", row.allChecksPassed, "\n");
        AppendTo(log, input.number, ". Fourfold presentation: ", row.status,
            "; passed = ", row.allChecksPassed, "\n");
    od;
    audit.status := "completed";
    audit.referenceOnlyCount := Number(audit.rows, r -> r.status = "reference_only");
    audit.componentOnlyCount := Number(audit.rows, r -> r.status = "component_basis_only");
    audit.groupCheckedCount := Number(audit.rows, r -> r.groupChecked);
    audit.basisCheckedCount := Number(audit.rows, r -> r.basisChecked);
    audit.passedCount := Number(audit.rows, r -> r.allChecksPassed);
    audit.failures := List(Filtered(audit.rows,
        r -> r.status <> "reference_only" and not r.allChecksPassed), r -> r.number);
    audit.runtimeMilliseconds := Runtime() - started;
    CF_MV_WriteFourfold(audit);
    markdown := OutputTextFile(
        "gap_classification/gap_manuscript_validation/gap_fourfold_manuscript_audit.md",
        false);
    SetPrintFormattingStatus(markdown, false);
    PrintTo(markdown, "# Fourfold manuscript validation\n\n",
        "Source: `", ManuscriptValidationSource.file, "`.\n\n",
        "GAP ", GAPInfo.Version, "; groups checked: ", audit.groupCheckedCount,
        "; bases checked: ", audit.basisCheckedCount,
        "; component-only rows: ", audit.componentOnlyCount,
        "; reference-only rows: ", audit.referenceOnlyCount,
        "; failures: `", audit.failures, "`.\n\n",
        "A reference-only row is not a fresh presentation verification. ",
        "Exact group and coefficient certificates are retained in ",
        "[the GAP-readable result](gap_fourfold_manuscript_audit.out).\n\n",
        "| No. | Symplectic part | Index | Dimension | Status | Basis | Passed |\n",
        "| ---: | --- | ---: | ---: | --- | --- | --- |\n");
    for row in audit.rows do
        AppendTo(markdown, "| ", row.number, " | ", row.symplecticPart,
            " | ", row.index, " | ", row.familyDimension, " | ", row.status,
            " | ", row.basisChecked, " | ", row.allChecksPassed, " |\n");
    od;
    CloseStream(markdown);
    CloseStream(log);
    Print("VALIDATION_COMPLETE fourfold; groups = ", audit.groupCheckedCount,
        "; bases = ", audit.basisCheckedCount, "; failures = ", audit.failures, "\n");
    return audit;
end;

FourfoldManuscriptAudit := CF_MV_RunFourfold();
QUIT_GAP(0);
