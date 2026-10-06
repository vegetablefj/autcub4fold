# Exact same-symplectic-part restrictions for Nos. 88, 89, 90, 91, 93.
# The full S3 kernel is retained. Stages do not edit the numbered catalogue.

using SHA
include(joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))
include(joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl"))

const same_s3_specs = (
    (child=88,parent=94,index=2,dimension=6,id=(12,4),primary=true),
    (child=88,parent=95,index=2,dimension=6,id=(12,4),primary=false),
    (child=89,parent=94,index=4,dimension=3,id=(24,5),primary=true),
    (child=89,parent=95,index=4,dimension=3,id=(24,5),primary=false),
    (child=90,parent=94,index=6,dimension=3,id=(36,12),primary=true),
    (child=91,parent=95,index=6,dimension=3,id=(36,12),primary=true),
    (child=93,parent=96,index=8,dimension=1,id=(48,4),primary=true),
)
const same_s3_parent_94_95 = joinpath(@__DIR__,
    "restriction_candidates_94_95_from_24.direct_lattices.mrdi")
const same_s3_parent_96 = joinpath(@__DIR__, "maximal_six_standard.mrdi")
const same_s3_kernel_96 = joinpath(@__DIR__, "restriction_129_from_96.kernel.mrdi")
const same_s3_table = joinpath(@__DIR__, "..", "input", "family_numbering.md")
const same_s3_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result",
    "gap_fourfold_cross_dimension_all_pairs.tsv")
const same_s3_frozen_groups = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const same_s3_frozen_witnesses = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result",
    "gap_fourfold_cross_dimension_positive_edges.g")
const same_s3_character_script = joinpath(@__DIR__,
    "restriction_same_s3_geometric_characters.g")
const same_s3_characters = joinpath(@__DIR__,
    "restriction_same_s3_geometric_characters.tsv")
const same_s3_groups_file = joinpath(@__DIR__,
    "restriction_same_s3_from_94_95_96.groups.mrdi")
const same_s3_lattices_file = joinpath(@__DIR__,
    "restriction_same_s3_from_94_95_96.lattices.mrdi")
const same_s3_verified_file = joinpath(@__DIR__,
    "restriction_same_s3_from_94_95_96.verified.mrdi")

same_s3_note(s) = (println(s); flush(stdout))
same_s3_hash(path) = bytes2hex(sha256(read(path)))

function same_s3_hashes()
    paths = (same_s3_parent_94_95,same_s3_parent_96,same_s3_kernel_96,
        same_s3_table,same_s3_edges,same_s3_frozen_groups,
        same_s3_frozen_witnesses,same_s3_character_script,
        same_s3_characters,joinpath(@__DIR__,"restriction_same_s3_from_94_95_96.jl"),
        joinpath(@__DIR__,"enumerate_restrictions_94_95_direct.jl"),
        joinpath(@__DIR__,"..","..","oscar","oscar_script.jl"))
    all(isfile,paths) || error("Missing parent, geometric character, or source")
    return Tuple((basename(p),same_s3_hash(p)) for p in paths)
end

function same_s3_table_checks()
    expected = Dict(
        88=>(14,"S3",2,2,6,(12,4)),
        89=>(14,"S3",2,4,3,(24,5)),
        90=>(14,"S3",2,6,3,(36,12)),
        91=>(14,"S3",2,6,3,(36,12)),
        93=>(14,"S3",2,8,1,(48,4)),
        94=>(14,"S3",2,12,1,(72,27)),
        95=>(14,"S3",2,12,1,(72,27)),
        96=>(14,"S3",2,24,0,(144,69)),
    )
    found = Dict{Int,Tuple}()
    for line in eachline(same_s3_table)
        startswith(line,"|") || continue
        cells = strip.(split(line,'|'))
        length(cells) >= 9 || continue
        n = tryparse(Int,cells[2])
        n === nothing && continue
        haskey(expected,n) || continue
        haskey(found,n) && error("Duplicate numbered row $n")
        m = match(r"\[(\d+),(\d+)\]",cells[8])
        m === nothing && error("Missing group ID for row $n")
        found[n] = (parse(Int,cells[3]),replace(cells[4],"`"=>""),
            parse(Int,cells[5]),parse(Int,cells[6]),parse(Int,cells[7]),
            (parse(Int,m.captures[1]),parse(Int,m.captures[2])))
    end
    found == expected || error("Numbered rank, group, index or dimension changed")
end

function same_s3_edge_checks()
    wanted = Set((s.child,s.parent) for s in same_s3_specs)
    found = Set{Tuple{Int,Int}}()
    for (i,line) in enumerate(eachline(same_s3_edges))
        i == 1 && continue
        v = split(line,'\t')
        length(v) == 12 || error("Malformed strict-containment row $i")
        pair = (parse(Int,v[1]),parse(Int,v[2]))
        pair in wanted || continue
        pair in found && error("Duplicate strict edge $pair")
        s = only(x for x in same_s3_specs if
            (x.child,x.parent) == pair)
        source_dim = s.dimension
        parent_dim = s.parent == 96 ? 0 : 1
        parent_order = s.parent == 96 ? 144 : 72
        Tuple(parse.(Int,v[3:6])) ==
            (source_dim,parent_dim,3*s.id[1],3*parent_order) ||
            error("Wrong strict-containment metadata $pair")
        v[7:10] == ["embedded","direct","true","fail"] ||
            error("The edge $pair is not a direct strict containment")
        v[11] in ("found","literal_matrix_subgroup") ||
            error("Unexpected strict-containment finding $pair")
        v[12] in ("literal_matrix_subgroup","A_strict") ||
            error("Unexpected containment method $pair")
        push!(found,pair)
    end
    found == wanted || error("A direct strict-containment edge is missing")
end

function same_s3_character(child,order)
    h = Dict{Tuple{Int,Int},Int}()
    for (i,line) in enumerate(eachline(same_s3_characters))
        if i == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric character header")
            continue
        end
        isempty(strip(line)) && continue
        v = split(line,'\t')
        length(v) == 4 || error("Malformed character line $i")
        n,ord,tr,count = parse.(Int,v)
        n == child || continue
        1 <= ord <= order && -22 <= tr <= 22 && count > 0 ||
            error("Invalid geometric character line $i")
        key = (ord,tr)
        haskey(h,key) && error("Duplicate geometric character bin $key")
        h[key] = count
    end
    sum(values(h)) == order && get(h,(1,22),0) == 1 ||
        error("Incomplete geometric character for No. $child")
    return h
end

function same_s3_parent(number)
    if number in (94,95)
        data = load(same_s3_parent_94_95)
        @assert data.format_version == 1 && data.parent_number == 24
        @assert data.character_assignment_verified
        class = number == 94 ? data.assigned_class_94 : data.assigned_class_95
        parent = only(x for x in data.results if
            x.class_number == class && x.character_matches == [number])
        @assert parent.abstract_projective_group_id == (72,27)
        @assert parent.symplectic_intersection_id == (6,1)
        @assert length(parent.symplectic_generators_in_parent) == 2
        generators = parent.symplectic_generators_in_parent
        quotient = 12
    elseif number == 96
        data = load(same_s3_parent_96)
        record = data["records"]["096"]
        @assert record.provenance.family_number == 96
        @assert record.provenance.selected_output == 1
        parent = record.data
        @assert parent.group_gap_id == (144,69)
        cache = load(same_s3_kernel_96)
        @assert cache.format_version == 1 && cache.parent_number == 96
        @assert cache.symplectic_order == 6 && cache.quotient_order == 24
        @assert cache.full_group_order == 144
        @assert cache.extra_generator_Lambda0 == isometry(parent.Lambda0)
        generators = cache.symplectic_generators_Lambda0
        quotient = 24
    else
        error("Unsupported parent No. $number")
    end
    L = lattice(parent.Lambda0)
    S = lattice(parent.S_in_Lambda0)
    T = lattice(parent.T_in_Lambda0)
    f = isometry(parent.Lambda0)
    @assert rank(L) == 22 && signature_tuple(L) == (20,0,2)
    @assert abs(det(gram_matrix(L))) == 3
    @assert rank(S) == 14 && rank(T) == 8
    @assert parent.order == quotient
    @assert order_of_isometry(parent.T_action) == quotient
    e = identity_matrix(QQ,22)
    eT = basis_matrix(T)*inv(basis_matrix(L))
    @assert all(eT*g == eT for g in generators)
    @assert rank(hcat((g-e for g in generators)...)) == 14
    nctx = direct_context(generators,f,6,quotient)
    @assert sort(nctx.orders) == [1,2,2,2,3,3]
    return (;number,parent,L,S,T,generators,f,quotient,nctx)
end

# Exact finite table for N f^k; N is the order-six full symplectic kernel.
function same_s3_context(p)
    q = p.quotient
    idx(n,k) = 6*k+n
    fpowers = [p.f^k for k in 0:q-1]
    elements = [p.nctx.elements[n]*fpowers[k+1]
        for k in 0:q-1 for n in 1:6]
    @assert length(elements) == 6*q
    @assert length(Set(direct_matrix_key(x) for x in elements)) == 6*q
    function phi_power(n,k)
        for _ in 1:k
            n = p.nctx.phi[n]
        end
        return n
    end
    mul = zeros(Int,6*q,6*q)
    for i in 1:6*q, j in 1:6*q
        n,k = mod1(i,6),div(i-1,6)
        m,l = mod1(j,6),div(j-1,6)
        a = p.nctx.mul(n,phi_power(m,k))
        k+l >= q && (a = p.nctx.mul(a,p.nctx.c))
        mul[i,j] = idx(a,mod(k+l,q))
    end
    @assert all(mul[1,i] == i && mul[i,1] == i for i in 1:6*q)
    inverses = [only(j for j in 1:6*q if
        mul[i,j] == 1 && mul[j,i] == 1) for i in 1:6*q]
    orders = Int[]
    for i in 1:6*q
        x = 1; ord = 0
        while true
            x = mul[x,i]; ord += 1
            x == 1 && break
            ord <= 6*q || error("Order exceeds finite parent size")
        end
        push!(orders,ord)
    end
    generators = [p.nctx.generator_ids;idx(1,1)]
    @assert all(elements[mul[i,g]] == elements[i]*elements[g]
        for i in 1:6*q for g in generators)
    @assert all(elements[i]*elements[inverses[i]] == elements[1]
        for i in 1:6*q)
    return (;p,idx,elements,mul,inverses,orders,generators)
end

function same_s3_key(ctx,index)
    q = ctx.p.quotient
    q % index == 0 || error("Index does not divide parent quotient")
    step = div(q,index)
    key = Tuple(ctx.idx(n,k) for k in 0:step:q-1 for n in 1:6)
    @assert length(key) == 6*index && length(unique(key)) == 6*index
    set = Set(key)
    @assert all(ctx.mul[i,j] in set for i in key for j in key)
    @assert all(ctx.inverses[i] in set for i in key)
    @assert Tuple(i for i in key if i <= 6) == Tuple(1:6)
    return key,step
end

function same_s3_group_id(ctx,key,step)
    positions = Dict(x => i for (i,x) in enumerate(key))
    perms = Any[]
    for g in [ctx.p.nctx.generator_ids;ctx.idx(1,step)]
        image = [positions[ctx.mul[g,x]] for x in key]
        @assert sort(image) == collect(1:length(key))
        push!(perms,GAP.Globals.PermList(GapObj(image)))
    end
    group = GAP.Globals.Group(perms...)
    @assert Int(GAP.Globals.Size(group)) == length(key)
    id = GAP.Globals.IdGroup(group)
    return (Int(id[1]),Int(id[2]))
end

function same_s3_histogram(ctx,key)
    h = Dict{Tuple{Int,Int},Int}()
    for i in key
        trace = sum(ctx.elements[i][j,j] for j in 1:22)
        denominator(trace) == 1 || error("Nonintegral primitive trace")
        bin = (ctx.orders[i],Int(numerator(trace)))
        h[bin] = get(h,bin,0)+1
    end
    @assert sum(values(h)) == length(key) && get(h,(1,22),0) == 1
    return h
end

function same_s3_preflight()
    hashes = same_s3_hashes()
    same_s3_table_checks(); same_s3_edge_checks()
    for child in (88,89,90,91,93)
        s = only(x for x in same_s3_specs if x.child == child && x.primary)
        same_s3_character(child,s.id[1])
    end
    for parent in (94,95,96)
        same_s3_parent(parent)
    end
    same_s3_note("Five numbered rows, seven strict edges, exact characters and three saved parents passed")
    same_s3_note("Source SHA-256 hashes: $hashes")
    return hashes
end

function same_s3_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    hashes = same_s3_preflight()
    contexts = Dict(parent => same_s3_context(same_s3_parent(parent))
        for parent in (94,95,96))
    candidates = NamedTuple[]
    for s in same_s3_specs
        ctx = contexts[s.parent]
        key,step = same_s3_key(ctx,s.index)
        id = same_s3_group_id(ctx,key,step)
        id == s.id || error("Wrong abstract subgroup for No. $(s.child) in No. $(s.parent): $id")
        hist = same_s3_histogram(ctx,key)
        expected = same_s3_character(s.child,s.id[1])
        match = hist == expected
        s.primary && !match && error("Primary No. $(s.child) path has wrong geometric character")
        push!(candidates,(child_number=s.child,parent_number=s.parent,
            primary=s.primary,quotient_index=s.index,power=step,
            subgroup_indices=key,subgroup_id=id,
            primitive_character_histogram=hist,
            geometric_character_match=match,
            extra_generator=ctx.p.f^step))
        same_s3_note("No. $(s.child) from No. $(s.parent): power=$step, group=$id, character match=$match")
    end
    save(output,(format_version=1,source_hashes=hashes,
        method="full S3 kernel plus unique subgroup of cyclic parent quotient; exact table, ID and primitive character",
        complete_for_listed_parent_child_pairs=true,candidates=Tuple(candidates),
        lattice_and_root_checks_done=false))
    check = load(output)
    @assert check.source_hashes == hashes && length(check.candidates) == 7
    same_s3_note("Saved and reloaded $output")
end

function same_s3_lattice_result(ctx,c)
    p = ctx.p; L,S,T = p.L,p.S,p.T
    f = c.extra_generator
    @assert f == p.f^c.power
    Lambda0 = integer_lattice_with_isometry(L,f;
        ambient_representation=false,check=true)
    @assert trivial_action_on_discriminant(Lambda0)
    Simg = lattice_in_same_ambient_space(Lambda0,basis_matrix(S);check=true)
    Timg = lattice_in_same_ambient_space(Lambda0,basis_matrix(T);check=true)
    Taction = full_rank_model(Timg)
    @assert order_of_isometry(Taction) == c.quotient_index
    pk = embedded_PK_data(Lambda0,Timg,c.quotient_index)
    P,K = pk.P_lattice,pk.K_lattice
    @assert rank(P) == 8 && rank(K) == 14
    @assert signature_tuple(P) == (6,0,2)
    @assert signature_tuple(K) == (14,0,0)
    s = only(x for x in same_s3_specs if
        x.child == c.child_number && x.parent == c.parent_number)
    @assert period_dimension(P,c.quotient_index) == s.dimension
    # P has full rank in the primitive invariant T, so it equals T as an
    # embedded primitive lattice; K is the orthogonal complement of T.
    # Their computed bases need not literally equal the saved S/T bases.
    @assert rank(vcat(basis_matrix(P),basis_matrix(T))) == 8
    @assert rank(vcat(basis_matrix(K),basis_matrix(S))) == 14
    @assert abs(det(gram_matrix(P))) == abs(det(gram_matrix(T)))
    @assert abs(det(gram_matrix(K))) == abs(det(gram_matrix(S)))
    return (order=c.quotient_index,dimension=s.dimension,
        S_in_Lambda0=Simg,T_in_Lambda0=Timg,T_action=Taction,
        P_in_Lambda0=P,K_in_Lambda0=K,P_action=pk.P_with_isometry,
        Lambda0=Lambda0,group_gap_id=nothing,
        extracted_subgroup_id=c.subgroup_id,
        symplectic_generators_in_parent=p.generators,
        extra_generator_in_parent=f,parent_number=c.parent_number,
        child_number=c.child_number,
        symplectic_kernel_order_from_parent=6,
        symplectic_saturation_verified=false,
        group_id_source="exact subgroup of the saved parent")
end

function same_s3_lattices(output,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path)
    @assert groups.format_version == 1 &&
        groups.complete_for_listed_parent_child_pairs
    @assert groups.source_hashes == same_s3_hashes()
    contexts = Dict(parent => same_s3_context(same_s3_parent(parent))
        for parent in (94,95,96))
    results = NamedTuple[]
    for c in groups.candidates
        c.geometric_character_match || continue
        r = same_s3_lattice_result(contexts[c.parent_number],c)
        push!(results,(child_number=c.child_number,parent_number=c.parent_number,
            primary=c.primary,result=r))
        same_s3_note("No. $(c.child_number) from No. $(c.parent_number): P=8, K=14, dimension=$(r.dimension)")
    end
    @assert all(any(r.child_number == child && r.primary for r in results)
        for child in (88,89,90,91,93))
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=same_s3_hash(groups_path),results=Tuple(results),
        lattice_match_count=length(results),roots_verified=false,
        symplectic_saturation_verified=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert length(check.results) == length(results)
    same_s3_note("Saved and reloaded $output; lattice matches=$(length(results))")
end

function same_s3_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path); data = load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.source_hashes == data.source_hashes == same_s3_hashes()
    @assert data.groups_file_hash == same_s3_hash(groups_path)
    contexts = Dict(parent => same_s3_context(same_s3_parent(parent))
        for parent in (94,95,96))
    verified = NamedTuple[]
    for row in data.results
        c = only(x for x in groups.candidates if
            x.child_number == row.child_number && x.parent_number == row.parent_number)
        ctx = contexts[c.parent_number]
        key,step = same_s3_key(ctx,c.quotient_index)
        @assert step == c.power && key == c.subgroup_indices
        @assert same_s3_group_id(ctx,key,step) == c.subgroup_id
        @assert same_s3_histogram(ctx,key) == c.primitive_character_histogram ==
            same_s3_character(c.child_number,c.subgroup_id[1])
        fresh = same_s3_lattice_result(ctx,c)
        old = row.result
        @assert basis_matrix(lattice(fresh.S_in_Lambda0)) ==
            basis_matrix(lattice(old.S_in_Lambda0))
        @assert basis_matrix(lattice(fresh.T_in_Lambda0)) ==
            basis_matrix(lattice(old.T_in_Lambda0))
        @assert basis_matrix(fresh.P_in_Lambda0) == basis_matrix(old.P_in_Lambda0)
        @assert basis_matrix(fresh.K_in_Lambda0) == basis_matrix(old.K_in_Lambda0)
        @assert isometry(fresh.Lambda0) == isometry(old.Lambda0)
        @assert isometry(fresh.T_action) == isometry(old.T_action)
        @assert !has_root(fresh.K_in_Lambda0,ctx.p.L)
        push!(verified,(child_number=c.child_number,parent_number=c.parent_number,
            primary=c.primary,subgroup_id=c.subgroup_id,
            roots_verified=true,result=fresh))
        same_s3_note("No. $(c.child_number) from No. $(c.parent_number): exact subgroup, lattice and roots verified")
    end
    @assert all(any(r.child_number == child && r.primary for r in verified)
        for child in (88,89,90,91,93))
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=same_s3_hash(groups_path),
        lattices_file_hash=same_s3_hash(lattices_path),
        verified_results=Tuple(verified),match_count=length(verified),
        roots_verified=true,symplectic_saturation_verified=false,
        numbered_catalogue_edited=false))
    check = load(output)
    @assert check.source_hashes == data.source_hashes
    @assert length(check.verified_results) == length(verified)
    same_s3_note("Saved and reloaded $output; verified=$(length(verified))")
end

function same_s3_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices, or verify")
    stage = ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no arguments")
        same_s3_preflight()
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        same_s3_groups(length(ARGS) == 2 ? abspath(ARGS[2]) : same_s3_groups_file)
    elseif stage == "lattices"
        length(ARGS) <= 3 || error("lattices [output.mrdi] [groups.mrdi]")
        same_s3_lattices(length(ARGS) >= 2 ? abspath(ARGS[2]) : same_s3_lattices_file,
            length(ARGS) == 3 ? abspath(ARGS[3]) : same_s3_groups_file)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        same_s3_verify(length(ARGS) >= 2 ? abspath(ARGS[2]) : same_s3_verified_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : same_s3_lattices_file,
            length(ARGS) == 4 ? abspath(ARGS[4]) : same_s3_groups_file)
    else
        error("Unknown stage: $stage")
    end
end

same_s3_main()
