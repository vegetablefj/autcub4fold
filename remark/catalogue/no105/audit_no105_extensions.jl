# Read-only audit of the completed No. 105 extension output.  This reloads
# existing MRDI data; it does not repeat extension, root, or group enumeration.
using Oscar
using SHA

include(joinpath(@__DIR__, "..", "..", "..", "oscar", "oscar_script.jl"))

same_polynomial(p, q) = degree(p) == degree(q) &&
    all(coeff(p, i) == coeff(q, i) for i in 0:degree(p))

output_dir = get(ENV, "NO105_OUTPUT_DIR", @__DIR__)
result_path = joinpath(output_dir, "no105_extensions.mrdi")
T_actions_path = joinpath(output_dir, "no105_T_enumeration.mrdi")
source_path = joinpath(@__DIR__, "..", "restriction_97_100_from_74.verified.mrdi")

data = load(result_path)
@assert data["format_version"] == 1
@assert data["family_number"] == 105
@assert data["source_no97_sha256"] == bytes2hex(sha256(read(source_path)))
@assert data["T_enumeration_sha256"] == bytes2hex(sha256(read(T_actions_path)))
@assert data["glue_order"] == 1024
@assert data["symplectic_kernel_order_S"] == 4

counts = data["counts"]
@assert counts["extensions"] == sum(counts[k] for k in
    ("nonstable", "wrong_S_character", "roots", "saturation", "wrong_group", "retained"))
results = data["results"] === nothing ? Any[] : data["results"]
@assert length(results) == counts["retained"]
@assert length(data["T_action_indices_excluded_by_discriminant3"]) == 20
@assert length(results) == 1

r = only(results)
@assert 1 <= r.source_T_action_index <= 26
@assert r.order == 6 && r.dimension == 2
@assert r.group_gap_id == (24, 13)
@assert r.symplectic_kernel_order_S == 4
@assert r.roots_verified && r.symplectic_saturation_verified
@assert !r.numbered_assignment_claimed && !data["numbered_assignment_claimed"]

S = lattice(r.S_in_Lambda0)
T = lattice(r.T_in_Lambda0)
P = r.P_in_Lambda0
K = r.K_in_Lambda0
L = lattice(r.Lambda0)
@assert rank(S) == 12 && absdisc_int(S) == 1024
@assert rank(T) == 10 && absdisc_int(T) == 3072
@assert rank(P) == 6 && signature_tuple(P) == (4, 0, 2)
@assert rank(K) == 16 && signature_tuple(K) == (16, 0, 0)
@assert rank(L) == 22 && signature_tuple(L) == (20, 0, 2)
@assert absdisc_int(L) == 3
@assert gram_matrix(lattice(r.T_action)) == gram_matrix(data["T_input"]) ||
    is_isometric(lattice(r.T_action), data["T_input"])
@assert gram_matrix(lattice(r.P_action)) == gram_matrix(P)
@assert order_of_isometry(r.T_action) == 6
@assert order_of_isometry(r.T_in_Lambda0) == 6
@assert order_of_isometry(r.Lambda0) == 6
@assert same_polynomial(characteristic_polynomial(r.T_in_Lambda0),
    data["expected_T_characteristic_polynomial"])
@assert same_polynomial(characteristic_polynomial(r.S_in_Lambda0),
    data["expected_S_characteristic_polynomial"])
@assert trivial_action_on_discriminant(r.Lambda0)

println("AUDIT_PASS")
println("counts=", counts)
println("retained_source_T_action_index=", r.source_T_action_index)
println("retained_extension_index=", r.extension_index)
println("group_gap_id=", r.group_gap_id)
println("S/T/P/K/L ranks=", (rank(S), rank(T), rank(P), rank(K), rank(L)))
println("S/T/L absolute discriminants=", (absdisc_int(S), absdisc_int(T), absdisc_int(L)))
println("root/saturation flags=", (r.roots_verified, r.symplectic_saturation_verified))
println("numbered_assignment_claimed=", data["numbered_assignment_claimed"])
