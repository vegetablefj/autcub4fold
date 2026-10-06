# No. 104 as a restriction of No. 28

The numbered catalogue assigns OSCAR case 10, result 1 to No. 28. Its
saved record has index six, dimension one, projective group `[432,745]`,
an embedded rank-18 symplectic coinvariant lattice `S`, an embedded rank-4
period lattice `T`, and one rank-22 extra isometry. It does **not** save
generators for the entire No. 28 group. No. 104 has rank `S=12`, index six,
dimension two, projective group `[24,13]`, and symplectic part `C2^2`.

The existing complete fourfold containment calculation records a **direct**
strict linear-conjugacy witness `104 -> 28` (linear orders 72 and 1296;
`gap_fourfold_cross_dimension_all_pairs.tsv`, row `104 28`). The independent
`restriction_104_geometric_character.g` loads the frozen 156-group file and
the saved direct witness, rechecks its six-dimensional conjugation exactly,
and computes the No. 104 projective primitive-`H^4` character from the
equivariant Jacobian ring. Its sorted `(element order, trace, count)` data
are `(1,22,1)`, `(2,-10,1)`, `(2,-2,3)`, `(2,6,3)`, `(3,-2,8)`, and
`(6,2,8)`, saved in `restriction_104_geometric_character.tsv`. This
distinguishes No. 104 from the other `[24,13]` family No. 105; abstract
group ID and index alone do not.

`prepare_no28_full_lattice_group.jl` is the separate OSCAR cache builder.
It is modelled on the verified No. 60 preparation and has three stages:

- `source-check` checks the frozen source, case 10/result 1 metadata,
  the signatures and ranks of `S`, `T`, and `Lambda0`, and compatibility of
  the saved extra action on the embedded lattices. It does not compute `O(S)`.
- `prepare` computes the stable discriminant kernel of `O(S)`, **asserts**
  that its order is 72, extends each kernel generator over `Lambda0` while
  fixing `T`, and checks the quotient-six relation. It checks all 432
  distinct 22-dimensional matrices and the conjugation relations before
  writing a new `source_28_full_lattice_group.mrdi` file. It refuses to
  overwrite an existing file.
- `verify-cache` reloads the cache and repeats the source, matrix, and
  order checks without recomputing `O(S)`.

The three cache stages completed on 2026-10-04 under OSCAR 1.8.2. The
stable kernel has order 72; all 39 computed generators extended to
`Lambda0`, and the 432 ambient matrices were checked to be distinct. The
cache `source_28_full_lattice_group.mrdi` was independently reloaded.
See `prepare_no28_full_lattice_group.md` for the environment and cache
provenance. Rebuilding `O(S)` is comparatively expensive; the No. 104
restriction stages only reverify and read this cache.

The restriction script builds the finite group as
`G = {n f^k : n in N, 0 <= k < 6}`, where `N` is the verified order-72
stable kernel and `f` is the saved extra action. Enumerate **all**
four-element `V4` subgroups `A` of `N`. For each `A`, test every `n f^k`
with `n in N` and `k=1` or `5`. Keep it when it normalizes `A` and its
sixth power lies in `A`; then `H=<A,n f^k>` has order 24, projects onto
the quotient `C6`, and has `H intersect N=A`. Verify that its abstract
group is `[24,13]`, deduplicate the resulting subgroups, and take
conjugacy orbits under the **full** group `G`. This enumerates exactly the
possible restrictions with the prescribed symplectic kernel and index;
no prior uniqueness assumption is used. Multiplication and conjugation
are obtained from the order-72 kernel and its six formal cosets, rather
than a generic subgroup enumeration of 432-dimensional permutation or
rank-22 matrix representations. The `k=5` pass cross-checks the complete
`k=1` candidate set.

For every orbit, compare the full projective `(order, trace)` histogram of
the saved ambient action with the independent No. 104 character above.
Only then compute its embedded `S`, `T`, the extra action, lattice root
conditions, and the retained ambient record. The direct linear witness
guarantees that a geometric inclusion exists, but it does **not** assert
that the character filter leaves a unique integral subgroup orbit. If
several survive, keep them all until an additional geometric or lattice
identification is proved.

## Completed staged calculation

`restriction_104_from_28.jl` has `preflight`, `groups`, `lattices`, and
`verify` stages. All four completed successfully. The finite search found
10 distinct `V4` subgroups of `N`, 36 distinct candidate subgroups of
order 24, and six conjugacy classes in the full No. 28 group. Exactly one
class, numbered 5 with conjugacy orbit size 6, has both abstract group
ID `[24,13]` and the full geometric character above. It yields
`rank(S)=12`, `rank(T)=10`, `rank(P)=6`, `rank(K)=16`, index six, and
period dimension two. The separate final stage rechecked the group and
embedded lattices, found no root obstruction, and saved the root-free
record in `restriction_104_from_28.verified.mrdi`. The two earlier stage
files are `restriction_104_from_28.groups.mrdi` and
`restriction_104_from_28.lattices.mrdi`.

Run the stages separately from this directory, with the OSCAR 1.8.2
project active:

```text
julia --startup-file=no -O1 --project=/path/to/oscar-environment restriction_104_from_28.jl preflight
julia --startup-file=no -O1 --project=/path/to/oscar-environment restriction_104_from_28.jl groups
julia --startup-file=no -O1 --project=/path/to/oscar-environment restriction_104_from_28.jl lattices
julia --startup-file=no -O1 --project=/path/to/oscar-environment restriction_104_from_28.jl verify
```

Each stage refuses to overwrite an existing result. The calculation is
complete **within the saved No. 28 lattice action**. It does not separately
prove global integral uniqueness or symplectic saturation for No. 104;
those conclusions are not encoded in the saved record.
