# Read-only check of the exact A_T[3] prefilter for the saved No. 105 actions.
# The glue has order 2^10, so ambient stable actions must fix this quotient.
using Oscar

actions_file = joinpath(@__DIR__, "no105_T_enumeration.mrdi")
data = load(actions_file)
actions = data["T_actions"]
allowed = Int[]
excluded = Int[]
for (i, Tf) in enumerate(actions)
    D, fD = discriminant_group(Tf)
    good = all(fD(ZZ(1024) * x) == ZZ(1024) * x for x in gens(D))
    push!(good ? allowed : excluded, i)
end
println("T actions with trivial A_T[3] action: ", allowed)
println("T actions excluded: ", excluded)
@assert length(allowed) + length(excluded) == length(actions)
