# Exact-character lattice search for family No. 96, S3 x C24.
# The T-action is constrained at the enumeration entrance to pure Phi_24.

using Dates
using SHA
include(joinpath(@__DIR__, "source_history.jl"))

const family_number = 96
const tested_order = 24
const run_prefix = "family_096_phi24_oscar18"
const log_file_096 = joinpath(@__DIR__, run_prefix * ".log")
const status_file_096 = joinpath(@__DIR__, run_prefix * ".status.txt")
const data_file_096 = joinpath(@__DIR__, run_prefix * ".mrdi")
const result_file_096 = joinpath(@__DIR__, run_prefix * "_result.md")
const shared_script_096 = joinpath(@__DIR__, "..", "..", "..", "oscar", "oscar_script.jl")
const extension_adapter_096 = joinpath(@__DIR__, "oscar_1_8_public_extensions.jl")
const runner_file_096 = @__FILE__
const started_at_096 = string(Dates.now())
const clock_started_096 = time()

function same_polynomial_096(left, right)
    degree(left) == degree(right) || return false
    return all(coeff(left, i) == coeff(right, i) for i in 0:degree(left))
end

function progress_096(message)
    line = "$(Dates.now()) | $message | elapsed $(round(time() - clock_started_096; digits=2)) s"
    println(line)
    flush(stdout)
    open(log_file_096, "a") do io
        println(io, line)
    end
end

function write_status_096(status)
    open(status_file_096, "w") do io
        println(io, status)
        println(io, "Family: 96")
        println(io, "Character on T: Phi24")
        println(io, "Updated: ", Dates.now())
    end
end

function memory_guard_096()
    Sys.islinux() || error("Run this search in the resource-limited WSL service")
    entry = only(filter(line -> startswith(line, "0::"), readlines("/proc/self/cgroup")))
    relative = replace(split(entry, ':'; limit = 3)[3], r"^/+" => "")
    directory = joinpath("/sys/fs/cgroup", relative)
    maximum = strip(read(joinpath(directory, "memory.max"), String))
    maximum == "max" && error("No cgroup memory limit; refusing to start")
    max_bytes = parse(Int, maximum)
    max_bytes <= 6 * 1024^3 || error("Memory limit exceeds the six-GiB budget")
    swap = strip(read(joinpath(directory, "memory.swap.max"), String))
    swap == "0" || error("Swap must be disabled")
    return (
        directory = directory,
        maximum_bytes = max_bytes,
        high_bytes = parse(Int, strip(read(joinpath(directory, "memory.high"), String))),
    )
end

function validate_snapshot_096(saved)
    @assert saved.format_version == 2
    @assert saved.family_number == 96
    @assert saved.tested_order == 24
    @assert saved.characteristic_polynomial == "Phi24"
    @assert v"1.8.0" <= VersionNumber(saved.oscar_version) < v"1.9.0"
    @assert saved.source_input_sha256 == bytes2hex(sha256(read(maximal_source_input_file)))
    @assert saved.shared_script_sha256 == bytes2hex(sha256(read(shared_script_096)))
    @assert lowrank_saved_source_sha_matches(saved.extension_adapter_sha256, extension_adapter_096)
    @assert lowrank_saved_source_sha_matches(saved.runner_sha256, runner_file_096)
    @assert saved.structural_checks_passed
    @assert saved.expected_family_found
    @assert saved.number_of_results == length(saved.results)
end

function write_report_096(saved)
    open(result_file_096, "w") do io
        println(io, "# Family 96: exact `Phi24` lattice search")
        println(io, "\nJulia ", saved.julia_version, "; OSCAR ", saved.oscar_version, ".")
        println(io, "\nThe enumeration imposed `chi(f|T)=mu_f=Phi24`, rank 8, and signature `(6,2)` at the enumeration entrance.")
        println(io, "It then used the OSCAR 1.8 public primitive-extension routine and the shared root, saturation, and stable-ambient tests.")
        println(io, "\nT-action classes before extension tests: ", saved.number_of_T_actions, ".")
        println(io, "Retained lattice-data outputs: ", saved.number_of_results, ".")
        println(io, "\n| Output | Dimension | Group ID | rank(P) | rank(K) | Expected No. 96 group |")
        println(io, "| ---: | ---: | --- | ---: | ---: | --- |")
        for (index, record) in enumerate(saved.results)
            println(io, "| ", index, " | ", record.dimension, " | `", record.group_gap_id,
                "` | ", rank(record.P_in_Lambda0), " | ", rank(record.K_in_Lambda0),
                " | ", record.matches_expected_group, " |")
        end
        println(io, "\nThe rational character and signature were derived independently from the cubic equation in `maximal_family_character_result.md`. This run addresses the integral isometry, gluing, root, and ambient-extension steps.")
        println(io, "\nCompleted: ", saved.completed_at, ". Elapsed before saving: ", round(saved.elapsed_seconds; digits = 2), " seconds.")
        println(io, "Memory ceiling: ", saved.memory_maximum_bytes, " bytes; peak charged memory before saving: ", saved.memory_peak_bytes, " bytes.")
    end
end

function enumerate_phi24_actions_096(T)
    Qx, x = polynomial_ring(QQ, "x")
    phi24 = cyclotomic_polynomial(24, Qx)
    raw = enumerate_classes_of_lattices_with_isometry(
        T,
        24;
        char_poly = phi24,
        min_poly = phi24,
        rks = [(24, 8)],
        pos_sigs = [(24, 6)],
        neg_sigs = [(24, 2)],
        fix_root = 24,
    )

    actions = ZZLatWithIsom[]
    for raw_action in raw
        action = full_rank_model(raw_action)
        @assert order_of_isometry(action) == 24
        @assert same_polynomial_096(characteristic_polynomial(action), phi24)
        @assert same_polynomial_096(minimal_polynomial(action), phi24)
        @assert signature_tuple(action) == (6, 0, 2)
        @assert rank(phi_kernel(action, 24)) == 8
        push!(actions, action)
    end
    return actions
end

function run_family_096(memory_budget)
    input = maximal_lattice_input_by_family[96]
    S, T = input.S, input.T
    progress_096("Enumerating rank-eight pure-Phi24 T-actions")
    actions = enumerate_phi24_actions_096(T)
    progress_096("Exact-character enumeration returned $(length(actions)) T-action class(es)")
    isempty(actions) && error("No pure-Phi24 action was found on the supplied T genus")

    context = plain_side_extension_context(S)
    @assert context.tilde_order == 6
    k_order_cache = Dict{Any, Any}()
    records = Any[]

    for (action_index, action) in enumerate(actions)
        progress_096("Running public primitive extensions for T-action $action_index/$(length(actions))")
        data = lattice_data_for_T_action_public_18(
            S,
            action,
            24;
            ordS = context.tilde_order,
            k_order_cache = k_order_cache,
        )
        progress_096("T-action $action_index retained $(length(data)) extension datum(a)")

        for datum in data
            group_id = practical_group_gap_id(datum.S_in_Lambda0)
            checks = (
                dimension_zero = datum.dimension == 0,
                period_rank_eight = rank(datum.P_in_Lambda0) == 8,
                coinvariant_rank_fourteen = rank(datum.K_in_Lambda0) == 14,
                ambient_discriminant_three = absdisc_int(lattice(datum.Lambda0)) == 3,
                stable_ambient_action = trivial_action_on_discriminant(datum.Lambda0),
                exact_T_character = same_polynomial_096(
                    characteristic_polynomial(datum.T_action),
                    cyclotomic_polynomial(24, polynomial_ring(QQ, "y")[1]),
                ),
            )
            matches_expected = Tuple(group_id) == (144, 69)
            push!(records, merge(datum, (
                source_T_action_index = action_index,
                group_gap_id = group_id,
                matches_expected_group = matches_expected,
                checks = checks,
            )))
            progress_096("Retained group=$group_id; expected=$matches_expected; checks=$(all(values(checks)))")
        end
    end

    isempty(records) && error("No extension survived the geometric lattice tests")
    structural_checks_passed = all(record -> all(values(record.checks)), records)
    expected_family_found = any(record -> record.matches_expected_group, records)
    structural_checks_passed || error("A retained record failed a structural check")
    expected_family_found || error("The expected group [144,69] was not found")

    peak_file = joinpath(memory_budget.directory, "memory.peak")
    peak = isfile(peak_file) ? parse(Int, strip(read(peak_file, String))) : 0
    snapshot = (
        format_version = 2,
        description = "Family 96 exact-character lattice search",
        family_number = 96,
        tested_order = 24,
        characteristic_polynomial = "Phi24",
        source_label = input.label,
        source_input_file = "../input_original.jl.txt",
        source_input_sha256 = bytes2hex(sha256(read(maximal_source_input_file))),
        shared_script = "../../../oscar/oscar_script.jl",
        shared_script_sha256 = bytes2hex(sha256(read(shared_script_096))),
        extension_adapter = "oscar_1_8_public_extensions.jl",
        extension_adapter_sha256 = bytes2hex(sha256(read(extension_adapter_096))),
        runner = "run_family_096_phi24.jl",
        runner_sha256 = bytes2hex(sha256(read(runner_file_096))),
        julia_version = string(VERSION),
        oscar_version = string(pkgversion(Oscar)),
        started_at = started_at_096,
        completed_at = string(Dates.now()),
        elapsed_seconds = time() - clock_started_096,
        input_S = S,
        input_T = T,
        number_of_T_actions = length(actions),
        number_of_results = length(records),
        structural_checks_passed = structural_checks_passed,
        expected_family_found = expected_family_found,
        memory_maximum_bytes = memory_budget.maximum_bytes,
        memory_high_bytes = memory_budget.high_bytes,
        memory_peak_bytes = peak,
        results = Tuple(records),
    )

    temporary = data_file_096 * ".partial.mrdi"
    save(temporary, snapshot)
    reloaded = load(temporary)
    validate_snapshot_096(reloaded)
    mv(temporary, data_file_096; force = false)
    write_report_096(reloaded)
    progress_096("Completed; MRDI reload and all post-checks passed")
end

open(log_file_096, "a") do io
    println(io, "Family 96 exact-Phi24 search started $started_at_096")
end
write_status_096("RUNNING")

try
    memory_budget_096 = memory_guard_096()
    progress_096("Resource guard passed: high=$(memory_budget_096.high_bytes), max=$(memory_budget_096.maximum_bytes), swap=0")
    include(shared_script_096)
    include(joinpath(@__DIR__, "input.jl"))
    include(joinpath(@__DIR__, "oscar_1_8_public_extensions.jl"))
    set_verbosity_level(:ZZLatWithIsom, 1)
    progress_096("Julia $VERSION; OSCAR $(pkgversion(Oscar)); public 1.8 primitive-extension route")

    if isfile(data_file_096)
        saved = load(data_file_096)
        validate_snapshot_096(saved)
        write_report_096(saved)
        progress_096("Existing completed result validated; search not repeated")
    else
        run_family_096(memory_budget_096)
    end
    write_status_096("COMPLETED")
catch err
    progress_096("FAILED: $(sprint(showerror, err))")
    write_status_096("FAILED")
    rethrow()
end
