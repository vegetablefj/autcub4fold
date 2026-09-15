#############################################################################
## Verify uniformization on the eight rank-below-15 symplectic families.
## The audit writes its GAP-readable certificates and concise Markdown report;
## it does not rebuild the final 156-family catalogue.
#############################################################################

CF_UNI_RunPaths := function()
    if IsExistingFile(
        "gap_classification/gap_uniformization/gap_uniformization.g"
    ) then
        return rec(
            uniformizationDirectory :=
                "gap_classification/gap_uniformization/",
            saturationDirectory := "gap_classification/gap_saturation/",
            outputFile := Concatenation(
                "gap_classification/gap_uniformization/",
                "gap_uniformization.out"
            ),
            markdownFile := Concatenation(
                "gap_classification/gap_uniformization/",
                "gap_uniformization_result.md"
            )
        );
    fi;
    Error("Run this audit from the repository root.");
end;


CF_UNI_RunPathRecord := CF_UNI_RunPaths();
Read(Concatenation(
    CF_UNI_RunPathRecord.uniformizationDirectory,
    "gap_uniformization_functions.g"
));
Read(Concatenation(
    CF_UNI_RunPathRecord.saturationDirectory,
    "gap_saturation_input.g"
));


UniformizationSymplecticFamilyResults := [];
Print("Uniformizing the eight rank-below-15 symplectic families\n");
for CF_UNI_RunNumber in
    [1 .. Length(SaturationInputRankBelow15SymplecticFamilies)] do
    CF_UNI_RunCandidate :=
        SaturationInputRankBelow15SymplecticFamilies[CF_UNI_RunNumber];
    CF_UNI_RunResult := CF_UNI_UniformizeFamily(CF_UNI_RunCandidate);
    Add(
        UniformizationSymplecticFamilyResults,
        CF_UNI_CompactResult(CF_UNI_RunResult)
    );
    Print(
        CF_UNI_RunNumber, ". ", CF_UNI_RunResult.sourceKey,
        ": ", CF_UNI_RunResult.status
    );
    if CF_UNI_RunResult.status = "uniformized" then
        Print(
            "; ", CF_UNI_RunResult.witnessType,
            "; generic index ", CF_UNI_RunResult.genericIndex,
            "; full index ", CF_UNI_RunResult.fullIndex,
            "; relative quotient ",
            CF_UNI_RunResult.relativeQuotientOrder,
            "; extra ", CF_UNI_RunResult.extraGeneratorOrigin
        );
    fi;
    Print("\n");
od;

if ForAny(
    UniformizationSymplecticFamilyResults,
    result -> result.status <> "uniformized"
             or result.determinantKernelVerified <> true
             or result.genericFullGroupContainedVerified <> true
             or result.fullGroupVerified <> true
) then
    Error("At least one standard-family uniformization failed.");
fi;

PrintTo(
    CF_UNI_RunPathRecord.outputFile,
    "UniformizationSymplecticFamilyResults := ",
    UniformizationSymplecticFamilyResults,
    ";\n"
);

CF_UNI_MarkdownStream := OutputTextFile(
    CF_UNI_RunPathRecord.markdownFile,
    false
);
if CF_UNI_MarkdownStream = fail then
    Error("Could not open the uniformization Markdown file.");
fi;
SetPrintFormattingStatus(CF_UNI_MarkdownStream, false);
PrintTo(
    CF_UNI_MarkdownStream,
    "# Uniformization of the small symplectic families\n\n",
    "The generic full linear group is moved to the displayed Koike ",
    "coordinates. The last column records the source of the single ",
    "additional generator when the family is special.\n\n",
    "| No. | Source | Standard form | Change of coordinates | Generic ",
    "index | Full index | Relative quotient | Additional generator |\n",
    "|---:|---|---|---|---:|---:|---:|---|\n"
);
for CF_UNI_RunNumber in
    [1 .. Length(UniformizationSymplecticFamilyResults)] do
    CF_UNI_RunResult :=
        UniformizationSymplecticFamilyResults[CF_UNI_RunNumber];
    AppendTo(
        CF_UNI_MarkdownStream,
        "| ", CF_UNI_RunNumber,
        " | `", CF_UNI_RunResult.sourceKey,
        "` | ", CF_UNI_RunResult.standardLabel,
        " | `", CF_UNI_RunResult.witnessType,
        "` | ", CF_UNI_RunResult.genericIndex,
        " | ", CF_UNI_RunResult.fullIndex,
        " | ", CF_UNI_RunResult.relativeQuotientOrder,
        " | `", CF_UNI_RunResult.extraGeneratorOrigin,
        "` |\n"
    );
od;
AppendTo(
    CF_UNI_MarkdownStream,
    "\nEvery row passed three exact checks: the transformed determinant ",
    "kernel equals the recorded standard strict lift, the transformed full ",
    "group contains the standard generic full group, and that generic group ",
    "together with the additional generator recovers the full transformed ",
    "matrix group.  The matrices themselves are stored in ",
    "`gap_uniformization.out`.\n"
);
CloseStream(CF_UNI_MarkdownStream);

Print("Results written to ", CF_UNI_RunPathRecord.outputFile, "\n");
Print("Summary written to ", CF_UNI_RunPathRecord.markdownFile, "\n");
