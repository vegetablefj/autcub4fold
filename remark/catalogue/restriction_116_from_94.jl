# Exhaustive No. 116 restrictions of the saved, assigned integral No. 94 action.
# Run the companion GAP script, then preflight, groups, lattices, verify.
# This script does not edit the numbered lattice catalogue.

using SHA
include(joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))
include(joinpath(@__DIR__, "restriction_functions.jl"))

const r116_parent_file = joinpath(@__DIR__,
    "restriction_candidates_94_95_from_24.direct_lattices.mrdi")
const r116_table = joinpath(@__DIR__, "..", "input",
    "family_numbering.md")
const r116_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result",
    "gap_fourfold_cross_dimension_all_pairs.tsv")
const r116_frozen_groups = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const r116_frozen_witnesses = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result",
    "gap_fourfold_cross_dimension_positive_edges.g")
const r116_characters = joinpath(@__DIR__,
    "restriction_116_geometric_character.tsv")
const r116_character_script = joinpath(@__DIR__,
    "restriction_116_geometric_character.g")
const r116_groups_file = joinpath(@__DIR__, "restriction_116_from_94.groups.mrdi")
const r116_lattices_file = joinpath(@__DIR__, "restriction_116_from_94.lattices.mrdi")
const r116_verified_file = joinpath(@__DIR__, "restriction_116_from_94.verified.mrdi")

const r116_spec = (number=116,rank_S=12,sym_order=3,generic_index=2,
    group_id=(18,3),index=6,dimension=4)

r116_note(s) = (println(s); flush(stdout))
r116_hash(path) = bytes2hex(sha256(read(path)))

function r116_hashes()
    paths = (r116_parent_file,r116_table,r116_edges,r116_frozen_groups,
        r116_frozen_witnesses,r116_characters,r116_character_script,
        joinpath(@__DIR__, "restriction_116_from_94.jl"),
        joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"),
        joinpath(@__DIR__, "restriction_functions.jl"),
        joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl"))
    all(isfile,paths) || error("A source is missing; run the companion GAP script first")
    return Tuple((basename(p),r116_hash(p)) for p in paths)
end

function r116_table_checks()
    expected = Dict(
        94 => (14,"S3",2,12,1,(72,27)),
        116 => (12,"C3",2,6,4,(18,3)),
    )
    found = Dict{Int,Tuple}()
    for line in eachline(r116_table)
        startswith(line,"|") || continue
        cells = strip.(split(line,'|'))
        length(cells) >= 9 || continue
        n = tryparse(Int,cells[2])
        n === nothing && continue
        haskey(expected,n) || continue
        haskey(found,n) && error("Duplicate numbered row $n")
        m = match(r"\[(\d+),(\d+)\]",cells[8])
        m === nothing && error("Missing group ID for numbered row $n")
        found[n] = (parse(Int,cells[3]),replace(cells[4],"`"=>""),
            parse(Int,cells[5]),parse(Int,cells[6]),parse(Int,cells[7]),
            (parse(Int,m.captures[1]),parse(Int,m.captures[2])))
    end
    found == expected || error("Numbered group/rank/index/dimension data changed")
end

function r116_strict_checks()
    count = 0
    for (line_number,line) in enumerate(eachline(r116_edges))
        line_number == 1 && continue
        v = split(line,'\t')
        length(v) == 12 || error("Malformed strict-containment row $line_number")
        parse(Int,v[1]) == 116 && parse(Int,v[2]) == 94 || continue
        Tuple(parse.(Int,v[3:6])) == (4,1,54,216) ||
            error("Wrong No. 116 -> No. 94 containment metadata")
        v[7:10] == ["embedded","direct","true","fail"] ||
            error("No. 116 -> No. 94 is not direct and strict")
        v[12] in ("literal_matrix_subgroup","A_strict") ||
            error("Unexpected No. 116 containment method")
        count += 1
    end
    count == 1 || error("A unique direct strict containment is missing")
end

function r116_geometric_character()
    h = Dict{Tuple{Int,Int},Int}()
    for (i,line) in enumerate(eachline(r116_characters))
        if i == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric character header")
            continue
        end
        isempty(strip(line)) && continue
        v = split(line,'\t')
        length(v) == 4 || error("Malformed geometric character line $i")
        n,ord,tr,count = parse.(Int,v)
        n == 116 && count > 0 && 1 <= ord <= 18 && -22 <= tr <= 22 ||
            error("Unexpected geometric character line $i")
        key = (ord,tr)
        haskey(h,key) && error("Duplicate geometric character bin")
        h[key] = count
    end
    sum(values(h)) == 18 && get(h,(1,22),0) == 1 ||
        error("Incomplete No. 116 geometric character")
    return h
end

function r116_parent()
    cache = load(r116_parent_file)
    @assert cache.format_version == 1 && cache.parent_number == 24
    @assert cache.character_assignment_verified
    @assert cache.assigned_class_94 != cache.assigned_class_95
    parent = only(r for r in cache.results if
        r.class_number == cache.assigned_class_94 && r.character_matches == [94])
    @assert parent.abstract_projective_group_id == (72,27)
    @assert parent.symplectic_intersection_id == (6,1)
    @assert parent.order == 12 && parent.dimension == 1
    # This is the No. 94 record; No. 95 has a different saved extra action.
    @assert length(parent.symplectic_generators_in_parent) == 2
    L = lattice(parent.Lambda0)
    T = lattice(parent.T_in_Lambda0)
    @assert rank(L) == 22 && rank(T) == 8
    @assert rank(lattice(parent.S_in_Lambda0)) == 14
    @assert signature_tuple(L) == (20,0,2) && abs(det(gram_matrix(L))) == 3
    @assert isometry(parent.Lambda0) == parent.extra_generator_in_parent
    @assert order_of_isometry(parent.T_action) == 12
    eT = basis_matrix(T)*inv(basis_matrix(L))
    @assert all(eT*g == eT for g in parent.symplectic_generators_in_parent)
    return parent
end

# Index 6k+n represents n*f^k, with n in the No. 94 normal S3.
function r116_context(parent)
    f = parent.extra_generator_in_parent
    nctx = direct_context(parent.symplectic_generators_in_parent,f,6,12)
    @assert sort(nctx.orders) == [1,2,2,2,3,3]
    idx(n,k) = 6*k+n
    fpowers = [f^k for k in 0:11]
    elements = [nctx.elements[n]*fpowers[k+1] for k in 0:11 for n in 1:6]
    @assert length(elements) == 72
    @assert length(Set(direct_matrix_key(x) for x in elements)) == 72
    phi_power(n,k) = foldl((x,_) -> nctx.phi[x],1:k;init=n)
    mul = zeros(Int,72,72)
    for i in 1:72, j in 1:72
        n,k = mod1(i,6),div(i-1,6)
        m,l = mod1(j,6),div(j-1,6)
        a = nctx.mul(n,phi_power(m,k))
        k+l >= 12 && (a = nctx.mul(a,nctx.c))
        mul[i,j] = idx(a,mod(k+l,12))
    end
    @assert all(mul[1,i] == i && mul[i,1] == i for i in 1:72)
    inverse = [only(j for j in 1:72 if mul[i,j] == 1 && mul[j,i] == 1)
        for i in 1:72]
    @assert all(mul[mul[i,j],k] == mul[i,mul[j,k]]
        for i in 1:72 for j in 1:72 for k in 1:72)
    orders = Int[]
    for i in 1:72
        x = 1; ord = 0
        while true
            x = mul[x,i]; ord += 1
            x == 1 && break
            ord <= 72 || error("Finite multiplication table has no order")
        end
        push!(orders,ord)
    end
    generators = [nctx.generator_ids; idx(1,1)]
    @assert all(elements[mul[i,g]] == elements[i]*elements[g]
        for i in 1:72 for g in generators)
    @assert all(elements[i]*elements[inverse[i]] == elements[1] for i in 1:72)
    return (;parent,nctx,f,elements,mul,inverse,orders,generators,idx)
end

function r116_subgroup(ctx,generators)
    seen = Set([1]); todo = [1]; head = 1
    symmetric = [generators; [ctx.inverse[g] for g in generators]]
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

function r116_group_id(ctx,key,gens)
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

function r116_histogram(ctx,key)
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

function r116_raw(ctx)
    raw = Dict{Any,Tuple{Int,Int}}()
    # Every eligible B has A=B intersect S3=C3 and B/A=C6. A lift of a
    # fixed generator of C6 lies over f^2*N. Include all six such lifts.
    for t in 2:6
        ctx.orders[t] == 3 || continue
        kernel = r116_subgroup(ctx,[t])
        @assert length(kernel) == 3 && all(i <= 6 for i in kernel)
        for b in 1:72
            div(b-1,6) == 2 || continue
            key = r116_subgroup(ctx,[t,b])
            length(key) == 18 || continue
            Tuple(i for i in key if i <= 6) == kernel || continue
            r116_group_id(ctx,key,[t,b]) == (18,3) || continue
            get!(raw,key,(t,b))
        end
    end
    isempty(raw) && error("No subgroup of type [18,3] inside saved No. 94")
    return raw
end

function r116_classes(ctx,raw)
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

function r116_preflight()
    hashes = r116_hashes()
    r116_table_checks(); r116_strict_checks()
    expected = r116_geometric_character()
    parent = r116_parent()
    r116_note("No. 94 saved action and No. 116 frozen character passed")
    r116_note("Source SHA-256 hashes: $hashes")
    return parent,expected,hashes
end

function r116_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    parent,expected,hashes = r116_preflight()
    ctx = r116_context(parent)
    raw = r116_raw(ctx)
    classes = r116_classes(ctx,raw)
    candidates = NamedTuple[]; matched = 0
    for (class_number,c) in enumerate(classes)
        sym,b = raw[c.key]
        h = r116_histogram(ctx,c.key)
        is_match = h == expected
        matched += is_match
        push!(candidates,(child_number=116,parent_number=94,
            class_number=class_number,parent_conjugacy_orbit_size=c.orbit_size,
            subgroup_indices=c.key,subgroup_id=(18,3),
            symplectic_generator_index=sym,extra_generator_index=b,
            symplectic_generator=ctx.elements[sym],
            extra_generator=ctx.elements[b],
            primitive_character_histogram=h,geometric_character_match=is_match))
        r116_note("No. 116 class $class_number: orbit $(c.orbit_size), character match=$is_match")
    end
    matched > 0 || error("No parent class matches No. 116 geometric character")
    save(output,(format_version=1,source_hashes=hashes,
        method="all C3 kernels and all lifts over f^2*N; exact closure and full-parent conjugacy",
        parent_number=94,child_number=116,parent_group_order=72,
        complete_within_saved_parent=true,
        raw_subgroups=length(raw),parent_conjugacy_classes=length(classes),
        character_matches=matched,candidates=Tuple(candidates),
        lattice_and_root_checks_done=false,numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == hashes && length(check.candidates) == length(candidates)
    r116_note("Saved and reloaded $output")
end

function r116_lattices(output,groups_path,selected_class)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path)
    @assert groups.format_version == 1 && groups.parent_number == 94
    @assert groups.child_number == 116 && groups.complete_within_saved_parent
    @assert groups.source_hashes == r116_hashes()
    parent = r116_parent()
    summaries = NamedTuple[]; results = NamedTuple[]
    for c in groups.candidates
        c.geometric_character_match || continue
        if selected_class !== nothing && c.class_number != selected_class
            continue
        end
        L = lattice(parent.Lambda0)
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
            if index != 6
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
        push!(summaries,(child_number=116,class_number=c.class_number,
            rank_S=rank(S),rank_T=rank(T),rank_P=rank_P,rank_K=rank_K,
            index=index,dimension=dimension,matched=matched,reason=reason))
        r116_note("No. 116 class $(c.class_number): S=$(rank(S)), P=$rank_P, dim=$dimension, match=$matched")
        matched || continue
        result = complete_cyclic_restriction(parent,
            c.symplectic_generator,c.extra_generator;
            child_number=116,parent_number=94,index=6,
            expected_rank_S=12,expected_dimension=4,
            expected_group_id=(18,3),verify_group_id=false,
            verify_roots=false,verify_symplectic_saturation=false)
        push!(results,(child_number=116,class_number=c.class_number,result=result))
    end
    isempty(summaries) && error("No matching No. 116 class was selected")
    isempty(results) && error("No selected class passed the lattice filters")
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=r116_hash(groups_path),
        selected_class=selected_class,summaries=Tuple(summaries),
        results=Tuple(results),target_number=116,match_count=length(results),
        roots_verified=false,symplectic_saturation_verified=false,
        numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert length(check.results) == length(results)
    r116_note("Saved and reloaded $output; lattice matches=$(length(results))")
end

function r116_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path); data = load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.parent_number == 94 && data.target_number == 116
    @assert groups.source_hashes == data.source_hashes == r116_hashes()
    @assert data.groups_file_hash == r116_hash(groups_path)
    parent = r116_parent(); ctx = r116_context(parent)
    expected = r116_geometric_character()
    verified = NamedTuple[]
    root_obstructed = String[]
    for r in data.results
        @assert r.child_number == 116
        c = only(x for x in groups.candidates if x.child_number == 116 &&
            x.class_number == r.class_number)
        key = r116_subgroup(ctx,
            [c.symplectic_generator_index,c.extra_generator_index])
        @assert key == c.subgroup_indices
        @assert r116_group_id(ctx,key,
            [c.symplectic_generator_index,c.extra_generator_index]) == (18,3)
        @assert Tuple(i for i in key if i <= 6) ==
            r116_subgroup(ctx,[c.symplectic_generator_index])
        @assert r116_histogram(ctx,key) ==
            c.primitive_character_histogram == expected
        @assert ctx.elements[c.symplectic_generator_index] == c.symplectic_generator
        @assert ctx.elements[c.extra_generator_index] == c.extra_generator
        if has_root(r.result.K_in_Lambda0,lattice(parent.Lambda0))
            push!(root_obstructed,string("116:",c.class_number))
            r116_note("No. 116 class $(c.class_number): root-obstructed")
            continue
        end
        result = complete_cyclic_restriction(parent,
            c.symplectic_generator,c.extra_generator;
            child_number=116,parent_number=94,index=6,
            expected_rank_S=12,expected_dimension=4,
            expected_group_id=(18,3),verify_group_id=false,
            verify_roots=true,verify_symplectic_saturation=false)
        @assert gram_matrix(lattice(result.S_in_Lambda0)) ==
            gram_matrix(lattice(r.result.S_in_Lambda0))
        @assert basis_matrix(lattice(result.S_in_Lambda0)) ==
            basis_matrix(lattice(r.result.S_in_Lambda0))
        @assert gram_matrix(lattice(result.T_in_Lambda0)) ==
            gram_matrix(lattice(r.result.T_in_Lambda0))
        @assert basis_matrix(lattice(result.T_in_Lambda0)) ==
            basis_matrix(lattice(r.result.T_in_Lambda0))
        @assert gram_matrix(result.P_in_Lambda0) == gram_matrix(r.result.P_in_Lambda0)
        @assert basis_matrix(result.P_in_Lambda0) == basis_matrix(r.result.P_in_Lambda0)
        @assert gram_matrix(result.K_in_Lambda0) == gram_matrix(r.result.K_in_Lambda0)
        @assert basis_matrix(result.K_in_Lambda0) == basis_matrix(r.result.K_in_Lambda0)
        @assert isometry(result.Lambda0) == isometry(r.result.Lambda0)
        @assert isometry(result.T_action) == isometry(r.result.T_action)
        push!(verified,(child_number=116,parent_number=94,
            class_number=c.class_number,subgroup_id=(18,3),
            roots_verified=true,result=result))
        r116_note("No. 116 class $(c.class_number): subgroup, lattice and roots verified")
    end
    @assert length(verified)+length(root_obstructed) == data.match_count
    # OSCAR cannot serialize an empty tuple or Vector{Tuple}; String[] is safe.
    verified_data = isempty(verified) ? String[] : Tuple(verified)
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=r116_hash(groups_path),
        lattices_file_hash=r116_hash(lattices_path),
        verified_results=verified_data,target_number=116,
        match_count=length(verified),lattice_match_count=data.match_count,
        root_obstructed_classes=root_obstructed,roots_verified=true,
        symplectic_saturation_verified=false,numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == data.source_hashes
    @assert length(check.verified_results) == length(verified)
    r116_note("Saved and reloaded $output; verified matches=$(length(verified))")
end

function r116_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices or verify")
    stage = ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no arguments")
        r116_preflight()
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        r116_groups(length(ARGS) == 2 ? abspath(ARGS[2]) : r116_groups_file)
    elseif stage == "lattices"
        length(ARGS) <= 4 || error("lattices [output.mrdi] [groups.mrdi] [class]")
        selected_class = length(ARGS) == 4 ? parse(Int,ARGS[4]) : nothing
        selected_class === nothing || selected_class > 0 ||
            error("The selected No. 116 class must be positive")
        r116_lattices(length(ARGS) >= 2 ? abspath(ARGS[2]) :
            r116_lattices_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : r116_groups_file,
            selected_class)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        r116_verify(length(ARGS) >= 2 ? abspath(ARGS[2]) :
            r116_verified_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : r116_lattices_file,
            length(ARGS) == 4 ? abspath(ARGS[4]) : r116_groups_file)
    else
        error("Unknown stage: $stage")
    end
end

r116_main()
