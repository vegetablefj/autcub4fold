#############################################################################
## Exact projective primitive-H4 character of No. 116 and its direct strict
## containment in No. 94. Run from autcub4fold/remark/catalogue.
## This script refuses to replace an existing output table.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

Restrict116Output := "restriction_116_geometric_character.tsv";
Restrict116Omega := E(3)*IdentityMat(6);
Restrict116Scalars := [IdentityMat(6),Restrict116Omega,Restrict116Omega^2];

Restrict116Trace := function(g)
    local dimensions,value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions,k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;

Restrict116ProjectiveOrder := function(g,bound)
    local k,power;
    power := IdentityMat(6);
    for k in [1..bound] do
        power := power*g;
        if power in Restrict116Scalars then return k; fi;
    od;
    Error("Projective order exceeds the full-group order");
end;

if Families[116].number <> 116 or Families[94].number <> 94
   or Families[116].familyDimension <> 4
   or Families[94].familyDimension <> 1
   or Families[116].projectiveGroupId <> [18,3]
   or Families[94].projectiveGroupId <> [72,27] then
    Error("Frozen numbering, dimensions, or projective IDs changed");
fi;
Restrict116Source := Group(Families[116].generators);
Restrict116Target := Group(Families[94].generators);
if Size(Restrict116Source) <> 54 or Size(Restrict116Target) <> 216
   or not Restrict116Omega in Restrict116Source
   or not Restrict116Omega in Restrict116Target then
    Error("Unexpected linear group order or scalar kernel");
fi;

Restrict116Edges := Filtered(FourfoldCrossDimensionPositiveEdges,
    r -> r.sourceNumber = 116 and r.targetNumber = 94
         and r.ok = true and r.status = "embedded"
         and r.classification = "direct");
if Length(Restrict116Edges) <> 1 then
    Error("Missing unique direct strict containment witness");
fi;
Restrict116Edge := Restrict116Edges[1];
if Restrict116Edge.sourceOrder <> 54
   or Restrict116Edge.targetOrder <> 216
   or Restrict116Edge.sourceDimension <> 4
   or Restrict116Edge.targetDimension <> 1
   or Restrict116Edge.direct <> true
   or Restrict116Edge.viaNumber <> fail
   or not Restrict116Edge.method in ["literal_matrix_subgroup","A_strict"] then
    Error("Strict containment witness metadata changed");
fi;
Restrict116Image := Group(List(Families[116].generators,
    h -> Restrict116Edge.P^-1*h*Restrict116Edge.P));
if not IsSubgroup(Restrict116Target,Restrict116Image)
   or Size(Restrict116Image) <> 54 then
    Error("Saved conjugating matrix does not embed No. 116 in No. 94");
fi;

if Restrict116Trace(IdentityMat(6)) <> 22 then
    Error("The identity primitive trace must be 22");
fi;
Restrict116Seen := [];
Restrict116Histogram := [];
for Restrict116G in Elements(Restrict116Source) do
    if Restrict116G in Restrict116Seen then continue; fi;
    for Restrict116Scalar in Restrict116Scalars do
        if Restrict116Trace(Restrict116Scalar*Restrict116G) <>
           Restrict116Trace(Restrict116G)
           or Restrict116ProjectiveOrder(Restrict116Scalar*Restrict116G,18) <>
              Restrict116ProjectiveOrder(Restrict116G,18) then
            Error("Projective character depends on scalar lift");
        fi;
        Add(Restrict116Seen,Restrict116Scalar*Restrict116G);
    od;
    Restrict116Key := [Restrict116ProjectiveOrder(Restrict116G,18),
                       Restrict116Trace(Restrict116G)];
    Restrict116Position := PositionProperty(Restrict116Histogram,
        row -> row[1] = Restrict116Key[1] and row[2] = Restrict116Key[2]);
    if Restrict116Position = fail then
        Add(Restrict116Histogram,[Restrict116Key[1],Restrict116Key[2],1]);
    else
        Restrict116Histogram[Restrict116Position][3] :=
            Restrict116Histogram[Restrict116Position][3]+1;
    fi;
od;
if Length(Set(Restrict116Seen)) <> 54
   or Sum(Restrict116Histogram,row -> row[3]) <> 18
   or Position(Restrict116Histogram,[1,22,1]) = fail then
    Error("Incomplete projective character");
fi;
Sort(Restrict116Histogram,function(a,b)
    if a[1] <> b[1] then return a[1] < b[1]; fi;
    return a[2] < b[2];
end);
if IsExistingFile(Restrict116Output) then
    Error("Refusing to overwrite existing character TSV");
fi;
PrintTo(Restrict116Output,
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
for Restrict116Row in Restrict116Histogram do
    AppendTo(Restrict116Output,"116\t",Restrict116Row[1],"\t",
        Restrict116Row[2],"\t",Restrict116Row[3],"\n");
od;
Print("No. 116 in No. 94: projective primitive-H4 character = ",
      Restrict116Histogram,"\nSaved ",Restrict116Output,"\n");
