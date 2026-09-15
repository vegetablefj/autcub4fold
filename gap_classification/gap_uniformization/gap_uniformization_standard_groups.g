#############################################################################
## Standard strict lifts for the eight rank-below-15 symplectic families.
##
## Scalar cube roots of unity are included in every strict linear group.
## The two generic index-two components also record their natural
## non-symplectic involution.
#############################################################################

CF_UNI_DiagonalMatrix := function(entries)
    local matrix, position;

    matrix := NullMat(Length(entries), Length(entries), Field(entries));
    for position in [1 .. Length(entries)] do
        matrix[position][position] := entries[position];
    od;
    return matrix;
end;


CF_UNI_BuildStandardGroups := function()
    local omega, iota, identity, scalar, c2, c2First, c2Second,
          c3First, c3Second, c4, s3InitialTransposition,
          s3InitialThreeCycle, s3CorrigendumTransposition,
          s3CorrigendumThreeCycle, c3GenericInvolution,
          s3GenericInvolution, records, record;

    omega := E(3);
    iota := E(4);
    identity := IdentityMat(6);
    scalar := omega * identity;

    c2 := CF_UNI_DiagonalMatrix([1, 1, 1, 1, -1, -1]);
    c2First := c2;
    c2Second := CF_UNI_DiagonalMatrix([1, 1, 1, -1, -1, 1]);
    c3First := CF_UNI_DiagonalMatrix(
        [1, 1, omega, omega, omega^2, omega^2]
    );
    c3Second := CF_UNI_DiagonalMatrix(
        [1, 1, 1, 1, omega, omega^2]
    );
    c4 := CF_UNI_DiagonalMatrix([1, 1, -1, -1, iota, -iota]);

    s3InitialTransposition := [
        [0, 1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0],
        [0, 0, 0, 0, 1, 0],
        [0, 0, 0, 1, 0, 0],
        [0, 0, 0, 0, 0, 1]
    ];
    s3InitialThreeCycle := [
        [0, 0, 1, 0, 0, 0],
        [1, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 1],
        [0, 0, 0, 1, 0, 0],
        [0, 0, 0, 0, 1, 0]
    ];
    s3CorrigendumTransposition := [
        [0, 1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0],
        [0, 0, 0, 1, 0, 0],
        [0, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, -1]
    ];
    s3CorrigendumThreeCycle := [
        [0, 0, 1, 0, 0, 0],
        [1, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0],
        [0, 0, 0, 1, 0, 0],
        [0, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 1]
    ];

    c3GenericInvolution := [
        [1, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0],
        [0, 0, 0, 1, 0, 0],
        [0, 0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1, 0]
    ];
    s3GenericInvolution := CF_UNI_DiagonalMatrix([1, 1, 1, 1, 1, -1]);

    records := [
        rec(
            key := "trivial",
            label := "trivial symplectic group",
            symplecticPart := "1",
            koikeReference := "trivial group",
            genericIndex := 1,
            familyDimension := 20,
            strictSymplecticGenerators := [scalar],
            genericNonSymplecticGenerators := []
        ),
        rec(
            key := "koike-3.1-C2",
            label := "C2, Koike (3.1)",
            symplecticPart := "C2",
            koikeReference := "Koike (3.1)",
            genericIndex := 1,
            familyDimension := 12,
            strictSymplecticGenerators := [scalar, c2],
            genericNonSymplecticGenerators := []
        ),
        rec(
            key := "koike-3.2-C2^2",
            label := "C2^2, Koike (3.2)",
            symplecticPart := "C2^2",
            koikeReference := "Koike (3.2)",
            genericIndex := 1,
            familyDimension := 8,
            strictSymplecticGenerators := [scalar, c2First, c2Second],
            genericNonSymplecticGenerators := []
        ),
        rec(
            key := "koike-3.4-C3",
            label := "C3, Koike (3.4)",
            symplecticPart := "C3",
            koikeReference := "Koike (3.4)",
            genericIndex := 1,
            familyDimension := 8,
            strictSymplecticGenerators := [scalar, c3First],
            genericNonSymplecticGenerators := []
        ),
        rec(
            key := "koike-3.5-C4",
            label := "C4, Koike (3.5)",
            symplecticPart := "C4",
            koikeReference := "Koike (3.5)",
            genericIndex := 1,
            familyDimension := 6,
            strictSymplecticGenerators := [scalar, c4],
            genericNonSymplecticGenerators := []
        ),
        rec(
            key := "koike-3.3-C3",
            label := "C3, Koike (3.3)",
            symplecticPart := "C3",
            koikeReference := "Koike (3.3)",
            genericIndex := 2,
            familyDimension := 8,
            strictSymplecticGenerators := [scalar, c3Second],
            genericNonSymplecticGenerators := [c3GenericInvolution]
        ),
        rec(
            key := "koike-3.6-S3",
            label := "S3, Koike (3.6)",
            symplecticPart := "S3",
            koikeReference := "Koike (3.6)",
            genericIndex := 1,
            familyDimension := 6,
            strictSymplecticGenerators := [
                scalar,
                s3InitialTransposition,
                s3InitialThreeCycle
            ],
            genericNonSymplecticGenerators := []
        ),
        rec(
            key := "koike-corrigendum-0.1-S3",
            label := "S3, corrigendum (0.1)",
            symplecticPart := "S3",
            koikeReference := "Koike corrigendum (0.1)",
            genericIndex := 2,
            familyDimension := 6,
            strictSymplecticGenerators := [
                scalar,
                s3CorrigendumTransposition,
                s3CorrigendumThreeCycle
            ],
            genericNonSymplecticGenerators := [s3GenericInvolution]
        )
    ];

    for record in records do
        record.strictSymplecticGroup :=
            Group(record.strictSymplecticGenerators);
        record.strictSymplecticOrder := Size(record.strictSymplecticGroup);
        record.strictGenericFullGenerators := Concatenation(
            record.strictSymplecticGenerators,
            record.genericNonSymplecticGenerators
        );
        record.strictGenericFullGroup :=
            Group(record.strictGenericFullGenerators);
        record.strictGenericFullOrder := Size(record.strictGenericFullGroup);

        if not ForAll(
            record.strictSymplecticGenerators,
            generator -> DeterminantMat(generator) = 1
        ) then
            Error("A standard symplectic generator has nontrivial determinant.");
        fi;
        if record.strictGenericFullOrder
             <> record.genericIndex * record.strictSymplecticOrder then
            Error("A standard generic full group has the wrong index.");
        fi;
        if Group(Filtered(
            Elements(record.strictGenericFullGroup),
            element -> DeterminantMat(element) = 1
        )) <> record.strictSymplecticGroup then
            Error("The determinant kernel of a standard group is incorrect.");
        fi;
    od;

    return records;
end;


UniformizationStandardGroups := CF_UNI_BuildStandardGroups();

