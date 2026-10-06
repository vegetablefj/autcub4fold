#############################################################################
## Primitive-H4 projective characters for the No. 92 and No. 118 restrictions.
## Run from autcub4fold/remark/catalogue. This verifies each saved
## direct strict GL(6) containment witness before writing the character table.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

Restrict92118Output := "restriction_92_118_geometric_characters.tsv";
Restrict92118Identity := IdentityMat(6);
Restrict92118Omega := E(3)*Restrict92118Identity;
Restrict92118Scalars := [Restrict92118Identity, Restrict92118Omega,
                          Restrict92118Omega^2];

Restrict92118Trace := function(g)
    local dimensions, value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*Restrict92118Identity));
    value := Sum(dimensions, k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

Restrict92118ProjectiveOrder := function(g)
    local k, power;
    power := Restrict92118Identity;
    for k in [1..36] do
        power := power*g;
        if power in Restrict92118Scalars then return k; fi;
    od;
    Error("Projective order exceeds the order of the No. 92 group");
end;

Restrict92118Metadata := [
    [92,2,[108,42],[36,12],108],
    [118,3,[54,12],[18,3],54]
];
Restrict92118Parents := [
    [36,[648,746],[216,170]],
    [38,[648,718],[216,157]]
];

Restrict92118CheckParent := function(row)
    local n, family, group;
    n := row[1];
    family := Families[n];
    if family.number <> n or family.familyDimension <> 1
       or family.linearGroupId <> row[2]
       or family.projectiveGroupId <> row[3]
       or family.reportedOrder <> 648 then
        Error("Frozen S33 parent family metadata changed");
    fi;
    group := Group(family.generators);
    if Size(group) <> 648 or IdGroup(group) <> row[2]
       or not Restrict92118Omega in group then
        Error("Unexpected S33 parent linear group or scalar kernel");
    fi;
    return group;
end;

Restrict92118CheckChild := function(row)
    local n, family, group;
    n := row[1];
    family := Families[n];
    if family.number <> n or family.familyDimension <> row[2]
       or family.linearGroupId <> row[3]
       or family.projectiveGroupId <> row[4]
       or family.reportedOrder <> row[5] then
        Error("Frozen child family metadata changed");
    fi;
    group := Group(family.generators);
    if Size(group) <> row[5] or IdGroup(group) <> row[3]
       or not Restrict92118Omega in group then
        Error("Unexpected child linear group or scalar kernel");
    fi;
    return group;
end;

Restrict92118Histogram := function(group)
    local seen, histogram, g, scalar, key, position;
    seen := [];
    histogram := [];
    for g in Elements(group) do
        if g in seen then continue; fi;
        for scalar in Restrict92118Scalars do
            if Restrict92118Trace(scalar*g) <> Restrict92118Trace(g) then
                Error("Primitive trace depends on scalar lift");
            fi;
            Add(seen, scalar*g);
        od;
        key := [Restrict92118ProjectiveOrder(g),Restrict92118Trace(g)];
        position := PositionProperty(histogram,
            row -> row[1] = key[1] and row[2] = key[2]);
        if position = fail then
            Add(histogram,[key[1],key[2],1]);
        else
            histogram[position][3] := histogram[position][3]+1;
        fi;
    od;
    if Length(Set(seen)) <> Size(group)
       or Sum(histogram,row -> row[3]) <> Size(group)/3
       or Position(histogram,[1,22,1]) = fail then
        Error("Incomplete projective primitive-H4 character");
    fi;
    Sort(histogram,function(a,b)
        if a[1] <> b[1] then return a[1] < b[1]; fi;
        return a[2] < b[2];
    end);
    return histogram;
end;

Restrict92118CheckEdge := function(child,parent,target)
    local edges, edge, image, family;
    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = child and r.targetNumber = parent
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct" and r.direct = true);
    if Length(edges) <> 1 then
        Error("Missing unique direct strict linear containment witness");
    fi;
    edge := edges[1];
    family := Families[child];
    if edge.sourceOrder <> family.reportedOrder
       or edge.targetOrder <> 648
       or edge.sourceDimension <> family.familyDimension
       or edge.targetDimension <> 1 or edge.method <> "A_strict" then
        Error("Strict containment witness metadata changed");
    fi;
    image := Group(List(family.generators,h -> edge.P^-1*h*edge.P));
    if Size(image) <> family.reportedOrder or not IsSubgroup(target,image) then
        Error("Saved conjugating matrix does not embed the child");
    fi;
    Print("verified direct GL containment ",child," -> ",parent,
          "; linear order ",Size(image),"\n");
end;

if Restrict92118Trace(Restrict92118Identity) <> 22 then
    Error("The identity primitive trace must be 22");
fi;
if IsExistingFile(Restrict92118Output) then
    Error("Refusing to overwrite the character TSV");
fi;

Restrict92118Parent36 := Restrict92118CheckParent(Restrict92118Parents[1]);
Restrict92118Parent38 := Restrict92118CheckParent(Restrict92118Parents[2]);
Restrict92118Child92 := Restrict92118CheckChild(Restrict92118Metadata[1]);
Restrict92118Child118 := Restrict92118CheckChild(Restrict92118Metadata[2]);
Restrict92118CheckEdge(92,36,Restrict92118Parent36);
Restrict92118CheckEdge(118,36,Restrict92118Parent36);
Restrict92118CheckEdge(118,38,Restrict92118Parent38);

Restrict92118Rows := [];
for Restrict92118Row in [
    [92,Restrict92118Child92],[118,Restrict92118Child118]] do
    Restrict92118Character := Restrict92118Histogram(Restrict92118Row[2]);
    Print("family=",Restrict92118Row[1]," character=",
          Restrict92118Character,"\n");
    for Restrict92118Part in Restrict92118Character do
        Add(Restrict92118Rows,[Restrict92118Row[1],
            Restrict92118Part[1],Restrict92118Part[2],Restrict92118Part[3]]);
    od;
od;
PrintTo(Restrict92118Output,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for Restrict92118Row in Restrict92118Rows do
    AppendTo(Restrict92118Output,
        Restrict92118Row[1],"\t",Restrict92118Row[2],"\t",
        Restrict92118Row[3],"\t",Restrict92118Row[4],"\n");
od;
Print("Saved ",Restrict92118Output,"\n");
