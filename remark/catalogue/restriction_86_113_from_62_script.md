# Nos. 86 and 113 as restrictions of No. 62

This is a separate, staged computation inside the saved full No. 62 action. It does not copy No. 60's 22-dimensional generators. The No. 62 cache is independently reconstructed in `prepare_no62_full_lattice_group.jl` from OSCAR case 24, saved result 4, and verified before any subgroup search.

## Frozen geometric inputs

`restriction_86_113_geometric_characters.g` reads the numbered linear groups and the direct strict linear-conjugacy witnesses from the classification output. It checks their actual matrix images inside No. 62 and writes the complete projective primitive-\(H^4\) characters to `restriction_86_113_geometric_characters.tsv`. Here the trace of a cubic-fourfold automorphism with linear eigenvalue multiplicities \(m_1,m_\omega,m_{\omega^2}\) is \(\bigl((-2)^{m_1}+(-2)^{m_\omega}+(-2)^{m_{\omega^2}}\bigr)/3\). The scalar lift does not affect the result; this is checked for every element. The GAP script refuses to overwrite its TSV. `restriction_86_113_embedding_audit.g` separately checks the projective quotient and determinant-one symplectic kernel of each strict image and writes no files.

The abstract data are No. 62: \([72,30]\), symplectic part \(D_{12}\), index 6; No. 86: \([18,3]\), symplectic part \(S_3\), index 3, dimension 3; and No. 113: \([18,5]\), symplectic part \(C_3\), index 6, dimension 2. The No. 86 and No. 113 projective groups both have order 18 but are not isomorphic.

## Exhaustive finite-group stage

`restriction_86_113_from_62.jl` constructs all 72 No. 62 elements as \(n f^k\), where \(n\) lies in the order-12 symplectic kernel and \(0\leq k<6\). It checks the rank-16 and rank-22 extension relations and the abstract group ID; the multiplication table follows exactly from these relations. No ambient orthogonal group or large matrix-group subgroup search is used.

For No. 86, any desired subgroup \(B\) meets the kernel in an \(S_3\) subgroup \(A\) and has image the unique order-3 subgroup of \(C_6\). Thus \(B=\langle A,nf^2\rangle\) for some \(n\) in the kernel. For No. 113, \(A=B\cap N\cong C_3\), the quotient image is all \(C_6\), and \(B=\langle A,nf\rangle\). The script enumerates every such \(A\) and every \(n\), checks exact closure and \(B\cap N=A\), and then takes conjugacy orbits under the *full* No. 62 group. It retains all structural classes, including those of a different abstract isomorphism type or character. Abstract ID plus every element's pair `(projective order, primitive H4 trace)` identifies matching candidates. This proves completeness **within the saved No. 62 parent action**, not global uniqueness of either family.

The `lattices` stage computes the symplectic coinvariant and invariant lattices, the extra action on \(T\), period/complement ranks and signatures, and the expected period dimension for *every* character-matching class. The `verify` stage recomputes subgroup and lattice data from the saved inputs, checks roots in the complement, and records all root-free candidates. Neither stage silently chooses one candidate or asserts saturation.

## Running

Run from `remark/catalogue` after the No. 62 cache exists. Use the project environment containing OSCAR 1.8.2. In GAP, run the geometric-character script once if its TSV is absent; the embedding audit is read-only. In Julia, run the following stages in order, one process at a time:

```text
julia --startup-file=no -O1 --project=PATH_TO_OSCAR_PROJECT restriction_86_113_from_62.jl preflight
julia --startup-file=no -O1 --project=PATH_TO_OSCAR_PROJECT restriction_86_113_from_62.jl groups
julia --startup-file=no -O1 --project=PATH_TO_OSCAR_PROJECT restriction_86_113_from_62.jl lattices
julia --startup-file=no -O1 --project=PATH_TO_OSCAR_PROJECT restriction_86_113_from_62.jl verify
```

Each stage refuses to overwrite its `.mrdi` output. Source and preceding-stage inputs are checked at the next stage. The generated files are `restriction_86_113_from_62.groups.mrdi`, `.lattices.mrdi`, and `.verified.mrdi`, respectively. Until the final stage passes, a character match is only a candidate, not a verified lattice action.

## Verified 2026-10-04 run

The finite-group stage found two raw eligible subgroups for each target and one No. 62-conjugacy class in each case. That class has the required abstract group and full geometric character. Both lattice matches passed the root check. No. 86 has \(\operatorname{rk}S=14\), \(\operatorname{rk}T=8\), \(\operatorname{rk}P=8\), and dimension 3 at index 3. No. 113 has \(\operatorname{rk}S=12\), \(\operatorname{rk}T=10\), \(\operatorname{rk}P=6\), and dimension 2 at index 6. The results are unique among eligible subgroups of this verified parent action; this statement does not claim global integral uniqueness or independent saturation.
