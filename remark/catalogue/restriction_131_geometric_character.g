# Exact projective primitive-H4 character of No. 131 and its direct
# strict linear containment in the saved No. 24 family.
# Run from autcub4fold/remark/catalogue; never replaces an output.

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

R131Output := "restriction_131_geometric_character.tsv";;
R131Omega := E(3)*IdentityMat(6);;
R131Scalars := [IdentityMat(6), R131Omega, R131Omega^2];;
R131Key := [];;

R131Trace := function(g)
    local dimensions, value;
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions,k -> (-2)^k)/3;
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive H4 trace");
    fi;
    return value;
end;;

R131ProjectiveOrder := function(g)
    local k, power;
    power := IdentityMat(6);
    for k in [1..24] do
        power := power*g;
        if power in R131Scalars then return k; fi;
    od;
    Error("Projective order exceeds 24");
end;;

if Families[131].number <> 131 or Families[24].number <> 24
   or Families[131].familyDimension <> 1
   or Families[24].familyDimension <> 0
   or Families[131].projectiveGroupId <> [24,9] then
    Error("Frozen numbering, dimension, or projective ID changed");
fi;
R131Source := Group(Families[131].generators);;
R131Parent := Group(Families[24].generators);;
if Size(R131Source) <> 72 or Size(R131Parent) <> 17496
   or not R131Omega in R131Source
   or not R131Omega in R131Parent then
    Error("Unexpected strict group order or scalar kernel");
fi;
R131Edges := Filtered(FourfoldCrossDimensionPositiveEdges,
    r -> r.sourceNumber = 131 and r.targetNumber = 24
         and r.ok = true and r.status = "embedded"
         and r.classification = "direct");;
if Length(R131Edges) <> 1 then
    Error("Missing unique direct strict containment witness");
fi;
R131Edge := R131Edges[1];;
if R131Edge.sourceOrder <> 72 or R131Edge.targetOrder <> 17496
   or R131Edge.sourceDimension <> 1 or R131Edge.targetDimension <> 0
   or R131Edge.direct <> true or R131Edge.viaNumber <> fail
   or R131Edge.method <> "subgroup_classes_full_aut" then
    Error("Direct containment metadata changed");
fi;
R131Image := Group(List(Families[131].generators,
    h -> R131Edge.P^-1*h*R131Edge.P));;
if not IsSubgroup(R131Parent,R131Image)
   or Size(R131Image) <> Size(R131Source) then
    Error("Saved conjugating matrix does not embed No. 131 in No. 24");
fi;

R131Seen := [];;
R131Histogram := [];;
for R131G in Elements(R131Source) do
    if R131G in R131Seen then continue; fi;
    for R131Scalar in R131Scalars do
        if R131Trace(R131Scalar*R131G) <> R131Trace(R131G)
           or R131ProjectiveOrder(R131Scalar*R131G)
              <> R131ProjectiveOrder(R131G) then
            Error("Primitive character depends on scalar lift");
        fi;
        Add(R131Seen,R131Scalar*R131G);
    od;
    R131Key := [R131ProjectiveOrder(R131G),R131Trace(R131G)];;
R131Position := PositionProperty(R131Histogram,
        function(r)
            return r[1] = R131Key[1] and r[2] = R131Key[2];
        end);;
    if R131Position = fail then
        Add(R131Histogram,[R131Key[1],R131Key[2],1]);
    else
        R131Histogram[R131Position][3] :=
            R131Histogram[R131Position][3]+1;
    fi;
od;
if Length(Set(R131Seen)) <> 72
   or Sum(R131Histogram,function(r) return r[3]; end) <> 24
   or Position(R131Histogram,[1,22,1]) = fail then
    Error("Incomplete projective character");
fi;
Sort(R131Histogram,function(a,b)
    if a[1] <> b[1] then return a[1] < b[1]; fi;
    return a[2] < b[2];
end);
R131ExpectedLines := [
    "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n"
];;
for R131Row in R131Histogram do
    Add(R131ExpectedLines,Concatenation("131\t",String(R131Row[1]),
        "\t",String(R131Row[2]),"\t",String(R131Row[3]),"\n"));
od;
if IsExistingFile(R131Output) then
    R131Stream := InputTextFile(R131Output);;
    if R131Stream = fail then Error("Could not read existing TSV"); fi;
    for R131Line in R131ExpectedLines do
        if ReadLine(R131Stream) <> R131Line then
            Error("Existing TSV differs from recomputed exact character");
        fi;
    od;
    if ReadLine(R131Stream) <> fail then
        Error("Existing TSV has extra rows");
    fi;
    CloseStream(R131Stream);
    Print("PASS: No. 131 direct containment and existing character TSV match exactly: ",
        R131Histogram,"\n");
else
    PrintTo(R131Output,R131ExpectedLines[1]);
    for R131Line in R131ExpectedLines{[2..Length(R131ExpectedLines)]} do
        AppendTo(R131Output,R131Line);
    od;
    Print("PASS: No. 131 direct containment and character verified; saved ",
        R131Output,"\n",R131Histogram,"\n");
fi;
