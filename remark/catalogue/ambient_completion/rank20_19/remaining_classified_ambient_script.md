# Remaining classified prescribed ambient actions

This documents the original seven-case construction and independent
verification. The seven saved sidecars and their `.verified.txt` receipts
are retained here. The development-stage runner, verifier, and merger named
below are not included in this selected repository; the current 156-row
catalogue can instead be reloaded and structurally checked using the
[ambient guide](../README.md).

The targets are Nos. 1, 3, 4, 7, 8, 34, and 42 in the 156-family numbering.
This document describes the code, its verification requirements, and the
saved constructions. Verification and import are separate stages; their
completion is recorded by the SHA-bound receipts.

| No. | Original input | rank `S,T` | Prescribed `f_T` | Kernel order | Quotient order | Dimension | Required full-group GAP ID |
| ---: | --- | --- | --- | ---: | ---: | ---: | --- |
| 1 | `list_S.txt` #1; builder row 1 | 20, 2 | builder order-six matrix | 29160 | 6 | 0 | order only |
| 3 | `list_S.txt` #2; builder row 3 | 20, 2 | `-Id_T` | 2520 | 2 | 0 | order only |
| 4 | `list_S.txt` #3; builder row 4 | 20, 2 | builder order-four matrix | 1944 | 4 | 0 | order only |
| 7 | `list_S.txt` #5; builder row 7 | 20, 2 | builder order-three matrix | 660 | 3 | 0 | `[1980,57]` |
| 8 | `list_S.txt` #6; builder row 8 | 20, 2 | builder order-six matrix | 360 | 6 | 0 | order only |
| 34 | `oscar/input.jl` case 14 | 18, 4 | `-Id_T` | 36 | 2 | 2 | `[72,40]` |
| 42 | `oscar/input.jl` case 17 | 18, 4 | `Id_T` | 20 | 1 | 2 | `[20,3]` |

The rank-two Gram and action matrices are the original models in
`build_lattice_156.jl`. Only the selected source expression is evaluated.
No conjugacy-class enumeration in `O(T)` is needed: each target has a fixed
prescribed action. The field `order` means quotient order; the actual orders
on `S` and `Lambda0` are recorded separately.

For the first six targets, `run_remaining_classified_ambient.jl` calls the
existing `lattice_data_for_T_action` in `oscar/oscar_script.jl`, with its
primitive-extension, root, and surviving-witness refinement logic unchanged.
No. 42 instead uses finite quadratic gluing: `|A_T|=3|A_S|`, with
`|det S|=500` and `|det T|=1500`. It considers index-three subgroups of `A_T`
anti-isometric to all of `A_S`, constructs the primitive extension, and
uses the identity ambient extra action. All retained witnesses are saved.

The plain-side `O(S)` context is computed once per target. Its orthogonal
and stable-kernel generators are cached as matrices in the `S` lattice
basis, not as serialized homomorphisms. Group-order and group-ID checks
reuse this cache; they do not enumerate `O(S)` again. The original
surviving-witness correction remains unchanged and may compute an embedded
`O(S)` when a correction is necessary. Equal Gram matrices permit direct
cache reuse; another basis requires an explicit checked integral transport.

The saved ambient data include embedded `S,T,P,K` and the compatible extra
action on `Lambda0`. Here the verifier requires `P=T` and `K=S` as primitive
embedded lattices. The kernel generators are saved in the `S` basis; this
does not claim that rank-22 matrices for every full-group generator are
stored.

The classified pairs have one primitive embedding class under the
primitive-embedding classification; none is one of its two
exceptional pairs. Identification uses this mathematical input and an
independently checked stable ambient realization, not the number of raw
witnesses. The stable-fitting refinement criterion applies to the generic
index-two rank-18 target No. 34. It is not invoked as a rank-20
identification theorem.

## Run and verify

`run_remaining_classified_ambient.jl` accepts one target number, or that
number followed by `--parse-only` to inspect the selected expression without
loading OSCAR. `run_remaining_classified_guarded.sh` runs one Julia process
at a time, in order `42,34,7,8,4,3,1`, and skips existing saved outputs.
The runner refuses to overwrite a sidecar or staging file. Each target has
a `remaining_classified_NNN_20261004.mrdi` sidecar, a stage-timed `.log`, a
`.console.log`, and a `.status.txt`. Source inputs are checked before
saving, and the staged sidecar is reloaded before promotion.

`verify_remaining_classified_ambient.jl` accepts one target or `all`, followed
optionally by the input catalogue path. It independently selects the
original `S,T,f_T` and checks the eight source inputs, primitive orthogonal
embeddings, gluing index, cubic discriminant form, integral actions and
their actual restrictions, stability, exact orders, `P=T`, `K=S`, dimension,
and short/long roots. Saved kernel generators must be stable and have the
classified kernel order; no new lattice orthogonal-group search is used.
The generated full group must have kernel order times quotient order, and
Nos. 7, 34, and 42 must have the stated GAP IDs. A successful check writes a
`.verified.txt` receipt.

Each source kernel is checked once. Output records reuse this check only
after their Gram matrix and generators have been shown to be identical.
Group orders and IDs are computed after reduction modulo 5. This does not
weaken the check: integral isometries of a positive-definite Gram matrix form
a finite group, and the principal congruence kernel of `GL(r,Z)` modulo an
odd prime is torsion-free. The reduction is therefore faithful. It avoids
the rational matrix-group conversion that verifies a finite presentation
by substituting its relators back into rational matrices.

For completeness, suppose a nonidentity finite-order matrix is congruent
to the identity modulo 5. Take a nonidentity power of prime order `ell`,
and write it as `Id + 5^s B`, where `s>=1` and `B` is nonzero modulo 5.
Expanding its `ell`-th power gives a nonzero leading term modulo `5^(s+1)`
if `ell!=5`, and modulo `5^(s+2)` if `ell=5`, a contradiction.

Root tests use the prescribed `S` basis after the equality `K=S` has been
checked inside the ambient lattice. The pairing matrix with `Lambda0` is
computed once; short-vector divisibilities are then tested over the
integers. Each embedding still receives its own long-root divisibility
check, since divisibility depends on the ambient gluing, not just the
abstract Gram matrix.

`merge_remaining_classified_ambient.jl` requires input and fresh output
catalogue paths and all seven matching receipts. It imports `saved_result`,
`T_in_ambient`, and `T_extra_action`, preserving every retained candidate
when several exist. Independent reload and the existing `cm_same` comparison
check the imported coordinate models and leave the other 149 rows unchanged.
The merger checks a staging file before promotion and never overwrites the
input or an existing output. `resume_classified_completion_guarded.sh`
connects construction, verification, and this side-by-side merge after the
earlier classified assignments and normalization.

## Compilation and resource guard

The configured WSL environment is Julia 1.10.11 with OSCAR 1.8.2. Use
`--startup-file=no --compile=yes -O2`; the earlier `--compile=min -O0`
startup workaround substantially slows lattice hot loops. The guarded
scripts set `JULIA_NUM_THREADS=1`, `OPENBLAS_NUM_THREADS=1`, and
`JULIA_NUM_PRECOMPILE_TASKS=1`. Do not run targets or heavy verification jobs
in parallel. Run the shell entry point inside the supervised systemd cgroup
with `MemoryHigh=4 GiB`, `MemoryMax=6 GiB`, and `MemorySwapMax=0`; these limits
are supplied by the external launcher, not by the shell script itself.
No mathematical runtime limit is imposed. Keep all recorded source
files unchanged while a target is running; progress and completion must be
read from its log, status file, and verification receipt.

## Saved constructions

All seven constructions completed on 4 October 2026 and passed their
staged save/reload checks. They subsequently passed the independent
verifier and were imported into
`../lattice_156_complete_ambient_20261004.mrdi`; its reload comparison
preserved the other 149 rows. These counts describe saved witnesses,
not a new uniqueness proof. The SHA-bound receipts document the checks.

| No. | Saved witnesses | Full group order | Total measured seconds |
| ---: | ---: | ---: | ---: |
| 1 | 1 | 174960 | 182.18 |
| 3 | 1 | 5040 | 168.50 |
| 4 | 1 | 7776 | 173.38 |
| 7 | 1 | 1980 | 165.32 |
| 8 | 1 | 2160 | 162.60 |
| 34 | 1 | 72 | 159.70 |
| 42 | 1 | 20 | 101.70 |

The totals include source loading, first-call compilation, construction,
group checks, and save/reload. They are not pure mathematical search times.
The external systemd startup is also outside the runner's measured total.
