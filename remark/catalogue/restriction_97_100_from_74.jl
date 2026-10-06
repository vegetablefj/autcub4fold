# Exhaustive subgroup-class pilot for Nos. 97--100 inside the saved full
# lattice group of No. 74.  The symplectic kernel is C2^2, not cyclic: its
# common invariant lattice is computed from both symplectic generators.
# No stage computes the large lattice automorphism group anew.
# In particular, [8,5] = C2^3 is three-generated.  All subgroups of the
# 16-element parent are enumerated by closing under adjoining one element;
# a two-generator-only search would be incomplete for Nos. 98 and 100.
#
# First run restriction_97_100_geometric_characters.g in GAP, then run:
#   julia restriction_97_100_from_74.jl preflight
#   julia restriction_97_100_from_74.jl groups
#   julia restriction_97_100_from_74.jl lattices
#   julia restriction_97_100_from_74.jl verify
# Every output is saved/reloaded and never overwritten. All matching parent
# conjugacy classes are retained; no numbered assignment is presumed unique.

using SHA
include(joinpath(@__DIR__, "restriction_functions.jl"))

const v4_specs = (
    (child=97,  id=(4,2), index=1, dimension=8),
    (child=98,  id=(8,5), index=2, dimension=7),
    (child=99,  id=(8,3), index=2, dimension=6),
    (child=100, id=(8,5), index=2, dimension=5),
)
const v4_parent_number = 74
const v4_parent_id = (16,11)
const v4_parent_index = 2
const v4_parent_dimension = 4
const v4_parent_rank_S = 15
const v4_child_rank_S = 12
const v4_symplectic_order = 4
const v4_source_file = joinpath(@__DIR__, "..", "..", "oscar", "oscar_script_data.mrdi")
const v4_table_file = joinpath(@__DIR__, "..", "input", "family_numbering.md")
const v4_containment_file = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_all_pairs.tsv")
const v4_cache_file = joinpath(@__DIR__, "source_74_full_lattice_group.mrdi")
const v4_character_file = joinpath(@__DIR__, "restriction_97_100_geometric_characters.tsv")
const v4_groups_file = joinpath(@__DIR__, "restriction_97_100_from_74.groups.mrdi")
const v4_lattices_file = joinpath(@__DIR__, "restriction_97_100_from_74.lattices.mrdi")
const v4_verified_file = joinpath(@__DIR__, "restriction_97_100_from_74.verified.mrdi")

v4_note(s) = (println(s); flush(stdout))
v4_hash(path) = bytes2hex(sha256(read(path)))
v4_spec(number) = only(s for s in v4_specs if s.child == number)

function v4_hashes()
    files = (v4_source_file,v4_table_file,v4_containment_file,
        v4_cache_file,v4_character_file)
    all(isfile,files) || error("Missing input; first run the GAP character script")
    return Tuple(v4_hash(file) for file in files)
end

function v4_table_check()
    expected = Dict(v4_parent_number => (v4_parent_rank_S,v4_parent_index,
        v4_parent_dimension,v4_parent_id))
    for spec in v4_specs
        expected[spec.child] = (v4_child_rank_S,spec.index,
            spec.dimension,spec.id)
    end
    seen = Set{Int}()
    for line in eachline(v4_table_file)
        startswith(line,"|") || continue
        cells = strip.(split(line,'|'))
        length(cells) >= 9 || continue
        n = tryparse(Int,cells[2])
        n === nothing && continue
        haskey(expected,n) || continue
        m = match(r"\[(\d+),(\d+)\]",cells[8])
        m === nothing && error("Missing group ID in numbered row $n")
        actual = (parse(Int,cells[3]),parse(Int,cells[6]),
            parse(Int,cells[7]),(parse(Int,m.captures[1]),
                parse(Int,m.captures[2])))
        actual == expected[n] || error("Numbered row $n changed: $actual")
        push!(seen,n)
    end
    seen == Set(keys(expected)) || error("A numbered family row is missing")
end

function v4_containment_check()
    found = Set{Int}()
    for (line_number,line) in enumerate(eachline(v4_containment_file))
        line_number == 1 && continue
        fields = split(line,'\t')
        length(fields) == 12 || error("Malformed containment row $line_number")
        source,target = parse(Int,fields[1]),parse(Int,fields[2])
        target == v4_parent_number || continue
        any(s -> s.child == source,v4_specs) || continue
        spec = v4_spec(source)
        @assert parse(Int,fields[3]) == spec.dimension
        @assert parse(Int,fields[4]) == v4_parent_dimension
        @assert parse(Int,fields[5]) == 3*spec.id[1]
        @assert parse(Int,fields[6]) == 3*v4_parent_id[1]
        @assert fields[7] == "embedded" && fields[8] == "direct"
        @assert fields[9] == "true" && fields[10] == "fail"
        @assert fields[12] in ("literal_matrix_subgroup","A_strict")
        push!(found,source)
    end
    found == Set(s.child for s in v4_specs) ||
        error("A strict geometric containment is missing")
end

function v4_expected_characters()
    expected = Dict(s.child => Dict{Tuple{Int,Int},Int}() for s in v4_specs)
    for (line_number,line) in enumerate(eachline(v4_character_file))
        if line_number == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected character TSV header")
            continue
        end
        isempty(strip(line)) && continue
        fields = split(line,'\t')
        length(fields) == 4 || error("Malformed character row $line_number")
        n,ord,tr,count = parse.(Int,fields)
        haskey(expected,n) || error("Unexpected family in character file")
        count > 0 || error("Nonpositive character count")
        key = (ord,tr)
        haskey(expected[n],key) && error("Duplicate character bin")
        expected[n][key] = count
    end
    for spec in v4_specs
        hist = expected[spec.child]
        sum(values(hist)) == spec.id[1] || error("Incomplete No. $(spec.child) character")
        get(hist,(1,22),0) == 1 || error("Bad identity character")
    end
    return expected
end

function v4_parent()
    source = load(v4_source_file)
    @assert source.format_version == 3 && source.completed_cases == 29
    case = source.cases[29]
    @assert case.case_index == 29
    parent = case.results[1]
    @assert parent.group_gap_id == v4_parent_id
    @assert parent.order == v4_parent_index
    @assert parent.dimension == v4_parent_dimension
    L = lattice(parent.Lambda0)
    S = lattice(parent.S_in_Lambda0)
    @assert rank(L) == 22 && rank(S) == v4_parent_rank_S
    @assert signature_tuple(L) == (20,0,2) && abs(det(gram_matrix(L))) == 3
    cache = load(v4_cache_file)
    @assert cache.parent_number == v4_parent_number
    @assert cache.full_group_id == v4_parent_id
    @assert gram_matrix(lattice(cache.Lambda0)) == gram_matrix(L)
    @assert basis_matrix(lattice(cache.Lambda0)) == basis_matrix(L)
    @assert isometry(cache.Lambda0) == isometry(parent.Lambda0)
    @assert basis_matrix(lattice(cache.S_in_Lambda0)) == basis_matrix(S)
    @assert cache.extra_generator == isometry(parent.Lambda0)
    lifts = cache.symplectic_generators
    @assert !isempty(lifts)
    H = matrix_group(vcat(lifts,[cache.extra_generator]))
    N,_ = sub(H,[H(g) for g in lifts])
    @assert Int(order(H)) == v4_parent_id[1]
    @assert small_group_identification(H) == v4_parent_id
    @assert Int(order(N)) == div(v4_parent_id[1],v4_parent_index)
    @assert small_group_identification(N) == (8,3) # D8
    items = collect(elements(H))
    @assert all(h*n*inv(h) in N for h in items, n in elements(N))
    return (;parent,L,H,N,items)
end

function v4_trace(A)
    value = sum(A[i,i] for i in 1:22)
    denominator(value) == 1 || error("Nonintegral primitive trace")
    return Int(numerator(value))
end

function v4_histogram(B)
    hist = Dict{Tuple{Int,Int},Int}()
    for x in elements(B)
        key = (Int(order(x)),v4_trace(matrix(x)))
        hist[key] = get(hist,key,0)+1
    end
    @assert sum(values(hist)) == Int(order(B))
    @assert get(hist,(1,22),0) == 1
    return hist
end

function v4_generators(B,ctx,spec)
    overlap = [x for x in elements(B) if x in ctx.N]
    length(overlap) == v4_symplectic_order || return nothing
    sym = nothing
    for u in overlap, v in overlap
        D,_ = sub(ctx.H,[u,v])
        if Int(order(D)) == v4_symplectic_order &&
           all(x in D for x in overlap) &&
           Int(order(u)) <= 2 && Int(order(v)) <= 2
            sym = (u,v)
            break
        end
    end
    sym === nothing && return nothing
    if spec.index == 1
        @assert Int(order(B)) == v4_symplectic_order
        extra = only(x for x in ctx.items if Int(order(x)) == 1)
    else
        extra = nothing
        for x in elements(B)
            x in ctx.N && continue
            D,_ = sub(ctx.H,[sym[1],sym[2],x])
            if Int(order(D)) == spec.id[1]
                extra = x
                break
            end
        end
        extra === nothing && return nothing
    end
    return (Tuple(matrix(x) for x in sym),matrix(extra))
end

function v4_all_subgroups(ctx)
    # Breadth-first closure under adding each parent element is exhaustive:
    # every subgroup is generated by a finite sequence of its own elements.
    identity = only(x for x in ctx.items if Int(order(x)) == 1)
    trivial,_ = sub(ctx.H,[identity])
    groups = NamedTuple[(B=trivial,generators=[identity])]
    seen = Set{Any}([Tuple(x in trivial for x in ctx.items)])
    head = 1
    while head <= length(groups)
        current = groups[head]
        for x in ctx.items
            x in current.B && continue
            generators = vcat(current.generators,[x])
            B,_ = sub(ctx.H,generators)
            mask = Tuple(y in B for y in ctx.items)
            mask in seen && continue
            push!(seen,mask)
            push!(groups,(B=B,generators=generators))
        end
        head += 1
    end
    @assert length(groups) == length(seen)
    @assert any(g -> Int(order(g.B)) == Int(order(ctx.H)),groups)
    # Independent GAP check: SmallGroup(16,11) has 35 exact subgroups;
    # among them, 13 are [4,2], two are [8,5], and four are [8,3].
    @assert length(groups) == 35
    for (id,expected_count) in (((4,2),13),((8,5),2),((8,3),4))
        @assert count(g -> Int(order(g.B)) == id[1] &&
            small_group_identification(g.B) == id,groups) == expected_count
    end
    # Independently verify that the enumerated set is closed under every
    # possible one-element extension; this is a cheap completeness audit.
    @assert all(Tuple(y in first(sub(ctx.H,vcat(g.generators,[x])))
        for y in ctx.items) in seen for g in groups for x in ctx.items)
    return groups
end

function v4_candidates(ctx,spec,all_subgroups)
    raw = NamedTuple[]
    for entry in all_subgroups
        B = entry.B
        Int(order(B)) == spec.id[1] || continue
        small_group_identification(B) == spec.id || continue
        pair = v4_generators(B,ctx,spec)
        pair === nothing && continue
        push!(raw,(B=B,symplectic_generators=pair[1],
            extra_generator=pair[2]))
    end
    classes = NamedTuple[]
    visited = Set{Int}()
    for i in eachindex(raw)
        i in visited && continue
        elements_B = collect(elements(raw[i].B))
        orbit = [j for j in eachindex(raw) if any(h ->
            all(x -> h*x*inv(h) in raw[j].B,elements_B),ctx.items)]
        push!(classes,(representative=i,orbit_size=length(orbit)))
        union!(visited,orbit)
    end
    length(visited) == length(raw) || error("Incomplete parent-conjugacy partition")
    return raw,classes
end

function v4_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    hashes = v4_hashes()
    v4_table_check(); v4_containment_check()
    expected = v4_expected_characters()
    ctx = v4_parent()
    all_subgroups = v4_all_subgroups(ctx)
    v4_note("Enumerated $(length(all_subgroups)) exact subgroups of the 16-element parent")
    candidates = NamedTuple[]
    for spec in v4_specs
        raw,classes = v4_candidates(ctx,spec,all_subgroups)
        v4_note("No. $(spec.child): $(length(raw)) exact subgroups; $(length(classes)) parent classes")
        for (class_number,cl) in enumerate(classes)
            c = raw[cl.representative]
            hist = v4_histogram(c.B)
            matched = hist == expected[spec.child]
            push!(candidates,(child=spec.child,parent=v4_parent_number,
                class_number=class_number,orbit_size=cl.orbit_size,
                group_id=spec.id,symplectic_order=v4_symplectic_order,
                quotient_order=spec.index,character_match=matched,
                primitive_character_histogram=hist,
                symplectic_generators=c.symplectic_generators,
                extra_generator=c.extra_generator))
            v4_note("  class $class_number: orbit $(cl.orbit_size), character match=$matched")
        end
    end
    save(output,(format_version=1,source_hashes=hashes,
        character_file=basename(v4_character_file),
        candidates=Tuple(candidates),numbered_assignment_claimed=false))
    check=load(output)
    @assert check.source_hashes == hashes
    @assert length(check.candidates) == length(candidates)
    v4_note("Saved and reloaded $output")
end

function v4_restriction(ctx,spec,c;verify_roots::Bool)
    # The common fixed lattice of the two C2^2 generators is primitive.
    T = invariant_lattice(ctx.L,collect(c.symplectic_generators);
        ambient_representation=false)
    S = orthogonal_submodule(ctx.L,T)
    @assert rank(S) == v4_child_rank_S && rank(T) == 22-v4_child_rank_S
    @assert signature_tuple(S) == (rank(S),0,0)
    @assert signature_tuple(T) == (rank(T)-2,0,2)
    Lf = integer_lattice_with_isometry(ctx.L,c.extra_generator;
        ambient_representation=false,check=true)
    @assert trivial_action_on_discriminant(Lf)
    Simg = lattice_in_same_ambient_space(Lf,basis_matrix(S);check=true)
    Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
    @assert basis_matrix(S)*gram_matrix(ambient_space(ctx.L))*
        transpose(basis_matrix(T)) == zero_matrix(QQ,rank(S),rank(T))
    Taction = full_rank_model(Timg)
    @assert Int(order_of_isometry(Taction)) == spec.index
    pk = embedded_PK_data(Lf,Timg,spec.index)
    P,K = pk.P_lattice,pk.K_lattice
    @assert rank(P)+rank(K) == 22
    @assert signature_tuple(P) == (rank(P)-2,0,2)
    @assert signature_tuple(K) == (rank(K),0,0)
    @assert period_dimension(P,spec.index) == spec.dimension
    verify_roots && @assert !has_root(K,ctx.L)
    return (order=spec.index,dimension=spec.dimension,
        S_in_Lambda0=Simg,T_in_Lambda0=Timg,T_action=Taction,
        K_in_Lambda0=K,P_in_Lambda0=P,P_action=pk.P_with_isometry,
        Lambda0=Lf,group_gap_id=nothing,
        symplectic_kernel_order_S=nothing,
        symplectic_kernel_order_K=nothing,
        symplectic_saturation_verified=false,
        extracted_subgroup_id=spec.id,
        group_id_source="verified subgroup of cached parent full group",
        parent_number=v4_parent_number,child_number=spec.child,
        symplectic_generators_in_parent=c.symplectic_generators,
        extra_generator_in_parent=c.extra_generator)
end

function v4_lattices(output,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups=load(groups_path)
    @assert groups.format_version == 1 && groups.source_hashes == v4_hashes()
    ctx=v4_parent()
    summaries=NamedTuple[]
    results=NamedTuple[]
    for c in groups.candidates
        c.character_match || continue
        spec=v4_spec(c.child)
        T=invariant_lattice(ctx.L,collect(c.symplectic_generators);
            ambient_representation=false)
        S=orthogonal_submodule(ctx.L,T)
        reason=""; index=0; dimension=-1; rank_P=0; rank_K=0
        if rank(S) != v4_child_rank_S || rank(T) != 22-v4_child_rank_S
            reason="symplectic coinvariant rank mismatch"
        else
            Lf=integer_lattice_with_isometry(ctx.L,c.extra_generator;
                ambient_representation=false,check=true)
            @assert trivial_action_on_discriminant(Lf)
            Timg=lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
            index=Int(order_of_isometry(full_rank_model(Timg)))
            if index != spec.index
                reason="quotient action order mismatch"
            else
                pk=embedded_PK_data(Lf,Timg,index)
                rank_P=rank(pk.P_lattice); rank_K=rank(pk.K_lattice)
                if signature_tuple(pk.P_lattice) != (rank_P-2,0,2) ||
                   signature_tuple(pk.K_lattice) != (rank_K,0,0)
                    reason="period/complement signature mismatch"
                else
                    dimension=period_dimension(pk.P_lattice,index)
                    dimension == spec.dimension || (reason="period dimension mismatch")
                end
            end
        end
        push!(summaries,(child=spec.child,parent=v4_parent_number,
            class_number=c.class_number,rank_S=rank(S),rank_T=rank(T),
            rank_P=rank_P,rank_K=rank_K,index=index,dimension=dimension,
            reason=reason))
        v4_note("No. $(spec.child) class $(c.class_number): S=$(rank(S)), P=$rank_P, dimension=$dimension, reason=$reason")
        isempty(reason) || continue
        result=v4_restriction(ctx,spec,c;verify_roots=false)
        push!(results,(child=spec.child,parent=v4_parent_number,
            class_number=c.class_number,result=result))
    end
    counts=Tuple((child=s.child,
        count=count(r -> r.child == s.child,results)) for s in v4_specs)
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=v4_hash(groups_path),summaries=Tuple(summaries),
        results=Tuple(results),matching_parent_match_counts=counts,
        roots_verified=false,symplectic_saturation_verified=false,
        numbered_assignment_claimed=false))
    check=load(output)
    @assert length(check.results) == length(results)
    v4_note("Saved and reloaded $output; character/period matches: $counts")
end

function v4_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups=load(groups_path); data=load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.source_hashes == data.source_hashes == v4_hashes()
    @assert data.groups_file_hash == v4_hash(groups_path)
    ctx=v4_parent()
    verified=NamedTuple[]
    for r in data.results
        c=only(x for x in groups.candidates if
            x.child == r.child && x.class_number == r.class_number)
        @assert c.character_match
        B,_=sub(ctx.H,vcat([ctx.H(g) for g in c.symplectic_generators],
            [ctx.H(c.extra_generator)]))
        @assert Int(order(B)) == c.group_id[1]
        @assert small_group_identification(B) == c.group_id
        overlap=[x for x in elements(B) if x in ctx.N]
        @assert length(overlap) == v4_symplectic_order
        D,_=sub(ctx.H,[ctx.H(g) for g in c.symplectic_generators])
        @assert Int(order(D)) == v4_symplectic_order
        @assert all(x in D for x in overlap)
        @assert v4_histogram(B) == c.primitive_character_histogram
        spec=v4_spec(r.child)
        result=v4_restriction(ctx,spec,c;verify_roots=true)
        @assert gram_matrix(result.P_in_Lambda0) ==
            gram_matrix(r.result.P_in_Lambda0)
        @assert gram_matrix(result.K_in_Lambda0) ==
            gram_matrix(r.result.K_in_Lambda0)
        @assert isometry(result.T_action) == isometry(r.result.T_action)
        push!(verified,(child=spec.child,parent=v4_parent_number,
            class_number=c.class_number,group_id=c.group_id,
            roots_verified=true,result=result))
        v4_note("Verified roots and extracted group for No. $(spec.child) class $(c.class_number)")
    end
    counts=Tuple((child=s.child,
        count=count(r -> r.child == s.child,verified)) for s in v4_specs)
    @assert counts == data.matching_parent_match_counts
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=v4_hash(groups_path),
        lattices_file_hash=v4_hash(lattices_path),
        verified_results=Tuple(verified),matching_parent_match_counts=counts,
        roots_verified=true,symplectic_saturation_verified=false,
        numbered_assignment_claimed=false))
    check=load(output)
    @assert length(check.verified_results) == length(verified)
    v4_note("Saved and reloaded $output; root-verified matches: $counts")
end

function v4_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices, or verify")
    stage=ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no arguments")
        hashes=v4_hashes()
        v4_table_check(); v4_containment_check(); v4_expected_characters()
        v4_parent()
        v4_note("Preflight passed; source SHA-256 tuple=$hashes")
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        v4_groups(length(ARGS) == 2 ? abspath(ARGS[2]) : v4_groups_file)
    elseif stage == "lattices"
        length(ARGS) <= 3 || error("lattices [output.mrdi] [groups.mrdi]")
        v4_lattices(length(ARGS) >= 2 ? abspath(ARGS[2]) : v4_lattices_file,
            length(ARGS) == 3 ? abspath(ARGS[3]) : v4_groups_file)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        v4_verify(length(ARGS) >= 2 ? abspath(ARGS[2]) : v4_verified_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : v4_lattices_file,
            length(ARGS) == 4 ? abspath(ARGS[4]) : v4_groups_file)
    else
        error("Unknown stage: $stage")
    end
end

v4_main()
