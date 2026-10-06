# Brown Slurm launcher for the family No. 156 exact-character search.
# The launcher checks the audited source before adapting its resource guard.

using SHA
include(joinpath(@__DIR__, "source_history.jl"))

const brown_source_156 = joinpath(@__DIR__, "run_family_156_phi48.jl")
const expected_brown_source_sha256_156 =
    "78b2294494dc3ed66a35c62ff6e04594f58ee6704af22f0fb02cfd9fc9a53d05"

isfile(brown_source_156) || error("Missing source file: $brown_source_156")
lowrank_saved_source_sha_matches(expected_brown_source_sha256_156, brown_source_156) ||
    error("run_family_156_phi48.jl does not have the audited SHA-256 digest")

source_156 = replace(read(brown_source_156, String), "\r\n" => "\n")
occursin("const prefix_156 = \"family_156_phi48_oscar18\"", source_156) ||
    error("Could not locate the audited output prefix")
source_156 = replace(
    source_156,
    "const prefix_156 = \"family_156_phi48_oscar18\"" =>
        "const prefix_156 = \"family_156_phi48_brown_oscar18\"",
    count=1,
)
occursin("const runner_file_156 = @__FILE__", source_156) ||
    error("Could not locate the audited runner path")
source_156 = replace(
    source_156,
    "const runner_file_156 = @__FILE__" =>
        "const runner_file_156 = joinpath(@__DIR__, \"run_family_156_phi48_brown.jl\")",
    count=1,
)

const brown_guard_pattern_156 = r"(?s)function resource_guard_156\(\).*?\nend\n\nfunction same_polynomial_156"
const brown_guard_replacement_156 = chomp(raw"""
function resource_guard_156()
    Sys.islinux() || error("Run on a Linux Slurm compute node")
    haskey(ENV, "SLURM_JOB_ID") || error("Run inside a Slurm job")
    Threads.nthreads() == 1 || error("Use one Julia thread")

    requested_mib = if haskey(ENV, "SLURM_MEM_PER_NODE")
        parse(Int, ENV["SLURM_MEM_PER_NODE"])
    elseif haskey(ENV, "SLURM_MEM_PER_CPU")
        parse(Int, ENV["SLURM_MEM_PER_CPU"]) *
            parse(Int, get(ENV, "SLURM_CPUS_PER_TASK", "1"))
    else
        error("Slurm did not expose the requested memory allocation")
    end
    requested_mib >= 12 * 1024 || error("Request at least twelve GiB")

    memberships = Tuple{String, String}[]
    for line in readlines("/proc/self/cgroup")
        fields = split(line, ':'; limit=3)
        length(fields) == 3 || continue
        if fields[1] == "0" && isempty(fields[2])
            push!(memberships, ("cgroup2", fields[3]))
        elseif "memory" in split(fields[2], ',')
            push!(memberships, ("cgroup", fields[3]))
        end
    end
    requested_bytes = requested_mib * 1024^2
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
                    high_bytes=high_bytes)
            end
        end
    end
    error("Cannot verify a finite cgroup v1/v2 memory limit near the Slurm request")
end

function same_polynomial_156
""")

occursin(brown_guard_pattern_156, source_156) ||
    error("Could not locate the audited WSL resource guard")
source_156 = replace(
    source_156,
    brown_guard_pattern_156 => brown_guard_replacement_156,
    count=1,
)
occursin("function same_polynomial_156(left, right)", source_156) ||
    error("The guard replacement damaged the next function signature")
occursin(
    raw"Resource guard passed: high=$(budget_156.high_bytes), max=$(budget_156.maximum_bytes), swap=0",
    source_156,
) || error("Could not locate the audited resource log message")
source_156 = replace(
    source_156,
    raw"Resource guard passed: high=$(budget_156.high_bytes), max=$(budget_156.maximum_bytes), swap=0" =>
        raw"Slurm resource guard passed: high=$(budget_156.high_bytes), max=$(budget_156.maximum_bytes)",
    count=1,
)
occursin("peak_path = joinpath(budget.directory, \"memory.peak\")", source_156) ||
    error("Could not locate the audited cgroup peak path")
source_156 = replace(
    source_156,
    "peak_path = joinpath(budget.directory, \"memory.peak\")" =>
        "peak_path = isfile(joinpath(budget.directory, \"memory.peak\")) ? " *
        "joinpath(budget.directory, \"memory.peak\") : " *
        "joinpath(budget.directory, \"memory.max_usage_in_bytes\")",
    count=1,
)

function contains_parse_error_156(node)
    node isa Expr || return false
    node.head in (:error, :incomplete) && return true
    return any(contains_parse_error_156, node.args)
end

parsed_source_156 = Meta.parseall(source_156)
contains_parse_error_156(parsed_source_156) &&
    error("The generated family No. 156 source has a Julia syntax error")

if get(ENV, "FAMILY156_BROWN_PARSE_ONLY", "") == "1"
    println("Generated family No. 156 source: syntax OK")
else
    Base.include_string(Main, source_156, brown_source_156)
end
