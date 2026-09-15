#############################################################################
## Compare all fourfold table rows with saved classification results.
## No group enumeration, liftability test, or containment search is rerun.
#############################################################################

Read("gap_classification/gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g");
Read("gap_classification/gap_liftability/gap_liftability.out");
Read("gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_extrema.g");
Read("gap_classification/gap_manuscript_validation/gap_manuscript_input.g");

CF_MV_MetadataRun := function()
    local result, input, family, standard, lifting, row, checks, stream;
    result := rec(status := "completed", gapVersion := GAPInfo.Version,
        manuscriptSource := ManuscriptValidationSource, rows := []);
    for input in ManuscriptValidationInput do
        family := CanonicalFamilyMatrixGroups[input.number];
        standard := CanonicalKoikeStandardGroups[family.standardPosition];
        lifting := First(CubicFourfoldLiftabilityAudit.results,
            r -> r.number = input.number);
        checks := rec(rank := input.table.rankS = family.rankS,
            symplecticOrder := input.table.symplecticProjectiveOrder
                = standard.symplecticLinearOrder / 3,
            genericIndex := input.table.genericIndex = family.genericIndex,
            fullIndex := input.table.fullIndex = family.fullIndex,
            dimension := input.table.familyDimension = family.familyDimension,
            liftable := input.table.liftable = lifting.isLiftable,
            fLiftable := input.table.fLiftable = lifting.isFLiftable,
            actionMaximal := input.table.aMaximal
                = (input.number in FourfoldCrossDimensionExtrema.geometricMinimalFamilyNumbers));
        row := rec(number := input.number, checks := checks,
            projectiveIdCompared := false, passed := ForAll(RecNames(checks),
                name -> checks.(name)));
        if input.table.projectiveId <> fail and family.projectiveGroupId[2] <> 0 then
            row.projectiveIdCompared := true;
            row.projectiveIdMatched := input.table.projectiveId
                = family.projectiveGroupId;
            row.passed := row.passed and row.projectiveIdMatched;
        fi;
        Add(result.rows, row);
    od;
    result.verifiedCount := Number(result.rows, r -> r.passed);
    result.failures := List(Filtered(result.rows, r -> not r.passed), r -> r.number);
    result.liftableCount := Number(ManuscriptValidationInput, r -> r.table.liftable);
    result.fLiftableCount := Number(ManuscriptValidationInput, r -> r.table.fLiftable);
    result.actionMaximalCount := Number(ManuscriptValidationInput, r -> r.table.aMaximal);
    stream := OutputTextFile(
        "gap_classification/gap_manuscript_validation/gap_manuscript_metadata_audit.out", false);
    SetPrintFormattingStatus(stream, false);
    PrintTo(stream, "ManuscriptMetadataAudit := ", result, ";\n");
    CloseStream(stream);
    Print("VALIDATION_COMPLETE metadata; verified = ", result.verifiedCount,
        "; failures = ", result.failures, "; liftable = ", result.liftableCount,
        "; F-liftable = ", result.fLiftableCount,
        "; action-maximal = ", result.actionMaximalCount, "\n");
    return result;
end;

ManuscriptMetadataAudit := CF_MV_MetadataRun();
QUIT_GAP(0);
