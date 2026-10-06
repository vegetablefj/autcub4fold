#############################################################################
## Exact projective primitive-H4 character of No. 106.
## Run from autcub4fold/remark/catalogue. The direct strict
## No. 106 -> No. 67 linear-conjugacy witness is checked first.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

Restrict106Output := "restriction_106_geometric_character.tsv";
Restrict106Omega := E(3)*IdentityMat(6);
Restrict106Scalars := [IdentityMat(6), Restrict106Omega, Restrict106Omega^2];

Restrict106Trace := function(g)
    local dimensions, value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions, k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

Restrict106ProjectiveOrder := function(g)
    local k, power;
    power := IdentityMat(6);
    for k in [1..3] do
        power := power*g;
        if power in Restrict106Scalars then return k; fi;
    od;
    Error("Projective order exceeds three");
end;

Restrict106Character := function()
    local child, parent, source, target, edges, edge, image, seen,
          histogram, g, scalar, key, position;
    child := Families[106]; parent := Families[67];
    if child.number <> 106 or parent.number <> 67
       or child.familyDimension <> 8 or parent.familyDimension <> 2
       or child.projectiveGroupId <> [3,1]
       or parent.projectiveGroupId <> [36,11]
       or child.reportedOrder <> 9 or parent.reportedOrder <> 108 then
        Error("Frozen family number, dimension, group ID, or order changed");
    fi;
    source := Group(child.generators);
    target := Group(parent.generators);
    if Size(source) <> 9 or Size(target) <> 108
       or not Restrict106Omega in source
       or not Restrict106Omega in target then
        Error("Unexpected linear group or scalar kernel");
    fi;
    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = 106 and r.targetNumber = 67
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct" and r.direct = true);
    if Length(edges) <> 1 then
        Error("Missing unique direct strict containment witness");
    fi;
    edge := edges[1];
    if edge.sourceOrder <> 9 or edge.targetOrder <> 108
       or edge.sourceDimension <> 8 or edge.targetDimension <> 2
       or not edge.method in ["literal_matrix_subgroup", "A_strict"] then
        Error("Strict containment witness metadata changed");
    fi;
    image := Group(List(child.generators, h -> edge.P^-1*h*edge.P));
    if not IsSubgroup(target, image) then
        Error("Saved conjugating matrix does not embed No. 106");
    fi;

    seen := []; histogram := [];
    for g in Elements(source) do
        if g in seen then continue; fi;
        for scalar in Restrict106Scalars do
            if Restrict106Trace(scalar*g) <> Restrict106Trace(g) then
                Error("Primitive trace depends on scalar lift");
            fi;
            Add(seen, scalar*g);
        od;
        key := [Restrict106ProjectiveOrder(g), Restrict106Trace(g)];
        position := PositionProperty(histogram,
            row -> row[1] = key[1] and row[2] = key[2]);
        if position = fail then
            Add(histogram, [key[1], key[2], 1]);
        else
            histogram[position][3] := histogram[position][3] + 1;
        fi;
    od;
    if Length(Set(seen)) <> 9
       or Sum(histogram, row -> row[3]) <> 3
       or Position(histogram, [1,22,1]) = fail then
        Error("Incomplete projective character");
    fi;
    Sort(histogram, function(a,b)
        if a[1] <> b[1] then return a[1] < b[1]; fi;
        return a[2] < b[2];
    end);
    return histogram;
end;

if Restrict106Trace(IdentityMat(6)) <> 22 then
    Error("The identity primitive trace must be 22");
fi;
if IsExistingFile(Restrict106Output) then
    Error("Refusing to overwrite the character TSV");
fi;
Restrict106Rows := Restrict106Character();
PrintTo(Restrict106Output,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for Restrict106Row in Restrict106Rows do
    AppendTo(Restrict106Output,
        106, "\t", Restrict106Row[1], "\t",
        Restrict106Row[2], "\t", Restrict106Row[3], "\n");
od;
Print("No. 106 projective character=", Restrict106Rows, "\n");
Print("Saved ", Restrict106Output, "\n");
