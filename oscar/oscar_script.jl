# OSCAR routines for the cubic-fourfold lattice search.
#
# Tested with Julia 1.10.11 and OSCAR 1.7.3.  The local
# equivariant_primitive_extensions_issue6071 wrapper uses internal OSCAR/Hecke
# functions and is therefore version-sensitive.

using Oscar


function has_root(L1::ZZLat, L2::ZZLat)
    @req is_positive_definite(L1) "L1 must be positive definite"
    @req rank(L1) <= rank(L2) "L1 must have rank <= L2"

    B1 = basis_matrix(L1)
    B2 = basis_matrix(L2)

    G1 = gram_matrix(ambient_space(L1))
    G2 = gram_matrix(ambient_space(L2))

    @req G1 == G2 "L1 and L2 must be represented in the same ambient quadratic space"

    Gamb = G2

    # Short roots have norm 2.
    for (_, sq) in short_vectors(L1, 2, 2)
        sq == 2 && return true
    end

    # Long roots have norm 6 and divisibility 3 in the ambient lattice L2.
    for (v, sq) in short_vectors(L1, 6, 6)
        sq == 6 || continue

        v_amb = matrix(QQ, 1, length(v), v) * B1
        pairings = v_amb * Gamb * transpose(B2)

        div = ZZ(0)

        for i in 1:ncols(pairings)
            x = QQ(pairings[1, i])
            @req denominator(x) == 1 "Pairing with L2 is not integral"
            div = gcd(div, abs(ZZ(numerator(x))))
        end

        div == 3 && return true
    end

    return false
end

# Return the absolute discriminant as an exact ZZ integer.
# The function rejects any representation whose discriminant is not integral.

function absdisc_int(L::ZZLat)
    d = abs(QQ(discriminant(L)))
    @req denominator(d) == 1 "The discriminant is not integral"
    return ZZ(numerator(d))
end

# Return the exact square root of a nonnegative square integer.
# Limitation: the result is converted to Julia Int, so it must fit in a machine
# integer on the running platform.

function sqrt_int_exact(n)
    n = ZZ(n)
    @req n >= 0 "Expected a nonnegative integer"
    @req is_square(n) "Expected a square integer"
    return Int(sqrt(n))
end

# Compute the required glue order for a primitive extension P + Q <= Lambda0.
# This uses [Lambda0 : P + Q]^2 = |disc(P)|*|disc(Q)|/3 and is valid only for
# the orthogonal primitive-extension setting with |disc(Lambda0)| = 3.
# The quotient must be an exact square; otherwise the function raises an error.

function glue_order_to_disc3(P::ZZLat, Q::ZZLat)
    dP = absdisc_int(P)
    dQ = absdisc_int(Q)

    num = dP * dQ
    @req rem(num, ZZ(3)) == 0 "|disc(P)|*|disc(Q)| must be divisible by 3"

    return sqrt_int_exact(divexact(num, ZZ(3)))
end

# Test |disc(S)| = 3*|disc(T)|.  Absolute discriminants are intentional because
# OSCAR's signed discriminant depends on the lattice signature.

function disc_S_equals_3disc_T(S::ZZLat, T::ZZLat)
    return absdisc_int(S) == ZZ(3) * absdisc_int(T)
end

# Rebuild a lattice-with-isometry in a full-rank ambient model while preserving
# its Gram matrix and isometry.  This is a representation-level normalization;
# it assumes the stored isometry is expressed in the lattice basis.

function full_rank_model(Lf::ZZLatWithIsom)
    L = integer_lattice(; gram = gram_matrix(Lf))
    return integer_lattice_with_isometry(L, isometry(Lf); check = true)
end

# Return ker(Phi_m(f)).  OSCAR versions accept either m or the cyclotomic
# polynomial, so the second form is used as a compatibility fallback.
# Limitation: the broad catch intentionally retries after any error from the
# first call; callers should inspect unexpected failures from the fallback.

function phi_kernel(Lf::ZZLatWithIsom, m::Int)
    try
        return kernel_lattice(Lf, m)
    catch
        return kernel_lattice(Lf, cyclotomic_polynomial(m))
    end
end

# Enumerate representatives of conjugacy classes of order-m isometries of T and
# keep only actions whose relevant cyclotomic kernel has the required (*, 2)
# signature.  Completeness here means completeness of OSCAR's conjugacy-class
# enumeration for the supplied integral lattice T and the fixed order m.

function enumerate_T_actions(T::ZZLat, m::Int)
    raw = enumerate_classes_of_lattices_with_isometry(
        T, m;
        neg_sigs = [(m, 2)]
    )

    good = ZZLatWithIsom[]

    for Tf0 in raw
        Tf = full_rank_model(Tf0)

        Pm = phi_kernel(Tf, m)
        sigs = signatures(Pm)

        # The second entry of the OSCAR signature datum is the required
        # negative index; the intended condition is exactly sigs[1][2] == 2.
        if haskey(sigs, 1) && sigs[1][2] == 2
            push!(good, Tf)
        end
    end

    return good
end

# Translate the classification mode when the two extension factors are swapped.
# Only :subemb and :embsub change; the other supported modes are symmetric.

function _reverse_equivariant_classification(classification::Symbol)
    if classification == :subemb
        return :embsub
    elseif classification == :embsub
        return :subemb
    else
        return classification
    end
end

# Data attached to the fixed plain input lattice N.  In the cubic-fourfold
# search this is always the original input S, not one of the embedded copies
# S_in_Lambda0 returned by the primitive-extension routine.
#
# The context may therefore be reused for all T-actions in one call to
# cubic_fourfold_search.  It must not be reused for the final GAP computation on
# different embedded copies of S unless explicit isometries identifying their
# bases have been constructed.

function plain_side_extension_context(N::ZZLat)
    @req is_definite(N) "The plain side must be definite"

    qN = discriminant_group(N)
    ON = orthogonal_group(N)
    discN = discriminant_representation(N, ON)
    OqfN, _ = image(discN)

    return (
        lattice = N,
        discriminant_group = qN,
        orthogonal_group = ON,
        discriminant_representation = discN,
        discriminant_image = OqfN,
        tilde_order = divexact(order(ON), order(OqfN)),
    )
end

# Local one-marked-side implementation of equivariant primitive extensions.
#
# Required input order:
#   M is a lattice with isometry; N is a plain definite lattice.
# Only N's full orthogonal group is computed.  This is essential because M may
# be indefinite of rank greater than 2, where a full finite orthogonal-group
# computation is not available in this workflow.
#
# Version note:
#   This method mirrors the PR #6004 fix by disabling the discriminant-
#   annihilator prefilter on both sides (chiM = chiN = 0).  OSCAR v1.7.3 can
#   otherwise discard a valid glue domain before fitting isometries are lifted.
#   Because internal OSCAR functions are called, API compatibility is not
#   guaranteed outside the tested 1.7.x code line.

function equivariant_primitive_extensions_issue6071(
    M::ZZLatWithIsom,
    N::ZZLat;
    glue_order::AbstractVector{T}=Int[],
    form_over::Vector{TorQuadModule}=TorQuadModule[],
    even::Bool=(is_even(M) && is_even(N)),
    classification::Symbol=:subsub,
    compute_bar_Gf::Bool=false,
    first_fitting_isometry::Bool=false,
    plain_context=nothing,
) where T <: Hecke.IntegerUnion
    @req classification in Symbol[:none, :first, :embemb, :subsub, :subemb, :embsub] "Wrong classification method"
    @req is_definite(N) "Input without isometry must be definite"

    # The unmarked side supplies both the classification image and the
    # discriminant representation used to lift a fitting isometry.  These data
    # depend only on the fixed plain input lattice and can safely be cached.
    ctx = plain_context === nothing ? plain_side_extension_context(N) : plain_context
    @req ctx.lattice === N "The cached context must belong to the same plain lattice object"

    qN = ctx.discriminant_group
    discN = ctx.discriminant_representation
    OqfN = ctx.discriminant_image

    qM, fqM = discriminant_group(M)

    if classification == :embsub || classification == :embemb
        GMbar = Oscar._orthogonal_group(
            qM,
            TorQuadModuleMap[id_hom(qM)];
            check=false,
        )
    else
        GMbar, _ = image_centralizer_in_Oq(M)
    end

    if classification == :subemb || classification == :embemb
        GNbar = Oscar._orthogonal_group(
            qN,
            TorQuadModuleMap[id_hom(qN)];
            check=false,
        )
    else
        GNbar = OqfN
    end

    if compute_bar_Gf
        OqfM, _ = image_centralizer_in_Oq(M)
    else
        OqfM = Oscar._orthogonal_group(
            qM,
            TorQuadModuleMap[id_hom(qM)];
            check=false,
        )
    end

    exist_only = classification == :none
    first = classification == :first

    return Oscar._primitive_extensions_generic(
        lattice(M),
        N,
        GMbar,
        GNbar,
        (:equivariant, :plain);
        even,
        exist_only,
        first,
        first_fitting_isometry,
        fM=isometry(M),
        fqM=hom(fqM),

        # Core #6071/#6004 correction: do not apply an annihilator
        # prefilter in the one-marked-side branch.
        chiM=zero(Hecke.Globals.Qx),
        chiN=zero(Hecke.Globals.Qx),

        glue_order,
        form_over,
        compute_bar_Gf,
        OqfM,
        OqfN,
        discrep=discN,
    )
end

# Public-order wrapper for the common call (plain lattice, marked lattice).
# The factors and asymmetric classification modes are reversed internally, then
# the two embedded images are swapped back.  Thus the return order remains
# (Lf, image_of_M, image_of_N), matching the caller's input order.

function equivariant_primitive_extensions_issue6071(
    M::ZZLat,
    N::ZZLatWithIsom;
    classification::Symbol=:subsub,
    kwargs...,
)
    reversed_classification = _reverse_equivariant_classification(classification)

    ok, res = equivariant_primitive_extensions_issue6071(
        N,
        M;
        classification=reversed_classification,
        kwargs...,
    )

    for i in eachindex(res)
        res[i] = res[i][[1, 3, 2]]
    end

    return ok, res
end

# Backward-compatible alias retained for earlier notebooks.  It adds no new
# behavior and inherits all restrictions of the issue-#6071 wrapper.

function my_equivariant_primitive_extensions(args...; kwargs...)
    return equivariant_primitive_extensions_issue6071(args...; kwargs...)
end

# Test whether the stored isometry acts trivially on the discriminant group.
# Normally only generators are tested.  If generator access is unavailable, the
# fallback iterates over all elements, which may be expensive for a large group.

function trivial_action_on_discriminant(Lf::ZZLatWithIsom)
    D, fD = discriminant_group(Lf)

    gensD = try
        collect(gens(D))
    catch
        collect(D)
    end

    return all(fD(x) == x for x in gensD)
end

# The first fitting isometry is an admissible witness if it is already stable,
# or if the cubic-fourfold index-two criterion |disc(S)| = 3|disc(T)| applies.
# In the second case the witness is refined only after the root and
# symplectic-saturatedness tests have succeeded.

function keep_first_fitting_extension(S::ZZLat, T::ZZLat, Lf::ZZLatWithIsom)
    return trivial_action_on_discriminant(Lf) || disc_S_equals_3disc_T(S, T)
end

# Apply an automorphism-group element to an element of a finite quadratic
# module.  AutomorphismGroupElem objects are callable in the tested OSCAR
# version.  The fallback keeps the helper usable if the action interface is
# exposed only through ^ in a later version.

function _apply_torquad_automorphism(g, x)
    try
        return g(x)
    catch
        return x^g
    end
end

# Return the image in A_S of the glue subgroup H_S and the residual subgroup
# R = H_S^perp.  In the index-two case H_T = A_T and |R| = 3.
#
# The residual subgroup is represented as a list of elements rather than as a
# new TorQuadModule object.  This avoids changing parents and keeps all action
# tests inside the discriminant group returned by glue_map.

function index_two_glue_data(
    L::ZZLat,
    S::ZZLat,
    T::ZZLat,
)
    gamma, iHS, iHT = glue_map(L, S, T)

    HS = domain(iHS)
    HT = domain(iHT)
    AS = codomain(iHS)
    AT = codomain(iHT)

    @req order(HT) == order(AT) "Expected the T-side glue subgroup to be all of A_T"
    @req is_bijective(gamma) "Expected the glue map to be bijective"

    H_gens = [iHS(x) for x in collect(gens(HS))]

    R_elems = [
        x for x in collect(AS)
        if all(iszero(inner_product(x, h)) for h in H_gens)
    ]

    @req length(R_elems) == 3 "Expected the residual discriminant subgroup to have order 3"
    @req order(HS) * length(R_elems) == order(AS) "Expected A_S = H_S orthogonal-sum R"

    return (
        discriminant_group = AS,
        glue_generators = H_gens,
        residual_elements = R_elems,
    )
end

# Find a lift u in O(S) whose discriminant action is identity on the glue
# subgroup and minus identity on the residual order-three subgroup.
#
# This computation is deliberately performed on the concrete embedded lattice
# S_in_Lambda0.  No matrix group or discriminant representation is shared
# between different outputs.

function index_two_correction_isometry(
    S::ZZLat,
    glue_generators,
    residual_elements,
)
    O_generators = automorphism_group_generators(
        S;
        ambient_representation=false,
    )
    O = matrix_group(O_generators)

    rho = discriminant_representation(
        S,
        O;
        ambient_representation=false,
        full=false,
        check=true,
    )

    for gbar in elements(codomain(rho))
        fixes_glue = all(
            _apply_torquad_automorphism(gbar, h) == h
            for h in glue_generators
        )
        fixes_glue || continue

        negates_residual = all(
            _apply_torquad_automorphism(gbar, r) == -r
            for r in residual_elements
        )
        negates_residual || continue

        u_in_O = preimage(rho, gbar)
        return matrix(u_in_O)
    end

    error("The index-two correction is not in the image of O(S) -> O(q_S)")
end

# Rebuild the same embedded extension with a new ambient isometry.  The
# underlying lattices and their basis matrices are unchanged.

function rebuild_extension_with_ambient_isometry(
    L::ZZLat,
    S::ZZLat,
    T::ZZLat,
    f_ambient,
)
    Lf_new = integer_lattice_with_isometry(
        L,
        f_ambient;
        ambient_representation=true,
        check=true,
    )

    Simg_new = lattice_in_same_ambient_space(
        Lf_new,
        basis_matrix(S);
        check=true,
    )

    Timg_new = lattice_in_same_ambient_space(
        Lf_new,
        basis_matrix(T);
        check=true,
    )

    return Lf_new, Simg_new, Timg_new
end

# Refine a surviving index-two fitting witness.  If the ambient action is
# already stable, the original tuple is returned unchanged.
#
# The correction u is extended by the identity on S_Q^perp = T_Q.  The tested
# constructor integer_lattice_with_isometry(...; ambient_representation=false)
# performs exactly this extension for a non-full-rank lattice.

function refine_surviving_fitting_extension(
    Lf::ZZLatWithIsom,
    Simg::ZZLatWithIsom,
    Timg::ZZLatWithIsom,
)
    trivial_action_on_discriminant(Lf) && return (Lf, Simg, Timg)

    L = lattice(Lf)
    S = lattice(Simg)
    T = lattice(Timg)

    @req disc_S_equals_3disc_T(S, T) "A non-stable witness can only be refined in the index-two case"

    glue_data = index_two_glue_data(L, S, T)
    _, fS_disc = discriminant_group(Simg)

    @req all(
        _apply_torquad_automorphism(fS_disc, r) == -r
        for r in glue_data.residual_elements
    ) "The first fitting isometry does not act as -1 on the residual order-three subgroup"

    u = index_two_correction_isometry(
        S,
        glue_data.glue_generators,
        glue_data.residual_elements,
    )

    Uf = integer_lattice_with_isometry(
        S,
        u;
        ambient_representation=false,
        check=true,
    )
    u_ambient = ambient_isometry(Uf)
    f_ambient = ambient_isometry(Lf)

    # OSCAR stores row-action matrices.  The first product is the expected one.
    # The second candidate is a harmless compatibility fallback; on the
    # discriminant group the two products differ by an element of tilde O(S).
    for candidate in (f_ambient * u_ambient, u_ambient * f_ambient)
        rebuilt = try
            rebuild_extension_with_ambient_isometry(L, S, T, candidate)
        catch
            nothing
        end
        rebuilt === nothing && continue

        Lf_new, Simg_new, Timg_new = rebuilt
        trivial_action_on_discriminant(Lf_new) || continue
        isometry(Timg_new) == isometry(Timg) || continue

        return Lf_new, Simg_new, Timg_new
    end

    error("Failed to rebuild the stable ambient extension after the index-two correction")
end

# Enumerate equivariant primitive extensions of S and (T, f_T) into a lattice of
# absolute discriminant 3.  Only one fitting S-side isometry is retained for
# each primitive-extension class.
#
# At this stage the index-two criterion is used only as an existence criterion.
# The actual stable fitting representative is constructed later, and only for
# extensions that survive the root and symplectic-saturatedness tests.

function equivariant_extensions_stable_discriminant(
    S::ZZLat,
    Tf::ZZLatWithIsom;
    plain_context=nothing,
)
    T = lattice(Tf)
    glue_order = glue_order_to_disc3(S, T)

    ok, exts = equivariant_primitive_extensions_issue6071(
        S,
        Tf;
        glue_order=[glue_order],
        even=true,
        classification=:subsub,
        compute_bar_Gf=false,
        first_fitting_isometry=true,
        plain_context=plain_context,
    )

    ok || return []

    good = []

    for (Lf, Simg, Timg) in exts
        # Fail early if the wrapper ever returns embedded factors in the wrong
        # order; otherwise the Phi_m-kernel would be taken on S.
        @req rank(lattice(Simg)) == rank(S) "First image is not the S-side"
        @req rank(lattice(Timg)) == rank(T) "Second image is not the T-side"
        @req absdisc_int(lattice(Simg)) == absdisc_int(S) "First image has the wrong discriminant"
        @req absdisc_int(lattice(Timg)) == absdisc_int(T) "Second image has the wrong discriminant"

        keep_first_fitting_extension(S, T, Lf) || continue
        push!(good, (Lf, Simg, Timg))
    end

    return good
end

# Compatibility aliases.

function equivariant_extensions_first_fitting(
    S::ZZLat,
    Tf::ZZLatWithIsom;
    kwargs...,
)
    return equivariant_extensions_stable_discriminant(S, Tf; kwargs...)
end

function equivariant_extensions_trivial_discriminant(
    S::ZZLat,
    Tf::ZZLatWithIsom;
    kwargs...,
)
    return equivariant_extensions_stable_discriminant(S, Tf; kwargs...)
end

# Compute |tilde O(L)| = |ker(O(L) -> O(q_L))| from the full orthogonal group and
# its discriminant image.
# Limitation: O(L) must be finite in the computational sense used here.  The
# function permits definite lattices and the existing rank-at-most-2 fallback;
# full orthogonal-group computation can be expensive even when finite.

function discriminant_kernel_order(L::ZZLat)
    rank(L) == 0 && return ZZ(1)

    @req is_definite(L) || rank(L) <= 2 """
    Expected O(L) to be finite. In this workflow L should be positive definite.
    """

    G = orthogonal_group(L)
    img, _ = image_in_Oq(L)

    return divexact(order(G), order(img))
end

# A conservative cache key.  Values are reused only when the complete Gram
# matrices agree entry by entry; no isometry test or numerical-invariant
# identification is used.

function gram_matrix_key(L::ZZLat)
    G = gram_matrix(L)
    return Tuple(QQ(G[i, j]) for i in 1:nrows(G) for j in 1:ncols(G))
end

function cached_discriminant_kernel_order!(cache::Dict, L::ZZLat)
    key = gram_matrix_key(L)
    return get!(cache, key) do
        discriminant_kernel_order(L)
    end
end

# Compute the period-domain dimension used in the article:
# rank(P)/phi(m)-2 for m=1,2 and rank(P)/phi(m)-1 for m>=3.
# The caller must ensure that P is the relevant Phi_m-kernel and that rank(P) is
# divisible by phi(m); div is intentionally used without an extra check.

function period_dimension(P::ZZLat, m::Int)
    phi = Int(euler_phi(m))

    if m == 1 || m == 2
        return div(rank(P), phi) - 2
    else
        return div(rank(P), phi) - 1
    end
end

# Construct P = ker(Phi_m(f_T)) and K = P^perp inside Lambda0.  This helper is
# used both before refinement and when the same objects are rebuilt in the new
# ZZLatWithIsom ambient context after refinement.

function embedded_PK_data(
    Lf::ZZLatWithIsom,
    Timg::ZZLatWithIsom,
    m::Int,
)
    P_f = phi_kernel(Timg, m)
    P = lattice(P_f)
    K = orthogonal_submodule(lattice(Lf), basis_matrix(P))

    return (
        P_with_isometry=P_f,
        P_lattice=P,
        K_lattice=K,
    )
end

# For one embedded extension, form P = ker(Phi_m(f_T)) and K = P^perp in
# Lambda0, reject the cubic-fourfold root obstruction, and apply the condition
# |tilde O(K)| = |tilde O(S)| from the symplectic-saturatedness criterion.
#
# The optional ordS is computed once from the fixed input S.  It is only a
# numerical value and is safe to reuse for all embedded copies of S.

function lattice_data_after_root_and_symplectic_tests(
    S::ZZLat,
    Lf::ZZLatWithIsom,
    Simg::ZZLatWithIsom,
    Timg::ZZLatWithIsom,
    m::Int;
    ordS=nothing,
    k_order_cache=nothing,
)
    Lambda0 = lattice(Lf)
    pk = embedded_PK_data(Lf, Timg, m)
    P_f = pk.P_with_isometry
    P = pk.P_lattice
    K = pk.K_lattice

    # Exclude both short and long roots from K.
    if has_root(K, Lambda0)
        return (
            ok=false,
            reason=:root_obstruction,
            P_with_isometry=P_f,
            P_lattice=P,
            K_lattice=K,
        )
    end

    # Equal rank triggers the workflow-specific automatic equality case.
    if rank(K) == rank(S)
        return (
            ok=true,
            reason=:automatic_equal_rank,
            P_with_isometry=P_f,
            P_lattice=P,
            K_lattice=K,
        )
    end

    ordS_value = ordS === nothing ? discriminant_kernel_order(S) : ordS
    ordK = k_order_cache === nothing ?
        discriminant_kernel_order(K) :
        cached_discriminant_kernel_order!(k_order_cache, K)

    return (
        ok=(ordK == ordS_value),
        reason=(ordK == ordS_value ? :tildeO_orders_match : :tildeO_orders_mismatch),
        P_with_isometry=P_f,
        P_lattice=P,
        K_lattice=K,
    )
end

# Compatibility wrapper returning the full named tuple.

function passes_root_and_symplectic_test(
    S::ZZLat,
    Lf::ZZLatWithIsom,
    Simg::ZZLatWithIsom,
    Timg::ZZLatWithIsom,
    m::Int;
    kwargs...,
)
    return lattice_data_after_root_and_symplectic_tests(
        S,
        Lf,
        Simg,
        Timg,
        m;
        kwargs...,
    )
end

# Compute the article's calL(S,T,f_T) data for one fixed conjugacy-class
# representative f_T.
#
# The expensive index-two refinement is deliberately delayed until the
# extension has passed the root and symplectic-saturatedness tests.  Refinement
# does not change the underlying lattices L, S, T, P, or K, but P and K are
# rebuilt afterwards so that all returned objects belong to the new ambient
# ZZLatWithIsom context.

function lattice_data_for_T_action(
    S::ZZLat,
    Tf::ZZLatWithIsom,
    m::Int;
    plain_context=nothing,
    ordS=nothing,
    k_order_cache=nothing,
)
    data = []

    extensions = equivariant_extensions_stable_discriminant(
        S,
        Tf;
        plain_context=plain_context,
    )

    for (Lf, Simg, Timg) in extensions
        test = lattice_data_after_root_and_symplectic_tests(
            S,
            Lf,
            Simg,
            Timg,
            m;
            ordS=ordS,
            k_order_cache=k_order_cache,
        )
        test.ok || continue

        # Only surviving extensions pay for the concrete correction on their
        # embedded S-side.
        Lf_st, Simg_st, Timg_st = refine_surviving_fitting_extension(
            Lf,
            Simg,
            Timg,
        )

        if Lf_st === Lf
            P_f = test.P_with_isometry
            P = test.P_lattice
            K = test.K_lattice
        else
            pk_st = embedded_PK_data(Lf_st, Timg_st, m)
            P_f = pk_st.P_with_isometry
            P = pk_st.P_lattice
            K = pk_st.K_lattice

            @req rank(P) == rank(test.P_lattice) "The rank of P changed during refinement"
            @req rank(K) == rank(test.K_lattice) "The rank of K changed during refinement"
            @req period_dimension(P, m) == period_dimension(test.P_lattice, m) "The period dimension changed during refinement"
        end

        d = period_dimension(P, m)

        push!(
            data,
            (
                order=m,
                dimension=d,
                S_in_Lambda0=Simg_st,
                T_in_Lambda0=Timg_st,
                T_action=Tf,
                K_in_Lambda0=K,
                P_in_Lambda0=P,
                P_action=P_f,
                Lambda0=Lf_st,
            )
        )
    end

    return data
end

# Return a proper divisor of m that belongs to the supplied order list and has
# already been proved to have empty output.  If no such divisor exists, return
# nothing.

function empty_proper_divisor(
    m::Int,
    order_set::Set{Int},
    results_by_order::Dict{Int, Vector{Any}},
)
    for d in sort(collect(order_set))
        d < m || continue
        m % d == 0 || continue
        haskey(results_by_order, d) || continue
        isempty(results_by_order[d]) && return d
    end

    return nothing
end

# Run the search over the caller-supplied candidate orders.  Each output record
# has the previous NamedTuple fields, followed by group_gap_id.
#
# The value of group_gap_id is:
#   * a pair (order, id) when GAP's SmallGroups identification is available and
#     the generated group has order at most 2000;
#   * otherwise a descriptive string containing the group order and, when GAP
#     can compute it, StructureDescription.
#
# Safe optimizations:
#   * the fixed plain input S supplies one reusable primitive-extension context;
#   * |tilde O(S)| is computed once;
#   * an order m is skipped if a proper divisor d in the same supplied list has
#     already produced no prescribed-action datum;
#   * phi(m) > rank(T) is rejected before conjugacy-class enumeration;
#   * |tilde O(K)| is cached only for literally identical Gram matrices;
#   * index-two refinement is applied only to surviving extensions.

function cubic_fourfold_search(
    S::ZZLat,
    T::ZZLat,
    orders::Vector{Int};
    prune_empty_divisors::Bool=true,
    verbose::Bool=false,
)
    @req all(m -> m > 0, orders) "Candidate orders must be positive"

    unique_orders = sort(unique(orders))
    order_set = Set(unique_orders)
    results_by_order = Dict{Int, Vector{Any}}()

    plain_context = nothing
    ordS = nothing
    k_order_cache = Dict{Any, Any}()

    for m in unique_orders
        if Int(euler_phi(m)) > rank(T)
            verbose && println("Skipping order $m: phi($m) > rank(T).")
            results_by_order[m] = Any[]
            continue
        end

        if prune_empty_divisors
            d = empty_proper_divisor(m, order_set, results_by_order)
            if d !== nothing
                verbose && println("Skipping order $m: proper divisor $d in the supplied list has empty output.")
                results_by_order[m] = Any[]
                continue
            end
        end

        # Construct the fixed-S context only when an order actually reaches the
        # primitive-extension stage.
        if plain_context === nothing
            plain_context = plain_side_extension_context(S)
            ordS = plain_context.tilde_order
        end

        order_results = Any[]

        for Tf in enumerate_T_actions(T, m)
            data_for_Tf = lattice_data_for_T_action(
                S,
                Tf,
                m;
                plain_context=plain_context,
                ordS=ordS,
                k_order_cache=k_order_cache,
            )
            number_of_data = length(data_for_Tf)

            for datum in data_for_Tf
                group_gap_id = practical_group_gap_id(
                    datum.S_in_Lambda0;
                    verbose=false,
                )

                verbose && println(
                    "Order $(datum.order), group identifier: $group_gap_id"
                )

                push!(
                    order_results,
                    (
                        order=datum.order,
                        dimension=datum.dimension,
                        number_of_data=number_of_data,
                        S_in_Lambda0=datum.S_in_Lambda0,
                        T_in_Lambda0=datum.T_in_Lambda0,
                        T_action=datum.T_action,
                        K_in_Lambda0=datum.K_in_Lambda0,
                        P_in_Lambda0=datum.P_in_Lambda0,
                        P_action=datum.P_action,
                        Lambda0=datum.Lambda0,
                        group_gap_id=group_gap_id,
                    )
                )
            end
        end

        results_by_order[m] = order_results
    end

    # Preserve the order supplied by the caller.  Repeated entries in orders
    # reproduce the corresponding output, matching the old loop semantics.
    results = Any[]
    for m in orders
        append!(results, results_by_order[m])
    end

    return results
end

# Return a practical identifier for <tilde O(S), f>.
#
# The function deliberately returns only the information used in the final
# search output.  It does not return O(S), tilde O(S), embeddings, or the
# discriminant representation.
#
# Return value:
#   * (n, i) if |<tilde O(S), f>| <= small_group_bound and GAP's SmallGroups
#     identification is available;
#   * otherwise a string containing the order and StructureDescription;
#   * if StructureDescription is unavailable or fails, a clear diagnostic
#     string containing the order.

function practical_group_gap_id(
    Sf::ZZLatWithIsom;
    small_group_bound::Int=2000,
    verbose::Bool=false,
)
    S = lattice(Sf)
    f = isometry(Sf)

    @req is_definite(S) "The underlying lattice S must be definite"
    @req is_integral(S) "The underlying lattice S must be integral"
    @req small_group_bound >= 1 "small_group_bound must be positive"

    # Work in lattice-basis coordinates, matching isometry(Sf).
    O_generators = automorphism_group_generators(
        S;
        ambient_representation=false,
    )
    O = matrix_group(O_generators)
    f_in_O = O(f)

    rho = discriminant_representation(
        S,
        O;
        ambient_representation=false,
        full=false,
        check=true,
    )

    tildeO, i_tildeO = kernel(rho)
    generators_in_O = [i_tildeO(g) for g in gens(tildeO)]
    push!(generators_in_O, f_in_O)

    H, _ = sub(O, generators_in_O)
    n = order(H)

    result = if n <= small_group_bound && has_small_group_identification(n)
        small_group_identification(H)
    else
        description = try
            gap_description = GAP.Globals.StructureDescription(GapObj(H))
            GAP.gap_to_julia(String, gap_description)
        catch
            try
                describe(H)
            catch
                nothing
            end
        end

        if description === nothing || isempty(strip(description))
            if n > small_group_bound
                "order $n > $small_group_bound; StructureDescription unavailable"
            else
                "order $n; SmallGroup identification and StructureDescription unavailable"
            end
        elseif n > small_group_bound
            "order $n; StructureDescription = $description"
        else
            "order $n; SmallGroup identification unavailable; StructureDescription = $description"
        end
    end

    if verbose
        println("|<tilde O(S), f>| = ", n)
        println("group_gap_id       = ", result)
    end

    return result
end

# Backward-compatible name.  Unlike the earlier version, this now returns only
# the practical identifier stored in cubic_fourfold_search.

function tilde_and_isometry_gap_ids(
    Sf::ZZLatWithIsom;
    small_group_bound::Int=2000,
    verbose::Bool=true,
)
    return practical_group_gap_id(
        Sf;
        small_group_bound=small_group_bound,
        verbose=verbose,
    )
end

function cubic_fourfold_search(L)
    return cubic_fourfold_search(L[1],L[2],L[3])
end
