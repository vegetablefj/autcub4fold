# Staged restrictions No. 102/103 inside the saved No. 69 A4 action.
# No stage runs by default. `prepare` reconstructs the rank-22 full group;
# the later stages enumerate finite subgroups, then check lattices and roots.
# The companion GAP script must be run before preflight/groups.

using SHA
include(joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))
include(joinpath(@__DIR__, "restriction_functions.jl"))

const r69_specs = ((child=102,id=(12,3),quotient=3,coset_step=2,
                    dimension=3,rank_P=8),
                   (child=103,id=(24,10),quotient=6,coset_step=1,
                    dimension=3,rank_P=8))
const r69_source = joinpath(@__DIR__, "..", "..", "oscar", "oscar_script_data.mrdi")
const r69_source_sha256 = "c5278c3aeb5b2f7ed3574030d75d48680bba276302e035603531fa701bcf976b"
const r69_table = joinpath(@__DIR__, "..", "input", "family_numbering.md")
const r69_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_all_pairs.tsv")
const r69_gap_families = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const r69_gap_families_sha256 = "ffc8c914ab1250d5d60f9697dbe5c37844bfaddc480a547f5eb2a8cdd5535c1c"
const r69_gap_witnesses = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_positive_edges.g")
const r69_gap_witnesses_sha256 = "cf3339b80609385d40ebaf9d801bbe38bb251731873240e654293d29e12a5234"
const r69_gap_script = joinpath(@__DIR__, "restriction_102_103_geometric_characters.g")
const r69_characters = joinpath(@__DIR__, "restriction_102_103_geometric_characters.tsv")
const r69_cache = joinpath(@__DIR__, "source_69_full_lattice_group_restriction_102_103.mrdi")
const r69_groups_file = joinpath(@__DIR__, "restriction_102_103_from_69.groups.mrdi")
const r69_lattices_file = joinpath(@__DIR__, "restriction_102_103_from_69.lattices.mrdi")
const r69_verified_file = joinpath(@__DIR__, "restriction_102_103_from_69.verified.mrdi")

r69_note(s) = (println(s); flush(stdout))
r69_hash(path) = bytes2hex(sha256(read(path)))
r69_spec(n) = only(s for s in r69_specs if s.child == n)
r69_saved_collection(items) = isempty(items) ? String[] : Tuple(items)

function r69_prepare_hashes()
    paths = (r69_source,r69_table,r69_edges,r69_gap_families,
        r69_gap_witnesses,r69_gap_script,@__FILE__,
        joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"),
        joinpath(@__DIR__, "restriction_functions.jl"),
        joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl"))
    all(isfile,paths) || error("A frozen preparation input is missing")
    hashes = Tuple((basename(path),r69_hash(path)) for path in paths)
    hashes[1][2] == r69_source_sha256 || error("Frozen OSCAR source changed")
    hashes[4][2] == r69_gap_families_sha256 || error("Frozen GAP family list changed")
    hashes[5][2] == r69_gap_witnesses_sha256 || error("GAP strict witnesses changed")
    return hashes
end

function r69_run_hashes()
    h = r69_prepare_hashes()
    isfile(r69_cache) || error("Run prepare first: $r69_cache")
    isfile(r69_characters) || error("Run the companion GAP character script first")
    return (h..., (basename(r69_cache),r69_hash(r69_cache)),
        (basename(r69_characters),r69_hash(r69_characters)))
end

function r69_table_check()
    expected = Dict(69=>(16,"A_4",2,6,2,(72,42)),
        102=>(12,"C2^2",1,3,3,(12,3)),
        103=>(12,"C2^2",1,6,3,(24,10)))
    found = Dict{Int,Tuple}()
    for line in eachline(r69_table)
        startswith(line,'|') || continue
        cells = strip.(split(line,'|'))
        length(cells) >= 9 || continue
        n = tryparse(Int,cells[2])
        n === nothing && continue
        haskey(expected,n) || continue
        haskey(found,n) && error("Duplicate numbered row $n")
        m = match(r"\[(\d+),(\d+)\]",cells[8])
        m === nothing && error("Missing group ID for No. $n")
        found[n] = (parse(Int,cells[3]),replace(cells[4],"`"=>""),
            parse(Int,cells[5]),parse(Int,cells[6]),parse(Int,cells[7]),
            (parse(Int,m.captures[1]),parse(Int,m.captures[2])))
    end
    found == expected || error("Numbered rank/group/index/dimension rows changed: $found")
end

function r69_containment_check()
    found = Dict(s.child=>0 for s in r69_specs)
    for (line_number,line) in enumerate(eachline(r69_edges))
        line_number == 1 && continue
        v = split(line,'\t')
        length(v) == 12 || error("Malformed strict-containment row $line_number")
        source,target = parse(Int,v[1]),parse(Int,v[2])
        target == 69 && haskey(found,source) || continue
        spec = r69_spec(source)
        Tuple(parse.(Int,v[3:6])) ==
            (spec.dimension,2,3*spec.id[1],216) ||
            error("Wrong direct-containment dimensions or GL orders")
        v[7:10] == ["embedded","direct","true","fail"] ||
            error("No. $source -> 69 is not a direct strict containment")
        v[12] in ("literal_matrix_subgroup","A_strict") ||
            error("Unexpected strict containment method")
        found[source] += 1
    end
    all(x == 1 for x in values(found)) ||
        error("Expected exactly one direct strict edge per target: $found")
end

function r69_geometric_characters()
    expected = Dict(s.child=>Dict{Tuple{Int,Int},Int}() for s in r69_specs)
    for (i,line) in enumerate(eachline(r69_characters))
        if i == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric-character header")
            continue
        end
        isempty(strip(line)) && continue
        v = split(line,'\t')
        length(v) == 4 || error("Malformed geometric-character row $i")
        n,ord,tr,count = parse.(Int,v)
        haskey(expected,n) && count > 0 && 1 <= ord <= 24 ||
            error("Unexpected geometric-character row $i")
        key = (ord,tr)
        haskey(expected[n],key) && error("Duplicate geometric-character bin")
        expected[n][key] = count
    end
    for spec in r69_specs
        sum(values(expected[spec.child])) == spec.id[1] ||
            error("Incomplete No. $(spec.child) character")
        get(expected[spec.child],(1,22),0) == 1 || error("Bad identity trace")
    end
    return expected
end

function r69_parent_source()
    source = load(r69_source)
    @assert source.format_version == 3 && source.completed_cases == 29
    case = source.cases[27]
    @assert case.case_index == 27 && length(case.results) == 1
    parent = only(case.results)
    @assert parent.group_gap_id == (72,42)
    @assert parent.order == 6 && parent.dimension == 2
    L,S,T = lattice(parent.Lambda0),lattice(parent.S_in_Lambda0),
        lattice(parent.T_in_Lambda0)
    @assert rank(L) == 22 && rank(S) == 16 && rank(T) == 6
    @assert signature_tuple(L) == (20,0,2) && abs(det(gram_matrix(L))) == 3
    @assert order_of_isometry(parent.T_action) == 6
    return (;parent,L,S,T)
end

function r69_source_check()
    hashes = r69_prepare_hashes()
    r69_table_check(); r69_containment_check()
    p = r69_parent_source()
    r69_note("No. 69 source, No. 102/103 numbered rows and direct strict edges passed")
    r69_note("Source hashes: $hashes")
    return p,hashes
end

function r69_prepare(output)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Cache path must end in .mrdi")
    p,hashes = r69_source_check()
    embedding = basis_matrix(p.S)*inv(basis_matrix(p.L))
    tcoordinates = basis_matrix(p.T)*inv(basis_matrix(p.L))
    fL,fS = isometry(p.parent.Lambda0),isometry(p.parent.S_in_Lambda0)
    @assert fS*embedding == embedding*fL
    r69_note("Computing O(S) and its discriminant kernel for No. 69")
    O = matrix_group(automorphism_group_generators(p.S;
        ambient_representation=false))
    rho = discriminant_representation(p.S,O;
        ambient_representation=false,full=false,check=true)
    N,inclusion = kernel(rho)
    @assert Int(order(N)) == 12
    generators_S = typeof(fS)[]; generators_L = typeof(fL)[]
    for u in gens(N)
        uS = matrix(inclusion(u))
        Su = integer_lattice_with_isometry(p.S,uS;
            ambient_representation=false,check=true)
        Lu = integer_lattice_with_isometry(p.L,ambient_isometry(Su);
            ambient_representation=true,check=true)
        uL = isometry(Lu)
        @assert uS*embedding == embedding*uL
        @assert tcoordinates*uL == tcoordinates
        push!(generators_S,uS); push!(generators_L,uL)
    end
    isempty(generators_S) && error("Empty No. 69 kernel generator set")
    save(output,(format_version=1,parent_number=69,
        source="oscar/oscar_script_data.mrdi case 27 result 1",
        source_sha256=r69_source_sha256,prepare_hashes=hashes,
        Lambda0=p.parent.Lambda0,S_in_Lambda0=p.parent.S_in_Lambda0,
        symplectic_generators=generators_L,
        symplectic_generators_S=generators_S,
        extra_generator=fL,extra_generator_S=fS,
        symplectic_order=12,quotient_order=6,full_group_id=(72,42),
        order_proof="discriminant-kernel order 12, quotient order 6; finite stage verifies all lifts"))
    check = load(output)
    @assert check.prepare_hashes == hashes && check.symplectic_order == 12
    @assert length(check.symplectic_generators) == length(generators_L)
    r69_note("Saved and reloaded $output")
end

function r69_parent()
    p = r69_parent_source()
    cache = load(r69_cache)
    @assert cache.format_version == 1 && cache.parent_number == 69
    @assert cache.prepare_hashes == r69_prepare_hashes()
    @assert cache.source_sha256 == r69_source_sha256
    @assert cache.symplectic_order == 12 && cache.quotient_order == 6
    @assert cache.full_group_id == (72,42)
    @assert basis_matrix(lattice(cache.Lambda0)) == basis_matrix(p.L)
    @assert gram_matrix(lattice(cache.Lambda0)) == gram_matrix(p.L)
    @assert basis_matrix(lattice(cache.S_in_Lambda0)) == basis_matrix(p.S)
    @assert cache.extra_generator == isometry(p.parent.Lambda0)
    @assert cache.extra_generator_S == isometry(p.parent.S_in_Lambda0)
    @assert length(cache.symplectic_generators) ==
        length(cache.symplectic_generators_S) > 0
    embedding = basis_matrix(p.S)*inv(basis_matrix(p.L))
    tcoordinates = basis_matrix(p.T)*inv(basis_matrix(p.L))
    for (uS,uL) in zip(cache.symplectic_generators_S,
                         cache.symplectic_generators)
        @assert uS*embedding == embedding*uL
        @assert tcoordinates*uL == tcoordinates
    end
    return (;p...,cache,embedding,tcoordinates)
end

function r69_preflight()
    hashes = r69_run_hashes()
    r69_table_check(); r69_containment_check()
    expected = r69_geometric_characters()
    p = r69_parent()
    r69_note("No. 69 cache, both direct strict edges and both characters passed")
    r69_note("Source hashes: $hashes")
    return p,expected,hashes
end

# Formal element (n,k) = n*f^k, 1 <= n <= 12, 0 <= k < 6.
# The S-action alone may hide a quotient element; 22-dimensional lifts and
# formal coset coordinates are both checked, so no quotient is collapsed.
function r69_context(p)
    nctx = direct_context(p.cache.symplectic_generators_S,
        p.cache.extra_generator_S,12,6)
    idx(n,k) = 12*k+n
    e = identity_matrix(QQ,22)
    nL = [foldl(*,(p.cache.symplectic_generators[j] for j in nctx.words[n]);
        init=e) for n in 1:12]
    @assert length(Set(direct_matrix_key(x) for x in nL)) == 12
    @assert all(nctx.elements[n]*p.embedding == p.embedding*nL[n] for n in 1:12)
    @assert all(p.tcoordinates*nL[n] == p.tcoordinates for n in 1:12)
    f = p.cache.extra_generator
    @assert f^6 == nL[nctx.c]
    @assert all(f*nL[n]*inv(f) == nL[nctx.phi[n]] for n in 1:12)
    elements = [nL[n]*f^k for k in 0:5 for n in 1:12]
    @assert length(Set(direct_matrix_key(x) for x in elements)) == 72
    phi = [collect(1:12)]
    for _ in 1:5
        push!(phi,[nctx.phi[phi[end][n]] for n in 1:12])
    end
    mul = zeros(Int,72,72)
    for i in 1:72, j in 1:72
        n,k = mod1(i,12),div(i-1,12)
        m,l = mod1(j,12),div(j-1,12)
        a = nctx.mul(n,phi[k+1][m])
        k+l >= 6 && (a = nctx.mul(a,nctx.c))
        mul[i,j] = idx(a,mod(k+l,6))
    end
    @assert all(mul[1,i] == i && mul[i,1] == i for i in 1:72)
    inverse = [only(j for j in 1:72 if mul[i,j] == 1 && mul[j,i] == 1)
        for i in 1:72]
    orders = Int[]
    for i in 1:72
        x = 1; ord = 0
        while true
            x = mul[x,i]; ord += 1
            x == 1 && break
            ord <= 72 || error("Invalid finite multiplication table")
        end
        push!(orders,ord)
    end
    generators = [nctx.generator_ids;idx(1,1)]
    @assert all(elements[mul[i,g]] == elements[i]*elements[g]
        for i in 1:72 for g in generators)
    ctx = (;p,nctx,elements,mul,inverse,orders,generators,idx)
    @assert r69_group_id(ctx,Tuple(1:12),nctx.generator_ids) == (12,3)
    @assert r69_group_id(ctx,Tuple(1:72),generators) == (72,42)
    return ctx
end

function r69_subgroup(ctx,gens)
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

function r69_group_id(ctx,key,gens)
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

function r69_histogram(ctx,key)
    hist = Dict{Tuple{Int,Int},Int}()
    for i in key
        tr = sum(ctx.elements[i][j,j] for j in 1:22)
        denominator(tr) == 1 || error("Nonintegral primitive trace")
        bin = (ctx.orders[i],Int(numerator(tr)))
        hist[bin] = get(hist,bin,0)+1
    end
    @assert sum(values(hist)) == length(key) && get(hist,(1,22),0) == 1
    return hist
end

function r69_v4(ctx)
    v4 = Dict{Any,Tuple{Int,Int}}()
    for a in 1:12, b in a+1:12
        ctx.orders[a] == ctx.orders[b] == 2 || continue
        A = r69_subgroup(ctx,[a,b])
        length(A) == 4 && all(i <= 12 && (i == 1 || ctx.orders[i] == 2)
            for i in A) || continue
        get!(v4,A,(a,b))
    end
    isempty(v4) && error("No V4 subgroup in saved No. 69 kernel")
    return v4
end

# For No. 102 the quotient is the unique order-three subgroup of C6,
# represented by f^2. For No. 103 it is all of C6, represented by f.
# All twelve possible n*f^step lifts are enumerated for every V4 kernel.
function r69_raw(ctx,spec,v4)
    raw = Dict{Any,Tuple{Int,Int,Int}}()
    for (A,(a,b)) in v4, n in 1:12
        lift = ctx.idx(n,spec.coset_step)
        z = 1
        for _ in 1:spec.quotient
            z = ctx.mul[z,lift]
        end
        z in A || continue
        all(ctx.mul[ctx.mul[lift,x],ctx.inverse[lift]] in A for x in A) || continue
        B = r69_subgroup(ctx,[a,b,lift])
        length(B) == spec.id[1] || error("Normalized lift did not form target order")
        Tuple(i for i in B if i <= 12) == A || error("Wrong kernel intersection")
        Set(div(i-1,12) for i in B) ==
            Set(mod(spec.coset_step*k,6) for k in 0:spec.quotient-1) ||
            error("Wrong quotient image")
        get!(raw,B,(a,b,lift))
    end
    isempty(raw) && error("No eligible No. $(spec.child) subgroup in No. 69")
    return raw
end

function r69_classes(ctx,raw)
    unseen = Set(keys(raw)); classes = NamedTuple[]
    while !isempty(unseen)
        first_key = first(sort!(collect(unseen)))
        orbit = Set([first_key]); todo = [first_key]; head = 1
        while head <= length(todo)
            key = todo[head]
            for g in ctx.generators
                next_key = Tuple(sort!([ctx.mul[ctx.mul[g,x],ctx.inverse[g]]
                    for x in key]))
                haskey(raw,next_key) || error("Eligible classes are not conjugacy stable")
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

function r69_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Group path must end in .mrdi")
    p,expected,hashes = r69_preflight()
    ctx = r69_context(p)
    v4 = r69_v4(ctx)
    candidates = NamedTuple[]; counts = NamedTuple[]
    for spec in r69_specs
        raw = r69_raw(ctx,spec,v4)
        eligible = Dict(key=>gens for (key,gens) in raw if
            r69_group_id(ctx,key,collect(gens)) == spec.id)
        classes = r69_classes(ctx,eligible)
        matches = 0
        for (class_number,c) in enumerate(classes)
            a,b,lift = eligible[c.key]
            hist = r69_histogram(ctx,c.key)
            matched = hist == expected[spec.child]
            matches += matched
            push!(candidates,(child=spec.child,parent=69,
                class_number=class_number,orbit_size=c.orbit_size,
                subgroup_indices=c.key,group_id=spec.id,
                symplectic_generator_indices=(a,b),extra_generator_index=lift,
                symplectic_generators=(ctx.elements[a],ctx.elements[b]),
                extra_generator=ctx.elements[lift],
                primitive_character_histogram=hist,character_match=matched))
            r69_note("No. $(spec.child) class $class_number: orbit $(c.orbit_size), character match=$matched")
        end
        matches > 0 || error("No No. $(spec.child) subgroup matches its geometric character")
        push!(counts,(child=spec.child,raw_subgroups=length(raw),
            abstract_subgroups=length(eligible),parent_classes=length(classes),
            character_matches=matches))
    end
    save(output,(format_version=1,source_hashes=hashes,
        method="all V4 kernels in A4, all twelve lifts above f^2 or f; exact closure and full parent conjugacy",
        parent_number=69,parent_group_order=72,complete_within_saved_parent=true,
        numbered_assignment_claimed=false,v4_subgroups=length(v4),
        counts=Tuple(counts),candidates=r69_saved_collection(candidates),
        lattice_and_root_checks_done=false))
    check = load(output)
    @assert check.source_hashes == hashes && length(check.candidates) == length(candidates)
    r69_note("Saved and reloaded $output")
end

function r69_restriction(p,spec,c)
    T = invariant_lattice(p.L,collect(c.symplectic_generators);
        ambient_representation=false)
    S = orthogonal_submodule(p.L,T)
    @assert rank(S) == 12 && rank(T) == 10
    @assert signature_tuple(S) == (12,0,0)
    @assert signature_tuple(T) == (8,0,2)
    Lf = integer_lattice_with_isometry(p.L,c.extra_generator;
        ambient_representation=false,check=true)
    @assert trivial_action_on_discriminant(Lf)
    Simg = lattice_in_same_ambient_space(Lf,basis_matrix(S);check=true)
    Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
    @assert basis_matrix(S)*gram_matrix(ambient_space(p.L))*
        transpose(basis_matrix(T)) == zero_matrix(QQ,12,10)
    Taction = full_rank_model(Timg)
    @assert Int(order_of_isometry(Taction)) == spec.quotient
    pk = embedded_PK_data(Lf,Timg,spec.quotient)
    P,K = pk.P_lattice,pk.K_lattice
    @assert rank(P) == spec.rank_P && rank(K) == 22-spec.rank_P
    @assert signature_tuple(P) == (spec.rank_P-2,0,2)
    @assert signature_tuple(K) == (rank(K),0,0)
    @assert period_dimension(P,spec.quotient) == spec.dimension
    return (order=spec.quotient,dimension=spec.dimension,
        S_in_Lambda0=Simg,T_in_Lambda0=Timg,T_action=Taction,
        K_in_Lambda0=K,P_in_Lambda0=P,P_action=pk.P_with_isometry,
        Lambda0=Lf,group_gap_id=nothing,
        symplectic_kernel_order_S=nothing,symplectic_kernel_order_K=nothing,
        symplectic_saturation_verified=false,extracted_subgroup_id=spec.id,
        group_id_source="verified subgroup of cached No. 69 full group",
        parent_number=69,child_number=spec.child,
        symplectic_generators_in_parent=c.symplectic_generators,
        extra_generator_in_parent=c.extra_generator)
end

function r69_lattices(output,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Lattice path must end in .mrdi")
    groups = load(groups_path)
    @assert groups.format_version == 1 && groups.source_hashes == r69_run_hashes()
    p = r69_parent()
    summaries = NamedTuple[]; results = NamedTuple[]
    for c in groups.candidates
        c.character_match || continue
        spec = r69_spec(c.child)
        T = invariant_lattice(p.L,collect(c.symplectic_generators);
            ambient_representation=false)
        S = orthogonal_submodule(p.L,T)
        reason = ""; index = 0; dimension = -1; rank_P = 0; rank_K = 0
        if rank(S) != 12 || rank(T) != 10
            reason = "symplectic rank mismatch"
        elseif signature_tuple(S) != (12,0,0) || signature_tuple(T) != (8,0,2)
            reason = "symplectic lattice signature mismatch"
        else
            Lf = integer_lattice_with_isometry(p.L,c.extra_generator;
                ambient_representation=false,check=true)
            @assert trivial_action_on_discriminant(Lf)
            Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
            index = Int(order_of_isometry(full_rank_model(Timg)))
            if index != spec.quotient
                reason = "quotient action order mismatch"
            else
                pk = embedded_PK_data(Lf,Timg,spec.quotient)
                rank_P,rank_K = rank(pk.P_lattice),rank(pk.K_lattice)
                if rank_P != spec.rank_P || rank_K != 22-spec.rank_P
                    reason = "period/complement rank mismatch"
                elseif signature_tuple(pk.P_lattice) != (rank_P-2,0,2) ||
                       signature_tuple(pk.K_lattice) != (rank_K,0,0)
                    reason = "period/complement signature mismatch"
                else
                    dimension = period_dimension(pk.P_lattice,spec.quotient)
                    dimension == spec.dimension || (reason = "period dimension mismatch")
                end
            end
        end
        push!(summaries,(child=c.child,class_number=c.class_number,
            rank_S=rank(S),rank_T=rank(T),rank_P=rank_P,rank_K=rank_K,
            index=index,dimension=dimension,matched=isempty(reason),reason=reason))
        r69_note("No. $(c.child) class $(c.class_number): S=$(rank(S)), P=$rank_P, dim=$dimension, reason=$reason")
        isempty(reason) || continue
        push!(results,(child=c.child,class_number=c.class_number,
            result=r69_restriction(p,spec,c)))
    end
    counts = Tuple((child=s.child,count=count(r->r.child==s.child,results)) for s in r69_specs)
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=r69_hash(groups_path),
        summaries=r69_saved_collection(summaries),results=r69_saved_collection(results),
        target_numbers=(102,103),match_counts=counts,complete_lattice_pass=true,
        roots_verified=false,symplectic_saturation_verified=false,
        numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert length(check.results) == length(results)
    r69_note("Saved and reloaded $output; lattice matches=$counts")
end

function r69_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Verified path must end in .mrdi")
    groups,data = load(groups_path),load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.source_hashes == data.source_hashes == r69_run_hashes()
    @assert data.groups_file_hash == r69_hash(groups_path)
    p = r69_parent(); ctx = r69_context(p)
    expected = r69_geometric_characters()
    verified = NamedTuple[]; obstructed = NamedTuple[]
    for r in data.results
        c = only(x for x in groups.candidates if
            x.child == r.child && x.class_number == r.class_number)
        @assert c.character_match
        a,b = c.symplectic_generator_indices
        lift = c.extra_generator_index
        A = r69_subgroup(ctx,[a,b])
        @assert length(A) == 4 && all(i <= 12 for i in A)
        B = r69_subgroup(ctx,[a,b,lift])
        @assert B == c.subgroup_indices && Tuple(i for i in B if i <= 12) == A
        spec = r69_spec(r.child)
        @assert r69_group_id(ctx,B,[a,b,lift]) == spec.id
        @assert r69_histogram(ctx,B) == c.primitive_character_histogram ==
            expected[r.child]
        result = r69_restriction(p,spec,c)
        @assert gram_matrix(lattice(result.S_in_Lambda0)) ==
            gram_matrix(lattice(r.result.S_in_Lambda0))
        @assert gram_matrix(lattice(result.T_in_Lambda0)) ==
            gram_matrix(lattice(r.result.T_in_Lambda0))
        @assert gram_matrix(result.P_in_Lambda0) == gram_matrix(r.result.P_in_Lambda0)
        @assert gram_matrix(result.K_in_Lambda0) == gram_matrix(r.result.K_in_Lambda0)
        @assert isometry(result.T_action) == isometry(r.result.T_action)
        if has_root(result.K_in_Lambda0,p.L)
            push!(obstructed,(child=r.child,parent=69,
                class_number=r.class_number,group_id=spec.id))
            r69_note("No. $(r.child) class $(r.class_number): root obstruction")
        else
            push!(verified,(child=r.child,parent=69,
                class_number=r.class_number,group_id=spec.id,
                roots_verified=true,result=result))
            r69_note("No. $(r.child) class $(r.class_number): subgroup, lattice and roots verified")
        end
    end
    @assert length(verified)+length(obstructed) == length(data.results)
    counts = Tuple((child=s.child,count=count(r->r.child==s.child,verified),
        obstructed=count(r->r.child==s.child,obstructed)) for s in r69_specs)
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=r69_hash(groups_path),
        lattices_file_hash=r69_hash(lattices_path),
        verified_results=r69_saved_collection(verified),
        root_obstructed=r69_saved_collection(obstructed),
        target_numbers=(102,103),counts=counts,roots_verified=true,
        complete_lattice_pass=data.complete_lattice_pass,
        complete_within_saved_parent=true,symplectic_saturation_verified=false,
        numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == data.source_hashes
    @assert length(check.verified_results) == length(verified)
    @assert length(check.root_obstructed) == length(obstructed)
    r69_note("Saved and reloaded $output; root outcomes=$counts")
end

function r69_main()
    isempty(ARGS) && error("Choose source-check, prepare, preflight, groups, lattices, or verify")
    stage = ARGS[1]
    if stage == "source-check"
        length(ARGS) == 1 || error("source-check takes no arguments")
        r69_source_check()
    elseif stage == "prepare"
        length(ARGS) <= 2 || error("prepare [cache.mrdi]")
        r69_prepare(length(ARGS) == 2 ? abspath(ARGS[2]) : r69_cache)
    elseif stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no arguments")
        r69_preflight()
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        r69_groups(length(ARGS) == 2 ? abspath(ARGS[2]) : r69_groups_file)
    elseif stage == "lattices"
        length(ARGS) <= 3 || error("lattices [output.mrdi] [groups.mrdi]")
        r69_lattices(length(ARGS) >= 2 ? abspath(ARGS[2]) : r69_lattices_file,
            length(ARGS) == 3 ? abspath(ARGS[3]) : r69_groups_file)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        r69_verify(length(ARGS) >= 2 ? abspath(ARGS[2]) : r69_verified_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : r69_lattices_file,
            length(ARGS) == 4 ? abspath(ARGS[4]) : r69_groups_file)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    r69_main()
end
