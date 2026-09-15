#############################################################################
## Liftability audit for the final 156 cubic-fourfold families.
##
## The matrix input is the complete ordered family catalogue
##
##     gap_manuscript_validation/gap_family_catalogue.g.
##
## The 48 connected symplectic families are read from the reference table.
## For these families, F-liftability is equivalent to liftability.  If that
## reference result is negative, every special family in the same connected
## symplectic family is negative as well.  The remaining special families
## are tested by the small-3-subgroup criterion in gap_liftability.g.  The
## completed batch writes the GAP-readable result, progress log, and Markdown
## table documented in README.md.
#############################################################################


CF_LIB_Paths := function()
    if IsExistingFile("gap_liftability_all.g") then
        return rec(
            selfDirectory := "",
            catalogueDirectory := "../gap_manuscript_validation/"
        );
    fi;
    if IsExistingFile(
        "gap_classification/gap_liftability/gap_liftability_all.g"
    ) then
        return rec(
            selfDirectory := "gap_classification/gap_liftability/",
            catalogueDirectory := "gap_classification/gap_manuscript_validation/"
        );
    fi;
    if IsExistingFile("gap_liftability/gap_liftability_all.g") then
        return rec(
            selfDirectory := "gap_liftability/",
            catalogueDirectory := "gap_manuscript_validation/"
        );
    fi;
    Error(
        "Run from the repository root, gap_classification, or ",
        "gap_classification/gap_liftability."
    );
end;


CF_LIB_PathRecord := CF_LIB_Paths();

if not IsBound(CF_LI_TestFullAutomorphismGroup) then
    Read(Concatenation(
        CF_LIB_PathRecord.selfDirectory,
        "gap_liftability.g"
    ));
fi;
if not IsBound(CubicFourfoldFamilyCatalogue) then
    Read(Concatenation(
        CF_LIB_PathRecord.catalogueDirectory,
        "gap_family_catalogue.g"
    ));
fi;
Read(Concatenation(CF_LIB_PathRecord.catalogueDirectory,
    "gap_family_correspondence.out"));


if not IsBound(CF_LIB_PRINT_PROGRESS) then
    CF_LIB_PRINT_PROGRESS := true;
fi;
if not IsBound(CF_LIB_LOG_FILE) then
    CF_LIB_LOG_FILE := Concatenation(
        CF_LIB_PathRecord.selfDirectory,
        "gap_liftability.log"
    );
fi;
if not IsBound(CF_LIB_OUTPUT_FILE) then
    CF_LIB_OUTPUT_FILE := Concatenation(
        CF_LIB_PathRecord.selfDirectory,
        "gap_liftability.out"
    );
fi;
if not IsBound(CF_LIB_MARKDOWN_FILE) then
    CF_LIB_MARKDOWN_FILE := Concatenation(
        CF_LIB_PathRecord.selfDirectory,
        "gap_liftability_result.md"
    );
fi;


CF_LIB_Log := function(arg)
    local item;
    for item in arg do
        if CF_LIB_PRINT_PROGRESS then
            Print(item);
        fi;
        AppendTo(CF_LIB_LOG_FILE, item);
    od;
end;


#############################################################################
## Reference values for the 48 connected symplectic families.
##
## The order is the 48 connected symplectic components in Koike order.
## These reference values are not used as substitutes for the independent
## distinguished-kernel test performed on every final matrix group.
#############################################################################

CF_LIB_StandardFamilyNumbers := [
    1,2,3,4,5,6,7,8,9,10,11,12,15,16,17,19,20,21,25,27,29,31,33,34,
    35,37,39,42,43,45,47,48,52,55,58,63,65,68,70,73,77,83,88,97,
    106,115,119,132
];

CF_LIB_SymplecticReference := [
    rec(name := "3^4:A_6",           liftable := false),
    rec(name := "A_7",               liftable := false),
    rec(name := "A_7",               liftable := true),
    rec(name := "3^{1+4}:2.2^2",     liftable := false),
    rec(name := "M_10",              liftable := false),
    rec(name := "M_10",              liftable := false),
    rec(name := "L_2(11)",           liftable := true),
    rec(name := "A_3,5",             liftable := true),
    rec(name := "3^{1+4}:2.2",       liftable := false),
    rec(name := "A_6",               liftable := false),
    rec(name := "A_6",               liftable := true),
    rec(name := "PSL(2,7)",          liftable := true),
    rec(name := "S_5",               liftable := true),
    rec(name := "S_5",               liftable := true),
    rec(name := "M_9",               liftable := false),
    rec(name := "N_72",              liftable := true),
    rec(name := "T_48",              liftable := true),
    rec(name := "3^{1+4}:2",         liftable := false),
    rec(name := "A_4,3",             liftable := false),
    rec(name := "A_4,3",             liftable := true),
    rec(name := "A_5",               liftable := true),
    rec(name := "A_5",               liftable := true),
    rec(name := "3^2.4",             liftable := false),
    rec(name := "3^2.4",             liftable := true),
    rec(name := "S_3,3",             liftable := true),
    rec(name := "S_3,3",             liftable := true),
    rec(name := "F_21",              liftable := true),
    rec(name := "Hol_5",             liftable := true),
    rec(name := "QD_16",             liftable := true),
    rec(name := "S_4",               liftable := true),
    rec(name := "S_4",               liftable := true),
    rec(name := "Q_8",               liftable := true),
    rec(name := "A_3,3",             liftable := false),
    rec(name := "A_3,3",             liftable := true),
    rec(name := "D_12",              liftable := true),
    rec(name := "D_12",              liftable := true),
    rec(name := "A_4",               liftable := true),
    rec(name := "A_4",               liftable := true),
    rec(name := "D_10",              liftable := true),
    rec(name := "D_8",               liftable := true),
    rec(name := "C4",                liftable := true),
    rec(name := "S3",                liftable := true),
    rec(name := "S3",                liftable := true),
    rec(name := "C2^2",              liftable := true),
    rec(name := "C3",                liftable := true),
    rec(name := "C3",                liftable := true),
    rec(name := "C2",                liftable := true),
    rec(name := "1",                 liftable := true)
];


CF_LIB_ValidateInput := function()
    local position, standard, reference, familyNumbers;

    if Length(CubicFourfoldFamilyCatalogue) <> 156 then
        Error("The final family catalogue must have length 156.");
    fi;
    if Length(CF_LIB_SymplecticReference) <> 48 then
        Error("The symplectic reference list must have length 48.");
    fi;

    for position in [1 .. 48] do
        standard := CubicFourfoldFamilyCatalogue[
            CF_LIB_StandardFamilyNumbers[position]];
        reference := CF_LIB_SymplecticReference[position];
        if standard.standardPosition <> position then
            Error("Unexpected standard-family position ", position, ".");
        fi;
        if standard.symplecticPart <> reference.name then
            Error(
                "Reference-name mismatch at standard position ",
                position,
                "."
            );
        fi;
        if standard.fullIndex <> standard.genericIndex
            or standard.familyDimension <> 20 - standard.rankS then
            Error("The reference row is not the generic symplectic family.");
        fi;
    od;

    familyNumbers := List(CubicFourfoldFamilyCatalogue, item -> item.number);
    if familyNumbers <> [1 .. 156] then
        Error("The final catalogue is not numbered consecutively 1..156.");
    fi;
    if not ForAll(
        CubicFourfoldFamilyCatalogue,
        family -> family.fullGroupVerified = true
            and family.determinantKernelVerified = true
    ) then
        Error("The canonical catalogue contains an unverified matrix group.");
    fi;
    if FamilyCoordinateAudit.status <> "completed"
        or FamilyCoordinateAudit.verifiedCount <> 156
        or Length(FamilyCoordinateAudit.rows) <> 156
        or not ForAll(FamilyCoordinateAudit.rows, row -> row.passed) then
        Error("The saved family correspondence is incomplete.");
    fi;
    for position in [1..156] do
        if FamilyCoordinateAudit.rows[position].number <> position
            or FamilyCoordinateAudit.rows[position].sourceKey <>
                CubicFourfoldFamilyCatalogue[position].sourceKey then
            Error("The saved correspondence and catalogue are not aligned.");
        fi;
    od;
end;


CF_LIB_IsStandardFamily := function(family, standard)
    return family.number = standard.number;
end;


CF_LIB_StrictGroup := function(family, standard)
    return Group(family.matrixGenerators);
end;


CF_LIB_LightLocalTest := function(test)
    return rec(
        label := test.label,
        projectiveOrder := test.projectiveOrder,
        strictPreimageOrder := test.strictPreimageOrder,
        strictPreimageId := test.strictPreimageId,
        strictPreimageStructure := test.strictPreimageStructure,
        strictPreimageExponent := test.strictPreimageExponent,
        scalarDerivedIntersectionOrder :=
            test.scalarDerivedIntersectionOrder,
        isLiftable := test.isLiftable,
        isFLiftable := test.isFLiftable,
        obstruction := test.obstruction,
        reason := test.reason
    );
end;


CF_LIB_ReferenceResult := function(family, standard, reference)
    return rec(
        number := family.number,
        standardPosition := family.standardPosition,
        standardFamilyNumber := family.standardFamilyNumber,
        symplecticPart := family.symplecticPart,
        rankS := family.rankS,
        familyDimension := family.familyDimension,
        genericIndex := family.genericIndex,
        fullIndex := family.fullIndex,
        projectiveGroupId := family.projectiveGroupId,
        linearGroupId := family.linearGroupId,
        isStandardFamily := true,
        symplecticReferenceLiftable := reference.liftable,
        method := "symplectic_reference",
        isLiftable := reference.liftable,
        isFLiftable := reference.liftable,
        numberOfC3Classes := fail,
        numberOfC9Classes := fail,
        numberOfC3xC3Classes := fail,
        localTests := [],
        criterion :=
            "48 connected symplectic components; verified by the scalar-kernel test"
    );
end;


CF_LIB_InheritedNegativeResult := function(family, standard, reference)
    return rec(
        number := family.number,
        standardPosition := family.standardPosition,
        standardFamilyNumber := family.standardFamilyNumber,
        symplecticPart := family.symplecticPart,
        rankS := family.rankS,
        familyDimension := family.familyDimension,
        genericIndex := family.genericIndex,
        fullIndex := family.fullIndex,
        projectiveGroupId := family.projectiveGroupId,
        linearGroupId := family.linearGroupId,
        isStandardFamily := false,
        symplecticReferenceLiftable := reference.liftable,
        method := "nonliftable_symplectic_subgroup",
        isLiftable := false,
        isFLiftable := false,
        numberOfC3Classes := fail,
        numberOfC9Classes := fail,
        numberOfC3xC3Classes := fail,
        localTests := [],
        criterion :=
            "a non-liftable symplectic subgroup is already an obstruction"
    );
end;


CF_LIB_ComputedResult := function(family, standard, reference, strictGroup)
    local test;

    if Size(strictGroup) <> family.linearGroupId[1] then
        Error("Strict group order mismatch for family ", family.number, ".");
    fi;

    test := CF_LI_TestFullAutomorphismGroup(strictGroup);
    if test.projectiveGroupOrder <> family.projectiveGroupId[1] then
        Error(
            "Projective group order mismatch for family ",
            family.number,
            "."
        );
    fi;
    if not test.compatibleWithSmoothC9Lemma then
        Error(
            "Family ", family.number,
            " conflicts with the smooth-C9 lemma."
        );
    fi;

    return rec(
        number := family.number,
        standardPosition := family.standardPosition,
        standardFamilyNumber := family.standardFamilyNumber,
        symplecticPart := family.symplecticPart,
        rankS := family.rankS,
        familyDimension := family.familyDimension,
        genericIndex := family.genericIndex,
        fullIndex := family.fullIndex,
        projectiveGroupId := family.projectiveGroupId,
        linearGroupId := family.linearGroupId,
        isStandardFamily := false,
        symplecticReferenceLiftable := reference.liftable,
        method := "small_3_subgroup_test",
        isLiftable := test.isLiftable,
        isFLiftable := test.isFLiftable,
        numberOfC3Classes := test.numberOfC3Classes,
        numberOfC9Classes := test.numberOfC9Classes,
        numberOfC3xC3Classes := test.numberOfC3xC3Classes,
        localTests := List(test.localTests, CF_LIB_LightLocalTest),
        criterion := test.criterion
    );
end;


CF_LIB_MethodLabel := function(method)
    if method = "symplectic_reference" then
        return "reference";
    elif method = "nonliftable_symplectic_subgroup" then
        return "inherited obstruction";
    elif method = "small_3_subgroup_test" then
        return "small 3-subgroups";
    fi;
    Error("Unknown liftability method.");
end;


CF_LIB_YesNo := function(value)
    if value then
        return "yes";
    fi;
    return "no";
end;


CF_LIB_IdString := function(identifier)
    if identifier[2] = 0 then
        return Concatenation("[", String(identifier[1]), ", --]");
    fi;
    return Concatenation(
        "[",
        String(identifier[1]),
        ", ",
        String(identifier[2]),
        "]"
    );
end;


CF_LIB_ObstructionSummary := function(result)
    local obstructions;

    obstructions := Set(List(
        Filtered(
            result.localTests,
            test -> test.obstruction <> "none"
        ),
        test -> test.obstruction
    ));
    if Length(obstructions) = 0 then
        return "none";
    fi;
    return JoinStringsWithSeparator(obstructions, "; ");
end;


CF_LIB_WriteQuoted := function(file, value)
    AppendTo(file, "\"", value, "\"");
end;


CF_LIB_WriteLocalTests := function(file, tests)
    local position, test;

    AppendTo(file, "[");
    for position in [1 .. Length(tests)] do
        test := tests[position];
        if position > 1 then
            AppendTo(file, ", ");
        fi;
        AppendTo(file, "rec(label := ");
        CF_LIB_WriteQuoted(file, test.label);
        AppendTo(
            file,
            ", projectiveOrder := ", test.projectiveOrder,
            ", strictPreimageOrder := ", test.strictPreimageOrder,
            ", strictPreimageId := ", test.strictPreimageId,
            ", strictPreimageStructure := "
        );
        CF_LIB_WriteQuoted(file, test.strictPreimageStructure);
        AppendTo(
            file,
            ", strictPreimageExponent := ", test.strictPreimageExponent,
            ", scalarDerivedIntersectionOrder := ",
            test.scalarDerivedIntersectionOrder,
            ", isLiftable := ", test.isLiftable,
            ", isFLiftable := ", test.isFLiftable,
            ", obstruction := "
        );
        CF_LIB_WriteQuoted(file, test.obstruction);
        AppendTo(file, ", reason := ");
        CF_LIB_WriteQuoted(file, test.reason);
        AppendTo(file, ")");
    od;
    AppendTo(file, "]");
end;


CF_LIB_WriteOutput := function(results, runtime)
    local stream, position, result;

    stream := OutputTextFile(CF_LIB_OUTPUT_FILE, false);
    if stream = fail then
        Error("Could not open the GAP output file.");
    fi;
    SetPrintFormattingStatus(stream, false);
    AppendTo(
        stream,
        "#############################################################################\n",
        "## GAP-readable liftability audit for the final 156 families.\n",
        "#############################################################################\n\n",
        "CubicFourfoldLiftabilityAudit := rec(\n",
        "status := \"completed\",\n",
        "gapVersion := \"", GAPInfo.Version, "\",\n",
        "catalogue := \"gap_classification/gap_manuscript_validation/gap_family_catalogue.g\",\n",
        "catalogueGenerators := ", List(CubicFourfoldFamilyCatalogue,
            family -> family.matrixGenerators), ",\n",
        "allScalarKernelsVerified := true,\n",
        "allExtensionTestsAgree := true,\n",
        "allCatalogueLabelsAgree := true,\n",
        "allInheritedSubgroupsVerified := true,\n",
        "familyCount := ", Length(results), ",\n",
        "runtimeMilliseconds := ", runtime, ",\n",
        "liftableCount := ", Number(results, item -> item.isLiftable), ",\n",
        "fLiftableCount := ", Number(results, item -> item.isFLiftable), ",\n",
        "referenceCount := ", Number(
            results,
            item -> item.method = "symplectic_reference"
        ), ",\n",
        "inheritedObstructionCount := ", Number(
            results,
            item -> item.method = "nonliftable_symplectic_subgroup"
        ), ",\n",
        "computedCount := ", Number(
            results,
            item -> item.method = "small_3_subgroup_test"
        ), ",\n",
        "results := [\n"
    );

    for position in [1 .. Length(results)] do
        result := results[position];
        AppendTo(
            stream,
            "rec(number := ", result.number,
            ", standardPosition := ", result.standardPosition,
            ", standardFamilyNumber := ", result.standardFamilyNumber,
            ", symplecticPart := "
        );
        CF_LIB_WriteQuoted(stream, result.symplecticPart);
        AppendTo(
            stream,
            ", rankS := ", result.rankS,
            ", familyDimension := ", result.familyDimension,
            ", genericIndex := ", result.genericIndex,
            ", fullIndex := ", result.fullIndex,
            ", projectiveGroupId := ", result.projectiveGroupId,
            ", linearGroupId := ", result.linearGroupId,
            ", isStandardFamily := ", result.isStandardFamily,
            ", symplecticReferenceLiftable := ",
            result.symplecticReferenceLiftable,
            ", method := "
        );
        CF_LIB_WriteQuoted(stream, result.method);
        AppendTo(
            stream,
            ", isLiftable := ", result.isLiftable,
            ", isFLiftable := ", result.isFLiftable,
            ", numberOfC3Classes := ", result.numberOfC3Classes,
            ", numberOfC9Classes := ", result.numberOfC9Classes,
            ", numberOfC3xC3Classes := ", result.numberOfC3xC3Classes,
            ", localTests := "
        );
        CF_LIB_WriteLocalTests(stream, result.localTests);
        AppendTo(stream, ", sourceKey := ");
        CF_LIB_WriteQuoted(stream, result.sourceKey);
        AppendTo(stream, ", extensionTest := ", result.extensionTest,
            ", inheritedSubgroupVerified := ", result.inheritedSubgroupVerified,
            ", catalogueLabelsVerified := ", result.catalogueLabelsVerified);
        AppendTo(stream, ", criterion := ");
        CF_LIB_WriteQuoted(stream, result.criterion);
        AppendTo(stream, ")");
        if position < Length(results) then
            AppendTo(stream, ",");
        fi;
        AppendTo(stream, "\n");
    od;
    AppendTo(stream, "]\n);\n");
    CloseStream(stream);
end;


CF_LIB_WriteMarkdown := function(results, runtime)
    local stream, result, nonLiftable, liftableNonF,
          computedExceptions;

    nonLiftable := Filtered(results, item -> not item.isLiftable);
    liftableNonF := Filtered(
        results,
        item -> item.isLiftable and not item.isFLiftable
    );
    computedExceptions := Filtered(
        results,
        item -> item.method = "small_3_subgroup_test"
            and not item.isFLiftable
    );

    stream := OutputTextFile(CF_LIB_MARKDOWN_FILE, false);
    if stream = fail then
        Error("Could not open the Markdown output file.");
    fi;
    SetPrintFormattingStatus(stream, false);
    AppendTo(
        stream,
        "# Liftability of the 156 cubic-fourfold families\n\n",
        "The input is the [complete family catalogue](../gap_manuscript_validation/gap_family_catalogue.g), numbered 1--156. ",
        "The 48 reference families and inherited obstructions are retained; ",
        "the other 101 rows use all conjugacy classes of projective subgroups ",
        "`C3`, `C9`, and `C3 x C3`. In addition, every row is independently ",
        "tested using its distinguished scalar kernel in `H_ab` and `H_ab/3H_ab`. ",
        "All 156 ordinary and F-liftability decisions agree, and every ",
        "inherited symplectic subgroup is checked as an actual matrix subgroup. ",
        "The saved catalogue labels are compared only after the decisions are computed.\n\n",
        "Definitions and hypotheses are explained in [the script guide](gap_liftability_script.md). ",
        "The [GAP result](gap_liftability.out) binds each number and source key to its exact input matrices; ",
        "the [log](gap_liftability.log) ends with `LIFTABILITY_COMPLETED`. ",
        "The input's smoothness and saturation are mathematical prerequisites, not conclusions of this test.\n\n",
        "The run used GAP ", GAPInfo.Version, " and took ", runtime,
        " ms. It processed ", Length(results), " families: ",
        Number(results, item -> item.isLiftable), " are liftable and ",
        Number(results, item -> item.isFLiftable), " are F-liftable. ",
        "The three decision routes account for ",
        Number(results, item -> item.method = "symplectic_reference"),
        " reference rows, ",
        Number(
            results,
            item -> item.method = "nonliftable_symplectic_subgroup"
        ),
        " inherited obstructions, and ",
        Number(results, item -> item.method = "small_3_subgroup_test"),
        " computed rows.\n\n",
        "## Complete table\n\n",
        "| No. | Symplectic family | PGL ID | Index | Dimension | ",
        "Liftable | F-liftable | Decision |\n",
        "|---:|---|---:|---:|---:|:---:|:---:|---|\n"
    );

    for result in results do
        AppendTo(
            stream,
            "| ", result.number,
            " | `", result.symplecticPart,
            "` | `", CF_LIB_IdString(result.projectiveGroupId),
            "` | ", result.fullIndex,
            " | ", result.familyDimension,
            " | ", CF_LIB_YesNo(result.isLiftable),
            " | ", CF_LIB_YesNo(result.isFLiftable),
            " | ", CF_LIB_MethodLabel(result.method),
            " |\n"
        );
    od;

    AppendTo(
        stream,
        "\n## Negative and intermediate cases\n\n",
        "The non-liftable family numbers are `",
        JoinStringsWithSeparator(
            List(nonLiftable, item -> String(item.number)),
            ", "
        ),
        "`.\n\n"
    );
    if Length(liftableNonF) = 0 then
        AppendTo(
            stream,
            "No family is liftable without being F-liftable.\n"
        );
    else
        AppendTo(
            stream,
            "The liftable but non-F-liftable family numbers are `",
            JoinStringsWithSeparator(
                List(liftableNonF, item -> String(item.number)),
                ", "
            ),
            "`.\n"
        );
    fi;

    AppendTo(
        stream,
        "\n### Computed obstructions\n\n",
        "These are the rows whose negative conclusion is obtained from ",
        "an explicit strict inverse image, rather than from the reference ",
        "table or the inheritance shortcut.\n\n",
        "| No. | PGL ID | Liftable | F-liftable | Detected obstruction |\n",
        "|---:|---:|:---:|:---:|---|\n"
    );
    for result in computedExceptions do
        AppendTo(
            stream,
            "| ", result.number,
            " | `", CF_LIB_IdString(result.projectiveGroupId),
            "` | ", CF_LIB_YesNo(result.isLiftable),
            " | ", CF_LIB_YesNo(result.isFLiftable),
            " | `", CF_LIB_ObstructionSummary(result),
            "` |\n"
        );
    od;
    CloseStream(stream);
end;


CF_LIB_Run := function()
    local startTime, results, family, standard, reference, result,
          elapsed, runtime, strictGroup, extensionTest, symplecticGroup,
          inheritedSubgroupVerified, inputFamily;

    CF_LIB_ValidateInput();
    PrintTo(
        CF_LIB_LOG_FILE,
        "Liftability audit for the final 156 families\n",
        "GAP version: ", GAPInfo.Version, "\n",
        "Catalogue: gap_classification/gap_manuscript_validation/gap_family_catalogue.g\n",
        "Started runtime counter: ", Runtime(), " ms\n\n"
    );

    startTime := Runtime();
    results := [];
    for inputFamily in CubicFourfoldFamilyCatalogue do
        family := ShallowCopy(inputFamily);
        standard := CubicFourfoldFamilyCatalogue[
            CF_LIB_StandardFamilyNumbers[family.standardPosition]];
        family.standardFamilyNumber := standard.number;
        reference := CF_LIB_SymplecticReference[family.standardPosition];
        strictGroup := CF_LIB_StrictGroup(family, standard);
        extensionTest := CF_LI_TestStrictExtension(strictGroup);
        if extensionTest.strictGroupOrder <> family.linearGroupId[1]
            or extensionTest.projectiveGroupOrder <> family.projectiveGroupId[1] then
            Error("Catalogue group order mismatch at family ", family.number, ".");
        fi;
        inheritedSubgroupVerified := true;

        if CF_LIB_IsStandardFamily(family, standard) then
            result := CF_LIB_ReferenceResult(family, standard, reference);
        elif not reference.liftable then
            symplecticGroup := Group(standard.symplecticGenerators);
            inheritedSubgroupVerified := IsSubgroup(strictGroup, symplecticGroup)
                and not CF_LI_TestStrictExtension(symplecticGroup).isLiftable;
            if not inheritedSubgroupVerified then
                Error("The inherited non-liftable subgroup is not verified.");
            fi;
            result := CF_LIB_InheritedNegativeResult(
                family,
                standard,
                reference
            );
        else
            result := CF_LIB_ComputedResult(family, standard, reference, strictGroup);
        fi;
        if result.isLiftable <> extensionTest.isLiftable
            or result.isFLiftable <> extensionTest.isFLiftable then
            Error("Local/reference and global extension tests disagree at family ",
                family.number, ".");
        fi;
        if result.isLiftable <> inputFamily.isLiftable
            or result.isFLiftable <> inputFamily.isFLiftable then
            Error("Computed liftability differs from the catalogue labels.");
        fi;
        result.sourceKey := family.sourceKey;
        result.extensionTest := extensionTest;
        result.inheritedSubgroupVerified := inheritedSubgroupVerified;
        result.catalogueLabelsVerified := true;
        Add(results, result);

        elapsed := Runtime() - startTime;
        CF_LIB_Log(
            family.number, "/156: ", family.symplecticPart,
            ", PGL ", family.projectiveGroupId,
            ", method = ", CF_LIB_MethodLabel(result.method),
            ", liftable = ", result.isLiftable,
            ", F-liftable = ", result.isFLiftable,
            ", elapsed = ", elapsed, " ms\n"
        );
    od;

    runtime := Runtime() - startTime;
    CF_LIB_WriteOutput(results, runtime);
    CF_LIB_WriteMarkdown(results, runtime);
    CF_LIB_Log(
        "\nCompleted.\n",
        "Families = ", Length(results), "\n",
        "Liftable = ", Number(results, item -> item.isLiftable), "\n",
        "F-liftable = ", Number(results, item -> item.isFLiftable), "\n",
        "Runtime = ", runtime, " ms\n",
        "Output = ", CF_LIB_OUTPUT_FILE, "\n",
        "Markdown = ", CF_LIB_MARKDOWN_FILE, "\n"
    );
    CF_LIB_Log("LIFTABILITY_COMPLETED\n");
    return results;
end;


CubicFourfoldLiftabilityResults := CF_LIB_Run();
