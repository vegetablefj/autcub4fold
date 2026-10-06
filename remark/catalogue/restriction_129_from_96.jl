# Exact No. 129 restriction inside the saved full No. 96 lattice action.
# Run the companion GAP character script first. OSCAR stages: kernel,
# preflight, groups, lattices, verify. Each output refuses replacement.

using SHA
include(joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"))
include(joinpath(@__DIR__, "restriction_functions.jl"))

const r129_spec = (number=129,parent=96,rank_S=8,index=8,
    dimension=2,group_id=(16,5))
const r129_parent_file = joinpath(@__DIR__, "maximal_six_standard.mrdi")
const r129_original_file = joinpath(@__DIR__, "..", "low_rank",
    "maximal_cases", "family_096_phi24_oscar18.mrdi")
const r129_table = joinpath(@__DIR__, "..", "input",
    "family_numbering.md")
const r129_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result",
    "gap_fourfold_cross_dimension_all_pairs.tsv")
const r129_frozen_groups = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const r129_frozen_witnesses = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result",
    "gap_fourfold_cross_dimension_positive_edges.g")
const r129_character_script = joinpath(@__DIR__,
    "restriction_129_geometric_characters.g")
const r129_characters = joinpath(@__DIR__,
    "restriction_129_geometric_characters.tsv")
const r129_kernel_file = joinpath(@__DIR__, "restriction_129_from_96.kernel.mrdi")
const r129_groups_file = joinpath(@__DIR__, "restriction_129_from_96.groups.mrdi")
const r129_lattices_file = joinpath(@__DIR__, "restriction_129_from_96.lattices.mrdi")
const r129_verified_file = joinpath(@__DIR__, "restriction_129_from_96.verified.mrdi")

r129_note(s) = (println(s); flush(stdout))
r129_hash(path) = bytes2hex(sha256(read(path)))

function r129_core_hashes()
    paths = (r129_parent_file,r129_original_file,r129_table,r129_edges,
        joinpath(@__DIR__, "restriction_129_from_96.jl"),
        joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"),
        joinpath(@__DIR__, "restriction_functions.jl"),
        joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl"))
    all(isfile,paths) || error("A saved No. 96 source or implementation is missing")
    return Tuple((basename(p),r129_hash(p)) for p in paths)
end

function r129_source_hashes(kernel_path)
    paths = (r129_frozen_groups,r129_frozen_witnesses,
        r129_character_script,r129_characters,kernel_path)
    all(isfile,paths) || error("Run the GAP character and kernel stages first")
    return (core=r129_core_hashes(),
        geometry=Tuple((basename(p),r129_hash(p)) for p in paths))
end

function r129_parent()
    catalogue = load(r129_parent_file)
    record = catalogue["records"]["096"]
    @assert record.provenance.family_number == 96
    @assert record.provenance.selected_output == 1
    parent = record.data
    @assert parent.order == 24 && parent.dimension == 0
    @assert parent.group_gap_id == (144,69)
    L = lattice(parent.Lambda0)
    S = lattice(parent.S_in_Lambda0)
    T = lattice(parent.T_in_Lambda0)
    @assert rank(L) == 22 && rank(S) == 14 && rank(T) == 8
    @assert signature_tuple(L) == (20,0,2)
    @assert abs(det(gram_matrix(L))) == 3
    @assert order_of_isometry(parent.T_action) == 24
    @assert trivial_action_on_discriminant(parent.Lambda0)
    return parent
end

function r129_table_and_edge_checks()
    found = Dict{Int,Tuple}()
    for line in eachline(r129_table)
        startswith(line,"|") || continue
        cells = strip.(split(line,'|'))
        length(cells) >= 9 || continue
        n = tryparse(Int,cells[2])
        n in (96,129) || continue
        m = match(r"\[(\d+),(\d+)\]",cells[8])
        m === nothing && error("Missing group ID for row $n")
        found[n] = (parse(Int,cells[3]),replace(cells[4],"`"=>""),
            parse(Int,cells[6]),parse(Int,cells[7]),
            (parse(Int,m.captures[1]),parse(Int,m.captures[2])))
    end
    @assert found == Dict(96=>(14,"S3",24,0,(144,69)),
                          129=>(8,"C2",8,2,(16,5)))
    count = 0
    for (line_number,line) in enumerate(eachline(r129_edges))
        line_number == 1 && continue
        v = split(line,'\t')
        length(v) == 12 || error("Malformed strict-containment row $line_number")
        parse(Int,v[1]) == 129 && parse(Int,v[2]) == 96 || continue
        @assert Tuple(parse.(Int,v[3:6])) == (2,0,48,432)
        @assert v[7:10] == ["embedded","direct","true","fail"]
        @assert v[11:12] == ["found","A_strict"]
        count += 1
    end
    count == 1 || error("Missing or duplicate direct No. 129 < No. 96 edge")
end

function r129_geometric_character()
    expected = Dict{Tuple{Int,Int},Int}()
    for (i,line) in enumerate(eachline(r129_characters))
        if i == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric character header")
            continue
        end
        isempty(strip(line)) && continue
        v = split(line,'\t')
        length(v) == 4 || error("Malformed character line $i")
        n,ord,tr,count = parse.(Int,v)
        n == 129 && 1 <= ord <= 16 && count > 0 ||
            error("Unexpected geometric character line $i")
        key = (ord,tr)
        haskey(expected,key) && error("Duplicate geometric character bin")
        expected[key] = count
    end
    @assert sum(values(expected)) == 16 && get(expected,(1,22),0) == 1
    return expected
end

# The original No. 96 search used the discriminant kernel to identify its
# group, but saved only the ID. Reconstruct its six matrices once, then cache
# their checked full-lattice extensions for the finite restriction stages.
function r129_kernel(output)
    ispath(output) && error("Refusing to overwrite $output")
    hashes = r129_core_hashes()
    parent = r129_parent()
    L = lattice(parent.Lambda0)
    S = lattice(parent.S_in_Lambda0)
    T = lattice(parent.T_in_Lambda0)
    O = matrix_group(automorphism_group_generators(S;
        ambient_representation=false))
    rho = discriminant_representation(S,O;
        ambient_representation=false,full=false,check=true)
    N,inclusion = kernel(rho)
    @assert Int(order(N)) == 6
    eS = basis_matrix(S)*inv(basis_matrix(L))
    eT = basis_matrix(T)*inv(basis_matrix(L))
    f = isometry(parent.Lambda0)
    @assert isometry(parent.S_in_Lambda0)*eS == eS*f
    @assert isometry(parent.T_in_Lambda0)*eT == eT*f
    generators_S = typeof(isometry(parent.S_in_Lambda0))[]
    generators_L = typeof(f)[]
    for u in gens(N)
        uS = matrix(inclusion(u))
        Su = integer_lattice_with_isometry(S,uS;
            ambient_representation=false,check=true)
        Lu = integer_lattice_with_isometry(L,ambient_isometry(Su);
            ambient_representation=true,check=true)
        uL = isometry(Lu)
        @assert uS*eS == eS*uL && eT*uL == eT
        @assert trivial_action_on_discriminant(Lu)
        push!(generators_S,uS)
        push!(generators_L,uL)
    end
    ctx = direct_context(generators_L,f,6,24)
    @assert sort(ctx.orders) == [1,2,2,2,3,3]
    @assert order_of_isometry(parent.T_action) == 24
    save(output,(format_version=1,parent_number=96,
        core_hashes=hashes,symplectic_order=6,quotient_order=24,
        full_group_order=144,symplectic_generators_S=generators_S,
        symplectic_generators_Lambda0=generators_L,
        extra_generator_Lambda0=f,
        order_proof="N=ker(O(S)->O(A_S)) has order 6, fixes T; f^24 in N and f|T has order 24"))
    check = load(output)
    @assert check.core_hashes == hashes && check.full_group_order == 144
    @assert length(check.symplectic_generators_Lambda0) == length(generators_L)
    r129_note("Saved and reloaded No. 96 full-lattice kernel cache: $output")
end

function r129_kernel_cache(path)
    cache = load(path)
    @assert cache.format_version == 1 && cache.parent_number == 96
    @assert cache.core_hashes == r129_core_hashes()
    @assert cache.symplectic_order == 6 && cache.quotient_order == 24
    @assert cache.full_group_order == 144
    parent = r129_parent()
    @assert cache.extra_generator_Lambda0 == isometry(parent.Lambda0)
    L = lattice(parent.Lambda0)
    S = lattice(parent.S_in_Lambda0)
    T = lattice(parent.T_in_Lambda0)
    eS = basis_matrix(S)*inv(basis_matrix(L))
    eT = basis_matrix(T)*inv(basis_matrix(L))
    @assert length(cache.symplectic_generators_S) ==
        length(cache.symplectic_generators_Lambda0)
    for (uS,uL) in zip(cache.symplectic_generators_S,
                       cache.symplectic_generators_Lambda0)
        @assert uS*eS == eS*uL && eT*uL == eT
        Lu = integer_lattice_with_isometry(L,uL;
            ambient_representation=false,check=true)
        @assert trivial_action_on_discriminant(Lu)
    end
    nctx = direct_context(cache.symplectic_generators_Lambda0,
        cache.extra_generator_Lambda0,6,24)
    @assert sort(nctx.orders) == [1,2,2,2,3,3]
    return parent,cache,nctx
end

function r129_preflight(kernel_path)
    r129_table_and_edge_checks()
    expected = r129_geometric_character()
    parent,cache,nctx = r129_kernel_cache(kernel_path)
    hashes = r129_source_hashes(kernel_path)
    r129_note("No. 96 kernel, quotient, numbered data and geometric character passed")
    return parent,cache,nctx,expected,hashes
end

# Represent each of the 144 elements as n*f^k, with n in N and 0 <= k < 24.
# The exact relation f^24 in N and conjugation action on N determine the table.
function r129_context(cache,nctx)
    f = cache.extra_generator_Lambda0
    idx(n,k) = 6*k+n
    fpowers = [f^k for k in 0:23]
    elements = [nctx.elements[n]*fpowers[k+1] for k in 0:23 for n in 1:6]
    @assert length(Set(direct_matrix_key(x) for x in elements)) == 144
    function phi_power(n,k)
        for _ in 1:k
            n = nctx.phi[n]
        end
        return n
    end
    mul = zeros(Int,144,144)
    for i in 1:144, j in 1:144
        n,k = mod1(i,6),div(i-1,6)
        m,l = mod1(j,6),div(j-1,6)
        a = nctx.mul(n,phi_power(m,k))
        k+l >= 24 && (a = nctx.mul(a,nctx.c))
        mul[i,j] = idx(a,mod(k+l,24))
    end
    @assert all(mul[1,i] == i && mul[i,1] == i for i in 1:144)
    @assert all(mul[mul[i,j],k] == mul[i,mul[j,k]]
        for i in 1:144 for j in 1:144 for k in 1:144)
    inverse = [only(j for j in 1:144 if mul[i,j] == 1 && mul[j,i] == 1)
        for i in 1:144]
    orders = Int[]
    for i in 1:144
        x = 1; ord = 0
        while true
            x = mul[x,i]; ord += 1
            x == 1 && break
            ord <= 144 || error("Finite multiplication table has no order")
        end
        push!(orders,ord)
    end
    generators = [nctx.generator_ids; idx(1,1)]
    @assert all(elements[mul[i,g]] == elements[i]*elements[g]
        for i in 1:144 for g in generators)
    @assert all(elements[i]*elements[inverse[i]] == elements[1]
        for i in 1:144)
    return (; nctx,f,elements,mul,inverse,orders,generators,idx)
end

function r129_subgroup(ctx,generators)
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

function r129_group_id(ctx,key,gens)
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

function r129_histogram(ctx,key)
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

function r129_raw(ctx)
    raw = Dict{Any,Tuple{Int,Int}}()
    # Every C8 quotient generator has a power in the f^3 N coset. Thus each
    # eligible subgroup is <t,n*f^3> for t an involution in N and n in N.
    for t in 2:6
        ctx.nctx.orders[t] == 2 || continue
        kernel = r129_subgroup(ctx,[t])
        @assert length(kernel) == 2 && all(i <= 6 for i in kernel)
        for b in 1:144
            div(b-1,6) == 3 || continue
            key = r129_subgroup(ctx,[t,b])
            length(key) == 16 || continue
            Tuple(i for i in key if i <= 6) == kernel || continue
            r129_group_id(ctx,key,[t,b]) == r129_spec.group_id || continue
            get!(raw,key,(t,b))
        end
    end
    isempty(raw) && error("No eligible [16,5] subgroup inside saved No. 96")
    return raw
end

function r129_classes(ctx,raw)
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

function r129_groups(output,kernel_path)
    ispath(output) && error("Refusing to overwrite $output")
    _,cache,nctx,expected,hashes = r129_preflight(kernel_path)
    ctx = r129_context(cache,nctx)
    raw = r129_raw(ctx)
    classes = r129_classes(ctx,raw)
    candidates = NamedTuple[]
    for (class_number,c) in enumerate(classes)
        t,b = raw[c.key]
        h = r129_histogram(ctx,c.key)
        matched = h == expected
        push!(candidates,(child_number=129,parent_number=96,
            class_number=class_number,parent_conjugacy_orbit_size=c.orbit_size,
            subgroup_indices=c.key,subgroup_id=r129_spec.group_id,
            symplectic_generator_index=t,extra_generator_index=b,
            symplectic_generator=ctx.elements[t],
            extra_generator=ctx.elements[b],
            primitive_character_histogram=h,geometric_character_match=matched))
        r129_note("No. 129 class $class_number: orbit $(c.orbit_size), character match=$matched")
    end
    count(c -> c.geometric_character_match,candidates) > 0 ||
        error("No saved-parent class matches the No. 129 geometric character")
    save(output,(format_version=1,source_hashes=hashes,
        parent_number=96,parent_group_order=144,child_number=129,
        method="all C2 kernel intersections and all f^3 coset lifts; exact closure, group ID and full-parent conjugacy",
        complete_within_saved_parent=true,raw_subgroups=length(raw),
        parent_conjugacy_classes=length(classes),
        character_matches=count(c -> c.geometric_character_match,candidates),
        candidates=Tuple(candidates),lattice_and_root_checks_done=false,
        numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == hashes
    @assert length(check.candidates) == length(candidates)
    r129_note("Saved and reloaded $output")
end

function r129_lattices(output,groups_path,kernel_path,selected_class)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path)
    @assert groups.format_version == 1 && groups.parent_number == 96
    @assert groups.source_hashes == r129_source_hashes(kernel_path)
    parent,_,_ = r129_kernel_cache(kernel_path)
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
        if rank(S) != 8 || rank(T) != 14
            reason = "symplectic coinvariant rank mismatch"
        else
            Lf = integer_lattice_with_isometry(L,c.extra_generator;
                ambient_representation=false,check=true)
            @assert trivial_action_on_discriminant(Lf)
            Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
            index = Int(order_of_isometry(full_rank_model(Timg)))
            if index != 8
                reason = "quotient action order mismatch"
            else
                pk = embedded_PK_data(Lf,Timg,index)
                rank_P,rank_K = rank(pk.P_lattice),rank(pk.K_lattice)
                if rank_P != 12 || rank_K != 10
                    reason = "period/complement rank mismatch"
                elseif signature_tuple(pk.P_lattice) != (10,0,2) ||
                       signature_tuple(pk.K_lattice) != (10,0,0)
                    reason = "period/complement signature mismatch"
                else
                    dimension = period_dimension(pk.P_lattice,index)
                end
            end
        end
        matched = isempty(reason) && dimension == 2
        isempty(reason) && !matched && (reason = "period dimension mismatch")
        push!(summaries,(class_number=c.class_number,rank_S=rank(S),
            rank_T=rank(T),rank_P=rank_P,rank_K=rank_K,index=index,
            dimension=dimension,matched=matched,reason=reason))
        r129_note("No. 129 class $(c.class_number): S=$(rank(S)), P=$rank_P, dim=$dimension, match=$matched")
        matched || continue
        result = complete_cyclic_restriction(parent,
            c.symplectic_generator,c.extra_generator;
            child_number=129,parent_number=96,index=8,
            expected_rank_S=8,expected_dimension=2,
            expected_group_id=(16,5),verify_group_id=false,
            verify_roots=false,verify_symplectic_saturation=false)
        push!(results,(child_number=129,class_number=c.class_number,result=result))
    end
    isempty(results) && error("No selected class passed the No. 129 lattice filters")
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=r129_hash(groups_path),selected_class=selected_class,
        summaries=Tuple(summaries),results=Tuple(results),
        lattice_match_count=length(results),roots_verified=false,
        symplectic_saturation_verified=false,numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert length(check.results) == length(results)
    r129_note("Saved and reloaded $output; lattice matches=$(length(results))")
end

function r129_verify(output,lattices_path,groups_path,kernel_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path); data = load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.source_hashes == data.source_hashes ==
        r129_source_hashes(kernel_path)
    @assert data.groups_file_hash == r129_hash(groups_path)
    parent,cache,nctx,expected,_ = r129_preflight(kernel_path)
    ctx = r129_context(cache,nctx)
    verified = NamedTuple[]; root_obstructed = Int[]
    for r in data.results
        c = only(x for x in groups.candidates if
            x.child_number == 129 && x.class_number == r.class_number)
        key = r129_subgroup(ctx,
            [c.symplectic_generator_index,c.extra_generator_index])
        @assert key == c.subgroup_indices
        @assert r129_group_id(ctx,key,
            [c.symplectic_generator_index,c.extra_generator_index]) == (16,5)
        @assert Tuple(i for i in key if i <= 6) ==
            r129_subgroup(ctx,[c.symplectic_generator_index])
        @assert r129_histogram(ctx,key) ==
            c.primitive_character_histogram == expected
        @assert ctx.elements[c.symplectic_generator_index] == c.symplectic_generator
        @assert ctx.elements[c.extra_generator_index] == c.extra_generator
        if has_root(r.result.K_in_Lambda0,lattice(parent.Lambda0))
            push!(root_obstructed,c.class_number)
            r129_note("No. 129 class $(c.class_number): root-obstructed")
            continue
        end
        result = complete_cyclic_restriction(parent,
            c.symplectic_generator,c.extra_generator;
            child_number=129,parent_number=96,index=8,
            expected_rank_S=8,expected_dimension=2,
            expected_group_id=(16,5),verify_group_id=false,
            verify_roots=true,verify_symplectic_saturation=false)
        @assert basis_matrix(lattice(result.S_in_Lambda0)) ==
            basis_matrix(lattice(r.result.S_in_Lambda0))
        @assert basis_matrix(lattice(result.T_in_Lambda0)) ==
            basis_matrix(lattice(r.result.T_in_Lambda0))
        @assert basis_matrix(result.P_in_Lambda0) ==
            basis_matrix(r.result.P_in_Lambda0)
        @assert basis_matrix(result.K_in_Lambda0) ==
            basis_matrix(r.result.K_in_Lambda0)
        @assert isometry(result.Lambda0) == isometry(r.result.Lambda0)
        @assert isometry(result.T_action) == isometry(r.result.T_action)
        push!(verified,(child_number=129,parent_number=96,
            class_number=c.class_number,subgroup_id=(16,5),
            roots_verified=true,result=result))
        r129_note("No. 129 class $(c.class_number): subgroup, lattice and roots verified")
    end
    @assert length(verified)+length(root_obstructed) == data.lattice_match_count
    isempty(verified) && error("All No. 129 lattice matches are root-obstructed")
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=r129_hash(groups_path),
        lattices_file_hash=r129_hash(lattices_path),
        verified_results=Tuple(verified),lattice_match_count=data.lattice_match_count,
        # OSCAR 1.8.2 does not serialize an empty Tuple() unambiguously.
        root_obstructed_classes=string.(root_obstructed),roots_verified=true,
        symplectic_saturation_verified=false,numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == data.source_hashes
    @assert length(check.verified_results) == length(verified)
    r129_note("Saved and reloaded $output; root-free classes=$(length(verified))")
end

function r129_main()
    isempty(ARGS) && error("Choose kernel, preflight, groups, lattices or verify")
    stage = ARGS[1]
    if stage == "kernel"
        length(ARGS) <= 2 || error("kernel [output.mrdi]")
        r129_kernel(length(ARGS) == 2 ? abspath(ARGS[2]) : r129_kernel_file)
    elseif stage == "preflight"
        length(ARGS) <= 2 || error("preflight [kernel.mrdi]")
        r129_preflight(length(ARGS) == 2 ? abspath(ARGS[2]) : r129_kernel_file)
    elseif stage == "groups"
        length(ARGS) <= 3 || error("groups [output.mrdi] [kernel.mrdi]")
        r129_groups(length(ARGS) >= 2 ? abspath(ARGS[2]) : r129_groups_file,
            length(ARGS) == 3 ? abspath(ARGS[3]) : r129_kernel_file)
    elseif stage == "lattices"
        length(ARGS) <= 5 ||
            error("lattices [output.mrdi] [groups.mrdi] [kernel.mrdi] [class]")
        selected = length(ARGS) == 5 ? parse(Int,ARGS[5]) : nothing
        selected === nothing || selected > 0 || error("Class must be positive")
        r129_lattices(length(ARGS) >= 2 ? abspath(ARGS[2]) : r129_lattices_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : r129_groups_file,
            length(ARGS) >= 4 ? abspath(ARGS[4]) : r129_kernel_file,
            selected)
    elseif stage == "verify"
        length(ARGS) <= 5 ||
            error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi] [kernel.mrdi]")
        r129_verify(length(ARGS) >= 2 ? abspath(ARGS[2]) : r129_verified_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : r129_lattices_file,
            length(ARGS) >= 4 ? abspath(ARGS[4]) : r129_groups_file,
            length(ARGS) == 5 ? abspath(ARGS[5]) : r129_kernel_file)
    else
        error("Unknown stage: $stage")
    end
end

r129_main()
