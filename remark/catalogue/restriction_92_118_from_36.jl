# Exhaustive No. 92 and No. 118 restrictions inside the saved No. 36 action.
# No stage computes O(S); the No. 36 full-action cache is prepared separately.
# Candidate subgroup classes and lattice/root checks are saved in separate stages.

using SHA
include(joinpath(@__DIR__, "prepare_no36_full_lattice_group.jl"))
include(joinpath(@__DIR__, "restriction_functions.jl"))

const r92118_children = (92, 118)
const r92118_table = joinpath(@__DIR__, "..", "input", "family_numbering.md")
const r92118_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_all_pairs.tsv")
const r92118_families = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const r92118_witnesses = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_positive_edges.g")
const r92118_character_script = joinpath(@__DIR__, "restriction_92_118_geometric_characters.g")
const r92118_character_file = joinpath(@__DIR__, "restriction_92_118_geometric_characters.tsv")
const r92118_groups_file = joinpath(@__DIR__, "restriction_92_118_from_36.groups.mrdi")
const r92118_lattices_file = joinpath(@__DIR__, "restriction_92_118_from_36.lattices.mrdi")
const r92118_verified_file = joinpath(@__DIR__, "restriction_92_118_from_36.verified.mrdi")

r92118_note(s) = (println(s); flush(stdout))
r92118_hash(path) = bytes2hex(sha256(read(path)))
r92118_saved(items) = isempty(items) ? String[] : Tuple(items)
r92118_idx(n::Int,k::Int) = 36*k+n
r92118_normal(i::Int) = ((i-1)%36+1,(i-1)÷36)

function r92118_hashes()
    paths = (no36_cache,no36_source,r92118_table,r92118_edges,
        r92118_families,r92118_witnesses,r92118_character_script,
        r92118_character_file,@__FILE__,
        joinpath(@__DIR__, "prepare_no36_full_lattice_group.jl"),
        joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"),
        joinpath(@__DIR__, "restriction_functions.jl"),
        joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl"))
    all(isfile,paths) || error("A No. 92/118 input or the No. 36 cache is missing")
    return Tuple((basename(p),r92118_hash(p)) for p in paths)
end

function r92118_numbering_and_edges()
    expected = Dict(36=>(18,"S_3,3",2,6,1,(216,170)),
        92=>(14,"S3",2,6,2,(36,12)),
        118=>(12,"C3",2,6,3,(18,3)))
    found = Dict{Int,Tuple}()
    for line in eachline(r92118_table)
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
    found == expected || error("No. 36/92/118 numbering changed: $found")
    counts = Dict(n=>0 for n in r92118_children)
    for (i,line) in enumerate(eachline(r92118_edges))
        i == 1 && continue
        v = split(line,'\t')
        length(v) == 12 || error("Malformed containment row $i")
        source,target = parse(Int,v[1]),parse(Int,v[2])
        target == 36 && haskey(counts,source) || continue
        Tuple(parse.(Int,v[3:6])) ==
            (source == 92 ? (2,1,108,648) : (3,1,54,648)) ||
            error("Wrong No. $source -> 36 edge dimensions or orders")
        v[7:11] == ["embedded","direct","true","fail","found"] ||
            error("No. $source -> 36 is not direct and strict")
        v[12] == "A_strict" || error("Unexpected containment method")
        counts[source] += 1
    end
    all(x == 1 for x in values(counts)) ||
        error("Expected one strict edge for each child: $counts")
end

function r92118_geometric_characters()
    observed = Dict(n=>Dict{Tuple{Int,Int},Int}() for n in r92118_children)
    for (i,line) in enumerate(eachline(r92118_character_file))
        if i == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric-character header")
            continue
        end
        isempty(strip(line)) && continue
        v = split(line,'\t')
        length(v) == 4 || error("Malformed character row $i")
        n,ord,tr,count = parse.(Int,v)
        haskey(observed,n) && 1 <= ord <= 36 && -22 <= tr <= 22 && count > 0 ||
            error("Unexpected character row $i")
        key = (ord,tr)
        haskey(observed[n],key) && error("Duplicate No. $n character bin")
        observed[n][key] = count
    end
    frozen = Dict(
        92=>Dict((1,22)=>1,(2,-10)=>4,(2,6)=>3,(3,-2)=>6,
            (3,4)=>2,(6,-4)=>4,(6,0)=>6,(6,2)=>10),
        118=>Dict((1,22)=>1,(2,-10)=>3,(3,-2)=>6,(3,4)=>2,(6,2)=>6))
    for n in r92118_children
        sum(values(observed[n])) == (n == 92 ? 36 : 18) ||
            error("Incomplete No. $n projective character")
        got = sort!([(k[1],k[2],v) for (k,v) in observed[n]])
        want = sort!([(k[1],k[2],v) for (k,v) in frozen[n]])
        got == want || error("No. $n geometric character changed: $got")
    end
    return observed
end

function r92118_parent()
    cache = no36_verify_cache()
    source = load(no36_source)
    parent = source.cases[15].results[2]
    @assert parent.group_gap_id == (216,170) && parent.dimension == 1
    @assert cache.parent_number == 36 && cache.symplectic_order == 36
    @assert cache.quotient_order == 6 && cache.full_group_order == 216
    @assert rank(lattice(parent.Lambda0)) == 22
    @assert rank(lattice(parent.S_in_Lambda0)) == 18
    @assert isometry(cache.Lambda0) == isometry(parent.Lambda0)
    return parent,cache
end

function r92118_preflight()
    hashes = r92118_hashes()
    r92118_numbering_and_edges()
    expected = r92118_geometric_characters()
    parent,cache = r92118_parent()
    r92118_note("PASS: case 15 result 2, direct strict edges, full geometric characters")
    r92118_note("PASS: No. 36 kernel 36, quotient 6, parent ID (216,170)")
    return parent,cache,expected,hashes
end

function r92118_small_generators(small)
    function closure(gens)
        seen = Set([1]); todo = [1]; head = 1
        while head <= length(todo)
            x = todo[head]
            for g in gens
                y = small.mul(x,g)
                if !(y in seen)
                    push!(seen,y); push!(todo,y)
                end
            end
            head += 1
        end
        return seen
    end
    chosen = Int[]
    generated = Set([1])
    for g in unique(small.generator_ids)
        g in generated && continue
        push!(chosen,g)
        generated = closure(chosen)
        length(generated) == 36 && break
    end
    length(generated) == 36 || error("Reduced generators do not generate the kernel")
    return chosen
end

# The exact pair multiplication is (n,k)(m,l) =
# (n phi^k(m) c^floor((k+l)/6), (k+l) mod 6), where f^6=c.
function r92118_context(cache)
    small = direct_context(cache.symplectic_generators_S,
        cache.extra_generator_S,36,6)
    phipowers = [collect(1:36)]
    for _ in 1:5
        push!(phipowers,[small.phi[phipowers[end][i]] for i in 1:36])
    end
    function mul(i::Int,j::Int)
        n,k = r92118_normal(i); m,l = r92118_normal(j)
        u = small.mul(n,phipowers[k+1][m])
        k+l >= 6 && (u = small.mul(u,small.c))
        return r92118_idx(u,(k+l)%6)
    end
    inverse = [only(j for j in 1:216 if mul(i,j) == 1 && mul(j,i) == 1)
               for i in 1:216]
    @assert all(mul(i,inverse[i]) == 1 && mul(inverse[i],i) == 1 for i in 1:216)
    oneL = identity_matrix(QQ,22)
    nL = [foldl(*,(cache.symplectic_generators[j] for j in small.words[i]);
                 init=oneL) for i in 1:36]
    f = cache.extra_generator
    fpowers = [f^k for k in 0:5]
    E = basis_matrix(lattice(cache.S_in_Lambda0))*
        inv(basis_matrix(lattice(cache.Lambda0)))
    @assert all(small.elements[i]*E == E*nL[i] for i in 1:36)
    @assert cache.extra_generator_S*E == E*f
    @assert f^6 == nL[small.c]
    @assert length(Set(direct_matrix_key(nL[i]*fpowers[k+1])
                       for k in 0:5 for i in 1:36)) == 216
    orders = Int[]
    for i in 1:216
        x = 1; ord = 0
        while true
            x = mul(x,i); ord += 1
            x == 1 && break
            ord <= 216 || error("Element order exceeds No. 36 parent order")
        end
        push!(orders,ord)
    end
    traces = Dict{Int,Int}()
    generators = [r92118_small_generators(small);r92118_idx(1,1)]
    return (;small,phipowers,mul,inverse,nL,fpowers,orders,traces,generators)
end

r92118_matrix(ctx,i::Int) = begin
    n,k = r92118_normal(i)
    ctx.nL[n]*ctx.fpowers[k+1]
end

function r92118_trace(ctx,i::Int)
    return get!(ctx.traces,i) do
        m = r92118_matrix(ctx,i)
        tr = sum(m[j,j] for j in 1:22)
        denominator(tr) == 1 || error("Nonintegral primitive H4 trace")
        Int(numerator(tr))
    end
end

function r92118_histogram(ctx,key)
    hist = Dict{Tuple{Int,Int},Int}()
    for i in key
        bin = (ctx.orders[i],r92118_trace(ctx,i))
        hist[bin] = get(hist,bin,0)+1
    end
    sum(values(hist)) == length(key) && get(hist,(1,22),0) == 1 ||
        error("Incomplete subgroup character")
    return hist
end

function r92118_group_id(ctx,key,gens)
    positions = Dict(x=>i for (i,x) in enumerate(key))
    perms = Any[]
    for g in gens
        image = [positions[ctx.mul(g,x)] for x in key]
        sort(image) == collect(1:length(key)) || error("Bad regular subgroup permutation")
        push!(perms,GAP.Globals.PermList(GapObj(image)))
    end
    G = GAP.Globals.Group(perms...)
    Int(GAP.Globals.Size(G)) == length(key) || error("Wrong subgroup order")
    id = GAP.Globals.IdGroup(G)
    return (Int(id[1]),Int(id[2]))
end

function r92118_kernel_subgroups(ctx,child::Int)
    found = Dict{Any,Tuple}()
    if child == 92
        for (A,gens) in direct_s3_subgroups(ctx.small)
            length(A) == 6 || error("Wrong S3 kernel intersection")
            found[A] = gens
        end
    elseif child == 118
        for r in 2:36
            ctx.small.orders[r] == 3 && r < ctx.small.inverses[r] || continue
            A = Tuple(sort([1,r,ctx.small.mul(r,r)]))
            length(unique(A)) == 3 || error("Wrong C3 kernel intersection")
            found[A] = (r,)
        end
    else
        error("Only No. 92 or No. 118 is supported")
    end
    isempty(found) && error("No required subgroup of the parent symplectic kernel")
    return found
end

function r92118_subgroup_key(ctx,A,n::Int)
    x = r92118_idx(n,1)
    powers = Int[]
    y = 1
    for _ in 1:6
        push!(powers,y)
        y = ctx.mul(y,x)
    end
    y in A || error("Outer lift sixth power is outside its kernel intersection")
    key = Tuple(sort!([ctx.mul(a,p) for p in powers for a in A]))
    length(unique(key)) == 6*length(A) ||
        error("Outer lift did not give the expected quotient order")
    Tuple(i for i in key if i <= 36) == A ||
        error("Subgroup intersection with the symplectic kernel changed")
    return key
end

function r92118_raw(ctx,child::Int)
    kernels = r92118_kernel_subgroups(ctx,child)
    raw = Dict{Any,NamedTuple}()
    for A in sort!(collect(keys(kernels)))
        gens = kernels[A]
        for n in 1:36
            x = r92118_idx(n,1)
            y = 1
            for _ in 1:6
                y = ctx.mul(y,x)
            end
            y in A || continue
            all(ctx.mul(ctx.mul(x,a),ctx.inverse[x]) in A for a in gens) ||
                continue
            key = r92118_subgroup_key(ctx,A,n)
            get!(raw,key,(A=A,gens=gens,n=n))
        end
    end
    # Any subgroup projecting onto the parent C6 has a lift projecting to
    # its generator f. Thus k=1 visits every required subgroup; other
    # primitive coset exponents only repeat subgroups already present here.
    return kernels,raw
end

function r92118_classes(ctx,raw)
    unseen = Set(keys(raw))
    classes = NamedTuple[]
    while !isempty(unseen)
        first_key = first(sort!(collect(unseen)))
        orbit = Set([first_key]); todo = [first_key]; head = 1
        while head <= length(todo)
            key = todo[head]
            for g in ctx.generators
                next_key = Tuple(sort!([ctx.mul(ctx.mul(g,x),ctx.inverse[g])
                                        for x in key]))
                haskey(raw,next_key) ||
                    error("Candidate list is not closed under parent conjugacy")
                if !(next_key in orbit)
                    push!(orbit,next_key); push!(todo,next_key)
                end
            end
            head += 1
        end
        setdiff!(unseen,orbit)
        push!(classes,(key=first_key,orbit_size=length(orbit)))
    end
    sum(c.orbit_size for c in classes) == length(raw) ||
        error("Conjugacy classes do not partition the raw subgroups")
    return classes
end

function r92118_candidate(ctx,child,number,item,raw,expected)
    data = raw[item.key]
    gens = [collect(data.gens);r92118_idx(data.n,1)]
    id = r92118_group_id(ctx,item.key,gens)
    hist = r92118_histogram(ctx,item.key)
    target_id = child == 92 ? (36,12) : (18,3)
    matches = id == target_id && hist == expected[child]
    return (child_number=child,class_number=number,
        parent_conjugacy_orbit_size=item.orbit_size,
        subgroup_indices=item.key,
        kernel_indices=data.A,
        kernel_generator_indices=data.gens,
        outer_lift_index=r92118_idx(data.n,1),
        group_id=id,primitive_character_histogram=hist,
        character_matches=matches)
end

function r92118_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Output path must end in .mrdi")
    _,cache,expected,hashes = r92118_preflight()
    ctx = r92118_context(cache)
    candidates = NamedTuple[]
    statistics = NamedTuple[]
    for child in r92118_children
        kernels,raw = r92118_raw(ctx,child)
        classes = r92118_classes(ctx,raw)
        r92118_note("No. $child: $(length(kernels)) kernel subgroups, $(length(raw)) raw subgroups, $(length(classes)) parent-conjugacy classes")
        local_candidates = [r92118_candidate(ctx,child,j,item,raw,expected)
                            for (j,item) in enumerate(classes)]
        append!(candidates,local_candidates)
        push!(statistics,(child_number=child,kernel_subgroups=length(kernels),
            raw_subgroups=length(raw),parent_conjugacy_classes=length(classes),
            abstract_id_matches=count(c->c.group_id ==
                (child == 92 ? (36,12) : (18,3)),local_candidates),
            character_matches=count(c->c.character_matches,local_candidates)))
        for c in local_candidates
            r92118_note("No. $child class $(c.class_number): ID=$(c.group_id), orbit=$(c.parent_conjugacy_orbit_size), exact character=$(c.character_matches)")
        end
    end
    save(output,(format_version=1,source_hashes=hashes,parent_number=36,
        target_numbers=r92118_children,
        method="all S3 and C3 subgroups of the 36-element kernel; all n*f lifts; complete full-parent conjugacy",
        complete_within_saved_parent=true,
        all_abstract_ids_retained=true,
        statistics=Tuple(statistics),candidates=r92118_saved(candidates),
        lattice_and_root_checks_done=false,
        global_integral_uniqueness_claimed=false))
    check = load(output)
    @assert check.source_hashes == hashes
    @assert length(check.candidates) == length(candidates)
    r92118_note("Saved and reloaded $output")
end

function r92118_check_candidate(ctx,c,expected)
    A = Tuple(sort!(collect(c.kernel_indices)))
    gens = collect(c.kernel_generator_indices)
    key = r92118_subgroup_key(ctx,A,r92118_normal(c.outer_lift_index)[1])
    key == c.subgroup_indices || error("Saved subgroup indices changed")
    all(g in A for g in gens) || error("Saved kernel generators are outside A")
    r92118_group_id(ctx,key,[gens;c.outer_lift_index]) == c.group_id ||
        error("Saved subgroup abstract ID changed")
    r92118_histogram(ctx,key) == c.primitive_character_histogram ||
        error("Saved lattice character changed")
    target_id = c.child_number == 92 ? (36,12) : (18,3)
    c.character_matches ==
        (c.group_id == target_id &&
         c.primitive_character_histogram == expected[c.child_number]) ||
        error("Character label changed")
    return nothing
end

function r92118_lattice_data(parent,ctx,c)
    child = c.child_number
    expected_S = child == 92 ? 14 : 12
    expected_T = 22-expected_S
    expected_P = child == 92 ? 6 : 8
    expected_K = 22-expected_P
    expected_dim = child == 92 ? 2 : 3
    L = lattice(parent.Lambda0)
    symplectic_generators = [r92118_matrix(ctx,i)
                             for i in c.kernel_generator_indices]
    T = invariant_lattice(L,symplectic_generators;
        ambient_representation=false)
    S = orthogonal_submodule(L,T)
    rank(S) == expected_S && rank(T) == expected_T ||
        error("No. $child symplectic S/T rank mismatch")
    signature_tuple(S) == (expected_S,0,0) &&
        signature_tuple(T) == (expected_T-2,0,2) ||
        error("No. $child symplectic S/T signature mismatch")
    extra = r92118_matrix(ctx,c.outer_lift_index)
    Lf = integer_lattice_with_isometry(L,extra;
        ambient_representation=false,check=true)
    trivial_action_on_discriminant(Lf) ||
        error("No. $child action on A_Lambda0 is nontrivial")
    Simg = lattice_in_same_ambient_space(Lf,basis_matrix(S);check=true)
    Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
    basis_matrix(S)*gram_matrix(ambient_space(L))*
        transpose(basis_matrix(T)) == zero_matrix(QQ,expected_S,expected_T) ||
        error("S/T are not orthogonal")
    Taction = full_rank_model(Timg)
    Int(order_of_isometry(Taction)) == 6 ||
        error("No. $child quotient action does not have order six")
    pk = embedded_PK_data(Lf,Timg,6)
    P,K = pk.P_lattice,pk.K_lattice
    rank(P) == expected_P && rank(K) == expected_K ||
        error("No. $child P/K rank mismatch")
    signature_tuple(P) == (expected_P-2,0,2) &&
        signature_tuple(K) == (expected_K,0,0) ||
        error("No. $child P/K signature mismatch")
    period_dimension(P,6) == expected_dim ||
        error("No. $child period dimension mismatch")
    return (order=6,dimension=expected_dim,
        S_in_Lambda0=Simg,T_in_Lambda0=Timg,T_action=Taction,
        K_in_Lambda0=K,P_in_Lambda0=P,P_action=pk.P_with_isometry,
        Lambda0=Lf,group_gap_id=nothing,
        extracted_subgroup_id=c.group_id,
        group_id_source="exact finite subgroup of verified No. 36 parent",
        parent_number=36,possible_child_number=child,
        symplectic_generators_in_parent=Tuple(symplectic_generators),
        extra_generator_in_parent=extra,
        symplectic_saturation_verified=false)
end

function r92118_lattices(output,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Output path must end in .mrdi")
    groups = load(groups_path)
    @assert groups.format_version == 1 && groups.parent_number == 36
    @assert groups.target_numbers == r92118_children
    @assert groups.complete_within_saved_parent
    @assert groups.source_hashes == r92118_hashes()
    parent,cache = r92118_parent()
    ctx = r92118_context(cache)
    summaries = NamedTuple[]
    results = NamedTuple[]
    for c in groups.candidates
        c.character_matches || continue
        child = c.child_number
        L = lattice(parent.Lambda0)
        symplectic_generators = [r92118_matrix(ctx,i)
                                 for i in c.kernel_generator_indices]
        T = invariant_lattice(L,symplectic_generators;
            ambient_representation=false)
        S = orthogonal_submodule(L,T)
        rank_P = 0; rank_K = 0; index = 0; dimension = -1; reason = ""
        expected_S = child == 92 ? 14 : 12
        if rank(S) != expected_S || rank(T) != 22-expected_S
            reason = "symplectic rank mismatch"
        elseif signature_tuple(S) != (expected_S,0,0) ||
               signature_tuple(T) != (20-expected_S,0,2)
            reason = "symplectic signature mismatch"
        else
            extra = r92118_matrix(ctx,c.outer_lift_index)
            Lf = integer_lattice_with_isometry(L,extra;
                ambient_representation=false,check=true)
            @assert trivial_action_on_discriminant(Lf)
            Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
            index = Int(order_of_isometry(full_rank_model(Timg)))
            if index != 6
                reason = "quotient action order mismatch"
            else
                pk = embedded_PK_data(Lf,Timg,6)
                rank_P,rank_K = rank(pk.P_lattice),rank(pk.K_lattice)
                expected_P = child == 92 ? 6 : 8
                if rank_P != expected_P || rank_K != 22-expected_P
                    reason = "period/complement rank mismatch"
                elseif signature_tuple(pk.P_lattice) != (expected_P-2,0,2) ||
                       signature_tuple(pk.K_lattice) != (22-expected_P,0,0)
                    reason = "period/complement signature mismatch"
                else
                    dimension = period_dimension(pk.P_lattice,6)
                    dimension == (child == 92 ? 2 : 3) ||
                        (reason = "period dimension mismatch")
                end
            end
        end
        push!(summaries,(child_number=child,class_number=c.class_number,
            rank_S=rank(S),rank_T=rank(T),rank_P=rank_P,rank_K=rank_K,
            index=index,dimension=dimension,matched=isempty(reason),reason=reason))
        r92118_note("No. $child class $(c.class_number): S=$(rank(S)), P=$rank_P, dim=$dimension, reason=$reason")
        isempty(reason) || continue
        push!(results,(child_number=child,class_number=c.class_number,
            result=r92118_lattice_data(parent,ctx,c)))
    end
    counts = Tuple((child_number=n,
        lattice_matches=count(r->r.child_number==n,results))
        for n in r92118_children)
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=r92118_hash(groups_path),
        target_numbers=r92118_children,
        summaries=r92118_saved(summaries),results=r92118_saved(results),
        counts=counts,all_character_matches_processed=true,
        roots_verified=false,symplectic_saturation_verified=false,
        global_integral_uniqueness_claimed=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert length(check.results) == length(results)
    r92118_note("Saved and reloaded $output; lattice matches=$counts")
end

function r92118_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Output path must end in .mrdi")
    groups,data = load(groups_path),load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.source_hashes == data.source_hashes == r92118_hashes()
    @assert data.groups_file_hash == r92118_hash(groups_path)
    parent,cache,expected,_ = r92118_preflight()
    ctx = r92118_context(cache)
    verified = NamedTuple[]
    obstructed = NamedTuple[]
    for r in data.results
        c = only(x for x in groups.candidates if
            x.child_number == r.child_number &&
            x.class_number == r.class_number)
        c.character_matches || error("Saved nonmatching class among lattice results")
        r92118_check_candidate(ctx,c,expected)
        fresh = r92118_lattice_data(parent,ctx,c)
        @assert basis_matrix(lattice(fresh.S_in_Lambda0)) ==
                basis_matrix(lattice(r.result.S_in_Lambda0))
        @assert basis_matrix(lattice(fresh.T_in_Lambda0)) ==
                basis_matrix(lattice(r.result.T_in_Lambda0))
        @assert basis_matrix(fresh.P_in_Lambda0) ==
                basis_matrix(r.result.P_in_Lambda0)
        @assert basis_matrix(fresh.K_in_Lambda0) ==
                basis_matrix(r.result.K_in_Lambda0)
        @assert isometry(fresh.T_action) == isometry(r.result.T_action)
        if has_root(fresh.K_in_Lambda0,lattice(parent.Lambda0))
            push!(obstructed,(child_number=c.child_number,
                class_number=c.class_number,group_id=c.group_id))
            r92118_note("No. $(c.child_number) class $(c.class_number): root obstruction")
        else
            push!(verified,(child_number=c.child_number,
                class_number=c.class_number,group_id=c.group_id,
                roots_verified=true,result=fresh))
            r92118_note("No. $(c.child_number) class $(c.class_number): subgroup, lattice and roots verified")
        end
    end
    length(verified)+length(obstructed) == length(data.results) ||
        error("Incomplete root verification")
    counts = Tuple((child_number=n,
        root_free=count(r->r.child_number==n,verified),
        root_obstructed=count(r->r.child_number==n,obstructed))
        for n in r92118_children)
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=r92118_hash(groups_path),
        lattices_file_hash=r92118_hash(lattices_path),
        target_numbers=r92118_children,counts=counts,
        verified_results=r92118_saved(verified),
        root_obstructed=r92118_saved(obstructed),
        roots_verified=true,complete_within_saved_parent=true,
        all_character_matches_processed=data.all_character_matches_processed,
        symplectic_saturation_verified=false,
        global_integral_uniqueness_claimed=false))
    check = load(output)
    @assert check.source_hashes == data.source_hashes
    @assert length(check.verified_results) == length(verified)
    r92118_note("Saved and reloaded $output; root outcomes=$counts")
end

function r92118_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices, or verify")
    stage = ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no extra arguments")
        r92118_preflight()
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        r92118_groups(length(ARGS)==2 ? abspath(ARGS[2]) : r92118_groups_file)
    elseif stage == "lattices"
        length(ARGS) <= 3 || error("lattices [output.mrdi] [groups.mrdi]")
        r92118_lattices(length(ARGS)>=2 ? abspath(ARGS[2]) : r92118_lattices_file,
            length(ARGS)==3 ? abspath(ARGS[3]) : r92118_groups_file)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        r92118_verify(length(ARGS)>=2 ? abspath(ARGS[2]) : r92118_verified_file,
            length(ARGS)>=3 ? abspath(ARGS[3]) : r92118_lattices_file,
            length(ARGS)==4 ? abspath(ARGS[4]) : r92118_groups_file)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    r92118_main()
end
