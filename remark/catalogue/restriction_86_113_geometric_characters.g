#############################################################################
## Exact projective primitive-H4 characters of Nos. 86 and 113.
## Run from autcub4fold/remark/catalogue. Verify the saved direct
## strict linear-conjugacy witnesses into No. 62 before writing the TSV.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

Restrict86113Output := "restriction_86_113_geometric_characters.tsv";
Restrict86113Identity := IdentityMat(6);
Restrict86113Omega := E(3)*Restrict86113Identity;
Restrict86113Scalars := [Restrict86113Identity,
                        Restrict86113Omega,Restrict86113Omega^2];

Restrict86113Trace := function(g)
    local dimensions, value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*Restrict86113Identity));
    value := Sum(dimensions, k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

Restrict86113ProjectiveOrder := function(g)
    local k, power;
    power := Restrict86113Identity;
    for k in [1..18] do
        power := power*g;
        if power in Restrict86113Scalars then return k; fi;
    od;
    Error("Projective order exceeds the order of the child group");
end;

Restrict86113One := function(number, target)
    local child, dimension, projectiveId, linearId, source,
          edges, edge, image, seen, histogram, g, scalar, key, position;
    if number = 86 then
        dimension := 3; projectiveId := [18,3]; linearId := [54,12];
    elif number = 113 then
        dimension := 2; projectiveId := [18,5]; linearId := [54,15];
    else
        Error("Only Nos. 86 and 113 are supported");
    fi;
    child := Families[number];
    if child.number <> number or child.familyDimension <> dimension
       or child.projectiveGroupId <> projectiveId
       or child.linearGroupId <> linearId or child.reportedOrder <> 54 then
        Error("Frozen child family metadata changed");
    fi;
    source := Group(child.generators);
    if Size(source) <> 54 or IdGroup(source) <> linearId
       or not Restrict86113Omega in source then
        Error("Unexpected child linear group or scalar kernel");
    fi;
    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = number and r.targetNumber = 62
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct" and r.direct = true);
    if Length(edges) <> 1 then
        Error("Missing unique direct strict linear containment witness");
    fi;
    edge := edges[1];
    if edge.sourceOrder <> 54 or edge.targetOrder <> 216
       or edge.sourceDimension <> dimension or edge.targetDimension <> 1
       or not edge.method in ["literal_matrix_subgroup", "A_strict"] then
        Error("Strict containment witness metadata changed");
    fi;
    image := Group(List(child.generators, h -> edge.P^-1*h*edge.P));
    if Size(image) <> 54 or not IsSubgroup(target,image) then
        Error("Saved conjugating matrix does not embed the child");
    fi;

    seen := []; histogram := [];
    for g in Elements(source) do
        if g in seen then continue; fi;
        for scalar in Restrict86113Scalars do
            if Restrict86113Trace(scalar*g) <> Restrict86113Trace(g) then
                Error("Primitive trace depends on scalar lift");
            fi;
            Add(seen,scalar*g);
        od;
        key := [Restrict86113ProjectiveOrder(g),Restrict86113Trace(g)];
        position := PositionProperty(histogram,
            row -> row[1] = key[1] and row[2] = key[2]);
        if position = fail then
            Add(histogram,[key[1],key[2],1]);
        else
            histogram[position][3] := histogram[position][3] + 1;
        fi;
    od;
    if Length(Set(seen)) <> 54
       or Sum(histogram,row -> row[3]) <> 18
       or Position(histogram,[1,22,1]) = fail
       or Sum(histogram,row -> row[2]*row[3]) mod 18 <> 0
       or Sum(histogram,row -> row[2]^2*row[3]) mod 18 <> 0 then
        Error("Incomplete or nonintegral projective character");
    fi;
    Sort(histogram,function(a,b)
        if a[1] <> b[1] then return a[1] < b[1]; fi;
        return a[2] < b[2];
    end);
    Print("family=",number," parent=62 character=",histogram,"\n");
    return histogram;
end;

if Restrict86113Trace(Restrict86113Identity) <> 22 then
    Error("The identity primitive trace must be 22");
fi;
if IsExistingFile(Restrict86113Output) then
    Error("Refusing to overwrite the character TSV");
fi;
Restrict86113Parent := Families[62];
if Restrict86113Parent.number <> 62
   or Restrict86113Parent.familyDimension <> 1
   or Restrict86113Parent.projectiveGroupId <> [72,30]
   or Restrict86113Parent.linearGroupId <> [216,139]
   or Restrict86113Parent.reportedOrder <> 216 then
    Error("Frozen No. 62 metadata changed");
fi;
Restrict86113Target := Group(Restrict86113Parent.generators);
if Size(Restrict86113Target) <> 216
   or IdGroup(Restrict86113Target) <> [216,139]
   or not Restrict86113Omega in Restrict86113Target then
    Error("Unexpected No. 62 linear group or scalar kernel");
fi;
Restrict86113Rows := [];
for Restrict86113Number in [86,113] do
    Restrict86113Histogram := Restrict86113One(
        Restrict86113Number,Restrict86113Target);
    for Restrict86113Row in Restrict86113Histogram do
        Add(Restrict86113Rows,[Restrict86113Number,
            Restrict86113Row[1],Restrict86113Row[2],Restrict86113Row[3]]);
    od;
od;
PrintTo(Restrict86113Output,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for Restrict86113Row in Restrict86113Rows do
    AppendTo(Restrict86113Output,
        Restrict86113Row[1],"\t",Restrict86113Row[2],"\t",
        Restrict86113Row[3],"\t",Restrict86113Row[4],"\n");
od;
Print("Saved ",Restrict86113Output,"\n");
