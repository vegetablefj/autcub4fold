# Exhaust all S3 subgroups of the cached full No. 18 action and compare the
# exact primitive-H4 character of No. 83. The stages do not edit the catalogue.
# No independent symplectic-saturation or global integral-uniqueness claim.

using SHA
include(joinpath(@__DIR__, "restriction_111_from_18.jl"))

const r83_table = joinpath(@__DIR__, "..", "input", "family_numbering.md")
const r83_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_all_pairs.tsv")
const r83_gap_families = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const r83_gap_witnesses = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_positive_edges.g")
const r83_characters = joinpath(@__DIR__, "restriction_83_geometric_character.tsv")
const r83_character_script = joinpath(@__DIR__, "restriction_83_geometric_character.g")
const r83_groups_file = joinpath(@__DIR__, "restriction_83_from_18.groups.mrdi")
const r83_lattices_file = joinpath(@__DIR__, "restriction_83_from_18.lattices.mrdi")
const r83_verified_file = joinpath(@__DIR__, "restriction_83_from_18.verified.mrdi")

r83_note(s) = (println(s); flush(stdout))
r83_hash(path) = bytes2hex(sha256(read(path)))
r83_saved(xs) = isempty(xs) ? String[] : Tuple(xs)

function r83_hashes()
    paths = (r111_source, r111_cache, r83_table, r83_edges,
        r83_gap_families, r83_gap_witnesses, r83_characters,
        r83_character_script, @__FILE__,
        joinpath(@__DIR__, "restriction_111_from_18.jl"),
        joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"),
        joinpath(@__DIR__, "restriction_functions.jl"),
        joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl"))
    all(isfile, paths) || error("Missing source; run the companion GAP certificate first")
    hashes = Tuple((basename(path), r83_hash(path)) for path in paths)
    hashes[1][2] == r111_source_sha256 || error("Frozen OSCAR source changed")
    hashes[2][2] == r111_cache_sha256 || error("No. 18 full-group cache changed")
    hashes[5][2] == r111_gap_families_sha256 || error("Frozen GAP families changed")
    hashes[6][2] == r111_gap_witnesses_sha256 || error("GAP witnesses changed")
    return hashes
end

function r83_table_check()
    expected = Dict(18 => (19, "M_9", 1, 3, 0, (216,153)),
                    83 => (14, "S3", 1, 1, 6, (6,1)))
    found = Dict{Int,Tuple}()
    for line in eachline(r83_table)
        startswith(line, "|") || continue
        cells = strip.(split(line, '|'))
        length(cells) >= 9 || continue
        n = tryparse(Int, cells[2])
        n === nothing && continue
        haskey(expected,n) || continue
        haskey(found,n) && error("Duplicate numbered row $n")
        m = match(r"\[(\d+),(\d+)\]", cells[8])
        m === nothing && error("Missing group ID for No. $n")
        found[n] = (parse(Int,cells[3]), replace(cells[4],"`"=>""),
            parse(Int,cells[5]),parse(Int,cells[6]),parse(Int,cells[7]),
            (parse(Int,m.captures[1]),parse(Int,m.captures[2])))
    end
    found == expected || error("Numbered group/rank/index/dimension data changed")
end

function r83_containment_check()
    matches = 0
    for (line_number,line) in enumerate(eachline(r83_edges))
        line_number == 1 && continue
        v = split(line,'\t')
        length(v) == 12 || error("Malformed containment TSV line $line_number")
        parse(Int,v[1]) == 83 && parse(Int,v[2]) == 18 || continue
        Tuple(parse.(Int,v[3:6])) == (6,0,18,648) ||
            error("Wrong strict-containment metadata for No. 83 -> No. 18")
        v[7:10] == ["embedded","direct","true","fail"] ||
            error("No. 83 -> No. 18 is not a direct strict containment")
        v[12] in ("literal_matrix_subgroup","A_strict") ||
            error("Unexpected strict-witness method")
        matches += 1
    end
    matches == 1 || error("Unique direct strict containment missing")
end

function r83_geometric_character()
    expected = Dict{Tuple{Int,Int},Int}()
    for (i,line) in enumerate(eachline(r83_characters))
        if i == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric-character header")
            continue
        end
        isempty(strip(line)) && continue
        v = split(line,'\t')
        length(v) == 4 || error("Malformed character line $i")
        n,ord,tr,count = parse.(Int,v)
        n == 83 && count > 0 && 1 <= ord <= 6 ||
            error("Unexpected character line $i")
        key = (ord,tr)
        haskey(expected,key) && error("Duplicate character bin")
        expected[key] = count
    end
    sum(values(expected)) == 6 || error("Incomplete No. 83 character")
    get(expected,(1,22),0) == 1 || error("Bad identity trace")
    return expected
end

function r83_preflight()
    hashes = r83_hashes()
    r83_table_check()
    r83_containment_check()
    expected = r83_geometric_character()
    p = r111_parent()
    r83_note("No. 18 cache, direct No. 83 edge, and exact character passed")
    r83_note("Source hashes: $hashes")
    return p,expected,hashes
end

# Every S3 in the order-72 symplectic kernel is generated by an involution
# and a 3-element that do not commute. Test all such pairs and exact closure.
function r83_raw(ctx)
    raw = Dict{Any,Tuple{Int,Int}}()
    for a in 1:72
        ctx.orders[a] == 2 || continue
        for b in 1:72
            ctx.orders[b] == 3 || continue
            ctx.mul[a,b] != ctx.mul[b,a] || continue
            key = r111_subgroup(ctx,[a,b])
            length(key) == 6 || continue
            all(i <= 72 for i in key) || error("S3 left the symplectic kernel")
            get!(raw,key,(a,b))
        end
    end
    isempty(raw) && error("No S3 subgroup found in the No. 18 kernel")
    return raw
end

function r83_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    p,expected,hashes = r83_preflight()
    ctx = r111_context(p)
    raw = r83_raw(ctx)
    classes = r111_classes(ctx,raw)
    candidates = NamedTuple[]; matched = 0
    for (class_number,c) in enumerate(classes)
        a,b = raw[c.key]
        @assert r111_group_id(ctx,c.key,[a,b]) == (6,1)
        h = r111_histogram(ctx,c.key)
        is_match = h == expected
        matched += is_match
        push!(candidates,(child_number=83,parent_number=18,
            class_number=class_number,parent_conjugacy_orbit_size=c.orbit_size,
            subgroup_indices=c.key,subgroup_id=(6,1),
            symplectic_generator_indices=(a,b),
            symplectic_generators=(ctx.elements[a],ctx.elements[b]),
            primitive_character_histogram=h,geometric_character_match=is_match))
        r83_note("No. 83 class $class_number: orbit $(c.orbit_size), character match=$is_match")
    end
    matched > 0 || error("No No. 18 class matches the No. 83 character")
    save(output,(format_version=1,source_hashes=hashes,
        method="all involution/3-element pairs in the order-72 kernel; exact S3 closure and full No. 18 conjugacy",
        parent_number=18,parent_group_order=216,
        complete_within_saved_parent=true,numbered_assignment_claimed=false,
        raw_subgroups=length(raw),parent_conjugacy_classes=length(classes),
        character_matches=matched,candidates=Tuple(candidates),
        lattice_and_root_checks_done=false))
    check = load(output)
    @assert check.source_hashes == hashes && length(check.candidates) == length(candidates)
    r83_note("Saved and reloaded $output")
end

function r83_restriction(p,c)
    L = p.L
    T = invariant_lattice(L,collect(c.symplectic_generators);
        ambient_representation=false)
    S = orthogonal_submodule(L,T)
    @assert rank(S) == 14 && rank(T) == 8
    @assert signature_tuple(S) == (14,0,0)
    @assert signature_tuple(T) == (6,0,2)
    identity = identity_matrix(QQ,22)
    Lf = integer_lattice_with_isometry(L,identity;
        ambient_representation=false,check=true)
    @assert trivial_action_on_discriminant(Lf)
    Simg = lattice_in_same_ambient_space(Lf,basis_matrix(S);check=true)
    Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
    @assert basis_matrix(S)*gram_matrix(ambient_space(L))*
        transpose(basis_matrix(T)) == zero_matrix(QQ,14,8)
    Taction = full_rank_model(Timg)
    @assert Int(order_of_isometry(Taction)) == 1
    pk = embedded_PK_data(Lf,Timg,1)
    P,K = pk.P_lattice,pk.K_lattice
    @assert rank(P) == 8 && rank(K) == 14
    @assert signature_tuple(P) == (6,0,2)
    @assert signature_tuple(K) == (14,0,0)
    @assert period_dimension(P,1) == 6
    return (order=1,dimension=6,S_in_Lambda0=Simg,T_in_Lambda0=Timg,
        T_action=Taction,K_in_Lambda0=K,P_in_Lambda0=P,
        P_action=pk.P_with_isometry,Lambda0=Lf,group_gap_id=nothing,
        symplectic_kernel_order_S=nothing,symplectic_kernel_order_K=nothing,
        symplectic_saturation_verified=false,extracted_subgroup_id=(6,1),
        group_id_source="verified subgroup of cached No. 18 full group",
        parent_number=18,child_number=83,
        symplectic_generators_in_parent=c.symplectic_generators,
        extra_generator_in_parent=identity)
end

function r83_lattices(output,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups = load(groups_path)
    @assert groups.format_version == 1 && groups.source_hashes == r83_hashes()
    p = r111_parent()
    summaries = NamedTuple[]; results = NamedTuple[]
    for c in groups.candidates
        c.geometric_character_match || continue
        T = invariant_lattice(p.L,collect(c.symplectic_generators);
            ambient_representation=false)
        S = orthogonal_submodule(p.L,T)
        reason = ""
        if rank(S) != 14 || rank(T) != 8
            reason = "symplectic rank mismatch"
        elseif signature_tuple(S) != (14,0,0) ||
               signature_tuple(T) != (6,0,2)
            reason = "symplectic signature mismatch"
        end
        push!(summaries,(child_number=83,class_number=c.class_number,
            rank_S=rank(S),rank_T=rank(T),matched=isempty(reason),reason=reason))
        r83_note("No. 83 class $(c.class_number): S=$(rank(S)), T=$(rank(T)), reason=$reason")
        isempty(reason) || continue
        push!(results,(child_number=83,class_number=c.class_number,
            result=r83_restriction(p,c)))
    end
    isempty(results) && error("No character-matched No. 83 class passed lattice filters")
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=r83_hash(groups_path),
        summaries=r83_saved(summaries),results=Tuple(results),
        target_numbers=[83],match_counts=[length(results)],
        complete_lattice_pass=true,roots_verified=false,
        symplectic_saturation_verified=false,numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert length(check.results) == length(results)
    r83_note("Saved and reloaded $output; lattice matches=$(length(results))")
end

function r83_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    groups,data = load(groups_path),load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.source_hashes == data.source_hashes == r83_hashes()
    @assert data.groups_file_hash == r83_hash(groups_path)
    @assert data.complete_lattice_pass
    p = r111_parent(); ctx = r111_context(p)
    expected = r83_geometric_character()
    verified = NamedTuple[]; obstructed = NamedTuple[]
    for r in data.results
        c = only(x for x in groups.candidates if
            x.child_number == 83 && x.class_number == r.class_number)
        a,b = c.symplectic_generator_indices
        key = r111_subgroup(ctx,[a,b])
        @assert key == c.subgroup_indices && all(i <= 72 for i in key)
        @assert r111_group_id(ctx,key,[a,b]) == (6,1)
        @assert r111_histogram(ctx,key) ==
            c.primitive_character_histogram == expected
        result = r83_restriction(p,c)
        @assert gram_matrix(lattice(result.S_in_Lambda0)) ==
            gram_matrix(lattice(r.result.S_in_Lambda0))
        @assert gram_matrix(lattice(result.T_in_Lambda0)) ==
            gram_matrix(lattice(r.result.T_in_Lambda0))
        @assert gram_matrix(result.P_in_Lambda0) == gram_matrix(r.result.P_in_Lambda0)
        @assert gram_matrix(result.K_in_Lambda0) == gram_matrix(r.result.K_in_Lambda0)
        @assert isometry(result.T_action) == isometry(r.result.T_action)
        if has_root(result.K_in_Lambda0,p.L)
            push!(obstructed,(child_number=83,parent_number=18,
                class_number=c.class_number,subgroup_id=(6,1)))
            r83_note("No. 83 class $(c.class_number): root obstruction")
        else
            push!(verified,(child_number=83,parent_number=18,
                class_number=c.class_number,subgroup_id=(6,1),
                roots_verified=true,result=result))
            r83_note("No. 83 class $(c.class_number): subgroup, lattice and roots verified")
        end
    end
    @assert length(verified)+length(obstructed) == data.match_counts[1]
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=r83_hash(groups_path),
        lattices_file_hash=r83_hash(lattices_path),
        verified_results=r83_saved(verified),root_obstructed=r83_saved(obstructed),
        target_numbers=[83],match_counts=[length(verified)],
        root_obstructed_counts=[length(obstructed)],roots_verified=true,
        complete_lattice_pass=true,complete_within_saved_parent=true,
        symplectic_saturation_verified=false,numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == data.source_hashes
    @assert length(check.verified_results) == length(verified)
    @assert length(check.root_obstructed) == length(obstructed)
    r83_note("Saved and reloaded $output; root-free=$(length(verified)), obstructed=$(length(obstructed))")
end

function r83_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices, or verify")
    stage = ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no arguments")
        r83_preflight()
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        r83_groups(length(ARGS) == 2 ? abspath(ARGS[2]) : r83_groups_file)
    elseif stage == "lattices"
        length(ARGS) <= 3 || error("lattices [output.mrdi] [groups.mrdi]")
        r83_lattices(length(ARGS) >= 2 ? abspath(ARGS[2]) : r83_lattices_file,
            length(ARGS) == 3 ? abspath(ARGS[3]) : r83_groups_file)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        r83_verify(length(ARGS) >= 2 ? abspath(ARGS[2]) : r83_verified_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : r83_lattices_file,
            length(ARGS) == 4 ? abspath(ARGS[4]) : r83_groups_file)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    r83_main()
end
