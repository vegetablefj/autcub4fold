#############################################################################
##
## gap_small_nonabelian_c3.g
##
## Ordered liftable non-abelian inputs for the two C3 symplectic components.
## This file defines a case configuration; the main driver controls execution
## and output.
##
#############################################################################

if not IsBound(CF_CheckSmallGroupId) then
    Read("../gap_functions.g");
fi;
if not IsBound(CF_SN_ValidateCaseConfiguration)
   or not IsBound(CF_SN_YYZNonabelianFullGroupIds) then
    Read("gap_small_nonabelian_functions.g");
fi;


# Swapping the two nontrivial C3 eigenspaces gives the generic projective S3.
CF_SN_C3GenericIndexTwoInvolution := function()
    return [
        [ 1, 0, 0, 0, 0, 0 ],
        [ 0, 1, 0, 0, 0, 0 ],
        [ 0, 0, 1, 0, 0, 0 ],
        [ 0, 0, 0, 1, 0, 0 ],
        [ 0, 0, 0, 0, 0, 1 ],
        [ 0, 0, 0, 0, 1, 0 ]
    ];
end;


CF_SN_C3Configuration := function()
    local omega, KgenGenericOne, KgenGenericTwo, candidateGIds,
          genericFullLinearGenerators;

    omega := E(3);

    # Koike (3.4), in the coordinates used by the reference computation.
    KgenGenericOne := [
        [ 1, 0, 0, 0, 0, 0 ],
        [ 0, 1, 0, 0, 0, 0 ],
        [ 0, 0, omega^2, 0, 0, 0 ],
        [ 0, 0, 0, omega^2, 0, 0 ],
        [ 0, 0, 0, 0, omega, 0 ],
        [ 0, 0, 0, 0, 0, omega ]
    ];

    # Koike (3.3), the component with generic non-symplectic index two.
    KgenGenericTwo := [
        [ 1, 0, 0, 0, 0, 0 ],
        [ 0, 1, 0, 0, 0, 0 ],
        [ 0, 0, 1, 0, 0, 0 ],
        [ 0, 0, 0, 1, 0, 0 ],
        [ 0, 0, 0, 0, omega^2, 0 ],
        [ 0, 0, 0, 0, 0, omega ]
    ];

    candidateGIds := CF_SN_YYZNonabelianFullGroupIds("C3");
    # Include omega*I explicitly so this is the strict linear group used by
    # the conjugacy-containment test, not only its projective image.
    genericFullLinearGenerators := [
        KgenGenericTwo,
        CF_SN_C3GenericIndexTwoInvolution(),
        omega * IdentityMat(6)
    ];

    return rec(
        schemaVersion := 1,
        label := "small non-abelian C3",
        symplecticPart := "C3",
        symplecticGId := [3, 1],
        engine := "liftable S_1--S_3",
        components := [
            rec(
                label := "Koike (3.4), generic index 1",
                genericIndex := 1,
                expectedSymplecticInvariantDimension := 20,
                Kgens := [KgenGenericOne],
                gids := ShallowCopy(candidateGIds),
                sourceRecords := [
                    "C_3_generic=1_family_liftable_nonabelian.docx"
                ]
            ),
            rec(
                label := "Koike (3.3), generic index 2",
                genericIndex := 2,
                expectedSymplecticInvariantDimension := 26,
                Kgens := [KgenGenericTwo],
                gids := CF_SN_GroupIdsForGenericIndex(
                    [3, 1],
                    candidateGIds,
                    2
                ),
                genericFullGroupLabel := "S3",
                genericFullProjectiveGId := [6, 1],
                genericFullLinearGId := [18, 3],
                genericFullLinearGenerators :=
                    genericFullLinearGenerators,
                sourceRecords := [
                    "G_s=C_3_generic_index=2_family_non-abelian.docx"
                ]
            )
        ]
    );
end;


# Examples, after the audited liftable engine has been read:
# C3Config := CF_SN_C3Configuration();;
# C3Audit := CF_SN_ValidateCaseConfiguration(C3Config);;
# C3Candidates := CF_SN_RunS1S2S3Configuration(C3Config);;
