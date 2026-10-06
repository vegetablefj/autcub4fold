# Reconstruct the full saved No. 51 lattice group once, then extract the
# unique No. 81 subgroup.  No. 81 changes the symplectic part Q8 -> C4.

include(joinpath(@__DIR__, "restriction_functions.jl"))

const began = time()
function note81(message)
    println(round(time() - began; digits=1), " s | ", message)
    flush(stdout)
end

function subgroup_with_id_and_symplectic_intersection(H, N, wanted_id)
    items = collect(elements(H))
    matches = Any[]
    for a in items, b in items
        B, _ = sub(H, [a, b])
        order(B) == wanted_id[1] || continue
        small_group_identification(B) == wanted_id || continue
        overlap = [x for x in elements(B) if x in N]
        length(overlap) == 4 || continue
        any(x -> order(x) == 4, overlap) || continue
        any(C -> all(x -> x in C, elements(B)), matches) && continue
        push!(matches, B)
    end
    @assert length(matches) == 1 "The expected subgroup is not unique"
    B = only(matches)
    return B, [x for x in elements(B) if x in N]
end

source = load(joinpath(@__DIR__, "..", "..", "oscar", "oscar_script_data.mrdi"))
parent = source.cases[21].results[3]
L = lattice(parent.Lambda0)
S = lattice(parent.S_in_Lambda0)
@assert rank(L) == 22 && rank(S) == 17
note81("Loaded No. 51 parent result")

cache_path = joinpath(@__DIR__, "source_51_full_lattice_group.mrdi")
if isfile(cache_path)
    cache = load(cache_path)
    @assert cache.parent_number == 51
    @assert gram_matrix(lattice(cache.Lambda0)) == gram_matrix(L)
    @assert basis_matrix(lattice(cache.Lambda0)) == basis_matrix(L)
    @assert isometry(cache.Lambda0) == isometry(parent.Lambda0)
    @assert basis_matrix(lattice(cache.S_in_Lambda0)) == basis_matrix(S)
    lifts = cache.symplectic_generators
    note81("Loaded previously verified ambient symplectic generators")
else
    note81("Computing O(S_51) generators")
    O = matrix_group(automorphism_group_generators(S; ambient_representation=false))
    rho = discriminant_representation(S, O;
        ambient_representation=false, full=false, check=true)
    K, inclusion = kernel(rho)
    @assert order(K) == 8 && small_group_identification(K) == (8, 4)
    lifts = typeof(isometry(parent.Lambda0))[]
    for u in gens(K)
        Su = integer_lattice_with_isometry(S, matrix(inclusion(u));
            ambient_representation=false, check=true)
        Lu = integer_lattice_with_isometry(L, ambient_isometry(Su);
            ambient_representation=true, check=true)
        push!(lifts, isometry(Lu))
    end
    note81("Recovered Q8 generators in the parent Lambda0 basis")
end

H = matrix_group(vcat(lifts, [isometry(parent.Lambda0)]))
N, _ = sub(H, [H(a) for a in lifts])
@assert order(H) == 32 && small_group_identification(H) == (32, 11)
@assert order(N) == 8 && small_group_identification(N) == (8, 4)
if !isfile(cache_path)
    save(cache_path, (
        parent_number=51,
        source="oscar/oscar_script_data.mrdi case 21 result 3",
        Lambda0=parent.Lambda0,
        S_in_Lambda0=parent.S_in_Lambda0,
        symplectic_generators=lifts,
        extra_generator=isometry(parent.Lambda0),
        full_group_id=(32, 11),
    ))
    reloaded_cache = load(cache_path)
    @assert length(reloaded_cache.symplectic_generators) == length(lifts)
    note81("Saved and reloaded reusable No. 51 ambient generators")
end

B, overlap = subgroup_with_id_and_symplectic_intersection(H, N, (16, 2))
c4 = first(x for x in overlap if order(x) == 4)
C4, _ = sub(H, [c4])
extra = first(x for x in elements(B) if
    !(x in C4) && !(x^2 in C4) && (x^4 in C4))
note81("Selected unique [16,2] subgroup with C4 symplectic intersection")

function save_checked_result81(path, result;
    group_checked::Bool, roots_checked::Bool, saturation_checked::Bool)
    save(path, (
        format_version=1,
        source_file="oscar/oscar_script_data.mrdi case 21 result 3",
        construction="unique subgroup restriction No. 51 -> No. 81",
        verify_group_id=group_checked,
        verify_roots=roots_checked,
        verify_symplectic_saturation=saturation_checked,
        result=result,
    ))
    r = load(path)
    @assert rank(lattice(r.result.S_in_Lambda0)) == 14
    @assert rank(lattice(r.result.T_in_Lambda0)) == 8
    @assert rank(r.result.P_in_Lambda0) == 6
    @assert rank(r.result.K_in_Lambda0) == 16
    @assert order_of_isometry(r.result.T_action) == 4
end

kwargs = (
    parent_number=51,
    child_number=81,
    index=4,
    expected_rank_S=14,
    expected_dimension=2,
    expected_group_id=(16, 2),
)
precheck = complete_cyclic_restriction(
    parent, matrix(c4), matrix(extra); kwargs...,
    verify_group_id=false, verify_roots=false,
    verify_symplectic_saturation=false,
)
precheck_path = joinpath(@__DIR__, "restriction_complete_81_from_51.precheck.mrdi")
save_checked_result81(precheck_path, precheck;
    group_checked=false, roots_checked=false, saturation_checked=false)
note81("Saved full ambient S/T/P/K precheck for No. 81")

if get(ENV, "RESTRICTION_VERIFY_FULL", "1") == "1"
    note81("Checking the root obstruction and independently recomputing the group ID")
    verified = complete_cyclic_restriction(
        parent, matrix(c4), matrix(extra); kwargs...,
        verify_group_id=true, verify_roots=true,
        verify_symplectic_saturation=false,
    )
    full_path = joinpath(@__DIR__, "restriction_complete_81_from_51.mrdi")
    save_checked_result81(full_path, verified;
        group_checked=true, roots_checked=true, saturation_checked=false)
    note81("Saved verified complete No. 81 result")
end
