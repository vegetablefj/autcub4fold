# No. 127 saved full-lattice witness: independent postcheck

This record concerns the **first saved witness only** in
`family_127_g13_full_finite_glue_preflight.json`.
The finite E6(2)-to-N search stopped on its first passing graph;
`search_complete=false`. Existence is established; uniqueness and a full
classification are not claimed.

`alternative_family_127_g13_full_l_audit.py` independently verifies the
saved integer matrices, without importing the searcher's helper code. Its
fixed output is `alternative_family_127_g13_full_l_audit.out`. It checks that
E6(2) and N are primitive orthogonal sublattices of index 64; L is even of
rank 22, signature (20,2), determinant 3; g and s are integral isometries
with g^4=s^2=1 and gs=sg; g^2 acts as +1 on E6(2) and -1 on N; both act
trivially on A_L=Z/3. The fixed primitive plane vector has norm 24 and
ambient divisibility 3.

`run_family_127_g13_full_l_oscar_postcheck.jl` reads exactly that saved L
JSON. Its immutable run log/status are
`family_127_g13_full_l_oscar_postcheck.out` and `.status.txt`. On
2026-09-29, Julia 1.10.11 / OSCAR 1.8.2 returned:

| Restriction | Phi1 rank/signature | Phi2 rank/signature | Phi4 rank/signature |
| --- | --- | --- | --- |
| T=L^s | 1, (1,0) | 3, (3,0) | 10, (8,2) |
| S=L^-s | 1, (1,0) | 1, (1,0) | 6, (6,0) |

Thus the full g characteristic polynomial is Phi1^2 Phi2^4 Phi4^8,
exactly the No. 127 character. OSCAR extracted S of rank 8, positive
definite, determinant 256 and T of rank 14, signature (12,2), determinant
768. It confirmed `genus(S)==genus(E8(2))` and directly
`is_isometric(S,E8(2))==true`. It confirmed `genus(T)==genus(original T)`;
the two T lattices are isometric by uniqueness of an even indefinite
lattice in its genus when rank >= l(A)+2: here rank 14 and
`l(A_T)<=8` because `|A_T|=2^8*3`. It also confirmed
`genus(L)==genus(E8^2+U^2+A2)` and directly
`is_isometric(L,E8^2+U^2+A2)==true`.

The one-shot service was `family127-g13-full-l-postcheck.service`, with
one Julia thread, MemoryHigh=4 GiB, MemoryMax=6 GiB, MemorySwapMax=0,
CPUQuota=100%, RuntimeMaxSec=300s, and an outer 310s timeout. The script
completed in 93.0s; systemd reported exit 0, service runtime 1m56.552s,
peak memory 3.5G, swap peak 0. Post-exit the service was inactive/dead and
no Julia process remained.

`run_family_127_g13_root_period_preflight.jl` separately restricted g to T,
took the saturated Phi4 kernel P, and formed K=P^perp in L. Its immutable
`.out/.status.txt` show P rank 10/signature (8,2)/period dimension 4 and K
positive rank 12. The original `has_root(K,L)` predicate in
`oscar/oscar_script.jl` returned **false**: no norm-2 root or norm-6 root
of ambient divisibility 3. The service
`family127-g13-root-period-preflight.service` completed with exit 0 on
2026-09-29 (script 4.7s, service 26.373s, swap 0); it used the same
one-thread/4-GiB-high/6-GiB-max/zero-swap/300s guard. Its systemd
`MemoryPeak=512K` is implausible for an OSCAR process and is not treated as
a reliable memory measurement.
The later separate saturation test is recorded below.

`alternative_family_127_g13_h4_plane_audit.py/.out` constructs the full
odd cohomology lattice with basis (Pi,L), where Pi=(h^2+p)/3 for the saved
norm-24/divisibility-3 vector p. Exact arithmetic gives
`[H4:<h^2>+L]=3`, determinant 1, signature (21,2), and odd parity.
The vector h^2=3Pi-p is primitive characteristic, square 3, and
orthogonal to L; Pi has square 3 and degree `(h^2,Pi)=1`. Both g and s
extend integrally while fixing h^2 and Pi.

The saved action is stable, the $\Phi_4$-part of $T$ has signature $(8,2)$,
and $K$ is root-free. The [geometric realization criterion](family_127_progress_20260929.md#geometric-realization-criterion)
explains how these checked lattice conditions give a nonempty
four-dimensional smooth cubic family through the cubic period map and
Torelli theorem. The computation verifies the lattice conditions; the
geometric conclusion also uses those mathematical results.

Source review of OSCAR 1.8.2 / Hecke shows that
`representatives(G::HermGenus)` builds and returns an entire vector via
`genus_representatives(representative(G))`. The indefinite rank-five
Hermitian branch uses `spinor_genera_in_genus`, which has no public
iterator/checkpoint callback; except for `max==1`, its `max` argument does
not give incremental batches (the implementation builds `res` and returns
it in full). A separate mathematical argument now makes this particular
enumeration unnecessary: Kirschmer's local determinant theorem, the
special-genus count, and indefinite strong approximation prove that
this rank-five genus over the class-number-one ring `Z[i]` contains one
global Hermitian class. See `family_127_g13_hermitian_genus_note.md`.
The theorem concerns the undecorated `(K,J)`; gluing and geometric
identification are separate questions.

Still open: a full classification of all actions and a direct comparison
with the displayed coordinate cubic's complete $H^4$ action. The
geometric $\phi_3$ fixed-lattice comparison is recorded by
`family_127_g13_p_decorated_isometry_verified.json/.out`; it gives an
equivariant integral match on the positive algebraic part, including the
plane class, but does not determine the coordinate cubic's integral action
on its complementary rank-twelve lattice.

## Symplectic saturation of this witness

`run_family_127_g13_saturation_preflight.jl` completed once under a
foreground `systemd-run --wait --pipe` service with the same one-thread,
4-GiB-high, 6-GiB-hard, zero-swap, 300s guard. The script itself checked
the cgroup settings. It found the positive rank-12 orthogonal complement
Kroot to have determinant 3072 and discriminant elementary divisors
`[2,2,2,2,2,2,4,12]`. The restriction of s gives a nontrivial stable
involution on Kroot. OSCAR then computed

```
|O(Kroot)| = 8,847,360
|im(O(Kroot) -> O(q_Kroot))| = 4,423,680
|tilde O(Kroot)| = 2 = |tilde O(E8(2))|.
```

Thus this one saved witness satisfies the **symplectic saturation**
criterion. The log/status files are
`family_127_g13_saturation_preflight.out/.status.txt`.
The script elapsed time was 57.6s; systemd reported exit 0, runtime
1m18.367s, peak memory 3.4G, swap peak 0. This does not enumerate other
#13 actions or prove full classification.

For full saturation at rank `S=8`, use the direct generic-period proof
in `family_127_progress_20260929.md`: a very general period in the
four-dimensional `i`-eigenball forces every period-preserving integral
isometry to act by a scalar on the entire `i`-eigenspace. Rationality
puts that scalar in `Q(i)`, and finiteness of the cubic's automorphism
group leaves only `+/-1,+/-i`. Thus the generic index is exactly four;
with symplectic kernel of order two, the displayed `C4 x C2` is the
generic full group. The alternative totient obstruction to a strictly
larger cyclic index is numerically valid, but the generic-period proof
does not need that comparison. No completeness across other integral
actions is claimed. The geometric realization criterion and generic-period
argument are recorded in the [construction notes](family_127_progress_20260929.md#geometric-realization-criterion).
