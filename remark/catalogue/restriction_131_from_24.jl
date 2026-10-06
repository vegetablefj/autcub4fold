# No. 131 inside the cached full No. 24 integral action.
# Stages: preflight, groups, lattices, verify. No isometry enumeration.
# Every output is new; the saved No. 24 parent is always read-only.

using SHA
include(joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))
include(joinpath(@__DIR__, "restriction_functions.jl"))

const r131_spec = (number=131,parent=24,rank_S=8,generic_index=1,
    full_index=12,dimension=1,group_id=(24,9))
const r131_cache_path = joinpath(@__DIR__, "source_24_full_lattice_group.mrdi")
const r131_original_path = joinpath(@__DIR__, "..", "..", "oscar", "oscar_script_data.mrdi")
const r131_table_path = joinpath(@__DIR__, "..", "input", "family_numbering.md")
const r131_edges_path = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_all_pairs.tsv")
const r131_groups_input = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const r131_witness_input = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_positive_edges.g")
const r131_character_script = joinpath(@__DIR__, "restriction_131_geometric_character.g")
const r131_character_path = joinpath(@__DIR__, "restriction_131_geometric_character.tsv")
const r131_groups_path = joinpath(@__DIR__, "restriction_131_from_24.groups.mrdi")
const r131_lattices_path = joinpath(@__DIR__, "restriction_131_from_24.lattices.mrdi")
const r131_verified_path = joinpath(@__DIR__, "restriction_131_from_24.verified.mrdi")

r131_note(s) = (println(s); flush(stdout))
r131_hash(path) = bytes2hex(sha256(read(path)))

function r131_hashes()
    paths = (r131_cache_path,r131_original_path,r131_table_path,r131_edges_path,
        r131_groups_input,r131_witness_input,r131_character_script,
        r131_character_path,joinpath(@__DIR__, "restriction_131_from_24.jl"),
        joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"),
        joinpath(@__DIR__, "restriction_functions.jl"))
    all(isfile,paths) || error("Missing saved No. 24 source or GAP character TSV")
    return Tuple((basename(path),r131_hash(path)) for path in paths)
end

function r131_table_and_edge_checks()
    rows = Dict{Int,Tuple}()
    for line in eachline(r131_table_path)
        startswith(line,'|') || continue
        cells = strip.(split(line,'|'))
        length(cells) >= 9 || continue
        n = tryparse(Int,cells[2])
        n in (24,131) || continue
        rows[n] = (parse(Int,cells[3]),replace(cells[4],"`"=>""),
            parse(Int,cells[5]),parse(Int,cells[6]),parse(Int,cells[7]))
        if n == 131
            occursin("[24,9]",replace(cells[8]," "=>"")) ||
                error("No. 131 projective group ID changed")
        end
    end
    @assert rows == Dict(24=>(18,"3^{1+4}:2",2,12,0),
                         131=>(8,"C2",1,12,1))
    count = 0
    for (line_number,line) in enumerate(eachline(r131_edges_path))
        line_number == 1 && continue
        v = split(line,'\t')
        length(v) == 12 || error("Malformed containment row $line_number")
        parse(Int,v[1]) == 131 && parse(Int,v[2]) == 24 || continue
        @assert Tuple(parse.(Int,v[3:6])) == (1,0,72,17496)
        @assert v[7:10] == ["embedded","direct","true","fail"]
        @assert v[11:12] == ["found","subgroup_classes_full_aut"]
        count += 1
    end
    count == 1 || error("Expected exactly one direct No. 131 < No. 24 edge")
end

function r131_character()
    expected = Dict{Tuple{Int,Int},Int}()
    for (line_number,line) in enumerate(eachline(r131_character_path))
        if line_number == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric-character header")
            continue
        end
        isempty(strip(line)) && continue
        fields = split(line,'\t')
        length(fields) == 4 || error("Malformed character row $line_number")
        n,ord,tr,count = parse.(Int,fields)
        n == 131 && 1 <= ord <= 24 && count > 0 ||
            error("Unexpected geometric-character row $line_number")
        key = (ord,tr)
        haskey(expected,key) && error("Duplicate geometric-character bin")
        expected[key] = count
    end
    @assert sum(values(expected)) == 24 && get(expected,(1,22),0) == 1
    return expected
end

function r131_parent()
    cache = load(r131_cache_path)
    @assert cache.parent_number == 24 && cache.symplectic_order == 486
    @assert cache.full_group_order == 5832
    source = load(r131_original_path)
    parent = source.cases[8].results[3]
    @assert parent.order == 12 && parent.dimension == 0
    @assert rank(lattice(parent.S_in_Lambda0)) == 18
    @assert rank(lattice(parent.T_in_Lambda0)) == 4
    @assert rank(lattice(parent.Lambda0)) == 22
    @assert order_of_isometry(parent.T_action) == 12
    @assert isometry(parent.Lambda0) == cache.extra_generator
    @assert gram_matrix(lattice(parent.Lambda0)) ==
            gram_matrix(lattice(cache.Lambda0))
    embedding = basis_matrix(lattice(cache.S_in_Lambda0)) *
                inv(basis_matrix(lattice(cache.Lambda0)))
    @assert length(cache.symplectic_generators_S) ==
            length(cache.symplectic_generators)
    for (gS,gL) in zip(cache.symplectic_generators_S,
                       cache.symplectic_generators)
        @assert gS*embedding == embedding*gL
    end
    @assert cache.extra_generator_S*embedding ==
            embedding*cache.extra_generator
    return parent,cache
end

function r131_preflight()
    hashes = r131_hashes()
    r131_table_and_edge_checks()
    expected = r131_character()
    parent,cache = r131_parent()
    r131_note("PASS: No. 131 rank 8, generic index 1, full index 12, dimension 1, [24,9]")
    r131_note("PASS: direct strict edge, exact 24-element geometric character, cached No. 24 group")
    r131_note("Source hashes: $hashes")
    return parent,cache,expected,hashes
end

# Let N be the 486-element symplectic kernel and f the quotient generator.
# Every requested B has A=B∩N=C2 and maps onto C12. After taking a suitable
# power of a quotient generator, B=<t,n*f>, where t is an involution in N.
function r131_raw(ctx)
    mul,phi,invs,q = ctx.mul,ctx.phi,ctx.inverses,ctx.quotient_order
    bq = Int[]
    for n in eachindex(ctx.elements)
        product,term = 1,n
        for _ in 1:q
            product = mul(product,term)
            term = phi[term]
        end
        push!(bq,mul(product,ctx.c))
    end
    involutions = [t for t in eachindex(ctx.elements) if ctx.orders[t] == 2]
    raw = Dict{Any,Tuple{Int,Int}}()
    for t in involutions
        for n in eachindex(ctx.elements)
            bq[n] in (1,t) || continue
            mul(mul(n,phi[t]),invs[n]) == t || continue
            coset = Tuple(sort([n,mul(t,n)]))
            key = (t,coset)
            get!(raw,key,(t,n))
        end
    end
    isempty(raw) && error("No eligible C2-by-C12 subgroup in saved No. 24")
    r131_note("$(length(involutions)) involutions; $(length(raw)) raw C2-by-C12 subgroups")
    return raw,length(involutions)
end

function r131_id(ctx,t,n)
    mul,phi,c,q = ctx.mul,ctx.phi,ctx.c,ctx.quotient_order
    A = (1,t)
    npowers = ones(Int,q)
    term = n
    for k in 2:q
        npowers[k] = mul(npowers[k-1],term)
        term = phi[term]
    end
    @assert mul(mul(npowers[q],term),c) in A
    pairs = [(mul(a,npowers[k+1]),k) for k in 0:q-1 for a in A]
    @assert length(unique(pairs)) == 24
    position = Dict(x=>i for (i,x) in enumerate(pairs))
    function regular_permutation(extra)
        image = Int[]
        for (x,k) in pairs
            y,l = if extra
                z = mul(n,phi[x])
                k == q-1 ? (mul(z,c),0) : (z,k+1)
            else
                (mul(t,x),k)
            end
            push!(image,position[(y,l)])
        end
        @assert sort(image) == collect(1:24)
        return GAP.Globals.PermList(GapObj(image))
    end
    group = GAP.Globals.Group(regular_permutation(false),regular_permutation(true))
    @assert Int(GAP.Globals.Size(group)) == 24
    id = GAP.Globals.IdGroup(group)
    return (Int(id[1]),Int(id[2]))
end

function r131_classes(ctx,raw)
    mul,phi,invs = ctx.mul,ctx.phi,ctx.inverses
    function conjugate(key,g)
        t,coset = key
        tnew = mul(mul(g,t),invs[g])
        nnew = mul(mul(g,first(coset)),phi[invs[g]])
        return (tnew,Tuple(sort([nnew,mul(tnew,nnew)])))
    end
    function conjugate_f(key)
        t,coset = key
        tnew,nnew = phi[t],phi[first(coset)]
        return (tnew,Tuple(sort([nnew,mul(tnew,nnew)])))
    end
    unseen = Set(keys(raw))
    classes = NamedTuple[]
    id_histogram = Dict{Tuple{Int,Int},Int}()
    while !isempty(unseen)
        representative = first(sort!(collect(unseen)))
        orbit = Set([representative]); todo = [representative]; head = 1
        while head <= length(todo)
            key = todo[head]
            neighbours = [conjugate(key,g) for g in ctx.generator_ids]
            push!(neighbours,conjugate_f(key))
            for next in neighbours
                haskey(raw,next) || error("Candidate set is not H-conjugacy stable")
                if !(next in orbit)
                    push!(orbit,next); push!(todo,next)
                end
            end
            head += 1
        end
        setdiff!(unseen,orbit)
        t = representative[1]; n = first(representative[2])
        id = r131_id(ctx,t,n)
        id_histogram[id] = get(id_histogram,id,0)+1
        push!(classes,(key=representative,t=t,n=n,
            orbit_size=length(orbit),group_id=id))
        r131_note("H-class $(length(classes)): ID=$id, orbit=$(length(orbit))")
    end
    @assert sum(c.orbit_size for c in classes) == length(raw)
    return classes,id_histogram
end

function r131_lift(ctx,cache,i)
    result = identity_matrix(QQ,22)
    for j in ctx.words[i]
        result *= cache.symplectic_generators[j]
    end
    return result
end

function r131_integer_trace(m)
    tr = sum(m[i,i] for i in 1:nrows(m))
    denominator(tr) == 1 || error("Nonintegral primitive trace")
    return Int(numerator(tr))
end

function r131_matrix_order(m,bound)
    one = identity_matrix(QQ,nrows(m))
    power = one
    for k in 1:bound
        power *= m
        power == one && return k
    end
    error("Element exceeds stated order bound")
end

function r131_histogram(ctx,cache,parent,t,n)
    mul,phi,c,q = ctx.mul,ctx.phi,ctx.c,ctx.quotient_order
    npowers = ones(Int,q); term = n
    for k in 2:q
        npowers[k] = mul(npowers[k-1],term)
        term = phi[term]
    end
    @assert mul(mul(npowers[q],term),c) in (1,t)
    fS = cache.extra_generator_S
    fT = isometry(parent.T_action)
    histogram = Dict{Tuple{Int,Int},Int}()
    for k in 0:q-1, a in (1,t)
        i = mul(a,npowers[k+1])
        gS = ctx.elements[i]*fS^k
        gT = fT^k
        ord = lcm(r131_matrix_order(gS,24),r131_matrix_order(gT,12))
        tr = r131_integer_trace(gS)+r131_integer_trace(gT)
        bin = (ord,tr)
        histogram[bin] = get(histogram,bin,0)+1
    end
    @assert sum(values(histogram)) == 24
    @assert get(histogram,(1,22),0) == 1
    return histogram
end

function r131_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    parent,cache,expected,hashes = r131_preflight()
    ctx = direct_context(cache.symplectic_generators_S,
        cache.extra_generator_S,486,12)
    @assert r131_lift(ctx,cache,ctx.c) == cache.extra_generator^12
    for (j,g) in enumerate(ctx.generator_ids)
        @assert cache.extra_generator*cache.symplectic_generators[j]*
                inv(cache.extra_generator) == r131_lift(ctx,cache,ctx.phi[g])
    end
    r131_note("Verified the full 486-by-12 extension and its 18/22-dimensional lifts")
    raw,involutions = r131_raw(ctx)
    classes,id_histogram = r131_classes(ctx,raw)
    candidates = NamedTuple[]
    for (class_number,c) in enumerate(classes)
        c.group_id == r131_spec.group_id || continue
        h = r131_histogram(ctx,cache,parent,c.t,c.n)
        match = h == expected
        push!(candidates,(class_number=class_number,
            parent_conjugacy_orbit_size=c.orbit_size,
            group_id=c.group_id,symplectic_intersection_id=(2,1),
            symplectic_generator_index=c.t,extra_coset_index=c.n,
            symplectic_generator_word=ctx.words[c.t],
            extra_coset_word=ctx.words[c.n],
            symplectic_generator_Lambda0=r131_lift(ctx,cache,c.t),
            extra_generator_Lambda0=r131_lift(ctx,cache,c.n)*cache.extra_generator,
            primitive_character_histogram=h,geometric_character_match=match))
        r131_note("[24,9] class $class_number: geometric character match=$match")
    end
    isempty(candidates) && error("No [24,9] subgroup in saved parent")
    save(output,(format_version=1,source_hashes=hashes,
        parent_number=24,parent_group_order=5832,child_number=131,
        symplectic_order=2,quotient_order=12,
        complete_within_saved_parent=true,
        involutions_in_parent_kernel=involutions,
        raw_subgroups=length(raw),parent_conjugacy_classes=length(classes),
        group_id_histogram=id_histogram,candidates=Tuple(candidates),
        character_match_count=count(c->c.geometric_character_match,candidates),
        lattice_and_root_checks_done=false,numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == hashes
    @assert length(check.candidates) == length(candidates)
    r131_note("Saved and reloaded $output; character matches=$(check.character_match_count)")
end

function r131_lattices(output,groups_path,selected_class)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path)
    @assert groups.format_version == 1 && groups.child_number == 131
    @assert groups.source_hashes == r131_hashes()
    parent,cache,expected,_ = r131_preflight()
    L = lattice(parent.Lambda0)
    summaries = NamedTuple[]; results = NamedTuple[]
    for c in groups.candidates
        c.geometric_character_match || continue
        selected_class !== nothing && c.class_number != selected_class && continue
        sym = integer_lattice_with_isometry(L,c.symplectic_generator_Lambda0;
            ambient_representation=false,check=true)
        S = lattice(coinvariant_lattice(sym))
        T = lattice(invariant_lattice(sym))
        rank(S) == 8 && rank(T) == 14 || begin
            push!(summaries,(class_number=c.class_number,rank_S=rank(S),
                rank_T=rank(T),matched=false,reason="rank mismatch"))
            continue
        end
        Lf = integer_lattice_with_isometry(L,c.extra_generator_Lambda0;
            ambient_representation=false,check=true)
        @assert trivial_action_on_discriminant(Lf)
        Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
        index = Int(order_of_isometry(full_rank_model(Timg)))
        index == 12 || begin
            push!(summaries,(class_number=c.class_number,rank_S=8,
                rank_T=14,matched=false,reason="quotient order mismatch"))
            continue
        end
        pk = embedded_PK_data(Lf,Timg,12)
        dimension = period_dimension(pk.P_lattice,12)
        matched = rank(pk.P_lattice) == 8 && rank(pk.K_lattice) == 14 &&
            signature_tuple(pk.P_lattice) == (6,0,2) &&
            signature_tuple(pk.K_lattice) == (14,0,0) && dimension == 1
        push!(summaries,(class_number=c.class_number,rank_S=8,rank_T=14,
            rank_P=rank(pk.P_lattice),rank_K=rank(pk.K_lattice),
            index=index,dimension=dimension,matched=matched,
            reason=matched ? "passed" : "period lattice mismatch"))
        r131_note("Class $(c.class_number): P=$(rank(pk.P_lattice)), dimension=$dimension, match=$matched")
        matched || continue
        result = complete_cyclic_restriction(parent,
            c.symplectic_generator_Lambda0,c.extra_generator_Lambda0;
            child_number=131,parent_number=24,index=12,
            expected_rank_S=8,expected_dimension=1,
            expected_group_id=(24,9),verify_group_id=false,
            verify_roots=false,verify_symplectic_saturation=false)
        push!(results,(class_number=c.class_number,result=result))
    end
    isempty(results) && error("No character-matched class passed the lattice filters")
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=r131_hash(groups_path),
        selected_class=selected_class === nothing ? 0 : selected_class,
        summaries=Tuple(summaries),results=Tuple(results),
        lattice_match_count=length(results),roots_verified=false,
        symplectic_saturation_verified=false,numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert length(check.results) == length(results)
    r131_note("Saved and reloaded $output; lattice matches=$(length(results))")
end

function r131_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path); data = load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.source_hashes == data.source_hashes == r131_hashes()
    @assert data.groups_file_hash == r131_hash(groups_path)
    parent,cache,expected,_ = r131_preflight()
    ctx = direct_context(cache.symplectic_generators_S,
        cache.extra_generator_S,486,12)
    verified = NamedTuple[]; root_obstructed = Int[]
    for r in data.results
        c = only(x for x in groups.candidates if x.class_number == r.class_number)
        t,n = c.symplectic_generator_index,c.extra_coset_index
        @assert r131_id(ctx,t,n) == (24,9)
        @assert r131_histogram(ctx,cache,parent,t,n) ==
            c.primitive_character_histogram == expected
        @assert r131_lift(ctx,cache,t) == c.symplectic_generator_Lambda0
        @assert r131_lift(ctx,cache,n)*cache.extra_generator ==
            c.extra_generator_Lambda0
        if has_root(r.result.K_in_Lambda0,lattice(parent.Lambda0))
            push!(root_obstructed,c.class_number)
            r131_note("Class $(c.class_number): root-obstructed")
            continue
        end
        fresh = complete_cyclic_restriction(parent,
            c.symplectic_generator_Lambda0,c.extra_generator_Lambda0;
            child_number=131,parent_number=24,index=12,
            expected_rank_S=8,expected_dimension=1,
            expected_group_id=(24,9),verify_group_id=false,
            verify_roots=true,verify_symplectic_saturation=false)
        @assert basis_matrix(lattice(fresh.S_in_Lambda0)) ==
            basis_matrix(lattice(r.result.S_in_Lambda0))
        @assert basis_matrix(lattice(fresh.T_in_Lambda0)) ==
            basis_matrix(lattice(r.result.T_in_Lambda0))
        @assert basis_matrix(fresh.P_in_Lambda0) ==
            basis_matrix(r.result.P_in_Lambda0)
        @assert basis_matrix(fresh.K_in_Lambda0) ==
            basis_matrix(r.result.K_in_Lambda0)
        @assert isometry(fresh.Lambda0) == isometry(r.result.Lambda0)
        @assert isometry(fresh.T_action) == isometry(r.result.T_action)
        push!(verified,(class_number=c.class_number,roots_verified=true,
            result=fresh))
        r131_note("Class $(c.class_number): subgroup, integral action and roots verified")
    end
    @assert length(verified)+length(root_obstructed) == data.lattice_match_count
    isempty(verified) && error("Every No. 131 lattice match is root-obstructed")
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=r131_hash(groups_path),
        lattices_file_hash=r131_hash(lattices_path),
        verified_results=Tuple(verified),
        root_obstructed_classes=string.(root_obstructed),
        roots_verified=true,symplectic_saturation_verified=false,
        numbered_assignment_claimed=length(verified)==1))
    check = load(output)
    @assert check.source_hashes == data.source_hashes
    @assert length(check.verified_results) == length(verified)
    r131_note("Saved and reloaded $output; root-free classes=$(length(verified))")
end

function r131_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices, or verify")
    stage = ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no extra argument")
        r131_preflight()
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        r131_groups(length(ARGS)==2 ? abspath(ARGS[2]) : r131_groups_path)
    elseif stage == "lattices"
        length(ARGS) <= 4 || error("lattices [output.mrdi] [groups.mrdi] [class]")
        selected = length(ARGS)==4 ? parse(Int,ARGS[4]) : nothing
        selected === nothing || selected > 0 || error("Class must be positive")
        r131_lattices(length(ARGS)>=2 ? abspath(ARGS[2]) : r131_lattices_path,
            length(ARGS)>=3 ? abspath(ARGS[3]) : r131_groups_path,selected)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        r131_verify(length(ARGS)>=2 ? abspath(ARGS[2]) : r131_verified_path,
            length(ARGS)>=3 ? abspath(ARGS[3]) : r131_lattices_path,
            length(ARGS)==4 ? abspath(ARGS[4]) : r131_groups_path)
    else
        error("Unknown stage: $stage")
    end
end

r131_main()
