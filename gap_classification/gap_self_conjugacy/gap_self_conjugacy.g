#############################################################################
## Exact self-conjugacy audit for the final 156 cubic-fourfold families.
##
## The final catalogue is recovered from the survivor keys in the completed
## equal-dimensional saturation audit.  The following families are recorded
## as theoretical exemptions and are not recomputed here:
##
##   * connected symplectic families;
##   * families with rank(S) at least 19;
##   * families whose projective group order is divisible by 7;
##   * families with symplectic part 3^{1+4}:2.
##
## Every other family is checked by an exact linear conjugacy certificate and
## an exact identification of its invariant cubic space with its
## coefficientwise complex conjugate.
#############################################################################

CF_SCB_Paths := function()
    if IsExistingFile("gap_self_conjugacy.g") then
        return rec(
            selfDirectory := "",
            saturationDirectory := "../gap_saturation/"
        );
    fi;
    if IsExistingFile(
        "gap_classification/gap_self_conjugacy/gap_self_conjugacy.g"
    ) then
        return rec(
            selfDirectory := "gap_classification/gap_self_conjugacy/",
            saturationDirectory := "gap_classification/gap_saturation/"
        );
    fi;
    if IsExistingFile("gap_self_conjugacy/gap_self_conjugacy.g") then
        return rec(
            selfDirectory := "gap_self_conjugacy/",
            saturationDirectory := "gap_saturation/"
        );
    fi;
    Error(
        "Run from the repository root, gap_classification, or ",
        "gap_classification/gap_self_conjugacy."
    );
end;


CF_SCB_PathRecord := CF_SCB_Paths();

if not IsBound(CF_SC_TestFamilySelfConjugacy) then
    Read(Concatenation(
        CF_SCB_PathRecord.selfDirectory,
        "gap_self_conjugacy_functions.g"
    ));
fi;
if not IsBound(SaturationInputCandidates) then
    Read(Concatenation(
        CF_SCB_PathRecord.saturationDirectory,
        "gap_saturation_input.g"
    ));
fi;
if not IsBound(EqualDimensionSaturationAudit) then
    Read(Concatenation(
        CF_SCB_PathRecord.saturationDirectory,
        "gap_equal_dimension_saturation.out"
    ));
fi;


if not IsBound(CF_SCB_PRINT_PROGRESS) then
    CF_SCB_PRINT_PROGRESS := true;
fi;
if not IsBound(CF_SCB_LOG_FILE) then
    CF_SCB_LOG_FILE := Concatenation(
        CF_SCB_PathRecord.selfDirectory,
        "gap_self_conjugacy.log"
    );
fi;
if not IsBound(CF_SCB_OUTPUT_FILE) then
    CF_SCB_OUTPUT_FILE := Concatenation(
        CF_SCB_PathRecord.selfDirectory,
        "gap_self_conjugacy.out"
    );
fi;
if not IsBound(CF_SCB_MARKDOWN_FILE) then
    CF_SCB_MARKDOWN_FILE := Concatenation(
        CF_SCB_PathRecord.selfDirectory,
        "gap_self_conjugacy.md"
    );
fi;


CF_SCB_Log := function(arg)
    local item;
    for item in arg do
        if CF_SCB_PRINT_PROGRESS then
            Print(item);
        fi;
        AppendTo(CF_SCB_LOG_FILE, item);
    od;
end;


CF_SCB_RecordValue := function(record, name, default)
    if name in RecNames(record) then
        return record.(name);
    fi;
    return default;
end;


CF_SCB_FinalCandidates := function()
    local keys, candidates, key, candidate;

    if EqualDimensionSaturationAudit.status <> "completed"
       or EqualDimensionSaturationAudit.survivorCount <> 156 then
        Error("A completed 156-family saturation audit is required.");
    fi;

    keys := EqualDimensionSaturationAudit.survivorKeys;
    if Length(keys) <> 156 or Length(Set(keys)) <> 156 then
        Error("The final survivor-key list is not a set of size 156.");
    fi;

    candidates := [];
    for key in keys do
        candidate := First(
            SaturationInputCandidates,
            record -> record.sourceKey = key
        );
        if candidate = fail then
            Error("Cannot recover final family: ", key, ".");
        fi;
        Add(candidates, candidate);
    od;
    return candidates;
end;


CF_SCB_ExemptionData := function(candidate)
    local reasons, symplectic, highRank, sevenDivisible,
          threePowerFamily;

    symplectic := candidate.isSymplecticFamily = true;
    highRank := IsInt(candidate.rankS) and candidate.rankS >= 19;
    sevenDivisible :=
        IsList(candidate.projectiveGroupId)
        and Length(candidate.projectiveGroupId) >= 1
        and IsInt(candidate.projectiveGroupId[1])
        and candidate.projectiveGroupId[1] mod 7 = 0;
    threePowerFamily := candidate.symplecticPart = "3^{1+4}:2";

    reasons := [];
    if symplectic then
        Add(reasons, "connected symplectic family");
    fi;
    if highRank then
        Add(reasons, "rank(S) at least 19");
    fi;
    if sevenDivisible then
        Add(reasons, "projective group order divisible by 7");
    fi;
    if threePowerFamily then
        Add(reasons, "symplectic part 3^{1+4}:2");
    fi;

    return rec(
        exempt := Length(reasons) > 0,
        reasons := reasons,
        isSymplecticFamily := symplectic,
        isHighRank := highRank,
        isSevenDivisible := sevenDivisible,
        isThreePowerFamily := threePowerFamily
    );
end;


CF_SCB_StoredInvariantDimension := function(candidate)
    if IsBound(candidate.cubicInvariantBasisStrings)
       and IsList(candidate.cubicInvariantBasisStrings) then
        return Length(candidate.cubicInvariantBasisStrings);
    fi;
    return fail;
end;


CF_SCB_ExemptResult := function(position, candidate, exemption)
    return rec(
        cataloguePosition := position,
        sourceKey := candidate.sourceKey,
        sourceCategory := candidate.sourceCategory,
        symplecticPart := candidate.symplecticPart,
        rankS := candidate.rankS,
        projectiveGroupId := candidate.projectiveGroupId,
        linearGroupId := candidate.linearGroupId,
        fullIndex := candidate.fullIndex,
        familyDimension := candidate.familyDimension,
        status := "self_conjugate_by_theory",
        verificationKind := "theoretical_exemption",
        exemptionReasons := exemption.reasons,
        invariantDimension := CF_SCB_StoredInvariantDimension(candidate),
        invariantDimensionVerified := fail,
        groupOrder := candidate.linearGroupId[1],
        proofType := "theoretical exemption requested for this catalogue",
        witnessVerified := fail,
        cubicSpaceVerified := fail,
        conjugatingMatrix := fail,
        generatorImages := fail,
        cubicBasisMap := fail,
        runtimeMilliseconds := 0
    );
end;


CF_SCB_CheckedResult := function(position, candidate)
    local startTime, cubic, storedInvariantDimension, dimensionVerified,
          certificate, successful;

    startTime := Runtime();
    cubic := CF_CubicInvariantBasis(
        candidate.matrixGenerators,
        rec(
            buildPolynomialObjects := false,
            buildStrings := false
        )
    );
    storedInvariantDimension := CF_SCB_StoredInvariantDimension(candidate);
    dimensionVerified :=
        storedInvariantDimension <> fail
        and storedInvariantDimension = cubic.invariantDimension;
    if not dimensionVerified then
        return rec(
            cataloguePosition := position,
            sourceKey := candidate.sourceKey,
            sourceCategory := candidate.sourceCategory,
            symplecticPart := candidate.symplecticPart,
            rankS := candidate.rankS,
            projectiveGroupId := candidate.projectiveGroupId,
            linearGroupId := candidate.linearGroupId,
            fullIndex := candidate.fullIndex,
            familyDimension := candidate.familyDimension,
            status := "invariant_dimension_mismatch",
            verificationKind := "exact_computation",
            exemptionReasons := [],
            invariantDimension := cubic.invariantDimension,
            storedInvariantDimension := storedInvariantDimension,
            invariantDimensionVerified := false,
            groupOrder := fail,
            proofType := "stored and recomputed invariant dimensions disagree",
            witnessVerified := false,
            cubicSpaceVerified := false,
            conjugatingMatrix := fail,
            generatorImages := fail,
            cubicBasisMap := fail,
            runtimeMilliseconds := Runtime() - startTime
        );
    fi;

    certificate := CF_SC_TestFamilySelfConjugacy(
        candidate.matrixGenerators,
        cubic.coefficientBasis,
        cubic.monomialExponents,
        rec(
            trySetwiseEqualityFirst := true,
            maximumAutomorphisms := infinity,
            progressInterval := 0,
            printProgress := false
        )
    );
    successful :=
        certificate.status = "self_conjugate"
        and certificate.witnessVerified = true
        and certificate.cubicSpaceVerified = true
        and certificate.groupOrder = candidate.linearGroupId[1];

    return rec(
        cataloguePosition := position,
        sourceKey := candidate.sourceKey,
        sourceCategory := candidate.sourceCategory,
        symplecticPart := candidate.symplecticPart,
        rankS := candidate.rankS,
        projectiveGroupId := candidate.projectiveGroupId,
        linearGroupId := candidate.linearGroupId,
        fullIndex := candidate.fullIndex,
        familyDimension := candidate.familyDimension,
        status := certificate.status,
        verificationKind := "exact_matrix_and_cubic_space",
        exemptionReasons := [],
        invariantDimension := cubic.invariantDimension,
        storedInvariantDimension := storedInvariantDimension,
        invariantDimensionVerified := dimensionVerified,
        groupOrder := certificate.groupOrder,
        groupOrderVerified :=
            certificate.groupOrder = candidate.linearGroupId[1],
        proofType := certificate.proofType,
        witnessVerified := certificate.witnessVerified,
        cubicSpaceVerified := certificate.cubicSpaceVerified,
        exactVerificationPassed := successful,
        automorphismsTested := CF_SCB_RecordValue(
            certificate,
            "automorphismsTested",
            fail
        ),
        scalarCompatibleAutomorphisms := CF_SCB_RecordValue(
            certificate,
            "scalarCompatibleAutomorphisms",
            fail
        ),
        characterCompatibleAutomorphisms := CF_SCB_RecordValue(
            certificate,
            "characterCompatibleAutomorphisms",
            fail
        ),
        conjugatingMatrix := CF_SCB_RecordValue(
            certificate,
            "conjugatingMatrix",
            fail
        ),
        generatorImages := CF_SCB_RecordValue(
            certificate,
            "generatorImages",
            fail
        ),
        cubicBasisMap := CF_SCB_RecordValue(
            certificate.cubicSpaceCertificate,
            "basisMap",
            fail
        ),
        runtimeMilliseconds := Runtime() - startTime
    );
end;


CF_SCB_IsAccepted := function(result)
    return result.status = "self_conjugate_by_theory"
           or (result.status = "self_conjugate"
               and result.witnessVerified = true
               and result.cubicSpaceVerified = true
               and result.invariantDimensionVerified = true
               and result.groupOrderVerified = true);
end;


CF_SCB_WriteMarkdown := function(audit)
    local stream, result, reason;

    stream := OutputTextFile(CF_SCB_MARKDOWN_FILE, false);
    SetPrintFormattingStatus(stream, false);
    AppendTo(
        stream,
        "# Self-conjugacy of the final families\n\n",
        "The input is the set of 156 survivors in the completed equal-",
        "dimensional saturation audit. Connected symplectic families, rank-",
        "at-least-19 families, families of projective order divisible by 7, ",
        "and families with symplectic part `3^{1+4}:2` are recorded as ",
        "theoretical exemptions. Every other family is verified with exact ",
        "cyclotomic arithmetic, an explicit linear conjugating matrix, and ",
        "the induced invertible map on the invariant cubic space.\n\n",
        "## Summary\n\n",
        "- final families: **", String(audit.totalCount), "**\n",
        "- theoretical exemptions: **", String(audit.exemptCount), "**\n",
        "- exact computations: **", String(audit.checkedCount), "**\n",
        "- exact computations passed: **", String(audit.exactPassedCount),
        "**\n",
        "- accepted as self-conjugate: **", String(audit.acceptedCount),
        "**\n",
        "- overall result: **", String(audit.allSelfConjugate), "**\n\n",
        "The four exemption counts below overlap.\n\n",
        "| exemption | count |\n",
        "|---|---:|\n",
        "| connected symplectic family | ",
        String(audit.symplecticExemptCount), " |\n",
        "| rank(S) at least 19 | ",
        String(audit.highRankExemptCount), " |\n",
        "| projective order divisible by 7 | ",
        String(audit.sevenDivisibleExemptCount), " |\n",
        "| symplectic part `3^{1+4}:2` | ",
        String(audit.threePowerFamilyExemptCount), " |\n\n",
        "## Family audit\n\n",
        "| run no. | source key | PGL ID | dimension | status | method |\n",
        "|---:|---|---|---:|---|---|\n"
    );

    for result in audit.familyResults do
        if result.verificationKind = "theoretical_exemption" then
            reason := CF_JoinStrings(result.exemptionReasons, "; ");
        else
            reason := result.proofType;
        fi;
        AppendTo(
            stream,
            "| ", String(result.cataloguePosition),
            " | `", result.sourceKey,
            "` | `", String(result.projectiveGroupId),
            "` | ", String(result.familyDimension),
            " | `", result.status,
            "` | ", reason, " |\n"
        );
    od;
    CloseStream(stream);
end;


CF_SCB_Run := function()
    local candidates, results, startTime, position, candidate,
          exemption, result, audit, failures;

    candidates := CF_SCB_FinalCandidates();
    results := [];
    startTime := Runtime();

    PrintTo(CF_SCB_LOG_FILE, "");
    PrintTo(
        CF_SCB_OUTPUT_FILE,
        "SelfConjugacyAudit := rec(status := \"running\", ",
        "inputCount := 156);\n"
    );
    CF_SCB_Log(
        "============================================================\n",
        "Self-conjugacy audit for the final 156 families\n",
        "============================================================\n"
    );

    for position in [1 .. Length(candidates)] do
        candidate := candidates[position];
        exemption := CF_SCB_ExemptionData(candidate);
        CF_SCB_Log(
            String(position), "/", String(Length(candidates)), " ",
            candidate.sourceKey, ": started\n"
        );
        if exemption.exempt then
            result := CF_SCB_ExemptResult(
                position,
                candidate,
                exemption
            );
            CF_SCB_Log(
                "    theoretical exemption: ",
                CF_JoinStrings(exemption.reasons, "; "), "\n"
            );
        else
            result := CF_SCB_CheckedResult(position, candidate);
            CF_SCB_Log(
                "    status=", result.status,
                "; proof=", result.proofType,
                "; runtime=", String(result.runtimeMilliseconds), " ms\n"
            );
        fi;
        Add(results, result);
    od;

    audit := rec(
        schemaVersion := 1,
        status := "completed",
        scope := "the 156 survivors of equal-dimensional saturation",
        totalCount := Length(results),
        exemptCount := Number(
            results,
            item -> item.verificationKind = "theoretical_exemption"
        ),
        checkedCount := Number(
            results,
            item -> item.verificationKind =
                "exact_matrix_and_cubic_space"
        ),
        exactPassedCount := Number(
            results,
            item -> item.verificationKind =
                    "exact_matrix_and_cubic_space"
                    and CF_SCB_IsAccepted(item)
        ),
        acceptedCount := Number(results, CF_SCB_IsAccepted),
        symplecticExemptCount := Number(
            candidates,
            item -> CF_SCB_ExemptionData(item).isSymplecticFamily
        ),
        highRankExemptCount := Number(
            candidates,
            item -> CF_SCB_ExemptionData(item).isHighRank
        ),
        sevenDivisibleExemptCount := Number(
            candidates,
            item -> CF_SCB_ExemptionData(item).isSevenDivisible
        ),
        threePowerFamilyExemptCount := Number(
            candidates,
            item -> CF_SCB_ExemptionData(item).isThreePowerFamily
        ),
        allSelfConjugate := ForAll(results, CF_SCB_IsAccepted),
        runtimeMilliseconds := Runtime() - startTime,
        familyResults := results
    );
    failures := Filtered(results, item -> not CF_SCB_IsAccepted(item));

    if audit.totalCount <> 156
       or audit.exemptCount + audit.checkedCount <> 156 then
        Error("The self-conjugacy coverage audit failed.");
    fi;
    if Length(failures) > 0 then
        audit.status := "completed_with_failures";
    fi;

    PrintTo(
        CF_SCB_OUTPUT_FILE,
        "SelfConjugacyAudit := ", audit, ";\n"
    );
    CF_SCB_WriteMarkdown(audit);
    CF_SCB_Log(
        "\n============================================================\n",
        "Self-conjugacy audit completed\n",
        "============================================================\n",
        "Theoretical exemptions: ", String(audit.exemptCount), "\n",
        "Exact computations: ", String(audit.checkedCount), "\n",
        "Exact computations passed: ",
        String(audit.exactPassedCount), "\n",
        "Accepted total: ", String(audit.acceptedCount), "/156\n",
        "Runtime: ", String(audit.runtimeMilliseconds), " ms\n",
        "Output: ", CF_SCB_OUTPUT_FILE, "\n",
        "Markdown: ", CF_SCB_MARKDOWN_FILE, "\n"
    );

    if Length(failures) > 0 then
        Error(
            "Self-conjugacy failed or remained unknown for ",
            Length(failures), " final families."
        );
    fi;
    return audit;
end;


SelfConjugacyAudit := CF_SCB_Run();
