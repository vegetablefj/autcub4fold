#############################################################################
## Exact projective primitive-H4 character for No. 104 and its direct
## strict linear embedding into No. 28. Run from remark/catalogue.
## This does not construct or restrict an integral lattice action.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

if not IsBound(R104Output) then
    R104Output := "restriction_104_geometric_character.tsv";;
fi;
R104I := IdentityMat(6);;
R104Scalars := [R104I, E(3)*R104I, E(3)^2*R104I];;

# The equivariant Jacobian ring of a smooth invariant cubic has Hilbert
# numerator det(I-z^2 g^-1) and denominator det(I-z g). The primitive-H4
# trace is det(g) times the sum of its degrees 0, 3, and 6.
R104PrimitiveTrace := function(g)
    local p, q, h, e, n, j, r3, r6, value;
    p := List([1..6], k -> TraceMat(g^k));
    q := List([1..3], k -> TraceMat(g^(-k)));
    h := [1];
    for n in [1..6] do
        Add(h, Sum([1..n], k -> p[k]*h[n-k+1])/n);
    od;
    e := [1];
    for j in [1..3] do
        Add(e, Sum([1..j], k -> (-1)^(k-1)*q[k]*e[j-k+1])/j);
    od;
    r3 := h[4] - e[2]*h[2];
    r6 := h[7] - e[2]*h[5] + e[3]*h[3] - e[4];
    value := DeterminantMat(g)*(1+r3+r6);
    if not IsInt(value) or value < -22 or value > 22 then
        Error("Invalid primitive-H4 trace for No. 104");
    fi;
    return value;
end;;

R104ProjectiveOrder := function(g)
    local k, power;
    power := R104I;
    for k in [1..6] do
        power := power*g;
        if power in R104Scalars then return k; fi;
    od;
    Error("No. 104 projective order exceeds six");
end;;

R104Child := Families[104];;
R104Parent := Families[28];;
if R104Child.number <> 104 or R104Child.familyDimension <> 2 or
   R104Child.projectiveGroupId <> [24,13] or
   R104Child.linearGroupId <> [72,47] or
   R104Parent.number <> 28 or R104Parent.familyDimension <> 1 or
   R104Parent.projectiveGroupId <> [432,745] or
   R104Parent.linearGroupId <> [1296,3545] then
    Error("Frozen family metadata changed");
fi;
R104Source := Group(R104Child.generators);;
R104Target := Group(R104Parent.generators);;
if Size(R104Source) <> 72 or Size(R104Target) <> 1296 or
   IdGroup(R104Source) <> [72,47] or
   IdGroup(R104Target) <> [1296,3545] or
   not E(3)*R104I in R104Source or
   not E(3)*R104I in R104Target then
    Error("Frozen linear groups changed");
fi;
R104Edges := Filtered(FourfoldCrossDimensionPositiveEdges,
    r -> r.sourceNumber = 104 and r.targetNumber = 28 and
         r.ok = true and r.status = "embedded" and
         r.classification = "direct" and r.direct = true);;
if Length(R104Edges) <> 1 or
   R104Edges[1].sourceOrder <> 72 or
   R104Edges[1].targetOrder <> 1296 or
   R104Edges[1].method <> "A_strict" or
   DeterminantMat(R104Edges[1].P) = 0 or
   not ForAll(R104Child.generators,
       g -> R104Edges[1].P^-1*g*R104Edges[1].P in R104Target) then
    Error("No. 104 -> No. 28 direct strict witness failed");
fi;

if R104PrimitiveTrace(R104I) <> 22 then
    Error("Identity must have primitive-H4 trace 22");
fi;
R104Seen := [];;
R104Histogram := [];;
for R104g in Elements(R104Source) do
    if R104g in R104Seen then continue; fi;
    for R104scalar in R104Scalars do
        if R104PrimitiveTrace(R104scalar*R104g) <>
           R104PrimitiveTrace(R104g) then
            Error("Primitive-H4 trace depends on scalar lift");
        fi;
        Add(R104Seen, R104scalar*R104g);
    od;
    R104Key := [R104ProjectiveOrder(R104g),
                R104PrimitiveTrace(R104g)];
    R104Position := fail;
    for R104j in [1..Length(R104Histogram)] do
        if R104Histogram[R104j][1] = R104Key[1] and
           R104Histogram[R104j][2] = R104Key[2] then
            R104Position := R104j;
            break;
        fi;
    od;
    if R104Position = fail then
        Add(R104Histogram, [R104Key[1], R104Key[2], 1]);
    else
        R104Histogram[R104Position][3] :=
            R104Histogram[R104Position][3]+1;
    fi;
od;
if Length(Set(R104Seen)) <> 72 or
   Sum(R104Histogram, row -> row[3]) <> 24 or
   Position(R104Histogram, [1,22,1]) = fail then
    Error("Incomplete No. 104 projective character");
fi;
Sort(R104Histogram, function(a,b)
    if a[1] <> b[1] then return a[1] < b[1]; fi;
    return a[2] < b[2];
end);
if R104Output <> fail then
    if IsExistingFile(R104Output) then
        Error("Refusing to overwrite the character TSV");
    fi;
    PrintTo(R104Output,
        "family_number\tprojective_order\tprimitive_H4_trace\telement_count\n");
    for R104Row in R104Histogram do
        AppendTo(R104Output, "104\t", R104Row[1], "\t",
            R104Row[2], "\t", R104Row[3], "\n");
    od;
    Print("No. 104 -> No. 28 strict witness verified; character=",
        R104Histogram, "\nSaved ", R104Output, "\n");
else
    Print("No. 104 -> No. 28 strict witness verified; character=",
        R104Histogram, "\n");
fi;
