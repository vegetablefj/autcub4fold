#############################################################################
## Exact projective primitive-H4 character of No. 111.
## Run from autcub4fold/remark/catalogue. The strict No. 111 -> No. 18
## GL(6) witness is checked before any output is written.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

Restrict111Output := "restriction_111_geometric_character.tsv";
Restrict111Omega := E(3)*IdentityMat(6);
Restrict111Scalars := [IdentityMat(6), Restrict111Omega, Restrict111Omega^2];

Restrict111Trace := function(g)
    local dimensions, value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions, k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

Restrict111ProjectiveOrder := function(g)
    local k, power;
    power := IdentityMat(6);
    for k in [1..9] do
        power := power*g;
        if power in Restrict111Scalars then return k; fi;
    od;
    Error("Projective order exceeds nine");
end;

Restrict111Character := function()
    local child, parent, source, target, edges, edge, image, seen,
          histogram, g, scalar, key, position;
    child := Families[111]; parent := Families[18];
    if child.number <> 111 or parent.number <> 18
       or child.familyDimension <> 3 or parent.familyDimension <> 0
       or child.projectiveGroupId <> [9,2]
       or child.reportedOrder <> 27 or parent.reportedOrder <> 648 then
        Error("Frozen family number, dimension, group ID, or order changed");
    fi;
    source := Group(child.generators);
    target := Group(parent.generators);
    if Size(source) <> 27 or Size(target) <> 648
       or not Restrict111Omega in source
       or not Restrict111Omega in target then
        Error("Unexpected linear group or scalar kernel");
    fi;
    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = 111 and r.targetNumber = 18
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct" and r.direct = true);
    if Length(edges) <> 1 then
        Error("Missing unique direct strict containment witness");
    fi;
    edge := edges[1];
    if edge.sourceOrder <> 27 or edge.targetOrder <> 648
       or edge.sourceDimension <> 3 or edge.targetDimension <> 0
       or not edge.method in ["literal_matrix_subgroup", "A_strict"] then
        Error("Strict containment witness metadata changed");
    fi;
    image := Group(List(child.generators, h -> edge.P^-1*h*edge.P));
    if not IsSubgroup(target, image) then
        Error("Saved conjugating matrix does not embed No. 111");
    fi;

    seen := []; histogram := [];
    for g in Elements(source) do
        if g in seen then continue; fi;
        for scalar in Restrict111Scalars do
            if Restrict111Trace(scalar*g) <> Restrict111Trace(g) then
                Error("Primitive trace depends on scalar lift");
            fi;
            Add(seen, scalar*g);
        od;
        key := [Restrict111ProjectiveOrder(g), Restrict111Trace(g)];
        position := PositionProperty(histogram,
            row -> row[1] = key[1] and row[2] = key[2]);
        if position = fail then
            Add(histogram, [key[1], key[2], 1]);
        else
            histogram[position][3] := histogram[position][3] + 1;
        fi;
    od;
    if Length(Set(seen)) <> 27
       or Sum(histogram, row -> row[3]) <> 9
       or Position(histogram, [1,22,1]) = fail then
        Error("Incomplete projective character");
    fi;
    Sort(histogram, function(a,b)
        if a[1] <> b[1] then return a[1] < b[1]; fi;
        return a[2] < b[2];
    end);
    return histogram;
end;

if Restrict111Trace(IdentityMat(6)) <> 22 then
    Error("The identity primitive trace must be 22");
fi;
if IsExistingFile(Restrict111Output) then
    Error("Refusing to overwrite the character TSV");
fi;
Restrict111Rows := Restrict111Character();
PrintTo(Restrict111Output,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for Restrict111Row in Restrict111Rows do
    AppendTo(Restrict111Output,
        111, "\t", Restrict111Row[1], "\t",
        Restrict111Row[2], "\t", Restrict111Row[3], "\n");
od;
Print("No. 111 projective character=", Restrict111Rows, "\n");
Print("Saved ", Restrict111Output, "\n");
