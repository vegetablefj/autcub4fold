# No. 24 -> No. 94/95: exact finite group stage in the 18-dimensional S action.
# No 22-dimensional matrix-group order, subgroup_classes or normalizer is used.
# Set NO24_DIRECT_SMOKE=1 to run only the small S3 x C2 self-test.

using Oscar

const direct_started = time()
function direct_note(s)
    println(round(time() - direct_started; digits=1), " s | ", s)
    flush(stdout)
end

function direct_matrix_key(m)
    io = IOBuffer()
    for i in 1:nrows(m), j in 1:ncols(m)
        print(io, m[i, j], ';')
    end
    return String(take!(io))
end

function direct_context(generators, f, expected_order::Int, quotient_order::Int)
    @assert !isempty(generators)
    d = nrows(f)
    @assert ncols(f) == d
    @assert all(nrows(g) == d && ncols(g) == d for g in generators)
    e = identity_matrix(QQ, d)
    elements = typeof(e)[e]
    positions = Dict(direct_matrix_key(e) => 1)
    parent = Int[0]
    parent_generator = Int[0]
    right = zeros(Int, expected_order, length(generators))
    head = 1
    while head <= length(elements)
        for (j, g) in enumerate(generators)
            z = elements[head] * g
            key = direct_matrix_key(z)
            k = get(positions, key, 0)
            if k == 0
                @assert length(elements) < expected_order "More than the stated kernel order"
                push!(elements, z)
                push!(parent, head)
                push!(parent_generator, j)
                k = length(elements)
                positions[key] = k
            end
            right[head, j] = k
        end
        head += 1
    end
    @assert length(elements) == expected_order "Saved generators do not generate N"
    words = [Int[] for _ in 1:expected_order]
    for i in 2:expected_order
        words[i] = [words[parent[i]]; parent_generator[i]]
    end
    function mul(i::Int, j::Int)
        for t in words[j]
            i = right[i, t]
        end
        return i
    end
    right_inverse = zeros(Int, size(right))
    for i in 1:expected_order, j in eachindex(generators)
        @assert right_inverse[right[i, j], j] == 0
        right_inverse[right[i, j], j] = i
    end
    inverses = ones(Int, expected_order)
    for i in 2:expected_order
        k = 1
        for t in reverse(words[i])
            k = right_inverse[k, t]
        end
        inverses[i] = k
    end
    @assert all(mul(i, inverses[i]) == 1 && mul(inverses[i], i) == 1
                for i in 1:expected_order)
    generator_ids = [positions[direct_matrix_key(g)] for g in generators]
    finv = inv(f)
    phi_generator = Int[]
    for g in generators
        k = get(positions, direct_matrix_key(f * g * finv), 0)
        @assert k != 0 "The extra generator does not normalize N"
        push!(phi_generator, k)
    end
    phi = ones(Int, expected_order)
    for i in 2:expected_order
        phi[i] = mul(phi[parent[i]], phi_generator[parent_generator[i]])
    end
    @assert length(unique(phi)) == expected_order
    c = get(positions, direct_matrix_key(f^quotient_order), 0)
    @assert c != 0 "f^q is not in N"
    @assert phi[c] == c
    for i in 1:expected_order
        j = i
        for _ in 1:quotient_order
            j = phi[j]
        end
        @assert j == mul(mul(c, i), inverses[c])
    end
    orders = zeros(Int, expected_order)
    for i in 1:expected_order
        k = 1
        while true
            k = mul(k, i)
            orders[i] += 1
            k == 1 && break
            @assert orders[i] < expected_order
        end
    end
    return (; elements, positions, words, mul, inverses, generator_ids,
             phi, c, orders, quotient_order)
end

function direct_s3_subgroups(ctx)
    mul, invs, orders = ctx.mul, ctx.inverses, ctx.orders
    found = Dict{Any, Tuple{Int, Int}}()
    for r in eachindex(orders)
        orders[r] == 3 || continue
        r < invs[r] || continue
        r2 = mul(r, r)
        for s in eachindex(orders)
            orders[s] == 2 || continue
            mul(mul(s, r), s) == r2 || continue
            key = Tuple(sort([1, r, r2, s, mul(s, r), mul(s, r2)]))
            @assert length(unique(key)) == 6
            if !haskey(found, key) || (r, s) < found[key]
                found[key] = (r, s)
            end
        end
    end
    return found
end

function direct_coset_key(ctx, akey, n::Int)
    return (akey, Tuple(sort([ctx.mul(a, n) for a in akey])))
end

function direct_group_id(ctx, akey, r::Int, s::Int, n::Int)
    mul, phi, c, q = ctx.mul, ctx.phi, ctx.c, ctx.quotient_order
    npowers = ones(Int, q)
    term = n
    for k in 2:q
        npowers[k] = mul(npowers[k - 1], term)
        term = phi[term]
    end
    @assert mul(mul(npowers[q], term), c) in akey
    pairs = [(mul(a, npowers[k + 1]), k) for k in 0:q-1 for a in akey]
    @assert length(unique(pairs)) == 6 * q
    index = Dict(x => i for (i, x) in enumerate(pairs))
    function permutation_for(g::Int, extra::Bool)
        image = Int[]
        for (x, k) in pairs
            y, l = if extra
                z = mul(n, phi[x])
                k == q - 1 ? (mul(z, c), 0) : (z, k + 1)
            else
                (mul(g, x), k)
            end
            push!(image, index[(y, l)])
        end
        @assert sort(image) == collect(1:length(pairs))
        return GAP.Globals.PermList(GapObj(image))
    end
    gr = GAP.Globals.Group(permutation_for(r, false),
                           permutation_for(s, false),
                           permutation_for(n, true))
    @assert Int(GAP.Globals.Size(gr)) == 6 * q
    id = GAP.Globals.IdGroup(gr)
    return (Int(id[1]), Int(id[2]))
end

function direct_enumerate(ctx; wanted_id=nothing)
    mul, invs, phi, q = ctx.mul, ctx.inverses, ctx.phi, ctx.quotient_order
    subgroups = direct_s3_subgroups(ctx)
    direct_note("Enumerated $(length(subgroups)) distinct S3 subgroups of N")
    bq = Int[]
    for n in eachindex(ctx.elements)
        z, t = 1, n
        for _ in 1:q
            z = mul(z, t)
            t = phi[t]
        end
        push!(bq, mul(z, ctx.c))
    end
    candidates = Dict{Any, Tuple{Int, Int, Int}}()
    for (ai, (akey, (r, s))) in enumerate(subgroups)
        aset = Set(akey)
        for n in eachindex(ctx.elements)
            bq[n] in aset || continue
            cr = mul(mul(n, phi[r]), invs[n])
            cs = mul(mul(n, phi[s]), invs[n])
            cr in aset && cs in aset || continue
            key = direct_coset_key(ctx, akey, n)
            get!(candidates, key, (r, s, n))
        end
        if ai % 25 == 0 || ai == length(subgroups)
            direct_note("Processed S3 subgroup $ai/$(length(subgroups)); raw B count=$(length(candidates))")
        end
    end
    direct_note("Found $(length(candidates)) raw subgroups after A-coset deduplication")
    function conjugate_key(key, g::Int)
        akey, coset = key
        new_a = Tuple(sort([mul(mul(g, a), invs[g]) for a in akey]))
        n = first(coset)
        new_n = mul(mul(g, n), phi[invs[g]])
        return direct_coset_key(ctx, new_a, new_n)
    end
    function conjugate_key_by_f(key)
        akey, coset = key
        return direct_coset_key(ctx, Tuple(sort([phi[a] for a in akey])),
                                phi[first(coset)])
    end
    unseen = Set(keys(candidates))
    orbits = NamedTuple[]
    all_orbit_count = 0
    orbit_size_sum = 0
    id_histogram = Dict{Tuple{Int, Int}, Int}()
    while !isempty(unseen)
        first_key = sort!(collect(unseen))[1]
        orbit = Set([first_key])
        todo = [first_key]
        head = 1
        while head <= length(todo)
            key = todo[head]
            neighbours = [conjugate_key(key, g) for g in ctx.generator_ids]
            push!(neighbours, conjugate_key_by_f(key))
            for next_key in neighbours
                @assert haskey(candidates, next_key) "Candidate list not closed under H-conjugation"
                if !(next_key in orbit)
                    push!(orbit, next_key)
                    push!(todo, next_key)
                end
            end
            head += 1
        end
        setdiff!(unseen, orbit)
        representative = sort!(collect(orbit))[1]
        akey = representative[1]
        n = first(representative[2])
        r, s, _ = candidates[representative]
        group_id = direct_group_id(ctx, akey, r, s, n)
        all_orbit_count += 1
        orbit_size_sum += length(orbit)
        id_histogram[group_id] = get(id_histogram, group_id, 0) + 1
        if wanted_id === nothing || group_id == wanted_id
            push!(orbits, (; representative, r, s, n,
                           orbit_size=length(orbit), group_id))
            direct_note("Retained H-class $(length(orbits)); ID=$group_id; orbit size=$(length(orbit))")
        end
        if all_orbit_count % 25 == 0
            direct_note("Classified $all_orbit_count H-conjugacy classes; $(length(unseen)) raw subgroups remain")
        end
    end
    @assert orbit_size_sum == length(candidates)
    return (; s3_subgroups=length(subgroups), raw_subgroups=length(candidates),
            all_orbit_count, id_histogram, orbits)
end

function direct_smoke()
    # S3 acts on the first three coordinates, and f flips the fourth.
    r = matrix(QQ, 4, 4, [0,1,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,1])
    s = matrix(QQ, 4, 4, [0,1,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,1])
    f = matrix(QQ, 4, 4, [1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,-1])
    ctx = direct_context([r, s], f, 6, 2)
    result = direct_enumerate(ctx)
    @assert result.s3_subgroups == 1
    @assert result.raw_subgroups == 1 && length(result.orbits) == 1
    @assert result.orbits[1].group_id[1] == 12
    # The formal coset coordinate must remain valid even when the S-action
    # alone does not see the extra generator (as can happen before T is used).
    hidden = direct_context([r, s], identity_matrix(QQ, 4), 6, 2)
    hidden_result = direct_enumerate(hidden)
    @assert length(hidden_result.orbits) == 1
    @assert hidden_result.orbits[1].group_id == result.orbits[1].group_id
    target_id = GAP.Globals.IdGroup(GAP.Globals.SmallGroup(72, 27))
    @assert (Int(target_id[1]), Int(target_id[2])) == (72, 27)
    direct_note("SMOKE_OK: exact S3 x C2 example and GAP regular-action ID")
end

function direct_main()
    cache_file = joinpath(@__DIR__, "source_24_full_lattice_group.mrdi")
    @assert isfile(cache_file) "The checked No. 24 parent cache must be produced first"
    cache = load(cache_file)
    @assert cache.parent_number == 24
    @assert cache.symplectic_order == 486 && cache.full_group_order == 5832
    @assert length(cache.symplectic_generators_S) ==
            length(cache.symplectic_generators)
    source = load(joinpath(@__DIR__, "..", "..", "oscar", "oscar_script_data.mrdi"))
    parent = source.cases[8].results[3]
    @assert order_of_isometry(parent.T_action) == 12
    @assert isometry(parent.Lambda0) == cache.extra_generator
    # Convert the embedded S basis to coordinates in the Lambda0 lattice basis.
    embedding = basis_matrix(lattice(cache.S_in_Lambda0)) *
                inv(basis_matrix(lattice(cache.Lambda0)))
    @assert nrows(embedding) == 18 && ncols(embedding) == 22
    for (gS, gL) in zip(cache.symplectic_generators_S,
                         cache.symplectic_generators)
        @assert gS * embedding == embedding * gL
    end
    @assert cache.extra_generator_S * embedding ==
            embedding * cache.extra_generator
    ctx = direct_context(cache.symplectic_generators_S,
                         cache.extra_generator_S, 486, 12)
    function lift_n(i::Int)
        m = identity_matrix(QQ, nrows(cache.extra_generator))
        for j in ctx.words[i]
            m *= cache.symplectic_generators[j]
        end
        return m
    end
    @assert lift_n(ctx.c) == cache.extra_generator^12
    for (j, g) in enumerate(ctx.generator_ids)
        @assert cache.extra_generator * cache.symplectic_generators[j] *
                inv(cache.extra_generator) == lift_n(ctx.phi[g])
    end
    direct_note("Verified the 486-by-12 parent extension and matched its 18/22-dimensional generators")
    result = direct_enumerate(ctx; wanted_id=(72, 27))
    saved = NamedTuple[]
    for (i, item) in enumerate(result.orbits)
        r, s, n = item.r, item.s, item.n
        push!(saved, (
            class_number=i,
            abstract_group_id=item.group_id,
            symplectic_intersection_id=(6, 1),
            h_conjugacy_orbit_size=item.orbit_size,
            symplectic_generators_S=[ctx.elements[r], ctx.elements[s]],
            extra_generator_S=ctx.elements[n] * cache.extra_generator_S,
            symplectic_generators_Lambda0=[lift_n(r), lift_n(s)],
            extra_generator_Lambda0=lift_n(n) * cache.extra_generator,
            generator_word_indices=(ctx.words[r], ctx.words[s], ctx.words[n]),
        ))
    end
    output = joinpath(@__DIR__, "restriction_candidates_94_95_from_24.direct_groups.mrdi")
    save(output, (
        format_version=1,
        parent_number=24,
        possible_child_numbers=(94, 95),
        geometric_assignment="unassigned",
        parent_cache=basename(cache_file),
        method="all S3 subgroups of N; b=n*f; exact H-conjugacy orbits; regular permutation ID",
        complete_within_verified_parent_group=true,
        s3_subgroups_in_N=result.s3_subgroups,
        raw_subgroups_before_H_conjugacy=result.raw_subgroups,
        all_H_conjugacy_classes=result.all_orbit_count,
        H_class_group_id_histogram=result.id_histogram,
        target_H_classes=length(saved),
        candidates=saved,
    ))
    loaded = load(output)
    @assert loaded.parent_number == 24
    @assert loaded.target_H_classes == length(saved)
    @assert all(x.abstract_group_id == (72, 27) for x in loaded.candidates)
    direct_note("Saved and reloaded $(length(saved)) unassigned [72,27] subgroup classes")
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    if get(ENV, "NO24_DIRECT_SMOKE", "0") == "1"
        direct_smoke()
    else
        direct_main()
    end
end
