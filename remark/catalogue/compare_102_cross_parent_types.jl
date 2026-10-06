# Necessary isometry invariants only; not an integral conjugacy certificate.
include(joinpath(@__DIR__, "restriction_101_102_from_67.jl"))

from67 = load(joinpath(@__DIR__, "restriction_101_102_from_67.verified.mrdi"))
from69 = load(joinpath(@__DIR__, "restriction_102_103_from_69.verified.mrdi"))
a = [v for v in from67.verified_results if v.child == 102]
b = only(v for v in from69.verified_results if v.child == 102)
@assert length(a) == 2 && all(v.roots_verified for v in a) && b.roots_verified

for v in (a...,b)
    f = v.result.T_action
    fixed = invariant_lattice(f)
    println("No. 102 parent ", v.parent, ", class ", v.class_number)
    println("T determinant = ", det(gram_matrix(lattice(f))))
    println("T characteristic polynomial = ", characteristic_polynomial(f))
    println("fixed Gram = ", gram_matrix(lattice(fixed)))
    println("P determinant = ", det(gram_matrix(v.result.P_in_Lambda0)))
    println("K determinant = ", det(gram_matrix(v.result.K_in_Lambda0)))
end

for v in a
    println("No. 69 class versus No. 67 class ", v.class_number,
        ": same OSCAR type = ", is_of_same_type(b.result.T_action,
            v.result.T_action))
end
println("Same type is necessary, not sufficient, for integral conjugacy.")
