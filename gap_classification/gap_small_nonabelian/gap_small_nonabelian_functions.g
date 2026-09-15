#############################################################################
##
## gap_small_nonabelian_functions.g
##
## Shared workflow functions for the small non-abelian classification.
##
## This file contains the parts of the small non-abelian computation that
## are independent of the four symplectic groups C3, C2^2, C4, and S3.
## It includes the exact ternary-vector traversal used in the audited
## extension searches and the prime-order restriction used after candidate
## generation.  Batch execution and output writing remain in the main driver.
##
## The Gonzalez--Aguilera--Liendo restriction is written for strict linear
## lifts: every matrix under consideration is assumed to fix the cubic
## polynomial, not merely its zero locus.
##
## Read ../gap_functions.g before reading this file.
##
#############################################################################

if not IsBound(CF_SquareMatrixDimension)
   or not IsBound(CF_IsScalarMatrix) then
    Error(
        "Read gap_classification/gap_functions.g before ",
        "gap_small_nonabelian_functions.g."
    );
fi;


#############################################################################
## 1. Gonzalez--Aguilera--Liendo data for cubic fourfolds
#############################################################################

# The signature entries are exponents modulo p for an order-p linear
# representative A.  The field cubicWeight records
#
#                         A(F) = E(p)^cubicWeight F.
#
# For p <> 3 the representatives in the theorem have cubicWeight zero.
# For p = 3 the last case is not strictly invariant and must be converted
# to a strict order-nine lift.
# Source: Gonzalez--Aguilera and Liendo, published Theorem 3.8.
# The historical F5_2 row is retained; Yu-Zheng, Section 6A, excludes it.
# This only weakens a necessary test. Current small-group inputs involve
# primes 2 and 3, so that unused row does not affect the recorded run.
# See ../../REFERENCES.md for the precise reference and scope.

CF_SN_GonzalezFourfoldCases := function()
    return [
        rec(
            label := "F2_1", projectiveOrder := 2,
            signature := [0,0,0,0,0,1], cubicWeight := 0
        ),
        rec(
            label := "F2_2", projectiveOrder := 2,
            signature := [0,0,0,0,1,1], cubicWeight := 0
        ),
        rec(
            label := "F2_3", projectiveOrder := 2,
            signature := [0,0,0,1,1,1], cubicWeight := 0
        ),

        rec(
            label := "F3_1", projectiveOrder := 3,
            signature := [0,0,0,0,0,1], cubicWeight := 0
        ),
        rec(
            label := "F3_2", projectiveOrder := 3,
            signature := [0,0,0,0,1,1], cubicWeight := 0
        ),
        rec(
            label := "F3_3", projectiveOrder := 3,
            signature := [0,0,0,0,1,2], cubicWeight := 0
        ),
        rec(
            label := "F3_4", projectiveOrder := 3,
            signature := [0,0,0,1,1,1], cubicWeight := 0
        ),
        rec(
            label := "F3_5", projectiveOrder := 3,
            signature := [0,0,0,1,1,2], cubicWeight := 0
        ),
        rec(
            label := "F3_6", projectiveOrder := 3,
            signature := [0,0,1,1,2,2], cubicWeight := 0
        ),
        rec(
            label := "F3_7", projectiveOrder := 3,
            signature := [0,0,1,1,2,2], cubicWeight := 1
        ),

        rec(
            label := "F5_1", projectiveOrder := 5,
            signature := [0,0,1,2,3,4], cubicWeight := 0
        ),
        rec(
            label := "F5_2", projectiveOrder := 5,
            signature := [1,1,2,2,3,4], cubicWeight := 0
        ),
        rec(
            label := "F7_1", projectiveOrder := 7,
            signature := [1,2,3,4,5,6], cubicWeight := 0
        ),
        rec(
            label := "F11_1", projectiveOrder := 11,
            signature := [0,1,3,4,5,9], cubicWeight := 0
        )
    ];
end;


CF_SN_NonnegativeResidue := function(value, modulus)
    return ((value mod modulus) + modulus) mod modulus;
end;


CF_SN_SortedResidues := function(values, modulus)
    local answer;

    answer := List(
        values,
        value -> CF_SN_NonnegativeResidue(value, modulus)
    );
    Sort(answer);
    return answer;
end;


#############################################################################
## 2. Strict-invariant spectral patterns
#############################################################################

# Suppose p = 3 and A^3 = I with A(F) = E(3)^a F.  A strict lift is
#
#                         B = E(9)^(-a) A.
#
# It satisfies B(F) = F and B^3 = E(3)^(-a) I.  Its E(9)-exponents are
# 3*sigma_i-a.  Generator inversion and multiplication by a central element
# of mu_3 are both included below.

CF_SN_AddGonzalezStrictPattern := function(patterns, pattern)
    local position;

    position := PositionProperty(
        patterns,
        old -> old.projectiveOrder = pattern.projectiveOrder
            and old.liftPowerScalarExponent
                = pattern.liftPowerScalarExponent
            and old.characteristicPolynomial
                = pattern.characteristicPolynomial
    );

    if position = fail then
        Add(patterns, pattern);
    fi;

    return true;
end;


CF_SN_BuildGonzalezStrictPatterns := function()
    local patterns, caseData, p, a, units, u, centralPower,
          modulus, weights, sortedWeights, diagonalMatrix,
          scalarExponent, pattern;

    patterns := [];

    for caseData in CF_SN_GonzalezFourfoldCases() do
        p := caseData.projectiveOrder;
        a := caseData.cubicWeight;
        units := Filtered([1 .. p - 1], u -> GcdInt(u, p) = 1);

        if p = 3 then
            if a = 0 then
                modulus := 3;
                for u in units do
                    for centralPower in [0 .. 2] do
                        weights := List(
                            caseData.signature,
                            value -> CF_SN_NonnegativeResidue(
                                u * value + centralPower,
                                modulus
                            )
                        );
                        sortedWeights := ShallowCopy(weights);
                        Sort(sortedWeights);
                        diagonalMatrix := DiagonalMat(
                            List(weights, value -> E(modulus)^value)
                        );
                        pattern := rec(
                            label := caseData.label,
                            projectiveOrder := p,
                            sourceSignature := ShallowCopy(
                                caseData.signature
                            ),
                            cubicWeight := a,
                            generatorPower := u,
                            centralScalarPower := centralPower,
                            strictRootOrder := modulus,
                            strictExponents := sortedWeights,
                            liftPowerScalarExponent := 0,
                            characteristicPolynomial :=
                                CharacteristicPolynomial(diagonalMatrix)
                        );
                        CF_SN_AddGonzalezStrictPattern(patterns, pattern);
                    od;
                od;
            else
                modulus := 9;
                for u in units do
                    for centralPower in [0 .. 2] do
                        weights := List(
                            caseData.signature,
                            value -> CF_SN_NonnegativeResidue(
                                u * (3 * value - a)
                                    + 3 * centralPower,
                                modulus
                            )
                        );
                        sortedWeights := ShallowCopy(weights);
                        Sort(sortedWeights);
                        scalarExponent := CF_SN_NonnegativeResidue(
                            -a * u,
                            3
                        );
                        diagonalMatrix := DiagonalMat(
                            List(weights, value -> E(modulus)^value)
                        );
                        pattern := rec(
                            label := caseData.label,
                            projectiveOrder := p,
                            sourceSignature := ShallowCopy(
                                caseData.signature
                            ),
                            cubicWeight := a,
                            generatorPower := u,
                            centralScalarPower := centralPower,
                            strictRootOrder := modulus,
                            strictExponents := sortedWeights,
                            liftPowerScalarExponent := scalarExponent,
                            characteristicPolynomial :=
                                CharacteristicPolynomial(diagonalMatrix)
                        );
                        CF_SN_AddGonzalezStrictPattern(patterns, pattern);
                    od;
                od;
            fi;
        else
            # For p <> 3 a strict lift can be normalized uniquely by mu_3
            # to have linear order p.  Only generator powers remain.
            modulus := p;
            for u in units do
                weights := List(
                    caseData.signature,
                    value -> CF_SN_NonnegativeResidue(u * value, modulus)
                );
                sortedWeights := ShallowCopy(weights);
                Sort(sortedWeights);
                diagonalMatrix := DiagonalMat(
                    List(weights, value -> E(modulus)^value)
                );
                pattern := rec(
                    label := caseData.label,
                    projectiveOrder := p,
                    sourceSignature := ShallowCopy(caseData.signature),
                    cubicWeight := a,
                    generatorPower := u,
                    centralScalarPower := 0,
                    strictRootOrder := modulus,
                    strictExponents := sortedWeights,
                    liftPowerScalarExponent := 0,
                    characteristicPolynomial :=
                        CharacteristicPolynomial(diagonalMatrix)
                );
                CF_SN_AddGonzalezStrictPattern(patterns, pattern);
            od;
        fi;
    od;

    return patterns;
end;


CF_SN_GONZALEZ_STRICT_PATTERN_CACHE := fail;


CF_SN_GonzalezStrictPatterns := function()
    if CF_SN_GONZALEZ_STRICT_PATTERN_CACHE = fail then
        CF_SN_GONZALEZ_STRICT_PATTERN_CACHE :=
            CF_SN_BuildGonzalezStrictPatterns();
    fi;

    return CF_SN_GONZALEZ_STRICT_PATTERN_CACHE;
end;


# The non-invariant F3_7 case must contain both generator directions.
# In E(9)-exponent notation they are 225588 and 114477.
CF_SN_CheckGonzalezOrderNineInversePair := function()
    local patterns, forward, inverse;

    patterns := Filtered(
        CF_SN_GonzalezStrictPatterns(),
        pattern -> pattern.label = "F3_7"
    );
    forward := [2,2,5,5,8,8];
    inverse := [1,1,4,4,7,7];

    if not ForAny(
        patterns,
        pattern -> pattern.strictExponents = forward
    ) then
        Error("The strict F3_7 pattern 225588 is missing.");
    fi;

    if not ForAny(
        patterns,
        pattern -> pattern.strictExponents = inverse
    ) then
        Error("The inverse strict F3_7 pattern 114477 is missing.");
    fi;

    return true;
end;


CF_SN_GONZALEZ_ORDER_NINE_INVERSE_PAIR_CHECKED :=
    CF_SN_CheckGonzalezOrderNineInversePair();;


#############################################################################
## 3. Matrix-element restriction
#############################################################################

CF_SN_ProjectiveOrderOfFiniteMatrix := function(matrix)
    local dimension, linearOrder, divisors, exponent;

    dimension := CF_SquareMatrixDimension(matrix);
    if dimension = fail then
        Error("A square matrix is required.");
    fi;

    linearOrder := Order(matrix);
    if not IsInt(linearOrder) or linearOrder < 1 then
        return rec(
            ok := false,
            reason := "matrix_order_is_not_finite"
        );
    fi;

    divisors := ShallowCopy(DivisorsInt(linearOrder));
    Sort(divisors);
    for exponent in divisors do
        if CF_IsScalarMatrix(matrix^exponent) then
            return rec(
                ok := true,
                linearOrder := linearOrder,
                projectiveOrder := exponent
            );
        fi;
    od;

    return rec(
        ok := false,
        reason := "projective_order_not_found"
    );
end;


CF_SN_Mu3Exponent := function(scalar)
    local exponent;

    for exponent in [0 .. 2] do
        if scalar = E(3)^exponent then
            return exponent;
        fi;
    od;

    return fail;
end;


CF_SN_NormalizePrimeLiftAwayFromThree := function(
    matrix,
    projectiveOrder,
    scalarPower
)
    local centralScalar;

    for centralScalar in [1, E(3), E(3)^2] do
        if centralScalar^projectiveOrder * scalarPower = 1 then
            return rec(
                matrix := centralScalar * matrix,
                scalar := centralScalar
            );
        fi;
    od;

    return fail;
end;


CF_SN_GonzalezInvariantElementRestriction := function(matrix)
    local orderData, p, scalarPowerMatrix, scalarPower,
          scalarExponent, normalized, testedMatrix,
          normalizingScalar, testedScalarExponent,
          characteristicPolynomial, matches, match;

    if not IsMatrix(matrix) then
        Error("CF_SN_GonzalezInvariantElementRestriction needs a matrix.");
    fi;

    orderData := CF_SN_ProjectiveOrderOfFiniteMatrix(matrix);
    if not orderData.ok then
        return rec(
            applicable := false,
            ok := false,
            status := "invalid_input",
            reason := orderData.reason
        );
    fi;

    p := orderData.projectiveOrder;
    if p = 1 then
        scalarPower := matrix[1][1];
        if scalarPower^3 <> 1 then
            return rec(
                applicable := true,
                ok := false,
                status := "forbidden_strict_scalar",
                reason := "a_scalar_fixing_a_nonzero_cubic_must_lie_in_mu_3",
                linearOrder := orderData.linearOrder,
                projectiveOrder := p,
                scalar := scalarPower
            );
        fi;
        return rec(
            applicable := false,
            ok := true,
            status := "strict_cubic_scalar",
            linearOrder := orderData.linearOrder,
            projectiveOrder := p,
            scalar := scalarPower
        );
    fi;

    if not IsPrimeInt(p) then
        return rec(
            applicable := false,
            ok := true,
            status := "projective_order_not_prime",
            linearOrder := orderData.linearOrder,
            projectiveOrder := p
        );
    fi;

    if not p in [2,3,5,7,11] then
        return rec(
            applicable := true,
            ok := false,
            status := "forbidden_prime_order",
            reason := "prime_not_admissible_for_a_smooth_cubic_fourfold",
            linearOrder := orderData.linearOrder,
            projectiveOrder := p
        );
    fi;

    scalarPowerMatrix := matrix^p;
    if not CF_IsScalarMatrix(scalarPowerMatrix) then
        return rec(
            applicable := true,
            ok := false,
            status := "internal_projective_order_error",
            linearOrder := orderData.linearOrder,
            projectiveOrder := p
        );
    fi;

    scalarPower := scalarPowerMatrix[1][1];
    scalarExponent := CF_SN_Mu3Exponent(scalarPower);
    if scalarExponent = fail then
        return rec(
            applicable := true,
            ok := false,
            status := "not_a_strict_cubic_lift",
            reason := "the_projective_power_scalar_does_not_lie_in_mu_3",
            linearOrder := orderData.linearOrder,
            projectiveOrder := p,
            projectivePowerScalar := scalarPower
        );
    fi;

    testedMatrix := matrix;
    normalizingScalar := 1;
    testedScalarExponent := scalarExponent;

    if p <> 3 then
        normalized := CF_SN_NormalizePrimeLiftAwayFromThree(
            matrix,
            p,
            scalarPower
        );
        if normalized = fail then
            return rec(
                applicable := true,
                ok := false,
                status := "strict_lift_normalization_failed",
                linearOrder := orderData.linearOrder,
                projectiveOrder := p,
                projectivePowerScalar := scalarPower
            );
        fi;
        testedMatrix := normalized.matrix;
        normalizingScalar := normalized.scalar;
        testedScalarExponent := 0;
    fi;

    characteristicPolynomial := CharacteristicPolynomial(testedMatrix);
    matches := Filtered(
        CF_SN_GonzalezStrictPatterns(),
        pattern -> pattern.projectiveOrder = p
            and pattern.liftPowerScalarExponent = testedScalarExponent
            and pattern.characteristicPolynomial
                = characteristicPolynomial
    );

    if Length(matches) = 0 then
        return rec(
            applicable := true,
            ok := false,
            status := "forbidden_strict_invariant_spectrum",
            reason := "no_Gonzalez_strict_invariant_pattern_matches",
            linearOrder := orderData.linearOrder,
            projectiveOrder := p,
            projectivePowerScalar := scalarPower,
            projectivePowerScalarExponent := scalarExponent,
            normalizingScalar := normalizingScalar,
            testedCharacteristicPolynomial := characteristicPolynomial
        );
    fi;

    match := matches[1];
    return rec(
        applicable := true,
        ok := true,
        status := "allowed",
        linearOrder := orderData.linearOrder,
        projectiveOrder := p,
        projectivePowerScalar := scalarPower,
        projectivePowerScalarExponent := scalarExponent,
        normalizingScalar := normalizingScalar,
        testedCharacteristicPolynomial := characteristicPolynomial,
        matchedCase := match.label,
        sourceSignature := ShallowCopy(match.sourceSignature),
        sourceCubicWeight := match.cubicWeight,
        matchedGeneratorPower := match.generatorPower,
        matchedCentralScalarPower := match.centralScalarPower,
        strictRootOrder := match.strictRootOrder,
        strictExponents := ShallowCopy(match.strictExponents)
    );
end;


#############################################################################
## 4. Finite linear-group restriction
#############################################################################

# Only representatives of conjugacy classes inside the input group are tested. The
# restriction is conjugacy invariant, and central scalar multiples are
# already included in the strict pattern orbits.

CF_SN_GonzalezInvariantLinearGroupRestriction := function(matrixGroup)
    local classes, results, failures, restrictionClassCount,
          primeOrderClassCount,
          classIndex, class, representative, result, groupStatus;

    if not IsGroup(matrixGroup) or not IsFinite(matrixGroup) then
        Error(
            "CF_SN_GonzalezInvariantLinearGroupRestriction needs ",
            "a finite matrix group."
        );
    fi;

    classes := ConjugacyClasses(matrixGroup);
    results := [];
    failures := [];
    restrictionClassCount := 0;
    primeOrderClassCount := 0;

    for classIndex in [1 .. Length(classes)] do
        class := classes[classIndex];
        representative := Representative(class);
        if not IsMatrix(representative) then
            Error("A conjugacy-class representative is not a matrix.");
        fi;

        result := CF_SN_GonzalezInvariantElementRestriction(
            representative
        );
        result.classIndex := classIndex;
        result.classSize := Size(class);

        if result.applicable then
            restrictionClassCount := restrictionClassCount + 1;
            if IsBound(result.projectiveOrder)
               and IsPrimeInt(result.projectiveOrder) then
                primeOrderClassCount := primeOrderClassCount + 1;
            fi;
            Add(results, result);
            if not result.ok then
                Add(failures, result);
            fi;
        fi;
    od;

    if Length(failures) = 0 then
        groupStatus := "passed";
    else
        groupStatus := "rejected";
    fi;

    return rec(
        ok := Length(failures) = 0,
        status := groupStatus,
        groupOrder := Size(matrixGroup),
        conjugacyClassCount := Length(classes),
        testedRestrictionClassCount := restrictionClassCount,
        primeProjectiveOrderClassCount := primeOrderClassCount,
        classResults := results,
        failures := failures
    );
end;


#############################################################################
## 5. Cohomology dimension audit
#############################################################################

# The liftable and non-liftable scripts construct their cohomolo records in
# different ways.  The numerical completeness check is nevertheless the
# same and is recorded here without constructing an extension.

CF_SN_CohomologyDimensionAudit := function(arg)
    local G, chr, abelianInvariants, multiplier3Invariants,
          h2Dimension, homMultiplierDimension,
          extAbelianizationDimension, dimensionCheckPassed,
          skippedByCoprimeOrder;

    if Length(arg) < 1 or Length(arg) > 2 then
        Error(
            "Use CF_SN_CohomologyDimensionAudit(G) when 3 does not ",
            "divide |G|, or CF_SN_CohomologyDimensionAudit(G, chr)."
        );
    fi;

    G := arg[1];
    if not IsGroup(G) or not IsFinite(G) then
        Error("The cohomology audit requires a finite group.");
    fi;

    chr := fail;
    if Length(arg) = 2 then
        chr := arg[2];
    fi;

    skippedByCoprimeOrder := Size(G) mod 3 <> 0;
    if skippedByCoprimeOrder then
        multiplier3Invariants := [];
        h2Dimension := 0;
    else
        if chr = fail then
            Error(
                "A cohomolo CHR record is required when 3 divides |G|."
            );
        fi;
        if not IsBoundGlobal("SchurMultiplier")
           or not IsBoundGlobal("SecondCohomologyDimension") then
            Error(
                "The cohomolo package must be loaded before auditing ",
                "a group whose order is divisible by 3."
            );
        fi;
        multiplier3Invariants := CallFuncList(
            ValueGlobal("SchurMultiplier"),
            [chr]
        );
        h2Dimension := CallFuncList(
            ValueGlobal("SecondCohomologyDimension"),
            [chr]
        );
    fi;

    abelianInvariants := AbelianInvariants(
        G / DerivedSubgroup(G)
    );
    homMultiplierDimension := Length(multiplier3Invariants);
    extAbelianizationDimension := Number(
        abelianInvariants,
        invariant -> invariant mod 3 = 0
    );
    dimensionCheckPassed := h2Dimension
        = homMultiplierDimension + extAbelianizationDimension;

    return rec(
        groupOrder := Size(G),
        abelianInvariants := abelianInvariants,
        multiplier3Invariants := multiplier3Invariants,
        HomMultiplierDimension := homMultiplierDimension,
        ExtAbelianizationDimension := extAbelianizationDimension,
        H2Dimension := h2Dimension,
        H2ClassCount := 3^h2Dimension,
        nonzeroLabelledH2VectorCount := 3^h2Dimension - 1,
        expectedLiftableExtVectorCount :=
            3^extAbelianizationDimension,
        expectedStemVectorCount :=
            (3^homMultiplierDimension - 1)
            * 3^extAbelianizationDimension,
        CohomologyDimensionCheckPassed := dimensionCheckPassed,
        cohomologySkippedByCoprimeOrder := skippedByCoprimeOrder
    );
end;


#############################################################################
## 6. Ordered ternary-vector traversal
#############################################################################

# Coordinates are visited from left to right, and each coordinate is tried
# in the order 0, 1, 2.  Thus the output order is exactly the order used by
# CF_ForEachExtVector and by the audited CF_ForEachNonzeroH2Vector in the
# integrated calculations.  A callback returning true stops the traversal.

CF_SN_ForEachTernaryVector := function(
    dimension,
    includeZeroVector,
    callback
)
    local vector, stopped, search;

    if not IsInt(dimension) or dimension < 0 then
        Error("The ternary-vector dimension must be a nonnegative integer.");
    fi;
    if includeZeroVector <> true and includeZeroVector <> false then
        Error("includeZeroVector must be true or false.");
    fi;
    if not IsFunction(callback) then
        Error("The ternary-vector callback must be a function.");
    fi;

    vector := List([1 .. dimension], index -> 0);
    stopped := false;

    search := function(position)
        local value;

        if stopped then
            return;
        fi;

        if position > dimension then
            if includeZeroVector
               or ForAny(vector, value -> value <> 0) then
                if callback(ShallowCopy(vector)) = true then
                    stopped := true;
                fi;
            fi;
            return;
        fi;

        for value in [0, 1, 2] do
            vector[position] := value;
            search(position + 1);
            if stopped then
                return;
            fi;
        od;
    end;

    search(1);
    return stopped;
end;


CF_SN_ForEachExtVector := function(dimension, callback)
    return CF_SN_ForEachTernaryVector(dimension, true, callback);
end;


CF_SN_ForEachNonzeroH2Vector := function(dimension, callback)
    return CF_SN_ForEachTernaryVector(dimension, false, callback);
end;


#############################################################################
## 7. Candidate records and the Gonzalez--Aguilera--Liendo restriction
#############################################################################

CF_SN_CandidateMatrixGroup := function(candidate)
    local matrixGroup;

    if IsGroup(candidate) then
        matrixGroup := candidate;
    elif IsRecord(candidate)
         and IsBound(candidate.matrixImage)
         and IsGroup(candidate.matrixImage) then
        matrixGroup := candidate.matrixImage;
    elif IsRecord(candidate)
         and IsBound(candidate.matrixGenerators)
         and IsList(candidate.matrixGenerators)
         and Length(candidate.matrixGenerators) > 0 then
        matrixGroup := Group(candidate.matrixGenerators);
    elif IsRecord(candidate)
         and IsBound(candidate.group)
         and IsGroup(candidate.group) then
        matrixGroup := candidate.group;
    else
        Error(
            "A candidate must be a matrix group or contain .matrixImage, ",
            ".matrixGenerators, or .group."
        );
    fi;

    if not IsFinite(matrixGroup) then
        Error("The candidate matrix group is not finite.");
    fi;
    if not ForAll(GeneratorsOfGroup(matrixGroup), IsMatrix) then
        Error("The selected candidate group is not a matrix group.");
    fi;
    if CF_MatrixListDimension(GeneratorsOfGroup(matrixGroup)) <> 6 then
        Error("The candidate matrix group must act on six variables.");
    fi;

    return matrixGroup;
end;


CF_SN_LinearAndProjectiveGroupData := function(matrixGroup)
    local scalarElements, scalarSubgroup, quotientMap, projectiveGroup;

    matrixGroup := CF_SN_CandidateMatrixGroup(matrixGroup);
    scalarElements := Filtered(
        Elements(Centre(matrixGroup)),
        CF_IsScalarMatrix
    );
    scalarSubgroup := Group(scalarElements);
    quotientMap := NaturalHomomorphismByNormalSubgroup(
        matrixGroup,
        scalarSubgroup
    );
    projectiveGroup := Image(quotientMap);

    return rec(
        linearGroup := matrixGroup,
        linearGroupData := CF_GroupIdentificationData(matrixGroup),
        scalarSubgroup := scalarSubgroup,
        scalarSubgroupOrder := Size(scalarSubgroup),
        scalarElements := scalarElements,
        projectiveQuotientMap := quotientMap,
        projectiveGroup := projectiveGroup,
        projectiveGroupData := CF_GroupIdentificationData(projectiveGroup),
        determinantImageOrder := CF_DeterminantImageOrder(matrixGroup),
        determinantKernelSize := CF_DeterminantKernelSize(matrixGroup)
    );
end;


# The input list is never reordered or modified.  Every audit record retains
# its original position, so later group-specific scripts can compare their
# survivor order with the integrated calculations.

CF_SN_FilterCandidatesByGonzalezRestriction := function(candidates)
    local kept, rejected, audits, candidateIndex, candidate,
          matrixGroup, result, audit;

    if not IsList(candidates) then
        Error("The candidate collection must be a list.");
    fi;

    kept := [];
    rejected := [];
    audits := [];

    for candidateIndex in [1 .. Length(candidates)] do
        candidate := candidates[candidateIndex];
        matrixGroup := CF_SN_CandidateMatrixGroup(candidate);
        result := CF_SN_GonzalezInvariantLinearGroupRestriction(
            matrixGroup
        );
        audit := rec(
            candidateIndex := candidateIndex,
            matrixGroupOrder := Size(matrixGroup),
            ok := result.ok,
            gonzalezPrimeOrderRestriction := result
        );
        Add(audits, audit);

        if result.ok then
            Add(kept, candidate);
        else
            Add(rejected, rec(
                candidateIndex := candidateIndex,
                candidate := candidate,
                audit := audit
            ));
        fi;
    od;

    return rec(
        inputCount := Length(candidates),
        keptCount := Length(kept),
        rejectedCount := Length(rejected),
        orderPreserved := true,
        kept := kept,
        rejected := rejected,
        audits := audits
    );
end;


CF_SN_PrintGonzalezRestrictionSummary := function(result)
    local audit;

    if not IsRecord(result)
       or not IsBound(result.audits)
       or not IsBound(result.keptCount) then
        Error(
            "CF_SN_PrintGonzalezRestrictionSummary expects the record ",
            "returned by CF_SN_FilterCandidatesByGonzalezRestriction."
        );
    fi;

    CF_SPrint("Gonzalez restriction summary\n");
    CF_SPrint("Input candidates: ", result.inputCount, "\n");
    CF_SPrint("Retained candidates: ", result.keptCount, "\n");
    CF_SPrint("Rejected candidates: ", result.rejectedCount, "\n");

    for audit in result.audits do
        CF_SPrint(
            audit.candidateIndex, ". Status: ",
            audit.gonzalezPrimeOrderRestriction.status,
            "; retained: ", audit.ok, "\n"
        );
    od;

    return true;
end;


#############################################################################
## 8. Generic-index filters and ordered case configurations
#############################################################################

# The generic non-symplectic index divides every index occurring in the same
# connected symplectic family.  This cheap abstract filter is applied before
# an extension or a representation is constructed.

CF_SN_ProjectiveIndexFromGroupId := function(symplecticGId, fullGId)
    if fullGId[1] mod symplecticGId[1] <> 0 then
        Error(
            "The proposed full-group order is not divisible by the ",
            "symplectic-group order."
        );
    fi;
    return QuoInt(fullGId[1], symplecticGId[1]);
end;


CF_SN_GroupIdsForGenericIndex := function(
    symplecticGId,
    fullGIds,
    genericIndex
)
    if genericIndex = 1 then
        return ShallowCopy(fullGIds);
    elif genericIndex = 2 then
        return Filtered(
            fullGIds,
            gid -> CF_SN_ProjectiveIndexFromGroupId(
                       symplecticGId,
                       gid
                   ) mod 2 = 0
        );
    fi;
    Error("The small-group configurations use generic index 1 or 2.");
end;


# In a generic-index-two component every full automorphism group contains the
# generic full group.  The source generators below include mu_3, so this is a
# strict GL(6)-conjugacy containment test rather than an abstract subgroup
# test or a coordinate-dependent membership test.  The test is performed on
# S_2 representations, before cubic invariant spaces are constructed.

CF_SN_GenericFullLinearGroupInfo := function(component)
    if component.genericIndex <> 2 then
        return fail;
    fi;
    if not IsBound(component.genericFullLinearGenerators) then
        Error(
            "A generic-index-two component needs ",
            ".genericFullLinearGenerators."
        );
    fi;
    if not IsBound(component.genericFullLinearGroupInfo) then
        component.genericFullLinearGroupInfo :=
            PreprocessMatrixGroupStrict(
                component.genericFullLinearGenerators,
                fail,
                fail
            );
        if not component.genericFullLinearGroupInfo.strict_ok then
            Error("The generic full linear group could not be prepared.");
        fi;
    fi;
    return component.genericFullLinearGroupInfo;
end;


CF_SN_FilterStep2ByGenericFullGroup := function(component, step2)
    local filteredStep2, sourceInfo, retained, audits, position, solution,
          targetInfo, result, progressHook, candidateStart;

    if not IsRecord(step2) or not IsBound(step2.solutions) then
        Error("The generic-full-group filter expects an S_2 record.");
    fi;

    if component.genericIndex = 1 then
        return rec(
            applied := false,
            inputCount := Length(step2.solutions),
            retainedCount := Length(step2.solutions),
            rejectedCount := 0,
            orderPreserved := true,
            audits := [],
            step2 := step2
        );
    fi;

    sourceInfo := CF_SN_GenericFullLinearGroupInfo(component);
    retained := [];
    audits := [];
    progressHook := fail;
    if IsBoundGlobal("CF_SN_GENERIC_FILTER_PROGRESS_HOOK") then
        progressHook := ValueGlobal(
            "CF_SN_GENERIC_FILTER_PROGRESS_HOOK"
        );
        if not IsFunction(progressHook) then
            Error("CF_SN_GENERIC_FILTER_PROGRESS_HOOK must be a function.");
        fi;
    fi;

    for position in [1 .. Length(step2.solutions)] do
        solution := step2.solutions[position];
        candidateStart := Runtime();
        if not IsBound(solution.determinantImageOrder) then
            Error("An S_2 solution has no determinant-image order.");
        fi;
        if progressHook <> fail then
            progressHook(rec(
                event := "start",
                position := position,
                total := Length(step2.solutions),
                HId := ShallowCopy(solution.HId),
                determinantImageOrder := solution.determinantImageOrder,
                candidateElapsedMilliseconds := 0
            ));
        fi;

        # The specialized [72,27] branch knows some negative family
        # dimensions before the 56-dimensional cubic action is built.  Let
        # S_3 discard these records without spending time on containment.
        if IsBound(solution.precomputedCubicInvariantDimension)
           and IsBound(solution.centralizerDimensionByCharacter)
           and solution.precomputedCubicInvariantDimension
               - solution.centralizerDimensionByCharacter < 0 then
            Add(audits, rec(
                solutionNumber := position,
                HId := ShallowCopy(solution.HId),
                determinantImageOrder := solution.determinantImageOrder,
                status := "not_tested",
                reason := "negative_dimension_will_be_discarded"
            ));
            Add(retained, solution);
            if progressHook <> fail then
                progressHook(rec(
                    event := "complete",
                    position := position,
                    total := Length(step2.solutions),
                    HId := ShallowCopy(solution.HId),
                    determinantImageOrder :=
                        solution.determinantImageOrder,
                    status := "not_tested",
                    reason := "negative_dimension_will_be_discarded",
                    candidateElapsedMilliseconds :=
                        Runtime() - candidateStart
                ));
            fi;
            continue;
        fi;

        if solution.determinantImageOrder mod 2 <> 0 then
            Add(audits, rec(
                solutionNumber := position,
                HId := ShallowCopy(solution.HId),
                determinantImageOrder := solution.determinantImageOrder,
                status := "no_embedding",
                reason := "odd_non_symplectic_index"
            ));
            if progressHook <> fail then
                progressHook(rec(
                    event := "complete",
                    position := position,
                    total := Length(step2.solutions),
                    HId := ShallowCopy(solution.HId),
                    determinantImageOrder :=
                        solution.determinantImageOrder,
                    status := "no_embedding",
                    reason := "odd_non_symplectic_index",
                    candidateElapsedMilliseconds :=
                        Runtime() - candidateStart
                ));
            fi;
            continue;
        fi;

        targetInfo := PreprocessMatrixGroupStrict(
            solution.matrixGenerators,
            solution.matrixImageOrder,
            solution.HId
        );
        if progressHook <> fail then
            progressHook(rec(
                event := "preprocessed",
                position := position,
                total := Length(step2.solutions),
                HId := ShallowCopy(solution.HId),
                determinantImageOrder := solution.determinantImageOrder,
                candidateElapsedMilliseconds := Runtime() - candidateStart
            ));
        fi;
        result := SearchEmbeddingStrict(
            sourceInfo,
            targetInfo,
            rec(
                stop_first := true,
                construct_witness := false,
                try_literal_inclusion := true,
                use_fingerprints := false
            )
        );

        if result.status = "undecided" then
            Error(
                "The generic-full-group containment test was undecided ",
                "for strict linear group ", solution.HId,
                ": ", result.reason, "."
            );
        fi;

        Add(audits, rec(
            solutionNumber := position,
            HId := ShallowCopy(solution.HId),
            determinantImageOrder := solution.determinantImageOrder,
            status := result.status,
            reason := result.reason,
            method := result.method
        ));

        if result.status = "embedded" then
            solution.genericFullLinearContainmentVerified := true;
            solution.genericFullLinearContainmentMethod := result.method;
            Add(retained, solution);
        fi;
        if progressHook <> fail then
            progressHook(rec(
                event := "complete",
                position := position,
                total := Length(step2.solutions),
                HId := ShallowCopy(solution.HId),
                determinantImageOrder := solution.determinantImageOrder,
                status := result.status,
                reason := result.reason,
                method := result.method,
                candidateElapsedMilliseconds := Runtime() - candidateStart
            ));
        fi;
    od;

    filteredStep2 := ShallowCopy(step2);
    filteredStep2.solutions := retained;
    filteredStep2.genericFullLinearContainmentApplied := true;
    filteredStep2.genericFullLinearContainmentInputCount :=
        Length(step2.solutions);
    filteredStep2.genericFullLinearContainmentRejectedCount :=
        Length(step2.solutions) - Length(retained);

    return rec(
        applied := true,
        inputCount := Length(step2.solutions),
        retainedCount := Length(retained),
        rejectedCount := Length(step2.solutions) - Length(retained),
        orderPreserved := true,
        audits := audits,
        step2 := filteredStep2
    );
end;

# These are exactly the non-abelian projective full groups retained from
# gap_yyz_bounds/gap_yyz_bounds.md.  Their order follows the earlier
# small-group traversal whenever possible.  The known S3 x C24 action is
# stored separately, and [72,12] in the C3 case is excluded before enumeration.

CF_SN_YYZNonabelianFullGroupIds := function(symplecticPart)
    if symplecticPart = "C3" then
        return [
            [18, 3],
            [6, 1],
            [12, 1],
            [36, 6],
            [24, 1]
        ];
    elif symplecticPart = "C2^2" then
        return [
            [12, 3],
            [8, 3],
            [16, 6],
            [24, 13],
            [24, 10]
        ];
    elif symplecticPart = "C4" then
        return [
            [8, 4],
            [8, 3],
            [24, 10],
            [16, 6]
        ];
    elif symplecticPart = "S3" then
        return [
            [6, 1],
            [12, 4],
            [18, 3],
            [24, 5],
            [36, 12],
            [48, 4],
            [72, 27]
        ];
    fi;
    Error("Unknown small non-abelian symplectic part: ", symplecticPart, ".");
end;

# A case file records the fixed strict symplectic lift and the ordered list of
# abstract full groups.  This check is deliberately independent of S_1--S_3,
# so the input documents can be audited before the enumeration engine is read.

CF_SN_ValidateCaseConfiguration := function(configuration)
    local componentAudits, componentIndex, component, generator,
          symplecticGroup, symplecticGroupData, zeta3Identity, Kplus,
          projectiveData, expectedGIds, expectedComponentGIds, seenGIds,
          gid, gidKey, fullGroup, genericFullGroup, genericFullData,
          genericFullInfo;

    if not IsRecord(configuration)
       or not IsBound(configuration.label)
       or not IsBound(configuration.symplecticGId)
       or not IsBound(configuration.components) then
        Error(
            "A case configuration needs .label, .symplecticGId, ",
            "and .components."
        );
    fi;

    CF_CheckSmallGroupId(configuration.symplecticGId);
    if not IsBound(configuration.symplecticPart) then
        Error("A case configuration needs .symplecticPart.");
    fi;
    expectedGIds := CF_SN_YYZNonabelianFullGroupIds(
        configuration.symplecticPart
    );
    if not IsList(configuration.components)
       or Length(configuration.components) = 0 then
        Error("A case configuration needs at least one component.");
    fi;

    componentAudits := [];
    zeta3Identity := E(3) * IdentityMat(6);

    for componentIndex in [1 .. Length(configuration.components)] do
        component := configuration.components[componentIndex];
        if not IsRecord(component)
           or not IsBound(component.label)
           or not IsBound(component.genericIndex)
           or not IsBound(component.Kgens)
           or not IsBound(component.gids) then
            Error(
                "Each component needs .label, .genericIndex, .Kgens, ",
                "and .gids."
            );
        fi;
        if not IsList(component.Kgens) or Length(component.Kgens) = 0 then
            Error("The fixed symplectic generator list cannot be empty.");
        fi;
        if not IsList(component.gids) then
            Error("The ordered full-group IDs must form a list.");
        fi;
        expectedComponentGIds := CF_SN_GroupIdsForGenericIndex(
            configuration.symplecticGId,
            expectedGIds,
            component.genericIndex
        );
        if component.gids <> expectedComponentGIds then
            Error(
                "The ordered full-group IDs for ",
                configuration.symplecticPart, " component ",
                component.label,
                " do not match the retained YYZ list after the ",
                "generic-index divisibility filter."
            );
        fi;

        for generator in component.Kgens do
            if not IsMatrix(generator)
               or DimensionsMat(generator) <> [6, 6] then
                Error("Every fixed symplectic generator must be 6 by 6.");
            fi;
            if DeterminantMat(generator) <> 1 then
                Error("A fixed symplectic generator has determinant != 1.");
            fi;
        od;

        symplecticGroup := Group(component.Kgens);
        symplecticGroupData := CF_GroupIdentificationData(
            symplecticGroup
        );
        if symplecticGroupData.id <> configuration.symplecticGId then
            Error(
                "The fixed generators in component ", component.label,
                " have group ID ", symplecticGroupData.id,
                ", not ", configuration.symplecticGId, "."
            );
        fi;

        Kplus := Group(
            Concatenation(component.Kgens, [zeta3Identity])
        );
        projectiveData := CF_SN_LinearAndProjectiveGroupData(Kplus);
        if projectiveData.scalarSubgroupOrder <> 3 then
            Error("The full scalar subgroup of Kplus is not mu_3.");
        fi;
        if projectiveData.projectiveGroupData.id
           <> configuration.symplecticGId then
            Error(
                "Kplus/mu_3 in component ", component.label,
                " has the wrong group ID."
            );
        fi;

        genericFullData := fail;
        genericFullInfo := fail;
        if component.genericIndex = 2 then
            genericFullInfo := CF_SN_GenericFullLinearGroupInfo(component);
            genericFullGroup := genericFullInfo.G;
            genericFullData := CF_SN_LinearAndProjectiveGroupData(
                genericFullGroup
            );
            if not IsSubgroup(genericFullGroup, Kplus) then
                Error(
                    "The fixed Kplus is not contained in the generic full ",
                    "linear group for component ", component.label, "."
                );
            fi;
            if genericFullData.scalarSubgroupOrder <> 3 then
                Error(
                    "The generic full linear group must contain exactly ",
                    "the scalar subgroup mu_3."
                );
            fi;
            if genericFullData.projectiveGroupData.order
               <> 2 * configuration.symplecticGId[1] then
                Error(
                    "The projective generic full group must have index two ",
                    "over the symplectic group."
                );
            fi;
            if genericFullData.determinantImageOrder <> 2 then
                Error(
                    "The determinant image of the generic full linear ",
                    "group must have order two."
                );
            fi;
            if IsBound(component.genericFullProjectiveGId)
               and genericFullData.projectiveGroupData.id
                   <> component.genericFullProjectiveGId then
                Error("The generic full projective group has the wrong ID.");
            fi;
            if IsBound(component.genericFullLinearGId)
               and genericFullData.linearGroupData.id
                   <> component.genericFullLinearGId then
                Error("The generic full linear group has the wrong ID.");
            fi;
        fi;

        seenGIds := [];
        for gid in component.gids do
            CF_CheckSmallGroupId(gid);
            fullGroup := SmallGroup(gid[1], gid[2]);
            if IsAbelian(fullGroup) then
                Error(
                    "The retained YYZ list contains an abelian group: ",
                    gid, "."
                );
            fi;
            gidKey := String(gid);
            if Position(seenGIds, gidKey) <> fail then
                Error(
                    "A full-group ID is repeated in component ",
                    component.label, ": ", gid, "."
                );
            fi;
            Add(seenGIds, gidKey);
        od;

        Add(componentAudits, rec(
            componentIndex := componentIndex,
            componentLabel := component.label,
            fixedSymplecticGroupData := symplecticGroupData,
            KplusGroupData := projectiveData.linearGroupData,
            scalarSubgroupOrder := projectiveData.scalarSubgroupOrder,
            projectiveGroupData := projectiveData.projectiveGroupData,
            genericIndex := component.genericIndex,
            genericFullLinearGroupData := genericFullData,
            orderedFullGroupIds := ShallowCopy(component.gids),
            fullGroupCount := Length(component.gids)
        ));
    od;

    return rec(
        label := configuration.label,
        symplecticGId := ShallowCopy(configuration.symplecticGId),
        componentCount := Length(configuration.components),
        components := componentAudits,
        valid := true
    );
end;


# The liftable integrated engine defines S_1, S_2, and S_3.  This wrapper only
# supplies their inputs in the recorded order.  It does not run S_4, apply the
# Gonzalez--Aguilera--Liendo restriction, redirect output, or create .out/.log
# files.

CF_SN_RunS1S2S3Configuration := function(configuration)
    local audit, results, componentIndex, component, gid,
          step1Function, step2Function, step3Function,
          step1, step2, step3, genericFullFilter, genericFullAudit,
          progressHook, family;

    audit := CF_SN_ValidateCaseConfiguration(configuration);
    if not IsBoundGlobal("S_1")
       or not IsBoundGlobal("S_2")
       or not IsBoundGlobal("S_3") then
        Error(
            "Read the liftable S_1--S_3 enumeration engine before ",
            "running a case configuration."
        );
    fi;

    step1Function := ValueGlobal("S_1");
    step2Function := ValueGlobal("S_2");
    step3Function := ValueGlobal("S_3");
    progressHook := fail;
    if IsBoundGlobal("CF_SN_CASE_PROGRESS_HOOK") then
        progressHook := ValueGlobal("CF_SN_CASE_PROGRESS_HOOK");
        if not IsFunction(progressHook) then
            Error("CF_SN_CASE_PROGRESS_HOOK must be a function.");
        fi;
    fi;

    results := [];
    for componentIndex in [1 .. Length(configuration.components)] do
        component := configuration.components[componentIndex];
        for gid in component.gids do
            if progressHook <> fail then
                progressHook(rec(
                    event := "start",
                    configurationLabel := configuration.label,
                    symplecticPart := configuration.symplecticPart,
                    componentIndex := componentIndex,
                    componentLabel := component.label,
                    gid := ShallowCopy(gid)
                ));
            fi;
            step1 := step1Function(gid, component.Kgens);
            step2 := step2Function(step1);
            genericFullFilter :=
                CF_SN_FilterStep2ByGenericFullGroup(component, step2);
            step2 := genericFullFilter.step2;
            step3 := step3Function(step2);
            genericFullAudit := ShallowCopy(genericFullFilter);
            Unbind(genericFullAudit.step2);
            step3.genericFullLinearContainmentAudit := genericFullAudit;
            for family in step3.families do
                family.genericFullLinearContainmentRequired :=
                    component.genericIndex = 2;
                family.genericFullLinearContainmentVerified :=
                    component.genericIndex = 2;
            od;
            Add(results, rec(
                componentIndex := componentIndex,
                componentLabel := component.label,
                gid := ShallowCopy(gid),
                genericFullLinearContainmentAudit := genericFullAudit,
                step3Result := step3
            ));
            if progressHook <> fail then
                progressHook(rec(
                    event := "complete",
                    configurationLabel := configuration.label,
                    symplecticPart := configuration.symplecticPart,
                    componentIndex := componentIndex,
                    componentLabel := component.label,
                    gid := ShallowCopy(gid),
                    familyCount := Length(step3.families)
                ));
            fi;
            step1 := fail;
            step2 := fail;
            genericFullFilter := fail;
        od;
    od;

    return rec(
        configurationLabel := configuration.label,
        configurationAudit := audit,
        orderPreserved := true,
        gonzalezRestrictionApplied := false,
        smoothnessTestApplied := false,
        cases := results
    );
end;
