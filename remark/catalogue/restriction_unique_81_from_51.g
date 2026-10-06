# Abstract subgroup certificate for No. 51 -> No. 81.
# This checks the order-32 group only; lattice actions are checked separately.

CheckRestrictionUnique81 := function()
    local G, classes, q8Classes, cls, Q8, B, overlap, matchingCount,
          selected, quotient, element, cosetGenerator;

    G := SmallGroup(32, 11);
    classes := ConjugacyClassesSubgroups(G);

    q8Classes := [];
    for cls in classes do
        if IdGroup(Representative(cls)) = [8, 4] then
            Add(q8Classes, cls);
        fi;
    od;
    if Length(q8Classes) <> 1 or Size(q8Classes[1]) <> 1 then
        Error("Expected a unique normal Q8 subgroup of [32,11]");
    fi;
    Q8 := Representative(q8Classes[1]);
    if not IsNormal(G, Q8) then
        Error("The selected Q8 subgroup is not normal");
    fi;

    matchingCount := 0;
    selected := fail;
    for cls in classes do
        B := Representative(cls);
        if IdGroup(B) = [16, 2] then
            overlap := Intersection(B, Q8);
            if IdGroup(overlap) = [4, 1] then
                if not IsNormal(B, overlap) then
                    Error("The C4 intersection is not normal in [16,2]");
                fi;
                quotient := FactorGroup(B, overlap);
                if IdGroup(quotient) = [4, 1] then
                    # A class can contain several distinct subgroups.
                    matchingCount := matchingCount + Size(cls);
                    selected := B;
                fi;
            fi;
        fi;
    od;
    if matchingCount <> 1 then
        Error("Expected exactly one [16,2] subgroup with C4 intersection and quotient");
    fi;
    if not IsNormal(G, selected) then
        Error("The unique No. 81 subgroup is not normal in [32,11]");
    fi;

    overlap := Intersection(selected, Q8);
    cosetGenerator := fail;
    for element in Elements(selected) do
        if not (element in overlap) and not (element^2 in overlap)
           and element^4 in overlap then
            cosetGenerator := element;
            break;
        fi;
    od;
    if cosetGenerator = fail then
        Error("Could not find a generator of the order-four quotient");
    fi;
    if Size(Group(Concatenation(GeneratorsOfGroup(overlap),
                                [cosetGenerator]))) <> 16 then
        Error("The C4 intersection and quotient generator do not generate [16,2]");
    fi;

    Print("No. 51 -> No. 81: unique normal [16,2] subgroup; ",
          "Q8 intersection C4; quotient C4.\n");
end;

CheckRestrictionUnique81();
Unbind(CheckRestrictionUnique81);
