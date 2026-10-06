# Exact same-symplectic-part restrictions No. 108 < No. 113 and
# No. 128 < No. 131 in the frozen six-dimensional linear coordinates.
# Run from autcub4fold/remark/catalogue. Existing output is checked,
# never replaced.

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

RSPOutput := "restriction_same_part_108_128_geometric.tsv";;
RSPOne := IdentityMat(6);;
RSPOmega := E(3)*RSPOne;;
RSPScalars := [RSPOne,RSPOmega,RSPOmega^2];;

RSPTrace := function(g)
    local dims, value;
    dims := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g-alpha*RSPOne));
    value := Sum(dims,k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;;

RSPProjectiveOrder := function(g)
    local k, h;
    h := RSPOne;
    for k in [1..24] do
        h := h*g;
        if h in RSPScalars then return k; fi;
    od;
    Error("Projective order exceeds 24");
end;;

RSPHistogram := function(group)
    local seen, bins, g, scalar, key, position;
    seen := []; bins := [];
    for g in Elements(group) do
        if g in seen then continue; fi;
        key := [RSPProjectiveOrder(g),RSPTrace(g)];
        for scalar in RSPScalars do
            if RSPProjectiveOrder(scalar*g) <> key[1]
               or RSPTrace(scalar*g) <> key[2] then
                Error("Primitive character depends on a scalar lift");
            fi;
            Add(seen,scalar*g);
        od;
        position := PositionProperty(bins,
            row -> row[1]=key[1] and row[2]=key[2]);
        if position = fail then
            Add(bins,[key[1],key[2],1]);
        else
            bins[position][3] := bins[position][3]+1;
        fi;
    od;
    if Length(Set(seen)) <> Size(group)
       or Sum(bins,row -> row[3]) <> Size(group)/3
       or Position(bins,[1,22,1]) = fail then
        Error("Incomplete projective character");
    fi;
    Sort(bins,function(a,b)
        if a[1] <> b[1] then return a[1] < b[1]; fi;
        return a[2] < b[2];
    end);
    return bins;
end;;

RSPSpecs := [
    rec(child := 108, parent := 113, power := 3, index := 2,
        symOrder := 3, symTrace := 4, parentOrder := 54,
        childOrder := 18, parentId := [54,15], childId := [18,5],
        parentProjectiveId := [18,5], childProjectiveId := [6,2],
        parentDimension := 2, childDimension := 4),
    rec(child := 128, parent := 131, power := 2, index := 6,
        symOrder := 2, symTrace := 6, parentOrder := 72,
        childOrder := 36, parentId := [72,36], childId := [36,14],
        parentProjectiveId := [24,9], childProjectiveId := [12,5],
        parentDimension := 1, childDimension := 3)
];;

RSPRows := [];;
for RSPSpec in RSPSpecs do
    RSPParentRecord := Families[RSPSpec.parent];;
    RSPChildRecord := Families[RSPSpec.child];;
    if RSPParentRecord.number <> RSPSpec.parent
       or RSPChildRecord.number <> RSPSpec.child
       or RSPParentRecord.familyDimension <> RSPSpec.parentDimension
       or RSPChildRecord.familyDimension <> RSPSpec.childDimension
       or RSPParentRecord.linearGroupId <> RSPSpec.parentId
       or RSPChildRecord.linearGroupId <> RSPSpec.childId
       or RSPParentRecord.projectiveGroupId <> RSPSpec.parentProjectiveId
       or RSPChildRecord.projectiveGroupId <> RSPSpec.childProjectiveId then
        Error("Frozen numbered family metadata changed");
    fi;
    RSPParent := Group(RSPParentRecord.generators);;
    RSPChild := Group(RSPChildRecord.generators);;
    if Size(RSPParent) <> RSPSpec.parentOrder
       or Size(RSPChild) <> RSPSpec.childOrder
       or IdGroup(RSPParent) <> RSPSpec.parentId
       or IdGroup(RSPChild) <> RSPSpec.childId
       or not RSPOmega in RSPChild
       or not IsSubgroup(RSPParent,RSPChild) then
        Error("Unexpected linear groups or literal containment");
    fi;
    RSPEdges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber=RSPSpec.child
             and r.targetNumber=RSPSpec.parent
             and r.ok=true and r.status="embedded"
             and r.classification="direct" and r.direct=true);;
    if Length(RSPEdges) <> 1
       or RSPEdges[1].method <> "literal_matrix_subgroup"
       or RSPEdges[1].sourceOrder <> RSPSpec.childOrder
       or RSPEdges[1].targetOrder <> RSPSpec.parentOrder then
        Error("The frozen strict-containment witness changed");
    fi;
    RSPImage := Group(List(RSPChildRecord.generators,
        h -> RSPEdges[1].P^-1*h*RSPEdges[1].P));;
    if Size(RSPImage) <> RSPSpec.childOrder
       or not IsSubgroup(RSPParent,RSPImage) then
        Error("The saved conjugating matrix does not verify containment");
    fi;
    if Length(RSPParentRecord.generators) <> 3
       or RSPParentRecord.generators[1] <> RSPOmega then
        Error("Expected scalar, symplectic, extra generator order changed");
    fi;
    RSPSym := RSPParentRecord.generators[2];;
    RSPExtra := RSPParentRecord.generators[3];;
    RSPA := Group([RSPOmega,RSPSym]);;
    if Size(RSPA) <> 3*RSPSpec.symOrder
       or RSPProjectiveOrder(RSPSym) <> RSPSpec.symOrder
       or RSPTrace(RSPSym) <> RSPSpec.symTrace
       or not IsNormal(RSPParent,RSPA)
       or not IsSubgroup(RSPChild,RSPA) then
        Error("The common symplectic subgroup was not verified");
    fi;
    if Size(RSPParent)/Size(RSPA) <> RSPSpec.parentProjectiveId[1]/RSPSpec.symOrder
       or Size(Group(Concatenation(GeneratorsOfGroup(RSPA),[RSPExtra])))
          <> Size(RSPParent) then
        Error("The parent quotient is not generated by the extra element");
    fi;
    RSPPower := Group(Concatenation(GeneratorsOfGroup(RSPA),
        [RSPExtra^RSPSpec.power]));;
    RSPUnique := Group(Filtered(Elements(RSPParent),
        g -> g^RSPSpec.index in RSPA));;
    if Size(RSPPower) <> RSPSpec.childOrder
       or Size(RSPUnique) <> RSPSpec.childOrder
       or Size(Intersection(RSPPower,RSPChild)) <> RSPSpec.childOrder
       or Size(Intersection(RSPUnique,RSPChild)) <> RSPSpec.childOrder then
        Error("The powered subgroup is not the unique quotient preimage");
    fi;
    RSPBins := RSPHistogram(RSPChild);;
    if RSPBins <> RSPHistogram(RSPPower) then
        Error("The powered subgroup has a different geometric character");
    fi;
    for RSPBin in RSPBins do
        Add(RSPRows,[RSPSpec.child,RSPSpec.parent,
            RSPBin[1],RSPBin[2],RSPBin[3]]);
    od;
    Print("PASS: No. ",RSPSpec.child," is the unique quotient preimage in No. ",
        RSPSpec.parent,"; bins=",RSPBins,"\n");
od;

RSPExpected := [
    "child_number\tparent_number\tprojective_order\tprimitive_H4_trace\telement_count\n"
];;
for RSPRow in RSPRows do
    Add(RSPExpected,Concatenation(String(RSPRow[1]),"\t",String(RSPRow[2]),
        "\t",String(RSPRow[3]),"\t",String(RSPRow[4]),"\t",
        String(RSPRow[5]),"\n"));
od;
if IsExistingFile(RSPOutput) then
    RSPStream := InputTextFile(RSPOutput);;
    if RSPStream=fail then Error("Cannot read existing output"); fi;
    for RSPLine in RSPExpected do
        if ReadLine(RSPStream) <> RSPLine then
            Error("Existing geometric TSV disagrees with the recomputation");
        fi;
    od;
    if ReadLine(RSPStream) <> fail then Error("Existing TSV has extra rows"); fi;
    CloseStream(RSPStream);
    Print("PASS: checked existing ",RSPOutput,"\n");
else
    PrintTo(RSPOutput,RSPExpected[1]);
    for RSPLine in RSPExpected{[2..Length(RSPExpected)]} do
        AppendTo(RSPOutput,RSPLine);
    od;
    Print("Saved ",RSPOutput,"\n");
fi;
