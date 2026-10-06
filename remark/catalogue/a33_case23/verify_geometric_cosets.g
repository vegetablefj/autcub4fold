#############################################################################
## Recompute the geometric reference histograms for Nos. 56 and 57.
## Run with GAP from this directory. This script reads frozen matrix data
## and prints its result; it does not write any files.
#############################################################################

Read("../../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");

A33PrimitiveH4Trace := function(g)
    local dimensions, value;
    # Chenevert's formula for a form-fixing lift of a smooth cubic fourfold.
    dimensions := List([1, E(3), E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions, k -> (-2)^k)/3;
    if not IsInt(value) then
        Error("Nonintegral primitive H4 trace");
    fi;
    return value;
end;

A33GeometricCosetHistogram := function(number)
    local family, linear, symplecticLinear, representatives, scalars,
          omega, extra, histogram, k, g, pair, position;

    family := Families[number];
    if family.number <> number or family.familyDimension <> 2
       or family.reportedOrder <> 324
       or family.projectiveGroupId <> [108, 38]
       or Length(family.generators) <> 5 then
        Error("Unexpected frozen family metadata");
    fi;

    # The first three matrices generate A_{3,3} (order 18). The fourth is
    # the central cubic scalar; adjoining it gives its form-fixing lift.
    representatives := Group(family.generators{[1..3]});
    omega := E(3)*IdentityMat(6);
    scalars := Group(omega);
    symplecticLinear := Group(family.generators{[1..4]});
    linear := Group(family.generators);
    extra := family.generators[5];
    if Size(representatives) <> 18 or Size(scalars) <> 3
       or Size(Intersection(representatives, scalars)) <> 1
       or Size(symplecticLinear) <> 54 or Size(linear) <> 324
       or not IsNormal(linear, symplecticLinear)
       or not ForAll(Elements(representatives),
           k -> DeterminantMat(k) = 1) then
        Error("Unexpected A_{3,3} group or scalar kernel");
    fi;

    # Each extra*k is a distinct projective element in one primitive
    # quotient coset. The inverse coset has the same trace-pair histogram.
    histogram := [];
    for k in Elements(representatives) do
        g := extra*k;
        if not ForAll([0..2], j ->
            A33PrimitiveH4Trace(omega^j*g) = A33PrimitiveH4Trace(g))
           or not ForAll([0..2], j ->
            A33PrimitiveH4Trace(omega^j*g^2) = A33PrimitiveH4Trace(g^2)) then
            Error("Primitive trace depends on a cubic scalar lift");
        fi;
        pair := [A33PrimitiveH4Trace(g), A33PrimitiveH4Trace(g^2)];
        position := PositionProperty(histogram,
            row -> row[1] = pair[1] and row[2] = pair[2]);
        if position = fail then
            Add(histogram, [pair[1], pair[2], 1]);
        else
            histogram[position][3] := histogram[position][3] + 1;
        fi;
    od;
    Sort(histogram);
    if Sum(histogram, row -> row[3]) <> 18 then
        Error("Incomplete projective primitive coset");
    fi;
    return histogram;
end;

if Families[56].generators{[1..4]} <>
   Families[57].generators{[1..4]} then
    Error("Nos. 56 and 57 no longer have the same symplectic lift");
fi;

A33Histogram56 := A33GeometricCosetHistogram(56);
A33Histogram57 := A33GeometricCosetHistogram(57);
Print("No. 56: ", A33Histogram56, "\n");
Print("No. 57: ", A33Histogram57, "\n");

if A33Histogram56 <> [[-1, 7, 3], [2, -2, 6], [5, -11, 6], [5, 7, 3]]
   or A33Histogram57 <> [[2, -2, 12], [5, -11, 6]] then
    Error("Geometric histograms differ from compare_case23_cosets.jl");
fi;
Print("Both geometric reference histograms verified.\n");
QUIT;
