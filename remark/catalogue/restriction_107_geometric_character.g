#############################################################################
## Exact projective primitive-H4 character of No. 107.
## Run from autcub4fold/remark/catalogue. The direct strict
## No. 107 -> No. 60 linear-conjugacy witness is checked first.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

Restrict107Output := "restriction_107_geometric_character.tsv";
Restrict107Omega := E(3)*IdentityMat(6);
Restrict107Scalars := [IdentityMat(6), Restrict107Omega, Restrict107Omega^2];

Restrict107Trace := function(g)
    local dimensions, value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions, k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

Restrict107ProjectiveOrder := function(g)
    local k, power;
    power := IdentityMat(6);
    for k in [1..6] do
        power := power*g;
        if power in Restrict107Scalars then return k; fi;
    od;
    Error("Projective order exceeds six");
end;

Restrict107Character := function()
    local child, parent, source, target, edges, edge, image, seen,
          histogram, g, scalar, key, position;
    child := Families[107]; parent := Families[60];
    if child.number <> 107 or parent.number <> 60
       or child.familyDimension <> 4 or parent.familyDimension <> 2
       or child.projectiveGroupId <> [6,1]
       or parent.projectiveGroupId <> [24,14]
       or child.linearGroupId <> [18,3]
       or parent.linearGroupId <> [72,48]
       or child.reportedOrder <> 18 or parent.reportedOrder <> 72 then
        Error("Frozen family number, dimension, group ID, or order changed");
    fi;
    source := Group(child.generators);
    target := Group(parent.generators);
    if Size(source) <> 18 or Size(target) <> 72
       or not Restrict107Omega in source
       or not Restrict107Omega in target then
        Error("Unexpected linear group or scalar kernel");
    fi;
    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = 107 and r.targetNumber = 60
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct" and r.direct = true);
    if Length(edges) <> 1 then
        Error("Missing unique direct strict containment witness");
    fi;
    edge := edges[1];
    if edge.sourceOrder <> 18 or edge.targetOrder <> 72
       or edge.sourceDimension <> 4 or edge.targetDimension <> 2
       or not edge.method in ["literal_matrix_subgroup", "A_strict"] then
        Error("Strict containment witness metadata changed");
    fi;
    image := Group(List(child.generators, h -> edge.P^-1*h*edge.P));
    if Size(image) <> 18 or not IsSubgroup(target, image) then
        Error("Saved conjugating matrix does not embed No. 107");
    fi;

    seen := []; histogram := [];
    for g in Elements(source) do
        if g in seen then continue; fi;
        for scalar in Restrict107Scalars do
            if Restrict107Trace(scalar*g) <> Restrict107Trace(g) then
                Error("Primitive trace depends on scalar lift");
            fi;
            Add(seen, scalar*g);
        od;
        key := [Restrict107ProjectiveOrder(g), Restrict107Trace(g)];
        position := PositionProperty(histogram,
            row -> row[1] = key[1] and row[2] = key[2]);
        if position = fail then
            Add(histogram, [key[1], key[2], 1]);
        else
            histogram[position][3] := histogram[position][3] + 1;
        fi;
    od;
    if Length(Set(seen)) <> 18
       or Sum(histogram, row -> row[3]) <> 6
       or Position(histogram, [1,22,1]) = fail then
        Error("Incomplete projective character");
    fi;
    Sort(histogram, function(a,b)
        if a[1] <> b[1] then return a[1] < b[1]; fi;
        return a[2] < b[2];
    end);
    return histogram;
end;

if Restrict107Trace(IdentityMat(6)) <> 22 then
    Error("The identity primitive trace must be 22");
fi;
if IsExistingFile(Restrict107Output) then
    Error("Refusing to overwrite the character TSV");
fi;
Restrict107Rows := Restrict107Character();
PrintTo(Restrict107Output,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for Restrict107Row in Restrict107Rows do
    AppendTo(Restrict107Output,
        107, "\t", Restrict107Row[1], "\t",
        Restrict107Row[2], "\t", Restrict107Row[3], "\n");
od;
Print("No. 107 projective character=", Restrict107Rows, "\n");
Print("Saved ", Restrict107Output, "\n");
