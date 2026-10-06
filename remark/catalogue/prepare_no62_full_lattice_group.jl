# Reconstruct the full No. 62 action from saved case 24 result 4.
# The stable kernel on S is reused from the independently verified No. 60
# cache. Its 22-dimensional lifts are NOT reused: No. 62 has a different
# ambient lattice and a different T Gram matrix.
# Only `prepare` extends the kernel generators; no stage computes O(S).

using SHA
include(joinpath(@__DIR__, "prepare_no60_full_lattice_group.jl"))

const no62_source = no60_source
const no62_source_sha256 = no60_source_sha256
const no62_cache = joinpath(@__DIR__, "source_62_full_lattice_group.mrdi")

no62_note(s) = (println(s); flush(stdout))
no62_hash(path) = bytes2hex(sha256(read(path)))

function no62_hashes()
    paths = (no62_source, @__FILE__,
             joinpath(@__DIR__, "prepare_no60_full_lattice_group.jl"),
             joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"),
             no60_cache)
    all(isfile, paths) || error("A No. 62 preparation input is missing")
    hashes = Tuple((basename(path), no62_hash(path)) for path in paths)
    hashes[1][2] == no62_source_sha256 || error("Frozen OSCAR source changed")
    return hashes
end

function no62_source_check()
    hashes = no62_hashes()
    kernel_cache = no60_verify_cache(no60_cache)
    source = load(no62_source)
    @assert source.format_version == 3 && source.completed_cases == 29
    case = source.cases[24]
    @assert case.case_index == 24 && case.number_of_results == 4
    parent = case.results[4]
    @assert parent.order == 6 && parent.dimension == 1
    @assert parent.group_gap_id == (72, 30)
    @assert parent.number_of_data == 1

    L = lattice(parent.Lambda0)
    S = lattice(parent.S_in_Lambda0)
    T = lattice(parent.T_in_Lambda0)
    @assert rank(L) == 22 && rank(S) == 16 && rank(T) == 6
    @assert signature_tuple(L) == (20, 0, 2)
    @assert signature_tuple(S) == (16, 0, 0)
    @assert signature_tuple(T) == (4, 0, 2)
    @assert abs(det(gram_matrix(L))) == 3
    @assert order_of_isometry(parent.T_action) == 6

    # Identical matrices for the embedded S basis and its Gram form justify
    # reusing only the 16-dimensional stable-kernel action. The T Gram form
    # and L basis differ, so the old 22-dimensional matrices cannot be copied.
    S60 = lattice(kernel_cache.S_in_Lambda0)
    T60 = lattice(case.results[1].T_in_Lambda0)
    L60 = lattice(kernel_cache.Lambda0)
    @assert basis_matrix(S) == basis_matrix(S60)
    @assert gram_matrix(S) == gram_matrix(S60)
    @assert basis_matrix(T) == basis_matrix(T60)
    @assert gram_matrix(T) != gram_matrix(T60)
    @assert basis_matrix(L) != basis_matrix(L60)

    E = basis_matrix(S) * inv(basis_matrix(L))
    C = basis_matrix(T) * inv(basis_matrix(L))
    @assert isometry(parent.S_in_Lambda0) * E ==
            E * isometry(parent.Lambda0)
    @assert isometry(parent.T_in_Lambda0) * C ==
            C * isometry(parent.Lambda0)
    @assert all(u * gram_matrix(S) * transpose(u) == gram_matrix(S)
                for u in kernel_cache.symplectic_generators_S)
    no62_note("Checked case 24 result 4 = No. 62; shared S, distinct T/L; source SHA-256 $(hashes[1][2])")
    return (; parent, L, S, T, kernel_cache, hashes)
end

function no62_check_relations(p, generators_S, generators_L)
    @assert !isempty(generators_S)
    @assert length(generators_S) == length(generators_L)
    @assert generators_S == p.kernel_cache.symplectic_generators_S
    E = basis_matrix(p.S) * inv(basis_matrix(p.L))
    C = basis_matrix(p.T) * inv(basis_matrix(p.L))
    fS = isometry(p.parent.S_in_Lambda0)
    fL = isometry(p.parent.Lambda0)
    ctx = direct_context(generators_S, fS, 12, 6)
    eL = identity_matrix(QQ, 22)
    nL = [foldl(*, (generators_L[j] for j in ctx.words[n]); init=eL)
          for n in 1:12]
    @assert all(generators_S[j] * E == E * generators_L[j]
                for j in eachindex(generators_S))
    @assert all(C * generators_L[j] == C
                for j in eachindex(generators_L))
    @assert all(ctx.elements[n] * E == E * nL[n] for n in 1:12)
    @assert all(C * nL[n] == C for n in 1:12)
    @assert fL^6 == nL[ctx.c]
    @assert all(fL * nL[n] * inv(fL) == nL[ctx.phi[n]]
                for n in 1:12)
    @assert length(Set(direct_matrix_key(nL[n] * fL^k)
                       for k in 0:5 for n in 1:12)) == 72
    for uL in generators_L
        integer_lattice_with_isometry(p.L, uL;
            ambient_representation=false, check=true)
    end
    return nothing
end

function no62_verify_cache(path=no62_cache)
    isfile(path) || error("Missing No. 62 cache: $path")
    p = no62_source_check()
    cache = load(path)
    @assert cache.format_version == 1 && cache.parent_number == 62
    @assert cache.source == "oscar/oscar_script_data.mrdi case 24 result 4"
    @assert cache.source_sha256 == no62_source_sha256
    @assert cache.kernel_cache_sha256 == no62_hash(no60_cache)
    @assert cache.prepare_hashes == p.hashes
    @assert cache.symplectic_order == 12 && cache.quotient_order == 6
    @assert cache.full_group_order == 72
    @assert cache.full_group_id_from_saved_search == (72, 30)
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
    no62_check_relations(p, cache.symplectic_generators_S,
                        cache.symplectic_generators)
    no62_note("Verified saved No. 62 cache: kernel order 12, quotient order 6, full order 72")
    return cache
end

function no62_prepare(output=no62_cache)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output), ".mrdi") || error("Cache path must end in .mrdi")
    p = no62_source_check()
    E = basis_matrix(p.S) * inv(basis_matrix(p.L))
    C = basis_matrix(p.T) * inv(basis_matrix(p.L))
    fS = isometry(p.parent.S_in_Lambda0)
    fL = isometry(p.parent.Lambda0)
    generators_S = p.kernel_cache.symplectic_generators_S
    generators_L = typeof(fL)[]
    no62_note("Extending $(length(generators_S)) cached S-kernel generators to the No. 62 ambient lattice")
    for uS in generators_S
        Su = integer_lattice_with_isometry(p.S, uS;
            ambient_representation=false, check=true)
        Lu = integer_lattice_with_isometry(p.L, ambient_isometry(Su);
            ambient_representation=true, check=true)
        uL = isometry(Lu)
        @assert uS * E == E * uL
        @assert C * uL == C
        push!(generators_L, uL)
    end
    no62_check_relations(p, generators_S, generators_L)
    no62_note("Checked the exact order-72 extension in the No. 62 ambient lattice")

    save(output, (
        format_version=1,
        parent_number=62,
        source="oscar/oscar_script_data.mrdi case 24 result 4",
        source_sha256=no62_source_sha256,
        kernel_cache_sha256=no62_hash(no60_cache),
        prepare_hashes=p.hashes,
        Lambda0=p.parent.Lambda0,
        S_in_Lambda0=p.parent.S_in_Lambda0,
        T_in_Lambda0=p.parent.T_in_Lambda0,
        symplectic_generators=generators_L,
        symplectic_generators_S=generators_S,
        extra_generator=fL,
        extra_generator_S=fS,
        symplectic_order=12,
        quotient_order=6,
        full_group_order=72,
        full_group_id_from_saved_search=(72, 30),
        order_proof="cached stable kernel order 12; quotient order 6; exact 16- and 22-dimensional relations checked",
    ))
    no62_verify_cache(output)
    no62_note("Saved and reloaded $output")
end

function no62_main()
    isempty(ARGS) && error("Choose source-check, prepare, or verify-cache")
    stage = ARGS[1]
    if stage == "source-check"
        length(ARGS) == 1 || error("source-check takes no arguments")
        no62_source_check()
    elseif stage == "prepare"
        length(ARGS) <= 2 || error("prepare [cache.mrdi]")
        no62_prepare(length(ARGS) == 2 ? abspath(ARGS[2]) : no62_cache)
    elseif stage == "verify-cache"
        length(ARGS) <= 2 || error("verify-cache [cache.mrdi]")
        no62_verify_cache(length(ARGS) == 2 ? abspath(ARGS[2]) : no62_cache)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    no62_main()
end
