#############################################################################
##
##  gap_yyz_bounds.g
##
##  GAP calculation of the group-theoretic Yang--Yu--Zhu bounds for
##  automorphism groups of smooth cubic fourfolds.
##
##  The output YYZResults is a list of entries
##
##    [ "G_i", index, full_group_id, full_group_description, sources ]
##
##  where sources is a list of Yang--Yu--Zhu maximal groups M_j containing
##  the candidate full group.
##
##  Special convention for G_14:
##    full groups are not identified.  Occurrences are merged only by index,
##    and only the union of their sources is retained:
##
##    [ "G_14", index, fail, fail, sources ].
##
#############################################################################

# Set to false to suppress progress messages on stdout.
YYZ_SHOW_PROGRESS := true;

# Human-readable audit report written after the calculation.
# Bare filenames are relative to GAP's current working directory.
YYZ_OUTPUT_FILE := "gap_yyz_bounds_output.txt";

# Lightweight execution log, also written to the current working directory.
YYZ_LOG_FILE := "gap_yyz_bounds_log.txt";
YYZ_RUN_START_MS := Runtime();
PrintTo(YYZ_LOG_FILE,
    "YYZ bounds calculation log\n",
    "==========================\n",
    "GAP version: ", GAPInfo.Version, "\n",
    "Output file: ", YYZ_OUTPUT_FILE, "\n",
    "Log file: ", YYZ_LOG_FILE, "\n\n"
);;

# Filled by GenerateYYZResults.  It records enough run-level information to
# make the output auditable without changing the mathematical search.
YYZRunSummary := fail;

if LoadPackage("smallgrp") = fail then
    Error("The GAP package smallgrp is required.");
fi;


#############################################################################
##  1. Group data
#############################################################################

ScalarGroup := Group([E(3) * IdentityMat(6)]);;

ProjectiveQuotientByCubicScalars := function(linearGroup, label)
    if not IsSubgroup(linearGroup, ScalarGroup) then
        Error(label, " does not contain the cubic scalar subgroup C3.");
    fi;

    return FactorGroup(linearGroup, ScalarGroup);
end;

# First Yang-Yu-Zhu maximal group: the Fermat cubic fourfold.
mat1 := [
    [0,1,0,0,0,0], [1,0,0,0,0,0], [0,0,1,0,0,0],
    [0,0,0,1,0,0], [0,0,0,0,1,0], [0,0,0,0,0,1]
];;
mat2 := [
    [0,1,0,0,0,0], [0,0,1,0,0,0], [0,0,0,1,0,0],
    [0,0,0,0,1,0], [0,0,0,0,0,1], [1,0,0,0,0,0]
];;
mat3 := DiagonalMat([1,E(3),1,1,1,1]);;
H1Linear := Group([mat1, mat2, mat3]);;
H1 := ProjectiveQuotientByCubicScalars(H1Linear, "H1Linear");;

# Second Yang-Yu-Zhu maximal group.
# The lower-right 3 by 3 block of mat4 is the cycle (4,5,6), not the
# transposition (4,5).  Together with the transposition in mat5, this gives
# the full S3 permutation action on the Fermat summand x4^3+x5^3+x6^3.
mat4 := [
    [0,1,0,0,0,0], [0,0,1,0,0,0], [1,0,0,0,0,0],
    [0,0,0,0,1,0], [0,0,0,0,0,1], [0,0,0,1,0,0]
];;
mat5 := [
    [1,0,0,0,0,0], [0,E(3),0,0,0,0], [0,0,E(3)^2,0,0,0],
    [0,0,0,0,1,0], [0,0,0,1,0,0], [0,0,0,0,0,1]
];;
mat6 := (1 / Sqrt(3)) * [
    [1,1,1,0,0,0], [1,E(3),E(3)^2,0,0,0],
    [1,E(3)^2,E(3),0,0,0], [0,0,0,E(3)*Sqrt(3),0,0],
    [0,0,0,0,Sqrt(3),0], [0,0,0,0,0,Sqrt(3)]
];;
H2Linear := Group([mat4, mat5, mat6]);;
H2 := ProjectiveQuotientByCubicScalars(H2Linear, "H2Linear");;

# Seventh Yang-Yu-Zhu maximal group.
mat7 := DiagonalMat([1,E(3),E(3)^2,1,1,1]);;
mat8 := (1 / Sqrt(3)) * [
    [1,1,1,0,0,0], [1,E(3),E(3)^2,0,0,0],
    [1,E(3)^2,E(3),0,0,0], [0,0,0,Sqrt(3),0,0],
    [0,0,0,0,Sqrt(3),0], [0,0,0,0,0,Sqrt(3)]
];;
mat9 := [
    [0,0,0,0,1,0], [0,0,0,0,0,1], [0,0,0,1,0,0],
    [1,0,0,0,0,0], [0,1,0,0,0,0], [0,0,1,0,0,0]
];;
H7Linear := Group([mat7, mat8, mat9]);;
H7 := ProjectiveQuotientByCubicScalars(H7Linear, "H7Linear");;

# The 15 maximal groups in Yang-Yu-Zhu, Theorem 1.2.
MaximalGroups := [
    H1,
    H2,
    SmallGroup(144,69),
    DirectProduct(SymmetricGroup(5), SmallGroup(18,3)),
    SmallGroup(48,2),
    SmallGroup(1980,57),
    H7,
    SmallGroup(32,1),
    SmallGroup(126,7),
    SmallGroup(720,765),
    SymmetricGroup(7),
    SmallGroup(32,42),
    SmallGroup(336,208),
    SmallGroup(48,29),
    SmallGroup(216,153)
];;

MaximalGroupLabels := List(
    [1 .. Length(MaximalGroups)],
    i -> Concatenation("M_", String(i))
);;

ExpectedMaximalOrders := [
    174960, 5832, 144, 2160, 48,
    1980, 7776, 32, 126, 720,
    5040, 32, 336, 48, 216
];;

# Select the Fermat symplectic group by its order.  Do not use a positional
# expression such as NormalSubgroups(H1)[3], whose result depends on GAP's
# ordering of the normal-subgroup list.
G1Candidates := Filtered(
    NormalSubgroups(H1),
    N -> Size(N) = 29160
);;
if Length(G1Candidates) <> 1 then
    Error(
        "Expected a unique normal subgroup of H1 of order 29160, found ",
        Length(G1Candidates), "."
    );
fi;
G1 := G1Candidates[1];;

# The 34 symplectic automorphism groups in Laza-Zheng, Theorem 1.2.
SymplecticGroups := [
    G1,
    AlternatingGroup(7),
    SmallGroup(1944,3559),
    SmallGroup(720,765),
    SmallGroup(660,13),
    SmallGroup(360,120),
    SmallGroup(972,776),
    SmallGroup(360,118),
    SmallGroup(168,42),
    SmallGroup(120,34),
    SmallGroup(72,41),
    SmallGroup(72,40),
    SmallGroup(48,29),
    SmallGroup(486,249),
    SmallGroup(72,43),
    SmallGroup(60,5),
    SmallGroup(36,9),
    SmallGroup(36,10),
    SmallGroup(21,1),
    SmallGroup(20,3),
    SmallGroup(16,8),
    SmallGroup(24,12),
    SmallGroup(8,4),
    SmallGroup(18,4),
    SmallGroup(12,4),
    SmallGroup(12,3),
    SmallGroup(10,1),
    SmallGroup(8,3),
    SmallGroup(4,1),
    SmallGroup(6,1),
    SmallGroup(4,2),
    SmallGroup(3,1),
    SmallGroup(2,1),
    SmallGroup(1,1)
];;

SymplecticGroupLabels := List(
    [1 .. Length(SymplecticGroups)],
    i -> Concatenation("G_", String(i))
);;

ExpectedSymplecticOrders := [
    29160, 2520, 1944, 720, 660, 360, 972, 360, 168, 120,
    72, 72, 48, 486, 72, 60, 36, 36, 21, 20, 16, 24, 8, 18,
    12, 12, 10, 8, 4, 6, 4, 3, 2, 1
];;


#############################################################################
##  2. Validation and auxiliary functions
#############################################################################

YYZ_Progress := function(message)
    # Always record progress in the log; optionally mirror it to stdout.
    AppendTo(YYZ_LOG_FILE, "# [YYZ] ", message, "\n");
    if YYZ_SHOW_PROGRESS then
        Print("# [YYZ] ", message, "\n");
    fi;
end;

YYZ_ValidateOrders := function(groups, expectedOrders, labels)
    local i, actual;

    if Length(groups) <> Length(expectedOrders)
       or Length(groups) <> Length(labels) then
        Error("Inconsistent group-data lengths.");
    fi;

    for i in [1 .. Length(groups)] do
        actual := Size(groups[i]);
        if actual <> expectedOrders[i] then
            Error(
                labels[i], " has order ", actual,
                ", but the expected order is ", expectedOrders[i], "."
            );
        fi;
    od;
end;

YYZ_ValidateOrders(
    MaximalGroups,
    ExpectedMaximalOrders,
    MaximalGroupLabels
);;
YYZ_ValidateOrders(
    SymplecticGroups,
    ExpectedSymplecticOrders,
    SymplecticGroupLabels
);;
YYZ_Progress("group data validated.");

# The admissible index is 2^a or 3*2^a.
YYZ_IsAllowedIndex := function(n)
    local residual;

    if not IsInt(n) or n < 1 then
        return false;
    fi;

    residual := n;
    if residual mod 3 = 0 then
        residual := residual / 3;
    fi;

    while residual > 1 and residual mod 2 = 0 do
        residual := residual / 2;
    od;

    return residual = 1;
end;

YYZ_GroupId := function(G)
    if IdGroupsAvailable(Size(G)) then
        return IdGroup(G);
    fi;
    return fail;
end;

YYZ_GroupDescription := function(G, id)
    local H, description;

    if id = fail then
        H := G;
    else
        H := SmallGroup(id[1], id[2]);
    fi;

    description := StructureDescription(H);
    if description = fail then
        return Concatenation("group of order ", String(Size(G)));
    fi;

    return description;
end;

# The normal-subgroup list is cached on each subgroup candidate because the
# same candidate is tested against several symplectic groups.
YYZ_HasNormalCyclicQuotient := function(symplecticGroup, candidate)
    local symplecticOrder, normalSubgroup, quotient;

    symplecticOrder := Size(symplecticGroup);

    if candidate.order mod symplecticOrder <> 0 then
        return false;
    fi;

    if not YYZ_IsAllowedIndex(candidate.order / symplecticOrder) then
        return false;
    fi;

    if not IsBound(candidate.normalSubgroups) then
        candidate.normalSubgroups := NormalSubgroups(candidate.group);
    fi;

    for normalSubgroup in candidate.normalSubgroups do
        if Size(normalSubgroup) = symplecticOrder
           and IsomorphismGroups(symplecticGroup, normalSubgroup) <> fail then
            quotient := FactorGroup(candidate.group, normalSubgroup);
            if IsCyclic(quotient) then
                return true;
            fi;
        fi;
    od;

    return false;
end;

YYZ_SourceDescriptorCache := [];;

YYZ_SourceDescriptor := function(sourceIndex)
    local id;

    if not IsBound(YYZ_SourceDescriptorCache[sourceIndex]) then
        id := YYZ_GroupId(MaximalGroups[sourceIndex]);
        YYZ_SourceDescriptorCache[sourceIndex] := [
            MaximalGroupLabels[sourceIndex],
            id,
            YYZ_GroupDescription(MaximalGroups[sourceIndex], id)
        ];
    fi;

    return YYZ_SourceDescriptorCache[sourceIndex];
end;

YYZ_CandidateId := function(candidate)
    if not IsBound(candidate.groupId) then
        candidate.groupId := YYZ_GroupId(candidate.group);
    fi;
    return candidate.groupId;
end;

YYZ_SameFullGroup := function(record, candidate)
    local candidateId;

    if record.order <> candidate.order then
        return false;
    fi;

    candidateId := YYZ_CandidateId(candidate);

    if record.fullGroupId <> fail and candidateId <> fail then
        return record.fullGroupId = candidateId;
    fi;

    return IsomorphismGroups(record.fullGroup, candidate.group) <> fail;
end;

# Identification and abstract isomorphism tests are performed only after all
# maximal groups have been searched.  This keeps the expensive operations out
# of the subgroup-enumeration loop.
YYZ_DeduplicateRawResults := function(rawResults)
    local results, raw, candidate, bucket, existing, candidateId, record;

    results := [];

    for raw in rawResults do
        if raw.symplecticIndex = 14 then
            # For G_14, deliberately retain only index and source data.
            existing := First(
                results,
                r -> r.symplecticIndex = 14 and r.index = raw.index
            );

            if existing = fail then
                Add(results, rec(
                    symplecticIndex := 14,
                    index := raw.index,
                    order := fail,
                    fullGroup := fail,
                    fullGroupId := fail,
                    fullGroupDescription := fail,
                    sourceIndices := [raw.sourceIndex],
                    indexSourcesOnly := true
                ));
            elif not raw.sourceIndex in existing.sourceIndices then
                Add(existing.sourceIndices, raw.sourceIndex);
            fi;
        else
            candidate := raw.candidate;

            bucket := Filtered(
                results,
                r -> not r.indexSourcesOnly
                     and r.symplecticIndex = raw.symplecticIndex
                     and r.index = raw.index
                     and r.order = candidate.order
            );

            existing := First(
                bucket,
                r -> YYZ_SameFullGroup(r, candidate)
            );

            if existing = fail then
                candidateId := YYZ_CandidateId(candidate);
                Add(results, rec(
                    symplecticIndex := raw.symplecticIndex,
                    index := raw.index,
                    order := candidate.order,
                    fullGroup := candidate.group,
                    fullGroupId := candidateId,
                    fullGroupDescription := fail,
                    sourceIndices := [raw.sourceIndex],
                    indexSourcesOnly := false
                ));
            elif not raw.sourceIndex in existing.sourceIndices then
                Add(existing.sourceIndices, raw.sourceIndex);
            fi;
        fi;
    od;

    for record in results do
        Sort(record.sourceIndices);
        if not record.indexSourcesOnly then
            record.fullGroupDescription := YYZ_GroupDescription(
                record.fullGroup,
                record.fullGroupId
            );
        fi;
    od;

    return results;
end;

YYZ_SortInternalResults := function(results)
    Sort(results, function(left, right)
        if left.symplecticIndex <> right.symplecticIndex then
            return left.symplecticIndex < right.symplecticIndex;
        fi;

        if left.index <> right.index then
            return left.index < right.index;
        fi;

        # G_14 has only one record for each index.
        if left.indexSourcesOnly or right.indexSourcesOnly then
            return false;
        fi;

        if left.fullGroupId <> fail and right.fullGroupId <> fail then
            if left.fullGroupId[1] <> right.fullGroupId[1] then
                return left.fullGroupId[1] < right.fullGroupId[1];
            fi;
            return left.fullGroupId[2] < right.fullGroupId[2];
        fi;

        if left.fullGroupId <> fail then
            return true;
        elif right.fullGroupId <> fail then
            return false;
        fi;

        return left.fullGroupDescription < right.fullGroupDescription;
    end);
end;


#############################################################################
##  3. Main functions
#############################################################################

# Enumerate subgroup conjugacy-class representatives in each maximal group,
# test the normal cyclic quotient condition, and deduplicate only at the end.
GenerateYYZResults := function(symplecticGroups, maximalGroups)
    local rawResults, sourceIndex, sourceStart, sourceElapsedMs, maximalGroup,
          subgroupClasses, class, subgroup, candidate,
          symplecticIndex, symplecticGroup, symplecticOrder, index,
          successfulCount, internalResults, formatted, sourceStats;

    rawResults := [];
    sourceStats := [];

    YYZ_Progress(Concatenation(
        "starting with ", String(Length(maximalGroups)),
        " maximal groups and ", String(Length(symplecticGroups)),
        " symplectic groups."
    ));

    for sourceIndex in [1 .. Length(maximalGroups)] do
        maximalGroup := maximalGroups[sourceIndex];
        sourceStart := Runtime();

        YYZ_Progress(Concatenation(
            MaximalGroupLabels[sourceIndex],
            ": enumerating subgroup conjugacy classes (order ",
            String(Size(maximalGroup)), ") ..."
        ));

        subgroupClasses := ConjugacyClassesSubgroups(maximalGroup);
        successfulCount := 0;

        for class in subgroupClasses do
            subgroup := Representative(class);
            candidate := rec(
                group := subgroup,
                order := Size(subgroup),
                sourceIndex := sourceIndex
            );

            for symplecticIndex in [1 .. Length(symplecticGroups)] do
                symplecticGroup := symplecticGroups[symplecticIndex];
                symplecticOrder := Size(symplecticGroup);

                if candidate.order mod symplecticOrder = 0 then
                    index := candidate.order / symplecticOrder;

                    if YYZ_IsAllowedIndex(index)
                       and YYZ_HasNormalCyclicQuotient(
                           symplecticGroup,
                           candidate
                       ) then
                        successfulCount := successfulCount + 1;

                        if symplecticIndex = 14 then
                            Add(rawResults, rec(
                                symplecticIndex := 14,
                                index := index,
                                sourceIndex := sourceIndex
                            ));
                        else
                            Add(rawResults, rec(
                                symplecticIndex := symplecticIndex,
                                index := index,
                                candidate := candidate,
                                sourceIndex := sourceIndex
                            ));
                        fi;
                    fi;
                fi;
            od;
        od;

        sourceElapsedMs := Runtime() - sourceStart;
        Add(sourceStats, rec(
            sourceIndex := sourceIndex,
            label := MaximalGroupLabels[sourceIndex],
            order := Size(maximalGroup),
            subgroupClassCount := Length(subgroupClasses),
            successfulOccurrences := successfulCount,
            runtimeMilliseconds := sourceElapsedMs
        ));

        YYZ_Progress(Concatenation(
            MaximalGroupLabels[sourceIndex], ": ",
            String(Length(subgroupClasses)), " subgroup classes; ",
            String(successfulCount), " successful occurrences; ",
            String(QuoInt(sourceElapsedMs, 1000)), " s."
        ));
    od;

    YYZ_Progress(Concatenation(
        "search complete: ", String(Length(rawResults)),
        " raw successful occurrences; deduplicating ..."
    ));

    internalResults := YYZ_DeduplicateRawResults(rawResults);
    YYZ_SortInternalResults(internalResults);

    formatted := List(internalResults, r -> [
        SymplecticGroupLabels[r.symplecticIndex],
        r.index,
        r.fullGroupId,
        r.fullGroupDescription,
        List(r.sourceIndices, YYZ_SourceDescriptor)
    ]);

    YYZ_Progress(Concatenation(
        "finished: ", String(Length(formatted)), " output records."
    ));

    YYZRunSummary := rec(
        rawSuccessfulOccurrences := Length(rawResults),
        outputRecordCount := Length(formatted),
        sourceStats := sourceStats
    );

    return formatted;
end;

PrintYYZResults := function(results)
    Print("YYZResults := ", results, ";\n");
end;


#############################################################################
##  4. Audit-report helpers
#############################################################################

YYZ_StringOrDash := function(obj)
    if obj = fail then
        return "-";
    fi;
    return String(obj);
end;

# These are only display names.  They do not enter the calculation.
SymplecticArticleNames := [
    "3^4:A6", "A7", "3^(1+4):2.2^2", "M10", "L2(11)", "A_{3,5}",
    "3^(1+4):2.2", "A6", "L2(7)", "S5", "M9", "N72", "T48",
    "3^(1+4):2", "A_{4,3}", "A5", "3^2.4", "S_{3,3}", "F21",
    "Hol(5)", "QD16", "S4", "Q8", "A_{3,3}", "D12", "A4", "D10",
    "D8", "C4", "S3", "C2^2", "C3", "C2", "1"
];;

YYZMaximalArticleNames := [
    "C3^5 : S6",
    "((C3 x (C3^3 : C3)) : C3) : (C4 x C2)",
    "C8 x (C3^2 : C2)",
    "S5 x (C3^2 : C2)",
    "C48",
    "PSL(2,11) x C3",
    "((C3 x (C3^2 : C3)) : C3) : (C4^2 : C2)",
    "C32",
    "C21 : C6",
    "M10",
    "S7",
    "(C8 x C2) : C2",
    "PSL(3,2) : C2",
    "GL(2,3)",
    "(C3^2 : Q8) : C3"
];;

# If H is a subgroup of a YYZ maximal group M, then |H| divides |M|.
# Thus the following finite list contains every index that can possibly occur
# for a fixed symplectic group, before subgroup structure is tested.
YYZ_OrderAdmissibleIndices := function(symplecticGroup)
    local indices, maximalGroup, quotientOrder, d;

    indices := [];
    for maximalGroup in MaximalGroups do
        if Size(maximalGroup) mod Size(symplecticGroup) = 0 then
            quotientOrder := Size(maximalGroup) / Size(symplecticGroup);
            for d in DivisorsInt(quotientOrder) do
                if YYZ_IsAllowedIndex(d) then
                    AddSet(indices, d);
                fi;
            od;
        fi;
    od;
    return indices;
end;

YYZ_ResultSourcesAsLabels := function(resultRecord)
    return List(resultRecord[5], descriptor -> descriptor[1]);
end;

YYZ_WriteAuditReport := function(filename, results)
    local i, id, description, stat, label, indices, m, matches, r,
          sourceLabels, smallIndices;

    PrintTo(filename,
        "YYZ / Laza--Zheng group-theoretic audit for cubic fourfold automorphisms\n",
        "======================================================================\n\n",
        "Background (brief).\n",
        "Yang--Yu--Zhu classify finite groups acting faithfully on smooth cubic\n",
        "fourfolds by showing that every such group is isomorphic to a subgroup\n",
        "of one of 15 maximal groups.  Laza--Zheng classify the 34 possible\n",
        "symplectic automorphism groups.  In the index calculation used here,\n",
        "Aut^s(X) is normal in Aut(X), the quotient is cyclic, and the admissible\n",
        "index m is required to be 2^a or 3*2^a.\n\n",
        "The calculation below is group-theoretic: a listed group is a necessary\n",
        "candidate inside the YYZ maximal groups, not by itself a geometric\n",
        "realizability statement.  Conversely, a zero count below means that the\n",
        "script searched all subgroup conjugacy classes of all 15 YYZ maximal\n",
        "groups and found no subgroup satisfying the stated normal/cyclic-quotient\n",
        "conditions for that index.\n\n",
        "GAP version: ", GAPInfo.Version, "\n",
        "Output file: ", filename, "\n\n"
    );

    AppendTo(filename, "INPUT A: 15 Yang--Yu--Zhu maximal groups\n");
    AppendTo(filename, "------------------------------------------\n");
    for i in [1 .. Length(MaximalGroups)] do
        id := YYZ_GroupId(MaximalGroups[i]);
        description := YYZ_GroupDescription(MaximalGroups[i], id);
        AppendTo(filename,
            MaximalGroupLabels[i],
            " | article notation: ", YYZMaximalArticleNames[i],
            " | order: ", Size(MaximalGroups[i]),
            " | GAP id: ", YYZ_StringOrDash(id),
            " | GAP description: ", description, "\n"
        );
    od;

    AppendTo(filename, "\nINPUT B: 34 Laza--Zheng symplectic groups\n");
    AppendTo(filename, "------------------------------------------\n");
    for i in [1 .. Length(SymplecticGroups)] do
        id := YYZ_GroupId(SymplecticGroups[i]);
        description := YYZ_GroupDescription(SymplecticGroups[i], id);
        AppendTo(filename,
            SymplecticGroupLabels[i],
            " | article notation: ", SymplecticArticleNames[i],
            " | order: ", Size(SymplecticGroups[i]),
            " | GAP id: ", YYZ_StringOrDash(id),
            " | GAP description: ", description, "\n"
        );
    od;

    AppendTo(filename, "\nRUN SUMMARY\n");
    AppendTo(filename, "-----------\n");
    if YYZRunSummary = fail then
        AppendTo(filename, "Run summary unavailable.\n");
    else
        AppendTo(filename,
            "Raw successful subgroup occurrences before final deduplication: ",
            YYZRunSummary.rawSuccessfulOccurrences, "\n",
            "Final output records: ", YYZRunSummary.outputRecordCount, "\n\n",
            "Per YYZ maximal group:\n"
        );
        for stat in YYZRunSummary.sourceStats do
            AppendTo(filename,
                "  ", stat.label,
                " | order ", stat.order,
                " | subgroup conjugacy classes ", stat.subgroupClassCount,
                " | successful occurrences ", stat.successfulOccurrences,
                " | runtime(ms) ", stat.runtimeMilliseconds, "\n"
            );
        od;
    fi;

    AppendTo(filename,
        "\nCOMPLETE INDEX/CANDIDATE AUDIT\n",
        "------------------------------\n",
        "For each G_i, 'order-admissible indices' are all allowed m for which\n",
        "|G_i|*m divides the order of at least one YYZ maximal group.  Every\n",
        "such m is printed, including those for which the search finds 0\n",
        "candidate full groups.\n\n"
    );

    for i in [1 .. Length(SymplecticGroups)] do
        label := SymplecticGroupLabels[i];
        indices := YYZ_OrderAdmissibleIndices(SymplecticGroups[i]);
        AppendTo(filename,
            "[", label, "] ", SymplecticArticleNames[i],
            " | order ", Size(SymplecticGroups[i]), "\n",
            "order-admissible indices: ", indices, "\n"
        );

        for m in indices do
            matches := Filtered(
                results,
                r -> r[1] = label and r[2] = m
            );
            AppendTo(filename,
                "  m = ", m, " : ", Length(matches), " output record(s)\n"
            );

            if Length(matches) = 0 then
                AppendTo(filename, "    NONE\n");
            else
                for r in matches do
                    sourceLabels := YYZ_ResultSourcesAsLabels(r);
                    AppendTo(filename,
                        "    id = ", YYZ_StringOrDash(r[3]),
                        " | description = ", YYZ_StringOrDash(r[4]),
                        " | sources = ", sourceLabels, "\n"
                    );
                od;
            fi;
        od;
        AppendTo(filename, "\n");
    od;

    # The low-rank cases are the ones used most directly in the later
    # representation enumeration, so print a compact pointer to them.
    AppendTo(filename,
        "LOW-RANK POINTER\n",
        "----------------\n",
        "The small symplectic groups relevant for the later low-rank analysis are:\n",
        "  G_29 = C4, G_30 = S3, G_31 = C2^2, G_32 = C3.\n",
        "Their complete index/candidate rows appear above; zero rows are explicit.\n\n"
    );

    AppendTo(filename,
        "SPECIAL CONVENTION FOR G_14\n",
        "---------------------------\n",
        "For G_14 = 3^(1+4):2, full groups are deliberately not identified.\n",
        "Occurrences are merged only by index and source.  Thus one G_14 row\n",
        "may stand for more than one non-isomorphic full group.\n\n"
    );

    AppendTo(filename,
        "MACHINE-READABLE GAP OBJECT\n",
        "---------------------------\n",
        "YYZResults := ", results, ";\n"
    );
end;


#############################################################################
##  5. Run
#############################################################################

YYZResults := GenerateYYZResults(SymplecticGroups, MaximalGroups);;
PrintYYZResults(YYZResults);
YYZ_WriteAuditReport(YYZ_OUTPUT_FILE, YYZResults);;
YYZ_Progress(Concatenation(
    "audit report written to ", YYZ_OUTPUT_FILE
));;
AppendTo(YYZ_LOG_FILE,
    "\nFINAL SUMMARY\n",
    "-------------\n",
    "Raw successful subgroup occurrences: ",
    YYZRunSummary.rawSuccessfulOccurrences, "\n",
    "Final output records: ", YYZRunSummary.outputRecordCount, "\n",
    "Total runtime(ms): ", Runtime() - YYZ_RUN_START_MS, "\n",
    "Audit output: ", YYZ_OUTPUT_FILE, "\n",
    "Log output: ", YYZ_LOG_FILE, "\n"
);;
Print("# [YYZ] audit report written to ", YYZ_OUTPUT_FILE, "\n");
Print("# [YYZ] log written to ", YYZ_LOG_FILE, "\n");
