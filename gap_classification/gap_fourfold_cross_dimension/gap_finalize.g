#############################################################################
## Final coverage, witness, transitivity, and cover-relation audit.
#############################################################################

Read("gap_cross_dimension_common.g");
Read("input/fourfold_156.g");
Read("input/large_target_schedule.g");
Read("audit/small_all_results.g");
Read("audit/known_positive_edges.g");

if Length(Families) <> 156 or Length(LargeTargetSchedule) <> 14 then
    Error("Unexpected final input size or large-target schedule.");
fi;
familyNumbers := List(Families, family -> family.number);
if familyNumbers <> [1 .. 156] then
    Error("Final family numbers are not 1 through 156.");
fi;

allResults := ShallowCopy(SmallAllResults);
for schedule in LargeTargetSchedule do
    path := Concatenation(
        "output/large_targets/layer_", String(schedule.layer),
        "_family_", String(schedule.number), ".g"
    );
    logPath := Concatenation(
        "output/large_targets/layer_", String(schedule.layer),
        "_family_", String(schedule.number), ".log"
    );
    if not IsExistingFile(path) or not IsExistingFile(logPath) then
        Error("Missing large-target output for family ", schedule.number, ".");
    fi;
    logText := StringFile(logPath);
    if PositionSublist(logText, "LARGE_TARGET_DONE") = fail
       or PositionSublist(logText, "undecided=0") = fail
       or PositionSublist(logText, "coverage=complete") = fail
       or PositionSublist(logText, "Error,") <> fail then
        Error("Incomplete or failed large target ", schedule.number, ".");
    fi;
    Read(path);
    if not IsBound(LargeTargetResults) or not IsList(LargeTargetResults) then
        Error("Malformed large-target output for family ", schedule.number, ".");
    fi;
    Append(allResults, LargeTargetResults);
    Unbind(LargeTargetResults);
od;

expected := [];
for sourcePosition in [1 .. Length(Families)] do
    for targetPosition in [1 .. Length(Families)] do
        if sourcePosition <> targetPosition
           and Families[sourcePosition].familyDimension
               > Families[targetPosition].familyDimension
           and Families[targetPosition].reportedOrder
               mod Families[sourcePosition].reportedOrder = 0 then
            Add(expected, [
                Families[sourcePosition].number,
                Families[targetPosition].number
            ]);
        fi;
    od;
od;
if Length(expected) <> 6568 then
    Error("Unexpected final eligible-pair count ", Length(expected), ".");
fi;

seen := [];
positive := [];
negative := [];
targetGroups := List([1 .. Length(Families)], position -> fail);
directPositiveCount := 0;
transitivePositiveCount := 0;
for result in allResults do
    key := [result.sourceNumber, result.targetNumber];
    if key in seen then
        Error("Duplicate final pair ", key, ".");
    fi;
    Add(seen, key);
    sourcePosition := Position(familyNumbers, result.sourceNumber);
    targetPosition := Position(familyNumbers, result.targetNumber);
    if sourcePosition = fail or targetPosition = fail then
        Error("A result references an unknown family number.");
    fi;
    if result.sourceDimension <> Families[sourcePosition].familyDimension
       or result.targetDimension <> Families[targetPosition].familyDimension
       or result.sourceOrder <> Families[sourcePosition].reportedOrder
       or result.targetOrder <> Families[targetPosition].reportedOrder then
        Error("A result's metadata disagrees with the frozen catalogue.");
    fi;
    ## Small-row positions refer to a 142-entry subset. Export positions in
    ## the full catalogue; stable family numbers and decisions are unchanged.
    result.sourcePosition := sourcePosition;
    result.targetPosition := targetPosition;
    if Families[sourcePosition].familyDimension
          <= Families[targetPosition].familyDimension
       or Families[targetPosition].reportedOrder
          mod Families[sourcePosition].reportedOrder <> 0 then
        Error("A final result is not an eligible cross-dimensional pair.");
    fi;
    if result.ok = fail or result.status = "undecided" then
        Error("An undecided final pair remains.");
    fi;

    if result.ok = true then
        if result.status <> "embedded"
           or result.P = fail
           or IsZero(DeterminantMat(result.P)) then
            Error("A positive final pair has no valid witness.");
        fi;
        if targetGroups[targetPosition] = fail then
            targetGroups[targetPosition] := Group(
                Families[targetPosition].generators
            );
        fi;
        if not ForAll(
            Families[sourcePosition].generators,
            element -> result.P^-1 * element * result.P
                       in targetGroups[targetPosition]
        ) then
            Error("A final positive witness failed verification.");
        fi;
        if result.classification = "direct" then
            directPositiveCount := directPositiveCount + 1;
        elif result.classification = "transitive" then
            transitivePositiveCount := transitivePositiveCount + 1;
        else
            Error("Unknown positive classification.");
        fi;
        Add(positive, result);
    else
        if result.status <> "no_embedding" or result.direct <> true then
            Error("A negative final result is not a direct strict decision.");
        fi;
        Add(negative, result);
    fi;
od;

if Length(allResults) <> Length(expected) or Set(seen) <> Set(expected) then
    Error("Final pair coverage is incomplete.");
fi;
if not ForAll(allResults, result ->
    result.sourcePosition = result.sourceNumber
    and result.targetPosition = result.targetNumber) then
    Error("Final catalogue positions are not canonical.");
fi;
if Set(List(KnownPositiveEdges, edge -> [edge.sourceNumber, edge.targetNumber]))
   <> Set(List(positive, edge -> [edge.sourceNumber, edge.targetNumber])) then
    Error("The incremental positive-edge file disagrees with the final list.");
fi;

positiveMatrix := List(
    [1 .. Length(Families)],
    first -> List([1 .. Length(Families)], second -> false)
);
for result in positive do
    sourcePosition := Position(familyNumbers, result.sourceNumber);
    targetPosition := Position(familyNumbers, result.targetNumber);
    positiveMatrix[sourcePosition][targetPosition] := true;
od;

for first in [1 .. Length(Families)] do
    for second in [1 .. Length(Families)] do
        if positiveMatrix[first][second] then
            for third in [1 .. Length(Families)] do
                if positiveMatrix[second][third]
                   and not positiveMatrix[first][third] then
                    Error(
                        "Positive relation is not transitively closed: ",
                        Families[first].number, " -> ",
                        Families[second].number, " -> ",
                        Families[third].number, "."
                    );
                fi;
            od;
        fi;
    od;
od;

groupEmbeddingCovers := [];
geometricFamilyCovers := [];
for result in positive do
    sourcePosition := Position(familyNumbers, result.sourceNumber);
    targetPosition := Position(familyNumbers, result.targetNumber);
    isCover := not ForAny(
        [1 .. Length(Families)],
        middle -> positiveMatrix[sourcePosition][middle]
                  and positiveMatrix[middle][targetPosition]
    );
    if isCover then
        Add(groupEmbeddingCovers, result);
        Add(geometricFamilyCovers, rec(
            smallerFamilyNumber := result.targetNumber,
            largerFamilyNumber := result.sourceNumber,
            groupSourceNumber := result.sourceNumber,
            groupTargetNumber := result.targetNumber,
            classification := result.classification,
            P := result.P
        ));
    fi;
od;

geometricMaximalFamilyNumbers := [];
geometricMinimalFamilyNumbers := [];
for position in [1 .. Length(Families)] do
    if not ForAny(
        [1 .. Length(Families)],
        other -> positiveMatrix[other][position]
    ) then
        Add(geometricMaximalFamilyNumbers, Families[position].number);
    fi;
    if not ForAny(
        [1 .. Length(Families)],
        other -> positiveMatrix[position][other]
    ) then
        Add(geometricMinimalFamilyNumbers, Families[position].number);
    fi;
od;

## Keep the search-coordinate decisions as input to the coordinate audit.
## Public matrices and reports are written by gap_coordinate_containment.g.
CFCD_WriteAssignment(
    "input/fourfold_computed_pairs.g",
    "FourfoldCrossDimensionAllPairs",
    allResults
);
PrintTo(
    "audit/fourfold_search_summary.txt",
    "input_families=156\n",
    "eligible_cross_dimension_pairs=", Length(expected), "\n",
    "embedded_pairs=", Length(positive), "\n",
    "no_embedding_pairs=", Length(negative), "\n",
    "undecided_pairs=0\n",
    "direct_positive_pairs=", directPositiveCount, "\n",
    "transitive_positive_pairs=", transitivePositiveCount, "\n",
    "verified_positive_witnesses=", Length(positive), "\n",
    "group_embedding_cover_edges=", Length(groupEmbeddingCovers), "\n",
    "pair_coverage=complete\n",
    "transitive_closure_audit=passed\n"
);
Print(
    "FOURFOLD_CROSS_DIMENSION_DONE\n",
    StringFile("audit/fourfold_search_summary.txt")
);
QUIT_GAP(0);
