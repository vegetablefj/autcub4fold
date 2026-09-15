#############################################################################
## Verify the abstract-group data of the final threefold catalogue.
##
## The matrices and numbering come from the final family catalogue; the
## action-maximal flags come from the saved threefold containment result.
## This script verifies the records and writes table data.  It performs no
## extraction or embedding search.
#############################################################################

if LoadPackage("smallgrp") = fail then
    Error("The GAP package smallgrp is required.");
fi;

CF_TT_Paths := function()
    if IsExistingFile("gap_threefold_table_data.g") then
        return rec(
            selfDirectory := "",
            functionsFile := "../gap_functions.g",
            extractionFile := "result/gap_threefold_families.g",
            containmentFile := "result/gap_threefold_containment.out"
        );
    fi;
    if IsExistingFile(
        "gap_classification/gap_threefold/gap_threefold_table_data.g"
    ) then
        return rec(
            selfDirectory := "gap_classification/gap_threefold/",
            functionsFile := "gap_classification/gap_functions.g",
            extractionFile := Concatenation(
                "gap_classification/gap_threefold/result/",
                "gap_threefold_families.g"
            ),
            containmentFile := Concatenation(
                "gap_classification/gap_threefold/result/",
                "gap_threefold_containment.out"
            )
        );
    fi;
    if IsExistingFile("gap_threefold/gap_threefold_table_data.g") then
        return rec(
            selfDirectory := "gap_threefold/",
            functionsFile := "gap_functions.g",
            extractionFile :=
                "gap_threefold/result/gap_threefold_families.g",
            containmentFile := Concatenation(
                "gap_threefold/result/",
                "gap_threefold_containment.out"
            )
        );
    fi;
    Error(
        "Run from the repository root, gap_classification, or ",
        "gap_classification/gap_threefold."
    );
end;

CF_TT_PathRecord := CF_TT_Paths();
Read(CF_TT_PathRecord.functionsFile);
Read(CF_TT_PathRecord.extractionFile);
Read(CF_TT_PathRecord.containmentFile);

CF_TT_OUTPUT_FILE := Concatenation(
    CF_TT_PathRecord.selfDirectory,
    "result/gap_threefold_table_data.out"
);
CF_TT_LOG_FILE := Concatenation(
    CF_TT_PathRecord.selfDirectory,
    "output/gap_threefold_table_data.log"
);
CF_TT_LogStream := OutputTextFile(CF_TT_LOG_FILE, false);
if CF_TT_LogStream = fail then
    Error("Cannot open log: ", CF_TT_LOG_FILE);
fi;
SetPrintFormattingStatus(CF_TT_LogStream, false);
AppendTo(CF_TT_LogStream,
    "Final cubic-threefold group and table checks\nGAP ", GAPInfo.Version,
    "\nNumbering: increasing source fourfold number\n\n");
CF_TT_Started := Runtime();
CF_TT_Log := function(line)
    Print(line);
    AppendTo(CF_TT_LogStream, line);
end;
CF_TT_ACTION_MAXIMAL_NUMBERS :=
    ThreefoldContainmentAudit.actionMaximalNumbers;


CF_TT_WriteAssignment := function(path, name, value)
    local stream;
    stream := OutputTextFile(path, false);
    if stream = fail then
        Error("Cannot open output file: ", path);
    fi;
    SetPrintFormattingStatus(stream, false);
    PrintTo(stream, name, " :=\n", value, ";\n");
    CloseStream(stream);
end;


# Calling StructureDescription directly on the larger cyclotomic matrix
# groups is unnecessarily expensive.  Identify the projective quotient first
# and read the standard description from the SmallGroups representative.
CF_TT_ProjectiveData := function(group)
    local identifier, description;

    identifier := fail;
    description := fail;
    if IdGroupsAvailable(Size(group)) then
        identifier := IdGroup(group);
        description := StructureDescription(
            SmallGroup(identifier[1], identifier[2])
        );
    fi;
    return rec(
        order := Size(group),
        id := identifier,
        structureDescription := description
    );
end;


CF_TT_Extracted := CubicThreefoldFamilyCatalogue;

if Length(CF_TT_Extracted) <> 40 then
    Error("Expected exactly 40 final threefold records.");
fi;
if List(CF_TT_Extracted, family -> family.number) <> [1 .. 40]
   or not ForAll([2 .. 40], number ->
       CF_TT_Extracted[number-1].sourceFourfoldNumber
           < CF_TT_Extracted[number].sourceFourfoldNumber) then
    Error("The final catalogue must follow increasing fourfold-source number.");
fi;

CF_TT_Records := [];
for CF_TT_Number in [1 .. 40] do
    CF_TT_Source := CF_TT_Extracted[CF_TT_Number];
    CF_TT_H := Group(CF_TT_Source.matrixGenerators);
    CF_TT_Z := Group([E(3) * IdentityMat(5, Cyclotomics)]);

    if Size(CF_TT_H) <> CF_TT_Source.strictOrder then
        Error("Strict-order mismatch in threefold row ", CF_TT_Number, ".");
    fi;
    if not IsSubgroup(CF_TT_H, CF_TT_Z) then
        Error("The cubic scalar is missing in threefold row ", CF_TT_Number, ".");
    fi;

    CF_TT_QuotientMap := NaturalHomomorphismByNormalSubgroup(CF_TT_H, CF_TT_Z);
    CF_TT_G := Image(CF_TT_QuotientMap);
    if Size(CF_TT_G) <> CF_TT_Source.projectiveOrder then
        Error("Projective-order mismatch in threefold row ", CF_TT_Number, ".");
    fi;
    if CF_TT_Source.isActionMaximal <>
        (CF_TT_Number in CF_TT_ACTION_MAXIMAL_NUMBERS) then
        Error("Action-maximal flag mismatch in threefold row ", CF_TT_Number, ".");
    fi;

    CF_TT_GData := CF_TT_ProjectiveData(CF_TT_G);
    if CF_TT_GData.id <> fail
       and CF_TT_GData.id <> CF_TT_Source.projectiveGroupId then
        Error("Projective-ID mismatch in threefold row ", CF_TT_Number, ".");
    fi;
    # The Fermat group lies beyond the installed SmallGroups library range;
    # its standard semidirect-product description is known directly.
    if CF_TT_Number = 1 and CF_TT_GData.structureDescription = fail then
        CF_TT_GData.structureDescription := "(C3^4) : S5";
    fi;
    Add(
        CF_TT_Records,
        rec(
            number := CF_TT_Number,
            sourceFourfoldNumber := CF_TT_Source.sourceFourfoldNumber,
            familyDimension := CF_TT_Source.familyDimension,
            threefoldFermatRank := CF_TT_Source.threefoldFermatRank,
            invariantDimension := CF_TT_Source.invariantDimension,
            centralizerDimension := CF_TT_Source.centralizerDimension,
            strictOrder := Size(CF_TT_H),
            projectiveGroup := CF_TT_GData,
            isActionMaximal :=
                CF_TT_Number in CF_TT_ACTION_MAXIMAL_NUMBERS
        )
    );
    CF_TT_Log(Concatenation(String(CF_TT_Number), "/40: source ",
        String(CF_TT_Source.sourceFourfoldNumber), ", projective group ID ",
        String(CF_TT_GData.id), "; elapsed ", String(Runtime()-CF_TT_Started),
        " ms\n"));
od;

CF_TT_Result := rec(
    status := "completed",
    gapVersion := GAPInfo.Version,
    source := "result/gap_threefold_families.g",
    numbering := "increasing source fourfold number",
    familyCount := Length(CF_TT_Records),
    actionMaximalNumbers := CF_TT_ACTION_MAXIMAL_NUMBERS,
    records := CF_TT_Records,
    allOrdersVerified := true,
    allScalarKernelsVerified := true,
    allAvailableProjectiveIdsVerified := true,
    runtimeMilliseconds := Runtime()-CF_TT_Started
);

CF_TT_WriteAssignment(
    CF_TT_OUTPUT_FILE,
    "CubicThreefoldTableData",
    CF_TT_Result
);


CF_TT_Log("THREEFOLD_TABLE_DATA_COMPLETED\n");
CloseStream(CF_TT_LogStream);
QUIT_GAP(0);
