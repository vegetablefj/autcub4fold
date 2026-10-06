# Reconstruct the full No. 60 action from the saved case-24 result.
# `source-check` and `verify-cache` do not enumerate O(S). Only `prepare` does.
# No stage runs when this file is included by another script.

using SHA
include(joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))

const no60_source = joinpath(@__DIR__, "..", "..", "oscar", "oscar_script_data.mrdi")
const no60_source_sha256 =
    "c5278c3aeb5b2f7ed3574030d75d48680bba276302e035603531fa701bcf976b"
const no60_cache = joinpath(@__DIR__, "source_60_full_lattice_group.mrdi")

no60_note(s) = (println(s); flush(stdout))
no60_hash(path) = bytes2hex(sha256(read(path)))

function no60_hashes()
    paths = (no60_source, @__FILE__,
             joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))
    all(isfile, paths) || error("A No. 60 preparation input is missing")
    hashes = Tuple((basename(path), no60_hash(path)) for path in paths)
    hashes[1][2] == no60_source_sha256 || error("Frozen OSCAR source changed")
    return hashes
end

function no60_source_check()
    hashes = no60_hashes()
    source = load(no60_source)
    @assert source.format_version == 3 && source.completed_cases == 29
    case = source.cases[24]
    @assert case.case_index == 24 && case.number_of_results == 4
    parent = case.results[1]
    @assert parent.order == 2 && parent.dimension == 2
    @assert parent.group_gap_id == (24, 14)
    @assert parent.number_of_data == 1

    L = lattice(parent.Lambda0)
    S = lattice(parent.S_in_Lambda0)
    T = lattice(parent.T_in_Lambda0)
    @assert rank(L) == 22 && rank(S) == 16 && rank(T) == 6
    @assert signature_tuple(L) == (20, 0, 2)
    @assert signature_tuple(S) == (16, 0, 0)
    @assert signature_tuple(T) == (4, 0, 2)
    @assert abs(det(gram_matrix(L))) == 3
    @assert order_of_isometry(parent.T_action) == 2
    @assert isometry(parent.S_in_Lambda0) *
            (basis_matrix(S) * inv(basis_matrix(L))) ==
            (basis_matrix(S) * inv(basis_matrix(L))) *
            isometry(parent.Lambda0)
    no60_note("Checked frozen OSCAR case 24 result 1 = No. 60; source SHA-256 $(hashes[1][2])")
    return (; parent, L, S, T, hashes)
end

# Check the 12-element stable kernel and its quotient-two extension using
# 16-dimensional matrices. Avoid a rank-22 matrix-group order computation.
function no60_check_relations(p, generators_S, generators_L)
    @assert !isempty(generators_S)
    @assert length(generators_S) == length(generators_L)
    E = basis_matrix(p.S) * inv(basis_matrix(p.L))
    C = basis_matrix(p.T) * inv(basis_matrix(p.L))
    fS = isometry(p.parent.S_in_Lambda0)
    fL = isometry(p.parent.Lambda0)
    ctx = direct_context(generators_S, fS, 12, 2)
    eL = identity_matrix(QQ, 22)
    nL = [foldl(*, (generators_L[j] for j in ctx.words[n]); init=eL)
          for n in 1:12]
    @assert all(ctx.elements[n] * E == E * nL[n] for n in 1:12)
    @assert all(C * nL[n] == C for n in 1:12)
    @assert fL^2 == nL[ctx.c]
    @assert all(fL * nL[n] * inv(fL) == nL[ctx.phi[n]] for n in 1:12)
    @assert length(Set(direct_matrix_key(nL[n] * fL^k)
                       for k in 0:1 for n in 1:12)) == 24
    return nothing
end

function no60_verify_cache(path=no60_cache)
    isfile(path) || error("Missing No. 60 cache: $path")
    p = no60_source_check()
    cache = load(path)
    @assert cache.format_version == 1 && cache.parent_number == 60
    @assert cache.source == "oscar/oscar_script_data.mrdi case 24 result 1"
    @assert cache.source_sha256 == no60_source_sha256
    @assert cache.prepare_hashes == p.hashes
    @assert cache.symplectic_order == 12 && cache.quotient_order == 2
    @assert cache.full_group_order == 24
    @assert cache.full_group_id_from_saved_search == (24, 14)
    @assert basis_matrix(lattice(cache.Lambda0)) == basis_matrix(p.L)
    @assert gram_matrix(lattice(cache.Lambda0)) == gram_matrix(p.L)
    @assert isometry(cache.Lambda0) == isometry(p.parent.Lambda0)
    @assert basis_matrix(lattice(cache.S_in_Lambda0)) == basis_matrix(p.S)
    @assert isometry(cache.S_in_Lambda0) == isometry(p.parent.S_in_Lambda0)
    no60_check_relations(p, cache.symplectic_generators_S,
                        cache.symplectic_generators)
    no60_note("Verified saved No. 60 cache: kernel order 12, quotient order 2, full order 24")
    return cache
end

function no60_prepare(output=no60_cache)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output), ".mrdi") || error("Cache path must end in .mrdi")
    p = no60_source_check()
    E = basis_matrix(p.S) * inv(basis_matrix(p.L))
    C = basis_matrix(p.T) * inv(basis_matrix(p.L))
    fS = isometry(p.parent.S_in_Lambda0)
    fL = isometry(p.parent.Lambda0)

    no60_note("Computing O(S) and its discriminant kernel for No. 60")
    O = matrix_group(automorphism_group_generators(p.S;
        ambient_representation=false))
    rho = discriminant_representation(p.S, O;
        ambient_representation=false, full=false, check=true)
    N, inclusion = kernel(rho)
    @assert Int(order(N)) == 12
    no60_note("Computed the stable discriminant kernel; order = 12")

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
    no60_note("Extended $(length(generators_L)) kernel generators to rank 22")

    # The group and discriminant objects are no longer needed for the finite
    # relation check or serialization.
    N = nothing; inclusion = nothing; rho = nothing; O = nothing
    GC.gc(true)
    no60_check_relations(p, generators_S, generators_L)
    no60_note("Checked exact order-24 extension in the saved ambient lattice")

    save(output, (
        format_version=1,
        parent_number=60,
        source="oscar/oscar_script_data.mrdi case 24 result 1",
        source_sha256=no60_source_sha256,
        prepare_hashes=p.hashes,
        Lambda0=p.parent.Lambda0,
        S_in_Lambda0=p.parent.S_in_Lambda0,
        symplectic_generators=generators_L,
        symplectic_generators_S=generators_S,
        extra_generator=fL,
        extra_generator_S=fS,
        symplectic_order=12,
        quotient_order=2,
        full_group_order=24,
        full_group_id_from_saved_search=(24, 14),
        order_proof="kernel order 12; T action and quotient order 2; exact 16- and 22-dimensional relations checked",
    ))
    no60_verify_cache(output)
    no60_note("Saved and reloaded $output")
end

function no60_main()
    isempty(ARGS) && error("Choose source-check, prepare, or verify-cache")
    stage = ARGS[1]
    if stage == "source-check"
        length(ARGS) == 1 || error("source-check takes no arguments")
        no60_source_check()
    elseif stage == "prepare"
        length(ARGS) <= 2 || error("prepare [cache.mrdi]")
        no60_prepare(length(ARGS) == 2 ? abspath(ARGS[2]) : no60_cache)
    elseif stage == "verify-cache"
        length(ARGS) <= 2 || error("verify-cache [cache.mrdi]")
        no60_verify_cache(length(ARGS) == 2 ? abspath(ARGS[2]) : no60_cache)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    no60_main()
end
