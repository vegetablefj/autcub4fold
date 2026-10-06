# Exact-character integral lattice search for family No. 156 (C48).
# Here S=0 and the supplied rank-22 T is already the ambient primitive lattice.

using Dates
using SHA
include(joinpath(@__DIR__, "source_history.jl"))

const family_number_156 = 156
const order_156 = 48
const prefix_156 = "family_156_phi48_oscar18"
const log_file_156 = joinpath(@__DIR__, prefix_156 * ".log")
const status_file_156 = joinpath(@__DIR__, prefix_156 * ".status.txt")
const data_file_156 = joinpath(@__DIR__, prefix_156 * ".mrdi")
const report_file_156 = joinpath(@__DIR__, prefix_156 * "_result.md")
const shared_file_156 = joinpath(@__DIR__, "..", "..", "..", "oscar", "oscar_script.jl")
const input_file_156 = joinpath(@__DIR__, "input.jl")
const character_file_156 = joinpath(@__DIR__, "maximal_family_data.jl")
const runner_file_156 = @__FILE__
const started_156 = string(Dates.now())
const clock_156 = time()

function progress_156(message)
    line = "$(Dates.now()) | $message | elapsed $(round(time() - clock_156; digits=2)) s"
    println(line)
    flush(stdout)
    open(log_file_156, "a") do io
        println(io, line)
    end
end

function write_status_156(status)
    open(status_file_156, "w") do io
        println(io, status)
        println(io, "Family: 156; order: 48; character: Phi3 Phi12 Phi48")
        println(io, "Updated: ", Dates.now())
    end
end

function resource_guard_156()
    Sys.islinux() || error("Run inside the bounded WSL user service")
    entry = only(filter(line -> startswith(line, "0::"), readlines("/proc/self/cgroup")))
    relative = replace(split(entry, ':'; limit=3)[3], r"^/+" => "")
    directory = joinpath("/sys/fs/cgroup", relative)
    maximum = strip(read(joinpath(directory, "memory.max"), String))
    maximum == "max" && error("The service has no memory maximum")
    maximum_bytes = parse(Int, maximum)
    maximum_bytes <= 6 * 1024^3 || error("Memory maximum exceeds six GiB")
    strip(read(joinpath(directory, "memory.swap.max"), String)) == "0" ||
        error("The service must not use swap")
    return (
        directory=directory,
        maximum_bytes=maximum_bytes,
        high_bytes=parse(Int, strip(read(joinpath(directory, "memory.high"), String))),
    )
end

function same_polynomial_156(left, right)
    degree(left) == degree(right) || return false
    return all(coeff(left, i) == coeff(right, i) for i in 0:degree(left))
end

function expected_polynomial_156()
    ring, _ = polynomial_ring(QQ, "x")
    return prod(cyclotomic_polynomial(n, ring) for n in (3, 12, 48))
end

function validate_snapshot_156(saved)
    @assert saved.format_version == 1
    @assert saved.family_number == family_number_156
    @assert saved.order == order_156
    @assert saved.characteristic_polynomial == "Phi3 Phi12 Phi48"
    @assert saved.julia_version == string(VERSION)
    @assert saved.oscar_version == "1.8.2"
    @assert saved.source_input_sha256 == bytes2hex(sha256(read(maximal_source_input_file)))
    @assert saved.input_loader_sha256 == bytes2hex(sha256(read(input_file_156)))
    @assert lowrank_saved_source_sha_matches(saved.character_data_sha256, character_file_156)
    @assert saved.shared_script_sha256 == bytes2hex(sha256(read(shared_file_156)))
    @assert lowrank_saved_source_sha_matches(saved.runner_sha256, runner_file_156)
    @assert saved.number_of_actions >= saved.number_of_results >= 1
    @assert saved.number_of_results == length(saved.results)
    @assert all(result -> all(values(result.checks)), saved.results)
end

function write_report_156(saved)
    open(report_file_156, "w") do io
        println(io, "# Family 156: exact `Phi3 Phi12 Phi48` lattice search")
        println(io, "\nJulia ", saved.julia_version, "; OSCAR ", saved.oscar_version, ".")
        println(io, "\nThe enumeration fixed order 48, the complete characteristic and minimal polynomials, the ranks 2/4/16, and block signatures (2,0)/(4,0)/(14,2). No generator-root shortcut was used.")
        println(io, "OSCAR enumerates isometry classes in the genus of the input lattice. Here the rank-22 even lattice of signature (20,2) and discriminant form of the cubic-fourfold primitive lattice has a unique class, so the returned lattices represent the required ambient lattice. Since S=0, each action is tested directly. The checks require stable discriminant action, no short or long roots in K, and |tilde O(K)|=1.")
        println(io, "\nEnumerated action classes: ", saved.number_of_actions, ".")
        println(io, "Retained geometric lattice outputs: ", saved.number_of_results, ".")
        println(io, "Rejected for non-stable discriminant action: ", saved.rejection_counts.nonstable, ".")
        println(io, "Rejected for roots: ", saved.rejection_counts.roots, ".")
        println(io, "Rejected for a nontrivial stable symplectic group: ", saved.rejection_counts.symplectic, ".")
        println(io, "\n| Output | rank(P) | rank(K) | Dimension | Stable kernel order | Cyclic group |")
        println(io, "| ---: | ---: | ---: | ---: | ---: | --- |")
        for (i, result) in enumerate(saved.results)
            println(io, "| ", i, " | ", rank(result.P), " | ", rank(result.K),
                " | ", result.dimension, " | ", result.stable_kernel_order,
                " | `C48 = [48,2]` |")
        end
        println(io, "\nThe cubic equation independently supplies the Hodge character in `maximal_family_character_result.md`. The block signature does not distinguish the primitive 48th root assigned to the negative complex line; a power coprime to 48 of the lattice generator may be needed to match the displayed geometric generator (whose character is zeta_48). This integral calculation does not itself identify which retained class is realized by that equation if more than one class survives.")
        println(io, "\nCompleted: ", saved.completed_at, ". Elapsed before saving: ", round(saved.elapsed_seconds; digits=2), " seconds.")
        println(io, "Memory ceiling: ", saved.memory_maximum_bytes, " bytes; charged peak: ", saved.memory_peak_bytes, " bytes.")
    end
end

function run_family_156(budget)
    input = maximal_lattice_input_by_family[family_number_156]
    data = only(filter(item -> item.number == family_number_156, maximal_family_data))
    @assert data.projective_group_id == (48, 2)
    @assert data.expected_T_character == Dict(3 => 1, 12 => 1, 48 => 1)
    @assert data.determinant_exponent == 1
    @assert [(block.cyclotomic, block.signature) for block in data.signature_blocks] ==
        [(3, (2, 0)), (12, (4, 0)), (48, (14, 2))]
    progress_156("Checking the rank-22 lattice input")
    @assert rank(input.S) == 0
    @assert rank(input.T) == 22
    @assert signature_tuple(input.T) == (20, 0, 2)
    @assert absdisc_int(input.T) == 3
    progress_156("Lattice input checks passed; constructing the exact character")
    expected = expected_polynomial_156()
    @assert degree(expected) == 22

    progress_156("Enumerating all order-48 actions with the exact three-block character")
    raw = enumerate_classes_of_lattices_with_isometry(
        input.T,
        order_156;
        char_poly=expected,
        min_poly=expected,
        rks=[(3, 2), (12, 4), (48, 16)],
        pos_sigs=[(3, 2), (12, 4), (48, 14)],
        neg_sigs=[(3, 0), (12, 0), (48, 2)],
    )
    progress_156("Exact-character enumeration returned $(length(raw)) action class(es)")

    records = Any[]
    nonstable = 0
    roots = 0
    nonsymplectic_kernel = 0
    k_cache = Dict{Any, Any}()

    for (i, candidate) in enumerate(raw)
        action = full_rank_model(candidate)
        L = lattice(action)
        @assert rank(L) == 22
        @assert signature_tuple(action) == (20, 0, 2)
        @assert absdisc_int(L) == 3
        @assert order_of_isometry(action) == 48
        @assert same_polynomial_156(characteristic_polynomial(action), expected)
        @assert same_polynomial_156(minimal_polynomial(action), expected)

        P_action = phi_kernel(action, 48)
        P = lattice(P_action)
        K = orthogonal_submodule(L, basis_matrix(P))
        @assert rank(P) == 16 && signature_tuple(P) == (14, 0, 2)
        @assert rank(K) == 6 && signature_tuple(K) == (6, 0, 0)
        @assert period_dimension(P, 48) == 0

        if !trivial_action_on_discriminant(action)
            nonstable += 1
            progress_156("Action $i/$(length(raw)): rejected, non-stable ambient action")
            continue
        end
        if has_root(K, L)
            roots += 1
            progress_156("Action $i/$(length(raw)): rejected, short or long root in K")
            continue
        end
        kernel_order = cached_discriminant_kernel_order!(k_cache, K)
        if kernel_order != 1
            nonsymplectic_kernel += 1
            progress_156("Action $i/$(length(raw)): rejected, |tilde O(K)|=$kernel_order")
            continue
        end

        checks = (
            order=order_of_isometry(action) == 48,
            characteristic_polynomial=same_polynomial_156(characteristic_polynomial(action), expected),
            minimal_polynomial=same_polynomial_156(minimal_polynomial(action), expected),
            ambient_discriminant=absdisc_int(L) == 3,
            stable=trivial_action_on_discriminant(action),
            period_rank=rank(P) == 16,
            complement_rank=rank(K) == 6,
            dimension=period_dimension(P, 48) == 0,
            root_free=!has_root(K, L),
            symplectic_kernel=kernel_order == 1,
        )
        @assert all(values(checks))
        push!(records, (
            source_action_index=i,
            Lambda0=action,
            P_action=P_action,
            P=P,
            K=K,
            dimension=0,
            stable_kernel_order=kernel_order,
            checks=checks,
        ))
        progress_156("Action $i/$(length(raw)): retained; geometric checks all passed")
    end

    progress_156("Filter summary: stable=$(length(raw)-nonstable), root-free after stability=$(length(raw)-nonstable-roots), retained=$(length(records))")
    isempty(records) && error("No action survived the geometric lattice conditions; inspect the saved log")

    peak_path = joinpath(budget.directory, "memory.peak")
    peak = isfile(peak_path) ? parse(Int, strip(read(peak_path, String))) : 0
    snapshot = (
        format_version=1,
        description="Family 156 complete exact-character lattice search",
        family_number=family_number_156,
        order=order_156,
        characteristic_polynomial="Phi3 Phi12 Phi48",
        source_label=input.label,
        source_input_sha256=bytes2hex(sha256(read(maximal_source_input_file))),
        input_loader_sha256=bytes2hex(sha256(read(input_file_156))),
        character_data_sha256=bytes2hex(sha256(read(character_file_156))),
        shared_script_sha256=bytes2hex(sha256(read(shared_file_156))),
        runner_sha256=bytes2hex(sha256(read(runner_file_156))),
        julia_version=string(VERSION),
        oscar_version=string(pkgversion(Oscar)),
        started_at=started_156,
        completed_at=string(Dates.now()),
        elapsed_seconds=time()-clock_156,
        input_gram=gram_matrix(input.T),
        number_of_actions=length(raw),
        number_of_results=length(records),
        rejection_counts=(nonstable=nonstable, roots=roots, symplectic=nonsymplectic_kernel),
        memory_maximum_bytes=budget.maximum_bytes,
        memory_high_bytes=budget.high_bytes,
        memory_peak_bytes=peak,
        results=Tuple(records),
    )
    temporary = data_file_156 * ".$(getpid()).partial.mrdi"
    isfile(temporary) && error("Run-specific partial MRDI path already exists")
    save(temporary, snapshot)
    reloaded = load(temporary)
    validate_snapshot_156(reloaded)
    mv(temporary, data_file_156; force=false)
    write_report_156(reloaded)
    progress_156("Completed; MRDI reload and all post-checks passed")
end

open(log_file_156, "a") do io
    println(io, "Family 156 exact-character search started $started_156")
end
write_status_156("RUNNING")

try
    budget_156 = resource_guard_156()
    progress_156("Resource guard passed: high=$(budget_156.high_bytes), max=$(budget_156.maximum_bytes), swap=0")
    include(shared_file_156)
    include(input_file_156)
    include(character_file_156)
    pkgversion(Oscar) == v"1.8.2" || error("This recorded run requires OSCAR 1.8.2")
    set_verbosity_level(:ZZLatWithIsom, 1)
    progress_156("Julia $VERSION; OSCAR $(pkgversion(Oscar)); S=0 direct ambient-lattice route")

    if isfile(data_file_156)
        saved = load(data_file_156)
        validate_snapshot_156(saved)
        write_report_156(saved)
        progress_156("Existing completed result validated; search not repeated")
    else
        run_family_156(budget_156)
    end
    write_status_156("COMPLETED")
catch err
    progress_156("FAILED: $(sprint(showerror, err))")
    write_status_156("FAILED")
    rethrow()
end
