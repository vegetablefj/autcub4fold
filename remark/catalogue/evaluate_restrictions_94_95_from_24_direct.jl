# Evaluate the unassigned No. 24 subgroup classes of [72,27] on the lattice.
# The 18-dimensional S action, together with the known four-dimensional
# T action of the parent, suffices for every primitive-cohomology trace.
# No order or subgroup enumeration is performed in a 22-dimensional group.

include(joinpath(@__DIR__, "restriction_functions.jl"))

const evaluation_started = time()
function evaluation_note(message)
    println(round(time() - evaluation_started; digits=1), " s | ", message)
    flush(stdout)
end

function matrix_key_9495(m)
    io = IOBuffer()
    for i in 1:nrows(m), j in 1:ncols(m)
        print(io, m[i, j], ';')
    end
    return String(take!(io))
end

function integer_trace_9495(m)
    t = sum(m[i, i] for i in 1:nrows(m))
    @assert denominator(t) == 1
    return Int(numerator(t))
end

function matrix_order_9495(m, identity, bound::Int)
    p = identity
    for k in 1:bound
        p *= m
        p == identity && return k
    end
    error("An alleged finite-group element exceeded its order bound")
end

function expected_histograms_9495(path)
    @assert isfile(path) "Run the geometric primitive-character GAP script first"
    expected = Dict(94 => Dict{Tuple{Int, Int}, Int}(),
                    95 => Dict{Tuple{Int, Int}, Int}())
    for (line_number, line) in enumerate(eachline(path))
        line_number == 1 && continue
        isempty(strip(line)) && continue
        fields = split(line, '\t')
        @assert length(fields) == 4
        family, order, trace, count = parse.(Int, fields)
        @assert family in (94, 95) && count > 0
        key = (order, trace)
        @assert !haskey(expected[family], key)
        expected[family][key] = count
    end
    @assert all(sum(values(expected[n])) == 72 for n in (94, 95))
    return expected
end

function subgroup_histogram_9495(data, parent_T_action)
    q = 12
    generators = [data.symplectic_generators_S...,
                  data.extra_generator_S]
    @assert length(generators) == 3
    d = nrows(generators[1])
    @assert d == 18 && all(nrows(g) == d && ncols(g) == d for g in generators)
    identity = identity_matrix(QQ, d)
    elements = typeof(identity)[identity]
    exponents = Int[0]
    # The action on S alone need not detect the full C12 quotient.  Keep the
    # T-exponent as part of the key, so (S-matrix, exponent) is faithful.
    positions = Dict((matrix_key_9495(identity), 0) => 1)
    head = 1
    while head <= length(elements)
        for (j, g) in enumerate(generators)
            product = elements[head] * g
            exponent = mod(exponents[head] + (j == 3 ? 1 : 0), q)
            key = (matrix_key_9495(product), exponent)
            old = get(positions, key, 0)
            if old == 0
                @assert length(elements) < 72 "The saved candidate is larger than 72"
                push!(elements, product)
                push!(exponents, exponent)
                positions[key] = length(elements)
            end
        end
        head += 1
    end
    @assert length(elements) == 72
    fT = isometry(parent_T_action)
    @assert nrows(fT) == 4 && ncols(fT) == 4
    powers_T = [fT^k for k in 0:q-1]
    traces_T = [integer_trace_9495(t) for t in powers_T]
    histogram = Dict{Tuple{Int, Int}, Int}()
    for (matrix, exponent) in zip(elements, exponents)
        order_S = matrix_order_9495(matrix, identity, 72)
        order_T = div(q, gcd(q, exponent))
        element_order = lcm(order_S, order_T)
        primitive_trace = integer_trace_9495(matrix) + traces_T[exponent + 1]
        key = (element_order, primitive_trace)
        histogram[key] = get(histogram, key, 0) + 1
    end
    @assert sum(values(histogram)) == 72
    @assert get(histogram, (1, 22), 0) == 1
    return histogram
end

source = load(joinpath(@__DIR__, "..", "..", "oscar", "oscar_script_data.mrdi"))
parent = source.cases[8].results[3]
L = lattice(parent.Lambda0)
@assert rank(L) == 22 && rank(lattice(parent.S_in_Lambda0)) == 18
@assert rank(lattice(parent.T_in_Lambda0)) == 4
@assert order_of_isometry(parent.T_action) == 12
cache_path = joinpath(@__DIR__, "source_24_full_lattice_group.mrdi")
group_path = joinpath(@__DIR__,
    "restriction_candidates_94_95_from_24.direct_groups.mrdi")
@assert isfile(cache_path) && isfile(group_path)
cache = load(cache_path)
groups = load(group_path)
@assert cache.parent_number == 24 && cache.full_group_order == 5832
@assert groups.parent_number == 24 && groups.complete_within_verified_parent_group
@assert groups.target_H_classes == length(groups.candidates)
@assert gram_matrix(lattice(cache.Lambda0)) == gram_matrix(L)
expected = expected_histograms_9495(joinpath(@__DIR__, "..",
    "gap_checks", "cross_symplectic_95",
    "pilot_94_95_primitive_character_summary.tsv"))
evaluation_note("Loaded the verified parent, exhaustive group classes and geometric characters")

summaries = NamedTuple[]
full_results = NamedTuple[]
for data in groups.candidates
    i = data.class_number
    histogram = subgroup_histogram_9495(data, parent.T_action)
    character_matches = [n for n in (94, 95) if histogram == expected[n]]
    if isempty(character_matches)
        push!(summaries, (class_number=i, character_matches=character_matches,
            histogram=histogram, passes_lattice_filter=false,
            reason="geometric character mismatch"))
        evaluation_note("Class $i: geometric character mismatch")
        continue
    end
    T = invariant_lattice(L, data.symplectic_generators_Lambda0;
        ambient_representation=false)
    S = orthogonal_submodule(L, T)
    rank_S, rank_T = rank(S), rank(T)
    evaluation_note("Class $i: rank(S)=$rank_S, character matches=$(character_matches)")
    if rank_S != 14 || rank_T != 8
        push!(summaries, (class_number=i, rank_S=rank_S, rank_T=rank_T,
            character_matches=character_matches, histogram=histogram,
            passes_lattice_filter=false))
        continue
    end
    @assert signature_tuple(S) == (14, 0, 0)
    @assert signature_tuple(T) == (6, 0, 2)
    Lambda0 = integer_lattice_with_isometry(L, data.extra_generator_Lambda0;
        ambient_representation=false, check=true)
    @assert trivial_action_on_discriminant(Lambda0)
    Simg = lattice_in_same_ambient_space(Lambda0, basis_matrix(S); check=true)
    Timg = lattice_in_same_ambient_space(Lambda0, basis_matrix(T); check=true)
    Taction = full_rank_model(Timg)
    index = order_of_isometry(Taction)
    if index != 12
        push!(summaries, (class_number=i, rank_S=14, rank_T=8,
            character_matches=character_matches, histogram=histogram,
            index=index, passes_lattice_filter=false))
        continue
    end
    pk = embedded_PK_data(Lambda0, Timg, 12)
    P, K = pk.P_lattice, pk.K_lattice
    dimension = period_dimension(P, 12)
    passes = rank(P) == 8 && rank(K) == 14 && dimension == 1
    push!(summaries, (class_number=i, rank_S=14, rank_T=8,
        character_matches=character_matches, histogram=histogram,
        index=12, rank_P=rank(P), rank_K=rank(K), dimension=dimension,
        passes_lattice_filter=passes))
    passes || continue
    @assert basis_matrix(S) * gram_matrix(ambient_space(L)) *
        transpose(basis_matrix(T)) == zero_matrix(QQ, 14, 8)
    push!(full_results, (
        class_number=i,
        character_matches=character_matches,
        order=12,
        dimension=1,
        S_in_Lambda0=Simg,
        T_in_Lambda0=Timg,
        T_action=Taction,
        P_in_Lambda0=P,
        K_in_Lambda0=K,
        P_action=pk.P_with_isometry,
        Lambda0=Lambda0,
        abstract_projective_group_id=(72, 27),
        symplectic_intersection_id=(6, 1),
        symplectic_generators_in_parent=data.symplectic_generators_Lambda0,
        extra_generator_in_parent=data.extra_generator_Lambda0,
        # This script determines the restricted lattice action.  It does not
        # independently test roots or saturation of the symplectic subgroup.
        root_check="not independently tested in this restriction script",
        symplectic_saturation_check="not independently tested in this restriction script",
    ))
end

matching94 = [x.class_number for x in full_results if x.character_matches == [94]]
matching95 = [x.class_number for x in full_results if x.character_matches == [95]]
assignment_verified = length(matching94) == 1 && length(matching95) == 1 &&
    matching94[1] != matching95[1]
output = joinpath(@__DIR__, "restriction_candidates_94_95_from_24.direct_lattices.mrdi")
save(output, (
    format_version=1,
    parent_number=24,
    possible_child_numbers=(94, 95),
    group_candidates_file=basename(group_path),
    geometric_character_file="gap_cross_symplectic_95/pilot_94_95_primitive_character_summary.tsv",
    character_assignment_verified=assignment_verified,
    assigned_class_94=assignment_verified ? only(matching94) : nothing,
    assigned_class_95=assignment_verified ? only(matching95) : nothing,
    # OSCAR does not serialize a Vector{NamedTuple} whose entries have
    # different fields (the rejected class has fewer lattice fields).
    # Heterogeneous tuples are supported and preserve the exact records.
    summaries=Tuple(summaries),
    results=Tuple(full_results),
))
check = load(output)
@assert check.parent_number == 24 && length(check.summaries) == length(summaries)
@assert length(check.results) == length(full_results)
evaluation_note("Saved and reloaded $(length(full_results)) lattice candidates; unique character assignment=$assignment_verified")
