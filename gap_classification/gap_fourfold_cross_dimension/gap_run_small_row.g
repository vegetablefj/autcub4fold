#############################################################################
## One independent source row in the 142-family small layer.
## Usage: gap -r -q -b gap_run_small_row.g <source-position>
#############################################################################

Read("gap_cross_dimension_common.g");
Read("input/fourfold_small.g");

sourcePosition := EvalString(
    GAPInfo.SystemCommandLine[Length(GAPInfo.SystemCommandLine)]
);
if Length(Families) <> 142
   or sourcePosition < 1
   or sourcePosition > Length(Families) then
    Error("Invalid small-row source position.");
fi;

source := Families[sourcePosition];
results := [];
tested := 0;
embedded := 0;

eligibleTargetPositions := Filtered(
    [1 .. Length(Families)],
    targetPosition -> sourcePosition <> targetPosition
                      and source.familyDimension
                          > Families[targetPosition].familyDimension
                      and Families[targetPosition].reportedOrder
                          mod source.reportedOrder = 0
);

sourceInfo := fail;

for targetPosition in eligibleTargetPositions do
    target := Families[targetPosition];
    tested := tested + 1;

    ## In the standardized catalogue, some subgroup generators already
    ## occur verbatim among the target generators.  This is an immediate
    ## positive certificate with conjugating matrix equal to the identity.
    if ForAll(
        source.generators,
        generator -> generator in target.generators
    ) then
        Add(results, rec(
            sourcePosition := sourcePosition,
            targetPosition := targetPosition,
            sourceNumber := source.number,
            targetNumber := target.number,
            sourceDimension := source.familyDimension,
            targetDimension := target.familyDimension,
            sourceOrder := source.reportedOrder,
            targetOrder := target.reportedOrder,
            ok := true,
            status := "embedded",
            classification := "direct",
            reason := "literal_generator_sublist",
            method := "literal_generator_sublist",
            direct := true,
            viaNumber := fail,
            P := IdentityMat(6)
        ));
        embedded := embedded + 1;
        continue;
    fi;

    ## When both documented SmallGroups IDs are available, exhaustive
    ## abstract subgroup enumeration is an exact negative certificate.  A
    ## positive abstract result is only a necessary condition and still goes
    ## through the full matrix-conjugacy test below.
    abstractResult := AbstractEmbedsById(
        source.linearGroupId,
        target.linearGroupId
    );
    if abstractResult = false then
        Add(results, rec(
            sourcePosition := sourcePosition,
            targetPosition := targetPosition,
            sourceNumber := source.number,
            targetNumber := target.number,
            sourceDimension := source.familyDimension,
            targetDimension := target.familyDimension,
            sourceOrder := source.reportedOrder,
            targetOrder := target.reportedOrder,
            ok := false,
            status := "no_embedding",
            classification := "direct",
            reason := "exhaustive_abstract_subgroup_filter",
            method := "SmallGroups",
            direct := true,
            viaNumber := fail,
            P := fail
        ));
        continue;
    fi;

    if sourceInfo = fail then
        sourceInfo := CFCD_PreprocessFamily(source);
    fi;
    targetInfo := CFCD_PreprocessFamily(target);
    result := SearchEmbeddingStrict(
        sourceInfo,
        targetInfo,
        rec(stop_first := true, allow_hard_iso := true)
    );
    if result.ok = fail or result.status = "undecided" then
        Error(
            "Undecided small pair ", source.number, " -> ", target.number,
            ": ", result.reason, "."
        );
    fi;
    result := CFCD_EnsureExplicitWitness(sourceInfo, targetInfo, result);
    if result.ok = true then
        embedded := embedded + 1;
        witness := result.P;
    else
        witness := fail;
    fi;

    Add(results, rec(
        sourcePosition := sourcePosition,
        targetPosition := targetPosition,
        sourceNumber := source.number,
        targetNumber := target.number,
        sourceDimension := source.familyDimension,
        targetDimension := target.familyDimension,
        sourceOrder := sourceInfo.order,
        targetOrder := targetInfo.order,
        ok := result.ok,
        status := result.status,
        classification := "direct",
        reason := result.reason,
        method := result.method,
        direct := true,
        viaNumber := fail,
        P := witness
    ));
od;

CFCD_WriteAssignment(
    Concatenation("output/small_rows/row_", String(sourcePosition), ".g"),
    "SmallRowResults",
    results
);
Print(
    "SMALL_ROW_DONE position=", sourcePosition,
    " family=", source.number,
    " tested=", tested,
    " embedded=", embedded,
    " undecided=0\n"
);
QUIT_GAP(0);
