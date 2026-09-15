#############################################################################
## Exact data for the two non-liftable projective-abelian candidates.
##
## Reading this file defines matrices, invariant cubic bases, dimensions, and
## group metadata.  It performs no enumeration or geometric test.  The
## theoretical classification and downstream smoothness certificates are
## documented in this module's README.md.
#############################################################################

NonliftableAbelianPermutation := [
  [ 0, 1, 0, 0, 0, 0 ],
  [ 0, 0, 1, 0, 0, 0 ],
  [ 1, 0, 0, 0, 0, 0 ],
  [ 0, 0, 0, 0, 1, 0 ],
  [ 0, 0, 0, 0, 0, 1 ],
  [ 0, 0, 0, 1, 0, 0 ]
];

NonliftableAbelianNinthRootDiagonal := DiagonalMat(
  [ E(9), E(9)^4, E(9)^7, E(9), E(9)^4, E(9)^7 ]
);

NonliftableAbelianInvolution := DiagonalMat([ 1, 1, 1, -1, -1, -1 ]);

NonliftableAbelianSourceRecord := rec(
  mathematicalSource := "theoretical classification of non-liftable abelian full projective stabilizers",
  projectiveClassification := "C3^2 and C2 x C3^2",
  matrixConvention := "row action; the permutation matrix has entries (i,sigma(i))",
  verification := "saved exact group and invariant-space data; no tests are run on loading"
);

NonliftableAbelianCandidates := [
  rec(
    label := "NLA-001",
    symplecticPart := "C3",
    symplecticGId := [ 3, 1 ],
    rankS := 12,
    genericIndex := 1,
    fullIndex := 3,
    projectiveGroupId := [ 9, 2 ],
    projectiveGroupStructure := "C3 x C3",
    linearGroupId := [ 27, 4 ],
    linearGroupStructure := "C9 : C3",
    linearOrder := 27,
    determinantOneSubgroupSize := 9,
    liftable := false,
    familyDimension := 2,
    cubicInvariantDimension := 6,
    centralizerDimension := 4,
    matrixGenerators := [
      NonliftableAbelianPermutation,
      NonliftableAbelianNinthRootDiagonal
    ],
    cubicInvariantBasisStrings := [
      "x5*x6^2 + x4*x5^2 + x4^2*x6",
      "x3*x4^2 + x2*x6^2 + x1*x5^2",
      "x3*x5*x6 + x2*x4*x5 + x1*x4*x6",
      "x2*x3*x6 + x1*x3*x4 + x1*x2*x5",
      "x3^2*x5 + x2^2*x4 + x1^2*x6",
      "x2*x3^2 + x1*x2^2 + x1^2*x3"
    ],
    smoothnessStatus := "retained by the theoretical non-liftable abelian classification",
    source := "non-liftable abelian normal form"
  ),
  rec(
    label := "NLA-002",
    symplecticPart := "C3",
    symplecticGId := [ 3, 1 ],
    rankS := 12,
    genericIndex := 1,
    fullIndex := 6,
    projectiveGroupId := [ 18, 5 ],
    projectiveGroupStructure := "C6 x C3",
    linearGroupId := [ 54, 11 ],
    linearGroupStructure := "C2 x (C9 : C3)",
    linearOrder := 54,
    determinantOneSubgroupSize := 9,
    liftable := false,
    familyDimension := 1,
    cubicInvariantDimension := 3,
    centralizerDimension := 2,
    matrixGenerators := [
      NonliftableAbelianPermutation,
      NonliftableAbelianNinthRootDiagonal,
      NonliftableAbelianInvolution
    ],
    cubicInvariantBasisStrings := [
      "x3*x4^2 + x2*x6^2 + x1*x5^2",
      "x3*x5*x6 + x2*x4*x5 + x1*x4*x6",
      "x2*x3^2 + x1*x2^2 + x1^2*x3"
    ],
    smoothnessStatus := "retained by the theoretical non-liftable abelian classification",
    source := "non-liftable abelian normal form"
  )
];

FinalNonliftableAbelianCandidates := NonliftableAbelianCandidates;
