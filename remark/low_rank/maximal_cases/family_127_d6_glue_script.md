# No. 127: D6(2) gluing probes

This note records early OSCAR 1.8.2 tests for a commuting involution
alongside the saved order-four Eckardt action. They are experiments, not an
identification of the integral action for No. 127. The exploratory programs
named below are not included in this release; the selected construction and
checks are in `family_127_g13_full_l_postcheck.md`.

The saved Eckardt construction glues an $E_6(2)$ lattice (rank 6,
discriminant 192) to $N=U^2\oplus D_4^3$ (rank 16, signature $(14,2)$,
discriminant 64) with index 64 to obtain the cubic-fourfold primitive
cohomology lattice. The chosen involution on $E_6(2)$ has a rank-two
anti-invariant part. The D6 probes seek a rank-six $D_6(2)$ anti-invariant
part inside $N$. Even if both pieces exist, integrality and commutation
must hold across the **full** ambient glue, and the resulting involution's
coinvariant lattice must actually be $E_8(2)$.

For the targeted rank-16 construction, $M=D_6(2)$ has discriminant 256
and the proposed fixed complement $K=U^2\oplus D_6(2)$ has rank 10,
signature $(8,2)$, and discriminant 256. An overlattice in the genus of
$N$ requires glue index $\sqrt{256\cdot256/64}=32$.
As primitive eigensublattices of an integral involution, $M$ and $K$ have
glue given by the graph of an isomorphism between subgroups of their
discriminant groups. Stability under $(-I_M,+I_K)$ and injectivity of both
graph projections force every glued element to be $2$-torsion. Thus the
index-32 graph uses five-dimensional subspaces of the six-dimensional
$2$-torsion modules. The target discriminant group has exponent $2$, which
further forces these subspaces to contain the doubles of the order-four
discriminant elements; only three invariant hyperplanes satisfy that
necessary condition on each side.

More generally, if $|\operatorname{disc} K|=2^k$ and the glued lattice is
the target $N$, the graph has dimension $(k+2)/2$. Since the target
discriminant group has exponent $2$, the graph must contain the doubles
of all discriminant elements. Nondegeneracy of the discriminant pairings
then identifies $2A_M$ with $2A_K$. Here
$A_M\simeq(\mathbb Z/4)^2\oplus(\mathbb Z/2)^4$, so $A_K$ must have
exactly two order-four factors and no higher-order factors. Comparing
the graph dimension with the dimensions of $A_M[2]$ and $A_K[2]$ leaves
only $k=6,8,10$, i.e. $|\operatorname{disc} K|=64,256,1024$.

There is a sharper constraint for this particular family. In the displayed
coordinates, $q=hs$ has three negative eigenvalues, hence is Marquand's
type $\phi_3$ involution. [Marquand, Proposition 2.12(3), Theorem 1.1(3),
and Lemma 5.13](https://arxiv.org/pdf/2202.13213) give its anti-invariant lattice
$Q=L^{-q}\simeq U\oplus A_1\oplus A_1(-1)\oplus E_8(2)$, of determinant
$2^{10}$ and with exponent-two discriminant group. Her statement is for
the general smooth member; the eigenspace-lattice type persists for this
special smooth member because the smooth locus of the fixed linear system
is connected. Inside $Q$, the primitive orthogonal eigensublattices of
$h$ are $A=E^{-s}\simeq\langle4\rangle^2$ and $K=N^s$. Their glue is a
graph of $2$-torsion subgroups. Since $A_Q$ has exponent $2$, the
projection of the glue to $A_A\simeq(\mathbb Z/4)^2$ must contain
$2A_A$. But it lies in $A_A[2]=2A_A$, so this projection is exactly
$2A_A$ and the glue index is $4$. The determinant formula therefore
forces $|\operatorname{disc} K|=2^{10}$, eliminating the determinant-64
and determinant-256 possibilities above. The same argument gives
$A_K\simeq(\mathbb Z/4)^2\oplus(\mathbb Z/2)^6$; it does not yet identify
$K$ as an integral lattice or its order-four action.
In particular, its discriminant group needs eight generators. Thus $K$
cannot split off $U^2$: the remaining rank-six lattice would have the
same discriminant group, which cannot need more than six generators.
This rules out a construction in which $s$ fixes the entire displayed
$U^2$ summand of $N=U^2\oplus D_4^3$.

| Script and recorded run | Result and exact scope |
| --- | --- |
| `run_family_127_plane_probe.jl`; `family_127_plane_probe.log` | **Completed.** In the $A$-fixed rank-two sublattice of the saved $E_6(2)$ block, Gram matrix $\begin{psmallmatrix}8&-4\\-4&8\end{psmallmatrix}$, it found six norm-24, divisibility-3 plane-class candidates; two are fixed by the chosen $E_6$ involution. This passes a necessary fixed-class check for that seed, not a geometric realization or full-lattice involution check. |
| `run_family_127_d6_embedding_probe.jl`; `family_127_d6_embedding_probe_r2.log` | **Completed for the first primitive embedding only.** An embedding of $D_6(2)$ into a lattice in the genus of $N$ exists. Its orthogonal complement has rank 10, signature $(8,2)$, and discriminant 1024; the glue index is 64. The sign involution on this one embedding is an isometry of order two over $\mathbb Q$ but is **not integral**. The search imposed no order-four action, so this does not exclude other embeddings or the targeted index-32 construction. |
| `run_family_127_d6_equivariant_probe.jl`; `family_127_d6_equivariant_preflight_manual.log` | **Preflight completed.** The explicit order-four actions on $M$ and $K$ square to $-I$ and the target determinant is 64. The `glue-first` run requested one equivariant index-32 extension with the target discriminant form, but the local 10-minute process limit expired before an extension returned. Its `.status.txt` was left at `RUNNING` because the external timeout killed Julia before the script could write a final status; no process or saved result remains. This is not a nonexistence test. A first extension alone would not enumerate all actions. |
| `run_family_127_d6_manual_glue.jl`; `family_127_d6_manual_glue_r2.log` | **Completed for seven diagonal graphs on $A$-stable five-dimensional mod-2 hyperplanes.** Every constructed rank-16 overlattice has signature $(14,2)$ and determinant 64, and its involution's anti-part has rank 6 and determinant 256. All seven have `genus_target=false`. Rank and determinant alone do not establish that the anti-part is $D_6(2)$, and this diagonal test does not cover other glue maps. |
| `run_family_127_d6_finite_glue.jl`; `family_127_d6_finite_glue.log` | **Completed, with a saved and reloaded `.mrdi` record.** Its finite preflight found seven invariant hyperplanes for a fixed $D_6(2)$ order-four action whose reduction has three size-two Jordan blocks. It exhausted the 86,016 invertible maps in that action's mod-2 centralizer, restricting their graphs to those hyperplanes, and found no target discriminant-form invariants. This excludes only that finite family of graphs: it is not all integral actions, complements, or equivariant hyperplane glue maps. No ambient $E_6(2)$ glue was tested. |
| `run_family_127_d6_hyperplane_glue.jl`; `family_127_d6_hyperplane_scan_scan_20260929.mrdi` | **Completed, with a saved and reloaded record.** For the fixed determinant-256 seed $K=U^2\oplus D_6(2)$, this enumerates every order-four-equivariant isomorphism between the relevant five-dimensional $2$-torsion hyperplanes, including maps that do not extend to the six-dimensional modules. Among 13,824 maps, 1,152 preserve the quadratic form and 576 also preserve the necessary radical. All 576 give exponent-two quotients, but none has integral discriminant quadratic form ($\delta=0$). The subsequent $\phi_3$ argument excludes this determinant-256 seed theoretically and directs the next construction toward determinant 1024. |

The initial embedding attempt stopped with a `ZZMatrix`/`QQFieldElem`
assignment error, and the initial manual-glue attempt stopped at an HNF
basis assertion; the `r2` runs above are the completed retries. The
equivariant `glue-first` status is stale for the reason above.

The separate `verify_family_127_k1024_seed.jl` test constructed a
determinant-1024 lattice with the required discriminant-group structure
and an explicit integral order-four isometry squaring to $-I$. OSCAR
verified that this lattice is isometric to the natural abstract model
$U\oplus A_1\oplus A_1(-1)\oplus D_6(2)$; see
`family_127_k1024_seed.out`. The independent
`verify_family_127_q_glue.jl` test then checked both equivariant
index-four graph gluings of $E^{-s}\oplus K$. In both cases the result is
isometric to Marquand's $Q$, and the induced $g,h,s$ are integral
commuting isometries with $g^2=h$ and $hs=-I_Q$. The two results were
saved and reloaded in `family_127_q_glue_scan.mrdi`, with the checks in
`family_127_q_glue_scan.out`. This establishes $Q$-side compatibility
for the fixed seed, not a compatible action on $N$ or the full cubic
lattice.

The next finite check, `verify_family_127_k1024_n_obstruction.jl`, first rules
out **this particular order-four action on $K$** before an index-64
extension search. Such an extension would identify all of $A_M[2]$
(dimension six) with a six-dimensional subgroup of $A_K[2]$. Since
$q_M$ is integral on $A_M[2]$, its image must lie in the seven-dimensional
subgroup $T_K$ where $q_K$ is integral. The recorded actions have
$\operatorname{rank}(g+I\mid A_M[2])=3$ but
$\operatorname{rank}(g+I\mid T_K)=2$, so no equivariant injection exists.
Because $g^2=-I$ becomes the identity in characteristic two, $g+I$ has
square zero on $T_K$. The required rank three is therefore the maximal
possible rank on this seven-dimensional space (Jordan pattern
$2+2+2+1$). This is a cheap necessary filter for any future integral
order-four action on $K$.
See `family_127_k1024_n_obstruction.out`. A subsequent integral-Hermitian
parity argument strengthens this: every integral $J$ with $J^2=-I$ on
a rank-ten $K$ of this discriminant group has rank three on $A_K[2]$,
but only rank two on $T_K$ when $q_K$ is nonintegral on some
two-torsion class. Hence the entire natural $\delta_K=1$ genus is
excluded, although its finite quadratic form alone admits a rank-three
action. The proof and its precise assumptions are in
`family_127_local_module_criterion.md`.

The bounded check `verify_family_127_d6prime_order4.jl` exhausts the
order-four actions on the positive rank-six $D_6'$ block of this seed
while keeping its orthogonal rank-four block fixed as displayed. The
norm-two roots of $D_6'$ form $A_1^4$, their orthogonal complement is
$\langle4\rangle^2$, and $D_6'$ has index two over their sum. The unique
glue coset has half-integral coordinates in all six orthogonal directions.
Consequently its full isometry group is the signed-permutation product
of order $3072$. Exactly $24$ of these isometries square to $-I$; every
one still has $\operatorname{rank}(J+I\mid T_K)=2$. The result is recorded
in `family_127_d6prime_order4.out`. The analogous positive rank-eight
block has root system $A_1^6$, but its index-two glue distinguishes the
two added roots from the four in $D_6'$. Hence allowing all isometries
of that positive block still cannot mix these two subsets. This is a
complete statement only for actions preserving the displayed
positive/negative splitting of $K$; the stronger integral-Hermitian
argument above excludes even mixed-signature actions on this
$\delta_K=1$ lattice.

The separate `verify_family_127_complex_reflection_box.jl` test examines
one restricted way to mix the two signatures: multiply the seed $J$ by
an integral involution that negates a $J$-stable plane generated by a
short vector $v$ and $Jv$. It tested 116,728 distinct nonzero vectors
in the explicitly stated bounded coordinate sets. Of these, 2,586
gave integral complex reflections, and none raised
$\operatorname{rank}(J+I\mid T_K)$ above two. The counts are recorded in
`family_127_complex_reflection_box.out`. This is exploratory evidence
about that finite box, not a classification of mixed-signature actions.

A separate guarded OSCAR 1.8.2 preflight,
`run_family_127_k1024_hermitian_preflight.jl`, asked for pure
$\Phi_4$ actions on the rank-ten determinant-$1024$ genus with signature
$(8,2)$. It identified 19 possible Hermitian genera but did not return
an action list before its 160-second service limit. Peak memory was about
3.2 GiB, with no swap; the service exited and the status is `TIMED_OUT`.
This neither excludes an action nor establishes that all 19 genera are
needed. Even a returned list would require filtering its underlying
lattices for isometry with the particular $K$ model and checking the
finite rank-three condition.
An inspection of OSCAR 1.8.2's public Hermitian-splitting route found no
per-genus cursor or finite-discriminant-action filter. Its `first=true`
option still reaches the same genus-construction stage. The timeout
occurred before the next genus-enumeration progress line, so neither an
ETA nor a candidate count can presently be inferred. Further long runs
of the unchanged wrapper would be speculative. A more controlled next
step is to make a small targeted driver that checks the finite rank-three
condition for individual Hermitian genera before their class enumeration;
that requires inspecting and carefully using lower-level OSCAR routines.

Later work found an integral order-four action in Hermitian genus #13
on a $\delta_K=0$ lattice isometric to the explicit complement in
Marquand's target $Q$. Both $Q$ graphs work. A complete finite
index-64 $N$ graph scan for that one action found witnesses, and an
independent OSCAR posterior identified the first $N$ with
$U^2\oplus D_4^3$ and its actual $s$-anti-invariant lattice with
$D_6(2)$. A further finite $E_6(2)\oplus N$ graph produced a first
even determinant-three rank-22 action, but that E-side search stopped
at its first match. The exact counts and scope are in
`family_127_g13_n_finite_script.md` and
`family_127_g13_full_glue_audit.md`.
The remaining work is to identify the full involution coinvariant
lattice with $E_8(2)$, compare the fixed $S,T$ and geometric
$P,Q$ actions with No. 127, and perform root, saturation,
plane-class, period, and monodromy checks. No full geometric
identification or Hermitian-class completeness is claimed here.
