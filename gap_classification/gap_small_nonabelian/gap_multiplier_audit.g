#############################################################################
##
## gap_multiplier_audit.g
##
## Exact cohomological audit for the non-abelian projective target groups in
## the small-group enumeration.  This script does not enumerate matrix
## representations.  It verifies that the 3-primary Schur multiplier of
## every current target is trivial.  Hence the Ext^1 classes already used by
## gap_small_nonabelian exhaust H^2(G,C3) for these groups.  Control groups
## are recorded separately and are never added to the classification input.
##
## Run with this directory as the GAP working directory.  The script writes
## one GAP-readable audit, one progress log, and one Markdown summary.
##
#############################################################################

if LoadPackage("smallgrp") = fail then
    Error("The GAP package smallgrp is required.");
fi;
if LoadPackage("cohomolo") = fail then
    Error("The GAP package cohomolo is required.");
fi;

Read("../gap_functions.g");
Read("gap_small_nonabelian_functions.g");

CF_MA_OUTPUT_FILE := "gap_multiplier_audit.out";
CF_MA_LOG_FILE := "gap_multiplier_audit.log";
CF_MA_MARKDOWN_FILE := "gap_small_nonabelian_result.md";
CF_MA_MARKDOWN_BEGIN := "<!-- multiplier-audit:start -->";
CF_MA_MARKDOWN_END := "<!-- multiplier-audit:end -->";


CF_MA_WriteAssignment := function(path, name, value)
    local stream;

    stream := OutputTextFile(path, false);
    if stream = fail then
        Error("Cannot open output file: ", path);
    fi;
    SetPrintFormattingStatus(stream, false);
    PrintTo(stream, name, " :=\n");
    PrintTo(stream, value, ";\n");
    CloseStream(stream);
end;


# Audit trivial GF(3) coefficients; no representations are enumerated.
CF_MA_AuditGroup := function(id, role)
    local G, P, chr, audit;

    G := Image(IsomorphismPermGroup(SmallGroup(id[1], id[2])));
    if Size(G) mod 3 = 0 then
        chr := CHR(
            G,
            3,
            0,
            List(GeneratorsOfGroup(G), g -> [[One(GF(3))]])
        );
        if chr = fail then
            Error("cohomolo failed for SmallGroup(", id, ").");
        fi;
        audit := CF_SN_CohomologyDimensionAudit(G, chr);
        P := SylowSubgroup(G, 3);
    else
        audit := CF_SN_CohomologyDimensionAudit(G);
        P := TrivialSubgroup(G);
    fi;

    if not audit.CohomologyDimensionCheckPassed then
        Error("Universal-coefficient dimension check failed for ", id, ".");
    fi;

    return rec(
        role := role,
        id := id,
        order := Size(G),
        structure := StructureDescription(G),
        abelianInvariants := audit.abelianInvariants,
        sylow3Order := Size(P),
        sylow3Structure := StructureDescription(P),
        multiplier3Invariants := audit.multiplier3Invariants,
        extDimension := audit.ExtAbelianizationDimension,
        h2Dimension := audit.H2Dimension,
        universalCoefficientCheckPassed :=
            audit.CohomologyDimensionCheckPassed
    );
end;


CF_MA_AddDistinct := function(list, value)
    if not value in list then
        Add(list, value);
    fi;
end;


CF_MA_CaseLabels := ["C3", "C2^2", "C4", "S3"];
CF_MA_CaseTargets := [];
CF_MA_TargetIds := [];

for CF_MA_Label in CF_MA_CaseLabels do
    CF_MA_Ids := CF_SN_YYZNonabelianFullGroupIds(CF_MA_Label);
    Add(CF_MA_CaseTargets, rec(label := CF_MA_Label, ids := CF_MA_Ids));
    for CF_MA_Id in CF_MA_Ids do
        CF_MA_AddDistinct(CF_MA_TargetIds, CF_MA_Id);
    od;
od;

CF_MA_LogStream := OutputTextFile(CF_MA_LOG_FILE, false);
if CF_MA_LogStream = fail then
    Error("Cannot open log file: ", CF_MA_LOG_FILE);
fi;
SetPrintFormattingStatus(CF_MA_LogStream, false);
LogTo(CF_MA_LogStream);

Print("Small non-abelian multiplier audit\n");
Print("GAP version: ", GAPInfo.Version, "\n");
Print("Current distinct target count: ", Length(CF_MA_TargetIds), "\n");

CF_MA_CurrentResults := [];
for CF_MA_Position in [1 .. Length(CF_MA_TargetIds)] do
    CF_MA_Id := CF_MA_TargetIds[CF_MA_Position];
    Print(
        CF_MA_Position, "/", Length(CF_MA_TargetIds),
        " current target ", CF_MA_Id, "\n"
    );
    Add(CF_MA_CurrentResults, CF_MA_AuditGroup(CF_MA_Id, "current target"));
od;

# The explicit S3 x C24 example is appended after the representation search.
CF_MA_DirectResult := CF_MA_AuditGroup([144, 69], "direct S3 x C24 example");

# Controls are not targets: [72,12] has zero multiplier 3-part; the four
# abelian groups have nonzero multiplier 3-part in the saved audit.
CF_MA_ControlIds := [[72, 12], [9, 2], [18, 5], [36, 8], [72, 14]];
CF_MA_ControlResults := List(
    CF_MA_ControlIds,
    id -> CF_MA_AuditGroup(id, "control only")
);

CF_MA_AllCurrentMultipliersTrivial := ForAll(
    CF_MA_CurrentResults,
    result -> Length(result.multiplier3Invariants) = 0
);
CF_MA_DirectMultiplierTrivial :=
    Length(CF_MA_DirectResult.multiplier3Invariants) = 0;
CF_MA_AllDimensionChecksPassed := ForAll(
    Concatenation(CF_MA_CurrentResults, [CF_MA_DirectResult], CF_MA_ControlResults),
    result -> result.universalCoefficientCheckPassed
);

if Length(CF_MA_TargetIds) <> 16 then
    Error("The current target list no longer has 16 distinct groups.");
fi;
if not CF_MA_AllCurrentMultipliersTrivial then
    Error("A current target has nontrivial 3-primary Schur multiplier.");
fi;
if not CF_MA_DirectMultiplierTrivial then
    Error("The direct S3 x C24 example has nontrivial multiplier 3-part.");
fi;
if not CF_MA_AllDimensionChecksPassed then
    Error("A universal-coefficient dimension check failed.");
fi;

CF_MA_Result := rec(
    gapVersion := GAPInfo.Version,
    caseTargets := CF_MA_CaseTargets,
    distinctCurrentTargetIds := CF_MA_TargetIds,
    distinctCurrentTargetCount := Length(CF_MA_TargetIds),
    currentResults := CF_MA_CurrentResults,
    directExample := CF_MA_DirectResult,
    controlsNotClassificationInput := CF_MA_ControlResults,
    allCurrentMultiplier3PartsTrivial :=
        CF_MA_AllCurrentMultipliersTrivial,
    directExampleMultiplier3PartTrivial :=
        CF_MA_DirectMultiplierTrivial,
    allUniversalCoefficientDimensionChecksPassed :=
        CF_MA_AllDimensionChecksPassed,
    conclusion :=
        "For every current non-abelian target, H^2(G,C3) is the Ext^1(G_ab,C3) part already enumerated by gap_small_nonabelian."
);

CF_MA_WriteAssignment(CF_MA_OUTPUT_FILE, "MultiplierAuditResult", CF_MA_Result);

# Preserve every report section outside this audit; do not rerun enumeration.
CF_MA_ReportText := StringFile(CF_MA_MARKDOWN_FILE);
if CF_MA_ReportText = fail then
    Error("Cannot read the shared result document: ", CF_MA_MARKDOWN_FILE);
fi;
CF_MA_ReportStart := PositionSublist(CF_MA_ReportText, CF_MA_MARKDOWN_BEGIN);
CF_MA_ReportEnd := PositionSublist(CF_MA_ReportText, CF_MA_MARKDOWN_END);
if CF_MA_ReportStart = fail and CF_MA_ReportEnd = fail then
    CF_MA_ReportPrefix := Concatenation(CF_MA_ReportText, "\n\n");
    CF_MA_ReportSuffix := "\n";
elif CF_MA_ReportStart = fail or CF_MA_ReportEnd = fail
     or CF_MA_ReportEnd < CF_MA_ReportStart then
    Error("The shared result document has an incomplete audit section.");
else
    CF_MA_ReportPrefix := "";
    if CF_MA_ReportStart > 1 then
        CF_MA_ReportPrefix :=
            CF_MA_ReportText{[1 .. CF_MA_ReportStart - 1]};
    fi;
    CF_MA_AfterSection := CF_MA_ReportEnd + Length(CF_MA_MARKDOWN_END);
    CF_MA_ReportSuffix := "";
    if CF_MA_AfterSection <= Length(CF_MA_ReportText) then
        CF_MA_ReportSuffix :=
            CF_MA_ReportText{[CF_MA_AfterSection .. Length(CF_MA_ReportText)]};
    fi;
fi;

CF_MA_MarkdownStream := OutputTextFile(CF_MA_MARKDOWN_FILE, false);
if CF_MA_MarkdownStream = fail then
    Error("Cannot open markdown file: ", CF_MA_MARKDOWN_FILE);
fi;
SetPrintFormattingStatus(CF_MA_MarkdownStream, false);
PrintTo(
    CF_MA_MarkdownStream,
    CF_MA_ReportPrefix, CF_MA_MARKDOWN_BEGIN, "\n",
    "## Multiplier audit\n\n",
    "The audit reads the small non-abelian target IDs from the corresponding\n",
    "functions, retaining first-occurrence order. All 16 distinct targets and the\n",
    "separate `S3 x C24` example have trivial Schur multiplier 3-part.\n",
    "Consequently, their `H^2(G,C3)` is the Ext part already covered by the\n",
    "small non-abelian enumeration. The conclusion is restricted to these targets.\n\n",
    "### Run information\n\n",
    "- GAP version: `", GAPInfo.Version, "`.\n",
    "- Distinct targets: 16; direct example: 1; controls: 5.\n",
    "- Universal-coefficient dimension checks: passed for all 22 records.\n",
    "- GAP-readable data: [gap_multiplier_audit.out](gap_multiplier_audit.out).\n",
    "- Runtime log: [gap_multiplier_audit.log](gap_multiplier_audit.log).\n",
    "- Criterion and scope: [gap_small_nonabelian_script.md#multiplier-audit-and-extension-completeness](gap_small_nonabelian_script.md#multiplier-audit-and-extension-completeness).\n\n",
    "All dimensions below are over `GF(3)`; `[]` means trivial multiplier 3-part.\n\n",
    "### Target groups\n\n",
    "| GAP ID | Structure | Sylow 3-subgroup | Ext dimension | H2 dimension | Multiplier 3-part |\n",
    "| --- | --- | --- | ---: | ---: | --- |\n"
);
for CF_MA_Record in CF_MA_CurrentResults do
    PrintTo(
        CF_MA_MarkdownStream,
        "| `", CF_MA_Record.id, "` | `", CF_MA_Record.structure,
        "` | `", CF_MA_Record.sylow3Structure, "` | ",
        CF_MA_Record.extDimension, " | ", CF_MA_Record.h2Dimension,
        " | `", CF_MA_Record.multiplier3Invariants, "` |\n"
    );
od;
PrintTo(
    CF_MA_MarkdownStream,
    "\n### Direct example\n\n",
    "| GAP ID | Structure | Sylow 3-subgroup | Ext dimension | H2 dimension | Multiplier 3-part |\n",
    "| --- | --- | --- | ---: | ---: | --- |\n",
    "| `", CF_MA_DirectResult.id, "` | `", CF_MA_DirectResult.structure,
    "` | `", CF_MA_DirectResult.sylow3Structure, "` | ",
    CF_MA_DirectResult.extDimension, " | ", CF_MA_DirectResult.h2Dimension,
    " | `", CF_MA_DirectResult.multiplier3Invariants, "` |\n\n",
    "### Controls\n\n",
    "These records are not classification inputs. The excluded target\n",
    "`[72,12]` is a zero-value control; the four abelian groups are nonzero-value\n",
    "controls. These roles describe the saved values, not additional assertions\n",
    "enforced by the script.\n\n",
    "| GAP ID | Structure | Ext dimension | H2 dimension | Multiplier 3-part | Role |\n",
    "| --- | --- | ---: | ---: | --- | --- |\n"
);
for CF_MA_Record in CF_MA_ControlResults do
    PrintTo(
        CF_MA_MarkdownStream,
        "| `", CF_MA_Record.id, "` | `", CF_MA_Record.structure,
        "` | ", CF_MA_Record.extDimension, " | ", CF_MA_Record.h2Dimension,
        " | `", CF_MA_Record.multiplier3Invariants, "` | "
    );
    if Length(CF_MA_Record.multiplier3Invariants) = 0 then
        PrintTo(CF_MA_MarkdownStream, "zero-value control |\n");
    else
        PrintTo(CF_MA_MarkdownStream, "nonzero-value control |\n");
    fi;
od;
PrintTo(
    CF_MA_MarkdownStream,
    "\n### Interpretation\n\n",
    Number(CF_MA_CurrentResults, r -> r.extDimension = 1),
    " target groups have Ext and H2 dimension 1; ",
    Number(CF_MA_CurrentResults, r -> r.extDimension = 0),
    " have dimension 0.\n",
    "The direct example has dimension 1. A vanishing multiplier 3-part removes\n",
    "the non-liftable branch, but does not force every extension to split:\n",
    "nonzero Ext classes can still be liftable without being F-liftable.\n",
    "This audit does not establish geometric realizability or smoothness.\n"
);
PrintTo(CF_MA_MarkdownStream, CF_MA_MARKDOWN_END, CF_MA_ReportSuffix);
CloseStream(CF_MA_MarkdownStream);

Print("All current multiplier 3-parts trivial: true\n");
Print("Direct S3 x C24 multiplier 3-part trivial: true\n");
Print("All universal-coefficient dimension checks passed: true\n");
Print("Output: ", CF_MA_OUTPUT_FILE, "\n");
Print("Readable report: ", CF_MA_MARKDOWN_FILE, "\n");

LogTo();
CloseStream(CF_MA_LogStream);
QUIT_GAP(0);
