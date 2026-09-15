## Independent small central-extension tests; no family catalogue is read.
if IsExistingFile("gap_liftability.g") then
    CF_LI_TEST_DIRECTORY := "";
elif IsExistingFile("gap_classification/gap_liftability/gap_liftability.g") then
    CF_LI_TEST_DIRECTORY := "gap_classification/gap_liftability/";
elif IsExistingFile("gap_liftability/gap_liftability.g") then
    CF_LI_TEST_DIRECTORY := "gap_liftability/";
else
    Error("Run from the repository root, gap_classification, or gap_liftability.");
fi;
Read(Concatenation(CF_LI_TEST_DIRECTORY, "gap_liftability.g"));

CF_LI_RunTests := function()
    local models, cases, position, item, globalTest, localTest, splitC9,
          nonsplitC9, output;
    models := CF_LI_ObstructionModels();
    splitC9 := Group([
        CF_LI_DiagonalRootMatrix(9, [1,0,0,0,0,0]),
        E(3) * IdentityMat(6)
    ]);
    nonsplitC9 := Group([
        CF_LI_DiagonalRootMatrix(27, [1,4,7,1,4,7])
    ]);
    cases := [
        rec(group := models.C3NonFLiftable, ordinary := true, invariant := false),
        rec(group := models.C3xC3NonLiftableExponent3, ordinary := false, invariant := false),
        rec(group := models.C3xC3NonLiftableExponent9, ordinary := false, invariant := false),
        rec(group := models.C3xC3LiftableNonFLiftable, ordinary := true, invariant := false),
        rec(group := splitC9, ordinary := true, invariant := true),
        rec(group := nonsplitC9, ordinary := true, invariant := false)
    ];
    output := Concatenation(CF_LI_TEST_DIRECTORY, "gap_liftability_test.log");
    PrintTo(output, "Small strict-extension tests\nGAP version: ",
        GAPInfo.Version, "\n");
    for position in [1..Length(cases)] do
        item := cases[position];
        globalTest := CF_LI_TestStrictExtension(item.group);
        localTest := CF_LI_TestFullAutomorphismGroup(item.group);
        if globalTest.isLiftable <> item.ordinary
            or globalTest.isFLiftable <> item.invariant
            or localTest.isLiftable <> item.ordinary
            or localTest.isFLiftable <> item.invariant then
            Error("Small extension test failed at case ", position, ".");
        fi;
        if localTest.compatibleWithSmoothC9Lemma <> (position <> 6) then
            Error("The cyclic order-27 smoothness exclusion is inconsistent.");
        fi;
        AppendTo(output, position, ". H-ID ", IdGroup(item.group),
            "; |G| = ", globalTest.projectiveGroupOrder,
            "; liftable = ", globalTest.isLiftable,
            "; F-liftable = ", globalTest.isFLiftable, "\n");
    od;
    if IdGroup(splitC9) <> IdGroup(models.C3xC3LiftableNonFLiftable) then
        Error("The distinguished-kernel comparison models are not isomorphic.");
    fi;
    AppendTo(output, "LIFTABILITY_TESTS_COMPLETED\n");
    Print("LIFTABILITY_TESTS_COMPLETED; cases = ", Length(cases), "\n");
end;
CF_LI_RunTests();
