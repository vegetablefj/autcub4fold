#############################################################################
## Common exact smoothness helpers for invariant cubic families.
##
## The GAP-side helpers require no additional GAP package. Polynomial-ideal
## tests call the external Singular executable, with GNU timeout in the
## recorded WSL runs.  Loading this file only defines functions; source-
## specific entry points prepare candidates, choose bounded searches, and
## write results.  A failed bounded search is never a singularity certificate.
#############################################################################

CF_SNS_JoinStrings := function(strings, separator)
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


CF_SNS_FindSystemProgram := function(names)
    local name, path;
    for name in names do
        path := Filename(DirectoriesSystemPrograms(), name);
        if path <> fail and IsExecutableFile(path) then
            return path;
        fi;
    od;
    return fail;
end;


CF_SNS_ExternalTools := function()
    return rec(
        singular := CF_SNS_FindSystemProgram(["Singular", "singular"]),
        timeout := CF_SNS_FindSystemProgram(["timeout", "gtimeout"])
    );
end;


CF_SNS_FamilyConductor := function(family)
    local conductor, vector, coefficient;
    conductor := 1;
    for vector in family.cubicInvariantBasisVectors do
        for coefficient in vector do
            if coefficient <> 0 then
                conductor := Lcm(conductor, Conductor(coefficient));
            fi;
        od;
    od;
    return conductor;
end;


CF_SNS_LinearCombinationOfVectors := function(basis, coefficients)
    local answer, i, j;
    if Length(basis) <> Length(coefficients) then
        Error("The basis and coefficient list have different lengths.");
    fi;
    if Length(basis) = 0 then
        return [];
    fi;
    answer := List([1 .. Length(basis[1])], j -> 0);
    for i in [1 .. Length(basis)] do
        for j in [1 .. Length(answer)] do
            answer[j] := answer[j] + coefficients[i] * basis[i][j];
        od;
    od;
    return answer;
end;


CF_SNS_MonomialString := function(exponent)
    local factors, i;
    factors := [];
    for i in [1 .. 6] do
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
    return CF_SNS_JoinStrings(factors, "*");
end;


CF_SNS_CoefficientVectorToPolynomialString := function(
    vector,
    exponentBasis
)
    local terms, i, coefficient, monomial;
    terms := [];
    for i in [1 .. Length(vector)] do
        coefficient := vector[i];
        if coefficient <> 0 then
            monomial := CF_SNS_MonomialString(exponentBasis[i]);
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
    return CF_SNS_JoinStrings(terms, " + ");
end;


#############################################################################
## Finite-field reduction of one chosen member
#############################################################################

CF_SNS_RationalToPrimeField := function(q, p, field)
    local numerator, denominator;
    numerator := NumeratorRat(q) mod p;
    denominator := DenominatorRat(q) mod p;
    if denominator = 0 then
        return fail;
    fi;
    return (numerator * One(field)) / (denominator * One(field));
end;


CF_SNS_CyclotomicToResidue := function(c, conductor, p)
    local field, root, coefficients, value, i, term;
    if c = 0 then
        return 0;
    fi;
    if (p - 1) mod conductor <> 0 then
        return fail;
    fi;
    field := GF(p);
    if conductor = 1 then
        root := One(field);
    else
        root := Z(p) ^ ((p - 1) / conductor);
    fi;
    coefficients := CoeffsCyc(c, conductor);
    value := Zero(field);
    for i in [1 .. Length(coefficients)] do
        term := CF_SNS_RationalToPrimeField(
            coefficients[i],
            p,
            field
        );
        if term = fail then
            return fail;
        fi;
        value := value + term * root ^ (i - 1);
    od;
    return IntFFE(value);
end;


CF_SNS_FamilyReducesAtPrime := function(family, conductor, p)
    local vector, coefficient;
    for vector in family.cubicInvariantBasisVectors do
        for coefficient in vector do
            if CF_SNS_CyclotomicToResidue(
                coefficient,
                conductor,
                p
            ) = fail then
                return false;
            fi;
        od;
    od;
    return true;
end;


CF_SNS_AdmissibleSplitPrimes := function(family, maxPrimes, maxPrime)
    local conductor, answer, p;
    conductor := CF_SNS_FamilyConductor(family);
    answer := [];
    p := 3;
    while Length(answer) < maxPrimes do
        p := NextPrimeInt(p);
        if p > maxPrime then
            break;
        fi;
        if (p - 1) mod conductor = 0
           and CF_SNS_FamilyReducesAtPrime(
               family,
               conductor,
               p
           ) then
            Add(answer, p);
        fi;
    od;
    return rec(
        conductor := conductor,
        primes := answer
    );
end;


CF_SNS_ReduceCoefficientVector := function(vector, conductor, p)
    local answer, coefficient, residue;
    answer := [];
    for coefficient in vector do
        residue := CF_SNS_CyclotomicToResidue(
            coefficient,
            conductor,
            p
        );
        if residue = fail then
            return fail;
        fi;
        Add(answer, residue);
    od;
    return answer;
end;


CF_SNS_PrepareCandidateMembersAtPrime := function(
    family,
    coefficientCandidates,
    conductor,
    p
)
    local records, coefficients, memberVector, reducedVector;
    records := [];
    for coefficients in coefficientCandidates do
        memberVector := CF_SNS_LinearCombinationOfVectors(
            family.cubicInvariantBasisVectors,
            coefficients
        );
        reducedVector := CF_SNS_ReduceCoefficientVector(
            memberVector,
            conductor,
            p
        );
        if reducedVector <> fail
           and not ForAll(reducedVector, x -> x = 0)
           and PositionProperty(
               records,
               r -> r.reducedVector = reducedVector
           ) = fail then
            Add(
                records,
                rec(
                    coefficients := ShallowCopy(coefficients),
                    memberVector := ShallowCopy(memberVector),
                    reducedVector := reducedVector
                )
            );
        fi;
    od;
    return records;
end;


CF_SNS_FiniteFieldDerivativeString := function(
    reducedVector,
    exponentBasis,
    variableIndex,
    p
)
    local terms, j, exponent, derivativeExponent, coefficient,
          monomial;
    terms := [];
    for j in [1 .. Length(reducedVector)] do
        exponent := exponentBasis[j];
        if reducedVector[j] <> 0
           and exponent[variableIndex] > 0 then
            coefficient :=
                (reducedVector[j] * exponent[variableIndex]) mod p;
            if coefficient <> 0 then
                derivativeExponent := ShallowCopy(exponent);
                derivativeExponent[variableIndex] :=
                    derivativeExponent[variableIndex] - 1;
                monomial := CF_SNS_MonomialString(
                    derivativeExponent
                );
                Add(
                    terms,
                    Concatenation(
                        String(coefficient), "*", monomial
                    )
                );
            fi;
        fi;
    od;
    if Length(terms) = 0 then
        return "0";
    fi;
    return CF_SNS_JoinStrings(terms, "+");
end;


# A homogeneous Jacobian cone of dimension zero has only the origin.
# This finite-field test does not use the characteristic-zero chart loop.
CF_SNS_SingularBatchSmoothnessScript := function(
    memberRecords,
    exponentBasis,
    p
)
    local lines, memberIndex, derivatives, variableIndex, prefix;
    lines := [
        Concatenation(
            "ring r=", String(p),
            ",(x1,x2,x3,x4,x5,x6),dp;"
        ),
        "option(redSB);",
        "int cf_found=0;"
    ];
    for memberIndex in [1 .. Length(memberRecords)] do
        derivatives := List(
            [1 .. 6],
            variableIndex -> CF_SNS_FiniteFieldDerivativeString(
                memberRecords[memberIndex].reducedVector,
                exponentBasis,
                variableIndex,
                p
            )
        );
        prefix := Concatenation("m", String(memberIndex), "_");
        Add(lines, "if (cf_found==0)");
        Add(lines, "{");
        for variableIndex in [1 .. 6] do
            Add(
                lines,
                Concatenation(
                    "poly ", prefix, "d", String(variableIndex),
                    "=", derivatives[variableIndex], ";"
                )
            );
        od;
        Add(
            lines,
            Concatenation(
                "ideal ", prefix, "J=",
                prefix, "d1,", prefix, "d2,", prefix, "d3,",
                prefix, "d4,", prefix, "d5,", prefix, "d6;"
            )
        );
        Add(
            lines,
            Concatenation("ideal ", prefix, "B=std(", prefix, "J);")
        );
        Add(lines, Concatenation("if (dim(", prefix, "B)==0)"));
        Add(lines, "{");
        Add(
            lines,
            Concatenation(
                "print(\"CF_SMOOTH_MEMBER_", String(memberIndex),
                "_END\");"
            )
        );
        Add(lines, Concatenation("cf_found=", String(memberIndex), ";"));
        Add(lines, "}");
        Add(lines, "else");
        Add(lines, "{");
        Add(
            lines,
            Concatenation(
                "print(\"CF_SINGULAR_MEMBER_", String(memberIndex),
                "_END\");"
            )
        );
        Add(lines, "}");
        Add(lines, "}");
    od;
    Add(lines, "if (cf_found==0)");
    Add(lines, "{");
    Add(lines, "print(\"CF_NO_SMOOTH_MEMBER\");");
    Add(lines, "}");
    Add(lines, "print(\"CF_SCRIPT_COMPLETED_OK\");");
    Add(lines, "quit;");
    return CF_SNS_JoinStrings(lines, "\n");
end;


#############################################################################
## External Singular process
#############################################################################

CF_SNS_OutputHasErrorMarker := function(output)
    return PositionSublist(output, "? error occurred") <> fail
        or PositionSublist(output, "syntax error") <> fail
        or PositionSublist(output, "ERROR") <> fail
        or PositionSublist(output, "Error:") <> fail;
end;


# GAP manages these temporary directories and attempts cleanup on exit.
# Relevant output text can be retained by the caller in a result record.
CF_SNS_RunBoundedSingularScript := function(script, tools, timeoutSeconds)
    local tempDirectory, inputFile, outputFile, outputStream,
          exitCode, output, outputHasError;
    if tools.singular = fail or tools.timeout = fail then
        return rec(
            status := "unavailable",
            output := "",
            exitCode := fail
        );
    fi;
    tempDirectory := DirectoryTemporary("cf_sns");
    if tempDirectory = fail then
        return rec(
            status := "temporary_directory_error",
            output := "",
            exitCode := fail
        );
    fi;
    inputFile := Filename(tempDirectory, "input.sing");
    outputFile := Filename(tempDirectory, "output.txt");
    PrintTo(inputFile, script);
    outputStream := OutputTextFile(outputFile, false);
    if outputStream = fail then
        return rec(
            status := "output_file_error",
            output := "",
            exitCode := fail
        );
    fi;
    SetPrintFormattingStatus(outputStream, false);
    exitCode := Process(
        tempDirectory,
        tools.timeout,
        InputTextNone(),
        outputStream,
        [
            "-k",
            "1s",
            Concatenation(String(timeoutSeconds), "s"),
            tools.singular,
            "-q",
            inputFile
        ]
    );
    CloseStream(outputStream);
    if IsExistingFile(outputFile) then
        output := StringFile(outputFile);
    else
        output := "";
    fi;
    outputHasError := CF_SNS_OutputHasErrorMarker(output);
    if exitCode = 0
       and not outputHasError
       and PositionSublist(output, "CF_SCRIPT_COMPLETED_OK") <> fail
       and PositionSublist(output, "CF_SMOOTH_MEMBER_") <> fail then
        return rec(
            status := "smooth",
            output := output,
            exitCode := exitCode
        );
    fi;
    if exitCode = 0
       and not outputHasError
       and PositionSublist(output, "CF_SCRIPT_COMPLETED_OK") <> fail
       and PositionSublist(output, "CF_NO_SMOOTH_MEMBER") <> fail then
        return rec(
            status := "no_smooth_in_batch",
            output := output,
            exitCode := exitCode
        );
    fi;
    if exitCode = 0
       and not outputHasError
       and PositionSublist(output, "CF_SCRIPT_COMPLETED_OK") <> fail then
        return rec(
            status := "completed",
            output := output,
            exitCode := exitCode
        );
    fi;
    return rec(
        status := "timeout_or_error",
        output := output,
        exitCode := exitCode
    );
end;


CF_SNS_FindSmoothMemberIndexInOutput := function(output, count)
    local i, marker;
    for i in [1 .. count] do
        marker := Concatenation(
            "CF_SMOOTH_MEMBER_", String(i), "_END"
        );
        if PositionSublist(output, marker) <> fail then
            return i;
        fi;
    od;
    return fail;
end;


CF_SNS_TestCandidateBatchAtPrime := function(
    family,
    coefficientCandidates,
    conductor,
    p,
    tools,
    timeoutSeconds
)
    local memberRecords, script, run, witnessIndex,
          verificationScript, verificationRun, verificationIndex;
    memberRecords := CF_SNS_PrepareCandidateMembersAtPrime(
        family,
        coefficientCandidates,
        conductor,
        p
    );
    if Length(memberRecords) = 0 then
        return rec(
            status := "no_nonzero_reductions",
            prime := p,
            memberRecords := [],
            witnessIndex := fail,
            witnessVerificationPassed := false,
            output := "",
            exitCode := fail
        );
    fi;
    script := CF_SNS_SingularBatchSmoothnessScript(
        memberRecords,
        family.cubicMonomialExponents,
        p
    );
    run := CF_SNS_RunBoundedSingularScript(
        script,
        tools,
        timeoutSeconds
    );
    witnessIndex := CF_SNS_FindSmoothMemberIndexInOutput(
        run.output,
        Length(memberRecords)
    );
    run.prime := p;
    run.memberRecords := memberRecords;
    run.witnessIndex := witnessIndex;
    run.witnessVerificationPassed := false;
    if run.status = "smooth" and witnessIndex <> fail then
        verificationScript := CF_SNS_SingularBatchSmoothnessScript(
            [memberRecords[witnessIndex]],
            family.cubicMonomialExponents,
            p
        );
        verificationRun := CF_SNS_RunBoundedSingularScript(
            verificationScript,
            tools,
            timeoutSeconds
        );
        verificationIndex := CF_SNS_FindSmoothMemberIndexInOutput(
            verificationRun.output,
            1
        );
        run.witnessVerificationPassed :=
            verificationRun.status = "smooth"
            and verificationIndex = 1;
        if not run.witnessVerificationPassed then
            run.status := "verification_failed";
        fi;
    elif witnessIndex <> fail then
        run.status := "marker_status_mismatch";
    fi;
    return run;
end;


#############################################################################
## Exact GAP evaluation of common singular points
#############################################################################

CF_SNS_EvaluateCubicPartialAtPoint := function(
    coefficientVector,
    exponentBasis,
    variableIndex,
    point
)
    local answer, monomialIndex, exponent, j, term;
    answer := 0;
    for monomialIndex in [1 .. Length(coefficientVector)] do
        if coefficientVector[monomialIndex] <> 0
           and exponentBasis[monomialIndex][variableIndex] > 0 then
            exponent := exponentBasis[monomialIndex];
            term := coefficientVector[monomialIndex]
                * exponent[variableIndex];
            for j in [1 .. 6] do
                if j = variableIndex then
                    if exponent[j] > 1 then
                        term := term * point[j] ^ (exponent[j] - 1);
                    fi;
                elif exponent[j] > 0 then
                    term := term * point[j] ^ exponent[j];
                fi;
            od;
            answer := answer + term;
        fi;
    od;
    return answer;
end;


CF_SNS_PointIsCommonSingularPoint := function(family, point)
    local basisVector, variableIndex;
    for basisVector in family.cubicInvariantBasisVectors do
        for variableIndex in [1 .. 6] do
            if CF_SNS_EvaluateCubicPartialAtPoint(
                basisVector,
                family.cubicMonomialExponents,
                variableIndex,
                point
            ) <> 0 then
                return false;
            fi;
        od;
    od;
    return true;
end;


CF_SNS_FindSmallCommonSingularPointBounded := function(
    family,
    maxSupport,
    maxChecks
)
    local values, checks, found, supportSize, supports, support,
          point, searchTail;
    values := [1, -1, 2, -2, E(3), E(3)^2];
    checks := 0;
    found := fail;
    maxSupport := Minimum(maxSupport, 6);
    for supportSize in [1 .. maxSupport] do
        supports := Combinations([1 .. 6], supportSize);
        for support in supports do
            point := [0, 0, 0, 0, 0, 0];
            point[support[1]] := 1;
            searchTail := function(position)
                local value;
                if found <> fail or checks >= maxChecks then
                    return;
                fi;
                if position > supportSize then
                    checks := checks + 1;
                    if CF_SNS_PointIsCommonSingularPoint(
                        family,
                        point
                    ) then
                        found := ShallowCopy(point);
                    fi;
                    return;
                fi;
                for value in values do
                    point[support[position]] := value;
                    searchTail(position + 1);
                    if found <> fail or checks >= maxChecks then
                        return;
                    fi;
                od;
                point[support[position]] := 0;
            end;
            searchTail(2);
            if found <> fail or checks >= maxChecks then
                break;
            fi;
        od;
        if found <> fail or checks >= maxChecks then
            break;
        fi;
    od;
    return rec(
        point := found,
        checks := checks,
        limitReached := checks >= maxChecks and found = fail
    );
end;


#############################################################################
## Exact characteristic-zero Singular test
#############################################################################

CF_SNS_TrimPolynomialCoefficients := function(coefficients)
    local answer;
    answer := ShallowCopy(coefficients);
    while Length(answer) > 1
          and answer[Length(answer)] = 0 do
        Remove(answer, Length(answer));
    od;
    return answer;
end;


CF_SNS_ExactPolynomialQuotient := function(dividend, divisor)
    local remainder, quotient, shift, factor, i;
    dividend := CF_SNS_TrimPolynomialCoefficients(dividend);
    divisor := CF_SNS_TrimPolynomialCoefficients(divisor);
    if Length(divisor) = 1 and divisor[1] = 0 then
        Error("Polynomial division by zero.");
    fi;
    remainder := ShallowCopy(dividend);
    quotient := List(
        [1 .. Maximum(1, Length(dividend) - Length(divisor) + 1)],
        i -> 0
    );
    while not (Length(remainder) = 1 and remainder[1] = 0)
          and Length(remainder) >= Length(divisor) do
        shift := Length(remainder) - Length(divisor);
        factor := remainder[Length(remainder)]
            / divisor[Length(divisor)];
        quotient[shift + 1] := quotient[shift + 1] + factor;
        for i in [1 .. Length(divisor)] do
            remainder[shift + i] := remainder[shift + i]
                - factor * divisor[i];
        od;
        remainder := CF_SNS_TrimPolynomialCoefficients(remainder);
    od;
    if not (Length(remainder) = 1 and remainder[1] = 0) then
        Error("Expected an exact polynomial quotient.");
    fi;
    return CF_SNS_TrimPolynomialCoefficients(quotient);
end;


CF_SNS_CyclotomicPolynomialCache := [];


CF_SNS_CyclotomicPolynomialCoefficients := function(n)
    local polynomial, properDivisors, d;
    if not IsInt(n) or n < 1 then
        Error("The cyclotomic conductor must be a positive integer.");
    fi;
    if IsBound(CF_SNS_CyclotomicPolynomialCache[n]) then
        return ShallowCopy(CF_SNS_CyclotomicPolynomialCache[n]);
    fi;
    polynomial := Concatenation(
        [-1],
        List([1 .. n - 1], i -> 0),
        [1]
    );
    properDivisors := Filtered(DivisorsInt(n), d -> d < n);
    for d in properDivisors do
        polynomial := CF_SNS_ExactPolynomialQuotient(
            polynomial,
            CF_SNS_CyclotomicPolynomialCoefficients(d)
        );
    od;
    CF_SNS_CyclotomicPolynomialCache[n] := ShallowCopy(polynomial);
    return polynomial;
end;


CF_SNS_PolynomialString := function(coefficients, variableName)
    local terms, i, coefficient, monomial;
    terms := [];
    for i in [1 .. Length(coefficients)] do
        coefficient := coefficients[i];
        if coefficient <> 0 then
            if i = 1 then
                monomial := "1";
            elif i = 2 then
                monomial := variableName;
            else
                monomial := Concatenation(
                    variableName,
                    "^",
                    String(i - 1)
                );
            fi;
            Add(
                terms,
                Concatenation(
                    "(", String(coefficient), ")*", monomial
                )
            );
        fi;
    od;
    if Length(terms) = 0 then
        return "0";
    fi;
    return CF_SNS_JoinStrings(terms, "+");
end;


CF_SNS_CyclotomicCoefficientString := function(coefficient, conductor)
    local coefficients;
    if coefficient = 0 then
        return "0";
    fi;
    if conductor = 1 then
        return String(coefficient);
    fi;
    coefficients := CoeffsCyc(coefficient, conductor);
    return CF_SNS_PolynomialString(coefficients, "a");
end;


CF_SNS_ExactDerivativeString := function(
    coefficientVector,
    exponentBasis,
    variableIndex,
    conductor
)
    local terms, j, exponent, derivativeExponent, coefficient,
          coefficientString, monomial;
    terms := [];
    for j in [1 .. Length(coefficientVector)] do
        exponent := exponentBasis[j];
        if coefficientVector[j] <> 0
           and exponent[variableIndex] > 0 then
            coefficient := coefficientVector[j] * exponent[variableIndex];
            coefficientString := CF_SNS_CyclotomicCoefficientString(
                coefficient,
                conductor
            );
            derivativeExponent := ShallowCopy(exponent);
            derivativeExponent[variableIndex] :=
                derivativeExponent[variableIndex] - 1;
            monomial := CF_SNS_MonomialString(derivativeExponent);
            Add(
                terms,
                Concatenation("(", coefficientString, ")*", monomial)
            );
        fi;
    od;
    if Length(terms) = 0 then
        return "0";
    fi;
    return CF_SNS_JoinStrings(terms, "+");
end;


CF_SNS_ExactRingLines := function(conductor)
    local minpoly;
    if conductor = 1 then
        return [
            "ring r=0,(x1,x2,x3,x4,x5,x6),dp;",
            "option(redSB);"
        ];
    fi;
    minpoly := CF_SNS_PolynomialString(
        CF_SNS_CyclotomicPolynomialCoefficients(conductor),
        "a"
    );
    return [
        "ring r=(0,a),(x1,x2,x3,x4,x5,x6),dp;",
        Concatenation("minpoly=", minpoly, ";"),
        "option(redSB);"
    ];
end;


CF_SNS_ExactMemberSmoothnessScript := function(
    memberVector,
    exponentBasis,
    conductor
)
    local lines, derivatives, variableIndex, chartIndex, prefix;
    lines := CF_SNS_ExactRingLines(conductor);
    derivatives := List(
        [1 .. 6],
        variableIndex -> CF_SNS_ExactDerivativeString(
            memberVector,
            exponentBasis,
            variableIndex,
            conductor
        )
    );
    for variableIndex in [1 .. 6] do
        Add(
            lines,
            Concatenation(
                "poly d", String(variableIndex), "=",
                derivatives[variableIndex], ";"
            )
        );
    od;
    Add(lines, "int cf_singular_chart=0;");
    for chartIndex in [1 .. 6] do
        prefix := Concatenation("c", String(chartIndex), "_");
        Add(lines, "if (cf_singular_chart==0)");
        Add(lines, "{");
        Add(
            lines,
            Concatenation(
                "ideal ", prefix, "J=d1,d2,d3,d4,d5,d6,x",
                String(chartIndex), "-1;"
            )
        );
        Add(
            lines,
            Concatenation("ideal ", prefix, "B=std(", prefix, "J);")
        );
        Add(
            lines,
            Concatenation(
                "poly ", prefix, "n=reduce(1,", prefix, "B);"
            )
        );
        Add(lines, Concatenation("if (", prefix, "n!=0)"));
        Add(lines, "{");
        Add(
            lines,
            Concatenation(
                "print(\"CF_EXACT_SINGULAR_CHART_",
                String(chartIndex), "\");"
            )
        );
        Add(
            lines,
            Concatenation(
                "cf_singular_chart=", String(chartIndex), ";"
            )
        );
        Add(lines, "}");
        Add(lines, "}");
    od;
    Add(lines, "if (cf_singular_chart==0)");
    Add(lines, "{");
    Add(lines, "print(\"CF_EXACT_SMOOTH\");");
    Add(lines, "}");
    Add(lines, "else");
    Add(lines, "{");
    Add(lines, "print(\"CF_EXACT_SINGULAR\");");
    Add(lines, "}");
    Add(lines, "print(\"CF_SCRIPT_COMPLETED_OK\");");
    Add(lines, "quit;");
    return CF_SNS_JoinStrings(lines, "\n");
end;


CF_SNS_FindExactSingularChartInOutput := function(output)
    local i, marker;
    for i in [1 .. 6] do
        marker := Concatenation(
            "CF_EXACT_SINGULAR_CHART_",
            String(i)
        );
        if PositionSublist(output, marker) <> fail then
            return i;
        fi;
    od;
    return fail;
end;


CF_SNS_RunExactMemberTest := function(
    family,
    coefficients,
    tools,
    timeoutSeconds
)
    local conductor, memberVector, script, run, chart;
    if Length(coefficients) <> family.cubicInvariantDimension then
        Error("The exact-test coefficient vector has the wrong length.");
    fi;
    if ForAll(coefficients, x -> x = 0) then
        Error("The zero cubic cannot be tested for smoothness.");
    fi;
    conductor := CF_SNS_FamilyConductor(family);
    memberVector := CF_SNS_LinearCombinationOfVectors(
        family.cubicInvariantBasisVectors,
        coefficients
    );
    script := CF_SNS_ExactMemberSmoothnessScript(
        memberVector,
        family.cubicMonomialExponents,
        conductor
    );
    run := CF_SNS_RunBoundedSingularScript(
        script,
        tools,
        timeoutSeconds
    );
    chart := CF_SNS_FindExactSingularChartInOutput(run.output);
    if run.status = "completed"
       and PositionSublist(run.output, "CF_EXACT_SMOOTH") <> fail then
        run.status := "exact_smooth";
    elif run.status = "completed"
         and PositionSublist(run.output, "CF_EXACT_SINGULAR") <> fail then
        run.status := "exact_singular";
    else
        run.status := "timeout_or_error";
    fi;
    run.coefficients := ShallowCopy(coefficients);
    run.memberVector := ShallowCopy(memberVector);
    run.conductor := conductor;
    run.singularChart := chart;
    return run;
end;


#############################################################################
## Exact common singular locus of the whole invariant space
#############################################################################

# A non-unit chart ideal proves a common point exists over the algebraic
# closure. An empty common locus does not prove a smooth member exists.
CF_SNS_ExactCommonSingularLocusScript := function(family, conductor)
    local lines, derivativeNames, basisIndex, variableIndex,
          derivativeName, derivativeString, chartIndex, prefix;

    lines := CF_SNS_ExactRingLines(conductor);
    derivativeNames := [];
    for basisIndex in [1 .. Length(family.cubicInvariantBasisVectors)] do
        for variableIndex in [1 .. 6] do
            derivativeName := Concatenation(
                "b", String(basisIndex), "d", String(variableIndex)
            );
            derivativeString := CF_SNS_ExactDerivativeString(
                family.cubicInvariantBasisVectors[basisIndex],
                family.cubicMonomialExponents,
                variableIndex,
                conductor
            );
            Add(
                lines,
                Concatenation(
                    "poly ", derivativeName, "=",
                    derivativeString, ";"
                )
            );
            Add(derivativeNames, derivativeName);
        od;
    od;

    Add(lines, "int cf_common_chart=0;");
    for chartIndex in [1 .. 6] do
        prefix := Concatenation("q", String(chartIndex), "_");
        Add(lines, "if (cf_common_chart==0)");
        Add(lines, "{");
        Add(
            lines,
            Concatenation(
                "ideal ", prefix, "J=",
                CF_SNS_JoinStrings(derivativeNames, ","),
                ",x", String(chartIndex), "-1;"
            )
        );
        Add(
            lines,
            Concatenation(
                "ideal ", prefix, "B=std(", prefix, "J);"
            )
        );
        Add(
            lines,
            Concatenation(
                "poly ", prefix, "n=reduce(1,", prefix, "B);"
            )
        );
        Add(lines, Concatenation("if (", prefix, "n!=0)"));
        Add(lines, "{");
        Add(
            lines,
            Concatenation(
                "print(\"CF_EXACT_COMMON_SINGULAR_CHART_",
                String(chartIndex), "\");"
            )
        );
        Add(
            lines,
            Concatenation(
                "cf_common_chart=", String(chartIndex), ";"
            )
        );
        Add(lines, "}");
        Add(lines, "}");
    od;

    Add(lines, "if (cf_common_chart==0)");
    Add(lines, "{");
    Add(lines, "print(\"CF_NO_COMMON_SINGULAR_POINT\");");
    Add(lines, "}");
    Add(lines, "else");
    Add(lines, "{");
    Add(lines, "print(\"CF_EXACT_COMMON_SINGULAR_POINT\");");
    Add(lines, "}");
    Add(lines, "print(\"CF_SCRIPT_COMPLETED_OK\");");
    Add(lines, "quit;");
    return CF_SNS_JoinStrings(lines, "\n");
end;


CF_SNS_FindExactCommonSingularChartInOutput := function(output)
    local chartIndex, marker;

    for chartIndex in [1 .. 6] do
        marker := Concatenation(
            "CF_EXACT_COMMON_SINGULAR_CHART_",
            String(chartIndex)
        );
        if PositionSublist(output, marker) <> fail then
            return chartIndex;
        fi;
    od;
    return fail;
end;


CF_SNS_RunExactCommonSingularLocusTest := function(
    family,
    tools,
    timeoutSeconds
)
    local conductor, script, run, chart;

    conductor := CF_SNS_FamilyConductor(family);
    script := CF_SNS_ExactCommonSingularLocusScript(
        family,
        conductor
    );
    run := CF_SNS_RunBoundedSingularScript(
        script,
        tools,
        timeoutSeconds
    );
    chart := fail;
    if run.status = "completed"
       and PositionSublist(
            run.output,
            "CF_EXACT_COMMON_SINGULAR_POINT"
       ) <> fail then
        run.status := "common_singular_point_exists";
        chart := CF_SNS_FindExactCommonSingularChartInOutput(
            run.output
        );
    elif run.status = "completed"
         and PositionSublist(
              run.output,
              "CF_NO_COMMON_SINGULAR_POINT"
         ) <> fail then
        run.status := "no_common_singular_point";
    else
        run.status := "timeout_or_error";
    fi;
    run.conductor := conductor;
    run.singularChart := chart;
    return run;
end;


#############################################################################
## Deterministic characteristic-zero smooth-member verification
#############################################################################

CF_SMOOTH_AddUniqueVector := function(vectors, vector)
    if Position(vectors, vector) = fail then
        Add(vectors, ShallowCopy(vector));
    fi;
end;


CF_SMOOTH_DeterministicCoefficientVectors := function(dimension, maximum)
    local vectors, i, vector, scale;

    if not IsInt(dimension) or dimension < 1 then
        Error("The invariant-space dimension must be positive.");
    fi;
    if not IsInt(maximum) or maximum < 1 then
        Error("The maximum number of coefficient vectors must be positive.");
    fi;

    vectors := [];
    CF_SMOOTH_AddUniqueVector(
        vectors,
        List([1 .. dimension], i -> i^2 + 1)
    );
    CF_SMOOTH_AddUniqueVector(vectors, List([1 .. dimension], i -> 1));
    CF_SMOOTH_AddUniqueVector(vectors, [1 .. dimension]);
    CF_SMOOTH_AddUniqueVector(
        vectors,
        List([1 .. dimension], i -> (-1)^i * (i^2 + 1))
    );

    scale := 2;
    while Length(vectors) < maximum do
        vector := List(
            [1 .. dimension],
            i -> ((i + scale)^2 + scale) * (-1)^(i * scale)
        );
        CF_SMOOTH_AddUniqueVector(vectors, vector);
        scale := scale + 1;
    od;

    if Length(vectors) > maximum then
        vectors := vectors{[1 .. maximum]};
    fi;
    return vectors;
end;


CF_SMOOTH_CompactExactTrial := function(trial)
    return rec(
        coefficients := ShallowCopy(trial.coefficients),
        status := trial.status,
        exitCode := trial.exitCode,
        singularChart := trial.singularChart
    );
end;


CF_SMOOTH_FindExactSmoothMember := function(
    family,
    tools,
    maximumTrials,
    timeoutSeconds
)
    local coefficientVectors, trials, coefficients, trial, memberVector;

    if not IsBound(family.cubicInvariantDimension)
       or not IsBound(family.cubicInvariantBasisVectors)
       or not IsBound(family.cubicMonomialExponents) then
        Error("The smoothness candidate has incomplete cubic-basis data.");
    fi;
    if Length(family.cubicInvariantBasisVectors)
       <> family.cubicInvariantDimension then
        Error("The invariant-basis dimension is inconsistent.");
    fi;
    if tools.singular = fail or tools.timeout = fail then
        return rec(
            status := "unknown",
            proofType := "Singular or GNU timeout is unavailable",
            trials := []
        );
    fi;

    coefficientVectors := CF_SMOOTH_DeterministicCoefficientVectors(
        family.cubicInvariantDimension,
        maximumTrials
    );
    trials := [];
    for coefficients in coefficientVectors do
        trial := CF_SNS_RunExactMemberTest(
            family,
            coefficients,
            tools,
            timeoutSeconds
        );
        Add(trials, CF_SMOOTH_CompactExactTrial(trial));
        if trial.status = "exact_smooth" then
            memberVector := CF_SNS_LinearCombinationOfVectors(
                family.cubicInvariantBasisVectors,
                coefficients
            );
            return rec(
                status := "smooth",
                proofType :=
                    "an explicit member has empty projective Jacobian locus",
                coefficients := ShallowCopy(coefficients),
                polynomial :=
                    CF_SNS_CoefficientVectorToPolynomialString(
                        memberVector,
                        family.cubicMonomialExponents
                    ),
                trials := trials
            );
        fi;
    od;

    return rec(
        status := "unknown",
        proofType :=
            "no explicit smooth member was certified in the deterministic batch",
        trials := trials
    );
end;
