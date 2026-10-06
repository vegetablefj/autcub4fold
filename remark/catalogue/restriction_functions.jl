# Complete lattice data for subgroup restrictions with a cyclic symplectic part.
# Input matrices act in the saved Lambda0 lattice basis (row convention).

using Oscar

include(joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl"))

function small_full_group_id_and_kernel_order(Sf::ZZLatWithIsom)
    S = lattice(Sf)
    O = matrix_group(automorphism_group_generators(
        S; ambient_representation=false,
    ))
    f = O(isometry(Sf))
    rho = discriminant_representation(
        S, O; ambient_representation=false, full=false, check=true,
    )
    tildeO, inclusion = kernel(rho)
    H, _ = sub(O, vcat([inclusion(g) for g in gens(tildeO)], [f]))
    @assert has_small_group_identification(order(H))
    return small_group_identification(H), order(tildeO)
end

function complete_cyclic_restriction(
    parent_result,
    symplectic_generator,
    extra_generator;
    child_number::Int,
    parent_number::Int,
    index::Int,
    expected_rank_S::Int,
    expected_dimension::Int,
    expected_group_id=nothing,
    verify_group_id::Bool=false,
    verify_roots::Bool=false,
    verify_symplectic_saturation::Bool=false,
)
    L = lattice(parent_result.Lambda0)
    @assert rank(L) == 22 && signature_tuple(L) == (20, 0, 2)
    @assert abs(det(gram_matrix(L))) == 3

    symplectic_action = integer_lattice_with_isometry(
        L, symplectic_generator;
        ambient_representation=false, check=true,
    )
    S = lattice(coinvariant_lattice(symplectic_action))
    T = lattice(invariant_lattice(symplectic_action))
    @assert rank(S) == expected_rank_S && rank(T) == 22 - expected_rank_S
    @assert signature_tuple(S) == (rank(S), 0, 0)
    @assert signature_tuple(T) == (rank(T) - 2, 0, 2)

    Lambda0 = integer_lattice_with_isometry(
        L, extra_generator;
        ambient_representation=false, check=true,
    )
    @assert trivial_action_on_discriminant(Lambda0)
    Simg = lattice_in_same_ambient_space(
        Lambda0, basis_matrix(S); check=true,
    )
    Timg = lattice_in_same_ambient_space(
        Lambda0, basis_matrix(T); check=true,
    )
    @assert rank(lattice(Simg)) == rank(S)
    @assert rank(lattice(Timg)) == rank(T)
    @assert basis_matrix(S) * gram_matrix(ambient_space(L)) * transpose(basis_matrix(T)) ==
        zero_matrix(QQ, rank(S), rank(T))

    Taction = full_rank_model(Timg)
    @assert order_of_isometry(Taction) == index
    pk = embedded_PK_data(Lambda0, Timg, index)
    P = pk.P_lattice
    K = pk.K_lattice
    @assert rank(P) + rank(K) == 22
    @assert signature_tuple(P) == (rank(P) - 2, 0, 2)
    @assert signature_tuple(K) == (rank(K), 0, 0)
    @assert period_dimension(P, index) == expected_dimension
    if verify_roots
        @assert !has_root(K, L)
    end

    computed_group_id = nothing
    kernel_order_S = nothing
    if verify_group_id
        computed_group_id, kernel_order_S =
            small_full_group_id_and_kernel_order(Simg)
        @assert expected_group_id !== nothing
        @assert computed_group_id == expected_group_id
    end

    # The group ID above is computed in O(S), where the coset order of f
    # need not equal its order on T.  Determine tilde O(S) independently;
    # compare it with the symplectic intersection of the extracted subgroup,
    # then apply the ambient-lattice catalogue's tilde O(K) equality test.
    kernel_order_K = nothing
    if verify_symplectic_saturation
        @assert verify_group_id
        @assert computed_group_id isa Tuple && computed_group_id[1] % index == 0
        @assert kernel_order_S == div(expected_group_id[1], index)
        kernel_order_K = discriminant_kernel_order(K)
        @assert kernel_order_K == kernel_order_S
    end

    return (
        order=index,
        dimension=expected_dimension,
        S_in_Lambda0=Simg,
        T_in_Lambda0=Timg,
        T_action=Taction,
        K_in_Lambda0=K,
        P_in_Lambda0=P,
        P_action=pk.P_with_isometry,
        Lambda0=Lambda0,
        group_gap_id=computed_group_id,
        symplectic_kernel_order_S=kernel_order_S,
        symplectic_kernel_order_K=kernel_order_K,
        symplectic_saturation_verified=verify_symplectic_saturation,
        extracted_subgroup_id=expected_group_id,
        group_id_source=verify_group_id ? "recomputed from embedded S" : "parent subgroup; independent check pending",
        parent_number=parent_number,
        child_number=child_number,
        symplectic_generator_in_parent=symplectic_generator,
        extra_generator_in_parent=extra_generator,
    )
end
