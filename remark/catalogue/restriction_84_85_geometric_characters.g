#############################################################################
## Exact projective primitive-H4 characters of Nos. 84 and 85.
## Run from autcub4fold/remark/catalogue. Both frozen direct strict
## linear-conjugacy witnesses into No. 60 are verified before output.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

Restrict8485Output := "restriction_84_85_geometric_characters.tsv";
Restrict8485Identity := IdentityMat(6);
Restrict8485Omega := E(3)*Restrict8485Identity;
Restrict8485Scalars := [Restrict8485Identity, Restrict8485Omega,
                      Restrict8485Omega^2];

Restrict8485Trace := function(g)
    local dimensions, value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*Restrict8485Identity));
    value := Sum(dimensions, k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

Restrict8485ProjectiveOrder := function(g)
    local k, power;
    power := Restrict8485Identity;
    for k in [1..12] do
        power := power*g;
        if power in Restrict8485Scalars then return k; fi;
    od;
    Error("Projective order exceeds twelve");
end;

Restrict8485One := function(number, target)
    local child, source, edges, edge, image, seen, histogram,
          g, scalar, key, position;
    child := Families[number];
    if child.number <> number or child.familyDimension <> 3
       or child.projectiveGroupId <> [12,4]
       or child.linearGroupId <> [36,12]
       or child.reportedOrder <> 36 then
        Error("Frozen child family metadata changed");
    fi;
    source := Group(child.generators);
    if Size(source) <> 36 or IdGroup(source) <> [36,12]
       or not Restrict8485Omega in source then
        Error("Unexpected child linear group or scalar kernel");
    fi;
    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = number and r.targetNumber = 60
             and r.ok = true and r.status = "embedded"
             and r.classification = "direct" and r.direct = true);
    if Length(edges) <> 1 then
        Error("Missing unique direct strict linear containment witness");
    fi;
    edge := edges[1];
    if edge.sourceOrder <> 36 or edge.targetOrder <> 72
       or edge.sourceDimension <> 3 or edge.targetDimension <> 2
       or not edge.method in ["literal_matrix_subgroup", "A_strict"] then
        Error("Strict containment witness metadata changed");
    fi;
    image := Group(List(child.generators, h -> edge.P^-1*h*edge.P));
    if Size(image) <> 36 or not IsSubgroup(target, image) then
        Error("Saved conjugating matrix does not embed the child");
    fi;

    seen := []; histogram := [];
    for g in Elements(source) do
        if g in seen then continue; fi;
        for scalar in Restrict8485Scalars do
            if Restrict8485Trace(scalar*g) <> Restrict8485Trace(g) then
                Error("Primitive trace depends on scalar lift");
            fi;
            Add(seen, scalar*g);
        od;
        key := [Restrict8485ProjectiveOrder(g), Restrict8485Trace(g)];
        position := PositionProperty(histogram,
            row -> row[1] = key[1] and row[2] = key[2]);
        if position = fail then
            Add(histogram, [key[1], key[2], 1]);
        else
            histogram[position][3] := histogram[position][3] + 1;
        fi;
    od;
    if Length(Set(seen)) <> 36
       or Sum(histogram, row -> row[3]) <> 12
       or Position(histogram, [1,22,1]) = fail
       or Sum(histogram, row -> row[2]*row[3]) <> 36
       or (Sum(histogram, row -> row[2]^2*row[3]) mod 12) <> 0 then
        Error("Incomplete projective character");
    fi;
    Sort(histogram, function(a,b)
        if a[1] <> b[1] then return a[1] < b[1]; fi;
        return a[2] < b[2];
    end);
    Print("family=", number, " parent=60 character=", histogram, "\n");
    return histogram;
end;

if Restrict8485Trace(Restrict8485Identity) <> 22 then
    Error("The identity primitive trace must be 22");
fi;
if IsExistingFile(Restrict8485Output) then
    Error("Refusing to overwrite the character TSV");
fi;
Restrict8485Parent := Families[60];
if Restrict8485Parent.number <> 60
   or Restrict8485Parent.familyDimension <> 2
   or Restrict8485Parent.projectiveGroupId <> [24,14]
   or Restrict8485Parent.linearGroupId <> [72,48]
   or Restrict8485Parent.reportedOrder <> 72 then
    Error("Frozen No. 60 metadata changed");
fi;
Restrict8485Target := Group(Restrict8485Parent.generators);
if Size(Restrict8485Target) <> 72
   or IdGroup(Restrict8485Target) <> [72,48]
   or not Restrict8485Omega in Restrict8485Target then
    Error("Unexpected No. 60 linear group or scalar kernel");
fi;
Restrict8485Rows := [];
## Independent check from the displayed S3 action on two triples.  No. 84's
## extra involution has (+1,-1) multiplicities (3,3); No. 85's have (5,1).
Restrict8485Expected := [
    [ [1,22,1], [2,-2,4], [2,6,3], [3,4,2], [6,-2,2] ],
    [ [1,22,1], [2,-10,1], [2,-2,3], [2,6,3], [3,4,2], [6,2,2] ]
];
for Restrict8485Number in [84,85] do
    Restrict8485Histogram := Restrict8485One(
        Restrict8485Number, Restrict8485Target);
    if Restrict8485Histogram <> Restrict8485Expected[Restrict8485Number-83] then
        Error("Full geometric character differs from the frozen S3 representation");
    fi;
    for Restrict8485Row in Restrict8485Histogram do
        Add(Restrict8485Rows, [Restrict8485Number,
            Restrict8485Row[1], Restrict8485Row[2], Restrict8485Row[3]]);
    od;
od;
PrintTo(Restrict8485Output,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for Restrict8485Row in Restrict8485Rows do
    AppendTo(Restrict8485Output,
        Restrict8485Row[1], "\t", Restrict8485Row[2], "\t",
        Restrict8485Row[3], "\t", Restrict8485Row[4], "\n");
od;
Print("Saved ", Restrict8485Output, "\n");
