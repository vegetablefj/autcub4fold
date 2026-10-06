# Exhaustive small-parent pilot for No. 80 inside the saved No. 51 action and
# No. 121 inside the saved No. 74 action. Both full parent groups have cached
# ambient generators; this script never computes automorphism_group_generators.
#
# After running restriction_next_small_geometric_characters.g in GAP:
#   julia restriction_pilot_80_121_cached_parents.jl preflight
#   julia restriction_pilot_80_121_cached_parents.jl groups
#   julia restriction_pilot_80_121_cached_parents.jl lattices
#   julia restriction_pilot_80_121_cached_parents.jl verify
#
# Each stage refuses to overwrite its output. Character and period matches
# are recorded as candidates until uniqueness and any desired root/group
# checks have been assessed separately. No stage edits a catalogue builder.

using SHA
include(joinpath(@__DIR__, "restriction_functions.jl"))

const pilot_specs = (
    (child=80, parent=51, case_index=21, result_index=3,
     parent_id=(32,11), parent_rank_S=17, parent_index=4,
     parent_dimension=1, child_id=(8,3), rank_S=14,
     sym_order=4, index=2, dimension=3,
     cache="source_51_full_lattice_group.mrdi"),
    (child=121, parent=74, case_index=29, result_index=1,
     parent_id=(16,11), parent_rank_S=15, parent_index=2,
     parent_dimension=4, child_id=(4,2), rank_S=8,
     sym_order=2, index=2, dimension=8,
     cache="source_74_full_lattice_group.mrdi"),
)

const pilot_source_file = joinpath(@__DIR__, "..", "..", "oscar", "oscar_script_data.mrdi")
const pilot_table_file = joinpath(@__DIR__, "..", "input", "family_numbering.md")
const pilot_containment_file = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_all_pairs.tsv")
const pilot_character_file = joinpath(@__DIR__,
    "restriction_next_small_geometric_characters.tsv")
const pilot_groups_file = joinpath(@__DIR__, "restriction_pilot_80_121.groups.mrdi")
const pilot_lattices_file = joinpath(@__DIR__, "restriction_pilot_80_121.lattices.mrdi")
const pilot_verified_file = joinpath(@__DIR__, "restriction_pilot_80_121.verified.mrdi")

pilot_note(s) = (println(s); flush(stdout))
pilot_hash(path) = bytes2hex(sha256(read(path)))
pilot_cache_path(spec) = joinpath(@__DIR__, spec.cache)

function pilot_source_hashes()
    files = vcat([pilot_source_file, pilot_table_file,
        pilot_containment_file, pilot_character_file],
        [pilot_cache_path(s) for s in pilot_specs])
    all(isfile, files) || error("Missing input; first run the companion GAP character script")
    return Tuple(pilot_hash(path) for path in files)
end

function pilot_table_checks()
    seen = Set{Int}()
    for line in eachline(pilot_table_file)
        startswith(line, "|") || continue
        cells = strip.(split(line, '|'))
        length(cells) >= 9 || continue
        n = tryparse(Int, cells[2])
        n === nothing && continue
        for spec in pilot_specs
            n in (spec.child, spec.parent) || continue
            expected = n == spec.child ?
                (spec.rank_S, spec.index, spec.dimension, spec.child_id) :
                (spec.parent_rank_S, spec.parent_index, spec.parent_dimension, spec.parent_id)
            m = match(r"\[(\d+),(\d+)\]", cells[8])
            m === nothing && error("Missing group ID in numbered row $n")
            actual = (parse(Int,cells[3]), parse(Int,cells[6]),
                parse(Int,cells[7]), (parse(Int,m.captures[1]),parse(Int,m.captures[2])))
            actual == expected || error("Numbered row $n changed: $actual")
            push!(seen,n)
        end
    end
    expected_numbers = Set(vcat([s.child for s in pilot_specs],
        [s.parent for s in pilot_specs]))
    seen == expected_numbers ||
        error("A numbered family row is missing")
end

function pilot_containment_checks()
    seen = Set{Tuple{Int,Int}}()
    for (line_number,line) in enumerate(eachline(pilot_containment_file))
        line_number == 1 && continue
        fields = split(line,'\t')
        length(fields) == 12 || error("Malformed containment TSV line $line_number")
        source, target = parse(Int,fields[1]), parse(Int,fields[2])
        for spec in pilot_specs
            (source,target) == (spec.child,spec.parent) || continue
            @assert parse(Int,fields[3]) == spec.dimension
            @assert parse(Int,fields[4]) == spec.parent_dimension
            @assert parse(Int,fields[5]) == 3*spec.child_id[1]
            @assert parse(Int,fields[6]) == 3*spec.parent_id[1]
            @assert fields[7] == "embedded" && fields[8] == "direct"
            @assert fields[9] == "true" && fields[10] == "fail"
            @assert fields[12] in ("literal_matrix_subgroup", "A_strict")
            push!(seen,(source,target))
        end
    end
    seen == Set((s.child,s.parent) for s in pilot_specs) ||
        error("A direct strict containment is missing")
end

function pilot_geometric_characters()
    expected = Dict(s.child => Dict{Tuple{Int,Int},Int}() for s in pilot_specs)
    for (line_number,line) in enumerate(eachline(pilot_character_file))
        if line_number == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric character TSV header")
            continue
        end
        isempty(strip(line)) && continue
        fields = split(line,'\t')
        length(fields) == 4 || error("Malformed character TSV line $line_number")
        n, ord, tr, count = parse.(Int,fields)
        haskey(expected,n) || continue
        count > 0 || error("Nonpositive character count")
        key = (ord,tr)
        haskey(expected[n],key) && error("Duplicate character bin")
        expected[n][key] = count
    end
    for spec in pilot_specs
        hist = expected[spec.child]
        sum(values(hist)) == spec.child_id[1] || error("Incomplete character for No. $(spec.child)")
        get(hist,(1,22),0) == 1 || error("Bad identity character for No. $(spec.child)")
    end
    return expected
end

function pilot_parent(spec, source)
    case = source.cases[spec.case_index]
    @assert case.case_index == spec.case_index
    parent = case.results[spec.result_index]
    @assert parent.order == spec.parent_index
    @assert parent.dimension == spec.parent_dimension
    @assert parent.group_gap_id == spec.parent_id
    L = lattice(parent.Lambda0)
    S = lattice(parent.S_in_Lambda0)
    @assert rank(L) == 22 && rank(S) == spec.parent_rank_S
    @assert signature_tuple(L) == (20,0,2) && abs(det(gram_matrix(L))) == 3
    cache = load(pilot_cache_path(spec))
    @assert cache.parent_number == spec.parent
    @assert cache.full_group_id == spec.parent_id
    @assert gram_matrix(lattice(cache.Lambda0)) == gram_matrix(L)
    @assert basis_matrix(lattice(cache.Lambda0)) == basis_matrix(L)
    @assert isometry(cache.Lambda0) == isometry(parent.Lambda0)
    @assert basis_matrix(lattice(cache.S_in_Lambda0)) == basis_matrix(S)
    @assert cache.extra_generator == isometry(parent.Lambda0)
    lifts = cache.symplectic_generators
    @assert !isempty(lifts)
    H = matrix_group(vcat(lifts,[cache.extra_generator]))
    N, _ = sub(H,[H(g) for g in lifts])
    @assert Int(order(H)) == spec.parent_id[1]
    @assert small_group_identification(H) == spec.parent_id
    @assert Int(order(N)) == div(spec.parent_id[1],spec.parent_index)
    @assert all(h*n*inv(h) in N for h in elements(H), n in elements(N))
    return (; parent,L,H,N,items=collect(elements(H)))
end

function pilot_trace(A)
    value = sum(A[i,i] for i in 1:22)
    denominator(value) == 1 || error("Nonintegral primitive trace")
    return Int(numerator(value))
end

function pilot_histogram(B)
    hist = Dict{Tuple{Int,Int},Int}()
    for x in elements(B)
        key = (Int(order(x)),pilot_trace(matrix(x)))
        hist[key] = get(hist,key,0)+1
    end
    @assert sum(values(hist)) == Int(order(B))
    @assert get(hist,(1,22),0) == 1
    return hist
end

function pilot_candidates(spec, ctx)
    seen = Set{Any}()
    raw = NamedTuple[]
    for a in ctx.items, b in ctx.items
        B, _ = sub(ctx.H,[a,b])
        Int(order(B)) == spec.child_id[1] || continue
        mask = Tuple(x in B for x in ctx.items)
        mask in seen && continue
        push!(seen,mask)
        small_group_identification(B) == spec.child_id || continue
        overlap = [x for x in elements(B) if x in ctx.N]
        length(overlap) == spec.sym_order || continue
        generators = [x for x in overlap if Int(order(x)) == spec.sym_order]
        isempty(generators) && continue
        sym = first(generators)
        C, _ = sub(ctx.H,[sym])
        all(x in C for x in overlap) || continue
        extras = [x for x in elements(B) if !(x in C) && x^spec.index in C &&
            Int(order(first(sub(ctx.H,[sym,x])))) == spec.child_id[1]]
        isempty(extras) && continue
        push!(raw,(B=B,symplectic_generator=matrix(sym),
            extra_generator=matrix(first(extras))))
    end
    classes = NamedTuple[]
    visited = Set{Int}()
    for i in eachindex(raw)
        i in visited && continue
        elements_B = collect(elements(raw[i].B))
        orbit = [j for j in eachindex(raw) if
            any(h -> all(x -> h*x*inv(h) in raw[j].B, elements_B),ctx.items)]
        push!(classes,(representative=i,orbit_size=length(orbit)))
        union!(visited,orbit)
    end
    length(visited) == length(raw) || error("Incomplete parent conjugacy partition")
    return raw,classes
end

function pilot_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    hashes = pilot_source_hashes()
    pilot_table_checks(); pilot_containment_checks()
    expected = pilot_geometric_characters()
    source = load(pilot_source_file)
    @assert source.format_version == 3 && source.completed_cases == 29
    candidates = NamedTuple[]
    for spec in pilot_specs
        ctx = pilot_parent(spec,source)
        raw,classes = pilot_candidates(spec,ctx)
        pilot_note("No. $(spec.child) in No. $(spec.parent): $(length(raw)) exact subgroups, $(length(classes)) parent classes")
        for (class_number,cl) in enumerate(classes)
            c = raw[cl.representative]
            hist = pilot_histogram(c.B)
            matched = hist == expected[spec.child]
            push!(candidates,(child=spec.child,parent=spec.parent,
                class_number=class_number,orbit_size=cl.orbit_size,
                group_id=spec.child_id,symplectic_order=spec.sym_order,
                quotient_order=spec.index,character_match=matched,
                primitive_character_histogram=hist,
                symplectic_generator=c.symplectic_generator,
                extra_generator=c.extra_generator))
            pilot_note("  class $class_number: orbit $(cl.orbit_size), character match=$matched")
        end
    end
    save(output,(format_version=1,source_hashes=hashes,
        character_file=basename(pilot_character_file),
        candidates=Tuple(candidates),numbered_assignment_claimed=false))
    check=load(output)
    @assert check.source_hashes == hashes
    @assert length(check.candidates) == length(candidates)
    pilot_note("Saved and reloaded $output")
end

function pilot_lattices(output, groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups=load(groups_path)
    @assert groups.format_version == 1
    @assert groups.source_hashes == pilot_source_hashes()
    source=load(pilot_source_file)
    contexts=Dict(s.parent => pilot_parent(s,source) for s in pilot_specs)
    summaries=NamedTuple[]
    results=NamedTuple[]
    for candidate in groups.candidates
        candidate.character_match || continue
        spec=only(s for s in pilot_specs if s.child == candidate.child)
        ctx=contexts[spec.parent]
        sym=integer_lattice_with_isometry(ctx.L,candidate.symplectic_generator;
            ambient_representation=false,check=true)
        S=lattice(coinvariant_lattice(sym))
        T=lattice(invariant_lattice(sym))
        reason=""; index=0; dimension=-1; rank_P=0; rank_K=0
        if rank(S) != spec.rank_S || rank(T) != 22-spec.rank_S
            reason="symplectic coinvariant rank mismatch"
        else
            Lf=integer_lattice_with_isometry(ctx.L,candidate.extra_generator;
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
        push!(summaries,(child=spec.child,parent=spec.parent,
            class_number=candidate.class_number,rank_S=rank(S),rank_T=rank(T),
            rank_P=rank_P,rank_K=rank_K,index=index,dimension=dimension,
            reason=reason))
        pilot_note("No. $(spec.child) class $(candidate.class_number): S=$(rank(S)), P=$rank_P, dimension=$dimension, reason=$reason")
        isempty(reason) || continue
        result=complete_cyclic_restriction(ctx.parent,
            candidate.symplectic_generator,candidate.extra_generator;
            child_number=spec.child,parent_number=spec.parent,
            index=spec.index,expected_rank_S=spec.rank_S,
            expected_dimension=spec.dimension,expected_group_id=spec.child_id,
            verify_group_id=false,verify_roots=false,
            verify_symplectic_saturation=false)
        push!(results,(child=spec.child,parent=spec.parent,
            class_number=candidate.class_number,result=result))
    end
    matches=Tuple((child=s.child,
        count=count(r -> r.child == s.child, results)) for s in pilot_specs)
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=pilot_hash(groups_path),summaries=Tuple(summaries),
        results=Tuple(results),matching_parent_match_counts=matches,
        roots_verified=false,symplectic_saturation_verified=false,
        numbered_assignment_claimed=false))
    check=load(output)
    @assert length(check.results) == length(results)
    pilot_note("Saved and reloaded $output; character/period matches: $matches")
end

function pilot_verify(output, lattices_path, groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups=load(groups_path)
    data=load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.source_hashes == data.source_hashes == pilot_source_hashes()
    @assert data.groups_file_hash == pilot_hash(groups_path)
    source=load(pilot_source_file)
    contexts=Dict(s.parent => pilot_parent(s,source) for s in pilot_specs)
    verified=NamedTuple[]
    for r in data.results
        c=only(x for x in groups.candidates if
            x.child == r.child && x.parent == r.parent &&
            x.class_number == r.class_number)
        @assert c.character_match
        ctx=contexts[r.parent]
        B,_=sub(ctx.H,[ctx.H(c.symplectic_generator),
            ctx.H(c.extra_generator)])
        @assert Int(order(B)) == c.group_id[1]
        @assert small_group_identification(B) == c.group_id
        @assert length([x for x in elements(B) if x in ctx.N]) ==
            c.symplectic_order
        @assert pilot_histogram(B) == c.primitive_character_histogram
        spec=only(s for s in pilot_specs if s.child == r.child)
        result=complete_cyclic_restriction(ctx.parent,
            c.symplectic_generator,c.extra_generator;
            child_number=spec.child,parent_number=spec.parent,
            index=spec.index,expected_rank_S=spec.rank_S,
            expected_dimension=spec.dimension,expected_group_id=spec.child_id,
            verify_group_id=false,verify_roots=true,
            verify_symplectic_saturation=false)
        @assert gram_matrix(result.P_in_Lambda0) ==
            gram_matrix(r.result.P_in_Lambda0)
        @assert gram_matrix(result.K_in_Lambda0) ==
            gram_matrix(r.result.K_in_Lambda0)
        @assert isometry(result.T_action) == isometry(r.result.T_action)
        push!(verified,(child=spec.child,parent=spec.parent,
            class_number=c.class_number,group_id=c.group_id,
            roots_verified=true,result=result))
        pilot_note("Verified roots and extracted group for No. $(spec.child) class $(c.class_number)")
    end
    matches=Tuple((child=s.child,
        count=count(r -> r.child == s.child,verified)) for s in pilot_specs)
    @assert matches == data.matching_parent_match_counts
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=pilot_hash(groups_path),
        lattices_file_hash=pilot_hash(lattices_path),
        verified_results=Tuple(verified),matching_parent_match_counts=matches,
        roots_verified=true,symplectic_saturation_verified=false,
        numbered_assignment_claimed=false))
    check=load(output)
    @assert length(check.verified_results) == length(verified)
    pilot_note("Saved and reloaded $output; root-verified matches: $matches")
end

function pilot_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices, or verify")
    if ARGS[1] == "preflight"
        length(ARGS) == 1 || error("preflight takes no arguments")
        hashes=pilot_source_hashes()
        pilot_table_checks(); pilot_containment_checks(); pilot_geometric_characters()
        source=load(pilot_source_file)
        for spec in pilot_specs
            pilot_parent(spec,source)
        end
        pilot_note("Preflight passed; source SHA-256 tuple=$hashes")
    elseif ARGS[1] == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        pilot_groups(length(ARGS) == 2 ? abspath(ARGS[2]) : pilot_groups_file)
    elseif ARGS[1] == "lattices"
        length(ARGS) <= 3 || error("lattices [output.mrdi] [groups.mrdi]")
        pilot_lattices(length(ARGS) >= 2 ? abspath(ARGS[2]) : pilot_lattices_file,
            length(ARGS) == 3 ? abspath(ARGS[3]) : pilot_groups_file)
    elseif ARGS[1] == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        pilot_verify(length(ARGS) >= 2 ? abspath(ARGS[2]) : pilot_verified_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : pilot_lattices_file,
            length(ARGS) == 4 ? abspath(ARGS[4]) : pilot_groups_file)
    else
        error("Unknown stage: $(ARGS[1])")
    end
end

pilot_main()
