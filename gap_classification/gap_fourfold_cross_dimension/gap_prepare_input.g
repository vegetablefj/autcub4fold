#############################################################################
## Freeze the final 156-family catalogue used by the cross-dimensional run.
#############################################################################

Read("gap_cross_dimension_common.g");
Read("input/fourfold_search_catalogue.g");

if Length(CanonicalFamilyMatrixGroups) <> 156 then
    Error("Expected 156 final fourfold families.");
fi;
if List(CanonicalFamilyMatrixGroups, family -> family.number) <> [1 .. 156] then
    Error("The final family numbering must be exactly 1 through 156.");
fi;

Families := [];
for family in CanonicalFamilyMatrixGroups do
    if not IsBound(family.familyDimension)
       or not IsBound(family.linearGroupId)
       or not IsBound(family.projectiveGroupId)
       or not IsBound(family.matrixGenerators)
       or Length(family.matrixGenerators) = 0 then
        Error("Incomplete canonical record at family ", family.number, ".");
    fi;
    if CF_MatrixListDimension(family.matrixGenerators) <> 6 then
        Error("Family ", family.number, " is not represented in GL(6)." );
    fi;
    if not IsBound(family.fullGroupVerified)
       or family.fullGroupVerified <> true then
        Error("The full linear group is unverified at family ", family.number, ".");
    fi;
    if not IsBound(family.determinantKernelVerified)
       or family.determinantKernelVerified <> true then
        Error("The determinant kernel is unverified at family ", family.number, ".");
    fi;
    Add(Families, rec(
        number := family.number,
        familyDimension := family.familyDimension,
        reportedOrder := family.linearGroupId[1],
        linearGroupId := family.linearGroupId,
        projectiveGroupId := family.projectiveGroupId,
        generators := family.matrixGenerators
    ));
od;

## The canonical input has already verified every full linear group and its
## determinant kernel.  Each group that enters a pairwise comparison is also
## independently preprocessed by CFCD_PreprocessFamily in that GAP task.  We
## therefore avoid constructing all 156 permutation models once more here.

SmallFamilies := Filtered(
    Families,
    family -> family.reportedOrder <= 2000
);
LargeFamilies := Filtered(
    Families,
    family -> family.reportedOrder > 2000
);

Sort(LargeFamilies, function(first, second)
    if first.familyDimension <> second.familyDimension then
        return first.familyDimension > second.familyDimension;
    fi;
    if first.reportedOrder <> second.reportedOrder then
        return first.reportedOrder < second.reportedOrder;
    fi;
    return first.number < second.number;
end);

if Length(SmallFamilies) <> 142 or Length(LargeFamilies) <> 14 then
    Error(
        "Unexpected small/large split: ", Length(SmallFamilies), "/",
        Length(LargeFamilies), "."
    );
fi;

eligibleCount := 0;
smallEligibleCount := 0;
for source in Families do
    for target in Families do
        if source.number <> target.number
           and source.familyDimension > target.familyDimension
           and target.reportedOrder mod source.reportedOrder = 0 then
            eligibleCount := eligibleCount + 1;
            if source in SmallFamilies and target in SmallFamilies then
                smallEligibleCount := smallEligibleCount + 1;
            fi;
        fi;
    od;
od;
if eligibleCount <> 6568 or smallEligibleCount <> 5131 then
    Error(
        "Unexpected eligible-pair counts: ", eligibleCount, "/",
        smallEligibleCount, "."
    );
fi;

CFCD_WriteAssignment("input/fourfold_156.g", "Families", Families);
CFCD_WriteAssignment("input/fourfold_small.g", "Families", SmallFamilies);
CFCD_WriteAssignment(
    "input/large_target_schedule.g",
    "LargeTargetSchedule",
    List([1 .. Length(LargeFamilies)], position -> rec(
        layer := position,
        number := LargeFamilies[position].number,
        familyDimension := LargeFamilies[position].familyDimension,
        reportedOrder := LargeFamilies[position].reportedOrder
    ))
);

PrintTo(
    "input/input_manifest.txt",
    "source=input/fourfold_search_catalogue.g\n",
    "families=", Length(Families), "\n",
    "small_order_threshold=2000\n",
    "small_families=", Length(SmallFamilies), "\n",
    "large_families=", Length(LargeFamilies), "\n",
    "eligible_cross_dimension_pairs=", eligibleCount, "\n",
    "eligible_small_pairs=", smallEligibleCount, "\n",
    "large_target_numbers=", List(LargeFamilies, family -> family.number), "\n"
);

Print(
    "INPUT_READY families=156 small=142 large=14 eligible=6568 ",
    "small_eligible=5131\n"
);
QUIT_GAP(0);
