# Exhaust all No. 87 subgroup classes inside the cached full No. 18 action.
# The finite group is S3-by-C3; each named stage writes a distinct MRDI file.
# No independent symplectic-saturation or global uniqueness claim is made.

using SHA
include(joinpath(@__DIR__, "restriction_83_from_18.jl"))

const r87_table = joinpath(@__DIR__, "..", "input", "family_numbering.md")
const r87_edges = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_all_pairs.tsv")
const r87_gap_families = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "input", "fourfold_156.g")
const r87_gap_witnesses = joinpath(@__DIR__, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_positive_edges.g")
const r87_characters = joinpath(@__DIR__, "restriction_87_geometric_character.tsv")
const r87_character_script = joinpath(@__DIR__, "restriction_87_geometric_character.g")
const r87_groups_file = joinpath(@__DIR__, "restriction_87_from_18.groups.mrdi")
const r87_lattices_file = joinpath(@__DIR__, "restriction_87_from_18.lattices.mrdi")
const r87_verified_file = joinpath(@__DIR__, "restriction_87_from_18.verified.mrdi")

r87_note(s) = (println(s); flush(stdout))
r87_hash(path) = bytes2hex(sha256(read(path)))
r87_saved(xs) = isempty(xs) ? String[] : Tuple(xs)

function r87_hashes()
    paths = (r111_source, r111_cache, r87_table, r87_edges,
        r87_gap_families, r87_gap_witnesses, r87_characters,
        r87_character_script, @__FILE__,
        joinpath(@__DIR__, "restriction_83_from_18.jl"),
        joinpath(@__DIR__, "restriction_111_from_18.jl"),
        joinpath(@__DIR__, "enumerate_restrictions_94_95_direct.jl"),
        joinpath(@__DIR__, "restriction_functions.jl"),
        joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl"))
    all(isfile,paths) || error("Missing source; run the companion GAP certificate first")
    hashes = Tuple((basename(path),r87_hash(path)) for path in paths)
    hashes[1][2] == r111_source_sha256 || error("Frozen OSCAR source changed")
    hashes[2][2] == r111_cache_sha256 || error("No. 18 full-group cache changed")
    hashes[5][2] == r111_gap_families_sha256 || error("Frozen GAP families changed")
    hashes[6][2] == r111_gap_witnesses_sha256 || error("GAP witnesses changed")
    return hashes
end

function r87_table_check()
    expected = Dict(18 => (19,"M_9",1,3,0,(216,153)),
                    87 => (14,"S3",1,3,2,(18,3)))
    found = Dict{Int,Tuple}()
    for line in eachline(r87_table)
        startswith(line,'|') || continue
        cells = strip.(split(line,'|'))
        length(cells) >= 9 || continue
        n = tryparse(Int,cells[2])
        n === nothing && continue
        haskey(expected,n) || continue
        haskey(found,n) && error("Duplicate numbered row $n")
        m = match(r"\[(\d+),(\d+)\]",cells[8])
        m === nothing && error("Missing group ID for No. $n")
        found[n] = (parse(Int,cells[3]),replace(cells[4],"`"=>""),
            parse(Int,cells[5]),parse(Int,cells[6]),parse(Int,cells[7]),
            (parse(Int,m.captures[1]),parse(Int,m.captures[2])))
    end
    found == expected || error("Numbered group/rank/index/dimension data changed")
end

function r87_containment_check()
    matches = 0
    for (line_number,line) in enumerate(eachline(r87_edges))
        line_number == 1 && continue
        v = split(line,'\t')
        length(v) == 12 || error("Malformed containment TSV line $line_number")
        parse(Int,v[1]) == 87 && parse(Int,v[2]) == 18 || continue
        Tuple(parse.(Int,v[3:6])) == (2,0,54,648) ||
            error("Wrong strict-containment metadata for No. 87 -> No. 18")
        v[7:10] == ["embedded","direct","true","fail"] ||
            error("No. 87 -> No. 18 is not a direct strict containment")
        v[12] in ("literal_matrix_subgroup","A_strict") ||
            error("Unexpected strict-witness method")
        matches += 1
    end
    matches == 1 || error("Unique direct strict containment missing")
end

function r87_geometric_character()
    expected = Dict{Tuple{Int,Int},Int}()
    for (i,line) in enumerate(eachline(r87_characters))
        if i == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric-character header")
            continue
        end
        isempty(strip(line)) && continue
        v = split(line,'\t')
        length(v) == 4 || error("Malformed character line $i")
        n,ord,tr,count = parse.(Int,v)
        n == 87 && count > 0 && 1 <= ord <= 18 ||
            error("Unexpected character line $i")
        key = (ord,tr)
        haskey(expected,key) && error("Duplicate character bin")
        expected[key] = count
    end
    sum(values(expected)) == 18 || error("Incomplete No. 87 character")
    get(expected,(1,22),0) == 1 || error("Bad identity trace")
    return expected
end

function r87_preflight()
    hashes = r87_hashes()
    r87_table_check(); r87_containment_check()
    expected = r87_geometric_character()
    p = r111_parent()
    r87_note("No. 18 cache, direct No. 87 edge, and exact character passed")
    r87_note("Source hashes: $hashes")
    return p,expected,hashes
end

# Every eligible B has B intersect N = S3 and B/N image C3. This is checked
# by all S3 kernels A < N and every lift n*f in the first quotient
# coset. Closure/normalization and the abstract group ID are checked exactly.
function r87_raw(ctx)
    s3 = r83_raw(ctx)
    raw = Dict{Any,Tuple{Int,Int,Int}}()
    for (A,(a,b)) in s3, n in 1:72
        lift = ctx.idx(n,1)
        ctx.mul[ctx.mul[lift,lift],lift] in A || continue
        all(ctx.mul[ctx.mul[lift,x],ctx.inverse[lift]] in A for x in A) || continue
        B = r111_subgroup(ctx,[a,b,lift])
        length(B) == 18 || error("Normalized S3 lift did not form order 18")
        Tuple(i for i in B if i <= 72) == A || error("Wrong symplectic intersection")
        Set(div(i-1,72) for i in B) == Set(0:2) || error("Wrong cyclic quotient")
        get!(raw,B,(a,b,lift))
    end
    isempty(raw) && error("No eligible S3-by-C3 subgroup in No. 18")
    return raw,length(s3)
end

function r87_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Group path must end in .mrdi")
    p,expected,hashes = r87_preflight()
    ctx = r111_context(p)
    raw,n_s3 = r87_raw(ctx)
    eligible = Dict(key=>gens for (key,gens) in raw if
        r111_group_id(ctx,key,collect(gens)) == (18,3))
    isempty(eligible) && error("No subgroup of abstract type [18,3]")
    classes = r111_classes(ctx,eligible)
    candidates = NamedTuple[]; matched = 0
    for (class_number,c) in enumerate(classes)
        a,b,lift = eligible[c.key]
        h = r111_histogram(ctx,c.key)
        is_match = h == expected
        matched += is_match
        push!(candidates,(child_number=87,parent_number=18,
            class_number=class_number,parent_conjugacy_orbit_size=c.orbit_size,
            subgroup_indices=c.key,subgroup_id=(18,3),
            symplectic_generator_indices=(a,b),extra_generator_index=lift,
            symplectic_generators=(ctx.elements[a],ctx.elements[b]),
            extra_generator=ctx.elements[lift],
            primitive_character_histogram=h,geometric_character_match=is_match))
        r87_note("No. 87 class $class_number: orbit $(c.orbit_size), character match=$is_match")
    end
    matched > 0 || error("No No. 18 class matches the No. 87 character")
    save(output,(format_version=1,source_hashes=hashes,
        method="all S3 kernels in M9 and all 72 quotient-generator lifts; exact closure and full parent conjugacy",
        parent_number=18,parent_group_order=216,
        complete_within_saved_parent=true,numbered_assignment_claimed=false,
        s3_subgroups=n_s3,raw_subgroups=length(raw),
        abstract_subgroups=length(eligible),parent_conjugacy_classes=length(classes),
        character_matches=matched,candidates=Tuple(candidates),
        lattice_and_root_checks_done=false))
    check = load(output)
    @assert check.source_hashes == hashes && length(check.candidates) == length(candidates)
    r87_note("Saved and reloaded $output")
end

function r87_restriction(p,c)
    T = invariant_lattice(p.L,collect(c.symplectic_generators);
        ambient_representation=false)
    S = orthogonal_submodule(p.L,T)
    @assert rank(S) == 14 && rank(T) == 8
    @assert signature_tuple(S) == (14,0,0)
    @assert signature_tuple(T) == (6,0,2)
    Lf = integer_lattice_with_isometry(p.L,c.extra_generator;
        ambient_representation=false,check=true)
    @assert trivial_action_on_discriminant(Lf)
    Simg = lattice_in_same_ambient_space(Lf,basis_matrix(S);check=true)
    Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
    @assert basis_matrix(S)*gram_matrix(ambient_space(p.L))*
        transpose(basis_matrix(T)) == zero_matrix(QQ,14,8)
    Taction = full_rank_model(Timg)
    @assert Int(order_of_isometry(Taction)) == 3
    pk = embedded_PK_data(Lf,Timg,3)
    P,K = pk.P_lattice,pk.K_lattice
    @assert rank(P) == 6 && rank(K) == 16
    @assert signature_tuple(P) == (4,0,2)
    @assert signature_tuple(K) == (16,0,0)
    @assert period_dimension(P,3) == 2
    return (order=3,dimension=2,S_in_Lambda0=Simg,T_in_Lambda0=Timg,
        T_action=Taction,K_in_Lambda0=K,P_in_Lambda0=P,
        P_action=pk.P_with_isometry,Lambda0=Lf,group_gap_id=nothing,
        symplectic_kernel_order_S=nothing,symplectic_kernel_order_K=nothing,
        symplectic_saturation_verified=false,extracted_subgroup_id=(18,3),
        group_id_source="verified subgroup of cached No. 18 full group",
        parent_number=18,child_number=87,
        symplectic_generators_in_parent=c.symplectic_generators,
        extra_generator_in_parent=c.extra_generator)
end

function r87_lattices(output,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Lattice path must end in .mrdi")
    groups = load(groups_path)
    @assert groups.format_version == 1 && groups.source_hashes == r87_hashes()
    p = r111_parent()
    summaries = NamedTuple[]; results = NamedTuple[]
    for c in groups.candidates
        c.geometric_character_match || continue
        T = invariant_lattice(p.L,collect(c.symplectic_generators);
            ambient_representation=false)
        S = orthogonal_submodule(p.L,T)
        reason = ""; index = 0; dimension = -1; rank_P = 0; rank_K = 0
        if rank(S) != 14 || rank(T) != 8
            reason = "symplectic rank mismatch"
        elseif signature_tuple(S) != (14,0,0) || signature_tuple(T) != (6,0,2)
            reason = "symplectic signature mismatch"
        else
            Lf = integer_lattice_with_isometry(p.L,c.extra_generator;
                ambient_representation=false,check=true)
            @assert trivial_action_on_discriminant(Lf)
            Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
            index = Int(order_of_isometry(full_rank_model(Timg)))
            if index != 3
                reason = "quotient action order mismatch"
            else
                pk = embedded_PK_data(Lf,Timg,3)
                rank_P,rank_K = rank(pk.P_lattice),rank(pk.K_lattice)
                if rank_P != 6 || rank_K != 16
                    reason = "period/complement rank mismatch"
                elseif signature_tuple(pk.P_lattice) != (4,0,2) ||
                       signature_tuple(pk.K_lattice) != (16,0,0)
                    reason = "period/complement signature mismatch"
                else
                    dimension = period_dimension(pk.P_lattice,3)
                    dimension == 2 || (reason = "period dimension mismatch")
                end
            end
        end
        push!(summaries,(child_number=87,class_number=c.class_number,
            rank_S=rank(S),rank_T=rank(T),rank_P=rank_P,rank_K=rank_K,
            index=index,dimension=dimension,matched=isempty(reason),reason=reason))
        r87_note("No. 87 class $(c.class_number): S=$(rank(S)), P=$rank_P, dim=$dimension, reason=$reason")
        isempty(reason) || continue
        push!(results,(child_number=87,class_number=c.class_number,
            result=r87_restriction(p,c)))
    end
    isempty(results) && error("No character-matched No. 87 class passed lattice filters")
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=r87_hash(groups_path),
        summaries=r87_saved(summaries),results=Tuple(results),
        target_numbers=[87],match_counts=[length(results)],
        complete_lattice_pass=true,roots_verified=false,
        symplectic_saturation_verified=false,numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert length(check.results) == length(results)
    r87_note("Saved and reloaded $output; lattice matches=$(length(results))")
end

function r87_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Verified path must end in .mrdi")
    groups,data = load(groups_path),load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.source_hashes == data.source_hashes == r87_hashes()
    @assert data.groups_file_hash == r87_hash(groups_path)
    @assert data.complete_lattice_pass
    p = r111_parent(); ctx = r111_context(p)
    expected = r87_geometric_character()
    verified = NamedTuple[]; obstructed = NamedTuple[]
    for r in data.results
        c = only(x for x in groups.candidates if
            x.child_number == 87 && x.class_number == r.class_number)
        a,b = c.symplectic_generator_indices
        lift = c.extra_generator_index
        A = r111_subgroup(ctx,[a,b])
        @assert length(A) == 6 && all(i <= 72 for i in A)
        @assert r111_group_id(ctx,A,[a,b]) == (6,1)
        B = r111_subgroup(ctx,[a,b,lift])
        @assert B == c.subgroup_indices && Tuple(i for i in B if i <= 72) == A
        @assert r111_group_id(ctx,B,[a,b,lift]) == (18,3)
        @assert r111_histogram(ctx,B) ==
            c.primitive_character_histogram == expected
        result = r87_restriction(p,c)
        @assert gram_matrix(lattice(result.S_in_Lambda0)) ==
            gram_matrix(lattice(r.result.S_in_Lambda0))
        @assert gram_matrix(lattice(result.T_in_Lambda0)) ==
            gram_matrix(lattice(r.result.T_in_Lambda0))
        @assert gram_matrix(result.P_in_Lambda0) == gram_matrix(r.result.P_in_Lambda0)
        @assert gram_matrix(result.K_in_Lambda0) == gram_matrix(r.result.K_in_Lambda0)
        @assert isometry(result.T_action) == isometry(r.result.T_action)
        if has_root(result.K_in_Lambda0,p.L)
            push!(obstructed,(child_number=87,parent_number=18,
                class_number=c.class_number,subgroup_id=(18,3)))
            r87_note("No. 87 class $(c.class_number): root obstruction")
        else
            push!(verified,(child_number=87,parent_number=18,
                class_number=c.class_number,subgroup_id=(18,3),
                roots_verified=true,result=result))
            r87_note("No. 87 class $(c.class_number): subgroup, lattice and roots verified")
        end
    end
    @assert length(verified)+length(obstructed) == data.match_counts[1]
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=r87_hash(groups_path),
        lattices_file_hash=r87_hash(lattices_path),
        verified_results=r87_saved(verified),root_obstructed=r87_saved(obstructed),
        target_numbers=[87],match_counts=[length(verified)],
        root_obstructed_counts=[length(obstructed)],roots_verified=true,
        complete_lattice_pass=true,complete_within_saved_parent=true,
        symplectic_saturation_verified=false,numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == data.source_hashes
    @assert length(check.verified_results) == length(verified)
    @assert length(check.root_obstructed) == length(obstructed)
    r87_note("Saved and reloaded $output; root-free=$(length(verified)), obstructed=$(length(obstructed))")
end

function r87_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices, or verify")
    stage = ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no arguments")
        r87_preflight()
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        r87_groups(length(ARGS) == 2 ? abspath(ARGS[2]) : r87_groups_file)
    elseif stage == "lattices"
        length(ARGS) <= 3 || error("lattices [output.mrdi] [groups.mrdi]")
        r87_lattices(length(ARGS) >= 2 ? abspath(ARGS[2]) : r87_lattices_file,
            length(ARGS) == 3 ? abspath(ARGS[3]) : r87_groups_file)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        r87_verify(length(ARGS) >= 2 ? abspath(ARGS[2]) : r87_verified_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : r87_lattices_file,
            length(ARGS) == 4 ? abspath(ARGS[4]) : r87_groups_file)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    r87_main()
end
