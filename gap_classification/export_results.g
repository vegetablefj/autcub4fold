#############################################################################
## Mechanical export of the final family catalogues and saved relations.
## No group, invariant-space, liftability, or embedding search is performed.
## Run from the repository root or gap_classification/ after all source audits.
## Projective group labels are saved in result_display_labels.g.
#############################################################################

if IsExistingFile("gap_manuscript_validation/gap_family_catalogue.g") then
    CF_RE_SourceRoot := "";
    CF_RE_ResultRoot := "../gap_result/";
elif IsExistingFile("gap_classification/gap_manuscript_validation/gap_family_catalogue.g") then
    CF_RE_SourceRoot := "gap_classification/";
    CF_RE_ResultRoot := "gap_result/";
else
    Error("Run export_results.g from the repository root or gap_classification/.");
fi;

Read(Concatenation(CF_RE_SourceRoot,
    "gap_fourfold_cross_dimension/gap_family_poset_functions.g"));

CF_RE_Read := function(path, name)
    return CF_FP_ReadGlobal(Concatenation(CF_RE_SourceRoot,path),name);
end;

CF_RE_CopyFields := function(source, fields)
    local target, name;
    target := rec();
    for name in fields do
        if IsBound(source.(name)) then target.(name) := source.(name); fi;
    od;
    return target;
end;

CF_RE_NumberSet := function(numbers)
    local text, i;
    text := "{";
    for i in [1 .. Length(numbers)] do
        if i > 1 then Append(text,", "); fi;
        Append(text,String(numbers[i]));
    od;
    Append(text,"}");
    return text;
end;

CF_RE_YesNo := function(value)
    if value = true then return "Yes";
    elif value = false then return "No";
    else return "Not tested"; fi;
end;

CF_RE_Relations := function(catalogue, pairs, audit, dimension)
    local count, expected, excluded, decisions, row, key, eligible,
          positive, negative, unknown, directPositive, transitivePositive,
          source, target, i, j, result, keys, maxima;
    count := Length(catalogue); expected := []; excluded := [];
    for i in [1 .. count] do
        for j in [1 .. count] do
            if i <> j then
                eligible := catalogue[i].familyDimension > catalogue[j].familyDimension
                    and catalogue[j].linearGroupId[1] mod catalogue[i].linearGroupId[1] = 0;
                if eligible then Add(expected,[i,j]); else Add(excluded,[i,j]); fi;
            fi;
        od;
    od;
    positive := []; negative := []; unknown := []; decisions := [];
    directPositive := []; transitivePositive := []; keys := [];
    for row in pairs do
        key := [row.sourceNumber,row.targetNumber];
        if not key[1] in [1 .. count] or not key[2] in [1 .. count]
           or key[1] = key[2] or key in keys then Error("Invalid saved pair: ",key); fi;
        Add(keys,key); eligible := key in expected;
        source := catalogue[key[1]]; target := catalogue[key[2]];
        if row.sourceOrder <> source.linearGroupId[1]
           or row.targetOrder <> target.linearGroupId[1]
           or row.sourceDimension <> source.familyDimension
           or row.targetDimension <> target.familyDimension
           or (IsBound(row.eligible) and row.eligible <> eligible) then
            Error("Saved relation metadata does not match the final catalogue: ",key);
        fi;
        if eligible then
            result := CF_RE_CopyFields(row,["sourceNumber","targetNumber",
                "classification","direct","method","status","reason","viaNumber"]);
            result.eligible := true; result.decision := row.ok;
            Add(decisions,result);
            if row.ok = true then
                Add(positive,key);
                if row.direct = true then Add(directPositive,key);
                else Add(transitivePositive,key); fi;
            elif row.ok = false then Add(negative,key);
            else Add(unknown,key); fi;
        elif row.ok = true then
            Error("An excluded pair carries a positive embedding decision: ",key);
        fi;
    od;
    if Set(List(decisions,r->[r.sourceNumber,r.targetNumber])) <> Set(expected)
       or Set(positive) <> Set(audit.positivePairs)
       or not IsBound(audit.coverClosureVerified) or audit.coverClosureVerified <> true
       or not IsBound(audit.transitiveClosureVerified) or audit.transitiveClosureVerified <> true
       or not ForAll(audit.coverPairs,p->p in positive) then
        Error("Incomplete relation export or inconsistent source audit.");
    fi;
    if dimension = 5 and Set(keys) <> Set(Concatenation(expected,excluded)) then
        Error("Expected all ordered distinct threefold pairs.");
    elif dimension = 6 and Set(keys) <> Set(expected) then
        Error("Expected exactly the eligible fourfold pairs.");
    fi;
    maxima := Set(audit.actionMaximalNumbers);
    if maxima <> Filtered([1 .. count],i->not ForAny(positive,p->p[1]=i))
       or maxima <> Filtered([1 .. count],i->catalogue[i].isActionMaximal) then
        Error("Action-maximal flags disagree with the complete positive relation.");
    fi;
    return rec(schemaVersion := 1, familyCount := count,
        matrixDimension := dimension,
        groupDirection := "i -> j means a proper GL-conjugate embedding H_i into H_j",
        familyDirection := "i -> j means Z_j is properly contained in Z_i",
        orderedDistinctPairCount := count*(count-1),
        eligiblePairCount := Length(expected), excludedPairCount := Length(excluded),
        positivePairCount := Length(positive), negativePairCount := Length(negative),
        unknownPairCount := Length(unknown), directPositiveCount := Length(directPositive),
        transitivePositiveCount := Length(transitivePositive),
        eligibleDecisions := decisions, excludedPairs := Set(excluded),
        positivePairs := Set(positive), negativePairs := Set(negative),
        unknownPairs := Set(unknown), directPositivePairs := Set(directPositive),
        transitivePositivePairs := Set(transitivePositive),
        coverPairs := Set(audit.coverPairs), coverCount := Length(audit.coverPairs),
        actionMaximalNumbers := maxima, actionMaximalCount := Length(maxima),
        geometricMaximalNumbers := Filtered([1 .. count],i->not ForAny(positive,p->p[2]=i)),
        geometricMinimalNumbers := maxima,
        coverTargets := List([1 .. count],i->List(Filtered(audit.coverPairs,p->p[1]=i),p->p[2])),
        allPositiveTargets := List([1 .. count],i->List(Filtered(Set(positive),p->p[1]=i),p->p[2])),
        actionMaximalTargets := List([1 .. count],function(i)
            if i in maxima then return [i]; fi;
            return List(Filtered(Set(positive),p->p[1]=i and p[2] in maxima),p->p[2]);
        end),
        sourceCoverClosureVerified := true, sourceTransitivityVerified := true,
        newEmbeddingSearchPerformed := false);
end;

CF_RE_Markdown := function(kind, catalogue, relation)
    local stream, entry, number, dimensions, dimension;
    stream := OutputTextFile(Concatenation(CF_RE_ResultRoot,kind,"_result.md"),false);
    if stream = fail then Error("Cannot open result table."); fi;
    SetPrintFormattingStatus(stream,false);
    AppendTo(stream,"# Cubic-",kind," results\n\n",
        "The numbered representatives, complete invariant cubic bases, and metadata are in ",
        "[the family data](",kind,"_families.g). The complete saved relation and its covers are in ",
        "[the relation data](",kind,"_relations.g). These files are display-only exports.\n\n");
    if kind = "fourfold" then
        AppendTo(stream,"The 156 rows use the final fourfold order. `H` is the strict linear group, ",
            "`G = H / <omega I6>` is its projective quotient, and the index is `[G:G_s]`. ",
            "The generic index belongs to the containing connected symplectic family.\n\n");
    else
        AppendTo(stream,"The 40 rows are ordered by increasing source fourfold number. ",
            "`H` is the strict five-dimensional group and `G = H / <omega I5>` is its projective quotient. ",
            "Fermat rank refers to the threefold, not to its six-variable suspension. ",
            "All threefold actions are liftable and F-liftable by the coprime criterion: ",
            "the cubic degree 3 is coprime to the number of variables 5. ",
            "These flags are not inherited from the source fourfold.\n\n");
    fi;
    AppendTo(stream,"For both tables, `m = W - C`, where `W` is the dimension of the complete invariant cubic space ",
        "and `C` is the dimension of the linear centralizer. Every row is saturated. ",
        "`[order, --]` records a known order without a supplied SmallGroups identifier. ",
        "Equal abstract group identifiers do not identify matrix actions.\n\n",
        "A group relation `i -> j` means a proper embedding up to linear conjugacy. ",
        "Its geometric direction is reversed: `Z_j subset Z_i`. ",
        "An action-maximal row has no outgoing group relation; it is geometrically minimal, ",
        "not geometrically maximal. Covers omit relations with an intermediate classified family.\n\n",
        "## Summary\n\n| Quantity | Count |\n| --- | ---: |\n",
        "| Families | ",Length(catalogue)," |\n",
        "| Ordered distinct pairs | ",relation.orderedDistinctPairCount," |\n",
        "| Eligible pairs | ",relation.eligiblePairCount," |\n",
        "| Excluded by dimension or order | ",relation.excludedPairCount," |\n",
        "| Positive relations | ",relation.positivePairCount," |\n",
        "| Direct positive decisions | ",relation.directPositiveCount," |\n",
        "| Positive decisions obtained by transitivity | ",relation.transitivePositiveCount," |\n",
        "| Negative eligible decisions | ",relation.negativePairCount," |\n",
        "| Unknown eligible decisions | ",relation.unknownPairCount," |\n",
        "| Covers | ",relation.coverCount," |\n",
        "| Action-maximal families | ",relation.actionMaximalCount," |\n",
        "| Liftable families | ",Number(catalogue,r->r.isLiftable=true)," |\n",
        "| F-liftable families | ",Number(catalogue,r->r.isFLiftable=true)," |\n\n",
        "Excluded pairs were ruled out by the static dimension/order restrictions; ",
        "they are not additional negative search decisions. Unknowns are recorded separately ",
        "and are never counted as negatives. The positive relation includes both direct and ",
        "transitive decisions. Explicit matrix certificates remain in the source calculation modules.\n\n",
        "## Family dimensions\n\n| Dimension | Families |\n| ---: | ---: |\n");
    dimensions := Set(List(catalogue,r->r.familyDimension));
    for dimension in dimensions do
        AppendTo(stream,"| ",dimension," | ",Number(catalogue,r->r.familyDimension=dimension)," |\n");
    od;
    AppendTo(stream,"\n## All families\n\n");
    if kind = "fourfold" then
        AppendTo(stream,"| No. | Projective group G | Symplectic part | rank S | Generic index | Index | m | W | C | H ID | G ID | Liftable | F-liftable | Action-maximal |\n",
            "| ---: | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- | --- | --- | --- |\n");
    else
        AppendTo(stream,"| No. | Source fourfold | Projective group G | Fermat rank | m | W | C | H ID | G ID | Liftable | F-liftable | Action-maximal |\n",
            "| ---: | ---: | --- | ---: | ---: | ---: | ---: | --- | --- | --- | --- | --- |\n");
    fi;
    for entry in catalogue do
        AppendTo(stream,"| ",entry.number," | ");
        if kind = "threefold" then AppendTo(stream,entry.sourceFourfoldNumber," | "); fi;
        AppendTo(stream,"$",entry.projectiveGroupLabel,"$ | ");
        if kind = "fourfold" then
            AppendTo(stream,"`",entry.symplecticPart,"` | ",entry.rankS," | ",
                entry.genericIndex," | ",entry.fullIndex," | ");
        else AppendTo(stream,entry.threefoldFermatRank," | "); fi;
        AppendTo(stream,entry.familyDimension," | ",entry.invariantDimension," | ",
            entry.centralizerDimension," | `",CF_FP_GroupIdText(entry.linearGroupId),
            "` | `",CF_FP_GroupIdText(entry.projectiveGroupId),"` | ",
            CF_RE_YesNo(entry.isLiftable)," | ",CF_RE_YesNo(entry.isFLiftable)," | ",
            CF_RE_YesNo(entry.isActionMaximal)," |\n");
    od;
    AppendTo(stream,"\n## Extremal rows\n\n",
        "Action-maximal (geometrically minimal): `",CF_RE_NumberSet(relation.actionMaximalNumbers),"`.\n\n",
        "Geometrically maximal: `",CF_RE_NumberSet(relation.geometricMaximalNumbers),"`.\n\n",
        "## Complete relation, covers, and action-maximal targets\n\n",
        "The second column lists the full positive relation, including transitive pairs. ",
        "The third lists only covers. All reachable action-maximal targets appear in the fourth; ",
        "an action-maximal row lists itself there.\n\n",
        "| No. | All positive group targets | Cover targets | Action-maximal targets |\n",
        "| ---: | --- | --- | --- |\n");
    for number in [1 .. Length(catalogue)] do
        AppendTo(stream,"| ",number," | `",CF_RE_NumberSet(relation.allPositiveTargets[number]),
            "` | `",CF_RE_NumberSet(relation.coverTargets[number]),"` | `",
            CF_RE_NumberSet(relation.actionMaximalTargets[number]),"` |\n");
    od;
    CloseStream(stream);
end;

CF_RE_Run := function()
    local four, three, fourAudit, threeAudit, coordinateAudit, threeCoordinate,
          lift, fourPairs, threePairs, fourLabels, threeLabels, entry, row,
          labelSnapshot, number, families4, families3, relation4, relation3, stream;
    four := CF_RE_Read("gap_manuscript_validation/gap_family_catalogue.g",
        "CubicFourfoldFamilyCatalogue");
    three := CF_RE_Read("gap_threefold/result/gap_threefold_families.g",
        "CubicThreefoldFamilyCatalogue");
    coordinateAudit := CF_RE_Read("gap_manuscript_validation/gap_family_correspondence.out",
        "FamilyCoordinateAudit");
    threeCoordinate := CF_RE_Read("gap_threefold/result/gap_threefold_coordinate_audit.out",
        "CubicThreefoldCoordinateAudit");
    fourAudit := CF_RE_Read("gap_fourfold_cross_dimension/result/gap_fourfold_maximal.out",
        "FourfoldMaximalAudit");
    threeAudit := CF_RE_Read("gap_threefold/result/gap_threefold_containment.out",
        "ThreefoldContainmentAudit");
    lift := CF_RE_Read("gap_liftability/gap_liftability.out","CubicFourfoldLiftabilityAudit");
    fourPairs := CF_RE_Read("gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_all_pairs.g",
        "FourfoldCrossDimensionAllPairs");
    threePairs := CF_RE_Read("gap_threefold/result/gap_threefold_cross_dimension_all_pairs.g",
        "ThreefoldCrossDimensionAllPairs");
    labelSnapshot := CF_RE_Read("result_display_labels.g","FinalProjectiveGroupLabels");
    if not IsRecord(labelSnapshot)
       or not IsBound(labelSnapshot.fourfold)
       or not IsBound(labelSnapshot.threefold)
       or Length(labelSnapshot.fourfold) <> 156
       or Length(labelSnapshot.threefold) <> 40
       or not ForAll(labelSnapshot.fourfold,IsString)
       or not ForAll(labelSnapshot.threefold,IsString) then
        Error("The saved final-order projective group labels are incomplete.");
    fi;
    if List(four,r->r.number) <> [1 .. 156] or List(three,r->r.number) <> [1 .. 40]
       or List(three,r->r.sourceFourfoldNumber) <> Set(List(three,r->r.sourceFourfoldNumber))
       or coordinateAudit.status <> "completed" or coordinateAudit.verifiedCount <> 156
       or threeCoordinate.status <> "completed" or threeCoordinate.verifiedCount <> 40
       or fourAudit.status <> "completed" or threeAudit.status <> "completed"
       or lift.status <> "completed" or lift.familyCount <> 156
       or List(lift.results,r->r.number) <> [1 .. 156] then
        Error("The final source catalogues or audits are incomplete.");
    fi;
    fourLabels := labelSnapshot.fourfold;
    threeLabels := labelSnapshot.threefold;
    families4 := []; families3 := [];
    for number in [1 .. 156] do
        entry := four[number]; row := lift.results[number];
        if row.rankS <> entry.rankS or row.symplecticPart <> entry.symplecticPart
           or row.familyDimension <> entry.familyDimension or row.fullIndex <> entry.fullIndex
           or row.linearGroupId <> entry.linearGroupId or row.projectiveGroupId <> entry.projectiveGroupId
           or row.isLiftable <> entry.isLiftable or row.isFLiftable <> entry.isFLiftable
           or entry.familyDimension <> entry.invariantDimension-entry.centralizerDimension
           or Length(entry.coefficientBasis) <> entry.invariantDimension then
            Error("Final fourfold metadata or liftability mismatch: ",number);
        fi;
        row := CF_RE_CopyFields(entry,["number","sourceKey","standardPosition",
            "symplecticPart","rankS","genericIndex","fullIndex","familyDimension",
            "linearGroupId","projectiveGroupId","invariantDimension","centralizerDimension",
            "symplecticGenerators","genericFullGenerators","extraGenerator","matrixGenerators",
            "cubicExponents","coefficientBasis","isLiftable","isFLiftable","isActionMaximal"]);
        row.projectiveGroupLabel := fourLabels[number]; row.isSaturated := true;
        row.liftabilityMethod := lift.results[number].method;
        Add(families4,row);
    od;
    for number in [1 .. 40] do
        entry := three[number];
        if entry.familyDimension <> entry.invariantDimension-entry.centralizerDimension
           or Length(entry.coefficientBasis) <> entry.invariantDimension
           or entry.sourceKey <> four[entry.sourceFourfoldNumber].sourceKey then
            Error("Final threefold metadata mismatch: ",number);
        fi;
        row := CF_RE_CopyFields(entry,["number","sourceFourfoldNumber","sourceKey",
            "sourceFullIndex","threefoldFermatRank","fourfoldFermatRank","familyDimension",
            "invariantDimension","centralizerDimension","linearGroupId","projectiveGroupId",
            "strictOrder","projectiveOrder","matrixGenerators","cubicExponents",
            "coefficientBasis","isActionMaximal"]);
        row.projectiveGroupLabel := threeLabels[number]; row.isSaturated := true;
        row.sourceSymplecticPart := four[entry.sourceFourfoldNumber].symplecticPart;
        row.sourceRankS := four[entry.sourceFourfoldNumber].rankS;
        row.sourceGenericIndex := four[entry.sourceFourfoldNumber].genericIndex;
        row.isLiftable := true; row.isFLiftable := true;
        row.liftabilityMethod := "coprime_degree_and_number_of_variables";
        Add(families3,row);
    od;
    relation4 := CF_RE_Relations(families4,fourPairs,fourAudit,6);
    relation3 := CF_RE_Relations(families3,threePairs,threeAudit,5);
    relation4.sourceDecisions := "../gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_all_pairs.g";
    relation3.sourceDecisions := "../gap_classification/gap_threefold/result/gap_threefold_cross_dimension_all_pairs.g";
    if relation4.positivePairCount <> 1793 or relation4.coverCount <> 433
       or relation4.actionMaximalCount <> 21 or relation4.unknownPairCount <> 0
       or relation3.positivePairCount <> 260 or relation3.coverCount <> 83
       or relation3.actionMaximalCount <> 7 or relation3.unknownPairCount <> 0 then
        Error("Unexpected completed relation counts.");
    fi;
    CF_FP_Write(Concatenation(CF_RE_ResultRoot,"fourfold_families.g"),"FourfoldResultFamilies",families4);
    CF_FP_Write(Concatenation(CF_RE_ResultRoot,"threefold_families.g"),"ThreefoldResultFamilies",families3);
    CF_FP_Write(Concatenation(CF_RE_ResultRoot,"fourfold_relations.g"),"FourfoldResultRelations",relation4);
    CF_FP_Write(Concatenation(CF_RE_ResultRoot,"threefold_relations.g"),"ThreefoldResultRelations",relation3);
    if CF_FP_ReadGlobal(Concatenation(CF_RE_ResultRoot,"fourfold_families.g"),
           "FourfoldResultFamilies") <> families4
       or CF_FP_ReadGlobal(Concatenation(CF_RE_ResultRoot,"threefold_families.g"),
           "ThreefoldResultFamilies") <> families3
       or CF_FP_ReadGlobal(Concatenation(CF_RE_ResultRoot,"fourfold_relations.g"),
           "FourfoldResultRelations") <> relation4
       or CF_FP_ReadGlobal(Concatenation(CF_RE_ResultRoot,"threefold_relations.g"),
           "ThreefoldResultRelations") <> relation3 then
        Error("The GAP-readable result exports did not round-trip exactly.");
    fi;
    CF_RE_Markdown("fourfold",families4,relation4);
    CF_RE_Markdown("threefold",families3,relation3);
    stream := OutputTextFile(Concatenation(CF_RE_ResultRoot,"README.md"),false);
    SetPrintFormattingStatus(stream,false);
    AppendTo(stream,"# Final classification results\n\n",
        "This directory displays the final 156 cubic-fourfold and 40 cubic-threefold families. ",
        "The fourfold rows use the final order 1–156; the threefold rows use increasing source fourfold number. ",
        "The classification programs do not read these display exports. ",
        "The separate numbering and generator files below supply fixed inputs to later lattice calculations.\n\n",
        "## Files\n\n| File | Content |\n| --- | --- |\n",
        "| [fourfold_families.g](fourfold_families.g) | Full six-dimensional representatives, complete cubic bases, and metadata |\n",
        "| [fourfold_relations.g](fourfold_relations.g) | Complete positive relation, eligible decisions, covers, and extremal rows |\n",
        "| [fourfold_result.md](fourfold_result.md) | Fourfold tables and statistics |\n",
        "| [threefold_families.g](threefold_families.g) | Final five-dimensional presentations, complete cubic bases, and metadata |\n",
        "| [threefold_relations.g](threefold_relations.g) | Complete positive relation, eligible decisions, covers, and extremal rows |\n",
        "| [threefold_result.md](threefold_result.md) | Threefold tables and statistics |\n",
        "| [family_numbering.md](../remark/input/family_numbering.md) | Fixed fourfold numbering, rank, index, and dimension used by the lattice scripts. |\n",
        "| [family_generators.g](../remark/input/family_generators.g) | Display-coordinate fourfold generators used for character and geometric identification checks. |\n\n",
        "## Data conventions\n\n",
        "`H` is the strict linear group; its projective quotient is `G = H / <omega I_n>`. ",
        "Matrices act on row variables by `x -> x*g`. ",
        "The rows of `coefficientBasis` give the complete invariant cubics in the monomial order `cubicExponents`. ",
        "`familyDimension = invariantDimension - centralizerDimension`. ",
        "An identifier `[order,0]` in GAP means that the order is supplied but no SmallGroups ID is supplied.\n\n",
        "A positive pair `[i,j]` means a proper GL-conjugate embedding `H_i` into `H_j`; ",
        "the family inclusion is `Z_j subset Z_i`. `positivePairs` is the full strict relation, ",
        "not only its covers. `coverPairs` has no intermediate classified row. ",
        "`negativePairs` contains only resolved eligible negative decisions; excluded pairs and unknowns ",
        "are separate. An action-maximal row is geometrically minimal, not geometrically maximal.\n\n",
        "All threefold liftability flags follow from coprimality of 3 and 5. Fourfold flags come from ",
        "the [liftability audit](../gap_classification/gap_liftability/README.md). ",
        "Source-fourfold rank and index fields in the threefold data describe the source, not the threefold action.\n\n",
        "## Sources and regeneration\n\n",
        "The full [fourfold catalogue and coordinate correspondence](../gap_classification/gap_manuscript_validation/README.md), ",
        "[fourfold relation](../gap_classification/gap_fourfold_cross_dimension/README.md), and ",
        "[threefold extraction and direct relation](../gap_classification/gap_threefold/README.md) ",
        "remain in their computation modules with the proof certificates. ",
        "The separately extracted threefold representatives remain in that module; they are not a second final result list here.\n\n",
        "For mechanical regeneration, run GAP from the repository root and read ",
        "[`gap_classification/export_results.g`](../gap_classification/export_results.g). ",
        "Projective group labels are saved in ",
        "[`result_display_labels.g`](../gap_classification/result_display_labels.g). ",
        "The export checks saved metadata and coverage, then replaces the six display files above and this README. ",
        "It does not rewrite the two fixed lattice-input files. ",
        "It performs no classification, invariant-space, liftability, or embedding calculation.\n");
    CloseStream(stream);
    Print("FINAL_RESULT_EXPORT_COMPLETED: 156 fourfolds; 40 threefolds.\n");
end;

CF_RE_Run();
