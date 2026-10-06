#############################################################################
## Exact projective primitive-H4 character of No. 87.
## Run from autcub4fold/remark/catalogue. The strict No. 87 -> No. 18
## GL(6) witness is checked before any output is written.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

Restrict87Output := "restriction_87_geometric_character.tsv";
Restrict87Omega := E(3)*IdentityMat(6);
Restrict87Scalars := [IdentityMat(6), Restrict87Omega, Restrict87Omega^2];

Restrict87Trace := function(g)
    local dimensions, value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions, k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

Restrict87ProjectiveOrder := function(g)
    local k, power;
    power := IdentityMat(6);
    for k in [1..18] do
        power := power*g;
        if power in Restrict87Scalars then return k; fi;
    od;
    Error("Projective order exceeds group order 18");
end;

Restrict87Character := function()
    local child, parent, source, target, edges, edge, image, seen,
          histogram, g, scalar, key, position;
    child := Families[87]; parent := Families[18];
    if child.number <> 87 or parent.number <> 18
       or child.familyDimension <> 2 or parent.familyDimension <> 0
       or child.projectiveGroupId <> [18,3]
       or child.reportedOrder <> 54 or parent.reportedOrder <> 648 then
        Error("Frozen family number, dimension, group ID, or order changed");
    fi;
    source := Group(child.generators);
    target := Group(parent.generators);
    if Size(source) <> 54 or Size(target) <> 648
       or not Restrict87Omega in source
       or not Restrict87Omega in target then
        Error("Unexpected linear group or scalar kernel");
    fi;
    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = 87 and r.targetNumber = 18
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct" and r.direct = true);
    if Length(edges) <> 1 then
        Error("Missing unique direct strict containment witness");
    fi;
    edge := edges[1];
    if edge.sourceOrder <> 54 or edge.targetOrder <> 648
       or edge.sourceDimension <> 2 or edge.targetDimension <> 0
       or not edge.method in ["literal_matrix_subgroup", "A_strict"] then
        Error("Strict containment witness metadata changed");
    fi;
    image := Group(List(child.generators, h -> edge.P^-1*h*edge.P));
    if not IsSubgroup(target, image) then
        Error("Saved conjugating matrix does not embed No. 87");
    fi;

    seen := []; histogram := [];
    for g in Elements(source) do
        if g in seen then continue; fi;
        for scalar in Restrict87Scalars do
            if Restrict87Trace(scalar*g) <> Restrict87Trace(g) then
                Error("Primitive trace depends on scalar lift");
            fi;
            Add(seen, scalar*g);
        od;
        key := [Restrict87ProjectiveOrder(g), Restrict87Trace(g)];
        position := PositionProperty(histogram,
            row -> row[1] = key[1] and row[2] = key[2]);
        if position = fail then
            Add(histogram, [key[1], key[2], 1]);
        else
            histogram[position][3] := histogram[position][3] + 1;
        fi;
    od;
    if Length(Set(seen)) <> 54
       or Sum(histogram, row -> row[3]) <> 18
       or Position(histogram, [1,22,1]) = fail then
        Error("Incomplete projective character");
    fi;
    Sort(histogram, function(a,b)
        if a[1] <> b[1] then return a[1] < b[1]; fi;
        return a[2] < b[2];
    end);
    return histogram;
end;

if Restrict87Trace(IdentityMat(6)) <> 22 then
    Error("The identity primitive trace must be 22");
fi;
if IsExistingFile(Restrict87Output) then
    Error("Refusing to overwrite the character TSV");
fi;
Restrict87Rows := Restrict87Character();
PrintTo(Restrict87Output,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for Restrict87Row in Restrict87Rows do
    AppendTo(Restrict87Output,
        87, "\t", Restrict87Row[1], "\t",
        Restrict87Row[2], "\t", Restrict87Row[3], "\n");
od;
Print("No. 87 projective character=", Restrict87Rows, "\n");
Print("Saved ", Restrict87Output, "\n");
