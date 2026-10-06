# Finite E6(2)-side check for cubic-fourfold family No. 127.
# The rank-16 N-side action and the ambient gluing are not checked here.

using Oscar

const C127 = matrix(ZZ, 6, 6, [
    2 -1  0  0  0  0;
   -1  2 -1  0  0  0;
    0 -1  2 -1  0 -1;
    0  0 -1  2 -1  0;
    0  0  0 -1  2  0;
    0  0 -1  0  0  2
])
const I127 = identity_matrix(ZZ, 6)
const PLANE127 = matrix(ZZ, 1, 6, [1, 2, 0, -2, -1, 0])

function matrix_key_127(M)
    return join((string(M[i, j]) for i in 1:nrows(M) for j in 1:ncols(M)), ",")
end

function root_reflection_127(root)
    # Row-vector convention: x -> x - (x,root) root in the E6 root lattice.
    @assert root * C127 * transpose(root) == matrix(ZZ, 1, 1, [2])
    return I127 - (C127 * transpose(root)) * root
end

function simple_root_127(i)
    root = zero_matrix(ZZ, 1, 6)
    root[1, i] = 1
    return root
end

const SIMPLE_REFLECTIONS127 = [root_reflection_127(simple_root_127(i)) for i in 1:6]

function closure_127(generators, seed)
    elements = [seed]
    seen = Set([matrix_key_127(seed)])
    cursor = 1
    while cursor <= length(elements)
        current = elements[cursor]
        for generator in generators
            next = current * generator
            key = matrix_key_127(next)
            if !(key in seen)
                push!(seen, key)
                push!(elements, next)
            end
        end
        cursor += 1
    end
    return elements
end

function roots_127()
    roots = [simple_root_127(i) for i in 1:6]
    seen = Set(matrix_key_127(root) for root in roots)
    cursor = 1
    while cursor <= length(roots)
        root = roots[cursor]
        for reflection in SIMPLE_REFLECTIONS127
            next = root * reflection
            key = matrix_key_127(next)
            if !(key in seen)
                push!(seen, key)
                push!(roots, next)
            end
        end
        cursor += 1
    end
    @assert length(roots) == 72
    @assert all(root -> root * C127 * transpose(root) == matrix(ZZ, 1, 1, [2]), roots)
    return roots
end

function trace_127(M)
    return sum(M[i, i] for i in 1:6)
end

function run_127()
    # The E6 diagram exchanges 1<->5 and 2<->4, fixing 3 and 6.
    diagram = zero_matrix(ZZ, 6, 6)
    for (i, j) in enumerate((5, 4, 3, 2, 1, 6))
        diagram[i, j] = 1
    end
    A_E = -diagram
    s_seed = SIMPLE_REFLECTIONS127[1] * SIMPLE_REFLECTIONS127[5]
    @assert diagram * diagram == I127
    @assert A_E * C127 * transpose(A_E) == C127
    @assert PLANE127 * (2 * C127) * transpose(PLANE127) == matrix(ZZ, 1, 1, [24])
    @assert PLANE127 * A_E == PLANE127
    @assert PLANE127 * s_seed == PLANE127

    # Folding E6 gives C_{W(E6)}(diagram) = W(F4), of order 1152.
    # The second coset in C_{O(E6)}(A_E) is obtained by diagram.
    folded_generators = [
        SIMPLE_REFLECTIONS127[3],
        SIMPLE_REFLECTIONS127[6],
        SIMPLE_REFLECTIONS127[2] * SIMPLE_REFLECTIONS127[4],
        SIMPLE_REFLECTIONS127[1] * SIMPLE_REFLECTIONS127[5],
    ]
    folded_group = closure_127(folded_generators, I127)
    @assert length(folded_group) == 1152
    @assert all(w -> w * A_E == A_E * w && w * C127 * transpose(w) == C127,
                folded_group)
    folded_keys = Set(matrix_key_127(w) for w in folded_group)
    @assert all(w -> !(matrix_key_127(w * diagram) in folded_keys), folded_group)

    candidates = Dict{String, Any}()
    for w in folded_group, coset in (I127, diagram)
        s = w * coset
        if s * s == I127 && s * A_E == A_E * s && PLANE127 * s == PLANE127 &&
           trace_127(s) == 2 && trace_127(A_E * s) == -2
            candidates[matrix_key_127(s)] = s
        end
    end
    @assert length(candidates) == 4
    @assert haskey(candidates, matrix_key_127(s_seed))

    # Independently identify each candidate as two orthogonal-root reflections.
    roots = roots_127()
    pair_witnesses = Dict{String, Any}()
    pair_count = 0
    for i in 1:length(roots), j in (i + 1):length(roots)
        alpha, beta = roots[i], roots[j]
        alpha * C127 * transpose(beta) == zero_matrix(ZZ, 1, 1) || continue
        s = root_reflection_127(alpha) * root_reflection_127(beta)
        key = matrix_key_127(s)
        if haskey(candidates, key)
            pair_count += 1
            get!(pair_witnesses, key, (alpha, beta))
        end
    end
    @assert length(pair_witnesses) == 4
    @assert pair_count == 16 # Four sign choices for each root pair.

    stabilizer = [w for w in folded_group if PLANE127 * w == PLANE127]
    @assert length(stabilizer) == 384
    ordered_keys = [matrix_key_127(s_seed)]
    append!(ordered_keys, sort([key for key in keys(candidates) if key != ordered_keys[1]]))
    witnesses = Any[]
    for key in ordered_keys
        target = candidates[key]
        place = findfirst(w -> w * s_seed == target * w, stabilizer)
        @assert place !== nothing
        push!(witnesses, stabilizer[place])
    end

    report = IOBuffer()
    println(report, "Family 127: finite E6(2)-side involution audit")
    println(report, "E6 roots = 72; folded centralizer = 1152; plane stabilizer = 384")
    println(report, "Candidates = 4; orthogonal-root-pair presentations = 16")
    println(report, "Plane vector = ", PLANE127, "; norm in E6(2) = 24")
    for (i, key) in enumerate(ordered_keys)
        alpha, beta = pair_witnesses[key]
        println(report, "\nCandidate ", i, i == 1 ? " (chosen seed)" : "")
        println(report, "s_E = ", candidates[key])
        println(report, "orthogonal roots = ", alpha, " and ", beta)
        println(report, "plane-stabilizer conjugator from seed = ", witnesses[i])
    end
    println(report, "\nAll four candidates form one orbit under the plane stabilizer: true")
    println(report, "This does not construct the N-side involution or test the ambient glue.")
    result = String(take!(report))
    print(result)

    output = joinpath(@__DIR__, "family_127_e6_involution.out")
    if isfile(output)
        read(output, String) == result || error("Existing output differs: $output")
    else
        open(output, "w") do io
            write(io, result)
        end
    end
end

run_127()
