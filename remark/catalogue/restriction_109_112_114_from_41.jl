# Exhaustive Nos. 109, 112 and 114 subgroup restrictions in the cached
# full No. 41 action. Run the companion GAP character script first, then
# preflight, groups, lattices, verify. No stage changes the 156-row catalogue.
# A character match is a filter; integral periods and roots are checked later.

using SHA
include(joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))
include(joinpath(@__DIR__, "restriction_functions.jl"))

const r41109112114_specs = (
    (number=109,rank_S=12,index=2,dimension=4,group_id=(6,2)),
    (number=112,rank_S=12,index=3,dimension=2,group_id=(9,2)),
    (number=114,rank_S=12,index=6,dimension=1,group_id=(18,5)),
)
const r41109112114_parent_number = 41
const r41109112114_parent_id = (126,7)
const r41109112114_source = joinpath(@__DIR__, "..", "..", "oscar", "oscar_script_data.mrdi")
const r41109112114_source_sha256 = "c5278c3aeb5b2f7ed3574030d75d48680bba276302e035603531fa701bcf976b"
const r41109112114_cache = joinpath(@__DIR__, "source_41_full_lattice_group_rank0.mrdi")
const r41109112114_cache_sha256 = "1f411446e5688869e78fe4b4360d5703f8ea2723cb7149882e1e811100e5a13c"
const r41109112114_table = joinpath(@__DIR__, "..", "input", "family_numbering.md")
const r41109112114_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_all_pairs.tsv")
const r41109112114_characters = joinpath(@__DIR__,
    "restriction_109_112_114_geometric_characters.tsv")
const r41109112114_character_script = joinpath(@__DIR__,
    "restriction_109_112_114_geometric_characters.g")
const r41109112114_gap_families = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const r41109112114_gap_families_sha256 = "ffc8c914ab1250d5d60f9697dbe5c37844bfaddc480a547f5eb2a8cdd5535c1c"
const r41109112114_gap_witnesses = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_positive_edges.g")
const r41109112114_gap_witnesses_sha256 = "cf3339b80609385d40ebaf9d801bbe38bb251731873240e654293d29e12a5234"
const r41109112114_julia_script = joinpath(@__DIR__, "restriction_109_112_114_from_41.jl")
const r41109112114_julia_group_helper = joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl")
const r41109112114_julia_lattice_helper = joinpath(@__DIR__, "restriction_functions.jl")
const r41109112114_julia_oscar_helper = joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl")
const r41109112114_groups_file = joinpath(@__DIR__,
    "restriction_109_112_114_from_41.groups.mrdi")
const r41109112114_lattices_file = joinpath(@__DIR__,
    "restriction_109_112_114_from_41.lattices.mrdi")
const r41109112114_verified_file = joinpath(@__DIR__,
    "restriction_109_112_114_from_41.verified.mrdi")

r41109112114_note(s) = (println(s); flush(stdout))
r41109112114_hash(path) = bytes2hex(sha256(read(path)))
r41109112114_spec(n) = only(s for s in r41109112114_specs if s.number == n)

function r41109112114_hashes()
    paths = (r41109112114_source,r41109112114_cache,r41109112114_table,
        r41109112114_edges,r41109112114_characters,r41109112114_character_script,
        r41109112114_gap_families,r41109112114_gap_witnesses,
        r41109112114_julia_script,r41109112114_julia_group_helper,
        r41109112114_julia_lattice_helper,r41109112114_julia_oscar_helper)
    all(isfile,paths) || error("A source is missing; run the companion GAP script first")
    hashes = Tuple(r41109112114_hash(p) for p in paths)
    hashes[1] == r41109112114_source_sha256 || error("The frozen OSCAR source changed")
    hashes[2] == r41109112114_cache_sha256 || error("The No. 41 cache changed")
    hashes[7] == r41109112114_gap_families_sha256 || error("The frozen GAP families changed")
    hashes[8] == r41109112114_gap_witnesses_sha256 || error("The GAP containment witnesses changed")
    return hashes
end

function r41109112114_table_check()
    expected = Dict(41 => (18,6,0,r41109112114_parent_id))
    for s in r41109112114_specs
        expected[s.number] = (s.rank_S,s.index,s.dimension,s.group_id)
    end
    seen = Set{Int}()
    for line in eachline(r41109112114_table)
        startswith(line,"|") || continue
        cells = strip.(split(line,'|'))
        length(cells) >= 9 || continue
        n = tryparse(Int,cells[2])
        n === nothing && continue
        haskey(expected,n) || continue
        m = match(r"\[(\d+),(\d+)\]",cells[8])
        m === nothing && error("Missing group ID for No. $n")
        actual = (parse(Int,cells[3]),parse(Int,cells[6]),
            parse(Int,cells[7]),(parse(Int,m.captures[1]),parse(Int,m.captures[2])))
        actual == expected[n] || error("Numbered data changed for No. $n: $actual")
        n in seen && error("Duplicate numbered row $n")
        push!(seen,n)
    end
    seen == Set(keys(expected)) || error("A numbered family row is missing")
end

function r41109112114_containment_check()
    seen = Set{Int}()
    for (line_number,line) in enumerate(eachline(r41109112114_edges))
        line_number == 1 && continue
        fields = split(line,'\t')
        length(fields) == 12 || error("Malformed containment TSV line $line_number")
        parse(Int,fields[2]) == 41 || continue
        n = parse(Int,fields[1])
        n in (109,112,114) || continue
        s = r41109112114_spec(n)
        Tuple(parse.(Int,fields[3:6])) == (s.dimension,0,3*s.group_id[1],378) ||
            error("Wrong strict-containment sizes for No. $n")
        fields[7:10] == ["embedded","direct","true","fail"] ||
            error("No. $n is not a direct strict containment")
        fields[12] in ("literal_matrix_subgroup","A_strict") ||
            error("Unexpected strict witness method for No. $n")
        n in seen && error("Duplicate strict containment for No. $n")
        push!(seen,n)
    end
    seen == Set((109,112,114)) || error("A direct strict containment is missing")
end

function r41109112114_expected_characters()
    expected = Dict(s.number => Dict{Tuple{Int,Int},Int}() for s in r41109112114_specs)
    for (i,line) in enumerate(eachline(r41109112114_characters))
        if i == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric-character TSV header")
            continue
        end
        isempty(strip(line)) && continue
        fields = split(line,'\t')
        length(fields) == 4 || error("Malformed character line $i")
        n,ord,tr,count = parse.(Int,fields)
        haskey(expected,n) && count > 0 || error("Unexpected character line $i")
        key = (ord,tr)
        haskey(expected[n],key) && error("Duplicate character bin on line $i")
        expected[n][key] = count
    end
    for s in r41109112114_specs
        sum(values(expected[s.number])) == s.group_id[1] ||
            error("Incomplete character for No. $(s.number)")
        get(expected[s.number],(1,22),0) == 1 || error("Bad identity trace")
    end
    return expected
end

function r41109112114_parent()
    source = load(r41109112114_source)
    @assert source.format_version == 3 && source.completed_cases == 29
    case = source.cases[16]
    @assert case.case_index == 16
    parent = case.results[3]
    @assert parent.group_gap_id == r41109112114_parent_id
    @assert parent.order == 6 && parent.dimension == 0
    L = lattice(parent.Lambda0)
    S = lattice(parent.S_in_Lambda0)
    T = lattice(parent.T_in_Lambda0)
    @assert rank(L) == 22 && rank(S) == 18 && rank(T) == 4
    @assert signature_tuple(L) == (20,0,2) && abs(det(gram_matrix(L))) == 3
    cache = load(r41109112114_cache)
    @assert cache.format_version == 1 && cache.parent_number == 41
    @assert cache.source_sha256 == r41109112114_source_sha256
    @assert cache.symplectic_order == 21 && cache.quotient_order == 6
    @assert cache.full_group_id == r41109112114_parent_id
    @assert basis_matrix(lattice(cache.Lambda0)) == basis_matrix(L)
    @assert gram_matrix(lattice(cache.Lambda0)) == gram_matrix(L)
    @assert basis_matrix(lattice(cache.S_in_Lambda0)) == basis_matrix(S)
    @assert cache.extra_generator == isometry(parent.Lambda0)
    @assert cache.extra_generator_S == isometry(parent.S_in_Lambda0)
    @assert length(cache.symplectic_generators) == length(cache.symplectic_generators_S)
    embedding = basis_matrix(S)*inv(basis_matrix(L))
    tcoordinates = basis_matrix(T)*inv(basis_matrix(L))
    for (uS,uL) in zip(cache.symplectic_generators_S,cache.symplectic_generators)
        @assert uS*embedding == embedding*uL
        @assert tcoordinates*uL == tcoordinates
    end
    return (;parent,cache,L,embedding,tcoordinates)
end

function r41109112114_preflight()
    hashes = r41109112114_hashes()
    r41109112114_table_check()
    r41109112114_containment_check()
    expected = r41109112114_expected_characters()
    p = r41109112114_parent()
    r41109112114_note("No. 41 cache and all three strict geometric characters passed")
    r41109112114_note("Source hashes: $hashes")
    return p,expected,hashes
end

# In the 126-element full group, element (n,k) means n*f^k for
# 1 <= n <= 21 and 0 <= k < 6.  The S-action gives multiplication in N,
# while the rank-22 action separates the six quotient cosets.
function r41109112114_context(p)
    nctx = direct_context(p.cache.symplectic_generators_S,
        p.cache.extra_generator_S,21,6)
    @assert count(==(3),nctx.orders) == 14 # seven C3 subgroups in F21
    idx(n,k) = 21*k+n
    e = identity_matrix(QQ,22)
    nL = [foldl(*,(p.cache.symplectic_generators[j] for j in nctx.words[n]);
        init=e) for n in 1:21]
    @assert length(Set(direct_matrix_key(x) for x in nL)) == 21
    @assert all(nctx.elements[n]*p.embedding == p.embedding*nL[n] for n in 1:21)
    @assert all(p.tcoordinates*nL[n] == p.tcoordinates for n in 1:21)
    f = p.cache.extra_generator
    @assert f^6 == nL[nctx.c]
    @assert all(f*nL[n]*inv(f) == nL[nctx.phi[n]] for n in 1:21)
    powers = [f^k for k in 0:5]
    elements = [nL[n]*powers[k+1] for k in 0:5 for n in 1:21]
    @assert length(elements) == 126
    @assert length(Set(direct_matrix_key(x) for x in elements)) == 126
    phi = [collect(1:21)]
    for _ in 1:5
        push!(phi,[nctx.phi[phi[end][n]] for n in 1:21])
    end
    mul = zeros(Int,126,126)
    for i in 1:126, j in 1:126
        n,k = mod1(i,21),div(i-1,21)
        m,l = mod1(j,21),div(j-1,21)
        a = nctx.mul(n,phi[k+1][m])
        if k+l >= 6
            a = nctx.mul(a,nctx.c)
        end
        mul[i,j] = idx(a,mod(k+l,6))
    end
    @assert all(mul[1,i] == i && mul[i,1] == i for i in 1:126)
    inverse = [only(j for j in 1:126 if mul[i,j] == 1 && mul[j,i] == 1)
        for i in 1:126]
    generators = [nctx.generator_ids; idx(1,1)]
    @assert all(elements[mul[i,g]] == elements[i]*elements[g]
        for i in 1:126 for g in generators)
    orders = Int[]
    for i in 1:126
        x = 1; ord = 0
        while true
            x = mul[x,i]; ord += 1
            x == 1 && break
            ord <= 126 || error("Finite table has no element order")
        end
        push!(orders,ord)
    end
    ctx = (;p,nctx,elements,mul,inverse,orders,generators,idx)
    @assert r41109112114_group_id(ctx,Tuple(1:126),generators) ==
        r41109112114_parent_id
    return ctx
end

function r41109112114_subgroup(ctx,gens)
    seen = Set([1]); todo = [1]; head = 1
    symmetric = [gens; [ctx.inverse[g] for g in gens]]
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

function r41109112114_group_id(ctx,key,gens)
    positions = Dict(x => i for (i,x) in enumerate(key))
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

function r41109112114_histogram(ctx,key)
    h = Dict{Tuple{Int,Int},Int}()
    for i in key
        tr = sum(ctx.elements[i][j,j] for j in 1:22)
        denominator(tr) == 1 || error("Nonintegral primitive trace")
        bin = (ctx.orders[i],Int(numerator(tr)))
        h[bin] = get(h,bin,0)+1
    end
    @assert sum(values(h)) == length(key) && get(h,(1,22),0) == 1
    return h
end

# If B has kernel A=C3 and cyclic quotient of order q, B contains a lift
# in N*f^(6/q). Enumerating all seven A and all 21 lifts exhausts such B.
function r41109112114_raw(ctx,s)
    q = s.index
    exponent = div(6,q)
    raw = Dict{Any,Tuple{Int,Int}}()
    for a in 1:21
        ctx.orders[a] == 3 || continue
        A = r41109112114_subgroup(ctx,[a])
        length(A) == 3 && all(i <= 21 for i in A) || error("Invalid C3 kernel")
        for n in 1:21
            b = ctx.idx(n,exponent)
            key = r41109112114_subgroup(ctx,[a,b])
            length(key) == 3*q || continue
            Tuple(i for i in key if i <= 21) == A || continue
            quotient = Set(div(i-1,21) for i in key)
            quotient == Set(mod(k*exponent,6) for k in 0:q-1) ||
                error("Wrong quotient subgroup")
            get!(raw,key,(a,b))
        end
    end
    isempty(raw) && error("No C3-by-C$q subgroup in saved No. 41")
    return raw
end

function r41109112114_classes(ctx,raw)
    unseen = Set(keys(raw)); classes = NamedTuple[]
    while !isempty(unseen)
        first_key = first(sort!(collect(unseen)))
        orbit = Set([first_key]); todo = [first_key]; head = 1
        while head <= length(todo)
            key = todo[head]
            for g in ctx.generators
                next_key = Tuple(sort!([ctx.mul[ctx.mul[g,x],ctx.inverse[g]]
                    for x in key]))
                haskey(raw,next_key) || error("Eligible subgroups not conjugacy stable")
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

function r41109112114_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    p,expected,hashes = r41109112114_preflight()
    ctx = r41109112114_context(p)
    candidates = NamedTuple[]; summaries = NamedTuple[]
    for s in r41109112114_specs
        raw = r41109112114_raw(ctx,s)
        eligible = Dict(key => gens for (key,gens) in raw if
            r41109112114_group_id(ctx,key,gens) == s.group_id)
        isempty(eligible) && error("No subgroup of abstract type $(s.group_id)")
        classes = r41109112114_classes(ctx,eligible)
        matched = 0
        for (class_number,c) in enumerate(classes)
            a,b = eligible[c.key]
            h = r41109112114_histogram(ctx,c.key)
            is_match = h == expected[s.number]
            matched += is_match
            push!(candidates,(child_number=s.number,parent_number=41,
                class_number=class_number,parent_conjugacy_orbit_size=c.orbit_size,
                subgroup_indices=c.key,subgroup_id=s.group_id,
                symplectic_generator_index=a,extra_generator_index=b,
                symplectic_generator=ctx.elements[a],
                extra_generator=ctx.elements[b],
                primitive_character_histogram=h,geometric_character_match=is_match))
            r41109112114_note("No. $(s.number) class $class_number: orbit $(c.orbit_size), character match=$is_match")
        end
        matched > 0 || error("No No. 41 class matches No. $(s.number) character")
        push!(summaries,(child_number=s.number,raw_subgroups=length(raw),
            abstract_subgroups=length(eligible),parent_conjugacy_classes=length(classes),
            character_matches=matched))
    end
    save(output,(format_version=1,source_hashes=hashes,
        method="all C3 subgroups of F21 and all lifts in the quotient generator coset; exact closure and full parent conjugacy",
        parent_number=41,parent_group_order=126,
        complete_within_saved_parent=true,numbered_assignment_claimed=false,
        summaries=Tuple(summaries),candidates=Tuple(candidates),
        lattice_and_root_checks_done=false))
    check = load(output)
    @assert check.source_hashes == hashes && length(check.candidates) == length(candidates)
    r41109112114_note("Saved and reloaded $output")
end

function r41109112114_lattices(output,groups_path,selected)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path)
    @assert groups.format_version == 1 && groups.source_hashes == r41109112114_hashes()
    p = r41109112114_parent()
    summaries = NamedTuple[]; results = NamedTuple[]
    for c in groups.candidates
        c.geometric_character_match || continue
        if selected !== nothing && (c.child_number,c.class_number) != selected
            continue
        end
        s = r41109112114_spec(c.child_number)
        sym = integer_lattice_with_isometry(p.L,c.symplectic_generator;
            ambient_representation=false,check=true)
        S = lattice(coinvariant_lattice(sym))
        T = lattice(invariant_lattice(sym))
        index = 0; dimension = -1; rank_P = 0; rank_K = 0; reason = ""
        if rank(S) != s.rank_S || rank(T) != 22-s.rank_S
            reason = "symplectic coinvariant rank mismatch"
        elseif signature_tuple(S) != (rank(S),0,0) ||
               signature_tuple(T) != (rank(T)-2,0,2)
            reason = "symplectic lattice signature mismatch"
        else
            Lf = integer_lattice_with_isometry(p.L,c.extra_generator;
                ambient_representation=false,check=true)
            @assert trivial_action_on_discriminant(Lf)
            Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
            index = Int(order_of_isometry(full_rank_model(Timg)))
            if index != s.index
                reason = "quotient action order mismatch"
            else
                pk = embedded_PK_data(Lf,Timg,index)
                rank_P,rank_K = rank(pk.P_lattice),rank(pk.K_lattice)
                @assert rank_P+rank_K == 22
                if signature_tuple(pk.P_lattice) != (rank_P-2,0,2) ||
                   signature_tuple(pk.K_lattice) != (rank_K,0,0)
                    reason = "period/complement signature mismatch"
                elseif rank_P % Int(euler_phi(index)) != 0
                    reason = "period rank incompatible with cyclotomic order"
                else
                    dimension = period_dimension(pk.P_lattice,index)
                    dimension == s.dimension || (reason = "period dimension mismatch")
                end
            end
        end
        push!(summaries,(child_number=s.number,class_number=c.class_number,
            rank_S=rank(S),rank_T=rank(T),rank_P=rank_P,rank_K=rank_K,
            index=index,dimension=dimension,matched=isempty(reason),reason=reason))
        r41109112114_note("No. $(s.number) class $(c.class_number): S=$(rank(S)), P=$rank_P, dim=$dimension, reason=$reason")
        isempty(reason) || continue
        result = complete_cyclic_restriction(p.parent,
            c.symplectic_generator,c.extra_generator;
            child_number=s.number,parent_number=41,index=s.index,
            expected_rank_S=s.rank_S,expected_dimension=s.dimension,
            expected_group_id=s.group_id,verify_group_id=false,
            verify_roots=false,verify_symplectic_saturation=false)
        push!(results,(child_number=s.number,class_number=c.class_number,result=result))
    end
    counts = [count(r -> r.child_number == s.number,results) for s in r41109112114_specs]
    isempty(results) && error("No selected class passed lattice filters")
    selected === nothing && !all(x -> x > 0,counts) &&
        error("An expected numbered family has no lattice match")
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=r41109112114_hash(groups_path),
        summaries=Tuple(summaries),results=Tuple(results),
        target_numbers=[s.number for s in r41109112114_specs],match_counts=counts,
        selected_class=selected,complete_lattice_pass=(selected === nothing),
        roots_verified=false,symplectic_saturation_verified=false,
        numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert length(check.results) == length(results)
    r41109112114_note("Saved and reloaded $output; match counts=$counts")
end

function r41109112114_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path); data = load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.source_hashes == data.source_hashes == r41109112114_hashes()
    @assert data.groups_file_hash == r41109112114_hash(groups_path)
    @assert data.complete_lattice_pass == (data.selected_class === nothing)
    isempty(data.results) && error("No lattice matches to verify")
    p = r41109112114_parent(); ctx = r41109112114_context(p)
    expected = r41109112114_expected_characters()
    verified = NamedTuple[]; root_obstructed = NamedTuple[]
    for r in data.results
        c = only(x for x in groups.candidates if x.child_number == r.child_number &&
            x.class_number == r.class_number)
        s = r41109112114_spec(r.child_number)
        key = r41109112114_subgroup(ctx,
            [c.symplectic_generator_index,c.extra_generator_index])
        @assert key == c.subgroup_indices
        @assert r41109112114_group_id(ctx,key,
            [c.symplectic_generator_index,c.extra_generator_index]) == s.group_id
        @assert Tuple(i for i in key if i <= 21) ==
            r41109112114_subgroup(ctx,[c.symplectic_generator_index])
        @assert r41109112114_histogram(ctx,key) ==
            c.primitive_character_histogram == expected[s.number]
        result = complete_cyclic_restriction(p.parent,
            c.symplectic_generator,c.extra_generator;
            child_number=s.number,parent_number=41,index=s.index,
            expected_rank_S=s.rank_S,expected_dimension=s.dimension,
            expected_group_id=s.group_id,verify_group_id=false,
            verify_roots=false,verify_symplectic_saturation=false)
        @assert gram_matrix(lattice(result.S_in_Lambda0)) ==
            gram_matrix(lattice(r.result.S_in_Lambda0))
        @assert gram_matrix(lattice(result.T_in_Lambda0)) ==
            gram_matrix(lattice(r.result.T_in_Lambda0))
        @assert gram_matrix(result.P_in_Lambda0) == gram_matrix(r.result.P_in_Lambda0)
        @assert gram_matrix(result.K_in_Lambda0) == gram_matrix(r.result.K_in_Lambda0)
        @assert isometry(result.T_action) == isometry(r.result.T_action)
        if has_root(result.K_in_Lambda0,p.L)
            push!(root_obstructed,(child_number=s.number,parent_number=41,
                class_number=c.class_number,subgroup_id=s.group_id))
            r41109112114_note("No. $(s.number) class $(c.class_number): root obstruction")
            continue
        end
        push!(verified,(child_number=s.number,parent_number=41,
            class_number=c.class_number,subgroup_id=s.group_id,
            roots_verified=true,result=result))
        r41109112114_note("No. $(s.number) class $(c.class_number): subgroup, lattice and roots verified")
    end
    counts = [count(r -> r.child_number == s.number,verified) for s in r41109112114_specs]
    obstructed_counts = [count(r -> r.child_number == s.number,root_obstructed)
        for s in r41109112114_specs]
    @assert all(counts[i]+obstructed_counts[i] == data.match_counts[i]
        for i in eachindex(counts))
    verified_saved = isempty(verified) ? String[] : Tuple(verified)
    obstructed_saved = isempty(root_obstructed) ? String[] : Tuple(root_obstructed)
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=r41109112114_hash(groups_path),
        lattices_file_hash=r41109112114_hash(lattices_path),
        verified_results=verified_saved,root_obstructed=obstructed_saved,
        target_numbers=data.target_numbers,match_counts=counts,
        root_obstructed_counts=obstructed_counts,
        roots_verified=data.complete_lattice_pass,
        roots_verified_for_saved_results=true,
        root_checks_complete_for_lattice_matches=data.complete_lattice_pass,
        selected_class=data.selected_class,
        complete_lattice_pass=data.complete_lattice_pass,
        symplectic_saturation_verified=false,numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == data.source_hashes
    @assert length(check.verified_results) == length(verified)
    @assert length(check.root_obstructed) == length(root_obstructed)
    @assert (isempty(verified) ? check.verified_results isa Vector{String} :
        check.verified_results isa Tuple)
    @assert (isempty(root_obstructed) ? check.root_obstructed isa Vector{String} :
        check.root_obstructed isa Tuple)
    r41109112114_note("Saved and reloaded $output; root-free=$counts, obstructed=$obstructed_counts")
end

function r41109112114_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices or verify")
    stage = ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no arguments")
        r41109112114_preflight()
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        r41109112114_groups(length(ARGS) == 2 ? abspath(ARGS[2]) : r41109112114_groups_file)
    elseif stage == "lattices"
        length(ARGS) <= 4 || error("lattices [output.mrdi] [groups.mrdi] [child:class]")
        selected = nothing
        if length(ARGS) == 4
            bits = split(ARGS[4],':')
            length(bits) == 2 || error("Select child:class, for example 109:1")
            selected = (parse(Int,bits[1]),parse(Int,bits[2]))
        end
        r41109112114_lattices(length(ARGS) >= 2 ? abspath(ARGS[2]) :
            r41109112114_lattices_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : r41109112114_groups_file,
            selected)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        r41109112114_verify(length(ARGS) >= 2 ? abspath(ARGS[2]) :
            r41109112114_verified_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : r41109112114_lattices_file,
            length(ARGS) == 4 ? abspath(ARGS[4]) : r41109112114_groups_file)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    r41109112114_main()
end
