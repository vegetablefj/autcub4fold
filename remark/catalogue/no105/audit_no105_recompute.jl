# Independent read-only recomputation of the expensive checks on the sole
# saved integral No. 105 candidate.  No isometry classes are re-enumerated.
using Oscar
using Dates

include(joinpath(@__DIR__, "..", "..", "..", "oscar", "oscar_script.jl"))

function progress(message)
    println(Dates.format(now(UTC), dateformat"yyyy-mm-ddTHH:MM:SS"), "Z | ", message)
    flush(stdout)
end

output_dir = get(ENV, "NO105_OUTPUT_DIR", @__DIR__)
data = load(joinpath(output_dir, "no105_extensions.mrdi"))
@assert data["family_number"] == 105
@assert data["counts"]["retained"] == 1
r = only(data["results"])
@assert 1 <= r.source_T_action_index <= 26 && r.extension_index >= 1

K = r.K_in_Lambda0
L = lattice(r.Lambda0)
S = lattice(r.S_in_Lambda0)
progress("Recomputing short/long root obstruction")
@assert !has_root(K, L)
progress("Root check passed; recomputing discriminant-kernel orders")
ordS = discriminant_kernel_order(S)
ordK = discriminant_kernel_order(K)
@assert ordS == 4 && ordK == 4
progress("Kernel orders S/K = $(ordS)/$(ordK); recomputing projective group ID")
id = practical_group_gap_id(r.S_in_Lambda0)
@assert id == (24, 13)
progress("RECOMPUTE_AUDIT_PASS: no roots; S/K kernel orders 4/4; group ID (24,13)")
