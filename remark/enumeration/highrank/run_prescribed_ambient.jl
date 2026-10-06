# One prescribed-action search per numbered family. The ten cases here use
# the same primitive-extension routine; No. 42 is deliberately excluded.
# Usage: julia --project=... run_prescribed_ambient.jl NUMBER [OUTPUT.mrdi]
#        julia run_prescribed_ambient.jl NUMBER --parse-only|--check-config
#        julia run_prescribed_ambient.jl --check-config-all
# Fresh outputs default to results/family_NNN.mrdi. Existing outputs are never
# overwritten. Run one case at a time; the O(S) computation may be expensive.

using SHA
using Dates
include(joinpath(@__DIR__, "specs.jl"))

1 <= length(ARGS) <= 2 || error("Supply one family number and optional output path")
const hr_check_config_all = length(ARGS) == 1 && ARGS[1] == "--check-config-all"
const hr_number = hr_check_config_all ? 0 : parse(Int,ARGS[1])
hr_check_config_all || haskey(hr_specs,hr_number) ||
    error("Unsupported family number")
const hr_spec = hr_check_config_all ? nothing : hr_specs[hr_number]
const hr_parse_only = !hr_check_config_all && length(ARGS) == 2 &&
    ARGS[2] == "--parse-only"
const hr_check_config = !hr_check_config_all && length(ARGS) == 2 &&
    ARGS[2] == "--check-config"
if !hr_check_config_all
    hr_check_numbering(hr_number,hr_spec)
end

if hr_parse_only
    expression = hr_source_expression(hr_spec)
    expression isa Expr || error("Selected source is not an expression")
    println("PASS parse-only No. $hr_number: source $(hr_spec.source) " *
        "$(hr_spec.source_index), rank(S)=$(hr_spec.rank_S), " *
        "rank(T)=$(hr_spec.rank_T), quotient=$(hr_spec.index)")
    exit()
end

using Oscar
pkgversion(Oscar) == v"1.8.2" || error("This search requires OSCAR 1.8.2")

if hr_check_config || hr_check_config_all
    include(joinpath(hr_project,"oscar","oscar_script.jl"))
    for n in (hr_check_config_all ? sort(collect(keys(hr_specs))) : [hr_number])
        spec = hr_specs[n]
        hr_check_numbering(n,spec)
        S,T,Tf = hr_inputs(spec)
        println("PASS No. $n input: rank(S)=$(rank(S)), " *
            "rank(T)=$(rank(T)), quotient=$(spec.index), " *
            "gluing index=$(glue_order_to_disc3(S,T))")
        flush(stdout)
    end
    exit()
end

const hr_output = length(ARGS) == 2 ? abspath(ARGS[2]) :
    joinpath(@__DIR__,"results","family_$(lpad(string(hr_number),3,'0')).mrdi")
endswith(hr_output,".mrdi") || error("Output must have the .mrdi extension")
const hr_stem = splitext(hr_output)[1]
const hr_started = time()
const hr_timings = Dict{String,Float64}()
for path in (hr_output,hr_stem*".building.mrdi",
        hr_stem*".log",hr_stem*".status.txt")
    ispath(path) && error("Refusing to reuse an existing output path: $path")
end
mkpath(dirname(hr_output))

hr_sha(path) = bytes2hex(sha256(read(path)))
hr_integral(M) = all(denominator(QQ(M[i,j])) == 1
    for i in 1:nrows(M) for j in 1:ncols(M))

function hr_note(message)
    line = "$(now()) | $message | elapsed=$(round(time()-hr_started;digits=2)) s"
    println(line)
    flush(stdout)
    open(hr_stem * ".log","a") do io
        println(io,line)
    end
end

function hr_status(state)
    open(hr_stem * ".status.txt","w") do io
        println(io,state," time=",now(),
            " elapsed_seconds=",round(time()-hr_started;digits=2))
    end
end

function hr_step(f::Function,label::String)
    hr_note("START $label")
    started = time()
    value = f()
    elapsed = time()-started
    hr_timings[label] = elapsed
    hr_note("DONE $label; step=$(round(elapsed;digits=3)) s")
    return value
end

function hr_source_hashes()
    paths = (@__FILE__,joinpath(@__DIR__,"specs.jl"),
        joinpath(@__DIR__,"cached_plain_side_groups.jl"),
        joinpath(hr_project,"oscar","oscar_script.jl"),
        hr_source_path(hr_spec),
        joinpath(hr_project,"remark","input","family_numbering.md"))
    all(isfile,paths) || error("A prescribed-action source file is missing")
    return Dict(relpath(path,hr_project)=>hr_sha(path) for path in paths)
end

# Same calculation order as the two original runners: form O(S), its
# discriminant representation and stable kernel, then cache their matrices.
function hr_plain_context(S)
    qS = hr_step("discriminant_group(S)") do
        discriminant_group(S)
    end
    OS = hr_step("orthogonal_group(S)") do
        orthogonal_group(S)
    end
    rho = hr_step("discriminant_representation(S,O(S))") do
        discriminant_representation(S,OS)
    end
    image_group = hr_step("discriminant image") do
        first(image(rho))
    end
    stable_order = hr_step("stable kernel order") do
        divexact(order(OS),order(image_group))
    end
    stable_order == hr_spec.symplectic_order ||
        error("Unexpected symplectic kernel order")
    return (lattice=S,discriminant_group=qS,orthogonal_group=OS,
        discriminant_representation=rho,discriminant_image=image_group,
        tilde_order=stable_order)
end

# For large groups the numbered table specifies the order, not a
# SmallGroups ID. Avoid requesting an unnecessary structure description.
function hr_group_data(Sf,cache)
    hr_spec.group_id !== nothing && return cached_embedded_group_data(Sf,cache)
    transported = transport_plain_side_matrix_cache(lattice(Sf),cache)
    fS = isometry(Sf)
    H = matrix_group(vcat(collect(transported.symplectic_generators_S),[fS]))
    full_order = Int(order(H))
    full_order % transported.symplectic_order == 0 ||
        error("Full group order is not divisible by its symplectic order")
    return merge(transported,(
        group_gap_id="order $full_order",
        full_group_order=full_order,
        quotient_order=div(full_order,transported.symplectic_order),
        extra_generator_S=fS,
    ))
end

function hr_check_record(datum,S,T,Tf,cache,i)
    L = lattice(datum.Lambda0)
    Si = lattice(datum.S_in_Lambda0)
    Ti = lattice(datum.T_in_Lambda0)
    @assert rank(L) == 22 && signature_tuple(L) == (20,0,2)
    @assert iseven(L) && abs(det(gram_matrix(L))) == 3
    @assert is_isometric_with_isometry(discriminant_group(L),
        discriminant_group(root_lattice(:A,2)))[1]
    @assert gram_matrix(Si) == gram_matrix(S)
    @assert gram_matrix(Ti) == gram_matrix(T)
    @assert is_primitive(L,Si) && is_primitive(L,Ti)
    GL = gram_matrix(ambient_space(L))
    @assert gram_matrix(ambient_space(Si)) == gram_matrix(ambient_space(Ti)) == GL
    @assert basis_matrix(Si)*GL*transpose(basis_matrix(Ti)) ==
        zero_matrix(QQ,rank(Si),rank(Ti))
    # These ten primitive-extension outputs use a square rank-22 ambient
    # basis. This is checked before taking coordinates in that exact basis.
    @assert nrows(basis_matrix(L)) == ncols(basis_matrix(L)) == 22
    E = basis_matrix(Si)*inv(basis_matrix(L))
    C = basis_matrix(Ti)*inv(basis_matrix(L))
    @assert hr_integral(E) && hr_integral(C)
    @assert abs(det(vcat(E,C))) == glue_order_to_disc3(S,T)
    fS,fTi,fL = isometry(datum.S_in_Lambda0),
        isometry(datum.T_in_Lambda0),isometry(datum.Lambda0)
    @assert fS*E == E*fL && fTi*C == C*fL
    # The original ten prescribed-action outputs retain the selected T basis.
    # A changed basis must be transported explicitly, not accepted merely
    # because the two lattices with isometry are abstractly isomorphic.
    @assert fTi == isometry(Tf)
    @assert trivial_action_on_discriminant(datum.Lambda0)
    @assert datum.order == hr_spec.index && datum.dimension == hr_spec.dimension
    @assert rank(datum.P_in_Lambda0) == rank(T)
    @assert rank(datum.K_in_Lambda0) == rank(S)
    @assert is_primitive(L,datum.P_in_Lambda0)
    @assert is_primitive(L,datum.K_in_Lambda0)
    @assert rank(vcat(basis_matrix(Ti),basis_matrix(datum.P_in_Lambda0))) == rank(Ti)
    @assert rank(vcat(basis_matrix(Si),basis_matrix(datum.K_in_Lambda0))) == rank(Si)
    group_data = hr_step("output $i cached full-group check") do
        hr_group_data(datum.S_in_Lambda0,cache)
    end
    @assert group_data.symplectic_order == hr_spec.symplectic_order
    @assert group_data.quotient_order == hr_spec.index
    @assert group_data.full_group_order == hr_spec.symplectic_order*hr_spec.index
    if hr_spec.group_id !== nothing
        @assert group_data.group_gap_id isa Tuple
        @assert Tuple(Int.(group_data.group_gap_id)) == hr_spec.group_id
    end
    ambient_order = Int(order_of_isometry(datum.Lambda0))
    s_order = Int(order_of_isometry(datum.S_in_Lambda0))
    @assert ambient_order == lcm(s_order,hr_spec.index)
    return merge(datum,(
        source_family_number=hr_number,
        group_gap_id=group_data.group_gap_id,
        symplectic_order=group_data.symplectic_order,
        full_group_order=group_data.full_group_order,
        quotient_order=group_data.quotient_order,
        symplectic_generators_S=group_data.symplectic_generators_S,
        orthogonal_generators_S=group_data.orthogonal_generators_S,
        actual_ambient_generator_order=ambient_order,
        actual_S_generator_order=s_order,
        roots_verified=true,
    ))
end

function hr_main()
    source_hashes = hr_source_hashes()
    hr_status("RUNNING")
    S,T,Tf = hr_step("selected original inputs") do
        hr_inputs(hr_spec)
    end
    glue_index = glue_order_to_disc3(S,T)
    hr_note("No. $hr_number: prescribed T action of order $(hr_spec.index); " *
        "gluing index $glue_index; preparing O(S)")
    context = hr_plain_context(S)
    cache = hr_step("cache O(S) and stable-kernel matrices") do
        plain_side_matrix_cache(context)
    end
    raw = hr_step("lattice_data_for_T_action") do
        lattice_data_for_T_action(S,Tf,hr_spec.index;
            plain_context=context,ordS=context.tilde_order)
    end
    isempty(raw) && error("No stable root-free prescribed-action output survived")
    hr_note("Prescribed-action search returned $(length(raw)) ambient witnesses")
    records = Tuple(hr_check_record(datum,S,T,Tf,cache,i)
        for (i,datum) in enumerate(raw))
    hr_source_hashes() == source_hashes || error("A source changed during computation")
    payload = Dict{String,Any}(
        "format_version"=>1,"family_number"=>hr_number,
        "expected_symplectic_order"=>hr_spec.symplectic_order,
        "expected_group_id"=>hr_spec.group_id,
        "gluing_index"=>glue_index,
        "S_input"=>S,"T_input"=>T,"prescribed_T_action"=>Tf,
        "plain_side_matrix_cache"=>cache,"results"=>records,
        "source_sha256"=>source_hashes,
        "stage_seconds"=>copy(hr_timings),
        "julia_version"=>string(VERSION),
        "oscar_version"=>string(pkgversion(Oscar)),
        "elapsed_seconds"=>time()-hr_started,
        "classification"=>"first-fitting prescribed-action primitive-extension search",
    )
    staging = hr_stem*".building.mrdi"
    hr_step("save and reload sidecar") do
        save(staging,payload)
        check = load(staging)
        @assert check["family_number"] == hr_number
        @assert length(check["results"]) == length(records)
        @assert check["plain_side_matrix_cache"].S_gram == gram_matrix(S)
        @assert check["source_sha256"] == source_hashes
        for (saved,original) in zip(check["results"],records)
            @assert saved.full_group_order == original.full_group_order
            @assert saved.group_gap_id == original.group_gap_id
            @assert saved.symplectic_generators_S == original.symplectic_generators_S
            @assert isometry(saved.Lambda0) == isometry(original.Lambda0)
            @assert basis_matrix(lattice(saved.Lambda0)) ==
                basis_matrix(lattice(original.Lambda0))
        end
        mv(staging,hr_output)
    end
    hr_note("PASS No. $hr_number: saved $(length(records)) ambient witnesses; " *
        "full group order $(hr_spec.symplectic_order*hr_spec.index)")
    hr_status("COMPLETED")
end

try
    hr_note("Loading shared OSCAR search functions; Julia $VERSION")
    include(joinpath(hr_project,"oscar","oscar_script.jl"))
    include(joinpath(@__DIR__,"cached_plain_side_groups.jl"))
    hr_main()
catch err
    hr_note("FAILED: $(sprint(showerror,err))")
    hr_status("FAILED")
    rethrow()
end
