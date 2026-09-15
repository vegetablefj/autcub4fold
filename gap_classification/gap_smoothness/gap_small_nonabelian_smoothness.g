#############################################################################
##
##  gap_small_nonabelian_smoothness.g
##
##  Smoothness screening for the 182 retained small non-abelian candidates.
##
##  This file reads gap_small_nonabelian_data.g.  It does not repeat the
##  representation enumeration.  For each retained candidate it applies, in
##  order:
##
##    1. exact dimension, common-factor, and coordinate-point singularity
##       certificates;
##    2. a deterministic batch of explicit smooth-member tests;
##    3. a bounded search for an exact common singular point of all F_i;
##    4. an exact projective common-Jacobian-locus test;
##    5. the conservative status "unknown" if no certificate is found.
##
##  Only a family-wide exact obstruction produces "singular".  Failure to
##  find a smooth member or a common singular point produces no conclusion.
##  Singular input files are temporary.  The persistent output is written in
##  GAP-oriented form to gap_small_nonabelian_smoothness.log and .out.
##  A smooth status certifies one member; a singular status applies to every
##  member. Later hand proofs do not alter a recorded unknown status.
##
#############################################################################

CF_SNS_Paths := function()
    if IsExistingFile("gap_small_nonabelian_smoothness.g") then
        return rec(
            functionsFile :=
                "gap_smoothness_functions.g",
            inputFile :=
                "../gap_small_nonabelian/gap_small_nonabelian_data.g",
            logFile := "gap_small_nonabelian_smoothness.log",
            outputFile := "gap_small_nonabelian_smoothness.out"
        );
    fi;
    if IsExistingFile(
        Concatenation(
            "gap_classification/gap_smoothness/",
            "gap_small_nonabelian_smoothness.g"
        )
    ) then
        return rec(
            functionsFile := Concatenation(
                "gap_classification/gap_smoothness/",
                "gap_smoothness_functions.g"
            ),
            inputFile := Concatenation(
                "gap_classification/gap_small_nonabelian/",
                "gap_small_nonabelian_data.g"
            ),
            logFile := Concatenation(
                "gap_classification/gap_smoothness/",
                "gap_small_nonabelian_smoothness.log"
            ),
            outputFile := Concatenation(
                "gap_classification/gap_smoothness/",
                "gap_small_nonabelian_smoothness.out"
            )
        );
    fi;
    if IsExistingFile(
        "gap_smoothness/gap_small_nonabelian_smoothness.g"
    ) then
        return rec(
            functionsFile := Concatenation(
                "gap_smoothness/",
                "gap_smoothness_functions.g"
            ),
            inputFile :=
                "gap_small_nonabelian/gap_small_nonabelian_data.g",
            logFile := "gap_smoothness/gap_small_nonabelian_smoothness.log",
            outputFile := "gap_smoothness/gap_small_nonabelian_smoothness.out"
        );
    fi;
    Error(
        "Run from the repository root, gap_classification, or ",
        "gap_classification/gap_smoothness."
    );
end;

CF_SNS_PathRecord := CF_SNS_Paths();

if not IsBound(CF_SNS_RunExactMemberTest)
   or not IsBound(CF_SNS_TestCandidateBatchAtPrime)
   or not IsBound(CF_SNS_FindSmallCommonSingularPointBounded)
   or not IsBound(CF_SNS_RunExactCommonSingularLocusTest) then
    if not IsExistingFile(CF_SNS_PathRecord.functionsFile) then
        Error(
            "Cannot find gap_smoothness_functions.g."
        );
    fi;
    Read(CF_SNS_PathRecord.functionsFile);
fi;

if not IsBound(CF_SNS_INPUT_FILE) then
    CF_SNS_INPUT_FILE := CF_SNS_PathRecord.inputFile;
fi;
if not IsBound(CF_SNS_LOG_FILE) then
    CF_SNS_LOG_FILE := CF_SNS_PathRecord.logFile;
fi;
if not IsBound(CF_SNS_OUTPUT_FILE) then
    CF_SNS_OUTPUT_FILE := CF_SNS_PathRecord.outputFile;
fi;
if not IsBound(CF_SNS_AUTO_RUN) then
    CF_SNS_AUTO_RUN := true;
fi;
if not IsBound(CF_SNS_RUN_OPTIONS) then
    CF_SNS_RUN_OPTIONS := rec();
fi;


#############################################################################
## 1. Options and input checks
#############################################################################

CF_SNS_DefaultOptions := function()
    return rec(
        useFiniteFieldTest := true,
        maxPrimeTrials := 3,
        maxSplitPrimes := 8,
        maxPrime := 10000,
        maxCoefficientCandidates := 32,
        finiteFieldTimeoutSeconds := 30,
        useExactCharacteristicZeroFallback := true,
        maxExactMemberTrials := 6,
        exactMemberTimeoutSeconds := 60,
        useExactCommonSingularLocusTest := true,
        commonLocusTimeoutSeconds := 60,
        maxCommonPointSupport := 4,
        maxCommonPointChecks := 8000,
        singularExecutable := fail,
        timeoutExecutable := fail,
        printProgress := true
    );
end;


CF_SNS_MergeOptions := function(options)
    local merged, name, integerNames, booleanNames;

    if not IsRecord(options) then
        Error("The smoothness options must be a record.");
    fi;

    merged := CF_SNS_DefaultOptions();
    for name in RecNames(options) do
        if not name in RecNames(merged) then
            Error("Unknown smoothness option: ", name, ".");
        fi;
        merged.(name) := options.(name);
    od;

    integerNames := [
        "maxPrimeTrials",
        "maxSplitPrimes",
        "maxPrime",
        "maxCoefficientCandidates",
        "finiteFieldTimeoutSeconds",
        "maxExactMemberTrials",
        "exactMemberTimeoutSeconds",
        "commonLocusTimeoutSeconds",
        "maxCommonPointSupport",
        "maxCommonPointChecks"
    ];
    for name in integerNames do
        if not IsInt(merged.(name)) or merged.(name) < 0 then
            Error("Smoothness option ", name,
                  " must be a nonnegative integer.");
        fi;
    od;

    booleanNames := [
        "useFiniteFieldTest",
        "useExactCharacteristicZeroFallback",
        "useExactCommonSingularLocusTest",
        "printProgress"
    ];
    for name in booleanNames do
        if merged.(name) <> true and merged.(name) <> false then
            Error("Smoothness option ", name, " must be boolean.");
        fi;
    od;

    for name in ["singularExecutable", "timeoutExecutable"] do
        if merged.(name) <> fail and not IsString(merged.(name)) then
            Error("Smoothness option ", name,
                  " must be fail or a path string.");
        fi;
    od;

    if merged.maxPrime < 5 then
        Error("Smoothness option maxPrime must be at least 5.");
    fi;
    if merged.maxCoefficientCandidates < 1 then
        Error("maxCoefficientCandidates must be positive.");
    fi;
    if merged.maxCommonPointSupport > 6 then
        Error("maxCommonPointSupport cannot exceed 6.");
    fi;

    return merged;
end;


CF_SNS_ValidateCandidate := function(candidate)
    local required, name, basis, exponents, vector, exponent;

    if not IsRecord(candidate) then
        Error("A smoothness candidate must be a record.");
    fi;

    required := [
        "candidateNumber",
        "symplecticPart",
        "componentIndex",
        "projectiveGId",
        "linearGId",
        "cubicMonomialExponents",
        "cubicInvariantBasisVectors",
        "cubicInvariantDimension",
        "centralizerDimension",
        "expectedModuliDimension",
        "genericIndex",
        "genericFullLinearContainmentVerified",
        "gonzalezRestrictionApplied",
        "gonzalezPassed",
        "isDirectKnownCase"
    ];
    for name in required do
        if not IsBound(candidate.(name)) then
            Error("Candidate record has no component ", name, ".");
        fi;
    od;

    basis := candidate.cubicInvariantBasisVectors;
    exponents := candidate.cubicMonomialExponents;
    if Length(basis) <> candidate.cubicInvariantDimension then
        Error("The retained invariant-basis dimension is inconsistent.");
    fi;
    if Length(basis) = 0 then
        Error("The zero-dimensional cubic space is not a smoothness candidate.");
    fi;

    for vector in basis do
        if Length(vector) <> Length(exponents) then
            Error("An invariant basis vector has the wrong length.");
        fi;
    od;
    for exponent in exponents do
        if Length(exponent) <> 6 or Sum(exponent) <> 3
           or ForAny(exponent, x -> not IsInt(x) or x < 0) then
            Error("The cubic monomial exponent list is invalid.");
        fi;
    od;

    if candidate.expectedModuliDimension
       <> candidate.cubicInvariantDimension
          - candidate.centralizerDimension then
        Error("The stored family dimension is inconsistent.");
    fi;
    if candidate.genericFullLinearContainmentVerified <> true then
        Error("The candidate has not passed the required containment check.");
    fi;
    if candidate.gonzalezRestrictionApplied <> true
       or candidate.gonzalezPassed <> true then
        Error("The candidate has not passed the Gonzalez restriction.");
    fi;

    return true;
end;


CF_SNS_ValidateCandidateList := function(candidates)
    local candidateNumbers, candidate;

    if not IsList(candidates) or Length(candidates) = 0 then
        Error("The retained candidate input must be a nonempty list.");
    fi;
    candidateNumbers := [];
    for candidate in candidates do
        CF_SNS_ValidateCandidate(candidate);
        Add(candidateNumbers, candidate.candidateNumber);
    od;
    if candidateNumbers <> Set(candidateNumbers) then
        Error(
            "Candidate numbers must be unique and occur in increasing ",
            "retained order."
        );
    fi;
    return true;
end;


CF_SNS_ResolveTools := function(options)
    local tools, lowerTimeoutPath;

    tools := CF_SNS_ExternalTools();

    # Windows ships an unrelated interactive command named timeout.exe.
    # The inherited Singular wrapper needs the GNU timeout interface, so do
    # not accept the System32 program found by automatic PATH lookup.
    if tools.timeout <> fail then
        lowerTimeoutPath := LowercaseString(tools.timeout);
        if PositionSublist(
            lowerTimeoutPath,
            "windows/system32/timeout"
        ) <> fail
        or PositionSublist(
            lowerTimeoutPath,
            "windows\\system32\\timeout"
        ) <> fail then
            tools.timeout := fail;
        fi;
    fi;

    if options.singularExecutable <> fail then
        if not IsExecutableFile(options.singularExecutable) then
            Error("The configured Singular file is not executable: ",
                  options.singularExecutable, ".");
        fi;
        tools.singular := options.singularExecutable;
    fi;

    if options.timeoutExecutable <> fail then
        if not IsExecutableFile(options.timeoutExecutable) then
            Error("The configured timeout file is not executable: ",
                  options.timeoutExecutable, ".");
        fi;
        tools.timeout := options.timeoutExecutable;
        lowerTimeoutPath := LowercaseString(tools.timeout);
        if PositionSublist(
            lowerTimeoutPath,
            "windows/system32/timeout"
        ) <> fail
        or PositionSublist(
            lowerTimeoutPath,
            "windows\\system32\\timeout"
        ) <> fail then
            Error("Windows System32 timeout.exe is not GNU timeout.");
        fi;
    fi;

    return tools;
end;


#############################################################################
## 2. Exact GAP obstructions and deterministic coefficient batches
#############################################################################

CF_SNS_LinearVariablesInFamily := function(candidate)
    local answer, variableIndex, maximumExponent, basisVector,
          monomialIndex;

    CF_SNS_ValidateCandidate(candidate);
    answer := [];

    for variableIndex in [1 .. 6] do
        maximumExponent := 0;
        for basisVector in candidate.cubicInvariantBasisVectors do
            for monomialIndex in
                [1 .. Length(candidate.cubicMonomialExponents)] do
                if basisVector[monomialIndex] <> 0 then
                    maximumExponent := Maximum(
                        maximumExponent,
                        candidate.cubicMonomialExponents[
                            monomialIndex
                        ][variableIndex]
                    );
                fi;
            od;
        od;
        if maximumExponent <= 1 then
            Add(answer, variableIndex);
        fi;
    od;

    return answer;
end;


CF_SNS_CoordinatePoint := function(variableIndex)
    local point;

    if not IsInt(variableIndex)
       or variableIndex < 1 or variableIndex > 6 then
        Error("A coordinate-point index must lie in [1..6].");
    fi;

    point := [0, 0, 0, 0, 0, 0];
    point[variableIndex] := 1;
    return point;
end;


CF_SNS_GuessCoefficients := function(dimension)
    if not IsInt(dimension) or dimension < 1 then
        Error("The invariant cubic dimension must be positive.");
    fi;
    return List([1 .. dimension], i -> i * i + 1);
end;


CF_SNS_AddUniqueCoefficientVector := function(candidates, vector)
    if Length(vector) = 0 or ForAll(vector, x -> x = 0) then
        return;
    fi;
    if Position(candidates, vector) = fail then
        Add(candidates, ShallowCopy(vector));
    fi;
end;


# A one-dimensional space needs only [1]. Otherwise begin with i^2+1 and
# preserve the fixed order of dense, sparse, and fixed-seed integer vectors.
CF_SNS_CoefficientCandidates := function(dimension, maximum)
    local candidates, vector, i, j, middle, seed, attempt, value;

    if not IsInt(dimension) or dimension < 1 then
        Error("The invariant cubic dimension must be positive.");
    fi;
    if not IsInt(maximum) or maximum < 1 then
        Error("The maximum number of coefficient candidates must be positive.");
    fi;
    if dimension = 1 then
        return [[1]];
    fi;

    candidates := [];
    CF_SNS_AddUniqueCoefficientVector(
        candidates,
        CF_SNS_GuessCoefficients(dimension)
    );
    CF_SNS_AddUniqueCoefficientVector(
        candidates,
        List([1 .. dimension], i -> 1)
    );
    CF_SNS_AddUniqueCoefficientVector(
        candidates,
        List([1 .. dimension], i -> i)
    );
    CF_SNS_AddUniqueCoefficientVector(
        candidates,
        List([1 .. dimension], i -> (-1) ^ (i - 1) * i)
    );

    if dimension > 1 then
        middle := QuoInt(dimension + 1, 2);
        vector := List([1 .. dimension], i -> 0);
        vector[1] := 1;
        vector[middle] := -1;
        vector[dimension] := 3;
        CF_SNS_AddUniqueCoefficientVector(candidates, vector);
    fi;

    for i in [1 .. dimension] do
        vector := List([1 .. dimension], j -> 0);
        vector[i] := 1;
        CF_SNS_AddUniqueCoefficientVector(candidates, vector);
        if Length(candidates) >= maximum then
            return candidates{[1 .. maximum]};
        fi;
    od;

    if dimension > 1 then
        for i in [1 .. dimension - 1] do
            for j in [i + 1 .. dimension] do
                vector := List([1 .. dimension], k -> 0);
                vector[i] := 1;
                vector[j] := 1;
                CF_SNS_AddUniqueCoefficientVector(candidates, vector);
                if Length(candidates) >= maximum then
                    return candidates{[1 .. maximum]};
                fi;
                vector[j] := -1;
                CF_SNS_AddUniqueCoefficientVector(candidates, vector);
                if Length(candidates) >= maximum then
                    return candidates{[1 .. maximum]};
                fi;
            od;
        od;
    fi;

    seed := 104729 + 97 * dimension;
    attempt := 1;
    while Length(candidates) < maximum
          and attempt <= 20 * maximum + 200 do
        vector := [];
        for i in [1 .. dimension] do
            seed := (1103515245 * seed + 12345) mod 2147483647;
            value := (seed mod 23) - 11;
            if value = 0 then
                value := ((i + attempt) mod 7) + 1;
            fi;
            Add(vector, value);
        od;
        CF_SNS_AddUniqueCoefficientVector(candidates, vector);
        attempt := attempt + 1;
    od;

    return candidates;
end;


CF_SNS_CommonMonomialFactor := function(candidate)
    local minimumExponents, foundTerm, vector, monomialIndex,
          exponent, variableIndex;

    minimumExponents := [3, 3, 3, 3, 3, 3];
    foundTerm := false;
    for vector in candidate.cubicInvariantBasisVectors do
        for monomialIndex in [1 .. Length(vector)] do
            if vector[monomialIndex] <> 0 then
                foundTerm := true;
                exponent := candidate.cubicMonomialExponents[monomialIndex];
                for variableIndex in [1 .. 6] do
                    minimumExponents[variableIndex] := Minimum(
                        minimumExponents[variableIndex],
                        exponent[variableIndex]
                    );
                od;
            fi;
        od;
    od;

    if not foundTerm or Sum(minimumExponents) = 0 then
        return fail;
    fi;
    return rec(
        exponents := minimumExponents,
        factor := CF_SNS_MonomialString(minimumExponents)
    );
end;


CF_SNS_MemberData := function(candidate, coefficients)
    local vector;

    if Length(coefficients) <> candidate.cubicInvariantDimension then
        Error("The guessed coefficient vector has the wrong length.");
    fi;
    if ForAll(coefficients, x -> x = 0) then
        Error("The guessed cubic cannot be zero.");
    fi;

    vector := CF_SNS_LinearCombinationOfVectors(
        candidate.cubicInvariantBasisVectors,
        coefficients
    );
    return rec(
        coefficients := ShallowCopy(coefficients),
        monomialCoefficients := vector,
        polynomial := CF_SNS_CoefficientVectorToPolynomialString(
            vector,
            candidate.cubicMonomialExponents
        )
    );
end;


#############################################################################
## 3. Singular tests for chosen members
#############################################################################

# Keep the relevant output text inside GAP-readable records, not as a
# separate permanent Singular transcript file.
CF_SNS_CompactTrial := function(test)
    local answer;

    answer := rec(status := test.status);
    if IsBound(test.exitCode) then
        answer.exitCode := test.exitCode;
    fi;
    if IsBound(test.prime) then
        answer.prime := test.prime;
    fi;
    if IsBound(test.witnessIndex) then
        answer.witnessIndex := test.witnessIndex;
    fi;
    if IsBound(test.witnessVerificationPassed) then
        answer.witnessVerificationPassed :=
            test.witnessVerificationPassed;
    fi;
    if IsBound(test.singularChart) then
        answer.singularChart := test.singularChart;
    fi;
    if IsBound(test.conductor) then
        answer.coefficientFieldConductor := test.conductor;
    fi;
    if IsBound(test.output) then
        answer.singularOutput := test.output;
    fi;
    if IsBound(test.memberRecords) then
        answer.numberOfMembersTested := Length(test.memberRecords);
    fi;
    return answer;
end;


CF_SNS_TestCandidateMembers := function(
    candidate,
    coefficientCandidates,
    tools,
    options
)
    local member, primeData, primeCount, primeIndex, p, test,
          finiteFieldTrials, exactTrials, exactCount, exactIndex,
          exactTest, witnessRecord;

    if Length(coefficientCandidates) = 0 then
        Error("At least one coefficient candidate is required.");
    fi;
    finiteFieldTrials := [];
    exactTrials := [];

    if tools.singular = fail or tools.timeout = fail then
        return rec(
            status := "unavailable",
            method := "none",
            coefficientCandidates := ShallowCopy(coefficientCandidates),
            finiteFieldTrials := [],
            exactTrials := []
        );
    fi;

    primeData := CF_SNS_AdmissibleSplitPrimes(
        candidate,
        options.maxSplitPrimes,
        options.maxPrime
    );
    if options.useFiniteFieldTest then
        primeCount := Minimum(
            options.maxPrimeTrials,
            Length(primeData.primes)
        );

        if primeCount > 0 then
            for primeIndex in [1 .. primeCount] do
                p := primeData.primes[primeIndex];
                test := CF_SNS_TestCandidateBatchAtPrime(
                    candidate,
                    coefficientCandidates,
                    primeData.conductor,
                    p,
                    tools,
                    options.finiteFieldTimeoutSeconds
                );
                Add(finiteFieldTrials, CF_SNS_CompactTrial(test));

                if test.status = "smooth"
                   and test.witnessIndex <> fail
                   and IsBound(test.witnessVerificationPassed)
                   and test.witnessVerificationPassed then
                    witnessRecord := test.memberRecords[test.witnessIndex];
                    member := CF_SNS_MemberData(
                        candidate,
                        witnessRecord.coefficients
                    );
                    return rec(
                        status := "smooth",
                        method := "smooth reduction at a good split prime",
                        member := member,
                        witnessPrime := p,
                        coefficientFieldConductor := primeData.conductor,
                        coefficientCandidates :=
                            ShallowCopy(coefficientCandidates),
                        finiteFieldTrials := finiteFieldTrials,
                        exactTrials := exactTrials
                    );
                fi;
            od;
        fi;
    fi;

    if options.useExactCharacteristicZeroFallback then
        exactCount := Minimum(
            options.maxExactMemberTrials,
            Length(coefficientCandidates)
        );
        if exactCount > 0 then
            for exactIndex in [1 .. exactCount] do
                exactTest := CF_SNS_RunExactMemberTest(
                    candidate,
                    coefficientCandidates[exactIndex],
                    tools,
                    options.exactMemberTimeoutSeconds
                );
                Add(
                    exactTrials,
                    rec(
                        coefficients := ShallowCopy(
                            coefficientCandidates[exactIndex]
                        ),
                        trial := CF_SNS_CompactTrial(exactTest)
                    )
                );
                if exactTest.status = "exact_smooth" then
                    member := CF_SNS_MemberData(
                        candidate,
                        coefficientCandidates[exactIndex]
                    );
                    return rec(
                        status := "smooth",
                        method :=
                            "exact characteristic-zero six-chart Jacobian test",
                        member := member,
                        coefficientFieldConductor := exactTest.conductor,
                        coefficientCandidates :=
                            ShallowCopy(coefficientCandidates),
                        finiteFieldTrials := finiteFieldTrials,
                        exactTrials := exactTrials
                    );
                fi;
            od;
        fi;
    fi;

    return rec(
        status := "no_smooth_witness",
        method := "deterministic coefficient batch",
        coefficientFieldConductor := primeData.conductor,
        coefficientCandidates := ShallowCopy(coefficientCandidates),
        finiteFieldTrials := finiteFieldTrials,
        exactTrials := exactTrials
    );
end;


CF_SNS_TestGuessedMember := function(
    candidate,
    coefficients,
    tools,
    options
)
    local result;

    result := CF_SNS_TestCandidateMembers(
        candidate,
        [coefficients],
        tools,
        options
    );
    if not IsBound(result.member) then
        result.member := CF_SNS_MemberData(candidate, coefficients);
    fi;
    return result;
end;


#############################################################################
## 4. Classification of one candidate
#############################################################################

CF_SNS_NewResult := function(candidate)
    local result;

    result := rec(
        candidateNumber := candidate.candidateNumber,
        symplecticPart := candidate.symplecticPart,
        componentIndex := candidate.componentIndex,
        projectiveGId := ShallowCopy(candidate.projectiveGId),
        linearGId := ShallowCopy(candidate.linearGId),
        genericIndex := candidate.genericIndex,
        isDirectKnownCase := candidate.isDirectKnownCase,
        cubicInvariantDimension := candidate.cubicInvariantDimension,
        centralizerDimension := candidate.centralizerDimension,
        familyDimension := candidate.expectedModuliDimension
    );
    if IsBound(candidate.componentLabel) then
        result.componentLabel := candidate.componentLabel;
    fi;
    if IsBound(candidate.familyIndexWithinCase) then
        result.familyIndexWithinCase :=
            candidate.familyIndexWithinCase;
    fi;
    if IsBound(candidate.determinantImageOrder) then
        result.determinantImageOrder := candidate.determinantImageOrder;
    fi;
    return result;
end;


CF_SNS_ClassifyCandidate := function(candidate, tools, options)
    local result, commonFactor, linearVariables, point,
          coefficientCandidates, firstMember, memberTest, commonPointData,
          exactCommonLocusTest;

    CF_SNS_ValidateCandidate(candidate);
    result := CF_SNS_NewResult(candidate);

    if candidate.cubicInvariantDimension
       < candidate.centralizerDimension then
        result.status := "singular";
        result.proofType :=
            "the invariant-space dimension is smaller than the matrix-centralizer dimension";
        result.invariantDimension := candidate.cubicInvariantDimension;
        result.centralizerDimension := candidate.centralizerDimension;
        result.guessedMemberTest := rec(status := "not_run");
        return result;
    fi;

    commonFactor := CF_SNS_CommonMonomialFactor(candidate);
    if commonFactor <> fail then
        result.status := "singular";
        result.proofType :=
            "every invariant cubic has a nonconstant common monomial factor";
        result.commonMonomialFactor := commonFactor.factor;
        result.commonMonomialFactorExponents := commonFactor.exponents;
        result.guessedMemberTest := rec(status := "not_run");
        return result;
    fi;

    linearVariables := CF_SNS_LinearVariablesInFamily(candidate);
    if Length(linearVariables) > 0 then
        point := CF_SNS_CoordinatePoint(linearVariables[1]);
        if not CF_SNS_PointIsCommonSingularPoint(candidate, point) then
            Error("The coordinate-point singularity certificate failed.");
        fi;
        result.status := "singular";
        result.proofType :=
            "a variable has exponent at most one throughout the family";
        result.linearVariables := linearVariables;
        result.commonSingularPoint := point;
        result.guessedMemberTest := rec(status := "not_run");
        return result;
    fi;

    coefficientCandidates := CF_SNS_CoefficientCandidates(
        candidate.cubicInvariantDimension,
        options.maxCoefficientCandidates
    );
    firstMember := CF_SNS_MemberData(
        candidate,
        coefficientCandidates[1]
    );
    memberTest := CF_SNS_TestCandidateMembers(
        candidate,
        coefficientCandidates,
        tools,
        options
    );

    if memberTest.status = "smooth" then
        result.status := "smooth";
        result.proofType :=
            "an explicit member of the invariant cubic family is smooth";
        result.guessedCoefficients :=
            memberTest.member.coefficients;
        result.smoothPolynomial := memberTest.member.polynomial;
        result.testedCoefficientCandidates := coefficientCandidates;
        result.guessedMemberTest := memberTest;
        return result;
    fi;

    exactCommonLocusTest := rec(status := "not_run");
    commonPointData := CF_SNS_FindSmallCommonSingularPointBounded(
        candidate,
        options.maxCommonPointSupport,
        options.maxCommonPointChecks
    );
    if commonPointData.point <> fail then
        if not CF_SNS_PointIsCommonSingularPoint(
            candidate,
            commonPointData.point
        ) then
            Error("The recorded common singular point failed rechecking.");
        fi;
        result.status := "singular";
        result.proofType :=
            "an exact common singular point was found for the invariant basis";
        result.commonSingularPoint := commonPointData.point;
        result.commonPointChecks := commonPointData.checks;
        result.guessedCoefficients := firstMember.coefficients;
        result.guessedPolynomial := firstMember.polynomial;
        result.testedCoefficientCandidates := coefficientCandidates;
        result.guessedMemberTest := memberTest;
        return result;
    fi;

    if options.useExactCommonSingularLocusTest then
        if tools.singular = fail or tools.timeout = fail then
            exactCommonLocusTest := rec(status := "unavailable");
        else
            exactCommonLocusTest :=
                CF_SNS_RunExactCommonSingularLocusTest(
                    candidate,
                    tools,
                    options.commonLocusTimeoutSeconds
                );
        fi;
        if exactCommonLocusTest.status
           = "common_singular_point_exists" then
            result.status := "singular";
            result.proofType :=
                "the invariant basis has a nonempty exact common projective Jacobian locus";
            result.commonSingularChart :=
                exactCommonLocusTest.singularChart;
            result.exactCommonLocusTest :=
                CF_SNS_CompactTrial(exactCommonLocusTest);
            result.guessedCoefficients := firstMember.coefficients;
            result.guessedPolynomial := firstMember.polynomial;
            result.testedCoefficientCandidates := coefficientCandidates;
            result.guessedMemberTest := memberTest;
            return result;
        fi;
    fi;

    result.status := "unknown";
    result.proofType :=
        "no smooth member or family-wide singularity certificate was found";
    result.guessedCoefficients := firstMember.coefficients;
    result.guessedPolynomial := firstMember.polynomial;
    result.testedCoefficientCandidates := coefficientCandidates;
    result.guessedMemberTest := memberTest;
    result.exactCommonLocusTest :=
        CF_SNS_CompactTrial(exactCommonLocusTest);
    result.commonPointChecks := commonPointData.checks;
    result.commonPointLimitReached := commonPointData.limitReached;
    return result;
end;


#############################################################################
## 5. Log and GAP-oriented output
#############################################################################

CF_SNS_Log := function(arg)
    local item;
    for item in arg do
        Print(item);
        AppendTo(CF_SNS_LOG_FILE, item);
    od;
end;


CF_SNS_CountProofTypes := function(results)
    local counts, result, position;

    counts := [];
    for result in results do
        position := PositionProperty(
            counts,
            item -> item.proofType = result.proofType
        );
        if position = fail then
            Add(
                counts,
                rec(proofType := result.proofType, count := 1)
            );
        else
            counts[position].count := counts[position].count + 1;
        fi;
    od;
    return counts;
end;


CF_SNS_CandidateNumbersWithStatus := function(results, status)
    return List(
        Filtered(results, result -> result.status = status),
        result -> result.candidateNumber
    );
end;


CF_SNS_Run := function(candidates, runOptions)
    local options, tools, startTime, results, candidate, result,
          position, candidateStartTime, run, smoothCount, singularCount,
          unknownCount, proofTypeCounts, sourceSummary, sourceRecord,
          outputStream, methodIndex;

    CF_SNS_ValidateCandidateList(candidates);

    options := CF_SNS_MergeOptions(runOptions);
    tools := CF_SNS_ResolveTools(options);
    startTime := Runtime();
    results := [];
    sourceSummary := fail;
    sourceRecord := fail;
    if IsBoundGlobal("SmallNonabelianResultSummary") then
        sourceSummary := ShallowCopy(
            ValueGlobal("SmallNonabelianResultSummary")
        );
    fi;
    if IsBoundGlobal("SmallNonabelianSourceRecord") then
        sourceRecord := ShallowCopy(
            ValueGlobal("SmallNonabelianSourceRecord")
        );
    fi;

    PrintTo(
        CF_SNS_LOG_FILE,
        "Small non-abelian smoothness screening log\n\n",
        "Run configuration\n",
        "Environment: WSL (Ubuntu)\n",
        "GAP version: ", GAPInfo.Version, "\n",
        "Input file: ", CF_SNS_INPUT_FILE, "\n",
        "Retained candidates: ", Length(candidates), "\n",
        "Deterministic coefficient vectors per family: at most ",
        options.maxCoefficientCandidates, "\n",
        "Good split primes per family: at most ",
        options.maxPrimeTrials, "\n",
        "Exact characteristic-zero members per family: at most ",
        options.maxExactMemberTrials, "\n",
        "Bounded common-point checks per family: at most ",
        options.maxCommonPointChecks, "\n",
        "Exact common Jacobian locus test: ",
        options.useExactCommonSingularLocusTest,
        "; timeout ", options.commonLocusTimeoutSeconds, " s\n",
        "Singular: ", tools.singular, "\n",
        "GNU timeout: ", tools.timeout, "\n"
    );
    if sourceSummary <> fail then
        AppendTo(
            CF_SNS_LOG_FILE,
            "Enumeration input: raw ", sourceSummary.rawCount,
            ", Gonzalez rejected ", sourceSummary.rejectedCount,
            ", retained ", sourceSummary.retainedCount, "\n"
        );
    fi;
    AppendTo(CF_SNS_LOG_FILE, "\nProgress\n");

    if tools.singular = fail or tools.timeout = fail then
        CF_SNS_Log(
            "Singular tests are unavailable; exact GAP certificates will ",
            "still be attempted.\n"
        );
    fi;

    for position in [1 .. Length(candidates)] do
        candidate := candidates[position];
        candidateStartTime := Runtime();
        result := CF_SNS_ClassifyCandidate(candidate, tools, options);
        Add(results, result);
        if options.printProgress then
            CF_SNS_Log(
                position, ". Candidate ", candidate.candidateNumber,
                " (", candidate.symplecticPart, ", projective ",
                String(candidate.projectiveGId), "): ", result.status,
                "; proof = ", result.proofType,
                "; elapsed ", Runtime() - candidateStartTime, " ms\n"
            );
        fi;
    od;

    smoothCount := Number(results, r -> r.status = "smooth");
    singularCount := Number(results, r -> r.status = "singular");
    unknownCount := Number(results, r -> r.status = "unknown");
    proofTypeCounts := CF_SNS_CountProofTypes(results);

    run := rec(
        schemaVersion := 3,
        sourceDataFile := CF_SNS_INPUT_FILE,
        sourceEnumerationSummary := sourceSummary,
        sourceEnumerationRecord := sourceRecord,
        coefficientRule :=
            "deterministic ordered batch beginning with [i^2+1 : i=1..d]",
        classificationConvention := rec(
            smooth :=
                "an explicit smooth member, hence a generically smooth family",
            singular :=
                "a singularity certificate valid for every family member",
            unknown := "neither certificate was found"
        ),
        unknownFollowUp :=
            "the retained unknown families will be verified separately by hand to be singular",
        options := options,
        externalTools := rec(
            environment := "WSL (Ubuntu)",
            gapVersion := GAPInfo.Version,
            singular := tools.singular,
            timeout := tools.timeout
        ),
        numberOfCandidates := Length(candidates),
        smoothCount := smoothCount,
        singularCount := singularCount,
        unknownCount := unknownCount,
        smoothCandidateNumbers :=
            CF_SNS_CandidateNumbersWithStatus(results, "smooth"),
        singularCandidateNumbers :=
            CF_SNS_CandidateNumbersWithStatus(results, "singular"),
        unknownCandidateNumbers :=
            CF_SNS_CandidateNumbersWithStatus(results, "unknown"),
        proofTypeCounts := proofTypeCounts,
        runtimeMilliseconds := Runtime() - startTime,
        results := results
    );

    outputStream := OutputTextFile(CF_SNS_OUTPUT_FILE, false);
    if outputStream = fail then
        Error("Cannot create ", CF_SNS_OUTPUT_FILE, ".");
    fi;
    SetPrintFormattingStatus(outputStream, false);
    PrintTo(
        outputStream,
        "# Generated by gap_small_nonabelian_smoothness.g.\n",
        "# This is GAP-readable result data.\n\n",
        "SmallNonabelianSmoothnessRun := ", run, ";\n",
        "SmallNonabelianSmoothnessResults := ",
        "SmallNonabelianSmoothnessRun.results;\n",
        "SmallNonabelianSmoothnessSummary := rec(\n",
        "  candidateCount := ", Length(candidates), ",\n",
        "  smoothCount := ", smoothCount, ",\n",
        "  singularCount := ", singularCount, ",\n",
        "  unknownCount := ", unknownCount, ",\n",
        "  smoothCandidateNumbers := ",
        run.smoothCandidateNumbers, ",\n",
        "  singularCandidateNumbers := ",
        run.singularCandidateNumbers, ",\n",
        "  unknownCandidateNumbers := ",
        run.unknownCandidateNumbers, ",\n",
        "  proofTypeCounts := ", proofTypeCounts, "\n",
        ");\n"
    );
    CloseStream(outputStream);

    CF_SNS_Log(
        "\nSummary\n",
        "candidates = ", Length(candidates), "\n",
        "smooth = ", smoothCount, "\n",
        "singular = ", singularCount, "\n",
        "unknown = ", unknownCount, "\n",
        "proof methods\n"
    );
    for methodIndex in [1 .. Length(proofTypeCounts)] do
        CF_SNS_Log(
            "  ", methodIndex, ". ",
            proofTypeCounts[methodIndex].proofType,
            " = ", proofTypeCounts[methodIndex].count, "\n"
        );
    od;
    if unknownCount > 0 then
        CF_SNS_Log(
            "manual follow-up = candidates ",
            String(run.unknownCandidateNumbers),
            " remain unknown in this screening and will be verified ",
            "separately by hand to be singular\n"
        );
    fi;
    CF_SNS_Log(
        "runtime = ", run.runtimeMilliseconds, " ms\n",
        "output = ", CF_SNS_OUTPUT_FILE, "\n"
    );

    return run;
end;


#############################################################################
## 6. Default run
#############################################################################

if CF_SNS_AUTO_RUN then
    if not IsExistingFile(CF_SNS_INPUT_FILE) then
        Error(
            "Cannot find ", CF_SNS_INPUT_FILE,
            ". Run gap_small_nonabelian.g to completion first."
        );
    fi;
    Read(CF_SNS_INPUT_FILE);
    if not IsBound(SmallNonabelianCandidates) then
        Error(
            CF_SNS_INPUT_FILE,
            " does not define SmallNonabelianCandidates."
        );
    fi;
    if IsBound(SmallNonabelianResultSummary) then
        if SmallNonabelianResultSummary.retainedCount
           <> Length(SmallNonabelianCandidates) then
            Error(
                "The retained candidate count disagrees with ",
                "SmallNonabelianResultSummary."
            );
        fi;
        if SmallNonabelianResultSummary.GonzalezApplied <> true then
            Error(
                "The smoothness input has not passed the Gonzalez filter."
            );
        fi;
        if SmallNonabelianResultSummary.smoothnessTested <> false then
            Error(
                "The source data should be the unmodified enumeration output."
            );
        fi;
    fi;
    CF_SNS_LAST_RUN := CF_SNS_Run(
        SmallNonabelianCandidates,
        CF_SNS_RUN_OPTIONS
    );
fi;
