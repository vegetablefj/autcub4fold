#############################################################################
## Exact comparison of computed matrix groups with canonical presentations.
## Coarse metadata only partitions the search; every accepted correspondence
## is certified by exact linear conjugacy.
#############################################################################

CF_CP_CoarseSignature := function(record)
    return [
        record.rankS,
        record.symplecticPart,
        record.genericIndex,
        record.fullIndex,
        record.familyDimension,
        record.projectiveGroupId
    ];
end;


CF_CP_PositionsWithSignature := function(positions, catalogue, signature)
    return Filtered(
        positions,
        position -> CF_CP_CoarseSignature(catalogue[position]) = signature
    );
end;


CF_CP_ComputedCatalogue := function(presentations, candidates)
    local catalogue, presentation, matches, candidate;

    catalogue := [];
    for presentation in presentations do
        matches := Filtered(
            candidates,
            candidate -> candidate.sourceKey = presentation.sourceKey
        );
        if Length(matches) <> 1 then
            Error(
                "The source key does not identify one computed family: ",
                presentation.sourceKey, "."
            );
        fi;
        candidate := matches[1];
        if candidate.projectiveGroupId <> presentation.projectiveGroupId
           or candidate.linearGroupId <> presentation.linearGroupId
           or candidate.familyDimension <> presentation.familyDimension
           or candidate.symplecticPart <> presentation.symplecticPart then
            Error(
                "Computed and presentation metadata disagree at row ",
                presentation.number, "."
            );
        fi;
        Add(catalogue, rec(
            position := Length(catalogue) + 1,
            intendedNumber := presentation.number,
            sourceKey := candidate.sourceKey,
            rankS := presentation.rankS,
            symplecticPart := presentation.symplecticPart,
            genericIndex := presentation.genericIndex,
            fullIndex := presentation.fullIndex,
            familyDimension := presentation.familyDimension,
            projectiveGroupId := candidate.projectiveGroupId,
            linearGroupId := candidate.linearGroupId,
            generators := candidate.matrixGenerators,
            groupInternal := Group(candidate.matrixGenerators),
            strictInfoInternal := fail
        ));
    od;
    return catalogue;
end;


CF_CP_PresentationCatalogue := function(presentations)
    local catalogue, presentation;

    catalogue := [];
    for presentation in presentations do
        Add(catalogue, rec(
            position := Length(catalogue) + 1,
            number := presentation.number,
            sourceKey := presentation.sourceKey,
            rankS := presentation.rankS,
            symplecticPart := presentation.symplecticPart,
            genericIndex := presentation.genericIndex,
            fullIndex := presentation.fullIndex,
            familyDimension := presentation.familyDimension,
            projectiveGroupId := presentation.projectiveGroupId,
            linearGroupId := presentation.linearGroupId,
            generators := presentation.matrixGenerators,
            groupInternal := Group(presentation.matrixGenerators),
            strictInfoInternal := fail,
            sourceToCanonicalMatrix :=
                presentation.sourceToStandardMatrix,
            canonicalToSourceMatrix :=
                presentation.standardToSourceMatrix,
            coordinateWitnessType := presentation.witnessType
        ));
    od;
    return catalogue;
end;


CF_CP_StrictInfo := function(entry)
    if entry.strictInfoInternal = fail then
        entry.strictInfoInternal := PreprocessMatrixGroupStrict(
            entry.generators,
            entry.linearGroupId[1],
            entry.linearGroupId
        );
    fi;
    return entry.strictInfoInternal;
end;


## SearchEmbeddingStrict uses P^-1*G*P.  The stored matrix follows the same
## convention when the computed group is the source.
CF_CP_VerifyStoredCoordinateWitness := function(computed, presentation)
    local P, imageGenerators;

    if computed.sourceKey <> presentation.sourceKey then
        return false;
    fi;
    P := presentation.sourceToCanonicalMatrix;
    if P = fail or IsZero(DeterminantMat(P)) then
        return false;
    fi;
    imageGenerators := List(
        computed.generators,
        generator -> P^-1 * generator * P
    );
    return ForAll(
        imageGenerators,
        generator -> generator in presentation.groupInternal
    ) and Size(computed.groupInternal) = Size(presentation.groupInternal);
end;


CF_CP_TestPair := function(computed, presentation)
    local computedGenerators, presentationGenerators, diagonalSearch, search;

    if Size(computed.groupInternal) <> Size(presentation.groupInternal) then
        return rec(
            status := "not_equivalent",
            method := "order",
            reason := "different_linear_group_orders",
            P := fail
        );
    fi;
    if computed.groupInternal = presentation.groupInternal then
        return rec(
            status := "equivalent",
            method := "literal_matrix_equality",
            reason := "equal_matrix_groups",
            P := IdentityMat(6)
        );
    fi;
    if CF_CP_VerifyStoredCoordinateWitness(computed, presentation) then
        return rec(
            status := "equivalent",
            method := "recorded_coordinate_witness",
            reason := presentation.coordinateWitnessType,
            P := presentation.sourceToCanonicalMatrix
        );
    fi;

    computedGenerators := GeneratorsOfGroup(computed.groupInternal);
    presentationGenerators :=
        GeneratorsOfGroup(presentation.groupInternal);
    if IsAbelian(computed.groupInternal)
       and IsAbelian(presentation.groupInternal)
       and ForAll(computedGenerators, IsDiagonalMatrix)
       and ForAll(presentationGenerators, IsDiagonalMatrix) then
        diagonalSearch := CF_SearchDiagonalConjugacyEmbedding(
            computed.groupInternal,
            presentation.groupInternal
        );
        if diagonalSearch.ok = true then
            return rec(
                status := "equivalent",
                method := diagonalSearch.method,
                reason := diagonalSearch.reason,
                P := diagonalSearch.P
            );
        fi;
        return rec(
            status := "not_equivalent",
            method := diagonalSearch.method,
            reason := diagonalSearch.reason,
            P := fail
        );
    fi;

    search := SearchEmbeddingStrict(
        CF_CP_StrictInfo(computed),
        CF_CP_StrictInfo(presentation),
        rec(
            stop_first := true,
            construct_witness := true,
            try_literal_inclusion := true,
            use_fingerprints := true,
            allow_hard_iso := true
        )
    );
    if search.ok = true then
        return rec(
            status := "equivalent",
            method := search.method,
            reason := search.reason,
            P := search.P
        );
    elif search.ok = false then
        return rec(
            status := "not_equivalent",
            method := search.method,
            reason := search.reason,
            P := fail
        );
    fi;
    return rec(
        status := "undecided",
        method := search.method,
        reason := search.reason,
        P := fail
    );
end;


CF_CP_PublicPairResult := function(
    computedPosition,
    presentationPosition,
    result
)
    return rec(
        computedPosition := computedPosition,
        presentationPosition := presentationPosition,
        status := result.status,
        method := result.method,
        reason := result.reason,
        P := result.P
    );
end;


CF_CP_RemoveInternalData := function(catalogue)
    return List(catalogue, entry -> rec(
        position := entry.position,
        number := entry.intendedNumber,
        sourceKey := entry.sourceKey,
        rankS := entry.rankS,
        symplecticPart := entry.symplecticPart,
        genericIndex := entry.genericIndex,
        fullIndex := entry.fullIndex,
        familyDimension := entry.familyDimension,
        projectiveGroupId := entry.projectiveGroupId,
        linearGroupId := entry.linearGroupId
    ));
end;


CF_CP_JoinStrings := function(strings, separator)
    local result, position;

    result := "";
    for position in [1 .. Length(strings)] do
        if position > 1 then
            result := Concatenation(result, separator);
        fi;
        result := Concatenation(result, strings[position]);
    od;
    return result;
end;
