#############################################################################
## Saved-relation audits and action-maximality helpers.
##
## Loading this file defines finite-poset functions and performs no embedding
## search. Run its entry-point callers from gap_fourfold_cross_dimension.
#############################################################################

CF_FP_StartLog := function(path, title)
    local stream;
    stream := OutputTextFile(path, false);
    if stream = fail then Error("Cannot open log: ", path); fi;
    SetPrintFormattingStatus(stream, false);
    AppendTo(stream, title, "\nGAP ", GAPInfo.Version, "\n\n");
    return rec(stream := stream, started := Runtime(), step := 0);
end;

CF_FP_Log := function(log, message)
    local line;
    log.step := log.step + 1;
    line := Concatenation(String(log.step), ". ", message,
        "; elapsed ", String(Runtime() - log.started), " ms\n");
    Print(line);
    AppendTo(log.stream, line);
end;

CF_FP_Write := function(path, name, value)
    local stream;
    stream := OutputTextFile(path, false);
    if stream = fail then Error("Cannot open result: ", path); fi;
    SetPrintFormattingStatus(stream, false);
    AppendTo(stream, name, " := ", value, ";\n");
    CloseStream(stream);
end;

CF_FP_ReadGlobal := function(path, name)
    ## Read afresh: a previous GAP session must not supply stale globals.
    if IsBoundGlobal(name) then UnbindGlobal(name); fi;
    Read(path);
    if not IsBoundGlobal(name) then Error("Missing saved object: ", name); fi;
    return ValueGlobal(name);
end;

CF_FP_AuditPairs := function(catalogue, pairs)
    local matrix, i, j, row, source, target, eligible, positive;
    if Length(catalogue) <> 156
       or List(catalogue, r -> r.number) <> [1 .. 156] then
        Error("Expected the numbered 156-family catalogue.");
    fi;
    matrix := List([1 .. 156], i -> List([1 .. 156], j -> fail));
    positive := [];
    for row in pairs do
        i := row.sourceNumber; j := row.targetNumber;
        if not i in [1 .. 156] or not j in [1 .. 156] then
            Error("Unknown fourfold pair number.");
        fi;
        source := catalogue[i]; target := catalogue[j];
        if matrix[i][j] <> fail then Error("Duplicate fourfold pair."); fi;
        if row.sourcePosition <> i or row.targetPosition <> j
           or row.sourceDimension <> source.familyDimension
           or row.targetDimension <> target.familyDimension
           or row.sourceOrder <> source.linearGroupId[1]
           or row.targetOrder <> target.linearGroupId[1] then
            Error("Fourfold pair metadata mismatch at ", [i,j]);
        fi;
        if row.ok = true and row.status = "embedded" then
            if row.P = fail or Length(row.P) <> 6
               or not ForAll(row.P, r -> Length(r) = 6)
               or IsZero(DeterminantMat(row.P)) then
                Error("Missing invertible fourfold witness.");
            fi;
            if (row.direct = true and (row.classification <> "direct"
                or row.viaNumber <> fail))
               or (row.direct = false and (row.classification <> "transitive"
                or not row.viaNumber in [1 .. 156]))
               or not row.direct in [true,false] then
                Error("Inconsistent positive decision metadata.");
            fi;
            Add(positive, [i,j]);
        elif row.ok <> false or row.status <> "no_embedding"
           or row.P <> fail or row.direct <> true
           or row.classification <> "direct" or row.viaNumber <> fail then
            Error("Unresolved fourfold decision at ", [i,j]);
        fi;
        matrix[i][j] := row;
    od;
    eligible := 0;
    for i in [1 .. 156] do
        for j in [1 .. 156] do
            if catalogue[i].familyDimension > catalogue[j].familyDimension
               and catalogue[j].linearGroupId[1]
                   mod catalogue[i].linearGroupId[1] = 0 then
                eligible := eligible + 1;
                if matrix[i][j] = fail then Error("Missing eligible pair."); fi;
            elif matrix[i][j] <> fail then
                Error("Unexpected ineligible pair.");
            fi;
        od;
    od;
    if eligible <> 6568 or Length(pairs) <> eligible then
        Error("Incomplete fourfold pair coverage.");
    fi;
    return rec(catalogue := catalogue, pairs := pairs,
        pairMatrix := matrix, positivePairs := Set(positive));
end;

CF_FP_LoadComputedFourfold := function()
    local catalogue, frozen, pairs, i, source, target, data;
    catalogue := CF_FP_ReadGlobal("input/fourfold_search_catalogue.g",
        "CanonicalFamilyMatrixGroups");
    frozen := CF_FP_ReadGlobal("input/fourfold_156.g", "Families");
    pairs := CF_FP_ReadGlobal("input/fourfold_computed_pairs.g",
        "FourfoldCrossDimensionAllPairs");
    if Length(catalogue) <> 156 or Length(frozen) <> 156
       or List(catalogue, r -> r.number) <> [1 .. 156]
       or List(frozen, r -> r.number) <> [1 .. 156] then
        Error("Expected the numbered 156-family search input.");
    fi;
    for i in [1 .. 156] do
        source := catalogue[i]; target := frozen[i];
        if source.matrixGenerators <> target.generators
           or source.familyDimension <> target.familyDimension
           or source.linearGroupId <> target.linearGroupId
           or source.projectiveGroupId <> target.projectiveGroupId
           or source.linearGroupId[1] <> target.reportedOrder
           or source.fullGroupVerified <> true
           or source.determinantKernelVerified <> true then
            Error("Frozen/search input mismatch at family ", i);
        fi;
    od;
    data := CF_FP_AuditPairs(catalogue, pairs);
    data.frozen := frozen;
    return data;
end;

CF_FP_LoadFourfold := function()
    local catalogue, pairs, audit, computed, data, i, row, original, copy;
    catalogue := CF_FP_ReadGlobal(
        "../gap_manuscript_validation/gap_family_catalogue.g",
        "CubicFourfoldFamilyCatalogue");
    pairs := CF_FP_ReadGlobal("result/gap_fourfold_cross_dimension_all_pairs.g",
        "FourfoldCrossDimensionAllPairs");
    audit := CF_FP_ReadGlobal("result/gap_fourfold_coordinate_audit.out",
        "FourfoldContainmentCoordinateAudit");
    computed := CF_FP_LoadComputedFourfold();
    if audit.status <> "completed" or audit.verifiedPositiveCount <> 1793
       or audit.pairCoverageVerified <> true
       or audit.positiveRelationsUnchanged <> true
       or audit.coverRelationsUnchanged <> true
       or audit.actionMaximaUnchanged <> true
       or List(catalogue, r -> r.matrixGenerators) <> audit.catalogueGenerators
       or List(computed.catalogue, r -> r.matrixGenerators)
           <> audit.inputGenerators
       or Length(audit.coordinateMatrices) <> 156 then
        Error("The completed coordinate audit does not match the input.");
    fi;
    for i in [1 .. 156] do
        row := catalogue[i]; original := computed.catalogue[i];
        if row.number <> i or row.sourceKey <> original.sourceKey
           or row.familyDimension <> original.familyDimension
           or row.linearGroupId <> original.linearGroupId
           or row.projectiveGroupId <> original.projectiveGroupId
           or row.fullIndex <> original.fullIndex
           or row.fullGroupVerified <> true
           or row.determinantKernelVerified <> true then
            Error("Displayed/search metadata mismatch at family ", i);
        fi;
    od;
    data := CF_FP_AuditPairs(catalogue, pairs);
    ## Bind the report to the actual transported matrices, not just its counts.
    for row in pairs do
        original := computed.pairMatrix[row.sourceNumber][row.targetNumber];
        copy := ShallowCopy(original);
        if original.ok then
            copy.P := audit.coordinateMatrices[row.sourceNumber]^-1
                * original.P * audit.coordinateMatrices[row.targetNumber];
        fi;
        if row <> copy then Error("Unmatched transported pair."); fi;
    od;
    return data;
end;

CF_FP_Poset := function(numbers, positivePairs)
    local n, relation, edge, i, j, k, covers, successors, maxima,
          records, targets, queue, seen, parents, head, current, next,
          paths, target, path, closurePairs;
    n := Length(numbers);
    if Length(Set(numbers)) <> n then Error("Repeated family numbers."); fi;
    if Length(Set(positivePairs)) <> Length(positivePairs) then
        Error("Repeated positive pairs.");
    fi;
    relation := List([1 .. n], i -> List([1 .. n], j -> false));
    for edge in positivePairs do
        i := Position(numbers, edge[1]); j := Position(numbers, edge[2]);
        if i = fail or j = fail or i = j then Error("Invalid strict edge."); fi;
        relation[i][j] := true;
    od;
    for i in [1 .. n] do
        for j in [1 .. n] do
            if relation[i][j] then
                for k in [1 .. n] do
                    if relation[j][k] and not relation[i][k] then
                        Error("Relation is not a strict transitive order.");
                    fi;
                od;
            fi;
        od;
    od;
    covers := [];
    successors := List([1 .. n], i -> []);
    for i in [1 .. n] do
        for j in [1 .. n] do
            if relation[i][j] and not ForAny([1 .. n],
                k -> relation[i][k] and relation[k][j]) then
                Add(covers, [numbers[i],numbers[j]]);
                Add(successors[i], j);
            fi;
        od;
    od;
    maxima := Filtered([1 .. n], i -> Length(successors[i]) = 0);
    records := []; closurePairs := [];
    for i in [1 .. n] do
        queue := [i]; seen := [i]; parents := List([1 .. n], j -> fail);
        head := 1;
        while head <= Length(queue) do
            current := queue[head]; head := head + 1;
            for next in successors[current] do
                if not next in seen then
                    Add(seen, next); Add(queue, next); parents[next] := current;
                fi;
            od;
        od;
        for j in Difference(seen, [i]) do
            Add(closurePairs, [numbers[i],numbers[j]]);
        od;
        targets := Filtered(maxima, j -> j in seen);
        if Length(targets) = 0 then Error("No reachable maximal action."); fi;
        paths := [];
        for target in targets do
            path := [numbers[target]]; current := target;
            while current <> i do
                current := parents[current]; Add(path, numbers[current]);
            od;
            Add(paths, rec(targetNumber := numbers[target],
                familyNumbers := Reversed(path)));
        od;
        Add(records, rec(number := numbers[i], isMaximal := i in maxima,
            maximalTargets := numbers{targets}, pathsToMaximal := paths));
    od;
    if Set(closurePairs) <> Set(positivePairs) then
        Error("Cover relation does not recover the complete relation.");
    fi;
    return rec(familyNumbers := numbers, positivePairs := Set(positivePairs),
        coverPairs := covers, maximalNumbers := numbers{maxima},
        familyTargets := records, transitiveClosureVerified := true,
        coverClosureVerified := true);
end;

CF_FP_TestPosetHelpers := function()
    local test;
    test := CF_FP_Poset([1 .. 5], [[1,2],[1,3],[1,4],[2,4],[3,4]]);
    if test.maximalNumbers <> [4,5]
       or Set(test.coverPairs) <> Set([[1,2],[1,3],[2,4],[3,4]])
       or test.familyTargets[1].maximalTargets <> [4]
       or test.familyTargets[5].pathsToMaximal[1].familyNumbers <> [5] then
        Error("Poset helper regression failed.");
    fi;
    test := CF_FP_Poset([1,2,3], [[1,2],[1,3]]);
    if test.familyTargets[1].maximalTargets <> [2,3] then
        Error("Multiple maximal targets were lost.");
    fi;
end;

CF_FP_GroupIdText := function(id)
    if id[2] = 0 then return Concatenation("[", String(id[1]), ", --]"); fi;
    return String(id);
end;
