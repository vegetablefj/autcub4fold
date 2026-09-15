#############################################################################
## Liftability tests for full automorphism groups of smooth cubic fourfolds.
##
## Input: a finite strict linear group
##
##     H = Aut(F) < GL(6,C),    Z = <zeta_3 I_6>.
##
## The projective group is G = H/Z.  The full-group criterion tests ordinary
## liftability on the C3 x C3 subgroups, and F-liftability on those ordinary
## tests together with the order-three elements.  We also inspect C9 inverse
## images, which gives a uniform record for all subgroups of order at most 9.
##
## No GL(6)-conjugacy search is needed.  The small-3-group lemma
## exhausts the possible obstruction models.  For the inverse images, their
## commutator subgroup and exponent distinguish exactly the required cases.
## See gap_liftability_script.md for the public Sylow and small-subgroup
## criteria.  Fullness and smoothness are hypotheses supplied by the
## classification, not established by these functions.
##
## This file only defines functions.  It does not read the family catalogue
## and does not start a batch computation.
#############################################################################


CF_LI_ScalarSubgroup := function(strictGroup)
    local identity, dimension, scalarMatrix, scalarGroup, centralScalars;

    if not IsGroup(strictGroup) then
        Error("A finite matrix group is required.");
    fi;
    identity := One(strictGroup);
    if not IsMatrix(identity) then
        Error("The strict group must be given as a matrix group.");
    fi;
    dimension := Length(identity);
    if dimension <> 6 then
        Error("The cubic-fourfold liftability test expects 6 by 6 matrices.");
    fi;

    scalarMatrix := E(3) * IdentityMat(dimension);
    if not scalarMatrix in strictGroup then
        Error("The strict group does not contain zeta_3 I_6.");
    fi;
    scalarGroup := Group([scalarMatrix]);
    if Size(scalarGroup) <> 3 or not IsCentral(strictGroup, scalarGroup) then
        Error("The expected central scalar subgroup has not been found.");
    fi;
    centralScalars := Filtered(Elements(Center(strictGroup)), matrix ->
        matrix = matrix[1][1] * identity);
    if Set(centralScalars) <> Set(Elements(scalarGroup)) then
        Error("The full scalar subgroup must be exactly <zeta_3 I_6>.");
    fi;
    return scalarGroup;
end;


## These two tests use the distinguished scalar kernel, not merely the
## abstract isomorphism type of H.  They apply to any strict subgroup action.
CF_LI_TestStrictExtension := function(strictGroup)
    local scalarGroup, derived, derivedCubes, scalarDerivedOrder,
          scalarDerivedCubesOrder;

    scalarGroup := CF_LI_ScalarSubgroup(strictGroup);
    derived := DerivedSubgroup(strictGroup);
    ## Modulo [H,H], the cubes of a generating set generate 3 H_ab.
    derivedCubes := Subgroup(strictGroup, Concatenation(
        GeneratorsOfGroup(derived),
        List(GeneratorsOfGroup(strictGroup), generator -> generator^3)
    ));
    if not IsNormal(strictGroup, derivedCubes) then
        Error("The derived-and-cubes subgroup is not normal.");
    fi;
    scalarDerivedOrder := Size(Intersection(scalarGroup, derived));
    scalarDerivedCubesOrder := Size(Intersection(scalarGroup, derivedCubes));
    return rec(
        strictGroupOrder := Size(strictGroup),
        projectiveGroupOrder := Size(strictGroup) / 3,
        scalarSubgroupOrder := Size(scalarGroup),
        scalarDerivedIntersectionOrder := scalarDerivedOrder,
        scalarDerivedCubesIntersectionOrder := scalarDerivedCubesOrder,
        isLiftable := scalarDerivedOrder = 1,
        isFLiftable := scalarDerivedCubesOrder = 1,
        criterion := "distinguished scalar kernel in H_ab and H_ab/3H_ab"
    );
end;


CF_LI_PrepareStrictGroup := function(strictGroup)
    local scalarGroup, quotientMap, projectiveGroup,
          permutationIsomorphism, permutationGroup;

    scalarGroup := CF_LI_ScalarSubgroup(strictGroup);
    quotientMap := NaturalHomomorphismByNormalSubgroup(
        strictGroup,
        scalarGroup
    );
    projectiveGroup := Image(quotientMap);
    if Size(strictGroup) <> 3 * Size(projectiveGroup) then
        Error("The strict/projective group orders are inconsistent.");
    fi;

    ## Subgroup enumeration is normally more reliable on a permutation model.
    permutationIsomorphism := IsomorphismPermGroup(projectiveGroup);
    if permutationIsomorphism = fail then
        Error("Could not construct a permutation model of the quotient.");
    fi;
    permutationGroup := Image(permutationIsomorphism);

    return rec(
        strictGroup := strictGroup,
        scalarGroup := scalarGroup,
        quotientMap := quotientMap,
        projectiveGroup := projectiveGroup,
        permutationIsomorphism := permutationIsomorphism,
        permutationGroup := permutationGroup
    );
end;


CF_LI_IsomorphicSubgroupRepresentatives := function(context, model, label)
    local embeddings;

    ## IsomorphicSubgroups returns representatives of the target-conjugacy
    ## classes of image subgroups.  Different embeddings with the same image
    ## are therefore not retained as separate cases.
    embeddings := IsomorphicSubgroups(context.permutationGroup, model);
    return List(
        embeddings,
        embedding -> rec(
            label := label,
            permutationSubgroup := Image(embedding),
            projectiveSubgroup := PreImage(
                context.permutationIsomorphism,
                Image(embedding)
            )
        )
    );
end;


CF_LI_RelevantSubgroupRepresentatives := function(context)
    local representatives;

    representatives := [];
    Append(
        representatives,
        CF_LI_IsomorphicSubgroupRepresentatives(
            context,
            CyclicGroup(3),
            "C3"
        )
    );
    Append(
        representatives,
        CF_LI_IsomorphicSubgroupRepresentatives(
            context,
            CyclicGroup(9),
            "C9"
        )
    );
    Append(
        representatives,
        CF_LI_IsomorphicSubgroupRepresentatives(
            context,
            AbelianGroup([3, 3]),
            "C3xC3"
        )
    );
    return representatives;
end;


CF_LI_ClassifyRepresentative := function(context, representative)
    local projectiveSubgroup, strictPreimage, projectiveOrder,
          strictOrder, strictExponent, derivedIntersectionOrder,
          isLiftable, isFLiftable, obstruction, reason,
          compatibleWithSmoothC9Lemma;

    projectiveSubgroup := representative.projectiveSubgroup;
    strictPreimage := PreImage(context.quotientMap, projectiveSubgroup);
    projectiveOrder := Size(projectiveSubgroup);
    strictOrder := Size(strictPreimage);

    if strictOrder <> 3 * projectiveOrder then
        Error("A strict inverse image has the wrong order.");
    fi;

    strictExponent := Exponent(strictPreimage);
    derivedIntersectionOrder := Size(
        Intersection(
            context.scalarGroup,
            DerivedSubgroup(strictPreimage)
        )
    );
    obstruction := "none";
    compatibleWithSmoothC9Lemma := true;

    if representative.label = "C3" then
        if projectiveOrder <> 3 or not IsCyclic(projectiveSubgroup) then
            Error("The labelled C3 representative is inconsistent.");
        fi;

        ## Every projective C3 is liftable.  Its strict inverse image has
        ## order 9.  It is C3 x C3 precisely in the split (F-liftable) case,
        ## and C9 precisely for the obstruction
        ## <1/9(1,1,4,4,7,7)>.
        isLiftable := true;
        isFLiftable := strictExponent = 3;
        if isFLiftable then
            reason := "strict preimage is elementary abelian of order 9";
        elif strictExponent = 9 then
            obstruction := "C3_non_F_liftable";
            reason := "strict preimage is cyclic of order 9";
        else
            Error("Unexpected strict inverse image of a projective C3.");
        fi;

    elif representative.label = "C9" then
        if projectiveOrder <> 9 or not IsCyclic(projectiveSubgroup) then
            Error("The labelled C9 representative is inconsistent.");
        fi;

        ## The inverse image is abelian of order 27.  It splits over Z if
        ## and only if its exponent is 9.  The small-3-group lemma proves
        ## that the exponent-27 alternative cannot occur for a smooth cubic.
        isLiftable := true;
        isFLiftable := strictExponent = 9;
        if isFLiftable then
            reason := "strict preimage has exponent 9";
        elif strictExponent = 27 then
            obstruction := "C9_exponent_27_forbidden_for_smooth_cubic";
            reason := "strict preimage is cyclic of order 27";
            compatibleWithSmoothC9Lemma := false;
        else
            Error("Unexpected strict inverse image of a projective C9.");
        fi;

    elif representative.label = "C3xC3" then
        if projectiveOrder <> 9
           or not IsAbelian(projectiveSubgroup)
           or IsCyclic(projectiveSubgroup) then
            Error("The labelled C3 x C3 representative is inconsistent.");
        fi;

        ## Since the quotient is abelian, the derived subgroup of the strict
        ## inverse image lies in Z.  A nontrivial intersection with Z is
        ## exactly the ordinary-liftability obstruction.  If it is trivial,
        ## F-liftability is equivalent to the inverse image being C3^3,
        ## equivalently to exponent 3.
        isLiftable := derivedIntersectionOrder = 1;
        isFLiftable := isLiftable and strictExponent = 3;

        if not isLiftable then
            if strictExponent = 3 then
                obstruction := "C3xC3_non_liftable_exponent_3";
                reason := "Heisenberg strict preimage of exponent 3";
            elif strictExponent = 9 then
                obstruction := "C3xC3_non_liftable_exponent_9";
                reason := "nonabelian strict preimage of exponent 9";
            else
                Error("Unexpected non-liftable C3 x C3 inverse image.");
            fi;
        elif not isFLiftable then
            if strictExponent <> 9 then
                Error("Unexpected liftable non-F-liftable inverse image.");
            fi;
            obstruction := "C3xC3_liftable_non_F_liftable";
            reason := "strict preimage is C9 x C3 with scalar kernel in its C9 part";
        else
            reason := "strict preimage is elementary abelian of order 27";
        fi;

    else
        Error("Unknown small 3-subgroup label: ", representative.label, ".");
    fi;

    return rec(
        label := representative.label,
        projectiveSubgroup := projectiveSubgroup,
        projectiveOrder := projectiveOrder,
        strictPreimage := strictPreimage,
        strictPreimageOrder := strictOrder,
        strictPreimageId := IdGroup(strictPreimage),
        strictPreimageStructure := StructureDescription(strictPreimage),
        strictPreimageExponent := strictExponent,
        scalarDerivedIntersectionOrder := derivedIntersectionOrder,
        isLiftable := isLiftable,
        isFLiftable := isFLiftable,
        obstruction := obstruction,
        reason := reason,
        compatibleWithSmoothC9Lemma := compatibleWithSmoothC9Lemma
    );
end;


CF_LI_TestFullAutomorphismGroup := function(strictGroup)
    local context, representatives, tests;

    context := CF_LI_PrepareStrictGroup(strictGroup);
    representatives := CF_LI_RelevantSubgroupRepresentatives(context);
    tests := List(
        representatives,
        representative -> CF_LI_ClassifyRepresentative(
            context,
            representative
        )
    );

    return rec(
        strictGroupOrder := Size(strictGroup),
        projectiveGroupOrder := Size(context.projectiveGroup),
        numberOfC3Classes := Number(tests, test -> test.label = "C3"),
        numberOfC9Classes := Number(tests, test -> test.label = "C9"),
        numberOfC3xC3Classes := Number(
            tests,
            test -> test.label = "C3xC3"
        ),
        localTests := tests,
        isLiftable := ForAll(tests, test -> test.isLiftable),
        isFLiftable := ForAll(tests, test -> test.isFLiftable),
        compatibleWithSmoothC9Lemma := ForAll(
            tests,
            test -> test.compatibleWithSmoothC9Lemma
        ),
        criterion := "all conjugacy classes of C3, C9, and C3xC3 subgroups"
    );
end;


CF_LI_PrintSummary := function(result)
    local test, counter;

    Print("strict group order = ", result.strictGroupOrder, "\n");
    Print("projective group order = ", result.projectiveGroupOrder, "\n");
    Print(
        "conjugacy classes: C3 = ", result.numberOfC3Classes,
        ", C9 = ", result.numberOfC9Classes,
        ", C3xC3 = ", result.numberOfC3xC3Classes,
        "\n"
    );
    counter := 0;
    for test in result.localTests do
        counter := counter + 1;
        Print(
            counter, ". ", test.label,
            ": liftable = ", test.isLiftable,
            ", F-liftable = ", test.isFLiftable,
            ", preimage = ", test.strictPreimageStructure,
            ", obstruction = ", test.obstruction,
            "\n"
        );
    od;
    Print("liftable = ", result.isLiftable, "\n");
    Print("F-liftable = ", result.isFLiftable, "\n");
    Print(
        "compatible with the smooth-C9 lemma = ",
        result.compatibleWithSmoothC9Lemma,
        "\n"
    );
end;


#############################################################################
## Canonical obstruction models from the small-3-group lemma.
##
## These are supplied for documentation and later self-tests.  The decision
## functions above do not perform a GL(6)-conjugacy search against them.
#############################################################################

CF_LI_DiagonalRootMatrix := function(order, exponents)
    return DiagonalMat(List(exponents, exponent -> E(order)^exponent));
end;


CF_LI_ObstructionModels := function()
    local permutationMatrix, c3NonF, c3xC3NonLiftableExponent3,
          c3xC3NonLiftableExponent9, c3xC3LiftableNonF;

    permutationMatrix := PermutationMat(
        (1, 2, 3)(4, 5, 6),
        6,
        Cyclotomics
    );
    c3NonF := Group([
        CF_LI_DiagonalRootMatrix(9, [1, 1, 4, 4, 7, 7])
    ]);
    c3xC3NonLiftableExponent3 := Group([
        permutationMatrix,
        CF_LI_DiagonalRootMatrix(3, [0, 1, 2, 0, 1, 2])
    ]);
    c3xC3NonLiftableExponent9 := Group([
        permutationMatrix,
        CF_LI_DiagonalRootMatrix(9, [1, 4, 7, 1, 4, 7])
    ]);
    c3xC3LiftableNonF := Group([
        CF_LI_DiagonalRootMatrix(9, [1, 1, 4, 4, 7, 7]),
        CF_LI_DiagonalRootMatrix(3, [0, 1, 0, 1, 0, 1])
    ]);

    return rec(
        C3NonFLiftable := c3NonF,
        C3xC3NonLiftableExponent3 := c3xC3NonLiftableExponent3,
        C3xC3NonLiftableExponent9 := c3xC3NonLiftableExponent9,
        C3xC3LiftableNonFLiftable := c3xC3LiftableNonF
    );
end;


Print("Loaded cubic-fourfold liftability functions.\n");
