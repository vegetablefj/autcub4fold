#############################################################################
## Exact projective primitive-H4 character of No. 110.
## Run from autcub4fold/remark/catalogue. First verify the saved
## direct strict No. 110 -> No. 67 linear-conjugacy witness.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

Restrict110Output := "restriction_110_geometric_character.tsv";
Restrict110Omega := E(3)*IdentityMat(6);
Restrict110Scalars := [IdentityMat(6), Restrict110Omega, Restrict110Omega^2];

Restrict110Trace := function(g)
    local dimensions, value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions, k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

Restrict110ProjectiveOrder := function(g)
    local k, power;
    power := IdentityMat(6);
    for k in [1..9] do
        power := power*g;
        if power in Restrict110Scalars then return k; fi;
    od;
    Error("Projective order exceeds nine");
end;

Restrict110Character := function()
    local child, parent, source, target, edges, edge, image, seen,
          histogram, g, scalar, key, position;
    child := Families[110]; parent := Families[67];
    if child.number <> 110 or parent.number <> 67
       or child.familyDimension <> 4 or parent.familyDimension <> 2
       or child.projectiveGroupId <> [9,2]
       or parent.projectiveGroupId <> [36,11]
       or child.reportedOrder <> 27 or parent.reportedOrder <> 108 then
        Error("Frozen family number, dimension, group ID, or order changed");
    fi;
    source := Group(child.generators);
    target := Group(parent.generators);
    if Size(source) <> 27 or Size(target) <> 108
       or not Restrict110Omega in source
       or not Restrict110Omega in target then
        Error("Unexpected linear group or scalar kernel");
    fi;
    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = 110 and r.targetNumber = 67
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct" and r.direct = true);
    if Length(edges) <> 1 then
        Error("Missing unique direct strict containment witness");
    fi;
    edge := edges[1];
    if edge.sourceOrder <> 27 or edge.targetOrder <> 108
       or edge.sourceDimension <> 4 or edge.targetDimension <> 2
       or not edge.method in ["literal_matrix_subgroup", "A_strict"] then
        Error("Strict containment witness metadata changed");
    fi;
    image := Group(List(child.generators, h -> edge.P^-1*h*edge.P));
    if not IsSubgroup(target, image) then
        Error("Saved conjugating matrix does not embed No. 110");
    fi;

    seen := []; histogram := [];
    for g in Elements(source) do
        if g in seen then continue; fi;
        for scalar in Restrict110Scalars do
            if Restrict110Trace(scalar*g) <> Restrict110Trace(g) then
                Error("Primitive trace depends on scalar lift");
            fi;
            Add(seen, scalar*g);
        od;
        key := [Restrict110ProjectiveOrder(g), Restrict110Trace(g)];
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

if Restrict110Trace(IdentityMat(6)) <> 22 then
    Error("The identity primitive trace must be 22");
fi;
if IsExistingFile(Restrict110Output) then
    Error("Refusing to overwrite the character TSV");
fi;
Restrict110Rows := Restrict110Character();
PrintTo(Restrict110Output,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for Restrict110Row in Restrict110Rows do
    AppendTo(Restrict110Output,
        110, "\t", Restrict110Row[1], "\t",
        Restrict110Row[2], "\t", Restrict110Row[3], "\n");
od;
Print("No. 110 projective character=", Restrict110Rows, "\n");
Print("Saved ", Restrict110Output, "\n");
