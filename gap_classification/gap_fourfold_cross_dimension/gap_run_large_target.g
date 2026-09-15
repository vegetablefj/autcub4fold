#############################################################################
## Resolve one large target, using verified earlier edges by transitivity.
## Usage: gap -r -q -b gap_run_large_target.g <layer> <family-number>
#############################################################################

Read("gap_cross_dimension_common.g");
Read("gap_large_embedding.g");
Read("input/fourfold_156.g");
Read("audit/known_positive_edges.g");

layer := EvalString(
    GAPInfo.SystemCommandLine[Length(GAPInfo.SystemCommandLine) - 1]
);
targetNumber := EvalString(
    GAPInfo.SystemCommandLine[Length(GAPInfo.SystemCommandLine)]
);
if Length(Families) <> 156 then
    Error("Expected 156 final families.");
fi;

familyNumbers := List(Families, family -> family.number);
targetPosition := Position(familyNumbers, targetNumber);
if targetPosition = fail or Families[targetPosition].reportedOrder <= 2000 then
    Error("Invalid large target family ", targetNumber, ".");
fi;

infos := List([1 .. Length(Families)], position -> fail);
GetInfo := function(position)
    if infos[position] = fail then
        infos[position] := CFCD_PreprocessFamily(Families[position]);
    fi;
    return infos[position];
end;

layerStarted := Runtime();
Print("LARGE_TARGET_PREPARE layer=", layer, " family=", targetNumber, "\n");
targetInfo := GetInfo(targetPosition);
Print("LARGE_TARGET_PREPARED family=", targetNumber,
      " cpu_ms=", Runtime()-layerStarted, "\n");
candidates := Filtered(
    [1 .. Length(Families)],
    position -> position <> targetPosition
                and Families[position].familyDimension
                    > Families[targetPosition].familyDimension
                and targetInfo.order mod Families[position].reportedOrder = 0
);

## Start with maximal candidates in the relation already proved.  Missing
## earlier edges can only enlarge this frontier and hence cause extra direct
## tests; they cannot create a false positive or a false negative.
frontier := Filtered(
    candidates,
    first -> not ForAny(
        candidates,
        second -> first <> second
                  and CFCD_FindKnownEdge(
                      KnownPositiveEdges,
                      Families[first].number,
                      Families[second].number
                  ) <> fail
    )
);
if Length(candidates) > 0 and Length(frontier) = 0 then
    Error("The large-target frontier is empty.");
fi;

queue := ShallowCopy(frontier);
classifiedNumbers := [];
results := [];
directTestCount := 0;
inferredCount := 0;

Print(
    "LARGE_TARGET_START layer=", layer,
    " family=", targetNumber,
    " candidates=", Length(candidates),
    " frontier=", Length(frontier), "\n"
);

while Length(queue) > 0 do
    sourcePosition := Remove(queue, 1);
    sourceNumber := Families[sourcePosition].number;
    if sourceNumber in classifiedNumbers then
        continue;
    fi;

    pairStarted := Runtime();
    Print("LARGE_PAIR_START source=", sourceNumber, " target=", targetNumber,
          " classified=", Length(classifiedNumbers), "/", Length(candidates), "\n");
    sourceInfo := GetInfo(sourcePosition);
    directTestCount := directTestCount + 1;
    result := CFCD_SearchLargeEmbedding(
        sourceInfo,
        targetInfo,
        rec(verbose := true)
    );
    if result.ok = fail or result.status = "undecided" then
        Error(
            "Undecided large pair ", sourceNumber, " -> ", targetNumber,
            ": ", result.reason, "."
        );
    fi;
    result := CFCD_EnsureExplicitWitness(sourceInfo, targetInfo, result);
    pairCpuMs := Runtime()-pairStarted;
    Print("LARGE_PAIR_DONE source=", sourceNumber, " target=", targetNumber,
          " status=", result.status, " method=", result.method,
          " reason=", result.reason, " cpu_ms=", pairCpuMs, "\n");

    if result.ok = true then
        edge := rec(
            sourcePosition := sourcePosition,
            targetPosition := targetPosition,
            sourceNumber := sourceNumber,
            targetNumber := targetNumber,
            sourceDimension := Families[sourcePosition].familyDimension,
            targetDimension := Families[targetPosition].familyDimension,
            sourceOrder := sourceInfo.order,
            targetOrder := targetInfo.order,
            ok := true,
            status := "embedded",
            classification := "direct",
            reason := result.reason,
            method := result.method,
            direct := true,
            viaNumber := fail,
            cpuMs := pairCpuMs,
            P := result.P
        );
        Add(results, edge);
        AddSet(classifiedNumbers, sourceNumber);

        for ancestorPosition in candidates do
            ancestorNumber := Families[ancestorPosition].number;
            if ancestorNumber in classifiedNumbers then
                continue;
            fi;
            known := CFCD_FindKnownEdge(
                KnownPositiveEdges,
                ancestorNumber,
                sourceNumber
            );
            if known = fail then
                continue;
            fi;
            if not IsBound(known.P) or known.P = fail then
                Error("A known positive edge lacks a witness matrix.");
            fi;
            composite := ComposeEmbeddingWitness(known.P, result.P);
            if not CFCD_VerifyWitness(
                Families[ancestorPosition].generators, targetInfo.G, composite
            ) then
                Error("A composite witness failed independent verification.");
            fi;
            Add(results, rec(
                sourcePosition := ancestorPosition,
                targetPosition := targetPosition,
                sourceNumber := ancestorNumber,
                targetNumber := targetNumber,
                sourceDimension := Families[ancestorPosition].familyDimension,
                targetDimension := Families[targetPosition].familyDimension,
                sourceOrder := Families[ancestorPosition].reportedOrder,
                targetOrder := targetInfo.order,
                ok := true,
                status := "embedded",
                classification := "transitive",
                reason := "verified_witness_composition",
                method := "transitivity",
                direct := false,
                viaNumber := sourceNumber,
                P := composite
            ));
            AddSet(classifiedNumbers, ancestorNumber);
            inferredCount := inferredCount + 1;
        od;
    else
        Add(results, rec(
            sourcePosition := sourcePosition,
            targetPosition := targetPosition,
            sourceNumber := sourceNumber,
            targetNumber := targetNumber,
            sourceDimension := Families[sourcePosition].familyDimension,
            targetDimension := Families[targetPosition].familyDimension,
            sourceOrder := sourceInfo.order,
            targetOrder := targetInfo.order,
            ok := false,
            status := "no_embedding",
            classification := "direct",
            reason := result.reason,
            method := result.method,
            direct := true,
            viaNumber := fail,
            cpuMs := pairCpuMs,
            P := fail
        ));
        AddSet(classifiedNumbers, sourceNumber);

        ## A negative answer for a larger source says nothing about its
        ## subgroups, so all unclassified known ancestors are queued.
        for ancestorPosition in candidates do
            ancestorNumber := Families[ancestorPosition].number;
            if not (ancestorNumber in classifiedNumbers)
               and CFCD_FindKnownEdge(
                   KnownPositiveEdges,
                   ancestorNumber,
                   sourceNumber
               ) <> fail
               and not (ancestorPosition in queue) then
                Add(queue, ancestorPosition);
            fi;
        od;
    fi;

    if directTestCount mod 5 = 0 then
        Print(
            "LARGE_TARGET_PROGRESS layer=", layer,
            " family=", targetNumber,
            " direct=", directTestCount,
            " classified=", Length(classifiedNumbers),
            "/", Length(candidates), "\n"
        );
    fi;
od;

if Set(classifiedNumbers)
   <> Set(List(candidates, position -> Families[position].number))
   or Length(results) <> Length(candidates)
   or Length(Set(List(results, edge -> edge.sourceNumber)))
      <> Length(results) then
    Error("Large-target coverage is incomplete for family ", targetNumber, ".");
fi;

outputPath := Concatenation(
    "output/large_targets/layer_", String(layer),
    "_family_", String(targetNumber), ".g"
);
CFCD_WriteAssignment(outputPath, "LargeTargetResults", results);

newPositive := Filtered(results, edge -> edge.ok = true);
for edge in newPositive do
    if CFCD_FindKnownEdge(
        KnownPositiveEdges,
        edge.sourceNumber,
        edge.targetNumber
    ) <> fail then
        Error("A large layer attempted to append a duplicate positive edge.");
    fi;
    Add(KnownPositiveEdges, edge);
od;
CFCD_WriteAssignment(
    "audit/known_positive_edges.g",
    "KnownPositiveEdges",
    KnownPositiveEdges
);

Print(
    "LARGE_TARGET_DONE layer=", layer,
    " family=", targetNumber,
    " candidates=", Length(candidates),
    " direct=", directTestCount,
    " inferred=", inferredCount,
    " embedded=", Length(newPositive),
    " no_embedding=", Length(Filtered(results, edge -> edge.ok = false)),
    " cpu_ms=", Runtime()-layerStarted,
    " undecided=0 coverage=complete\n"
);
QUIT_GAP(0);
