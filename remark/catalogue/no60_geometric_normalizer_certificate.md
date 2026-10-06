# No. 60 geometric normalizer certificate

From `remark/catalogue`, run
`gap -q -r no60_geometric_normalizer_certificate.g`. The script reads the
frozen 156-family GAP input and contains the three exact strict witnesses
for Nos. 84, 85, and 107 into No. 60 in that input's original coordinates.
It does not create or change any result file. Any failed assertion stops the
certificate before its final `PASS` line.
On 2026-10-04 this command finished with exit code 0 and `PASS` under WSL
GAP 4.12.1; the script prints its GAP version for later reruns.
The coordinate-consistent version below was rerun on 2026-10-05 under
Windows GAP 4.15.1 and reached its final `PASS` with exit code 0.

The public cross-dimension edge results now use the displayed coordinates:
`P_displayed = Q_source^-1 P_old Q_target`. They cannot be applied directly
to the old-coordinate `Families` input. The certificate therefore freezes
only the three original witness matrices, recording their original source
in its comments, and rechecks their subgroup inclusions,
orders, scalar kernels, and complete characters. The public edge results
are not changed by this certificate.

The fixed rational matrix `M` is checked directly against the full No. 60
linear group. The certificate checks that it fixes the scalar kernel,
normalizes the group, preserves every element's exact primitive-\(H^4\)
trace, and exchanges both projective `S3` subgroups for No. 107. It also
checks the strict No. 84 and No. 85 witnesses, the complete projective
characters of all their eligible `D12` subgroups, and that `M` exchanges
the two members of each separate character-matched pair. The corresponding
full linear preimages, not merely projective subgroups, are compared.

This certificate establishes the geometric exchange. The integral-lattice
conclusion also uses the No. 60 parent identification and connected-family
argument explained in `no60_normalizer_assignment_audit.md`; the script
does not identify either saved OSCAR class number with a particular frozen
GAP strict witness.
