#############################################################################
## Pair selection and list reduction for family-containment calculations.
##
## The proof-grade linear-conjugacy test is SearchEmbeddingStrict from
## gap_functions.g.  This file only standardizes catalogue records, chooses
## the pairs to test, and removes endpoints of proved containment edges.
## An embedding H_i -> H_j gives the reverse inclusion of invariant families.
## Every public search preserves the three statuses embedded, no_embedding,
## and undecided; an undecided comparison never removes a record.
#############################################################################

if not IsBound(SearchEmbeddingStrict) then
    if IsExistingFile("../gap_functions.g") then
        Read("../gap_functions.g");
    elif IsExistingFile("gap_functions.g") then
        Read("gap_functions.g");
    elif IsExistingFile("gap_classification/gap_functions.g") then
        Read("gap_classification/gap_functions.g");
    else
        Error(
            "Load gap_functions.g first, or run from the repository root, ",
            "gap_classification, or gap_classification/gap_saturation."
        );
    fi;
fi;


#############################################################################
## Record accessors
#############################################################################

CF_ContainmentRecordGenerators := function(record)
    if IsBound(record.matrixGenerators) then
        return record.matrixGenerators;
    elif IsBound(record.generators) then
        return record.generators;
    elif IsBound(record.linearGenerators) then
        return record.linearGenerators;
    elif IsBound(record.group) then
        return GeneratorsOfGroup(record.group);
    fi;

    Error("The record has no recognized matrix-generator field.");
end;


CF_ContainmentRecordGroupId := function(record)
    if IsBound(record.linearGroupId) then
        return record.linearGroupId;
    elif IsBound(record.linearGId) then
        return record.linearGId;
    elif IsBound(record.GLId) then
        return record.GLId;
    elif IsBound(record.groupId) then
        return record.groupId;
    fi;

    return fail;
end;


CF_ContainmentRecordReportedOrder := function(record)
    local groupId;

    if IsBound(record.linearOrder) then
        return record.linearOrder;
    elif IsBound(record.reportedOrder) then
        return record.reportedOrder;
    elif IsBound(record.groupOrder) then
        return record.groupOrder;
    fi;

    groupId := CF_ContainmentRecordGroupId(record);
    if IsList(groupId) and Length(groupId) >= 1 and IsInt(groupId[1]) then
        return groupId[1];
    fi;

    return fail;
end;


CF_ContainmentRecordFamilyDimension := function(record)
    if IsBound(record.familyDimension) then
        return record.familyDimension;
    elif IsBound(record.expectedModuliDimension) then
        return record.expectedModuliDimension;
    fi;

    return fail;
end;


CF_ContainmentRecordKey := function(record, position)
    if IsBound(record.sourceKey) then
        return record.sourceKey;
    elif IsBound(record.label) then
        return record.label;
    elif IsBound(record.inputNumber) then
        return Concatenation("input-", String(record.inputNumber));
    fi;

    return Concatenation("position-", String(position));
end;


#############################################################################
## Shared preprocessing
#############################################################################

CF_PrepareContainmentRecords := function(records)
    local entries, position, record, generators, groupId, reportedOrder,
          familyDimension, info, exactOrder;

    if not IsList(records) then
        Error("The containment input must be a list of records.");
    fi;

    entries := [];
    for position in [ 1 .. Length(records) ] do
        record := records[position];
        if not IsRecord(record) then
            Error("Containment input position ", position, " is not a record.");
        fi;

        generators := CF_ContainmentRecordGenerators(record);
        groupId := CF_ContainmentRecordGroupId(record);
        reportedOrder := CF_ContainmentRecordReportedOrder(record);
        familyDimension := CF_ContainmentRecordFamilyDimension(record);
        info := PreprocessMatrixGroupStrict(
            generators,
            reportedOrder,
            groupId
        );

        if IsBound(info.order) then
            exactOrder := info.order;
        elif IsBound(info.G) and IsFinite(info.G) then
            exactOrder := Size(info.G);
        else
            Error(
                "Could not determine a finite group order at input position ",
                position, "."
            );
        fi;

        Add(entries, rec(
            position := position,
            key := CF_ContainmentRecordKey(record, position),
            record := record,
            groupId := groupId,
            reportedOrder := reportedOrder,
            order := exactOrder,
            familyDimension := familyDimension,
            info := info
        ));
    od;

    return rec(
        isContainmentPreparation := true,
        recordCount := Length(records),
        entries := entries
    );
end;


CF_AsContainmentPreparation := function(data)
    if IsRecord(data)
       and IsBound(data.isContainmentPreparation)
       and data.isContainmentPreparation = true then
        return data;
    fi;

    return CF_PrepareContainmentRecords(data);
end;


#############################################################################
## Lazy pair preparation
#############################################################################

## This lighter preparation stores only documentary data.  Matrix groups and
## permutation models are constructed later, and only for pairs which survive
## the dimension, order-divisibility, and equal-order group-ID filters.
CF_PrepareContainmentRecordHeaders := function(records)
    local entries, position, record, groupId, reportedOrder,
          familyDimension;

    if not IsList(records) then
        Error("The containment input must be a list of records.");
    fi;

    entries := [];
    for position in [ 1 .. Length(records) ] do
        record := records[position];
        if not IsRecord(record) then
            Error("Containment input position ", position, " is not a record.");
        fi;

        groupId := CF_ContainmentRecordGroupId(record);
        reportedOrder := CF_ContainmentRecordReportedOrder(record);
        familyDimension := CF_ContainmentRecordFamilyDimension(record);

        Add(entries, rec(
            position := position,
            key := CF_ContainmentRecordKey(record, position),
            record := record,
            groupId := groupId,
            reportedOrder := reportedOrder,
            order := reportedOrder,
            familyDimension := familyDimension
        ));
    od;

    return rec(
        isContainmentHeaderPreparation := true,
        recordCount := Length(records),
        entries := entries
    );
end;


CF_AsContainmentHeaderPreparation := function(data)
    if IsRecord(data)
       and IsBound(data.isContainmentHeaderPreparation)
       and data.isContainmentHeaderPreparation = true then
        return data;
    fi;

    ## An eager preparation is also valid input for the lazy driver.  Its
    ## cached strict information is simply reused.
    if IsRecord(data)
       and IsBound(data.isContainmentPreparation)
       and data.isContainmentPreparation = true then
        return data;
    fi;

    return CF_PrepareContainmentRecordHeaders(data);
end;


CF_ContainmentEnsureEntryInfo := function(entry)
    local info;

    if IsBound(entry.info) then
        return entry.info;
    fi;

    info := PreprocessMatrixGroupStrict(
        CF_ContainmentRecordGenerators(entry.record),
        entry.reportedOrder,
        entry.groupId
    );
    entry.info := info;

    if IsBound(info.order) then
        entry.order := info.order;
    elif IsBound(info.G) and IsFinite(info.G) then
        entry.order := Size(info.G);
    fi;

    return info;
end;


CF_ContainmentEntryOrder := function(entry)
    if entry.order = fail then
        CF_ContainmentEnsureEntryInfo(entry);
    fi;
    if entry.order = fail then
        Error("Could not determine the group order for ", entry.key, ".");
    fi;
    return entry.order;
end;


CF_ContainmentDifferentEqualOrderGroupIds := function(first, second)
    return first.groupId <> fail
           and second.groupId <> fail
           and IsList(first.groupId)
           and IsList(second.groupId)
           and first.groupId <> second.groupId;
end;


## Test only the abstract subgroup relation encoded by two SmallGroups IDs.
## The result is cached because many different matrix representations have the
## same pair of abstract group IDs.  A missing or documentary ID [order,0]
## gives "unknown" and is never used as a negative certificate.
CF_AbstractEmbeddingPossibilityFromIds := function(sourceId, targetId, cache)
    local cached, sourceGroupCall, targetGroupCall, embeddingCall, result;

    cached := First(
        cache.entries,
        entry -> entry.sourceId = sourceId and entry.targetId = targetId
    );
    if cached <> fail then
        return cached.result;
    fi;

    if sourceId = fail or targetId = fail
       or not IsList(sourceId) or not IsList(targetId)
       or Length(sourceId) < 2 or Length(targetId) < 2
       or sourceId[2] = 0 or targetId[2] = 0 then
        result := rec(
            status := "unknown",
            reason := "SmallGroups ID is unavailable"
        );
    elif sourceId = targetId then
        result := rec(
            status := "possible",
            reason := "the abstract group IDs agree"
        );
    elif not IsInt(sourceId[1]) or not IsInt(sourceId[2])
         or not IsInt(targetId[1]) or not IsInt(targetId[2])
         or sourceId[1] < 1 or targetId[1] < 1
         or sourceId[2] < 1 or targetId[2] < 1 then
        result := rec(
            status := "unknown",
            reason := "the documented SmallGroups ID is invalid"
        );
    elif not SmallGroupsAvailable(sourceId[1])
         or not SmallGroupsAvailable(targetId[1]) then
        result := rec(
            status := "unknown",
            reason := "the required SmallGroups data are unavailable"
        );
    elif sourceId[2] > NumberSmallGroups(sourceId[1])
         or targetId[2] > NumberSmallGroups(targetId[1]) then
        result := rec(
            status := "unknown",
            reason := "the documented SmallGroups ID is out of range"
        );
    else
        sourceGroupCall := CALL_WITH_CATCH(
            SmallGroup,
            [sourceId[1], sourceId[2]]
        );
        targetGroupCall := CALL_WITH_CATCH(
            SmallGroup,
            [targetId[1], targetId[2]]
        );

        if not sourceGroupCall[1] or not targetGroupCall[1] then
            result := rec(
                status := "unknown",
                reason := "SmallGroup construction failed"
            );
        else
            embeddingCall := CALL_WITH_CATCH(
                IsomorphicSubgroups,
                [targetGroupCall[2], sourceGroupCall[2]]
            );
            if not embeddingCall[1] then
                result := rec(
                    status := "unknown",
                    reason := "abstract subgroup search failed"
                );
            elif Length(embeddingCall[2]) = 0 then
                result := rec(
                    status := "no_embedding",
                    reason := Concatenation(
                        "the documented abstract target has no subgroup ",
                        "of the documented source type"
                    )
                );
            else
                result := rec(
                    status := "possible",
                    reason := "an abstract subgroup embedding exists"
                );
            fi;
        fi;
    fi;

    Add(cache.entries, rec(
        sourceId := sourceId,
        targetId := targetId,
        result := result
    ));
    return result;
end;


CF_ContainmentSearchOptions := function(arguments)
    local options;

    if Length(arguments) = 0 then
        options := rec();
    elif Length(arguments) = 1 and IsRecord(arguments[1]) then
        options := ShallowCopy(arguments[1]);
    else
        Error("Containment options must be one optional record.");
    fi;

    if not IsBound(options.stop_first) then
        options.stop_first := true;
    fi;
    if not IsBound(options.construct_witness) then
        options.construct_witness := false;
    fi;

    return options;
end;


#############################################################################
## Pair searches
#############################################################################

CF_SearchContainmentPairs := function(preparedData, equalDimensionOnly, options)
    local prepared, entries, allPairs, embeddedEdges, noEmbeddingPairs,
          undecidedPairs, firstPosition, secondPosition, first, second,
          source, target, search, pair, searchMode;

    prepared := CF_AsContainmentPreparation(preparedData);
    entries := prepared.entries;

    if equalDimensionOnly
       and ForAny(entries, entry -> entry.familyDimension = fail) then
        Error(
            "Every record needs familyDimension or expectedModuliDimension ",
            "for an equal-dimension search."
        );
    fi;

    allPairs := [];
    embeddedEdges := [];
    noEmbeddingPairs := [];
    undecidedPairs := [];

    if Length(entries) >= 2 then
        for firstPosition in [ 1 .. Length(entries) - 1 ] do
            for secondPosition in [ firstPosition + 1 .. Length(entries) ] do
                first := entries[firstPosition];
                second := entries[secondPosition];

                if equalDimensionOnly
                   and first.familyDimension <> second.familyDimension then
                    continue;
                fi;

                # Only the smaller group can embed properly in the larger
                # group.  For equal orders, one orientation is sufficient:
                # an embedding is then a linear conjugacy.
                if first.order <= second.order then
                    source := first;
                    target := second;
                else
                    source := second;
                    target := first;
                fi;

                search := SearchEmbeddingStrict(
                    source.info,
                    target.info,
                    options
                );
                pair := rec(
                    sourcePosition := source.position,
                    targetPosition := target.position,
                    sourceKey := source.key,
                    targetKey := target.key,
                    sourceOrder := source.order,
                    targetOrder := target.order,
                    sourceFamilyDimension := source.familyDimension,
                    targetFamilyDimension := target.familyDimension,
                    status := search.status,
                    reason := search.reason,
                    method := search.method,
                    familyDirection :=
                        "target family is contained in source family",
                    embeddingResult := search
                );

                Add(allPairs, pair);
                if search.status = "embedded" then
                    Add(embeddedEdges, pair);
                elif search.status = "no_embedding" then
                    Add(noEmbeddingPairs, pair);
                elif search.status = "undecided" then
                    Add(undecidedPairs, pair);
                else
                    Error("Unexpected strict-embedding status: ", search.status);
                fi;
            od;
        od;
    fi;

    if equalDimensionOnly then
        searchMode := "equal_dimension";
    else
        searchMode := "all_dimensions";
    fi;

    return rec(
        mode := searchMode,
        recordCount := prepared.recordCount,
        testedPairCount := Length(allPairs),
        embeddedCount := Length(embeddedEdges),
        noEmbeddingCount := Length(noEmbeddingPairs),
        undecidedCount := Length(undecidedPairs),
        allPairs := allPairs,
        embeddedEdges := embeddedEdges,
        noEmbeddingPairs := noEmbeddingPairs,
        undecidedPairs := undecidedPairs
    );
end;


## Pair-lazy version of the same search.  Documentary orders and group IDs
## reject impossible pairs before either matrix group is converted to a
## permutation group.  Every surviving pair is still passed to the same
## proof-grade SearchEmbeddingStrict routine used above.
CF_SearchContainmentPairsLazy := function(headerData, equalDimensionOnly, options)
    local prepared, entries, allPairs, embeddedEdges, noEmbeddingPairs,
          undecidedPairs, firstPosition, secondPosition, first, second,
          firstOrder, secondOrder, source, target, sourceInfo, targetInfo,
          search, pair, searchMode, cheapRejectedCount, strictTestCount,
          progressInterval, preprocessedRecordCount, useAbstractIdFilter,
          abstractCache, abstractCheck, abstractRejectedCount,
          abstractUnknownCount;

    prepared := CF_AsContainmentHeaderPreparation(headerData);
    entries := prepared.entries;

    if equalDimensionOnly
       and ForAny(entries, entry -> entry.familyDimension = fail) then
        Error(
            "Every record needs familyDimension or expectedModuliDimension ",
            "for an equal-dimension search."
        );
    fi;

    if IsBound(options.progress_interval) then
        progressInterval := options.progress_interval;
    else
        progressInterval := 0;
    fi;
    if not IsInt(progressInterval) or progressInterval < 0 then
        Error("progress_interval must be a nonnegative integer.");
    fi;
    if IsBound(options.use_abstract_id_filter) then
        useAbstractIdFilter := options.use_abstract_id_filter;
    else
        useAbstractIdFilter := true;
    fi;

    allPairs := [];
    embeddedEdges := [];
    noEmbeddingPairs := [];
    undecidedPairs := [];
    cheapRejectedCount := 0;
    abstractRejectedCount := 0;
    abstractUnknownCount := 0;
    strictTestCount := 0;
    abstractCache := rec(entries := []);

    if Length(entries) >= 2 then
        for firstPosition in [ 1 .. Length(entries) - 1 ] do
            for secondPosition in [ firstPosition + 1 .. Length(entries) ] do
                first := entries[firstPosition];
                second := entries[secondPosition];

                if equalDimensionOnly
                   and first.familyDimension <> second.familyDimension then
                    continue;
                fi;

                firstOrder := CF_ContainmentEntryOrder(first);
                secondOrder := CF_ContainmentEntryOrder(second);
                if firstOrder <= secondOrder then
                    source := first;
                    target := second;
                else
                    source := second;
                    target := first;
                fi;

                if target.order mod source.order <> 0 then
                    search := rec(
                        status := "no_embedding",
                        reason := "source order does not divide target order",
                        method := "documentary order divisibility"
                    );
                    cheapRejectedCount := cheapRejectedCount + 1;
                elif source.order = target.order
                     and CF_ContainmentDifferentEqualOrderGroupIds(
                         source,
                         target
                     ) then
                    search := rec(
                        status := "no_embedding",
                        reason :=
                            "different documented group IDs at equal order",
                        method := "documentary group IDs"
                    );
                    cheapRejectedCount := cheapRejectedCount + 1;
                else
                    if useAbstractIdFilter then
                        abstractCheck :=
                            CF_AbstractEmbeddingPossibilityFromIds(
                                source.groupId,
                                target.groupId,
                                abstractCache
                            );
                    else
                        abstractCheck := rec(
                            status := "unknown",
                            reason := "abstract ID filter disabled"
                        );
                    fi;

                    if abstractCheck.status = "no_embedding" then
                        search := rec(
                            status := "no_embedding",
                            reason := abstractCheck.reason,
                            method := "abstract SmallGroup IDs"
                        );
                        abstractRejectedCount :=
                            abstractRejectedCount + 1;
                    else
                        if abstractCheck.status = "unknown" then
                            abstractUnknownCount :=
                                abstractUnknownCount + 1;
                        fi;

                        sourceInfo := CF_ContainmentEnsureEntryInfo(source);
                        targetInfo := CF_ContainmentEnsureEntryInfo(target);

                        ## Reorient using the exact computed orders.  A mismatch
                        ## with the documentary order is already reported by the
                        ## strict preprocessor.
                        source.order := CF_ContainmentEntryOrder(source);
                        target.order := CF_ContainmentEntryOrder(target);
                        if source.order > target.order then
                            first := source;
                            source := target;
                            target := first;
                            sourceInfo := source.info;
                            targetInfo := target.info;
                        fi;

                        search := SearchEmbeddingStrict(
                            sourceInfo,
                            targetInfo,
                            options
                        );
                        strictTestCount := strictTestCount + 1;
                    fi;
                fi;

                pair := rec(
                    sourcePosition := source.position,
                    targetPosition := target.position,
                    sourceKey := source.key,
                    targetKey := target.key,
                    sourceOrder := source.order,
                    targetOrder := target.order,
                    sourceFamilyDimension := source.familyDimension,
                    targetFamilyDimension := target.familyDimension,
                    status := search.status,
                    reason := search.reason,
                    method := search.method,
                    familyDirection :=
                        "target family is contained in source family",
                    embeddingResult := search
                );

                Add(allPairs, pair);
                if search.status = "embedded" then
                    Add(embeddedEdges, pair);
                elif search.status = "no_embedding" then
                    Add(noEmbeddingPairs, pair);
                elif search.status = "undecided" then
                    Add(undecidedPairs, pair);
                else
                    Error("Unexpected strict-embedding status: ", search.status);
                fi;

                if progressInterval > 0
                   and Length(allPairs) mod progressInterval = 0 then
                    Print(
                        "Containment pairs processed: ", Length(allPairs),
                        "; strict=", strictTestCount,
                        "; abstract-rejected=", abstractRejectedCount,
                        "; embedded=", Length(embeddedEdges),
                        "; undecided=", Length(undecidedPairs), "\n"
                    );
                fi;
            od;
        od;
    fi;

    if equalDimensionOnly then
        searchMode := "equal_dimension_lazy";
    else
        searchMode := "all_dimensions_lazy";
    fi;

    preprocessedRecordCount := Number(
        entries,
        entry -> IsBound(entry.info)
    );

    return rec(
        mode := searchMode,
        recordCount := prepared.recordCount,
        testedPairCount := Length(allPairs),
        cheapRejectedCount := cheapRejectedCount,
        abstractRejectedCount := abstractRejectedCount,
        abstractUnknownCount := abstractUnknownCount,
        abstractCacheEntryCount := Length(abstractCache.entries),
        strictTestCount := strictTestCount,
        preprocessedRecordCount := preprocessedRecordCount,
        embeddedCount := Length(embeddedEdges),
        noEmbeddingCount := Length(noEmbeddingPairs),
        undecidedCount := Length(undecidedPairs),
        allPairs := allPairs,
        embeddedEdges := embeddedEdges,
        noEmbeddingPairs := noEmbeddingPairs,
        undecidedPairs := undecidedPairs
    );
end;


#############################################################################
## Direct maximal-list search
#############################################################################

## Test one already oriented candidate pair.  The mutable state contains the
## abstract-ID cache and audit counters shared by the maximal-list driver.
CF_TestContainmentEntryPairLazy := function(first, second, options, state)
    local source, target, sourceInfo, targetInfo, abstractCheck, search;

    if first.familyDimension <> second.familyDimension then
        Error("The direct pair test requires equal family dimensions.");
    fi;

    if first.order <= second.order then
        source := first;
        target := second;
    else
        source := second;
        target := first;
    fi;

    state.testedPairCount := state.testedPairCount + 1;

    if target.order mod source.order <> 0 then
        search := rec(
            status := "no_embedding",
            reason := "source order does not divide target order",
            method := "documentary order divisibility"
        );
        state.cheapRejectedCount := state.cheapRejectedCount + 1;
    elif source.order = target.order
         and CF_ContainmentDifferentEqualOrderGroupIds(source, target) then
        search := rec(
            status := "no_embedding",
            reason := "different documented group IDs at equal order",
            method := "documentary group IDs"
        );
        state.cheapRejectedCount := state.cheapRejectedCount + 1;
    else
        if state.useAbstractIdFilter then
            abstractCheck := CF_AbstractEmbeddingPossibilityFromIds(
                source.groupId,
                target.groupId,
                state.abstractCache
            );
        else
            abstractCheck := rec(
                status := "unknown",
                reason := "abstract ID filter disabled"
            );
        fi;

        if abstractCheck.status = "no_embedding" then
            search := rec(
                status := "no_embedding",
                reason := abstractCheck.reason,
                method := "abstract SmallGroup IDs"
            );
            state.abstractRejectedCount :=
                state.abstractRejectedCount + 1;
        else
            if abstractCheck.status = "unknown" then
                state.abstractUnknownCount :=
                    state.abstractUnknownCount + 1;
            fi;

            sourceInfo := CF_ContainmentEnsureEntryInfo(source);
            targetInfo := CF_ContainmentEnsureEntryInfo(target);
            source.order := CF_ContainmentEntryOrder(source);
            target.order := CF_ContainmentEntryOrder(target);

            if source.order > target.order then
                first := source;
                source := target;
                target := first;
                sourceInfo := source.info;
                targetInfo := target.info;
            fi;

            search := SearchEmbeddingStrict(
                sourceInfo,
                targetInfo,
                options
            );
            state.strictTestCount := state.strictTestCount + 1;
        fi;
    fi;

    return rec(
        sourcePosition := source.position,
        targetPosition := target.position,
        sourceKey := source.key,
        targetKey := target.key,
        sourceOrder := source.order,
        targetOrder := target.order,
        sourceFamilyDimension := source.familyDimension,
        targetFamilyDimension := target.familyDimension,
        status := search.status,
        reason := search.reason,
        method := search.method,
        familyDirection := "target family is contained in source family",
        embeddingResult := search
    );
end;


## Process each dimension bucket in decreasing group order.  A record is
## compared only with records currently retained in that bucket.  Once a
## proved embedding removes it, it never participates in a later comparison.
CF_StripEqualDimensionSmallerGroupsLazy := function(data, arg...)
    local prepared, entries, options, useAbstractIdFilter, progressInterval,
          targetOrder, pairProgress, candidateIndex, pairIndex,
          state, processingPositions, keptProcessingPositions,
          removedPositions, certificates, undecidedPairs, position, entry,
          targetPositions, targetPosition, pair, wasRemoved, keptPositions;

    prepared := CF_AsContainmentHeaderPreparation(data);
    entries := prepared.entries;
    options := CF_ContainmentSearchOptions(arg);

    if ForAny(entries, item -> item.familyDimension = fail) then
        Error(
            "Every record needs familyDimension or expectedModuliDimension ",
            "for an equal-dimension search."
        );
    fi;

    if IsBound(options.use_abstract_id_filter) then
        useAbstractIdFilter := options.use_abstract_id_filter;
    else
        useAbstractIdFilter := true;
    fi;
    if IsBound(options.progress_interval) then
        progressInterval := options.progress_interval;
    else
        progressInterval := 0;
    fi;
    if IsBound(options.target_order) then
        targetOrder := options.target_order;
    else
        targetOrder := "input";
    fi;
    if not targetOrder in [ "input", "ascending", "descending" ] then
        Error("target_order must be input, ascending, or descending.");
    fi;
    if IsBound(options.pair_progress) then
        pairProgress := options.pair_progress;
    else
        pairProgress := false;
    fi;
    if pairProgress <> true and pairProgress <> false then
        Error("pair_progress must be true or false.");
    fi;

    state := rec(
        useAbstractIdFilter := useAbstractIdFilter,
        abstractCache := rec(entries := []),
        testedPairCount := 0,
        cheapRejectedCount := 0,
        abstractRejectedCount := 0,
        abstractUnknownCount := 0,
        strictTestCount := 0,
        startRuntime := Runtime()
    );

    processingPositions := [ 1 .. Length(entries) ];
    state.initialSaturatedPositions := Filtered(
        processingPositions,
        position ->
            IsBound(entries[position].record.initiallySaturated)
            and entries[position].record.initiallySaturated = true
    );
    processingPositions := Difference(
        processingPositions,
        state.initialSaturatedPositions
    );
    Sort(processingPositions, function(firstPosition, secondPosition)
        local first, second;
        first := entries[firstPosition];
        second := entries[secondPosition];
        if first.familyDimension <> second.familyDimension then
            return first.familyDimension < second.familyDimension;
        elif first.order <> second.order then
            return first.order > second.order;
        fi;
        return first.position < second.position;
    end);

    ## Initially saturated families are permanent targets.  They are never
    ## tested as sources and can therefore never be removed.
    keptProcessingPositions := ShallowCopy(
        state.initialSaturatedPositions
    );
    removedPositions := [];
    certificates := [];
    undecidedPairs := [];

    candidateIndex := 0;
    for position in processingPositions do
        candidateIndex := candidateIndex + 1;
        entry := entries[position];
        targetPositions := Filtered(
            keptProcessingPositions,
            targetPosition ->
                entries[targetPosition].familyDimension
                    = entry.familyDimension
                and entries[targetPosition].order mod entry.order = 0
        );
        if targetOrder = "ascending" then
            Sort(targetPositions, function(firstTarget, secondTarget)
                if entries[firstTarget].order
                   <> entries[secondTarget].order then
                    return entries[firstTarget].order
                           < entries[secondTarget].order;
                fi;
                return firstTarget < secondTarget;
            end);
        elif targetOrder = "descending" then
            Sort(targetPositions, function(firstTarget, secondTarget)
                if entries[firstTarget].order
                   <> entries[secondTarget].order then
                    return entries[firstTarget].order
                           > entries[secondTarget].order;
                fi;
                return firstTarget < secondTarget;
            end);
        fi;

        if pairProgress then
            Print(
                "Candidate ", candidateIndex, "/",
                Length(processingPositions), ": key=", entry.key,
                "; dimension=", entry.familyDimension,
                "; order=", entry.order,
                "; possible targets=", Length(targetPositions),
                "; elapsed=", Runtime() - state.startRuntime, " ms\n"
            );
        fi;

        wasRemoved := false;
        pairIndex := 0;
        for targetPosition in targetPositions do
            pairIndex := pairIndex + 1;
            if pairProgress then
                Print(
                    "  Pair ", pairIndex, "/", Length(targetPositions),
                    ": ", entry.key, " -> ",
                    entries[targetPosition].key,
                    " (", entry.order, " -> ",
                    entries[targetPosition].order, ") started; elapsed=",
                    Runtime() - state.startRuntime, " ms\n"
                );
            fi;
            pair := CF_TestContainmentEntryPairLazy(
                entry,
                entries[targetPosition],
                options,
                state
            );
            if pairProgress then
                Print(
                    "    status=", pair.status,
                    "; method=", pair.method,
                    "; reason=", pair.reason,
                    "; elapsed=", Runtime() - state.startRuntime, " ms\n"
                );
            fi;

            if pair.status = "embedded" then
                Add(removedPositions, position);
                Add(certificates, rec(
                    removedPosition := position,
                    keptPosition := targetPosition,
                    edge := pair
                ));
                wasRemoved := true;
                break;
            elif pair.status = "undecided" then
                Add(undecidedPairs, pair);
            fi;
        od;

        if not wasRemoved then
            Add(keptProcessingPositions, position);
        fi;

        if progressInterval > 0
           and candidateIndex mod progressInterval = 0
        then
            Print(
                "Candidates processed: ",
                candidateIndex,
                "/", Length(processingPositions),
                "; kept=", Length(keptProcessingPositions),
                "; removed=", Length(removedPositions),
                "; strict=", state.strictTestCount,
                "; undecided=", Length(undecidedPairs),
                "; elapsed=", Runtime() - state.startRuntime, " ms\n"
            );
        fi;
    od;

    keptPositions := Set(keptProcessingPositions);
    removedPositions := Set(removedPositions);

    return rec(
        mode := "equal_dimension_direct_maxima_lazy",
        removalMode := "smaller_group",
        originalCount := Length(entries),
        initialSaturatedCount := Length(state.initialSaturatedPositions),
        initialSaturatedPositions := state.initialSaturatedPositions,
        initialSaturatedRecords := List(
            state.initialSaturatedPositions,
            p -> entries[p].record
        ),
        remainingCount := Length(keptPositions),
        removedCount := Length(removedPositions),
        keptPositions := keptPositions,
        removedPositions := removedPositions,
        remainingRecords := List(keptPositions, p -> entries[p].record),
        removedRecords := List(removedPositions, p -> entries[p].record),
        removalCertificates := certificates,
        testedPairCount := state.testedPairCount,
        cheapRejectedCount := state.cheapRejectedCount,
        abstractRejectedCount := state.abstractRejectedCount,
        abstractUnknownCount := state.abstractUnknownCount,
        abstractCacheEntryCount := Length(state.abstractCache.entries),
        strictTestCount := state.strictTestCount,
        preprocessedRecordCount := Number(
            entries,
            item -> IsBound(item.info)
        ),
        undecidedPairs := undecidedPairs,
        undecidedCount := Length(undecidedPairs),
        maximaComplete := Length(undecidedPairs) = 0
    );
end;


#############################################################################
## Traceable equal-dimensional saturation search
#############################################################################

CF_ContainmentEntryIsKnownSaturated := function(entry)
    if IsBound(entry.record.saturationTag) then
        return entry.record.saturationTag = "known_saturated";
    fi;
    return IsBound(entry.record.initiallySaturated)
           and entry.record.initiallySaturated = true;
end;


CF_ContainmentParentPath := function(position, parentPositions)
    local path, current, next;

    path := [ position ];
    current := position;
    while parentPositions[current] <> fail do
        next := parentPositions[current];
        if next in path then
            Error("A cycle was found in the equal-dimensional containment graph.");
        fi;
        Add(path, next);
        current := next;
    od;
    return path;
end;


## Phase 1 merges proved equal-order conjugate actions.  Phase 2 processes
## the remaining representatives in increasing group order and tries every
## strictly larger target from the complete representative list, also in
## increasing order.  A target remains available even if it is later removed.
## The resulting parent graph is acyclic: equal-order edges point to an
## earlier representative, and proper edges strictly increase group order.
CF_TraceEqualDimensionSaturationLazy := function(data, arg...)
    local prepared, entries, options, useAbstractIdFilter, pairProgress,
          progressInterval, state, allPositions, knownPositions,
          equivalenceOrder, representativePositions, position, entry,
          targetPositions, targetPosition, pairIndex, pair, found,
          parentPositions, parentEdgeNumbers, certificates,
          noEmbeddingPairs, undecidedPairs, sourcePositions, sourceIndex,
          removedPositions, survivorPositions, computedSaturatedPositions,
          unresolvedSurvivorPositions, uncertainSourcePositions, traces,
          path, finalPosition, pathEdgeNumbers, finalStatus, disposition,
          pathUndecidedCount, directTargetPosition, directTargetKey, classes,
          memberPositions, knownInputCount, sourceUndecidedCount;

    prepared := CF_AsContainmentHeaderPreparation(data);
    entries := prepared.entries;
    options := CF_ContainmentSearchOptions(arg);

    if ForAny(entries, item -> item.familyDimension = fail) then
        Error(
            "Every record needs familyDimension or expectedModuliDimension ",
            "for an equal-dimension search."
        );
    fi;

    if IsBound(options.use_abstract_id_filter) then
        useAbstractIdFilter := options.use_abstract_id_filter;
    else
        useAbstractIdFilter := true;
    fi;
    if IsBound(options.pair_progress) then
        pairProgress := options.pair_progress;
    else
        pairProgress := true;
    fi;
    if pairProgress <> true and pairProgress <> false then
        Error("pair_progress must be true or false.");
    fi;
    if IsBound(options.progress_interval) then
        progressInterval := options.progress_interval;
    else
        progressInterval := 10;
    fi;
    if not IsInt(progressInterval) or progressInterval < 0 then
        Error("progress_interval must be a nonnegative integer.");
    fi;

    state := rec(
        useAbstractIdFilter := useAbstractIdFilter,
        abstractCache := rec(entries := []),
        testedPairCount := 0,
        cheapRejectedCount := 0,
        abstractRejectedCount := 0,
        abstractUnknownCount := 0,
        strictTestCount := 0,
        startRuntime := Runtime()
    );

    allPositions := [ 1 .. Length(entries) ];
    for position in allPositions do
        CF_ContainmentEntryOrder(entries[position]);
    od;
    knownPositions := Filtered(
        allPositions,
        position -> CF_ContainmentEntryIsKnownSaturated(entries[position])
    );
    knownInputCount := Length(knownPositions);

    parentPositions := ListWithIdenticalEntries(Length(entries), fail);
    parentEdgeNumbers := ListWithIdenticalEntries(Length(entries), fail);
    certificates := [];
    noEmbeddingPairs := [];
    undecidedPairs := [];

    #########################################################################
    ## Phase 1: equal-order equivalence
    #########################################################################

    equivalenceOrder := ShallowCopy(allPositions);
    Sort(equivalenceOrder, function(firstPosition, secondPosition)
        local first, second, firstKnown, secondKnown;
        first := entries[firstPosition];
        second := entries[secondPosition];
        if first.familyDimension <> second.familyDimension then
            return first.familyDimension < second.familyDimension;
        elif first.order <> second.order then
            return first.order < second.order;
        fi;
        firstKnown := CF_ContainmentEntryIsKnownSaturated(first);
        secondKnown := CF_ContainmentEntryIsKnownSaturated(second);
        if firstKnown <> secondKnown then
            return firstKnown;
        fi;
        return first.position < second.position;
    end);

    representativePositions := [];
    Print("Phase 1: equal-order equivalence; candidates=",
          Length(equivalenceOrder), "\n");
    for position in equivalenceOrder do
        entry := entries[position];
        targetPositions := Filtered(
            representativePositions,
            targetPosition ->
                entries[targetPosition].familyDimension
                    = entry.familyDimension
                and entries[targetPosition].order = entry.order
        );
        Sort(targetPositions, function(firstTarget, secondTarget)
            local firstKnown, secondKnown;
            firstKnown := CF_ContainmentEntryIsKnownSaturated(
                entries[firstTarget]
            );
            secondKnown := CF_ContainmentEntryIsKnownSaturated(
                entries[secondTarget]
            );
            if firstKnown <> secondKnown then
                return firstKnown;
            fi;
            return firstTarget < secondTarget;
        end);

        found := false;
        pairIndex := 0;
        for targetPosition in targetPositions do
            pairIndex := pairIndex + 1;
            if pairProgress then
                Print(
                    "  Equivalence pair ", pairIndex, "/",
                    Length(targetPositions), ": ", entry.key, " -> ",
                    entries[targetPosition].key, " (dimension=",
                    entry.familyDimension, ", order=", entry.order,
                    ") started; elapsed=", Runtime() - state.startRuntime,
                    " ms\n"
                );
            fi;
            pair := CF_TestContainmentEntryPairLazy(
                entry,
                entries[targetPosition],
                options,
                state
            );
            if pairProgress then
                Print(
                    "    status=", pair.status, "; method=", pair.method,
                    "; elapsed=", Runtime() - state.startRuntime, " ms\n"
                );
            fi;

            if pair.status = "embedded" then
                parentPositions[position] := targetPosition;
                Add(certificates, rec(
                    kind := "equal_order_equivalence",
                    removedPosition := position,
                    directTargetPosition := targetPosition,
                    edge := pair
                ));
                parentEdgeNumbers[position] := Length(certificates);
                found := true;
                break;
            elif pair.status = "no_embedding" then
                Add(noEmbeddingPairs, pair);
            elif pair.status = "undecided" then
                Add(undecidedPairs, pair);
            else
                Error("Unexpected strict-embedding status: ", pair.status);
            fi;
        od;

        if not found then
            Add(representativePositions, position);
        fi;
    od;
    Print(
        "Phase 1 completed: representatives=",
        Length(representativePositions), "; equal-order duplicates=",
        Length(certificates), "; strict=", state.strictTestCount,
        "; undecided=", Length(undecidedPairs), "; elapsed=",
        Runtime() - state.startRuntime, " ms\n\n"
    );

    #########################################################################
    ## Phase 2: nearest proper overgroup in the complete target list
    #########################################################################

    sourcePositions := Filtered(
        representativePositions,
        position -> not CF_ContainmentEntryIsKnownSaturated(entries[position])
    );
    Sort(sourcePositions, function(firstPosition, secondPosition)
        local first, second;
        first := entries[firstPosition];
        second := entries[secondPosition];
        if first.familyDimension <> second.familyDimension then
            return first.familyDimension < second.familyDimension;
        elif first.order <> second.order then
            return first.order < second.order;
        fi;
        return first.position < second.position;
    end);

    Print("Phase 2: proper equal-dimensional overgroups; sources=",
          Length(sourcePositions), "\n");
    sourceIndex := 0;
    for position in sourcePositions do
        sourceIndex := sourceIndex + 1;
        entry := entries[position];
        targetPositions := Filtered(
            representativePositions,
            targetPosition ->
                entries[targetPosition].familyDimension
                    = entry.familyDimension
                and entries[targetPosition].order > entry.order
                and entries[targetPosition].order mod entry.order = 0
        );
        Sort(targetPositions, function(firstTarget, secondTarget)
            local firstKnown, secondKnown;
            if entries[firstTarget].order <> entries[secondTarget].order then
                return entries[firstTarget].order
                       < entries[secondTarget].order;
            fi;
            firstKnown := CF_ContainmentEntryIsKnownSaturated(
                entries[firstTarget]
            );
            secondKnown := CF_ContainmentEntryIsKnownSaturated(
                entries[secondTarget]
            );
            if firstKnown <> secondKnown then
                return firstKnown;
            fi;
            return firstTarget < secondTarget;
        end);

        Print(
            "Candidate ", sourceIndex, "/", Length(sourcePositions),
            ": key=", entry.key, "; dimension=", entry.familyDimension,
            "; order=", entry.order, "; possible targets=",
            Length(targetPositions), "; elapsed=",
            Runtime() - state.startRuntime, " ms\n"
        );

        found := false;
        pairIndex := 0;
        for targetPosition in targetPositions do
            pairIndex := pairIndex + 1;
            if pairProgress then
                Print(
                    "  Pair ", pairIndex, "/", Length(targetPositions),
                    ": ", entry.key, " -> ", entries[targetPosition].key,
                    " (", entry.order, " -> ",
                    entries[targetPosition].order, ") started; elapsed=",
                    Runtime() - state.startRuntime, " ms\n"
                );
            fi;
            pair := CF_TestContainmentEntryPairLazy(
                entry,
                entries[targetPosition],
                options,
                state
            );
            if pairProgress then
                Print(
                    "    status=", pair.status, "; method=", pair.method,
                    "; elapsed=", Runtime() - state.startRuntime, " ms\n"
                );
            fi;

            if pair.status = "embedded" then
                parentPositions[position] := targetPosition;
                Add(certificates, rec(
                    kind := "proper_equal_dimension_overgroup",
                    removedPosition := position,
                    directTargetPosition := targetPosition,
                    edge := pair
                ));
                parentEdgeNumbers[position] := Length(certificates);
                found := true;
                break;
            elif pair.status = "no_embedding" then
                Add(noEmbeddingPairs, pair);
            elif pair.status = "undecided" then
                Add(undecidedPairs, pair);
            else
                Error("Unexpected strict-embedding status: ", pair.status);
            fi;
        od;

        if progressInterval > 0
           and (sourceIndex mod progressInterval = 0
                or sourceIndex = Length(sourcePositions)) then
            Print(
                "Progress: sources=", sourceIndex, "/",
                Length(sourcePositions), "; direct removals=",
                Number(parentPositions, parent -> parent <> fail),
                "; strict=", state.strictTestCount, "; undecided=",
                Length(undecidedPairs), "; elapsed=",
                Runtime() - state.startRuntime, " ms\n"
            );
        fi;
    od;

    #########################################################################
    ## Resolve every direct parent to its final survivor.
    #########################################################################

    removedPositions := Filtered(
        allPositions,
        position -> parentPositions[position] <> fail
    );
    survivorPositions := Difference(allPositions, removedPositions);
    uncertainSourcePositions := Set(List(
        undecidedPairs,
        undecided -> undecided.sourcePosition
    ));
    computedSaturatedPositions := Filtered(
        survivorPositions,
        position ->
            not CF_ContainmentEntryIsKnownSaturated(entries[position])
            and not (position in uncertainSourcePositions)
    );
    unresolvedSurvivorPositions := Filtered(
        survivorPositions,
        position ->
            not CF_ContainmentEntryIsKnownSaturated(entries[position])
            and position in uncertainSourcePositions
    );

    traces := [];
    for position in allPositions do
        path := CF_ContainmentParentPath(position, parentPositions);
        finalPosition := path[Length(path)];
        if Length(path) = 1 then
            pathEdgeNumbers := [];
            directTargetPosition := fail;
            directTargetKey := fail;
        else
            pathEdgeNumbers := List(
                path{[ 1 .. Length(path) - 1 ]},
                pathPosition -> parentEdgeNumbers[pathPosition]
            );
            directTargetPosition := path[2];
            directTargetKey := entries[directTargetPosition].key;
        fi;

        sourceUndecidedCount := Number(
            undecidedPairs,
            undecided -> undecided.sourcePosition = position
        );
        pathUndecidedCount := Number(
            undecidedPairs,
            undecided -> undecided.sourcePosition in path
        );
        if CF_ContainmentEntryIsKnownSaturated(entries[finalPosition]) then
            finalStatus := "known_saturated";
        elif finalPosition in unresolvedSurvivorPositions then
            finalStatus := "unresolved";
        else
            finalStatus := "computed_saturated";
        fi;

        if parentPositions[position] = fail then
            disposition := finalStatus;
        elif certificates[parentEdgeNumbers[position]].kind
             = "equal_order_equivalence" then
            disposition := "equal_order_duplicate";
        else
            disposition := "contained_same_dimension";
        fi;

        Add(traces, rec(
            inputPosition := position,
            key := entries[position].key,
            familyDimension := entries[position].familyDimension,
            groupOrder := entries[position].order,
            disposition := disposition,
            directTargetPosition := directTargetPosition,
            directTargetKey := directTargetKey,
            finalTargetPosition := finalPosition,
            finalTargetKey := entries[finalPosition].key,
            finalStatus := finalStatus,
            pathPositions := path,
            pathKeys := List(path, pathPosition -> entries[pathPosition].key),
            pathEdgeNumbers := pathEdgeNumbers,
            sourceUndecidedCount := sourceUndecidedCount,
            pathUndecidedCount := pathUndecidedCount
        ));
    od;

    Sort(survivorPositions, function(firstPosition, secondPosition)
        local first, second;
        first := entries[firstPosition];
        second := entries[secondPosition];
        if first.familyDimension <> second.familyDimension then
            return first.familyDimension < second.familyDimension;
        elif first.order <> second.order then
            return first.order < second.order;
        fi;
        return first.position < second.position;
    end);
    classes := [];
    for finalPosition in survivorPositions do
        memberPositions := Filtered(
            allPositions,
            position -> traces[position].finalTargetPosition = finalPosition
        );
        Add(classes, rec(
            finalTargetPosition := finalPosition,
            finalTargetKey := entries[finalPosition].key,
            finalStatus := traces[finalPosition].finalStatus,
            familyDimension := entries[finalPosition].familyDimension,
            groupOrder := entries[finalPosition].order,
            memberCount := Length(memberPositions),
            memberPositions := memberPositions,
            memberKeys := List(
                memberPositions,
                memberPosition -> entries[memberPosition].key
            )
        ));
    od;

    return rec(
        mode := "equal_dimension_traceable_ascending_lazy",
        removalMode := "smaller_group",
        originalCount := Length(entries),
        knownSaturatedInputCount := knownInputCount,
        knownSaturatedInputPositions := knownPositions,
        representativeCountAfterEqualOrder := Length(representativePositions),
        representativePositionsAfterEqualOrder := representativePositions,
        remainingCount := Length(survivorPositions),
        removedCount := Length(removedPositions),
        keptPositions := survivorPositions,
        removedPositions := removedPositions,
        remainingRecords := List(
            survivorPositions,
            position -> entries[position].record
        ),
        removedRecords := List(
            removedPositions,
            position -> entries[position].record
        ),
        knownSaturatedSurvivorPositions := Intersection(
            survivorPositions,
            knownPositions
        ),
        computedSaturatedPositions := computedSaturatedPositions,
        unresolvedSurvivorPositions := unresolvedSurvivorPositions,
        directEdges := certificates,
        removalCertificates := certificates,
        parentPositions := parentPositions,
        familyTraces := traces,
        saturationClasses := classes,
        testedPairCount := state.testedPairCount,
        noEmbeddingPairs := noEmbeddingPairs,
        noEmbeddingCount := Length(noEmbeddingPairs),
        cheapRejectedCount := state.cheapRejectedCount,
        abstractRejectedCount := state.abstractRejectedCount,
        abstractUnknownCount := state.abstractUnknownCount,
        abstractCacheEntryCount := Length(state.abstractCache.entries),
        strictTestCount := state.strictTestCount,
        preprocessedRecordCount := Number(
            entries,
            item -> IsBound(item.info)
        ),
        undecidedPairs := undecidedPairs,
        undecidedCount := Length(undecidedPairs),
        maximaComplete := Length(undecidedPairs) = 0,
        runtimeMilliseconds := Runtime() - state.startRuntime
    );
end;


#############################################################################
## Remove endpoints of proved containment edges
#############################################################################

CF_StripListByContainment := function(records, containmentData, removeWhich)
    local normalizedMode, removedPositions, certificates, edge,
          removedPosition, keptPosition, keptPositions;

    if not IsList(records) then
        Error("The first argument must be the original record list.");
    fi;
    if not IsRecord(containmentData)
       or not IsBound(containmentData.embeddedEdges) then
        Error("The second argument must be a containment-search result.");
    fi;
    if IsBound(containmentData.recordCount)
       and containmentData.recordCount <> Length(records) then
        Error("The record list does not match the containment result.");
    fi;

    if removeWhich = "smaller" or removeWhich = "smaller_group" then
        normalizedMode := "smaller_group";
    elif removeWhich = "larger" or removeWhich = "larger_group" then
        normalizedMode := "larger_group";
    else
        Error(
            "removeWhich must be smaller_group or larger_group."
        );
    fi;

    removedPositions := [];
    certificates := [];
    for edge in containmentData.embeddedEdges do
        if edge.sourceOrder < edge.targetOrder then
            if normalizedMode = "smaller_group" then
                removedPosition := edge.sourcePosition;
                keptPosition := edge.targetPosition;
            else
                removedPosition := edge.targetPosition;
                keptPosition := edge.sourcePosition;
            fi;
        elif edge.sourceOrder = edge.targetOrder then
            # Equal-order embeddings are conjugacies.  Keep the earlier input
            # record deterministically, independently of the removal mode.
            removedPosition := Maximum(
                edge.sourcePosition,
                edge.targetPosition
            );
            keptPosition := Minimum(
                edge.sourcePosition,
                edge.targetPosition
            );
        else
            Error("Containment edge orientation is inconsistent with orders.");
        fi;

        Add(removedPositions, removedPosition);
        Add(certificates, rec(
            removedPosition := removedPosition,
            keptPosition := keptPosition,
            edge := edge
        ));
    od;

    removedPositions := Set(removedPositions);
    keptPositions := Difference(
        [ 1 .. Length(records) ],
        removedPositions
    );

    return rec(
        removalMode := normalizedMode,
        originalCount := Length(records),
        remainingCount := Length(keptPositions),
        removedCount := Length(removedPositions),
        keptPositions := keptPositions,
        removedPositions := removedPositions,
        remainingRecords := records{keptPositions},
        removedRecords := records{removedPositions},
        removalCertificates := certificates
    );
end;


CF_ContainmentFilteredList := function(records, containmentData, removeWhich)
    return CF_StripListByContainment(
        records,
        containmentData,
        removeWhich
    ).remainingRecords;
end;


#############################################################################
## Public search entries
#############################################################################

CF_ContainmentsEqualDimension := function(data, arg...)
    local prepared;

    prepared := CF_AsContainmentPreparation(data);
    return CF_SearchContainmentPairs(
        prepared,
        true,
        CF_ContainmentSearchOptions(arg)
    );
end;


## Preferred entry point for large catalogues.  Unlike
## CF_ContainmentsEqualDimension, this does not require an eager call to
## CF_PrepareContainmentRecords.
CF_ContainmentsEqualDimensionLazy := function(data, arg...)
    return CF_SearchContainmentPairsLazy(
        data,
        true,
        CF_ContainmentSearchOptions(arg)
    );
end;


CF_ContainmentsAllDimensions := function(data, arg...)
    local prepared, result, records, maximalData;

    prepared := CF_AsContainmentPreparation(data);
    result := CF_SearchContainmentPairs(
        prepared,
        false,
        CF_ContainmentSearchOptions(arg)
    );
    records := List(prepared.entries, entry -> entry.record);
    maximalData := CF_StripListByContainment(
        records,
        result,
        "smaller_group"
    );

    # This is the full proved relation, not only its transitive reduction.
    result.containmentPairs := result.embeddedEdges;
    result.maximalRecords := maximalData.remainingRecords;
    result.maximalPositions := maximalData.keptPositions;
    result.maximalKeys := List(
        maximalData.keptPositions,
        position -> prepared.entries[position].key
    );
    result.maximalCount := maximalData.remainingCount;
    result.maximaComplete := result.undecidedCount = 0;
    result.maximalReduction := maximalData;

    return result;
end;
