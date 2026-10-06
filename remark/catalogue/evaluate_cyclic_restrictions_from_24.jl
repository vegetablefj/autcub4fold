# Match the exhaustive cyclic classes in the saved No. 24 integral action
# against exact primitive-H4 characters of the numbered cubic families.
# Only uniquely matched rows are recorded as assigned integral actions.

include(joinpath(@__DIR__, "restriction_functions.jl"))

const source_path_cyclic = joinpath(@__DIR__, "cyclic_restrictions_from_24.groups.mrdi")
const geometric_path_cyclic = joinpath(@__DIR__, "..", "gap_checks",
    "cyclic_141_150", "primitive_cyclic_141_150_summary.tsv")
const output_path_cyclic = joinpath(@__DIR__,
    "restriction_cyclic_141_142_149_150_from_24.mrdi")

function geometric_cyclic_histograms(path)
    result = Dict(n => Dict{Tuple{Int, Int}, Int}() for n in (141, 142, 149, 150))
    for line in Iterators.drop(eachline(path), 1)
        isempty(strip(line)) && continue
        fields = split(line, '\t')
        @assert length(fields) == 4
        n, order, trace, count = parse.(Int, fields)
        @assert haskey(result, n) && count > 0
        key = (order, trace)
        @assert !haskey(result[n], key)
        result[n][key] = count
    end
    @assert [sum(values(result[n])) for n in (141, 142, 149, 150)] ==
        [6, 6, 12, 12]
    return result
end

source = load(source_path_cyclic)
cache = load(joinpath(@__DIR__, "source_24_full_lattice_group.mrdi"))
@assert source.parent_number == cache.parent_number == 24
@assert source.counts_by_order[3].parent_conjugacy_classes == 5
@assert source.counts_by_order[6].parent_conjugacy_classes == 8
@assert source.counts_by_order[12].parent_conjugacy_classes == 6
@assert length(source.results) == 19
L = lattice(cache.Lambda0)
@assert rank(L) == 22 && signature_tuple(L) == (20, 0, 2)
@assert abs(det(gram_matrix(L))) == 3
expected = geometric_cyclic_histograms(geometric_path_cyclic)

matches = Dict(n => [r.class_number for r in source.results
    if r.quotient_order == (n in (141, 142) ? 6 : 12) &&
       r.primitive_character_histogram == expected[n]]
    for n in (141, 142, 149, 150))
@assert matches[141] == [2, 4, 5]
@assert matches[142] == [6]
@assert matches[149] == [6]
@assert matches[150] == [2]
println("Character matches: ", matches)
flush(stdout)

assigned = NamedTuple[]
for n in (142, 149, 150)
    order = n == 142 ? 6 : 12
    r = only([x for x in source.results
        if x.quotient_order == order && x.class_number == only(matches[n])])
    action = integer_lattice_with_isometry(L, r.extra_generator_Lambda0;
        ambient_representation=false, check=true)
    @assert order_of_isometry(action) == order
    @assert trivial_action_on_discriminant(action)
    Paction = phi_kernel(action, order)
    P = lattice(Paction)
    K = orthogonal_submodule(L, basis_matrix(P))
    @assert rank(P) + rank(K) == 22
    @assert signature_tuple(P) == (rank(P) - 2, 0, 2)
    @assert signature_tuple(K) == (rank(K), 0, 0)
    dimension = period_dimension(P, order)
    @assert dimension == (n == 142 ? 4 : 2)
    @assert basis_matrix(P) * gram_matrix(ambient_space(L)) *
        transpose(basis_matrix(K)) == zero_matrix(QQ, rank(P), rank(K))
    push!(assigned, (
        child_number=n,
        parent_number=24,
        quotient_order=order,
        class_number=r.class_number,
        character_matches=[n],
        primitive_character_histogram=r.primitive_character_histogram,
        dimension=dimension,
        rank_S=0,
        T_in_Lambda0=action,
        T_action=action,
        P_in_Lambda0=P,
        K_in_Lambda0=K,
        P_action=Paction,
        Lambda0=action,
        parent_kernel_word=r.kernel_generator_word,
        parent_conjugacy_orbit_size=r.parent_conjugacy_orbit_size,
        root_check="not independently tested by this restriction script",
        saturation_check="not independently tested by this restriction script",
    ))
    println("No. $n: parent class $(r.class_number), order $order, " *
        "rank(P)=$(rank(P)), dimension=$dimension, rank(K)=$(rank(K))")
    flush(stdout)
end

save(output_path_cyclic, (
    format_version=1,
    parent_number=24,
    exhaustive_group_file=basename(source_path_cyclic),
    geometric_character_file=relpath(geometric_path_cyclic, @__DIR__),
    matches_by_family=matches,
    assigned_numbers=(142, 149, 150),
    unassigned_numbers=(141,),
    results=Tuple(assigned),
))
check = load(output_path_cyclic)
@assert check.assigned_numbers == (142, 149, 150)
@assert [r.child_number for r in check.results] == [142, 149, 150]
@assert check.matches_by_family == matches
println("Saved and reloaded three uniquely matched complete integral actions")
