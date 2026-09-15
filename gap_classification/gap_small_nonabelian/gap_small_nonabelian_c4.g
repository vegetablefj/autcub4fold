#############################################################################
##
## gap_small_nonabelian_c4.g
##
## Ordered liftable non-abelian inputs for the C4 symplectic component.
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


CF_SN_C4Configuration := function()
    local Kgen, candidateGIds;

    Kgen := [
        [ 1, 0, 0, 0, 0, 0 ],
        [ 0, 1, 0, 0, 0, 0 ],
        [ 0, 0, -1, 0, 0, 0 ],
        [ 0, 0, 0, -1, 0, 0 ],
        [ 0, 0, 0, 0, E(4), 0 ],
        [ 0, 0, 0, 0, 0, -E(4) ]
    ];
    candidateGIds := CF_SN_YYZNonabelianFullGroupIds("C4");

    return rec(
        schemaVersion := 1,
        label := "small non-abelian C4",
        symplecticPart := "C4",
        symplecticGId := [4, 1],
        engine := "liftable S_1--S_3",
        components := [
            rec(
                label := "unique C4 component",
                genericIndex := 1,
                expectedSymplecticInvariantDimension := 16,
                Kgens := [Kgen],
                gids := ShallowCopy(candidateGIds),
                sourceRecords := [
                    "G_s=C_4,_liftable,_non-abelian.docx"
                ]
            )
        ]
    );
end;


# Examples, after the audited liftable engine has been read:
# C4Config := CF_SN_C4Configuration();;
# C4Audit := CF_SN_ValidateCaseConfiguration(C4Config);;
# C4Candidates := CF_SN_RunS1S2S3Configuration(C4Config);;
