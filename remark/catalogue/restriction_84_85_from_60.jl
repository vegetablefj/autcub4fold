# Staged restrictions No. 84/85 inside the verified full No. 60 action.
# No O(S) computation or stage runs merely by including this file.
# Run the companion GAP character script before preflight/groups/lattices/verify.

using SHA
include(joinpath(@__DIR__, "prepare_no60_full_lattice_group.jl"))
include(joinpath(@__DIR__, "restriction_functions.jl"))

const r8485_children = (84,85)
const r8485_table = joinpath(@__DIR__, "..", "input", "family_numbering.md")
const r8485_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_all_pairs.tsv")
const r8485_families = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const r8485_witnesses = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_positive_edges.g")
const r8485_character_script = joinpath(@__DIR__, "restriction_84_85_geometric_characters.g")
const r8485_character_file = joinpath(@__DIR__, "restriction_84_85_geometric_characters.tsv")
const r8485_groups_file = joinpath(@__DIR__, "restriction_84_85_from_60.groups.mrdi")
const r8485_lattices_file = joinpath(@__DIR__, "restriction_84_85_from_60.lattices.mrdi")
const r8485_verified_file = joinpath(@__DIR__, "restriction_84_85_from_60.verified.mrdi")

r8485_note(s) = (println(s); flush(stdout))
r8485_hash(path) = bytes2hex(sha256(read(path)))
r8485_saved(items) = isempty(items) ? String[] : Tuple(items)

function r8485_hashes()
    paths = (no60_cache,no60_source,r8485_table,r8485_edges,
        r8485_families,r8485_witnesses,r8485_character_script,
        r8485_character_file,@__FILE__,
        joinpath(@__DIR__, "prepare_no60_full_lattice_group.jl"),
        joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"),
        joinpath(@__DIR__, "restriction_functions.jl"),
        joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl"))
    all(isfile,paths) || error("A source or GAP character TSV is missing")
    return Tuple((basename(p),r8485_hash(p)) for p in paths)
end

function r8485_numbering_and_edges()
    expected = Dict(60=>(16,"D_12",1,2,2,(24,14)),
        84=>(14,"S3",1,2,3,(12,4)),
        85=>(14,"S3",1,2,3,(12,4)))
    found = Dict{Int,Tuple}()
    for line in eachline(r8485_table)
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
    found == expected || error("Numbered No. 60/84/85 metadata changed")
    counts = Dict(n=>0 for n in r8485_children)
    for (i,line) in enumerate(eachline(r8485_edges))
        i == 1 && continue
        v = split(line,'\t')
        length(v) == 12 || error("Malformed containment row $i")
        source,target = parse(Int,v[1]),parse(Int,v[2])
        target == 60 && haskey(counts,source) || continue
        Tuple(parse.(Int,v[3:6])) == (3,2,36,72) ||
            error("Wrong No. $source -> 60 edge dimensions or linear orders")
        v[7:11] == ["embedded","direct","true","fail","found"] ||
            error("No. $source -> 60 is not direct and strict")
        v[12] in ("literal_matrix_subgroup","A_strict") ||
            error("Unexpected strict containment method")
        counts[source] += 1
    end
    all(x == 1 for x in values(counts)) ||
        error("Expected one direct strict edge for each child: $counts")
end

function r8485_geometric_characters()
    expected = Dict(n=>Dict{Tuple{Int,Int},Int}() for n in r8485_children)
    for (i,line) in enumerate(eachline(r8485_character_file))
        if i == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric-character header")
            continue
        end
        isempty(strip(line)) && continue
        v = split(line,'\t')
        length(v) == 4 || error("Malformed geometric-character row $i")
        n,ord,tr,count = parse.(Int,v)
        haskey(expected,n) && 1 <= ord <= 12 && -22 <= tr <= 22 && count > 0 ||
            error("Unexpected geometric-character row $i")
        key = (ord,tr)
        haskey(expected[n],key) && error("Duplicate geometric-character bin")
        expected[n][key] = count
    end
    for n in r8485_children
        sum(values(expected[n])) == 12 || error("Incomplete No. $n character")
        get(expected[n],(1,22),0) == 1 || error("Bad identity trace for No. $n")
    end
    frozen = Dict(
        84=>Dict((1,22)=>1,(2,-2)=>4,(2,6)=>3,(3,4)=>2,(6,-2)=>2),
        85=>Dict((1,22)=>1,(2,-10)=>1,(2,-2)=>3,(2,6)=>3,
            (3,4)=>2,(6,2)=>2))
    for n in r8485_children
        observed_bins = sort!([(key[1],key[2],count) for
            (key,count) in expected[n]])
        frozen_bins = sort!([(key[1],key[2],count) for
            (key,count) in frozen[n]])
        observed_bins == frozen_bins || error(
            "No. $n geometric character changed: observed=$observed_bins; expected=$frozen_bins")
    end
    return expected
end

function r8485_parent()
    cache = no60_verify_cache()
    source = load(no60_source)
    parent = source.cases[24].results[1]
    @assert parent.group_gap_id == (24,14)
    @assert parent.order == 2 && parent.dimension == 2
    @assert cache.parent_number == 60 && cache.symplectic_order == 12
    @assert cache.quotient_order == 2 && cache.full_group_order == 24
    @assert rank(lattice(parent.Lambda0)) == 22
    @assert rank(lattice(parent.S_in_Lambda0)) == 16
    @assert isometry(cache.Lambda0) == isometry(parent.Lambda0)
    return parent,cache
end

function r8485_preflight()
    hashes = r8485_hashes()
    r8485_numbering_and_edges()
    expected = r8485_geometric_characters()
    parent,cache = r8485_parent()
    r8485_note("PASS: numbered rows, both direct strict edges, both twelve-element characters")
    r8485_note("PASS: saved No. 60 kernel order 12, quotient order 2, full order 24")
    r8485_note("Geometric characters distinct: $(expected[84] != expected[85])")
    r8485_note("Source SHA-256 hashes: $hashes")
    return parent,cache,expected,hashes
end

# The finite group search uses the 16-dimensional S action and a formal C2
# coset. The 22-dimensional lifts below check it against the actual lattice.
function r8485_context(cache)
    small = direct_context(cache.symplectic_generators_S,
        cache.extra_generator_S,12,2)
    oneL = identity_matrix(QQ,22)
    nL = [foldl(*,(cache.symplectic_generators[j] for j in small.words[n]);
        init=oneL) for n in 1:12]
    f = cache.extra_generator
    elements = [nL[n]*f^k for k in 0:1 for n in 1:12]
    positions = Dict(direct_matrix_key(x)=>i for (i,x) in enumerate(elements))
    length(positions) == 24 || error("No. 60 full lattice action has fewer than 24 elements")
    E = basis_matrix(lattice(cache.S_in_Lambda0))*
        inv(basis_matrix(lattice(cache.Lambda0)))
    @assert all(small.elements[n]*E == E*nL[n] for n in 1:12)
    @assert cache.extra_generator_S*E == E*f
    @assert f^2 == nL[small.c]
    mul = zeros(Int,24,24)
    for i in 1:24, j in 1:24
        mul[i,j] = get(positions,direct_matrix_key(elements[i]*elements[j]),0)
        mul[i,j] > 0 || error("Saved No. 60 full lattice matrices are not closed")
    end
    @assert all(mul[1,i] == i && mul[i,1] == i for i in 1:24)
    inverse = [only(j for j in 1:24 if mul[i,j] == 1 && mul[j,i] == 1)
        for i in 1:24]
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
    @assert all(mul[mul[i,j],k] == mul[i,mul[j,k]]
        for i in 1:24 for j in 1:24 for k in 1:24)
    return (;small,elements,mul,inverse,orders,nL)
end

function r8485_subgroup(ctx,gens)
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

function r8485_group_id(ctx,key,gens)
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

function r8485_histogram(ctx,key)
    hist = Dict{Tuple{Int,Int},Int}()
    for i in key
        tr = sum(ctx.elements[i][j,j] for j in 1:22)
        denominator(tr) == 1 || error("Nonintegral primitive H4 trace")
        bin = (ctx.orders[i],Int(numerator(tr)))
        hist[bin] = get(hist,bin,0)+1
    end
    @assert sum(values(hist)) == length(key) && get(hist,(1,22),0) == 1
    return hist
end

function r8485_group_key(item)
    A,coset = item.representative
    @assert length(A) == 6 && length(coset) == 6
    return Tuple(sort!([collect(A);[12+n for n in coset]]))
end

function r8485_check_candidate(ctx,c)
    key = r8485_subgroup(ctx,[c.r,c.s,12+c.n])
    key == c.subgroup_indices || error("Saved subgroup indices changed")
    A = r8485_subgroup(ctx,[c.r,c.s])
    length(A) == 6 && all(i <= 12 for i in A) ||
        error("Wrong S3 intersection")
    Tuple(i for i in key if i <= 12) == A ||
        error("Wrong symplectic subgroup intersection")
    r8485_group_id(ctx,A,[c.r,c.s]) == (6,1) ||
        error("Symplectic intersection is not S3")
    r8485_group_id(ctx,key,[c.r,c.s,12+c.n]) == c.group_id ||
        error("Full subgroup ID changed")
    r8485_histogram(ctx,key) == c.primitive_character_histogram ||
        error("Full lattice character changed")
    @assert ctx.elements[c.r] == c.symplectic_generators[1]
    @assert ctx.elements[c.s] == c.symplectic_generators[2]
    @assert ctx.elements[12+c.n] == c.extra_generator
    return key
end

function r8485_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Group output must end in .mrdi")
    _,cache,expected,hashes = r8485_preflight()
    ctx = r8485_context(cache)
    search = direct_enumerate(ctx.small) # all S3-by-C2 classes, every abstract ID
    length(search.orbits) == search.all_orbit_count ||
        error("The S3-by-C2 class enumeration was filtered")
    candidates = NamedTuple[]
    for (class_number,item) in enumerate(search.orbits)
        key = r8485_group_key(item)
        r,s,n = item.r,item.s,item.n
        @assert r8485_subgroup(ctx,[r,s,12+n]) == key
        @assert r8485_group_id(ctx,key,[r,s,12+n]) == item.group_id
        hist = r8485_histogram(ctx,key)
        matches = Tuple(child for child in r8485_children if
            item.group_id == (12,4) && hist == expected[child])
        push!(candidates,(class_number=class_number,
            parent_conjugacy_orbit_size=item.orbit_size,
            subgroup_indices=key,group_id=item.group_id,
            r=r,s=s,n=n,
            symplectic_generators=(ctx.elements[r],ctx.elements[s]),
            extra_generator=ctx.elements[12+n],
            primitive_character_histogram=hist,character_matches=matches))
        r8485_note("Class $class_number: ID=$(item.group_id), orbit=$(item.orbit_size), matches=$matches")
    end
    counts = Tuple((child=child,
        character_matching_classes=count(c->child in c.character_matches,candidates))
        for child in r8485_children)
    all(x.character_matching_classes > 0 for x in counts) ||
        r8485_note("A target has no character-matching class; retaining the complete negative search")
    save(output,(format_version=1,source_hashes=hashes,parent_number=60,
        target_numbers=r8485_children,
        method="all S3 subgroups of the order-12 kernel; all outer lifts; full-parent conjugacy; no abstract-ID prefilter",
        complete_within_saved_parent=true,
        symplectic_s3_subgroups=search.s3_subgroups,
        raw_s3_by_c2_subgroups=search.raw_subgroups,
        all_parent_conjugacy_classes=search.all_orbit_count,
        all_group_id_histogram=search.id_histogram,
        target_abstract_classes=count(c->c.group_id==(12,4),candidates),
        counts=counts,candidates=Tuple(candidates),
        lattice_and_root_checks_done=false,global_uniqueness_claimed=false))
    check = load(output)
    @assert check.source_hashes == hashes
    @assert length(check.candidates) == search.all_orbit_count
    r8485_note("Saved and reloaded $output")
end

function r8485_restriction(parent,c)
    L = lattice(parent.Lambda0)
    T = invariant_lattice(L,collect(c.symplectic_generators);
        ambient_representation=false)
    S = orthogonal_submodule(L,T)
    @assert rank(S) == 14 && rank(T) == 8
    @assert signature_tuple(S) == (14,0,0)
    @assert signature_tuple(T) == (6,0,2)
    Lf = integer_lattice_with_isometry(L,c.extra_generator;
        ambient_representation=false,check=true)
    @assert trivial_action_on_discriminant(Lf)
    Simg = lattice_in_same_ambient_space(Lf,basis_matrix(S);check=true)
    Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
    @assert basis_matrix(S)*gram_matrix(ambient_space(L))*
        transpose(basis_matrix(T)) == zero_matrix(QQ,14,8)
    Taction = full_rank_model(Timg)
    @assert Int(order_of_isometry(Taction)) == 2
    pk = embedded_PK_data(Lf,Timg,2)
    P,K = pk.P_lattice,pk.K_lattice
    @assert rank(P) == 5 && rank(K) == 17
    @assert signature_tuple(P) == (3,0,2)
    @assert signature_tuple(K) == (17,0,0)
    @assert period_dimension(P,2) == 3
    return (order=2,dimension=3,
        S_in_Lambda0=Simg,T_in_Lambda0=Timg,T_action=Taction,
        K_in_Lambda0=K,P_in_Lambda0=P,P_action=pk.P_with_isometry,
        Lambda0=Lf,group_gap_id=nothing,
        symplectic_kernel_order_S=nothing,symplectic_kernel_order_K=nothing,
        symplectic_saturation_verified=false,extracted_subgroup_id=(12,4),
        group_id_source="verified subgroup of cached No. 60 full group",
        parent_number=60,possible_child_numbers=c.character_matches,
        symplectic_generators_in_parent=c.symplectic_generators,
        extra_generator_in_parent=c.extra_generator)
end

function r8485_lattices(output,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Lattice output must end in .mrdi")
    groups = load(groups_path)
    @assert groups.format_version == 1 && groups.parent_number == 60
    @assert groups.target_numbers == r8485_children
    @assert groups.complete_within_saved_parent
    @assert groups.source_hashes == r8485_hashes()
    parent,_ = r8485_parent()
    L = lattice(parent.Lambda0)
    summaries = NamedTuple[]; results = NamedTuple[]
    for c in groups.candidates
        c.group_id == (12,4) && !isempty(c.character_matches) || continue
        T = invariant_lattice(L,collect(c.symplectic_generators);
            ambient_representation=false)
        S = orthogonal_submodule(L,T)
        reason = ""; index = 0; dimension = -1; rank_P = 0; rank_K = 0
        if rank(S) != 14 || rank(T) != 8
            reason = "symplectic rank mismatch"
        elseif signature_tuple(S) != (14,0,0) || signature_tuple(T) != (6,0,2)
            reason = "symplectic signature mismatch"
        else
            Lf = integer_lattice_with_isometry(L,c.extra_generator;
                ambient_representation=false,check=true)
            @assert trivial_action_on_discriminant(Lf)
            Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
            index = Int(order_of_isometry(full_rank_model(Timg)))
            if index != 2
                reason = "quotient action order mismatch"
            else
                pk = embedded_PK_data(Lf,Timg,2)
                rank_P,rank_K = rank(pk.P_lattice),rank(pk.K_lattice)
                if rank_P != 5 || rank_K != 17
                    reason = "period/complement rank mismatch"
                elseif signature_tuple(pk.P_lattice) != (3,0,2) ||
                       signature_tuple(pk.K_lattice) != (17,0,0)
                    reason = "period/complement signature mismatch"
                else
                    dimension = period_dimension(pk.P_lattice,2)
                    dimension == 3 || (reason = "period dimension mismatch")
                end
            end
        end
        push!(summaries,(class_number=c.class_number,
            character_matches=c.character_matches,rank_S=rank(S),rank_T=rank(T),
            rank_P=rank_P,rank_K=rank_K,index=index,dimension=dimension,
            matched=isempty(reason),reason=reason))
        r8485_note("Class $(c.class_number): S=$(rank(S)), P=$rank_P, dimension=$dimension, reason=$reason")
        isempty(reason) || continue
        push!(results,(class_number=c.class_number,
            character_matches=c.character_matches,result=r8485_restriction(parent,c)))
    end
    counts = Tuple((child=child,
        lattice_matches=count(r->child in r.character_matches,results))
        for child in r8485_children)
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=r8485_hash(groups_path),target_numbers=r8485_children,
        summaries=r8485_saved(summaries),results=r8485_saved(results),
        counts=counts,all_character_matches_processed=true,
        roots_verified=false,symplectic_saturation_verified=false,
        global_uniqueness_claimed=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert length(check.results) == length(results)
    r8485_note("Saved and reloaded $output; lattice matches=$counts")
end

function r8485_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Verified output must end in .mrdi")
    groups,data = load(groups_path),load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.source_hashes == data.source_hashes == r8485_hashes()
    @assert data.groups_file_hash == r8485_hash(groups_path)
    parent,cache,expected,_ = r8485_preflight()
    ctx = r8485_context(cache)
    verified = NamedTuple[]; obstructed = NamedTuple[]
    for r in data.results
        c = only(x for x in groups.candidates if x.class_number == r.class_number)
        @assert c.group_id == (12,4) && c.character_matches == r.character_matches
        r8485_check_candidate(ctx,c)
        @assert c.character_matches == Tuple(n for n in r8485_children if
            c.primitive_character_histogram == expected[n])
        fresh = r8485_restriction(parent,c)
        @assert basis_matrix(lattice(fresh.S_in_Lambda0)) ==
            basis_matrix(lattice(r.result.S_in_Lambda0))
        @assert basis_matrix(lattice(fresh.T_in_Lambda0)) ==
            basis_matrix(lattice(r.result.T_in_Lambda0))
        @assert basis_matrix(fresh.P_in_Lambda0) == basis_matrix(r.result.P_in_Lambda0)
        @assert basis_matrix(fresh.K_in_Lambda0) == basis_matrix(r.result.K_in_Lambda0)
        @assert isometry(fresh.T_action) == isometry(r.result.T_action)
        if has_root(fresh.K_in_Lambda0,lattice(parent.Lambda0))
            push!(obstructed,(class_number=c.class_number,
                character_matches=c.character_matches,group_id=c.group_id))
            r8485_note("Class $(c.class_number): root obstruction")
        else
            push!(verified,(class_number=c.class_number,
                character_matches=c.character_matches,group_id=c.group_id,
                roots_verified=true,result=fresh))
            r8485_note("Class $(c.class_number): subgroup, lattice and roots verified")
        end
    end
    @assert length(verified)+length(obstructed) == length(data.results)
    counts = Tuple((child=child,
        root_free=count(r->child in r.character_matches,verified),
        root_obstructed=count(r->child in r.character_matches,obstructed))
        for child in r8485_children)
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=r8485_hash(groups_path),
        lattices_file_hash=r8485_hash(lattices_path),
        target_numbers=r8485_children,counts=counts,
        verified_results=r8485_saved(verified),
        root_obstructed=r8485_saved(obstructed),
        roots_verified=true,complete_within_saved_parent=true,
        all_character_matches_processed=data.all_character_matches_processed,
        symplectic_saturation_verified=false,global_uniqueness_claimed=false))
    check = load(output)
    @assert check.source_hashes == data.source_hashes
    @assert length(check.verified_results) == length(verified)
    r8485_note("Saved and reloaded $output; root outcomes=$counts")
end

function r8485_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices, or verify")
    stage = ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no extra arguments")
        r8485_preflight()
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        r8485_groups(length(ARGS)==2 ? abspath(ARGS[2]) : r8485_groups_file)
    elseif stage == "lattices"
        length(ARGS) <= 3 || error("lattices [output.mrdi] [groups.mrdi]")
        r8485_lattices(length(ARGS)>=2 ? abspath(ARGS[2]) : r8485_lattices_file,
            length(ARGS)==3 ? abspath(ARGS[3]) : r8485_groups_file)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        r8485_verify(length(ARGS)>=2 ? abspath(ARGS[2]) : r8485_verified_file,
            length(ARGS)>=3 ? abspath(ARGS[3]) : r8485_lattices_file,
            length(ARGS)==4 ? abspath(ARGS[4]) : r8485_groups_file)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    r8485_main()
end
