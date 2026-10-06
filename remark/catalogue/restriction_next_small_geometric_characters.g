#############################################################################
## Exact primitive-H4 characters for four next small restrictions.
## Run with GAP from autcub4fold/remark/catalogue. This script checks
## the saved strict GL(6) containment witness before writing any character.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

NextSmallSpecs := [
    [80,51,3,1,8,32],
    [121,74,8,4,4,16],
    [123,95,6,1,6,72],
    [126,50,4,1,6,24]
];
NextSmallOutput := "restriction_next_small_geometric_characters.tsv";
NextSmallOmega := E(3)*IdentityMat(6);
NextSmallScalars := [IdentityMat(6), NextSmallOmega, NextSmallOmega^2];

NextSmallTrace := function(g)
    local dimensions, value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions, k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

NextSmallProjectiveOrder := function(g)
    local k, power;
    power := IdentityMat(6);
    for k in [1..24] do
        power := power*g;
        if power in NextSmallScalars then
            return k;
        fi;
    od;
    Error("Projective order exceeds 24");
end;

NextSmallOne := function(spec)
    local child, parent, childDimension, parentDimension, childOrder,
          parentOrder, source, target, edges, edge, image, seen, histogram,
          g, scalar, key, position, row;
    child := spec[1]; parent := spec[2];
    childDimension := spec[3]; parentDimension := spec[4];
    childOrder := spec[5]; parentOrder := spec[6];
    if Families[child].number <> child or Families[parent].number <> parent
       or Families[child].familyDimension <> childDimension
       or Families[parent].familyDimension <> parentDimension then
        Error("Frozen family numbering or dimension changed");
    fi;
    source := Group(Families[child].generators);
    target := Group(Families[parent].generators);
    if Size(source) <> 3*childOrder or Size(target) <> 3*parentOrder
       or not NextSmallOmega in source or not NextSmallOmega in target then
        Error("Unexpected strict linear group or scalar kernel");
    fi;
    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = child and r.targetNumber = parent
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct");
    if Length(edges) <> 1 then
        Error("Missing unique strict linear containment witness");
    fi;
    edge := edges[1];
    if edge.sourceOrder <> Size(source) or edge.targetOrder <> Size(target)
       or edge.sourceDimension <> childDimension
       or edge.targetDimension <> parentDimension
       or not edge.method in ["literal_matrix_subgroup", "A_strict"] then
        Error("Strict containment witness metadata changed");
    fi;
    image := Group(List(Families[child].generators,
        g -> edge.P^-1 * g * edge.P));
    if not IsSubgroup(target, image) then
        Error("Saved conjugating matrix does not embed the child");
    fi;

    seen := []; histogram := [];
    for g in Elements(source) do
        if g in seen then continue; fi;
        for scalar in NextSmallScalars do
            if NextSmallTrace(scalar*g) <> NextSmallTrace(g) then
                Error("Primitive trace depends on scalar lift");
            fi;
            Add(seen, scalar*g);
        od;
        key := [NextSmallProjectiveOrder(g), NextSmallTrace(g)];
        position := PositionProperty(histogram,
            row -> row[1] = key[1] and row[2] = key[2]);
        if position = fail then
            Add(histogram, [key[1], key[2], 1]);
        else
            histogram[position][3] := histogram[position][3] + 1;
        fi;
    od;
    if Length(Set(seen)) <> Size(source)
       or Sum(histogram, row -> row[3]) <> childOrder
       or Position(histogram, [1,22,1]) = fail then
        Error("Incomplete projective character");
    fi;
    Sort(histogram, function(a,b)
        if a[1] <> b[1] then return a[1] < b[1]; fi;
        return a[2] < b[2];
    end);
    for row in histogram do
        AppendTo(NextSmallOutput, child, "\t", row[1], "\t",
                 row[2], "\t", row[3], "\n");
    od;
    Print("family=", child, " parent=", parent,
          " projective character=", histogram, "\n");
end;

if NextSmallTrace(IdentityMat(6)) <> 22 then
    Error("The identity primitive trace must be 22");
fi;
PrintTo(NextSmallOutput,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for NextSmallSpec in NextSmallSpecs do
    NextSmallOne(NextSmallSpec);
od;
Print("Saved ", NextSmallOutput, "\n");
