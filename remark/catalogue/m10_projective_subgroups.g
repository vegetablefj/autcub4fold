# Exact certificate for the real singular fibers of the M10/A6 pencil.
# Koike's arXiv v2 equation (2.8) prints plus signs before the 4-, 5-, and
# 8-coefficient blocks. Those signs fail invariance for (2.2),(2.7); this
# script uses the corrected minus signs, as certified below.
w := E(3);;
a := DiagonalMat([1,1,w,w,w^2,w^2]);;
b := (1/3) * [
  [-1,0,-w,0,3*w^2,2*w^2],
  [2,0,2*w,0,0,-w^2],
  [-w^2,0,2,3,0,-w],
  [2*w^2,0,-1,0,0,2*w],
  [2*w,3*w,-w^2,0,0,-1],
  [-w,0,2*w^2,0,0,2]
];;
s := a^2 * (b*a^2*b^2*a)^2 * a;;
t := b^2*a^2*b*a;;
G := Group(s,t);;
Print("size G = ", Size(G), "\n");
if Size(G) <> 1080 then Error("Expected the order-1080 group 3.A6."); fi;
ZG := Centre(G);;
Print("size Z = ", Size(ZG), "\n");
if Size(ZG) <> 3 then Error("Expected the order-three center."); fi;
q := NaturalHomomorphismByNormalSubgroup(G,ZG);;
Q := Image(q);;
Print("size Q = ", Size(Q), "\n");
Print("IdGroup(Q) = ", IdGroup(Q), "\n");
if IdGroup(Q) <> [360,118] then Error("Expected the A6 quotient."); fi;
C := ConjugacyClassesSubgroups(Q);;
Print("all subgroup conjugacy classes = ", Length(C), "\n");
commonEigenSpaces := function(H)
  local spaces, gen, next, B, z, D, ker;
  spaces := [IdentityMat(6)];
  for gen in GeneratorsOfGroup(H) do
    next := [];
    for B in spaces do
      for z in List([0..Order(gen)-1], j -> E(Order(gen))^j) do
        D := B * TransposedMat(gen) - z * B;
        ker := NullspaceMat(D);
        if Length(ker) > 0 then
          Add(next, ker * B);
        fi;
      od;
    od;
    spaces := next;
    if Length(spaces) = 0 then
      return [];
    fi;
  od;
  return spaces;
end;;
fTerms := [];;
for i in [1..6] do Add(fTerms,[2,[i,i,i]]); od;
for ij in [[1,2],[3,4],[5,6]] do
  Add(fTerms,[3,[ij[1],ij[1],ij[2]]]);
  Add(fTerms,[3,[ij[1],ij[2],ij[2]]]);
od;
for ijk in [[2,3,5],[1,4,5],[1,3,6],[2,4,6]] do
  Add(fTerms,[2,ijk]);
od;
for ijk in [[1,3,5],[2,4,5],[2,3,6],[1,4,6]] do
  Add(fTerms,[4,ijk]);
od;
gTerms := [];;
for ijk in [[1,2,3],[1,2,4],[1,2,5],[1,2,6],[1,3,4],[1,3,5],
            [1,5,6],[2,3,4],[2,5,6],[3,5,6],[3,4,6],[3,4,5],[4,5,6]] do
  Add(gTerms,[3,ijk]);
od;
for ijk in [[1,4,5],[1,3,6],[2,3,5],[2,4,6]] do
  Add(gTerms,[-4,ijk]);
od;
for ijk in [[1,4,6],[2,3,6],[2,4,5]] do
  Add(gTerms,[-5,ijk]);
od;
Add(gTerms,[-8,[1,3,5]]);;
gPrintedTerms := List(gTerms, term -> [AbsInt(term[1]),term[2]]);;
gradTerms := function(terms,point)
  local out, term, j, k, val, inds;
  out := [0,0,0,0,0,0];
  for term in terms do
    inds := term[2];
    for j in [1..3] do
      val := term[1];
      for k in [1..3] do
        if k <> j then val := val*point[inds[k]]; fi;
      od;
      out[inds[j]] := out[inds[j]] + val;
    od;
  od;
  return out;
end;;
monomials := [];;
for i in [1..6] do
  for j in [i..6] do
    for k in [j..6] do Add(monomials,[i,j,k]); od;
  od;
od;
imageMatrix := function(h)
  local rows, m, row, i, j, k, c, triple;
  rows := [];
  for m in monomials do
    row := List(monomials,x -> 0);
    for i in [1..6] do
      for j in [1..6] do
        for k in [1..6] do
          c := h[m[1]][i]*h[m[2]][j]*h[m[3]][k];
          if c <> 0 then
            triple := SortedList([i,j,k]);
            row[Position(monomials,triple)] := row[Position(monomials,triple)] + c;
          fi;
        od;
      od;
    od;
    Add(rows,row);
  od;
  return rows;
end;;
ps := imageMatrix(s);;
pt := imageMatrix(t);;
vs := NullspaceMat(ps-IdentityMat(Length(monomials)));;
invBasis := NullspaceMat(vs*(pt-IdentityMat(Length(monomials))))*vs;;
Print("cubic invariant dimension = ", Length(invBasis), "\n");
if Length(invBasis) <> 2 then Error("Expected two invariant cubics."); fi;
r0 := [
  [2*w+3,-w,-2*(w+1),-3*w-1,w-2,-7],
  [-w-3,-w,7*(w+1),3*w+2,1-2*w,2],
  [2*w,-4*w,w-2,3*w+2,w-2,3*w+2],
  [-7*w,-4*w,1-2*w,-3*w-1,1-2*w,-3*w-1],
  [2*w+3,-w,w-2,-7,-2*(w+1),-3*w-1],
  [-w-3,-w,1-2*w,2,7*(w+1),3*w+2]
];;
coefTerms := function(terms)
  local c, term;
  c := List(monomials,x -> 0);
  for term in terms do
    c[Position(monomials,SortedList(term[2]))] :=
      c[Position(monomials,SortedList(term[2]))] + term[1];
  od;
  return c;
end;;
fc := coefTerms(fTerms);; gc := coefTerms(gTerms);;
pc := coefTerms(gPrintedTerms);;
Print("exact f,g invariance under s,t = ",
  fc*ps=fc and fc*pt=fc and gc*ps=gc and gc*pt=gc, "\n");
Print("printed-sign g invariant under s,t = ", pc*ps=pc and pc*pt=pc, "\n");
Print("corrected f,g span all invariant cubics = ",
  Length(invBasis)=2 and RankMat([fc,gc])=2, "\n");
if fc*ps<>fc or fc*pt<>fc or gc*ps<>gc or gc*pt<>gc then
  Error("The corrected f,g are not invariant under 3.A6.");
fi;
if pc*ps=pc and pc*pt=pc then
  Error("The printed-sign g unexpectedly is invariant.");
fi;
if RankMat([fc,gc])<>2 then
  Error("The corrected f,g do not span the invariant cubics.");
fi;
pr := imageMatrix(r0);;
fr := fc*pr;; gr := gc*pr;;
af := fr[Position(monomials,[1,1,1])]/2;;
bg := fr[Position(monomials,[1,2,3])]/3;;
cf := gr[Position(monomials,[1,1,1])]/2;;
dg := gr[Position(monomials,[1,2,3])]/3;;
Print("r0 pullback on (f,g_correct) = ", [[af,bg],[cf,dg]], "\n");
Print("r0 preserves pencil = ", fr=af*fc+bg*gc and gr=cf*fc+dg*gc, "\n");
if fr<>af*fc+bg*gc or gr<>cf*fc+dg*gc then
  Error("r0 does not preserve the corrected pencil.");
fi;
Print("eigenslope polynomial C*t^2+(D-A)*t-B = ", [cf,dg-af,-bg], "\n");
slopeAt := function(point)
  local gf, gg, i, q0;
  gf := gradTerms(fTerms,point);
  gg := gradTerms(gTerms,point);
  i := PositionProperty(gg,x -> x <> 0);
  if i = fail then
    if ForAll(gf,x -> x=0) then return "all parameters"; fi;
    return "g singular at infinity only";
  fi;
  q0 := gf[i]/gg[i];
  if ForAll([1..6],j -> gf[j] = q0*gg[j]) then
    return q0;
  fi;
  return "no singular parameter";
end;;
testedClasses := 0;;
testedLines := 0;;
finiteSlopes := [];;
for cl in C do
  U := Representative(cl);
  if Index(Q,U) <= 32 then
    testedClasses := testedClasses + 1;
    K := PreImage(q,U);
    eig := commonEigenSpaces(K);
    Print("index = ", Index(Q,U), ", order = ", Size(U), ", class size = ", Size(cl),
      ", eigenspace dimensions = ", List(eig,Length), "\n");
    for B in eig do
      if Length(B) <> 1 then
        Error("An index-at-most-32 subgroup has a higher-dimensional common eigenspace.");
      fi;
      testedLines := testedLines + 1;
      slope := slopeAt(B[1]);
      Print("  line = ", B[1], "\n");
      Print("  singular parameter = ", slope, "\n");
      if slope in [-1,1/4,7] then
        Add(finiteSlopes,slope);
      elif slope <> "no singular parameter" and
           slope <> "g singular at infinity only" then
        Error("An unexpected singular parameter was found.");
      fi;
    od;
  fi;
od;
if Set(finiteSlopes) <> Set([-1,1/4,7]) then
  Error("The finite singular-parameter set is not {-1,1/4,7}.");
fi;
Print("PASS: ", testedClasses, " subgroup classes and ", testedLines,
  " common eigenlines checked; finite singular parameters = ",
  Set(finiteSlopes), "\n");
QUIT;
