# Read-only comparison of the two saved No. 88 and No. 89 parent paths.
# Literal equality is strong evidence; unequal matrices do not prove inequivalence.

include(joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))

data = load(joinpath(@__DIR__,
    "restriction_same_s3_from_94_95_96.verified.mrdi"))
@assert data.format_version == 1 && data.roots_verified
@assert data.match_count == 7

function path_result(child,parent)
    return only(r.result for r in data.verified_results if
        r.child_number == child && r.parent_number == parent)
end

function full_subgroup_keys(r,index)
    nctx = direct_context(r.symplectic_generators_in_parent,
        r.extra_generator_in_parent,6,index)
    f = r.extra_generator_in_parent
    keys = Set(direct_matrix_key(n*f^k) for k in 0:index-1
        for n in nctx.elements)
    @assert length(keys) == 6*index
    return keys
end

for (child,index) in ((88,2),(89,4))
    a,b = path_result(child,94),path_result(child,95)
    La,Lb = lattice(a.Lambda0),lattice(b.Lambda0)
    same_ambient = basis_matrix(La) == basis_matrix(Lb) &&
        gram_matrix(La) == gram_matrix(Lb)
    println("No. $child, parents 94/95:")
    println("  same ambient Lambda0 basis and Gram: ",same_ambient)
    println("  same embedded S basis: ",
        basis_matrix(lattice(a.S_in_Lambda0)) ==
        basis_matrix(lattice(b.S_in_Lambda0)))
    println("  same embedded T basis: ",
        basis_matrix(lattice(a.T_in_Lambda0)) ==
        basis_matrix(lattice(b.T_in_Lambda0)))
    println("  same T Gram: ",
        gram_matrix(lattice(a.T_action)) == gram_matrix(lattice(b.T_action)))
    println("  same T extra-action matrix: ",
        isometry(a.T_action) == isometry(b.T_action))
    println("  same P embedding: ",
        basis_matrix(a.P_in_Lambda0) == basis_matrix(b.P_in_Lambda0))
    println("  same K embedding: ",
        basis_matrix(a.K_in_Lambda0) == basis_matrix(b.K_in_Lambda0))
    if same_ambient
        println("  same full subgroup literally in common Lambda0: ",
            full_subgroup_keys(a,index) == full_subgroup_keys(b,index))
    end
    flush(stdout)
end
