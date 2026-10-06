#############################################################################
## Primitive-H4 characters for No. 97--100, with strict embeddings in No. 74.
## Run from autcub4fold/remark/catalogue in GAP. This file only reads
## the frozen family list and its existing cross-dimensional edge witnesses.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

VFourSpecs := [
    [97,74,8,4,4,16],
    [98,74,7,4,8,16],
    [99,74,6,4,8,16],
    [100,74,5,4,8,16]
];
VFourOutput := "restriction_97_100_geometric_characters.tsv";
VFourOmega := E(3)*IdentityMat(6);
VFourScalars := [IdentityMat(6),VFourOmega,VFourOmega^2];

VFourTrace := function(g)
    local dimensions,value;
    dimensions := List(VFourScalars,
        alpha -> 6 - RankMat(g - alpha[1][1]*IdentityMat(6)));
    value := Sum(dimensions,k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

VFourProjectiveOrder := function(g)
    local k,power;
    power := IdentityMat(6);
    for k in [1..16] do
        power := power*g;
        if power in VFourScalars then return k; fi;
    od;
    Error("Projective order exceeds the full-group order");
end;

VFourOne := function(spec)
    local child,parent,childDim,parentDim,childOrder,parentOrder,
          source,target,edges,edge,image,seen,histogram,g,scalar,key,
          position,row;
    child := spec[1]; parent := spec[2];
    childDim := spec[3]; parentDim := spec[4];
    childOrder := spec[5]; parentOrder := spec[6];
    if Families[child].number <> child or Families[parent].number <> parent
       or Families[child].familyDimension <> childDim
       or Families[parent].familyDimension <> parentDim then
        Error("Frozen numbering or dimension changed");
    fi;
    source := Group(Families[child].generators);
    target := Group(Families[parent].generators);
    if Size(source) <> 3*childOrder or Size(target) <> 3*parentOrder
       or not VFourOmega in source or not VFourOmega in target then
        Error("Unexpected linear group or scalar kernel");
    fi;
    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = child and r.targetNumber = parent
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct");
    if Length(edges) <> 1 then
        Error("Missing unique strict containment witness");
    fi;
    edge := edges[1];
    if edge.sourceOrder <> Size(source) or edge.targetOrder <> Size(target)
       or edge.sourceDimension <> childDim
       or edge.targetDimension <> parentDim
       or not edge.method in ["literal_matrix_subgroup","A_strict"] then
        Error("Strict containment witness metadata changed");
    fi;
    image := Group(List(Families[child].generators,
        g -> edge.P^-1*g*edge.P));
    if not IsSubgroup(target,image) then
        Error("Saved conjugating matrix does not embed the child");
    fi;

    seen := []; histogram := [];
    for g in Elements(source) do
        if g in seen then continue; fi;
        for scalar in VFourScalars do
            if VFourTrace(scalar*g) <> VFourTrace(g) then
                Error("Primitive trace depends on scalar lift");
            fi;
            Add(seen,scalar*g);
        od;
        key := [VFourProjectiveOrder(g),VFourTrace(g)];
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
    for row in histogram do
        AppendTo(VFourOutput,child,"\t",row[1],"\t",row[2],"\t",row[3],"\n");
    od;
    Print("family=",child," parent=",parent,
          " projective character=",histogram,"\n");
end;

if VFourTrace(IdentityMat(6)) <> 22 then
    Error("Identity primitive trace must be 22");
fi;
PrintTo(VFourOutput,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for VFourSpec in VFourSpecs do VFourOne(VFourSpec); od;
Print("Saved ",VFourOutput,"\n");
