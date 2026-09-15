#############################################################################
## Put a family into standard Koike symplectic coordinates.
##
## The returned record contains an exact coordinate witness and, when the
## determinant quotient is nontrivial, one additional generator.  Loading
## this file defines functions only; the audit and catalogue builder are
## separate entry points.
#############################################################################

CF_UNI_Paths := function()
    if IsExistingFile("gap_uniformization_standard_groups.g") then
        return rec(
            uniformizationDirectory := "",
            classificationDirectory := "../"
        );
    fi;
    if IsExistingFile(
        "gap_classification/gap_uniformization/gap_uniformization_standard_groups.g"
    ) then
        return rec(
            uniformizationDirectory :=
                "gap_classification/gap_uniformization/",
            classificationDirectory := "gap_classification/"
        );
    fi;
    Error("Run from the repository root or gap_uniformization directory.");
end;


CF_UNI_PathRecord := CF_UNI_Paths();
if not IsBound(UniformizationStandardGroups) then
    Read(Concatenation(
        CF_UNI_PathRecord.uniformizationDirectory,
        "gap_uniformization_standard_groups.g"
    ));
fi;
if not IsBound(SearchEmbeddingStrict) then
    Read(Concatenation(
        CF_UNI_PathRecord.classificationDirectory,
        "gap_functions.g"
    ));
fi;


CF_UNI_CandidateGenerators := function(candidate)
    if IsBound(candidate.matrixGenerators) then
        return candidate.matrixGenerators;
    elif IsBound(candidate.generators) then
        return candidate.generators;
    elif IsBound(candidate.linearGenerators) then
        return candidate.linearGenerators;
    fi;
    Error("The family record has no matrix-generator list.");
end;


CF_UNI_CandidateKey := function(candidate)
    if IsBound(candidate.sourceKey) then
        return candidate.sourceKey;
    elif IsBound(candidate.label) then
        return candidate.label;
    fi;
    return "unnamed-family";
end;


CF_UNI_DeterminantKernelInfo := function(generators)
    local fullGroup, kernelGroup;

    fullGroup := Group(generators);
    kernelGroup := Group(Filtered(
        Elements(fullGroup),
        element -> DeterminantMat(element) = 1
    ));

    return rec(
        fullGroup := fullGroup,
        fullOrder := Size(fullGroup),
        kernelGroup := kernelGroup,
        kernelOrder := Size(kernelGroup),
        kernelGenerators := GeneratorsOfGroup(kernelGroup),
        quotientOrder := Size(fullGroup) / Size(kernelGroup)
    );
end;


## Return P with P^-1 * standard * P contained in source, if literal
## containment or a coordinate permutation already gives the embedding.
CF_UNI_FindPermutationEmbeddingWitness := function(
    standardGenerators,
    sourceGroup
)
    local permutation, matrix, conjugatedGenerators;

    if ForAll(
        standardGenerators,
        generator -> generator in sourceGroup
    ) then
        return rec(
            found := true,
            witnessType := "literal_inclusion",
            permutation := (),
            matrix := IdentityMat(6)
        );
    fi;

    for permutation in Elements(SymmetricGroup(6)) do
        matrix := PermutationMat(permutation, 6);
        conjugatedGenerators := List(
            standardGenerators,
            generator -> matrix^-1 * generator * matrix
        );
        if ForAll(
            conjugatedGenerators,
            generator -> generator in sourceGroup
        ) then
            return rec(
                found := true,
                witnessType := "coordinate_permutation_inclusion",
                permutation := permutation,
                matrix := matrix
            );
        fi;
    od;

    return rec(found := false);
end;


CF_UNI_FindStandardWitness := function(candidate, kernelInfo)
    local possibleStandards, standard, sourceFullInfo, genericInfo,
          genericPermutation, genericSearch;

    possibleStandards := UniformizationStandardGroups;
    if IsBound(candidate.symplecticPart) then
        possibleStandards := Filtered(
            possibleStandards,
            record -> record.symplecticPart = candidate.symplecticPart
        );
    fi;
    possibleStandards := Filtered(
        possibleStandards,
        record -> record.strictSymplecticOrder = kernelInfo.kernelOrder
                  and IsInt(
                      kernelInfo.fullOrder
                      / record.strictGenericFullOrder
                  )
                  and IsInt(
                      kernelInfo.quotientOrder / record.genericIndex
                  )
    );

    sourceFullInfo := fail;

    for standard in possibleStandards do
        genericPermutation := CF_UNI_FindPermutationEmbeddingWitness(
            standard.strictGenericFullGenerators,
            kernelInfo.fullGroup
        );
        if genericPermutation.found then
            return rec(
                found := true,
                standard := standard,
                witnessType := Concatenation(
                    "generic_full_",
                    genericPermutation.witnessType
                ),
                permutation := genericPermutation.permutation,
                P := genericPermutation.matrix,
                search := fail
            );
        fi;

        genericInfo := PreprocessMatrixGroupStrict(
            standard.strictGenericFullGenerators,
            standard.strictGenericFullOrder,
            fail
        );
        if sourceFullInfo = fail then
            sourceFullInfo := PreprocessMatrixGroupStrict(
                GeneratorsOfGroup(kernelInfo.fullGroup),
                kernelInfo.fullOrder,
                fail
            );
        fi;
        genericSearch := SearchEmbeddingStrict(
            genericInfo,
            sourceFullInfo,
            rec(
                stop_first := true,
                construct_witness := true,
                try_literal_inclusion := false,
                allow_hard_iso := true
            )
        );
        if genericSearch.ok = true
           and IsBound(genericSearch.P)
           and genericSearch.P <> fail then
            return rec(
                found := true,
                standard := standard,
                witnessType := "generic_full_linear_embedding",
                permutation := fail,
                P := genericSearch.P,
                search := genericSearch
            );
        fi;
    od;

    return rec(
        found := false,
        reason := "no_explicit_generic_full_group_embedding_witness"
    );
end;


CF_UNI_QuotientGeneratorCandidate := function(
    element,
    standardGenericGroup,
    standardizedFullGroup,
    fullIndex,
    origin,
    position
)
    local generatedGroup;

    if Order(DeterminantMat(element)) <> fullIndex then
        return fail;
    fi;
    generatedGroup := Group(Concatenation(
        GeneratorsOfGroup(standardGenericGroup),
        [element]
    ));
    if generatedGroup <> standardizedFullGroup then
        return fail;
    fi;

    return rec(
        element := element,
        origin := origin,
        position := position
    );
end;


CF_UNI_SelectQuotientGenerator := function(
    standard,
    standardizedFullGroup,
    transformedInputGenerators,
    fullIndex,
    relativeQuotientOrder
)
    local position, result, element;

    if relativeQuotientOrder = 1 then
        return rec(
            found := true,
            element := fail,
            origin := "not_needed",
            position := fail
        );
    fi;

    for position in [1 .. Length(transformedInputGenerators)] do
        result := CF_UNI_QuotientGeneratorCandidate(
            transformedInputGenerators[position],
            standard.strictGenericFullGroup,
            standardizedFullGroup,
            fullIndex,
            "transformed_input_generator",
            position
        );
        if result <> fail then
            result.found := true;
            return result;
        fi;
    od;

    for element in Elements(standardizedFullGroup) do
        result := CF_UNI_QuotientGeneratorCandidate(
            element,
            standard.strictGenericFullGroup,
            standardizedFullGroup,
            fullIndex,
            "standardized_group_element",
            fail
        );
        if result <> fail then
            result.found := true;
            return result;
        fi;
    od;

    return rec(
        found := false,
        reason := "no_single_generator_over_standard_generic_group"
    );
end;


CF_UNI_UniformizeFamily := function(candidate)
    local inputGenerators, kernelInfo, witness, standard, P,
          sourceToStandard, transformedInputGenerators,
          standardizedFullGroup, transformedKernel,
          quotientGenerator, outputGenerators, generatedOutputGroup,
          extraSourceCoordinates, relativeQuotientOrder,
          genericGroupContained;

    inputGenerators := CF_UNI_CandidateGenerators(candidate);
    kernelInfo := CF_UNI_DeterminantKernelInfo(inputGenerators);
    witness := CF_UNI_FindStandardWitness(candidate, kernelInfo);
    if not witness.found then
        return rec(
            status := "not_uniformized",
            sourceKey := CF_UNI_CandidateKey(candidate),
            reason := witness.reason
        );
    fi;

    standard := witness.standard;
    P := witness.P;
    sourceToStandard := P^-1;
    transformedInputGenerators := List(
        inputGenerators,
        generator -> P * generator * P^-1
    );
    standardizedFullGroup := Group(transformedInputGenerators);
    transformedKernel := Group(List(
        kernelInfo.kernelGenerators,
        generator -> P * generator * P^-1
    ));
    if transformedKernel <> standard.strictSymplecticGroup then
        Error("The computed witness does not standardize the determinant kernel.");
    fi;
    genericGroupContained := ForAll(
        standard.strictGenericFullGenerators,
        generator -> generator in standardizedFullGroup
    );
    if not genericGroupContained then
        Error("The transformed group does not contain the standard generic group.");
    fi;
    relativeQuotientOrder :=
        kernelInfo.fullOrder / standard.strictGenericFullOrder;
    if not IsInt(relativeQuotientOrder)
       or kernelInfo.quotientOrder
            <> standard.genericIndex * relativeQuotientOrder then
        Error("The relative generic-group quotient has the wrong order.");
    fi;

    quotientGenerator := CF_UNI_SelectQuotientGenerator(
        standard,
        standardizedFullGroup,
        transformedInputGenerators,
        kernelInfo.quotientOrder,
        relativeQuotientOrder
    );
    if not quotientGenerator.found then
        return rec(
            status := "not_uniformized",
            sourceKey := CF_UNI_CandidateKey(candidate),
            standardKey := standard.key,
            reason := quotientGenerator.reason,
            standardWitness := witness
        );
    fi;

    outputGenerators := ShallowCopy(standard.strictGenericFullGenerators);
    extraSourceCoordinates := fail;
    if quotientGenerator.element <> fail then
        Add(outputGenerators, quotientGenerator.element);
        extraSourceCoordinates :=
            P^-1 * quotientGenerator.element * P;
    fi;
    generatedOutputGroup := Group(outputGenerators);
    if generatedOutputGroup <> standardizedFullGroup then
        Error("The uniformized generators do not recover the full group.");
    fi;

    return rec(
        status := "uniformized",
        sourceKey := CF_UNI_CandidateKey(candidate),
        standardKey := standard.key,
        standardLabel := standard.label,
        koikeReference := standard.koikeReference,
        symplecticPart := standard.symplecticPart,
        fullOrder := kernelInfo.fullOrder,
        symplecticKernelOrder := kernelInfo.kernelOrder,
        genericIndex := standard.genericIndex,
        fullIndex := kernelInfo.quotientOrder,
        relativeQuotientOrder := relativeQuotientOrder,
        witnessType := witness.witnessType,
        permutation := witness.permutation,
        standardToSourceMatrix := P,
        sourceToStandardMatrix := sourceToStandard,
        standardSymplecticGenerators :=
            standard.strictSymplecticGenerators,
        standardGenericFullGenerators :=
            standard.strictGenericFullGenerators,
        extraGenerator := quotientGenerator.element,
        extraGeneratorInSourceCoordinates := extraSourceCoordinates,
        extraGeneratorOrigin := quotientGenerator.origin,
        extraGeneratorOriginPosition := quotientGenerator.position,
        uniformizedGenerators := outputGenerators,
        determinantKernelVerified :=
            transformedKernel = standard.strictSymplecticGroup,
        genericFullGroupContainedVerified := genericGroupContained,
        fullGroupVerified := generatedOutputGroup = standardizedFullGroup,
        equalsStandardGenericFullGroup :=
            relativeQuotientOrder = 1
    );
end;


CF_UNI_CompactResult := function(result)
    if result.status <> "uniformized" then
        return result;
    fi;
    return rec(
        status := result.status,
        sourceKey := result.sourceKey,
        standardKey := result.standardKey,
        standardLabel := result.standardLabel,
        koikeReference := result.koikeReference,
        symplecticPart := result.symplecticPart,
        fullOrder := result.fullOrder,
        symplecticKernelOrder := result.symplecticKernelOrder,
        genericIndex := result.genericIndex,
        fullIndex := result.fullIndex,
        relativeQuotientOrder := result.relativeQuotientOrder,
        witnessType := result.witnessType,
        permutation := result.permutation,
        standardToSourceMatrix := result.standardToSourceMatrix,
        sourceToStandardMatrix := result.sourceToStandardMatrix,
        standardSymplecticGenerators := result.standardSymplecticGenerators,
        standardGenericFullGenerators :=
            result.standardGenericFullGenerators,
        extraGenerator := result.extraGenerator,
        extraGeneratorInSourceCoordinates :=
            result.extraGeneratorInSourceCoordinates,
        extraGeneratorOrigin := result.extraGeneratorOrigin,
        extraGeneratorOriginPosition := result.extraGeneratorOriginPosition,
        uniformizedGenerators := result.uniformizedGenerators,
        determinantKernelVerified := result.determinantKernelVerified,
        genericFullGroupContainedVerified :=
            result.genericFullGroupContainedVerified,
        fullGroupVerified := result.fullGroupVerified,
        equalsStandardGenericFullGroup :=
            result.equalsStandardGenericFullGroup
    );
end;
