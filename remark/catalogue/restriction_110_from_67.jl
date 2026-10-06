# Exhaustive No. 110 restrictions inside the saved No. 67 full lattice action.
# The separate No. 67 cache is reused; no stage runs unless named explicitly.
# This script does not assert independent child saturation or global uniqueness.

using SHA
include(joinpath(@__DIR__, "restriction_101_102_from_67.jl"))

const r110_spec = (child=110,id=(9,2),dimension=4,rank_P=10)
const r110_gap_script = joinpath(@__DIR__, "restriction_110_geometric_character.g")
const r110_characters = joinpath(@__DIR__, "restriction_110_geometric_character.tsv")
const r110_groups_file = joinpath(@__DIR__, "restriction_110_from_67.groups.mrdi")
const r110_lattices_file = joinpath(@__DIR__, "restriction_110_from_67.lattices.mrdi")
const r110_verified_file = joinpath(@__DIR__, "restriction_110_from_67.verified.mrdi")

r110_note(s) = (println(s); flush(stdout))

function r110_source_hashes()
    isfile(r67_cache) || error("Run the No. 67 preparation first: $r67_cache")
    isfile(r110_characters) || error("Run the companion No. 110 GAP script first")
    return (r67_prepare_hashes()...,
        (basename(r67_cache),r67_hash(r67_cache)),
        (basename(r110_gap_script),r67_hash(r110_gap_script)),
        (basename(r110_characters),r67_hash(r110_characters)),
        (basename(@__FILE__),r67_hash(@__FILE__)))
end

function r110_table_check()
    r67_table_check() # Also guard the cached parent No. 67 row.
    found = Tuple[]
    for line in eachline(r67_table)
        startswith(line,'|') || continue
        cells = strip.(split(line,'|'))
        length(cells) >= 9 || continue
        tryparse(Int,cells[2]) == 110 || continue
        m = match(r"\[(\d+),(\d+)\]",cells[8])
        m === nothing && error("Missing No. 110 group ID")
        push!(found,(parse(Int,cells[3]),replace(cells[4],"`"=>""),
            parse(Int,cells[5]),parse(Int,cells[6]),parse(Int,cells[7]),
            (parse(Int,m.captures[1]),parse(Int,m.captures[2]))))
    end
    found == [(12,"C3",1,3,4,(9,2))] ||
        error("No. 110 rank/group/index/dimension row changed: $found")
end

function r110_containment_check()
    matches = 0
    for (line_number,line) in enumerate(eachline(r67_edges))
        line_number == 1 && continue
        v = split(line,'\t')
        length(v) == 12 || error("Malformed strict-containment row $line_number")
        parse(Int,v[1]) == 110 && parse(Int,v[2]) == 67 || continue
        Tuple(parse.(Int,v[3:6])) == (4,2,27,108) ||
            error("Wrong direct-containment dimensions or GL orders")
        v[7:10] == ["embedded","direct","true","fail"] ||
            error("No. 110 -> 67 is not a direct strict containment")
        v[12] in ("literal_matrix_subgroup","A_strict") ||
            error("Unexpected strict-containment method")
        matches += 1
    end
    matches == 1 || error("Expected exactly one direct No. 110 -> 67 edge")
end

function r110_geometric_character()
    histogram = Dict{Tuple{Int,Int},Int}()
    for (i,line) in enumerate(eachline(r110_characters))
        if i == 1
            line == "family_number\tprojective_order\tprimitive_H4_trace\telement_count" ||
                error("Unexpected geometric-character header")
            continue
        end
        isempty(strip(line)) && continue
        v = split(line,'\t')
        length(v) == 4 || error("Malformed geometric-character row $i")
        n,ord,tr,count = parse.(Int,v)
        n == 110 && count > 0 && 1 <= ord <= 9 ||
            error("Unexpected geometric-character row $i")
        key = (ord,tr)
        haskey(histogram,key) && error("Duplicate geometric-character bin")
        histogram[key] = count
    end
    sum(values(histogram)) == 9 || error("Incomplete No. 110 character")
    get(histogram,(1,22),0) == 1 || error("Incorrect identity trace")
    return histogram
end

function r110_preflight()
    hashes = r110_source_hashes()
    r110_table_check(); r110_containment_check()
    expected = r110_geometric_character()
    p = r67_parent()
    r110_note("No. 67 complete cache, No. 110 direct edge and exact character passed")
    r110_note("Source hashes: $hashes")
    return p,expected,hashes
end

# An eligible order-nine subgroup has a C3 kernel inside A4 and maps onto
# the order-three quotient. Every such subgroup contains a lift in the n*f
# coset, n in A4, so these finite loops are exhaustive within No. 67.
function r110_raw(ctx)
    c3 = Dict{Any,Int}()
    for a in 1:12
        ctx.orders[a] == 3 || continue
        A = r67_subgroup(ctx,[a])
        length(A) == 3 && all(i <= 12 for i in A) || continue
        get!(c3,A,a)
    end
    length(c3) == 4 || error("Expected four C3 subgroups in A4")
    raw = Dict{Any,Tuple{Int,Int}}()
    for (A,a) in c3, n in 1:12
        lift = ctx.idx(n,1)
        ctx.mul[ctx.mul[lift,lift],lift] in A || continue
        all(ctx.mul[ctx.mul[lift,x],ctx.inverse[lift]] in A for x in A) || continue
        B = r67_subgroup(ctx,[a,lift])
        length(B) == 9 || error("Normalized C3 lift did not form order nine")
        Tuple(i for i in B if i <= 12) == A || error("Wrong symplectic intersection")
        Set(div(i-1,12) for i in B) == Set(0:2) || error("Wrong quotient")
        get!(raw,B,(a,lift))
    end
    isempty(raw) && error("No eligible C3-by-C3 subgroup in No. 67")
    return raw,length(c3)
end

function r110_groups(output)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Group path must end in .mrdi")
    p,expected,hashes = r110_preflight()
    ctx = r67_context(p)
    raw,n_c3 = r110_raw(ctx)
    eligible = Dict(key=>gens for (key,gens) in raw if
        r67_group_id(ctx,key,collect(gens)) == r110_spec.id)
    classes = r67_classes(ctx,eligible)
    candidates = NamedTuple[]; matches = 0
    for (class_number,c) in enumerate(classes)
        a,lift = eligible[c.key]
        hist = r67_histogram(ctx,c.key)
        matched = hist == expected
        matches += matched
        push!(candidates,(child=110,parent=67,class_number=class_number,
            orbit_size=c.orbit_size,subgroup_indices=c.key,
            group_id=r110_spec.id,symplectic_generator_index=a,
            extra_generator_index=lift,
            symplectic_generator=ctx.elements[a],
            extra_generator=ctx.elements[lift],
            primitive_character_histogram=hist,character_match=matched))
        r110_note("No. 110 class $class_number: orbit $(c.orbit_size), character match=$matched")
    end
    matches > 0 || error("No No. 67 subgroup matches the No. 110 geometric character")
    save(output,(format_version=1,source_hashes=hashes,
        method="all C3 subgroups of A4 and all twelve lifts above f; exact closure and full parent conjugacy",
        parent_number=67,parent_group_order=36,complete_within_saved_parent=true,
        numbered_assignment_claimed=false,c3_subgroups=n_c3,
        raw_subgroups=length(raw),abstract_subgroups=length(eligible),
        parent_classes=length(classes),character_matches=matches,
        candidates=r67_saved_collection(candidates),lattice_and_root_checks_done=false))
    check = load(output)
    @assert check.source_hashes == hashes && length(check.candidates) == length(candidates)
    r110_note("Saved and reloaded $output")
end

function r110_restriction(p,c)
    T = invariant_lattice(p.L,[c.symplectic_generator];
        ambient_representation=false)
    S = orthogonal_submodule(p.L,T)
    @assert rank(S) == 12 && rank(T) == 10
    @assert signature_tuple(S) == (12,0,0)
    @assert signature_tuple(T) == (8,0,2)
    Lf = integer_lattice_with_isometry(p.L,c.extra_generator;
        ambient_representation=false,check=true)
    @assert trivial_action_on_discriminant(Lf)
    Simg = lattice_in_same_ambient_space(Lf,basis_matrix(S);check=true)
    Timg = lattice_in_same_ambient_space(Lf,basis_matrix(T);check=true)
    @assert basis_matrix(S)*gram_matrix(ambient_space(p.L))*
        transpose(basis_matrix(T)) == zero_matrix(QQ,12,10)
    Taction = full_rank_model(Timg)
    @assert Int(order_of_isometry(Taction)) == 3
    pk = embedded_PK_data(Lf,Timg,3)
    P,K = pk.P_lattice,pk.K_lattice
    @assert rank(P) == r110_spec.rank_P && rank(K) == 22-r110_spec.rank_P
    @assert signature_tuple(P) == (r110_spec.rank_P-2,0,2)
    @assert signature_tuple(K) == (rank(K),0,0)
    @assert period_dimension(P,3) == r110_spec.dimension
    return (order=3,dimension=r110_spec.dimension,
        S_in_Lambda0=Simg,T_in_Lambda0=Timg,T_action=Taction,
        K_in_Lambda0=K,P_in_Lambda0=P,P_action=pk.P_with_isometry,
        Lambda0=Lf,group_gap_id=nothing,
        symplectic_kernel_order_S=nothing,symplectic_kernel_order_K=nothing,
        symplectic_saturation_verified=false,extracted_subgroup_id=r110_spec.id,
        group_id_source="verified subgroup of cached No. 67 full group",
        parent_number=67,child_number=110,
        symplectic_generators_in_parent=(c.symplectic_generator,),
        extra_generator_in_parent=c.extra_generator)
end

function r110_lattices(output,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Lattice path must end in .mrdi")
    groups = load(groups_path)
    @assert groups.format_version == 1 && groups.source_hashes == r110_source_hashes()
    p = r67_parent()
    summaries = NamedTuple[]; results = NamedTuple[]
    for c in groups.candidates
        c.character_match || continue
        T = invariant_lattice(p.L,[c.symplectic_generator];
            ambient_representation=false)
        S = orthogonal_submodule(p.L,T)
        reason = ""; index = 0; dimension = -1; rank_P = 0; rank_K = 0
        if rank(S) != 12 || rank(T) != 10
            reason = "symplectic rank mismatch"
        elseif signature_tuple(S) != (12,0,0) || signature_tuple(T) != (8,0,2)
            reason = "symplectic lattice signature mismatch"
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
                if rank_P != r110_spec.rank_P || rank_K != 22-r110_spec.rank_P
                    reason = "period/complement rank mismatch"
                elseif signature_tuple(pk.P_lattice) != (rank_P-2,0,2) ||
                       signature_tuple(pk.K_lattice) != (rank_K,0,0)
                    reason = "period/complement signature mismatch"
                else
                    dimension = period_dimension(pk.P_lattice,3)
                    dimension == r110_spec.dimension ||
                        (reason = "period dimension mismatch")
                end
            end
        end
        push!(summaries,(child=110,class_number=c.class_number,
            rank_S=rank(S),rank_T=rank(T),rank_P=rank_P,rank_K=rank_K,
            index=index,dimension=dimension,matched=isempty(reason),reason=reason))
        r110_note("No. 110 class $(c.class_number): S=$(rank(S)), P=$rank_P, dim=$dimension, reason=$reason")
        isempty(reason) || continue
        push!(results,(child=110,class_number=c.class_number,
            result=r110_restriction(p,c)))
    end
    save(output,(format_version=1,source_hashes=groups.source_hashes,
        groups_file_hash=r67_hash(groups_path),
        summaries=r67_saved_collection(summaries),
        results=r67_saved_collection(results),target_numbers=(110,),
        match_count=length(results),complete_lattice_pass=true,
        roots_verified=false,symplectic_saturation_verified=false,
        numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == groups.source_hashes
    @assert length(check.results) == length(results)
    r110_note("Saved and reloaded $output; lattice matches=$(length(results))")
end

function r110_verify(output,lattices_path,groups_path)
    ispath(output) && error("Refusing to overwrite $output")
    endswith(lowercase(output),".mrdi") || error("Verified path must end in .mrdi")
    groups,data = load(groups_path),load(lattices_path)
    @assert groups.format_version == data.format_version == 1
    @assert groups.source_hashes == data.source_hashes == r110_source_hashes()
    @assert data.groups_file_hash == r67_hash(groups_path)
    p = r67_parent(); ctx = r67_context(p)
    expected = r110_geometric_character()
    verified = NamedTuple[]; obstructed = NamedTuple[]
    for r in data.results
        c = only(x for x in groups.candidates if
            x.child == r.child && x.class_number == r.class_number)
        @assert c.character_match
        a,lift = c.symplectic_generator_index,c.extra_generator_index
        A = r67_subgroup(ctx,[a])
        @assert length(A) == 3 && all(i <= 12 for i in A)
        B = r67_subgroup(ctx,[a,lift])
        @assert B == c.subgroup_indices && Tuple(i for i in B if i <= 12) == A
        @assert r67_group_id(ctx,B,[a,lift]) == r110_spec.id
        @assert r67_histogram(ctx,B) == c.primitive_character_histogram == expected
        result = r110_restriction(p,c)
        @assert gram_matrix(lattice(result.S_in_Lambda0)) ==
            gram_matrix(lattice(r.result.S_in_Lambda0))
        @assert gram_matrix(lattice(result.T_in_Lambda0)) ==
            gram_matrix(lattice(r.result.T_in_Lambda0))
        @assert gram_matrix(result.P_in_Lambda0) == gram_matrix(r.result.P_in_Lambda0)
        @assert gram_matrix(result.K_in_Lambda0) == gram_matrix(r.result.K_in_Lambda0)
        @assert isometry(result.T_action) == isometry(r.result.T_action)
        if has_root(result.K_in_Lambda0,p.L)
            push!(obstructed,(child=110,parent=67,class_number=r.class_number,
                group_id=r110_spec.id))
            r110_note("No. 110 class $(r.class_number): root obstruction")
        else
            push!(verified,(child=110,parent=67,class_number=r.class_number,
                group_id=r110_spec.id,roots_verified=true,result=result))
            r110_note("No. 110 class $(r.class_number): subgroup, lattice and roots verified")
        end
    end
    @assert length(verified)+length(obstructed) == length(data.results)
    save(output,(format_version=1,source_hashes=data.source_hashes,
        groups_file_hash=r67_hash(groups_path),
        lattices_file_hash=r67_hash(lattices_path),
        verified_results=r67_saved_collection(verified),
        root_obstructed=r67_saved_collection(obstructed),
        target_numbers=(110,),verified_count=length(verified),
        obstructed_count=length(obstructed),roots_verified=true,
        complete_lattice_pass=data.complete_lattice_pass,
        complete_within_saved_parent=true,
        symplectic_saturation_verified=false,numbered_assignment_claimed=false))
    check = load(output)
    @assert check.source_hashes == data.source_hashes
    @assert length(check.verified_results) == length(verified)
    @assert length(check.root_obstructed) == length(obstructed)
    r110_note("Saved and reloaded $output; root-free=$(length(verified)), obstructed=$(length(obstructed))")
end

function r110_main()
    isempty(ARGS) && error("Choose preflight, groups, lattices, or verify")
    stage = ARGS[1]
    if stage == "preflight"
        length(ARGS) == 1 || error("preflight takes no arguments")
        r110_preflight()
    elseif stage == "groups"
        length(ARGS) <= 2 || error("groups [output.mrdi]")
        r110_groups(length(ARGS) == 2 ? abspath(ARGS[2]) : r110_groups_file)
    elseif stage == "lattices"
        length(ARGS) <= 3 || error("lattices [output.mrdi] [groups.mrdi]")
        r110_lattices(length(ARGS) >= 2 ? abspath(ARGS[2]) : r110_lattices_file,
            length(ARGS) == 3 ? abspath(ARGS[3]) : r110_groups_file)
    elseif stage == "verify"
        length(ARGS) <= 4 || error("verify [output.mrdi] [lattices.mrdi] [groups.mrdi]")
        r110_verify(length(ARGS) >= 2 ? abspath(ARGS[2]) : r110_verified_file,
            length(ARGS) >= 3 ? abspath(ARGS[3]) : r110_lattices_file,
            length(ARGS) == 4 ? abspath(ARGS[4]) : r110_groups_file)
    else
        error("Unknown stage: $stage")
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    r110_main()
end
