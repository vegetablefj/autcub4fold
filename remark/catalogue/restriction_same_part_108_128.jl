# Exact same-symplectic-part power restrictions, No. 108 from No. 113 and
# No. 128 from No. 131. This consumes already verified integral parent
# actions; it does not search for new isometry classes or edit the catalogue.
# Stages: preflight, restrict, verify. Existing outputs are never replaced.

using SHA
include(joinpath(@__DIR__, "restriction_functions.jl"))

const rsp_specs = (
    (child=108,parent=113,sym_order=3,parent_index=6,power=3,
     index=2,rank_S=12,dimension=4,group_id=(6,2)),
    (child=128,parent=131,sym_order=2,parent_index=12,power=2,
     index=6,rank_S=8,dimension=3,group_id=(12,5)),
)
const rsp_parent_113 = joinpath(@__DIR__,
    "restriction_86_113_from_62.verified.mrdi")
const rsp_parent_131 = joinpath(@__DIR__,
    "restriction_131_from_24.verified.mrdi")
const rsp_geometry = joinpath(@__DIR__,
    "restriction_same_part_108_128_geometric.tsv")
const rsp_geometry_script = joinpath(@__DIR__,
    "restriction_same_part_108_128_geometric.g")
const rsp_families = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const rsp_witnesses = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result",
    "gap_fourfold_cross_dimension_positive_edges.g")
const rsp_numbering = joinpath(@__DIR__, "..", "input",
    "family_numbering.md")
const rsp_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result",
    "gap_fourfold_cross_dimension_all_pairs.tsv")
const rsp_default_restricted = joinpath(@__DIR__,
    "restriction_same_part_108_128.restricted.mrdi")
const rsp_default_verified = joinpath(@__DIR__,
    "restriction_same_part_108_128.verified.mrdi")

rsp_note(s) = (println(s); flush(stdout))
rsp_sha(p) = bytes2hex(sha256(read(p)))
rsp_key(n) = lpad(string(n),3,'0')

function rsp_source_hashes()
    paths = (rsp_parent_113,rsp_parent_131,rsp_geometry,
        rsp_geometry_script,rsp_families,rsp_witnesses,rsp_numbering,
        rsp_edges,@__FILE__,joinpath(@__DIR__,"restriction_functions.jl"),
        joinpath(@__DIR__,"..","..","oscar","oscar_script.jl"))
    all(isfile,paths) || error("A verified parent, geometric audit, or implementation is missing")
    return Tuple((basename(p),rsp_sha(p)) for p in paths)
end

function rsp_table_and_edges()
    expected = Dict(
        108=>(12,"C3",1,2,4,(6,2)),
        113=>(12,"C3",1,6,2,(18,5)),
        128=>(8,"C2",1,6,3,(12,5)),
        131=>(8,"C2",1,12,1,(24,9)))
    observed = Dict{Int,Tuple}()
    for line in eachline(rsp_numbering)
        startswith(line,'|') || continue
        fields = strip.(split(line,'|'))
        length(fields) >= 9 || continue
        n = tryparse(Int,fields[2])
        n === nothing && continue
        haskey(expected,n) || continue
        m = match(r"\[(\d+),(\d+)\]",fields[8])
        m === nothing && error("Missing group ID in row $n")
        haskey(observed,n) && error("Duplicate numbered row $n")
        observed[n] = (parse(Int,fields[3]),replace(fields[4],"`"=>""),
            parse(Int,fields[5]),parse(Int,fields[6]),
            parse(Int,fields[7]),
            (parse(Int,m.captures[1]),parse(Int,m.captures[2])))
    end
    observed == expected || error("Numbered metadata changed: $observed")
    for spec in rsp_specs
        hits = 0
        for (i,line) in enumerate(eachline(rsp_edges))
            i == 1 && continue
            v = split(line,'\t')
            length(v) == 12 || error("Malformed containment row $i")
            parse(Int,v[1]) == spec.child && parse(Int,v[2]) == spec.parent || continue
            Tuple(parse.(Int,v[3:6])) ==
                (spec.dimension,expected[spec.parent][5],3*spec.sym_order*spec.index,
                 3*spec.sym_order*spec.parent_index) ||
                error("Containment orders/dimensions changed for $(spec.child)")
            v[7:12] == ["embedded","direct","true","fail",
                "literal_matrix_subgroup","literal_matrix_subgroup"] ||
                error("No. $(spec.child) -> $(spec.parent) is no longer literal/direct")
            hits += 1
        end
        hits == 1 || error("Expected one literal strict edge for No. $(spec.child)")
    end
end

function rsp_geometric_histograms()
    out = Dict(n=>Dict{Tuple{Int,Int},Int}() for n in (108,128))
    for (i,line) in enumerate(eachline(rsp_geometry))
        if i == 1
            line == "child_number\tparent_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric TSV header")
            continue
        end
        isempty(strip(line)) && continue
        v = split(line,'\t')
        length(v) == 5 || error("Malformed geometric row $i")
        n,parent,ord,tr,count = parse.(Int,v)
        spec = only(s for s in rsp_specs if s.child == n)
        parent == spec.parent && ord > 0 && count > 0 ||
            error("Geometric metadata mismatch in row $i")
        key = (ord,tr)
        haskey(out[n],key) && error("Duplicate geometric bin")
        out[n][key] = count
    end
    for spec in rsp_specs
        sum(values(out[spec.child])) == spec.sym_order*spec.index ||
            error("Incomplete child geometric character")
        get(out[spec.child],(1,22),0) == 1 ||
            error("Identity geometric character absent")
    end
    return out
end

function rsp_parent(spec)
    if spec.child == 108
        v = load(rsp_parent_113)
        @assert v.format_version == 1 && v.roots_verified &&
            v.complete_within_saved_parent &&
            v.all_character_matches_processed &&
            isempty(v.root_obstructed)
        path = only(x for x in v.verified_results if x.child_number == 113)
        parent = path.result
        @assert parent.parent_number == 62 && parent.child_number == 113
        @assert parent.extracted_subgroup_id == (18,5)
        @assert length(parent.symplectic_generators_in_parent) == 1
        a = only(parent.symplectic_generators_in_parent)
    elseif spec.child == 128
        v = load(rsp_parent_131)
        @assert v.format_version == 1 && v.roots_verified &&
            v.numbered_assignment_claimed && isempty(v.root_obstructed_classes)
        path = only(v.verified_results)
        parent = path.result
        @assert parent.parent_number == 24 && parent.child_number == 131
        @assert parent.extracted_subgroup_id == (24,9)
        a = parent.symplectic_generator_in_parent
    else
        error("Unsupported target No. $(spec.child)")
    end
    @assert parent.order == spec.parent_index
    @assert rank(lattice(parent.S_in_Lambda0)) == spec.rank_S
    @assert rank(lattice(parent.T_in_Lambda0)) == 22-spec.rank_S
    @assert Int(order_of_isometry(parent.T_action)) == spec.parent_index
    return parent,a
end

function rsp_order(M,max_order)
    one = identity_matrix(QQ,nrows(M))
    power = one
    for k in 1:max_order
        power *= M
        power == one && return k
    end
    error("A rank-22 action exceeds the expected finite order")
end

function rsp_elements(a,g,sym_order,quotient_order)
    elements = [a^i*g^j for j in 0:quotient_order-1
                        for i in 0:sym_order-1]
    length(elements) == sym_order*quotient_order || error("Bad element count")
    all(elements[i] != elements[j] for i in 1:length(elements)
        for j in i+1:length(elements)) ||
        error("Group elements are not distinct")
    return elements
end

function rsp_histogram(elements)
    max_order = length(elements)
    histogram = Dict{Tuple{Int,Int},Int}()
    for M in elements
        ord = rsp_order(M,max_order)
        trace = sum(M[i,i] for i in 1:22)
        denominator(trace) == 1 || error("Nonintegral primitive trace")
        key = (ord,Int(trace))
        histogram[key] = get(histogram,key,0)+1
    end
    return histogram
end

function rsp_embedded_basis_change(older,newer)
    X,Y = lattice(older),lattice(newer)
    rank(X) == rank(Y) || error("Embedded lattice ranks differ")
    B,C = basis_matrix(X),basis_matrix(Y)
    G = gram_matrix(ambient_space(X))
    U = C*G*transpose(B)*inv(B*G*transpose(B))
    U*B == C || error("The sublattices have different rational spans")
    all(denominator(U[i,j]) == 1 for i in 1:nrows(U), j in 1:ncols(U)) ||
        error("The new lattice is not contained integrally in the old one")
    abs(det(U)) == 1 || error("The embedded lattices differ by index")
    return U
end

function rsp_one(spec,expected)
    parent,a = rsp_parent(spec)
    L = lattice(parent.Lambda0)
    f = isometry(parent.Lambda0)
    I22 = identity_matrix(QQ,22)
    a^spec.sym_order == I22 || error("Wrong symplectic generator order")
    f*a == a*f || error("The saved parent action is not abelian")
    f^spec.parent_index in [a^i for i in 0:spec.sym_order-1] ||
        error("The parent quotient relation does not close")
    @assert Int(order_of_isometry(parent.T_action)) == spec.parent_index
    full = rsp_elements(a,f,spec.sym_order,spec.parent_index)
    g = f^spec.power
    g^spec.index in [a^i for i in 0:spec.sym_order-1] ||
        error("The child quotient relation does not close")
    restricted = rsp_elements(a,g,spec.sym_order,spec.index)
    all(any(x==y for y in full) for x in restricted) ||
        error("A child matrix is absent from the parent action")
    char = rsp_histogram(restricted)
    char == expected || error("Exact integral H4 character differs from geometry: $char")
    result = complete_cyclic_restriction(parent,a,g;
        child_number=spec.child,parent_number=spec.parent,index=spec.index,
        expected_rank_S=spec.rank_S,expected_dimension=spec.dimension,
        expected_group_id=spec.group_id,verify_group_id=false,
        verify_roots=true,verify_symplectic_saturation=false)
    @assert result.extracted_subgroup_id == spec.group_id
    @assert rank(lattice(result.Lambda0)) == 22
    @assert trivial_action_on_discriminant(result.Lambda0)
    @assert Int(order_of_isometry(result.T_action)) == spec.index
    @assert !has_root(result.K_in_Lambda0,L)
    rsp_embedded_basis_change(parent.S_in_Lambda0,result.S_in_Lambda0)
    U = rsp_embedded_basis_change(parent.T_in_Lambda0,result.T_in_Lambda0)
    @assert isometry(result.T_action) ==
        U*isometry(parent.T_action)^spec.power*inv(U)
    return (child=spec.child,parent=spec.parent,power=spec.power,
        subgroup_order=length(restricted),symplectic_order=spec.sym_order,
        quotient_order=spec.index,geometric_character=char,
        S_T_unchanged=true,roots_verified=true,
        quotient_power_verified=true,result=result)
end

function rsp_preflight()
    hashes = rsp_source_hashes()
    rsp_table_and_edges()
    geometry = rsp_geometric_histograms()
    for spec in rsp_specs
        rsp_parent(spec)
        rsp_note("PASS: No. $(spec.child) < No. $(spec.parent), quotient index $(spec.index), geometric character size $(sum(values(geometry[spec.child])))")
    end
    rsp_note("Source SHA-256 hashes: $hashes")
    return hashes,geometry
end

function rsp_restrict(output)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Output must end in .mrdi")
    hashes,geometry = rsp_preflight()
    paths = Tuple(rsp_one(spec,geometry[spec.child]) for spec in rsp_specs)
    save(output,(format_version=1,source_hashes=hashes,
        method="unique quotient-subgroup preimages, exact primitive character, full integral restriction",
        target_numbers=(108,128),paths=paths,
        complete_within_verified_parent_actions=true,
        roots_verified=true,symplectic_saturation_verified=false,
        global_integral_uniqueness_claimed=false))
    data = load(output)
    @assert data.source_hashes == hashes && length(data.paths) == 2
    rsp_note("Saved and reloaded $output")
end

function rsp_verify(output,input)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Output must end in .mrdi")
    data = load(input)
    hashes,geometry = rsp_preflight()
    @assert data.format_version == 1 && data.source_hashes == hashes
    @assert data.target_numbers == (108,128) && length(data.paths) == 2
    @assert data.complete_within_verified_parent_actions && data.roots_verified
    fresh = Tuple(rsp_one(spec,geometry[spec.child]) for spec in rsp_specs)
    for (old,new) in zip(data.paths,fresh)
        @assert old.child == new.child && old.parent == new.parent
        @assert old.geometric_character == new.geometric_character
        @assert old.result.order == new.result.order
        @assert old.result.dimension == new.result.dimension
        @assert old.result.extracted_subgroup_id == new.result.extracted_subgroup_id
        @assert basis_matrix(lattice(old.result.S_in_Lambda0)) ==
            basis_matrix(lattice(new.result.S_in_Lambda0))
        @assert basis_matrix(lattice(old.result.T_in_Lambda0)) ==
            basis_matrix(lattice(new.result.T_in_Lambda0))
        @assert basis_matrix(old.result.P_in_Lambda0) ==
            basis_matrix(new.result.P_in_Lambda0)
        @assert basis_matrix(old.result.K_in_Lambda0) ==
            basis_matrix(new.result.K_in_Lambda0)
        @assert isometry(old.result.T_action) == isometry(new.result.T_action)
        @assert isometry(old.result.Lambda0) == isometry(new.result.Lambda0)
    end
    save(output,(format_version=1,source_hashes=hashes,
        restriction_file_hash=rsp_sha(input),target_numbers=(108,128),
        paths=fresh,independently_recomputed=true,
        complete_within_verified_parent_actions=true,roots_verified=true,
        symplectic_saturation_verified=false,
        global_integral_uniqueness_claimed=false))
    check = load(output)
    @assert check.restriction_file_hash == rsp_sha(input)
    @assert length(check.paths) == 2
    rsp_note("Independently recomputed and verified $output")
end

function rsp_main()
    isempty(ARGS) && error("Choose preflight, restrict, or verify")
    stage = ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no extra arguments")
        rsp_preflight()
    elseif stage == "restrict"
        length(ARGS) <= 2 || error("restrict [output.mrdi]")
        rsp_restrict(length(ARGS)==2 ? abspath(ARGS[2]) : rsp_default_restricted)
    elseif stage == "verify"
        length(ARGS) <= 3 || error("verify [output.mrdi] [restricted.mrdi]")
        rsp_verify(length(ARGS)>=2 ? abspath(ARGS[2]) : rsp_default_verified,
            length(ARGS)==3 ? abspath(ARGS[3]) : rsp_default_restricted)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    rsp_main()
end
