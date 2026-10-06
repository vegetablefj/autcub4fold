using Oscar
using Dates

const OUTDIR = get(ENV, "NO105_OUTPUT_DIR", @__DIR__)
isdir(OUTDIR) || error("Output directory does not exist: $OUTDIR")
const VERIFIED_SOURCE = joinpath(@__DIR__, "..", "restriction_97_100_from_74.verified.mrdi")
const LOG = joinpath(OUTDIR, "no105_T_enumeration.log")
const RAW = joinpath(OUTDIR, "no105_T_raw_genus_classes.mrdi")
const RESULT = joinpath(OUTDIR, "no105_T_enumeration.mrdi")

function progress(message)
    line = string(Dates.format(now(UTC), dateformat"yyyy-mm-ddTHH:MM:SS"), "Z | ", message)
    println(line)
    flush(stdout)
    open(LOG, "a") do io
        println(io, line)
    end
end

progress("Loading the compact, verified No. 97 restriction result")
source_data = load(VERIFIED_SOURCE)
@assert source_data.format_version == 1
source_result = only(v for v in source_data.verified_results
    if v.child == 97 && v.parent == 74 && v.class_number == 1)
T = lattice(source_result.result.T_in_Lambda0)
@assert rank(T) == 10
@assert abs(det(gram_matrix(T))) == 3072
progress("Loaded C2^2 generic T: rank 10, determinant 3072")

Qx, x = polynomial_ring(QQ, "x")
phi1 = cyclotomic_polynomial(1, Qx)
phi2 = cyclotomic_polynomial(2, Qx)
phi6 = cyclotomic_polynomial(6, Qx)
expected_char = phi1 * phi2^3 * phi6^3
expected_min = phi1 * phi2 * phi6
@assert degree(expected_char) == 10

if get(ENV, "NO105_PREFLIGHT", "0") == "1"
    progress("PREFLIGHT_COMPLETE: no isometry enumeration was started")
    exit(0)
end

ispath(RESULT) && error("Refusing to overwrite existing result: $RESULT")

started = time()
if isfile(RAW)
    progress("Loading saved raw genus-action checkpoint")
    raw_data = load(RAW)
    @assert raw_data["family_number"] == 105
    @assert gram_matrix(raw_data["T_input"]) == gram_matrix(T)
    raw_actions = raw_data["raw_actions"]
    progress("Loaded $(length(raw_actions)) raw genus-action class(es)")
else
    progress("Starting order-6 action enumeration in the genus of T with all character and signature blocks fixed")
    raw_actions = enumerate_classes_of_lattices_with_isometry(
        T,
        6;
        char_poly = expected_char,
        min_poly = expected_min,
        rks = [(1, 1), (2, 3), (6, 6)],
        pos_sigs = [(1, 1), (2, 3), (6, 4)],
        neg_sigs = [(1, 0), (2, 0), (6, 2)],
    )
    progress("Enumerator returned $(length(raw_actions)) genus class(es) after $(round(time() - started; digits=1)) seconds")
    # Different genus representatives have different serialization params.
    # OSCAR's JSON serializer accepts their heterogeneous Tuple, not Vector.
    save(RAW, Dict("family_number" => 105, "T_input" => T,
                   "raw_actions" => Tuple(raw_actions)))
    progress("Saved raw genus-action checkpoint")
end

function full_rank_model_local(action)
    plain = integer_lattice(; gram=gram_matrix(action))
    return integer_lattice_with_isometry(plain, isometry(action); check=true)
end

same_polynomial(p, q) = degree(p) == degree(q) &&
    all(coeff(p, i) == coeff(q, i) for i in 0:degree(p))

function cyclotomic_kernel(action, m)
    try
        return kernel_lattice(action, m)
    catch
        return kernel_lattice(action, cyclotomic_polynomial(m))
    end
end

actions = Any[]
for (i, candidate) in enumerate(raw_actions)
    action = full_rank_model_local(candidate)
    @assert order_of_isometry(action) == 6
    @assert same_polynomial(characteristic_polynomial(action), expected_char)
    @assert same_polynomial(minimal_polynomial(action), expected_min)
    @assert rank(cyclotomic_kernel(action, 6)) == 6
    exact_T = gram_matrix(lattice(action)) == gram_matrix(T) ||
        is_isometric(lattice(action), T)
    if exact_T
        push!(actions, action)
    end
    progress("Checked genus action $i/$(length(raw_actions)); exact-T actions=$(length(actions))")
end
progress("Exact input-T action classes retained: $(length(actions))")
isempty(actions) && error("The genus search returned no action on the exact input T lattice")

for (i, action) in enumerate(actions)
    @assert order_of_isometry(action) == 6
    @assert same_polynomial(characteristic_polynomial(action), expected_char)
    progress("Validated T-action class $i/$(length(actions))")
end

save(RESULT, Dict(
    "family_number" => 105,
    "T_input" => T,
    "expected_characteristic_polynomial" => expected_char,
    "expected_minimal_polynomial" => expected_min,
    "T_actions" => Tuple(actions),
    "raw_genus_action_count" => length(raw_actions),
    "exact_input_T_action_count" => length(actions),
    "elapsed_seconds" => time() - started,
    "method" => "Exact order-six T enumeration with character Phi1 Phi2^3 Phi6^3 and signature (1,0)+(3,0)+(4,2)",
))
reloaded = load(RESULT)
@assert length(reloaded["T_actions"]) == length(actions)
progress("COMPLETED: MRDI saved and reloaded successfully")
