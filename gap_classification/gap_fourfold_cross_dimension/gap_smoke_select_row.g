#############################################################################
## Diagnostic summary of selected small-row workloads.
##
## This script prints eligible-pair counts for a fixed diagnostic sample. It
## performs no embedding search and writes no catalogue or result file.
#############################################################################

Read("gap_cross_dimension_common.g");
Read("input/fourfold_small.g");
for position in [1 .. Length(Families)] do
    count := Length(Filtered(
        [1 .. Length(Families)],
        target -> position <> target
                  and Families[position].familyDimension
                      > Families[target].familyDimension
                  and Families[target].reportedOrder
                      mod Families[position].reportedOrder = 0
    ));
    if position in [25, 26, 29, 30, 34] then
        Print([
            position,
            Families[position].number,
            Families[position].familyDimension,
            Families[position].reportedOrder,
            count
        ], "\n");
        for target in Filtered(
            [1 .. Length(Families)],
            target -> position <> target
                      and Families[position].familyDimension
                          > Families[target].familyDimension
                      and Families[target].reportedOrder
                          mod Families[position].reportedOrder = 0
        ) do
            Print(
                "  ", Families[position].number, " -> ",
                Families[target].number, " ids=",
                Families[position].linearGroupId, " -> ",
                Families[target].linearGroupId, " abstract=",
                AbstractEmbedsById(
                    Families[position].linearGroupId,
                    Families[target].linearGroupId
                ), "\n"
            );
        od;
    fi;
od;
QUIT_GAP(0);
