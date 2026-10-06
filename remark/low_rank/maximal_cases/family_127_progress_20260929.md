# Family No. 127: integral-action work checkpoint

Started: 2026-09-29 05:53 UTC. This checkpoint separates proved constraints,
bounded computations, and work still open. It is not a classification result.

## Established constraints

For the displayed projective generators, the square of the order-four
generator is the Eckardt involution $h$, and $q=hs$ is the three-negative-
coordinate involution of Marquand's $\phi_3$ type. The anti-invariant lattice
$Q=L^{-q}$ is 2-elementary of determinant $2^{10}$. With
$A=E^{-s}\cong\langle4\rangle^2$ and $K=N^s$, the primitive $A\oplus K$
glue in $Q$ has index four, so $|\operatorname{disc}K|=2^{10}$ and
$A_K\cong(\mathbb Z/4)^2\oplus(\mathbb Z/2)^6$. The derivation and
reference are in `family_127_d6_glue_script.md`.

Any prospective order-four action $J$ on $K$ must pass a finite necessary
test before attempting the index-64 glue with $M=N^{-s}\cong D_6(2)$.
Writing $T_K=\{x\in A_K[2]:q_K(x)\in\mathbb Z\}$, its dimension is seven
for the explicit seed. An equivariant injection of $A_M[2]$ requires
$\operatorname{rank}(J+I\mid T_K)=3$; the action on $2A_K$ must also match
the two-dimensional $Q$-side action. This test is necessary, not sufficient.
For every integral pure order-four action on an even rank-ten lattice
with this discriminant group, Hermitian parity forces
$\operatorname{rank}(J+I\mid A_K[2])=3$. Its fixed subspace lies in
$T_K$, so a codimension-one $T_K$ would have rank two. Thus the required
rank three forces $T_K=A_K[2]$: the 2-torsion quadratic values of $K$
must all be integral. This excludes the preceding explicit seed's
local quadratic type, not merely its chosen matrix.

For the proposed $N$-side search, fixing the standard pure order-four
action on $M=D_6(2)$ loses no conjugacy class on this factor. Indeed
$O(D_6)$ is the full signed-permutation group in six coordinates. An
isometry $J_M$ with $J_M^2=-I$ must pair all six coordinates into three
two-cycles and have opposite signs in each pair. There are
$15\cdot2^3=120$ such matrices, and all are conjugate by signed
permutations. This does not classify the compatible gluing maps.

For the saved #13 action, the finite $N$-side search can be narrowed
without omitting a target gluing: $A_K[2]$ is eight-dimensional,
$U=\operatorname{im}(J+I)$ is three-dimensional, and
$R=2A_K$ is two-dimensional with $\dim(U+R)=4$. Any six-dimensional
image $V$ of the full $A_M[2]$ gluing must contain $U$ by equivariance
and $R$ because the target discriminant group has exponent two. Thus
there are exactly 35 candidate subspaces; sixteen have
the required rank-three Jordan action. A complete scan must still
enumerate all equivariant quadratic anti-isometries for each surviving
$V$, not just one map per subspace.

## Bounded computations

An explicit $K$ model with determinant $2^{10}$ and pure order-four action
is isometric to $U\oplus A_1\oplus A_1(-1)\oplus D_6(2)$. Its small
$Q$-side glue works, but this specific action has rank two on $T_K$ and
cannot extend over $N$. Complete finite enumeration of actions preserving
its displayed positive/negative splitting also gives rank two. A finite
short-vector complex-reflection box search found no rank-three action; its
scope is restricted and gives no nonexistence theorem.

A second explicit model $K_0\cong U\oplus U(2)\oplus D_6(2)$ carries an
integral pure order-four action and passes this $N$-side rank test.
However, its two equivariant index-four $Q$-side graph gluings yield a
2-elementary lattice with integral 2-torsion quadratic values
($\delta=0$), while Marquand's target $Q$ has $\delta=1$.
Thus this simple model is not the desired action either.

A guarded OSCAR 1.8.2 Hermitian-splitting preflight on rank ten identified
19 possible Hermitian genera but returned no actions within 160 seconds.
Peak memory was about 3.2 GiB, with no swap. The public wrapper lacks a
per-genus cursor and does not apply the finite rank-three filter before
constructing global representatives.
The shorter local-symbol script subsequently generated the same 19
Hermitian genera without global representatives. Only two (#13 and #14
in its recorded order) pass the abelian discriminant structure, evenness,
the $N$-side rank condition, and the 2-torsion quadratic condition.
Their distinction is a local determinant class. An explicit primitive
embedding $A\cong\langle4\rangle^2$ into Marquand's target $Q$ gives an
orthogonal complement $K_{\rm comp}$ of rank ten, signature $(8,2)$,
determinant $2^{10}$, and $\delta_K=0$. A guarded local-only OSCAR check
shows that the trace lattice of Hermitian genus #13 has the same
$2$-adic integral genus as $K_{\rm comp}$, whereas #14 does not. The
previous simple model $K_0\cong U\oplus U(2)\oplus D_6(2)$ belongs to
#14. Thus #13 is the only surviving Hermitian *local* genus for this
explicit target embedding. The local comparison alone does not supply a
global representative, an integral order-four action on
$K_{\rm comp}$, or an equivariant glue.
The checks are recorded in `family_127_q_explicit_complement.out` and
`family_127_q_local_genus_compare.out`.

A subsequent single-genus calculation **did** construct one global
Hermitian representative of #13. Its trace is an even integral lattice
of rank ten, signature $(8,2)$ and determinant $2^{10}$, with an integral
order-four isometry $J$ satisfying $J^2=-I$. OSCAR reports that this
trace lattice is isometric to $K_{\rm comp}$. Its Gram and action
matrices were saved to and reloaded from
`family_127_g13_global_preflight.mrdi`. The run constructed one
representative rather than enumerating its Hermitian genus. A separate
application of [Kirschmer's local determinant theorem, special-genus
formula, and indefinite strong-approximation result](https://www.math.rwth-aachen.de/~Markus.Kirschmer/papers/det.pdf)
now shows that this genus has **exactly one global Hermitian isometry
class**: its rank over $\QQ(i)$ is odd (five), $\mathbb Z[i]$ has class
number one, and its signature is $(4,1)$. See
`family_127_g13_hermitian_genus_note.md` for the exact hypotheses.
Starting from this saved
representative, both equivariant index-four gluings of
$A\oplus K$ were constructed. Each gives an even $Q$ isometric to
Marquand's target, with integral commuting $g,h,s$ satisfying
$g^2=h$ and $hs=-I$; each has 2-elementary discriminant group and
$\delta_Q=1$. Their coarse quadratic-value orbit fingerprints match
the geometric $\phi_3$ action. An independent Python check also finds
that both finer orbit-span quadratic fingerprints match. These are
necessary finite tests, not an exhibited discriminant anti-isometry.
Gram/action matrices were saved and reloaded in
`family_127_g13_q_graph_preflight.mrdi`, with a JSON copy for the
independent comparison. The next paragraphs record subsequent
$N$- and full-lattice existence witnesses.

The $N$-side finite scan has now exhausted all 35 candidate subspaces
for this one saved $K,J$ action. Sixteen have the required Jordan rank;
it examined all $16\cdot86{,}016=1{,}376{,}256$ equivariant maps on
them and found 6,144 quadratic anti-isometries. All 6,144 satisfy the
finite exponent-two and $\delta_N=0$ quotient tests. A first complete
16-by-16 Gram/action witness is saved for each of the sixteen
subspaces; exact integral checks give determinant 64, 2-elementary
discriminant of length six, $\delta_N=0$, and $g^2=-I$, $s^2=I$,
$gs=sg$. An independent integer-arithmetic check reconstructed the
first witness and confirmed that its embedded $M$ and $K$ are primitive
and mutually orthogonal. The full finite record is
`family_127_g13_n_finite_full_v1-35.json`. Its completeness is only
for this particular global Hermitian representative and the fixed
canonical $J_M$. A separate bounded OSCAR posterior on the first
saved witness verifies both genus equality and actual isometry
$N\cong U^2\oplus D_4^3$. Its saturated $s$-anti-invariant lattice
is isometric to $D_6(2)$, and its fixed lattice has rank ten,
signature $(8,2)$, and determinant $2^{10}$; see
family_127_g13_n_oscar_postcheck.out.

An independent subsecond exact comparison of the finite quadratic
discriminant modules of all sixteen saved first $N$ witnesses also found
the same $(g,s)$ action in every case. Relative to the first witness,
each comparison has a twelve-dimensional intertwiner space over
$\mathbb F_2$ (4,096 maps), 768 invertible maps, and 96 quadratic
isometries. Consequently its $E$-side discriminant anti-isometry can
be transported to the other fifteen witnesses at the finite-module
level. This finite comparison **alone** does not establish integral equivalence of their
$N$- or full-$L$ actions, nor root-freeness or saturation for the
other witnesses. See
`verify_family_127_g13_n_discriminant_actions.py` and
`family_127_g13_n_discriminant_actions.out`.

The sixteen candidate image subspaces themselves admit a stronger
integral reduction. Four explicit norm-four, divisibility-two complex
reflections of the saved $K$ commute with $J_K$ and are integral
isometries. Their induced permutations generate a single orbit on all
sixteen eligible $V$. Exact Gram, commutation, involution, and
discriminant-action checks are reproducible in
`verify_family_127_g13_k_v_orbit.py` and
`family_127_g13_k_v_orbit.out`. Over one representative image
$V_{10}$, the 384 equivariant quadratic maps form two 192-element
orbits under the integral $O(M,J_M)$ centralizer alone. Schreier
generators of the displayed $K$-reflection subgroup's stabilizer of
$V_{10}$ merge these into one 384-element orbit. The exact finite
audit `verify_family_127_g13_phi_orbits.py` and its `.out` checks the
integrality and action of the generators. Thus **all 6,144 $N$-side
graphs for this fixed global $K,J_K$ are integrally conjugate** by
commuting isometries of $M\oplus K$. Together with the genus-one-class
theorem above, it resolves the $N$-gluing ambiguity for the chosen
local genus, but not other possible $A\hookrightarrow Q$ settings.

A further finite preflight using that first $N$ witness and the
saved $E_6(2)$-side pair found a first index-64
$E_6(2)\oplus N$ graph. The simultaneous $g,s$ intertwiner space
on the two six-dimensional 2-primary discriminant groups has
dimension 12 (4,096 linear maps). The script stopped at its first
passing graph after 1,282 maps, so its JSON correctly reports
search_complete=false. Exact integer checks give an even
rank-22 determinant-three Gram matrix, integral commuting $g,s$,
trivial action of both on its order-three discriminant, and a
fixed plane vector of norm 24 and divisibility 3. See
run_family_127_g13_full_finite_glue.py and
family_127_g13_full_finite_glue_preflight.json.
This original JSON establishes a first **abstract full-lattice
existence witness**; by itself it neither enumerates all E-side
glues nor identifies the geometric No. 127 action.
A separate pure finite count did exhaust the 4,096 intertwining
matrices for this fixed E pair and first N witness, without
building more rank-22 lattices: 768 are invertible, and 96
preserve the quadratic forms anti-isometrically. These 96 form
one orbit under the finite centralizer; see
family_127_g13_full_intertwiner_count.out. An independent exact
integral E-side orbit audit generates the folded Weyl centralizer
of order 1,152; its plane-vector stabilizer has order 384, and
its subgroup also commuting with $s_E$ has order 96. The latter
has 96 distinct mod-2 images, and its orbit of the first graph is
the entire 96-map anti-isometry set. Hence all E-side graph
overlattices for this **fixed first $N$ action** are integrally
conjugate by plane-fixing $w\oplus I_N$; see
family_127_e_glue_orbit.out. The intrinsic finite E-side
centralizer also has order 96, since the anti-isometry set is its
torsor. Conditionally, for **any fixed $N$ discriminant action**
admitting one full 2-primary equivariant anti-isometry, all its
E-side full-graph glues are integrally conjugate in the same way.
Together with the preceding integral $N$-orbit computation, this
shows that all 6,144 fixed-$K$ graphs admit an $E$-side graph and
yield **one plane-decorated full-$L$ action class** for this saved
$K,J_K$ and the fixed $E$-side action: transport the first full
anti-isometry along the $N$ conjugacies, then use the plane-fixing
$E$-side orbit. It does not address another geometric embedding
setting, nor identify this class with the complete cohomology
action of the displayed coordinate cubic.

A separate bounded OSCAR posterior on the first full-lattice
witness verifies that $L$ is isometric to the standard primitive
cubic lattice and saturated $S=L^{-s}$ is directly isometric to
$E_8(2)$. The saturated $T=L^s$ has the same indefinite genus as
the preserved "2 generic 1" lattice, hence is isometric by
indefinite genus uniqueness. The full and restricted characters
and signatures match the prescribed data, including the rank-ten
$\Phi_4$ piece of $T$ with signature $(8,2)$; see
family_127_g13_full_l_oscar_postcheck.out. This remains an
abstract integral-lattice identification, not a proof of
geometric No. 127 realization.

The positive definite rank-ten
$P_{\rm geo}=L^{g^2s}$ for this same full-lattice witness has also
passed an exact **decorated** integral comparison with the
Marquand geometric plane-class model. An independently checked
unimodular matrix of determinant $-1$ matches its Gram form, the
row-action geometric pushforward of $g$, and the projected norm-24
plane class. See
family_127_g13_p_decorated_isometry_verified.json/.out. The
verified record corrects an earlier input-metadata error; the matrix
equalities themselves passed independently.
This directly identifies the decorated $P_{\rm geo}$ for the saved
full-lattice witness. The genus and gluing orbit arguments above carry
it to the chosen genus-#13 setting, but not to other geometric
$A\hookrightarrow Q$ embeddings.
Both small #13 $Q=L^{-(g^2s)}$ graph models separately pass
Marquand's target test. Exact extraction of the **saturated
actual** $Q$ from this full-lattice witness matches the saved
swap=False #13 $Q$ graph, with an explicit unimodular basis
change and exact Gram/$g,h,s$ intertwining; the swap=True graph
is not induced here. See
family_127_g13_q_graph_realization.json/.out. The positive
definite $P_{\rm geo}$ is not the period lattice
$P_{\rm per}=\ker\Phi_4(g|T)$, also rank ten but of signature
$(8,2)$.

A bounded OSCAR check then computed that saturated period kernel
for the first witness: rank ten, signature $(8,2)$, period-domain
dimension four. Its orthogonal complement in $L$ is positive
definite rank twelve. The original project predicate
has_root(K,L) returns false, excluding norm-two roots and
norm-six roots of ambient divisibility three. See
family_127_g13_root_period_preflight.out. These are necessary
root/period tests; this computation alone does not prove
saturation. The stable-action hypothesis and the existing
construction proposition below handle geometric realization
without a separate monodromy enumeration.

A separate guarded OSCAR computation applied the original
helper's symplectic-saturation criterion to the same positive
rank-twelve $K=P_{\rm per}^{\perp}\subset L$:
$|O(K)|=8{,}847{,}360$ and
$|\operatorname{im}(O(K)\to O(q_K))|=4{,}423{,}680$.
Thus the discriminant kernel has order two, exactly
$|\widetilde O(E_8(2))|=2$; the known stable involution supplies
the nontrivial element. For this **single saved witness**, the
prescribed family is symplectically saturated. See
family_127_g13_saturation_preflight.out. This computation
alone does not prove a global uniqueness statement across other
geometric embedding settings.

The same saved family is also **fully saturated**, by a direct
generic-period argument that does not use any faithfulness-on-$S$
result restricted to higher rank. Choose a very general period in the
four-dimensional $i$-eigenball, outside the countable union of proper
eigenline loci of integral isometries of $L$. Any automorphism of the
corresponding smooth cubic then acts as a scalar $\lambda$ on the whole
$i$-eigenspace of $g$ in $P_{\rm per,\CC}$. By rationality and complex
conjugation, its restriction to $P_{\rm per,\QQ}$ is a scalar in
$\QQ(i)$. The smooth cubic has finite automorphism group, so
$\lambda$ is a root of unity; hence $\lambda\in\{\pm1,\pm i\}$.
The displayed $g$ realizes order four, while the preceding
discriminant-kernel computation gives a generic symplectic subgroup
of order two. Thus the generic full group has order eight and equals
the eight-element subgroup generated by the commuting $g,s$:
$C_4\times C_2$ ($s$ fixes $T$, whereas $g^2$ does not).
This proves full saturation of **this one constructed family**, not
an exhaustive classification of all integral actions.

The numerical alternative also rules out a strictly larger cyclic index
$m'>4$ containing this order-four
action would require $4\mid m'$ and
$\varphi(m')\mid\operatorname{rank}P_{\rm per}=10$, impossible since
$4\mid\varphi(m')$. The generic-period argument above establishes full
saturation directly and applies at this family's symplectic rank eight.

An independent integer audit of the same full witness also
constructs the index-three extension
$H^4=\mathbb Z\Pi+L$, with
$\Pi=(h^2+p)/3$. It is odd unimodular of rank 23 and signature
$(21,2)$; $h^2$ is primitive characteristic of norm three, and
$\Pi$ has norm three and degree $(h^2,\Pi)=1$. Both $g$ and $s$
extend integrally, commute, and fix $h^2$ and $\Pi$; see
alternative_family_127_g13_h4_plane_audit.out. These checks do
not identify $\Pi$ with a plane on the original displayed cubic.

## Geometric realization criterion

For a stable primitive cubic-fourfold lattice action, take the
non-symplectic generator's eigenspace containing a negative real two-plane.
Its period domain must be nonempty, and its positive orthogonal lattice
must contain no norm-two vector and no norm-six vector of ambient
divisibility three. These excluded vectors are precisely the short and
long root obstructions to a smooth cubic period. The cubic period map
then realizes the remaining periods, and strong Torelli realizes the
stable period-preserving isometries as automorphisms. Choosing a very
general period avoids additional algebraic classes.

For this saved action, $g$ fixes $A_L\cong\mathbb Z/3$, preserves $S,T$,
its restriction to $T$ has order four, and its $\Phi_4$ real space has
signature $(8,2)$. The script
[`run_family_127_g13_root_period_preflight.jl`](run_family_127_g13_root_period_preflight.jl)
checks the saturated rank-ten period lattice and applies
[`has_root`](../../../oscar/oscar_script.jl) to its positive orthogonal
lattice, finding neither short nor long roots. The $i$-eigenspace has
complex dimension five, hence its projective period domain has dimension
four. These conditions and the cubic period map/strong Torelli produce a
complex four-dimensional prescribed family of smooth cubic fourfolds
carrying the constructed
$C_4\times C_2$ action. This is a **geometric existence theorem for
the saved lattice action**, now fully saturated,
but not an identification of its full $H^4$ action with the
particular displayed No. 127 cubic or a uniqueness result
across classes.
The final 156-row table does not close that gap: row 124 shares
$S\cong E_8(2)$, index four, and abstract group $C_4\times C_2$
with row 127, but has family dimension five rather than this
witness's four (equivalently a rank-twelve rather than rank-ten
$\Phi_4$ period lattice). Row 79 has group $C_4\times C_2$ and
dimension four but symplectic rank fourteen, not eight. Thus
these coarse invariants single out row 127 **among the listed
fully saturated rows**. Together with the table's claimed
completeness, this gives row 127 as an *indirect classification
label* for the constructed family. It does not exhibit a
complete $H^4$ action/gluing conjugacy certificate with the
particular coordinate model or enumerate the other integral
classes considered in the search.

Separately, the $\phi_3$ plane classes give an explicit integral matrix
for the order-four action on $P_{\rm geo}=L^q$, a positive definite
rank-ten lattice. Its action on the 2-primary
discriminant group has Jordan pattern $4+2+2+1+1$, with a recorded
quadratic-value orbit profile. These are additional finite tests for
any proposed $Q$ action; see `family_127_phi3_plane_action_script.md`.
Both previously saved $Q$ actions for the old, $N$-incompatible seed
fail even the coarse orbit-profile comparison, despite having the
correct abstract $Q$ lattice and $\delta_Q=1$. This confirms that the
geometric finite-action test has genuine discriminating power; it
did not by itself prove extension to $L$; the subsequent saved
full-lattice witness supplies one such extension.

## Remaining work

1. Within the chosen $A\hookrightarrow Q$ setting, genus #13 has one
   global Hermitian class. For the fixed canonical $M,J_M$ and
   $E$-side actions, its full $M\oplus K$ and E-side gluing choices
   now give one plane-decorated integral full-$L$ action class.
   A global uniqueness claim would still need to control any other
   admissible primitive embedding of $A$ into the geometric $Q$ or
   otherwise show that the chosen setting and $M\cong D_6(2)$ setup
   are exhaustive. Given $M\cong D_6(2)$ and a pure order-four
   $J_M^2=-I$, its conjugacy class is already unique, as checked
   above. The bare
   primitive embedding is not unique: two orthogonal roots in the
   $E_8(2)$ factor of
   $Q=U\oplus\langle2\rangle\oplus\langle-2\rangle\oplus E_8(2)$
   span another primitive $\langle4\rangle^2$ whose complement is
   $U\oplus\langle2\rangle\oplus\langle-2\rangle\oplus D_6(2)$
   with $\delta=1$; the selected embedding has complement with
   $\delta=0$. Thus only an argument incorporating the $g,s$ and plane
   conditions could establish exhaustiveness. In fact this explicit
   $\delta=1$ embedding is already excluded by the required
   order-four, index-$64$ $M\oplus K\to N$ glue: the local
   $(J+I)$-rank is two on the integral-quadratic-value hyperplane
   of $A_K[2]$, whereas equivariance with $M=D_6(2)$ requires at
   least three; see `family_127_local_module_criterion.md`.
   This exclusion still does not classify all embeddings: even
   uniqueness of the remaining bare $\delta=0$ embeddings under
   $O(Q)$ has not been verified, let alone their $g,s$, plane, and
   full-lattice decorations.
2. Compare the full $H^4$ action and plane class with the
   particular displayed No. 127 cubic, if that explicit-equation
   identification is required. Full generic group
   $C_4\times C_2$ is now established for the saved family,
   but the specified coordinate cubic's complementary $Q$ action
   has not been computed independently. The decorated positive
   $P_{\rm geo}$ match does not by itself identify the full
   $H^4$ action. No unattended global-class enumeration is running:
   the theorem makes it unnecessary within #13, while other
   embedding questions require a different, checkpointable search.

The saved action now gives a smooth four-dimensional prescribed
cubic family by the geometric realization criterion above, with the correct
primitive and full-cohomology lattice data, decorated Marquand
plane-class lattice, root-free period orthogonal, and verified
full saturation. A direct full-$H^4$ conjugacy certificate
with the displayed No. 127 equation and exhaustiveness across
other geometric embeddings remain open.
