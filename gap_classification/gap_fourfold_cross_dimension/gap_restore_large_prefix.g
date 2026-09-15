#############################################################################
## Rebuild the positive-edge accumulator from audited small edges and a
## completed prefix of the large-target schedule.
##
## Usage: gap -r -q -b gap_restore_large_prefix.g <prefix-length>
## The script verifies every restored layer before writing the accumulator.
#############################################################################

Read("gap_cross_dimension_common.g");
Read("input/fourfold_156.g");
Read("input/large_target_schedule.g");
Read("audit/small_positive_edges.g");
prefixLength := Int(GAPInfo.SystemCommandLine[Length(GAPInfo.SystemCommandLine)]);
if prefixLength < 0 or prefixLength > Length(LargeTargetSchedule) then
    Error("Invalid completed large-target prefix.");
fi;
KnownPositiveEdges := ShallowCopy(SmallPositiveEdges);
for prefixPosition in [1 .. prefixLength] do
    schedule := LargeTargetSchedule[prefixPosition];
    Read(Concatenation("output/large_targets/layer_",String(schedule.layer),
        "_family_",String(schedule.number),".g"));
    targetFamily := Families[schedule.number];
    targetGroup := Group(targetFamily.generators);
    expectedSources := List(Filtered(Families, f ->
        f.familyDimension > targetFamily.familyDimension
        and targetFamily.reportedOrder mod f.reportedOrder = 0), f -> f.number);
    if Length(LargeTargetResults) <> Length(expectedSources)
       or Set(List(LargeTargetResults,r->r.sourceNumber)) <> Set(expectedSources) then
        Error("Incomplete resumed layer.");
    fi;
    for edge in LargeTargetResults do
        if edge.targetNumber <> schedule.number or edge.ok=fail then
            Error("Invalid resumed edge.");
        fi;
        if edge.ok then
            if not CFCD_VerifyWitness(Families[edge.sourceNumber].generators,
                targetGroup,edge.P) then Error("Invalid resumed witness."); fi;
            Add(KnownPositiveEdges,edge);
        elif edge.status <> "no_embedding" or not edge.direct then
            Error("Invalid resumed negative result.");
        fi;
    od;
od;
CFCD_WriteAssignment("audit/known_positive_edges.g","KnownPositiveEdges",KnownPositiveEdges);
Print("LARGE_PREFIX_RESTORED layers=",prefixLength,"\n");
QUIT_GAP(0);
