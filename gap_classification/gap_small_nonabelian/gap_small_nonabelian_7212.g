#############################################################################
##
## gap_small_nonabelian_7212.g
##
## Isolated enumeration of the projective group SmallGroup(72,12) in the
## two C3-symplectic components.  This file deliberately writes to its own
## output files and does not alter the canonical small-nonabelian data.
## Run it from the gap_small_nonabelian directory.
##
#############################################################################

CF_SN_AUTO_RUN := false;;
CF_SN_SHOW_PROGRESS := true;;
CF_SN_ENGINE_DETAILS := false;;
CF_SN_SHOW_GENERIC_FILTER_PROGRESS := false;;
CF_SN_APPLY_GONZALEZ := true;;
CF_SN_OUTPUT_FILE := "gap_small_nonabelian_7212.out";;
CF_SN_LOG_FILE := "gap_small_nonabelian_7212.log";;
CF_SN_DATA_FILE := "gap_small_nonabelian_7212_data.g";;
if not IsBoundGlobal("CF_7212_AUTO_RUN") then
    CF_7212_AUTO_RUN := true;;
fi;

Read("gap_small_nonabelian.g");


#############################################################################
## 1. Restrict the common engine to the omitted YYZ candidate [72,12]
#############################################################################

CF_7212_ProjectiveGId := [72, 12];;
CF_7212_OriginalYYZNonabelianFullGroupIds :=
    CF_SN_YYZNonabelianFullGroupIds;;

CF_SN_YYZNonabelianFullGroupIds := function(symplecticPart)
    if symplecticPart = "C3" then
        return [ShallowCopy(CF_7212_ProjectiveGId)];
    fi;
    return CF_7212_OriginalYYZNonabelianFullGroupIds(symplecticPart);
end;;


#############################################################################
## 2. Gonzalez audit without the unrelated direct S3 x C24 check
#############################################################################

CF_7212_AttachGonzalezAudits := function(candidates, applyRestriction)
    local filtered, audited, kept, rejected, i, candidate, audit;

    audited := [];
    kept := [];
    rejected := [];

    if applyRestriction then
        filtered := CF_SN_FilterCandidatesByGonzalezRestriction(candidates);
        for i in [1 .. Length(candidates)] do
            candidate := ShallowCopy(candidates[i]);
            audit := filtered.audits[i];
            candidate.gonzalezRestrictionApplied := true;
            candidate.gonzalezPassed := audit.ok;
            candidate.gonzalezStatus :=
                audit.gonzalezPrimeOrderRestriction.status;
            candidate.gonzalezAudit :=
                audit.gonzalezPrimeOrderRestriction;
            Add(audited, candidate);
            if candidate.gonzalezPassed then
                Add(kept, candidate);
            else
                Add(rejected, candidate);
            fi;
        od;
    else
        filtered := fail;
        for candidate in candidates do
            candidate := ShallowCopy(candidate);
            candidate.gonzalezRestrictionApplied := false;
            candidate.gonzalezPassed := true;
            candidate.gonzalezStatus := "not_applied";
            candidate.gonzalezAudit := fail;
            Add(audited, candidate);
            Add(kept, candidate);
        od;
    fi;

    return rec(
        applied := applyRestriction,
        sharedFilterResult := filtered,
        audited := audited,
        kept := kept,
        rejected := rejected,
        orderPreserved := true
    );
end;;


#############################################################################
## 3. Targeted run
#############################################################################

CF_7212_Run := function()
    local configuration, specification, run, rawCandidates, gonzalez,
          sourceRecord, result, summary;

    CF_SN_RunStartMilliseconds := Runtime();
    CF_SN_ProgressCounter := 0;
    PrintTo(
        CF_SN_LOG_FILE,
        "Targeted SmallGroup(72,12) calculation\n\n",
        "GAP version: ", GAPInfo.Version, "\n",
        "Symplectic part: C3\n",
        "Projective group ID: ", CF_7212_ProjectiveGId, "\n",
        "Gonzalez restriction: ", CF_SN_APPLY_GONZALEZ, "\n\n",
        "Progress\n"
    );

    configuration := CF_SN_C3Configuration();
    if Length(configuration.components) <> 2 then
        Error("The C3 configuration no longer has exactly two components.");
    fi;
    if not ForAll(
        configuration.components,
        component -> component.gids = [CF_7212_ProjectiveGId]
    ) then
        Error("The target [72,12] is not present in both C3 components.");
    fi;

    specification := rec(
        key := "C3-[72,12]",
        configuration := configuration,
        useSpecialS3Runner := false
    );

    CF_SN_Progress("C3, projective group [72,12]: started");
    run := CF_SN_RunS1S2S3Configuration(configuration);
    rawCandidates := [];
    CF_SN_CollectCandidatesFromRun(
        rawCandidates,
        specification,
        run
    );
    CF_SN_Progress(
        "C3, projective group [72,12]: enumeration completed; families ",
        Length(rawCandidates)
    );

    gonzalez := CF_7212_AttachGonzalezAudits(
        rawCandidates,
        CF_SN_APPLY_GONZALEZ
    );
    summary := CF_SN_CaseRunSummary(specification, run);
    sourceRecord := ShallowCopy(CF_SN_ArchiveSourceRecord);
    sourceRecord.excludedProjectiveCandidate := fail;
    sourceRecord.targetProjectiveCandidate :=
        ShallowCopy(CF_7212_ProjectiveGId);
    sourceRecord.caseOrder := ["C3-[72,12]"];

    result := rec(
        sourceRecord := sourceRecord,
        runs := [rec(key := specification.key, result := run)],
        caseSummaries := [summary],
        rawCandidates := rawCandidates,
        auditedCandidates := gonzalez.audited,
        candidates := gonzalez.kept,
        rejectedCandidates := gonzalez.rejected,
        gonzalez := gonzalez,
        numberOfEnumeratedCandidates := Length(rawCandidates),
        numberOfDirectKnownCandidates := 0,
        numberOfRawCandidates := Length(rawCandidates),
        numberOfCandidates := Length(gonzalez.kept),
        numberOfRejectedCandidates := Length(gonzalez.rejected),
        orderPreserved := true,
        smoothnessTestApplied := false,
        runtimeMilliseconds := Runtime() - CF_SN_RunStartMilliseconds
    );

    CF_SN_WriteHumanOutput(CF_SN_OUTPUT_FILE, result);
    CF_SN_WriteMachineData(CF_SN_DATA_FILE, result);
    AppendTo(
        CF_SN_LOG_FILE,
        "\nSummary\n",
        "Enumerated component-group inputs: ", Length(run.cases), "\n",
        "Raw candidates: ", result.numberOfRawCandidates, "\n",
        "Retained after Gonzalez: ", result.numberOfCandidates, "\n",
        "Rejected after Gonzalez: ", result.numberOfRejectedCandidates, "\n",
        "Runtime: ", result.runtimeMilliseconds, " ms\n"
    );
    return result;
end;;


if CF_7212_AUTO_RUN then
    CF_7212_Result := CF_7212_Run();;
    CF_7212_Candidates := CF_7212_Result.candidates;;

    Print(
        "TARGET_7212_COMPLETED raw=", CF_7212_Result.numberOfRawCandidates,
        " retained=", CF_7212_Result.numberOfCandidates,
        " rejected=", CF_7212_Result.numberOfRejectedCandidates,
        " runtime_ms=", CF_7212_Result.runtimeMilliseconds, "\n"
    );
fi;
