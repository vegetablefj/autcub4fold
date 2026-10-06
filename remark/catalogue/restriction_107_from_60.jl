# Strict No. 107 inside the saved full No. 60 integral action.
# Run the GAP character script first, then preflight, groups, lattices, verify.
# The search is exhaustive only inside this saved No. 60 parent.

using SHA
include(joinpath(@__DIR__, "prepare_no60_full_lattice_group.jl"))
include(joinpath(@__DIR__, "restriction_functions.jl"))

const r107_spec = (number=107,parent=60,rank_S=12,sym_order=3,
    generic_index=1,index=2,dimension=4,group_id=(6,1))
const r107_table = joinpath(@__DIR__, "..", "input", "family_numbering.md")
const r107_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_all_pairs.tsv")
const r107_frozen_groups = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const r107_frozen_witnesses = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result",
    "gap_fourfold_cross_dimension_positive_edges.g")
const r107_character_script = joinpath(@__DIR__, "restriction_107_geometric_character.g")
const r107_character_file = joinpath(@__DIR__, "restriction_107_geometric_character.tsv")
const r107_groups_file = joinpath(@__DIR__, "restriction_107_from_60.groups.mrdi")
const r107_lattices_file = joinpath(@__DIR__, "restriction_107_from_60.lattices.mrdi")
const r107_verified_file = joinpath(@__DIR__, "restriction_107_from_60.verified.mrdi")

r107_note(s) = (println(s); flush(stdout))
r107_hash(path) = bytes2hex(sha256(read(path)))

function r107_hashes()
    paths = (no60_cache,no60_source,r107_table,r107_edges,r107_frozen_groups,
        r107_frozen_witnesses,r107_character_script,r107_character_file,
        joinpath(@__DIR__, "restriction_107_from_60.jl"),
        joinpath(@__DIR__, "prepare_no60_full_lattice_group.jl"),
        joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"),
        joinpath(@__DIR__, "restriction_functions.jl"),
        joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl"))
    all(isfile,paths) || error("A source is missing; run restriction_107_geometric_character.g first")
    return Tuple((basename(p),r107_hash(p)) for p in paths)
end

function r107_numbering_and_edge_checks()
    expected = Dict(60 => (16,"D_12",1,2,2,(24,14)),
                    107 => (12,"C3",1,2,4,(6,1)))
    found = Dict{Int,Tuple}()
    for line in eachline(r107_table)
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
    found == expected || error("No. 60/107 numbered data changed")

    count = 0
    for (line_number,line) in enumerate(eachline(r107_edges))
        line_number == 1 && continue
        v = split(line,'\t')
        length(v) == 12 || error("Malformed strict-containment row $line_number")
        parse(Int,v[1]) == 107 && parse(Int,v[2]) == 60 || continue
        Tuple(parse.(Int,v[3:6])) == (4,2,18,72) ||
            error("Wrong No. 107 -> No. 60 edge metadata")
        v[7:11] == ["embedded","direct","true","fail","found"] ||
            error("No. 107 -> No. 60 edge is not direct and strict")
        v[12] in ("literal_matrix_subgroup","A_strict") ||
            error("Unexpected strict containment method")
        count += 1
    end
    count == 1 || error("Expected exactly one direct strict No. 107 -> No. 60 edge")
end

function r107_geometric_character()
    h = Dict{Tuple{Int,Int},Int}()
    for (line_number,line) in enumerate(eachline(r107_character_file))
        if line_number == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric-character header")
            continue
        end
        isempty(strip(line)) && continue
        v = split(line,'\t')
        length(v) == 4 || error("Malformed character row $line_number")
        n,ord,tr,count = parse.(Int,v)
        n == 107 && 1 <= ord <= 6 && -22 <= tr <= 22 && count > 0 ||
            error("Unexpected character row $line_number")
        key = (ord,tr)
        haskey(h,key) && error("Duplicate geometric-character bin")
        h[key] = count
    end
    sum(values(h)) == 6 && get(h,(1,22),0) == 1 ||
        error("Incomplete No. 107 projective character")
    return h
end

function r107_parent()
    cache = no60_verify_cache()
    source = load(no60_source)
    parent = source.cases[24].results[1]
    @assert parent.order == 2 && parent.dimension == 2
    @assert parent.group_gap_id == (24,14)
    @assert cache.parent_number == 60 && cache.symplectic_order == 12
    @assert cache.quotient_order == 2 && cache.full_group_order == 24
    @assert rank(lattice(parent.Lambda0)) == 22
    @assert rank(lattice(parent.S_in_Lambda0)) == 16
    @assert rank(lattice(parent.T_in_Lambda0)) == 6
    @assert isometry(cache.Lambda0) == isometry(parent.Lambda0)
    @assert order_of_isometry(parent.T_action) == 2
    return parent,cache
end

function r107_preflight()
    hashes = r107_hashes()
    r107_numbering_and_edge_checks()
    expected = r107_geometric_character()
    parent,cache = r107_parent()
    r107_note("PASS: No. 107 numbered data, direct strict edge, six-element character")
    r107_note("PASS: saved No. 60 kernel order 12, quotient order 2, full order 24")
    r107_note("Source SHA-256 hashes: $hashes")
    return parent,cache,expected,hashes
end

# Index 12*k+n denotes n*f^k.  Build the exact 22-dimensional matrices and
# their full multiplication table; no large ambient matrix-group search occurs.
function r107_context(cache)
    nctx = direct_context(cache.symplectic_generators_S,
        cache.extra_generator_S,12,2)
    oneL = identity_matrix(QQ,22)
    nL = [foldl(*,(cache.symplectic_generators[j] for j in nctx.words[n]);
            init=oneL) for n in 1:12]
    f = cache.extra_generator
    elements = [nL[n]*f^k for k in 0:1 for n in 1:12]
    positions = Dict(direct_matrix_key(x)=>i for (i,x) in enumerate(elements))
    length(positions) == 24 || error("No. 60 rank-22 action has fewer than 24 elements")
    mul = zeros(Int,24,24)
    for i in 1:24, j in 1:24
        mul[i,j] = get(positions,direct_matrix_key(elements[i]*elements[j]),0)
        mul[i,j] > 0 || error("Saved No. 60 matrices are not closed")
    end
    @assert all(mul[1,i] == i && mul[i,1] == i for i in 1:24)
    inverse = [only(j for j in 1:24 if mul[i,j] == 1 && mul[j,i] == 1)
        for i in 1:24]
    @assert all(mul[mul[i,j],k] == mul[i,mul[j,k]]
        for i in 1:24 for j in 1:24 for k in 1:24)
    orders = Int[]
    for i in 1:24
        x = 1; ord = 0
        while true
            x = mul[x,i]; ord += 1
            x == 1 && break
            ord <= 24 || error("Element order exceeds parent order")
        end
        push!(orders,ord)
    end
    generators = unique([nctx.generator_ids; 13])
    E = basis_matrix(lattice(cache.S_in_Lambda0))*
        inv(basis_matrix(lattice(cache.Lambda0)))
    @assert all(nctx.elements[n]*E == E*nL[n] for n in 1:12)
    @assert f^2 == nL[nctx.c]
    ctx = (;elements,mul,inverse,orders,generators,nctx)
    @assert r107_group_id(ctx,Tuple(1:24),generators) == (24,14)
    return ctx
end

function r107_subgroup(ctx,gens)
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

function r107_group_id(ctx,key,gens)
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

function r107_histogram(ctx,key)
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

function r107_raw(ctx)
    raw = Dict{Any,Tuple{Int,Int}}()
    # Every target B has A=B intersect N=C3 and B/A=C2.  Test both
    # generators of each C3 and all twelve lifts in the nontrivial coset.
    for t in 2:12
        ctx.orders[t] == 3 || continue
        kernel = r107_subgroup(ctx,[t])
        @assert length(kernel) == 3 && all(i <= 12 for i in kernel)
        for b in 13:24
            key = r107_subgroup(ctx,[t,b])
            length(key) == 6 || continue
            Tuple(i for i in key if i <= 12) == kernel || continue
            r107_group_id(ctx,key,[t,b]) == (6,1) || continue
            get!(raw,key,(t,b))
        end
    end
    isempty(raw) && error("No eligible [6,1] subgroup in saved No. 60")
    return raw
end

function r107_classes(ctx,raw)
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
    length(classes) == 2 || error("Expected two nonconjugate [6,1] classes in saved No. 60")
    return classes
end

function r107_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    _,cache,expected,hashes = r107_preflight()
    ctx = r107_context(cache)
    raw = r107_raw(ctx)
    classes = r107_classes(ctx,raw)
    candidates = NamedTuple[]
    for (class_number,c) in enumerate(classes)
        t,b = raw[c.key]
        h = r107_histogram(ctx,c.key)
        match = h == expected
        push!(candidates,(child_number=107,parent_number=60,
            class_number=class_number,parent_conjugacy_orbit_size=c.orbit_size,
            subgroup_indices=c.key,subgroup_id=(6,1),
            symplectic_generator_index=t,extra_generator_index=b,
            symplectic_generator=ctx.elements[t],extra_generator=ctx.elements[b],
            primitive_character_histogram=h,geometric_character_match=match))
        r107_note("[6,1] class $class_number: orbit $(c.orbit_size), character=$h, match=$match")
    end
    count(c->c.geometric_character_match,candidates) > 0 ||
        error("Neither [6,1] parent class matches No. 107 geometric character")
    save(output,(format_version=1,source_hashes=hashes,
        method="all C3 kernels and outer-coset lifts; exact closure and full-parent conjugacy",
        parent_number=60,child_number=107,parent_group_order=24,
        complete_within_saved_parent=true,raw_subgroups=length(raw),
        parent_conjugacy_classes=length(classes),
        character_matches=count(c->c.geometric_character_match,candidates),
        candidates=Tuple(candidates),lattice_and_root_checks_done=false,
        global_uniqueness_claimed=false))
    check = load(output)
    @assert check.source_hashes == hashes && length(check.candidates) == 2
    r107_note("Saved and reloaded $output")
end

function r107_lattices(output,groups_path,selected_class)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path)
    @assert groups.format_version == 1 && groups.parent_number == 60
    @assert groups.child_number == 107 && groups.complete_within_saved_parent
    @assert groups.source_hashes == r107_hashes()
    parent,_ = r107_parent()
    L = lattice(parent.Lambda0)
    summaries = NamedTuple[]; results = NamedTuple[]
    for c in groups.candidates
        c.geometric_character_match || continue
        selected_class !== nothing && c.class_number != selected_class && continue
        sym = integer_lattice_with_isometry(L,c.symplectic_generator;
            ambient_representation=false,check=true)
        S = lattice(coinvariant_lattice(sym))
        T = lattice(invariant_lattice(sym))
        index = 0; dimension = -1; rank_P = 0; rank_K = 0
        reason = ""
        if rank(S) != 12 || rank(T) != 10
            reason = "symplectic coinvariant rank mismatch"
        else
            Lf = integer_lattice_with_isometry(L,c.extra_generator;
                ambient_representation=false,check=true)
            @assert trivial_action_on_discriminant(Lf)
            Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
            index = Int(order_of_isometry(full_rank_model(Timg)))
            if index != 2
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
                end
            end
        end
        matched = isempty(reason) && dimension == 4
        isempty(reason) && !matched && (reason = "period dimension mismatch")
        push!(summaries,(class_number=c.class_number,rank_S=rank(S),rank_T=rank(T),
            rank_P=rank_P,rank_K=rank_K,index=index,dimension=dimension,
            matched=matched,reason=reason))
        r107_note("Class $(c.class_number): S=$(rank(S)), P=$rank_P, dimension=$dimension, match=$matched")
        matched || continue
        result = complete_cyclic_restriction(parent,
            c.symplectic_generator,c.extra_generator;
            child_number=107,parent_number=60,index=2,
            expected_rank_S=12,expected_dimension=4,
            expected_group_id=(6,1),verify_group_id=false,
            verify_roots=false,verify_symplectic_saturation=false)
        push!(results,(class_number=c.class_number,result=result))
    end
    isempty(summaries) && error("No character-matching class was selected")
    isempty(results) && error("No selected class passed the lattice filters")
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=r107_hash(groups_path),selected_class=selected_class,
        summaries=Tuple(summaries),results=Tuple(results),
        lattice_match_count=length(results),roots_verified=false,
        all_character_matches_processed=selected_class === nothing,
        symplectic_saturation_verified=false,global_uniqueness_claimed=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert length(check.results) == length(results)
    r107_note("Saved and reloaded $output; lattice matches=$(length(results))")
end

function r107_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path); data = load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.parent_number == 60 && data.lattice_match_count > 0
    @assert groups.source_hashes == data.source_hashes == r107_hashes()
    @assert data.groups_file_hash == r107_hash(groups_path)
    parent,cache,expected,_ = r107_preflight()
    ctx = r107_context(cache)
    verified = NamedTuple[]; root_obstructed = String[]
    for r in data.results
        c = only(x for x in groups.candidates if x.class_number == r.class_number)
        key = r107_subgroup(ctx,[c.symplectic_generator_index,
                                  c.extra_generator_index])
        @assert key == c.subgroup_indices
        @assert r107_group_id(ctx,key,[c.symplectic_generator_index,
                                       c.extra_generator_index]) == (6,1)
        @assert Tuple(i for i in key if i <= 12) ==
            r107_subgroup(ctx,[c.symplectic_generator_index])
        @assert r107_histogram(ctx,key) == c.primitive_character_histogram == expected
        @assert ctx.elements[c.symplectic_generator_index] == c.symplectic_generator
        @assert ctx.elements[c.extra_generator_index] == c.extra_generator
        if has_root(r.result.K_in_Lambda0,lattice(parent.Lambda0))
            push!(root_obstructed,string(c.class_number))
            r107_note("Class $(c.class_number): root-obstructed")
            continue
        end
        fresh = complete_cyclic_restriction(parent,
            c.symplectic_generator,c.extra_generator;
            child_number=107,parent_number=60,index=2,
            expected_rank_S=12,expected_dimension=4,
            expected_group_id=(6,1),verify_group_id=false,
            verify_roots=true,verify_symplectic_saturation=false)
        @assert basis_matrix(lattice(fresh.S_in_Lambda0)) ==
            basis_matrix(lattice(r.result.S_in_Lambda0))
        @assert basis_matrix(lattice(fresh.T_in_Lambda0)) ==
            basis_matrix(lattice(r.result.T_in_Lambda0))
        @assert basis_matrix(fresh.P_in_Lambda0) == basis_matrix(r.result.P_in_Lambda0)
        @assert basis_matrix(fresh.K_in_Lambda0) == basis_matrix(r.result.K_in_Lambda0)
        @assert isometry(fresh.Lambda0) == isometry(r.result.Lambda0)
        @assert isometry(fresh.T_action) == isometry(r.result.T_action)
        push!(verified,(class_number=c.class_number,roots_verified=true,result=fresh))
        r107_note("Class $(c.class_number): subgroup, lattice and roots verified")
    end
    @assert length(verified)+length(root_obstructed) == data.lattice_match_count
    # OSCAR serialization needs a typed empty collection when no class survives.
    verified_data = isempty(verified) ? String[] : Tuple(verified)
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=r107_hash(groups_path),
        lattices_file_hash=r107_hash(lattices_path),
        verified_results=verified_data,root_obstructed_classes=root_obstructed,
        lattice_match_count=data.lattice_match_count,
        root_free_count=length(verified),roots_verified=true,
        symplectic_saturation_verified=false,
        group_enumeration_complete_within_saved_parent=true,
        all_character_matches_processed=data.all_character_matches_processed,
        global_uniqueness_claimed=false))
    check = load(output)
    @assert check.source_hashes == data.source_hashes
    @assert length(check.verified_results) == length(verified)
    r107_note("Saved and reloaded $output; root-free classes=$(length(verified))")
end

function r107_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices, or verify")
    stage = ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no extra argument")
        r107_preflight()
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        r107_groups(length(ARGS)==2 ? abspath(ARGS[2]) : r107_groups_file)
    elseif stage == "lattices"
        length(ARGS) <= 4 || error("lattices [output.mrdi] [groups.mrdi] [class]")
        selected = length(ARGS)==4 ? parse(Int,ARGS[4]) : nothing
        selected === nothing || selected > 0 || error("Class must be positive")
        r107_lattices(length(ARGS)>=2 ? abspath(ARGS[2]) : r107_lattices_file,
            length(ARGS)>=3 ? abspath(ARGS[3]) : r107_groups_file,selected)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        r107_verify(length(ARGS)>=2 ? abspath(ARGS[2]) : r107_verified_file,
            length(ARGS)>=3 ? abspath(ARGS[3]) : r107_lattices_file,
            length(ARGS)==4 ? abspath(ARGS[4]) : r107_groups_file)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    r107_main()
end
