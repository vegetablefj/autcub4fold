#############################################################################
## Direct five-dimensional containment tests for the 40 threefold families.
## Every eligible pair is tested independently. No fourfold decisions,
## transitive decisions, saturation, or deduplication are used here.
## See gap_threefold_script.md.
#############################################################################

TD_Paths := function()
    local self, shared;
    if IsExistingFile("gap_threefold_cross_dimension.g") then
        self := ""; shared := "../";
    elif IsExistingFile("gap_threefold/gap_threefold_cross_dimension.g") then
        self := "gap_threefold/"; shared := "";
    elif IsExistingFile(
        "gap_classification/gap_threefold/gap_threefold_cross_dimension.g") then
        self := "gap_classification/gap_threefold/";
        shared := "gap_classification/";
    else
        Error("Run from the repository root, gap_classification, or ",
            "gap_classification/gap_threefold.");
    fi;
    return rec(self := self,
        functionsFile := Concatenation(shared,"gap_functions.g"),
        catalogueFile := Concatenation(self,"result/gap_threefold_families.g"));
end;

TD_PathRecord := TD_Paths();
if not IsBound(SearchEmbeddingStrict) then Read(TD_PathRecord.functionsFile); fi;

TD_Read := function(path, name)
    if IsBoundGlobal(name) then UnbindGlobal(name); fi;
    Read(path);
    if not IsBoundGlobal(name) then Error("Missing saved object: ",name); fi;
    return ValueGlobal(name);
end;

TD_Write := function(path, name, value)
    local stream;
    stream := OutputTextFile(path,false);
    if stream = fail then Error("Cannot open result: ",path); fi;
    SetPrintFormattingStatus(stream,false);
    AppendTo(stream,name," := ",value,";\n");
    CloseStream(stream);
end;

TD_Log := function(log, message)
    local line;
    log.step := log.step + 1;
    line := Concatenation(String(log.step),". ",message,"; elapsed ",
        String(Runtime()-log.started)," ms\n");
    Print(line);
    AppendTo(log.stream,line);
end;

TD_Options := rec(stop_first := true, allow_hard_iso := true,
    construct_witness := true, try_literal_inclusion := true,
    use_fingerprints := false);
TD_Algorithm := "direct-five-dimensional-strict-embedding-1";
TD_WitnessConvention := "P^-1 * g * P belongs to the target group for every source generator";

TD_Binding := function(catalogue)
    return List(catalogue,r -> rec(number := r.number,
        sourceFourfoldNumber := r.sourceFourfoldNumber, sourceKey := r.sourceKey,
        familyDimension := r.familyDimension, strictOrder := r.strictOrder,
        projectiveOrder := r.projectiveOrder,
        matrixGenerators := r.matrixGenerators));
end;

TD_CheckWitness := function(sourceGenerators, targetGroup, matrix)
    local inverse;
    if matrix = fail or not IsList(matrix) or Length(matrix) <> 5
       or not ForAll(matrix,r -> IsList(r) and Length(r)=5)
       or IsZero(DeterminantMat(matrix)) then return false; fi;
    inverse := matrix^-1;
    return ForAll(sourceGenerators,g -> inverse*g*matrix in targetGroup);
end;

TD_Preprocess := function(family)
    local info;
    if CF_MatrixListDimension(family.matrixGenerators) <> 5 then
        Error("Expected five-dimensional generators at family ",family.number);
    fi;
    info := PreprocessMatrixGroupStrict(family.matrixGenerators,
        family.strictOrder,family.linearGroupId);
    if Size(info.G) <> family.strictOrder
       or family.strictOrder <> 3*family.projectiveOrder then
        Error("Strict/projective order mismatch at family ",family.number);
    fi;
    if not E(3)*IdentityMat(5) in info.G then
        Error("Missing cubic scalar at family ",family.number);
    fi;
    return info;
end;

TD_NewPair := function(source, target)
    local eligible;
    eligible := source.familyDimension > target.familyDimension
        and target.strictOrder mod source.strictOrder = 0;
    return rec(sourcePosition := source.number, targetPosition := target.number,
        sourceNumber := source.number, targetNumber := target.number,
        sourceFourfoldNumber := source.sourceFourfoldNumber,
        targetFourfoldNumber := target.sourceFourfoldNumber,
        sourceDimension := source.familyDimension,
        targetDimension := target.familyDimension,
        sourceOrder := source.strictOrder, targetOrder := target.strictOrder,
        eligible := eligible, ok := fail, status := "not_compared",
        reason := "dimension_orientation", method := "dimension_filter",
        direct := true, classification := "direct", viaNumber := fail,
        P := fail, witnessVerified := false, characterEmbeddingProved := false);
end;

TD_TestPair := function(source, target, sourceInfo, targetInfo)
    local pair, caught, result, matrix;
    pair := TD_NewPair(source,target);
    if source.familyDimension <= target.familyDimension then return pair; fi;
    if target.strictOrder mod source.strictOrder <> 0 then
        pair.ok := false; pair.status := "no_embedding";
        pair.reason := "order_divisibility"; pair.method := "order_filter";
        return pair;
    fi;
    caught := CALL_WITH_CATCH(SearchEmbeddingStrict,
        [sourceInfo,targetInfo,TD_Options]);
    if not caught[1] then
        pair.status := "undecided"; pair.reason := "embedding_computation_error";
        pair.method := "strict";
        return pair;
    fi;
    result := caught[2];
    pair.reason := result.reason; pair.method := result.method;
    if result.ok = false and result.status = "no_embedding" then
        pair.ok := false; pair.status := "no_embedding";
        return pair;
    fi;
    if result.ok <> true or result.status <> "embedded" then
        pair.status := "undecided";
        return pair;
    fi;
    pair.characterEmbeddingProved := true;
    matrix := fail;
    if IsBound(result.P) then matrix := result.P; fi;
    ## Failure of the finite witness search is not a negative decision.
    if matrix = fail and IsBound(result.images) and result.images <> fail then
        caught := CALL_WITH_CATCH(FindInvertibleIntertwiner,
            [sourceInfo.gens,result.images]);
        if caught[1] then matrix := caught[2]; fi;
    fi;
    caught := CALL_WITH_CATCH(TD_CheckWitness,
        [sourceInfo.gens,targetInfo.G,matrix]);
    if caught[1] and caught[2] then
        pair.ok := true; pair.status := "embedded";
        pair.P := matrix; pair.witnessVerified := true;
    else
        pair.status := "undecided";
        pair.reason := "explicit_five_dimensional_witness_not_verified";
    fi;
    return pair;
end;

TD_CheckSavedPair := function(pair, source, target, infos)
    local expected;
    expected := TD_NewPair(source,target);
    if not ForAll(["sourcePosition","targetPosition","sourceNumber",
        "targetNumber","sourceFourfoldNumber","targetFourfoldNumber",
        "sourceDimension","targetDimension","sourceOrder","targetOrder",
        "eligible","direct","classification","viaNumber"],
        name -> IsBound(pair.(name)) and pair.(name)=expected.(name)) then
        Error("Saved pair metadata mismatch at ",[source.number,target.number]);
    fi;
    if not expected.eligible then
        if pair.witnessVerified or pair.characterEmbeddingProved then
            Error("An excluded pair has unsupported witness metadata.");
        fi;
        if source.familyDimension <= target.familyDimension then
            if pair.status <> "not_compared" or pair.ok <> fail
               or pair.reason <> "dimension_orientation" or pair.P <> fail then
                Error("Invalid saved dimension exclusion.");
            fi;
        elif pair.status <> "no_embedding" or pair.ok <> false
           or pair.reason <> "order_divisibility" or pair.P <> fail then
            Error("Invalid saved order exclusion.");
        fi;
    elif pair.status = "embedded" and pair.ok = true then
        if not pair.witnessVerified or not pair.characterEmbeddingProved
           or not TD_CheckWitness(source.matrixGenerators,
                infos[target.number].G,pair.P) then
            Error("Saved five-dimensional witness failed at ",
                [source.number,target.number]);
        fi;
    elif pair.status = "no_embedding" and pair.ok = false then
        if pair.P <> fail or pair.witnessVerified
           or pair.characterEmbeddingProved then Error("Invalid negative record."); fi;
    elif pair.status <> "undecided" or pair.ok <> fail or pair.P <> fail then
        Error("Invalid saved unresolved record.");
    fi;
end;

TD_Manifest := function(catalogue, pairs, status)
    local eligible, positive, negative, unresolved, orientations, orders;
    eligible := Filtered(pairs,p -> p.eligible);
    positive := Filtered(eligible,p -> p.ok=true and p.status="embedded");
    negative := Filtered(eligible,p -> p.ok=false and p.status="no_embedding");
    unresolved := Filtered(eligible,p -> p.status="undecided");
    orientations := Filtered(pairs,p -> p.status="not_compared");
    orders := Filtered(pairs,p -> not p.eligible and p.status="no_embedding");
    return rec(status := status, algorithm := TD_Algorithm, options := TD_Options,
        gapVersion := GAPInfo.Version, catalogueBinding := TD_Binding(catalogue),
        catalogueGenerators := List(catalogue,r -> r.matrixGenerators),
        witnessConvention := TD_WitnessConvention, pairCount := Length(pairs),
        eligiblePairCount := Length(eligible), positiveCount := Length(positive),
        eligibleNegativeCount := Length(negative), undecidedCount := Length(unresolved),
        orientationExcludedCount := Length(orientations), orderExcludedCount := Length(orders),
        pairCoverageVerified := Length(pairs)=1560,
        allEligiblePairsDirect := ForAll(eligible,p -> p.direct=true
            and p.classification="direct" and p.viaNumber=fail),
        allPositiveWitnessesVerified := ForAll(positive,p -> p.witnessVerified));
end;

TD_SelfTest := function()
    local scalar, involution, other, swap, source, target, infos, result,
          witness, reducedOptions;
    Print("Five-dimensional embedding regression checks\nGAP ",
        GAPInfo.Version,"\n\n");
    scalar := E(3)*IdentityMat(5);
    involution := DiagonalMat([-1,1,1,1,1]);
    other := DiagonalMat([-1,-1,1,1,1]);
    swap := IdentityMat(5); swap[1] := [0,1,0,0,0];
    swap[2] := [1,0,0,0,0];
    source := rec(number:=1,sourceFourfoldNumber:=1,familyDimension:=2,
        strictOrder:=6,projectiveOrder:=2,linearGroupId:=[6,2],
        matrixGenerators:=[scalar,involution]);
    target := rec(number:=2,sourceFourfoldNumber:=2,familyDimension:=1,
        strictOrder:=6,projectiveOrder:=2,linearGroupId:=[6,2],
        matrixGenerators:=[scalar,swap^-1*involution*swap]);
    infos := [TD_Preprocess(source),TD_Preprocess(target)];
    result := TD_TestPair(source,target,infos[1],infos[2]);
    if result.ok <> true or not result.witnessVerified
       or not TD_CheckWitness(source.matrixGenerators,infos[2].G,result.P) then
        Error("Positive non-literal five-dimensional regression failed.");
    fi;
    Print("1. Non-literal positive: invertible 5 x 5 P verified on all source generators.\n");
    target.matrixGenerators := [scalar,other];
    infos[2] := TD_Preprocess(target);
    ## Disable optional fingerprints to exercise exhaustive subgroup/character
    ## enumeration in the negative regression, not just a spectral prefilter.
    reducedOptions := ShallowCopy(TD_Options);
    reducedOptions.use_fingerprints := false;
    result := SearchEmbeddingStrict(infos[1],infos[2],reducedOptions);
    if result.ok <> false or result.status <> "no_embedding"
       or result.reason <> "exhausted_no_verified_candidate" then
        Error("Exhaustive negative five-dimensional regression failed.");
    fi;
    Print("2. Negative: exhaustive subgroup/character test without spectral fingerprints.\n");
    witness := TD_NewPair(source,source);
    if witness.status <> "not_compared" or witness.ok <> fail then
        Error("Dimension exclusion regression failed.");
    fi;
    Print("3. Dimension exclusion: not compared, not an abstract nonembedding claim.\n");
    Print("THREEFOLD_CROSS_DIMENSION_SELF_TEST_COMPLETED\n");
end;

TD_Run := function(resume, firstRow, lastRow)
    local catalogue, binding, infos, log, stream, i, j, source, target,
          targets, rowPath, saved, pairs, pair, position, keep, manifest,
          allPairs, seen, pairPath, manifestPath, row, sourceNumbers;
    catalogue := TD_Read(TD_PathRecord.catalogueFile,"CubicThreefoldFamilyCatalogue");
    if Length(catalogue)<>40 or List(catalogue,r -> r.number)<>[1..40] then
        Error("Expected the numbered 40-family presentation catalogue.");
    fi;
    sourceNumbers := List(catalogue,r -> r.sourceFourfoldNumber);
    if sourceNumbers<>Set(sourceNumbers) then
        Error("Expected ascending, distinct fourfold source numbers.");
    fi;
    if Sum(List(catalogue,s -> Length(Filtered(catalogue,t ->
        s.number<>t.number and s.familyDimension>t.familyDimension
        and t.strictOrder mod s.strictOrder=0)))) <> 493 then
        Error("The eligible-pair schedule differs from the 40-family catalogue.");
    fi;
    binding := TD_Binding(catalogue);
    stream := OutputTextFile(Concatenation(TD_PathRecord.self,
        "output/gap_threefold_cross_dimension.log"),false);
    if stream=fail then Error("Cannot open the direct-search log."); fi;
    SetPrintFormattingStatus(stream,false);
    log := rec(stream:=stream,started:=Runtime(),step:=0);
    AppendTo(stream,"Direct five-dimensional threefold containment\nGAP ",
        GAPInfo.Version,"\nOptions: ",TD_Options,"\nResume: ",resume,"\n\n");
    TD_Log(log,"40 families; 1560 ordered pairs; 493 eligible direct tests");
    pairPath := Concatenation(TD_PathRecord.self,
        "result/gap_threefold_cross_dimension_all_pairs.g");
    manifestPath := Concatenation(TD_PathRecord.self,
        "result/gap_threefold_cross_dimension_manifest.g");
    if firstRow=1 and lastRow=40 then
        TD_Write(manifestPath,"ThreefoldCrossDimensionManifest",
            TD_Manifest(catalogue,[],"running"));
    fi;
    infos := [];
    for i in [1..40] do
        TD_Log(log,Concatenation("Family ",String(i)," (fourfold source ",
            String(catalogue[i].sourceFourfoldNumber),
            "): constructing and checking its strict five-dimensional group"));
        Add(infos,TD_Preprocess(catalogue[i]));
    od;
    allPairs := [];
    for i in [firstRow..lastRow] do
        source := catalogue[i];
        targets := Filtered([1..40],j -> j<>i);
        rowPath := Concatenation(TD_PathRecord.self,
            "output/threefold_direct_row_",String(i),".g");
        pairs := [];
        if resume and IsExistingFile(rowPath) then
            saved := TD_Read(rowPath,"ThreefoldDirectRow");
            if saved.catalogueBinding<>binding or saved.options<>TD_Options
               or saved.algorithm<>TD_Algorithm or saved.sourceNumber<>i
               or saved.gapVersion<>GAPInfo.Version
               or Length(saved.pairs)>39 then
                Error("Resume input/algorithm binding mismatch in row ",i);
            fi;
            keep := Length(saved.pairs);
            for position in [1..Length(saved.pairs)] do
                pair := saved.pairs[position]; j := targets[position];
                TD_CheckSavedPair(pair,source,catalogue[j],infos);
                if pair.status="undecided" and keep=Length(saved.pairs) then
                    keep := position-1;
                fi;
            od;
            if keep>0 then pairs := saved.pairs{[1..keep]}; fi;
            TD_Log(log,Concatenation("Source ",String(i),": restored ",
                String(keep)," checked pair records"));
        fi;
        for position in [Length(pairs)+1..39] do
            j := targets[position]; target := catalogue[j];
            TD_Log(log,Concatenation("Source ",String(i)," -> target ",
                String(j),": started; pair ",String(position),"/39"));
            pair := TD_TestPair(source,target,infos[i],infos[j]);
            Add(pairs,pair);
            TD_Write(rowPath,"ThreefoldDirectRow",rec(
                algorithm:=TD_Algorithm,options:=TD_Options,
                catalogueBinding:=binding,sourceNumber:=i,pairs:=pairs,
                rowComplete:=Length(pairs)=39,gapVersion:=GAPInfo.Version));
            TD_Log(log,Concatenation("Source ",String(i)," -> target ",
                String(j),": ",pair.status,"; ",pair.reason));
        od;
        Append(allPairs,pairs);
        TD_Log(log,Concatenation("Source ",String(i),": completed; positives ",
            String(Length(Filtered(pairs,p -> p.ok=true))),"; unresolved ",
            String(Length(Filtered(pairs,p -> p.status="undecided")))));
    od;
    if firstRow=1 and lastRow=40 then
        seen := List([1..40],i -> List([1..40],j -> false));
        for pair in allPairs do
            i:=pair.sourceNumber; j:=pair.targetNumber;
            if i=j or seen[i][j] then Error("Duplicate/self direct pair."); fi;
            TD_CheckSavedPair(pair,catalogue[i],catalogue[j],infos);
            seen[i][j]:=true;
        od;
        if not ForAll([1..40],i -> ForAll([1..40],j -> i=j or seen[i][j])) then
            Error("Incomplete ordered-pair coverage.");
        fi;
        manifest := TD_Manifest(catalogue,allPairs,"completed");
        if manifest.pairCount<>1560 or manifest.eligiblePairCount<>493 then
            Error("Invalid full direct-search coverage.");
        fi;
        TD_Write(pairPath,"ThreefoldCrossDimensionAllPairs",allPairs);
        TD_Write(manifestPath,"ThreefoldCrossDimensionManifest",manifest);
        TD_Log(log,Concatenation("Completed: eligible ",
            String(manifest.eligiblePairCount),"; positives ",
            String(manifest.positiveCount),"; eligible negatives ",
            String(manifest.eligibleNegativeCount),"; undecided ",
            String(manifest.undecidedCount)));
        Print("THREEFOLD_CROSS_DIMENSION_COMPLETED undecided=",
            manifest.undecidedCount,"\n");
        AppendTo(stream,"THREEFOLD_CROSS_DIMENSION_COMPLETED undecided=",
            manifest.undecidedCount,"\n");
    else
        Print("THREEFOLD_CROSS_DIMENSION_ROWS_COMPLETED\n");
        AppendTo(stream,"THREEFOLD_CROSS_DIMENSION_ROWS_COMPLETED\n");
    fi;
    CloseStream(stream);
end;

TD_CommandSettings := function()
    local position, arguments;
    position := PositionProperty(GAPInfo.SystemCommandLine,x -> IsString(x)
        and PositionSublist(x,"gap_threefold_cross_dimension.g")<>fail);
    arguments := [];
    if position<>fail and position<Length(GAPInfo.SystemCommandLine) then
        arguments := List(GAPInfo.SystemCommandLine{
            [position+1..Length(GAPInfo.SystemCommandLine)]},EvalString);
    fi;
    if Length(arguments)=0 then arguments := [0,1,40,0]; fi;
    if Length(arguments)<>4 or not ForAll(arguments,IsInt)
       or not arguments[1] in [0,1] or not arguments[4] in [0,1]
       or arguments[2]<1 or arguments[3]>40 or arguments[2]>arguments[3] then
        Error("Use: gap -r -q -b gap_threefold_cross_dimension.g ",
            "<resume 0/1> <first row> <last row> <self-test 0/1>.");
    fi;
    return arguments;
end;

if not IsBound(TD_DEFINE_ONLY) or TD_DEFINE_ONLY<>true then
    TD_Settings := TD_CommandSettings();
    if TD_Settings[4]=1 then TD_SelfTest();
    else TD_Run(TD_Settings[1]=1,TD_Settings[2],TD_Settings[3]); fi;
    QUIT_GAP(0);
fi;
