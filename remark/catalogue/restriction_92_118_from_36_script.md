# Nos. 92 and 118 inside the No. 36 lattice action

This is a staged, parent-specific computation. It does not independently
enumerate all integral actions of either child group and does not assert
global integral uniqueness. All outputs are new files; the existing
156-row catalogue and original OSCAR MRDI are unchanged.

## Parent and geometric evidence

The numbered No. 36 family has symplectic part `S_3,3` of order 36,
generic index 6, dimension 1, and projective full group `[216,170]`.
It is OSCAR case 15, **result 2**. The other case-15 output has full group
`[216,157]` and belongs to No. 38. These outputs share the generic
`S_3,3` input, but must not be interchanged merely because of that shared
input. `prepare_no36_full_lattice_group.jl` reconstructs the stable kernel
afresh from No. 36's embedded rank-18 lattice, extends its generators to
the rank-22 ambient lattice, and independently verifies the order-216
extension and its `[216,170]` GAP ID. It does not copy No. 38 matrices.

The checked cross-dimensional relation contains direct strict GL(6)
inclusions `92 -> 36`, `118 -> 36`, and `118 -> 38`. It records
`92 -> 38` as `no_embedding` by its necessary fingerprint filter.
The accompanying GAP script verifies the three positive conjugating
matrices on the actual linear groups and computes complete primitive-H4
projective characters:

| Child | Full projective group | `(projective order, primitive trace): count` |
| --- | --- | --- |
| 92 | `[36,12]` | `(1,22):1`, `(2,-10):4`, `(2,6):3`, `(3,-2):6`, `(3,4):2`, `(6,-4):4`, `(6,0):6`, `(6,2):10` |
| 118 | `[18,3]` | `(1,22):1`, `(2,-10):3`, `(3,-2):6`, `(3,4):2`, `(6,2):6` |

The direct inclusions supply a special cubic in each child's connected
smooth invariant family. Restricting the parent H4 action therefore gives
the child's action along that family. This does not determine which
candidate subgroup class is geometric unless the exact character, lattice,
and smoothness checks identify it.

## Finite enumeration and lattice checks

`restriction_92_118_from_36.jl` has four stages. Its finite group is the
36-element stable kernel `N` plus six formal cosets of the saved extra
generator `f`, with `f^6` retained inside `N`. For No. 92 it enumerates
every `S3` subgroup of `N`; for No. 118 every `C3` subgroup. In each case
it tries all lifts `n f`, keeps precisely the lifts whose sixth power lies
in the kernel subgroup and which normalize it, and deduplicates the
resulting full subgroups under conjugation by the complete parent. This is
exhaustive for subgroups projecting onto the parent quotient `C6`: every
such subgroup contains a lift whose quotient exponent is one. The abstract
group ID is computed from the exact finite multiplication table. **No
abstract-ID or trace filter is applied before the full candidate list is
enumerated.**

The next stage compares the full `(order, trace)` histogram with the GAP
geometric character. It then computes the embedded `S`, `T`, `P`, and `K`
lattices for each match, verifies ranks, signatures, index 6, and period
dimension. The final stage reloads and rechecks the subgroup data and
embedded lattices and tests roots of `K` in the saved cubic-fourfold
lattice. It retains every root-free candidate and every obstruction. If
more than one candidate remains, the numbered row is **not** assigned by
an arbitrary choice of subgroup or by its abstract group ID alone.

The completed run has the following parent-specific results:

| Child | Raw subgroups | Parent-conjugacy classes | Exact-character class | `(rank S,rank P,dimension)` | Root-free classes |
| --- | ---: | ---: | ---: | --- | ---: |
| 92 | 30 | 11 | 10 | `(14,6,2)` | 1 |
| 118 | 36 | 15 | 9 | `(12,8,3)` | 1 |

In each row the one exact-character class is also the sole lattice-compatible,
root-free class. This identifies the action **within the verified No. 36
parent**. It is not a new global integral-action classification.

## Commands and output

Run from `remark/catalogue` in the tested WSL OSCAR
environment. The GAP stage and No. 36 cache need be made only once:

```text
gap -q -b < restriction_92_118_geometric_characters.g
julia --startup-file=no -O1 --project=/path/to/oscar-environment prepare_no36_full_lattice_group.jl source-check
julia --startup-file=no -O1 --project=/path/to/oscar-environment prepare_no36_full_lattice_group.jl prepare
julia --startup-file=no -O1 --project=/path/to/oscar-environment prepare_no36_full_lattice_group.jl verify-cache
julia --startup-file=no -O1 --project=/path/to/oscar-environment restriction_92_118_from_36.jl preflight
julia --startup-file=no -O1 --project=/path/to/oscar-environment restriction_92_118_from_36.jl groups
julia --startup-file=no -O1 --project=/path/to/oscar-environment restriction_92_118_from_36.jl lattices
julia --startup-file=no -O1 --project=/path/to/oscar-environment restriction_92_118_from_36.jl verify
```

Each stage refuses to overwrite its default MRDI. The final output is
`restriction_92_118_from_36.verified.mrdi`; the intermediate `.groups.mrdi`
and `.lattices.mrdi` preserve all candidates and failed checks. Source
checks tie the stages to the exact geometric-character file, No. 36 cache,
and scripts. The No. 36 route is the economical first choice because it
covers **both** outstanding rows with one prepared parent. A separate
No. 38 cache would be useful only if the No. 118 No. 36 restriction remains
ambiguous or needs an independent cross-check.
