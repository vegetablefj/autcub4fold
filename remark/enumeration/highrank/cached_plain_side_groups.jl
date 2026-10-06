# Reuse the full O(S) already computed by plain_side_extension_context.
# Include after oscar/oscar_script.jl. No computation runs on include.
# The serializable cache contains matrices, never a GAP homomorphism.

function plain_side_matrix_cache(context)
    S = context.lattice
    N, inclusion = kernel(context.discriminant_representation)
    @assert order(N) == context.tilde_order
    O_matrices = Tuple(Oscar.restrict_to_lattice(S, QQ.(matrix(g)); check=true)
        for g in gens(context.orthogonal_group))
    N_matrices = Tuple(Oscar.restrict_to_lattice(S,
        QQ.(matrix(inclusion(g))); check=true) for g in gens(N))
    return (
        format_version=1,
        S_gram=gram_matrix(S),
        orthogonal_generators_S=O_matrices,
        symplectic_generators_S=N_matrices,
        orthogonal_order=Int(order(context.orthogonal_group)),
        discriminant_image_order=Int(order(context.discriminant_image)),
        symplectic_order=Int(context.tilde_order),
    )
end

function transport_plain_side_matrix_cache(S::ZZLat, cache;
        basis_transport=nothing, check_stability::Bool=true)
    r = rank(S)
    G = gram_matrix(S)
    C = if basis_transport === nothing
        @assert G == cache.S_gram "Different Gram matrices require explicit basis_transport"
        identity_matrix(QQ, r)
    else
        QQ.(basis_transport)
    end
    @assert nrows(C) == ncols(C) == r
    @assert all(denominator(C[i,j]) == 1 for i in 1:r for j in 1:r)
    @assert abs(det(C)) == 1 "Transport must be an integral lattice isomorphism"
    @assert C * cache.S_gram * transpose(C) == G
    Ci = inv(C)
    transport(u) = C * u * Ci
    O_matrices = Tuple(transport(u) for u in cache.orthogonal_generators_S)
    N_matrices = Tuple(transport(u) for u in cache.symplectic_generators_S)
    for u in O_matrices
        @assert all(denominator(u[i,j]) == 1 for i in 1:r for j in 1:r)
        @assert u * G * transpose(u) == G
    end
    if check_stability
        for u in N_matrices
            Su = integer_lattice_with_isometry(S, u;
                ambient_representation=false, check=true)
            @assert trivial_action_on_discriminant(Su)
        end
    end
    return merge(cache, (
        S_gram=G,
        orthogonal_generators_S=O_matrices,
        symplectic_generators_S=N_matrices,
    ))
end

function cached_embedded_group_data(Sf::ZZLatWithIsom, cache;
        basis_transport=nothing, small_group_bound::Int=2000)
    S = lattice(Sf)
    transported = transport_plain_side_matrix_cache(S, cache; basis_transport)
    f = isometry(Sf)
    G = gram_matrix(S)
    @assert f * G * transpose(f) == G
    H = matrix_group(vcat(collect(transported.symplectic_generators_S), [f]))
    full_order = Int(order(H))
    @assert full_order % transported.symplectic_order == 0
    group_id = if full_order <= small_group_bound && has_small_group_identification(full_order)
        small_group_identification(H)
    else
        "order $full_order; StructureDescription = $(describe(H))"
    end
    return merge(transported, (
        group_gap_id=group_id,
        full_group_order=full_order,
        quotient_order=div(full_order, transported.symplectic_order),
        extra_generator_S=f,
    ))
end

# This context can also be passed to a correction helper that uses rho's
# preimages. It recomputes only the finite discriminant representation and
# never calls orthogonal_group(S) or automorphism_group_generators(S).
function cached_embedded_plain_side_context(S::ZZLat, cache;
        basis_transport=nothing)
    transported = transport_plain_side_matrix_cache(S, cache; basis_transport)
    O = matrix_group(collect(transported.orthogonal_generators_S))
    @assert Int(order(O)) == transported.orthogonal_order
    rho = discriminant_representation(S, O;
        ambient_representation=false, full=false, check=true)
    image_group, _ = image(rho)
    @assert Int(order(image_group)) == transported.discriminant_image_order
    return (
        lattice=S,
        discriminant_group=discriminant_group(S),
        orthogonal_group=O,
        discriminant_representation=rho,
        discriminant_image=image_group,
        tilde_order=transported.symplectic_order,
    )
end
