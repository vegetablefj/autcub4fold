# No. 105 lattice-action computation log

Started 2026-10-02 07:55 UTC, with a two-hour wall-clock budget. The full
enumeration completed at 09:26 UTC and produced one verified integral action.
No existing catalogue row or source result was overwritten.

## Input and exact rational filter

No. 105 has symplectic kernel (C_2^2), full projective group
(A_4\times C_2), non-symplectic index six, rank-(12) (S), and
rank-(10) (T). The generic (C_2^2) lattice in the numbered catalogue
(row 97) has (|\det T|=3072).

At the Fermat specialization, the projective group can be represented by
the pair permutations (a=(12)(34)), (b=(12)(56)) and a monomial lift
(t=\operatorname{diag}(\omega^2,\omega^2,1,1,1,1)P_{(1\,3\,5\,2\,4\,6)}).
The (V_4=\langle a,b\rangle)-invariants in primitive fourth cohomology
have traces (10,1,1,-8,1,1) for (t^0,\ldots,t^5). Equivalently,
the order-six action on (T) has rational characteristic polynomial
(\Phi_1\Phi_2^3\Phi_6^3); the three blocks have signatures
((1,0),(3,0),(4,2)). These trace values were independently reproduced
from the squarefree Jacobian-ring model of the Fermat cubic and from the
coordinate action's primitive-cohomology character formula. The standalone exact
GAP calculation is saved as `verify_no105_character.g`.
The same certificate checks that the displayed monomial lifts generate a
linear group of order 72 with projective quotient SmallGroup [24,13].

The same exact calculation gives traces (12,0,0,6,0,0) on the
rank-12 coinvariant lattice (S), hence characteristic polynomial
(\Phi_1^3\Phi_2\Phi_3^3\Phi_6) for this chosen order-six generator.
From the verified No. 97 restriction, (|\det S|=1024) and
(|\det T|=3072), so any primitive extension to the cubic lattice has
glue order (\sqrt{1024\cdot3072/3}=1024). This is an input for a later
full-extension test, not a claim that the current T-only enumeration
already identifies the geometric action.

The first computational route uses OSCAR 1.8.2 to enumerate order-six
actions in the **genus** of this (T) with the exact character and signature.
Each returned lattice is then tested for isometry with the exact input
(T); a genus representative is not automatically an action on the chosen
lattice. This does **not** by itself classify No. 105: a retained action
still needs a compatible (S\hookrightarrow\Lambda_0) extension, root
checks, and identification with the displayed cubic family.
In particular, Nos. 104 and 105 share the group ID, index, rank and
dimension; those coarse fields alone cannot assign a lattice output to
No. 105. Their displayed linear actions do have different exact
characters on the respective V4-invariant rank-ten lattice: the traces
of the chosen order-six generator's powers are
`(10,2,-2,-4,-2,2)` for No. 104 and `(10,1,1,-8,1,1)` for No. 105.
Equivalently their T-characteristic polynomials are
`Phi_1 Phi_2 Phi_3 Phi_6^3` and `Phi_1 Phi_2^3 Phi_6^3`.
The S traces are respectively `(12,0,0,-6,0,0)` and
`(12,0,0,6,0,0)`. The standalone exact GAP certificate
`verify_no104_no105_character.g` checks both pairs of characters and
the corresponding displayed linear-group IDs. The certificate also builds
an explicit invertible 6-by-6 change of basis simultaneously taking the
six-edge Fermat generators to the listed coordinate action's No. 105 generators.
The six-edge monomial representation and this distinction are needed
in the numbered identification; one retained integral action alone
does not yet prove uniqueness.

An independent exact Smith-form calculation on the saved No. 97
rank-10 Gram matrix gives diagonal
`(1,1,2,2,2,2,2,2,4,12)`. Thus the 2-primary discriminant group
needs eight generators and the 3-primary part one. Nikulin's
even-indefinite uniqueness criterion (Theorem 1.14.2 of *Integral
symmetric bilinear forms and some of their applications*) applies:
rank 10 exceeds the 2-primary length 8 and is at least two above the
odd-primary length. Consequently this genus has one *underlying lattice*
class. The script nevertheless tests each returned lattice against the
exact input, since none of this identifies the isometries themselves.

## Running record

- 07:55 UTC: Began read-only audits of No. 1 and No. 105 lattice data.
- 07:58 UTC: Confirmed WSL Julia 1.10.11 and OSCAR 1.8.2 in
  `~/research/oscar-julia18`; no heavy Julia/GAP process was active.
- 08:00 UTC: Derived the exact (T)-character above; prepared the bounded
  direct-isometry script. The No. 1 catalogue row contains only its rank-two
  (T)-action, not a complete rank-22 ambient group action.
- 08:03--08:11 UTC: A preflight deserializing the entire 156-row catalogue
  remained active in the loader for over seven minutes. This preflight was
  stopped before enumeration. The input was changed to the compact verified
  No. 97 restriction file, from which the catalogue itself obtains its
  (T)-lattice.
- 08:12 UTC: Compact-source preflight passed: rank 10, determinant 3072,
  OSCAR 1.8.2. No isometry enumeration ran during preflight.
- 08:12 UTC: The first protected service attempt ended immediately because
  systemd's PATH did not contain Julia (exit 127). The launcher was corrected
  to an absolute Julia path; no mathematical work was lost.
- 08:15 UTC: Exact GAP Jacobian-ring character certificate passed, with
  traces (10,1,1,-8,1,1). A second detached systemd attempt started, but
  WSL shut down its user service when the launching command exited; it
  did not reach the enumeration. The status file from that attempt was stale.
- 08:16:50 UTC: Launched a foreground systemd scope, keeping WSL alive.
  The enumeration began at 08:17:21 UTC. It uses one Julia thread, an
  automatic stop after 90 minutes, and cgroup MemoryHigh=5 GiB,
  MemoryMax=7 GiB, MemorySwapMax=0. At 08:17:33 UTC the actual Julia
  process and the cgroup limits were verified; memory use was 2.7 GiB.
- 08:20 UTC: Extended the exact GAP certificate to the full primitive
  character and the rank-12 coinvariant character; both assertions passed.
- 08:22 UTC: During source audit, found that the post-enumeration
  cyclotomic-kernel check referred to a helper defined only in another
  script. Stopped our four-minute-old enumeration before it could return
  an unsaved result; added the local helper without altering the search
  constraints. The corrected foreground run started at 08:22:49 UTC and
  entered enumeration at 08:23:19 UTC. Its 90-minute timeout ends by
  09:52:49 UTC, before the 09:55 UTC two-hour deadline.
- 08:32:55 UTC: The exact enumerator returned 26 classes in the genus
  after 575.8 seconds. The subsequent validation stopped immediately
  because `full_rank_model` was another helper not defined in this
  standalone script; consequently no 26-class file was saved. The raw
  enumerator itself did not report an error.
- 08:34 UTC: Added a local full-rank conversion and an immediate raw-MRDI
  checkpoint before per-class tests. A complete symbol audit found no
  further borrowed helper names. The corrected run started at 08:34:39
  UTC and entered the same enumeration at 08:35:08 UTC. Its automatic
  stop was shortened to 75 minutes, ending by 09:49:39 UTC.
- 08:44:42 UTC: The same exact search again returned 26 genus action
  classes, in 573.5 seconds. OSCAR rejected serialization of the
  heterogeneous `Vector{ZZLatWithIsom}` before writing the checkpoint.
  Changed the storage to a heterogeneous `Tuple`, matching established
  repository MRDI records. A separate compact-source save/reload smoke
  test, including the full-rank conversion, passed.
- 08:47:27 UTC: Started the corrected run; it entered enumeration at
  08:47:57 UTC. The automatic stop is now 60 minutes, ending by
  09:47:27 UTC, well before the overall 09:55 UTC limit.
- 08:57:30 UTC: Completed successfully in ten minutes. The enumerator
  returned 26 genus action classes, saved in
  `no105_T_raw_genus_classes.mrdi`. All 26 passed the exact input-(T)
  isometry check, order-six test, characteristic and minimal polynomial
  tests, and rank-six (\Phi_6)-kernel check. The filtered tuple is saved
  in `no105_T_enumeration.mrdi`; it was reloaded and counted successfully.
  These are **T-action classes**, not yet 26 No. 105 geometric families.
- 08:59 UTC: The standalone full-lattice extension script passed its
  preflight: exact (S,T) from the same verified No. 97 source and required
  glue order 1024. A parse-only check also passed after per-action MRDI
  checkpoints were added.
- 09:01:25 UTC: Started the bounded full-lattice extension test for the
  26 actions. It has one thread, the same 5/7 GiB no-swap memory guard,
  and a 45-minute automatic stop, ending before 09:47 UTC.
- 09:08:49 UTC: T-action 1 had four fitting primitive-extension classes.
  One survived the stable-discriminant, S-character, root, saturation,
  period, and projective-group tests, with group `[24,13]`. Its complete
  lattice data were saved in `no105_extensions_action_01.mrdi`. This is an
  integral lattice candidate, not yet an identification of numbered
  geometric family No. 105.
- 09:10:49 UTC: T-action 2 had four fitting extensions and none survived.
  OSCAR then failed while serializing an empty tuple for its per-action
  checkpoint. The first checkpoint remains intact. This is an output-format
  failure after the mathematical tests for action 2, not an extension-search
  failure; the script is being corrected for resumable runs.
- 09:11 UTC: An independent exact mod-3 audit of all 26 saved actions
  (including `F*G*transpose(F)==G` for each) found that only saved indices
  `1, 2, 10, 13, 14, 20` act trivially on `A_T[3]` of order three.
  Because `|A_S|=2^10` and the primitive glue has order `2^10`, the
  3-primary part of `A_Lambda0` is naturally `A_T[3]`. A cubic-fourfold
  automorphism fixes the polarization, hence must act trivially on
  `A_Lambda0`. The other 20 T-actions therefore cannot give the target
  stable ambient action. This is a necessary filter only; the six remaining
  actions still require full extension and geometric identification.
- 09:15:50 UTC: Corrected empty-checkpoint serialization (store `nothing`
  instead of an empty tuple) and added checkpoint resumption. A separate
  OSCAR 1.8.2 read-only check, `check_no105_discriminant3.jl`, reproduced
  precisely the six allowed indices from the saved lattice actions. The
  corrected extension search restarted in a foreground systemd scope,
  retaining the 5/7 GiB no-swap guard and one thread. Its automatic stop
  is 35 minutes after start, before the overall 09:55 UTC deadline.
- 09:18 UTC: The resumed run loaded action 1's saved integral extension
  without recomputation. A separate exact GAP Jacobian-ring character
  comparison of the listed coordinate action's No. 104 and No. 105 displayed actions
  obtained the distinct T traces and polynomials stated above. In
  particular, their common projective group `[24,13]` is not being used
  as a numbered-family identification criterion.
- 09:20--09:26 UTC: The corrected run completed all six 3-primary-allowed
  T-actions. Action 1 was resumed from its original checkpoint; actions
  2, 10, 13, 14, and 20 were freshly processed. Each completed action
  has an individual MRDI checkpoint. The other 20 actions were excluded
  by the proven necessary discriminant condition, not merely omitted.
- 09:26:36 UTC: Full run exited with code 0. The 6 allowed T-actions
  produced 20 fitting primitive-extension classes. Of these, 18 failed
  the exact S-character, one had a root obstruction, and exactly one
  (T-action 1, extension 1) passed all tests, including stable ambient
  action, period signature/dimension, root check, symplectic saturation,
  and projective group `[24,13]`. The final
  `no105_extensions.mrdi` was saved and reloaded successfully; no heavy
  calculation remains running. The unique output is an integral-lattice
  classification under the script's necessary constraints. Its numbered
  geometric interpretation uses the independently verified No. 105
  character and the existing classification/existence of that smooth
  family; it is not an independent reconstruction from Fermat planes.
- 09:30 UTC: Extended and ran the GAP certificate with an explicit
  Fermat-to-listed-coordinate No. 105 linear conjugacy. Combined with the unique
  integral output and the established smooth No. 105 family, this
  identifies the saved action with numbered No. 105. The raw MRDI retains
  `numbered_assignment_claimed=false` because the separate geometric
  certificate was completed afterward; see `no105_result.md` for the
  combined conclusion. The rank-12 case does not invoke the ambient-lattice catalogue's
  group-recovery lemma, whose hypothesis is rank at least 13. Full generic
  automorphism-group saturation belongs to the separate cubic-family
  classification, not to this lattice computation alone.
- 09:37--09:41 UTC: Independently reloaded the unique MRDI output and
  recomputed its short/long-root check, the stable-kernel orders of S and
  K, and the constructed projective group ID. All passed: no roots,
  `|tilde O(S)|=|tilde O(K)|=4`, and `[24,13]`. The bounded audit
  `audit_no105_recompute.jl` exited with code 0 under the same single-thread,
  5/7 GiB no-swap guard; see `no105_audit_recompute.log`. Neither the raw
  enumeration nor its MRDI result was modified.

## Alternative route if direct enumeration stalls

Construct the No. 1 Fermat action simultaneously from its algebraic cycles.
Yang--Yu give a 21-plane integral basis of the Fermat algebraic lattice.
Monomial automorphisms permute the 405 Fermat planes, so their action on the
rank-20 primitive algebraic sublattice can be recovered by exact intersection
pairings. An equivariant discriminant-form gluing with the known rank-two
transcendental lattice would yield the complete parent action. Only the
specific No. 105 subgroup need then be restricted. This route has not yet
been implemented or verified in the present attempt.
