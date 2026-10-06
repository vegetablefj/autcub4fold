# Complete ambient restrictions in ranks 18–15

This is a record of the intermediate restriction stages. Its pending-row
counts below describe the catalogues at those stages, not the current
[156-row standard catalogue](../README.md). The selected sidecar MRDI files
are retained here; the named stage scripts belong to the original
development tree and are not included in this curated directory. Paths and
commands for those scripts below document the historical calculation, not a
runnable workflow from this directory alone.

The independently verified starting point was
`../../lattice_156_with_generic_actions_v3_20261004.mrdi`.
That catalogue has abstract actions on every `T`, but the generic rows below
have no assigned `T_in_ambient` or full `saved_result`. The scripts here build
sidecar records; they never replace the starting catalogue.

The three restriction sidecars and the independent 19-row merge verifier
have now passed. Their side-by-side output is
`lattice_156_with_rank18_15_ambient_20261004.mrdi`.
Only the 19 rows listed below changed; the other 137 v3 rows remain intact.
The catalogue-wide provenance audit is
`../sources/family_156_sources_after_ambient.md`.

Let `N` be the full symplectic subgroup of a saved parent `G`, with cyclic
quotient `G/N = C_m`. The parent record fixes one embedded primitive cubic
lattice `Λ₀`, its primitive sublattices `S` and `T`, and a single ambient
isometry `f` lifting a generator of `G/N`. If a numbered child has the same
symplectic subgroup and quotient order `i | m`, its full group is the inverse
image of the **unique** order-`i` subgroup of `C_m`, namely
`⟨N,f^(m/i)⟩`. This conclusion uses the frozen strict linear containment,
the identified parent action, equality of the symplectic part, and the
specified group orders. The scripts check those inputs and take the power
on the *same* `Λ₀` action. Both the `S` and `T` actions are reconstructed
from that powered ambient isometry, so gluing compatibility is preserved.

For index-one children, the inverse image is `N`. Its quotient generator
is the identity on the parent `Λ₀`, but its embedded `S` and `T` still come
from the parent. This supplies a particular primitive embedding, which an
abstract identity action on `T` alone would not determine.

| Child | Saved full parent | Quotient restriction | Script |
| ---: | ---: | --- | --- |
| 21 | 22 | `f²`, `4 → 2` | `rank18_samepart_powers.jl` |
| 27 | 28 | `f³`, `6 → 2` | `rank18_samepart_powers.jl` |
| 31 | 32 | `f³`, `6 → 2` | `rank18_samepart_powers.jl` |
| 35 | 36 | `f³`, `6 → 2` | `rank18_samepart_powers.jl` |
| 37 | 38 | `f³`, `6 → 2` | `rank18_samepart_powers.jl` |
| 55 | 56 and 57 | `f³`, `6 → 2`; both paths retained | `rank16_samepart_cubes.jl` |
| 63 | 64 | `f³`, `6 → 2` | `rank16_samepart_cubes.jl` |
| 68 | 69 | `f³`, `6 → 2` | `rank16_samepart_cubes.jl` |
| 25 | 26 | identity, `2 → 1` | `generic_identity_from_parents.jl` |
| 29 | 30 | identity, `3 → 1` | `generic_identity_from_parents.jl` |
| 39 | 40 | identity, `2 → 1` | `generic_identity_from_parents.jl` |
| 43 | 44 | identity, `2 → 1` | `generic_identity_from_parents.jl` |
| 45 | 46 | identity, `2 → 1` | `generic_identity_from_parents.jl` |
| 48 | 49 | identity, `2 → 1` | `generic_identity_from_parents.jl` |
| 52 | 53 | identity, `2 → 1` | `generic_identity_from_parents.jl` |
| 58 | 59 | identity, `2 → 1` | `generic_identity_from_parents.jl` |
| 65 | 66 | identity, `2 → 1` | `generic_identity_from_parents.jl` |
| 70 | 71 | identity, `2 → 1` | `generic_identity_from_parents.jl` |
| 73 | 74 | identity, `2 → 1` | `generic_identity_from_parents.jl` |

The parent records above are selected complete results of the frozen OSCAR
29-case search in `../../../../oscar/oscar_script_data.mrdi`, imported and numbered
by `../../build_lattice_156.jl`. No. 56 and No. 57 are separate case-23
outputs, assigned by the complete primitive-coset comparison in
`../../a33_case23/result.md`. The separate No. 36 and No. 38 case-15 outputs
are likewise kept separate: No. 35 uses No. 36, and No. 37 uses No. 38.
The common abstract `T` action of Nos. 35 and 37 does not identify their
primitive embeddings.

Each script has read-only `preflight`, writing `restrict`, and read-only
`verify` stages. The preflight checks the verified catalogue, frozen
numbering, projective group IDs, exact parent and child orders and
dimensions, direct literal containment, parent embedded `S/T/Λ₀`, and
the expected abstract action on `T`. The restriction computes embedded
`S,T,P,K` from one ambient lattice, tests trivial action on its discriminant,
period rank/signature/dimension, and the cubic-fourfold short- and long-root
obstruction. The independent verify stage reloads the sidecar, rebuilds
the actions and embedded bases, and repeats the root test. All stages refuse
to overwrite an output. Run stages sequentially with the configured
Julia/OSCAR 1.8.2 project.

The saved sidecars record the numbered projective ID as an ID inherited from
the strict same-part subgroup; they do not claim to recompute the entire
child discriminant-kernel group or symplectic saturation. They certify a
complete integral ambient representative within each identified saved
parent. No global uniqueness across unrelated ambient parent actions is
claimed. For No. 55 both No. 56 and No. 57 parent paths remain present; a
separate integral comparison is needed before declaring their labelled
matrices equal.

At the stage described here, within the 56 rows numbered 21–76, the
original search already gives 33
complete non-generic ambient records. These scripts target another 19
generic rows. Nos. 33, 34, 42, and 47 still require separate cross-part
work: No. 33 embeds literally in No. 18, No. 47 embeds strictly in No. 28,
while Nos. 34 and 42 need complete containing actions or new extension
calculations. An abstract identity or `−Id` action on `T` alone does not
finish those four rows.

## Cross-part pilot for Nos. 33 and 47

`crosspart_33_47_character.g` first verifies the frozen direct strict
`GL(6)` witnesses `33 → 18` and `47 → 28`, and computes the exact
projective primitive-`H⁴` characters of the *numbered geometric* children.
Run it from `remark/catalogue`; it refuses to overwrite its TSV.
The source families and containment witnesses are frozen in
`../../gap_classification/gap_fourfold_cross_dimension/`. No lattice conclusion
is drawn from a small-group ID by itself. The GAP stage recomputes the
invariant cubic space from the frozen linear generators and substitutes
every generator into every basis cubic to certify exact fixation; it also
checks determinant/Hodge-index sizes. If exact fixation fails, the cubic's
scalar multiplier must be recovered before using the Jacobian character.

`crosspart_33_47_pilot.jl` then reads the two saved complete full-parent
group caches (No. 18: order `216 = 72·3`, No. 28: order `432 = 72·6`).
For No. 33, its index-one group has order 36; the pilot tests **every**
index-two subgroup of the No. 18 symplectic kernel by enumerating the
nonzero homomorphisms `N₇₂ → C₂`. For No. 47, its symplectic part is
`S₄` of order 24; since `S₄` is two-generated, the pilot tests every
two-generated order-24 `S₄` subgroup of the No. 28 kernel, then all 72
lifts in the unique exponent-three coset of the `C₆` quotient. It checks
exact closure, abstract group ID, full-parent conjugacy, and the saved
geometric character. This is an exhaustive finite search **inside those
chosen saved parent actions**, not a search of all integral embeddings.

Each Julia child has separate `preflight`, `groups`, `lattices`, and
`verify` stages; invoke `crosspart_33_47_pilot.jl STAGE 33` or
`crosspart_33_47_pilot.jl STAGE 47`. The lattice stage recomputes the
new symplectic invariant lattice `T`, its orthogonal `S`, and the same
ambient lift on `Λ₀`; it does not reuse the parent's `S/T`. It checks the
v3 abstract `S/T` genera and discriminant forms, exact integral isometry
of the rank-four/five `T`, numbered abstract-action target, period and
complement, then the verify
stage rebuilds those data and tests roots. Sidecars retain all candidate
classes. Even a unique character/root match is labelled a *candidate*
until the geometric subgroup assignment to the saved integral parent is
audited; every sidecar says `numbered_assignment_claimed=false` and nothing
is merged automatically. No independent symplectic-saturation or global
uniqueness claim is made. For the rank-17/18 positive-definite `S`, an
unequal Gram matrix is not subjected to a potentially expensive global
integral-isometry search in this pilot; only equality of genus and
discriminant form is asserted unless the Gram matrices agree exactly.

The GAP calculation passed under a 2 GiB cap and saved
`crosspart_33_47_character.tsv`.
The No. 33 `(order, trace):count` bins are
`(1,22):1, (2,6):9, (3,4):8, (4,2):18`; No. 47 has
`(1,22):1, (2,-10):7, (2,-2):3, (2,6):9, (3,4):8,
(4,-2):6, (4,2):6, (6,-4):8`. Both sum to their numbered projective
orders. The Julia
`groups` stage is a finite search in groups of order at most 432 and uses
the existing full-group caches; it does not recompute an automorphism group
of a lattice. The `lattices` and `verify` stages can invoke expensive exact
lattice and root calculations and should be run one child at a time under
the same 6 GiB memory cap used for the parent-cache checks. All four stages
have now passed for each of Nos. 33 and 47. In each case there is exactly
one full-parent conjugacy class matching the geometric character, one
abstract-lattice-compatible candidate, and one independently rebuilt,
root-free ambient candidate. The sidecars are `crosspart_33.groups.mrdi`,
`crosspart_33.lattices.mrdi`, `crosspart_33.verified.mrdi` and the analogous
three files for No. 47. These are **not yet numbered assignments**. Separate
exact positive-definite tests in `crosspart_33.exact_S_isometry.mrdi` and
`crosspart_47.exact_S_isometry.mrdi` now prove that both candidate `S`
lattices are integrally isometric to their numbered abstract inputs;
their displayed Gram matrices were unequal. The remaining issue is to
identify the geometric subgroup inside the selected integral parent
representation, rather than infer that from a character match alone.

The later `certify_crosspart_33_47.jl` closes this parent-relative gap:
the saved finite searches have three eligible subgroups for each child,
but **one** full-parent conjugacy class in each case. Thus any strict
geometric embedding with the verified symplectic intersection and quotient
has the same restriction in the already identified parent action. The
certificate combines this exhaustive class result with exact `S/T`
isometry and root-free ambient restrictions. `merge_crosspart_33_47.jl`
imports them into a new side-by-side 156-row catalogue. This conclusion
is relative to the previously identified parent actions, not a global
enumeration of unrelated lattice representations.

## Historical abstract-only dependency audit

After the rank-19 index-one sidecars and No. 2's unique primitive orbit
are merged, and with Nos. 33/47 certified relative to their identified
full parents,
the 11 rows that then had only abstract `T` actions were
`1, 3, 4, 7, 8, 9, 11, 16, 19, 34, 42`. The arrows below are
*strict geometric containment* edges from the frozen GAP cross-dimension
table, not assertions that an integral `Λ₀` restriction has been made.

| Rows | Geometric route | Present integral dependency |
| --- | --- | --- |
| 1, 3, 4, 7, 8 | Rank-20 source families | No saved complete full-group `Λ₀` action. No. 2 now has a unique primitive `S/T` orbit and compatible identity extra action, but not all symplectic `A_7` matrices. |
| 9, 11, 16, 19 | `9 → 1,4`; `11 → 1,3`; `16 → 3,8`; `19 → 1` | Each containing rank-20 row still lacks a complete full-group ambient action; the abstract `−I_T` of the child is not an ambient lift. |
| 33, 47 | `33 → 18`; `47 → 28` | The parent-relative unique-subgroup certificates and exact `S/T` isometries are now saved; the two restrictions are imported into the latest side-by-side catalogue. |
| 34 | `34 → 19,11,9` directly; also `34 → 3,4,1` transitively | None of these parents has a saved complete full-group ambient action. The checked edges `34 → 18,28` are negative. A future full No. 19, 11, or 9 could avoid a fresh child gluing, but requires exact subgroup transport. |
| 42 | `42 → 15,16,5,6` directly; also `42 → 8,2,3` transitively | Nos. 15 and 5/6 have primitive embeddings or an identity extra action, **not** saved matrices for their full symplectic group on `Λ₀`; the other parents remain abstract. Thus no existing complete parent action can currently be restricted. |

In particular, No. 33 is not an ambient shortcut to No. 34 merely because
their input coinvariant `S` Gram matrices agree: their respective
rank-four `T` determinants are `972` (input case 13) and `108` (case 14).
For a *fixed primitive copy* of `S` in `Λ₀`, the orthogonal complement is
fixed, so the No. 33 embedding cannot simply be relabelled as No. 34.
One could instead construct a suitable new embedding and compatible
index-two ambient extension, or first complete a geometrically containing
parent such as No. 19 and restrict its whole group. Likewise, the existing
No. 15 or M10 gluings offer possible starting embeddings for No. 42 only
after their full symplectic ambient actions and the numbered geometric
subgroup transport have been supplied; gluing alone does not determine `S`
or `T` for the child.
