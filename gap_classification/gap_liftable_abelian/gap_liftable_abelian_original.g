#############################################################################
##
## Preserved diagonal core: gap_liftable_abelian_original.g
##
## Complete GAP workflow for diagonal liftable abelian standard extensions
## acting on cubic forms in six variables.
##
## The file performs the following mathematical/computational tasks.
##
##   A. Construct the 32 maximal standard extensions in GL(6,C):
##        * 24 simple K/T/Y block types;
##        *  8 non-simple types from Theorem 4.2.
##
##   B. For a finite diagonal abelian group G containing mu_3=<E(3)I>:
##        * enumerate all subgroups H containing mu_3 by enumerating
##          subgroups of G/mu_3 and taking inverse images;
##        * compute
##
##              familyDimension(H)
##                = dim Sym^3(C^6)^H - dim C_GL(6)(H);
##
##        * remove H when a strictly larger subgroup K has the same family
##          dimension.
##
##   C. Apply the order filter |H| dividing at least one of 48, 72, 108,
##      combine the results from all 32 maximal groups, and deduplicate them
##      under equivalence of the natural representations.
##
##      For finite abelian diagonal groups, representation equivalence is
##      exactly conjugacy by a coordinate permutation.  The implementation
##      first uses strong inexpensive invariants to form small buckets, then
##      performs an exact backtracking coordinate-permutation test only
##      inside a bucket.
##
##   D. Apply the final geometric restrictions:
##      These concern abelian full projective stabilizers, not smoothness
##      of arbitrary subgroup actions.
##        * H contains no element whose GL(6,C)-conjugacy class occurs in
##          DangerousPatterns below;
##        * |H intersect SL(6,C)| <= 12.
##
##      DangerousPatterns are expanded by all units modulo the indicated
##      order and by all central scalar multiples E(3)^j.  The requested
##      DangerousCharPolys list is constructed exactly.  Since every group
##      considered here is diagonal and abelian, the actual test uses the
##      sorted multiset of diagonal eigenvalues, which is equivalent to
##      comparing characteristic polynomials and is substantially faster.
##
##   E. Display functions are deliberately placed at the end of the file.
##      They optionally print group generators and a monomial basis of the
##      invariant cubic space.
##
## Typical core-only run from the module directory:
##
##      Read("gap_liftable_abelian_original.g");
##      all := RunLiftableAbelianCompletePipeline(true);
##      pool := all.pooled;
##      dedup := all.deduplicated;
##      final := all.restricted;
##      FinalRestrictedList := final.survivors;
##
##      PrintLiftableAbelianFinalRestrictedResult(final, false, true);
##
## All matrices use exact cyclotomic entries.
##
#############################################################################

#############################################################################
## Basic helpers
#############################################################################

LAM_ScalarMatrix := function(n, z)
    return DiagonalMat(List([1 .. n], i -> z));
end;

LAM_GroupFromDiagonalLists := function(diagonalLists)
    return Group(List(diagonalLists, d -> DiagonalMat(d)));
end;

#############################################################################
## Cubic blocks
##
## T_n = x_1^2 x_2 + ... + x_{n-1}^2 x_n + x_n^3.
## Its exact diagonal stabilizer is cyclic of order 3*2^(n-1).
#############################################################################

LAM_TBlock := function(n)
    local order, z, diagonal;

    if not IsInt(n) or n < 1 then
        Error("LAM_TBlock: n must be a positive integer");
    fi;

    order := 3 * 2^(n - 1);
    z := E(order);
    diagonal := List([0 .. n - 1], i -> z^((-2)^i));

    return rec(
        kind      := "T",
        parameters := [n],
        dim       := n,
        diagonals := [diagonal]
    );
end;

#############################################################################
## K_n = x_1^2 x_2 + ... + x_{n-1}^2 x_n + x_n^2 x_1.
## Its exact diagonal stabilizer is cyclic of order 2^n-(-1)^n.
## K_2 is intentionally not used in the maximal list.
#############################################################################

LAM_KBlock := function(n)
    local order, z, diagonal;

    if not IsInt(n) or n < 2 then
        Error("LAM_KBlock: n must be an integer at least 2");
    fi;

    order := 2^n - (-1)^n;
    z := E(order);
    diagonal := List([0 .. n - 1], i -> z^((-2)^i));

    return rec(
        kind      := "K",
        parameters := [n],
        dim       := n,
        diagonals := [diagonal]
    );
end;

#############################################################################
## Y_{a,b}, using a+b+2 variables:
##
##   x_1^2 x_2 + ... + x_{a-1}^2 x_a
## + y_1^2 y_2 + ... + y_{b-1}^2 y_b
## + x_a^2 z + y_b^2 z + z^2 w + w^3 + x_a y_b w.
##
## We assume a >= b >= 1.  The returned generators preserve every displayed
## monomial exactly.  The first generator is the block scalar E(3) I.
#############################################################################

LAM_YBlock := function(a, b)
    local n, scalar, xvals, yvals, xval, yval,
          g1, yvals2, yval2, g2, diagonals, i;

    if not IsInt(a) or not IsInt(b) or b < 1 or a < b then
        Error("LAM_YBlock: require integers a >= b >= 1");
    fi;

    n := a + b + 2;
    scalar := List([1 .. n], i -> E(3));

    xvals := [];
    xval := E(2^(a + 1))^((-1)^(a - 1));
    for i in [1 .. a] do
        Add(xvals, xval);
        xval := xval^(-2);
    od;

    yvals := [];
    yval := E(2^(b + 1))^((-1)^b);
    for i in [1 .. b] do
        Add(yvals, yval);
        yval := yval^(-2);
    od;

    g1 := Concatenation(
        xvals,
        yvals,
        [xvals[a]^(-2), 1]
    );

    diagonals := [scalar, g1];

    if b > 1 then
        yvals2 := [];
        yval2 := E(2^(b - 1))^((-1)^(b - 1));
        for i in [1 .. b] do
            Add(yvals2, yval2);
            yval2 := yval2^(-2);
        od;

        g2 := Concatenation(
            List([1 .. a], i -> 1),
            yvals2,
            [1, 1]
        );
        Add(diagonals, g2);
    fi;

    return rec(
        kind      := "Y",
        parameters := [a, b],
        dim       := n,
        diagonals := diagonals
    );
end;

#############################################################################
## Form the direct product of exact diagonal block stabilizers, embedded on
## consecutive coordinate blocks.  The total number of variables must be 6.
#############################################################################

LAM_DiagonalGroupFromBlocks := function(blocks)
    local total, fullDiagonals, start, block, localDiagonal,
          fullDiagonal, i;

    if not IsList(blocks) or Length(blocks) = 0 then
        Error("LAM_DiagonalGroupFromBlocks: blocks must be a nonempty list");
    fi;

    total := Sum(blocks, block -> block.dim);
    if total <> 6 then
        Error("LAM_DiagonalGroupFromBlocks: total block dimension must be 6");
    fi;

    fullDiagonals := [];
    start := 1;

    for block in blocks do
        for localDiagonal in block.diagonals do
            fullDiagonal := List([1 .. total], i -> 1);
            for i in [1 .. block.dim] do
                fullDiagonal[start + i - 1] := localDiagonal[i];
            od;
            Add(fullDiagonals, fullDiagonal);
        od;
        start := start + block.dim;
    od;

    return LAM_GroupFromDiagonalLists(fullDiagonals);
end;

#############################################################################
## The 24 simple maximal standard extensions
#############################################################################

LAM_SimpleMaximalList := [

    #  1. T1 + T1 + T1 + T1 + T1 + T1
    LAM_DiagonalGroupFromBlocks([
        LAM_TBlock(1), LAM_TBlock(1), LAM_TBlock(1),
        LAM_TBlock(1), LAM_TBlock(1), LAM_TBlock(1)
    ]),

    #  2. T2 + T1 + T1 + T1 + T1
    LAM_DiagonalGroupFromBlocks([
        LAM_TBlock(2), LAM_TBlock(1), LAM_TBlock(1),
        LAM_TBlock(1), LAM_TBlock(1)
    ]),

    #  3. T2 + T2 + T1 + T1
    LAM_DiagonalGroupFromBlocks([
        LAM_TBlock(2), LAM_TBlock(2), LAM_TBlock(1), LAM_TBlock(1)
    ]),

    #  4. T2 + T2 + T2
    LAM_DiagonalGroupFromBlocks([
        LAM_TBlock(2), LAM_TBlock(2), LAM_TBlock(2)
    ]),

    #  5. K3 + T1 + T1 + T1
    LAM_DiagonalGroupFromBlocks([
        LAM_KBlock(3), LAM_TBlock(1), LAM_TBlock(1), LAM_TBlock(1)
    ]),

    #  6. T3 + T1 + T1 + T1
    LAM_DiagonalGroupFromBlocks([
        LAM_TBlock(3), LAM_TBlock(1), LAM_TBlock(1), LAM_TBlock(1)
    ]),

    #  7. K3 + T2 + T1
    LAM_DiagonalGroupFromBlocks([
        LAM_KBlock(3), LAM_TBlock(2), LAM_TBlock(1)
    ]),

    #  8. T3 + T2 + T1
    LAM_DiagonalGroupFromBlocks([
        LAM_TBlock(3), LAM_TBlock(2), LAM_TBlock(1)
    ]),

    #  9. K3 + K3
    LAM_DiagonalGroupFromBlocks([
        LAM_KBlock(3), LAM_KBlock(3)
    ]),

    # 10. K3 + T3
    LAM_DiagonalGroupFromBlocks([
        LAM_KBlock(3), LAM_TBlock(3)
    ]),

    # 11. T3 + T3
    LAM_DiagonalGroupFromBlocks([
        LAM_TBlock(3), LAM_TBlock(3)
    ]),

    # 12. K4 + T1 + T1
    LAM_DiagonalGroupFromBlocks([
        LAM_KBlock(4), LAM_TBlock(1), LAM_TBlock(1)
    ]),

    # 13. T4 + T1 + T1
    LAM_DiagonalGroupFromBlocks([
        LAM_TBlock(4), LAM_TBlock(1), LAM_TBlock(1)
    ]),

    # 14. Y11 + T1 + T1
    LAM_DiagonalGroupFromBlocks([
        LAM_YBlock(1, 1), LAM_TBlock(1), LAM_TBlock(1)
    ]),

    # 15. K4 + T2
    LAM_DiagonalGroupFromBlocks([
        LAM_KBlock(4), LAM_TBlock(2)
    ]),

    # 16. T4 + T2
    LAM_DiagonalGroupFromBlocks([
        LAM_TBlock(4), LAM_TBlock(2)
    ]),

    # 17. Y11 + T2
    LAM_DiagonalGroupFromBlocks([
        LAM_YBlock(1, 1), LAM_TBlock(2)
    ]),

    # 18. K5 + T1
    LAM_DiagonalGroupFromBlocks([
        LAM_KBlock(5), LAM_TBlock(1)
    ]),

    # 19. T5 + T1
    LAM_DiagonalGroupFromBlocks([
        LAM_TBlock(5), LAM_TBlock(1)
    ]),

    # 20. Y21 + T1
    LAM_DiagonalGroupFromBlocks([
        LAM_YBlock(2, 1), LAM_TBlock(1)
    ]),

    # 21. K6
    LAM_DiagonalGroupFromBlocks([
        LAM_KBlock(6)
    ]),

    # 22. T6
    LAM_DiagonalGroupFromBlocks([
        LAM_TBlock(6)
    ]),

    # 23. Y31
    LAM_DiagonalGroupFromBlocks([
        LAM_YBlock(3, 1)
    ]),

    # 24. Y22
    LAM_DiagonalGroupFromBlocks([
        LAM_YBlock(2, 2)
    ])
];

#############################################################################
## The 8 non-simple maximal standard extensions
#############################################################################

LAM_NonSimpleMaximalList := [

    # 25. Non-simple case (1): nonsplit C18 standard extension.
    #     eta = E(18); this generator preserves all listed monomials exactly.
    LAM_GroupFromDiagonalLists([
        [E(18)^2, E(18)^14, E(18)^8,
         E(18)^17, E(18)^11, E(18)^5]
    ]),

    # 26. Non-simple case (2): <mu_3 I, C8>.
    LAM_GroupFromDiagonalLists([
        [E(3), E(3), E(3), E(3), E(3), E(3)],
        [E(8), E(8)^6, E(8)^4, 1, E(8)^5, E(8)^2]
    ]),

    # 27. Non-simple case (3): mu_3 x (C4 x C2).
    LAM_GroupFromDiagonalLists([
        [E(3), E(3), E(3), E(3), E(3), E(3)],
        [E(4), E(4)^2, 1, 1, E(4)^2, 1],
        [1, 1, 1, -1, -1, 1]
    ]),

    # 28. Non-simple case (4): mu_3 x (C4 x C2).
    LAM_GroupFromDiagonalLists([
        [E(3), E(3), E(3), E(3), E(3), E(3)],
        [E(4), E(4)^2, 1, E(4), E(4)^2, 1],
        [1, 1, 1, -1, -1, 1]
    ]),

    # 29. Non-simple case (5): mu_3 x (C4 x C2).
    LAM_GroupFromDiagonalLists([
        [E(3), E(3), E(3), E(3), E(3), E(3)],
        [E(4), E(4)^2, 1, E(4), E(4)^2, 1],
        [1, 1, 1, -1, -1, -1]
    ]),

    # 30. Non-simple case (6): mu_3 x (C4 x C2).
    LAM_GroupFromDiagonalLists([
        [E(3), E(3), E(3), E(3), E(3), E(3)],
        [E(4), E(4)^2, 1, E(4)^2, 1, E(4)^3],
        [1, 1, 1, -1, -1, -1]
    ]),

    # 31. Non-simple case (7): mu_3 x C2^2 x C3^2.
    LAM_GroupFromDiagonalLists([
        [E(3), E(3), E(3), E(3), E(3), E(3)],
        [-1, 1, -1, 1, 1, 1],
        [1, -1, -1, 1, 1, 1],
        [1, 1, 1, 1, E(3), 1],
        [1, 1, 1, 1, 1, E(3)]
    ]),

    # 32. Non-simple case (8): mu_3 x C2^2 x C6.
    LAM_GroupFromDiagonalLists([
        [E(3), E(3), E(3), E(3), E(3), E(3)],
        [-1, 1, -1, 1, 1, 1],
        [1, -1, -1, 1, 1, 1],
        [1, 1, 1, E(6), 1, E(6)^4]
    ])
];

#############################################################################
## Requested list
#############################################################################

LiftableAbelianMaximalList := Concatenation(
    LAM_SimpleMaximalList,
    LAM_NonSimpleMaximalList
);

#############################################################################
## Optional labels, in the same order as LiftableAbelianMaximalList.
#############################################################################

LiftableAbelianMaximalNames := [
    "T1+T1+T1+T1+T1+T1",
    "T2+T1+T1+T1+T1",
    "T2+T2+T1+T1",
    "T2+T2+T2",
    "K3+T1+T1+T1",
    "T3+T1+T1+T1",
    "K3+T2+T1",
    "T3+T2+T1",
    "K3+K3",
    "K3+T3",
    "T3+T3",
    "K4+T1+T1",
    "T4+T1+T1",
    "Y11+T1+T1",
    "K4+T2",
    "T4+T2",
    "Y11+T2",
    "K5+T1",
    "T5+T1",
    "Y21+T1",
    "K6",
    "T6",
    "Y31",
    "Y22",
    "NonSimple-1",
    "NonSimple-2",
    "NonSimple-3",
    "NonSimple-4",
    "NonSimple-5",
    "NonSimple-6",
    "NonSimple-7",
    "NonSimple-8"
];

#############################################################################
## Optional expected group orders, useful for checking the construction.
#############################################################################

LiftableAbelianMaximalExpectedOrders := [
    729, 486, 324, 216,
    243, 324, 162, 216,
    81, 108, 144,
    135, 216, 108,
    90, 144, 72,
    99, 144, 72,
    63, 96, 48, 48,
    18, 24, 24, 24, 24, 24, 108, 72
];

#############################################################################
## Optional verification routine.
#############################################################################

VerifyLiftableAbelianMaximalList := function()
    local scalar, i, G, actualOrder;

    if Length(LiftableAbelianMaximalList) <> 32 then
        Error("Expected exactly 32 groups");
    fi;

    scalar := LAM_ScalarMatrix(6, E(3));

    for i in [1 .. 32] do
        G := LiftableAbelianMaximalList[i];

        if not IsAbelian(G) then
            Error("Entry ", i, " is not abelian");
        fi;

        if not scalar in G then
            Error("Entry ", i, " does not contain E(3) I_6");
        fi;

        actualOrder := Size(G);
        if actualOrder <> LiftableAbelianMaximalExpectedOrders[i] then
            Error(
                "Entry ", i,
                " has order ", actualOrder,
                ", expected ", LiftableAbelianMaximalExpectedOrders[i]
            );
        fi;
    od;

    return true;
end;

#############################################################################
## Example:
##
##   Read("gap_liftable_abelian_original.g");
##   Length(LiftableAbelianMaximalList);          # 32
##   LiftableAbelianMaximalNames[25];             # NonSimple-1
##   GeneratorsOfGroup(LiftableAbelianMaximalList[25]);
##   VerifyLiftableAbelianMaximalList();
##
#############################################################################
#############################################################################
##
## LiftableAbelianEssentialPipeline.g
##
## Pipeline for the thirty-two groups in LiftableAbelianMaximalList:
##
##   Stage 1-2:
##     * compute EssentialCubicSubgroupsContainingMu3 for every maximal group;
##     * retain only subgroups H whose order divides at least one of
##           48, 72, 108;
##     * concatenate all retained records into one candidate pool.
##
##   Stage 3:
##     * deduplicate the candidate pool under equivalence of the natural
##       diagonal representations;
##     * for finite abelian diagonal groups this is exactly conjugacy by a
##       coordinate permutation.
##
## The maximal source list and all required functions are defined in this
## combined file. No separately split source files are needed.
##
#############################################################################

#############################################################################
## 0. Dimension of the invariant cubic family
#############################################################################

CubicDiagonalModuliData := function(obj)
    local gens, dims, n, g, i, j, k, m,
          signatures, blockSignatures, blockSizes,
          sig, pos, dimCentGL,
          invExponents, exponent,
          invariant, weight, dimInv;

    if IsGroup(obj) then
        gens := GeneratorsOfGroup(obj);
        if Length(gens) = 0 then
            gens := [One(obj)];
        fi;
    elif IsMatrix(obj) then
        gens := [obj];
    elif IsList(obj) and Length(obj) > 0 then
        gens := obj;
    else
        Error(
            "CubicDiagonalModuliData: input must be a matrix group, ",
            "a diagonal matrix, or a nonempty list of diagonal matrices"
        );
    fi;

    dims := DimensionsMat(gens[1]);
    if dims = fail or Length(dims) <> 2 or dims[1] <> dims[2] then
        Error("CubicDiagonalModuliData: generators must be square matrices");
    fi;
    n := dims[1];

    for g in gens do
        if DimensionsMat(g) <> [n, n] then
            Error("CubicDiagonalModuliData: inconsistent matrix dimensions");
        fi;
        if not IsDiagonalMatrix(g) then
            Error("CubicDiagonalModuliData: every generator must be diagonal");
        fi;
        for i in [1 .. n] do
            if g[i][i] = 0 then
                Error("CubicDiagonalModuliData: diagonal entries must be nonzero");
            fi;
        od;
    od;

    # The character of the i-th coordinate, represented by its values on the
    # selected generators.
    signatures := [];
    for i in [1 .. n] do
        Add(signatures, List(gens, g -> g[i][i]));
    od;

    blockSignatures := [];
    blockSizes := [];
    for sig in signatures do
        pos := Position(blockSignatures, sig);
        if pos = fail then
            Add(blockSignatures, sig);
            Add(blockSizes, 1);
        else
            blockSizes[pos] := blockSizes[pos] + 1;
        fi;
    od;

    dimCentGL := Sum(blockSizes, m -> m^2);

    # Enumerate all degree-three monomials x_i x_j x_k, i <= j <= k.
    invExponents := [];
    for i in [1 .. n] do
        for j in [i .. n] do
            for k in [j .. n] do
                invariant := true;
                for g in gens do
                    weight := g[i][i] * g[j][j] * g[k][k];
                    if weight <> 1 then
                        invariant := false;
                        break;
                    fi;
                od;

                if invariant then
                    exponent := List([1 .. n], x -> 0);
                    exponent[i] := exponent[i] + 1;
                    exponent[j] := exponent[j] + 1;
                    exponent[k] := exponent[k] + 1;
                    Add(invExponents, exponent);
                fi;
            od;
        od;
    od;

    dimInv := Length(invExponents);

    return rec(
        ambientDimension             := n,
        degree                       := 3,
        invariantCubicDimension      := dimInv,
        projectiveInvariantDimension := dimInv - 1,
        centralizerBlocks            := blockSizes,
        centralizerGLDimension       := dimCentGL,
        centralizerPGLDimension      := dimCentGL - 1,
        moduliDimension              := dimInv - dimCentGL,
        invariantExponentVectors     := invExponents
    );
end;

#############################################################################
## 1. Essential subgroups containing mu_3
#############################################################################

EssentialCubicSubgroupsContainingMu3 := function(G)
    local gens, dims, n, g,
          omega, scalar, Z,
          quotientMap, Q, pcIso, Qpc,
          quotientSubgroups,
          Upc, Uq, H,
          data, entries, entry,
          survivors, removed, witness;

    if not IsGroup(G) then
        Error("EssentialCubicSubgroupsContainingMu3: input must be a group");
    fi;
    if not IsFinite(G) then
        Error("EssentialCubicSubgroupsContainingMu3: group must be finite");
    fi;
    if not IsAbelian(G) then
        Error("EssentialCubicSubgroupsContainingMu3: group must be abelian");
    fi;

    gens := GeneratorsOfGroup(G);
    if Length(gens) = 0 or not IsMatrix(gens[1]) then
        Error("EssentialCubicSubgroupsContainingMu3: matrix group required");
    fi;

    dims := DimensionsMat(gens[1]);
    if dims = fail or dims[1] <> dims[2] then
        Error("EssentialCubicSubgroupsContainingMu3: square matrices required");
    fi;
    n := dims[1];

    for g in gens do
        if DimensionsMat(g) <> [n, n] then
            Error("EssentialCubicSubgroupsContainingMu3: inconsistent dimensions");
        fi;
        if not IsDiagonalMatrix(g) then
            Error("EssentialCubicSubgroupsContainingMu3: diagonal group required");
        fi;
    od;

    omega := E(3);
    scalar := DiagonalMat(List([1 .. n], i -> omega));

    if not scalar in G then
        Error("EssentialCubicSubgroupsContainingMu3: G does not contain E(3) I");
    fi;

    Z := Subgroup(G, [scalar]);
    if Size(Z) <> 3 then
        Error("EssentialCubicSubgroupsContainingMu3: scalar subgroup is not C3");
    fi;

    # Subgroups containing Z correspond to subgroups of G/Z.
    quotientMap := NaturalHomomorphismByNormalSubgroup(G, Z);
    Q := ImagesSource(quotientMap);

    pcIso := IsomorphismPcGroup(Q);
    if pcIso = fail then
        Error("EssentialCubicSubgroupsContainingMu3: pc conversion failed");
    fi;
    Qpc := Image(pcIso);

    quotientSubgroups := AllSubgroups(Qpc);
    entries := [];

    for Upc in quotientSubgroups do
        Uq := PreImage(pcIso, Upc);
        H := PreImage(quotientMap, Uq);

        data := CubicDiagonalModuliData(H);

        Add(entries, rec(
            group                      := H,
            order                      := Size(H),
            projectiveOrder            := Size(H) / 3,
            familyDimension            := data.moduliDimension,
            invariantCubicDimension    := data.invariantCubicDimension,
            centralizerGLDimension     := data.centralizerGLDimension,
            centralizerPGLDimension    := data.centralizerPGLDimension,
            centralizerBlocks          := data.centralizerBlocks
        ));
    od;

    # Process larger groups first.
    Sort(entries, function(a, b)
        if a.order = b.order then
            return a.familyDimension > b.familyDimension;
        fi;
        return a.order > b.order;
    end);

    survivors := [];
    removed := [];

    for entry in entries do
        witness := First(survivors, function(larger)
            return
                larger.familyDimension = entry.familyDimension and
                larger.order > entry.order and
                IsSubset(larger.group, entry.group);
        end);

        if witness = fail then
            Add(survivors, entry);
        else
            Add(removed, rec(
                group                       := entry.group,
                order                       := entry.order,
                projectiveOrder             := entry.projectiveOrder,
                familyDimension             := entry.familyDimension,
                dominatedBy                 := witness.group,
                dominatedByOrder            := witness.order,
                dominatedByProjectiveOrder  := witness.projectiveOrder
            ));
        fi;
    od;

    for entry in survivors do
        entry.structureDescription := StructureDescription(entry.group);
    od;

    return rec(
        ambientGroup                    := G,
        scalarMatrix                    := scalar,
        scalarSubgroup                  := Z,
        numberOfQuotientSubgroups       := Length(quotientSubgroups),
        numberOfSubgroupsContainingMu3  := Length(entries),
        numberOfSurvivors               := Length(survivors),
        numberRemoved                   := Length(removed),
        survivors                       := survivors,
        removed                         := removed
    );
end;

#############################################################################
## 2. Stage 1-2: collect and order-filter candidates
#############################################################################

LAM_OrderPasses4872108Filter := function(order)
    return ForAny([48, 72, 108], n -> n mod order = 0);
end;

CollectLiftableAbelianEssentialCandidates := function(verbose)
    local pool, summaries,
          i, G, name, result, entry, keptHere, candidate;

    if not IsBoundGlobal("LiftableAbelianMaximalList") then
        Error(
            "CollectLiftableAbelianEssentialCandidates: first read ",
            "LiftableAbelianMaximalList.g"
        );
    fi;

    if not IsBool(verbose) then
        Error("CollectLiftableAbelianEssentialCandidates: verbose must be true or false");
    fi;

    pool := [];
    summaries := [];

    for i in [1 .. Length(LiftableAbelianMaximalList)] do
        G := LiftableAbelianMaximalList[i];

        if IsBoundGlobal("LiftableAbelianMaximalNames") then
            name := LiftableAbelianMaximalNames[i];
        else
            name := Concatenation("Maximal-", String(i));
        fi;

        if verbose then
            Print(
                "[", i, "/", Length(LiftableAbelianMaximalList), "] ",
                name, ": computing essential subgroups ...\n"
            );
        fi;

        result := EssentialCubicSubgroupsContainingMu3(G);
        keptHere := 0;

        for entry in result.survivors do
            if LAM_OrderPasses4872108Filter(entry.order) then
                candidate := rec(
                    group                       := entry.group,
                    order                       := entry.order,
                    projectiveOrder             := entry.projectiveOrder,
                    familyDimension             := entry.familyDimension,
                    invariantCubicDimension     := entry.invariantCubicDimension,
                    centralizerGLDimension      := entry.centralizerGLDimension,
                    centralizerPGLDimension     := entry.centralizerPGLDimension,
                    centralizerBlocks           := entry.centralizerBlocks,
                    structureDescription        := entry.structureDescription,
                    sourceIndex                 := i,
                    sourceName                  := name,
                    sourceIndices               := [i],
                    sourceNames                 := [name],
                    equivalenceClassSize        := 1
                );
                Add(pool, candidate);
                keptHere := keptHere + 1;
            fi;
        od;

        Add(summaries, rec(
            sourceIndex                  := i,
            sourceName                   := name,
            ambientOrder                 := Size(G),
            allSubgroupsContainingMu3    := result.numberOfSubgroupsContainingMu3,
            essentialSubgroups           := result.numberOfSurvivors,
            retainedByOrderFilter        := keptHere
        ));

        if verbose then
            Print(
                "    essential: ", result.numberOfSurvivors,
                "; retained by order filter: ", keptHere, "\n"
            );
        fi;
    od;

    return rec(
        orderDivisibilityTargets := [48, 72, 108],
        sourceSummaries          := summaries,
        candidates               := pool,
        numberOfCandidates       := Length(pool)
    );
end;

#############################################################################
## 3. Fast invariants for diagonal representation equivalence
#############################################################################

LAM_DiagonalGroupBasicInfo := function(G)
    local gens, dims, n, g;

    if not IsGroup(G) or not IsFinite(G) or not IsAbelian(G) then
        Error("LAM_DiagonalGroupBasicInfo: finite abelian group required");
    fi;

    gens := GeneratorsOfGroup(G);
    if Length(gens) = 0 or not IsMatrix(gens[1]) then
        Error("LAM_DiagonalGroupBasicInfo: matrix group required");
    fi;

    dims := DimensionsMat(gens[1]);
    if dims = fail or dims[1] <> dims[2] then
        Error("LAM_DiagonalGroupBasicInfo: square matrices required");
    fi;
    n := dims[1];

    for g in gens do
        if DimensionsMat(g) <> [n, n] or not IsDiagonalMatrix(g) then
            Error("LAM_DiagonalGroupBasicInfo: common diagonal degree required");
        fi;
    od;

    return rec(group := G, generators := gens, degree := n);
end;

LAM_DiagonalEntryString := function(z)
    return String(z);
end;

# For each element, forget the order of the six coordinates, then collect the
# resulting multisets over all elements. This is a strong, inexpensive
# invariant under coordinate-permutation conjugacy.
LAM_ElementDiagonalSpectrumKey := function(G, n)
    local keys, g, values;

    keys := [];
    for g in Elements(G) do
        values := List([1 .. n], i -> LAM_DiagonalEntryString(g[i][i]));
        Sort(values);
        Add(keys, String(values));
    od;
    Sort(keys);
    return String(keys);
end;

LAM_DiagonalEquivalencePreData := function(entry)
    local info, G, gens, n,
          singleOrders, ratioOrders, vertexProfiles,
          i, j, g, value, row,
          sortedBlocks, spectrumKey, quickKey;

    G := entry.group;
    info := LAM_DiagonalGroupBasicInfo(G);
    gens := info.generators;
    n := info.degree;

    singleOrders := [];
    for i in [1 .. n] do
        value := 1;
        for g in gens do
            value := Lcm(value, Order(g[i][i]));
        od;
        Add(singleOrders, value);
    od;

    ratioOrders := [];
    for i in [1 .. n] do
        ratioOrders[i] := [];
        for j in [1 .. n] do
            value := 1;
            for g in gens do
                value := Lcm(value, Order(g[i][i] / g[j][j]));
            od;
            ratioOrders[i][j] := value;
        od;
    od;

    vertexProfiles := [];
    for i in [1 .. n] do
        row := ShallowCopy(ratioOrders[i]);
        Sort(row);
        Add(vertexProfiles, [singleOrders[i], row]);
    od;

    sortedBlocks := ShallowCopy(entry.centralizerBlocks);
    Sort(sortedBlocks);

    spectrumKey := LAM_ElementDiagonalSpectrumKey(G, n);

    # Equivalent representations must agree on all components of this key.
    # The last component is deliberately strong, so exact equivalence tests
    # are normally needed only inside very small buckets.
    quickKey := String([
        n,
        entry.order,
        AbelianInvariants(G),
        entry.familyDimension,
        entry.invariantCubicDimension,
        sortedBlocks,
        spectrumKey
    ]);

    return rec(
        group             := G,
        generators        := gens,
        degree            := n,
        singleOrders      := singleOrders,
        ratioOrders       := ratioOrders,
        vertexProfiles    := vertexProfiles,
        quickKey          := quickKey
    );
end;

#############################################################################
## 4. Exact equivalence test after the fast filters
##
## A and B are finite abelian diagonal groups. Their natural representations
## are equivalent up to an abstract group isomorphism iff a coordinate
## permutation conjugates A onto B.
#############################################################################

LAM_FastDiagonalEquivalenceData := function(dataA, dataB)
    local n, allowed, i, j,
          sourceOrder, used, mapping, witness,
          search;

    if dataA.degree <> dataB.degree then
        return rec(equivalent := false);
    fi;
    if Size(dataA.group) <> Size(dataB.group) then
        return rec(equivalent := false);
    fi;
    if dataA.quickKey <> dataB.quickKey then
        return rec(equivalent := false);
    fi;

    n := dataA.degree;
    allowed := [];

    for i in [1 .. n] do
        allowed[i] := Filtered([1 .. n], j ->
            dataA.vertexProfiles[i] = dataB.vertexProfiles[j]
        );
        if Length(allowed[i]) = 0 then
            return rec(equivalent := false);
        fi;
    od;

    # Assign the most constrained source coordinates first.
    sourceOrder := [1 .. n];
    Sort(sourceOrder, function(i, j)
        if Length(allowed[i]) = Length(allowed[j]) then
            return i < j;
        fi;
        return Length(allowed[i]) < Length(allowed[j]);
    end);

    used := List([1 .. n], i -> false);
    mapping := List([1 .. n], i -> 0);
    witness := fail;

    search := function(depth)
        local src, tgt, k, ok,
              gen, diagonal, conjugated;

        if depth > n then
            # mapping[src] is the target coordinate occupied by src.
            for gen in dataA.generators do
                diagonal := List([1 .. n], x -> 1);
                for k in [1 .. n] do
                    diagonal[mapping[k]] := gen[k][k];
                od;
                conjugated := DiagonalMat(diagonal);
                if not conjugated in dataB.group then
                    return false;
                fi;
            od;

            witness := ShallowCopy(mapping);
            return true;
        fi;

        src := sourceOrder[depth];

        for tgt in allowed[src] do
            if not used[tgt] then
                ok := true;

                # Pairwise ratio-character orders must be respected.
                for k in [1 .. n] do
                    if mapping[k] <> 0 then
                        if dataA.ratioOrders[src][k]
                           <> dataB.ratioOrders[tgt][mapping[k]] then
                            ok := false;
                            break;
                        fi;
                    fi;
                od;

                if ok then
                    mapping[src] := tgt;
                    used[tgt] := true;

                    if search(depth + 1) then
                        return true;
                    fi;

                    used[tgt] := false;
                    mapping[src] := 0;
                fi;
            fi;
        od;

        return false;
    end;

    if search(1) then
        return rec(
            equivalent       := true,
            coordinateMap    := witness
        );
    fi;

    return rec(equivalent := false);
end;

#############################################################################
## 5. Stage 3: deduplicate the combined list
#############################################################################

DeduplicateLiftableAbelianEssentialCandidates := function(poolResult, verbose)
    local prepared, candidate, data,
          unique, duplicateCount,
          i, j, bucket, bucketReps,
          item, repItem, test, matched,
          representative, finalEntry;

    if not IsRecord(poolResult) or not IsBound(poolResult.candidates) then
        Error(
            "DeduplicateLiftableAbelianEssentialCandidates: ",
            "input must be the result of CollectLiftableAbelianEssentialCandidates"
        );
    fi;
    if not IsBool(verbose) then
        Error("DeduplicateLiftableAbelianEssentialCandidates: verbose must be true or false");
    fi;

    prepared := [];

    if verbose then
        Print(
            "Preparing fast equivalence invariants for ",
            Length(poolResult.candidates), " candidates ...\n"
        );
    fi;

    for candidate in poolResult.candidates do
        data := LAM_DiagonalEquivalencePreData(candidate);
        Add(prepared, rec(
            entry    := candidate,
            eqData   := data,
            quickKey := data.quickKey
        ));
    od;

    Sort(prepared, function(a, b)
        return a.quickKey < b.quickKey;
    end);

    unique := [];
    duplicateCount := 0;
    i := 1;

    while i <= Length(prepared) do
        j := i;
        while j <= Length(prepared) and
              prepared[j].quickKey = prepared[i].quickKey do
            j := j + 1;
        od;

        bucket := prepared{[i .. j - 1]};
        bucketReps := [];

        if verbose and Length(bucket) > 1 then
            Print(
                "Exact comparison inside a bucket of size ",
                Length(bucket), " ...\n"
            );
        fi;

        for item in bucket do
            matched := false;

            for repItem in bucketReps do
                test := LAM_FastDiagonalEquivalenceData(
                    item.eqData,
                    repItem.eqData
                );

                if test.equivalent then
                    representative := repItem.entry;
                    representative.sourceIndices := Set(Concatenation(
                        representative.sourceIndices,
                        item.entry.sourceIndices
                    ));
                    representative.sourceNames := Set(Concatenation(
                        representative.sourceNames,
                        item.entry.sourceNames
                    ));
                    representative.equivalenceClassSize :=
                        representative.equivalenceClassSize +
                        item.entry.equivalenceClassSize;

                    duplicateCount := duplicateCount + 1;
                    matched := true;
                    break;
                fi;
            od;

            if not matched then
                Add(bucketReps, item);
            fi;
        od;

        Append(unique, List(bucketReps, x -> x.entry));
        i := j;
    od;

    # Compute/display abstract structures only once for each final class.
    for finalEntry in unique do
        finalEntry.structureDescription :=
            StructureDescription(finalEntry.group);
    od;

    Sort(unique, function(a, b)
        if a.familyDimension <> b.familyDimension then
            return a.familyDimension > b.familyDimension;
        fi;
        if a.order <> b.order then
            return a.order > b.order;
        fi;
        if a.structureDescription <> b.structureDescription then
            return a.structureDescription < b.structureDescription;
        fi;
        return String(a.sourceNames) < String(b.sourceNames);
    end);

    # Compatibility fields are included so that the old printer can run,
    # although the new printer below has accurate wording for equivalence
    # deduplication.
    return rec(
        orderDivisibilityTargets         := poolResult.orderDivisibilityTargets,
        inputCandidateCount              := Length(poolResult.candidates),
        numberOfSubgroupsContainingMu3   := Length(poolResult.candidates),
        numberRemoved                    := duplicateCount,
        numberOfSurvivors                := Length(unique),
        survivors                        := unique,
        sourceSummaries                  := poolResult.sourceSummaries
    );
end;

#############################################################################
## 6. Convenience wrapper
#############################################################################

RunLiftableAbelianEssentialPipeline := function(verbose)
    local pool, deduplicated;

    pool := CollectLiftableAbelianEssentialCandidates(verbose);
    deduplicated := DeduplicateLiftableAbelianEssentialCandidates(
        pool,
        verbose
    );

    return rec(
        pooled       := pool,
        deduplicated := deduplicated
    );
end;

#############################################################################
## 7. Dangerous conjugacy classes and determinant-one restriction
#############################################################################

# Each pair [n, [a_1,...,a_6]] represents the diagonal spectrum
#
#       diag(E(n)^a_1, ..., E(n)^a_6).
#
# We also forbid all Galois conjugates obtained by multiplying exponents by
# a unit modulo n, and all central scalar multiples E(3)^j.

DangerousPatterns := [
    [3,  [0,0,0,0,1,2]],
    [3,  [0,0,0,0,1,1]],
    [3,  [0,0,0,1,1,1]],
    [4,  [0,0,0,1,2,3]],
    [6,  [0,0,1,2,4,5]],
    [8,  [0,1,2,3,4,6]],
    [8,  [0,1,2,4,5,6]],
    [8,  [0,1,2,4,6,7]],
    [12, [0,0,3,4,6,9]]
];;

# This is the characteristic-polynomial list requested in the question.
# It is retained both as a mathematical record of the forbidden classes and
# as a possible independent verification mechanism.

DangerousCharPolys := Concatenation(
    List(DangerousPatterns, p ->
        Concatenation(
            List(Filtered([1 .. p[1]], u -> GcdInt(u, p[1]) = 1), u ->
                List([0 .. 2], j ->
                    CharacteristicPolynomial(
                        E(3)^j *
                        DiagonalMat(List(p[2], a -> E(p[1])^(u * a)))
                    )
                )
            )
        )
    )
);;

#############################################################################
## Canonical spectrum keys
##
## For a diagonal semisimple matrix, GL-conjugacy is determined by the
## multiset of eigenvalues.  The key below is therefore an exact conjugacy
## invariant in the present setting.
#############################################################################

LAM_DiagonalSpectrumKeyFromMatrix := function(M)
    local n, values;

    n := Length(M);
    values := List([1 .. n], i -> String(M[i][i]));
    Sort(values);
    return String(values);
end;

LAM_BuildDangerousSpectrumData := function()
    local records, p, n, exponents, u, j, M, key, oldPosition;

    records := [];

    for p in DangerousPatterns do
        n := p[1];
        exponents := p[2];

        for u in Filtered([1 .. n], x -> GcdInt(x, n) = 1) do
            for j in [0 .. 2] do
                M := E(3)^j * DiagonalMat(
                    List(exponents, a -> E(n)^(u * a))
                );
                key := LAM_DiagonalSpectrumKeyFromMatrix(M);

                oldPosition := PositionProperty(records, r -> r.key = key);
                if oldPosition = fail then
                    Add(records, rec(
                        key            := key,
                        orderParameter := n,
                        exponents      := ShallowCopy(exponents),
                        unit           := u,
                        scalarPower    := j,
                        matrix         := M,
                        charPoly       := CharacteristicPolynomial(M)
                    ));
                fi;
            od;
        od;
    od;

    return records;
end;

DangerousSpectrumData := LAM_BuildDangerousSpectrumData();;
DangerousSpectrumKeys := Set(List(DangerousSpectrumData, r -> r.key));;

#############################################################################
## Dangerous-element detection
##
## This replaces a loop over ConjugacyClasses(G).  Since G is abelian, every
## conjugacy class is a singleton; since G is diagonal, a sorted eigenvalue
## multiset is cheaper than a characteristic-polynomial computation.
#############################################################################

DangerousElementData := function(G)
    local g, key, pos, patternRecord;

    if not IsGroup(G) or not IsFinite(G) then
        Error("DangerousElementData: G must be a finite group");
    fi;

    for g in Elements(G) do
        key := LAM_DiagonalSpectrumKeyFromMatrix(g);
        pos := Position(DangerousSpectrumKeys, key);

        if pos <> fail then
            patternRecord := First(
                DangerousSpectrumData,
                r -> r.key = key
            );

            return rec(
                hasDangerousElement := true,
                witness             := g,
                spectrumKey         := key,
                pattern             := patternRecord
            );
        fi;
    od;

    return rec(
        hasDangerousElement := false,
        witness             := fail,
        spectrumKey         := fail,
        pattern             := fail
    );
end;

HasDangerousElement := function(G)
    return DangerousElementData(G).hasDangerousElement;
end;

# Slower reference implementation using the exact characteristic-polynomial
# formulation supplied in the question.  It is useful for spot checks.

HasDangerousElementByCharacteristicPolynomial := function(G)
    return ForAny(Elements(G), g ->
        CharacteristicPolynomial(g) in DangerousCharPolys
    );
end;

#############################################################################
## Size of the determinant-one subgroup
##
## det(G) is a finite subgroup of C^*, hence cyclic.  Its order is the lcm of
## the orders of the determinants of any generating set.  Thus
##
##       |ker(det)| = |G| / |det(G)|
##
## without enumerating all elements of G.
#############################################################################

LAM_DeterminantOneSubgroupSize := function(G)
    local imageOrder, g;

    if not IsGroup(G) or not IsFinite(G) then
        Error("LAM_DeterminantOneSubgroupSize: G must be finite");
    fi;

    imageOrder := 1;
    for g in GeneratorsOfGroup(G) do
        imageOrder := Lcm(imageOrder, Order(DeterminantMat(g)));
    od;

    return Size(G) / imageOrder;
end;

#############################################################################
## Apply the two final restrictions to a list of candidate records
#############################################################################

FilterEntriesByDangerousAndDeterminant := function(entries, determinantBound)
    local kept, removed, entry, newEntry,
          dangerousData, kernelSize, reasons;

    if not IsList(entries) then
        Error("FilterEntriesByDangerousAndDeterminant: entries must be a list");
    fi;
    if not IsInt(determinantBound) or determinantBound < 1 then
        Error("FilterEntriesByDangerousAndDeterminant: determinantBound must be positive");
    fi;

    kept := [];
    removed := [];

    for entry in entries do
        if not IsRecord(entry) or not IsBound(entry.group) then
            Error(
                "FilterEntriesByDangerousAndDeterminant: every entry must ",
                "be a record with a .group component"
            );
        fi;

        dangerousData := DangerousElementData(entry.group);
        kernelSize := LAM_DeterminantOneSubgroupSize(entry.group);

        newEntry := ShallowCopy(entry);
        newEntry.hasDangerousElement :=
            dangerousData.hasDangerousElement;
        newEntry.dangerousElementWitness := dangerousData.witness;
        newEntry.dangerousPattern := dangerousData.pattern;
        newEntry.determinantOneSubgroupSize := kernelSize;
        newEntry.determinantOneBound := determinantBound;
        newEntry.passesDangerousRestriction :=
            not dangerousData.hasDangerousElement;
        newEntry.passesDeterminantRestriction :=
            kernelSize <= determinantBound;
        newEntry.passesFinalRestrictions :=
            (not dangerousData.hasDangerousElement) and
            kernelSize <= determinantBound;

        if newEntry.passesFinalRestrictions then
            Add(kept, newEntry);
        else
            reasons := [];

            if dangerousData.hasDangerousElement then
                Add(reasons, "contains an element in DangerousPatterns");
            fi;

            if kernelSize > determinantBound then
                Add(reasons, Concatenation(
                    "determinant-one subgroup has order ",
                    String(kernelSize),
                    " > ",
                    String(determinantBound)
                ));
            fi;

            newEntry.removalReasons := reasons;
            Add(removed, newEntry);
        fi;
    od;

    return rec(
        inputCount          := Length(entries),
        determinantOneBound := determinantBound,
        numberOfSurvivors   := Length(kept),
        numberRemoved       := Length(removed),
        survivors           := kept,
        removed             := removed
    );
end;

ApplyFinalRestrictionsToDedup := function(dedupResult)
    if not IsRecord(dedupResult) or not IsBound(dedupResult.survivors) then
        Error(
            "ApplyFinalRestrictionsToDedup: input must have a .survivors list"
        );
    fi;

    return FilterEntriesByDangerousAndDeterminant(
        dedupResult.survivors,
        12
    );
end;

#############################################################################
## 8. Full convenience wrapper
#############################################################################

RunLiftableAbelianCompletePipeline := function(verbose)
    local base, restricted;

    base := RunLiftableAbelianEssentialPipeline(verbose);
    restricted := ApplyFinalRestrictionsToDedup(base.deduplicated);

    return rec(
        pooled       := base.pooled,
        deduplicated := base.deduplicated,
        restricted   := restricted
    );
end;

#############################################################################
## 9. Display and demonstration helpers
##
## All display-related functions are kept at the bottom of the file.
#############################################################################

LAM_ExponentVectorToMonomialString := function(exponent)
    local parts, i, e;

    parts := [];
    for i in [1 .. Length(exponent)] do
        e := exponent[i];
        if e = 1 then
            Add(parts, Concatenation("x", String(i)));
        elif e > 1 then
            Add(parts, Concatenation("x", String(i), "^", String(e)));
        fi;
    od;

    if Length(parts) = 0 then
        return "1";
    fi;

    return JoinStringsWithSeparator(parts, "*");
end;

InvariantCubicMonomialBasis := function(G)
    local data;

    data := CubicDiagonalModuliData(G);
    return List(
        data.invariantExponentVectors,
        LAM_ExponentVectorToMonomialString
    );
end;

PrintInvariantCubicMonomialBasis := function(G)
    local basis, i;

    basis := InvariantCubicMonomialBasis(G);
    Print("Invariant cubic monomial basis (", Length(basis), " terms):\n");

    for i in [1 .. Length(basis)] do
        Print("  ", basis[i]);
        if i < Length(basis) then
            Print(",");
        fi;
        Print("\n");
    od;
end;

PrintLiftableAbelianPoolSummary := function(poolResult)
    local summary;

    Print("Order-divisibility targets: ",
          poolResult.orderDivisibilityTargets, "\n");
    Print("Combined candidate count: ",
          poolResult.numberOfCandidates, "\n\n");

    for summary in poolResult.sourceSummaries do
        Print(
            summary.sourceIndex, ". ", summary.sourceName,
            "  ambient order=", summary.ambientOrder,
            "  containing mu3=", summary.allSubgroupsContainingMu3,
            "  essential=", summary.essentialSubgroups,
            "  retained=", summary.retainedByOrderFilter,
            "\n"
        );
    od;
end;

# Usage:
#
#   PrintLiftableAbelianDeduplicatedResult(result, printGenerators);
#   PrintLiftableAbelianDeduplicatedResult(
#       result, printGenerators, printInvariantBasis
#   );

PrintLiftableAbelianDeduplicatedResult := function(arg)
    local result, printGenerators, printInvariantBasis,
          i, entry, g;

    if Length(arg) < 2 or Length(arg) > 3 then
        Error(
            "PrintLiftableAbelianDeduplicatedResult: use ",
            "(result, printGenerators [, printInvariantBasis])"
        );
    fi;

    result := arg[1];
    printGenerators := arg[2];
    printInvariantBasis := false;
    if Length(arg) = 3 then
        printInvariantBasis := arg[3];
    fi;

    if not IsBool(printGenerators) or not IsBool(printInvariantBasis) then
        Error("PrintLiftableAbelianDeduplicatedResult: options must be boolean");
    fi;

    Print("Input candidates: ", result.inputCandidateCount, "\n");
    Print("Removed as representation-equivalent duplicates: ",
          result.numberRemoved, "\n");
    Print("Equivalence classes retained: ",
          result.numberOfSurvivors, "\n\n");

    for i in [1 .. Length(result.survivors)] do
        entry := result.survivors[i];

        Print("--------------------------------------------------\n");
        Print("Number: ", i, "\n");
        Print("Structure: ", entry.structureDescription, "\n");
        Print("|H|: ", entry.order, "\n");
        Print("|H / <E(3)I>|: ", entry.projectiveOrder, "\n");
        Print("Invariant cubic dimension: ",
              entry.invariantCubicDimension, "\n");
        Print("Centralizer GL dimension: ",
              entry.centralizerGLDimension, "\n");
        Print("Character multiplicity blocks: ",
              entry.centralizerBlocks, "\n");
        Print("Family dimension: ", entry.familyDimension, "\n");
        Print("Equivalent occurrences merged: ",
              entry.equivalenceClassSize, "\n");
        Print("Sources: ", entry.sourceNames, "\n");

        if printGenerators then
            Print("Generators:\n");
            for g in GeneratorsOfGroup(entry.group) do
                Print(g, "\n");
            od;
        fi;

        if printInvariantBasis then
            PrintInvariantCubicMonomialBasis(entry.group);
        fi;

        Print("\n");
    od;
end;

# Usage:
#
#   PrintLiftableAbelianFinalRestrictedResult(
#       result, printGenerators, printInvariantBasis
#   );

PrintLiftableAbelianFinalRestrictedResult := function(result,
                                                       printGenerators,
                                                       printInvariantBasis)
    local i, entry, g;

    if not IsRecord(result) or not IsBound(result.survivors) then
        Error(
            "PrintLiftableAbelianFinalRestrictedResult: invalid result record"
        );
    fi;
    if not IsBool(printGenerators) or not IsBool(printInvariantBasis) then
        Error(
            "PrintLiftableAbelianFinalRestrictedResult: options must be boolean"
        );
    fi;

    Print("Input deduplicated classes: ", result.inputCount, "\n");
    Print("Determinant-one subgroup bound: ",
          result.determinantOneBound, "\n");
    Print("Removed by final restrictions: ",
          result.numberRemoved, "\n");
    Print("Classes retained: ", result.numberOfSurvivors, "\n\n");

    for i in [1 .. Length(result.survivors)] do
        entry := result.survivors[i];

        Print("--------------------------------------------------\n");
        Print("Number: ", i, "\n");

        if IsBound(entry.structureDescription) then
            Print("Structure: ", entry.structureDescription, "\n");
        else
            Print("Structure: ", StructureDescription(entry.group), "\n");
        fi;

        if IsBound(entry.order) then
            Print("|H|: ", entry.order, "\n");
        else
            Print("|H|: ", Size(entry.group), "\n");
        fi;

        if IsBound(entry.projectiveOrder) then
            Print("|H / <E(3)I>|: ", entry.projectiveOrder, "\n");
        fi;
        if IsBound(entry.invariantCubicDimension) then
            Print("Invariant cubic dimension: ",
                  entry.invariantCubicDimension, "\n");
        fi;
        if IsBound(entry.centralizerGLDimension) then
            Print("Centralizer GL dimension: ",
                  entry.centralizerGLDimension, "\n");
        fi;
        if IsBound(entry.familyDimension) then
            Print("Family dimension: ", entry.familyDimension, "\n");
        fi;

        Print("|H intersect SL(6)|: ",
              entry.determinantOneSubgroupSize, "\n");
        Print("Contains a dangerous element: false\n");

        if IsBound(entry.equivalenceClassSize) then
            Print("Equivalent occurrences merged: ",
                  entry.equivalenceClassSize, "\n");
        fi;
        if IsBound(entry.sourceNames) then
            Print("Sources: ", entry.sourceNames, "\n");
        fi;

        if printGenerators then
            Print("Generators:\n");
            for g in GeneratorsOfGroup(entry.group) do
                Print(g, "\n");
            od;
        fi;

        if printInvariantBasis then
            PrintInvariantCubicMonomialBasis(entry.group);
        fi;

        Print("\n");
    od;
end;

PrintLiftableAbelianRemovedByFinalRestrictions := function(result,
                                                            printWitness)
    local i, entry;

    if not IsRecord(result) or not IsBound(result.removed) then
        Error(
            "PrintLiftableAbelianRemovedByFinalRestrictions: invalid result"
        );
    fi;
    if not IsBool(printWitness) then
        Error(
            "PrintLiftableAbelianRemovedByFinalRestrictions: option must be boolean"
        );
    fi;

    Print("Removed classes: ", result.numberRemoved, "\n\n");

    for i in [1 .. Length(result.removed)] do
        entry := result.removed[i];
        Print("--------------------------------------------------\n");
        Print("Number: ", i, "\n");
        Print("Structure: ", StructureDescription(entry.group), "\n");
        Print("|H|: ", Size(entry.group), "\n");
        Print("Reasons: ", entry.removalReasons, "\n");
        Print("|H intersect SL(6)|: ",
              entry.determinantOneSubgroupSize, "\n");

        if entry.hasDangerousElement and IsRecord(entry.dangerousPattern) then
            Print("Dangerous pattern order parameter: ",
                  entry.dangerousPattern.orderParameter, "\n");
            Print("Dangerous pattern exponents: ",
                  entry.dangerousPattern.exponents, "\n");
            Print("Unit: ", entry.dangerousPattern.unit,
                  ", central scalar power: ",
                  entry.dangerousPattern.scalarPower, "\n");

            if printWitness then
                Print("Witness:\n", entry.dangerousElementWitness, "\n");
            fi;
        fi;

        Print("\n");
    od;
end;

#############################################################################
## Demonstration
##
##   Read("gap_liftable_abelian_original.g");
##
##   # Stages 1-2: enumerate essential subgroups, order-filter, and pool.
##   pool := CollectLiftableAbelianEssentialCandidates(true);
##   PrintLiftableAbelianPoolSummary(pool);
##
##   # Stage 3: representation-equivalence deduplication.
##   dedup := DeduplicateLiftableAbelianEssentialCandidates(pool, true);
##   PrintLiftableAbelianDeduplicatedResult(dedup, false, false);
##
##   # Stage 4: dangerous-element and determinant-one restrictions.
##   final := ApplyFinalRestrictionsToDedup(dedup);
##   FinalRestrictedList := final.survivors;
##   PrintLiftableAbelianFinalRestrictedResult(final, false, true);
##
##   # Or run all stages in one command.
##   all := RunLiftableAbelianCompletePipeline(true);
##   pool := all.pooled;
##   dedup := all.deduplicated;
##   final := all.restricted;
##   FinalRestrictedList := final.survivors;
##
## Optional consistency check for the optimized dangerous-element test:
##
##   ForAll(dedup.survivors, e ->
##       HasDangerousElement(e.group) =
##       HasDangerousElementByCharacteristicPolynomial(e.group)
##   );
##
#############################################################################
