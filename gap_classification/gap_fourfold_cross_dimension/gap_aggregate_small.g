#############################################################################
## Aggregate and audit the complete 142-family small layer.
#############################################################################

Read("gap_cross_dimension_common.g");
Read("input/fourfold_small.g");

if Length(Families) <> 142 then
    Error("Expected 142 small families.");
fi;

allResults := [];
seen := [];
for sourcePosition in [1 .. Length(Families)] do
    rowPath := Concatenation(
        "output/small_rows/row_", String(sourcePosition), ".g"
    );
    logPath := Concatenation(
        "output/small_rows/row_", String(sourcePosition), ".log"
    );
    if not IsExistingFile(rowPath) or not IsExistingFile(logPath) then
        Error("Missing small-row output or log at position ", sourcePosition, ".");
    fi;
    logText := StringFile(logPath);
    if PositionSublist(logText, "SMALL_ROW_DONE") = fail
       or PositionSublist(logText, "undecided=0") = fail
       or PositionSublist(logText, "Error,") <> fail then
        Error("Incomplete or failed small row ", sourcePosition, ".");
    fi;

    Read(rowPath);
    if not IsBound(SmallRowResults) or not IsList(SmallRowResults) then
        Error("Malformed small-row output at position ", sourcePosition, ".");
    fi;
    for result in SmallRowResults do
        if result.sourcePosition <> sourcePosition
           or Families[result.sourcePosition].number <> result.sourceNumber
           or Families[result.targetPosition].number <> result.targetNumber then
            Error("Family number/position mismatch in a small row.");
        fi;
        if result.sourceDimension <= result.targetDimension
           or result.targetOrder mod result.sourceOrder <> 0 then
            Error("An ineligible pair appears in a small row.");
        fi;
        if result.ok = fail or result.status = "undecided" then
            Error("An undecided pair survived small-row aggregation.");
        fi;
        key := [result.sourcePosition, result.targetPosition];
        if key in seen then
            Error("Duplicate small pair ", key, ".");
        fi;
        Add(seen, key);
        Add(allResults, result);
    od;
    Unbind(SmallRowResults);
od;

expected := [];
for sourcePosition in [1 .. Length(Families)] do
    for targetPosition in [1 .. Length(Families)] do
        if sourcePosition <> targetPosition
           and Families[sourcePosition].familyDimension
               > Families[targetPosition].familyDimension
           and Families[targetPosition].reportedOrder
               mod Families[sourcePosition].reportedOrder = 0 then
            Add(expected, [sourcePosition, targetPosition]);
        fi;
    od;
od;
if Length(expected) <> 5131 or Set(seen) <> Set(expected) then
    Error("Small-layer pair coverage is incomplete.");
fi;

positive := Filtered(allResults, result -> result.ok = true);
negative := Filtered(allResults, result -> result.ok = false);
targetGroups := List([1 .. Length(Families)], position -> fail);
for result in positive do
    if result.P = fail or IsZero(DeterminantMat(result.P)) then
        Error("A positive small edge lacks an invertible witness.");
    fi;
    if targetGroups[result.targetPosition] = fail then
        targetGroups[result.targetPosition] := Group(
            Families[result.targetPosition].generators
        );
    fi;
    if not ForAll(
        Families[result.sourcePosition].generators,
        element -> result.P^-1 * element * result.P
                   in targetGroups[result.targetPosition]
    ) then
        Error("A positive small witness failed independent verification.");
    fi;
od;

positiveMatrix := List(
    [1 .. Length(Families)],
    first -> List([1 .. Length(Families)], second -> false)
);
for result in positive do
    positiveMatrix[result.sourcePosition][result.targetPosition] := true;
od;
for first in [1 .. Length(Families)] do
    for second in [1 .. Length(Families)] do
        if positiveMatrix[first][second] then
            for third in [1 .. Length(Families)] do
                if positiveMatrix[second][third]
                   and not positiveMatrix[first][third] then
                    Error("The small-layer positive relation is not transitive.");
                fi;
            od;
        fi;
    od;
od;

CFCD_WriteAssignment("audit/small_all_results.g", "SmallAllResults", allResults);
CFCD_WriteAssignment("audit/small_positive_edges.g", "SmallPositiveEdges", positive);
CFCD_WriteAssignment("audit/known_positive_edges.g", "KnownPositiveEdges", positive);
PrintTo(
    "audit/small_summary.txt",
    "small_families=142\n",
    "eligible_pairs=", Length(expected), "\n",
    "completed_pairs=", Length(allResults), "\n",
    "positive_edges=", Length(positive), "\n",
    "negative_edges=", Length(negative), "\n",
    "undecided_edges=0\n",
    "verified_positive_witnesses=", Length(positive), "\n",
    "transitive_closure_audit=passed\n"
);
Print("SMALL_AGGREGATION_DONE\n", StringFile("audit/small_summary.txt"));
QUIT_GAP(0);

