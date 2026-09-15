#############################################################################
##
## gap_small_nonabelian.g
##
## Entry point for the liftable small non-abelian candidate calculation.
##
## The audited liftable engine is used without changing its extension,
## representation, or internal deduplication logic.  The case wrappers apply
## the generic-index divisibility condition and, before cubic invariants are
## computed, the required strict GL(6)-conjugacy containment of the generic
## full group.  This file then collects the surviving families, applies the
## common Gonzalez--Aguilera--Liendo necessary restriction, and writes the
## data, log, and readable output documented in README.md.  Smoothness testing
## is not run here.  Liftable includes nonzero
## Ext^1 classes; it does not assert F-liftability of the projective action.
## Run this entry point from its module directory.
##
#############################################################################

if LoadPackage("smallgrp") = fail then
    Error("The GAP package smallgrp is required.");
fi;
if LoadPackage("cohomolo") = fail then
    Error("The GAP package cohomolo is required.");
fi;


#############################################################################
## 1. Run options
#############################################################################

if not IsBoundGlobal("CF_SN_SHOW_PROGRESS") then
    CF_SN_SHOW_PROGRESS := true;
fi;
if not IsBoundGlobal("CF_SN_ENGINE_DETAILS") then
    CF_SN_ENGINE_DETAILS := false;
fi;
if not IsBoundGlobal("CF_SN_SHOW_GENERIC_FILTER_PROGRESS") then
    CF_SN_SHOW_GENERIC_FILTER_PROGRESS := false;
fi;
if not IsBoundGlobal("CF_SN_AUTO_RUN") then
    CF_SN_AUTO_RUN := true;
fi;
if not IsBoundGlobal("CF_SN_APPLY_GONZALEZ") then
    CF_SN_APPLY_GONZALEZ := true;
fi;
if not IsBoundGlobal("CF_SN_OUTPUT_FILE") then
    CF_SN_OUTPUT_FILE := "gap_small_nonabelian.out";
fi;
if not IsBoundGlobal("CF_SN_LOG_FILE") then
    CF_SN_LOG_FILE := "gap_small_nonabelian.log";
fi;
if not IsBoundGlobal("CF_SN_DATA_FILE") then
    CF_SN_DATA_FILE := "gap_small_nonabelian_data.g";
fi;

CF_SN_ArchiveSourceRecord := rec(
    engineFile := "gap_small_nonabelian_liftable_engine.g",
    sharedFunctionsFile := "gap_small_nonabelian_functions.g",
    projectiveCandidateSource :=
        "../../gap_yyz_bounds/gap_yyz_bounds.md",
    excludedProjectiveCandidate := [72, 12],
    caseFiles := [
        "gap_small_nonabelian_c3.g",
        "gap_small_nonabelian_c2_2.g",
        "gap_small_nonabelian_c4.g",
        "gap_small_nonabelian_s3.g"
    ],
    caseOrder := ["C3", "C2^2", "C4", "S3"],
    genericIndexDivisibilityFilter := true,
    genericFullLinearContainmentFilter := true,
    laterStages :=
        "generic-index and generic-full-group filters, then Gonzalez; smoothness is not tested in this file"
);


#############################################################################
## 2. Load order
#############################################################################

if not IsBound(CF_CheckSmallGroupId) then
    Read("../gap_functions.g");
fi;
if not IsBound(CF_SN_ValidateCaseConfiguration)
   or not IsBound(CF_SN_YYZNonabelianFullGroupIds) then
    Read("gap_small_nonabelian_functions.g");
fi;

# Load the engine before the S3 file so that the exact [72,27] patch is
# installed over the corresponding engine definitions.
if not IsBoundGlobal("S_1")
   and not IsBoundGlobal("S_2")
   and not IsBoundGlobal("S_3") then
    Read("gap_small_nonabelian_liftable_engine.g");
elif not IsBoundGlobal("S_1")
     or not IsBoundGlobal("S_2")
     or not IsBoundGlobal("S_3") then
    Error("Only part of the audited liftable engine is loaded.");
fi;

if not IsBound(CF_SN_C3Configuration) then
    Read("gap_small_nonabelian_c3.g");
fi;
if not IsBound(CF_SN_C2_2Configuration) then
    Read("gap_small_nonabelian_c2_2.g");
fi;
if not IsBound(CF_SN_C4Configuration) then
    Read("gap_small_nonabelian_c4.g");
fi;
if not IsBoundGlobal("CF_SN_S3SpecialPatchInstalled")
   or ValueGlobal("CF_SN_S3SpecialPatchInstalled") <> true
   or not IsBound(CF_SN_S3Configuration) then
    Read("gap_small_nonabelian_s3.g");
fi;

# The standard run uses only the concise numbered stream.  A diagnostic
# launcher may retain the audited engine's internal progress messages.
CF_S_PRINT_ENABLED := CF_SN_ENGINE_DETAILS;


#############################################################################
## 3. Progress log
#############################################################################

CF_SN_RunStartMilliseconds := Runtime();
CF_SN_ProgressCounter := 0;

CF_SN_Progress := function(arg)
    local item, elapsed;

    CF_SN_ProgressCounter := CF_SN_ProgressCounter + 1;
    elapsed := Runtime() - CF_SN_RunStartMilliseconds;

    if CF_SN_SHOW_PROGRESS then
        Print(CF_SN_ProgressCounter, ". ");
        for item in arg do
            Print(item);
        od;
        Print("; elapsed ", elapsed, " ms\n");
    fi;

    AppendTo(CF_SN_LOG_FILE, CF_SN_ProgressCounter, ". ");
    for item in arg do
        AppendTo(CF_SN_LOG_FILE, item);
    od;
    AppendTo(CF_SN_LOG_FILE, "; elapsed ", elapsed, " ms\n");
end;


if CF_SN_SHOW_GENERIC_FILTER_PROGRESS then
    CF_SN_GENERIC_FILTER_PROGRESS_HOOK := function(event)
        if event.event = "start" then
            CF_SN_Progress(
                "strict containment candidate ", event.position,
                "/", event.total,
                ", linear group ", event.HId,
                ", determinant index ", event.determinantImageOrder,
                ": started"
            );
        elif event.event = "preprocessed" then
            CF_SN_Progress(
                "strict containment candidate ", event.position,
                "/", event.total,
                ", linear group ", event.HId,
                ": matrix group prepared; candidate time ",
                event.candidateElapsedMilliseconds, " ms"
            );
        elif event.event = "complete" then
            CF_SN_Progress(
                "strict containment candidate ", event.position,
                "/", event.total,
                ", linear group ", event.HId,
                ": ", event.status,
                " (", event.reason, "); candidate time ",
                event.candidateElapsedMilliseconds, " ms"
            );
        else
            Error("Unknown generic-full-group progress event.");
        fi;
    end;
fi;


CF_SN_CASE_PROGRESS_HOOK := function(event)
    if event.event = "start" then
        CF_SN_Progress(
            event.symplecticPart,
            ", component ", event.componentIndex,
            ", projective group ", event.gid,
            ": started"
        );
    elif event.event = "complete" then
        CF_SN_Progress(
            event.symplecticPart,
            ", component ", event.componentIndex,
            ", projective group ", event.gid,
            ": completed; families ", event.familyCount
        );
    else
        Error("Unknown small non-abelian progress event.");
    fi;
end;


#############################################################################
## 4. Ordered runs and candidate records
#############################################################################

CF_SN_OrderedCaseSpecifications := function()
    return [
        rec(
            key := "C3",
            configuration := CF_SN_C3Configuration(),
            useSpecialS3Runner := false
        ),
        rec(
            key := "C2^2",
            configuration := CF_SN_C2_2Configuration(),
            useSpecialS3Runner := false
        ),
        rec(
            key := "C4",
            configuration := CF_SN_C4Configuration(),
            useSpecialS3Runner := false
        ),
        rec(
            key := "S3",
            configuration := CF_SN_S3Configuration(),
            useSpecialS3Runner := true
        )
    ];
end;


CF_SN_AttachEnumeratedCandidateMetadata := function(
    family,
    candidateNumber,
    specification,
    caseRecord,
    familyIndex
)
    local candidate, component;

    component := specification.configuration.components[
        caseRecord.componentIndex
    ];
    candidate := ShallowCopy(family);
    candidate.candidateNumber := candidateNumber;
    candidate.caseKey := specification.key;
    candidate.symplecticPart :=
        specification.configuration.symplecticPart;
    candidate.symplecticGId := ShallowCopy(
        specification.configuration.symplecticGId
    );
    candidate.componentIndex := caseRecord.componentIndex;
    candidate.componentLabel := caseRecord.componentLabel;
    candidate.genericIndex := component.genericIndex;
    candidate.genericFullLinearContainmentRequired :=
        component.genericIndex = 2;
    candidate.genericFullLinearContainmentVerified :=
        not candidate.genericFullLinearContainmentRequired
        or (IsBound(family.genericFullLinearContainmentVerified)
            and family.genericFullLinearContainmentVerified);
    candidate.projectiveGId := ShallowCopy(caseRecord.gid);
    candidate.linearGId := ShallowCopy(family.HId);
    candidate.familyIndexWithinCase := familyIndex;
    candidate.sourceRecords := ShallowCopy(component.sourceRecords);
    candidate.isDirectKnownCase := false;
    candidate.enumerationInput := true;
    return candidate;
end;


CF_SN_AttachDirectCandidateMetadata := function(
    directCase,
    candidateNumber
)
    local candidate;

    candidate := ShallowCopy(directCase);
    candidate.candidateNumber := candidateNumber;
    candidate.caseKey := "S3";
    candidate.symplecticPart := "S3";
    candidate.symplecticGId := [6, 1];
    candidate.componentIndex := 2;
    candidate.componentLabel := directCase.symplecticComponent;
    candidate.genericIndex := directCase.genericIndex;
    candidate.genericFullLinearContainmentRequired :=
        directCase.genericFullLinearContainmentRequired;
    candidate.genericFullLinearContainmentVerified :=
        directCase.genericFullLinearContainmentVerified;
    candidate.projectiveGId := [144, 69];
    candidate.linearGId := ShallowCopy(
        directCase.fullStrictPreimageData.id
    );
    candidate.HId := ShallowCopy(candidate.linearGId);
    candidate.familyIndexWithinCase := 1;
    candidate.sourceRecords := [directCase.source];
    candidate.isDirectKnownCase := true;
    candidate.enumerationInput := false;
    candidate.YYZMatrixGenerators := ShallowCopy(
        directCase.matrixGenerators
    );
    candidate.matrixGenerators := ShallowCopy(
        directCase.fullStrictPreimageGenerators
    );
    candidate.matrixImageOrder := directCase.fullStrictPreimageData.order;
    return candidate;
end;


CF_SN_CollectCandidatesFromRun := function(
    candidates,
    specification,
    run
)
    local caseRecord, familyIndex, family, candidate;

    for caseRecord in run.cases do
        for familyIndex in [1 .. Length(caseRecord.step3Result.families)] do
            family := caseRecord.step3Result.families[familyIndex];
            candidate := CF_SN_AttachEnumeratedCandidateMetadata(
                family,
                Length(candidates) + 1,
                specification,
                caseRecord,
                familyIndex
            );
            Add(candidates, candidate);
        od;
    od;

    if specification.useSpecialS3Runner then
        if not IsBound(run.directKnownCase) then
            Error("The S3 run did not return its direct S3 x C24 case.");
        fi;
        Add(
            candidates,
            CF_SN_AttachDirectCandidateMetadata(
                run.directKnownCase,
                Length(candidates) + 1
            )
        );
    fi;
end;


CF_SN_CaseRunSummary := function(specification, run)
    local familyCount, directKnownCaseCount,
          genericFullLinearContainmentRejectedCount;

    familyCount := Sum(List(
        run.cases,
        caseRecord -> Length(caseRecord.step3Result.families)
    ));
    if specification.useSpecialS3Runner then
        directKnownCaseCount := 1;
    else
        directKnownCaseCount := 0;
    fi;
    genericFullLinearContainmentRejectedCount := Sum(List(
        run.cases,
        caseRecord ->
            caseRecord.genericFullLinearContainmentAudit.rejectedCount
    ));
    return rec(
        key := specification.key,
        configurationLabel := specification.configuration.label,
        componentCount := Length(specification.configuration.components),
        enumeratedCaseCount := Length(run.cases),
        enumeratedFamilyCount := familyCount,
        genericFullLinearContainmentRejectedCount :=
            genericFullLinearContainmentRejectedCount,
        directKnownCaseCount := directKnownCaseCount
    );
end;


#############################################################################
## 5. Common Gonzalez--Aguilera--Liendo restriction
#############################################################################

CF_SN_AttachGonzalezAudits := function(candidates, applyRestriction)
    local filtered, audited, kept, rejected, i, candidate, audit,
          directPosition;

    if applyRestriction then
        CF_SN_Progress(
            "Gonzalez restriction started for ",
            Length(candidates), " candidates"
        );
        filtered := CF_SN_FilterCandidatesByGonzalezRestriction(
            candidates
        );
        audited := [];
        kept := [];
        rejected := [];

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
        audited := [];
        kept := [];
        rejected := [];
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

    directPosition := PositionProperty(
        audited,
        candidate -> candidate.isDirectKnownCase
    );
    if directPosition = fail then
        Error("The direct S3 x C24 candidate is missing.");
    fi;
    if applyRestriction and not audited[directPosition].gonzalezPassed then
        Error(
            "The Gonzalez restriction rejected the known smooth ",
            "S3 x C24 example."
        );
    fi;

    CF_SN_Progress(
        "Gonzalez restriction completed; retained ", Length(kept),
        "; rejected ", Length(rejected)
    );
    return rec(
        applied := applyRestriction,
        sharedFilterResult := filtered,
        audited := audited,
        kept := kept,
        rejected := rejected,
        orderPreserved := true
    );
end;


#############################################################################
## 6. Archive writers
#############################################################################

CF_SN_FailureStatuses := function(candidate)
    if not candidate.gonzalezRestrictionApplied
       or candidate.gonzalezAudit = fail then
        return [];
    fi;
    return List(
        candidate.gonzalezAudit.failures,
        failure -> failure.status
    );
end;


CF_SN_WriteHumanCandidate := function(filename, candidate)
    AppendTo(
        filename,
        "\n", candidate.candidateNumber, ". Candidate\n",
        "   Symplectic group: ", candidate.symplecticPart, "\n",
        "   Component: ", candidate.componentIndex,
        "; ", candidate.componentLabel, "\n",
        "   Projective group ID: ", candidate.projectiveGId, "\n",
        "   Strict linear group ID: ", candidate.linearGId, "\n",
        "   Generic index: ", candidate.genericIndex, "\n",
        "   Generic full linear containment required: ",
        candidate.genericFullLinearContainmentRequired, "\n",
        "   Generic full linear containment verified: ",
        candidate.genericFullLinearContainmentVerified, "\n",
        "   Direct known case: ", candidate.isDirectKnownCase, "\n",
        "   Source records: ", candidate.sourceRecords, "\n",
        "   Family number within this input: ",
        candidate.familyIndexWithinCase, "\n",
        "   Strict cubic invariant dimension: ",
        candidate.cubicInvariantDimension, "\n",
        "   Centralizer dimension: ",
        candidate.centralizerDimension, "\n",
        "   Expected moduli dimension: ",
        candidate.expectedModuliDimension, "\n",
        "   Determinant image order: ",
        candidate.determinantImageOrder, "\n",
        "   Gonzalez status: ", candidate.gonzalezStatus, "\n",
        "   Retained: ", candidate.gonzalezPassed, "\n",
        "   Gonzalez failure statuses: ",
        CF_SN_FailureStatuses(candidate), "\n",
        "   Matrix generators: ", candidate.matrixGenerators, "\n",
        "   Cubic invariant basis strings: ",
        candidate.cubicInvariantBasisStrings, "\n",
        "   Cubic invariant basis vectors: ",
        candidate.cubicInvariantBasisVectors, "\n"
    );

    if candidate.isDirectKnownCase then
        AppendTo(
            filename,
            "   YYZ equation: ", candidate.equation, "\n",
            "   YYZ matrix generators: ",
            candidate.YYZMatrixGenerators, "\n"
        );
    fi;
    if candidate.gonzalezRestrictionApplied
       and not candidate.gonzalezPassed then
        AppendTo(
            filename,
            "   Gonzalez failures: ",
            candidate.gonzalezAudit.failures, "\n"
        );
    fi;
end;


CF_SN_WriteHumanOutput := function(filename, run)
    local summary, summaryNumber, candidate;

    PrintTo(
        filename,
        "Small non-abelian candidates for cubic fourfolds\n\n",
        "1. Run information\n",
        "   GAP version: ", GAPInfo.Version, "\n",
        "   Computational engine: ",
        run.sourceRecord.engineFile, "\n",
        "   Projective candidate source: ",
        run.sourceRecord.projectiveCandidateSource, "\n",
        "   Excluded projective candidate: ",
        run.sourceRecord.excludedProjectiveCandidate, "\n",
        "   Case order: ", run.sourceRecord.caseOrder, "\n",
        "   Generic-index divisibility filter: ",
        run.sourceRecord.genericIndexDivisibilityFilter, "\n",
        "   Generic full linear containment filter: ",
        run.sourceRecord.genericFullLinearContainmentFilter, "\n",
        "   Gonzalez restriction applied: ",
        run.gonzalez.applied, "\n",
        "   Smoothness tested: false\n\n",
        "2. Totals\n",
        "   Enumerated families: ",
        run.numberOfEnumeratedCandidates, "\n",
        "   Direct known cases: ",
        run.numberOfDirectKnownCandidates, "\n",
        "   Candidates before Gonzalez: ",
        run.numberOfRawCandidates, "\n",
        "   Candidates retained: ",
        run.numberOfCandidates, "\n",
        "   Candidates rejected: ",
        run.numberOfRejectedCandidates, "\n\n",
        "3. Cases\n"
    );

    summaryNumber := 0;
    for summary in run.caseSummaries do
        summaryNumber := summaryNumber + 1;
        AppendTo(
            filename,
            "   ", summaryNumber, ". ", summary.key,
            ": components ", summary.componentCount,
            "; enumerated inputs ", summary.enumeratedCaseCount,
            "; enumerated families ", summary.enumeratedFamilyCount,
            "; rejected by generic containment ",
            summary.genericFullLinearContainmentRejectedCount,
            "; direct cases ", summary.directKnownCaseCount, "\n"
        );
    od;

    AppendTo(filename, "\n4. Candidates\n");
    for candidate in run.auditedCandidates do
        CF_SN_WriteHumanCandidate(filename, candidate);
    od;
end;


CF_SN_WriteMachineCandidate := function(filename, candidate, isLast)
    local suffix;

    if isLast then
        suffix := "\n";
    else
        suffix := ",\n";
    fi;

    AppendTo(
        filename,
        "  rec(\n",
        "    candidateNumber := ", candidate.candidateNumber, ",\n",
        "    symplecticPart := \"", candidate.symplecticPart, "\",\n",
        "    symplecticGId := ", candidate.symplecticGId, ",\n",
        "    componentIndex := ", candidate.componentIndex, ",\n",
        "    componentLabel := \"", candidate.componentLabel, "\",\n",
        "    genericIndex := ", candidate.genericIndex, ",\n",
        "    genericFullLinearContainmentRequired := ",
        candidate.genericFullLinearContainmentRequired, ",\n",
        "    genericFullLinearContainmentVerified := ",
        candidate.genericFullLinearContainmentVerified, ",\n",
        "    projectiveGId := ", candidate.projectiveGId, ",\n",
        "    linearGId := ", candidate.linearGId, ",\n",
        "    familyIndexWithinCase := ",
        candidate.familyIndexWithinCase, ",\n",
        "    isDirectKnownCase := ",
        candidate.isDirectKnownCase, ",\n",
        "    sourceRecords := ", candidate.sourceRecords, ",\n",
        "    matrixGenerators := ", candidate.matrixGenerators, ",\n",
        "    cubicMonomialExponents := ",
        candidate.cubicMonomialExponents, ",\n",
        "    cubicInvariantBasisVectors := ",
        candidate.cubicInvariantBasisVectors, ",\n",
        "    cubicInvariantBasisStrings := ",
        candidate.cubicInvariantBasisStrings, ",\n",
        "    cubicInvariantDimension := ",
        candidate.cubicInvariantDimension, ",\n",
        "    centralizerDimension := ",
        candidate.centralizerDimension, ",\n",
        "    expectedModuliDimension := ",
        candidate.expectedModuliDimension, ",\n",
        "    determinantImageOrder := ",
        candidate.determinantImageOrder, ",\n",
        "    gonzalezRestrictionApplied := ",
        candidate.gonzalezRestrictionApplied, ",\n",
        "    gonzalezPassed := ", candidate.gonzalezPassed, ",\n",
        "    gonzalezStatus := \"", candidate.gonzalezStatus, "\",\n",
        "    gonzalezFailureStatuses := ",
        CF_SN_FailureStatuses(candidate), "\n",
        "  )", suffix
    );
end;


CF_SN_WriteMachineList := function(filename, name, candidates)
    local i;

    AppendTo(filename, name, " := [\n");
    for i in [1 .. Length(candidates)] do
        CF_SN_WriteMachineCandidate(
            filename,
            candidates[i],
            i = Length(candidates)
        );
    od;
    AppendTo(filename, "];\n\n");
end;


CF_SN_WriteMachineData := function(filename, run)
    PrintTo(
        filename,
        "# Generated by gap_small_nonabelian.g.\n",
        "# This file contains data only; it does not rerun the search.\n\n",
        "SmallNonabelianSourceRecord := ",
        run.sourceRecord, ";\n\n"
    );
    CF_SN_WriteMachineList(
        filename,
        "SmallNonabelianCandidates",
        run.candidates
    );
    CF_SN_WriteMachineList(
        filename,
        "SmallNonabelianRejectedCandidates",
        run.rejectedCandidates
    );
    AppendTo(
        filename,
        "FinalSmallNonabelianCandidates := ",
        "SmallNonabelianCandidates;\n",
        "SmallNonabelianResultSummary := rec(\n",
        "  rawCount := ", run.numberOfRawCandidates, ",\n",
        "  retainedCount := ", run.numberOfCandidates, ",\n",
        "  rejectedCount := ",
        run.numberOfRejectedCandidates, ",\n",
        "  GonzalezApplied := ", run.gonzalez.applied, ",\n",
        "  smoothnessTested := false\n",
        ");\n"
    );
end;


#############################################################################
## 7. Unified pipeline
#############################################################################

CF_SN_RunUnifiedPipeline := function()
    local specifications, runs, caseSummaries, rawCandidates,
          specification, run, gonzalez, result;

    CF_SN_RunStartMilliseconds := Runtime();
    CF_SN_ProgressCounter := 0;
    PrintTo(
        CF_SN_LOG_FILE,
        "Small non-abelian calculation log\n\n",
        "Run information\n",
        "GAP version: ", GAPInfo.Version, "\n",
        "Engine file: ", CF_SN_ArchiveSourceRecord.engineFile, "\n",
        "Projective candidate source: ",
        CF_SN_ArchiveSourceRecord.projectiveCandidateSource, "\n",
        "Excluded projective candidate: ",
        CF_SN_ArchiveSourceRecord.excludedProjectiveCandidate, "\n",
        "Generic-index divisibility filter: true\n",
        "Generic full linear containment filter: true\n",
        "Output file: ", CF_SN_OUTPUT_FILE, "\n",
        "Data file: ", CF_SN_DATA_FILE, "\n",
        "Gonzalez restriction: ", CF_SN_APPLY_GONZALEZ, "\n",
        "Smoothness test: false\n\n",
        "Progress\n"
    );

    specifications := CF_SN_OrderedCaseSpecifications();
    runs := [];
    caseSummaries := [];
    rawCandidates := [];

    for specification in specifications do
        CF_SN_Progress("Case ", specification.key, ": started");
        if specification.useSpecialS3Runner then
            run := CF_SN_RunS3Configuration();
        else
            run := CF_SN_RunS1S2S3Configuration(
                specification.configuration
            );
        fi;
        Add(runs, rec(key := specification.key, result := run));
        Add(
            caseSummaries,
            CF_SN_CaseRunSummary(specification, run)
        );
        CF_SN_CollectCandidatesFromRun(
            rawCandidates,
            specification,
            run
        );
        CF_SN_Progress(
            "Case ", specification.key,
            ": completed; cumulative candidates ", Length(rawCandidates)
        );
    od;

    gonzalez := CF_SN_AttachGonzalezAudits(
        rawCandidates,
        CF_SN_APPLY_GONZALEZ
    );
    result := rec(
        sourceRecord := CF_SN_ArchiveSourceRecord,
        runs := runs,
        caseSummaries := caseSummaries,
        rawCandidates := rawCandidates,
        auditedCandidates := gonzalez.audited,
        candidates := gonzalez.kept,
        rejectedCandidates := gonzalez.rejected,
        gonzalez := gonzalez,
        numberOfEnumeratedCandidates := Number(
            rawCandidates,
            candidate -> not candidate.isDirectKnownCase
        ),
        numberOfDirectKnownCandidates := Number(
            rawCandidates,
            candidate -> candidate.isDirectKnownCase
        ),
        numberOfRawCandidates := Length(rawCandidates),
        numberOfCandidates := Length(gonzalez.kept),
        numberOfRejectedCandidates := Length(gonzalez.rejected),
        orderPreserved := true,
        smoothnessTestApplied := false,
        runtimeMilliseconds := Runtime() - CF_SN_RunStartMilliseconds
    );

    CF_SN_WriteHumanOutput(CF_SN_OUTPUT_FILE, result);
    CF_SN_WriteMachineData(CF_SN_DATA_FILE, result);
    CF_SN_Progress("Human-readable output written to ", CF_SN_OUTPUT_FILE);
    CF_SN_Progress("Machine-readable data written to ", CF_SN_DATA_FILE);
    AppendTo(
        CF_SN_LOG_FILE,
        "\nSummary\n",
        "Projective group inputs: ",
        Sum(List(
            result.caseSummaries,
            summary -> summary.enumeratedCaseCount
        )), "\n",
        "Representations rejected by generic full-group containment: ",
        Sum(List(
            result.caseSummaries,
            summary -> summary.genericFullLinearContainmentRejectedCount
        )), "\n",
        "Enumerated families: ",
        result.numberOfEnumeratedCandidates, "\n",
        "Direct known cases: ",
        result.numberOfDirectKnownCandidates, "\n",
        "Raw candidates: ", result.numberOfRawCandidates, "\n",
        "Retained candidates: ", result.numberOfCandidates, "\n",
        "Rejected candidates: ",
        result.numberOfRejectedCandidates, "\n",
        "Runtime: ", result.runtimeMilliseconds, " ms\n"
    );
    return result;
end;


if CF_SN_AUTO_RUN then
    SmallNonabelianRun := CF_SN_RunUnifiedPipeline();;
    SmallNonabelianCandidates := SmallNonabelianRun.candidates;
    FinalSmallNonabelianCandidates := SmallNonabelianCandidates;
fi;
