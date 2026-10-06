#############################################################################
## Exact projective primitive-H4 characters for Nos. 109, 112 and 114.
## Run from autcub4fold/remark/catalogue.  Check the saved direct
## strict GL(6) witnesses before writing the output TSV.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

Restrict41109112114Specs := [
    [109,41,4,0,6,126,[6,2]],
    [112,41,2,0,9,126,[9,2]],
    [114,41,1,0,18,126,[18,5]]
];
Restrict41109112114Output := "restriction_109_112_114_geometric_characters.tsv";
Restrict41109112114Omega := E(3)*IdentityMat(6);
Restrict41109112114Scalars := [IdentityMat(6),
    Restrict41109112114Omega, Restrict41109112114Omega^2];

Restrict41109112114Trace := function(g)
    local dimensions, value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions, k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

Restrict41109112114ProjectiveOrder := function(g, bound)
    local k, power;
    power := IdentityMat(6);
    for k in [1..bound] do
        power := power*g;
        if power in Restrict41109112114Scalars then return k; fi;
    od;
    Error("Projective order exceeds the child group order");
end;

Restrict41109112114One := function(spec)
    local child, parent, childDimension, parentDimension, childOrder,
          parentOrder, source, target, edges, edge, image, seen, histogram,
          g, scalar, key, position, row;
    child := spec[1]; parent := spec[2];
    childDimension := spec[3]; parentDimension := spec[4];
    childOrder := spec[5]; parentOrder := spec[6];
    if Families[child].number <> child or Families[parent].number <> parent
       or Families[child].familyDimension <> childDimension
       or Families[parent].familyDimension <> parentDimension
       or Families[child].projectiveGroupId <> spec[7]
       or Families[child].reportedOrder <> 3*childOrder
       or Families[parent].reportedOrder <> 3*parentOrder then
        Error("Frozen family number, dimension, group ID, or order changed");
    fi;
    source := Group(Families[child].generators);
    target := Group(Families[parent].generators);
    if Size(source) <> 3*childOrder or Size(target) <> 3*parentOrder
       or not Restrict41109112114Omega in source
       or not Restrict41109112114Omega in target then
        Error("Unexpected linear group or scalar kernel");
    fi;
    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = child and r.targetNumber = parent
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct" and r.direct = true);
    if Length(edges) <> 1 then
        Error("Missing unique direct strict linear containment witness");
    fi;
    edge := edges[1];
    if edge.sourceOrder <> Size(source) or edge.targetOrder <> Size(target)
       or edge.sourceDimension <> childDimension
       or edge.targetDimension <> parentDimension
       or not edge.method in ["literal_matrix_subgroup", "A_strict"] then
        Error("Strict containment witness metadata changed");
    fi;
    image := Group(List(Families[child].generators,
        h -> edge.P^-1 * h * edge.P));
    if not IsSubgroup(target, image) then
        Error("Saved conjugating matrix does not embed the child");
    fi;

    seen := []; histogram := [];
    for g in Elements(source) do
        if g in seen then continue; fi;
        for scalar in Restrict41109112114Scalars do
            if Restrict41109112114Trace(scalar*g) <>
               Restrict41109112114Trace(g) then
                Error("Primitive trace depends on scalar lift");
            fi;
            Add(seen, scalar*g);
        od;
        key := [Restrict41109112114ProjectiveOrder(g, childOrder),
                Restrict41109112114Trace(g)];
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
    Print("family=", child, " parent=", parent,
          " projective character=", histogram, "\n");
    return histogram;
end;

if Restrict41109112114Trace(IdentityMat(6)) <> 22 then
    Error("The identity primitive trace must be 22");
fi;
if IsExistingFile(Restrict41109112114Output) then
    Error("Refusing to overwrite the character TSV");
fi;
Restrict41109112114Rows := [];
for Restrict41109112114Spec in Restrict41109112114Specs do
    Restrict41109112114Histogram :=
        Restrict41109112114One(Restrict41109112114Spec);
    for Restrict41109112114Row in Restrict41109112114Histogram do
        Add(Restrict41109112114Rows,
            [Restrict41109112114Spec[1],
             Restrict41109112114Row[1],
             Restrict41109112114Row[2],
             Restrict41109112114Row[3]]);
    od;
od;
PrintTo(Restrict41109112114Output,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for Restrict41109112114Row in Restrict41109112114Rows do
    AppendTo(Restrict41109112114Output,
        Restrict41109112114Row[1], "\t", Restrict41109112114Row[2], "\t",
        Restrict41109112114Row[3], "\t", Restrict41109112114Row[4], "\n");
od;
Print("Saved ", Restrict41109112114Output, "\n");
