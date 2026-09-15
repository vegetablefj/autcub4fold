#############################################################################
## Exact coordinate and invariant-basis checks for Records 78 and 127.
## Run from the repository root.  The canonical catalogue is read-only.
## The checked display snapshot is transcribed explicitly below; no external
## historical TeX file is needed to replay these coordinate certificates.
#############################################################################

Read("gap_classification/gap_functions.g");
Read("gap_classification/gap_manuscript_validation/gap_validation_functions.g");
Read("gap_classification/gap_fourfold_cross_dimension/input/fourfold_search_catalogue.g");

CF_SP_MonomialVector := function(indices, exponentBasis)
    local exponent, index, vector;
    exponent := List([1..6], i -> 0);
    for index in indices do
        exponent[index] := exponent[index] + 1;
    od;
    vector := List(exponentBasis, e -> 0);
    vector[Position(exponentBasis, exponent)] := 1;
    return vector;
end;

CF_SP_Audit := function()
    local exponentBasis, p78, p127, standard78, standard127, canonical78,
          canonical127, generators78, generators127, group78, group127,
          oldExtra78, oldExtra127, oldGroup78, oldGroup127, d78, oldD78,
          d127, pIndices, basis78, basis127, oldBasis78, oldBasis127,
          computed78, computed127, canonicalBasis78, canonicalBasis127,
          conjugacy127, perm, candidate, row78, row127, rows, output,
          stream, row, centralizer, scalars;

    exponentBasis := CF_DegreeThreeExponentVectors(6);
    p78 := List([
        [1,1,1], [1,1,2], [1,2,2], [1,3,3], [1,3,4], [1,4,4],
        [1,5,6], [2,2,2], [2,3,3], [2,3,4], [2,4,4], [2,5,6],
        [3,5,5], [3,6,6], [4,5,5], [4,6,6]
    ], indices -> CF_SP_MonomialVector(indices, exponentBasis));
    p127 := List([
        [1,1,1], [1,1,2], [1,1,3], [1,1,4], [1,2,2], [1,2,3],
        [1,2,4], [1,3,3], [1,3,4], [1,4,4], [1,5,5], [1,5,6],
        [1,6,6], [2,2,2], [2,2,3], [2,2,4], [2,3,3], [2,3,4],
        [2,4,4], [2,5,5], [2,5,6], [2,6,6], [3,3,3], [3,3,4],
        [3,4,4], [3,5,5], [3,5,6], [3,6,6], [4,4,4], [4,5,5],
        [4,5,6], [4,6,6]
    ], indices -> CF_SP_MonomialVector(indices, exponentBasis));
    standard78 := CanonicalKoikeStandardGroups[
        CanonicalFamilyMatrixGroups[78].standardPosition
    ];
    standard127 := CanonicalKoikeStandardGroups[
        CanonicalFamilyMatrixGroups[127].standardPosition
    ];
    canonical78 := Group(Concatenation(standard78.symplecticGenerators,
        [CanonicalFamilyMatrixGroups[78].extraGenerator]));
    canonical127 := Group(Concatenation(standard127.symplecticGenerators,
        [CanonicalFamilyMatrixGroups[127].extraGenerator]));
    generators78 := Concatenation(standard78.symplecticGenerators, [
        [ [1,0,0,0,0,0], [0,1,0,0,0,0], [0,0,-1,0,0,0],
          [0,0,0,-1,0,0], [0,0,0,0,0,1], [0,0,0,0,1,0] ]
    ]);
    generators127 := Concatenation(standard127.symplecticGenerators,
        [DiagonalMat([E(4),-1,1,1,1,-1])]);
    group78 := Group(generators78);
    group127 := Group(generators127);
    d78 := DiagonalMat([1,1,1,1,-3/4,1]);
    oldD78 := DiagonalMat([1,1,1,1,3/2,1]);
    oldExtra78 := [ [1,0,0,0,0,0], [0,1,0,0,0,0], [0,0,-1,0,0,0],
        [0,0,0,-1,0,0], [0,0,0,0,0,3/2], [0,0,0,0,2/3,0] ];
    oldExtra127 := DiagonalMat([1,1,-1,-E(4),1,-1]);
    oldGroup78 := Group(Concatenation(standard78.symplecticGenerators,
        [oldExtra78]));
    oldGroup127 := Group(Concatenation(standard127.symplecticGenerators,
        [oldExtra127]));

    ## The search has only 24 candidates and changes only the first four
    ## coordinates.  Each accepted witness is verified on all generators.
    conjugacy127 := fail;
    for perm in Elements(SymmetricGroup(4)) do
        candidate := PermutationMat(perm, 6);
        if CF_MV_VerifyGroupWitness(oldGroup127, group127, candidate) then
            conjugacy127 := candidate;
            break;
        fi;
    od;
    basis78 := Concatenation(p78{[1..12]},
        [p78[13]-p78[14], p78[15]-p78[16]]);
    basis127 := p127{[2,15,16,21,23,24,25,26,28,29,30,32]};
    oldBasis78 := Concatenation(p78{[1..12]},
        [p78[13]-4/9*p78[14], p78[15]-4/9*p78[16]]);
    oldBasis127 := p127{[1,2,5,8,11,13,14,17,20,22,25,27]};
    computed78 := CF_CubicInvariantBasis(generators78,
        rec(buildPolynomialObjects := false));
    computed127 := CF_CubicInvariantBasis(generators127,
        rec(buildPolynomialObjects := false));
    canonicalBasis78 := CF_CubicInvariantBasis(
        GeneratorsOfGroup(canonical78), rec(buildPolynomialObjects := false));
    canonicalBasis127 := CF_CubicInvariantBasis(
        GeneratorsOfGroup(canonical127), rec(buildPolynomialObjects := false));
    centralizer := CF_CentralizerAlgebraBasis(generators78, false);
    scalars := Subgroup(group78, Filtered(Elements(group78), CF_IsScalarMatrix));
    row78 := rec(
        number := 78,
        canonicalToDisplayedMatrix := d78,
        oldDisplayToDisplayedMatrix := oldD78,
        canonicalGroupConjugate := CF_MV_VerifyGroupWitness(
            canonical78, group78, d78),
        oldDisplayGroupConjugate := CF_MV_VerifyGroupWitness(
            oldGroup78, group78, oldD78),
        symplecticLiftFixedPointwise := ForAll(
            standard78.symplecticGenerators, g -> g^d78 = g),
        genericFullGroupFixed := CF_MV_VerifyGroupWitness(
            Group(standard78.genericFullGenerators),
            Group(standard78.genericFullGenerators), d78),
        genericFullGroupContained := ForAll(
            standard78.genericFullGenerators, g -> g in group78),
        linearGroupOrder := Size(group78),
        linearGroupId := IdGroup(group78),
        scalarSubgroupOrder := Size(scalars),
        projectiveGroupId := IdGroup(FactorGroup(group78, scalars)),
        invariantDimension := computed78.invariantDimension,
        centralizerDimension := centralizer.dimension,
        familyDimension := computed78.invariantDimension - centralizer.dimension,
        displayedBasisComplete := CF_MV_SameSpan(
            basis78, computed78.coefficientBasis),
        canonicalBasisPullbackComplete := CF_MV_SameSpan(basis78,
            CF_MV_TransformVectors(canonicalBasis78.coefficientBasis,
                d78^-1, exponentBasis)),
        oldDisplayBasisPullbackComplete := CF_MV_SameSpan(basis78,
            CF_MV_TransformVectors(oldBasis78, oldD78^-1, exponentBasis))
    );
    centralizer := CF_CentralizerAlgebraBasis(generators127, false);
    scalars := Subgroup(group127,
        Filtered(Elements(group127), CF_IsScalarMatrix));
    row127 := rec(
        number := 127,
        oldDisplayToDisplayedMatrix := conjugacy127,
        canonicalGroupLiteral := generators127[Length(generators127)]
            = CanonicalFamilyMatrixGroups[127].extraGenerator,
        oldDisplayGroupConjugate := conjugacy127 <> fail,
        symplecticLiftFixedPointwise := conjugacy127 <> fail and ForAll(
            standard127.symplecticGenerators, g -> g^conjugacy127 = g),
        genericFullGroupFixed := conjugacy127 <> fail and CF_MV_VerifyGroupWitness(
            Group(standard127.genericFullGenerators),
            Group(standard127.genericFullGenerators), conjugacy127),
        genericFullGroupContained := ForAll(
            standard127.genericFullGenerators, g -> g in group127),
        linearGroupOrder := Size(group127),
        linearGroupId := IdGroup(group127),
        scalarSubgroupOrder := Size(scalars),
        projectiveGroupId := IdGroup(FactorGroup(group127, scalars)),
        invariantDimension := computed127.invariantDimension,
        centralizerDimension := centralizer.dimension,
        familyDimension := computed127.invariantDimension - centralizer.dimension,
        displayedBasisComplete := CF_MV_SameSpan(
            basis127, computed127.coefficientBasis),
        canonicalBasisLiteral := CF_MV_SameSpan(
            basis127, canonicalBasis127.coefficientBasis),
        oldDisplayBasisPullbackComplete := conjugacy127 <> fail
            and CF_MV_SameSpan(basis127, CF_MV_TransformVectors(oldBasis127,
                conjugacy127^-1, exponentBasis))
    );
    rows := [row78, row127];
    for row in rows do
        row.expectedMetadataMatched :=
            row.linearGroupId = CanonicalFamilyMatrixGroups[row.number].linearGroupId
            and row.projectiveGroupId =
                CanonicalFamilyMatrixGroups[row.number].projectiveGroupId
            and row.familyDimension =
                CanonicalFamilyMatrixGroups[row.number].familyDimension;
        row.allChecksPassed := ForAll(RecNames(row),
            name -> not IsBool(row.(name)) or row.(name) = true);
    od;
    output := rec(gapVersion := GAPInfo.Version,
        allChecksPassed := ForAll(rows, row -> row.allChecksPassed),
        rows := rows);
    stream := OutputTextFile(
        "gap_classification/gap_manuscript_validation/special_coordinate_audit.out",
        false);
    SetPrintFormattingStatus(stream, false);
    PrintTo(stream, "SpecialCoordinateAudit := ", output, ";\n");
    CloseStream(stream);
    for row in rows do
        Print("Record ", row.number, ": ", row, "\n");
    od;
    if not output.allChecksPassed then
        Error("A special coordinate audit check failed; inspect the output.");
    fi;
    return output;
end;

SpecialCoordinateAudit := CF_SP_Audit();
Print("VALIDATION_COMPLETE: special coordinate audit\n");
QUIT_GAP(0);
