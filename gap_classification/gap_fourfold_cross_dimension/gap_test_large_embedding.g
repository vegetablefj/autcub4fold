#############################################################################
## Exact regression tests for the large-target embedding backend.
##
## The tests cover positive, negative, and undecided outcomes and recheck
## every positive witness. They write only the caller's redirected transcript;
## no catalogue or containment result is changed.
#############################################################################

Read("gap_cross_dimension_common.g");
Read("gap_large_embedding.g");

CFCD_Test := function(condition, message)
    if not condition then Error(message); fi;
    Print("PASS: ", message, "\n");
end;

testReflection := DiagonalMat([-1, 1]);;
testCycle := [[0,-1],[1,-1]];;
testTarget := PreprocessMatrixGroupStrict([testReflection], 2, fail);;
testChange := [[1,1],[0,1]];;
testSource := PreprocessMatrixGroupStrict([testChange*testReflection*testChange^-1], 2, fail);;
testAnswer := CFCD_SearchLargeEmbedding(testSource, testTarget, rec());;
CFCD_Test(testAnswer.ok = true and testAnswer.method = "subgroup_classes_full_aut"
    and CFCD_VerifyWitness(testSource.gens,testTarget.G,testAnswer.P),
    "nonliteral conjugacy with an explicit witness");

testA := PreprocessMatrixGroupStrict([
    DiagonalMat([1,1,-1,1,-1,-1]),
    DiagonalMat([1,1,1,-1,-1,-1])], 4, fail);;
testB := PreprocessMatrixGroupStrict([
    DiagonalMat([1,-1,-1,1,1,-1]),
    DiagonalMat([1,1,1,-1,-1,-1])], 4, fail);;
CFCD_Test(List(testA.gens,TraceMat) = List(testB.gens,TraceMat),
    "negative example has matching generator traces");
testAnswer := CFCD_LargeCharacterSearch(testA,testB,rec());;
CFCD_Test(testAnswer.exhaustive and Length(testAnswer.list)=0,
    "all class traces and all twists reject inequivalent faithful representations");

testAnswer := CFCD_SearchLargeEmbedding(testSource,testTarget,
    rec(try_literal_inclusion:=false,use_fingerprints:=false,max_aut:=0));;
CFCD_Test(testAnswer.ok = fail and testAnswer.status = "undecided",
    "automorphism cap is undecided, not a negative result");
testAnswer := CFCD_SearchLargeEmbedding(testTarget,testTarget,rec());;
CFCD_Test(testAnswer.ok = true and testAnswer.P=IdentityMat(2),
    "literal containment uses the identity witness");

testC3 := PreprocessMatrixGroupStrict([DiagonalMat([E(3),E(3)^2])],3,fail);;
testAnswer := CFCD_SearchLargeEmbedding(testC3,testTarget,rec());;
CFCD_Test(testAnswer.ok=false and testAnswer.reason="order_divisibility",
    "order divisibility is a strict necessary condition");
Print("LARGE_EMBEDDING_TESTS_DONE\n");
QUIT_GAP(0);
