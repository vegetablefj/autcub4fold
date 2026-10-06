# Abstract subgroup precheck for the lattice restriction No. 51 -> No. 82.
# It does not identify lattice actions; see restriction_pilot_82_from_51.jl.

G := SmallGroup(32, 11);;
classes := ConjugacyClassesSubgroups(G);;
q8 := Filtered(classes, c -> IdGroup(Representative(c)) = [8, 4]);;
target := Filtered(classes, c -> IdGroup(Representative(c)) = [16, 6]);;
if Length(q8) <> 1 or Length(target) <> 1 then
    Error("Expected unique Q8 and [16,6] conjugacy classes");
fi;
if Size(q8[1]) <> 1 or Size(target[1]) <> 1 then
    Error("Expected both subgroups to be normal");
fi;
if IdGroup(Intersection(Representative(q8[1]), Representative(target[1]))) <> [4, 1] then
    Error("Expected the symplectic intersection to be C4");
fi;
Print("No. 51 -> No. 82: unique normal [16,6] subgroup; intersection with Q8 is C4.\n");
