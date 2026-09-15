#############################################################################
## Minimize the single additional generator without moving the fixed
## generic full group.
##
## For a completed canonical family H with fixed symplectic lift H_s, every
## element whose determinant generates det(H) is of the form T^a h, where
## gcd(a,[H:H_s])=1 and h lies in H_s.  The script exhausts these elements,
## chooses the lexicographically smallest matrix score, and verifies the
## resulting generators exactly.  It never conjugates H or the generic full
## group and does not repeat classification, smoothness, or saturation.
##
## The default list consists only of entries whose displayed additional
## matrices merit a second look.  The complete catalogue builder has already
## performed the same coset search for all 156 entries.  Restricting this
## audit avoids reconstructing the element lists of the largest symplectic
## groups merely to detect negligible changes in printed coefficient length.
#############################################################################

if not IsExistingFile("gap_classification/gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g") then
    Error("Run this audit from the repository root.");
fi;

Read("gap_classification/gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g");

if not IsBound(CF_GO_FAMILY_NUMBERS) then
    CF_GO_FAMILY_NUMBERS := [
        26, 28, 32, 36, 38, 44, 49, 54, 56, 57, 61, 62, 64, 67,
        69, 72, 74, 75, 79, 86, 87, 90, 91, 92, 95, 96, 103, 104,
        105, 107, 113, 114, 116, 117, 118, 125, 127, 128, 129, 130,
        131, 141, 142, 143, 147, 148, 149, 150, 153, 154
    ];
fi;

CF_GO_MatrixScore := function(matrix)
    local rowCounts, columnCounts, monomialPenalty, nonzeroCount,
          nontrivialCount, totalLength, maximumLength, row, entry,
          entryLength, column;

    rowCounts := List(matrix, row -> Number(row, entry -> entry <> 0));
    columnCounts := [];
    for column in [1 .. Length(matrix)] do
        Add(columnCounts, Number(matrix, row -> row[column] <> 0));
    od;
    monomialPenalty :=
        Sum(rowCounts, count -> AbsInt(count - 1))
        + Sum(columnCounts, count -> AbsInt(count - 1));
    nonzeroCount := Sum(rowCounts);
    nontrivialCount := 0;
    totalLength := 0;
    maximumLength := 0;
    for row in matrix do
        for entry in row do
            if entry <> 0 then
                if entry <> 1 and entry <> -1 then
                    nontrivialCount := nontrivialCount + 1;
                fi;
                entryLength := Length(String(entry));
                totalLength := totalLength + entryLength;
                maximumLength := Maximum(maximumLength, entryLength);
            fi;
        od;
    od;
    return [
        monomialPenalty,
        nonzeroCount,
        nontrivialCount,
        totalLength,
        maximumLength
    ];
end;


CF_GO_AuditOne := function(record, standard, symplecticElements)
    local fullGroup, genericContained, current, currentScore, best,
          bestScore, exponent, power, h, candidate, candidateScore,
          improved, outputGroup;

    fullGroup := Group(record.matrixGenerators);
    genericContained := ForAll(
        standard.genericFullGenerators,
        generator -> generator in fullGroup
    );
    if not genericContained then
        Error(
            "The fixed generic full group is not contained in family ",
            record.number, "."
        );
    fi;

    current := record.extraGenerator;
    if current = fail then
        return rec(
            number := record.number,
            sourceKey := record.sourceKey,
            fullIndex := record.fullIndex,
            currentScore := fail,
            bestScore := fail,
            improved := false,
            bestGenerator := fail,
            exactGroupVerified := true
        );
    fi;

    if Order(DeterminantMat(current)) <> record.fullIndex then
        Error("The stored extra generator is not primitive at family ",
              record.number, ".");
    fi;

    currentScore := CF_GO_MatrixScore(current);
    best := current;
    bestScore := currentScore;
    for exponent in [1 .. record.fullIndex] do
        if Gcd(exponent, record.fullIndex) <> 1 then
            continue;
        fi;
        power := current^exponent;
        for h in symplecticElements do
            candidate := power * h;
            if Order(DeterminantMat(candidate)) <> record.fullIndex then
                continue;
            fi;
            candidateScore := CF_GO_MatrixScore(candidate);
            if candidateScore < bestScore
               or (candidateScore = bestScore
                   and String(candidate) < String(best)) then
                best := candidate;
                bestScore := candidateScore;
            fi;
        od;
    od;

    outputGroup := Group(Concatenation(
        standard.symplecticGenerators,
        [best]
    ));
    if outputGroup <> fullGroup then
        Error("The optimized generator does not recover family ",
              record.number, ".");
    fi;
    improved := bestScore < currentScore;
    return rec(
        number := record.number,
        sourceKey := record.sourceKey,
        fullIndex := record.fullIndex,
        currentScore := currentScore,
        bestScore := bestScore,
        improved := improved,
        bestGenerator := best,
        exactGroupVerified := true
    );
end;


CF_GO_Run := function()
    local cache, selectedRecords, rows, improvements, record, standard, position,
          symplecticElements, result, outputPath, markdownPath, stream;

    selectedRecords := Filtered(
        CanonicalFamilyMatrixGroups,
        record -> record.number in CF_GO_FAMILY_NUMBERS
    );
    if Length(selectedRecords) <> Length(Set(CF_GO_FAMILY_NUMBERS)) then
        Error("The requested family-number list is invalid.");
    fi;
    cache := [];
    rows := [];
    improvements := [];
    for record in selectedRecords do
        position := record.standardPosition;
        standard := CanonicalKoikeStandardGroups[position];
        if not IsBound(cache[position]) then
            cache[position] := Elements(Group(standard.symplecticGenerators));
        fi;
        symplecticElements := cache[position];
        result := CF_GO_AuditOne(record, standard, symplecticElements);
        Add(rows, result);
        if result.improved then
            Add(improvements, result);
            Print(
                "Improvement ", record.number, ": ",
                result.currentScore, " -> ", result.bestScore, "\n"
            );
        fi;
    od;

    outputPath := Concatenation(
        "gap_classification/gap_uniformization/",
        "gap_generator_optimization_audit.out"
    );
    PrintTo(
        outputPath,
        "GeneratorOptimizationAudit := rec(\n",
        "  gapVersion := \"", GAPInfo.Version, "\",\n",
        "  fixedGenericFullGroup := true,\n",
        "  selectedFamilyNumbers := ", CF_GO_FAMILY_NUMBERS, ",\n",
        "  numberOfFamiliesChecked := ", Length(rows), ",\n",
        "  numberOfImprovements := ", Length(improvements), ",\n",
        "  improvements := ", improvements, ",\n",
        "  rows := ", rows, "\n",
        ");\n"
    );

    markdownPath := Concatenation(
        "gap_classification/gap_uniformization/",
        "gap_generator_optimization_audit.md"
    );
    stream := OutputTextFile(markdownPath, false);
    if stream = fail then
        Error("Could not open the generator-optimization summary.");
    fi;
    SetPrintFormattingStatus(stream, false);
    PrintTo(
        stream,
        "# Additional-generator optimization audit\n\n",
        "The fixed generic full group is kept literally in its selected ",
        "Koike/corrigendum coordinates.  No conjugation is performed.  For ",
        "each family, all primitive determinant cosets modulo the fixed ",
        "symplectic lift are searched and the resulting full matrix group is ",
        "verified exactly.  This is an exact search inside each unchanged ",
        "full group; it is not a normalizer search that changes coordinates.\n\n",
        "- GAP version: `", GAPInfo.Version, "`\n",
        "- Selected families checked: ", Length(rows), "\n",
        "- Strict score improvements beyond the saved catalogue: ",
        Length(improvements), "\n\n"
    );
    if Length(improvements) = 0 then
        AppendTo(
            stream,
            "The saved single generators are already score-minimal inside ",
            "their unchanged full matrix groups.\n"
        );
    else
        AppendTo(
            stream,
            "| No. | Source | Current score | Best score |\n",
            "|---:|---|---|---|\n"
        );
        for result in improvements do
            AppendTo(
                stream,
                "| ", result.number,
                " | `", result.sourceKey,
                "` | `", result.currentScore,
                "` | `", result.bestScore,
                "` |\n"
            );
        od;
    fi;
    CloseStream(stream);

    Print("Families checked: ", Length(rows), "\n");
    Print("Further score improvements: ", Length(improvements), "\n");
end;

CF_GO_Run();
