#############################################################################
## Exact primitive-H4 projective characters for Nos. 102 and 103.
## Run from autcub4fold/remark/catalogue. The recorded strict direct
## GL(6) witnesses into No. 69 are checked before any TSV is written.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

Restrict69102103Specs := [
    [102,69,3,2,12,72,[12,3]],
    [103,69,3,2,24,72,[24,10]]
];
Restrict69102103Output := "restriction_102_103_geometric_characters.tsv";
Restrict69102103Omega := E(3)*IdentityMat(6);
Restrict69102103Scalars := [IdentityMat(6),
    Restrict69102103Omega, Restrict69102103Omega^2];

Restrict69102103Trace := function(g)
    local dimensions, value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions, k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

Restrict69102103ProjectiveOrder := function(g)
    local k, power;
    power := IdentityMat(6);
    for k in [1..24] do
        power := power*g;
        if power in Restrict69102103Scalars then return k; fi;
    od;
    Error("Projective order exceeds twenty-four");
end;

Restrict69102103One := function(spec)
    local child, parent, source, target, edges, edge, image, seen,
          histogram, g, scalar, key, position;
    child := Families[spec[1]]; parent := Families[spec[2]];
    if child.number <> spec[1] or parent.number <> spec[2]
       or child.familyDimension <> spec[3]
       or parent.familyDimension <> spec[4]
       or child.projectiveGroupId <> spec[7]
       or parent.projectiveGroupId <> [72,42]
       or child.reportedOrder <> 3*spec[5]
       or parent.reportedOrder <> 3*spec[6] then
        Error("Frozen family number, dimension, group ID, or order changed");
    fi;
    source := Group(child.generators);
    target := Group(parent.generators);
    if Size(source) <> 3*spec[5] or Size(target) <> 3*spec[6]
       or not Restrict69102103Omega in source
       or not Restrict69102103Omega in target then
        Error("Unexpected linear group or scalar kernel");
    fi;
    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = spec[1] and r.targetNumber = spec[2]
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct" and r.direct = true);
    if Length(edges) <> 1 then
        Error("Missing unique direct strict linear containment witness");
    fi;
    edge := edges[1];
    if edge.sourceOrder <> Size(source) or edge.targetOrder <> Size(target)
       or edge.sourceDimension <> spec[3]
       or edge.targetDimension <> spec[4]
       or not edge.method in ["literal_matrix_subgroup", "A_strict"] then
        Error("Strict containment witness metadata changed");
    fi;
    image := Group(List(child.generators, h -> edge.P^-1*h*edge.P));
    if not IsSubgroup(target, image) then
        Error("Saved conjugating matrix does not embed the child");
    fi;

    seen := []; histogram := [];
    for g in Elements(source) do
        if g in seen then continue; fi;
        for scalar in Restrict69102103Scalars do
            if Restrict69102103Trace(scalar*g) <>
               Restrict69102103Trace(g) then
                Error("Primitive trace depends on scalar lift");
            fi;
            Add(seen, scalar*g);
        od;
        key := [Restrict69102103ProjectiveOrder(g),
                Restrict69102103Trace(g)];
        position := PositionProperty(histogram,
            row -> row[1] = key[1] and row[2] = key[2]);
        if position = fail then
            Add(histogram, [key[1], key[2], 1]);
        else
            histogram[position][3] := histogram[position][3] + 1;
        fi;
    od;
    if Length(Set(seen)) <> Size(source)
       or Sum(histogram, row -> row[3]) <> spec[5]
       or Position(histogram, [1,22,1]) = fail then
        Error("Incomplete projective character");
    fi;
    Sort(histogram, function(a,b)
        if a[1] <> b[1] then return a[1] < b[1]; fi;
        return a[2] < b[2];
    end);
    Print("family=", spec[1], " parent=", spec[2],
          " projective character=", histogram, "\n");
    return histogram;
end;

if Restrict69102103Trace(IdentityMat(6)) <> 22 then
    Error("The identity primitive trace must be 22");
fi;
if IsExistingFile(Restrict69102103Output) then
    Error("Refusing to overwrite the character TSV");
fi;
Restrict69102103Rows := [];
for Restrict69102103Spec in Restrict69102103Specs do
    Restrict69102103Histogram := Restrict69102103One(Restrict69102103Spec);
    for Restrict69102103Row in Restrict69102103Histogram do
        Add(Restrict69102103Rows,
            [Restrict69102103Spec[1], Restrict69102103Row[1],
             Restrict69102103Row[2], Restrict69102103Row[3]]);
    od;
od;
PrintTo(Restrict69102103Output,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for Restrict69102103Row in Restrict69102103Rows do
    AppendTo(Restrict69102103Output,
        Restrict69102103Row[1], "\t", Restrict69102103Row[2], "\t",
        Restrict69102103Row[3], "\t", Restrict69102103Row[4], "\n");
od;
Print("Saved ", Restrict69102103Output, "\n");
