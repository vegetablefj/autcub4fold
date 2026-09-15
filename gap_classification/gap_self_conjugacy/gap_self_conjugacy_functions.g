#############################################################################
## Exact helpers for complex self-conjugacy of finite linear groups.
##
## A fully verified positive result contains an exact matrix P satisfying
##
##     P^-1 * H * P = conjugate(H).
##
## The optional cubic-space check verifies that F(x P^-1) carries the
## supplied H-invariant cubic space to its coefficientwise conjugate.
## This identifies the families, not each member with its own conjugate.
#############################################################################

if not IsBound(FindInvertibleIntertwiner)
   or not IsBound(CF_MonomialImageVector) then
    if IsExistingFile("../gap_functions.g") then
        Read("../gap_functions.g");
    elif IsExistingFile("gap_functions.g") then
        Read("gap_functions.g");
    elif IsExistingFile("gap_classification/gap_functions.g") then
        Read("gap_classification/gap_functions.g");
    else
        Error("Cannot find gap_functions.g.");
    fi;
fi;


CF_SC_ComplexConjugateScalar := function(value)
    if not IsCyc(value) then
        Error("Complex-conjugacy input must have cyclotomic entries.");
    fi;
    return GaloisCyc(value, -1);
end;


CF_SC_ComplexConjugateMatrix := function(matrix)
    if not IsMatrix(matrix) then
        Error("A matrix is required.");
    fi;
    return List(
        matrix,
        row -> List(row, CF_SC_ComplexConjugateScalar)
    );
end;


CF_SC_ComplexConjugateMatrices := function(matrices)
    if not IsList(matrices) then
        Error("A list of matrices is required.");
    fi;
    return List(matrices, CF_SC_ComplexConjugateMatrix);
end;


CF_SC_IsScalarMatrix := function(matrix)
    local n, scalar, i, j;
    if not IsMatrix(matrix) then
        return false;
    fi;
    n := Length(matrix);
    if n = 0 or ForAny(matrix, row -> Length(row) <> n) then
        return false;
    fi;
    scalar := matrix[1][1];
    for i in [1 .. n] do
        for j in [1 .. n] do
            if (i = j and matrix[i][j] <> scalar)
               or (i <> j and matrix[i][j] <> 0) then
                return false;
            fi;
        od;
    od;
    return true;
end;


CF_SC_VerifyLinearWitness := function(
    sourceGenerators,
    targetGenerators,
    conjugatingMatrix
)
    local sourceGroup, targetGroup, imageGroup, inverse, images;

    if Length(sourceGenerators) = 0 or Length(targetGenerators) = 0 then
        return rec(verified := false, reason := "empty_generators");
    fi;
    if IsZero(DeterminantMat(conjugatingMatrix)) then
        return rec(verified := false, reason := "singular_matrix");
    fi;

    sourceGroup := Group(sourceGenerators);
    targetGroup := Group(targetGenerators);
    inverse := conjugatingMatrix^-1;
    images := List(
        sourceGenerators,
        generator -> inverse * generator * conjugatingMatrix
    );
    if not ForAll(images, image -> image in targetGroup) then
        return rec(
            verified := false,
            reason := "generator_image_outside_target",
            generatorImages := images
        );
    fi;

    imageGroup := Group(images);
    if Size(sourceGroup) <> Size(targetGroup)
       or Size(imageGroup) <> Size(targetGroup) then
        return rec(
            verified := false,
            reason := "group_order_mismatch",
            generatorImages := images
        );
    fi;

    return rec(
        verified := true,
        reason := "exact_generator_and_order_check",
        generatorImages := images,
        sourceOrder := Size(sourceGroup),
        targetOrder := Size(targetGroup)
    );
end;


CF_SC_DefaultOptions := function()
    return rec(
        trySetwiseEqualityFirst := true,
        maximumAutomorphisms := infinity,
        progressInterval := 0,
        printProgress := false
    );
end;


CF_SC_MergeOptions := function(options)
    local merged, name;
    if not IsRecord(options) then
        Error("Self-conjugacy options must be a record.");
    fi;
    merged := CF_SC_DefaultOptions();
    for name in RecNames(options) do
        if not name in RecNames(merged) then
            Error("Unknown self-conjugacy option: ", name, ".");
        fi;
        merged.(name) := options.(name);
    od;
    if merged.trySetwiseEqualityFirst <> true
       and merged.trySetwiseEqualityFirst <> false then
        Error("trySetwiseEqualityFirst must be boolean.");
    fi;
    if merged.printProgress <> true and merged.printProgress <> false then
        Error("printProgress must be boolean.");
    fi;
    if merged.maximumAutomorphisms <> infinity
       and (not IsInt(merged.maximumAutomorphisms)
            or merged.maximumAutomorphisms < 1) then
        Error("maximumAutomorphisms must be positive or infinity.");
    fi;
    if not IsInt(merged.progressInterval)
       or merged.progressInterval < 0 then
        Error("progressInterval must be a nonnegative integer.");
    fi;
    return merged;
end;


CF_SC_ScalarConstraintData := function(
    generators,
    permutationIsomorphism
)
    local constraints, generator, conjugate;
    constraints := [];
    for generator in generators do
        if CF_SC_IsScalarMatrix(generator) then
            conjugate := CF_SC_ComplexConjugateMatrix(generator);
            if not conjugate in Group(generators) then
                Error("The conjugate scalar is not in the source group.");
            fi;
            Add(
                constraints,
                rec(
                    source := Image(permutationIsomorphism, generator),
                    requiredImage := Image(
                        permutationIsomorphism,
                        conjugate
                    )
                )
            );
        fi;
    od;
    return constraints;
end;


CF_SC_AutomorphismPassesScalarConstraints := function(
    automorphism,
    constraints
)
    return ForAll(
        constraints,
        constraint -> Image(automorphism, constraint.source)
                      = constraint.requiredImage
    );
end;


CF_SC_CharacterMatchesAutomorphism := function(
    automorphism,
    classRepresentatives,
    sourceClassTraces,
    permutationIsomorphism
)
    local position, element, targetTrace;
    for position in [1 .. Length(classRepresentatives)] do
        element := PreImagesRepresentative(
            permutationIsomorphism,
            Image(automorphism, classRepresentatives[position])
        );
        targetTrace := CF_SC_ComplexConjugateScalar(TraceMat(element));
        if sourceClassTraces[position] <> targetTrace then
            return false;
        fi;
    od;
    return true;
end;


CF_SC_AutomorphismGeneratorImages := function(
    automorphism,
    sourceGenerators,
    permutationIsomorphism
)
    return List(
        sourceGenerators,
        generator -> CF_SC_ComplexConjugateMatrix(
            PreImagesRepresentative(
                permutationIsomorphism,
                Image(
                    automorphism,
                    Image(permutationIsomorphism, generator)
                )
            )
        )
    );
end;


## The search is exhaustive unless maximumAutomorphisms imposes a cap.
## A negative result is returned only after all automorphisms have failed the
## exact character test.  A character match without a recovered matrix is
## recorded separately and is not promoted to a matrix certificate.
CF_SC_TestLinearGroupSelfConjugacy := function(arg)
    local sourceGenerators, options, sourceGroup, conjugateGenerators,
          conjugateGroup, n, identity, directVerification,
          permutationIsomorphism, permutationGroup,
          classRepresentatives, sourceClassTraces, constraints,
          automorphismGroup, automorphism, tested, scalarCompatible,
          characterCompatible, matchingAutomorphisms, images, matrix,
          verification, capped;

    if Length(arg) < 1 or Length(arg) > 2 then
        Error("Use CF_SC_TestLinearGroupSelfConjugacy(generators[, options]).");
    fi;
    sourceGenerators := arg[1];
    if Length(arg) = 2 then
        options := CF_SC_MergeOptions(arg[2]);
    else
        options := CF_SC_DefaultOptions();
    fi;
    if not IsList(sourceGenerators) or Length(sourceGenerators) = 0 then
        Error("A nonempty matrix-generator list is required.");
    fi;
    n := CF_MatrixListDimension(sourceGenerators);
    if n = fail
       or not ForAll(
           sourceGenerators,
           matrixEntry -> not IsZero(DeterminantMat(matrixEntry))
       ) then
        Error("The generators must be invertible matrices of one dimension.");
    fi;

    sourceGroup := Group(sourceGenerators);
    if not IsFinite(sourceGroup) then
        Error("The linear group must be finite.");
    fi;
    conjugateGenerators := CF_SC_ComplexConjugateMatrices(sourceGenerators);
    conjugateGroup := Group(conjugateGenerators);
    if Size(sourceGroup) <> Size(conjugateGroup) then
        Error("Complex conjugation changed the computed group order.");
    fi;

    identity := IdentityMat(n);
    if options.trySetwiseEqualityFirst and sourceGroup = conjugateGroup then
        directVerification := CF_SC_VerifyLinearWitness(
            sourceGenerators,
            conjugateGenerators,
            identity
        );
        if not directVerification.verified then
            Error("The setwise-equality self-conjugacy check failed.");
        fi;
        return rec(
            status := "self_conjugate",
            proofType := "source group equals its conjugate in the stored coordinates",
            conjugatingMatrix := identity,
            generatorImages := directVerification.generatorImages,
            groupOrder := Size(sourceGroup),
            automorphismsTested := 0,
            scalarCompatibleAutomorphisms := 0,
            characterCompatibleAutomorphisms := 0,
            witnessVerified := true
        );
    fi;

    permutationIsomorphism := IsomorphismPermGroup(sourceGroup);
    if permutationIsomorphism = fail then
        return rec(
            status := "unknown",
            proofType := "no faithful permutation model was constructed",
            groupOrder := Size(sourceGroup),
            witnessVerified := false
        );
    fi;
    permutationGroup := Image(permutationIsomorphism);
    classRepresentatives := List(
        ConjugacyClasses(permutationGroup),
        Representative
    );
    sourceClassTraces := List(
        classRepresentatives,
        representative -> TraceMat(
            PreImagesRepresentative(
                permutationIsomorphism,
                representative
            )
        )
    );
    constraints := CF_SC_ScalarConstraintData(
        sourceGenerators,
        permutationIsomorphism
    );
    automorphismGroup := AutomorphismGroup(permutationGroup);

    tested := 0;
    scalarCompatible := 0;
    characterCompatible := 0;
    matchingAutomorphisms := 0;
    capped := false;
    for automorphism in automorphismGroup do
        if options.maximumAutomorphisms <> infinity
           and tested >= options.maximumAutomorphisms then
            capped := true;
            break;
        fi;
        tested := tested + 1;
        if options.printProgress
           and options.progressInterval > 0
           and tested mod options.progressInterval = 0 then
            Print("   self-conjugacy automorphisms tested: ", tested, "\n");
        fi;
        if not CF_SC_AutomorphismPassesScalarConstraints(
            automorphism,
            constraints
        ) then
            continue;
        fi;
        scalarCompatible := scalarCompatible + 1;
        if not CF_SC_CharacterMatchesAutomorphism(
            automorphism,
            classRepresentatives,
            sourceClassTraces,
            permutationIsomorphism
        ) then
            continue;
        fi;
        characterCompatible := characterCompatible + 1;
        images := CF_SC_AutomorphismGeneratorImages(
            automorphism,
            sourceGenerators,
            permutationIsomorphism
        );
        matrix := FindInvertibleIntertwiner(sourceGenerators, images, n);
        if matrix = fail then
            matchingAutomorphisms := matchingAutomorphisms + 1;
            continue;
        fi;
        verification := CF_SC_VerifyLinearWitness(
            sourceGenerators,
            conjugateGenerators,
            matrix
        );
        if not verification.verified then
            Error("An alleged self-conjugacy matrix failed exact verification.");
        fi;
        return rec(
            status := "self_conjugate",
            proofType := "complete abstract-automorphism character match with exact intertwiner",
            conjugatingMatrix := matrix,
            generatorImages := verification.generatorImages,
            groupOrder := Size(sourceGroup),
            automorphismsTested := tested,
            scalarCompatibleAutomorphisms := scalarCompatible,
            characterCompatibleAutomorphisms := characterCompatible,
            witnessVerified := true
        );
    od;

    if matchingAutomorphisms > 0 then
        return rec(
            status := "character_certified_no_matrix",
            proofType := "a complete character match was found but no explicit invertible intertwiner was recovered",
            groupOrder := Size(sourceGroup),
            automorphismsTested := tested,
            scalarCompatibleAutomorphisms := scalarCompatible,
            characterCompatibleAutomorphisms := characterCompatible,
            witnessVerified := false,
            searchCapped := capped
        );
    fi;
    if capped then
        return rec(
            status := "unknown",
            proofType := "the automorphism search reached its user-supplied cap",
            groupOrder := Size(sourceGroup),
            automorphismsTested := tested,
            scalarCompatibleAutomorphisms := scalarCompatible,
            characterCompatibleAutomorphisms := characterCompatible,
            witnessVerified := false,
            searchCapped := true
        );
    fi;
    return rec(
        status := "not_self_conjugate",
        proofType := "all abstract automorphisms fail the exact natural-character comparison",
        groupOrder := Size(sourceGroup),
        automorphismsTested := tested,
        scalarCompatibleAutomorphisms := scalarCompatible,
        characterCompatibleAutomorphisms := characterCompatible,
        witnessVerified := false,
        searchCapped := false
    );
end;


CF_SC_TransformCubicCoefficientVector := function(
    vector,
    matrix,
    exponentBasis
)
    local monomialImages, answer, sourcePosition, targetPosition;
    if Length(vector) <> Length(exponentBasis) then
        Error("The cubic vector and monomial basis have different lengths.");
    fi;
    monomialImages := List(
        exponentBasis,
        exponent -> CF_MonomialImageVector(
            exponent,
            matrix,
            exponentBasis
        )
    );
    answer := List([1 .. Length(exponentBasis)], position -> 0);
    for sourcePosition in [1 .. Length(vector)] do
        if vector[sourcePosition] <> 0 then
            for targetPosition in [1 .. Length(answer)] do
                answer[targetPosition] := answer[targetPosition]
                    + vector[sourcePosition]
                      * monomialImages[sourcePosition][targetPosition];
            od;
        fi;
    od;
    return answer;
end;


## If P^-1 H P = conjugate(H), then F(x P^-1) carries W^H to
## conjugate(W^H).  The returned basisMap expresses those transformed source
## basis vectors in the coefficientwise conjugate target basis.
CF_SC_VerifyCubicSpaceWitness := function(
    sourceBasis,
    exponentBasis,
    conjugatingMatrix
)
    local targetBasis, transformedBasis, basisMap, vector, coordinates;
    if Length(sourceBasis) = 0 then
        return rec(verified := false, reason := "empty_cubic_space");
    fi;
    targetBasis := List(
        sourceBasis,
        row -> List(row, CF_SC_ComplexConjugateScalar)
    );
    transformedBasis := List(
        sourceBasis,
        row -> CF_SC_TransformCubicCoefficientVector(
            row,
            conjugatingMatrix^-1,
            exponentBasis
        )
    );
    if RankMat(targetBasis) <> Length(targetBasis)
       or RankMat(transformedBasis) <> Length(sourceBasis) then
        return rec(
            verified := false,
            reason := "basis_rank_failure",
            transformedBasis := transformedBasis
        );
    fi;
    basisMap := [];
    for vector in transformedBasis do
        coordinates := SolutionMat(targetBasis, vector);
        if coordinates = fail
           or coordinates * targetBasis <> vector then
            return rec(
                verified := false,
                reason := "transformed_cubic_outside_conjugate_space",
                transformedBasis := transformedBasis
            );
        fi;
        Add(basisMap, coordinates);
    od;
    if IsZero(DeterminantMat(basisMap)) then
        return rec(
            verified := false,
            reason := "singular_induced_basis_map",
            transformedBasis := transformedBasis,
            basisMap := basisMap
        );
    fi;
    return rec(
        verified := true,
        reason := "exact_cubic_basis_identification",
        basisMap := basisMap
    );
end;


CF_SC_TestFamilySelfConjugacy := function(arg)
    local generators, cubicBasis, exponentBasis, options, linearResult,
          cubicResult;
    if Length(arg) < 3 or Length(arg) > 4 then
        Error(
            "Use CF_SC_TestFamilySelfConjugacy(generators, cubicBasis, ",
            "exponentBasis[, options])."
        );
    fi;
    generators := arg[1];
    cubicBasis := arg[2];
    exponentBasis := arg[3];
    if Length(arg) = 4 then
        options := arg[4];
    else
        options := rec();
    fi;
    linearResult := CF_SC_TestLinearGroupSelfConjugacy(
        generators,
        options
    );
    if linearResult.status <> "self_conjugate"
       or not linearResult.witnessVerified then
        linearResult.cubicSpaceVerified := false;
        linearResult.cubicSpaceCertificate := rec(status := "not_run");
        return linearResult;
    fi;
    cubicResult := CF_SC_VerifyCubicSpaceWitness(
        cubicBasis,
        exponentBasis,
        linearResult.conjugatingMatrix
    );
    linearResult.cubicSpaceVerified := cubicResult.verified;
    linearResult.cubicSpaceCertificate := cubicResult;
    if not cubicResult.verified then
        linearResult.status := "linear_only_family_check_failed";
    fi;
    return linearResult;
end;
