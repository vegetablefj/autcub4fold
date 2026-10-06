# Same-symplectic-part `S3` restrictions

The calculation for Nos. 88, 89, 90, 91, and 93 completed successfully
on 2026-10-04. It reads the already assigned integral actions of Nos. 94 and 95
and the No. 96 action with its independently cached order-six symplectic
kernel. No stage changes a numbered catalogue or any parent output.

| Child | Primary parent | Parent quotient order | Child index | Extra action to restrict | Additional parent check |
| ---: | ---: | ---: | ---: | --- | ---: |
| 88 | 94 | 12 | 2 | `f_94^6` | 95, using `f_95^6` |
| 89 | 94 | 12 | 4 | `f_94^3` | 95, using `f_95^3` |
| 90 | 94 | 12 | 6 | `f_94^2` | — |
| 91 | 95 | 12 | 6 | `f_95^2` | — |
| 93 | 96 | 24 | 8 | `f_96^3` | — |

Here the **full** group, not merely its extra cyclic generator, is
restricted. Write the parent group as `H = <N,f>`, where `N ≅ S3` is the
full symplectic subgroup and `H/N ≅ C_m`. A child with the same
symplectic part `N` and index `i` must be the inverse image of the
unique order-`i` subgroup of `C_m`. Therefore it is exactly
`<N,f^(m/i)>`. This is why the finite subgroup selection requires no
search over embeddings; the scripts still verify the quotient order,
subgroup closure, abstract SmallGroup ID, and exact primitive-
cohomology character. The listed strict linear-containment edges are
checked independently against the frozen six-dimensional matrices and
their saved conjugators. Nos. 88 and 89 have more than one available
parent. The No. 94 and No. 95 paths are retained as a cross-check. A
subsequent literal comparison in their common ambient lattice found the
same full subgroup, embedded `S,T,P,K` bases, `T` Gram matrix, and extra
`T`-action matrix for both No. 88 and No. 89; they are not merely equal by
character. Additional direct edges into
No. 96 for Nos. 88, 89, and 90 are not part of this short run.

The geometric symplectic character is preserved by linear conjugacy.
Under each checked strict edge, the child symplectic subgroup maps
into the parent `N`. Both have order six, so its image is all of `N`.
The child full group has order `6i`, hence is the full inverse image
of the unique order-`i` subgroup in the parent's cyclic quotient.
Thus the power-preimage is not merely one plausible embedding.

The `groups` stage builds the exact finite parent multiplication table
from the saved order-six kernel and extra generator, then takes the
unique preimage above. It computes the subgroup ID and the complete
histogram of `(projective order, primitive-H^4 trace)`. The `lattices`
stage computes the embedded `S,T,P,K` and the restricted `T` action;
all seven checked paths have `rank(P)=8` and `rank(K)=14`.
The `verify` stage rebuilds the finite subgroup and lattice record and
tests the root obstruction. The separate geometric character file is
produced from the frozen linear groups by the standard cubic-fourfold
trace formula. A character match is necessary to assign the geometric
family; neither character equality alone nor a bare power of `f`
substitutes for the strict containment and full-kernel checks.
The extracted subgroup ID is stored separately from `group_gap_id`:
the latter remains unassigned because this run does not independently
recompute the entire discriminant-kernel extension on the child lattice.

Run sequentially, from `remark/catalogue`, with
the project OSCAR environment and one Julia thread:

```text
GAP:   Read("restriction_same_s3_geometric_characters.g");
Julia: restriction_same_s3_from_94_95_96.jl preflight
Julia: restriction_same_s3_from_94_95_96.jl groups
Julia: restriction_same_s3_from_94_95_96.jl lattices
Julia: restriction_same_s3_from_94_95_96.jl verify
```

All four Julia stages exited successfully. All seven listed paths passed
the exact projective-character test. Their period dimensions were
respectively 6 for No. 88; 3 for Nos. 89, 90, and 91; and 1 for No. 93.
The `verify` stage independently rebuilt every exact subgroup and
embedded lattice and confirmed that all seven complements are root-free.
The reloaded final file reports `verified=7`:
`restriction_same_s3_from_94_95_96.verified.mrdi`.

The Julia stages default to separate `.groups.mrdi`, `.lattices.mrdi`,
and `.verified.mrdi` files with the same script stem. Each refuses to
overwrite an existing output, records its source inputs, and reloads
what it writes. `groups` accepts an alternative output path;
`lattices` accepts output and groups paths; `verify` accepts output,
lattices, and groups paths. Use fresh paths for reruns. The existing
No. 96 kernel cache is an input, not recomputed here.

`compare_same_s3_parent_paths.jl` completed this comparison before the
numbered import. For Nos. 88 and 89, the No. 94 and No. 95 paths have
literally equal full subgroups and complete embedded integral records in
one ambient basis. The catalogue imports the No. 94 path as primary and
retains the No. 95 path as a checked alternative. This script does not
independently recompute
the child's full discriminant kernel or a saturation theorem; it uses
the known same-part parent kernel and the original classification.
