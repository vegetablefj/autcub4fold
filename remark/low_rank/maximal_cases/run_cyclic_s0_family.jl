# One exact-character integral-lattice search for families 152, 154, 155, 156.
# Usage: julia --project=PATH run_cyclic_s0_family.jl FAMILY [OUTPUT_DIR]
#        julia --project=PATH run_cyclic_s0_family.jl --check-config
#        julia --project=PATH run_cyclic_s0_family.jl --check-old-all
#        julia --project=PATH run_cyclic_s0_family.jl --check-old FAMILY MRDI_FILE
# The same mathematical code runs under either a bounded local Linux service
# or a Slurm job. Only the cgroup memory limit is inspected at run time.

using Dates
using SHA
include(joinpath(@__DIR__, "source_history.jl"))

const cyclic_runner_file = @__FILE__
const cyclic_specs_file = joinpath(@__DIR__, "cyclic_s0_specs.jl")
const cyclic_shared_file = joinpath(@__DIR__, "..", "..", "..", "oscar", "oscar_script.jl")
const cyclic_input_file = joinpath(@__DIR__, "input.jl")
const cyclic_character_file = joinpath(@__DIR__, "maximal_family_data.jl")
include(cyclic_specs_file)
include(cyclic_shared_file)
include(cyclic_input_file)
include(cyclic_character_file)

cyclic_sha256(path) = bytes2hex(sha256(Vector{UInt8}(codeunits(
    replace(read(path, String), "\r\n" => "\n")))))

# Historical runs hashed raw bytes; a Git checkout can change only CRLF/LF.
function cyclic_old_sha_matches(recorded, path)
    lowrank_saved_source_sha_matches(recorded, path) && return true
    source = replace(read(path, String), "\r\n" => "\n")
    # The preserved local oscar_script.jl had mixed line endings. Its text was
    # independently compared with this checkout's LF-only file, byte for byte
    # after newline normalization; a uniform CRLF rewrite cannot reproduce it.
    if path == cyclic_shared_file &&
       recorded == "a19f2bb9265d0aff025c623f411463c4ddf7f8c9511bc1910c07798cc8bc2ace" &&
       cyclic_sha256(path) == "d70980adb3d70dc8e5767ddbd0cb7f7678caeb19cc100d16f39e4862e10f498e"
        return true
    end
    return any(bytes2hex(sha256(Vector{UInt8}(codeunits(candidate)))) == recorded
               for candidate in (source, replace(source, "\n" => "\r\n")))
end

function cyclic_source_hashes()
    return (
        source_input=cyclic_sha256(maximal_source_input_file),
        input_loader=cyclic_sha256(cyclic_input_file),
        character_data=cyclic_sha256(cyclic_character_file),
        shared_script=cyclic_sha256(cyclic_shared_file),
        specs=cyclic_sha256(cyclic_specs_file),
        runner=cyclic_sha256(cyclic_runner_file),
    )
end

function cyclic_same_polynomial(left, right)
    degree(left) == degree(right) || return false
    return all(coeff(left, i) == coeff(right, i) for i in 0:degree(left))
end

function cyclic_character_label(blocks; minimal=false)
    return join(("Phi$(b[1])" * (minimal || b[2] == 1 ? "" : "^$(b[2])")
                 for b in blocks), " ")
end

function cyclic_prepare(spec)
    input = maximal_lattice_input_by_family[spec.number]
    data = only(filter(item -> item.number == spec.number, maximal_family_data))
    @assert spec.number in (152, 154, 155, 156)
    @assert data.symplectic_group == "1"
    @assert data.projective_group_id == spec.group_id
    @assert data.full_index == spec.order
    @assert data.determinant_exponent == spec.determinant_exponent
    @assert gcd(spec.determinant_exponent, spec.order) == 1
    @assert data.family_dimension == spec.dimension
    @assert data.rank_S == 0 && data.rank_T == 22
    @assert data.expected_T_character == Dict(b[1] => b[2] for b in spec.blocks)
    @assert Tuple((b.cyclotomic, b.multiplicity, b.signature[1], b.signature[2])
                  for b in data.signature_blocks) == spec.blocks
    @assert all(b.location == "T" for b in data.signature_blocks)
    @assert rank(input.S) == 0 && rank(input.T) == 22
    @assert signature_tuple(input.T) == (20, 0, 2)
    @assert absdisc_int(input.T) == 3
    @assert spec.order in input.candidate_orders

    ring, _ = polynomial_ring(QQ, "x")
    factors = [cyclotomic_polynomial(b[1], ring) for b in spec.blocks]
    characteristic = prod(factors[i]^spec.blocks[i][2] for i in eachindex(factors))
    minimal = prod(factors)
    rks = [(b[1], b[2] * degree(factors[i])) for (i, b) in enumerate(spec.blocks)]
    pos_sigs = [(b[1], b[3]) for b in spec.blocks]
    neg_sigs = [(b[1], b[4]) for b in spec.blocks]
    @assert degree(characteristic) == 22
    @assert sum(last, rks) == 22
    @assert sum(last, pos_sigs) == 20
    @assert sum(last, neg_sigs) == 2
    @assert count(b -> b[1] == spec.order, spec.blocks) == 1
    @assert only(filter(b -> b[1] == spec.order, spec.blocks))[3:4] == (14, 2)
    @assert all(b[4] == 0 for b in spec.blocks if b[1] != spec.order)
    @assert only(filter(b -> b[1] == spec.order, rks))[2] == 16
    return (
        input=input, characteristic=characteristic, minimal=minimal,
        rks=rks, pos_sigs=pos_sigs, neg_sigs=neg_sigs,
        characteristic_label=cyclic_character_label(spec.blocks),
        minimal_label=cyclic_character_label(spec.blocks; minimal=true),
    )
end

function cyclic_memory_budget()
    Sys.islinux() || error("The enumeration requires a Linux cgroup memory limit")
    Threads.nthreads() == 1 || error("Use one Julia thread")
    cap_gib = parse(Int, get(ENV, "MAXIMAL_SEARCH_MEMORY_CAP_GIB", "64"))
    cap_gib > 0 || error("MAXIMAL_SEARCH_MEMORY_CAP_GIB must be positive")
    cap = BigInt(cap_gib) * 1024^3

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
                finite = Tuple{BigInt, String}[]
                probe = directory
                while true
                    path = joinpath(probe, limit_name)
                    if isfile(path)
                        value = strip(read(path, String))
                        maximum = value == "max" ? nothing : tryparse(BigInt, value)
                        maximum === nothing || push!(finite, (maximum, probe))
                    end
                    probe == mountpoint && break
                    parent = dirname(probe)
                    (parent == probe || !startswith(parent * "/", mountpoint * "/")) && break
                    probe = parent
                end
                isempty(finite) && continue
                maximum, limiting_directory = finite[argmin(first.(finite))]
                0 < maximum <= cap && maximum <= typemax(Int) || continue
                high_bytes = Int(maximum)
                if kind == "cgroup2"
                    path = joinpath(limiting_directory, "memory.high")
                    if isfile(path)
                        high = tryparse(BigInt, strip(read(path, String)))
                        high === nothing || (high_bytes = Int(min(high, maximum)))
                    end
                end
                peak_name = kind == "cgroup2" ? "memory.peak" : "memory.max_usage_in_bytes"
                return (
                    kind=kind, directory=limiting_directory,
                    maximum_bytes=Int(maximum), high_bytes=high_bytes,
                    peak_path=joinpath(limiting_directory, peak_name),
                )
            end
        end
    end
    error("No finite cgroup memory limit at or below $(cap_gib) GiB was found")
end

function cyclic_paths(spec, output_dir)
    prefix = joinpath(output_dir, spec.name * "_shared_oscar18")
    return (
        log=prefix * ".log", status=prefix * ".status.txt",
        data=prefix * ".mrdi", report=prefix * "_result.md",
    )
end

function cyclic_progress(ctx, message)
    line = "$(Dates.now()) | $message | elapsed $(round(time()-ctx.clock; digits=2)) s"
    println(line)
    flush(stdout)
    open(ctx.paths.log, "a") do io
        println(io, line)
    end
end

function cyclic_status(ctx, status)
    open(ctx.paths.status, "w") do io
        println(io, status)
        println(io, "Family: $(ctx.spec.number); order: $(ctx.spec.order)")
        println(io, "Updated: $(Dates.now())")
    end
end

function cyclic_validate_snapshot(saved, spec, prepared)
    @assert saved.format_version == 2
    @assert saved.family_number == spec.number && saved.order == spec.order
    @assert saved.group_id == spec.group_id
    @assert saved.characteristic_polynomial == prepared.characteristic_label
    @assert saved.minimal_polynomial == prepared.minimal_label
    @assert saved.oscar_version == "1.8.2"
    @assert saved.source_hashes == cyclic_source_hashes()
    @assert saved.input_gram == gram_matrix(prepared.input.T)
    @assert saved.number_of_actions >= saved.number_of_results >= 1
    @assert saved.number_of_results == length(saved.results)
    @assert saved.number_of_actions == saved.number_of_results +
        sum(values(saved.rejection_counts))
    @assert all(record -> all(values(record.checks)), saved.results)
end

function cyclic_write_report(saved, spec, paths)
    open(paths.report, "w") do io
        println(io, "# Family $(spec.number): exact-character integral-lattice search")
        println(io, "\nOrder $(spec.order); characteristic polynomial `$(saved.characteristic_polynomial)`; minimal polynomial `$(saved.minimal_polynomial)`.")
        println(io, "Block constraints (cyclotomic index, multiplicity, positive rank, negative rank): `$(spec.blocks)`.")
        println(io, "The input is the rank-22 primitive cubic-fourfold lattice. Since S=0, the entire action is enumerated on this ambient lattice. The geometric filters test the stable discriminant action, roots in the positive complement, and its stable orthogonal kernel.")
        println(io, "\nEnumerated generator-action classes: $(saved.number_of_actions).")
        println(io, "Retained outputs: $(saved.number_of_results).")
        println(io, "Rejected: non-stable=$(saved.rejection_counts.nonstable), roots=$(saved.rejection_counts.roots), nontrivial stable kernel=$(saved.rejection_counts.symplectic).")
        println(io, "\n| Output | Source action | rank(P) | rank(K) | Dimension | Stable kernel order |")
        println(io, "| ---: | ---: | ---: | ---: | ---: | ---: |")
        for (i, record) in enumerate(saved.results)
            println(io, "| $i | $(record.source_action_index) | $(rank(record.P)) | $(rank(record.K)) | $(record.dimension) | $(record.stable_kernel_order) |")
        end
        println(io, "\nThe displayed cubic generator has period eigenvalue `zeta_$(spec.order)^$(spec.determinant_exponent)` by the independent character calculation. A coprime power of an enumerated generator may be needed to match it. These outputs count generator actions; a separate power-orbit comparison is needed to count cyclic-group actions or geometric families.")
        println(io, "\nJulia $(saved.julia_version); OSCAR $(saved.oscar_version). Completed $(saved.completed_at); elapsed before saving $(round(saved.elapsed_seconds; digits=2)) seconds.")
        println(io, "Cgroup memory ceiling $(saved.memory_maximum_bytes) bytes; charged peak $(saved.memory_peak_bytes) bytes.")
    end
end

function cyclic_enumerate(ctx, prepared, budget)
    spec = ctx.spec
    input = prepared.input
    cyclic_progress(ctx, "Enumerating exact order-$(spec.order) actions on the rank-22 ambient lattice")
    raw = enumerate_classes_of_lattices_with_isometry(
        input.T, spec.order;
        char_poly=prepared.characteristic, min_poly=prepared.minimal,
        rks=prepared.rks, pos_sigs=prepared.pos_sigs, neg_sigs=prepared.neg_sigs,
    )
    cyclic_progress(ctx, "Exact-character enumeration returned $(length(raw)) action class(es)")

    records = Any[]
    nonstable = 0
    roots = 0
    nonsymplectic_kernel = 0
    k_cache = Dict{Any, Any}()
    for (i, candidate) in enumerate(raw)
        action = full_rank_model(candidate)
        L = lattice(action)
        @assert rank(L) == 22 && signature_tuple(action) == (20, 0, 2)
        @assert absdisc_int(L) == 3 && order_of_isometry(action) == spec.order
        @assert cyclic_same_polynomial(characteristic_polynomial(action), prepared.characteristic)
        @assert cyclic_same_polynomial(minimal_polynomial(action), prepared.minimal)

        P_action = phi_kernel(action, spec.order)
        P = lattice(P_action)
        K = orthogonal_submodule(L, basis_matrix(P))
        @assert rank(P) == 16 && signature_tuple(P) == (14, 0, 2)
        @assert rank(K) == 6 && signature_tuple(K) == (6, 0, 0)
        @assert period_dimension(P, spec.order) == spec.dimension

        if !trivial_action_on_discriminant(action)
            nonstable += 1
            cyclic_progress(ctx, "Action $i/$(length(raw)): rejected, non-stable ambient action")
            continue
        end
        if has_root(K, L)
            roots += 1
            cyclic_progress(ctx, "Action $i/$(length(raw)): rejected, root in the positive complement")
            continue
        end
        kernel_order = cached_discriminant_kernel_order!(k_cache, K)
        if kernel_order != 1
            nonsymplectic_kernel += 1
            cyclic_progress(ctx, "Action $i/$(length(raw)): rejected, stable kernel order $kernel_order")
            continue
        end

        checks = (
            order=order_of_isometry(action) == spec.order,
            characteristic_polynomial=cyclic_same_polynomial(characteristic_polynomial(action), prepared.characteristic),
            minimal_polynomial=cyclic_same_polynomial(minimal_polynomial(action), prepared.minimal),
            ambient_discriminant=absdisc_int(L) == 3,
            stable=trivial_action_on_discriminant(action),
            period_rank=rank(P) == 16, complement_rank=rank(K) == 6,
            dimension=period_dimension(P, spec.order) == spec.dimension,
            root_free=!has_root(K, L), symplectic_kernel=kernel_order == 1,
        )
        @assert all(values(checks))
        push!(records, (
            source_action_index=i, Lambda0=action, P_action=P_action,
            P=P, K=K, dimension=spec.dimension,
            stable_kernel_order=kernel_order, checks=checks,
        ))
        cyclic_progress(ctx, "Action $i/$(length(raw)): retained")
    end
    isempty(records) && error("No action survived the geometric lattice filters")
    cyclic_progress(ctx, "Filter summary: stable=$(length(raw)-nonstable), root-free=$(length(raw)-nonstable-roots), retained=$(length(records))")

    peak = isfile(budget.peak_path) ? parse(Int, strip(read(budget.peak_path, String))) : 0
    snapshot = (
        format_version=2, description="Shared S=0 cyclic exact-character search",
        family_number=spec.number, order=spec.order, group_id=spec.group_id,
        characteristic_polynomial=prepared.characteristic_label,
        minimal_polynomial=prepared.minimal_label,
        source_label=input.label, source_hashes=cyclic_source_hashes(),
        julia_version=string(VERSION), oscar_version=string(pkgversion(Oscar)),
        started_at=ctx.started, completed_at=string(Dates.now()),
        elapsed_seconds=time()-ctx.clock, input_gram=gram_matrix(input.T),
        number_of_actions=length(raw), number_of_results=length(records),
        rejection_counts=(nonstable=nonstable, roots=roots, symplectic=nonsymplectic_kernel),
        memory_maximum_bytes=budget.maximum_bytes,
        memory_high_bytes=budget.high_bytes, memory_peak_bytes=peak,
        results=Tuple(records),
    )
    temporary = ctx.paths.data * ".$(getpid()).partial.mrdi"
    isfile(temporary) && error("Run-specific partial MRDI already exists: $temporary")
    save(temporary, snapshot)
    reloaded = load(temporary)
    cyclic_validate_snapshot(reloaded, spec, prepared)
    mv(temporary, ctx.paths.data; force=false)
    cyclic_write_report(reloaded, spec, ctx.paths)
    cyclic_progress(ctx, "Completed; MRDI reload and post-checks passed")
end

function cyclic_load_inputs()
    pkgversion(Oscar) == v"1.8.2" || error("This search requires OSCAR 1.8.2")
    set_verbosity_level(:ZZLatWithIsom, 1)
end

function cyclic_old_result_path(number)
    if number == 155
        return joinpath(@__DIR__, "family_155_phi32_oscar18.mrdi")
    end
    return joinpath(@__DIR__, "brown_results",
        "family_$(number)_phi$(cyclic_s0_specs[number].order)_brown_oscar18.mrdi")
end

function cyclic_old_runner_path(number)
    name = number == 155 ? "run_family_155_phi32.jl" :
        "run_family_$(number)_phi$(cyclic_s0_specs[number].order)_brown.jl"
    return joinpath(@__DIR__, name)
end

# This reads the historical MRDI without regenerating its report or status.
# Stored root and stable-kernel booleans are checked here; their expensive
# underlying predicates are intentionally left to a fresh full search.
function cyclic_check_old(number, path)
    spec = cyclic_s0_specs[number]
    prepared = cyclic_prepare(spec)
    isfile(path) || error("Historical MRDI not found: $path")
    saved = load(path)
    @assert saved.format_version == 1
    @assert saved.family_number == number && saved.order == spec.order
    @assert saved.characteristic_polynomial == prepared.characteristic_label
    if hasproperty(saved, :minimal_polynomial)
        @assert saved.minimal_polynomial == prepared.minimal_label
    end
    @assert saved.oscar_version == "1.8.2"
    @assert saved.source_label == prepared.input.label
    @assert saved.input_gram == gram_matrix(prepared.input.T)
    @assert cyclic_old_sha_matches(saved.source_input_sha256, maximal_source_input_file)
    @assert cyclic_old_sha_matches(saved.input_loader_sha256, cyclic_input_file)
    @assert cyclic_old_sha_matches(saved.character_data_sha256, cyclic_character_file)
    @assert cyclic_old_sha_matches(saved.shared_script_sha256, cyclic_shared_file)
    old_runner = cyclic_old_runner_path(number)
    if isfile(old_runner)
        @assert cyclic_old_sha_matches(saved.runner_sha256, old_runner)
    end
    @assert saved.number_of_actions >= saved.number_of_results >= 1
    @assert saved.number_of_results == length(saved.results)
    @assert saved.number_of_actions == saved.number_of_results +
        sum(values(saved.rejection_counts))
    for record in saved.results
        @assert 1 <= record.source_action_index <= saved.number_of_actions
        @assert all(values(record.checks))
        @assert record.dimension == spec.dimension && record.stable_kernel_order == 1
        @assert rank(record.P) == 16 && rank(record.K) == 6
        @assert order_of_isometry(record.Lambda0) == spec.order
        @assert cyclic_same_polynomial(
            characteristic_polynomial(record.Lambda0), prepared.characteristic)
    end
    println("$(number): old MRDI read-only check OK; actions=$(saved.number_of_actions), retained=$(saved.number_of_results), rejected=$(saved.rejection_counts), runner_hash=$(isfile(old_runner) ? "matched" : "source unavailable")")
end

function cyclic_main(args)
    if args == ["--check-config"]
        cyclic_load_inputs()
        for number in sort(collect(keys(cyclic_s0_specs)))
            spec = cyclic_s0_specs[number]
            prepared = cyclic_prepare(spec)
            println("$(number): order=$(spec.order), char=$(prepared.characteristic_label), min=$(prepared.minimal_label), rks=$(prepared.rks), pos=$(prepared.pos_sigs), neg=$(prepared.neg_sigs): OK")
        end
        return
    end
    if args == ["--check-old-all"]
        cyclic_load_inputs()
        for number in sort(collect(keys(cyclic_s0_specs)))
            cyclic_check_old(number, cyclic_old_result_path(number))
        end
        return
    end
    if length(args) == 3 && args[1] == "--check-old"
        number = tryparse(Int, args[2])
        number in keys(cyclic_s0_specs) || error("Family number must be one of 152, 154, 155, 156")
        cyclic_load_inputs()
        cyclic_check_old(number, abspath(args[3]))
        return
    end
    length(args) in (1, 2) || error("Usage: run_cyclic_s0_family.jl FAMILY [OUTPUT_DIR] or --check-config")
    number = tryparse(Int, args[1])
    number === nothing && error("Family number must be one of 152, 154, 155, 156")
    spec = get(cyclic_s0_specs, number, nothing)
    spec === nothing && error("Family number must be one of 152, 154, 155, 156")
    output_dir = length(args) == 2 ? abspath(args[2]) : joinpath(@__DIR__, "shared_results")
    mkpath(output_dir)
    paths = cyclic_paths(spec, output_dir)
    ctx = (spec=spec, paths=paths, started=string(Dates.now()), clock=time())
    cyclic_status(ctx, "RUNNING")
    try
        cyclic_load_inputs()
        prepared = cyclic_prepare(spec)
        cyclic_progress(ctx, "Julia $VERSION; OSCAR $(pkgversion(Oscar)); character $(prepared.characteristic_label)")
        if isfile(paths.data)
            saved = load(paths.data)
            cyclic_validate_snapshot(saved, spec, prepared)
            cyclic_write_report(saved, spec, paths)
            cyclic_progress(ctx, "Existing completed result validated; search not repeated")
        else
            budget = cyclic_memory_budget()
            cyclic_progress(ctx, "Cgroup resource guard passed: $(budget.kind), high=$(budget.high_bytes), max=$(budget.maximum_bytes)")
            cyclic_enumerate(ctx, prepared, budget)
        end
        cyclic_status(ctx, "COMPLETED")
    catch err
        cyclic_progress(ctx, "FAILED: $(sprint(showerror, err))")
        cyclic_status(ctx, "FAILED")
        rethrow()
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    cyclic_main(ARGS)
end
