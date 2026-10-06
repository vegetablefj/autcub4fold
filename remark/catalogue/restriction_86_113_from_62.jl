# Exact staged restrictions of Nos. 86 and 113 from the verified No. 62
# full lattice group. A saved No. 62 cache is required; No. 60's rank-22
# generators are not reused. No stage runs merely by including this file.

using SHA
include(joinpath(@__DIR__, "prepare_no62_full_lattice_group.jl"))
include(joinpath(@__DIR__, "restriction_functions.jl"))

const r86113_children = (86,113)
const r86113_specs = Dict(
    86 => (rank_S=14,sym_order=6,index=3,dimension=3,rank_P=8,
           group_id=(18,3),linear_id=(54,12)),
    113 => (rank_S=12,sym_order=3,index=6,dimension=2,rank_P=6,
            group_id=(18,5),linear_id=(54,15)))
const r86113_table = joinpath(@__DIR__, "..", "input", "family_numbering.md")
const r86113_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_all_pairs.tsv")
const r86113_families = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const r86113_witnesses = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_positive_edges.g")
const r86113_character_script = joinpath(@__DIR__, "restriction_86_113_geometric_characters.g")
const r86113_character_file = joinpath(@__DIR__, "restriction_86_113_geometric_characters.tsv")
const r86113_audit_script = joinpath(@__DIR__, "restriction_86_113_embedding_audit.g")
const r86113_groups_file = joinpath(@__DIR__, "restriction_86_113_from_62.groups.mrdi")
const r86113_lattices_file = joinpath(@__DIR__, "restriction_86_113_from_62.lattices.mrdi")
const r86113_verified_file = joinpath(@__DIR__, "restriction_86_113_from_62.verified.mrdi")

r86113_note(s) = (println(s); flush(stdout))
r86113_hash(path) = bytes2hex(sha256(read(path)))
r86113_saved(items) = isempty(items) ? String[] : Tuple(items)

function r86113_hashes()
    paths = (no62_cache,no62_source,no60_cache,r86113_table,r86113_edges,
        r86113_families,r86113_witnesses,r86113_character_script,
        r86113_character_file,r86113_audit_script,@__FILE__,
        joinpath(@__DIR__, "prepare_no62_full_lattice_group.jl"),
        joinpath(@__DIR__, "prepare_no60_full_lattice_group.jl"),
        joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"),
        joinpath(@__DIR__, "restriction_functions.jl"),
        joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl"))
    all(isfile,paths) || error("A source, No. 62 cache, or GAP character TSV is missing")
    return Tuple((basename(p),r86113_hash(p)) for p in paths)
end

function r86113_numbering_and_edges()
    expected = Dict(62=>(16,"D_12",1,6,1,(72,30)),
        86=>(14,"S3",1,3,3,(18,3)),
        113=>(12,"C3",1,6,2,(18,5)))
    found = Dict{Int,Tuple}()
    for line in eachline(r86113_table)
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
    found == expected || error("Numbered No. 62/86/113 metadata changed: $found")
    counts = Dict(n=>0 for n in r86113_children)
    for (i,line) in enumerate(eachline(r86113_edges))
        i == 1 && continue
        v = split(line,'\t')
        length(v) == 12 || error("Malformed containment row $i")
        source,target = parse(Int,v[1]),parse(Int,v[2])
        target == 62 && haskey(counts,source) || continue
        Tuple(parse.(Int,v[3:6])) == (r86113_specs[source].dimension,1,54,216) ||
            error("Wrong No. $source -> 62 edge dimensions or linear orders")
        v[7:11] == ["embedded","direct","true","fail","found"] ||
            error("No. $source -> 62 is not direct and strict")
        v[12] in ("literal_matrix_subgroup","A_strict") ||
            error("Unexpected strict containment method")
        counts[source] += 1
    end
    all(x == 1 for x in values(counts)) ||
        error("Expected one direct strict edge per child: $counts")
end

function r86113_geometric_characters()
    observed = Dict(n=>Dict{Tuple{Int,Int},Int}() for n in r86113_children)
    for (i,line) in enumerate(eachline(r86113_character_file))
        if i == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric-character header")
            continue
        end
        isempty(strip(line)) && continue
        v = split(line,'\t')
        length(v) == 4 || error("Malformed geometric-character row $i")
        n,ord,tr,count = parse.(Int,v)
        haskey(observed,n) && 1 <= ord <= 18 && -22 <= tr <= 22 && count > 0 ||
            error("Unexpected geometric-character row $i")
        key = (ord,tr)
        haskey(observed[n],key) && error("Duplicate geometric-character bin")
        observed[n][key] = count
    end
    frozen = Dict(
        86=>Dict((1,22)=>1,(2,6)=>3,(3,-11)=>2,(3,-2)=>4,
                 (3,4)=>2,(6,-3)=>6),
        113=>Dict((1,22)=>1,(2,-10)=>1,(3,-11)=>2,(3,-2)=>4,
                  (3,4)=>2,(6,-4)=>2,(6,2)=>4,(6,5)=>2))
    for n in r86113_children
        sum(values(observed[n])) == 18 && get(observed[n],(1,22),0) == 1 ||
            error("Incomplete No. $n character")
        observed_bins = sort!([(key[1],key[2],count) for
            (key,count) in observed[n]])
        frozen_bins = sort!([(key[1],key[2],count) for
            (key,count) in frozen[n]])
        observed_bins == frozen_bins || error(
            "No. $n geometric character changed: observed=$observed_bins; expected=$frozen_bins")
    end
    return observed
end

function r86113_parent()
    cache = no62_verify_cache()
    source = load(no62_source)
    parent = source.cases[24].results[4]
    @assert parent.group_gap_id == (72,30)
    @assert parent.order == 6 && parent.dimension == 1
    @assert cache.parent_number == 62 && cache.symplectic_order == 12
    @assert cache.quotient_order == 6 && cache.full_group_order == 72
    @assert rank(lattice(parent.Lambda0)) == 22
    @assert rank(lattice(parent.S_in_Lambda0)) == 16
    @assert rank(lattice(parent.T_in_Lambda0)) == 6
    @assert isometry(cache.Lambda0) == isometry(parent.Lambda0)
    return parent,cache
end

function r86113_preflight()
    hashes = r86113_hashes()
    r86113_numbering_and_edges()
    characters = r86113_geometric_characters()
    parent,cache = r86113_parent()
    r86113_note("PASS: No. 62/86/113 numbering, two direct strict edges and complete eighteen-element characters")
    r86113_note("PASS: independently prepared No. 62 full order 72, kernel 12, quotient 6")
    r86113_note("Source SHA-256 hashes: $hashes")
    return parent,cache,characters,hashes
end

# Elements are n*f^k, with 1 <= n <= 12 and 0 <= k < 6. Multiplication is
# computed from the checked extension relations, not by a matrix-group
# subgroup search. All 72 corresponding rank-22 matrices are checked.
function r86113_context(cache)
    small = direct_context(cache.symplectic_generators_S,
        cache.extra_generator_S,12,6)
    oneL = identity_matrix(QQ,22)
    nL = [foldl(*,(cache.symplectic_generators[j] for j in small.words[n]);
        init=oneL) for n in 1:12]
    f = cache.extra_generator
    elements = [nL[n]*f^k for k in 0:5 for n in 1:12]
    length(Set(direct_matrix_key(x) for x in elements)) == 72 ||
        error("No. 62 rank-22 representation is not faithful of order 72")
    E = basis_matrix(lattice(cache.S_in_Lambda0))*
        inv(basis_matrix(lattice(cache.Lambda0)))
    C = basis_matrix(lattice(cache.T_in_Lambda0))*
        inv(basis_matrix(lattice(cache.Lambda0)))
    @assert all(small.elements[n]*E == E*nL[n] for n in 1:12)
    @assert all(C*nL[n] == C for n in 1:12)
    @assert cache.extra_generator_S*E == E*f
    @assert f^6 == nL[small.c]
    @assert all(nL[a]*nL[b] == nL[small.mul(a,b)]
        for a in 1:12 for b in 1:12)
    @assert all(f*nL[n]*inv(f) == nL[small.phi[n]] for n in 1:12)
    phipowers = [collect(1:12)]
    for _ in 1:5
        push!(phipowers,[small.phi[x] for x in phipowers[end]])
    end
    mul = zeros(Int,72,72)
    for i in 1:72, j in 1:72
        k,n = divrem(i-1,12); l,m = divrem(j-1,12)
        a = small.mul(n+1,phipowers[k+1][m+1])
        e = k+l
        if e >= 6
            a = small.mul(a,small.c)
            e -= 6
        end
        mul[i,j] = 12*e+a
    end
    @assert all(mul[1,i] == i && mul[i,1] == i for i in 1:72)
    @assert all(mul[mul[i,j],k] == mul[i,mul[j,k]]
        for i in 1:72 for j in 1:72 for k in 1:72)
    inverse = [only(j for j in 1:72 if mul[i,j] == 1 && mul[j,i] == 1)
        for i in 1:72]
    orders = Int[]
    for i in 1:72
        x = 1; ord = 0
        while true
            x = mul[x,i]; ord += 1
            x == 1 && break
            ord <= 72 || error("Element order exceeds parent order")
        end
        push!(orders,ord)
    end
    generators = unique([small.generator_ids;13])
    ctx = (;small,elements,mul,inverse,orders,generators,nL)
    r86113_group_id(ctx,Tuple(1:72),generators) == (72,30) ||
        error("Saved rank-22 parent group has the wrong abstract ID")
    return ctx
end

function r86113_subgroup(ctx,gens)
    seen = Set([1]); todo = [1]; head = 1
    symmetric = [gens;[ctx.inverse[g] for g in gens]]
    while head <= length(todo)
        x = todo[head]
        for g in symmetric
            y = ctx.mul[x,g]
            if !(y in seen)
                push!(seen,y); push!(todo,y)
            end
        end
        head += 1
    end
    return Tuple(sort!(collect(seen)))
end

function r86113_group_id(ctx,key,gens)
    positions = Dict(x=>i for (i,x) in enumerate(key))
    perms = Any[]
    for g in gens
        image = [positions[ctx.mul[g,x]] for x in key]
        @assert sort(image) == collect(1:length(key))
        push!(perms,GAP.Globals.PermList(GapObj(image)))
    end
    G = GAP.Globals.Group(perms...)
    @assert Int(GAP.Globals.Size(G)) == length(key)
    id = GAP.Globals.IdGroup(G)
    return (Int(id[1]),Int(id[2]))
end

function r86113_histogram(ctx,key)
    h = Dict{Tuple{Int,Int},Int}()
    for i in key
        tr = sum(ctx.elements[i][j,j] for j in 1:22)
        denominator(tr) == 1 || error("Nonintegral primitive H4 trace")
        bin = (ctx.orders[i],Int(numerator(tr)))
        h[bin] = get(h,bin,0)+1
    end
    @assert sum(values(h)) == length(key) && get(h,(1,22),0) == 1
    return h
end

# All eligible subgroups are generated in the correct coset of N.  A No. 86
# subgroup maps onto the unique C3 in H/N=C6, so its outer generator lies
# in N*f^2. A No. 113 subgroup maps onto all of C6, so it has one in N*f.
function r86113_raw(ctx,number)
    raw = Dict{Any,Tuple{Vararg{Int}}}()
    if number == 86
        s3 = direct_s3_subgroups(ctx.small)
        for (A,(r,s)) in s3, b in 25:36
            key = r86113_subgroup(ctx,[r,s,b])
            length(key) == 18 || continue
            Tuple(i for i in key if i <= 12) == A || continue
            get!(raw,key,(r,s,b))
        end
    elseif number == 113
        c3 = Dict{Any,Int}()
        for t in 2:12
            ctx.orders[t] == 3 || continue
            A = r86113_subgroup(ctx,[t])
            @assert length(A) == 3 && all(i <= 12 for i in A)
            get!(c3,A,t)
        end
        for (A,t) in c3, b in 13:24
            key = r86113_subgroup(ctx,[t,b])
            length(key) == 18 || continue
            Tuple(i for i in key if i <= 12) == A || continue
            get!(raw,key,(t,b))
        end
    else
        error("Only Nos. 86 and 113 are supported")
    end
    isempty(raw) && error("No eligible order-18 subgroup for No. $number")
    return raw
end

function r86113_classes(ctx,raw)
    unseen = Set(keys(raw)); classes = NamedTuple[]
    while !isempty(unseen)
        first_key = first(sort!(collect(unseen)))
        orbit = Set([first_key]); todo = [first_key]; head = 1
        while head <= length(todo)
            key = todo[head]
            for g in ctx.generators
                next_key = Tuple(sort!([ctx.mul[ctx.mul[g,x],ctx.inverse[g]]
                    for x in key]))
                haskey(raw,next_key) || error("Eligible set is not parent-conjugacy stable")
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

function r86113_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Group output must end in .mrdi")
    _,cache,expected,hashes = r86113_preflight()
    ctx = r86113_context(cache)
    candidates = NamedTuple[]; counts = NamedTuple[]
    for number in r86113_children
        raw = r86113_raw(ctx,number)
        classes = r86113_classes(ctx,raw)
        for (class_number,c) in enumerate(classes)
            gens = raw[c.key]
            A = Tuple(i for i in c.key if i <= 12)
            @assert r86113_subgroup(ctx,collect(gens)) == c.key
            @assert length(A) == r86113_specs[number].sym_order
            id = r86113_group_id(ctx,c.key,collect(gens))
            hist = r86113_histogram(ctx,c.key)
            matched = id == r86113_specs[number].group_id && hist == expected[number]
            push!(candidates,(child_number=number,class_number=class_number,
                parent_conjugacy_orbit_size=c.orbit_size,
                subgroup_indices=c.key,symplectic_subgroup_indices=A,
                subgroup_id=id,generator_indices=gens,
                symplectic_generators=Tuple(ctx.elements[i] for i in gens[1:end-1]),
                extra_generator=ctx.elements[gens[end]],
                primitive_character_histogram=hist,
                geometric_character_match=matched))
            r86113_note("No. $number class $class_number: ID=$id, orbit=$(c.orbit_size), match=$matched")
        end
        push!(counts,(child_number=number,raw_subgroups=length(raw),
            parent_conjugacy_classes=length(classes),
            character_matching_classes=count(c->c.child_number==number &&
                c.geometric_character_match,candidates)))
    end
    save(output,(format_version=1,source_hashes=hashes,
        method="all S3/C3 kernel subgroups and the requisite quotient coset; exact closure and full-parent conjugacy",
        parent_number=62,target_numbers=r86113_children,parent_group_order=72,
        complete_within_saved_parent=true,counts=Tuple(counts),
        candidates=Tuple(candidates),lattice_and_root_checks_done=false,
        global_uniqueness_claimed=false))
    check = load(output)
    @assert check.source_hashes == hashes && length(check.candidates) == length(candidates)
    r86113_note("Saved and reloaded $output; counts=$counts")
end

function r86113_restriction(parent,c)
    number = c.child_number; spec = r86113_specs[number]
    L = lattice(parent.Lambda0)
    T = invariant_lattice(L,collect(c.symplectic_generators);
        ambient_representation=false)
    S = orthogonal_submodule(L,T)
    @assert rank(S) == spec.rank_S && rank(T) == 22-spec.rank_S
    @assert signature_tuple(S) == (spec.rank_S,0,0)
    @assert signature_tuple(T) == (rank(T)-2,0,2)
    Lf = integer_lattice_with_isometry(L,c.extra_generator;
        ambient_representation=false,check=true)
    @assert trivial_action_on_discriminant(Lf)
    Simg = lattice_in_same_ambient_space(Lf,basis_matrix(S);check=true)
    Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
    @assert basis_matrix(S)*gram_matrix(ambient_space(L))*
        transpose(basis_matrix(T)) == zero_matrix(QQ,rank(S),rank(T))
    Taction = full_rank_model(Timg)
    @assert Int(order_of_isometry(Taction)) == spec.index
    pk = embedded_PK_data(Lf,Timg,spec.index)
    P,K = pk.P_lattice,pk.K_lattice
    @assert rank(P) == spec.rank_P && rank(K) == 22-spec.rank_P
    @assert signature_tuple(P) == (rank(P)-2,0,2)
    @assert signature_tuple(K) == (rank(K),0,0)
    @assert period_dimension(P,spec.index) == spec.dimension
    return (order=spec.index,dimension=spec.dimension,
        S_in_Lambda0=Simg,T_in_Lambda0=Timg,T_action=Taction,
        K_in_Lambda0=K,P_in_Lambda0=P,P_action=pk.P_with_isometry,
        Lambda0=Lf,group_gap_id=nothing,
        symplectic_kernel_order_S=nothing,symplectic_kernel_order_K=nothing,
        symplectic_saturation_verified=false,extracted_subgroup_id=spec.group_id,
        group_id_source="verified subgroup of cached No. 62 full group",
        parent_number=62,child_number=number,
        symplectic_generators_in_parent=c.symplectic_generators,
        extra_generator_in_parent=c.extra_generator)
end

function r86113_lattices(output,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Lattice output must end in .mrdi")
    groups = load(groups_path)
    @assert groups.format_version == 1 && groups.parent_number == 62
    @assert groups.target_numbers == r86113_children && groups.complete_within_saved_parent
    @assert groups.source_hashes == r86113_hashes()
    parent,_ = r86113_parent(); L = lattice(parent.Lambda0)
    summaries = NamedTuple[]; results = NamedTuple[]
    for c in groups.candidates
        c.geometric_character_match || continue
        spec = r86113_specs[c.child_number]
        T = invariant_lattice(L,collect(c.symplectic_generators);
            ambient_representation=false)
        S = orthogonal_submodule(L,T)
        reason = ""; index = 0; dimension = -1; rank_P = 0; rank_K = 0
        if rank(S) != spec.rank_S || rank(T) != 22-spec.rank_S
            reason = "symplectic rank mismatch"
        elseif signature_tuple(S) != (spec.rank_S,0,0) ||
               signature_tuple(T) != (rank(T)-2,0,2)
            reason = "symplectic signature mismatch"
        else
            Lf = integer_lattice_with_isometry(L,c.extra_generator;
                ambient_representation=false,check=true)
            @assert trivial_action_on_discriminant(Lf)
            Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
            index = Int(order_of_isometry(full_rank_model(Timg)))
            if index != spec.index
                reason = "quotient action order mismatch"
            else
                pk = embedded_PK_data(Lf,Timg,index)
                rank_P,rank_K = rank(pk.P_lattice),rank(pk.K_lattice)
                if rank_P != spec.rank_P || rank_K != 22-spec.rank_P
                    reason = "period/complement rank mismatch"
                elseif signature_tuple(pk.P_lattice) != (rank_P-2,0,2) ||
                       signature_tuple(pk.K_lattice) != (rank_K,0,0)
                    reason = "period/complement signature mismatch"
                else
                    dimension = period_dimension(pk.P_lattice,index)
                    dimension == spec.dimension || (reason = "period dimension mismatch")
                end
            end
        end
        push!(summaries,(child_number=c.child_number,class_number=c.class_number,
            rank_S=rank(S),rank_T=rank(T),rank_P=rank_P,rank_K=rank_K,
            index=index,dimension=dimension,matched=isempty(reason),reason=reason))
        r86113_note("No. $(c.child_number) class $(c.class_number): S=$(rank(S)), P=$rank_P, dimension=$dimension, reason=$reason")
        isempty(reason) || continue
        push!(results,(child_number=c.child_number,class_number=c.class_number,
            result=r86113_restriction(parent,c)))
    end
    counts = Tuple((child_number=n,
        lattice_matches=count(r->r.child_number==n,results))
        for n in r86113_children)
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=r86113_hash(groups_path),target_numbers=r86113_children,
        summaries=r86113_saved(summaries),results=r86113_saved(results),
        counts=counts,all_character_matches_processed=true,
        roots_verified=false,symplectic_saturation_verified=false,
        global_uniqueness_claimed=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert length(check.results) == length(results)
    r86113_note("Saved and reloaded $output; lattice matches=$counts")
end

function r86113_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Verified output must end in .mrdi")
    groups,data = load(groups_path),load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.source_hashes == data.source_hashes == r86113_hashes()
    @assert data.groups_file_hash == r86113_hash(groups_path)
    parent,cache,expected,_ = r86113_preflight()
    ctx = r86113_context(cache)
    verified = NamedTuple[]; obstructed = NamedTuple[]
    for r in data.results
        c = only(x for x in groups.candidates if x.child_number==r.child_number &&
            x.class_number==r.class_number)
        spec = r86113_specs[c.child_number]
        @assert c.subgroup_id == spec.group_id && c.geometric_character_match
        @assert r86113_subgroup(ctx,collect(c.generator_indices)) == c.subgroup_indices
        @assert Tuple(i for i in c.subgroup_indices if i<=12) ==
            c.symplectic_subgroup_indices
        @assert r86113_group_id(ctx,c.subgroup_indices,
            collect(c.generator_indices)) == spec.group_id
        @assert r86113_histogram(ctx,c.subgroup_indices) ==
            c.primitive_character_histogram == expected[c.child_number]
        @assert all(ctx.elements[c.generator_indices[i]] ==
            c.symplectic_generators[i] for i in eachindex(c.symplectic_generators))
        @assert ctx.elements[c.generator_indices[end]] == c.extra_generator
        fresh = r86113_restriction(parent,c)
        @assert basis_matrix(lattice(fresh.S_in_Lambda0)) ==
            basis_matrix(lattice(r.result.S_in_Lambda0))
        @assert basis_matrix(lattice(fresh.T_in_Lambda0)) ==
            basis_matrix(lattice(r.result.T_in_Lambda0))
        @assert basis_matrix(fresh.P_in_Lambda0) == basis_matrix(r.result.P_in_Lambda0)
        @assert basis_matrix(fresh.K_in_Lambda0) == basis_matrix(r.result.K_in_Lambda0)
        @assert isometry(fresh.T_action) == isometry(r.result.T_action)
        if has_root(fresh.K_in_Lambda0,lattice(parent.Lambda0))
            push!(obstructed,(child_number=c.child_number,class_number=c.class_number))
            r86113_note("No. $(c.child_number) class $(c.class_number): root obstruction")
        else
            push!(verified,(child_number=c.child_number,class_number=c.class_number,
                roots_verified=true,result=fresh))
            r86113_note("No. $(c.child_number) class $(c.class_number): subgroup, lattice and roots verified")
        end
    end
    @assert length(verified)+length(obstructed) == length(data.results)
    counts = Tuple((child_number=n,
        root_free=count(r->r.child_number==n,verified),
        root_obstructed=count(r->r.child_number==n,obstructed))
        for n in r86113_children)
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=r86113_hash(groups_path),
        lattices_file_hash=r86113_hash(lattices_path),
        target_numbers=r86113_children,counts=counts,
        verified_results=r86113_saved(verified),
        root_obstructed=r86113_saved(obstructed),roots_verified=true,
        complete_within_saved_parent=true,
        all_character_matches_processed=data.all_character_matches_processed,
        symplectic_saturation_verified=false,global_uniqueness_claimed=false))
    check = load(output)
    @assert check.source_hashes == data.source_hashes
    @assert length(check.verified_results) == length(verified)
    r86113_note("Saved and reloaded $output; root outcomes=$counts")
end

function r86113_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices, or verify")
    stage = ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no extra arguments")
        r86113_preflight()
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        r86113_groups(length(ARGS)==2 ? abspath(ARGS[2]) : r86113_groups_file)
    elseif stage == "lattices"
        length(ARGS) <= 3 || error("lattices [output.mrdi] [groups.mrdi]")
        r86113_lattices(length(ARGS)>=2 ? abspath(ARGS[2]) : r86113_lattices_file,
            length(ARGS)==3 ? abspath(ARGS[3]) : r86113_groups_file)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        r86113_verify(length(ARGS)>=2 ? abspath(ARGS[2]) : r86113_verified_file,
            length(ARGS)>=3 ? abspath(ARGS[3]) : r86113_lattices_file,
            length(ARGS)==4 ? abspath(ARGS[4]) : r86113_groups_file)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    r86113_main()
end
