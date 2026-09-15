#############################################################################
##
## gap_small_nonabelian_c2_2.g
##
## Ordered liftable non-abelian inputs for the C2^2 symplectic component.
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


CF_SN_C2_2Configuration := function()
    local KgenOne, KgenTwo, candidateGIds;

    KgenOne := [
        [ 1, 0, 0, 0, 0, 0 ],
        [ 0, 1, 0, 0, 0, 0 ],
        [ 0, 0, 1, 0, 0, 0 ],
        [ 0, 0, 0, 1, 0, 0 ],
        [ 0, 0, 0, 0, -1, 0 ],
        [ 0, 0, 0, 0, 0, -1 ]
    ];
    KgenTwo := [
        [ 1, 0, 0, 0, 0, 0 ],
        [ 0, 1, 0, 0, 0, 0 ],
        [ 0, 0, 1, 0, 0, 0 ],
        [ 0, 0, 0, -1, 0, 0 ],
        [ 0, 0, 0, 0, -1, 0 ],
        [ 0, 0, 0, 0, 0, 1 ]
    ];
    candidateGIds := CF_SN_YYZNonabelianFullGroupIds("C2^2");

    return rec(
        schemaVersion := 1,
        label := "small non-abelian C2^2",
        symplecticPart := "C2^2",
        symplecticGId := [4, 2],
        engine := "liftable S_1--S_3",
        components := [
            rec(
                label := "unique C2^2 component",
                genericIndex := 1,
                expectedSymplecticInvariantDimension := 20,
                Kgens := [KgenOne, KgenTwo],
                gids := ShallowCopy(candidateGIds),
                sourceRecords := [
                    "G_s=C_2x_C_2_all_liftable_non-abelian.docx"
                ]
            )
        ]
    );
end;


# Examples, after the audited liftable engine has been read:
# C2_2Config := CF_SN_C2_2Configuration();;
# C2_2Audit := CF_SN_ValidateCaseConfiguration(C2_2Config);;
# C2_2Candidates := CF_SN_RunS1S2S3Configuration(C2_2Config);;
