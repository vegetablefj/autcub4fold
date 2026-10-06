# Exhaustive C6 restrictions inside the saved, numbered No. 95 action.
#
# Run `julia enumerate_cyclic_141_from_95.jl groups` first, then
# `julia enumerate_cyclic_141_from_95.jl lattices`.  Neither stage constructs
# a 22-dimensional matrix group: the exact kernel has only six elements.
# This file does not change any of the 156-row catalogue files.

include(joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))
include(joinpath(@__DIR__, "restriction_functions.jl"))

const cyclic95_cache_path = joinpath(@__DIR__,
    "restriction_candidates_94_95_from_24.direct_lattices.mrdi")
const cyclic95_group_path = joinpath(@__DIR__,
    "cyclic_141_from_95.groups.mrdi")
const cyclic95_lattice_path = joinpath(@__DIR__,
    "cyclic_141_from_95.lattices.mrdi")
const cyclic95_geometric_path = joinpath(@__DIR__, "..",
    "gap_checks", "cyclic_141_150",
    "primitive_cyclic_141_150_summary.tsv")

function note_95(message)
    println("No. 95 -> C6: ", message)
    flush(stdout)
end

function load_parent_95()
    @assert isfile(cyclic95_cache_path) "Evaluate the No. 24 -> 94/95 lattice restrictions first"
    cache = load(cyclic95_cache_path)
    @assert cache.parent_number == 24
    @assert cache.character_assignment_verified
    @assert cache.assigned_class_95 !== nothing
    parent = only(r for r in cache.results
        if r.class_number == cache.assigned_class_95 &&
           r.character_matches == [95])
    @assert parent.abstract_projective_group_id == (72, 27)
    @assert parent.symplectic_intersection_id == (6, 1)
    @assert length(parent.symplectic_generators_in_parent) == 2
    @assert parent.order == 12
    L = lattice(parent.Lambda0)
    @assert rank(L) == 22 && abs(det(gram_matrix(L))) == 3
    @assert rank(lattice(parent.T_in_Lambda0)) == 8
    @assert rank(lattice(parent.S_in_Lambda0)) == 14
    @assert isometry(parent.Lambda0) == parent.extra_generator_in_parent
    return cache, parent, L
end

function geometric_histogram_141()
    @assert isfile(cyclic95_geometric_path)
    result = Dict{Tuple{Int, Int}, Int}()
    for line in Iterators.drop(eachline(cyclic95_geometric_path), 1)
        isempty(strip(line)) && continue
        fields = split(line, '\t')
        @assert length(fields) == 4
        family, order, trace, count = parse.(Int, fields)
        family == 141 || continue
        @assert count > 0 && !haskey(result, (order, trace))
        result[(order, trace)] = count
    end
    @assert sum(values(result)) == 6
    @assert get(result, (1, 22), 0) == 1
    return result
end

function phi_power_95(ctx, x::Int, k::Int)
    for _ in 1:k
        x = ctx.phi[x]
    end
    return x
end

function has_order_six_95(ctx, n::Int)
    # For b=n*f^2, b^6=Norm_{phi^2}(n)*f^12.  The quotient image
    # already has order six, so b^6=1 is equivalent to |b|=6.
    product, term = 1, n
    for _ in 1:6
        product = ctx.mul(product, term)
        term = phi_power_95(ctx, term, 2)
    end
    return ctx.mul(product, ctx.c) == 1
end

function cyclic_orbits_95(ctx)
    candidates = Set(n for n in eachindex(ctx.elements)
        if has_order_six_95(ctx, n))
    unseen = copy(candidates)
    orbits = NamedTuple[]
    while !isempty(unseen)
        first_n = minimum(unseen)
        orbit = Set([first_n])
        queue = [first_n]
        head = 1
        while head <= length(queue)
            n = queue[head]
            # Conjugation by f, and by each generator g of N:
            # g*(n*f^2)*g^-1 = g*n*phi^2(g^-1)*f^2.
            neighbours = Int[ctx.phi[n]]
            for g in ctx.generator_ids
                push!(neighbours, ctx.mul(ctx.mul(g, n),
                    phi_power_95(ctx, ctx.inverses[g], 2)))
            end
            for other in neighbours
                @assert other in candidates "Order-six candidates must be conjugacy-stable"
                if !(other in orbit)
                    push!(orbit, other)
                    push!(queue, other)
                end
            end
            head += 1
        end
        setdiff!(unseen, orbit)
        push!(orbits, (representative=minimum(orbit), orbit_size=length(orbit)))
    end
    @assert sum(x.orbit_size for x in orbits) == length(candidates)
    return length(candidates), orbits
end

function primitive_histogram_95(b)
    @assert nrows(b) == ncols(b) == 22
    one_L = identity_matrix(QQ, 22)
    power = one_L
    result = Dict{Tuple{Int, Int}, Int}()
    for k in 0:5
        order = k == 0 ? 1 : div(6, gcd(6, k))
        trace = sum(power[i, i] for i in 1:22)
        @assert denominator(trace) == 1
        key = (order, Int(numerator(trace)))
        result[key] = get(result, key, 0) + 1
        power *= b
    end
    @assert power == one_L
    @assert sum(values(result)) == 6 && get(result, (1, 22), 0) == 1
    return result
end

function groups_95()
    cache, parent, L = load_parent_95()
    generators = parent.symplectic_generators_in_parent
    f = parent.extra_generator_in_parent
    one_L = identity_matrix(QQ, 22)
    @assert all(nrows(g) == ncols(g) == 22 for g in generators)
    @assert nrows(f) == ncols(f) == 22

    # The saved S3 generators fix T pointwise.  Since f|T has exact order
    # twelve, the six-element kernel and twelve quotient cosets are distinct.
    T = lattice(parent.T_in_Lambda0)
    embedding_T = basis_matrix(T) * inv(basis_matrix(L))
    @assert all(embedding_T * g == embedding_T for g in generators)
    fT = isometry(parent.T_action)
    @assert nrows(fT) == ncols(fT) == 8
    @assert fT^12 == identity_matrix(QQ, 8)
    @assert all(fT^k != identity_matrix(QQ, 8) for k in (1, 2, 3, 4, 6))

    ctx = direct_context(generators, f, 6, 12)
    @assert sort(ctx.orders) == [1, 2, 2, 2, 3, 3]
    @assert ctx.elements[ctx.c] == f^12
    note_95("Verified saved S3 kernel, exact C12 quotient and 22-dimensional extension")

    raw_count, orbits = cyclic_orbits_95(ctx)
    expected = geometric_histogram_141()
    results = NamedTuple[]
    for (j, orbit) in enumerate(orbits)
        n = orbit.representative
        b = ctx.elements[n] * f^2
        @assert b^6 == one_L && b != one_L
        histogram = primitive_histogram_95(b)
        matches = histogram == expected
        push!(results, (
            class_number=j,
            parent_conjugacy_orbit_size=orbit.orbit_size,
            kernel_element_index=n,
            kernel_generator_word=ctx.words[n],
            extra_generator_Lambda0=b,
            primitive_character_histogram=histogram,
            matches_geometric_141=matches,
        ))
        note_95("C6 class $j: orbit size $(orbit.orbit_size), " *
                "No. 141 character match=$matches; histogram=$histogram")
    end
    matches = [r.class_number for r in results if r.matches_geometric_141]
    save(cyclic95_group_path, (
        format_version=1,
        parent_number=95,
        parent_24_class_number=cache.assigned_class_95,
        parent_lattice_file=basename(cyclic95_cache_path),
        geometric_character_file=relpath(cyclic95_geometric_path, @__DIR__),
        method="all n*f^2 of exact order six, modulo conjugacy by <N,f>",
        exhaustive_within_saved_parent_group=true,
        symplectic_kernel_order=6,
        quotient_order=12,
        full_group_order=72,
        raw_order_six_generators=raw_count,
        parent_conjugacy_classes=length(orbits),
        geometric_141_histogram=expected,
        geometric_141_matching_classes=Tuple(matches),
        unique_character_match_within_parent=length(matches) == 1,
        numbered_integral_assignment_verified=false,
        results=Tuple(results),
    ))
    check = load(cyclic95_group_path)
    @assert check.parent_number == 95 &&
            length(check.results) == check.parent_conjugacy_classes
    @assert check.geometric_141_matching_classes == Tuple(matches)
    note_95("Saved $(length(orbits)) exhaustive parent classes; " *
            "No. 141 character matches=$(matches)")
end

function lattices_95()
    @assert isfile(cyclic95_group_path) "Run the groups stage first"
    group_data = load(cyclic95_group_path)
    cache, parent, L = load_parent_95()
    @assert group_data.parent_number == 95 &&
            group_data.parent_24_class_number == cache.assigned_class_95
    @assert group_data.exhaustive_within_saved_parent_group
    @assert group_data.geometric_141_histogram == geometric_histogram_141()
    @assert length(group_data.results) == group_data.parent_conjugacy_classes
    @assert signature_tuple(L) == (20, 0, 2)

    results = NamedTuple[]
    for r in group_data.results
        action = integer_lattice_with_isometry(L, r.extra_generator_Lambda0;
            ambient_representation=false, check=true)
        @assert order_of_isometry(action) == 6
        @assert trivial_action_on_discriminant(action)
        Paction = phi_kernel(action, 6)
        P = lattice(Paction)
        K = orthogonal_submodule(L, basis_matrix(P))
        @assert rank(P) + rank(K) == 22
        @assert signature_tuple(P) == (rank(P) - 2, 0, 2)
        @assert signature_tuple(K) == (rank(K), 0, 0)
        @assert basis_matrix(P) * gram_matrix(ambient_space(L)) *
                transpose(basis_matrix(K)) ==
                zero_matrix(QQ, rank(P), rank(K))
        dimension = period_dimension(P, 6)
        if r.matches_geometric_141
            @assert dimension == 5 "A No. 141 character match has the wrong period dimension"
        end
        push!(results, (
            class_number=r.class_number,
            parent_conjugacy_orbit_size=r.parent_conjugacy_orbit_size,
            parent_kernel_word=r.kernel_generator_word,
            primitive_character_histogram=r.primitive_character_histogram,
            matches_geometric_141=r.matches_geometric_141,
            order=6,
            dimension=dimension,
            rank_S=0,
            rank_T=22,
            T_in_Lambda0=action,
            T_action=action,
            P_in_Lambda0=P,
            K_in_Lambda0=K,
            P_action=Paction,
            Lambda0=action,
            root_check="inherited from common smooth parent, not independently retested",
            numbered_integral_assignment_verified=false,
        ))
        note_95("Class $(r.class_number): rank(P)=$(rank(P)), " *
                "rank(K)=$(rank(K)), dimension=$dimension")
    end
    save(cyclic95_lattice_path, (
        format_version=1,
        parent_number=95,
        exhaustive_group_file=basename(cyclic95_group_path),
        geometric_character_file=group_data.geometric_character_file,
        geometric_141_matching_classes=group_data.geometric_141_matching_classes,
        unique_character_match_within_parent=
            group_data.unique_character_match_within_parent,
        numbered_integral_assignment_verified=false,
        results=Tuple(results),
    ))
    check = load(cyclic95_lattice_path)
    @assert check.parent_number == 95 && length(check.results) == length(results)
    note_95("Saved and reloaded $(length(results)) complete rank-zero restrictions")
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    stage = isempty(ARGS) ? "groups" : only(ARGS)
    if stage == "groups"
        groups_95()
    elseif stage == "lattices"
        lattices_95()
    else
        error("Use stage `groups` or `lattices`")
    end
end
