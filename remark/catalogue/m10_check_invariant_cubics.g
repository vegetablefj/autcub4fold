# Diagnostic of the cubic invariant space of Koike's 3.A6 matrices.
# Run from the repository root.
Read("gap_classification/gap_functions.g");;
w := E(3);;
a := DiagonalMat([1,1,w,w,w^2,w^2]);;
b := (1/3)*[
 [-1,0,-w,0,3*w^2,2*w^2],
 [2,0,2*w,0,0,-w^2],
 [-w^2,0,2,3,0,-w],
 [2*w^2,0,-1,0,0,2*w],
 [2*w,3*w,-w^2,0,0,-1],
 [-w,0,2*w^2,0,0,2]
];;
s := a^2*(b*a^2*b^2*a)^2*a;;
t := b^2*a^2*b*a;;
inv := CF_CubicInvariantBasis([TransposedMat(s),TransposedMat(t)],rec(buildPolynomialObjects:=false,buildStrings:=true));;
Print("invariant dimension=",inv.invariantDimension,"\n");
for p in inv.polynomialStrings do Print("basis=",p,"\n"); od;
QUIT;
