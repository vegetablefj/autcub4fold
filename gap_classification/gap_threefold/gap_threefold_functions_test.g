#############################################################################
## Small regression tests for gap_threefold_functions.g.
## Run from the repository root, gap_classification, or this directory.
#############################################################################

CF_TF_TestPaths := function()
    if IsExistingFile("gap_threefold_functions_test.g") then
        return rec(
            functionsFile := "../gap_functions.g",
            catalogueFile := Concatenation(
                "../gap_fourfold_cross_dimension/input/",
                "fourfold_search_catalogue.g"
            ),
            extractionFile := "gap_threefold_functions.g"
        );
    fi;
    if IsExistingFile(
        "gap_classification/gap_threefold/gap_threefold_functions_test.g"
    ) then
        return rec(
            functionsFile := "gap_classification/gap_functions.g",
            catalogueFile := Concatenation(
                "gap_classification/gap_fourfold_cross_dimension/input/",
                "fourfold_search_catalogue.g"
            ),
            extractionFile :=
                "gap_classification/gap_threefold/gap_threefold_functions.g"
        );
    fi;
    if IsExistingFile("gap_threefold/gap_threefold_functions_test.g") then
        return rec(
            functionsFile := "gap_functions.g",
            catalogueFile := Concatenation(
                "gap_fourfold_cross_dimension/input/",
                "fourfold_search_catalogue.g"
            ),
            extractionFile := "gap_threefold/gap_threefold_functions.g"
        );
    fi;
    Error(
        "Run from the repository root, gap_classification, or ",
        "gap_classification/gap_threefold."
    );
end;

CF_TF_TestPathRecord := CF_TF_TestPaths();
Read(CF_TF_TestPathRecord.functionsFile);
Read(CF_TF_TestPathRecord.catalogueFile);
Read(CF_TF_TestPathRecord.extractionFile);


## Family 135 is obtained by adjoining one cube to a generic cubic
## threefold.  Its extracted strict group is the scalar group of order 3.
CF_TF_TestGeneric := CF_TF_ExtractCatalogueFamily(
    CanonicalFamilyMatrixGroups[135],
    rec(computeInvariantBasis := true)
);
if CF_TF_TestGeneric.status <> "extracted"
   or CF_TF_TestGeneric.fourfoldFermatRank <> 1
   or CF_TF_TestGeneric.threefoldFermatRank <> 0
   or CF_TF_TestGeneric.strictOrder <> 3
   or CF_TF_TestGeneric.projectiveOrder <> 1
   or CF_TF_TestGeneric.cubicInvariantDimension <> 35
   or CF_TF_TestGeneric.familyDimension <> 10 then
    Error("The generic threefold extraction test failed.");
fi;


## Family 132 has only the global scalar group, hence no Fermat summand.
CF_TF_TestNoSplit := CF_TF_ExtractCatalogueFamily(
    CanonicalFamilyMatrixGroups[132]
);
if CF_TF_TestNoSplit.status <> "no_Fermat_summand"
   or CF_TF_TestNoSplit.producesThreefold <> false then
    Error("The no-Fermat-summand test failed.");
fi;


## The Fermat cubic fourfold has six one-dimensional summands.  Restricting
## the centralizer of one Fermat element must give the Fermat threefold.
CF_TF_TestFermat := CF_TF_ExtractCatalogueFamily(
    CanonicalFamilyMatrixGroups[1],
    rec(computeInvariantBasis := true)
);
if CF_TF_TestFermat.status <> "extracted"
   or CF_TF_TestFermat.fourfoldFermatRank <> 6
   or CF_TF_TestFermat.threefoldFermatRank <> 5
   or CF_TF_TestFermat.strictOrder <> 29160
   or CF_TF_TestFermat.projectiveOrder <> 9720
   or CF_TF_TestFermat.cubicInvariantDimension <> 1
   or CF_TF_TestFermat.familyDimension <> 0 then
    Error("The Fermat threefold extraction test failed.");
fi;


Print("gap_threefold_functions_test.g: all tests passed.\n");
