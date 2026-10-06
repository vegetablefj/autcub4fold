#############################################################################
## No. 97 inside No. 74: compare the two exact C2^2 subgroups.
## Run from autcub4fold/remark/catalogue with GAP.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");

No97Omega := E(3) * IdentityMat(6);
No97Parent := Group(Families[74].generators);
No97Kernel := Group(Families[74].generators{[1..3]});
No97FrozenKernel := Group(Families[73].generators);
No97Standard := Group(Families[97].generators);
No97A := Families[74].generators[1];
No97B := Families[74].generators[2];
if Size(No97Parent) <> 48 or Size(No97Kernel) <> 24
   or Size(No97Standard) <> 12 or No97Kernel <> No97FrozenKernel then
    Error("Frozen group orders changed");
fi;

No97ToPerm := IsomorphismPermGroup(No97Parent);
No97Perm := Image(No97ToPerm);
No97SubgroupsPerm := Filtered(AllSubgroups(No97Perm),
    B -> Size(B) = 12 and Image(No97ToPerm,No97Omega) in B
         and IdGroup(B) = [12,5]
         and IsSubgroup(Image(No97ToPerm,No97Kernel),B));
No97Subgroups := List(No97SubgroupsPerm,
    B -> Group(List(GeneratorsOfGroup(B),
        x -> PreImagesRepresentative(No97ToPerm,x))));
if Length(No97Subgroups) <> 2 then
    Error("Expected precisely two exact C3 x C2^2 subgroups");
fi;

No97One := Group([No97Omega,No97B*No97A,No97B^2]);
No97Two := Group([No97Omega,No97A,No97B^2]);
if No97One = No97Two or
   not ForAll([No97One,No97Two], B -> B in No97Subgroups) or
   not ForAll([No97One,No97Two], B -> IsNormal(No97Parent,B)) then
    Error("The two explicit subgroups are not the two normal parent classes");
fi;

No97VFour := List([No97One,No97Two], B -> SylowSubgroup(B,2));
No97StandardVFour := SylowSubgroup(No97Standard,2);
for No97V in Concatenation(No97VFour,[No97StandardVFour]) do
    if Size(No97V) <> 4 or Set(List(Elements(No97V), TraceMat)) <> [2,6] then
        Error("Unexpected degree-six V4 character");
    fi;
od;

# Our conjugation convention is Q^-1 * g * Q. The row/column convention in
# the cubic code is immaterial because the equality is checked literally.
No97Q := IdentityMat(6);
No97Q[3][3] := 0; No97Q[3][4] := 1;
No97Q[4][3] := 1; No97Q[4][4] := 0;
No97Q[5][5] := -E(4);
if No97Q^-1*(No97B*No97A)*No97Q <> No97A or
   No97Q^-1*(No97B^2)*No97Q <> No97B^2 or
   Group(List(GeneratorsOfGroup(No97One),g -> No97Q^-1*g*No97Q))
       <> No97Two then
    Error("The explicit six-dimensional conjugator Q failed");
fi;

# The Hadamard change of basis diagonalizes the swap of coordinates 5,6.
# This identifies the second subgroup with the frozen No. 97 sign group.
No97R := IdentityMat(6);
No97R[5][5] := 1; No97R[5][6] := 1;
No97R[6][5] := 1; No97R[6][6] := -1;
if Group(List(GeneratorsOfGroup(No97Two),g -> No97R^-1*g*No97R))
   <> No97Standard then
    Error("The second subgroup is not the frozen No. 97 group");
fi;

Print("No. 97: two distinct normal parent subgroups, hence not parent-conjugate; ",
      "both have V4 character 6+2+2+2 and are GL6-conjugate to ",
      "the frozen No. 97 group. Explicit Q and R checks passed.\n");
