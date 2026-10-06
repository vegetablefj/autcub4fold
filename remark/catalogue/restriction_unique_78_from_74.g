# Abstract subgroup certificate for No. 74 -> No. 78.  The saved lattice
# action identifies the symplectic D8 inside [16,11]; this check verifies
# uniqueness relative to every normal D8 in the abstract parent group.

VerifyRestriction78 := function()
    local G, elts, d8s, a, b, B, normalD8s, N, rotations, C4, children;

    G := SmallGroup(16, 11);
    elts := Elements(G);
    d8s := [];
    for a in elts do
        for b in elts do
            B := Subgroup(G, [a, b]);
            if Size(B) = 8 and IdGroup(B) = [8, 3]
               and not ForAny(d8s, U -> U = B) then
                Add(d8s, B);
            fi;
        od;
    od;
    normalD8s := Filtered(d8s, N -> IsNormal(G, N));
    if Length(normalD8s) = 0 then
        Error("Expected a normal symplectic D8 in [16,11]");
    fi;

    for N in normalD8s do
        rotations := Filtered(Elements(N), x -> Order(x) = 4);
        if Length(rotations) <> 2 then
            Error("Expected the unique order-four cyclic subgroup of D8");
        fi;
        C4 := Subgroup(G, [rotations[1]]);
        children := Filtered(d8s, B -> Intersection(B, N) = C4);
        if Length(children) <> 1 then
            Error("Expected one D8 child with C4 symplectic intersection");
        fi;
        if not IsNormal(G, children[1]) then
            Error("Expected the unique child to be normal");
        fi;
    od;

    Print("No. 74 -> No. 78: each normal D8 has one normal D8 child with C4 intersection.\n");
end;;

VerifyRestriction78();
