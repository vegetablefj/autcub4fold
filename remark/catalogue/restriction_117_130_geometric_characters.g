#############################################################################
## Exact projective primitive-H4 characters for Nos. 117 and 130.
## Run with GAP from autcub4fold/remark/catalogue. The numbered
## six-dimensional groups and strict containment witnesses are frozen inputs.
## This script refuses to overwrite its character TSV.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

Restrict95117130Specs := [
    [117,95,4,1,18,72,[18,3]],
    [130,95,2,1,24,72,[24,9]]
];
Restrict95117130Output := "restriction_117_130_geometric_characters.tsv";
Restrict95117130Omega := E(3)*IdentityMat(6);
Restrict95117130Scalars := [IdentityMat(6),Restrict95117130Omega,
                              Restrict95117130Omega^2];

Restrict95117130Trace := function(g)
    local dimensions,value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions,k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

Restrict95117130ProjectiveOrder := function(g,bound)
    local k,power;
    power := IdentityMat(6);
    for k in [1..bound] do
        power := power*g;
        if power in Restrict95117130Scalars then return k; fi;
    od;
    Error("Projective order exceeds the full-group order");
end;

Restrict95117130One := function(spec)
    local child,parent,childDimension,parentDimension,childOrder,
          parentOrder,expectedId,source,target,edges,edge,image,seen,
          histogram,g,scalar,key,position,row;
    child := spec[1]; parent := spec[2];
    childDimension := spec[3]; parentDimension := spec[4];
    childOrder := spec[5]; parentOrder := spec[6]; expectedId := spec[7];
    if Families[child].number <> child or Families[parent].number <> parent
       or Families[child].familyDimension <> childDimension
       or Families[parent].familyDimension <> parentDimension
       or Families[child].projectiveGroupId <> expectedId
       or Families[parent].projectiveGroupId <> [72,27] then
        Error("Frozen numbering, dimension, or projective ID changed");
    fi;
    source := Group(Families[child].generators);
    target := Group(Families[parent].generators);
    if Size(source) <> 3*childOrder or Size(target) <> 3*parentOrder
       or not Restrict95117130Omega in source
       or not Restrict95117130Omega in target then
        Error("Unexpected strict linear group or scalar kernel");
    fi;
    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = child and r.targetNumber = parent
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct");
    if Length(edges) <> 1 then
        Error("Missing unique direct strict linear containment witness");
    fi;
    edge := edges[1];
    if edge.sourceOrder <> Size(source) or edge.targetOrder <> Size(target)
       or edge.sourceDimension <> childDimension
       or edge.targetDimension <> parentDimension
       or edge.direct <> true or edge.viaNumber <> fail
       or not edge.method in ["literal_matrix_subgroup","A_strict"] then
        Error("Strict containment witness metadata changed");
    fi;
    image := Group(List(Families[child].generators,
        h -> edge.P^-1*h*edge.P));
    if not IsSubgroup(target,image) or Size(image) <> Size(source) then
        Error("Saved conjugating matrix does not embed the child");
    fi;

    seen := []; histogram := [];
    for g in Elements(source) do
        if g in seen then continue; fi;
        for scalar in Restrict95117130Scalars do
            if Restrict95117130Trace(scalar*g) <>
               Restrict95117130Trace(g) or
               Restrict95117130ProjectiveOrder(scalar*g,childOrder) <>
               Restrict95117130ProjectiveOrder(g,childOrder) then
                Error("Primitive character depends on scalar lift");
            fi;
            Add(seen,scalar*g);
        od;
        key := [Restrict95117130ProjectiveOrder(g,childOrder),
                Restrict95117130Trace(g)];
        position := PositionProperty(histogram,
            row -> row[1] = key[1] and row[2] = key[2]);
        if position = fail then
            Add(histogram,[key[1],key[2],1]);
        else
            histogram[position][3] := histogram[position][3]+1;
        fi;
    od;
    if Length(Set(seen)) <> Size(source)
       or Sum(histogram,row -> row[3]) <> childOrder
       or Position(histogram,[1,22,1]) = fail then
        Error("Incomplete projective geometric character");
    fi;
    Sort(histogram,function(a,b)
        if a[1] <> b[1] then return a[1] < b[1]; fi;
        return a[2] < b[2];
    end);
    Print("family=",child," parent=",parent,
          " projective character=",histogram,"\n");
    return histogram;
end;

if Restrict95117130Trace(IdentityMat(6)) <> 22 then
    Error("The identity primitive trace must be 22");
fi;
Restrict95117130Histograms := List(Restrict95117130Specs,
    Restrict95117130One);
if IsExistingFile(Restrict95117130Output) then
    Error("Refusing to overwrite existing character TSV");
fi;
PrintTo(Restrict95117130Output,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for Restrict95117130I in [1..Length(Restrict95117130Specs)] do
    for Restrict95117130Row in Restrict95117130Histograms[Restrict95117130I] do
        AppendTo(Restrict95117130Output,
            Restrict95117130Specs[Restrict95117130I][1],"\t",
            Restrict95117130Row[1],"\t",Restrict95117130Row[2],"\t",
            Restrict95117130Row[3],"\n");
    od;
od;
Print("Saved ",Restrict95117130Output,"\n");
