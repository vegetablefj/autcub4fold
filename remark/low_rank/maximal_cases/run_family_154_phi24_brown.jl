# Exact-character integral-lattice search for family No. 154 (C24, family 2).
# S=0, so T is the whole primitive cubic-fourfold lattice. Run in a bounded
# Brown Slurm job; the geometric tests are applied after isometry enumeration.

using Dates
using SHA
include(joinpath(@__DIR__, "source_history.jl"))

const family_number_154 = 154
const order_154 = 24
const prefix_154 = "family_154_phi24_brown_oscar18"
const log_file_154 = joinpath(@__DIR__, prefix_154 * ".log")
const status_file_154 = joinpath(@__DIR__, prefix_154 * ".status.txt")
const data_file_154 = joinpath(@__DIR__, prefix_154 * ".mrdi")
const report_file_154 = joinpath(@__DIR__, prefix_154 * "_result.md")
const shared_file_154 = joinpath(@__DIR__, "..", "..", "..", "oscar", "oscar_script.jl")
const input_file_154 = joinpath(@__DIR__, "input.jl")
const character_file_154 = joinpath(@__DIR__, "maximal_family_data.jl")
const runner_file_154 = @__FILE__
const started_154 = string(Dates.now())
const clock_154 = time()

function progress_154(message)
    line = "$(Dates.now()) | $message | elapsed $(round(time() - clock_154; digits=2)) s"
    println(line)
    flush(stdout)
    open(log_file_154, "a") do io
        println(io, line)
    end
end

function write_status_154(status)
    open(status_file_154, "w") do io
        println(io, status)
        println(io, "Family: 154; order: 24; character: Phi3 Phi12 Phi24^2")
        println(io, "Updated: ", Dates.now())
    end
end

function cgroup_memory_limits_154(requested_bytes)
    memberships = Tuple{String, String}[]
    for line in readlines("/proc/self/cgroup")
        parts = split(line, ':'; limit=3)
        length(parts) == 3 || continue
        if parts[1] == "0" && isempty(parts[2])
            push!(memberships, ("cgroup2", parts[3]))
        elseif "memory" in split(parts[2], ',')
            push!(memberships, ("cgroup", parts[3]))
        end
    end

    upper_bytes = requested_bytes + max(16 * 1024^2, div(requested_bytes, 20))
    for kind in ("cgroup2", "cgroup")
        for line in readlines("/proc/self/mountinfo")
            halves = split(line, " - "; limit=2)
            length(halves) == 2 || continue
            mount = split(halves[1])
            filesystem = split(halves[2])
            length(mount) >= 5 && length(filesystem) >= 3 || continue
            filesystem[1] == kind || continue
            kind == "cgroup" && !("memory" in split(filesystem[3], ',')) && continue
            root = replace(mount[4], "\\040" => " ")
            mountpoint = replace(mount[5], "\\040" => " ")
            for (membership_kind, membership_path) in memberships
                membership_kind == kind || continue
                relative = if root == "/"
                    replace(membership_path, r"^/+" => "")
                elseif membership_path == root
                    ""
                elseif startswith(membership_path, root * "/")
                    membership_path[(length(root)+2):end]
                else
                    continue
                end
                directory = joinpath(mountpoint, relative)
                limit_name = kind == "cgroup2" ? "memory.max" : "memory.limit_in_bytes"
                finite_limits = Tuple{BigInt, String}[]
                probe = directory
                while true
                    maximum_path = joinpath(probe, limit_name)
                    if isfile(maximum_path)
                        value = strip(read(maximum_path, String))
                        maximum = value == "max" ? nothing : tryparse(BigInt, value)
                        maximum === nothing || push!(finite_limits, (maximum, probe))
                    end
                    probe == mountpoint && break
                    parent = dirname(probe)
                    (parent == probe || !startswith(parent * "/", mountpoint * "/")) && break
                    probe = parent
                end
                isempty(finite_limits) && continue
                _, limiting_index = findmin(first.(finite_limits))
                maximum, limiting_directory = finite_limits[limiting_index]
                12 * 1024^3 <= maximum <= upper_bytes || continue
                maximum_bytes = Int(maximum)
                high_bytes = maximum_bytes
                if kind == "cgroup2"
                    high_path = joinpath(limiting_directory, "memory.high")
                    if isfile(high_path)
                        high_value = strip(read(high_path, String))
                        if high_value != "max"
                            high = tryparse(BigInt, high_value)
                            high === nothing || (high_bytes = Int(min(high, maximum)))
                        end
                    end
                end
                return (directory=limiting_directory, maximum_bytes=maximum_bytes,
                    high_bytes=high_bytes, kind=kind)
            end
        end
    end
    error("Cannot verify a finite cgroup v1/v2 memory limit near the Slurm request")
end

function slurm_resource_guard_154()
    Sys.islinux() || error("Run on a Linux Slurm compute node")
    haskey(ENV, "SLURM_JOB_ID") || error("Run inside a Slurm job")
    Threads.nthreads() == 1 || error("Use exactly one Julia thread")
    requested_mib = if haskey(ENV, "SLURM_MEM_PER_NODE")
        parse(Int, ENV["SLURM_MEM_PER_NODE"])
    elseif haskey(ENV, "SLURM_MEM_PER_CPU")
        parse(Int, ENV["SLURM_MEM_PER_CPU"]) *
            parse(Int, get(ENV, "SLURM_CPUS_PER_TASK", "1"))
    else
        error("Slurm did not expose the requested memory allocation")
    end
    requested_mib >= 12 * 1024 || error("Request at least twelve GiB")
    return cgroup_memory_limits_154(requested_mib * 1024^2)
end

function same_polynomial_154(left, right)
    degree(left) == degree(right) || return false
    return all(coeff(left, i) == coeff(right, i) for i in 0:degree(left))
end

function expected_polynomials_154()
    ring, _ = polynomial_ring(QQ, "x")
    phi3 = cyclotomic_polynomial(3, ring)
    phi12 = cyclotomic_polynomial(12, ring)
    phi24 = cyclotomic_polynomial(24, ring)
    return (characteristic=phi3 * phi12 * phi24^2,
            minimal=phi3 * phi12 * phi24)
end

function validate_snapshot_154(saved)
    @assert saved.format_version == 1
    @assert saved.family_number == family_number_154
    @assert saved.order == order_154
    @assert saved.characteristic_polynomial == "Phi3 Phi12 Phi24^2"
    @assert saved.minimal_polynomial == "Phi3 Phi12 Phi24"
    @assert saved.julia_version == string(VERSION)
    @assert saved.oscar_version == "1.8.2"
    @assert saved.source_input_sha256 == bytes2hex(sha256(read(maximal_source_input_file)))
    @assert saved.input_loader_sha256 == bytes2hex(sha256(read(input_file_154)))
    @assert lowrank_saved_source_sha_matches(saved.character_data_sha256, character_file_154)
    @assert saved.shared_script_sha256 == bytes2hex(sha256(read(shared_file_154)))
    @assert lowrank_saved_source_sha_matches(saved.runner_sha256, runner_file_154)
    @assert saved.number_of_actions >= saved.number_of_results >= 1
    @assert saved.number_of_results == length(saved.results)
    @assert all(record -> all(values(record.checks)), saved.results)
end

function write_report_154(saved)
    open(report_file_154, "w") do io
        println(io, "# Family 154: exact `Phi3 Phi12 Phi24^2` lattice search")
        println(io, "\nJulia ", saved.julia_version, "; OSCAR ", saved.oscar_version, ".")
        println(io, "\nThe enumeration fixed order 24, characteristic polynomial `Phi3 Phi12 Phi24^2`, minimal polynomial `Phi3 Phi12 Phi24`, ranks 2/4/16, and block signatures (2,0)/(4,0)/(14,2). No generator-root shortcut was used.")
        println(io, "The input is the rank-22 primitive cubic-fourfold lattice with signature (20,2) and discriminant 3. Its genus has one isometry class. Since S=0, no gluing step is needed. Each action is tested for stable discriminant action, absence of short and long roots in the positive complement, and trivial stable kernel on that complement.")
        println(io, "\nEnumerated action classes: ", saved.number_of_actions, ".")
        println(io, "Retained geometric lattice outputs: ", saved.number_of_results, ".")
        println(io, "Rejections: non-stable=", saved.rejection_counts.nonstable,
                ", roots=", saved.rejection_counts.roots,
                ", nontrivial symplectic kernel=", saved.rejection_counts.symplectic, ".")
        println(io, "\n| Output | Source action | rank(P) | rank(K) | Dimension | Stable kernel order |")
        println(io, "| ---: | ---: | ---: | ---: | ---: | ---: |")
        for (i, record) in enumerate(saved.results)
            println(io, "| ", i, " | ", record.source_action_index, " | ", rank(record.P),
                    " | ", rank(record.K), " | ", record.dimension,
                    " | ", record.stable_kernel_order, " |")
        end
        println(io, "\nThe displayed cubic equation gives Hodge eigenvalue `zeta24^19` independently (see `maximal_family_character_result.md`). The rational block signature does not choose a particular primitive 24th root on the negative complex line. A coprime power of a retained lattice generator may be needed to match that geometric generator. Retained generator classes need not be distinct cyclic-group actions; this run does not claim uniqueness without a separate power-orbit comparison.")
        println(io, "\nCompleted: ", saved.completed_at, ". Elapsed before saving: ",
                round(saved.elapsed_seconds; digits=2), " seconds.")
        println(io, "Memory ceiling: ", saved.memory_maximum_bytes,
                " bytes; charged peak: ", saved.memory_peak_bytes, " bytes.")
    end
end

function run_family_154(budget)
    input = maximal_lattice_input_by_family[family_number_154]
    data = only(filter(item -> item.number == family_number_154, maximal_family_data))
    @assert data.projective_group_id == (24, 2)
    @assert data.expected_T_character == Dict(3 => 1, 12 => 1, 24 => 2)
    @assert data.determinant_exponent == 19
    @assert gcd(data.determinant_exponent, order_154) == 1
    @assert [(b.cyclotomic, b.multiplicity, b.signature) for b in data.signature_blocks] ==
        [(3, 1, (2, 0)), (12, 1, (4, 0)), (24, 2, (14, 2))]
    progress_154("Checking the rank-22 primitive lattice input")
    @assert rank(input.S) == 0
    @assert rank(input.T) == 22
    @assert signature_tuple(input.T) == (20, 0, 2)
    @assert absdisc_int(input.T) == 3
    polynomials = expected_polynomials_154()
    @assert degree(polynomials.characteristic) == 22
    @assert degree(polynomials.minimal) == 14

    progress_154("Enumerating all exact-character order-24 actions")
    raw = enumerate_classes_of_lattices_with_isometry(
        input.T, order_154;
        char_poly=polynomials.characteristic,
        min_poly=polynomials.minimal,
        rks=[(3, 2), (12, 4), (24, 16)],
        pos_sigs=[(3, 2), (12, 4), (24, 14)],
        neg_sigs=[(3, 0), (12, 0), (24, 2)],
    )
    progress_154("Exact-character enumeration returned $(length(raw)) action class(es)")

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
        @assert order_of_isometry(action) == 24
        @assert same_polynomial_154(characteristic_polynomial(action), polynomials.characteristic)
        @assert same_polynomial_154(minimal_polynomial(action), polynomials.minimal)

        P_action = phi_kernel(action, 24)
        P = lattice(P_action)
        K = orthogonal_submodule(L, basis_matrix(P))
        @assert rank(P) == 16 && signature_tuple(P) == (14, 0, 2)
        @assert rank(K) == 6 && signature_tuple(K) == (6, 0, 0)
        @assert period_dimension(P, 24) == 1

        if !trivial_action_on_discriminant(action)
            nonstable += 1
            progress_154("Action $i/$(length(raw)): rejected, non-stable ambient action")
            continue
        end
        if has_root(K, L)
            roots += 1
            progress_154("Action $i/$(length(raw)): rejected, root in the positive complement")
            continue
        end
        kernel_order = cached_discriminant_kernel_order!(k_cache, K)
        if kernel_order != 1
            nonsymplectic_kernel += 1
            progress_154("Action $i/$(length(raw)): rejected, |tilde O(K)|=$kernel_order")
            continue
        end

        checks = (
            order=order_of_isometry(action) == 24,
            characteristic_polynomial=same_polynomial_154(characteristic_polynomial(action), polynomials.characteristic),
            minimal_polynomial=same_polynomial_154(minimal_polynomial(action), polynomials.minimal),
            ambient_discriminant=absdisc_int(L) == 3,
            stable=trivial_action_on_discriminant(action),
            period_rank=rank(P) == 16,
            complement_rank=rank(K) == 6,
            dimension=period_dimension(P, 24) == 1,
            root_free=!has_root(K, L),
            symplectic_kernel=kernel_order == 1,
        )
        @assert all(values(checks))
        push!(records, (
            source_action_index=i, Lambda0=action, P_action=P_action,
            P=P, K=K, dimension=1, stable_kernel_order=kernel_order,
            checks=checks,
        ))
        progress_154("Action $i/$(length(raw)): retained; geometric checks passed")
    end
    progress_154("Filter summary: stable=$(length(raw)-nonstable), root-free after stability=$(length(raw)-nonstable-roots), retained=$(length(records))")
    isempty(records) && error("No action survived; inspect the log before drawing a conclusion")

    peak_name = budget.kind == "cgroup2" ? "memory.peak" : "memory.max_usage_in_bytes"
    peak_path = joinpath(budget.directory, peak_name)
    peak = isfile(peak_path) ? parse(Int, strip(read(peak_path, String))) : 0
    snapshot = (
        format_version=1,
        description="Family 154 exact-character integral-lattice search",
        family_number=family_number_154,
        order=order_154,
        characteristic_polynomial="Phi3 Phi12 Phi24^2",
        minimal_polynomial="Phi3 Phi12 Phi24",
        source_label=input.label,
        source_input_sha256=bytes2hex(sha256(read(maximal_source_input_file))),
        input_loader_sha256=bytes2hex(sha256(read(input_file_154))),
        character_data_sha256=bytes2hex(sha256(read(character_file_154))),
        shared_script_sha256=bytes2hex(sha256(read(shared_file_154))),
        runner_sha256=bytes2hex(sha256(read(runner_file_154))),
        julia_version=string(VERSION),
        oscar_version=string(pkgversion(Oscar)),
        started_at=started_154,
        completed_at=string(Dates.now()),
        elapsed_seconds=time()-clock_154,
        input_gram=gram_matrix(input.T),
        number_of_actions=length(raw),
        number_of_results=length(records),
        rejection_counts=(nonstable=nonstable, roots=roots, symplectic=nonsymplectic_kernel),
        memory_maximum_bytes=budget.maximum_bytes,
        memory_high_bytes=budget.high_bytes,
        memory_peak_bytes=peak,
        results=Tuple(records),
    )
    temporary = data_file_154 * ".$(getpid()).partial.mrdi"
    isfile(temporary) && error("Run-specific partial MRDI path already exists")
    save(temporary, snapshot)
    reloaded = load(temporary)
    validate_snapshot_154(reloaded)
    mv(temporary, data_file_154; force=false)
    write_report_154(reloaded)
    progress_154("Completed; MRDI reload and post-checks passed")
end

open(log_file_154, "a") do io
    println(io, "Family 154 exact-character search started $started_154")
end
write_status_154("RUNNING")

try
    budget_154 = slurm_resource_guard_154()
    progress_154("Slurm resource guard passed: $(budget_154.kind), high=$(budget_154.high_bytes), max=$(budget_154.maximum_bytes)")
    include(shared_file_154)
    include(input_file_154)
    include(character_file_154)
    pkgversion(Oscar) == v"1.8.2" || error("This recorded run requires OSCAR 1.8.2")
    set_verbosity_level(:ZZLatWithIsom, 1)
    progress_154("Julia $VERSION; OSCAR $(pkgversion(Oscar)); S=0 direct ambient-lattice route")
    if isfile(data_file_154)
        saved = load(data_file_154)
        validate_snapshot_154(saved)
        write_report_154(saved)
        progress_154("Existing completed result validated; search not repeated")
    else
        run_family_154(budget_154)
    end
    write_status_154("COMPLETED")
catch err
    progress_154("FAILED: $(sprint(showerror, err))")
    write_status_154("FAILED")
    rethrow()
end
