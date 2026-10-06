#############################################################################
## Exact projective H^4 characters for Nos. 88, 89, 90, 91, and 93.
## Check the frozen strict linear containments before writing the table.
## Run from autcub4fold/remark/catalogue. Existing output is preserved.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

SameS3Specs := [
    [88,94,6,1,12,72,[12,4]],
    [88,95,6,1,12,72,[12,4]],
    [89,94,3,1,24,72,[24,5]],
    [89,95,3,1,24,72,[24,5]],
    [90,94,3,1,36,72,[36,12]],
    [91,95,3,1,36,72,[36,12]],
    [93,96,1,0,48,144,[48,4]]
];
SameS3Output := "restriction_same_s3_geometric_characters.tsv";
SameS3Omega := E(3)*IdentityMat(6);
SameS3Scalars := [IdentityMat(6),SameS3Omega,SameS3Omega^2];

SameS3Trace := function(g)
    local dimensions,value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions,k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H^4 trace");
    fi;
    return value;
end;

SameS3ProjectiveOrder := function(g,bound)
    local k,power;
    power := IdentityMat(6);
    for k in [1..bound] do
        power := power*g;
        if power in SameS3Scalars then return k; fi;
    od;
    Error("Projective order exceeds stated group order");
end;

SameS3Character := function(number,projectiveOrder)
    local G,seen,histogram,g,scalar,key,position,row;
    G := Group(Families[number].generators);
    if Size(G) <> 3*projectiveOrder or not SameS3Omega in G then
        Error("Unexpected linear order or central scalar kernel");
    fi;
    seen := [];
    histogram := [];
    for g in Elements(G) do
        if g in seen then continue; fi;
        for scalar in SameS3Scalars do
            if SameS3Trace(scalar*g) <> SameS3Trace(g)
               or SameS3ProjectiveOrder(scalar*g,projectiveOrder) <>
                  SameS3ProjectiveOrder(g,projectiveOrder) then
                Error("Projective character depends on scalar lift");
            fi;
            Add(seen,scalar*g);
        od;
        key := [SameS3ProjectiveOrder(g,projectiveOrder),SameS3Trace(g)];
        position := PositionProperty(histogram,
            row -> row[1] = key[1] and row[2] = key[2]);
        if position = fail then
            Add(histogram,[key[1],key[2],1]);
        else
            histogram[position][3] := histogram[position][3]+1;
        fi;
    od;
    if Length(Set(seen)) <> 3*projectiveOrder
       or Sum(histogram,row -> row[3]) <> projectiveOrder
       or Position(histogram,[1,22,1]) = fail then
        Error("Incomplete projective character");
    fi;
    Sort(histogram,function(a,b)
        if a[1] <> b[1] then return a[1] < b[1]; fi;
        return a[2] < b[2];
    end);
    return histogram;
end;

SameS3CheckEdge := function(spec)
    local child,parent,cdim,pdim,childOrder,parentOrder,expectedId,expectedParentId,
          source,target,edges,edge,image;
    child := spec[1]; parent := spec[2];
    cdim := spec[3]; pdim := spec[4];
    childOrder := spec[5]; parentOrder := spec[6];
    expectedId := spec[7];
    if parent = 96 then
        expectedParentId := [144,69];
    else
        expectedParentId := [72,27];
    fi;
    if Families[child].number <> child or Families[parent].number <> parent
       or Families[child].familyDimension <> cdim
       or Families[parent].familyDimension <> pdim
       or Families[child].projectiveGroupId <> expectedId
       or Families[parent].projectiveGroupId <> expectedParentId then
        Error("Frozen numbering, dimension, or group ID changed");
    fi;
    source := Group(Families[child].generators);
    target := Group(Families[parent].generators);
    if Size(source) <> 3*childOrder or Size(target) <> 3*parentOrder
       or not SameS3Omega in source or not SameS3Omega in target then
        Error("Unexpected linear group order or scalar kernel");
    fi;
    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = child and r.targetNumber = parent
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct");
    if Length(edges) <> 1 then
        Error("Missing unique direct strict linear-containment witness");
    fi;
    edge := edges[1];
    if edge.sourceOrder <> 3*childOrder
       or edge.targetOrder <> 3*parentOrder
       or edge.sourceDimension <> cdim
       or edge.targetDimension <> pdim
       or edge.direct <> true or edge.viaNumber <> fail
       or not edge.method in ["literal_matrix_subgroup","A_strict"] then
        Error("Frozen strict-containment metadata changed");
    fi;
    image := Group(List(Families[child].generators,
        h -> edge.P^-1*h*edge.P));
    if not IsSubgroup(target,image) or Size(image) <> Size(source) then
        Error("Saved conjugator does not embed the child group");
    fi;
    Print("Checked strict No. ",child," < No. ",parent,"\n");
end;

for SameS3Spec in SameS3Specs do
    SameS3CheckEdge(SameS3Spec);
od;
if IsExistingFile(SameS3Output) then
    Error("Refusing to overwrite existing character TSV");
fi;
PrintTo(SameS3Output,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for SameS3Child in [88,89,90,91,93] do
    SameS3Spec := First(SameS3Specs,s -> s[1] = SameS3Child);
    SameS3Histogram := SameS3Character(SameS3Child,SameS3Spec[5]);
    for SameS3Row in SameS3Histogram do
        AppendTo(SameS3Output,SameS3Child,"\t",SameS3Row[1],"\t",
                 SameS3Row[2],"\t",SameS3Row[3],"\n");
    od;
    Print("No. ",SameS3Child," projective character = ",
          SameS3Histogram,"\n");
od;
Print("Saved ",SameS3Output,"\n");
