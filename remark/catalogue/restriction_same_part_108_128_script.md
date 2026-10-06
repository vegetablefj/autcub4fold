# Same-symplectic-part restrictions: Nos. 108 and 128

This staged calculation takes No. 108 from the verified No. 113 integral
action, and No. 128 from the verified No. 131 integral action. It leaves the
156-row catalogue untouched. It does not enumerate isometry classes.

The parents have projective groups of orders 18 and 24, respectively, with
symplectic parts $C_3$ and $C_2$. Their quotients by these parts are
$C_6$ and $C_{12}$. The desired children have the same symplectic parts
and quotient orders 2 and 6. In a cyclic quotient, there is exactly one
subgroup of the specified order; hence each child is its full preimage.
The frozen six-coordinate groups verify this directly: the No. 113 extra
generator cubed, together with its symplectic generator and scalar, generates
exactly No. 108; the No. 131 extra generator squared generates exactly
No. 128 in the same way. For No. 128, the frozen displayed generator is the
inverse of that square modulo the common symplectic part, but it generates
the same subgroup. The GAP script also checks the actual direct literal
containment witnesses, abstract IDs, quotient-preimage uniqueness, and every
bin of the primitive $H^4$ character. It does **not** infer a restriction
merely from divisibility of group orders.

The GAP audit completed successfully. For No. 108 the `(order, trace): count`
bins are `(1,22):1`, `(2,-10):1`, `(3,4):2`, `(6,2):2`. For No. 128 they are
`(1,22):1`, `(2,-10):2`, `(2,6):1`, `(3,-2):2`, `(6,-4):2`, `(6,0):2`,
`(6,2):2`. These are exact projective characters, not sampled traces.

On the saved integral lattice, the Julia script raises the extra generator
to the corresponding power and retains the same symplectic generator. It
checks the parent and child finite matrix groups, exact primitive character,
unchanged embedded $S,T$, the powered action on $T$, full integral
$S,T,P,K\subset\Lambda_0$, index, period dimension, discriminant action,
and root-freeness. Its `verify` stage independently reconstructs both
results. The subgroup argument proves completeness within the two verified
parent actions. No fresh global integral uniqueness or symplectic saturation
claim is made here.

From `remark/catalogue`, run the light GAP audit first:

```text
gap -q -b < restriction_same_part_108_128_geometric.g
```

Then use the established OSCAR project environment:

```text
julia --project=<OSCAR project> restriction_same_part_108_128.jl preflight
julia --project=<OSCAR project> restriction_same_part_108_128.jl restrict
julia --project=<OSCAR project> restriction_same_part_108_128.jl verify
```

The latter two stages write
`restriction_same_part_108_128.restricted.mrdi` and
`restriction_same_part_108_128.verified.mrdi`. Each refuses to overwrite an
existing file, records its source inputs, and reloads its saved output. Optional
output filenames can be passed after `restrict` or `verify`. Both numbered
rows should be added to the catalogue only after the verified file exists.

The three Julia stages have now completed successfully. The verified MRDI
reload gives the following embedded ranks and period data:

| No. | Parent | $\operatorname{rk}S$ | $\operatorname{rk}T$ | $\operatorname{rk}P$ | $\operatorname{rk}K$ | Index | Dimension | Roots in $K$ |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | :--- |
| 108 | 113 | 12 | 10 | 6 | 16 | 2 | 4 | none |
| 128 | 131 | 8 | 14 | 8 | 14 | 6 | 3 | none |

Both saved paths have unchanged embedded $S,T$, exact powered actions on
$T$, and full-group IDs `[6,2]` and `[12,5]` from the geometric subgroup
check. The saved results do not assert an independent symplectic-saturation
test.

The current `assembly/manifest.jl` selects the two saved paths, and the
direct-source structural check covers both numbered rows.
