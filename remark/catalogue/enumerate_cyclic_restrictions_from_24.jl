# Enumerate cyclic subgroups with trivial symplectic intersection in the
# checked No. 24 integral group.  This is a group/lattice candidate stage;
# geometric family labels are assigned separately by exact characters.

# The included file only defines its finite-extension functions when it is
# included, and retains its original entry point when run directly.
include(joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))

const cyclic_started_24 = time()
function cyclic_note_24(message)
    println(round(time() - cyclic_started_24; digits=1), " s | ", message)
    flush(stdout)
end

function power_phi_24(ctx, x::Int, k::Int)
    for _ in 1:k
        x = ctx.phi[x]
    end
    return x
end

function cyclic_order_condition_24(ctx, n::Int, m::Int)
    @assert 12 % m == 0
    q = div(12, m)
    product, term = 1, n
    for _ in 1:m
        product = ctx.mul(product, term)
        term = power_phi_24(ctx, term, q)
    end
    # (n*f^q)^m = n*phi^q(n)*...*phi^((m-1)q)(n)*f^12.
    return ctx.mul(product, ctx.c) == 1
end

function cyclic_orbits_24(ctx, m::Int)
    q = div(12, m)
    candidates = Set(n for n in eachindex(ctx.elements)
                     if cyclic_order_condition_24(ctx, n, m))
    unseen = copy(candidates)
    orbits = NamedTuple[]
    while !isempty(unseen)
        first_n = minimum(unseen)
        orbit = Set([first_n])
        queue = [first_n]
        head = 1
        while head <= length(queue)
            n = queue[head]
            neighbours = Int[ctx.phi[n]]
            for g in ctx.generator_ids
                # g*(n*f^q)*g^-1 = g*n*phi^q(g^-1)*f^q.
                push!(neighbours, ctx.mul(ctx.mul(g, n),
                    power_phi_24(ctx, ctx.inverses[g], q)))
            end
            for other in neighbours
                @assert other in candidates "Candidate set not closed under parent conjugation"
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

function cyclic_character_24(matrix, m::Int)
    identity = identity_matrix(QQ, nrows(matrix))
    @assert nrows(matrix) == ncols(matrix) == 22
    histogram = Dict{Tuple{Int, Int}, Int}()
    power = identity
    for k in 0:m-1
        element_order = k == 0 ? 1 : div(m, gcd(m, k))
        trace = sum(power[i, i] for i in 1:22)
        @assert denominator(trace) == 1
        key = (element_order, Int(numerator(trace)))
        histogram[key] = get(histogram, key, 0) + 1
        power *= matrix
    end
    @assert power == identity
    @assert sum(values(histogram)) == m
    @assert get(histogram, (1, 22), 0) == 1
    return histogram
end

cache = load(joinpath(@__DIR__, "source_24_full_lattice_group.mrdi"))
@assert cache.parent_number == 24
@assert cache.symplectic_order == 486 && cache.full_group_order == 5832
ctx = direct_context(cache.symplectic_generators_S,
                     cache.extra_generator_S, 486, 12)
function lift_n_24(i::Int)
    matrix = identity_matrix(QQ, nrows(cache.extra_generator))
    for j in ctx.words[i]
        matrix *= cache.symplectic_generators[j]
    end
    return matrix
end
@assert lift_n_24(ctx.c) == cache.extra_generator^12
cyclic_note_24("Verified No. 24 finite extension and 18/22-dimensional lifts")

all_results = NamedTuple[]
counts = Dict{Int, Any}()
for m in (3, 6, 12)
    raw_count, orbits = cyclic_orbits_24(ctx, m)
    q = div(12, m)
    cyclic_note_24("Order $m: $raw_count raw generators, $(length(orbits)) parent-conjugacy classes")
    for (j, orbit) in enumerate(orbits)
        n = orbit.representative
        extra_S = ctx.elements[n] * cache.extra_generator_S^q
        extra_L = lift_n_24(n) * cache.extra_generator^q
        @assert extra_S^m == identity_matrix(QQ, 18)
        @assert extra_L^m == identity_matrix(QQ, 22)
        @assert extra_L != identity_matrix(QQ, 22)
        histogram = cyclic_character_24(extra_L, m)
        push!(all_results, (
            quotient_order=m,
            class_number=j,
            parent_conjugacy_orbit_size=orbit.orbit_size,
            kernel_element_index=n,
            kernel_generator_word=ctx.words[n],
            extra_generator_S=extra_S,
            extra_generator_Lambda0=extra_L,
            primitive_character_histogram=histogram,
        ))
        cyclic_note_24("Order $m class $j: orbit size $(orbit.orbit_size), character=$histogram")
    end
    counts[m] = (raw_generators=raw_count,
                 parent_conjugacy_classes=length(orbits))
end

path = joinpath(@__DIR__, "cyclic_restrictions_from_24.groups.mrdi")
save(path, (
    format_version=1,
    parent_number=24,
    method="all n*f^(12/m) with (n*f^(12/m))^m=1, modulo full parent conjugacy",
    parent_cache="source_24_full_lattice_group.mrdi",
    quotient_orders=(3, 6, 12),
    counts_by_order=counts,
    results=Tuple(all_results),
))
check = load(path)
@assert check.parent_number == 24 && length(check.results) == length(all_results)
@assert check.counts_by_order == counts
cyclic_note_24("Saved and reloaded $(length(all_results)) cyclic subgroup classes")
