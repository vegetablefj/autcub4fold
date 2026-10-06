# Exact coordinate certificate for both M10 equations.
# Run from the project root with GAP 4.15:
#   Read("remark/catalogue/verify_m10_lz_koike_conjugacy.g");
# All variables are column vectors.  If x = B*y, then F_Koike(B*y)
# is compared coefficient by coefficient with the cubic in LZ (4.3).
# The generators mat1, mat2, mat3 and the 20-term cubic are also in
# article/yyz groups.txt, X'_10.  Koike's (2.8) prints incorrect plus
# signs in its last three blocks.  The 3.A6-invariant second cubic is
# g = 3*A - 4*B - 5*C - 8*D; the invariance checks below certify it.
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
r0 := [
 [2*w+3,-w,-2*(w+1),-3*w-1,w-2,-7],
 [-w-3,-w,7*(w+1),3*w+2,1-2*w,2],
 [2*w,-4*w,w-2,3*w+2,w-2,3*w+2],
 [-7*w,-4*w,1-2*w,-3*w-1,1-2*w,-3*w-1],
 [2*w+3,-w,w-2,-7,-2*(w+1),-3*w-1],
 [-w-3,-w,1-2*w,2,7*(w+1),3*w+2]
];;
r := r0/(3*Sqrt(6));;
mat1 := [[1,0,0,0,0,0],[0,0,1,0,0,0],[0,1,0,0,0,0],
 [0,0,0,0,1,0],[0,0,0,1,0,0],[0,0,0,0,0,1]];;
mat2 := [[0,1,0,0,0,0],[0,0,w,0,0,0],[0,0,0,1,0,0],
 [w^2,0,0,0,0,0],[0,0,0,0,0,1],[0,0,0,0,1,0]];;
mat3 := (1/Sqrt(6))*[[1,w,w^2,w,1,w],
 [w^2,1,1,w,w,w],[w,1,w^2,w,w^2,w^2],
 [w^2,w^2,w,w,1,w^2],[1,w^2,1,w,w^2,1],
 [w^2,w^2,w^2,w^2,w^2,w]];;
GK := Group(s,t,r);;
GY := Group(mat1,mat2,mat3);;
if Size(GK)<>2160 or Size(GY)<>2160
   or Size(Centre(GK))<>3 or Size(Centre(GY))<>3 then
  Error("Unexpected linear M10 group order or centre.");
fi;
B := [
 [w^2,-2*w^2,-w^2,-w,-2*w,1],
 [-2*w^2,w^2,-w^2,-w,w,-2],
 [-2*w^2,-2*w^2,-1,-1,w,1],
 [w^2,w^2,-1,-1,-2*w,-2],
 [w^2,-2*w^2,-w,-w^2,w,-2],
 [-2*w^2,w^2,-w,-w^2,-2*w,1]
];;
if DeterminantMat(B)=0 then Error("B is singular."); fi;
images := List([s,t,r],h->B^-1*h*B);;
if not ForAll(images,h->h in GY) then
  Error("B does not conjugate Koike's linear group onto YYZ's.");
fi;
Print("linear groups: both order 2160, centres order 3; B conjugates them\n");
H := Group(s,t);;
conjcyc := h -> List(h,row->List(row,z->GaloisCyc(z,-1)));;
Print("complex conjugation normalizes Koike 3.A6: ",
  conjcyc(s) in H and conjcyc(t) in H,"\n");
mons := [];;
for ii in [1..6] do for jj in [ii..6] do for kk in [jj..6] do
  Add(mons,[ii,jj,kk]);
od; od; od;
mkcoeff := function(terms)
  local coeff, term, p;
  coeff := List(mons,x->0);
  for term in terms do
    p := Position(mons,SortedList(term[2]));
    coeff[p] := coeff[p] + term[1];
  od;
  return coeff;
end;;
cubicImageMatrix := function(M)
  local rows, mon, row, ii, jj, kk, entry, triple, p;
  rows := [];
  for mon in mons do
    row := List(mons,x->0);
    for ii in [1..6] do for jj in [1..6] do for kk in [1..6] do
      entry := M[mon[1]][ii]*M[mon[2]][jj]*M[mon[3]][kk];
      if entry<>0 then
        triple := SortedList([ii,jj,kk]);
        p := Position(mons,triple);
        row[p] := row[p]+entry;
      fi;
    od; od; od;
    Add(rows,row);
  od;
  return rows;
end;;

# Koike (2.3) and corrected (2.8).
fterms := [];;
for ii in [1..6] do Add(fterms,[2,[ii,ii,ii]]); od;
for pair in [[1,2],[3,4],[5,6]] do
  Add(fterms,[3,[pair[1],pair[1],pair[2]]]);
  Add(fterms,[3,[pair[1],pair[2],pair[2]]]);
od;
for triple in [[2,3,5],[1,4,5],[1,3,6],[2,4,6]] do Add(fterms,[2,triple]); od;
for triple in [[1,3,5],[2,4,5],[2,3,6],[1,4,6]] do Add(fterms,[4,triple]); od;
gterms := [];;
for triple in [[1,2,3],[1,2,4],[1,2,5],[1,2,6],[1,3,4],[1,3,5],
  [1,5,6],[2,3,4],[2,5,6],[3,5,6],[3,4,6],[3,4,5],[4,5,6]] do
  Add(gterms,[3,triple]);
od;
for triple in [[1,4,5],[1,3,6],[2,3,5],[2,4,6]] do Add(gterms,[-4,triple]); od;
for triple in [[1,4,6],[2,3,6],[2,4,5]] do Add(gterms,[-5,triple]); od;
Add(gterms,[-8,[1,3,5]]);;
fc := mkcoeff(fterms);; gc := mkcoeff(gterms);;
gcPrinted := mkcoeff(List(gterms,term->[AbsInt(term[1]),term[2]]));;
ps := cubicImageMatrix(s);; pt := cubicImageMatrix(t);;
if fc*ps<>fc or fc*pt<>fc or gc*ps<>gc or gc*pt<>gc then
  Error("Koike's f or corrected g fails 3.A6 invariance.");
fi;
if gcPrinted*ps=gcPrinted and gcPrinted*pt=gcPrinted then
  Error("The printed-sign cubic unexpectedly is invariant.");
fi;
Print("corrected f,g: invariant under 3.A6; printed-sign g: not invariant\n");

# Laza--Zheng (4.3).  The 20 coefficients are 1, zeta_6-1, or -zeta_6.
qterms := [];;
for triple in [[1,2,3],[1,2,4],[1,2,6],[1,3,5],[1,3,6],
  [2,4,5],[2,4,6],[3,4,5],[3,5,6],[4,5,6]] do
  Add(qterms,[1,triple]);
od;
z6 := E(6);;
for triple in [[1,2,5],[1,3,4],[1,4,5],[2,3,4],[2,3,5]] do
  Add(qterms,[z6-1,triple]);
od;
for triple in [[1,4,6],[1,5,6],[2,3,6],[2,5,6],[3,4,6]] do
  Add(qterms,[-z6,triple]);
od;
if Length(qterms)<>20 then Error("Wrong number of LZ mixed monomials."); fi;
e0 := mkcoeff(List([1..6],ii->[1,[ii,ii,ii]]));;
qc := mkcoeff(qterms);;
z24 := E(24);;
c0 := (-3*z24^7-3*z24^5+3*z24^4-3*z24^3+6*z24-3)/5;;
yy := e0+c0*qc;;
yyConjugate := e0+GaloisCyc(c0,7)*qc;;

# Compare with the two numbered catalogue equations, coefficient by coefficient.
Read("gap_classification/gap_saturation/gap_large_koike_families.g");;
m10rows := Filtered(LargeKoikeFamilies,
  row -> row.symplecticPart="M_10" and row.rankS=20);;
if Length(m10rows)<>2 or
   not ForAll(m10rows,row->Length(row.cubicInvariantBasisStrings)=1) then
  Error("Expected exactly two rank-20 M10 rows with one cubic each.");
fi;
if LargeKoikeFamilies[71]<>m10rows[1] or
   LargeKoikeFamilies[72]<>m10rows[2] then
  Error("The M10 records are not source entries 71 and 72.");
fi;
polyRing := PolynomialRing(CF(24),["x1","x2","x3","x4","x5","x6"]);;
variables := IndeterminatesOfPolynomialRing(polyRing);;
x1 := variables[1];; x2 := variables[2];; x3 := variables[3];;
x4 := variables[4];; x5 := variables[5];; x6 := variables[6];;
coeffPolynomial := coeff -> Sum([1..Length(mons)],
  j -> coeff[j]*Product(mons[j],i->variables[i]));;
row5 := EvalString(m10rows[1].cubicInvariantBasisStrings[1]);;
row6 := EvalString(m10rows[2].cubicInvariantBasisStrings[1]);;
if coeffPolynomial(yy)<>row5 or coeffPolynomial(yyConjugate)<>row6
   or row5=row6 then
  Error("The LZ cubic and its Galois conjugate do not match rows 5 and 6.");
fi;
Print("LZ (4.3) and its zeta_24 -> zeta_24^7 conjugate equal rows 5 and 6\n");

im := cubicImageMatrix(B);;
fB := fc*im;; gB := gc*im;;
plusB := fB-(7+3*Sqrt(6))*gB;;
minusB := fB-(7-3*Sqrt(6))*gB;;
pr := cubicImageMatrix(r);;
fplus := fc-(7+3*Sqrt(6))*gc;;
fminus := fc-(7-3*Sqrt(6))*gc;;
if fplus*pr<>fplus or fminus*pr<>-fminus then
  Error("Koike's normalizer does not have the stated eigen-cubics.");
fi;
Print("Koike r acts on F_+, F_- with eigenvalues +1, -1\n");
lambda := -54*(8+3*Sqrt(6));;
lambdaMinus := -54*(8-3*Sqrt(6));;
if plusB<>lambda*yy then
  Error("Koike F_+(B*y) does not equal lambda times LZ (4.3).");
fi;
if minusB<>lambdaMinus*yyConjugate then
  Error("Koike F_-(B*y) does not equal lambdaMinus times row 6.");
fi;
Print("all 56 coefficients: F_+(B*y) = -54*(8+3*Sqrt(6))*LZ(4.3)\n");
Print("all 56 coefficients: F_-(B*y) = -54*(8-3*Sqrt(6))*row 6\n");
Print("PASS: both M10 equations match rows 5 and 6.\n");
QUIT;
