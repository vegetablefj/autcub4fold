# Exhaustive No. 104 restrictions inside the saved full No. 28 action.
# Requires the independently verified No. 28 rank-22 cache. No stage runs on include.
# The finite search uses the exact order-72 kernel and formal six cosets, never
# a black-box subgroup enumeration of the order-432 parent.

using SHA
include(joinpath(@__DIR__, "prepare_no28_full_lattice_group.jl"))
include(joinpath(@__DIR__, "restriction_functions.jl"))

const r104_table = joinpath(@__DIR__, "..", "input", "family_numbering.md")
const r104_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_all_pairs.tsv")
const r104_families = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const r104_witnesses = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result",
    "gap_fourfold_cross_dimension_positive_edges.g")
const r104_character_script = joinpath(@__DIR__, "restriction_104_geometric_character.g")
const r104_character_file = joinpath(@__DIR__, "restriction_104_geometric_character.tsv")
const r104_groups_file = joinpath(@__DIR__, "restriction_104_from_28.groups.mrdi")
const r104_lattices_file = joinpath(@__DIR__, "restriction_104_from_28.lattices.mrdi")
const r104_verified_file = joinpath(@__DIR__, "restriction_104_from_28.verified.mrdi")

r104_note(s) = (println(s); flush(stdout))
r104_hash(path) = bytes2hex(sha256(read(path)))
r104_saved(xs) = isempty(xs) ? String[] : Tuple(xs)
r104_idx(n::Int,k::Int) = 72*k+n
r104_normal(i::Int) = ((i-1)%72+1,(i-1)÷72)

function r104_hashes()
    paths = (no28_cache,no28_source,r104_table,r104_edges,r104_families,
        r104_witnesses,r104_character_script,r104_character_file,@__FILE__,
        joinpath(@__DIR__, "prepare_no28_full_lattice_group.jl"),
        joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"),
        joinpath(@__DIR__, "restriction_functions.jl"),
        joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl"))
    all(isfile,paths) || error("A No. 104 source or the No. 28 cache is missing")
    return Tuple((basename(p),r104_hash(p)) for p in paths)
end

function r104_numbering_and_edge()
    expected = Dict(28=>(18,"A_4,3",2,6,1,(432,745)),
                    104=>(12,"C2^2",1,6,2,(24,13)))
    found = Dict{Int,Tuple}()
    for line in eachline(r104_table)
        startswith(line,'|') || continue
        cells = strip.(split(line,'|'))
        length(cells) >= 9 || continue
        n = tryparse(Int,cells[2])
        n === nothing && continue
        haskey(expected,n) || continue
        haskey(found,n) && error("Duplicate numbered row $n")
        m = match(r"\[(\d+),(\d+)\]",cells[8])
        m === nothing && error("Missing projective group ID for No. $n")
        found[n] = (parse(Int,cells[3]),replace(cells[4],"`"=>""),
            parse(Int,cells[5]),parse(Int,cells[6]),parse(Int,cells[7]),
            (parse(Int,m.captures[1]),parse(Int,m.captures[2])))
    end
    found == expected || error("Numbered No. 28/104 metadata changed: $found")
    count = 0
    for (i,line) in enumerate(eachline(r104_edges))
        i == 1 && continue
        v = split(line,'\t')
        length(v) == 12 || error("Malformed strict-containment row $i")
        parse(Int,v[1]) == 104 && parse(Int,v[2]) == 28 || continue
        Tuple(parse.(Int,v[3:6])) == (2,1,72,1296) ||
            error("Wrong No. 104 -> 28 edge metadata")
        v[7:11] == ["embedded","direct","true","fail","found"] ||
            error("No. 104 -> 28 edge is not direct and strict")
        v[12] in ("literal_matrix_subgroup","A_strict") ||
            error("Unexpected strict containment method")
        count += 1
    end
    count == 1 || error("Expected one direct strict No. 104 -> 28 edge")
end

function r104_geometric_character()
    hist = Dict{Tuple{Int,Int},Int}()
    for (i,line) in enumerate(eachline(r104_character_file))
        if i == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric-character header")
            continue
        end
        isempty(strip(line)) && continue
        v = split(line,'\t')
        length(v) == 4 || error("Malformed character row $i")
        n,ord,tr,count = parse.(Int,v)
        n == 104 && 1 <= ord <= 24 && -22 <= tr <= 22 && count > 0 ||
            error("Unexpected character row $i")
        key = (ord,tr)
        haskey(hist,key) && error("Duplicate character bin")
        hist[key] = count
    end
    frozen = Dict((1,22)=>1,(2,-10)=>1,(2,-2)=>3,(2,6)=>3,
                  (3,-2)=>8,(6,2)=>8)
    hist == frozen || error("No. 104 geometric character changed: $hist")
    sum(values(hist)) == 24 || error("Incomplete No. 104 character")
    return hist
end

function r104_parent()
    isfile(no28_cache) || error("No. 28 full lattice cache is absent; prepare it separately")
    cache = no28_verify_cache()
    source = load(no28_source)
    parent = source.cases[10].results[1]
    @assert parent.order == 6 && parent.dimension == 1
    @assert parent.group_gap_id == (432,745)
    @assert cache.parent_number == 28 && cache.full_group_order == 432
    return parent,cache
end

function r104_preflight()
    parent,cache = r104_parent()
    r104_numbering_and_edge()
    expected = r104_geometric_character()
    hashes = r104_hashes()
    r104_note("PASS: verified No. 28 cache, numbered data, direct strict edge, No. 104 character")
    r104_note("PASS: kernel order 72, quotient order 6, full order 432")
    return parent,cache,expected,hashes
end

# If f^6=c and phi=conjugation by f, (n,k)(m,l) is
# (n phi^k(m) c^floor((k+l)/6), (k+l) mod 6). The order of the factors
# matters: c is not assumed central in N, and phi^6=conjugation by c.
function r104_context(cache)
    small = direct_context(cache.symplectic_generators_S,
        cache.extra_generator_S,72,6)
    phipowers = [collect(1:72)]
    for _ in 1:5
        push!(phipowers,[small.phi[phipowers[end][n]] for n in 1:72])
    end
    function mul(i::Int,j::Int)
        n,k = r104_normal(i); m,l = r104_normal(j)
        u = small.mul(n,phipowers[k+1][m])
        k+l >= 6 && (u = small.mul(u,small.c))
        return r104_idx(u,(k+l)%6)
    end
    inverse = Int[]
    for i in 1:432
        n,k = r104_normal(i)
        if k == 0
            push!(inverse,small.inverses[n])
        else
            m = small.mul(small.inverses[small.c],
                          phipowers[7-k][small.inverses[n]])
            push!(inverse,r104_idx(m,6-k))
        end
    end
    @assert all(mul(i,inverse[i]) == 1 && mul(inverse[i],i) == 1 for i in 1:432)
    @assert all(mul(i,j) == r104_idx(small.mul(i,j),0)
        for i in 1:72 for j in 1:72)
    @assert mul(73,1) == 73
    oneL = identity_matrix(QQ,22)
    nL = [foldl(*,(cache.symplectic_generators[j] for j in small.words[n]);
                 init=oneL) for n in 1:72]
    f = cache.extra_generator
    fpowers = [f^k for k in 0:5]
    E = basis_matrix(lattice(cache.S_in_Lambda0))*
        inv(basis_matrix(lattice(cache.Lambda0)))
    @assert all(small.elements[n]*E == E*nL[n] for n in 1:72)
    @assert cache.extra_generator_S*E == E*f
    @assert f^6 == nL[small.c]
    generators = unique([small.generator_ids;73])
    trace_cache = Dict{Int,Int}()
    order_cache = Dict{Int,Int}()
    return (;small,phipowers,mul,inverse,nL,fpowers,generators,
            trace_cache,order_cache)
end

r104_matrix(ctx,i::Int) = begin
    n,k = r104_normal(i)
    ctx.nL[n]*ctx.fpowers[k+1]
end

function r104_order(ctx,i::Int)
    return get!(ctx.order_cache,i) do
        x = 1
        for d in 1:432
            x = ctx.mul(x,i)
            x == 1 && return d
        end
        error("Element order exceeds the parent group order")
    end
end

function r104_v4_subgroups(ctx)
    found = Dict{NTuple{4,Int},NTuple{2,Int}}()
    involutions = [i for i in 2:72 if ctx.small.orders[i] == 2]
    for (j,a) in enumerate(involutions), b in involutions[j+1:end]
        ctx.small.mul(a,b) == ctx.small.mul(b,a) || continue
        c = ctx.small.mul(a,b)
        c != 1 && c != a && c != b && ctx.small.orders[c] == 2 || continue
        key = Tuple(sort([1,a,b,c]))
        get!(found,key,(key[2],key[3]))
    end
    return found
end

function r104_subgroup_key(ctx,A,n::Int,k::Int)
    x = r104_idx(n,k)
    powers = Int[]
    y = 1
    for _ in 1:6
        push!(powers,y)
        y = ctx.mul(y,x)
    end
    y in A || error("Outer lift has sixth power outside its V4 kernel")
    key = Tuple(sort([ctx.mul(a,p) for p in powers for a in A]))
    length(unique(key)) == 24 || error("Candidate subgroup does not have order 24")
    Tuple(i for i in key if i <= 72) == A ||
        error("Candidate intersection with the kernel changed")
    return key
end

function r104_raw(ctx,v4s)
    raw = Dict{NTuple{24,Int},NamedTuple}()
    counts_by_k = Dict(1=>0,5=>0)
    for (A,(a,b)) in v4s
        for k in (1,5), n in 1:72
            x = r104_idx(n,k)
            y = 1
            for _ in 1:6
                y = ctx.mul(y,x)
            end
            y in A || continue
            all(ctx.mul(ctx.mul(x,u),ctx.inverse[x]) in A for u in (a,b)) ||
                continue
            key = r104_subgroup_key(ctx,A,n,k)
            get!(raw,key,(A=A,a=a,b=b,n=n,k=k))
            counts_by_k[k] += 1
        end
    end
    isempty(raw) && error("No order-24 V4-by-C6 subgroup in No. 28")
    # Every quotient generator with exponent five has a power with exponent
    # one, so the k=1 pass must already recover the complete candidate set.
    k1 = Set{NTuple{24,Int}}()
    for (A,(a,b)) in v4s, n in 1:72
        x = r104_idx(n,1)
        y = 1
        for _ in 1:6
            y = ctx.mul(y,x)
        end
        y in A || continue
        all(ctx.mul(ctx.mul(x,u),ctx.inverse[x]) in A for u in (a,b)) ||
            continue
        push!(k1,r104_subgroup_key(ctx,A,n,1))
    end
    Set(keys(raw)) == k1 || error("The k=1 and k=5 subgroup enumerations disagree")
    return raw,counts_by_k
end

function r104_conjugate_key(ctx,item,g::Int)
    A,n,k = item.A,item.n,item.k
    if g == 73 # conjugation by f
        newA = Tuple(sort([ctx.small.phi[a] for a in A]))
        newn = ctx.small.phi[n]
    else
        gi = ctx.small.inverses[g]
        newA = Tuple(sort([ctx.small.mul(ctx.small.mul(g,a),gi) for a in A]))
        newn = ctx.small.mul(ctx.small.mul(g,n),ctx.phipowers[k+1][gi])
    end
    return r104_subgroup_key(ctx,newA,newn,k)
end

function r104_classes(ctx,raw)
    unseen = Set(keys(raw)); classes = NamedTuple[]
    while !isempty(unseen)
        first_key = first(sort!(collect(unseen)))
        orbit = Set([first_key]); todo = [first_key]; head = 1
        while head <= length(todo)
            key = todo[head]
            for g in ctx.generators
                next_key = r104_conjugate_key(ctx,raw[key],g)
                haskey(raw,next_key) || error("Raw candidates are not parent-conjugacy stable")
                if !(next_key in orbit)
                    push!(orbit,next_key); push!(todo,next_key)
                end
            end
            head += 1
        end
        setdiff!(unseen,orbit)
        push!(classes,(key=first_key,orbit_size=length(orbit)))
    end
    @assert sum(c.orbit_size for c in classes) == length(raw)
    return classes
end

function r104_group_id(ctx,key,gens)
    positions = Dict(x=>i for (i,x) in enumerate(key))
    perms = Any[]
    for g in gens
        image = [positions[ctx.mul(g,x)] for x in key]
        @assert sort(image) == collect(1:length(key))
        push!(perms,GAP.Globals.PermList(GapObj(image)))
    end
    G = GAP.Globals.Group(perms...)
    @assert Int(GAP.Globals.Size(G)) == 24
    id = GAP.Globals.IdGroup(G)
    return (Int(id[1]),Int(id[2]))
end

function r104_histogram(ctx,key)
    hist = Dict{Tuple{Int,Int},Int}()
    for i in key
        tr = get!(ctx.trace_cache,i) do
            M = r104_matrix(ctx,i)
            value = sum(M[j,j] for j in 1:22)
            denominator(value) == 1 || error("Nonintegral primitive H4 trace")
            Int(numerator(value))
        end
        bin = (r104_order(ctx,i),tr)
        hist[bin] = get(hist,bin,0)+1
    end
    @assert sum(values(hist)) == 24 && get(hist,(1,22),0) == 1
    return hist
end

function r104_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Group output must end in .mrdi")
    _,cache,expected,hashes = r104_preflight()
    ctx = r104_context(cache)
    v4s = r104_v4_subgroups(ctx)
    r104_note("Enumerated $(length(v4s)) distinct V4 subgroups of the order-72 kernel")
    raw,passes = r104_raw(ctx,v4s)
    r104_note("Found $(length(raw)) distinct V4-by-C6 subgroups; pass counts=$passes")
    classes = r104_classes(ctx,raw)
    r104_note("Full-parent conjugacy classes: $(length(classes))")
    summaries = NamedTuple[]; matches = NamedTuple[]
    for (class_number,c) in enumerate(classes)
        item = raw[c.key]
        gens = (item.a,item.b,r104_idx(item.n,item.k))
        id = r104_group_id(ctx,c.key,gens)
        hist = r104_histogram(ctx,c.key)
        matched = id == (24,13) && hist == expected
        push!(summaries,(class_number=class_number,key=c.key,
            orbit_size=c.orbit_size,group_id=id,character=hist,
            geometric_character_match=matched))
        matched || continue
        push!(matches,(class_number=class_number,key=c.key,
            orbit_size=c.orbit_size,group_id=id,character=hist,
            symplectic_generator_indices=(item.a,item.b),
            extra_generator_index=r104_idx(item.n,item.k),
            symplectic_generators=(r104_matrix(ctx,item.a),r104_matrix(ctx,item.b)),
            extra_generator=r104_matrix(ctx,r104_idx(item.n,item.k))))
        r104_note("No. 104 character match, class $class_number, orbit size $(c.orbit_size)")
    end
    save(output,(format_version=1,source_hashes=hashes,parent_number=28,
        child_number=104,parent_order=432,symplectic_kernel_order=72,
        quotient_order=6,complete_within_saved_parent=true,
        method="all kernel V4; all n*f^k with k=1,5; full 24-element deduplication; exact full-parent conjugacy",
        v4_subgroups=length(v4s),pass_counts=passes,
        raw_subgroups=length(raw),conjugacy_classes=length(classes),
        summaries=Tuple(summaries),matches=r104_saved(matches),
        match_count=length(matches),lattice_checks_done=false,
        global_integral_uniqueness_claimed=false))
    check = load(output)
    @assert check.source_hashes == hashes && check.match_count == length(matches)
    r104_note("Saved and reloaded $output; matching classes=$(length(matches))")
end

function r104_restriction(parent,c)
    L = lattice(parent.Lambda0)
    T = invariant_lattice(L,collect(c.symplectic_generators);
        ambient_representation=false)
    S = orthogonal_submodule(L,T)
    @assert rank(S) == 12 && rank(T) == 10
    @assert signature_tuple(S) == (12,0,0)
    @assert signature_tuple(T) == (8,0,2)
    Lf = integer_lattice_with_isometry(L,c.extra_generator;
        ambient_representation=false,check=true)
    @assert trivial_action_on_discriminant(Lf)
    Simg = lattice_in_same_ambient_space(Lf,basis_matrix(S);check=true)
    Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
    @assert basis_matrix(S)*gram_matrix(ambient_space(L))*
        transpose(basis_matrix(T)) == zero_matrix(QQ,12,10)
    Taction = full_rank_model(Timg)
    @assert Int(order_of_isometry(Taction)) == 6
    pk = embedded_PK_data(Lf,Timg,6)
    P,K = pk.P_lattice,pk.K_lattice
    @assert rank(P) == 6 && rank(K) == 16
    @assert signature_tuple(P) == (4,0,2)
    @assert signature_tuple(K) == (16,0,0)
    @assert period_dimension(P,6) == 2
    return (order=6,dimension=2,S_in_Lambda0=Simg,T_in_Lambda0=Timg,
        T_action=Taction,K_in_Lambda0=K,P_in_Lambda0=P,
        P_action=pk.P_with_isometry,Lambda0=Lf,
        extracted_subgroup_id=(24,13),group_id_source="verified subgroup of cached No. 28 full group",
        parent_number=28,child_number=104,
        symplectic_generators_in_parent=c.symplectic_generators,
        extra_generator_in_parent=c.extra_generator)
end

function r104_lattices(output,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Lattice output must end in .mrdi")
    groups = load(groups_path)
    groups.format_version == 1 && groups.parent_number == 28 &&
        groups.child_number == 104 && groups.complete_within_saved_parent ||
        error("Wrong or incomplete group-stage input")
    groups.source_hashes == r104_hashes() || error("A source changed after groups")
    @assert groups.match_count == length(groups.matches)
    @assert groups.conjugacy_classes == length(groups.summaries)
    @assert length(unique(c.class_number for c in groups.summaries)) ==
        length(groups.summaries)
    @assert Set(c.class_number for c in groups.matches) ==
        Set(c.class_number for c in groups.summaries if c.geometric_character_match)
    parent,_ = r104_parent()
    L = lattice(parent.Lambda0)
    summaries = NamedTuple[]; results = NamedTuple[]
    for c in groups.matches
        T = invariant_lattice(L,collect(c.symplectic_generators);
            ambient_representation=false)
        S = orthogonal_submodule(L,T)
        reason = ""; index = 0; dimension = -1; rank_P = 0; rank_K = 0
        if rank(S) != 12 || rank(T) != 10
            reason = "symplectic rank mismatch"
        elseif signature_tuple(S) != (12,0,0) || signature_tuple(T) != (8,0,2)
            reason = "symplectic signature mismatch"
        else
            Lf = integer_lattice_with_isometry(L,c.extra_generator;
                ambient_representation=false,check=true)
            @assert trivial_action_on_discriminant(Lf)
            Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
            index = Int(order_of_isometry(full_rank_model(Timg)))
            if index != 6
                reason = "quotient action order mismatch"
            else
                pk = embedded_PK_data(Lf,Timg,6)
                rank_P,rank_K = rank(pk.P_lattice),rank(pk.K_lattice)
                if rank_P != 6 || rank_K != 16
                    reason = "period/complement rank mismatch"
                elseif signature_tuple(pk.P_lattice) != (4,0,2) ||
                       signature_tuple(pk.K_lattice) != (16,0,0)
                    reason = "period/complement signature mismatch"
                else
                    dimension = period_dimension(pk.P_lattice,6)
                    dimension == 2 || (reason = "period dimension mismatch")
                end
            end
        end
        push!(summaries,(class_number=c.class_number,rank_S=rank(S),rank_T=rank(T),
            rank_P=rank_P,rank_K=rank_K,index=index,dimension=dimension,
            matched=isempty(reason),reason=reason))
        r104_note("Class $(c.class_number): rank S=$(rank(S)), rank P=$rank_P, dimension=$dimension, reason=$reason")
        isempty(reason) || continue
        push!(results,(class_number=c.class_number,result=r104_restriction(parent,c)))
    end
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=r104_hash(groups_path),parent_number=28,child_number=104,
        summaries=r104_saved(summaries),results=r104_saved(results),
        lattice_match_count=length(results),all_character_matches_processed=true,
        roots_verified=false,global_integral_uniqueness_claimed=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert check.lattice_match_count == length(results)
    r104_note("Saved and reloaded $output; lattice matches=$(length(results))")
end

function r104_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Verified output must end in .mrdi")
    groups,data = load(groups_path),load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.parent_number == data.parent_number == 28
    @assert groups.child_number == data.child_number == 104
    @assert groups.complete_within_saved_parent
    @assert groups.conjugacy_classes == length(groups.summaries)
    @assert groups.match_count == length(groups.matches)
    @assert data.all_character_matches_processed
    groups.source_hashes == data.source_hashes == r104_hashes() ||
        error("A source changed after the finite-group stage")
    data.groups_file_hash == r104_hash(groups_path) ||
        error("Group-stage input changed after the lattice stage")
    @assert length(unique(c.class_number for c in groups.summaries)) ==
        length(groups.summaries)
    @assert length(unique(c.class_number for c in groups.matches)) ==
        length(groups.matches)
    @assert Set(c.class_number for c in groups.matches) ==
        Set(c.class_number for c in groups.summaries if c.geometric_character_match)
    @assert length(unique(c.class_number for c in data.summaries)) ==
        length(data.summaries)
    @assert Set(c.class_number for c in data.summaries) ==
        Set(c.class_number for c in groups.matches)
    @assert length(unique(r.class_number for r in data.results)) ==
        length(data.results)
    @assert Set(r.class_number for r in data.results) ==
        Set(c.class_number for c in data.summaries if c.matched)
    @assert data.lattice_match_count == length(data.results)
    parent,cache,expected,_ = r104_preflight()
    ctx = r104_context(cache)
    verified = NamedTuple[]; obstructed = NamedTuple[]
    for r in data.results
        c = only(x for x in groups.matches if x.class_number == r.class_number)
        a,b = c.symplectic_generator_indices
        x = c.extra_generator_index
        @assert r104_subgroup_key(ctx,Tuple(sort([1,a,b,ctx.mul(a,b)])),
            r104_normal(x)...) == c.key
        @assert r104_group_id(ctx,c.key,(a,b,x)) == (24,13)
        @assert r104_histogram(ctx,c.key) == c.character == expected
        @assert r104_matrix(ctx,a) == c.symplectic_generators[1]
        @assert r104_matrix(ctx,b) == c.symplectic_generators[2]
        @assert r104_matrix(ctx,x) == c.extra_generator
        fresh = r104_restriction(parent,c)
        @assert basis_matrix(lattice(fresh.S_in_Lambda0)) ==
            basis_matrix(lattice(r.result.S_in_Lambda0))
        @assert basis_matrix(lattice(fresh.T_in_Lambda0)) ==
            basis_matrix(lattice(r.result.T_in_Lambda0))
        @assert basis_matrix(fresh.P_in_Lambda0) == basis_matrix(r.result.P_in_Lambda0)
        @assert basis_matrix(fresh.K_in_Lambda0) == basis_matrix(r.result.K_in_Lambda0)
        @assert isometry(fresh.Lambda0) == isometry(r.result.Lambda0)
        @assert isometry(fresh.T_action) == isometry(r.result.T_action)
        if has_root(fresh.K_in_Lambda0,lattice(parent.Lambda0))
            push!(obstructed,(class_number=c.class_number,group_id=c.group_id))
            r104_note("Class $(c.class_number): root obstruction")
        else
            push!(verified,(class_number=c.class_number,group_id=c.group_id,
                roots_verified=true,result=fresh))
            r104_note("Class $(c.class_number): subgroup, lattices and roots verified")
        end
    end
    @assert length(verified)+length(obstructed) == data.lattice_match_count
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=r104_hash(groups_path),
        lattices_file_hash=r104_hash(lattices_path),
        parent_number=28,child_number=104,
        verified_results=r104_saved(verified),root_obstructed=r104_saved(obstructed),
        root_free_count=length(verified),root_obstructed_count=length(obstructed),
        complete_within_saved_parent=true,all_character_matches_processed=true,
        roots_verified=true,global_integral_uniqueness_claimed=false))
    check = load(output)
    @assert check.root_free_count == length(verified)
    r104_note("Saved and reloaded $output; root-free classes=$(length(verified))")
end

function r104_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices, or verify")
    stage = ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no extra arguments")
        r104_preflight()
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        r104_groups(length(ARGS)==2 ? abspath(ARGS[2]) : r104_groups_file)
    elseif stage == "lattices"
        length(ARGS) <= 3 || error("lattices [output.mrdi] [groups.mrdi]")
        r104_lattices(length(ARGS)>=2 ? abspath(ARGS[2]) : r104_lattices_file,
            length(ARGS)==3 ? abspath(ARGS[3]) : r104_groups_file)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        r104_verify(length(ARGS)>=2 ? abspath(ARGS[2]) : r104_verified_file,
            length(ARGS)>=3 ? abspath(ARGS[3]) : r104_lattices_file,
            length(ARGS)==4 ? abspath(ARGS[4]) : r104_groups_file)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    r104_main()
end
