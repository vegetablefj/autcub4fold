#############################################################################
##
## gap_functions.g
##
## Shared GAP functions for the classification computations.
##
## This file contains reusable functions for finite groups, characters,
## matrix representations, exact intertwiners, proof-grade conjugacy
## embeddings, and invariant cubic forms.  Classification-wide enumeration
## drivers and record-specific batch operations remain in the individual
## computation directories.
##
## The original source files are retained unchanged for regression tests.
## See gap_functions.md for sources, version choices, and compatibility notes.
##
#############################################################################


#############################################################################
## 1. Basic utilities and validation
#############################################################################

if not IsBound(CF_S_PRINT_ENABLED) then
    CF_S_PRINT_ENABLED := false;
fi;

CF_SPrint := function(arg)
    local item;

    if CF_S_PRINT_ENABLED then
        for item in arg do
            Print(item);
        od;
    fi;

    return true;
end;


CF_CheckSmallGroupId := function(gid)
    local n, k;

    if not IsList(gid) or Length(gid) <> 2 then
        Error("The group ID must be a list [n,k].");
    fi;

    n := gid[1];
    k := gid[2];

    if not IsInt(n) or not IsInt(k) then
        Error("The entries of [n,k] must be integers.");
    fi;

    if not SmallGroupsAvailable(n) then
        Error("The Small Groups Library is unavailable for order ", n, ".");
    fi;

    if k < 1 or k > NumberSmallGroups(n) then
        Error("Invalid SmallGroup ID: ", gid, ".");
    fi;
end;


CF_SameSubgroup := function(A, B)
    if Size(A) <> Size(B) then
        return false;
    fi;

    return IsSubgroup(A, B) and IsSubgroup(B, A);
end;


CF_JoinStrings := function(strings, separator)
    local answer, i;

    if Length(strings) = 0 then
        return "";
    fi;

    answer := strings[1];
    for i in [2 .. Length(strings)] do
        answer := Concatenation(answer, separator, strings[i]);
    od;

    return answer;
end;


CF_SquareMatrixDimension := function(A)
    local dimensions;

    if not IsList(A) or Length(A) = 0 then
        return fail;
    fi;

    dimensions := DimensionsMat(A);
    if Length(dimensions) <> 2 or dimensions[1] <> dimensions[2] then
        return fail;
    fi;

    return dimensions[1];
end;


CF_MatrixListDimension := function(matrices)
    local n, A;

    if not IsList(matrices) or Length(matrices) = 0 then
        return fail;
    fi;

    n := CF_SquareMatrixDimension(matrices[1]);
    if n = fail then
        Error("The matrix list contains a non-square matrix.");
    fi;

    for A in matrices do
        if CF_SquareMatrixDimension(A) <> n then
            Error("The matrix list contains incompatible dimensions.");
        fi;
    od;

    return n;
end;


CF_IsScalarMatrix := function(A)
    local n, scalar, i, j;

    n := CF_SquareMatrixDimension(A);
    if n = fail then
        return false;
    fi;

    scalar := A[1][1];
    for i in [1 .. n] do
        if A[i][i] <> scalar then
            return false;
        fi;

        for j in [1 .. n] do
            if i <> j and A[i][j] <> 0 then
                return false;
            fi;
        od;
    od;

    return true;
end;


CF_IsScalarWithValue := function(A, scalar)
    if not CF_IsScalarMatrix(A) then
        return false;
    fi;

    return A[1][1] = scalar;
end;


CF_ScalarMultipleRatio := function(A, B)
    local n, i, j, ratio;

    if DimensionsMat(A) <> DimensionsMat(B) then
        return fail;
    fi;

    n := CF_SquareMatrixDimension(A);
    if n = fail then
        return fail;
    fi;

    ratio := fail;
    for i in [1 .. n] do
        for j in [1 .. n] do
            if B[i][j] <> 0 then
                ratio := A[i][j] / B[i][j];
                break;
            elif A[i][j] <> 0 then
                return fail;
            fi;
        od;

        if ratio <> fail then
            break;
        fi;
    od;

    if ratio = fail then
        return fail;
    fi;

    for i in [1 .. n] do
        for j in [1 .. n] do
            if A[i][j] <> ratio * B[i][j] then
                return fail;
            fi;
        od;
    od;

    return ratio;
end;


CF_BlockDiagonalMatrixList := function(blocks)
    local total, matrix, offset, block, i, j;

    if Length(blocks) = 0 then
        Error("At least one matrix block is required.");
    fi;

    total := Sum(List(blocks, Length));
    matrix := List([1 .. total], i -> List([1 .. total], j -> 0));
    offset := 0;

    for block in blocks do
        if CF_SquareMatrixDimension(block) = fail then
            Error("A block is not square.");
        fi;

        for i in [1 .. Length(block)] do
            for j in [1 .. Length(block)] do
                matrix[offset + i][offset + j] := block[i][j];
            od;
        od;

        offset := offset + Length(block);
    od;

    return Immutable(matrix);
end;


#############################################################################
## 2. Character and finite-group utilities
#############################################################################

CF_CharacterFromMultiplicities := function(irreducibles, multiplicities)
    local character, i;

    if Length(irreducibles) <> Length(multiplicities) then
        Error("Character and multiplicity lists have different lengths.");
    fi;

    if Length(irreducibles) = 0 then
        Error("At least one irreducible character is required.");
    fi;

    character := 0 * irreducibles[1];
    for i in [1 .. Length(irreducibles)] do
        character := character + multiplicities[i] * irreducibles[i];
    od;

    return character;
end;


CF_ClassPositionContainingElement := function(classes, element)
    return PositionProperty(classes, class -> element in class);
end;


CF_ClassFusionByImageFunction := function(sourceTable, targetTable, imageFunction)
    local sourceClasses, targetClasses, fusion, class, image, position;

    sourceClasses := ConjugacyClasses(sourceTable);
    targetClasses := ConjugacyClasses(targetTable);
    fusion := [];

    for class in sourceClasses do
        image := imageFunction(Representative(class));
        position := CF_ClassPositionContainingElement(targetClasses, image);

        if position = fail then
            Error("Could not locate an image in the target character-table classes.");
        fi;

        Add(fusion, position);
    od;

    return fusion;
end;


CF_PullbackClassFunctionByFusion := function(classFunction, sourceTable, fusion)
    local values;

    if Length(fusion) <> NrConjugacyClasses(sourceTable) then
        Error("A class-fusion list has the wrong length.");
    fi;

    values := ValuesOfClassFunction(classFunction){fusion};

    if IsCharacter(classFunction) then
        return Character(sourceTable, values);
    elif IsVirtualCharacter(classFunction) then
        return VirtualCharacter(sourceTable, values);
    fi;

    return ClassFunction(sourceTable, values);
end;


CF_RebaseClassFunction := function(classFunction, targetTable)
    local sourceTable, fusion, inverseFusion, i, j, values;

    sourceTable := UnderlyingCharacterTable(classFunction);
    if IsIdenticalObj(sourceTable, targetTable) then
        return classFunction;
    fi;

    fusion := FusionConjugacyClasses(sourceTable, targetTable);
    if fusion = fail then
        Error("Could not fuse the source character table to the target table.");
    fi;

    if Length(fusion) <> NrConjugacyClasses(targetTable) then
        Error("The two character tables have different class counts.");
    fi;

    inverseFusion := List([1 .. NrConjugacyClasses(targetTable)], i -> 0);
    for i in [1 .. Length(fusion)] do
        j := fusion[i];
        if j < 1 or j > Length(inverseFusion) or inverseFusion[j] <> 0 then
            Error("The class fusion between the two tables is not bijective.");
        fi;
        inverseFusion[j] := i;
    od;

    if 0 in inverseFusion then
        Error("The class fusion between the two tables is not surjective.");
    fi;

    values := ValuesOfClassFunction(classFunction){inverseFusion};

    if IsCharacter(classFunction) then
        return Character(targetTable, values);
    elif IsVirtualCharacter(classFunction) then
        return VirtualCharacter(targetTable, values);
    fi;

    return ClassFunction(targetTable, values);
end;


CF_NaturalCharacterOfMatrixGroup := function(matrixGroup)
    local isomorphism, permutationGroup, inverse, classes, values, character;

    isomorphism := IsomorphismPermGroup(matrixGroup);
    if isomorphism = fail then
        Error("Could not convert a matrix group to a permutation group.");
    fi;

    permutationGroup := Image(isomorphism);
    inverse := InverseGeneralMapping(isomorphism);
    classes := ConjugacyClasses(permutationGroup);
    values := List(
        classes,
        class -> TraceMat(Image(inverse, Representative(class)))
    );
    character := Character(permutationGroup, values);

    if not IsCharacter(character) then
        Error("The natural character of the matrix group was not recognized.");
    fi;

    return rec(
        permutationGroup := permutationGroup,
        isoMatrixToPerm  := isomorphism,
        character        := character
    );
end;


CF_CharacterOrbitUnderAutomorphisms := function(group, character)
    local table, automorphismGroup, generators, orbit, position,
          current, automorphism, twisted;

    table := UnderlyingCharacterTable(character);
    automorphismGroup := AutomorphismGroup(group);
    generators := GeneratorsOfGroup(automorphismGroup);
    character := CF_RebaseClassFunction(character, table);
    orbit := [character];
    position := 1;

    while position <= Length(orbit) do
        current := orbit[position];

        for automorphism in generators do
            twisted := RestrictedClassFunction(current, automorphism);
            twisted := CF_RebaseClassFunction(twisted, table);

            if Position(orbit, twisted) = fail then
                Add(orbit, twisted);
            fi;
        od;

        position := position + 1;
    od;

    return orbit;
end;


CF_EmbeddingIntoH := function(K, H, isomorphismKToSubgroup)
    local generators, images, embedding;

    generators := GeneratorsOfGroup(K);
    images := List(generators, g -> Image(isomorphismKToSubgroup, g));
    embedding := GroupHomomorphismByImages(K, H, generators, images);

    if embedding = fail then
        Error("Could not convert the supplied isomorphism into an embedding.");
    fi;

    return embedding;
end;


CF_NormalCopiesOfKbar := function(group, targetGroup)
    local targetOrder, answer, subgroup;

    targetOrder := Size(targetGroup);
    answer := [];

    for subgroup in NormalSubgroups(group) do
        if Size(subgroup) = targetOrder
           and IsomorphismGroups(targetGroup, subgroup) <> fail then
            Add(answer, subgroup);
        fi;
    od;

    return answer;
end;


CF_BlockImageOfComponents := function(componentMaps, element)
    return CF_BlockDiagonalMatrixList(
        List(componentMaps, representation -> Image(representation, element))
    );
end;


CF_ScalarImagesOfAbstractCentre := function(group, componentMaps)
    local answer, element, matrix;

    answer := [];
    for element in Elements(Centre(group)) do
        matrix := CF_BlockImageOfComponents(componentMaps, element);
        if CF_IsScalarMatrix(matrix) then
            Add(answer, rec(element := element, matrix := matrix));
        fi;
    od;

    return answer;
end;


CF_ApplyIndexPermutationToMultiplicityVector := function(vector, indexImages)
    local answer, i;

    if Length(vector) <> Length(indexImages) then
        Error("The vector and index-permutation list have different lengths.");
    fi;

    answer := List([1 .. Length(vector)], i -> 0);
    for i in [1 .. Length(vector)] do
        answer[indexImages[i]] := vector[i];
    od;

    return answer;
end;


CF_GroupIdentificationData := function(group)
    local identifier, abelianInvariants;

    if not IsGroup(group) or not IsFinite(group) then
        Error("A finite group is required for group identification.");
    fi;

    identifier := fail;
    if IdGroupsAvailable(Size(group)) then
        identifier := IdGroup(group);
    fi;

    abelianInvariants := fail;
    if IsAbelian(group) then
        abelianInvariants := AbelianInvariants(group);
    fi;

    return rec(
        order := Size(group),
        id := identifier,
        structureDescription := StructureDescription(group),
        abelianInvariants := abelianInvariants
    );
end;


CF_DeterminantImageOrder := function(matrixGroup)
    local imageOrder, matrix;

    if not IsGroup(matrixGroup) or not IsFinite(matrixGroup) then
        Error("A finite matrix group is required.");
    fi;

    imageOrder := 1;
    for matrix in GeneratorsOfGroup(matrixGroup) do
        imageOrder := Lcm(imageOrder, Order(DeterminantMat(matrix)));
    od;

    return imageOrder;
end;


CF_DeterminantKernelSize := function(matrixGroup)
    return Size(matrixGroup) / CF_DeterminantImageOrder(matrixGroup);
end;


#############################################################################
## 3. Exact linear algebra and intertwiners
#############################################################################

CF_NonnegativeColumnSolutions := function(columns, target)
    local answers, search;

    answers := [];
    if Length(columns) = 0 then
        if ForAll(target, x -> x = 0) then
            return [[]];
        fi;
        return [];
    fi;

    if not ForAll(columns, column -> Length(column) = Length(target)) then
        Error("A column has the wrong length.");
    fi;

    search := function(position, remaining, current)
        local column, bounds, maximum, j, multiplicity, next;

        if position > Length(columns) then
            if ForAll(remaining, x -> x = 0) then
                Add(answers, ShallowCopy(current));
            fi;
            return;
        fi;

        column := columns[position];
        bounds := [];
        for j in [1 .. Length(target)] do
            if column[j] > 0 then
                Add(bounds, QuoInt(remaining[j], column[j]));
            fi;
        od;

        if Length(bounds) = 0 then
            maximum := 0;
        else
            maximum := Minimum(bounds);
        fi;

        for multiplicity in [0 .. maximum] do
            next := List(
                [1 .. Length(target)],
                j -> remaining[j] - multiplicity * column[j]
            );

            if ForAll(next, x -> x >= 0) then
                current[position] := multiplicity;
                search(position + 1, next, current);
            fi;
        od;
    end;

    search(1, ShallowCopy(target), []);
    return answers;
end;


CF_NullspaceOfEquationRows := function(equations, numberOfUnknowns)
    if Length(equations) = 0 then
        return IdentityMat(numberOfUnknowns);
    fi;

    return NullspaceMat(TransposedMat(equations));
end;


## Row-major conversion used by CF_Intertwiner and the centralizer routines.
CF_VectorToSquareMatrix := function(vector, n)
    local matrix, i;

    if Length(vector) <> n * n then
        Error("The vector length is not n^2.");
    fi;

    matrix := [];
    for i in [1 .. n] do
        Add(matrix, vector{[(i - 1) * n + 1 .. i * n]});
    od;

    return matrix;
end;


CF_ForEachSparseIntegerVectorAtLevel := function(
    dimension,
    level,
    callback
)
    local maximumSupport, supportSize, supports, support, values,
          coefficients, stopped, searchValues, index;

    if dimension < 1 or level < 1 then
        return false;
    fi;

    maximumSupport := Minimum(dimension, level);
    values := Concatenation([-level .. -1], [1 .. level]);
    coefficients := List([1 .. dimension], i -> 0);
    stopped := false;

    for supportSize in [1 .. maximumSupport] do
        supports := Combinations([1 .. dimension], supportSize);

        for support in supports do
            searchValues := function(position, reachesBoundary)
                local value, newBoundary;

                if stopped then
                    return;
                fi;

                if position > supportSize then
                    if reachesBoundary or supportSize = level then
                        if callback(ShallowCopy(coefficients)) = true then
                            stopped := true;
                        fi;
                    fi;
                    return;
                fi;

                for value in values do
                    coefficients[support[position]] := value;
                    newBoundary := reachesBoundary or AbsInt(value) = level;
                    searchValues(position + 1, newBoundary);

                    if stopped then
                        return;
                    fi;
                od;

                coefficients[support[position]] := 0;
            end;

            searchValues(1, false);

            for index in support do
                coefficients[index] := 0;
            od;

            if stopped then
                return true;
            fi;
        od;
    od;

    return false;
end;


CF_FindInvertibleCombination := function(basis, n)
    local dimension, vector, matrix, tuples, coefficients, i, j, attempt,
          seed, value, level, found;

    dimension := Length(basis);
    if dimension = 0 then
        return fail;
    fi;

    for vector in basis do
        matrix := CF_VectorToSquareMatrix(vector, n);
        if DeterminantMat(matrix) <> 0 then
            return matrix;
        fi;
    od;

    if dimension <= 8 then
        tuples := Tuples([-1, 0, 1], dimension);
        for coefficients in tuples do
            if ForAny(coefficients, x -> x <> 0) then
                vector := List(
                    [1 .. n * n],
                    j -> Sum(
                        [1 .. dimension],
                        i -> coefficients[i] * basis[i][j]
                    )
                );
                matrix := CF_VectorToSquareMatrix(vector, n);

                if DeterminantMat(matrix) <> 0 then
                    return matrix;
                fi;
            fi;
        od;
    fi;

    seed := 104729 + 1009 * dimension + 9176 * n;
    for attempt in [1 .. 20000] do
        coefficients := [];
        for i in [1 .. dimension] do
            seed := (1103515245 * seed + 12345) mod 2147483647;
            value := (seed mod 41) - 20;
            if value = 0 then
                value := ((i + 3 * attempt) mod 11) + 1;
            fi;
            Add(coefficients, value);
        od;

        vector := List(
            [1 .. n * n],
            j -> Sum(
                [1 .. dimension],
                i -> coefficients[i] * basis[i][j]
            )
        );
        matrix := CF_VectorToSquareMatrix(vector, n);

        if DeterminantMat(matrix) <> 0 then
            return matrix;
        fi;
    od;

    level := 1;
    while true do
        found := fail;
        CF_ForEachSparseIntegerVectorAtLevel(
            dimension,
            level,
            function(candidateCoefficients)
                local candidateVector, candidateMatrix;

                candidateVector := List(
                    [1 .. n * n],
                    j -> Sum(
                        [1 .. dimension],
                        i -> candidateCoefficients[i] * basis[i][j]
                    )
                );
                candidateMatrix := CF_VectorToSquareMatrix(candidateVector, n);

                if DeterminantMat(candidateMatrix) <> 0 then
                    found := candidateMatrix;
                    return true;
                fi;

                return false;
            end
        );

        if found <> fail then
            return found;
        fi;

        if level mod 2 = 0 then
            CF_SPrint(
                "    exact intertwiner witness search reached level ",
                level,
                ".\n"
            );
        fi;

        level := level + 1;
    od;
end;


## Find P with B_i P = P A_i.  An optional third argument gives the
## dimension when both generator lists are empty.  The default 6 preserves
## the behavior of the original cubic-fourfold programs.
CF_Intertwiner := function(arg)
    local Bgenerators, Agenerators, n, equations, A, B, row,
          i, j, k, index, basis, P, t;

    if Length(arg) < 2 or Length(arg) > 3 then
        Error("Use CF_Intertwiner(Bgenerators, Agenerators[, dimension]).");
    fi;

    Bgenerators := arg[1];
    Agenerators := arg[2];

    if Length(Bgenerators) <> Length(Agenerators) then
        Error("The two generator lists have different lengths.");
    fi;

    if Length(Bgenerators) = 0 then
        if Length(arg) = 3 then
            n := arg[3];
        else
            n := 6;
        fi;
        return IdentityMat(n);
    fi;

    n := CF_MatrixListDimension(Bgenerators);
    if CF_MatrixListDimension(Agenerators) <> n then
        Error("Intertwiner input matrices have incompatible dimensions.");
    fi;

    equations := [];
    for t in [1 .. Length(Bgenerators)] do
        B := Bgenerators[t];
        A := Agenerators[t];

        for i in [1 .. n] do
            for j in [1 .. n] do
                row := List([1 .. n * n], k -> 0);
                for k in [1 .. n] do
                    index := (k - 1) * n + j;
                    row[index] := row[index] + B[i][k];
                    index := (i - 1) * n + k;
                    row[index] := row[index] - A[k][j];
                od;
                Add(equations, row);
            od;
        od;
    od;

    basis := CF_NullspaceOfEquationRows(equations, n * n);
    if Length(basis) = 0 then
        Error("The exact intertwiner space is zero.");
    fi;

    P := CF_FindInvertibleCombination(basis, n);
    if P = fail then
        Error("The intertwiner space did not yield an invertible matrix.");
    fi;

    for t in [1 .. Length(Bgenerators)] do
        if Bgenerators[t] * P <> P * Agenerators[t] then
            Error("The computed matrix does not intertwine the generators.");
        fi;
    od;

    return P;
end;


CF_LinearCombinationOfVectors := function(basis, coefficients)
    local answer, i, j;

    if Length(basis) <> Length(coefficients) then
        Error("The basis and coefficient list have different lengths.");
    fi;

    if Length(basis) = 0 then
        return [];
    fi;

    if not ForAll(basis, vector -> Length(vector) = Length(basis[1])) then
        Error("The basis vectors have different lengths.");
    fi;

    answer := List([1 .. Length(basis[1])], j -> 0);
    for i in [1 .. Length(basis)] do
        for j in [1 .. Length(answer)] do
            answer[j] := answer[j] + coefficients[i] * basis[i][j];
        od;
    od;

    return answer;
end;


#############################################################################
## 4. Matrix-group fingerprints and conjugacy witnesses
#############################################################################

FingerprintWeak := function(element)
    return [Order(element), TraceMat(element), DeterminantMat(element)];
end;


FingerprintStrong := function(element)
    return [
        Order(element),
        CoefficientsOfUnivariatePolynomial(CharacteristicPolynomial(element))
    ];
end;


MultisetFromList := function(list)
    local sorted, element, answer;

    sorted := ShallowCopy(list);
    Sort(sorted);
    answer := [];

    for element in sorted do
        if Length(answer) = 0
           or answer[Length(answer)][1] <> element then
            Add(answer, [element, 1]);
        else
            answer[Length(answer)][2] := answer[Length(answer)][2] + 1;
        fi;
    od;

    return answer;
end;


IsSubmultiset := function(first, second)
    local item, target, found;

    for item in first do
        found := false;
        for target in second do
            if item[1] = target[1] then
                if item[2] > target[2] then
                    return false;
                fi;
                found := true;
                break;
            fi;
        od;

        if not found then
            return false;
        fi;
    od;

    return true;
end;


MergeWeighted := function(weightedList)
    local answer, item, i, found;

    answer := [];
    for item in weightedList do
        found := false;

        for i in [1 .. Length(answer)] do
            if answer[i][1] = item[1] then
                answer[i][2] := answer[i][2] + item[2];
                found := true;
                break;
            fi;
        od;

        if not found then
            Add(answer, [item[1], item[2]]);
        fi;
    od;

    return answer;
end;


IsSubmultisetWeighted := function(first, second)
    return IsSubmultiset(first, second);
end;


ConjugacyFingerprintMultisets := function(group, permutationIsomorphism)
    local permutationGroup, classes, weak, strong, orders,
          class, permutationRepresentative, representative, classSize;

    permutationGroup := Image(permutationIsomorphism);
    classes := ConjugacyClasses(permutationGroup);
    weak := [];
    strong := [];
    orders := [];

    for class in classes do
        permutationRepresentative := Representative(class);
        representative := PreImagesRepresentative(
            permutationIsomorphism,
            permutationRepresentative
        );
        classSize := Size(class);
        Add(weak, [FingerprintWeak(representative), classSize]);
        Add(strong, [FingerprintStrong(representative), classSize]);
        Add(orders, [Order(representative), classSize]);
    od;

    return rec(
        weak          := MergeWeighted(weak),
        strong        := MergeWeighted(strong),
        element_orders := MergeWeighted(orders)
    );
end;


DerivedSeriesOrders := function(group)
    return List(DerivedSeriesOfGroup(group), Size);
end;


AbstractEmbedsById := function(firstId, secondId)
    local result;

    if firstId = fail or secondId = fail then
        return fail;
    fi;

    if not IsList(firstId) or not IsList(secondId)
       or Length(firstId) < 2 or Length(secondId) < 2 then
        return fail;
    fi;

    if not IsInt(firstId[1]) or not IsInt(secondId[1]) then
        return fail;
    fi;

    if firstId[1] = 0 or secondId[1] = 0 then
        return fail;
    fi;

    if not IsInt(secondId[1] / firstId[1]) then
        return false;
    fi;

    if firstId = secondId then
        return true;
    fi;

    if firstId[2] = 0 or secondId[2] = 0 then
        return fail;
    fi;

    if not SmallGroupsAvailable(firstId[1])
       or not SmallGroupsAvailable(secondId[1]) then
        return fail;
    fi;

    if firstId[2] < 1 or secondId[2] < 1 then
        return fail;
    fi;

    if NumberSmallGroups(firstId[1]) < firstId[2]
       or NumberSmallGroups(secondId[1]) < secondId[2] then
        return fail;
    fi;

    result := CALL_WITH_CATCH(
        function()
            return Length(
                IsomorphicSubgroups(
                    SmallGroup(secondId),
                    SmallGroup(firstId)
                )
            ) > 0;
        end,
        []
    );

    if not result[1] then
        return fail;
    fi;

    return result[2];
end;


## Column-major conversion used by IntertwinerSpace.  This convention is
## intentionally distinct from CF_VectorToSquareMatrix.
MatFromVec := function(vector, n)
    local matrix, i, j, position, zero;

    if Length(vector) <> n * n then
        Error("The vector length is not n^2.");
    fi;

    zero := 0 * vector[1];
    matrix := List([1 .. n], i -> List([1 .. n], j -> zero));
    position := 1;

    for j in [1 .. n] do
        for i in [1 .. n] do
            matrix[i][j] := vector[position];
            position := position + 1;
        od;
    od;

    return matrix;
end;


## An optional third argument gives the dimension for empty generator lists.
## The default 6 preserves the behavior of the original catalogue code.
IntertwinerSpace := function(arg)
    local firstGenerators, secondGenerators, n, identity, rows,
          k, first, second, matrix, nullspace, basis, vector, i, j, elementary;

    if Length(arg) < 2 or Length(arg) > 3 then
        Error("Use IntertwinerSpace(first, second[, dimension]).");
    fi;

    firstGenerators := arg[1];
    secondGenerators := arg[2];

    if Length(firstGenerators) <> Length(secondGenerators) then
        Error("The two generator lists have different lengths.");
    fi;

    if Length(firstGenerators) = 0 then
        if Length(arg) = 3 then
            n := arg[3];
        else
            n := 6;
        fi;

        basis := [];
        for j in [1 .. n] do
            for i in [1 .. n] do
                elementary := NullMat(n, n);
                elementary[i][j] := 1;
                Add(basis, elementary);
            od;
        od;
        return basis;
    fi;

    n := CF_MatrixListDimension(firstGenerators);
    if CF_MatrixListDimension(secondGenerators) <> n then
        Error("Intertwiner input matrices have incompatible dimensions.");
    fi;

    identity := IdentityMat(n);
    rows := [];
    for k in [1 .. Length(firstGenerators)] do
        first := firstGenerators[k];
        second := secondGenerators[k];
        matrix := KroneckerProduct(identity, first)
            - KroneckerProduct(TransposedMat(second), identity);
        Append(rows, matrix);
    od;

    nullspace := NullspaceMat(TransposedMat(rows));
    basis := List(nullspace, vector -> MatFromVec(vector, n));
    return basis;
end;


AveragedIntertwiner := function(firstGenerators, secondGenerators, seed)
    local sourceGroup, homomorphism, answer, element, image, order;

    if Length(firstGenerators) <> Length(secondGenerators) then
        Error("The two generator lists have different lengths.");
    fi;

    sourceGroup := Group(firstGenerators);
    order := Size(sourceGroup);
    if order = 0 or order > 100000 then
        return fail;
    fi;

    homomorphism := GroupHomomorphismByImages(
        sourceGroup,
        Group(secondGenerators),
        firstGenerators,
        secondGenerators
    );
    if homomorphism = fail then
        return fail;
    fi;

    answer := 0 * seed;
    for element in sourceGroup do
        image := Image(homomorphism, element);
        answer := answer + element * seed * image^-1;
    od;

    return (1 / order) * answer;
end;


IntertwinerSeedMaps := function(n)
    local seeds, i, j, elementary, seed, attempt;

    seeds := [IdentityMat(n)];
    for i in [1 .. n] do
        for j in [1 .. n] do
            elementary := NullMat(n, n);
            elementary[i][j] := 1;
            Add(seeds, elementary);
        od;
    od;

    for attempt in [1 .. 20] do
        seed := RandomMat(n, n);
        if IsZero(DeterminantMat(seed)) then
            seed := seed + IdentityMat(n);
        fi;
        Add(seeds, seed);
    od;

    return seeds;
end;


FindInvertibleIntertwiner := function(arg)
    local firstGenerators, secondGenerators, n, basis, dimension,
          matrix, attempt, coefficients, i, seed, bound;

    if Length(arg) < 2 or Length(arg) > 3 then
        Error("Use FindInvertibleIntertwiner(first, second[, dimension]).");
    fi;

    firstGenerators := arg[1];
    secondGenerators := arg[2];

    if Length(firstGenerators) <> Length(secondGenerators) then
        Error("The two generator lists have different lengths.");
    fi;

    if Length(firstGenerators) = 0 then
        if Length(arg) = 3 then
            n := arg[3];
        else
            n := 6;
        fi;
        return IdentityMat(n);
    fi;

    n := CF_MatrixListDimension(firstGenerators);
    if CF_MatrixListDimension(secondGenerators) <> n then
        Error("Intertwiner input matrices have incompatible dimensions.");
    fi;

    basis := IntertwinerSpace(firstGenerators, secondGenerators, n);
    if Length(basis) > 0 then
        dimension := Length(basis);

        for matrix in basis do
            if not IsZero(DeterminantMat(matrix)) then
                return matrix;
            fi;
        od;

        for bound in [4, 8, 16] do
            for attempt in [1 .. 200] do
                matrix := 0 * basis[1];
                for i in [1 .. dimension] do
                    matrix := matrix
                        + Random([-bound .. bound]) * basis[i];
                od;

                if not IsZero(DeterminantMat(matrix)) then
                    return matrix;
                fi;
            od;
        od;

        if dimension <= 4 then
            for coefficients in Tuples([-2 .. 2], dimension) do
                if ForAll(coefficients, x -> x = 0) then
                    continue;
                fi;

                matrix := 0 * basis[1];
                for i in [1 .. dimension] do
                    matrix := matrix + coefficients[i] * basis[i];
                od;

                if not IsZero(DeterminantMat(matrix)) then
                    return matrix;
                fi;
            od;
        fi;
    fi;

    for seed in IntertwinerSeedMaps(n) do
        matrix := AveragedIntertwiner(
            firstGenerators,
            secondGenerators,
            seed
        );

        if matrix <> fail and not IsZero(DeterminantMat(matrix)) then
            return matrix;
        fi;
    od;

    return fail;
end;


VerifyConjugation := function(firstGenerators, secondGenerators, matrix, targetGroup)
    local k, inverse;

    if Length(firstGenerators) <> Length(secondGenerators) then
        return false;
    fi;

    if IsZero(DeterminantMat(matrix)) then
        return false;
    fi;

    inverse := matrix^-1;
    for k in [1 .. Length(firstGenerators)] do
        if inverse * firstGenerators[k] * matrix <> secondGenerators[k] then
            return false;
        fi;

        if not secondGenerators[k] in targetGroup then
            return false;
        fi;
    od;

    if Size(Group(secondGenerators)) <> Size(Group(firstGenerators)) then
        return false;
    fi;

    return true;
end;


MatToGapString := function(matrix)
    local i, j, row, rows;

    rows := [];
    for i in [1 .. Length(matrix)] do
        row := List([1 .. Length(matrix[i])], j -> String(matrix[i][j]));
        Add(rows, Concatenation("[", CF_JoinStrings(row, ", "), "]"));
    od;

    return Concatenation("[", CF_JoinStrings(rows, ", "), "]");
end;


CF_PermuteDiagonalMatrix := function(matrix, permutation)
    local n, diagonal, position;

    n := CF_SquareMatrixDimension(matrix);
    if n = fail or not IsDiagonalMatrix(matrix) then
        Error("A square diagonal matrix is required.");
    fi;

    diagonal := List([1 .. n], position -> 0);
    for position in [1 .. n] do
        diagonal[position^permutation] := matrix[position][position];
    od;

    return DiagonalMat(diagonal);
end;


## For finite diagonal groups, a GL(n)-conjugacy embedding exists exactly
## when a coordinate permutation sends the source into the target.
CF_SearchDiagonalConjugacyEmbedding := function(firstGroup, secondGroup)
    local firstGenerators, secondGenerators, n, permutation,
          imageGenerators;

    if not IsGroup(firstGroup) or not IsGroup(secondGroup)
       or not IsFinite(firstGroup) or not IsFinite(secondGroup) then
        Error("Two finite matrix groups are required.");
    fi;
    if not IsAbelian(firstGroup) or not IsAbelian(secondGroup) then
        Error("The diagonal conjugacy backend requires abelian groups.");
    fi;
    if not IsInt(Size(secondGroup) / Size(firstGroup)) then
        return rec(
            ok := false,
            status := "no_embedding",
            reason := "order_divisibility",
            method := "diagonal_coordinate_permutations"
        );
    fi;

    firstGenerators := GeneratorsOfGroup(firstGroup);
    secondGenerators := GeneratorsOfGroup(secondGroup);
    n := CF_MatrixListDimension(firstGenerators);
    if CF_MatrixListDimension(secondGenerators) <> n then
        return rec(
            ok := false,
            status := "no_embedding",
            reason := "ambient_dimension",
            method := "diagonal_coordinate_permutations"
        );
    fi;
    if not ForAll(firstGenerators, IsDiagonalMatrix)
       or not ForAll(secondGenerators, IsDiagonalMatrix) then
        Error("Both groups must be diagonal in the supplied coordinates.");
    fi;

    for permutation in SymmetricGroup(n) do
        imageGenerators := List(
            firstGenerators,
            matrix -> CF_PermuteDiagonalMatrix(matrix, permutation)
        );
        if ForAll(imageGenerators, matrix -> matrix in secondGroup) then
            return rec(
                ok := true,
                status := "embedded",
                reason := "found",
                method := "diagonal_coordinate_permutations",
                coordinatePermutation := permutation,
                images := imageGenerators,
                P := fail
            );
        fi;
    od;

    return rec(
        ok := false,
        status := "no_embedding",
        reason := "exhausted_coordinate_permutations",
        method := "diagonal_coordinate_permutations"
    );
end;


#############################################################################
## 5. Proof-grade conjugacy embedding for finite matrix groups
#############################################################################

## Prepare a faithful permutation model.  The group identifier is annotation
## only and is never used as a negative embedding certificate.
PreprocessMatrixGroupStrict := function(generators, reportedOrder, groupId)
    local info, matrixGroup, isomorphism, order, dimension;

    if not IsList(generators) or Length(generators) = 0 then
        Error("A nonempty list of invertible square matrices is required.");
    fi;

    dimension := CF_MatrixListDimension(generators);
    if not ForAll(
        generators,
        matrix -> not IsZero(DeterminantMat(matrix))
    ) then
        Error("Every matrix-group generator must be invertible.");
    fi;

    info := rec();
    info.gens := generators;
    info.ambientDimension := dimension;
    info.reported_order := reportedOrder;
    info.h_id := groupId;
    info.h_id_doc := groupId;
    matrixGroup := Group(generators);
    info.G := matrixGroup;

    if not IsFinite(matrixGroup) then
        return rec(
            strict_ok := false,
            G := matrixGroup,
            gens := generators,
            ambientDimension := dimension,
            reason := "infinite_group"
        );
    fi;

    order := Size(matrixGroup);
    if reportedOrder <> fail and order <> reportedOrder then
        Print(
            "WARNING strict order mismatch reported=", reportedOrder,
            " computed=", order, "\n"
        );
    fi;

    isomorphism := IsomorphismPermGroup(matrixGroup);
    if isomorphism = fail then
        return rec(
            strict_ok := false,
            G := matrixGroup,
            gens := generators,
            ambientDimension := dimension,
            reason := "no_perm_model"
        );
    fi;

    info.iso_perm := isomorphism;
    info.P := Image(isomorphism);
    info.order := Size(info.P);
    SetSize(matrixGroup, info.order);
    info.strict_ok := true;
    info.ok := true;
    info.exponent := Exponent(info.P);
    return info;
end;


StrictEnsureFingerprints := function(info)
    if IsBound(info.fps) then
        return info.fps;
    fi;

    info.fps := ConjugacyFingerprintMultisets(info.G, info.iso_perm);
    return info.fps;
end;


StrictEnsureDerived := function(info)
    if not IsBound(info.derived_orders) then
        info.derived_orders := DerivedSeriesOrders(info.P);
    fi;

    return info.derived_orders;
end;


## Cache all source-side character data which are independent of the target.
## A source can be compared with many targets in a catalogue run, so these
## conjugacy classes and traces should be constructed only once.
StrictEnsureSourceCharacterData := function(info)
    local data;

    if IsBound(info.strict_source_character_data) then
        return info.strict_source_character_data;
    fi;

    data := rec();
    data.generators := info.gens;
    data.permutationGenerators := List(
        data.generators,
        element -> Image(info.iso_perm, element)
    );
    data.generatorTraces := List(data.generators, TraceMat);
    data.classRepresentatives := List(
        ConjugacyClasses(info.P),
        Representative
    );
    data.classTraces := List(
        data.classRepresentatives,
        element -> TraceMat(
            PreImagesRepresentative(info.iso_perm, element)
        )
    );
    info.strict_source_character_data := data;
    return data;
end;


## Cache a compact generating set used only to select the subgroup-search
## backend.  Failure is harmless and selects the general backend.
StrictEnsureSmallGeneratingSet := function(info)
    local caught;

    if IsBound(info.strict_small_generating_set_record) then
        return info.strict_small_generating_set_record;
    fi;

    caught := CALL_WITH_CATCH(SmallGeneratingSet, [info.P]);
    if not caught[1] then
        info.strict_small_generating_set_record := rec(
            ok := false,
            generators := fail
        );
    else
        info.strict_small_generating_set_record := rec(
            ok := true,
            generators := caught[2]
        );
    fi;
    return info.strict_small_generating_set_record;
end;


## Return the full automorphism group.  Exceeding max_aut gives an
## inconclusive record rather than a negative embedding result.
StrictAutGroup := function(info, options)
    local automorphismGroup, caught;

    if IsBound(info.strict_automorphism_group) then
        automorphismGroup := info.strict_automorphism_group;
    else
        caught := CALL_WITH_CATCH(AutomorphismGroup, [info.P]);
        if not caught[1] then
            return rec(
                exhaustive := false,
                size := fail,
                aut := fail,
                reason := "aut_error"
            );
        fi;
        automorphismGroup := caught[2];
        info.strict_automorphism_group := automorphismGroup;
    fi;
    if IsBound(options.max_aut)
       and Size(automorphismGroup) > options.max_aut then
        return rec(
            exhaustive := false,
            size := Size(automorphismGroup),
            aut := fail,
            reason := "aut_capped"
        );
    fi;

    return rec(
        exhaustive := true,
        size := Size(automorphismGroup),
        aut := automorphismGroup
    );
end;


## Return one representative of every outer-automorphism coset.  Inner
## twists are redundant: after an embedding phi, composing with conjugation
## by h in the source is target conjugation by phi(h), and hence preserves
## every target trace.  The transversal is cached on the source info record.
StrictOuterAutRepresentatives := function(info, options)
    local automorphismRecord, automorphismGroup, innerGroup,
          representatives, outerSize, caught;

    automorphismRecord := StrictAutGroup(info, options);
    if not automorphismRecord.exhaustive then
        return rec(
            exhaustive := false,
            automorphismSize := automorphismRecord.size,
            innerSize := fail,
            outerSize := fail,
            inner := fail,
            representatives := fail,
            reason := automorphismRecord.reason
        );
    fi;
    automorphismGroup := automorphismRecord.aut;

    if IsBound(info.strict_inner_automorphism_group) then
        innerGroup := info.strict_inner_automorphism_group;
    else
        caught := CALL_WITH_CATCH(
            InnerAutomorphismsAutomorphismGroup,
            [automorphismGroup]
        );
        if not caught[1] then
            return rec(
                exhaustive := false,
                automorphismSize := automorphismRecord.size,
                innerSize := fail,
                outerSize := fail,
                inner := fail,
                representatives := fail,
                reason := "inner_aut_error"
            );
        fi;
        innerGroup := caught[2];
        info.strict_inner_automorphism_group := innerGroup;
    fi;

    outerSize := Index(automorphismGroup, innerGroup);
    if IsBound(options.max_outer_aut)
       and outerSize > options.max_outer_aut then
        return rec(
            exhaustive := false,
            automorphismSize := automorphismRecord.size,
            innerSize := Size(innerGroup),
            outerSize := outerSize,
            inner := innerGroup,
            representatives := fail,
            reason := "outer_aut_capped"
        );
    fi;

    if IsBound(info.strict_outer_automorphism_representatives) then
        representatives :=
            info.strict_outer_automorphism_representatives;
    else
        caught := CALL_WITH_CATCH(
            RightTransversal,
            [automorphismGroup, innerGroup]
        );
        if not caught[1] then
            return rec(
                exhaustive := false,
                automorphismSize := automorphismRecord.size,
                innerSize := Size(innerGroup),
                outerSize := outerSize,
                inner := innerGroup,
                representatives := fail,
                reason := "outer_aut_transversal_error"
            );
        fi;
        representatives := caught[2];
        info.strict_outer_automorphism_representatives := representatives;
    fi;

    return rec(
        exhaustive := true,
        automorphismSize := automorphismRecord.size,
        innerSize := Size(innerGroup),
        outerSize := outerSize,
        inner := innerGroup,
        representatives := representatives
    );
end;


## Compatibility wrapper.  Large automorphism groups should be iterated
## directly through StrictAutGroup rather than materialized as a list.
StrictAutList := function(info, options)
    local automorphismRecord;

    automorphismRecord := StrictAutGroup(info, options);
    if not automorphismRecord.exhaustive then
        return rec(
            exhaustive := false,
            size := automorphismRecord.size,
            list := fail
        );
    fi;

    if automorphismRecord.size > 20000 then
        return rec(
            exhaustive := false,
            size := automorphismRecord.size,
            list := fail,
            reason := "aut_list_too_large_use_group"
        );
    fi;

    return rec(
        exhaustive := true,
        size := automorphismRecord.size,
        list := AsList(automorphismRecord.aut)
    );
end;


## Exact equality of the two natural characters on every conjugacy class.
StrictTraceAllClasses := function(firstInfo, secondInfo, homomorphism)
    local class, element, image;

    for class in ConjugacyClasses(firstInfo.P) do
        element := PreImagesRepresentative(
            firstInfo.iso_perm,
            Representative(class)
        );
        image := PreImagesRepresentative(
            secondInfo.iso_perm,
            Image(
                homomorphism,
                Image(firstInfo.iso_perm, element)
            )
        );

        if TraceMat(element) <> TraceMat(image) then
            return false;
        fi;
    od;

    return true;
end;


## Cache target traces for one isomorphism from the source permutation group.
IsoTraceTable := function(firstInfo, secondInfo, isomorphism)
    return rec(
        info_i := firstInfo,
        info_j := secondInfo,
        iso := isomorphism,
        cache := NewDictionary(One(firstInfo.P), true)
    );
end;


IsoTraceOf := function(table, element)
    local value, image;

    if KnowsDictionary(table.cache, element) then
        return LookupDictionary(table.cache, element);
    fi;

    image := PreImagesRepresentative(
        table.info_j.iso_perm,
        Image(table.iso, element)
    );
    value := TraceMat(image);
    AddDictionary(table.cache, element, value);
    return value;
end;


## Necessary conditions for a conjugacy embedding.  No catalogue group ID is
## used here: every negative result comes from an intrinsic invariant.
NecessaryFiltersStrict := function(firstInfo, secondInfo)
    local firstOk, secondOk;

    firstOk := (IsBound(firstInfo.strict_ok) and firstInfo.strict_ok)
        or (IsBound(firstInfo.ok) and firstInfo.ok);
    secondOk := (IsBound(secondInfo.strict_ok) and secondInfo.strict_ok)
        or (IsBound(secondInfo.ok) and secondInfo.ok);

    if not firstOk or not secondOk then
        return rec(ok := false, reason := "bad_group_data");
    fi;

    if firstInfo.order = fail or secondInfo.order = fail then
        return rec(ok := false, reason := "bad_group_data");
    fi;

    if not IsInt(secondInfo.order / firstInfo.order) then
        return rec(ok := false, reason := "order_divisibility");
    fi;

    if firstInfo.exponent <> fail and secondInfo.exponent <> fail then
        if not IsInt(secondInfo.exponent / firstInfo.exponent) then
            return rec(ok := false, reason := "exponent");
        fi;
    fi;

    if IsBound(firstInfo.derived_orders)
       and IsBound(secondInfo.derived_orders)
       and firstInfo.derived_orders <> fail
       and secondInfo.derived_orders <> fail
       and Length(firstInfo.derived_orders)
           <= Length(secondInfo.derived_orders) then
        if ForAny(
            [1 .. Length(firstInfo.derived_orders)],
            position -> not IsInt(
                secondInfo.derived_orders[position]
                / firstInfo.derived_orders[position]
            )
        ) then
            return rec(ok := false, reason := "derived_series");
        fi;
    fi;

    if IsBound(firstInfo.fps) and IsBound(secondInfo.fps)
       and firstInfo.fps <> fail and secondInfo.fps <> fail then
        if not IsSubmultisetWeighted(
            firstInfo.fps.element_orders,
            secondInfo.fps.element_orders
        ) then
            return rec(ok := false, reason := "element_order_multiset");
        fi;

        if not IsSubmultisetWeighted(
            firstInfo.fps.weak,
            secondInfo.fps.weak
        ) then
            return rec(ok := false, reason := "weak_fingerprint");
        fi;

        if not IsSubmultisetWeighted(
            firstInfo.fps.strong,
            secondInfo.fps.strong
        ) then
            return rec(ok := false, reason := "strong_fingerprint");
        fi;
    fi;

    return rec(ok := true, reason := "passed");
end;


## Exhaustively search subgroup images and outer-automorphism twists of the
## source.  Inner twists are target-conjugate to the identity twist and need
## not be repeated.  An infrastructure or resource failure is returned as
## exhaustive=false and must never be interpreted as non-embedding.
AlgorithmAStrict := function(firstInfo, secondInfo, stopFirst, options)
    local firstGroup, secondGroup, firstPermGroup, secondPermGroup,
          embeddings, generators, permutationGenerators,
          sourceCharacterData,
          outerAutomorphismRecord, outerAutomorphismRepresentatives,
          innerAutomorphismGroup, results,
          isomorphism, automorphism, homomorphism, imageMatrices,
          firstOrder, secondOrder, subgroup, subgroupClass,
          primes, prime, Sylow, matches, position, traceTable,
          generatorTraces, classRepresentatives, classTraces,
          smallGeneratorRecord, useSubgroupClasses,
          representative, caught;

    results := [];
    if not (IsBound(firstInfo.strict_ok) and firstInfo.strict_ok) then
        return rec(
            exhaustive := false,
            list := results,
            reason := "i_not_strict"
        );
    fi;
    if not (IsBound(secondInfo.strict_ok) and secondInfo.strict_ok) then
        return rec(
            exhaustive := false,
            list := results,
            reason := "j_not_strict"
        );
    fi;

    firstGroup := firstInfo.G;
    secondGroup := secondInfo.G;
    firstPermGroup := firstInfo.P;
    secondPermGroup := secondInfo.P;
    firstOrder := Size(firstPermGroup);
    secondOrder := Size(secondPermGroup);

    if not IsInt(secondOrder / firstOrder) then
        return rec(exhaustive := true, list := results, reason := "order");
    fi;

    primes := PrimeDivisors(firstOrder);
    embeddings := [];
    smallGeneratorRecord := StrictEnsureSmallGeneratingSet(firstInfo);
    useSubgroupClasses :=
        secondOrder <= 2000
        and smallGeneratorRecord.ok
        and Length(smallGeneratorRecord.generators) > 2;

    ## Equal orders require only a group isomorphism: the image subgroup must
    ## be the whole target.  This avoids any subgroup enumeration.
    if firstOrder = secondOrder then
        caught := CALL_WITH_CATCH(
            IsomorphismGroups,
            [firstPermGroup, secondPermGroup]
        );
        if not caught[1] then
            return rec(
                exhaustive := false,
                list := results,
                reason := "isomorphism_groups_error"
            );
        fi;
        if caught[2] <> fail then
            Add(embeddings, caught[2]);
        fi;
    elif Length(primes) = 1 and firstOrder <= 100 then
        ## GAP's general isomorphic-subgroup search is often slow for
        ## p-groups.  The Sylow-subgroup path is exhaustive and retains the
        ## established specialized logic.
        prime := primes[1];
        Sylow := SylowSubgroup(secondPermGroup, prime);
        caught := CALL_WITH_CATCH(AllSubgroups, [Sylow]);
        if not caught[1] then
            return rec(
                exhaustive := false,
                list := results,
                reason := "allsubgroups_error"
            );
        fi;

        for subgroup in caught[2] do
            if Size(subgroup) = firstOrder then
                isomorphism := IsomorphismGroups(
                    firstPermGroup,
                    subgroup
                );
                if isomorphism <> fail then
                    Add(embeddings, isomorphism);
                fi;
            fi;
        od;
    elif useSubgroupClasses then
        ## IsomorphicSubgroups can be exceptionally slow when the source
        ## genuinely needs more than two generators.  For a small target,
        ## enumerating its subgroup conjugacy classes is complete and is the
        ## backend recommended by GAP's own performance warning.  Cache the
        ## class list because one target can be used many times.
        if IsBound(secondInfo.strict_subgroup_conjugacy_classes) then
            caught := [ true,
                secondInfo.strict_subgroup_conjugacy_classes ];
        else
            caught := CALL_WITH_CATCH(
                ConjugacyClassesSubgroups,
                [secondPermGroup]
            );
            if caught[1] then
                secondInfo.strict_subgroup_conjugacy_classes := caught[2];
            fi;
        fi;
        if not caught[1] then
            return rec(
                exhaustive := false,
                list := results,
                reason := "ccs_error"
            );
        fi;
        for subgroupClass in caught[2] do
            subgroup := Representative(subgroupClass);
            if Size(subgroup) = firstOrder then
                isomorphism := IsomorphismGroups(
                    firstPermGroup,
                    subgroup
                );
                if isomorphism <> fail then
                    Add(embeddings, isomorphism);
                fi;
            fi;
        od;
    else
        ## IsomorphicSubgroups returns monomorphisms whose image subgroups
        ## represent all target-conjugacy classes isomorphic to the source.
        ## Source outer-automorphism representatives are handled below.
        if IsBound(options.allow_hard_iso)
           and options.allow_hard_iso = false
           and secondOrder > 2000 then
            return rec(
                exhaustive := false,
                list := results,
                reason := "hard_iso_deferred"
            );
        fi;

        caught := CALL_WITH_CATCH(
            IsomorphicSubgroups,
            [secondPermGroup, firstPermGroup]
        );
        if not caught[1] then
            return rec(
                exhaustive := false,
                list := results,
                reason := "isomorphic_subgroups_error"
            );
        fi;
        embeddings := caught[2];
    fi;

    sourceCharacterData := StrictEnsureSourceCharacterData(firstInfo);
    generators := sourceCharacterData.generators;
    permutationGenerators := sourceCharacterData.permutationGenerators;
    generatorTraces := sourceCharacterData.generatorTraces;
    classRepresentatives := sourceCharacterData.classRepresentatives;
    classTraces := sourceCharacterData.classTraces;

    outerAutomorphismRecord :=
        StrictOuterAutRepresentatives(firstInfo, options);
    if not outerAutomorphismRecord.exhaustive then
        if IsBound(outerAutomorphismRecord.reason) then
            return rec(
                exhaustive := false,
                list := results,
                reason := outerAutomorphismRecord.reason
            );
        fi;
        return rec(
            exhaustive := false,
            list := results,
            reason := "outer_aut_error"
        );
    fi;
    outerAutomorphismRepresentatives :=
        outerAutomorphismRecord.representatives;
    innerAutomorphismGroup := outerAutomorphismRecord.inner;

    for isomorphism in embeddings do
        traceTable := IsoTraceTable(firstInfo, secondInfo, isomorphism);

        matches := true;
        for position in [1 .. Length(permutationGenerators)] do
            if generatorTraces[position]
               <> IsoTraceOf(
                   traceTable,
                   permutationGenerators[position]
               ) then
                matches := false;
                break;
            fi;
        od;

        if matches then
            for position in [1 .. Length(classRepresentatives)] do
                if classTraces[position]
                   <> IsoTraceOf(
                       traceTable,
                       classRepresentatives[position]
                   ) then
                    matches := false;
                    break;
                fi;
            od;
        fi;

        if matches then
            homomorphism := GroupHomomorphismByImages(
                firstPermGroup,
                secondPermGroup,
                permutationGenerators,
                List(
                    permutationGenerators,
                    element -> Image(isomorphism, element)
                )
            );

            if homomorphism <> fail and IsInjective(homomorphism) then
                imageMatrices := List(
                    generators,
                    element -> PreImagesRepresentative(
                        secondInfo.iso_perm,
                        Image(
                            homomorphism,
                            Image(firstInfo.iso_perm, element)
                        )
                    )
                );
                Add(
                    results,
                    rec(images := imageMatrices, method := "A_strict")
                );

                if stopFirst then
                    return rec(
                        exhaustive := true,
                        list := results,
                        reason := "found"
                    );
                fi;
                continue;
            fi;
        fi;

        ## The identity twist was tested above.  The unique representative
        ## lying in Inn(H) is therefore skipped as well.
        for automorphism in outerAutomorphismRepresentatives do
            if automorphism in innerAutomorphismGroup then
                continue;
            fi;
            matches := true;
            for position in [1 .. Length(permutationGenerators)] do
                if generatorTraces[position]
                   <> IsoTraceOf(
                       traceTable,
                       Image(
                           automorphism,
                           permutationGenerators[position]
                       )
                   ) then
                    matches := false;
                    break;
                fi;
            od;

            if not matches then
                continue;
            fi;

            for position in [1 .. Length(classRepresentatives)] do
                if classTraces[position]
                   <> IsoTraceOf(
                       traceTable,
                       Image(
                           automorphism,
                           classRepresentatives[position]
                       )
                   ) then
                    matches := false;
                    break;
                fi;
            od;

            if not matches then
                continue;
            fi;

            homomorphism := GroupHomomorphismByImages(
                firstPermGroup,
                secondPermGroup,
                permutationGenerators,
                List(
                    permutationGenerators,
                    element -> Image(
                        isomorphism,
                        Image(automorphism, element)
                    )
                )
            );

            if homomorphism = fail or not IsInjective(homomorphism) then
                continue;
            fi;

            imageMatrices := List(
                generators,
                element -> PreImagesRepresentative(
                    secondInfo.iso_perm,
                    Image(
                        homomorphism,
                        Image(firstInfo.iso_perm, element)
                    )
                )
            );
            Add(
                results,
                rec(images := imageMatrices, method := "A_strict")
            );

            if stopFirst then
                return rec(
                    exhaustive := true,
                    list := results,
                    reason := "found"
                );
            fi;
            break;
        od;

        if Length(results) > 0 and stopFirst then
            return rec(
                exhaustive := true,
                list := results,
                reason := "found"
            );
        fi;
    od;

    return rec(
        exhaustive := true,
        list := results,
        reason := "exhausted_no_verified_candidate"
    );
end;


## Try to construct an explicit conjugating matrix.  A failed witness search
## does not negate a character-theoretically proved embedding.
StrictVerifyCandidates := function(firstInfo, secondInfo, candidates)
    local firstGenerators, candidate, matrix;

    firstGenerators := firstInfo.gens;
    for candidate in candidates do
        matrix := FindInvertibleIntertwiner(
            firstGenerators,
            candidate.images
        );
        if matrix = fail then
            continue;
        fi;

        if VerifyConjugation(
            firstGenerators,
            candidate.images,
            matrix,
            secondInfo.G
        ) then
            return rec(
                found := true,
                P := matrix,
                images := candidate.images,
                method := candidate.method
            );
        fi;
    od;

    return rec(found := false);
end;


## Complete strict entry point.  Its status is one of embedded,
## no_embedding, or undecided.  Only exhaustive negative searches return
## no_embedding.
SearchEmbeddingStrict := function(firstInfo, secondInfo, arg...)
    local options, filters, search, verification,
          firstDimension, secondDimension, constructWitness, literalWitness;

    if Length(arg) = 0 then
        options := rec();
    else
        options := arg[1];
    fi;
    if not IsRecord(options) then
        Error("Strict embedding options must be a record.");
    fi;
    if not IsBound(options.stop_first) then
        options.stop_first := false;
    fi;
    if not IsBound(options.try_literal_inclusion) then
        options.try_literal_inclusion := true;
    fi;
    if options.try_literal_inclusion <> true
       and options.try_literal_inclusion <> false then
        Error("try_literal_inclusion must be true or false.");
    fi;
    if not IsBound(options.use_fingerprints) then
        options.use_fingerprints := true;
    fi;
    if options.use_fingerprints <> true
       and options.use_fingerprints <> false then
        Error("use_fingerprints must be true or false.");
    fi;
    constructWitness := true;
    if IsBound(options.construct_witness) then
        if options.construct_witness <> true
           and options.construct_witness <> false then
            Error("construct_witness must be true or false.");
        fi;
        constructWitness := options.construct_witness;
    fi;

    if not (IsBound(firstInfo.strict_ok) and firstInfo.strict_ok) then
        return rec(
            ok := fail,
            status := "undecided",
            reason := "preprocess_i",
            method := "strict"
        );
    fi;
    if not (IsBound(secondInfo.strict_ok) and secondInfo.strict_ok) then
        return rec(
            ok := fail,
            status := "undecided",
            reason := "preprocess_j",
            method := "strict"
        );
    fi;

    if IsBound(firstInfo.ambientDimension) then
        firstDimension := firstInfo.ambientDimension;
    else
        firstDimension := CF_MatrixListDimension(firstInfo.gens);
    fi;
    if IsBound(secondInfo.ambientDimension) then
        secondDimension := secondInfo.ambientDimension;
    else
        secondDimension := CF_MatrixListDimension(secondInfo.gens);
    fi;
    if firstDimension <> secondDimension then
        return rec(
            ok := false,
            status := "no_embedding",
            reason := "ambient_dimension",
            method := "filter"
        );
    fi;

    if firstInfo.order = fail or secondInfo.order = fail then
        return rec(
            ok := fail,
            status := "undecided",
            reason := "bad_group_data",
            method := "filter"
        );
    fi;
    if not IsInt(secondInfo.order / firstInfo.order) then
        return rec(
            ok := false,
            status := "no_embedding",
            reason := "order_divisibility",
            method := "filter"
        );
    fi;
    if firstInfo.exponent <> fail and secondInfo.exponent <> fail then
        if not IsInt(secondInfo.exponent / firstInfo.exponent) then
            return rec(
                ok := false,
                status := "no_embedding",
                reason := "exponent",
                method := "filter"
            );
        fi;
    fi;

    ## Many catalogue records use compatible coordinates.  Literal matrix
    ## containment is already a complete positive certificate with P = 1.
    ## Failure of this fast path is not used as a negative result.
    if options.try_literal_inclusion = true
       and ForAll(
           firstInfo.gens,
           element -> element in secondInfo.G
       ) then
        if constructWitness then
            literalWitness := IdentityMat(firstDimension);
        else
            literalWitness := fail;
        fi;
        return rec(
            ok := true,
            status := "embedded",
            reason := "literal_matrix_subgroup",
            method := "literal_matrix_subgroup",
            P := literalWitness,
            images := ShallowCopy(firstInfo.gens)
        );
    fi;

    ## Derived-series orders are normally cheaper than the full element and
    ## characteristic-polynomial fingerprints.  Apply that exact necessary
    ## filter first, and construct fingerprints only for surviving pairs.
    StrictEnsureDerived(firstInfo);
    StrictEnsureDerived(secondInfo);
    filters := NecessaryFiltersStrict(firstInfo, secondInfo);

    if not filters.ok then
        if filters.reason = "bad_group_data" then
            return rec(
                ok := fail,
                status := "undecided",
                reason := "bad_group_data",
                method := "filter"
            );
        fi;
        return rec(
            ok := false,
            status := "no_embedding",
            reason := filters.reason,
            method := "filter"
        );
    fi;

    # Fingerprints are optional necessary filters.  Disabling them changes
    # only the fast rejection stage: AlgorithmAStrict below still performs
    # the exhaustive subgroup and character comparison.
    if options.use_fingerprints then
        StrictEnsureFingerprints(firstInfo);
        StrictEnsureFingerprints(secondInfo);
        filters := NecessaryFiltersStrict(firstInfo, secondInfo);

        if not filters.ok then
            if filters.reason = "bad_group_data" then
                return rec(
                    ok := fail,
                    status := "undecided",
                    reason := "bad_group_data",
                    method := "filter"
                );
            fi;
            return rec(
                ok := false,
                status := "no_embedding",
                reason := filters.reason,
                method := "filter"
            );
        fi;
    fi;

    search := AlgorithmAStrict(
        firstInfo,
        secondInfo,
        options.stop_first,
        options
    );
    if not search.exhaustive then
        return rec(
            ok := fail,
            status := "undecided",
            reason := search.reason,
            method := "A_strict"
        );
    fi;
    if Length(search.list) = 0 then
        return rec(
            ok := false,
            status := "no_embedding",
            reason := "exhausted_no_verified_candidate",
            method := "A_strict"
        );
    fi;

    if not constructWitness then
        return rec(
            ok := true,
            status := "embedded",
            reason := "character_iso_witness_skipped",
            method := search.list[1].method,
            P := fail,
            images := search.list[1].images
        );
    fi;

    verification := StrictVerifyCandidates(
        firstInfo,
        secondInfo,
        search.list
    );
    if verification.found then
        return rec(
            ok := true,
            status := "embedded",
            reason := "found",
            method := verification.method,
            P := verification.P,
            images := verification.images
        );
    fi;

    ## Over characteristic zero, equality of the natural characters of two
    ## finite-group representations proves their linear equivalence.  Thus an
    ## injective character-matching homomorphism proves the embedding even if
    ## the optional explicit intertwiner was not found.
    return rec(
        ok := true,
        status := "embedded",
        reason := "character_iso_no_explicit_P",
        method := search.list[1].method,
        P := fail,
        images := search.list[1].images
    );
end;


## Search through a specified intermediate subgroup.  A negative result in
## the intermediate group is globally negative only when the caller supplies
## N_is_embedding_complete := true.
SearchEmbeddingStrictViaSubgroup := function(
    firstInfo,
    subgroupInfo,
    secondInfo,
    arg...
)
    local result, matrix, inverse, options;

    result := CallFuncList(
        SearchEmbeddingStrict,
        Concatenation([firstInfo, subgroupInfo], arg)
    );

    if Length(arg) = 0 then
        options := rec();
    else
        options := arg[1];
    fi;

    if result.ok <> true then
        if IsBound(result.status) and result.status = "no_embedding" then
            if IsBound(options.N_is_embedding_complete)
               and options.N_is_embedding_complete = true then
                return result;
            fi;
            return rec(
                ok := fail,
                status := "undecided",
                reason := "no_embedding_via_N",
                method := "A_strict+viaN"
            );
        fi;
        return result;
    fi;

    if IsBound(result.P) and result.P <> fail then
        matrix := result.P;
        inverse := matrix^-1;
        if not ForAll(
            firstInfo.gens,
            element -> inverse * element * matrix in secondInfo.G
        ) then
            return rec(
                ok := fail,
                status := "undecided",
                reason := "viaN_not_in_ambient",
                method := "A_strict+viaN"
            );
        fi;
        return rec(
            ok := true,
            status := "embedded",
            reason := "found_via_subgroup",
            method := "A_strict+viaN",
            P := matrix,
            images := result.images
        );
    fi;

    if not IsBound(result.images) then
        return rec(
            ok := fail,
            status := "undecided",
            reason := "viaN_no_images",
            method := "A_strict+viaN"
        );
    fi;
    if not ForAll(result.images, matrix -> matrix in secondInfo.G) then
        return rec(
            ok := fail,
            status := "undecided",
            reason := "viaN_not_in_ambient",
            method := "A_strict+viaN"
        );
    fi;

    return rec(
        ok := true,
        status := "embedded",
        reason := "character_iso_via_subgroup_no_explicit_P",
        method := "A_strict+viaN",
        P := fail,
        images := result.images
    );
end;


ComposeEmbeddingWitness := function(firstMatrix, secondMatrix)
    return firstMatrix * secondMatrix;
end;


#############################################################################
## 6. Degree-three invariant polynomials
#############################################################################

CF_DegreeThreeExponentVectors := function(numberOfVariables)
    local answer, current, search;

    if not IsInt(numberOfVariables) or numberOfVariables < 1 then
        Error("The number of variables must be a positive integer.");
    fi;

    answer := [];
    current := List([1 .. numberOfVariables], i -> 0);

    search := function(position, remainingDegree)
        local value;

        if position = numberOfVariables then
            current[position] := remainingDegree;
            Add(answer, ShallowCopy(current));
            return;
        fi;

        for value in [0 .. remainingDegree] do
            current[position] := value;
            search(position + 1, remainingDegree - value);
        od;
    end;

    search(1, 3);
    return answer;
end;


## Compatibility wrapper preserving the original function name and order.
CF_DegreeThreeExponentVectors6 := function()
    return CF_DegreeThreeExponentVectors(6);
end;


CF_MultiplyTermsByLinearForm := function(terms, coefficients)
    local numberOfVariables, newTerms, term, i, newExponent, position;

    numberOfVariables := Length(coefficients);
    newTerms := [];

    for term in terms do
        if Length(term.exponent) <> numberOfVariables then
            Error("A term exponent has the wrong number of variables.");
        fi;

        for i in [1 .. numberOfVariables] do
            if coefficients[i] <> 0 then
                newExponent := ShallowCopy(term.exponent);
                newExponent[i] := newExponent[i] + 1;
                position := Position(
                    List(newTerms, record -> record.exponent),
                    newExponent
                );

                if position = fail then
                    Add(
                        newTerms,
                        rec(
                            exponent := newExponent,
                            coefficient := term.coefficient * coefficients[i]
                        )
                    );
                else
                    newTerms[position].coefficient :=
                        newTerms[position].coefficient
                        + term.coefficient * coefficients[i];
                fi;
            fi;
        od;
    od;

    return Filtered(newTerms, record -> record.coefficient <> 0);
end;


## Image of x^exponent under x |-> x*A in the supplied monomial basis.
CF_MonomialImageVector := function(exponent, matrix, exponentBasis)
    local numberOfVariables, terms, j, powerIndex, coefficients,
          vector, term, position;

    numberOfVariables := Length(exponent);
    if CF_SquareMatrixDimension(matrix) <> numberOfVariables then
        Error("The matrix and monomial exponent have incompatible dimensions.");
    fi;

    if not ForAll(
        exponentBasis,
        item -> Length(item) = numberOfVariables
    ) then
        Error("The monomial basis has incompatible exponent lengths.");
    fi;

    terms := [
        rec(
            exponent := List([1 .. numberOfVariables], i -> 0),
            coefficient := 1
        )
    ];

    for j in [1 .. numberOfVariables] do
        coefficients := List(
            [1 .. numberOfVariables],
            i -> matrix[i][j]
        );

        for powerIndex in [1 .. exponent[j]] do
            terms := CF_MultiplyTermsByLinearForm(terms, coefficients);
        od;
    od;

    vector := List([1 .. Length(exponentBasis)], i -> 0);
    for term in terms do
        position := Position(exponentBasis, term.exponent);
        if position = fail then
            Error("A transformed cubic term left the degree-three basis.");
        fi;
        vector[position] := vector[position] + term.coefficient;
    od;

    return vector;
end;


CF_MonomialString := function(exponent)
    local factors, i;

    factors := [];
    for i in [1 .. Length(exponent)] do
        if exponent[i] = 1 then
            Add(factors, Concatenation("x", String(i)));
        elif exponent[i] > 1 then
            Add(
                factors,
                Concatenation(
                    "x", String(i), "^", String(exponent[i])
                )
            );
        fi;
    od;

    if Length(factors) = 0 then
        return "1";
    fi;

    return CF_JoinStrings(factors, "*");
end;


## Exact fast path for a diagonal action.  Degree-three monomials are
## simultaneous eigenvectors, and centralizer blocks are the equal coordinate
## characters of the supplied generators.
CF_DiagonalCubicModuliData := function(arg)
    local obj, buildStrings, generators, n, matrix, i, j, k,
          signatures, blockSignatures, blockSizes, signature, position,
          centralizerDimension, invariantExponents, exponent, invariant,
          weight, basisStrings;

    if Length(arg) < 1 or Length(arg) > 2 then
        Error("Use CF_DiagonalCubicModuliData(obj[, buildStrings]).");
    fi;

    obj := arg[1];
    buildStrings := false;
    if Length(arg) = 2 then
        buildStrings := arg[2];
        if buildStrings <> true and buildStrings <> false then
            Error("The build-strings option must be boolean.");
        fi;
    fi;

    if IsGroup(obj) then
        generators := GeneratorsOfGroup(obj);
        if Length(generators) = 0 then
            generators := [One(obj)];
        fi;
    elif IsMatrix(obj) then
        generators := [obj];
    elif IsList(obj) and Length(obj) > 0 then
        generators := obj;
    else
        Error(
            "The input must be a matrix group, a diagonal matrix, ",
            "or a nonempty list of diagonal matrices."
        );
    fi;

    n := CF_MatrixListDimension(generators);
    if n = fail then
        Error("Could not determine a common matrix dimension.");
    fi;
    for matrix in generators do
        if not IsDiagonalMatrix(matrix) then
            Error("Every matrix generator must be diagonal.");
        fi;
        for i in [1 .. n] do
            if matrix[i][i] = 0 then
                Error("Every diagonal entry must be nonzero.");
            fi;
        od;
    od;

    signatures := List(
        [1 .. n],
        i -> List(generators, matrix -> matrix[i][i])
    );
    blockSignatures := [];
    blockSizes := [];
    for signature in signatures do
        position := Position(blockSignatures, signature);
        if position = fail then
            Add(blockSignatures, signature);
            Add(blockSizes, 1);
        else
            blockSizes[position] := blockSizes[position] + 1;
        fi;
    od;
    centralizerDimension := Sum(blockSizes, size -> size^2);

    invariantExponents := [];
    for i in [1 .. n] do
        for j in [i .. n] do
            for k in [j .. n] do
                invariant := true;
                for matrix in generators do
                    weight := matrix[i][i] * matrix[j][j]
                              * matrix[k][k];
                    if weight <> 1 then
                        invariant := false;
                        break;
                    fi;
                od;

                if invariant then
                    exponent := List([1 .. n], position -> 0);
                    exponent[i] := exponent[i] + 1;
                    exponent[j] := exponent[j] + 1;
                    exponent[k] := exponent[k] + 1;
                    Add(invariantExponents, exponent);
                fi;
            od;
        od;
    od;

    if buildStrings then
        basisStrings := List(invariantExponents, CF_MonomialString);
    else
        basisStrings := fail;
    fi;

    return rec(
        ambientDimension := n,
        degree := 3,
        invariantCubicDimension := Length(invariantExponents),
        projectiveInvariantDimension := Length(invariantExponents) - 1,
        centralizerBlocks := blockSizes,
        centralizerGLDimension := centralizerDimension,
        centralizerPGLDimension := centralizerDimension - 1,
        familyDimension :=
            Length(invariantExponents) - centralizerDimension,
        invariantExponentVectors := invariantExponents,
        invariantCubicBasisStrings := basisStrings,
        method := "diagonal_weights_and_character_blocks"
    );
end;


CF_CoefficientVectorToPolynomialString := function(vector, exponentBasis)
    local terms, i, coefficient, monomial;

    if Length(vector) <> Length(exponentBasis) then
        Error("The coefficient vector and monomial basis have different lengths.");
    fi;

    terms := [];
    for i in [1 .. Length(vector)] do
        coefficient := vector[i];
        if coefficient <> 0 then
            monomial := CF_MonomialString(exponentBasis[i]);

            if coefficient = 1 then
                Add(terms, monomial);
            elif coefficient = -1 then
                Add(terms, Concatenation("-", monomial));
            else
                Add(
                    terms,
                    Concatenation(
                        "(", String(coefficient), ")*", monomial
                    )
                );
            fi;
        fi;
    od;

    if Length(terms) = 0 then
        return "0";
    fi;

    return CF_JoinStrings(terms, " + ");
end;


CF_MonomialFromExponent := function(variables, exponent, ring)
    local monomial, i;

    if Length(variables) <> Length(exponent) then
        Error("The variable and exponent lists have different lengths.");
    fi;

    monomial := One(ring);
    for i in [1 .. Length(exponent)] do
        if exponent[i] > 0 then
            monomial := monomial * variables[i]^exponent[i];
        fi;
    od;

    return monomial;
end;


CF_CoefficientVectorToPolynomial := function(vector, monomials, ring)
    local polynomial, i;

    if Length(vector) <> Length(monomials) then
        Error("Coefficient and monomial lists have different lengths.");
    fi;

    polynomial := Zero(ring);
    for i in [1 .. Length(vector)] do
        if vector[i] <> 0 then
            polynomial := polynomial + vector[i] * monomials[i];
        fi;
    od;

    return polynomial;
end;


CF_ReduceGeneratorsForCubicInvariants := function(matrixGenerators)
    local n, kept, matrix, previous, ratio, duplicate, scalarValue;

    if Length(matrixGenerators) = 0 then
        return [];
    fi;

    n := CF_MatrixListDimension(matrixGenerators);
    kept := [];

    for matrix in matrixGenerators do
        if CF_SquareMatrixDimension(matrix) <> n then
            Error("The cubic-invariant generators have incompatible dimensions.");
        fi;

        if CF_IsScalarMatrix(matrix) then
            scalarValue := matrix[1][1];
            if scalarValue^3 <> 1 then
                Error("A scalar outside mu_3 cannot fix a nonzero cubic.");
            fi;
        else
            duplicate := false;
            for previous in kept do
                ratio := CF_ScalarMultipleRatio(matrix, previous);
                if ratio <> fail and ratio^3 = 1 then
                    duplicate := true;
                    break;
                fi;
            od;

            if not duplicate then
                Add(kept, matrix);
            fi;
        fi;
    od;

    return kept;
end;


CF_ReduceGeneratorsForCentralizer := function(matrixGenerators)
    local n, kept, matrix, previous, duplicate;

    if Length(matrixGenerators) = 0 then
        return [];
    fi;

    n := CF_MatrixListDimension(matrixGenerators);
    kept := [];

    for matrix in matrixGenerators do
        if CF_SquareMatrixDimension(matrix) <> n then
            Error("The centralizer generators have incompatible dimensions.");
        fi;

        if not CF_IsScalarMatrix(matrix) then
            duplicate := ForAny(
                kept,
                previous -> CF_ScalarMultipleRatio(matrix, previous) <> fail
            );

            if not duplicate then
                Add(kept, matrix);
            fi;
        fi;
    od;

    return kept;
end;


CF_RestrictRowBasisByEquationRows := function(basis, equations)
    local reducedEquations, coefficientBasis, ambientDimension;

    if Length(basis) = 0 or Length(equations) = 0 then
        return basis;
    fi;

    ambientDimension := Length(basis[1]);
    if not ForAll(basis, vector -> Length(vector) = ambientDimension) then
        Error("The row basis has incompatible vector lengths.");
    fi;

    if not ForAll(equations, row -> Length(row) = ambientDimension) then
        Error("An equation row has the wrong length.");
    fi;

    reducedEquations := List(
        equations,
        row -> List(
            [1 .. Length(basis)],
            i -> Sum(
                [1 .. ambientDimension],
                j -> row[j] * basis[i][j]
            )
        )
    );
    reducedEquations := Filtered(
        reducedEquations,
        row -> ForAny(row, entry -> entry <> 0)
    );

    if Length(reducedEquations) = 0 then
        return basis;
    fi;

    coefficientBasis := CF_NullspaceOfEquationRows(
        reducedEquations,
        Length(basis)
    );

    return List(
        coefficientBasis,
        coefficients -> List(
            [1 .. ambientDimension],
            j -> Sum(
                [1 .. Length(basis)],
                i -> coefficients[i] * basis[i][j]
            )
        )
    );
end;


CF_PrepareCubicPolynomialContext := function(arg)
    local numberOfVariables, exponentBasis, ring, variables,
          monomials, variableNames;

    if Length(arg) > 1 then
        Error("Use CF_PrepareCubicPolynomialContext([numberOfVariables]).");
    fi;

    if Length(arg) = 1 then
        numberOfVariables := arg[1];
    else
        numberOfVariables := 6;
    fi;

    exponentBasis := CF_DegreeThreeExponentVectors(numberOfVariables);
    variableNames := List(
        [1 .. numberOfVariables],
        i -> Concatenation("x", String(i))
    );
    ring := PolynomialRing(Cyclotomics, variableNames);
    variables := IndeterminatesOfPolynomialRing(ring);
    monomials := List(
        exponentBasis,
        exponent -> CF_MonomialFromExponent(variables, exponent, ring)
    );

    return rec(
        dimension      := numberOfVariables,
        exponentBasis  := exponentBasis,
        polynomialRing := ring,
        variables      := variables,
        monomials      := monomials
    );
end;


## The degree remains fixed at three.  The ambient dimension is inferred from
## the matrices.  For an empty list it can be supplied as
## rec(ambientDimension := n); otherwise the legacy default is 6.
CF_CubicInvariantBasis := function(arg)
    local matrixGenerators, options, buildPolynomialObjects, buildStrings,
          polynomialContext, numberOfVariables, exponentBasis,
          monomialCount, reducedGenerators, basis, matrix, columns,
          equations, i, j, row, ring, variables, monomials,
          polynomials, strings, initialGeneratorCount;

    if Length(arg) < 1 or Length(arg) > 2 then
        Error("Use CF_CubicInvariantBasis(matrixGenerators[, options]).");
    fi;

    matrixGenerators := arg[1];
    buildPolynomialObjects := true;
    buildStrings := true;
    polynomialContext := fail;
    numberOfVariables := fail;

    if Length(arg) = 2 then
        options := arg[2];
        if not IsRecord(options) then
            Error("The cubic-invariant options must be a record.");
        fi;

        if IsBound(options.buildPolynomialObjects) then
            buildPolynomialObjects := options.buildPolynomialObjects;
        fi;
        if IsBound(options.buildStrings) then
            buildStrings := options.buildStrings;
        fi;
        if IsBound(options.polynomialContext) then
            polynomialContext := options.polynomialContext;
        fi;
        if IsBound(options.ambientDimension) then
            numberOfVariables := options.ambientDimension;
        fi;
    fi;

    if Length(matrixGenerators) > 0 then
        if numberOfVariables = fail then
            numberOfVariables := CF_MatrixListDimension(matrixGenerators);
        elif CF_MatrixListDimension(matrixGenerators) <> numberOfVariables then
            Error("The supplied ambient dimension does not match the matrices.");
        fi;
    elif numberOfVariables = fail then
        numberOfVariables := 6;
    fi;

    exponentBasis := CF_DegreeThreeExponentVectors(numberOfVariables);
    monomialCount := Length(exponentBasis);
    initialGeneratorCount := Length(matrixGenerators);
    reducedGenerators := CF_ReduceGeneratorsForCubicInvariants(
        matrixGenerators
    );
    basis := IdentityMat(monomialCount);

    for matrix in reducedGenerators do
        columns := List(
            exponentBasis,
            exponent -> CF_MonomialImageVector(
                exponent,
                matrix,
                exponentBasis
            )
        );
        equations := [];

        for i in [1 .. monomialCount] do
            row := List(
                [1 .. monomialCount],
                j -> columns[j][i]
            );
            row[i] := row[i] - 1;

            if ForAny(row, entry -> entry <> 0) then
                Add(equations, row);
            fi;
        od;

        basis := CF_RestrictRowBasisByEquationRows(basis, equations);
        if Length(basis) = 0 then
            break;
        fi;
    od;

    ring := fail;
    variables := fail;
    monomials := fail;
    polynomials := fail;

    if buildPolynomialObjects then
        if polynomialContext = fail then
            polynomialContext := CF_PrepareCubicPolynomialContext(
                numberOfVariables
            );
        elif IsBound(polynomialContext.dimension)
             and polynomialContext.dimension <> numberOfVariables then
            Error("The polynomial context has the wrong dimension.");
        fi;

        ring := polynomialContext.polynomialRing;
        variables := polynomialContext.variables;
        monomials := polynomialContext.monomials;
        polynomials := List(
            basis,
            vector -> CF_CoefficientVectorToPolynomial(
                vector,
                monomials,
                ring
            )
        );
    fi;

    if buildStrings then
        strings := List(
            basis,
            vector -> CF_CoefficientVectorToPolynomialString(
                vector,
                exponentBasis
            )
        );
    else
        strings := fail;
    fi;

    return rec(
        ambientDimension       := numberOfVariables,
        polynomialRing         := ring,
        variables              := variables,
        monomialExponents      := exponentBasis,
        monomialBasis          := monomials,
        coefficientBasis       := basis,
        polynomialBasis        := polynomials,
        polynomialStrings      := strings,
        invariantDimension     := Length(basis),
        inputGeneratorCount    := initialGeneratorCount,
        effectiveGeneratorCount := Length(reducedGenerators)
    );
end;


## The optional second argument controls whether the matrix basis is retained.
## An optional third argument gives the dimension for an empty generator list.
## The legacy default for the empty list is 6.
CF_CentralizerAlgebraBasis := function(arg)
    local matrixGenerators, retainMatrixBasis, numberOfVariables,
          reducedGenerators, equations, matrix, i, j, k,
          row, index, basis, matrixBasis;

    if Length(arg) < 1 or Length(arg) > 3 then
        Error(
            "Use CF_CentralizerAlgebraBasis(generators",
            "[, retainMatrixBasis[, dimension]])."
        );
    fi;

    matrixGenerators := arg[1];
    retainMatrixBasis := true;

    if Length(arg) >= 2 then
        retainMatrixBasis := arg[2];
        if retainMatrixBasis <> true and retainMatrixBasis <> false then
            Error("The retain-matrix-basis option must be boolean.");
        fi;
    fi;

    if Length(matrixGenerators) > 0 then
        numberOfVariables := CF_MatrixListDimension(matrixGenerators);
        if Length(arg) = 3 and arg[3] <> numberOfVariables then
            Error("The supplied dimension does not match the matrices.");
        fi;
    elif Length(arg) = 3 then
        numberOfVariables := arg[3];
    else
        numberOfVariables := 6;
    fi;

    reducedGenerators := CF_ReduceGeneratorsForCentralizer(matrixGenerators);
    if Length(reducedGenerators) = 0 then
        basis := IdentityMat(numberOfVariables * numberOfVariables);
    else
        equations := [];
        for matrix in reducedGenerators do
            for i in [1 .. numberOfVariables] do
                for j in [1 .. numberOfVariables] do
                    row := List(
                        [1 .. numberOfVariables * numberOfVariables],
                        k -> 0
                    );

                    for k in [1 .. numberOfVariables] do
                        index := (i - 1) * numberOfVariables + k;
                        row[index] := row[index] + matrix[k][j];
                        index := (k - 1) * numberOfVariables + j;
                        row[index] := row[index] - matrix[i][k];
                    od;

                    if ForAny(row, entry -> entry <> 0) then
                        Add(equations, row);
                    fi;
                od;
            od;
        od;

        basis := CF_NullspaceOfEquationRows(
            equations,
            numberOfVariables * numberOfVariables
        );
    fi;

    if retainMatrixBasis then
        matrixBasis := List(
            basis,
            vector -> CF_VectorToSquareMatrix(vector, numberOfVariables)
        );
    else
        matrixBasis := fail;
    fi;

    return rec(
        ambientDimension       := numberOfVariables,
        basis                  := basis,
        matrixBasis            := matrixBasis,
        dimension              := Length(basis),
        effectiveGeneratorCount := Length(reducedGenerators)
    );
end;
