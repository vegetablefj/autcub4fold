# Exact same-type test; equality here is weaker than integral isometry.
include(joinpath(@__DIR__, "restriction_101_102_from_67.jl"))

data = load(joinpath(@__DIR__, "restriction_101_102_from_67.verified.mrdi"))
candidates = [v for v in data.verified_results if v.child == 102]
@assert length(candidates) == 2
for v in candidates
    @assert v.roots_verified && v.result.order == 3
end
println("No. 102 classes 1 and 2: testing OSCAR type of T with isometry")
flush(stdout)
same = is_of_same_type(candidates[1].result.T_action,
    candidates[2].result.T_action)
println("same type = ", same)
println("This test does not assert an integral conjugating matrix.")
