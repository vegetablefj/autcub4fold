#############################################################################
## The three No. 121-type classes inside the frozen No. 74 projective group.
## Run from autcub4fold/remark/catalogue with GAP.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Read("../../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_positive_edges.g");

No121PrimitiveTrace := function(g)
    local dimensions, value;
    dimensions := List([1, E(3), E(3)^2],
        alpha -> 6 - RankMat(g - alpha*IdentityMat(6)));
    value := Sum(dimensions, k -> (-2)^k)/3;
    if not IsInt(value) then
        Error("Nonintegral primitive H4 trace");
    fi;
    return value;
end;;

No121CheckThreeClasses := function()
    local parentLinear, scalarKernel, quotient, parentProjective,
          symplecticLinear, symplecticProjective, frozenLinear,
          frozenTwoSylow, expectedLinearTraces, expectedPrimitiveCharacter,
          edges, geometricImage, geometricProjective, abstractParent,
          normalD8, automorphisms, subgroup, orbit, classes, cc,
          projectiveChild, linearChild, twoSylow, primitiveCharacter,
          linearTraces, eligible, matched, geometricMatches, representative;

    parentLinear := Group(Families[74].generators);
    scalarKernel := Group(E(3)*IdentityMat(6));
    quotient := NaturalHomomorphismByNormalSubgroup(
        parentLinear, scalarKernel);
    parentProjective := Image(quotient);
    symplecticLinear := Group(Families[73].generators);
    symplecticProjective := Image(quotient, symplecticLinear);
    if Size(parentLinear) <> 48 or Size(scalarKernel) <> 3
       or IdGroup(parentProjective) <> [16,11]
       or IdGroup(symplecticProjective) <> [8,3]
       or not IsNormal(parentProjective, symplecticProjective) then
        Error("Frozen No. 74 group pair changed");
    fi;

    abstractParent := SmallGroup(16,11);
    normalD8 := Filtered(NormalSubgroups(abstractParent),
        n -> Size(n) = 8 and IdGroup(n) = [8,3]);
    automorphisms := AutomorphismGroup(abstractParent);
    if Length(normalD8) <> 4 then
        Error("Unexpected normal D8 count");
    fi;
    for subgroup in normalD8 do
        orbit := Set(List(Elements(automorphisms),
            a -> PositionProperty(normalD8,
                n -> Image(a, subgroup) = n)));
        if orbit <> [1..4] then
            Error("The normal D8 subgroups are not one automorphism orbit");
        fi;
    od;

    frozenLinear := Group(Families[121].generators);
    frozenTwoSylow := SylowSubgroup(frozenLinear, 2);
    expectedLinearTraces := [0,2,4,6];
    expectedPrimitiveCharacter :=
        [[1,22], [2,-10], [2,-2], [2,6]];
    if IdGroup(frozenLinear) <> [12,5]
       or not IsSubgroup(frozenLinear, scalarKernel)
       or Size(frozenTwoSylow) <> 4
       or SortedList(List(Elements(frozenTwoSylow), TraceMat))
          <> expectedLinearTraces then
        Error("Frozen No. 121 strict representation changed");
    fi;

    edges := Filtered(FourfoldCrossDimensionPositiveEdges,
        r -> r.sourceNumber = 121 and r.targetNumber = 74
             and r.classification = "direct" and r.ok = true);
    if Length(edges) <> 1 then
        Error("Expected one direct strict containment witness");
    fi;
    geometricImage := Group(List(Families[121].generators,
        g -> edges[1].P^-1*g*edges[1].P));
    if not IsSubgroup(parentLinear, geometricImage) then
        Error("Saved No. 121 subgroup witness failed");
    fi;
    geometricProjective := Image(quotient, geometricImage);

    eligible := 0; matched := 0; geometricMatches := 0;
    classes := ConjugacyClassesSubgroups(parentProjective);
    for cc in classes do
        projectiveChild := Representative(cc);
        if Size(projectiveChild) <> 4
           or IdGroup(projectiveChild) <> [4,2]
           or Size(Intersection(projectiveChild, symplecticProjective)) <> 2
        then
            continue;
        fi;
        eligible := eligible + 1;
        if not ForAll(Elements(projectiveChild), b ->
            ForAll([0,1,2], k ->
                No121PrimitiveTrace(E(3)^k*PreImagesRepresentative(quotient,b))
                = No121PrimitiveTrace(PreImagesRepresentative(quotient,b))))
        then
            Error("Primitive trace depends on a scalar lift");
        fi;
        primitiveCharacter := SortedList(List(Elements(projectiveChild),
            b -> [Order(b), No121PrimitiveTrace(
                PreImagesRepresentative(quotient,b))]));
        if primitiveCharacter <> expectedPrimitiveCharacter then
            continue;
        fi;
        matched := matched + 1;
        linearChild := PreImage(quotient, projectiveChild);
        twoSylow := SylowSubgroup(linearChild, 2);
        linearTraces := SortedList(List(Elements(twoSylow), TraceMat));
        if IdGroup(linearChild) <> [12,5]
           or Size(twoSylow) <> 4
           or not IsAbelian(linearChild)
           or linearTraces <> expectedLinearTraces then
            Error("A character-matched class has the wrong strict representation");
        fi;
        representative := geometricProjective in cc;
        if representative then
            geometricMatches := geometricMatches + 1;
        fi;
        Print("No. 121-type parent class ", matched,
              ": parent orbit=", Size(cc),
              ", strict 2-Sylow traces=", linearTraces,
              ", contains saved geometric witness=", representative, "\n");
    od;
    if eligible <> 7 or matched <> 3 or geometricMatches <> 1 then
        Error("Unexpected No. 121 subgroup class census");
    fi;
    Print("PASS: three strict GL(6)-equivalent No. 121-type classes ",
          "inside No. 74; four normal D8 subgroups form one Aut([16,11]) orbit.\n");
end;;

No121CheckThreeClasses();
