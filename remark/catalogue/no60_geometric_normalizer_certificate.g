#############################################################################
## Exact geometric normalizer certificate for Nos. 84, 85, and 107.
## Run from remark/catalogue. No output files are written.
#############################################################################

Read("../../gap_classification/gap_fourfold_cross_dimension/input/fourfold_156.g");
Print("GAP version=",GAPInfo.Version,"\n");

# These three strict witnesses use the frozen Families coordinates above:
# P^-1 * H_child * P <= H_60. They are copied from the original completed
# containment output (SHA-256 cf3339b80609385d40ebaf9d801bbe38bb251731873240e654293d29e12a5234).
# The public positive-edge output now uses displayed coordinates, with
# P_displayed = Q_source^-1 * P_old * Q_target, and must not be combined
# directly with Families. Each frozen witness is checked anew below.
No60CertFrozenStrictWitnesses := [
    rec(
        sourceNumber := 84, targetNumber := 60,
        sourceOrder := 36, targetOrder := 72,
        classification := "direct", direct := true,
        method := "A_strict", ok := true, status := "embedded",
        P := [
            [0,-3,0,3*E(3),-4,0],
            [0,-3*E(3)^2,0,3*E(3)^2,-4,0],
            [0,-3*E(3),0,3,-4,0],
            [3,3,3*E(3),-3*E(3),2,-2],
            [3*E(3)^2,3*E(3)^2,3*E(3)^2,-3*E(3)^2,2,-2],
            [3*E(3),3*E(3),3,-3,2,-2]
        ]
    ),
    rec(
        sourceNumber := 85, targetNumber := 60,
        sourceOrder := 36, targetOrder := 72,
        classification := "direct", direct := true,
        method := "A_strict", ok := true, status := "embedded",
        P := [
            [-4,-2,-4*E(3),2*E(3),-1,0],
            [-4*E(3)^2,-2*E(3)^2,-4*E(3)^2,2*E(3)^2,-1,0],
            [-4*E(3),-2*E(3),-4,2,-1,0],
            [-1,3,-E(3),-3*E(3),3,2],
            [-E(3)^2,3*E(3)^2,-E(3)^2,-3*E(3)^2,3,2],
            [-E(3),3*E(3),-1,-3,3,2]
        ]
    ),
    rec(
        sourceNumber := 107, targetNumber := 60,
        sourceOrder := 18, targetOrder := 72,
        classification := "direct", direct := true,
        method := "A_strict", ok := true, status := "embedded",
        P := [
            [0,0,0,0,79/8,2],
            [0,0,0,0,3,-4],
            [0,0,1,2,0,0],
            [0,0,4,0,0,0],
            [68/27,16/27,0,0,0,0],
            [-199/54,-133/27,0,0,0,0]
        ]
    )
];

No60CertI := IdentityMat(6);
No60CertOmega := E(3)*No60CertI;
No60CertScalars := Group(No60CertOmega);
No60CertM := [
    [-1,0,0,0,0,0],
    [0,1,0,0,0,0],
    [0,0,-1,0,0,0],
    [0,0,0,-1,0,0],
    [0,0,0,0,2,0],
    [0,0,0,0,-1,1]
];

No60CertTrace := function(hom, q)
    local g, dimensions, value;
    g := PreImagesRepresentative(hom, q);
    dimensions := List([1,E(3),E(3)^2],
        alpha -> 6-RankMat(g-alpha*No60CertI));
    value := Sum(dimensions, k -> (-2)^k)/3;
    if not IsInt(value) then Error("Nonintegral primitive H4 trace"); fi;
    return value;
end;

No60CertCharacter := function(hom, H)
    local collected;
    collected := Collected(List(Elements(H),
        q -> [Order(q),No60CertTrace(hom,q)]));
    return List(collected, row -> [row[1][1],row[1][2],row[2]]);
end;

No60CertImage := function(hom, M, H)
    return Group(List(GeneratorsOfGroup(H),
        q -> Image(hom,M*PreImagesRepresentative(hom,q)*M^-1)));
end;

No60CertWitness := function(number, expectedSize, L)
    local child, edges, edge, H;
    child := Families[number];
    edges := Filtered(No60CertFrozenStrictWitnesses,
        r -> r.sourceNumber=number and r.targetNumber=60 and
             r.ok=true and r.status="embedded" and
             r.classification="direct" and r.direct=true);
    if Length(edges)<>1 then
        Error("Expected exactly one strict direct witness for No. ",number);
    fi;
    edge := edges[1];
    if edge.sourceOrder<>expectedSize or edge.targetOrder<>72 or
       not edge.method in ["literal_matrix_subgroup","A_strict"] then
        Error("Strict witness metadata changed for No. ",number);
    fi;
    H := Group(List(child.generators,g -> edge.P^-1*g*edge.P));
    if Size(H)<>expectedSize or not IsSubgroup(L,H) or
       not No60CertOmega in H then
        Error("Strict witness does not give the expected linear subgroup");
    fi;
    return H;
end;

No60CertRun := function()
    local L, hom, Q, N, H107, s3, other, d12, expected, witnessed,
          number, H, qH, mate, pairs, character, q, qM, cubicDimension;

    L := Group(Families[60].generators);
    if Families[60].number<>60 or Size(L)<>72 or IdGroup(L)<>[72,48] or
       DeterminantMat(No60CertM)<>-2 or not No60CertOmega in L or
       Group(List(GeneratorsOfGroup(L),g -> No60CertM*g*No60CertM^-1))<>L then
        Error("M does not normalize the frozen No. 60 linear group");
    fi;
    if No60CertM*No60CertOmega*No60CertM^-1<>No60CertOmega then
        Error("M does not fix the central scalar");
    fi;
    cubicDimension := Sum(Elements(L),g ->
        (TraceMat(g)^3+3*TraceMat(g)*TraceMat(g^2)+
         2*TraceMat(g^3))/6)/Size(L);
    if cubicDimension<>6 then Error("No. 60 invariant cubic dimension changed"); fi;

    hom := NaturalHomomorphismByNormalSubgroup(L,No60CertScalars);
    Q := Image(hom);
    N := Image(hom,Subgroup(L,Filtered(Elements(L),
        g -> DeterminantMat(g)=1)));
    if Size(Q)<>24 or IdGroup(Q)<>[24,14] or Size(N)<>12 then
        Error("Unexpected No. 60 projective group or symplectic kernel");
    fi;
    for q in Elements(Q) do
        qM := Image(hom,No60CertM*PreImagesRepresentative(hom,q)*No60CertM^-1);
        if Order(qM)<>Order(q) or
           No60CertTrace(hom,qM)<>No60CertTrace(hom,q) then
            Error("M fails to preserve the complete primitive H4 character");
        fi;
    od;
    Print("No. 60: |L|=72, |Q|=24, |N|=12, invariant cubics=6; M normalizes L and preserves the full character.\n");

    H107 := No60CertWitness(107,18,L);
    s3 := Filtered(NormalSubgroups(Q),H -> Size(H)=6 and
        IdGroup(H)=[6,1] and Size(Intersection(H,N))=3);
    if Length(s3)<>2 or not Image(hom,H107) in s3 then
        Error("No. 107 eligible S3 pair or strict witness changed");
    fi;
    other := First(Filtered(s3,H -> H<>Image(hom,H107)));
    if No60CertImage(hom,No60CertM,Image(hom,H107))<>other or
       Group(List(GeneratorsOfGroup(H107),
           g -> No60CertM*g*No60CertM^-1))<>PreImage(hom,other) or
       No60CertCharacter(hom,s3[1])<>No60CertCharacter(hom,s3[2]) or
       No60CertCharacter(hom,s3[1])<>[[1,22,1],[2,-2,3],[3,4,2]] then
        Error("M does not exchange the exact No. 107 S3 pair");
    fi;
    Print("No. 107: two eligible S3 subgroups, both strict-character matches; M exchanges their full linear preimages.\n");

    d12 := Filtered(NormalSubgroups(Q),H -> Size(H)=12 and
        IdGroup(H)=[12,4] and Size(Intersection(H,N))=6);
    expected := [
        rec(number:=84, char:=[[1,22,1],[2,-2,4],[2,6,3],
                              [3,4,2],[6,-2,2]]),
        rec(number:=85, char:=[[1,22,1],[2,-10,1],[2,-2,3],
                              [2,6,3],[3,4,2],[6,2,2]])
    ];
    if Length(d12)<>5 then Error("Unexpected number of eligible D12 subgroups"); fi;
    pairs := [];
    for witnessed in expected do
        number := witnessed.number;
        H := No60CertWitness(number,36,L);
        qH := Image(hom,H);
        if not qH in d12 then Error("D12 strict witness is ineligible"); fi;
        character := No60CertCharacter(hom,qH);
        if character<>witnessed.char then
            Error("Full primitive H4 character changed for No. ",number);
        fi;
        mate := No60CertImage(hom,No60CertM,qH);
        if mate=qH or not mate in d12 or
           No60CertImage(hom,No60CertM,mate)<>qH or
           No60CertCharacter(hom,mate)<>witnessed.char or
           Group(List(GeneratorsOfGroup(H),
               g -> No60CertM*g*No60CertM^-1))<>PreImage(hom,mate) then
            Error("M does not exchange the exact D12 pair for No. ",number);
        fi;
        if Length(Filtered(d12,J ->
             No60CertCharacter(hom,J)=witnessed.char))<>2 then
            Error("The complete D12 character does not select a pair");
        fi;
        Add(pairs,[qH,mate]);
        Print("No. ",String(number),": strict D12 witness and its M-image form one character-distinct pair; character=",character,".\n");
    od;
    if Length(Set(Concatenation(pairs)))<>4 or
       No60CertCharacter(hom,pairs[1][1])=
       No60CertCharacter(hom,pairs[2][1]) then
        Error("No. 84 and No. 85 D12 pairs overlap or have equal characters");
    fi;
    Print("PASS: exact No. 60 geometric normalizer certificate; no OSCAR class number is assigned.\n");
end;

No60CertRun();
QuitGap(0);
