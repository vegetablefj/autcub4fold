# Upgrade the already checked No. 51 -> No. 82 restriction to the complete
# ambient result format of the rank-at-least-15 OSCAR calculations.

include(joinpath(@__DIR__, "restriction_functions.jl"))

const started_at = time()
function note(message)
    println(round(time() - started_at; digits=1), " s | ", message)
    flush(stdout)
end

source_path = joinpath(@__DIR__, "..", "..", "oscar", "oscar_script_data.mrdi")
pilot_path = joinpath(@__DIR__, "restriction_pilot_82_from_51.mrdi")
source = load(source_path)
parent = source.cases[21].results[3]
pilot = load(pilot_path)
@assert pilot.parent_number == 51 && pilot.child_number == 82
note("Loaded parent case 21 result 3 and the verified subgroup pilot")

verify_group = get(ENV, "RESTRICTION_VERIFY_GROUP", "0") == "1"
verify_roots = get(ENV, "RESTRICTION_VERIFY_ROOTS", "0") == "1"
verify_saturation = get(ENV, "RESTRICTION_VERIFY_SATURATION", "0") == "1"
result = complete_cyclic_restriction(
    parent,
    pilot.symplectic_generator_in_parent,
    pilot.extra_generator_in_parent;
    parent_number=51,
    child_number=82,
    index=4,
    expected_rank_S=14,
    expected_dimension=2,
    expected_group_id=(16, 6),
    verify_group_id=verify_group,
    verify_roots=verify_roots,
    verify_symplectic_saturation=verify_saturation,
)
note("Constructed S, T, P, K and their ambient isometries")

@assert gram_matrix(result.T_action) == gram_matrix(pilot.T_extra_action)
@assert isometry(result.T_action) == isometry(pilot.T_extra_action)
@assert rank(lattice(result.P_action)) == 6
@assert rank(result.K_in_Lambda0) == 16
p = characteristic_polynomial(result.T_action)
q = characteristic_polynomial(pilot.T_extra_action)
@assert degree(p) == degree(q)
@assert all(coeff(p, i) == coeff(q, i) for i in 0:degree(p))
note("Independent full-rank T action matches the pilot; P rank 6, K rank 16")

filename = if verify_group && verify_roots && verify_saturation
    "restriction_complete_82_from_51.saturation_checked.mrdi"
elseif verify_group && verify_roots
    "restriction_complete_82_from_51.mrdi"
else
    "restriction_complete_82_from_51.precheck.mrdi"
end
file = joinpath(@__DIR__, filename)
save(file, (
    format_version=1,
    source_file="oscar/oscar_script_data.mrdi case 21 result 3",
    construction="unique subgroup restriction No. 51 -> No. 82",
    verify_group_id=verify_group,
    verify_roots=verify_roots,
    verify_symplectic_saturation=verify_saturation,
    result=result,
))
reloaded = load(file)
@assert rank(lattice(reloaded.result.S_in_Lambda0)) == 14
@assert rank(lattice(reloaded.result.T_in_Lambda0)) == 8
@assert rank(reloaded.result.P_in_Lambda0) == 6
@assert rank(reloaded.result.K_in_Lambda0) == 16
@assert order_of_isometry(reloaded.result.T_action) == 4
note("Saved and reloaded $(basename(file))")
