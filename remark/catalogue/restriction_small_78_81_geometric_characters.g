#############################################################################
## Exact primitive-H4 characters for six small subgroup restrictions.
## Run with GAP from autcub4fold/remark/catalogue.  The frozen
## fourfold_156.g matrices are strict form-fixing lifts.  The Chenevert trace
## formula is invariant under the central cubic scalars, which is checked
## below for every element.  The saved cross-dimension matrices certify the
## particular strict linear containments used by the OSCAR script.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");
Read("../../gap_classification/gap_liftable_abelian/gap_liftable_abelian_data.g");
Read("../input/family_generators.g");

SmallRestrictionSpecs := [
    [77,78,6,5,4,1], [119,78,12,5,2,1],
    [120,78,10,5,4,2], [122,78,6,5,4,2],
    [79,81,4,2,8,2], [124,81,5,2,8,4]
];
SmallRestrictionOutput := "restriction_small_78_81_geometric_characters.tsv";
SmallRestrictionOmega := E(3)*IdentityMat(6);
SmallRestrictionScalars := [IdentityMat(6), SmallRestrictionOmega,
                            SmallRestrictionOmega^2];

SmallRestrictionTrace := function(g)
    local dimensions, value, alpha;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions, k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

SmallRestrictionProjectiveOrder := function(g)
    local k, power;
    power := IdentityMat(6);
    for k in [1..24] do
        power := power*g;
        if power in SmallRestrictionScalars then
            return k;
        fi;
    od;
    Error("Projective order exceeds the checked bound");
end;

SmallRestrictionOne := function(spec)
    local child, parent, childDimension, parentDimension, projectiveOrder,
          quotientOrder, source, target, edge, image, elements, seen,
          histogram, g, scalar, key, position, row, targetOrder;
    child := spec[1]; parent := spec[2];
    childDimension := spec[3]; parentDimension := spec[4];
    projectiveOrder := spec[5]; quotientOrder := spec[6];
    if Families[child].number <> child or Families[parent].number <> parent
       or Families[child].familyDimension <> childDimension
       or Families[parent].familyDimension <> parentDimension then
        Error("Frozen geometric family number/dimension changed");
    fi;
    source := Group(Families[child].generators);
    target := Group(Families[parent].generators);
    if parent = 78 then targetOrder := 24;
    else targetOrder := 48; fi;
    if Size(source) <> 3*projectiveOrder
       or Size(target) <> targetOrder
       or not SmallRestrictionOmega in source
       or not SmallRestrictionOmega in target then
        Error("Unexpected strict linear group or scalar kernel");
    fi;
    edge := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = child and r.targetNumber = parent
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct");
    if Length(edge) <> 1 then
        Error("Missing unique strict linear containment witness");
    fi;
    edge := edge[1];
    if edge.sourceOrder <> Size(source) or edge.targetOrder <> Size(target)
       or edge.sourceDimension <> childDimension
       or edge.targetDimension <> parentDimension
       or not edge.method in ["literal_matrix_subgroup", "A_strict"] then
        Error("Strict containment witness metadata changed");
    fi;
    image := Group(List(Families[child].generators,
        g -> edge.P^-1 * g * edge.P));
    if not IsSubgroup(target, image) then
        Error("Saved strict linear conjugating matrix is not a witness");
    fi;

    elements := Elements(source);
    seen := [];
    histogram := [];
    for g in elements do
        if g in seen then
            continue;
        fi;
        for scalar in SmallRestrictionScalars do
            if SmallRestrictionTrace(scalar*g) <> SmallRestrictionTrace(g) then
                Error("Primitive trace depends on scalar lift");
            fi;
            Add(seen, scalar*g);
        od;
        key := [SmallRestrictionProjectiveOrder(g),
                SmallRestrictionTrace(g)];
        position := PositionProperty(histogram,
            row -> row[1] = key[1] and row[2] = key[2]);
        if position = fail then
            Add(histogram, [key[1], key[2], 1]);
        else
            histogram[position][3] := histogram[position][3] + 1;
        fi;
    od;
    if Length(Set(seen)) <> Size(source)
       or Sum(histogram, row -> row[3]) <> projectiveOrder
       or Position(histogram, [1,22,1]) = fail then
        Error("Projective character enumeration is incomplete");
    fi;
    Sort(histogram, function(a,b)
        if a[1] <> b[1] then return a[1] < b[1]; fi;
        return a[2] < b[2];
    end);
    for row in histogram do
        AppendTo(SmallRestrictionOutput, child, "\t", row[1], "\t",
                 row[2], "\t", row[3], "\n");
    od;
    Print("GEOMETRIC_CHARACTER family=", child,
          " parent=", parent, " quotient=", quotientOrder,
          " projective_order=", projectiveOrder,
          " bins=", histogram, "\n");
end;

if SmallRestrictionTrace(IdentityMat(6)) <> 22 then
    Error("The identity primitive trace must be 22");
fi;
PrintTo(SmallRestrictionOutput,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for SmallRestrictionSpec in SmallRestrictionSpecs do
    SmallRestrictionOne(SmallRestrictionSpec);
od;

## At the smooth block cubic F0 = x1^2*x2+x2^2*x3+x3^3
##                              +x4^2*x5+x5^2*x6+x6^3,
## swapping the two blocks is an actual cubic automorphism.  It exchanges
## the two same-character C2-intersection subgroups of the No. 81 action.
## These A,C coordinates are the LA-044 block model, not the canonical
## coordinates in fourfold_156.g; only the abstract group and character
## comparisons above use the latter file.
SmallRestrictionA := DiagonalMat([1,1,1,E(4)^3,-1,1]);
SmallRestrictionC := DiagonalMat([E(4)^3,-1,1,1,1,1]);
SmallRestrictionP := [
    [0,0,0,1,0,0], [0,0,0,0,1,0], [0,0,0,0,0,1],
    [1,0,0,0,0,0], [0,1,0,0,0,0], [0,0,1,0,0,0]
];
SmallRestrictionFull81 := Group([SmallRestrictionOmega,
                                 SmallRestrictionA,SmallRestrictionC]);
SmallRestrictionHA := Group([SmallRestrictionOmega,
    SmallRestrictionA^2,SmallRestrictionC]);
SmallRestrictionHC := Group([SmallRestrictionOmega,
    SmallRestrictionA,SmallRestrictionC^2]);
SmallRestrictionLA44 := Filtered(LiftableAbelianCandidates,
    r -> r.label = "LA-044");
SmallRestrictionLA22 := Filtered(LiftableAbelianCandidates,
    r -> r.label = "LA-022");
if Size(SmallRestrictionFull81) <> 48
   or Length(SmallRestrictionLA44) <> 1
   or Length(SmallRestrictionLA22) <> 1
   or SmallRestrictionFull81 <> SmallRestrictionLA44[1].group
   or SmallRestrictionHA <> SmallRestrictionLA22[1].group
   or Size(SmallRestrictionHA) <> 24
   or Size(SmallRestrictionHC) <> 24
   or SmallRestrictionHA = SmallRestrictionHC
   or Group(List(GeneratorsOfGroup(SmallRestrictionHA),
       g -> SmallRestrictionP^-1*g*SmallRestrictionP)) <> SmallRestrictionHC
   or SmallRestrictionP^-1*SmallRestrictionA*SmallRestrictionP <> SmallRestrictionC
   or SmallRestrictionP^-1*SmallRestrictionC*SmallRestrictionP <> SmallRestrictionA then
    Error("No. 124 block-swap conjugacy certificate failed");
fi;
SmallRestrictionBridge81 := Filtered(CanonicalFamilyMatrixGroups,
    r -> r.number = 81);
SmallRestrictionBridge124 := Filtered(CanonicalFamilyMatrixGroups,
    r -> r.number = 124);
if Length(SmallRestrictionBridge81) <> 1
   or Length(SmallRestrictionBridge124) <> 1 then
    Error("Missing numbered-family source coordinate map");
fi;
SmallRestrictionBridge81 := SmallRestrictionBridge81[1];
SmallRestrictionBridge124 := SmallRestrictionBridge124[1];
if Group(List(GeneratorsOfGroup(SmallRestrictionFull81),
        g -> SmallRestrictionBridge81.sourceToStandardMatrix^-1*g*
             SmallRestrictionBridge81.sourceToStandardMatrix)) =
        Group(Families[81].generators)
   and Group(List(GeneratorsOfGroup(SmallRestrictionHA),
        g -> SmallRestrictionBridge124.sourceToStandardMatrix^-1*g*
             SmallRestrictionBridge124.sourceToStandardMatrix)) =
        Group(Families[124].generators) then
    Print("NO124_SOURCE_BRIDGE parent=81 child=124 verified=true\n");
else
    Error("Stored source-to-standard matrices do not bridge LA records");
fi;
Print("NO124_BLOCK_SWAP_CONJUGACY parent=81 source=124 verified=true\n");
Print("Saved ", SmallRestrictionOutput, "\n");
