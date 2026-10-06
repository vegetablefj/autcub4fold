# Exhaustive No. 111 subgroup restrictions of the cached full No. 18 action.
# Run the companion GAP character script, then preflight/groups/lattices/verify.
# Each stage writes a new file and leaves the numbered catalogue untouched.

using SHA
include(joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))
include(joinpath(@__DIR__, "restriction_functions.jl"))

const r111_source = joinpath(@__DIR__, "..", "..", "oscar", "oscar_script_data.mrdi")
const r111_source_sha256 = "c5278c3aeb5b2f7ed3574030d75d48680bba276302e035603531fa701bcf976b"
const r111_cache = joinpath(@__DIR__, "source_18_full_lattice_group_rank0.mrdi")
const r111_cache_sha256 = "6e79d7cf4499a3116e29aa4e99b11e885a56aae05c8de6f26beb3d42caa66541"
const r111_table = joinpath(@__DIR__, "..", "input", "family_numbering.md")
const r111_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_all_pairs.tsv")
const r111_gap_families = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const r111_gap_families_sha256 = "ffc8c914ab1250d5d60f9697dbe5c37844bfaddc480a547f5eb2a8cdd5535c1c"
const r111_gap_witnesses = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_positive_edges.g")
const r111_gap_witnesses_sha256 = "cf3339b80609385d40ebaf9d801bbe38bb251731873240e654293d29e12a5234"
const r111_characters = joinpath(@__DIR__, "restriction_111_geometric_character.tsv")
const r111_character_script = joinpath(@__DIR__, "restriction_111_geometric_character.g")
const r111_groups_file = joinpath(@__DIR__, "restriction_111_from_18.groups.mrdi")
const r111_lattices_file = joinpath(@__DIR__, "restriction_111_from_18.lattices.mrdi")
const r111_verified_file = joinpath(@__DIR__, "restriction_111_from_18.verified.mrdi")

r111_note(s) = (println(s); flush(stdout))
r111_hash(path) = bytes2hex(sha256(read(path)))

function r111_hashes()
    paths = (r111_source, r111_cache, r111_table, r111_edges,
        r111_gap_families, r111_gap_witnesses, r111_characters,
        r111_character_script, @__FILE__,
        joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"),
        joinpath(@__DIR__, "restriction_functions.jl"),
        joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl"))
    all(isfile, paths) || error("A source is missing; run the companion GAP script first")
    hashes = Tuple((basename(path), r111_hash(path)) for path in paths)
    hashes[1][2] == r111_source_sha256 || error("The frozen OSCAR source changed")
    hashes[2][2] == r111_cache_sha256 || error("The No. 18 cache changed")
    hashes[5][2] == r111_gap_families_sha256 || error("The frozen GAP families changed")
    hashes[6][2] == r111_gap_witnesses_sha256 || error("The GAP containment witnesses changed")
    return hashes
end

function r111_table_check()
    expected = Dict(18 => (19, "M_9", 1, 3, 0, (216,153)),
                    111 => (12, "C3", 1, 3, 3, (9,2)))
    found = Dict{Int,Tuple}()
    for line in eachline(r111_table)
        startswith(line, "|") || continue
        cells = strip.(split(line, '|'))
        length(cells) >= 9 || continue
        n = tryparse(Int, cells[2])
        n === nothing && continue
        haskey(expected, n) || continue
        haskey(found, n) && error("Duplicate numbered row $n")
        m = match(r"\[(\d+),(\d+)\]", cells[8])
        m === nothing && error("Missing group ID for No. $n")
        found[n] = (parse(Int, cells[3]), replace(cells[4], "`" => ""),
            parse(Int, cells[5]), parse(Int, cells[6]), parse(Int, cells[7]),
            (parse(Int, m.captures[1]), parse(Int, m.captures[2])))
    end
    found == expected || error("Numbered group/rank/index/dimension data changed")
end

function r111_containment_check()
    matches = 0
    for (line_number, line) in enumerate(eachline(r111_edges))
        line_number == 1 && continue
        v = split(line, '\t')
        length(v) == 12 || error("Malformed strict-containment TSV line $line_number")
        parse(Int, v[1]) == 111 && parse(Int, v[2]) == 18 || continue
        Tuple(parse.(Int, v[3:6])) == (3,0,27,648) ||
            error("Wrong strict-containment sizes for No. 111 -> No. 18")
        v[7:10] == ["embedded","direct","true","fail"] ||
            error("No. 111 -> No. 18 is not a direct strict containment")
        v[12] in ("literal_matrix_subgroup", "A_strict") ||
            error("Unexpected strict witness method")
        matches += 1
    end
    matches == 1 || error("A unique direct strict containment is missing")
end

function r111_geometric_character()
    expected = Dict{Tuple{Int,Int},Int}()
    for (i,line) in enumerate(eachline(r111_characters))
        if i == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric-character header")
            continue
        end
        isempty(strip(line)) && continue
        v = split(line, '\t')
        length(v) == 4 || error("Malformed character line $i")
        n,ord,tr,count = parse.(Int, v)
        n == 111 && count > 0 && 1 <= ord <= 9 ||
            error("Unexpected character line $i")
        key = (ord,tr)
        haskey(expected,key) && error("Duplicate geometric-character bin")
        expected[key] = count
    end
    sum(values(expected)) == 9 || error("Incomplete No. 111 character")
    get(expected,(1,22),0) == 1 || error("Bad identity trace")
    return expected
end

function r111_parent()
    source = load(r111_source)
    @assert source.format_version == 3 && source.completed_cases == 29
    case = source.cases[6]
    @assert case.case_index == 6
    parent = case.results[1]
    @assert parent.group_gap_id == (216,153)
    @assert parent.order == 3 && parent.dimension == 0
    L = lattice(parent.Lambda0)
    S = lattice(parent.S_in_Lambda0)
    T = lattice(parent.T_in_Lambda0)
    @assert rank(L) == 22 && rank(S) == 19 && rank(T) == 3
    @assert signature_tuple(L) == (20,0,2) && abs(det(gram_matrix(L))) == 3
    cache = load(r111_cache)
    @assert cache.format_version == 1 && cache.parent_number == 18
    @assert cache.source_sha256 == r111_source_sha256
    @assert cache.symplectic_order == 72 && cache.quotient_order == 3
    @assert cache.full_group_id == (216,153)
    @assert basis_matrix(lattice(cache.Lambda0)) == basis_matrix(L)
    @assert gram_matrix(lattice(cache.Lambda0)) == gram_matrix(L)
    @assert basis_matrix(lattice(cache.S_in_Lambda0)) == basis_matrix(S)
    @assert cache.extra_generator == isometry(parent.Lambda0)
    @assert cache.extra_generator_S == isometry(parent.S_in_Lambda0)
    @assert length(cache.symplectic_generators) ==
        length(cache.symplectic_generators_S) > 0
    embedding = basis_matrix(S)*inv(basis_matrix(L))
    tcoordinates = basis_matrix(T)*inv(basis_matrix(L))
    for (uS,uL) in zip(cache.symplectic_generators_S,
                         cache.symplectic_generators)
        @assert uS*embedding == embedding*uL
        @assert tcoordinates*uL == tcoordinates
    end
    return (;parent,cache,L,embedding,tcoordinates)
end

function r111_preflight()
    hashes = r111_hashes()
    r111_table_check()
    r111_containment_check()
    expected = r111_geometric_character()
    p = r111_parent()
    r111_note("No. 18 cache, strict No. 111 edge, and geometric character passed")
    r111_note("Source hashes: $hashes")
    return p,expected,hashes
end

# Element (n,k) means n*f^k, 1 <= n <= 72 and 0 <= k < 3. The saved
# 19-dimensional N action supplies exact multiplication; its unique lift
# fixing the parent's T supplies the corresponding rank-22 matrices.
function r111_context(p)
    nctx = direct_context(p.cache.symplectic_generators_S,
        p.cache.extra_generator_S,72,3)
    idx(n,k) = 72*k+n
    e = identity_matrix(QQ,22)
    nL = [foldl(*,(p.cache.symplectic_generators[j] for j in nctx.words[n]);
        init=e) for n in 1:72]
    @assert length(Set(direct_matrix_key(x) for x in nL)) == 72
    @assert all(nctx.elements[n]*p.embedding == p.embedding*nL[n] for n in 1:72)
    @assert all(p.tcoordinates*nL[n] == p.tcoordinates for n in 1:72)
    f = p.cache.extra_generator
    @assert f^3 == nL[nctx.c]
    @assert all(f*nL[n]*inv(f) == nL[nctx.phi[n]] for n in 1:72)
    fpowers = [f^k for k in 0:2]
    elements = [nL[n]*fpowers[k+1] for k in 0:2 for n in 1:72]
    @assert length(Set(direct_matrix_key(x) for x in elements)) == 216
    phi = [collect(1:72)]
    for _ in 1:2
        push!(phi,[nctx.phi[phi[end][n]] for n in 1:72])
    end
    mul = zeros(Int,216,216)
    for i in 1:216, j in 1:216
        n,k = mod1(i,72),div(i-1,72)
        m,l = mod1(j,72),div(j-1,72)
        a = nctx.mul(n,phi[k+1][m])
        k+l >= 3 && (a = nctx.mul(a,nctx.c))
        mul[i,j] = idx(a,mod(k+l,3))
    end
    @assert all(mul[1,i] == i && mul[i,1] == i for i in 1:216)
    inverse = [only(j for j in 1:216 if mul[i,j] == 1 && mul[j,i] == 1)
        for i in 1:216]
    orders = Int[]
    for i in 1:216
        x = 1; ord = 0
        while true
            x = mul[x,i]; ord += 1
            x == 1 && break
            ord <= 216 || error("Finite table has no element order")
        end
        push!(orders,ord)
    end
    generators = [nctx.generator_ids; idx(1,1)]
    @assert all(elements[mul[i,g]] == elements[i]*elements[g]
        for i in 1:216 for g in generators)
    ctx = (;p,nctx,elements,mul,inverse,orders,generators,idx)
    @assert r111_group_id(ctx,Tuple(1:216),generators) == (216,153)
    return ctx
end

function r111_subgroup(ctx,gens)
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

function r111_group_id(ctx,key,gens)
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

function r111_histogram(ctx,key)
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

# Any B with B intersect N = A of order three and B/A = C3 has one lift
# above fN. Testing every A < N and every one of the 72 lifts is exhaustive.
function r111_raw(ctx)
    subgroups_A = Dict{Any,Int}()
    for a in 1:72
        ctx.orders[a] == 3 || continue
        A = r111_subgroup(ctx,[a])
        length(A) == 3 && all(i <= 72 for i in A) ||
            error("Invalid C3 subgroup of the symplectic kernel")
        get!(subgroups_A,A,a)
    end
    isempty(subgroups_A) && error("No C3 in the saved No. 18 kernel")
    raw = Dict{Any,Tuple{Int,Int}}()
    for (A,a) in subgroups_A, n in 1:72
        b = ctx.idx(n,1)
        ctx.mul[ctx.mul[b,b],b] in A || continue
        all(ctx.mul[ctx.mul[b,x],ctx.inverse[b]] in A for x in A) || continue
        key = r111_subgroup(ctx,[a,b])
        length(key) == 9 || error("Normalized C3 lift did not form order nine")
        Tuple(i for i in key if i <= 72) == A ||
            error("Wrong symplectic intersection")
        Set(div(i-1,72) for i in key) == Set(0:2) ||
            error("Wrong cyclic quotient")
        get!(raw,key,(a,b))
    end
    isempty(raw) && error("No C3-by-C3 subgroup in the saved No. 18 action")
    return raw,length(subgroups_A)
end

function r111_classes(ctx,raw)
    unseen = Set(keys(raw)); classes = NamedTuple[]
    while !isempty(unseen)
        first_key = first(sort!(collect(unseen)))
        orbit = Set([first_key]); todo = [first_key]; head = 1
        while head <= length(todo)
            key = todo[head]
            for g in ctx.generators
                next_key = Tuple(sort!([ctx.mul[ctx.mul[g,x],ctx.inverse[g]]
                    for x in key]))
                haskey(raw,next_key) ||
                    error("Eligible subgroups are not parent-conjugacy stable")
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

function r111_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    p,expected,hashes = r111_preflight()
    ctx = r111_context(p)
    raw,n_C3 = r111_raw(ctx)
    eligible = Dict(key => gens for (key,gens) in raw if
        r111_group_id(ctx,key,gens) == (9,2))
    isempty(eligible) && error("No subgroup of abstract type [9,2]")
    classes = r111_classes(ctx,eligible)
    candidates = NamedTuple[]; matched = 0
    for (class_number,c) in enumerate(classes)
        a,b = eligible[c.key]
        h = r111_histogram(ctx,c.key)
        is_match = h == expected
        matched += is_match
        push!(candidates,(child_number=111,parent_number=18,
            class_number=class_number,parent_conjugacy_orbit_size=c.orbit_size,
            subgroup_indices=c.key,subgroup_id=(9,2),
            symplectic_generator_index=a,extra_generator_index=b,
            symplectic_generator=ctx.elements[a],
            extra_generator=ctx.elements[b],
            primitive_character_histogram=h,geometric_character_match=is_match))
        r111_note("No. 111 class $class_number: orbit $(c.orbit_size), character match=$is_match")
    end
    matched > 0 || error("No No. 18 class matches the No. 111 character")
    save(output,(format_version=1,source_hashes=hashes,
        method="all C3 subgroups of M9 and all 72 quotient-generator lifts; exact closure and full parent conjugacy",
        parent_number=18,parent_group_order=216,
        complete_within_saved_parent=true,numbered_assignment_claimed=false,
        c3_subgroups=n_C3,raw_subgroups=length(raw),
        abstract_subgroups=length(eligible),parent_conjugacy_classes=length(classes),
        character_matches=matched,candidates=Tuple(candidates),
        lattice_and_root_checks_done=false))
    check = load(output)
    @assert check.source_hashes == hashes && length(check.candidates) == length(candidates)
    r111_note("Saved and reloaded $output")
end

function r111_lattices(output,groups_path,selected)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path)
    @assert groups.format_version == 1 && groups.source_hashes == r111_hashes()
    p = r111_parent()
    summaries = NamedTuple[]; results = NamedTuple[]
    for c in groups.candidates
        c.geometric_character_match || continue
        selected !== nothing && c.class_number != selected && continue
        sym = integer_lattice_with_isometry(p.L,c.symplectic_generator;
            ambient_representation=false,check=true)
        S = lattice(coinvariant_lattice(sym))
        T = lattice(invariant_lattice(sym))
        index = 0; dimension = -1; rank_P = 0; rank_K = 0; reason = ""
        if rank(S) != 12 || rank(T) != 10
            reason = "symplectic coinvariant rank mismatch"
        elseif signature_tuple(S) != (12,0,0) ||
               signature_tuple(T) != (8,0,2)
            reason = "symplectic lattice signature mismatch"
        else
            Lf = integer_lattice_with_isometry(p.L,c.extra_generator;
                ambient_representation=false,check=true)
            @assert trivial_action_on_discriminant(Lf)
            Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
            index = Int(order_of_isometry(full_rank_model(Timg)))
            if index != 3
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
                    dimension == 3 || (reason = "period dimension mismatch")
                end
            end
        end
        push!(summaries,(child_number=111,class_number=c.class_number,
            rank_S=rank(S),rank_T=rank(T),rank_P=rank_P,rank_K=rank_K,
            index=index,dimension=dimension,matched=isempty(reason),reason=reason))
        r111_note("No. 111 class $(c.class_number): S=$(rank(S)), P=$rank_P, dim=$dimension, reason=$reason")
        isempty(reason) || continue
        result = complete_cyclic_restriction(p.parent,
            c.symplectic_generator,c.extra_generator;
            child_number=111,parent_number=18,index=3,
            expected_rank_S=12,expected_dimension=3,
            expected_group_id=(9,2),verify_group_id=false,
            verify_roots=false,verify_symplectic_saturation=false)
        push!(results,(child_number=111,class_number=c.class_number,result=result))
    end
    isempty(results) && error("No selected No. 111 class passed lattice filters")
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=r111_hash(groups_path),
        summaries=Tuple(summaries),results=Tuple(results),
        target_numbers=[111],match_counts=[length(results)],
        selected_class=selected,complete_lattice_pass=(selected === nothing),
        roots_verified=false,symplectic_saturation_verified=false,
        numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert length(check.results) == length(results)
    r111_note("Saved and reloaded $output; lattice matches=$(length(results))")
end

function r111_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path); data = load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.source_hashes == data.source_hashes == r111_hashes()
    @assert data.groups_file_hash == r111_hash(groups_path)
    @assert data.complete_lattice_pass == (data.selected_class === nothing)
    isempty(data.results) && error("No lattice matches to verify")
    p = r111_parent(); ctx = r111_context(p)
    expected = r111_geometric_character()
    verified = NamedTuple[]; root_obstructed = NamedTuple[]
    for r in data.results
        c = only(x for x in groups.candidates if x.child_number == 111 &&
            x.class_number == r.class_number)
        key = r111_subgroup(ctx,
            [c.symplectic_generator_index,c.extra_generator_index])
        @assert key == c.subgroup_indices
        @assert r111_group_id(ctx,key,
            [c.symplectic_generator_index,c.extra_generator_index]) == (9,2)
        @assert Tuple(i for i in key if i <= 72) ==
            r111_subgroup(ctx,[c.symplectic_generator_index])
        @assert r111_histogram(ctx,key) ==
            c.primitive_character_histogram == expected
        result = complete_cyclic_restriction(p.parent,
            c.symplectic_generator,c.extra_generator;
            child_number=111,parent_number=18,index=3,
            expected_rank_S=12,expected_dimension=3,
            expected_group_id=(9,2),verify_group_id=false,
            verify_roots=false,verify_symplectic_saturation=false)
        @assert gram_matrix(lattice(result.S_in_Lambda0)) ==
            gram_matrix(lattice(r.result.S_in_Lambda0))
        @assert gram_matrix(lattice(result.T_in_Lambda0)) ==
            gram_matrix(lattice(r.result.T_in_Lambda0))
        @assert gram_matrix(result.P_in_Lambda0) == gram_matrix(r.result.P_in_Lambda0)
        @assert gram_matrix(result.K_in_Lambda0) == gram_matrix(r.result.K_in_Lambda0)
        @assert isometry(result.T_action) == isometry(r.result.T_action)
        if has_root(result.K_in_Lambda0,p.L)
            push!(root_obstructed,(child_number=111,parent_number=18,
                class_number=c.class_number,subgroup_id=(9,2)))
            r111_note("No. 111 class $(c.class_number): root obstruction")
            continue
        end
        push!(verified,(child_number=111,parent_number=18,
            class_number=c.class_number,subgroup_id=(9,2),
            roots_verified=true,result=result))
        r111_note("No. 111 class $(c.class_number): subgroup, lattice and roots verified")
    end
    @assert length(verified)+length(root_obstructed) == data.match_counts[1]
    verified_saved = isempty(verified) ? String[] : Tuple(verified)
    obstructed_saved = isempty(root_obstructed) ? String[] : Tuple(root_obstructed)
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=r111_hash(groups_path),
        lattices_file_hash=r111_hash(lattices_path),
        verified_results=verified_saved,root_obstructed=obstructed_saved,
        target_numbers=[111],match_counts=[length(verified)],
        root_obstructed_counts=[length(root_obstructed)],
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
    r111_note("Saved and reloaded $output; root-free=$(length(verified)), obstructed=$(length(root_obstructed))")
end

function r111_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices or verify")
    stage = ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no arguments")
        r111_preflight()
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        r111_groups(length(ARGS) == 2 ? abspath(ARGS[2]) : r111_groups_file)
    elseif stage == "lattices"
        length(ARGS) <= 4 || error("lattices [output.mrdi] [groups.mrdi] [class]")
        selected = length(ARGS) == 4 ? parse(Int,ARGS[4]) : nothing
        r111_lattices(length(ARGS) >= 2 ? abspath(ARGS[2]) : r111_lattices_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : r111_groups_file, selected)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        r111_verify(length(ARGS) >= 2 ? abspath(ARGS[2]) : r111_verified_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : r111_lattices_file,
            length(ARGS) == 4 ? abspath(ARGS[4]) : r111_groups_file)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    r111_main()
end
