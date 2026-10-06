# Exhaustive Nos. 117 and 130 restrictions of the saved integral No. 95 action.
# Run the companion GAP script first, then preflight, groups, lattices, verify.
# Reuses the exact No. 95 kernel context and cyclic lattice restriction helpers
# used by restriction_115_125_from_95.jl. No stage edits the 156-row catalogue.

using SHA
include(joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))
include(joinpath(@__DIR__, "restriction_functions.jl"))

const r95117130_specs = (
    (number=117,rank_S=12,sym_order=3,generic_index=2,
        group_id=(18,3),index=6,dimension=4),
    (number=130,rank_S=8,sym_order=2,generic_index=1,
        group_id=(24,9),index=12,dimension=2),
)
const r95117130_parent_file = joinpath(@__DIR__,
    "restriction_candidates_94_95_from_24.direct_lattices.mrdi")
const r95117130_table = joinpath(@__DIR__, "..", "input",
    "family_numbering.md")
const r95117130_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result",
    "gap_fourfold_cross_dimension_all_pairs.tsv")
const r95117130_frozen_groups = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const r95117130_frozen_witnesses = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result",
    "gap_fourfold_cross_dimension_positive_edges.g")
const r95117130_characters = joinpath(@__DIR__,
    "restriction_117_130_geometric_characters.tsv")
const r95117130_character_script = joinpath(@__DIR__,
    "restriction_117_130_geometric_characters.g")
const r95117130_groups_file = joinpath(@__DIR__,
    "restriction_117_130_from_95.groups.mrdi")
const r95117130_lattices_file = joinpath(@__DIR__,
    "restriction_117_130_from_95.lattices.mrdi")
const r95117130_verified_file = joinpath(@__DIR__,
    "restriction_117_130_from_95.verified.mrdi")

r95117130_note(s) = (println(s); flush(stdout))
r95117130_hash(path) = bytes2hex(sha256(read(path)))
r95117130_spec(n) = only(s for s in r95117130_specs if s.number == n)

function r95117130_hashes()
    # Record both mathematical inputs and the code that interprets them.
    paths = (r95117130_parent_file,r95117130_table,r95117130_edges,
        r95117130_frozen_groups,r95117130_frozen_witnesses,
        r95117130_characters,r95117130_character_script,
        joinpath(@__DIR__, "restriction_117_130_from_95.jl"),
        joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"),
        joinpath(@__DIR__, "restriction_functions.jl"),
        joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl"))
    all(isfile,paths) || error("A source is missing; run the companion GAP script first")
    return Tuple((basename(p),r95117130_hash(p)) for p in paths)
end

function r95117130_table_checks()
    expected = Dict(95 => (14,"S3",2,12,1,(72,27)))
    for s in r95117130_specs
        expected[s.number] = (s.rank_S,s.sym_order == 3 ? "C3" : "C2",
            s.generic_index,s.index,s.dimension,s.group_id)
    end
    found = Dict{Int,Tuple}()
    for line in eachline(r95117130_table)
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

function r95117130_strict_checks()
    counts = Dict(s.number => 0 for s in r95117130_specs)
    for (line_number,line) in enumerate(eachline(r95117130_edges))
        line_number == 1 && continue
        v = split(line,'\t')
        length(v) == 12 || error("Malformed strict-containment row $line_number")
        parse(Int,v[2]) == 95 || continue
        n = parse(Int,v[1])
        haskey(counts,n) || continue
        s = r95117130_spec(n)
        Tuple(parse.(Int,v[3:6])) ==
            (s.dimension,1,3*s.group_id[1],216) ||
            error("Wrong strict-containment metadata for No. $n")
        v[7:10] == ["embedded","direct","true","fail"] ||
            error("No. $n is not direct and strict")
        v[12] in ("literal_matrix_subgroup","A_strict") ||
            error("No. $n has an unexpected containment method")
        counts[n] += 1
    end
    all(==(1),values(counts)) || error("A direct strict containment is missing or duplicated")
end

function r95117130_geometric_characters()
    expected = Dict(s.number => Dict{Tuple{Int,Int},Int}() for s in r95117130_specs)
    for (i,line) in enumerate(eachline(r95117130_characters))
        if i == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric character header")
            continue
        end
        isempty(strip(line)) && continue
        v = split(line,'\t')
        length(v) == 4 || error("Malformed geometric character line $i")
        n,ord,tr,count = parse.(Int,v)
        haskey(expected,n) && count > 0 && 1 <= ord <= 24 ||
            error("Unexpected character line $i")
        key = (ord,tr)
        haskey(expected[n],key) && error("Duplicate character bin")
        expected[n][key] = count
    end
    for s in r95117130_specs
        h = expected[s.number]
        sum(values(h)) == s.group_id[1] ||
            error("Incomplete character for No. $(s.number)")
        get(h,(1,22),0) == 1 || error("Bad identity trace")
    end
    return expected
end

function r95117130_parent()
    cache = load(r95117130_parent_file)
    @assert cache.parent_number == 24 && cache.character_assignment_verified
    parent = only(r for r in cache.results if
        r.class_number == cache.assigned_class_95 && r.character_matches == [95])
    @assert parent.abstract_projective_group_id == (72,27)
    @assert parent.symplectic_intersection_id == (6,1)
    @assert parent.order == 12 && parent.dimension == 1
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

# As in restriction_115_125_from_95.jl, (n,k) denotes n*f^k with n in the
# six-element normal S3 and 0 <= k < 12. All entries are exact integer indices.
function r95117130_context(parent)
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
    # Generator products plus associativity and unique normal forms certify
    # the whole table against the exact 22-by-22 ambient matrices.
    @assert all(elements[mul[i,g]] == elements[i]*elements[g]
        for i in 1:72 for g in generators)
    @assert all(elements[i]*elements[inverse[i]] == elements[1] for i in 1:72)
    return (;parent,nctx,f,elements,mul,inverse,orders,generators,idx)
end

function r95117130_subgroup(ctx,generators)
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

function r95117130_group_id(ctx,key,gens)
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

function r95117130_histogram(ctx,key)
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

function r95117130_raw(ctx,s)
    raw = Dict{Any,Tuple{Int,Int}}()
    quotient_coset = div(12,s.index)
    @assert quotient_coset*s.index == 12
    # If B maps onto C_index and B intersect N is cyclic of prime order,
    # B = <t,b> for a generator t of B intersect N and b over f^quotient_coset.
    # Testing every such t and b is exhaustive, including non-split lifts.
    for t in 2:6
        ctx.orders[t] == s.sym_order || continue
        kernel = r95117130_subgroup(ctx,[t])
        @assert length(kernel) == s.sym_order && all(i <= 6 for i in kernel)
        for b in 1:72
            div(b-1,6) == quotient_coset || continue
            key = r95117130_subgroup(ctx,[t,b])
            length(key) == s.group_id[1] || continue
            Tuple(i for i in key if i <= 6) == kernel || continue
            r95117130_group_id(ctx,key,[t,b]) == s.group_id || continue
            get!(raw,key,(t,b))
        end
    end
    isempty(raw) && error("No subgroup of type $(s.group_id) for No. $(s.number)")
    return raw
end

function r95117130_classes(ctx,raw)
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

function r95117130_preflight()
    hashes = r95117130_hashes()
    r95117130_table_checks(); r95117130_strict_checks()
    expected = r95117130_geometric_characters()
    parent = r95117130_parent()
    r95117130_note("No. 95 saved action and both frozen geometric characters passed")
    r95117130_note("Source SHA-256 hashes: $hashes")
    return parent,expected,hashes
end

function r95117130_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    parent,expected,hashes = r95117130_preflight()
    ctx = r95117130_context(parent)
    candidates = NamedTuple[]; summaries = NamedTuple[]
    for s in r95117130_specs
        raw = r95117130_raw(ctx,s)
        classes = r95117130_classes(ctx,raw)
        matched = 0
        for (class_number,c) in enumerate(classes)
            sym,b = raw[c.key]
            h = r95117130_histogram(ctx,c.key)
            is_match = h == expected[s.number]
            matched += is_match
            push!(candidates,(child_number=s.number,parent_number=95,
                class_number=class_number,parent_conjugacy_orbit_size=c.orbit_size,
                subgroup_indices=c.key,subgroup_id=s.group_id,
                symplectic_generator_index=sym,extra_generator_index=b,
                symplectic_generator=ctx.elements[sym],
                extra_generator=ctx.elements[b],
                primitive_character_histogram=h,geometric_character_match=is_match))
            r95117130_note("No. $(s.number) class $class_number: orbit $(c.orbit_size), character match=$is_match")
        end
        matched > 0 || error("No parent class matches No. $(s.number) character")
        push!(summaries,(child_number=s.number,raw_subgroups=length(raw),
            parent_conjugacy_classes=length(classes),character_matches=matched))
    end
    save(output,(format_version=1,source_hashes=hashes,
        method="exhaustive prime-order kernel and quotient lifts; exact closure and full-parent conjugacy",
        parent_number=95,parent_group_order=72,
        complete_within_saved_parent=true,
        summaries=Tuple(summaries),candidates=Tuple(candidates),
        lattice_and_root_checks_done=false,numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == hashes && length(check.candidates) == length(candidates)
    r95117130_note("Saved and reloaded $output")
end

function r95117130_lattices(output,groups_path,selected)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path)
    @assert groups.format_version == 1 && groups.source_hashes == r95117130_hashes()
    parent = r95117130_parent()
    summaries = NamedTuple[]; results = NamedTuple[]
    for c in groups.candidates
        c.geometric_character_match || continue
        if selected !== nothing && (c.child_number,c.class_number) != selected
            continue
        end
        s = r95117130_spec(c.child_number)
        L = lattice(parent.Lambda0)
        sym = integer_lattice_with_isometry(L,c.symplectic_generator;
            ambient_representation=false,check=true)
        S = lattice(coinvariant_lattice(sym))
        T = lattice(invariant_lattice(sym))
        index = 0; dimension = -1; rank_P = 0; rank_K = 0
        reason = ""
        if rank(S) != s.rank_S || rank(T) != 22-s.rank_S
            reason = "symplectic coinvariant rank mismatch"
        else
            Lf = integer_lattice_with_isometry(L,c.extra_generator;
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
                end
            end
        end
        matched = isempty(reason) && dimension == s.dimension
        isempty(reason) && !matched && (reason = "period dimension mismatch")
        push!(summaries,(child_number=s.number,class_number=c.class_number,
            rank_S=rank(S),rank_T=rank(T),rank_P=rank_P,rank_K=rank_K,
            index=index,dimension=dimension,matched=matched,reason=reason))
        r95117130_note("No. $(s.number) class $(c.class_number): S=$(rank(S)), P=$rank_P, dim=$dimension, match=$matched")
        matched || continue
        result = complete_cyclic_restriction(parent,
            c.symplectic_generator,c.extra_generator;
            child_number=s.number,parent_number=95,index=s.index,
            expected_rank_S=s.rank_S,expected_dimension=s.dimension,
            expected_group_id=s.group_id,verify_group_id=false,
            verify_roots=false,verify_symplectic_saturation=false)
        push!(results,(child_number=s.number,class_number=c.class_number,result=result))
    end
    counts = [count(r -> r.child_number == s.number,results) for s in r95117130_specs]
    isempty(results) && error("No selected class passed the lattice filters")
    if selected === nothing
        all(>(0),counts) || error("An expected numbered family has no lattice match")
    end
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=r95117130_hash(groups_path),
        selected_class=selected,summaries=Tuple(summaries),results=Tuple(results),
        target_numbers=Tuple(s.number for s in r95117130_specs),
        match_counts=Tuple(counts),roots_verified=false,
        symplectic_saturation_verified=false,numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert length(check.results) == length(results)
    r95117130_note("Saved and reloaded $output; match counts=$counts")
end

function r95117130_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path); data = load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.source_hashes == data.source_hashes == r95117130_hashes()
    @assert data.groups_file_hash == r95117130_hash(groups_path)
    parent = r95117130_parent(); ctx = r95117130_context(parent)
    expected = r95117130_geometric_characters()
    verified = NamedTuple[]
    root_obstructed = String[]
    for r in data.results
        c = only(x for x in groups.candidates if x.child_number == r.child_number &&
            x.class_number == r.class_number)
        s = r95117130_spec(r.child_number)
        key = r95117130_subgroup(ctx,
            [c.symplectic_generator_index,c.extra_generator_index])
        @assert key == c.subgroup_indices
        @assert r95117130_group_id(ctx,key,
            [c.symplectic_generator_index,c.extra_generator_index]) == s.group_id
        @assert Tuple(i for i in key if i <= 6) ==
            r95117130_subgroup(ctx,[c.symplectic_generator_index])
        @assert r95117130_histogram(ctx,key) ==
            c.primitive_character_histogram == expected[s.number]
        @assert ctx.elements[c.symplectic_generator_index] == c.symplectic_generator
        @assert ctx.elements[c.extra_generator_index] == c.extra_generator
        if has_root(r.result.K_in_Lambda0, lattice(parent.Lambda0))
            push!(root_obstructed,string(s.number, ":", c.class_number))
            r95117130_note("No. $(s.number) class $(c.class_number): root-obstructed")
            continue
        end
        result = complete_cyclic_restriction(parent,
            c.symplectic_generator,c.extra_generator;
            child_number=s.number,parent_number=95,index=s.index,
            expected_rank_S=s.rank_S,expected_dimension=s.dimension,
            expected_group_id=s.group_id,verify_group_id=false,
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
        push!(verified,(child_number=s.number,parent_number=95,
            class_number=c.class_number,subgroup_id=s.group_id,
            roots_verified=true,result=result))
        r95117130_note("No. $(s.number) class $(c.class_number): subgroup, lattice and roots verified")
    end
    counts = Tuple(count(r -> r.child_number == s.number,verified)
        for s in r95117130_specs)
    @assert all(counts[i] + count(r -> startswith(r,string(s.number, ":")),
        root_obstructed) == data.match_counts[i]
        for (i,s) in enumerate(r95117130_specs))
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=r95117130_hash(groups_path),
        lattices_file_hash=r95117130_hash(lattices_path),
        verified_results=Tuple(verified),target_numbers=data.target_numbers,
        match_counts=counts,lattice_match_counts=data.match_counts,
        root_obstructed_classes=root_obstructed,roots_verified=true,
        symplectic_saturation_verified=false,numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == data.source_hashes
    @assert length(check.verified_results) == length(verified)
    r95117130_note("Saved and reloaded $output; verified counts=$counts")
end

function r95117130_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices or verify")
    stage = ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no arguments")
        r95117130_preflight()
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        r95117130_groups(length(ARGS) == 2 ? abspath(ARGS[2]) : r95117130_groups_file)
    elseif stage == "lattices"
        length(ARGS) <= 4 || error("lattices [output.mrdi] [groups.mrdi] [child:class]")
        selected = nothing
        if length(ARGS) == 4
            bits = split(ARGS[4],':')
            length(bits) == 2 || error("Select child:class, for example 117:1")
            selected = (parse(Int,bits[1]),parse(Int,bits[2]))
            selected[1] in (117,130) && selected[2] > 0 ||
                error("The selected class must belong to No. 117 or No. 130")
        end
        r95117130_lattices(length(ARGS) >= 2 ? abspath(ARGS[2]) :
            r95117130_lattices_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : r95117130_groups_file,
            selected)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        r95117130_verify(length(ARGS) >= 2 ? abspath(ARGS[2]) :
            r95117130_verified_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : r95117130_lattices_file,
            length(ARGS) == 4 ? abspath(ARGS[4]) : r95117130_groups_file)
    else
        error("Unknown stage: $stage")
    end
end

r95117130_main()
