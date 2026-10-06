# Exhaustive restrictions inside the *saved* full lattice actions of Nos. 78
# and 81. No automorphism-group search of S is performed. Run the companion
# GAP character/witness script before `groups`.
#
#   julia restriction_small_from_78_81.jl preflight
#   julia restriction_small_from_78_81.jl groups [output.mrdi]
#   julia restriction_small_from_78_81.jl lattices [output.mrdi] [groups.mrdi] [parent:class]
#   julia restriction_small_from_78_81.jl verify [output.mrdi] [lattices.mrdi] [groups.mrdi]
#
# Each stage refuses to overwrite an existing output. Character matches and
# unique filtered classes remain candidate identifications, not an asserted
# explicit intertwiner between the geometric and saved lattice parent groups.

using SHA
include(joinpath(@__DIR__, "restriction_functions.jl"))

const small_specs = (
    (number=77, parent=78, rank_S=14, sym_order=4, group_id=(4,1), index=1, dimension=6),
    (number=119, parent=78, rank_S=8, sym_order=2, group_id=(2,1), index=1, dimension=12),
    (number=120, parent=78, rank_S=8, sym_order=2, group_id=(4,2), index=2, dimension=10),
    (number=122, parent=78, rank_S=8, sym_order=2, group_id=(4,2), index=2, dimension=6),
    (number=79, parent=81, rank_S=14, sym_order=4, group_id=(8,2), index=2, dimension=4),
    (number=124, parent=81, rank_S=8, sym_order=2, group_id=(8,2), index=4, dimension=5),
)
const small_parent_files = Dict(
    78 => "restriction_complete_78_from_74.mrdi",
    81 => "restriction_complete_81_from_51.mrdi",
)
const small_parent_ids = Dict(78 => (8,3), 81 => (16,2))
const small_table = joinpath(@__DIR__, "..", "input", "family_numbering.md")
const small_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_all_pairs.tsv")
const small_characters = joinpath(@__DIR__,
    "restriction_small_78_81_geometric_characters.tsv")
const small_groups_default = joinpath(@__DIR__, "restriction_small_78_81.groups.mrdi")
const small_lattices_default = joinpath(@__DIR__, "restriction_small_78_81.lattices.mrdi")
const small_verified_default = joinpath(@__DIR__, "restriction_small_78_81.verified.mrdi")

small_hash(path) = bytes2hex(sha256(read(path)))
small_note(s) = (println(s); flush(stdout))
small_parent_path(n) = joinpath(@__DIR__, small_parent_files[n])

function small_sources()
    paths = (small_table, small_edges, small_characters,
        small_parent_path(78), small_parent_path(81))
    all(isfile, paths) || error("Missing source; run restriction_small_78_81_geometric_characters.g first")
    return Tuple(small_hash(p) for p in paths)
end

function small_table_checks()
    found = Dict{Int,Tuple{Int,Int,Int,Tuple{Int,Int}}}()
    for line in eachline(small_table)
        startswith(line, "|") || continue
        cells = strip.(split(line, '|'))
        length(cells) >= 9 || continue
        n = tryparse(Int, cells[2])
        n === nothing && continue
        any(s -> s.number == n, small_specs) || continue
        match_id = match(r"\[(\d+),(\d+)\]", cells[8])
        match_id === nothing && error("Missing projective group ID for No. $n")
        found[n] = (parse(Int,cells[3]), parse(Int,cells[6]),
            parse(Int,match(r"\d+", cells[7]).match),
            (parse(Int,match_id.captures[1]), parse(Int,match_id.captures[2])))
    end
    for s in small_specs
        get(found,s.number,nothing) == (s.rank_S,s.index,s.dimension,s.group_id) ||
            error("Numbered table row $(s.number) changed")
    end
end

function small_strict_checks()
    expected = Set((s.number,s.parent) for s in small_specs)
    observed = Set{Tuple{Int,Int}}()
    for (i,line) in enumerate(eachline(small_edges))
        i == 1 && continue
        fields = split(line, '\t')
        length(fields) == 12 || error("Malformed strict-containment TSV line $i")
        a, b = parse(Int,fields[1]), parse(Int,fields[2])
        (a,b) in expected || continue
        s = only(x for x in small_specs if x.number == a && x.parent == b)
        @assert parse(Int,fields[3]) == s.dimension
        @assert parse(Int,fields[4]) == (b == 78 ? 5 : 2)
        @assert parse(Int,fields[5]) == 3*s.group_id[1]
        @assert parse(Int,fields[6]) == 3*small_parent_ids[b][1]
        @assert fields[7] == "embedded" && fields[8] == "direct"
        @assert fields[9] == "true" && fields[10] == "fail"
        @assert fields[12] in ("literal_matrix_subgroup", "A_strict")
        push!(observed,(a,b))
    end
    observed == expected || error("A required direct strict linear embedding is absent")
end

function small_expected_characters()
    expected = Dict(s.number => Dict{Tuple{Int,Int},Int}() for s in small_specs)
    for (i,line) in enumerate(eachline(small_characters))
        i == 1 && (line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
            error("Unexpected geometric character header"))
        i == 1 && continue
        isempty(strip(line)) && continue
        fields = split(line,'\t')
        length(fields) == 4 || error("Malformed character line $i")
        n, k, tr, count = parse.(Int,fields)
        haskey(expected,n) && count > 0 || error("Unexpected character row $i")
        key = (k,tr)
        haskey(expected[n],key) && error("Duplicate character bin")
        expected[n][key] = count
    end
    for s in small_specs
        @assert sum(values(expected[s.number])) == s.group_id[1]
        @assert get(expected[s.number],(1,22),0) == 1
    end
    return expected
end

function small_parent(n)
    record = load(small_parent_path(n))
    @assert record.format_version == 1
    @assert record.verify_group_id && record.verify_roots
    r = record.result
    @assert r.child_number == n && r.group_gap_id == small_parent_ids[n]
    @assert r.extracted_subgroup_id == small_parent_ids[n]
    @assert rank(lattice(r.Lambda0)) == 22
    @assert signature_tuple(lattice(r.Lambda0)) == (20,0,2)
    @assert abs(det(gram_matrix(lattice(r.Lambda0)))) == 3
    @assert rank(lattice(r.S_in_Lambda0)) == 14
    @assert isometry(r.Lambda0) == r.extra_generator_in_parent
    @assert order_of_isometry(r.T_action) == r.order
    H = matrix_group([r.symplectic_generator_in_parent,
                      r.extra_generator_in_parent])
    N, _ = sub(H,[H(r.symplectic_generator_in_parent)])
    @assert Int(order(H(r.symplectic_generator_in_parent))) == 4
    @assert Int(order(H)) == small_parent_ids[n][1]
    @assert small_group_identification(H) == small_parent_ids[n]
    @assert Int(order(N)) == 4 && small_group_identification(N) == (4,1)
    @assert all(h*x*inv(h) in N for h in elements(H), x in elements(N))
    return (; result=r, H, N, elements_H=collect(elements(H)))
end

function small_trace(A)
    t = sum(A[i,i] for i in 1:22)
    denominator(t) == 1 || error("Nonintegral primitive trace")
    return Int(numerator(t))
end

function small_histogram(B)
    hist = Dict{Tuple{Int,Int},Int}()
    for x in elements(B)
        key = (Int(order(x)),small_trace(matrix(x)))
        hist[key] = get(hist,key,0)+1
    end
    @assert sum(values(hist)) == Int(order(B))
    @assert get(hist,(1,22),0) == 1
    return hist
end

function small_eligible_subgroups(parent_number, ctx)
    all_h = ctx.elements_H
    seen = Set{Any}()
    raw = Any[]
    for a in all_h, b in all_h
        B, _ = sub(ctx.H,[a,b])
        len = Int(order(B))
        len in (2,4,8) || continue
        mask = Tuple(x in B for x in all_h)
        mask in seen && continue
        push!(seen,mask)
        gid = small_group_identification(B)
        overlap = [x for x in elements(B) if x in ctx.N]
        norder = length(overlap)
        len % norder == 0 || error("Bad symplectic intersection")
        q = div(len,norder)
        possible = [s.number for s in small_specs if s.parent == parent_number &&
            s.group_id == gid && s.sym_order == norder && s.index == q]
        isempty(possible) && continue
        sym = first(x for x in overlap if Int(order(x)) == norder)
        C, _ = sub(ctx.H,[sym])
        @assert Int(order(C)) == norder && all(x in C for x in overlap)
        options = [x for x in elements(B) if x^q in C &&
            all(!(x^k in C) for k in 1:q-1) &&
            Int(order(first(sub(ctx.H,[sym,x])))) == len]
        isempty(options) && error("Eligible quotient is not cyclic")
        extra = first(options)
        push!(raw,(; B, group_id=gid, symplectic_order=norder,
            quotient_order=q, possible_numbers=possible,
            symplectic_generator=matrix(sym), extra_generator=matrix(extra)))
    end
    classes = Any[]
    visited = Set{Int}()
    for i in eachindex(raw)
        i in visited && continue
        B = raw[i].B
        elts = collect(elements(B))
        orbit = [j for j in eachindex(raw) if
            Int(order(raw[j].B)) == Int(order(B)) &&
            any(h -> all(x -> h*x*inv(h) in raw[j].B, elts), all_h)]
        push!(classes,(representative=i, orbit_size=length(orbit)))
        union!(visited,orbit)
    end
    @assert length(visited) == length(raw)
    return raw, classes
end

function small_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    hashes = small_sources()
    small_table_checks(); small_strict_checks()
    expected = small_expected_characters()
    candidates = NamedTuple[]
    for n in (78,81)
        ctx = small_parent(n)
        raw, classes = small_eligible_subgroups(n,ctx)
        small_note("No. $n: $(length(raw)) eligible exact subgroups, $(length(classes)) parent-conjugacy classes")
        for (class_number,cl) in enumerate(classes)
            c = raw[cl.representative]
            B, _ = sub(ctx.H,[ctx.H(c.symplectic_generator),
                                 ctx.H(c.extra_generator)])
            @assert small_group_identification(B) == c.group_id
            @assert Int(order(B)) == c.group_id[1]
            @assert length([x for x in elements(B) if x in ctx.N]) == c.symplectic_order
            hist = small_histogram(B)
            matches = [i for i in c.possible_numbers if hist == expected[i]]
            push!(candidates,(parent_number=n, class_number=class_number,
                orbit_size=cl.orbit_size, subgroup_id=c.group_id,
                symplectic_order=c.symplectic_order,
                quotient_order=c.quotient_order,
                possible_numbers=c.possible_numbers, character_matches=matches,
                primitive_character_histogram=hist,
                symplectic_generator=c.symplectic_generator,
                extra_generator=c.extra_generator))
            small_note("  class $class_number: ID $(c.group_id), N intersection $(c.symplectic_order), quotient $(c.quotient_order), character matches $matches")
        end
    end
    save(output,(format_version=1, source_hashes=hashes,
        strict_witness_file=small_edges,
        geometric_character_file=small_characters,
        candidate_classes=Tuple(candidates), numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == hashes
    @assert length(check.candidate_classes) == length(candidates)
    small_note("Saved and reloaded $output")
end

function small_lattices(output, groups_path, selected)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path)
    @assert groups.format_version == 1 && groups.source_hashes == small_sources()
    contexts = Dict(n => small_parent(n) for n in (78,81))
    summaries = NamedTuple[]
    results = NamedTuple[]
    for c in groups.candidate_classes
        if selected !== nothing && (c.parent_number,c.class_number) != selected
            continue
        end
        ctx = contexts[c.parent_number]
        L = lattice(ctx.result.Lambda0)
        sym = integer_lattice_with_isometry(L,c.symplectic_generator;
            ambient_representation=false,check=true)
        S = lattice(coinvariant_lattice(sym))
        T = lattice(invariant_lattice(sym))
        ranks = unique(s.rank_S for s in small_specs if s.number in c.possible_numbers)
        @assert length(ranks) == 1
        reason = ""
        rank_P = 0; rank_K = 0; dimension = -1; index = 0
        if rank(S) != only(ranks) || rank(T) != 22-only(ranks)
            reason = "symplectic coinvariant rank mismatch"
        else
            Lf = integer_lattice_with_isometry(L,c.extra_generator;
                ambient_representation=false,check=true)
            @assert trivial_action_on_discriminant(Lf)
            Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
            Taction = full_rank_model(Timg)
            index = Int(order_of_isometry(Taction))
            if index != c.quotient_order
                reason = "quotient action order mismatch"
            else
                pk = embedded_PK_data(Lf,Timg,index)
                rank_P = rank(pk.P_lattice)
                rank_K = rank(pk.K_lattice)
                @assert rank_P+rank_K == 22
                if signature_tuple(pk.P_lattice) != (rank_P-2,0,2) ||
                   signature_tuple(pk.K_lattice) != (rank_K,0,0)
                    reason = "period/complement signature mismatch"
                else
                    @assert rank_P % Int(euler_phi(index)) == 0
                    dimension = period_dimension(pk.P_lattice,index)
                end
            end
        end
        matches = [s.number for s in small_specs if s.number in c.character_matches &&
            s.rank_S == rank(S) && s.index == index && s.dimension == dimension]
        if isempty(matches) && isempty(reason)
            reason = "exact dimension or geometric character mismatch"
        end
        push!(summaries,(parent_number=c.parent_number,class_number=c.class_number,
            rank_S=rank(S),rank_T=rank(T),rank_P=rank_P,rank_K=rank_K,
            index=index,dimension=dimension,character_matches=c.character_matches,
            filtered_matches=matches,reason=reason))
        small_note("No. $(c.parent_number) class $(c.class_number): S=$(rank(S)), P=$rank_P, dimension=$dimension, filtered matches=$matches")
        isempty(matches) && continue
        result = complete_cyclic_restriction(ctx.result,
            c.symplectic_generator,c.extra_generator;
            parent_number=c.parent_number,
            child_number=length(matches)==1 ? only(matches) : 0,
            index=index,expected_rank_S=rank(S),expected_dimension=dimension,
            expected_group_id=c.subgroup_id,
            verify_group_id=false,verify_roots=false,
            verify_symplectic_saturation=false)
        @assert result.extracted_subgroup_id == c.subgroup_id
        push!(results,(parent_number=c.parent_number,class_number=c.class_number,
            filtered_matches=matches,result=result))
    end
    # Store only fixed-size counts: OSCAR 1.8.2 cannot serialize empty Tuple
    # values in this nested record. All class identities remain in results.
    match_counts = [length([r for r in results if s.number in r.filtered_matches])
        for s in small_specs]
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=small_hash(groups_path),summaries=Tuple(summaries),
        results=Tuple(results),target_numbers=[s.number for s in small_specs],
        match_counts=match_counts,
        roots_verified=false,numbered_assignment_claimed=false))
    check=load(output)
    @assert length(check.summaries)==length(summaries)
    @assert length(check.results)==length(results)
    small_note("Saved and reloaded $output; match counts: $match_counts")
end

function small_verify(output, lattices_path, groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups=load(groups_path); data=load(lattices_path)
    @assert groups.source_hashes==data.source_hashes==small_sources()
    @assert data.groups_file_hash==small_hash(groups_path)
    contexts=Dict(n => small_parent(n) for n in (78,81))
    verified=NamedTuple[]
    for r in data.results
        c=only(x for x in groups.candidate_classes if
            x.parent_number==r.parent_number && x.class_number==r.class_number)
        ctx=contexts[r.parent_number]
        B,_=sub(ctx.H,[ctx.H(c.symplectic_generator),ctx.H(c.extra_generator)])
        @assert Int(order(B))==c.subgroup_id[1]
        @assert small_group_identification(B)==c.subgroup_id
        @assert length([x for x in elements(B) if x in ctx.N])==c.symplectic_order
        @assert small_histogram(B)==c.primitive_character_histogram
        result=complete_cyclic_restriction(ctx.result,
            c.symplectic_generator,c.extra_generator;
            parent_number=c.parent_number,child_number=r.result.child_number,
            index=c.quotient_order,
            expected_rank_S=rank(lattice(r.result.S_in_Lambda0)),
            expected_dimension=r.result.dimension,
            expected_group_id=c.subgroup_id,
            verify_group_id=false,verify_roots=true,
            verify_symplectic_saturation=false)
        @assert gram_matrix(result.P_in_Lambda0)==gram_matrix(r.result.P_in_Lambda0)
        @assert gram_matrix(result.K_in_Lambda0)==gram_matrix(r.result.K_in_Lambda0)
        push!(verified,(parent_number=c.parent_number,class_number=c.class_number,
            filtered_matches=r.filtered_matches,extracted_subgroup_id=c.subgroup_id,
            roots_verified=true,result=result))
        small_note("Verified roots and extracted group for No. $(c.parent_number) class $(c.class_number)")
    end
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=small_hash(groups_path),
        lattices_file_hash=small_hash(lattices_path),
        verified_results=Tuple(verified),
        target_numbers=data.target_numbers,match_counts=data.match_counts,
        numbered_assignment_claimed=false,
        symplectic_saturation_verified=false))
    check=load(output)
    @assert length(check.verified_results)==length(verified)
    small_note("Saved and reloaded $output")
end

function small_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices, or verify")
    stage=ARGS[1]
    if stage=="preflight"
        length(ARGS)==1 || error("preflight takes no arguments")
        hashes=small_sources()
        small_table_checks(); small_strict_checks(); small_expected_characters()
        small_parent(78); small_parent(81)
        small_note("Preflight passed; source SHA-256 tuple=$hashes")
    elseif stage=="groups"
        length(ARGS)<=2 || error("groups [output.mrdi]")
        small_groups(length(ARGS)==2 ? abspath(ARGS[2]) : small_groups_default)
    elseif stage=="lattices"
        length(ARGS)<=4 || error("lattices [output.mrdi] [groups.mrdi] [parent:class]")
        selected = nothing
        if length(ARGS)==4
            bits = split(ARGS[4],':')
            length(bits)==2 || error("Choose parent:class, for example 78:1")
            selected=(parse(Int,bits[1]),parse(Int,bits[2]))
        end
        small_lattices(length(ARGS)>=2 ? abspath(ARGS[2]) : small_lattices_default,
            length(ARGS)>=3 ? abspath(ARGS[3]) : small_groups_default, selected)
    elseif stage=="verify"
        length(ARGS)<=4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        small_verify(length(ARGS)>=2 ? abspath(ARGS[2]) : small_verified_default,
            length(ARGS)>=3 ? abspath(ARGS[3]) : small_lattices_default,
            length(ARGS)>=4 ? abspath(ARGS[4]) : small_groups_default)
    else
        error("Unknown stage: $stage")
    end
end

small_main()
