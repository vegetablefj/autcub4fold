# Reconstruct the full No. 28 integral action from frozen OSCAR case 10,
# result 1. `source-check` reads but does not compute O(S); only `prepare`
# computes the stable discriminant kernel. No stage runs on include.

using SHA
include(joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))

const no28_source = joinpath(@__DIR__, "..", "..", "oscar", "oscar_script_data.mrdi")
const no28_source_sha256 =
    "c5278c3aeb5b2f7ed3574030d75d48680bba276302e035603531fa701bcf976b"
const no28_cache = joinpath(@__DIR__, "source_28_full_lattice_group.mrdi")

no28_note(s) = (println(s); flush(stdout))
no28_hash(path) = bytes2hex(sha256(read(path)))

function no28_hashes()
    paths = (no28_source, @__FILE__,
             joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))
    all(isfile, paths) || error("A No. 28 preparation input is missing")
    hashes = Tuple((basename(path), no28_hash(path)) for path in paths)
    hashes[1][2] == no28_source_sha256 || error("Frozen OSCAR source changed")
    return hashes
end

function no28_source_check()
    hashes = no28_hashes()
    source = load(no28_source)
    @assert source.format_version == 3 && source.completed_cases == 29
    case = source.cases[10]
    @assert case.case_index == 10 && case.number_of_results == 1
    parent = case.results[1]
    @assert parent.order == 6 && parent.dimension == 1
    @assert parent.group_gap_id == (432, 745)
    @assert parent.number_of_data == 1

    L = lattice(parent.Lambda0)
    S = lattice(parent.S_in_Lambda0)
    T = lattice(parent.T_in_Lambda0)
    @assert rank(L) == 22 && rank(S) == 18 && rank(T) == 4
    @assert signature_tuple(L) == (20, 0, 2)
    @assert signature_tuple(S) == (18, 0, 0)
    @assert signature_tuple(T) == (2, 0, 2)
    @assert abs(det(gram_matrix(L))) == 3
    @assert order_of_isometry(parent.T_action) == 6
    E = basis_matrix(S) * inv(basis_matrix(L))
    C = basis_matrix(T) * inv(basis_matrix(L))
    fS = isometry(parent.S_in_Lambda0)
    fT = isometry(parent.T_in_Lambda0)
    fL = isometry(parent.Lambda0)
    @assert fS * E == E * fL
    @assert fT * C == C * fL
    @assert order_of_isometry(parent.T_in_Lambda0) == 6
    no28_note("Checked frozen OSCAR case 10 result 1 = No. 28; source SHA-256 $(hashes[1][2])")
    return (; parent, L, S, T, hashes)
end

function no28_check_relations(p, generators_S, generators_L)
    @assert !isempty(generators_S)
    @assert length(generators_S) == length(generators_L)
    E = basis_matrix(p.S) * inv(basis_matrix(p.L))
    C = basis_matrix(p.T) * inv(basis_matrix(p.L))
    fS = isometry(p.parent.S_in_Lambda0)
    fL = isometry(p.parent.Lambda0)
    ctx = direct_context(generators_S, fS, 72, 6)
    eL = identity_matrix(QQ, 22)
    nL = [foldl(*, (generators_L[j] for j in ctx.words[n]); init=eL)
          for n in 1:72]
    @assert all(generators_S[j] * E == E * generators_L[j]
                for j in eachindex(generators_S))
    @assert all(C * generators_L[j] == C
                for j in eachindex(generators_L))
    @assert all(ctx.elements[n] * E == E * nL[n] for n in 1:72)
    @assert all(C * nL[n] == C for n in 1:72)
    @assert fL^6 == nL[ctx.c]
    @assert all(fL * nL[n] * inv(fL) == nL[ctx.phi[n]]
                for n in 1:72)
    @assert length(Set(direct_matrix_key(nL[n] * fL^k)
                       for k in 0:5 for n in 1:72)) == 432
    for uL in generators_L
        integer_lattice_with_isometry(p.L, uL;
            ambient_representation=false, check=true)
    end
    return nothing
end

function no28_verify_cache(path=no28_cache)
    isfile(path) || error("Missing No. 28 cache: $path")
    p = no28_source_check()
    cache = load(path)
    @assert cache.format_version == 1 && cache.parent_number == 28
    @assert cache.source == "oscar/oscar_script_data.mrdi case 10 result 1"
    @assert cache.source_sha256 == no28_source_sha256
    @assert cache.prepare_hashes == p.hashes
    @assert cache.symplectic_order == 72 && cache.quotient_order == 6
    @assert cache.full_group_order == 432
    @assert cache.full_group_id_from_saved_search == (432, 745)
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
    no28_check_relations(p, cache.symplectic_generators_S,
                         cache.symplectic_generators)
    no28_note("Verified No. 28 cache: kernel order 72, quotient order 6, full order 432")
    return cache
end

function no28_prepare(output=no28_cache)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output), ".mrdi") || error("Cache path must end in .mrdi")
    p = no28_source_check()
    E = basis_matrix(p.S) * inv(basis_matrix(p.L))
    C = basis_matrix(p.T) * inv(basis_matrix(p.L))
    fS = isometry(p.parent.S_in_Lambda0)
    fL = isometry(p.parent.Lambda0)

    no28_note("Computing O(S) and its stable discriminant kernel for No. 28")
    O = matrix_group(automorphism_group_generators(p.S;
        ambient_representation=false))
    rho = discriminant_representation(p.S, O;
        ambient_representation=false, full=false, check=true)
    N, inclusion = kernel(rho)
    @assert Int(order(N)) == 72
    no28_note("Computed the stable kernel; order = 72")

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
    no28_note("Extended $(length(generators_L)) kernel generators to rank 22")
    N = nothing; inclusion = nothing; rho = nothing; O = nothing
    GC.gc(true)
    no28_check_relations(p, generators_S, generators_L)
    no28_note("Checked the exact order-432 extension in the ambient lattice")

    save(output, (
        format_version=1,
        parent_number=28,
        source="oscar/oscar_script_data.mrdi case 10 result 1",
        source_sha256=no28_source_sha256,
        prepare_hashes=p.hashes,
        Lambda0=p.parent.Lambda0,
        S_in_Lambda0=p.parent.S_in_Lambda0,
        T_in_Lambda0=p.parent.T_in_Lambda0,
        symplectic_generators=generators_L,
        symplectic_generators_S=generators_S,
        extra_generator=fL,
        extra_generator_S=fS,
        symplectic_order=72,
        quotient_order=6,
        full_group_order=432,
        full_group_id_from_saved_search=(432, 745),
        order_proof="stable discriminant kernel order 72; quotient order 6; exact 18- and 22-dimensional relations checked",
    ))
    no28_verify_cache(output)
    no28_note("Saved and reloaded $output")
end

function no28_main()
    isempty(ARGS) && error("Choose source-check, prepare, or verify-cache")
    stage = ARGS[1]
    if stage == "source-check"
        length(ARGS) == 1 || error("source-check takes no arguments")
        no28_source_check()
    elseif stage == "prepare"
        length(ARGS) <= 2 || error("prepare [cache.mrdi]")
        no28_prepare(length(ARGS) == 2 ? abspath(ARGS[2]) : no28_cache)
    elseif stage == "verify-cache"
        length(ARGS) <= 2 || error("verify-cache [cache.mrdi]")
        no28_verify_cache(length(ARGS) == 2 ? abspath(ARGS[2]) : no28_cache)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    no28_main()
end
