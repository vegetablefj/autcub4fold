#############################################################################
## Exact conjugacy embeddings for the large-target stage.
## Dependencies: gap_functions.g (loaded by gap_cross_dimension_common.g).
## Adapted from the collaborator's 2026-08-29 strict_embedding.g algorithm:
## all target subgroup conjugacy classes, then all source automorphisms.
## No collaborator containment results are read.
#############################################################################

CFCD_LargeProgress := function(options, message)
    if IsBound(options.verbose) and options.verbose = true then
        Print("  ", message, "\n");
    fi;
end;


## One target-conjugacy representative of each image subgroup suffices.
## Every isomorphism onto that subgroup is a fixed isomorphism composed with
## a source automorphism. Generator traces only reject; all class traces
## must agree before accepting. Finite characteristic-zero representations
## with equal characters are linearly equivalent.
CFCD_LargeCharacterSearch := function(source, target, options)
    local started, caught, embeddings, subgroupClass, subgroup, iso,
          sourceData, automorphisms, traceTable, beta, matches, match,
          images, hom, position, permutationImages, phaseStarted;

    started := Runtime();
    if not source.strict_ok or not target.strict_ok then
        return rec(exhaustive := false, list := [], reason := "preprocess");
    fi;
    if target.order mod source.order <> 0 then
        return rec(exhaustive := true, list := [], reason := "order");
    fi;

    if not IsBound(target.cfcd_subgroup_classes) then
        CFCD_LargeProgress(options, "subgroup classes: started");
        caught := CALL_WITH_CATCH(ConjugacyClassesSubgroups, [target.P]);
        if not caught[1] then
            return rec(exhaustive := false, list := [], reason := "ccs_error");
        fi;
        target.cfcd_subgroup_classes := caught[2];
        CFCD_LargeProgress(options, Concatenation(
            "subgroup classes: completed; count=",
            String(Length(caught[2])), "; cpu_ms=", String(Runtime()-started)
        ));
    fi;

    ## Preserve the reference algorithm's order: finish the subgroup scan
    ## before testing twists. Cache only data independent of the source.
    phaseStarted := Runtime();
    embeddings := [];
    for subgroupClass in target.cfcd_subgroup_classes do
        subgroup := Representative(subgroupClass);
        if Size(subgroup) = source.order then
            caught := CALL_WITH_CATCH(IsomorphismGroups, [source.P, subgroup]);
            if not caught[1] then
                return rec(exhaustive := false, list := [], reason := "iso_error");
            fi;
            if caught[2] <> fail then
                Add(embeddings, caught[2]);
            fi;
        fi;
    od;
    CFCD_LargeProgress(options, Concatenation(
        "isomorphic subgroup classes=", String(Length(embeddings)),
        "; cpu_ms=", String(Runtime()-phaseStarted)
    ));
    if Length(embeddings) = 0 then
        return rec(exhaustive := true, list := [], reason := "no_abstract_subgroup");
    fi;

    sourceData := StrictEnsureSourceCharacterData(source);
    phaseStarted := Runtime();
    automorphisms := StrictAutGroup(source, options);
    if not automorphisms.exhaustive then
        return rec(exhaustive := false, list := [], reason := "aut_unavailable_or_capped");
    fi;
    CFCD_LargeProgress(options, Concatenation(
        "source automorphisms=", String(automorphisms.size),
        "; cpu_ms=", String(Runtime()-phaseStarted)
    ));

    ## Iterate the full automorphism group, not a materialized list.
    ## The identity is tried first as in the reference implementation.
    for iso in embeddings do
        traceTable := IsoTraceTable(source, target, iso);
        matches := function(automorphism)
            local k, element;
            for k in [1 .. Length(sourceData.permutationGenerators)] do
                element := sourceData.permutationGenerators[k];
                if automorphism <> fail then
                    element := Image(automorphism, element);
                fi;
                if sourceData.generatorTraces[k] <> IsoTraceOf(traceTable, element) then
                    return false;
                fi;
            od;
            for k in [1 .. Length(sourceData.classRepresentatives)] do
                element := sourceData.classRepresentatives[k];
                if automorphism <> fail then
                    element := Image(automorphism, element);
                fi;
                if sourceData.classTraces[k] <> IsoTraceOf(traceTable, element) then
                    return false;
                fi;
            od;
            return true;
        end;
        match := matches(fail);
        beta := fail;
        if not match then
            for beta in automorphisms.aut do
                if matches(beta) then
                    match := true;
                    break;
                fi;
            od;
        fi;
        if not match then
            continue;
        fi;
        permutationImages := [];
        for position in [1 .. Length(sourceData.permutationGenerators)] do
            if beta = fail then
                Add(permutationImages, Image(iso, sourceData.permutationGenerators[position]));
            else
                Add(permutationImages, Image(iso, Image(beta, sourceData.permutationGenerators[position])));
            fi;
        od;
        hom := GroupHomomorphismByImages(
            source.P, target.P, sourceData.permutationGenerators, permutationImages
        );
        if hom = fail or not IsInjective(hom) then
            return rec(exhaustive := false, list := [], reason := "hom_verification_failed");
        fi;
        images := List(permutationImages, element -> PreImagesRepresentative(target.iso_perm, element));
        return rec(exhaustive := true,
            list := [rec(images := images, method := "subgroup_classes_full_aut")],
            reason := "character_match");
    od;
    return rec(exhaustive := true, list := [], reason := "exhausted_subgroup_classes_and_twists");
end;


## This entry point never selects IsomorphicSubgroups. A failed literal
## inclusion is only a failed shortcut, not a negative decision. Failures of
## exhaustive infrastructure remain undecided. Explicit witnesses are
## required and independently checked by the large-target driver.
CFCD_SearchLargeEmbedding := function(source, target, options)
    local filters, search, verification, useFingerprints, tryLiteral;

    if not (IsBound(source.strict_ok) and source.strict_ok)
       or not (IsBound(target.strict_ok) and target.strict_ok) then
        return rec(ok := fail, status := "undecided", reason := "preprocess", method := "strict");
    fi;
    if Length(source.gens[1]) <> Length(target.gens[1]) then
        return rec(ok := false, status := "no_embedding", reason := "ambient_dimension", method := "filter");
    fi;
    filters := NecessaryFiltersStrict(source, target);
    if not filters.ok then
        if filters.reason = "bad_group_data" then
            return rec(ok := fail, status := "undecided", reason := filters.reason, method := "filter");
        fi;
        return rec(ok := false, status := "no_embedding", reason := filters.reason, method := "filter");
    fi;
    tryLiteral := not IsBound(options.try_literal_inclusion) or options.try_literal_inclusion;
    if tryLiteral and ForAll(source.gens, element -> element in target.G) then
        return rec(ok := true, status := "embedded", reason := "literal_matrix_subgroup",
            method := "literal_matrix_subgroup", P := IdentityMat(Length(source.gens[1])),
            images := ShallowCopy(source.gens));
    fi;
    StrictEnsureDerived(source);
    StrictEnsureDerived(target);
    filters := NecessaryFiltersStrict(source, target);
    if not filters.ok then
        return rec(ok := false, status := "no_embedding", reason := filters.reason, method := "filter");
    fi;
    useFingerprints := not IsBound(options.use_fingerprints) or options.use_fingerprints;
    if useFingerprints then
        StrictEnsureFingerprints(source);
        StrictEnsureFingerprints(target);
        filters := NecessaryFiltersStrict(source, target);
        if not filters.ok then
            return rec(ok := false, status := "no_embedding", reason := filters.reason, method := "filter");
        fi;
    fi;
    search := CFCD_LargeCharacterSearch(source, target, options);
    if not search.exhaustive then
        return rec(ok := fail, status := "undecided", reason := search.reason,
            method := "subgroup_classes_full_aut");
    fi;
    if Length(search.list) = 0 then
        return rec(ok := false, status := "no_embedding", reason := search.reason,
            method := "subgroup_classes_full_aut");
    fi;
    verification := StrictVerifyCandidates(source, target, search.list);
    if verification.found then
        return rec(ok := true, status := "embedded", reason := "found",
            method := verification.method, P := verification.P, images := verification.images);
    fi;
    return rec(ok := true, status := "embedded", reason := "character_iso_no_explicit_P",
        method := search.list[1].method, P := fail, images := search.list[1].images);
end;
