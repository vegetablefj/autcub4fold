#############################################################################
##
## gap_threefold_functions.g
##
## Uniform extraction of cubic-threefold automorphism groups from the final
## cubic-fourfold matrix catalogue. Loading this file defines functions only.
##
## Let Fhat be smooth and Hhat = Aut(Fhat) < GL(6,C) its full strict
## stabilizer.  An element delta with
##
##     Order(delta) = 3,   Trace(delta) = 5 + E(3)
##
## scales one one-dimensional Fermat summand by E(3) and fixes its
## five-dimensional complement.  If V = Ker(delta-I), then
##
##     Aut(F) = Image(C_Hhat(delta) -> GL(V)),
##
## and the kernel of the restriction map is <delta>. Every successful result
## rechecks the relevant element, centralizer, kernel, and scalar subgroup.
## Fullness is essential. See gap_threefold_script.md for the maximal additive-splitting
## theorem and the argument that extraction needs no further saturation.
##
## This file only defines functions.  It expects gap_functions.g to have
## been read first.  It does not start a catalogue computation.
## Catalogue wrappers use the fixed fourfold search-input records, with
## standardPosition and extraGenerator. They do not accept the final
## five-dimensional family records.
##
#############################################################################


#############################################################################
## 1. Options and input construction
#############################################################################

CF_TF_ExtractionOptions := function(arg)
    local supplied, options;

    if Length(arg) > 1 then
        Error("Use CF_TF_ExtractionOptions([options]).");
    fi;

    options := rec(
        computeInvariantBasis := false,
        buildPolynomialObjects := false,
        buildPolynomialStrings := false,
        computeGroupDescriptions := false,
        directEnumerationBound := 400,
        requireExpectedFermatRanks := true,
        requireSingleFermatClass := true,
        retainNoFermatSources := true,
        printProgress := false
    );

    if Length(arg) = 0 then
        return options;
    fi;

    supplied := arg[1];
    if not IsRecord(supplied) then
        Error("The threefold-extraction options must be a record.");
    fi;

    if IsBound(supplied.computeInvariantBasis) then
        options.computeInvariantBasis := supplied.computeInvariantBasis;
    fi;
    if IsBound(supplied.buildPolynomialObjects) then
        options.buildPolynomialObjects := supplied.buildPolynomialObjects;
    fi;
    if IsBound(supplied.buildPolynomialStrings) then
        options.buildPolynomialStrings := supplied.buildPolynomialStrings;
    fi;
    if IsBound(supplied.computeGroupDescriptions) then
        options.computeGroupDescriptions := supplied.computeGroupDescriptions;
    fi;
    if IsBound(supplied.directEnumerationBound) then
        options.directEnumerationBound := supplied.directEnumerationBound;
    fi;
    if IsBound(supplied.requireExpectedFermatRanks) then
        options.requireExpectedFermatRanks :=
            supplied.requireExpectedFermatRanks;
    fi;
    if IsBound(supplied.requireSingleFermatClass) then
        options.requireSingleFermatClass :=
            supplied.requireSingleFermatClass;
    fi;
    if IsBound(supplied.retainNoFermatSources) then
        options.retainNoFermatSources := supplied.retainNoFermatSources;
    fi;
    if IsBound(supplied.printProgress) then
        options.printProgress := supplied.printProgress;
    fi;

    if not ForAll(
        [
            options.computeInvariantBasis,
            options.buildPolynomialObjects,
            options.buildPolynomialStrings,
            options.computeGroupDescriptions,
            options.requireExpectedFermatRanks,
            options.requireSingleFermatClass,
            options.retainNoFermatSources,
            options.printProgress
        ],
        value -> value = true or value = false
    ) then
        Error("Every threefold-extraction option must be boolean.");
    fi;

    if options.buildPolynomialObjects or options.buildPolynomialStrings then
        options.computeInvariantBasis := true;
    fi;
    if not IsInt(options.directEnumerationBound)
       or options.directEnumerationBound < 0 then
        Error("The direct-enumeration bound must be a nonnegative integer.");
    fi;

    return options;
end;


CF_TF_StrictGroupFromCatalogueEntry := function(family)
    local standard, generators, strictGroup, reportedOrder;

    if not IsRecord(family) or not IsBound(family.number)
       or not IsBound(family.standardPosition)
       or not IsBound(family.extraGenerator) then
        Error("A canonical family record is required.");
    fi;
    if not IsBound(CanonicalKoikeStandardGroups) then
        Error(
            "Read gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g ",
            "before constructing ",
            "a catalogue group."
        );
    fi;
    if family.standardPosition < 1
       or family.standardPosition > Length(CanonicalKoikeStandardGroups) then
        Error("Invalid standard position for family ", family.number, ".");
    fi;

    standard := CanonicalKoikeStandardGroups[family.standardPosition];
    if standard.standardPosition <> family.standardPosition
       or standard.symplecticPart <> family.symplecticPart then
        Error("The standard-family metadata are inconsistent.");
    fi;

    generators := ShallowCopy(standard.symplecticGenerators);
    if family.extraGenerator <> fail then
        Add(generators, family.extraGenerator);
    fi;
    strictGroup := Group(generators);

    reportedOrder := fail;
    if IsBound(family.linearGroupId) then
        reportedOrder := family.linearGroupId[1];
        if Size(strictGroup) <> reportedOrder then
            Error(
                "Strict group order mismatch for fourfold family ",
                family.number, "."
            );
        fi;
    fi;

    return rec(
        family := family,
        standard := standard,
        generators := generators,
        group := strictGroup,
        order := Size(strictGroup),
        reportedOrder := reportedOrder
    );
end;


CF_TF_PrepareStrictGroup := function(strictGroup)
    local identity, dimension, scalarMatrix, permutationIsomorphism,
          permutationGroup;

    if not IsGroup(strictGroup) or not IsFinite(strictGroup) then
        Error("A finite strict matrix group is required.");
    fi;

    identity := One(strictGroup);
    if not IsMatrix(identity) then
        Error("The strict group must be a matrix group.");
    fi;
    dimension := Length(identity);
    if dimension <> 6 then
        Error("The source strict group must act on six variables.");
    fi;

    scalarMatrix := E(3) * IdentityMat(6);
    if not scalarMatrix in strictGroup then
        Error("The source strict group does not contain E(3) I_6.");
    fi;

    permutationIsomorphism := IsomorphismPermGroup(strictGroup);
    if permutationIsomorphism = fail then
        Error("Could not construct a permutation model of the source group.");
    fi;
    permutationGroup := Image(permutationIsomorphism);
    if Size(permutationGroup) <> Size(strictGroup) then
        Error("The permutation model is not faithful.");
    fi;

    return rec(
        strictGroup := strictGroup,
        strictGenerators := GeneratorsOfGroup(strictGroup),
        linearOrder := Size(strictGroup),
        scalarMatrix := scalarMatrix,
        permutationIsomorphism := permutationIsomorphism,
        permutationGroup := permutationGroup
    );
end;


#############################################################################
## 2. Fermat elements
#############################################################################

CF_TF_IsFermatElement := function(matrix)
    if not IsMatrix(matrix) or Length(matrix) <> 6 then
        Error("CF_TF_IsFermatElement expects a 6 by 6 matrix.");
    fi;

    return Order(matrix) = 3 and TraceMat(matrix) = 5 + E(3);
end;


CF_TF_FermatClassData := function(prepared)
    local classes, matches, total, class, permutationRepresentative,
          matrixRepresentative, classSize;

    if not IsRecord(prepared)
       or not IsBound(prepared.permutationGroup)
       or not IsBound(prepared.permutationIsomorphism) then
        Error("Use CF_TF_PrepareStrictGroup before the class computation.");
    fi;

    classes := ConjugacyClasses(prepared.permutationGroup);
    matches := [];
    total := 0;

    for class in classes do
        permutationRepresentative := Representative(class);
        if Order(permutationRepresentative) = 3 then
            matrixRepresentative := PreImagesRepresentative(
                prepared.permutationIsomorphism,
                permutationRepresentative
            );
            if TraceMat(matrixRepresentative) = 5 + E(3) then
                classSize := Size(class);
                Add(
                    matches,
                    rec(
                        permutationClass := class,
                        permutationRepresentative :=
                            permutationRepresentative,
                        matrixRepresentative := matrixRepresentative,
                        classSize := classSize
                    )
                );
                total := total + classSize;
            fi;
        fi;
    od;

    return rec(
        classCount := Length(matches),
        classes := matches,
        elementCount := total,
        fourfoldFermatRank := total,
        hasFermatSummand := total > 0
    );
end;


#############################################################################
## 3. Centralizer restriction to the fixed five-space
#############################################################################

CF_TF_TopLeftBlock := function(matrix, blockSize)
    return List(
        [1 .. blockSize],
        row -> matrix[row]{[1 .. blockSize]}
    );
end;


CF_TF_VerifyBlockDiagonal := function(matrix, blockSize)
    local dimension;

    dimension := Length(matrix);
    if dimension <> blockSize + 1 then
        return false;
    fi;

    return ForAll(
        [1 .. blockSize],
        row -> matrix[row][dimension] = 0
    ) and ForAll(
        [1 .. blockSize],
        column -> matrix[dimension][column] = 0
    );
end;


CF_TF_RestrictMatrixCentralizer := function(
    delta,
    centralizerMatrixGenerators,
    centralizerOrder
)
    local identity6, fixedBasis, zetaBasis, changeBasis,
          inverseChangeBasis,
          conjugatedGenerators, restrictedGenerators, restrictedGroup,
          identity5, expectedRestrictedOrder,
          scalarMatrix, scalarGroup, projectiveMap, projectiveGroup,
          deltaInAdaptedBasis, deltaRestriction;

    if not CF_TF_IsFermatElement(delta) then
        Error("The selected element does not satisfy the Fermat criterion.");
    fi;
    if not IsList(centralizerMatrixGenerators)
       or Length(centralizerMatrixGenerators) = 0 then
        Error("Centralizer matrix generators are required.");
    fi;
    if not IsInt(centralizerOrder) or centralizerOrder < 3 then
        Error("The centralizer order is invalid.");
    fi;

    identity6 := IdentityMat(6);
    ## NullspaceMat returns a left nullspace.  Transposing the equations
    ## therefore gives column eigenvectors of delta, stored here as rows.
    ## The transpose of their concatenation is the usual change-of-basis
    ## matrix whose columns are the adapted basis vectors.
    fixedBasis := NullspaceMat(TransposedMat(delta - identity6));
    zetaBasis := NullspaceMat(
        TransposedMat(delta - E(3) * identity6)
    );
    if Length(fixedBasis) <> 5 or Length(zetaBasis) <> 1 then
        Error("The Fermat element does not have eigenspace dimensions 5+1.");
    fi;

    changeBasis := TransposedMat(Concatenation(fixedBasis, zetaBasis));
    if RankMat(changeBasis) <> 6 then
        Error("The two eigenspaces do not form a basis of the source space.");
    fi;
    inverseChangeBasis := Inverse(changeBasis);

    conjugatedGenerators := List(
        centralizerMatrixGenerators,
        generator -> inverseChangeBasis * generator * changeBasis
    );

    if not ForAll(
        conjugatedGenerators,
        generator -> CF_TF_VerifyBlockDiagonal(generator, 5)
    ) then
        Error("A centralizer generator does not preserve the eigenspace split.");
    fi;

    restrictedGenerators := List(
        conjugatedGenerators,
        generator -> CF_TF_TopLeftBlock(generator, 5)
    );
    identity5 := IdentityMat(5);
    restrictedGenerators := Filtered(
        restrictedGenerators,
        generator -> generator <> identity5
    );
    if Length(restrictedGenerators) = 0 then
        Error("The restricted strict group has no nontrivial generator.");
    fi;
    restrictedGroup := Group(restrictedGenerators);

    if not IsInt(centralizerOrder / 3) then
        Error("The centralizer order is not divisible by three.");
    fi;
    expectedRestrictedOrder := centralizerOrder / 3;
    if Size(restrictedGroup) <> expectedRestrictedOrder then
        Error(
            "The restriction kernel is not the expected group <delta> ",
            "of order three."
        );
    fi;

    deltaInAdaptedBasis := inverseChangeBasis * delta * changeBasis;
    deltaRestriction := CF_TF_TopLeftBlock(deltaInAdaptedBasis, 5);
    if deltaRestriction <> identity5 then
        Error("The Fermat element does not restrict trivially to its fixed space.");
    fi;

    scalarMatrix := E(3) * identity5;
    if not scalarMatrix in restrictedGroup then
        Error("The extracted strict group does not contain E(3) I_5.");
    fi;
    scalarGroup := Group([scalarMatrix]);
    if Size(scalarGroup) <> 3 or not IsCentral(restrictedGroup, scalarGroup) then
        Error("The extracted scalar subgroup is not central of order three.");
    fi;

    projectiveMap := NaturalHomomorphismByNormalSubgroup(
        restrictedGroup,
        scalarGroup
    );
    projectiveGroup := Image(projectiveMap);
    if Size(restrictedGroup) <> 3 * Size(projectiveGroup) then
        Error("The strict/projective threefold group orders are inconsistent.");
    fi;

    return rec(
        fermatElement := delta,
        fixedSpaceBasis := fixedBasis,
        zetaEigenspaceBasis := zetaBasis,
        sourceToAdaptedBasis := changeBasis,
        adaptedToSourceBasis := inverseChangeBasis,
        centralizerOrder := centralizerOrder,
        centralizerMatrixGenerators := centralizerMatrixGenerators,
        adaptedCentralizerGenerators := conjugatedGenerators,
        strictGenerators := restrictedGenerators,
        strictGroup := restrictedGroup,
        strictOrder := Size(restrictedGroup),
        restrictionKernelGenerator := delta,
        restrictionKernelOrder := 3,
        scalarMatrix := scalarMatrix,
        scalarGroup := scalarGroup,
        projectiveMap := projectiveMap,
        projectiveGroup := projectiveGroup,
        projectiveOrder := Size(projectiveGroup)
    );
end;


CF_TF_RestrictCentralizer := function(prepared, fermatClass)
    local delta, deltaPermutation, centralizerPermutationGroup,
          centralizerPermutationGenerators, centralizerMatrixGenerators,
          restriction;

    if not IsRecord(fermatClass)
       or not IsBound(fermatClass.matrixRepresentative)
       or not IsBound(fermatClass.permutationRepresentative) then
        Error("A Fermat conjugacy-class record is required.");
    fi;

    delta := fermatClass.matrixRepresentative;
    deltaPermutation := fermatClass.permutationRepresentative;
    centralizerPermutationGroup := Centralizer(
        prepared.permutationGroup,
        deltaPermutation
    );
    centralizerPermutationGenerators := GeneratorsOfGroup(
        centralizerPermutationGroup
    );
    centralizerMatrixGenerators := List(
        centralizerPermutationGenerators,
        generator -> PreImagesRepresentative(
            prepared.permutationIsomorphism,
            generator
        )
    );

    restriction := CF_TF_RestrictMatrixCentralizer(
        delta,
        centralizerMatrixGenerators,
        Size(centralizerPermutationGroup)
    );
    restriction.fermatPermutationElement := deltaPermutation;
    restriction.centralizerPermutationGroup :=
        centralizerPermutationGroup;

    return restriction;
end;


#############################################################################
## 4. One source group and one catalogue entry
#############################################################################

CF_TF_ValidateFermatData := function(fermatData, options)
    if options.requireExpectedFermatRanks
       and not fermatData.fourfoldFermatRank in [0, 1, 2, 3, 6] then
        Error(
            "Unexpected number of Fermat summands: ",
            fermatData.fourfoldFermatRank, "."
        );
    fi;
    if fermatData.hasFermatSummand
       and options.requireSingleFermatClass
       and fermatData.classCount <> 1 then
        Error(
            "The Fermat elements do not form one conjugacy class in the ",
            "full source group."
        );
    fi;
end;


CF_TF_NoFermatResult := function(strictGroup, fermatData, searchMethod)
    return rec(
        status := "no_Fermat_summand",
        sourceStrictGroup := strictGroup,
        sourceStrictOrder := Size(strictGroup),
        fermatSearchMethod := searchMethod,
        fermatClassData := fermatData,
        fourfoldFermatRank := 0,
        producesThreefold := false
    );
end;


CF_TF_BuildExtractionResult := function(
    strictGroup,
    fermatData,
    restriction,
    options,
    searchMethod
)
    local result, cubicData, centralizerData;

    result := rec(
        status := "extracted",
        producesThreefold := true,
        sourceStrictGroup := strictGroup,
        sourceStrictOrder := Size(strictGroup),
        fermatSearchMethod := searchMethod,
        fermatClassData := fermatData,
        fourfoldFermatRank := fermatData.fourfoldFermatRank,
        threefoldFermatRank := fermatData.fourfoldFermatRank - 1,
        fermatElement := restriction.fermatElement,
        fixedSpaceBasis := restriction.fixedSpaceBasis,
        sourceToAdaptedBasis := restriction.sourceToAdaptedBasis,
        adaptedToSourceBasis := restriction.adaptedToSourceBasis,
        centralizerOrder := restriction.centralizerOrder,
        restrictionKernelOrder := restriction.restrictionKernelOrder,
        strictGenerators := restriction.strictGenerators,
        strictGroup := restriction.strictGroup,
        strictOrder := restriction.strictOrder,
        scalarMatrix := restriction.scalarMatrix,
        projectiveGroup := restriction.projectiveGroup,
        projectiveOrder := restriction.projectiveOrder,
        liveRestrictionData := restriction
    );

    if options.computeInvariantBasis then
        if not IsBound(CF_CubicInvariantBasis)
           or not IsBound(CF_CentralizerAlgebraBasis) then
            Error("Read gap_functions.g before computing invariant cubics.");
        fi;

        cubicData := CF_CubicInvariantBasis(
            result.strictGenerators,
            rec(
                ambientDimension := 5,
                buildPolynomialObjects := options.buildPolynomialObjects,
                buildStrings := options.buildPolynomialStrings
            )
        );
        centralizerData := CF_CentralizerAlgebraBasis(
            result.strictGenerators,
            false,
            5
        );

        result.cubicInvariantData := cubicData;
        result.cubicInvariantBasisVectors := cubicData.coefficientBasis;
        result.cubicInvariantBasisStrings := cubicData.polynomialStrings;
        result.cubicInvariantDimension := cubicData.invariantDimension;
        result.centralizerAlgebraDimension := centralizerData.dimension;
        result.familyDimension :=
            cubicData.invariantDimension - centralizerData.dimension;
    fi;

    if options.computeGroupDescriptions then
        if not IsBound(CF_GroupIdentificationData) then
            Error("Read gap_functions.g before identifying groups.");
        fi;
        result.strictGroupData := CF_GroupIdentificationData(
            result.strictGroup
        );
        result.projectiveGroupData := CF_GroupIdentificationData(
            result.projectiveGroup
        );
    fi;

    return result;
end;


## For small groups, exact element enumeration is usually much faster than
## constructing a permutation model of a cyclotomic matrix group.  The class
## size is |H|/|C_H(delta)|.  Equality with the total number of Fermat
## elements proves that they form one conjugacy class.
CF_TF_EnumerateMatrixGroupBFS := function(strictGroup)
    local generators, elements, position, element, generator, product;

    generators := GeneratorsOfGroup(strictGroup);
    generators := Set(Concatenation(
        generators,
        List(generators, Inverse)
    ));
    elements := [One(strictGroup)];
    position := 1;

    while position <= Length(elements) do
        element := elements[position];
        for generator in generators do
            product := element * generator;
            if not product in elements then
                Add(elements, product);
            fi;
        od;
        position := position + 1;
    od;

    if Length(elements) <> Size(strictGroup) then
        Error("The direct matrix BFS did not enumerate the full group.");
    fi;
    return elements;
end;


CF_TF_ExtractCentralFermatGenerator := function(
    strictGroup,
    delta,
    options
)
    local generators, fermatData, restriction;

    generators := GeneratorsOfGroup(strictGroup);
    if not CF_TF_IsFermatElement(delta) then
        Error("The supplied central element is not a Fermat element.");
    fi;
    if not ForAll(
        generators,
        generator -> generator * delta = delta * generator
    ) then
        Error("The supplied Fermat element is not central.");
    fi;

    fermatData := rec(
        classCount := 1,
        classes := [rec(
            matrixRepresentative := delta,
            classSize := 1
        )],
        elementCount := 1,
        fourfoldFermatRank := 1,
        hasFermatSummand := true
    );
    CF_TF_ValidateFermatData(fermatData, options);
    restriction := CF_TF_RestrictMatrixCentralizer(
        delta,
        generators,
        Size(strictGroup)
    );

    return CF_TF_BuildExtractionResult(
        strictGroup,
        fermatData,
        restriction,
        options,
        "central_Fermat_generator"
    );
end;


CF_TF_ExtractByDirectEnumeration := function(
    strictGroup,
    options
)
    local identity, elements, fermatElements, fermatData, delta,
          centralizerElements, centralizerGroup, centralizerGenerators,
          classSize, restriction;

    identity := One(strictGroup);
    if not IsMatrix(identity) or Length(identity) <> 6 then
        Error("The source strict group must act on six variables.");
    fi;
    if not E(3) * IdentityMat(6) in strictGroup then
        Error("The source strict group does not contain E(3) I_6.");
    fi;

    elements := CF_TF_EnumerateMatrixGroupBFS(strictGroup);
    fermatElements := Filtered(elements, CF_TF_IsFermatElement);
    if Length(fermatElements) = 0 then
        fermatData := rec(
            classCount := 0,
            classes := [],
            elementCount := 0,
            fourfoldFermatRank := 0,
            hasFermatSummand := false
        );
        CF_TF_ValidateFermatData(fermatData, options);
        return CF_TF_NoFermatResult(
            strictGroup,
            fermatData,
            "direct_element_enumeration"
        );
    fi;

    delta := fermatElements[1];
    centralizerElements := Filtered(
        elements,
        element -> element * delta = delta * element
    );
    centralizerGroup := Group(centralizerElements);
    if Size(centralizerGroup) <> Length(centralizerElements) then
        Error("The directly enumerated centralizer has the wrong order.");
    fi;

    centralizerGenerators := GeneratorsOfGroup(centralizerGroup);

    classSize := Size(strictGroup) / Length(centralizerElements);
    if not IsInt(classSize) then
        Error("The directly computed Fermat class size is not integral.");
    fi;
    fermatData := rec(
        classCount := fail,
        classes := [rec(
            matrixRepresentative := delta,
            classSize := classSize
        )],
        elementCount := Length(fermatElements),
        fourfoldFermatRank := Length(fermatElements),
        hasFermatSummand := true
    );
    if Length(fermatElements) = classSize then
        fermatData.classCount := 1;
    fi;
    CF_TF_ValidateFermatData(fermatData, options);

    restriction := CF_TF_RestrictMatrixCentralizer(
        delta,
        centralizerGenerators,
        Length(centralizerElements)
    );
    restriction.centralizerMatrixGroup := centralizerGroup;

    return CF_TF_BuildExtractionResult(
        strictGroup,
        fermatData,
        restriction,
        options,
        "direct_element_enumeration"
    );
end;


CF_TF_ExtractFromStrictGroup := function(arg)
    local strictGroup, options, prepared, fermatData, restriction;

    if Length(arg) < 1 or Length(arg) > 2 then
        Error("Use CF_TF_ExtractFromStrictGroup(group[, options]).");
    fi;

    strictGroup := arg[1];
    if Length(arg) = 2 then
        options := CF_TF_ExtractionOptions(arg[2]);
    else
        options := CF_TF_ExtractionOptions();
    fi;

    if options.directEnumerationBound > 0
       and Size(strictGroup) <= options.directEnumerationBound then
        return CF_TF_ExtractByDirectEnumeration(strictGroup, options);
    fi;

    prepared := CF_TF_PrepareStrictGroup(strictGroup);
    fermatData := CF_TF_FermatClassData(prepared);
    CF_TF_ValidateFermatData(fermatData, options);

    if not fermatData.hasFermatSummand then
        return CF_TF_NoFermatResult(
            strictGroup,
            fermatData,
            "permutation_conjugacy_classes"
        );
    fi;

    restriction := CF_TF_RestrictCentralizer(
        prepared,
        fermatData.classes[1]
    );

    return CF_TF_BuildExtractionResult(
        strictGroup,
        fermatData,
        restriction,
        options,
        "permutation_conjugacy_classes"
    );
end;


CF_TF_ExtractCatalogueFamily := function(arg)
    local family, options, source, result, centralFermatGenerator;

    if Length(arg) < 1 or Length(arg) > 2 then
        Error("Use CF_TF_ExtractCatalogueFamily(family[, options]).");
    fi;

    family := arg[1];
    if Length(arg) = 2 then
        options := CF_TF_ExtractionOptions(arg[2]);
    else
        options := CF_TF_ExtractionOptions();
    fi;

    source := CF_TF_StrictGroupFromCatalogueEntry(family);
    centralFermatGenerator := First(
        source.generators,
        generator -> CF_TF_IsFermatElement(generator)
            and ForAll(
                source.generators,
                other -> other * generator = generator * other
            )
    );

    ## These are certified full automorphism groups.  A central Fermat
    ## element therefore gives exactly one Fermat summand: with at least two
    ## such summands, their coordinate transpositions would be automorphisms
    ## and would not centralize an individual scaling element.
    if centralFermatGenerator <> fail
       and IsBound(family.fullGroupVerified)
       and family.fullGroupVerified = true then
        result := CF_TF_ExtractCentralFermatGenerator(
            source.group,
            centralFermatGenerator,
            options
        );
    else
        result := CF_TF_ExtractFromStrictGroup(source.group, options);
    fi;

    result.sourceFamilyNumber := family.number;
    result.sourceStandardFamilyNumber := family.standardFamilyNumber;
    result.sourceStandardPosition := family.standardPosition;
    result.sourceSymplecticPart := family.symplecticPart;
    result.sourceRankS := family.rankS;
    result.sourceFamilyDimension := family.familyDimension;
    result.sourceGenericIndex := family.genericIndex;
    result.sourceFullIndex := family.fullIndex;
    result.sourceLinearGroupId := family.linearGroupId;
    result.sourceProjectiveGroupId := family.projectiveGroupId;
    if IsBound(family.sourceCategory) then
        result.sourceCategory := family.sourceCategory;
    fi;
    if IsBound(family.sourceKey) then
        result.sourceKey := family.sourceKey;
    fi;
    if IsBound(family.sourceReference) then
        result.sourceReference := family.sourceReference;
    fi;

    return result;
end;


#############################################################################
## 5. Batch wrapper
#############################################################################

CF_TF_ExtractCatalogue := function(arg)
    local families, options, audits, extracted, skipped, position,
          family, result;

    if Length(arg) < 1 or Length(arg) > 2 then
        Error("Use CF_TF_ExtractCatalogue(families[, options]).");
    fi;

    families := arg[1];
    if not IsList(families) then
        Error("The catalogue input must be a list of family records.");
    fi;
    if Length(arg) = 2 then
        options := CF_TF_ExtractionOptions(arg[2]);
    else
        options := CF_TF_ExtractionOptions();
    fi;

    audits := [];
    extracted := [];
    skipped := [];

    for position in [1 .. Length(families)] do
        family := families[position];
        if options.printProgress then
            Print(
                position, "/", Length(families),
                ": fourfold family ", family.number, "\n"
            );
        fi;

        result := CF_TF_ExtractCatalogueFamily(family, options);
        if options.retainNoFermatSources or result.producesThreefold then
            Add(audits, result);
        fi;
        if result.producesThreefold then
            Add(extracted, result);
        else
            Add(skipped, result);
        fi;
    od;

    return rec(
        sourceCount := Length(families),
        auditCount := Length(audits),
        extractedSourceCount := Length(extracted),
        skippedSourceCount := Length(skipped),
        audits := audits,
        extracted := extracted,
        skipped := skipped,
        options := options
    );
end;
