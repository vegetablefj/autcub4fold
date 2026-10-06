# Exact, dependency-free character calculation for the six cases in
# maximal_family_data.jl.  This script uses only Julia's standard library.

include(joinpath(@__DIR__, "maximal_family_data.jl"))

const TARGET_JACOBIAN_DEGREES = (0, 3, 6)

euler_phi(n::Int) = count(k -> gcd(k, n) == 1, 1:n)

function add_characters(a::Tuple, b::Tuple, moduli::Vector{Int})
    return Tuple(mod(a[i] + b[i], moduli[i]) for i in eachindex(moduli))
end

function scale_character(k::Int, a::Tuple, moduli::Vector{Int})
    return Tuple(mod(k * a[i], moduli[i]) for i in eachindex(moduli))
end

"""
Return the character multiplicities on R_0 + R_3 + R_6 of the Jacobian
ring, with the determinant twist giving primitive H^4 pullback.

Each row of `weight_rows` records one cyclic character on the six
coordinates; `moduli` records its modulus.  The cubic is assumed invariant,
not merely semi-invariant.
"""
function primitive_h4_spectrum(weight_rows::Vector{Vector{Int}}, moduli::Vector{Int})
    length(weight_rows) == length(moduli) || error("One modulus is required per weight row")
    all(length(row) == 6 for row in weight_rows) || error("Expected six coordinate weights")
    r = length(moduli)
    coordinate_characters = [
        Tuple(mod(weight_rows[j][i], moduli[j]) for j in 1:r) for i in 1:6
    ]

    states = Dict{Any, Int}((0, Tuple(zeros(Int, r))) => 1)
    for weight in coordinate_characters
        factor = Dict{Any, Int}()
        for degree in 0:6
            denominator_character = scale_character(degree, weight, moduli)
            factor[(degree, denominator_character)] =
                get(factor, (degree, denominator_character), 0) + 1
            if degree >= 2
                numerator_character = scale_character(degree - 3, weight, moduli)
                factor[(degree, numerator_character)] =
                    get(factor, (degree, numerator_character), 0) - 1
            end
        end

        next_states = Dict{Any, Int}()
        for ((degree_a, char_a), multiplicity_a) in states
            for ((degree_b, char_b), multiplicity_b) in factor
                degree = degree_a + degree_b
                degree > 6 && continue
                char = add_characters(char_a, char_b, moduli)
                next_states[(degree, char)] =
                    get(next_states, (degree, char), 0) + multiplicity_a * multiplicity_b
            end
        end
        states = Dict(key => value for (key, value) in next_states if value != 0)
    end

    determinant_character = Tuple(
        mod(sum(weight_rows[j]), moduli[j]) for j in eachindex(moduli)
    )
    result = Dict{Tuple, Int}()
    for ((degree, char), multiplicity) in states
        degree in TARGET_JACOBIAN_DEGREES || continue
        twisted = add_characters(char, determinant_character, moduli)
        result[twisted] = get(result, twisted, 0) + multiplicity
    end
    sum(values(result)) == 22 || error("Primitive H^4 must have rank 22")
    return result
end

function cyclotomic_factorization(spectrum::Dict{Int, Int}, modulus::Int)
    by_order = Dict{Int, Int}()
    for (exponent, multiplicity) in spectrum
        order = exponent == 0 ? 1 : div(modulus, gcd(modulus, exponent))
        by_order[order] = get(by_order, order, 0) + multiplicity
    end
    factors = Dict{Int, Int}()
    for order in sort(collect(keys(by_order)))
        degree = euler_phi(order)
        by_order[order] % degree == 0 || error("Non-rational spectrum in order-$order block")
        multiplicity = div(by_order[order], degree)
        primitive_exponents = [
            e for e in 0:(modulus - 1)
            if (e == 0 ? 1 : div(modulus, gcd(modulus, e))) == order
        ]
        observed = [get(spectrum, e, 0) for e in primitive_exponents]
        all(value == multiplicity for value in observed) ||
            error("Unequal Galois multiplicities in order-$order block")
        factors[order] = multiplicity
    end
    return factors
end

function factor_string(factors::Dict{Int, Int})
    isempty(factors) && return "1"
    pieces = String[]
    for order in sort(collect(keys(factors)))
        exponent = factors[order]
        push!(pieces, exponent == 1 ? "Phi$order" : "Phi$order^$exponent")
    end
    return join(pieces, " * ")
end

function spectrum_string(spectrum::Dict{Int, Int})
    return join(["$e:$(spectrum[e])" for e in sort(collect(keys(spectrum)))], ", ")
end

function coordinate_polynomial_string(weights::Vector{Int}, modulus::Int)
    counts = Dict{Int, Int}()
    for weight in weights
        exponent = mod(weight, modulus)
        counts[exponent] = get(counts, exponent, 0) + 1
    end
    pieces = String[]
    for exponent in sort(collect(keys(counts)))
        root = exponent == 0 ? "1" : "zeta_$(modulus)^$exponent"
        factor = "(u - $root)"
        counts[exponent] > 1 && (factor *= "^$(counts[exponent])")
        push!(pieces, factor)
    end
    return join(pieces, " ")
end

function cubic_exponents()
    result = NTuple{6, Int}[]
    function extend(prefix::Vector{Int}, remaining::Int, coordinate::Int)
        if coordinate == 6
            push!(result, Tuple(vcat(prefix, remaining)))
            return
        end
        for exponent in remaining:-1:0
            extend(vcat(prefix, exponent), remaining - exponent, coordinate + 1)
        end
    end
    extend(Int[], 3, 1)
    return result
end

function monomial_string(exponents::NTuple{6, Int})
    pieces = String[]
    for i in 1:6
        exponent = exponents[i]
        exponent == 0 && continue
        push!(pieces, exponent == 1 ? "x$i" : "x$i^$exponent")
    end
    return join(pieces, "*")
end

function invariant_monomials(exponents, weight_rows, moduli)
    return [
        exponent for exponent in exponents
        if all(mod(sum(weight_rows[j][i] * exponent[i] for i in 1:6), moduli[j]) == 0
               for j in eachindex(moduli))
    ]
end

function check_invariant_basis(case, all_monomials)
    if case.number == 96
        diagonal_invariants = invariant_monomials(
            all_monomials,
            [case.diagonal_exponents],
            [case.diagonal_modulus],
        )
        diagonal_set = Set(diagonal_invariants)
        visited = Set{NTuple{6, Int}}()
        fixed_basis = String[]
        for exponent in diagonal_invariants
            exponent in visited && continue
            swapped = (exponent[1], exponent[2], exponent[3], exponent[4], exponent[6], exponent[5])
            if swapped == exponent
                push!(fixed_basis, monomial_string(exponent))
                push!(visited, exponent)
            elseif swapped in diagonal_set
                push!(fixed_basis, monomial_string(exponent) * " + " * monomial_string(swapped))
                push!(visited, exponent)
                push!(visited, swapped)
            else
                # A P-fixed vector cannot use an orbit which leaves the
                # diagonal-invariant subspace.
                push!(visited, exponent)
            end
        end
        fixed_basis == case.invariant_basis ||
            error("No.96 diagonal-plus-swap invariant basis does not match")
    elseif case.number == 127
        h_invariants = invariant_monomials(
            all_monomials,
            [case.symplectic_involution_exponents],
            [2],
        )
        simultaneous = invariant_monomials(
            h_invariants,
            [case.diagonal_exponents],
            [case.diagonal_modulus],
        )
        local_indices = findall(exponent -> exponent in simultaneous, h_invariants)
        local_indices == case.invariant_basis_indices ||
            error("No.127 local C2 basis indices do not match")
        map(monomial_string, simultaneous) == case.invariant_basis ||
            error("No.127 expanded invariant basis does not match")
    else
        invariants = invariant_monomials(
            all_monomials,
            [case.diagonal_exponents],
            [case.diagonal_modulus],
        )
        global_indices = findall(exponent -> exponent in invariants, all_monomials)
        global_indices == case.invariant_basis_indices ||
            error("No.$(case.number) global cubic basis indices do not match")
        map(monomial_string, invariants) == case.invariant_basis ||
            error("No.$(case.number) expanded invariant basis does not match")
    end
end

function rank_of_factorization(factors::Dict{Int, Int})
    return sum(
        (euler_phi(order) * multiplicity for (order, multiplicity) in factors);
        init = 0,
    )
end

function combined_factorization(left::Dict{Int, Int}, right::Dict{Int, Int})
    result = copy(left)
    for (order, multiplicity) in right
        result[order] = get(result, order, 0) + multiplicity
    end
    return result
end

function check_signatures(case)
    signature_ranks = Dict("S" => 0, "T" => 0)
    positives = Dict("S" => 0, "T" => 0)
    negatives = Dict("S" => 0, "T" => 0)
    for block in case.signature_blocks
        block_rank = euler_phi(block.cyclotomic) * block.multiplicity
        sum(block.signature) == block_rank ||
            error("No.$(case.number) has a signature of the wrong rank")
        signature_ranks[block.location] += block_rank
        positives[block.location] += block.signature[1]
        negatives[block.location] += block.signature[2]
    end
    signature_ranks["S"] == case.rank_S || error("No.$(case.number) S-signature rank mismatch")
    signature_ranks["T"] == case.rank_T || error("No.$(case.number) T-signature rank mismatch")
    negatives["S"] == 0 || error("No.$(case.number) S must be positive definite")
    (positives["T"], negatives["T"]) == (case.rank_T - 2, 2) ||
        error("No.$(case.number) T must have signature (rank(T)-2,2)")
end

function print_case(case, all_monomials)
    check_invariant_basis(case, all_monomials)
    modulus = case.diagonal_modulus
    full_tuple_spectrum = primitive_h4_spectrum([case.diagonal_exponents], [modulus])
    full_spectrum = Dict(key[1] => value for (key, value) in full_tuple_spectrum)
    full_factors = cyclotomic_factorization(full_spectrum, modulus)
    full_factors == case.expected_full_character ||
        error("No.$(case.number) full characteristic polynomial does not match")
    mod(sum(case.diagonal_exponents), modulus) == case.determinant_exponent ||
        error("No.$(case.number) determinant exponent does not match")
    div(modulus, gcd(modulus, case.determinant_exponent)) == case.full_index ||
        error("No.$(case.number) H^(3,1) eigenvalue is not primitive of the full index")

    T_factors = case.expected_T_character
    S_factors = case.expected_S_character
    if case.number == 127
        joint = primitive_h4_spectrum(
            [case.diagonal_exponents, case.symplectic_involution_exponents],
            [4, 2],
        )
        T_spectrum = Dict{Int, Int}()
        S_spectrum = Dict{Int, Int}()
        for ((extra_exponent, involution_exponent), multiplicity) in joint
            target = involution_exponent == 0 ? T_spectrum : S_spectrum
            target[extra_exponent] = get(target, extra_exponent, 0) + multiplicity
        end
        T_factors = cyclotomic_factorization(T_spectrum, 4)
        S_factors = cyclotomic_factorization(S_spectrum, 4)
        T_factors == case.expected_T_character || error("No.127 T-character mismatch")
        S_factors == case.expected_S_character || error("No.127 S-character mismatch")
    end

    rank_of_factorization(T_factors) == case.rank_T ||
        error("No.$(case.number) T-character has the wrong rank")
    rank_of_factorization(S_factors) == case.rank_S ||
        error("No.$(case.number) S-character has the wrong rank")
    combined_factorization(S_factors, T_factors) == full_factors ||
        error("No.$(case.number) S and T characters do not recover primitive H^4")
    get(T_factors, case.full_index, 0) - 1 == case.family_dimension ||
        error("No.$(case.number) primitive period eigenspace has the wrong dimension")
    case.invariant_dimension - case.centralizer_dimension == case.family_dimension ||
        error("No.$(case.number) family dimension does not match")
    check_signatures(case)

    println("No.$(case.number): $(case.projective_group)")
    println("  projective ID=$(case.projective_group_id); strict-linear ID=$(case.strict_linear_group_id)")
    println("  ranks: S=$(case.rank_S), T=$(case.rank_T); family dimension=$(case.family_dimension)")
    println("  chosen diagonal/cyclic lift: m=$modulus, weights=$(case.diagonal_exponents)")
    println("  coordinate characteristic polynomial: ",
            coordinate_polynomial_string(case.diagonal_exponents, modulus))
    println("  determinant/H^(3,1) exponent: $(case.determinant_exponent) mod $modulus")
    println("  primitive-H4 eigenvalue exponents (exponent:multiplicity): ",
            spectrum_string(full_spectrum))
    println("  chi(H4_prim) = ", factor_string(full_factors))
    println("  chi(T)       = ", factor_string(T_factors))
    println("  chi(S)       = ", factor_string(S_factors))
    println("  invariant cubic dimension=$(case.invariant_dimension); centralizer dimension=$(case.centralizer_dimension)")
    println("  invariant cubic basis:")
    for basis_element in case.invariant_basis
        println("    ", basis_element)
    end
    println("  cyclotomic signatures:")
    for block in case.signature_blocks
        println("    $(block.location): Phi$(block.cyclotomic)^$(block.multiplicity) -> $(block.signature)")
    end
    println()
end

println("Exact Hodge-character data for six low-rank action-maximal families")
println("Convention: x |-> A*x, A^*F=F, and pullback on primitive H^4.")
println("Jacobian degrees used: R_0 + R_3 + R_6, with determinant twist.")
println()

all_monomials = cubic_exponents()
length(all_monomials) == 56 || error("Expected 56 cubic monomials")
for case in maximal_family_data
    print_case(case, all_monomials)
end

println("ALL EXACT CHARACTER AND CUBIC-BASIS CHECKS PASSED")
