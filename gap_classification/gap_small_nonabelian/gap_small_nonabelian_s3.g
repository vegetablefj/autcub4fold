#############################################################################
##
## gap_small_nonabelian_s3.g
##
## Ordered liftable non-abelian inputs for the two S3 symplectic components,
## together with the exact weight-enumeration patch for the corrigendum
## component.  This file also defines the S3-specific runner used by the main
## driver; it does not start a calculation when read on its own.
##
#############################################################################

if not IsBound(CF_SquareMatrixDimension)
   or not IsBound(CF_IsScalarMatrix) then
    if IsBound(S_1) or IsBound(S_2) or IsBound(S_3) then
        Error(
            "Read ../gap_functions.g and gap_small_nonabelian_functions.g ",
            "before the audited liftable engine."
        );
    fi;
    Read("../gap_functions.g");
fi;
if not IsBound(CF_SN_ValidateCaseConfiguration)
   or not IsBound(CF_SN_YYZNonabelianFullGroupIds) then
    Read("gap_small_nonabelian_functions.g");
fi;

if not IsBound(CF_SN_SHOW_ENGINE_DETAILS) then
    CF_SN_SHOW_ENGINE_DETAILS := false;
fi;

CF_SN_EngineDetailPrint := function(arg)
    local item;

    if CF_SN_SHOW_ENGINE_DETAILS then
        for item in arg do
            Print(item);
        od;
    fi;
    return true;
end;


CF_SN_S3InitialGenerators := function()
    local transposition, threeCycle;

    transposition := [
        [ 0, 1, 0, 0, 0, 0 ],
        [ 1, 0, 0, 0, 0, 0 ],
        [ 0, 0, 1, 0, 0, 0 ],
        [ 0, 0, 0, 0, 1, 0 ],
        [ 0, 0, 0, 1, 0, 0 ],
        [ 0, 0, 0, 0, 0, 1 ]
    ];
    threeCycle := [
        [ 0, 0, 1, 0, 0, 0 ],
        [ 1, 0, 0, 0, 0, 0 ],
        [ 0, 1, 0, 0, 0, 0 ],
        [ 0, 0, 0, 0, 0, 1 ],
        [ 0, 0, 0, 1, 0, 0 ],
        [ 0, 0, 0, 0, 1, 0 ]
    ];

    return [transposition, threeCycle];
end;


CF_SN_S3CorrigendumGenerators := function()
    local transposition, threeCycle;

    transposition := [
        [ 0, 1, 0, 0, 0, 0 ],
        [ 1, 0, 0, 0, 0, 0 ],
        [ 0, 0, 1, 0, 0, 0 ],
        [ 0, 0, 0, 1, 0, 0 ],
        [ 0, 0, 0, 0, 1, 0 ],
        [ 0, 0, 0, 0, 0, -1 ]
    ];
    threeCycle := [
        [ 0, 0, 1, 0, 0, 0 ],
        [ 1, 0, 0, 0, 0, 0 ],
        [ 0, 1, 0, 0, 0, 0 ],
        [ 0, 0, 0, 1, 0, 0 ],
        [ 0, 0, 0, 0, 1, 0 ],
        [ 0, 0, 0, 0, 0, 1 ]
    ];

    return [transposition, threeCycle];
end;


# The last coordinate is the sign summand.  Its sign change centralizes the
# corrigendum S3 and gives the generic projective S3 x C2.
CF_SN_S3CorrigendumGenericInvolution := function()
    return [
        [ 1, 0, 0, 0, 0, 0 ],
        [ 0, 1, 0, 0, 0, 0 ],
        [ 0, 0, 1, 0, 0, 0 ],
        [ 0, 0, 0, 1, 0, 0 ],
        [ 0, 0, 0, 0, 1, 0 ],
        [ 0, 0, 0, 0, 0, -1 ]
    ];
end;


CF_SN_S3CorrigendumGenericFullLinearGenerators := function()
    # Include omega*I explicitly for the strict linear containment test.
    return Concatenation(
        CF_SN_S3CorrigendumGenerators(),
        [
            CF_SN_S3CorrigendumGenericInvolution(),
            E(3) * IdentityMat(6)
        ]
    );
end;


CF_SN_S3Configuration := function()
    local candidateGIds;

    # The known S3 x C24 action is recorded separately at the end of this
    # file and is not part of the representation enumeration.
    candidateGIds := CF_SN_YYZNonabelianFullGroupIds("S3");

    return rec(
        schemaVersion := 1,
        label := "small non-abelian S3",
        symplecticPart := "S3",
        symplecticGId := [6, 1],
        engine := "liftable S_1--S_3",
        components := [
            rec(
                label := "Koike (3.6), generic index 1",
                genericIndex := 1,
                expectedSymplecticInvariantDimension := 14,
                Kgens := CF_SN_S3InitialGenerators(),
                gids := ShallowCopy(candidateGIds),
                specializedGIds := [],
                sourceRecords := [
                    "S_3_initial_generic_index=1_liftable.docx"
                ]
            ),
            rec(
                label := "corrigendum component, generic index 2",
                genericIndex := 2,
                expectedSymplecticInvariantDimension := 17,
                Kgens := CF_SN_S3CorrigendumGenerators(),
                gids := CF_SN_GroupIdsForGenericIndex(
                    [6, 1],
                    candidateGIds,
                    2
                ),
                genericFullGroupLabel := "S3 x C2",
                genericFullProjectiveGId := [12, 4],
                genericFullLinearGId := [36, 12],
                genericFullLinearGenerators :=
                    CF_SN_S3CorrigendumGenericFullLinearGenerators(),
                specializedGIds := [[72, 27]],
                sourceRecords := [
                    "S_3_corrigendum_generic_index=2_liftable.docx"
                ]
            )
        ]
    );
end;


CF_SN_ValidateS3Configuration := function(configuration)
    local baseAudit, component, gid, cyclicOrder, expectedGroup,
          specialGId, specialPosition;

    baseAudit := CF_SN_ValidateCaseConfiguration(configuration);

    for component in configuration.components do
        for gid in component.gids do
            if gid[1] mod 6 <> 0 then
                Error("An S3 x C_n candidate has order not divisible by 6.");
            fi;
            cyclicOrder := QuoInt(gid[1], 6);
            expectedGroup := DirectProduct(
                SmallGroup(6, 1),
                CyclicGroup(cyclicOrder)
            );
            if IsomorphismGroups(
                SmallGroup(gid[1], gid[2]),
                expectedGroup
            ) = fail then
                Error(
                    "Candidate ", gid,
                    " is not isomorphic to S3 x C_", cyclicOrder, "."
                );
            fi;
        od;

        if not IsBound(component.specializedGIds) then
            Error("Each S3 component must record .specializedGIds.");
        fi;
        for specialGId in component.specializedGIds do
            specialPosition := Position(component.gids, specialGId);
            if specialPosition = fail then
                Error("A specialized S3 group ID is not enumerated.");
            fi;
        od;
    od;

    if Length(configuration.components[1].specializedGIds) <> 0
       or configuration.components[2].specializedGIds <> [[72, 27]] then
        Error("The exact-weight branch must target only corrigendum [72,27].");
    fi;

    return rec(
        baseAudit := baseAudit,
        enumeratedComponentCount := Length(configuration.components),
        enumeratedRunCount := Sum(
            List(configuration.components, item -> Length(item.gids))
        ),
        specializedRunCount := Sum(
            List(
                configuration.components,
                item -> Length(item.specializedGIds)
            )
        ),
        valid := true
    );
end;


CF_SN_RunS3Configuration := function()
    local configuration, audit, result;

    configuration := CF_SN_S3Configuration();
    audit := CF_SN_ValidateS3Configuration(configuration);
    if not IsBoundGlobal("CF_SN_S3SpecialPatchInstalled")
       or ValueGlobal("CF_SN_S3SpecialPatchInstalled") <> true then
        Error(
            "Read the audited liftable engine and then read ",
            "gap_small_nonabelian_s3.g before running the S3 batch."
        );
    fi;

    result := CF_SN_RunS1S2S3Configuration(configuration);
    result.S3ConfigurationAudit := audit;
    if not IsBoundGlobal("CF_SN_S3C24Example") then
        Error("The direct S3 x C24 example is not loaded.");
    fi;
    result.directKnownCase := ValueGlobal("CF_SN_S3C24Example")();
    return result;
end;


if not IsBound(S3_family1_gens) then
    S3_family1_gens := CF_SN_S3CorrigendumGenerators();
elif not CF_SameSubgroup(
    Group(S3_family1_gens),
    Group(CF_SN_S3CorrigendumGenerators())
) then
    Error("The existing S3_family1_gens is not the corrigendum component.");
fi;

if not IsBound(Kgens_S3_family1) then
    Kgens_S3_family1 := S3_family1_gens;
fi;


#############################################################################
## Exact-weight patch for [72,27]
##
## The patch is installed only when the audited liftable engine is already
## loaded.  Only its [72,27] branch is retained here.
#############################################################################

CF_SN_S3SpecialPatchInstalled := false;

if IsBound(S_1) and IsBound(S_2) and IsBound(S_3) then
#############################################################################
# V26 PATCH: exact fast S_2 for Koike S3 family 1 and G=[72,27]
#            plus S_3 suppression of negative expected dimensions.
#
# The module loader supplies the fixed V26 engine and the component data
# before installing this patch. No external historical file is read here.
#
# The following calls describe the retained engine interface. They are not a
# separate instruction to rerun the frozen integrated calculation:
#   S1 := S_1([72,27], Kgens_S3_family1);;
#   S2 := S_2(S1);;
#   S3 := S_3(S2);;
#   S4 := S_4(S3);;
#
# For every other input, the original V26 S_2 is called unchanged.
#############################################################################

if not IsBound(S_1) or not IsBound(S_2) or not IsBound(S_3) then
    Error("Load the complete V26 program before this patch.");
fi;

if not IsBound(CF_ClassFusionByImageFunction)
   or not IsBound(CF_PullbackClassFunctionByFusion)
   or not IsBound(CF_Step3FamilyFromSolution)
   or not IsBound(CF_DefaultStep3Options)
   or not IsBound(CF_MergeStep3Options) then
    Error("The loaded program is not the expected optimized V26 interface.");
fi;

if not IsBound(S3_family1_gens) then
    Error(
        "Load Koike_corrigendum_S3_family1_GAP.txt before this patch."
    );
fi;

if not IsBound(CF_V26_S2_BEFORE_KOIKE_F1_PATCH) then
    CF_V26_S2_BEFORE_KOIKE_F1_PATCH := S_2;
fi;

if not IsBound(CF_V26_S3_BEFORE_NEGATIVE_FILTER_PATCH) then
    CF_V26_S3_BEFORE_NEGATIVE_FILTER_PATCH := S_3;
fi;


#############################################################################
# 1. SMALL INTEGER AND WEIGHT UTILITIES
#############################################################################

CF_KF1_GcdListWithModulus := function(n, values)
    local g, value;

    g := n;
    for value in values do
        g := GcdInt(g, AbsInt(value));
    od;
    return g;
end;


CF_KF1_LexicographicMinimum := function(lists)
    local answer, item;

    if Length(lists) = 0 then
        Error("Cannot take the minimum of an empty list.");
    fi;

    answer := lists[1];
    for item in lists do
        if item < answer then
            answer := item;
        fi;
    od;
    return answer;
end;


# When 3 divides n, T, z*T, and z^2*T generate exactly the same
# matrix subgroup.  In exponent coordinates this adds n/3 or 2n/3
# to every cyclic weight.  It is performed before the complete
# Aut(H)-orbit reduction for n=12.
CF_KF1_CanonicalCentralScalarTuple := function(tuple, n)
    local e, a1, a2, a3, b, c, step, shift, triples, candidate,
          candidates;

    if n mod 3 <> 0 then
        return ShallowCopy(tuple);
    fi;

    e := tuple[1];
    a1 := tuple[2];
    a2 := tuple[3];
    a3 := tuple[4];
    b := tuple[5];
    c := tuple[6];
    step := QuoInt(n, 3);
    candidates := [];

    for shift in [0, step, 2*step] do
        triples := SortedList(
            [
                (a1 + shift) mod n,
                (a2 + shift) mod n,
                (a3 + shift) mod n
            ]
        );
        candidate := [
            e,
            triples[1], triples[2], triples[3],
            (b + shift) mod n,
            (c + shift) mod n
        ];
        Add(candidates, candidate);
    od;

    return CF_KF1_LexicographicMinimum(candidates);
end;


CF_KF1_ProjectiveOrderIsExact := function(tuple, n)
    local a1, a2, a3, b, c;

    a1 := tuple[2];
    a2 := tuple[3];
    a3 := tuple[4];
    b := tuple[5];
    c := tuple[6];

    return CF_KF1_GcdListWithModulus(
        n,
        [a2-a1, a3-a1, b-a1, c-a1]
    ) = 1;
end;


CF_KF1_TripleMultiplicityCentralizerDimension := function(a1, a2, a3)
    local values, multiplicities, value;

    values := Set([a1, a2, a3]);
    multiplicities := [];
    for value in values do
        Add(multiplicities, Number([a1, a2, a3], x -> x = value));
    od;

    # The sign and standard S3 constituents each occur once.
    return Sum(multiplicities, m -> m * m) + 1 + 1;
end;


# Exact dimension of strict cubic invariants for
#   3*trivial + sign + standard
# after adjoining the cyclic generator T.
CF_KF1_StrictCubicInvariantDimension := function(tuple, n, isSplit)
    local e, weights, b, c, answer, i, j, k, condition;

    e := tuple[1];
    weights := tuple{[2,3,4]};
    b := tuple[5];
    c := tuple[6];
    answer := 0;

    if isSplit then
        condition := function(sum)
            return sum mod n = 0;
        end;
    else
        condition := function(sum)
            return (e + sum) mod n = 0;
        end;
    fi;

    # Sym^3 of the three-dimensional trivial multiplicity space.
    for i in [1 .. 3] do
        for j in [i .. 3] do
            for k in [j .. 3] do
                if condition(weights[i] + weights[j] + weights[k]) then
                    answer := answer + 1;
                fi;
            od;
        od;
    od;

    # U * sign^2.
    for i in [1 .. 3] do
        if condition(weights[i] + 2*b) then
            answer := answer + 1;
        fi;
    od;

    # U times the invariant quadratic in the standard representation.
    for i in [1 .. 3] do
        if condition(weights[i] + 2*c) then
            answer := answer + 1;
        fi;
    od;

    # The unique S3-invariant cubic on the standard representation.
    if condition(3*c) then
        answer := answer + 1;
    fi;

    return answer;
end;


#############################################################################
# 2. EXACT Aut(H)-ORBIT DATA
#############################################################################

CF_KF1_ClassPosition := function(table, element)
    local classes, pos;

    classes := ConjugacyClasses(table);
    pos := PositionProperty(classes, class -> element in class);
    if pos = fail then
        Error("Could not locate an element in table-ordered conjugacy classes.");
    fi;
    return pos;
end;


CF_KF1_ExponentOfRoot := function(root, modulus)
    local exponent;

    for exponent in [0 .. modulus-1] do
        if root = E(modulus)^exponent then
            return exponent;
        fi;
    od;

    return fail;
end;


CF_KF1_ApplyIndexAction := function(vector, action)
    local answer, i;

    answer := List([1 .. Length(vector)], i -> 0);
    for i in [1 .. Length(vector)] do
        answer[action[i]] := vector[i];
    od;
    return answer;
end;


CF_KF1_PrepareExactOrbitData := function(H)
    local HId, Hstd, tableStd, irrStd, tableSource, irrSource,
          isoStdToSource, fusion, sourceToStandard, i, transported,
          imageIndex, autH, autGenerators, actions, alpha, action,
          twisted;

    if not IdGroupsAvailable(Size(H)) then
        Error("The specialized exact deduplication requires a SmallGroup ID.");
    fi;

    HId := IdGroup(H);
    Hstd := SmallGroup(HId[1], HId[2]);
    tableStd := CharacterTable(Hstd);
    irrStd := Irr(Hstd);
    tableSource := CharacterTable(H);
    irrSource := Irr(H);

    isoStdToSource := IsomorphismGroups(Hstd, H);
    if isoStdToSource = fail then
        Error("Could not identify the direct-product model with SmallGroup(HId).");
    fi;

    fusion := CF_ClassFusionByImageFunction(
        tableStd,
        tableSource,
        g -> Image(isoStdToSource, g)
    );

    sourceToStandard := [];
    for i in [1 .. Length(irrSource)] do
        transported := CF_PullbackClassFunctionByFusion(
            irrSource[i],
            tableStd,
            fusion
        );
        imageIndex := Position(irrStd, transported);
        if imageIndex = fail then
            Error("Could not match a source irreducible with SmallGroup(HId).");
        fi;
        Add(sourceToStandard, imageIndex);
    od;

    CF_SN_EngineDetailPrint(
        "  preparing exact Aut(H)-action for SmallGroup(",
        HId[1], ",", HId[2], ")...\n"
    );

    autH := AutomorphismGroup(Hstd);
    autGenerators := GeneratorsOfGroup(autH);
    actions := [];

    for alpha in autGenerators do
        fusion := CF_ClassFusionByImageFunction(
            tableStd,
            tableStd,
            g -> Image(alpha, g)
        );
        action := [];
        for i in [1 .. Length(irrStd)] do
            twisted := CF_PullbackClassFunctionByFusion(
                irrStd[i],
                tableStd,
                fusion
            );
            imageIndex := Position(irrStd, twisted);
            if imageIndex = fail then
                Error("An automorphism failed to permute Irr(H).");
            fi;
            Add(action, imageIndex);
        od;
        Add(actions, action);
    od;

    # The full automorphism group is no longer needed after extracting its
    # finite permutation action on Irr(H).
    autH := fail;
    GASMAN("collect");

    return rec(
        HId := HId,
        H := H,
        sourceTable := tableSource,
        sourceIrr := irrSource,
        standardGroup := Hstd,
        standardTable := tableStd,
        standardIrr := irrStd,
        sourceToStandard := sourceToStandard,
        irreducibleActions := actions,
        orbitCache := NewDictionary("", true)
    );
end;


CF_KF1_ToStandardMultiplicityVector := function(sourceVector, orbitData)
    local answer, i;

    if Length(sourceVector) <> Length(orbitData.sourceToStandard) then
        Error("A specialized multiplicity vector has the wrong length.");
    fi;

    answer := List([1 .. Length(orbitData.standardIrr)], i -> 0);
    for i in [1 .. Length(sourceVector)] do
        answer[orbitData.sourceToStandard[i]] :=
            answer[orbitData.sourceToStandard[i]] + sourceVector[i];
    od;
    return answer;
end;


CF_KF1_CanonicalAutOrbitKey := function(vector, orbitData)
    local initialString, cached, orbit, seen, position, current, action,
          image, imageString, canonicalString, item, itemString;

    initialString := String(vector);
    cached := LookupDictionary(orbitData.orbitCache, initialString);
    if cached <> fail then
        return cached;
    fi;

    orbit := [ShallowCopy(vector)];
    seen := NewDictionary("", true);
    AddDictionary(seen, initialString, true);
    canonicalString := initialString;
    position := 1;

    while position <= Length(orbit) do
        current := orbit[position];
        for action in orbitData.irreducibleActions do
            image := CF_KF1_ApplyIndexAction(current, action);
            imageString := String(image);
            if LookupDictionary(seen, imageString) = fail then
                AddDictionary(seen, imageString, true);
                Add(orbit, image);
                if imageString < canonicalString then
                    canonicalString := imageString;
                fi;
            fi;
        od;
        position := position + 1;
    od;

    for item in orbit do
        itemString := String(item);
        if LookupDictionary(orbitData.orbitCache, itemString) = fail then
            AddDictionary(
                orbitData.orbitCache,
                itemString,
                canonicalString
            );
        fi;
    od;

    return canonicalString;
end;


#############################################################################
# 3. DIRECT-PRODUCT MODELS AND IRREDUCIBLE INDEX MAPS
#############################################################################

CF_KF1_PrepareModel := function(n, isSplit)
    local S3abstract, cyclic, scalarC3, H, embS3, embCyclic, embScalar,
          sElement, tElement, zElement, orbitData, table, irr,
          posS, posT, posZ, indexMap, i, chi, degree, sValue, type,
          root, exponent, expectedScalar, modulus, old;

    S3abstract := SmallGroup(6,1);

    if isSplit then
        cyclic := CyclicGroup(n);
        scalarC3 := CyclicGroup(3);
        H := DirectProduct(S3abstract, cyclic, scalarC3);
        embS3 := Embedding(H, 1);
        embCyclic := Embedding(H, 2);
        embScalar := Embedding(H, 3);
        tElement := Image(embCyclic, GeneratorsOfGroup(cyclic)[1]);
        zElement := Image(embScalar, GeneratorsOfGroup(scalarC3)[1]);
        modulus := n;
    else
        cyclic := CyclicGroup(3*n);
        H := DirectProduct(S3abstract, cyclic);
        embS3 := Embedding(H, 1);
        embCyclic := Embedding(H, 2);
        tElement := Image(embCyclic, GeneratorsOfGroup(cyclic)[1]);
        zElement := fail;
        modulus := 3*n;
    fi;

    sElement := First(Elements(S3abstract), g -> Order(g) = 2);
    sElement := Image(embS3, sElement);

    orbitData := CF_KF1_PrepareExactOrbitData(H);
    table := orbitData.sourceTable;
    irr := orbitData.sourceIrr;
    posS := CF_KF1_ClassPosition(table, sElement);
    posT := CF_KF1_ClassPosition(table, tElement);
    if isSplit then
        posZ := CF_KF1_ClassPosition(table, zElement);
    else
        posZ := fail;
    fi;

    indexMap := [
        List([1 .. modulus], x -> fail),
        List([1 .. modulus], x -> fail),
        List([1 .. modulus], x -> fail)
    ];

    for i in [1 .. Length(irr)] do
        chi := irr[i];
        degree := DegreeOfCharacter(chi);
        sValue := chi[posS];
        type := fail;

        if degree = 1 and sValue = 1 then
            type := 1;
        elif degree = 1 and sValue = -1 then
            type := 2;
        elif degree = 2 and sValue = 0 then
            type := 3;
        fi;

        if type <> fail then
            if isSplit then
                expectedScalar := E(3) * degree;
                if chi[posZ] <> expectedScalar then
                    type := fail;
                fi;
            fi;
        fi;

        if type <> fail then
            root := chi[posT] / degree;
            exponent := CF_KF1_ExponentOfRoot(root, modulus);
            if exponent = fail then
                Error("Could not decode a cyclic irreducible-character weight.");
            fi;
            old := indexMap[type][exponent+1];
            if old <> fail then
                Error("The direct-product irreducible index map is not unique.");
            fi;
            indexMap[type][exponent+1] := i;
        fi;
    od;

    for type in [1 .. 3] do
        if ForAny(indexMap[type], x -> x = fail) then
            Error("The direct-product irreducible index map is incomplete.");
        fi;
    od;

    return rec(
        n := n,
        isSplit := isSplit,
        H := H,
        HId := orbitData.HId,
        orbitData := orbitData,
        indexMap := indexMap,
        representatives := [],
        representativeDictionary := NewDictionary("", true),
        normalizedTupleCount := 0,
        centralScalarCanonicalCount := 0,
        projectiveOrderPassCount := 0,
        exactAutOrbitClassCount := 0
    );
end;


CF_KF1_SourceMultiplicityVector := function(model, tuple)
    local e, a1, a2, a3, b, c, q1, q2, q3, qb, qc,
          answer, index;

    e := tuple[1];
    a1 := tuple[2];
    a2 := tuple[3];
    a3 := tuple[4];
    b := tuple[5];
    c := tuple[6];

    if model.isSplit then
        q1 := a1;
        q2 := a2;
        q3 := a3;
        qb := b;
        qc := c;
    else
        q1 := (e + 3*a1) mod (3*model.n);
        q2 := (e + 3*a2) mod (3*model.n);
        q3 := (e + 3*a3) mod (3*model.n);
        qb := (e + 3*b) mod (3*model.n);
        qc := (e + 3*c) mod (3*model.n);
    fi;

    answer := List([1 .. Length(model.orbitData.sourceIrr)], i -> 0);

    for index in [q1, q2, q3] do
        answer[model.indexMap[1][index+1]] :=
            answer[model.indexMap[1][index+1]] + 1;
    od;
    answer[model.indexMap[2][qb+1]] :=
        answer[model.indexMap[2][qb+1]] + 1;
    answer[model.indexMap[3][qc+1]] :=
        answer[model.indexMap[3][qc+1]] + 1;

    return answer;
end;


CF_KF1_ExtVectorForTuple := function(tuple, n)
    if n <> 12 then
        Error("The retained specialized branch requires n=12.");
    fi;
    return [tuple[1]];
end;


CF_KF1_AddTupleToExactOrbitClasses := function(model, tuple)
    local sourceVector, standardVector, orbitKey, fullKey, position,
          extVector, cubicDimension, centralizerDimension, representative;

    sourceVector := CF_KF1_SourceMultiplicityVector(model, tuple);
    standardVector := CF_KF1_ToStandardMultiplicityVector(
        sourceVector,
        model.orbitData
    );
    orbitKey := CF_KF1_CanonicalAutOrbitKey(
        standardVector,
        model.orbitData
    );
    fullKey := Concatenation(String(model.HId), ":", orbitKey);
    position := LookupDictionary(model.representativeDictionary, fullKey);
    extVector := CF_KF1_ExtVectorForTuple(tuple, model.n);

    if position = fail then
        cubicDimension := CF_KF1_StrictCubicInvariantDimension(
            tuple,
            model.n,
            model.isSplit
        );
        centralizerDimension :=
            CF_KF1_TripleMultiplicityCentralizerDimension(
                tuple[2], tuple[3], tuple[4]
            );
        representative := rec(
            tuple := ShallowCopy(tuple),
            sourceMultiplicityVector := sourceVector,
            standardMultiplicityVector := standardVector,
            exactAutOrbitKey := fullKey,
            ExtVector := ShallowCopy(extVector),
            mergedExtVectors := [ShallowCopy(extVector)],
            mergedRawSolutionCount := 1,
            cubicInvariantDimension := cubicDimension,
            centralizerDimension := centralizerDimension
        );
        Add(model.representatives, representative);
        position := Length(model.representatives);
        AddDictionary(model.representativeDictionary, fullKey, position);
        model.exactAutOrbitClassCount :=
            model.exactAutOrbitClassCount + 1;
    else
        representative := model.representatives[position];
        if Position(representative.mergedExtVectors, extVector) = fail then
            Add(representative.mergedExtVectors, ShallowCopy(extVector));
        fi;
        representative.mergedRawSolutionCount :=
            representative.mergedRawSolutionCount + 1;
    fi;
end;


CF_KF1_EnumerateModel := function(model, extIndices)
    local n, e, a1, a2, a3, c, b, tuple, canonicalTuple;

    n := model.n;

    for e in extIndices do
        for a1 in [0 .. n-1] do
            for a2 in [a1 .. n-1] do
                for a3 in [a2 .. n-1] do
                    for c in [0 .. n-1] do
                        # Direct determinant normalization det(T)=E(n).
                        if model.isSplit then
                            b := (1-a1-a2-a3-2*c) mod n;
                        else
                            b := (1-2*e-a1-a2-a3-2*c) mod n;
                        fi;

                        tuple := [e,a1,a2,a3,b,c];
                        model.normalizedTupleCount :=
                            model.normalizedTupleCount + 1;

                        if model.normalizedTupleCount mod 10000 = 0 then
                            CF_SN_EngineDetailPrint(
                                "    normalized tuples processed = ",
                                model.normalizedTupleCount,
                                "; exact Aut(H) classes so far = ",
                                model.exactAutOrbitClassCount,
                                "\n"
                            );
                        fi;

                        canonicalTuple :=
                            CF_KF1_CanonicalCentralScalarTuple(tuple, n);
                        if tuple = canonicalTuple then
                            model.centralScalarCanonicalCount :=
                                model.centralScalarCanonicalCount + 1;

                            if CF_KF1_ProjectiveOrderIsExact(tuple, n) then
                                model.projectiveOrderPassCount :=
                                    model.projectiveOrderPassCount + 1;
                                CF_KF1_AddTupleToExactOrbitClasses(
                                    model,
                                    tuple
                                );
                            fi;
                        fi;
                    od;
                od;
            od;
        od;
    od;

    CF_SN_EngineDetailPrint(
        "  H=SmallGroup(", model.HId[1], ",", model.HId[2], ")",
        "; determinant-normalized tuples=", model.normalizedTupleCount,
        "; central-scalar representatives=",
        model.centralScalarCanonicalCount,
        "; exact projective-order pass=", model.projectiveOrderPassCount,
        "; exact Aut(H) character orbits=", model.exactAutOrbitClassCount,
        "\n"
    );
end;


#############################################################################
# 4. MATRIX REPRESENTATIVES AND FINAL V26-COMPATIBLE S_2 RECORDS
#############################################################################

CF_KF1_CyclicMatrix := function(tuple, n, isSplit)
    local e, a1, a2, a3, b, c, lambda1, lambda2, lambda3,
          lambdaB, lambdaC, M, i, j, Jentry;

    e := tuple[1];
    a1 := tuple[2];
    a2 := tuple[3];
    a3 := tuple[4];
    b := tuple[5];
    c := tuple[6];

    if isSplit then
        lambda1 := E(n)^a1;
        lambda2 := E(n)^a2;
        lambda3 := E(n)^a3;
        lambdaB := E(n)^b;
        lambdaC := E(n)^c;
    else
        lambda1 := E(3*n)^(e+3*a1);
        lambda2 := E(3*n)^(e+3*a2);
        lambda3 := E(3*n)^(e+3*a3);
        lambdaB := E(3*n)^(e+3*b);
        lambdaC := E(3*n)^(e+3*c);
    fi;

    M := List([1 .. 6], i -> List([1 .. 6], j -> 0));

    # On <x1,x2,x3>, lambda1 acts on x1+x2+x3 and lambdaC on
    # the two-dimensional standard summand.
    Jentry := (lambda1-lambdaC)/3;
    for i in [1 .. 3] do
        for j in [1 .. 3] do
            M[i][j] := Jentry;
            if i = j then
                M[i][j] := M[i][j] + lambdaC;
            fi;
        od;
    od;

    M[4][4] := lambda2;
    M[5][5] := lambda3;
    M[6][6] := lambdaB;

    return Immutable(M);
end;


CF_KF1_CharacterKernelOrder := function(character)
    local positions, sizes;

    positions := ClassPositionsOfKernel(character);
    sizes := SizesConjugacyClasses(UnderlyingCharacterTable(character));
    return Sum(positions, p -> sizes[p]);
end;


CF_KF1_SolutionFromRepresentative := function(S1, model, representative)
    local tuple, T, identity6, zmat, expectedPower, generators,
          determinantValues, sourceCharacter, determinantCharacter,
          characterKernelOrder, determinantKernelOrder, relationPower;

    tuple := representative.tuple;
    T := CF_KF1_CyclicMatrix(tuple, model.n, model.isSplit);
    identity6 := IdentityMat(6);
    zmat := E(3) * identity6;

    if model.isSplit then
        expectedPower := identity6;
    else
        expectedPower := zmat^tuple[1];
    fi;

    relationPower := T^model.n;
    if relationPower <> expectedPower then
        Error("The explicit cyclic matrix violates T^n=z^e.");
    fi;

    if not ForAll(S3_family1_gens, A -> A*T = T*A) then
        Error("The explicit cyclic matrix does not commute with the fixed S3.");
    fi;

    if DeterminantMat(T) <> E(model.n) then
        Error("The determinant-normalized cyclic generator is incorrect.");
    fi;

    sourceCharacter := CF_CharacterFromMultiplicities(
        model.orbitData.sourceIrr,
        representative.sourceMultiplicityVector
    );
    characterKernelOrder := CF_KF1_CharacterKernelOrder(sourceCharacter);
    if characterKernelOrder <> 1 then
        Error("A retained specialized character is not faithful.");
    fi;

    determinantCharacter := DeterminantOfCharacter(sourceCharacter);
    determinantKernelOrder :=
        CF_KF1_CharacterKernelOrder(determinantCharacter);
    if determinantKernelOrder <> Size(S1.input.K) then
        Error("The determinant kernel does not have the required Kplus order.");
    fi;

    generators := Concatenation(S1.input.generatorMatrices, [T]);
    determinantValues := List(generators, DeterminantMat);

    return rec(
        HId := ShallowCopy(model.HId),
        ExtVector := ShallowCopy(representative.ExtVector),
        H2Vector := ShallowCopy(representative.ExtVector),
        mergedExtVectors :=
            List(representative.mergedExtVectors, ShallowCopy),
        mergedH2Vectors :=
            List(representative.mergedExtVectors, ShallowCopy),
        mergedRawSolutionCount := representative.mergedRawSolutionCount,
        kernelDerivedIntersectionOrder := 1,
        isLiftableType := true,
        matrixGenerators := generators,
        matrixImageOrder := 3 * S1.quotientId[1],
        centralizerDimensionByCharacter :=
            representative.centralizerDimension,
        precomputedCubicInvariantDimension :=
            representative.cubicInvariantDimension,
        determinantGeneratorValues := determinantValues,
        determinantImageOrder := model.n,
        determinantIsTrivial := false,
        wholeProjectiveGroupSymplectic := false,
        symplecticKernelOrder := Size(S1.input.K),
        symplecticKernelContainedInInputKMu3 := true,
        symplecticKernelContainedInInputK := true,
        symplecticKernelEqualsInputKMu3 := true,
        symplecticKernelEqualsInputK := true,
        allElementsOutsideInputKMu3AreNonsymplectic := true,
        allElementsOutsideInputKAreNonsymplectic := true,
        matrixImageData := rec(
            fastCharacterOrbitKey := representative.exactAutOrbitKey,
            deduplicationMode := "exact full Aut(H)-orbit",
            standardMultiplicityVector :=
                ShallowCopy(representative.standardMultiplicityVector)
        ),
        specializedKoikeS3Family1 := true,
        cyclicOrder := model.n,
        cyclicExtensionIsSplit := model.isSplit,
        normalizedWeightTuple := ShallowCopy(tuple)
    );
end;


CF_KF1_IsTargetInput := function(S1)
    local expectedK;

    if not IsRecord(S1)
       or not IsBound(S1.quotientId)
       or S1.quotientId <> [72,27]
       or not IsBound(S1.input)
       or not IsBound(S1.input.Kmatrix) then
        return false;
    fi;

    expectedK := Group(
        Concatenation(S3_family1_gens, [E(3)*IdentityMat(6)])
    );

    return CF_SameSubgroup(S1.input.Kmatrix, expectedK);
end;


CF_S2_FastKoikeS3Family1 := function(S1)
    local gid, models, model, splitModel, nonsplitModel, solutions,
          representative, summaries, totalNormalized, totalProjective,
          totalClasses, expectedG, expectedCyclicOrder;

    if not CF_KF1_IsTargetInput(S1) then
        Error(
            "CF_S2_FastKoikeS3Family1 supports only Koike S3 family 1 with ",
            "G=[72,27]."
        );
    fi;

    if not ForAll(
        S1.input.generatorMatrices,
        matrix -> DeterminantMat(matrix) = 1
    ) then
        Error("The fixed Koike S3 family 1 input must be symplectic.");
    fi;

    gid := S1.quotientId;
    expectedCyclicOrder := 12;

    # Do not trust the SmallGroup label alone.  The specialized weight model
    # is valid only when the projective group is actually S3 x C_n.
    expectedG := DirectProduct(
        SmallGroup(6,1),
        CyclicGroup(expectedCyclicOrder)
    );
    if IsomorphismGroups(expectedG, S1.G) = fail then
        Error(
            "The selected SmallGroup is not isomorphic to S3 x C_",
            expectedCyclicOrder,
            "; the specialized Koike-family-1 S_2 model is not applicable."
        );
    fi;
    expectedG := fail;
    GASMAN("collect");

    models := [];

    CF_SN_EngineDetailPrint("\n1. Exact weight enumeration for the second S3 component\n");
    CF_SN_EngineDetailPrint(
        "Weights are generated directly with det(T)=E(n), then reduced by ",
        "the complete Aut(H)-orbit of the abstract extension character.\n"
    );
    CF_SN_EngineDetailPrint(
        "No expected final class count is hard-coded and no cubic-dimension ",
        "filter is applied at this point.\n"
    );

    splitModel := CF_KF1_PrepareModel(12, true);
    CF_KF1_EnumerateModel(splitModel, [0]);
    Add(models, splitModel);

    nonsplitModel := CF_KF1_PrepareModel(12, false);
    # Keep both labelled nonzero Ext vectors.  Their final merging, if any,
    # is decided only by the complete Aut(H)-character orbit.
    CF_KF1_EnumerateModel(nonsplitModel, [1,2]);
    Add(models, nonsplitModel);

    solutions := [];
    summaries := [];
    totalNormalized := 0;
    totalProjective := 0;
    totalClasses := 0;

    for model in models do
        for representative in model.representatives do
            Add(
                solutions,
                CF_KF1_SolutionFromRepresentative(
                    S1,
                    model,
                    representative
                )
            );
        od;

        Add(
            summaries,
            rec(
                HId := ShallowCopy(model.HId),
                isSplitExtensionModel := model.isSplit,
                determinantNormalizedTupleCount :=
                    model.normalizedTupleCount,
                centralScalarRepresentativeCount :=
                    model.centralScalarCanonicalCount,
                projectiveOrderPassCount :=
                    model.projectiveOrderPassCount,
                exactAutOrbitClassCount :=
                    model.exactAutOrbitClassCount
            )
        );
        totalNormalized := totalNormalized + model.normalizedTupleCount;
        totalProjective := totalProjective + model.projectiveOrderPassCount;
        totalClasses := totalClasses + model.exactAutOrbitClassCount;
    od;

    CF_SN_EngineDetailPrint("\n2. Exact weight summary\n");
    CF_SN_EngineDetailPrint(
        "   Determinant-normalized tuples: ", totalNormalized, "\n"
    );
    CF_SN_EngineDetailPrint(
        "   Exact projective-order passes: ", totalProjective, "\n"
    );
    CF_SN_EngineDetailPrint(
        "   Exact unmarked GL(6)-conjugacy classes: ", totalClasses, "\n"
    );
    CF_SN_EngineDetailPrint("   Matrix representatives returned: ",
          Length(solutions), "\n");

    models := fail;
    GASMAN("collect");

    return rec(
        step1 := S1,
        specializedFastS2 := true,
        specializedCase := "Koike S3 family 1",
        exactGL6ConjugacyDeduplication := true,
        conjugacyConvention :=
            "unmarked GL(6)-conjugacy via the full Aut(H)-orbit of characters",
        ExtRepresentativeCount :=
            S1.ExpectedLiftableRepresentativeCount,
        H2RepresentativeCount :=
            S1.ExpectedLiftableRepresentativeCount,
        liftableRepresentativeCount :=
            S1.ExpectedLiftableRepresentativeCount,
        compatibleLiftableRepresentativeCount :=
            S1.ExpectedLiftableRepresentativeCount,
        solutionExtensions := summaries,
        determinantNormalizedTupleCount := totalNormalized,
        projectiveOrderPassCount := totalProjective,
        solutions := solutions
    );
end;


#############################################################################
# 5. AUTOMATIC S_2 DISPATCH FOR THE SPECIAL [72,27] CASE
#############################################################################

S_2 := function(arg)
    if Length(arg) = 1 and CF_KF1_IsTargetInput(arg[1]) then
        return CF_S2_FastKoikeS3Family1(arg[1]);
    fi;

    if Length(arg) = 1 then
        return CF_V26_S2_BEFORE_KOIKE_F1_PATCH(arg[1]);
    elif Length(arg) = 2 then
        return CF_V26_S2_BEFORE_KOIKE_F1_PATCH(arg[1], arg[2]);
    elif Length(arg) = 3 then
        return CF_V26_S2_BEFORE_KOIKE_F1_PATCH(
            arg[1], arg[2], arg[3]
        );
    fi;

    Error("The liftable S_2 supports one, two, or three arguments.");
end;


#############################################################################
# 6. S_3: DISCARD NEGATIVE-DIMENSION FAMILIES WITHOUT PRINTING THEM
#############################################################################

CF_S3_DiscardNegativeDimensionFamilies := function(arg)
    local S2, options, final, sol, item, i, polynomialContext, GId,
          retainedStep2, basisString, predictedDimension,
          discardedNegativeCount;

    if Length(arg) < 1 or Length(arg) > 2 then
        Error("Use S_3(S2) or S_3(S2, optionsRecord).");
    fi;

    S2 := arg[1];
    if not IsRecord(S2) or not IsBound(S2.solutions) then
        Error("S_3 expects the record returned by S_2.");
    fi;

    if Length(arg) = 2 then
        if not IsRecord(arg[2]) then
            Error("The optional S_3 argument must be an options record.");
        fi;
        options := CF_MergeStep3Options(arg[2]);
    else
        options := CF_DefaultStep3Options();
    fi;

    GId := fail;
    if IsBound(S2.step1) and IsBound(S2.step1.quotientId) then
        GId := ShallowCopy(S2.step1.quotientId);
    fi;

    CF_SN_EngineDetailPrint("\n3. Cubic invariant families\n");
    CF_SN_EngineDetailPrint(
        "Families with dim(V_3)-dim(C_GL6)<0 are neither printed nor ",
        "stored.\n"
    );

    polynomialContext := fail;
    if options.buildPolynomialObjects then
        polynomialContext := CF_PrepareCubicPolynomialContext();
    fi;

    final := [];
    discardedNegativeCount := 0;

    for i in [1 .. Length(S2.solutions)] do
        sol := S2.solutions[i];

        # The specialized S_2 supplies an exact weight-count dimension, so a
        # negative family can be rejected before constructing the 56-dimensional
        # cubic action and its nullspace.
        if IsBound(sol.precomputedCubicInvariantDimension) then
            predictedDimension :=
                sol.precomputedCubicInvariantDimension
                - sol.centralizerDimensionByCharacter;
            if predictedDimension < 0 then
                discardedNegativeCount := discardedNegativeCount + 1;
                if options.garbageCollectEachFamily then
                    GASMAN("collect");
                fi;
                continue;
            fi;
        fi;

        item := CF_Step3FamilyFromSolution(
            sol,
            i,
            options,
            polynomialContext
        );

        if IsBound(sol.precomputedCubicInvariantDimension)
           and item.cubicInvariantDimension
               <> sol.precomputedCubicInvariantDimension then
            Error(
                "The specialized weight count and the exact matrix cubic ",
                "invariant dimension disagree."
            );
        fi;

        if item.expectedModuliDimension < 0 then
            discardedNegativeCount := discardedNegativeCount + 1;
            item := fail;
            if options.garbageCollectEachFamily then
                GASMAN("collect");
            fi;
            continue;
        fi;

        Add(final, item);

        CF_SN_EngineDetailPrint(
            "\n", i, ". Retained representation of ",
            Length(S2.solutions), "\n"
        );
        CF_SN_EngineDetailPrint("   Strict linear group ID: ", sol.HId, "\n");
        CF_SN_EngineDetailPrint(
            "   Represented Ext^1 vectors: ", sol.mergedExtVectors, "\n"
        );
        CF_SN_EngineDetailPrint(
            "   Matrix image order: ", sol.matrixImageOrder, "\n"
        );
        CF_SN_EngineDetailPrint(
            "   Strict cubic invariant dimension: ",
            item.cubicInvariantDimension,
            "\n"
        );
        CF_SN_EngineDetailPrint(
            "   Matrix centralizer dimension: ",
            item.centralizerDimension,
            "\n"
        );
        CF_SN_EngineDetailPrint(
            "   Expected moduli dimension: ",
            item.expectedModuliDimension,
            "\n"
        );

        if options.printPolynomialBasis then
            if item.cubicInvariantBasisStrings = fail then
                Error(
                    "printPolynomialBasis=true requires ",
                    "buildPolynomialStrings=true."
                );
            fi;
            CF_SN_EngineDetailPrint("   Cubic invariant basis:\n");
            for basisString in item.cubicInvariantBasisStrings do
                CF_SN_EngineDetailPrint("      ", basisString, "\n");
            od;
        fi;

        item := fail;
        if options.garbageCollectEachFamily then
            GASMAN("collect");
        fi;
    od;

    if options.retainStep2 then
        retainedStep2 := S2;
    else
        retainedStep2 := fail;
    fi;

    CF_SN_EngineDetailPrint("\n4. Cubic invariant summary\n");
    CF_SN_EngineDetailPrint(
        "   Input representation classes: ", Length(S2.solutions), "\n"
    );
    CF_SN_EngineDetailPrint("   Negative-dimensional families suppressed: ",
          discardedNegativeCount, "\n");
    CF_SN_EngineDetailPrint("   Families retained: ", Length(final), "\n");

    return rec(
        GId := GId,
        step2 := retainedStep2,
        step2Retained := options.retainStep2,
        options := options,
        inputSolutionCount := Length(S2.solutions),
        negativeDimensionDiscardedCount := discardedNegativeCount,
        families := final
    );
end;


S_3 := CF_S3_DiscardNegativeDimensionFamilies;


CF_SN_EngineDetailPrint(
    "Exact S3 weight routine for [72,27] loaded.\n"
);
#############################################################################

CF_SN_S3SpecialPatchInstalled := true;
fi;


# Examples:
# S3Config := CF_SN_S3Configuration();;
# S3Audit := CF_SN_ValidateS3Configuration(S3Config);;
#
# Actual load order: ../gap_functions.g, this directory's shared functions,
# the audited liftable engine, and finally this file.  Then run:
# S3Candidates := CF_SN_RunS3Configuration();;


#############################################################################
## Direct S3 x C24 example
##
## Source: Yang--Yu--Zhu, Example 6.1(3), and article/yyz groups.txt.
## This known action is recorded for the final comparison only.  It is not
## an input to the representation enumeration above.
#############################################################################

CF_SN_S3C24Example := function()
    local diagonalGenerator, transpositionGenerator, generators,
          matrixGroup, groupData, expectedGroup, determinantKernel,
          determinantKernelData, scalarGenerator, strictPreimage,
          strictPreimageData, genericSourceInfo, directTargetInfo,
          genericContainment, cubic, centralizer;

    diagonalGenerator := [
        [ E(8), 0, 0, 0, 0, 0 ],
        [ 0, E(4)^3, 0, 0, 0, 0 ],
        [ 0, 0, -1, 0, 0, 0 ],
        [ 0, 0, 0, 1, 0, 0 ],
        [ 0, 0, 0, 0, E(3), 0 ],
        [ 0, 0, 0, 0, 0, 1 ]
    ];
    transpositionGenerator := [
        [ 1, 0, 0, 0, 0, 0 ],
        [ 0, 1, 0, 0, 0, 0 ],
        [ 0, 0, 1, 0, 0, 0 ],
        [ 0, 0, 0, 1, 0, 0 ],
        [ 0, 0, 0, 0, 0, 1 ],
        [ 0, 0, 0, 0, 1, 0 ]
    ];

    # The six entries below are the multipliers of the six monomials
    # x1^2*x2, x2^2*x3, x3^2*x4, x4^3, x5^3, x6^3.
    if not ForAll([
        diagonalGenerator[1][1]^2 * diagonalGenerator[2][2],
        diagonalGenerator[2][2]^2 * diagonalGenerator[3][3],
        diagonalGenerator[3][3]^2 * diagonalGenerator[4][4],
        diagonalGenerator[4][4]^3,
        diagonalGenerator[5][5]^3,
        diagonalGenerator[6][6]^3
    ], multiplier -> multiplier = 1) then
        Error("The diagonal S3 x C24 generator does not fix the cubic.");
    fi;
    # The second generator fixes the first four monomials and exchanges
    # x5^3 with x6^3.
    if transpositionGenerator^2
       <> IdentityMat(6) then
        Error("The recorded coordinate transposition is invalid.");
    fi;

    generators := [diagonalGenerator, transpositionGenerator];
    matrixGroup := Group(generators);
    groupData := CF_SN_LinearAndProjectiveGroupData(matrixGroup);
    expectedGroup := DirectProduct(
        SmallGroup(6, 1),
        CyclicGroup(24)
    );

    if groupData.linearGroupData.id <> [144, 69]
       or IsomorphismGroups(matrixGroup, expectedGroup) = fail then
        Error("The YYZ matrices should generate S3 x C24.");
    fi;
    if groupData.scalarSubgroupOrder <> 1 then
        Error("The YYZ matrix group should have trivial scalar kernel.");
    fi;
    if groupData.projectiveGroupData.id <> [144, 69]
       or IsomorphismGroups(groupData.projectiveGroup, expectedGroup) = fail then
        Error("The projective image is not S3 x C24.");
    fi;
    if groupData.determinantImageOrder <> 24 then
        Error("The S3 x C24 determinant image should have order 24.");
    fi;

    determinantKernel := Group(Filtered(
        Elements(matrixGroup),
        matrix -> DeterminantMat(matrix) = 1
    ));
    determinantKernelData := CF_GroupIdentificationData(determinantKernel);
    if determinantKernelData.id <> [6, 1] then
        Error("The determinant-one kernel should be S3.");
    fi;

    # The liftable enumeration uses the full strict preimage, which is
    # obtained by adjoining the scalar cubic roots of unity.
    scalarGenerator := E(3) * IdentityMat(6);
    strictPreimage := Group(Concatenation(generators, [scalarGenerator]));
    strictPreimageData := CF_SN_LinearAndProjectiveGroupData(strictPreimage);
    if strictPreimageData.linearGroupData.id <> [432, 464]
       or strictPreimageData.scalarSubgroupOrder <> 3
       or strictPreimageData.projectiveGroupData.id <> [144, 69] then
        Error("The full strict preimage should have ID [432,464].");
    fi;

    genericSourceInfo := PreprocessMatrixGroupStrict(
        CF_SN_S3CorrigendumGenericFullLinearGenerators(),
        36,
        [36, 12]
    );
    directTargetInfo := PreprocessMatrixGroupStrict(
        GeneratorsOfGroup(strictPreimage),
        strictPreimageData.linearGroupData.order,
        strictPreimageData.linearGroupData.id
    );
    genericContainment := SearchEmbeddingStrict(
        genericSourceInfo,
        directTargetInfo,
        rec(
            stop_first := true,
            construct_witness := false,
            try_literal_inclusion := true
        )
    );
    if genericContainment.status <> "embedded" then
        Error(
            "The direct S3 x C24 action does not contain the generic ",
            "S3 x C2 strict linear group."
        );
    fi;

    cubic := CF_CubicInvariantBasis(
        GeneratorsOfGroup(strictPreimage),
        rec(buildPolynomialObjects := false, buildStrings := true)
    );
    centralizer := CF_CentralizerAlgebraBasis(
        GeneratorsOfGroup(strictPreimage),
        false
    );
    if cubic.invariantDimension <> 5
       or centralizer.dimension <> 5 then
        Error("The direct S3 x C24 family should have dimension zero.");
    fi;

    return rec(
        label := "Yang--Yu--Zhu X3'",
        source := "Yang--Yu--Zhu, Example 6.1(3); article/yyz groups.txt",
        symplecticComponent := "corrigendum component",
        genericIndex := 2,
        equation :=
            "x1^2*x2 + x2^2*x3 + x3^2*x4 + x4^3 + x5^3 + x6^3",
        equationTerms := [
            "x1^2*x2", "x2^2*x3", "x3^2*x4",
            "x4^3", "x5^3", "x6^3"
        ],
        matrixGenerators := generators,
        YYZMatrixGenerators := generators,
        linearGroup := matrixGroup,
        linearGroupData := groupData.linearGroupData,
        scalarSubgroupOrder := groupData.scalarSubgroupOrder,
        projectiveGroup := groupData.projectiveGroup,
        projectiveGroupData := groupData.projectiveGroupData,
        determinantImageOrder := groupData.determinantImageOrder,
        determinantKernel := determinantKernel,
        determinantKernelData := determinantKernelData,
        fullStrictPreimage := strictPreimage,
        fullStrictPreimageGenerators :=
            GeneratorsOfGroup(strictPreimage),
        fullStrictPreimageData := strictPreimageData.linearGroupData,
        fullStrictPreimageScalarSubgroupOrder :=
            strictPreimageData.scalarSubgroupOrder,
        cubicMonomialExponents := cubic.monomialExponents,
        cubicInvariantBasisVectors := cubic.coefficientBasis,
        cubicInvariantBasisStrings := cubic.polynomialStrings,
        cubicInvariantDimension := cubic.invariantDimension,
        centralizerDimension := centralizer.dimension,
        expectedModuliDimension :=
            cubic.invariantDimension - centralizer.dimension,
        familyDimension :=
            cubic.invariantDimension - centralizer.dimension,
        YYZStructure := "C8 x (C3^2 : C2)",
        classificationStructure := "S3 x C24",
        genericFullLinearContainmentRequired := true,
        genericFullLinearContainmentVerified := true,
        genericFullLinearContainmentMethod :=
            genericContainment.method,
        strictInvarianceVerified := true,
        enumerationInput := false
    );
end;
