# Exact-character integral lattice search for family No. 152 (C16, family 2).
# Brown Slurm variant. S=0, so T is the rank-22 cubic-fourfold primitive lattice.

using Dates
using SHA
include(joinpath(@__DIR__, "source_history.jl"))

const family_number_152 = 152
const order_152 = 16
const prefix_152 = "family_152_phi16_brown_oscar18"
const log_file_152 = joinpath(@__DIR__, prefix_152 * ".log")
const status_file_152 = joinpath(@__DIR__, prefix_152 * ".status.txt")
const data_file_152 = joinpath(@__DIR__, prefix_152 * ".mrdi")
const report_file_152 = joinpath(@__DIR__, prefix_152 * "_result.md")
const shared_file_152 = joinpath(@__DIR__, "..", "..", "..", "oscar", "oscar_script.jl")
const input_file_152 = joinpath(@__DIR__, "input.jl")
const character_file_152 = joinpath(@__DIR__, "maximal_family_data.jl")
const runner_file_152 = @__FILE__
const started_152 = string(Dates.now())
const clock_152 = time()

function progress_152(message)
    line = "$(Dates.now()) | $message | elapsed $(round(time()-clock_152; digits=2)) s"
    println(line)
    flush(stdout)
    open(log_file_152, "a") do io
        println(io, line)
    end
end

function write_status_152(status)
    open(status_file_152, "w") do io
        println(io, status)
        println(io, "Family: 152; order: 16; character: Phi1^2 Phi2^2 Phi4 Phi16^2")
        println(io, "Updated: ", Dates.now())
    end
end

function cgroup_memory_limits_152(requested_bytes)
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
                peak_name = kind == "cgroup2" ? "memory.peak" : "memory.max_usage_in_bytes"
                return (
                    directory=limiting_directory,
                    maximum_bytes=maximum_bytes,
                    high_bytes=high_bytes,
                    peak_path=joinpath(limiting_directory, peak_name),
                    kind=kind,
                )
            end
        end
    end
    error("Cannot verify a finite cgroup v1/v2 memory limit near the Slurm request")
end

function resource_guard_152()
    Sys.islinux() || error("Run on a Linux Slurm compute node")
    haskey(ENV, "SLURM_JOB_ID") || error("Run inside a Slurm job")
    Threads.nthreads() == 1 || error("Use one Julia thread")
    requested_mib = if haskey(ENV, "SLURM_MEM_PER_NODE")
        parse(Int, ENV["SLURM_MEM_PER_NODE"])
    elseif haskey(ENV, "SLURM_MEM_PER_CPU")
        parse(Int, ENV["SLURM_MEM_PER_CPU"]) *
            parse(Int, get(ENV, "SLURM_CPUS_PER_TASK", "1"))
    else
        error("Slurm did not expose the memory allocation")
    end
    requested_mib >= 12 * 1024 || error("Request at least twelve GiB")
    return cgroup_memory_limits_152(requested_mib * 1024^2)
end

function same_polynomial_152(left, right)
    degree(left) == degree(right) || return false
    return all(coeff(left, i) == coeff(right, i) for i in 0:degree(left))
end

function expected_polynomials_152()
    ring, _ = polynomial_ring(QQ, "x")
    factors = Dict(n => cyclotomic_polynomial(n, ring) for n in (1, 2, 4, 16))
    characteristic = factors[1]^2 * factors[2]^2 * factors[4] * factors[16]^2
    minimal = prod(factors[n] for n in (1, 2, 4, 16))
    return characteristic, minimal
end

function validate_snapshot_152(saved)
    @assert saved.format_version == 1
    @assert saved.family_number == family_number_152
    @assert saved.order == order_152
    @assert saved.characteristic_polynomial == "Phi1^2 Phi2^2 Phi4 Phi16^2"
    @assert saved.minimal_polynomial == "Phi1 Phi2 Phi4 Phi16"
    @assert saved.julia_version == string(VERSION)
    @assert saved.oscar_version == "1.8.2"
    @assert saved.source_input_sha256 == bytes2hex(sha256(read(maximal_source_input_file)))
    @assert saved.input_loader_sha256 == bytes2hex(sha256(read(input_file_152)))
    @assert lowrank_saved_source_sha_matches(saved.character_data_sha256, character_file_152)
    @assert saved.shared_script_sha256 == bytes2hex(sha256(read(shared_file_152)))
    @assert lowrank_saved_source_sha_matches(saved.runner_sha256, runner_file_152)
    @assert saved.number_of_actions >= saved.number_of_results >= 1
    @assert saved.number_of_results == length(saved.results)
    @assert all(result -> all(values(result.checks)), saved.results)
end

function write_report_152(saved)
    open(report_file_152, "w") do io
        println(io, "# Family 152: exact `Phi1^2 Phi2^2 Phi4 Phi16^2` lattice search")
        println(io, "\nJulia ", saved.julia_version, "; OSCAR ", saved.oscar_version, ".")
        println(io, "\nThe enumeration fixed order 16, characteristic polynomial Phi1^2 Phi2^2 Phi4 Phi16^2, minimal polynomial Phi1 Phi2 Phi4 Phi16, block ranks 2/2/2/16, and block signatures (2,0)/(2,0)/(2,0)/(14,2). These constraints distinguish this one-dimensional family from the other C16 family.")
        println(io, "OSCAR enumerates isometry classes in the genus of the input lattice. The rank-22 even lattice of signature (20,2) with the cubic-fourfold primitive discriminant form has a unique class. Since S=0, the checks act directly on this ambient lattice: stable discriminant action, no short or long roots in K, and trivial stable orthogonal kernel of K.")
        println(io, "\nEnumerated action classes: ", saved.number_of_actions, ".")
        println(io, "Retained geometric lattice outputs: ", saved.number_of_results, ".")
        println(io, "Rejected for non-stable discriminant action: ", saved.rejection_counts.nonstable, ".")
        println(io, "Rejected for roots: ", saved.rejection_counts.roots, ".")
        println(io, "Rejected for a nontrivial stable symplectic kernel: ", saved.rejection_counts.symplectic, ".")
        println(io, "\n| Output | rank(P) | rank(K) | Dimension | Stable kernel order | Cyclic group |")
        println(io, "| ---: | ---: | ---: | ---: | ---: | --- |")
        for (i, result) in enumerate(saved.results)
            println(io, "| ", i, " | ", rank(result.P), " | ", rank(result.K),
                " | ", result.dimension, " | ", result.stable_kernel_order,
                " | `C16 = [16,1]` |")
        end
        println(io, "\nThe cubic equation independently gives the rational Hodge character in `maximal_family_character_result.md`. The signature of the full Phi16-isotypic block does not select a primitive eigenvalue on the negative complex line. A power of the lattice generator coprime to 16 may be required to match the displayed geometric generator, whose period character is zeta_16^7. Distinct retained generator actions need not give distinct cyclic group actions or geometric families.")
        println(io, "\nCompleted: ", saved.completed_at, ". Elapsed before saving: ", round(saved.elapsed_seconds; digits=2), " seconds.")
        println(io, "Memory allocation/limit: ", saved.memory_maximum_bytes, " bytes; charged peak: ", saved.memory_peak_bytes, " bytes.")
    end
end

function run_family_152(budget)
    input = maximal_lattice_input_by_family[family_number_152]
    data = only(filter(item -> item.number == family_number_152, maximal_family_data))
    @assert data.projective_group_id == (16, 1)
    @assert data.expected_T_character == Dict(1 => 2, 2 => 2, 4 => 1, 16 => 2)
    @assert data.determinant_exponent == 7
    @assert [(block.cyclotomic, block.signature) for block in data.signature_blocks] ==
        [(1, (2, 0)), (2, (2, 0)), (4, (2, 0)), (16, (14, 2))]
    progress_152("Checking the rank-22 lattice input")
    @assert rank(input.S) == 0
    @assert rank(input.T) == 22
    @assert signature_tuple(input.T) == (20, 0, 2)
    @assert absdisc_int(input.T) == 3
    characteristic, minimal = expected_polynomials_152()
    @assert degree(characteristic) == 22
    @assert degree(minimal) == 12
    progress_152("Lattice input passed; enumerating exact order-16 actions")

    raw = enumerate_classes_of_lattices_with_isometry(
        input.T,
        order_152;
        char_poly=characteristic,
        min_poly=minimal,
        rks=[(1, 2), (2, 2), (4, 2), (16, 16)],
        pos_sigs=[(1, 2), (2, 2), (4, 2), (16, 14)],
        neg_sigs=[(1, 0), (2, 0), (4, 0), (16, 2)],
    )
    progress_152("Exact-character enumeration returned $(length(raw)) action class(es)")

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
        @assert order_of_isometry(action) == 16
        @assert same_polynomial_152(characteristic_polynomial(action), characteristic)
        @assert same_polynomial_152(minimal_polynomial(action), minimal)

        P_action = phi_kernel(action, 16)
        P = lattice(P_action)
        K = orthogonal_submodule(L, basis_matrix(P))
        @assert rank(P) == 16 && signature_tuple(P) == (14, 0, 2)
        @assert rank(K) == 6 && signature_tuple(K) == (6, 0, 0)
        @assert period_dimension(P, 16) == 1

        if !trivial_action_on_discriminant(action)
            nonstable += 1
            progress_152("Action $i/$(length(raw)): rejected, non-stable ambient action")
            continue
        end
        if has_root(K, L)
            roots += 1
            progress_152("Action $i/$(length(raw)): rejected, short or long root in K")
            continue
        end
        kernel_order = cached_discriminant_kernel_order!(k_cache, K)
        if kernel_order != 1
            nonsymplectic_kernel += 1
            progress_152("Action $i/$(length(raw)): rejected, |tilde O(K)|=$kernel_order")
            continue
        end
        checks = (
            order=order_of_isometry(action) == 16,
            characteristic_polynomial=same_polynomial_152(characteristic_polynomial(action), characteristic),
            minimal_polynomial=same_polynomial_152(minimal_polynomial(action), minimal),
            ambient_discriminant=absdisc_int(L) == 3,
            stable=trivial_action_on_discriminant(action),
            period_rank=rank(P) == 16,
            complement_rank=rank(K) == 6,
            dimension=period_dimension(P, 16) == 1,
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
            dimension=1,
            stable_kernel_order=kernel_order,
            checks=checks,
        ))
        progress_152("Action $i/$(length(raw)): retained; geometric checks all passed")
    end
    progress_152("Filter summary: stable=$(length(raw)-nonstable), root-free after stability=$(length(raw)-nonstable-roots), retained=$(length(records))")
    isempty(records) && error("No action survived; inspect the search log")

    peak = isfile(budget.peak_path) ?
        parse(Int, strip(read(budget.peak_path, String))) : 0
    snapshot = (
        format_version=1,
        description="Family 152 complete exact-character lattice search",
        family_number=family_number_152,
        order=order_152,
        characteristic_polynomial="Phi1^2 Phi2^2 Phi4 Phi16^2",
        minimal_polynomial="Phi1 Phi2 Phi4 Phi16",
        source_label=input.label,
        source_input_sha256=bytes2hex(sha256(read(maximal_source_input_file))),
        input_loader_sha256=bytes2hex(sha256(read(input_file_152))),
        character_data_sha256=bytes2hex(sha256(read(character_file_152))),
        shared_script_sha256=bytes2hex(sha256(read(shared_file_152))),
        runner_sha256=bytes2hex(sha256(read(runner_file_152))),
        julia_version=string(VERSION),
        oscar_version=string(pkgversion(Oscar)),
        started_at=started_152,
        completed_at=string(Dates.now()),
        elapsed_seconds=time()-clock_152,
        input_gram=gram_matrix(input.T),
        number_of_actions=length(raw),
        number_of_results=length(records),
        rejection_counts=(nonstable=nonstable, roots=roots, symplectic=nonsymplectic_kernel),
        memory_maximum_bytes=budget.maximum_bytes,
        memory_high_bytes=budget.high_bytes,
        memory_peak_bytes=peak,
        results=Tuple(records),
    )
    temporary = data_file_152 * ".$(getpid()).partial.mrdi"
    isfile(temporary) && error("Run-specific partial MRDI path already exists")
    save(temporary, snapshot)
    reloaded = load(temporary)
    validate_snapshot_152(reloaded)
    mv(temporary, data_file_152; force=false)
    write_report_152(reloaded)
    progress_152("Completed; MRDI reload and all post-checks passed")
end

if get(ENV, "FAMILY152_BROWN_PARSE_ONLY", "") == "1"
    println("Family No. 152 source: syntax OK")
else
    open(log_file_152, "a") do io
        println(io, "Family 152 exact-character search started $started_152")
    end
    write_status_152("RUNNING")
    try
        budget_152 = resource_guard_152()
        progress_152("Slurm resource guard passed: $(budget_152.kind), high=$(budget_152.high_bytes), max=$(budget_152.maximum_bytes)")
        include(shared_file_152)
        include(input_file_152)
        include(character_file_152)
        pkgversion(Oscar) == v"1.8.2" || error("This run requires OSCAR 1.8.2")
        set_verbosity_level(:ZZLatWithIsom, 1)
        progress_152("Julia $VERSION; OSCAR $(pkgversion(Oscar)); S=0 direct ambient-lattice route")
        if isfile(data_file_152)
            saved = load(data_file_152)
            validate_snapshot_152(saved)
            write_report_152(saved)
            progress_152("Existing completed result validated; search not repeated")
        else
            run_family_152(budget_152)
        end
        write_status_152("COMPLETED")
    catch err
        progress_152("FAILED: $(sprint(showerror, err))")
        write_status_152("FAILED")
        rethrow()
    end
end
