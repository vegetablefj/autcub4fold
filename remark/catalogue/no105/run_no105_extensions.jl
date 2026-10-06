# Post-enumeration primitive-extension search for No. 105 (OSCAR 1.8.x).
# The input T actions are produced by run_no105_T_enumeration.jl.  The exact
# S and T lattices come from the same verified No. 97 class-1 restriction.
#
# This searches integral lattice actions with the No. 105 Fermat character.
# Nos. 104 and 105 have the same group ID, index and period dimension, so a
# surviving lattice action is not assigned to the numbered No. 105 row here.
# That assignment needs the separate geometric comparison with the frozen
# No. 105 projective representation (or the Fermat subgroup of No. 1).

using Oscar
using Dates
using SHA

include(joinpath(@__DIR__, "..", "..", "..", "oscar", "oscar_script.jl"))

const NO105_DIR = get(ENV, "NO105_OUTPUT_DIR", @__DIR__)
isdir(NO105_DIR) || error("Output directory does not exist: $NO105_DIR")
const NO105_SOURCE = joinpath(@__DIR__, "..", "restriction_97_100_from_74.verified.mrdi")
const NO105_T_ACTIONS = joinpath(NO105_DIR, "no105_T_enumeration.mrdi")
const NO105_RESULT = joinpath(NO105_DIR, "no105_extensions.mrdi")
const NO105_LOG = joinpath(NO105_DIR, "no105_extensions.log")

function no105_progress(message)
    line = string(Dates.format(now(UTC), dateformat"yyyy-mm-ddTHH:MM:SS"),
                  "Z | ", message)
    println(line)
    flush(stdout)
    open(NO105_LOG, "a") do io
        println(io, line)
    end
end

function no105_same_polynomial(p, q)
    degree(p) == degree(q) || return false
    return all(coeff(p, i) == coeff(q, i) for i in 0:degree(p))
end

# The gluing subgroup has 2-power order, while A_T has order 2^10 * 3.
# Therefore the residual order-three part of A_Lambda0 comes entirely from
# A_T.  A stable ambient action must fix it.  Multiplication by 2^10 kills
# every 2-primary element of A_T and maps A_T onto its order-three part.
# Testing these images of generators is an exact necessary condition; it does
# not assert that a surviving T action has an ambient extension.
function no105_trivial_action_on_T_discriminant3(Tf)
    D, fD = discriminant_group(Tf)
    generators = collect(gens(D))
    return all(fD(ZZ(1024) * x) == ZZ(1024) * x for x in generators)
end

v"1.8.0" <= pkgversion(Oscar) < v"1.9.0" ||
    error("This script requires OSCAR 1.8.x")
isfile(NO105_SOURCE) || error("Missing verified No. 97 source: $NO105_SOURCE")

no105_progress("Loading exact S and T from verified No. 97 class 1")
source_data = load(NO105_SOURCE)
@assert source_data.format_version == 1
source_result = only(v for v in source_data.verified_results
    if v.child == 97 && v.parent == 74 && v.class_number == 1)
S = lattice(source_result.result.S_in_Lambda0)
T = lattice(source_result.result.T_in_Lambda0)
@assert rank(S) == 12 && signature_tuple(S) == (12, 0, 0)
@assert rank(T) == 10 && signature_tuple(T) == (8, 0, 2)
@assert absdisc_int(S) == 1024
@assert absdisc_int(T) == 3072

# [Lambda_0 : S+T]^2 = |A_S| |A_T| / 3.  Here the glue has order |A_S|,
# leaving an order-three residual discriminant on the T side.  In particular,
# the shared script's opposite-orientation index-two S-side correction does
# not apply; the ambient isometry must already fix A_Lambda0.
glue_order = glue_order_to_disc3(S, T)
@assert glue_order == 1024 && glue_order == absdisc_int(S)
@assert !disc_S_equals_3disc_T(S, T)

Qx, _ = polynomial_ring(QQ, "x")
phi1 = cyclotomic_polynomial(1, Qx)
phi2 = cyclotomic_polynomial(2, Qx)
phi3 = cyclotomic_polynomial(3, Qx)
phi6 = cyclotomic_polynomial(6, Qx)
expected_T_char = phi1 * phi2^3 * phi6^3
expected_T_min = phi1 * phi2 * phi6
# On the Fermat specialization the full primitive-H4 traces of t^0,...,t^5
# are (22,1,1,-2,1,1), while those on T are (10,1,1,-8,1,1).
# Their difference gives the S character below.  A standalone GAP character
# certificate and the geometric row assignment remain separate tasks.
expected_S_char = phi1^3 * phi2 * phi3^3 * phi6
expected_S_min = phi1 * phi2 * phi3 * phi6
@assert degree(expected_T_char) == rank(T)
@assert degree(expected_S_char) == rank(S)
no105_progress("Input checked: rank(S)=12, det(S)=1024; rank(T)=10, det(T)=3072; glue order=1024")

if get(ENV, "NO105_EXTENSIONS_PREFLIGHT", "0") == "1"
    no105_progress("PREFLIGHT_COMPLETE: no T-action file loaded or primitive extension started")
    exit(0)
end

isfile(NO105_T_ACTIONS) || error("Missing completed T enumeration: $NO105_T_ACTIONS")
ispath(NO105_RESULT) && error("Refusing to overwrite existing result: $NO105_RESULT")
enumerated = load(NO105_T_ACTIONS)
@assert enumerated["family_number"] == 105
@assert gram_matrix(enumerated["T_input"]) == gram_matrix(T)
@assert no105_same_polynomial(enumerated["expected_characteristic_polynomial"], expected_T_char)
@assert no105_same_polynomial(enumerated["expected_minimal_polynomial"], expected_T_min)
actions = enumerated["T_actions"]
@assert length(actions) == enumerated["exact_input_T_action_count"]
@assert !isempty(actions)
no105_progress("Loaded $(length(actions)) exact-T order-six action class(es)")

# The generic symplectic kernel is V4.  Compute its discriminant-kernel order
# independently once, then reuse the value in the K-saturation tests.
ordS = discriminant_kernel_order(S)
@assert ordS == 4
k_order_cache = Dict{Any, Any}()

counts = Dict(
    "extensions" => 0,
    "nonstable" => 0,
    "wrong_S_character" => 0,
    "roots" => 0,
    "saturation" => 0,
    "wrong_group" => 0,
    "retained" => 0,
)
records = Any[]
excluded_T_action_indices = Int[]
started = time()
for (action_index, Tf) in enumerate(actions)
    @assert order_of_isometry(Tf) == 6
    @assert no105_same_polynomial(characteristic_polynomial(Tf), expected_T_char)
    @assert no105_same_polynomial(minimal_polynomial(Tf), expected_T_min)
    @assert gram_matrix(lattice(Tf)) == gram_matrix(T) || is_isometric(lattice(Tf), T)

    if !no105_trivial_action_on_T_discriminant3(Tf)
        push!(excluded_T_action_indices, action_index)
        no105_progress("Skipped T-action $action_index: nontrivial action on residual A_T[3]")
        continue
    end

    checkpoint = joinpath(NO105_DIR,
        "no105_extensions_action_$(lpad(string(action_index), 2, '0')).mrdi")
    if isfile(checkpoint)
        saved = load(checkpoint)
        @assert saved["family_number"] == 105
        @assert saved["T_action_index"] == action_index
        saved_counts = saved["counts_cumulative"]
        @assert all(haskey(saved_counts, k) && saved_counts[k] >= counts[k]
                    for k in keys(counts))
        saved_records = saved["results"] === nothing ? Any[] : saved["results"]
        # This also catches an old cumulative checkpoint that included work
        # from a T action excluded by the new exact 3-primary prefilter.
        @assert saved_counts["retained"] - counts["retained"] == length(saved_records)
        append!(records, saved_records)
        for k in keys(counts)
            counts[k] = saved_counts[k]
        end
        no105_progress("Resumed completed T-action $action_index from checkpoint")
        continue
    end

    first_record_index = length(records) + 1
    no105_progress("Starting primitive extensions for T-action $action_index/$(length(actions))")

    # H_S=A_S, but its fitting lifts can differ by the four-element stable
    # kernel.  Unlike the No. 127 E8(2) shortcut, a first lift need not have
    # the prescribed S character.  Enumerate all fitting classes.
    ok, extensions = equivariant_primitive_extensions(
        S, Tf;
        glue_order=[glue_order],
        even=true,
        classification=:subsub,
        compute_bar_Gf=false,
        first_fitting_isometry=false,
    )
    if !ok
        no105_progress("T-action $action_index has no fitting primitive extension")
        continue
    end
    no105_progress("T-action $action_index has $(length(extensions)) fitting extension class(es)")

    for (extension_index, (Lf, Simg, Timg)) in enumerate(extensions)
        counts["extensions"] += 1
        @assert rank(lattice(Simg)) == 12 && absdisc_int(lattice(Simg)) == 1024
        @assert rank(lattice(Timg)) == 10 && absdisc_int(lattice(Timg)) == 3072
        @assert rank(lattice(Lf)) == 22
        @assert signature_tuple(lattice(Lf)) == (20, 0, 2)
        @assert absdisc_int(lattice(Lf)) == 3
        @assert order_of_isometry(Timg) == 6
        @assert no105_same_polynomial(characteristic_polynomial(Timg), expected_T_char)

        if !trivial_action_on_discriminant(Lf)
            counts["nonstable"] += 1
            continue
        end
        if order_of_isometry(Simg) != 6 ||
           !no105_same_polynomial(characteristic_polynomial(Simg), expected_S_char) ||
           !no105_same_polynomial(minimal_polynomial(Simg), expected_S_min)
            counts["wrong_S_character"] += 1
            continue
        end

        test = lattice_data_after_root_and_symplectic_tests(
            S, Lf, Simg, Timg, 6;
            ordS=ordS,
            k_order_cache=k_order_cache,
        )
        if !test.ok
            if test.reason == :root_obstruction
                counts["roots"] += 1
            else
                @assert test.reason == :tildeO_orders_mismatch
                counts["saturation"] += 1
            end
            continue
        end
        @assert test.reason == :tildeO_orders_match
        P = test.P_lattice
        K = test.K_lattice
        @assert rank(P) == 6 && signature_tuple(P) == (4, 0, 2)
        @assert rank(K) == 16 && signature_tuple(K) == (16, 0, 0)
        @assert period_dimension(P, 6) == 2

        group_id = practical_group_gap_id(Simg)
        if group_id != (24, 13)
            counts["wrong_group"] += 1
            continue
        end

        push!(records, (
            source_T_action_index=action_index,
            extension_index=extension_index,
            order=6,
            dimension=2,
            S_in_Lambda0=Simg,
            T_in_Lambda0=Timg,
            T_action=Tf,
            P_in_Lambda0=P,
            P_action=test.P_with_isometry,
            K_in_Lambda0=K,
            Lambda0=Lf,
            group_gap_id=group_id,
            symplectic_kernel_order_S=ordS,
            roots_verified=true,
            symplectic_saturation_verified=true,
            numbered_assignment_claimed=false,
        ))
        counts["retained"] += 1
        no105_progress("Retained T-action $action_index extension $extension_index with group [24,13]")
    end
    no105_progress("Finished T-action $action_index: " *
                   string(counts["retained"]) * " total retained")
    # Keep each completed T-action's surviving full-lattice records separately,
    # so a bounded run can be resumed/audited without repeating prior actions.
    new_records = records[first_record_index:end]
    # OSCAR's JSON encoding cannot infer a type for an empty Tuple{}.
    save(checkpoint, Dict(
        "family_number" => 105,
        "T_action_index" => action_index,
        "counts_cumulative" => copy(counts),
        "results" => isempty(new_records) ? nothing : Tuple(new_records),
    ))
    no105_progress("Saved checkpoint for T-action $action_index")
end

@assert counts["extensions"] == sum(counts[k] for k in (
    "nonstable", "wrong_S_character", "roots", "saturation",
    "wrong_group", "retained"))
save(NO105_RESULT, Dict(
    "format_version" => 1,
    "family_number" => 105,
    "source_no97_sha256" => bytes2hex(sha256(read(NO105_SOURCE))),
    "T_enumeration_sha256" => bytes2hex(sha256(read(NO105_T_ACTIONS))),
    "S_input" => S,
    "T_input" => T,
    "glue_order" => glue_order,
    "expected_T_characteristic_polynomial" => expected_T_char,
    "expected_S_characteristic_polynomial" => expected_S_char,
    "expected_T_minimal_polynomial" => expected_T_min,
    "expected_S_minimal_polynomial" => expected_S_min,
    "symplectic_kernel_order_S" => ordS,
    "counts" => counts,
    "T_action_indices_excluded_by_discriminant3" => Tuple(excluded_T_action_indices),
    "results" => isempty(records) ? nothing : Tuple(records),
    "elapsed_seconds" => time() - started,
    "numbered_assignment_claimed" => false,
    "geometric_identification" => "Pending explicit comparison with the frozen No. 105 projective representation; Nos. 104 and 105 share [24,13], index six and dimension two.",
))
reloaded = load(NO105_RESULT)
@assert reloaded["format_version"] == 1
@assert (reloaded["results"] === nothing ? 0 : length(reloaded["results"])) == counts["retained"]
no105_progress("COMPLETED: counts=$counts; MRDI saved and reloaded")
