#############################################################################
## Audit literal containment of the fixed generic full group.
##
## This reads the completed 156-family catalogue.  It does not reconstruct
## candidates or repeat smoothness, saturation, or conjugacy searches.
#############################################################################

if not IsExistingFile("gap_classification/gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g") then
    Error("Run this audit from the repository root.");
fi;

Read("gap_classification/gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g");

CF_GFG_Run := function()
    local rows, failures, record, standard, fullGroup,
          symplecticContained, genericContained, fullOrderCorrect, row,
          audit, outputPath, markdownPath, stream;

    rows := [];
    failures := [];
    for record in CanonicalFamilyMatrixGroups do
        standard := CanonicalKoikeStandardGroups[record.standardPosition];
        fullGroup := Group(record.matrixGenerators);
        symplecticContained := ForAll(
            standard.symplecticGenerators,
            generator -> generator in fullGroup
        );
        genericContained := ForAll(
            standard.genericFullGenerators,
            generator -> generator in fullGroup
        );
        fullOrderCorrect :=
            Size(fullGroup)
            = record.fullIndex * standard.symplecticLinearOrder;

        row := rec(
            number := record.number,
            sourceKey := record.sourceKey,
            symplecticPart := record.symplecticPart,
            genericIndex := record.genericIndex,
            fullIndex := record.fullIndex,
            symplecticGroupContained := symplecticContained,
            genericFullGroupContained := genericContained,
            fullOrderCorrect := fullOrderCorrect
        );
        Add(rows, row);
        if not symplecticContained
           or not genericContained
           or not fullOrderCorrect then
            Add(failures, row);
        fi;
    od;

    audit := rec(
        gapVersion := GAPInfo.Version,
        numberOfFamilies := Length(rows),
        numberOfFailures := Length(failures),
        failures := failures,
        rows := rows
    );
    outputPath := Concatenation(
        "gap_classification/gap_uniformization/",
        "gap_generic_full_group_audit.out"
    );
    PrintTo(
        outputPath,
        "GenericFullGroupAudit := ", audit, ";\n"
    );

    markdownPath := Concatenation(
        "gap_classification/gap_uniformization/",
        "gap_generic_full_group_audit.md"
    );
    stream := OutputTextFile(markdownPath, false);
    if stream = fail then Error("Could not open the audit summary."); fi;
    SetPrintFormattingStatus(stream, false);
    PrintTo(
        stream,
        "# Fixed generic-group audit\n\n",
        "The final catalogue was checked without changing coordinates.  ",
        "For every row, the selected Koike/corrigendum symplectic lift and ",
        "its generic full group are literally contained in the saved full ",
        "matrix group.  The expected full linear-group order is checked ",
        "independently.\n\n",
        "- GAP version: `", GAPInfo.Version, "`\n",
        "- Families checked: ", Length(rows), "\n",
        "- Failures: ", Length(failures), "\n"
    );
    CloseStream(stream);

    Print("Families checked: ", Length(rows), "\n");
    Print("Failures: ", Length(failures), "\n");
    for row in failures do
        Print(
            "  ", row.number, ": ", row.sourceKey,
            "; H_s=", row.symplecticGroupContained,
            "; generic=", row.genericFullGroupContained,
            "; order=", row.fullOrderCorrect, "\n"
        );
    od;
end;

CF_GFG_Run();
