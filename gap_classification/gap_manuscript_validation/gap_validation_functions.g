#############################################################################
## Exact checks for manuscript coordinate presentations.
## Read gap_classification/gap_functions.g before this file.
#############################################################################

CF_MV_SparseVector := function(terms, exponents)
    local vector, term, position, exponent, coefficient;
    vector := List(exponents, exponent -> 0);
    for term in terms do
        if IsRecord(term) then
            exponent := term.exponent;
            coefficient := term.coefficient;
        else
            exponent := term[1];
            coefficient := term[2];
        fi;
        position := Position(exponents, exponent);
        if position = fail then
            Error("A manuscript term is not a cubic in the ambient variables.");
        fi;
        vector[position] := vector[position] + coefficient;
    od;
    return vector;
end;


CF_MV_SameSpan := function(first, second)
    if Length(first) = 0 or Length(second) = 0 then
        return Length(first) = Length(second);
    fi;
    return RankMat(first) = RankMat(second)
       and ForAll(first, vector -> SolutionMat(second, vector) <> fail);
end;


## The shared polynomial action is f(x) -> f(x*M), with x a row vector.
CF_MV_TransformVectors := function(vectors, matrix, exponents)
    local monomialImages;
    monomialImages := List(exponents,
        exponent -> CF_MonomialImageVector(exponent, matrix, exponents));
    return List(vectors, vector -> vector * monomialImages);
end;


CF_MV_VerifyGroupWitness := function(first, second, matrix)
    if matrix = fail or DeterminantMat(matrix) = 0 then
        return false;
    fi;
    return ForAll(GeneratorsOfGroup(first),
           generator -> matrix^-1 * generator * matrix in second)
       and Size(first) = Size(second);
end;


## Literal equality and stored exact matrices precede the general search.
CF_MV_CompareGroups := function(first, second, groupId, candidates)
    local matrix, firstInfo, secondInfo, result;
    if first = second then
        return rec(status := "equal", method := "literal_equality",
            P := IdentityMat(Length(One(first))));
    fi;
    if Size(first) <> Size(second) then
        return rec(status := "not_conjugate", method := "group_order", P := fail);
    fi;
    for matrix in candidates do
        if CF_MV_VerifyGroupWitness(first, second, matrix) then
            return rec(status := "conjugate", method := "verified_stored_matrix",
                P := matrix);
        fi;
    od;
    firstInfo := PreprocessMatrixGroupStrict(
        GeneratorsOfGroup(first), Size(first), groupId);
    secondInfo := PreprocessMatrixGroupStrict(
        GeneratorsOfGroup(second), Size(second), groupId);
    result := SearchEmbeddingStrict(firstInfo, secondInfo,
        rec(stop_first := true, construct_witness := true,
            use_fingerprints := false, allow_hard_iso := true));
    if result.ok = true and IsBound(result.P) and result.P <> fail then
        if not CF_MV_VerifyGroupWitness(first, second, result.P) then
            Error("A general conjugacy witness failed matrix verification.");
        fi;
        return rec(status := "conjugate", method := result.method, P := result.P);
    elif result.ok = false then
        return rec(status := "not_conjugate", method := result.method, P := fail);
    fi;
    return rec(status := "undecided", method := result.method, P := fail);
end;


CF_MV_BasisAudit := function(generators, displayedBasis)
    local invariants, fullSpan, independent, centralizer;
    invariants := CF_CubicInvariantBasis(generators,
        rec(buildPolynomialObjects := false, buildStrings := false));
    independent := Length(displayedBasis) = 0
        or RankMat(displayedBasis) = Length(displayedBasis);
    fullSpan := CF_MV_SameSpan(displayedBasis, invariants.coefficientBasis);
    centralizer := CF_CentralizerAlgebraBasis(generators, false);
    return rec(independent := independent, equalsInvariantSpace := fullSpan,
        displayedDimension := Length(displayedBasis),
        invariantDimension := invariants.invariantDimension,
        centralizerDimension := centralizer.dimension,
        familyDimension := invariants.invariantDimension - centralizer.dimension,
        computedBasis := invariants.coefficientBasis,
        displayedBasis := displayedBasis);
end;
