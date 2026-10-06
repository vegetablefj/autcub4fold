# Reconstruct the full No. 36 integral action from OSCAR case 15, result 2.
# `source-check` reads the frozen result but does not compute O(S). Only
# `prepare` computes the stable kernel and its fresh rank-22 extensions.
# No No. 38 matrices or kernel cache are assumed or reused.

using SHA
include(joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))

const no36_source = joinpath(@__DIR__, "..", "..", "oscar", "oscar_script_data.mrdi")
const no36_source_sha256 =
    "c5278c3aeb5b2f7ed3574030d75d48680bba276302e035603531fa701bcf976b"
const no36_cache = joinpath(@__DIR__, "source_36_full_lattice_group.mrdi")

no36_note(s) = (println(s); flush(stdout))
no36_hash(path) = bytes2hex(sha256(read(path)))

function no36_hashes()
    paths = (no36_source, @__FILE__,
             joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))
    all(isfile, paths) || error("A No. 36 preparation input is missing")
    hashes = Tuple((basename(path), no36_hash(path)) for path in paths)
    hashes[1][2] == no36_source_sha256 || error("Frozen OSCAR source changed")
    return hashes
end

function no36_source_check()
    hashes = no36_hashes()
    source = load(no36_source)
    @assert source.format_version == 3 && source.completed_cases == 29
    case = source.cases[15]
    @assert case.case_index == 15 && case.number_of_results == 2
    # The other output has (216,157) and belongs to No. 38. Distinguish
    # by the full group, not by the shared S33 generic input alone.
    @assert case.results[1].group_gap_id == (216, 157)
    parent = case.results[2]
    @assert parent.order == 6 && parent.dimension == 1
    @assert parent.group_gap_id == (216, 170)
    @assert parent.number_of_data == 2

    L = lattice(parent.Lambda0)
    S = lattice(parent.S_in_Lambda0)
    T = lattice(parent.T_in_Lambda0)
    @assert rank(L) == 22 && rank(S) == 18 && rank(T) == 4
    @assert signature_tuple(L) == (20, 0, 2)
    @assert signature_tuple(S) == (18, 0, 0)
    @assert signature_tuple(T) == (2, 0, 2)
    @assert abs(det(gram_matrix(L))) == 3
    @assert order_of_isometry(parent.T_action) == 6
    @assert order_of_isometry(parent.T_in_Lambda0) == 6

    E = basis_matrix(S) * inv(basis_matrix(L))
    C = basis_matrix(T) * inv(basis_matrix(L))
    @assert isometry(parent.S_in_Lambda0) * E ==
            E * isometry(parent.Lambda0)
    @assert isometry(parent.T_in_Lambda0) * C ==
            C * isometry(parent.Lambda0)
    no36_note("Checked case 15 result 2 = No. 36 by full group (216,170); source SHA-256 $(hashes[1][2])")
    return (; parent, L, S, T, hashes)
end

function no36_extension_id(ctx)
    # Left regular action of the exact extension N.<f>, |N|=36, f^6=c.
    q = 6
    n = 36
    phi_powers = [collect(1:n)]
    for _ in 1:q-1
        push!(phi_powers, [ctx.phi[phi_powers[end][i]] for i in 1:n])
    end
    idx(a, k) = a + n*k
    function mulpair(i, j)
        a, k = mod1(i, n), div(i-1, n)
        b, l = mod1(j, n), div(j-1, n)
        product = ctx.mul(a, phi_powers[k+1][b])
        if k+l >= q
            product = ctx.mul(product, ctx.c)
        end
        return idx(product, mod(k+l, q))
    end
    gens = [ctx.generator_ids; idx(1, 1)]
    perms = [GAP.Globals.PermList(GapObj([mulpair(g, i)
                  for i in 1:n*q])) for g in gens]
    G = GAP.Globals.Group(perms...)
    @assert Int(GAP.Globals.Size(G)) == 216
    id = GAP.Globals.IdGroup(G)
    return (Int(id[1]), Int(id[2]))
end

function no36_check_relations(p, generators_S, generators_L)
    @assert !isempty(generators_S)
    @assert length(generators_S) == length(generators_L)
    E = basis_matrix(p.S) * inv(basis_matrix(p.L))
    C = basis_matrix(p.T) * inv(basis_matrix(p.L))
    fS = isometry(p.parent.S_in_Lambda0)
    fL = isometry(p.parent.Lambda0)
    ctx = direct_context(generators_S, fS, 36, 6)
    @assert no36_extension_id(ctx) == (216, 170)
    eL = identity_matrix(QQ, 22)
    nL = [foldl(*, (generators_L[j] for j in ctx.words[i]); init=eL)
          for i in 1:36]
    @assert all(generators_S[j] * E == E * generators_L[j]
                for j in eachindex(generators_S))
    @assert all(C * generators_L[j] == C for j in eachindex(generators_L))
    @assert all(ctx.elements[i] * E == E * nL[i] for i in 1:36)
    @assert all(C * nL[i] == C for i in 1:36)
    @assert fL^6 == nL[ctx.c]
    @assert all(fL * nL[i] * inv(fL) == nL[ctx.phi[i]] for i in 1:36)
    @assert length(Set(direct_matrix_key(ctx.elements[i] * fS^k)
                       for k in 0:5 for i in 1:36)) == 216
    @assert length(Set(direct_matrix_key(nL[i] * fL^k)
                       for k in 0:5 for i in 1:36)) == 216
    for uL in generators_L
        integer_lattice_with_isometry(p.L, uL;
            ambient_representation=false, check=true)
    end
    return nothing
end

function no36_verify_cache(path=no36_cache)
    isfile(path) || error("Missing No. 36 cache: $path")
    p = no36_source_check()
    cache = load(path)
    @assert cache.format_version == 1 && cache.parent_number == 36
    @assert cache.source == "oscar/oscar_script_data.mrdi case 15 result 2"
    @assert cache.source_sha256 == no36_source_sha256
    @assert cache.prepare_hashes == p.hashes
    @assert cache.symplectic_order == 36 && cache.quotient_order == 6
    @assert cache.full_group_order == 216
    @assert cache.full_group_id_from_saved_search == (216, 170)
    @assert cache.full_group_id_independent == (216, 170)
    @assert basis_matrix(lattice(cache.Lambda0)) == basis_matrix(p.L)
    @assert gram_matrix(lattice(cache.Lambda0)) == gram_matrix(p.L)
    @assert isometry(cache.Lambda0) == isometry(p.parent.Lambda0)
    @assert basis_matrix(lattice(cache.S_in_Lambda0)) == basis_matrix(p.S)
    @assert basis_matrix(lattice(cache.T_in_Lambda0)) == basis_matrix(p.T)
    @assert isometry(cache.S_in_Lambda0) ==
            isometry(p.parent.S_in_Lambda0)
    @assert isometry(cache.T_in_Lambda0) ==
            isometry(p.parent.T_in_Lambda0)
    @assert cache.extra_generator == isometry(p.parent.Lambda0)
    @assert cache.extra_generator_S == isometry(p.parent.S_in_Lambda0)
    no36_check_relations(p, cache.symplectic_generators_S,
                         cache.symplectic_generators)
    no36_note("Verified No. 36 cache: kernel order 36, quotient order 6, full order 216, ID (216,170)")
    return cache
end

function no36_prepare(output=no36_cache)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output), ".mrdi") || error("Cache path must end in .mrdi")
    p = no36_source_check()
    E = basis_matrix(p.S) * inv(basis_matrix(p.L))
    C = basis_matrix(p.T) * inv(basis_matrix(p.L))
    fS = isometry(p.parent.S_in_Lambda0)
    fL = isometry(p.parent.Lambda0)

    no36_note("Computing O(S) and its stable discriminant kernel for No. 36")
    O = matrix_group(automorphism_group_generators(p.S;
        ambient_representation=false))
    rho = discriminant_representation(p.S, O;
        ambient_representation=false, full=false, check=true)
    N, inclusion = kernel(rho)
    @assert Int(order(N)) == 36
    no36_note("Computed the stable kernel; order = 36")

    generators_S = typeof(fS)[]
    generators_L = typeof(fL)[]
    for u in gens(N)
        uS = matrix(inclusion(u))
        Su = integer_lattice_with_isometry(p.S, uS;
            ambient_representation=false, check=true)
        Lu = integer_lattice_with_isometry(p.L, ambient_isometry(Su);
            ambient_representation=true, check=true)
        uL = isometry(Lu)
        @assert uS * E == E * uL
        @assert C * uL == C
        push!(generators_S, uS)
        push!(generators_L, uL)
    end
    no36_note("Extended $(length(generators_L)) kernel generators to rank 22")
    N = nothing; inclusion = nothing; rho = nothing; O = nothing
    GC.gc(true)
    no36_check_relations(p, generators_S, generators_L)
    no36_note("Checked the exact order-216 extension and independent GAP ID")

    save(output, (
        format_version=1,
        parent_number=36,
        source="oscar/oscar_script_data.mrdi case 15 result 2",
        source_sha256=no36_source_sha256,
        prepare_hashes=p.hashes,
        Lambda0=p.parent.Lambda0,
        S_in_Lambda0=p.parent.S_in_Lambda0,
        T_in_Lambda0=p.parent.T_in_Lambda0,
        symplectic_generators=generators_L,
        symplectic_generators_S=generators_S,
        extra_generator=fL,
        extra_generator_S=fS,
        symplectic_order=36,
        quotient_order=6,
        full_group_order=216,
        full_group_id_from_saved_search=(216, 170),
        full_group_id_independent=(216, 170),
        order_proof="stable kernel order 36; quotient order 6; exact 18- and 22-dimensional relations; independent regular-action SmallGroup ID",
    ))
    no36_verify_cache(output)
    no36_note("Saved and reloaded $output")
end

function no36_main()
    isempty(ARGS) && error("Choose source-check, prepare, or verify-cache")
    stage = ARGS[1]
    if stage == "source-check"
        length(ARGS) == 1 || error("source-check takes no arguments")
        no36_source_check()
    elseif stage == "prepare"
        length(ARGS) <= 2 || error("prepare [cache.mrdi]")
        no36_prepare(length(ARGS) == 2 ? abspath(ARGS[2]) : no36_cache)
    elseif stage == "verify-cache"
        length(ARGS) <= 2 || error("verify-cache [cache.mrdi]")
        no36_verify_cache(length(ARGS) == 2 ? abspath(ARGS[2]) : no36_cache)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    no36_main()
end
