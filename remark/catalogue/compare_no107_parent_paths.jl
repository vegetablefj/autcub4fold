# Compare the two root-free No. 107 restrictions inside the saved No. 60.
# This script is read-only and does not assign either parent subgroup to the
# numbered geometric family.

using Oscar

const source = joinpath(@__DIR__, "restriction_107_from_60.verified.mrdi")
data = load(source)
@assert data.roots_verified && data.root_free_count == 2
@assert data.all_character_matches_processed
a, b = data.verified_results
@assert Set((a.class_number, b.class_number)) == Set((1, 2))
ra, rb = a.result, b.result

same_basis(x, y) = basis_matrix(lattice(x)) == basis_matrix(lattice(y))

println("class numbers: ", (a.class_number, b.class_number))
println("same S embedding: ", same_basis(ra.S_in_Lambda0, rb.S_in_Lambda0))
println("same T embedding: ", same_basis(ra.T_in_Lambda0, rb.T_in_Lambda0))
println("same T Gram matrix: ",
    gram_matrix(lattice(ra.T_action)) == gram_matrix(lattice(rb.T_action)))
println("same T extra isometry matrix: ",
    isometry(ra.T_action) == isometry(rb.T_action))
println("same P embedding: ",
    basis_matrix(ra.P_in_Lambda0) == basis_matrix(rb.P_in_Lambda0))
println("same K embedding: ",
    basis_matrix(ra.K_in_Lambda0) == basis_matrix(rb.K_in_Lambda0))
println("same full Lambda0 extra generator: ",
    isometry(ra.Lambda0) == isometry(rb.Lambda0))
println("|det(P)|: ",
    (abs(det(gram_matrix(ra.P_in_Lambda0))),
     abs(det(gram_matrix(rb.P_in_Lambda0)))))
println("|det(K)|: ",
    (abs(det(gram_matrix(ra.K_in_Lambda0))),
     abs(det(gram_matrix(rb.K_in_Lambda0)))))
println("same P Gram matrix: ",
    gram_matrix(ra.P_in_Lambda0) == gram_matrix(rb.P_in_Lambda0))
println("same K Gram matrix: ",
    gram_matrix(ra.K_in_Lambda0) == gram_matrix(rb.K_in_Lambda0))
println("same OSCAR isometry type: ",
    is_of_same_type(ra.T_action, rb.T_action))
if "--isometric-P" in ARGS
    pa = integer_lattice(; gram=gram_matrix(ra.P_in_Lambda0))
    pb = integer_lattice(; gram=gram_matrix(rb.P_in_Lambda0))
    println("P abstractly isometric: ",
        is_isometric(pa, pb))
end
