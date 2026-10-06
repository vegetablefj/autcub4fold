#############################################################################
## Exact projective primitive-H4 character of numbered No. 129, checked
## against its frozen direct strict containment in No. 96.
## Run from autcub4fold/remark/catalogue. Refuses to overwrite output.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

Restrict129Output := "restriction_129_geometric_characters.tsv";
Restrict129Omega := E(3)*IdentityMat(6);
Restrict129Scalars := [IdentityMat(6), Restrict129Omega, Restrict129Omega^2];

Restrict129Trace := function(g)
    local dimensions, value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions,k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

Restrict129ProjectiveOrder := function(g)
    local k, power;
    power := IdentityMat(6);
    for k in [1..16] do
        power := power*g;
        if power in Restrict129Scalars then return k; fi;
    od;
    Error("Projective order exceeds 16");
end;

if Families[129].number <> 129 or Families[96].number <> 96
   or Families[129].familyDimension <> 2
   or Families[96].familyDimension <> 0
   or Families[129].projectiveGroupId <> [16,5]
   or Families[96].projectiveGroupId <> [144,69] then
    Error("Frozen numbering, dimension or projective group ID changed");
fi;
Restrict129Source := Group(Families[129].generators);
Restrict129Parent := Group(Families[96].generators);
if Size(Restrict129Source) <> 48 or Size(Restrict129Parent) <> 432
   or not Restrict129Omega in Restrict129Source
   or not Restrict129Omega in Restrict129Parent then
    Error("Unexpected linear group order or scalar kernel");
fi;
Restrict129Edges := Filtered(FourfoldCrossDimensionPositiveEdges,
    r -> r.sourceNumber = 129 and r.targetNumber = 96
         and r.ok = true and r.status = "embedded"
         and r.classification = "direct");
if Length(Restrict129Edges) <> 1 then
    Error("Missing unique direct strict containment witness");
fi;
Restrict129Edge := Restrict129Edges[1];
if Restrict129Edge.sourceOrder <> 48 or Restrict129Edge.targetOrder <> 432
   or Restrict129Edge.sourceDimension <> 2
   or Restrict129Edge.targetDimension <> 0
   or Restrict129Edge.direct <> true or Restrict129Edge.viaNumber <> fail
   or Restrict129Edge.method <> "A_strict" then
    Error("Strict containment metadata changed");
fi;
Restrict129Image := Group(List(Families[129].generators,
    h -> Restrict129Edge.P^-1*h*Restrict129Edge.P));
if not IsSubgroup(Restrict129Parent,Restrict129Image)
   or Size(Restrict129Image) <> Size(Restrict129Source) then
    Error("Saved conjugating matrix does not embed No. 129 in No. 96");
fi;

Restrict129Seen := [];
Restrict129Histogram := [];
for Restrict129G in Elements(Restrict129Source) do
    if Restrict129G in Restrict129Seen then continue; fi;
    for Restrict129Scalar in Restrict129Scalars do
        if Restrict129Trace(Restrict129Scalar*Restrict129G) <>
           Restrict129Trace(Restrict129G) or
           Restrict129ProjectiveOrder(Restrict129Scalar*Restrict129G) <>
           Restrict129ProjectiveOrder(Restrict129G) then
            Error("Primitive character depends on scalar lift");
        fi;
        Add(Restrict129Seen,Restrict129Scalar*Restrict129G);
    od;
    Restrict129Key := [Restrict129ProjectiveOrder(Restrict129G),
                       Restrict129Trace(Restrict129G)];
    Restrict129Position := PositionProperty(Restrict129Histogram,
        row -> row[1] = Restrict129Key[1] and row[2] = Restrict129Key[2]);
    if Restrict129Position = fail then
        Add(Restrict129Histogram,[Restrict129Key[1],Restrict129Key[2],1]);
    else
        Restrict129Histogram[Restrict129Position][3] :=
            Restrict129Histogram[Restrict129Position][3]+1;
    fi;
od;
if Length(Set(Restrict129Seen)) <> 48
   or Sum(Restrict129Histogram,row -> row[3]) <> 16
   or Position(Restrict129Histogram,[1,22,1]) = fail
   or Restrict129Trace(IdentityMat(6)) <> 22 then
    Error("Incomplete projective geometric character");
fi;
Sort(Restrict129Histogram,function(a,b)
    if a[1] <> b[1] then return a[1] < b[1]; fi;
    return a[2] < b[2];
end);
if IsExistingFile(Restrict129Output) then
    Error("Refusing to overwrite existing character TSV");
fi;
PrintTo(Restrict129Output,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for Restrict129Row in Restrict129Histogram do
    AppendTo(Restrict129Output,
        "129\t",Restrict129Row[1],"\t",Restrict129Row[2],"\t",
        Restrict129Row[3],"\n");
od;
Print("No. 129 projective character=",Restrict129Histogram,"\n");
Print("Saved ",Restrict129Output,"\n");
