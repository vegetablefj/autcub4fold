# Directly assemble the 156 numbered records from independently saved stages.
# No historical 156-row catalogue is an input and no enumeration is run.
# Usage: julia --project=... build_156.jl --smoke
#    or: julia --project=... build_156.jl RAW.mrdi STANDARD.mrdi
using Oscar
using SHA
include(joinpath(@__DIR__, "manifest.jl"))

const a_repo = normpath(joinpath(@__DIR__, "..", "..", ".."))
const a_table = joinpath(a_repo, "remark", "input", "family_numbering.md")
const a_core = (:order,:dimension,:S_in_Lambda0,:T_in_Lambda0,:T_action,
    :K_in_Lambda0,:P_in_Lambda0,:P_action,:Lambda0)
const a_rank0 = Set((134,136,140,141,142,143,149,150,152,154,155,156))
const a_cache = Dict{String,Any}()
a_key(n) = lpad(string(n),3,'0')
a_sha(path) = bytes2hex(sha256(read(path)))
a_need(ok,msg) = ok || error(msg)
a_plain(x::ZZLatWithIsom) = lattice(x)
a_plain(x::ZZLat) = x
function a_get(x,k::Symbol,default=nothing)
    if x isa AbstractDict
        return haskey(x,k) ? x[k] : get(x,string(k),default)
    end
    return hasproperty(x,k) ? getproperty(x,k) : default
end
function a_source(item)
    rel = item.source_relpath
    a_need(!isabspath(rel) && !(".." in splitpath(rel)),"Unsafe source path $rel")
    path = normpath(joinpath(a_repo,rel))
    a_need(isfile(path),"Missing source $path")
    return get!(a_cache,path) do
        load(path)
    end
end

function a_table_rows()
    rows = Dict{String,Any}()
    for line in eachline(a_table)
        startswith(line,'|') || continue
        cells = strip.(split(line,'|'))
        length(cells) >= 8 || continue
        n = tryparse(Int,cells[2])
        n === nothing && continue
        1 <= n <= 156 || continue
        key = a_key(n)
        a_need(!haskey(rows,key),"Duplicate GAP number $n")
        rows[key] = Dict{String,Any}(
            "number"=>n,"rank_S"=>parse(Int,cells[3]),
            "symplectic_family"=>replace(cells[4],"`"=>""),
            "generic_index"=>parse(Int,cells[5]),"index"=>parse(Int,cells[6]),
            "dimension"=>parse(Int,match(r"\d+",cells[7]).match),
            "status"=>"unassembled","S_input"=>nothing,"T_input"=>nothing,
            "T_in_ambient"=>nothing,"T_extra_action"=>nothing,
            "saved_result"=>nothing,"candidate_saved_results"=>nothing,
            "source"=>"not yet determined","note"=>"")
    end
    a_need(Set(keys(rows)) == Set(a_key(n) for n in 1:156),
        "GAP numbering is not precisely 1:156")
    return rows
end

function a_identity_result(c,n)
    if n==2
        A,S,T = c["Lambda0"],c["S_in_Lambda0"],c["T_in_Lambda0"]
        a_need(c["root_check"]=="verified: no short or long roots in K=S",
            "No. 2 root record changed")
    else
        A = integer_lattice_with_isometry(c["ambient_lattice"])
        S = lattice_in_same_ambient_space(A,basis_matrix(c["S_in_ambient"]);check=true)
        T = lattice_in_same_ambient_space(A,basis_matrix(c["T_in_ambient"]);check=true)
    end
    L = lattice(A)
    a_need(rank(L)==22 && rank(a_plain(S))==20 && rank(a_plain(T))==2 &&
        iseven(L) && abs(det(L))==3 && is_primitive(L,a_plain(S)) &&
        is_primitive(L,a_plain(T)),"No. $n primitive embedding changed")
    model = integer_lattice(;gram=gram_matrix(a_plain(T)))
    Tf = integer_lattice_with_isometry(model,isometry(T);check=true)
    return (order=1,dimension=0,S_in_Lambda0=S,T_in_Lambda0=T,
        T_action=Tf,K_in_Lambda0=a_plain(S),P_in_Lambda0=a_plain(T),
        P_action=T,Lambda0=A)
end

function a_index_one_result(c,n)
    ids = Dict(10=>(360,118),12=>(168,42),15=>(120,34),
        17=>(72,41),20=>(48,29))
    a_need(a_get(c,:root_check)=="verified: no short or long roots in K=S",
        "No. $n index-one root record changed")
    return (order=1,dimension=1,S_in_Lambda0=c["S_in_Lambda0"],
        T_in_Lambda0=c["T_in_Lambda0"],T_action=c["T_action"],
        K_in_Lambda0=a_plain(c["K_in_Lambda0"]),
        P_in_Lambda0=a_plain(c["P_in_Lambda0"]),
        P_action=c["P_in_Lambda0"],Lambda0=c["Lambda0"],
        group_gap_id=ids[n],roots_verified=true,
        symplectic_saturation_verified=false,child_number=n,
        assignment_source="unique classified (S,T) family")
end

function a_select_results(data,s,n)
    list = a_get(data,:results)
    a_need(list !== nothing,"No. $n source has no results list")
    if haskey(s,:output)
        a_need(1<=s.output<=length(list),"No. $n output index invalid")
        return list[s.output],Tuple(list)
    end
    matches = collect(list)
    if haskey(s,:child)
        matches = filter(matches) do r
            child = a_get(r,:child_number,a_get(r,:child,
                a_get(r,:source_family_number)))
            child == s.child || (child === nothing &&
                (s.child in a_get(r,:character_matches,()) ||
                 (s.child == 141 && a_get(r,:matches_geometric_141,false))))
        end
    end
    if haskey(s,:class)
        matches = filter(r -> a_get(r,:class_number,
            a_get(r,:parent_class_number))==s.class,matches)
    end
    a_need(!isempty(matches),"No. $n result selector matches nothing")
    i = get(s,:index,1)
    a_need(1<=i<=length(matches),"No. $n result index invalid")
    return matches[i],Tuple(matches)
end

function a_select_verified(data,s,n)
    list = a_get(data,:verified_results,a_get(data,:paths))
    a_need(list !== nothing,"No. $n has no verified-results or paths stage")
    matches = collect(filter(list) do v
        r = a_get(v,:result)
        child = a_get(v,:child,a_get(v,:child_number,
            a_get(r,:child_number)))
        if child === nothing
            child = n in a_get(v,:filtered_matches,
                a_get(v,:character_matches,())) ? n : nothing
        end
        child==n || return false
        parent = a_get(v,:parent,a_get(v,:parent_number,
            a_get(r,:parent_number)))
        haskey(s,:parent) && parent!=s.parent && return false
        return true
    end)
    a_need(!isempty(matches),"No. $n verified selector matches nothing")
    sort!(matches;by=v -> (Int(a_get(v,:parent,a_get(v,:parent_number,
        a_get(a_get(v,:result),:parent_number,0)))),
        Int(a_get(v,:class_number,a_get(v,:parent_class_number,0)))))
    # A class selector chooses the representative, not which other matching
    # parent classes to discard (notably Nos. 121 and 124).
    primary = haskey(s,:class) ?
        filter(v -> a_get(v,:class_number,
            a_get(v,:parent_class_number))==s.class,matches) : matches
    i = get(s,:index,1)
    a_need(1<=i<=length(primary),"No. $n verified class/index invalid")
    chosen = primary[i]
    a_need(a_get(chosen,:roots_verified,a_get(data,:roots_verified,true))==true,
        "No. $n selected restriction lacks root certificate")
    return chosen.result,Tuple(matches)
end

function a_select(data,item,n)
    s,kind = item.selector,item.adapter
    if kind==:oscar_case
        c = data.cases[s.case]
        a_need(c.case_index==s.case && 1<=s.result<=length(c.results),
            "No. $n OSCAR case/result changed")
        return c.results[s.result],Tuple(c.results),Dict{String,Any}(
            "source_case_index"=>s.case,"source_result_index"=>s.result)
    elseif kind==:results
        r,others = a_select_results(data,s,n)
        return r,others,Dict{String,Any}()
    elseif kind==:result
        r = a_get(data,:result)
        a_need(a_get(r,:child_number)==n &&
            a_get(data,:verify_group_id)==true && a_get(data,:verify_roots)==true,
            "No. $n direct restriction certificate changed")
        return r,(),Dict{String,Any}()
    elseif kind==:verified_results
        r,paths = a_select_verified(data,s,n)
        return r,(),Dict{String,Any}("verified_parent_paths"=>paths)
    elseif kind==:restricted
        paths = [p for p in a_get(data,:paths) if a_get(p,:child)==n]
        a_need(!isempty(paths),"No. $n restriction path missing")
        chosen = only(p for p in paths if a_get(p,:parent)==s.parent)
        a_need(a_get(chosen,:primary,true)==true,"No. $n nonprimary path selected")
        return chosen.result,(),Dict{String,Any}("saved_parent_paths"=>Tuple(paths),
            "selected_parent_class"=>s.parent)
    elseif kind==:crosspart
        rec = data["records"][s.key]
        r = rec["ambient_restriction"]
        a_need(r.child_number==n && rec["parent_number"]==r.parent_number,
            "No. $n cross-part numbering changed")
        a_need(rec["eligible_parent_conjugacy_classes"]==1 &&
            rec["geometric_character_matches"]==1 &&
            rec["exact_S_integral_isometry"] &&
            rec["exact_T_integral_isometry"] && rec["root_free"],
            "No. $n cross-part uniqueness/isometry certificate changed")
        r = merge(r,(group_gap_id=rec["projective_group_id"],
            roots_verified=true,numbered_parent_restriction_certified=true))
        return r,(),Dict{String,Any}("ambient_parent_number"=>r.parent_number)
    elseif kind==:index1_gluing
        candidates = data["records"][s.key]
        a_need(!isempty(candidates),"No. $n index-one candidates missing")
        i = s.index
        a_need(1<=i<=length(candidates),"No. $n index-one selector invalid")
        return a_index_one_result(candidates[i],n),(),Dict{String,Any}(
            "candidate_ambient_embeddings"=>Tuple(candidates),
            "selected_ambient_candidate_index"=>i,
            "primitive_embedding"=>candidates[i])
    elseif kind==:index1_parent
        c = data["records"][s.key]
        candidates = n==12 ?
            (c,data["records"]["012_case3_result2"]) : (c,)
        return a_index_one_result(c,n),(),Dict{String,Any}(
            "candidate_ambient_embeddings"=>candidates,
            "selected_ambient_candidate_index"=>1,
            "primitive_embedding"=>c)
    elseif kind==:embedding
        if s.kind==:orbit_candidate
            a_need(data["orbit_count"]==data["candidate_count"]==1,
                "No. 2 primitive orbit is not unique")
            c = data["candidates"][s.index]
            return a_identity_result(c,n),(),Dict{String,Any}(
                "primitive_embedding"=>c,"no2_integral_orbit_count"=>1)
        elseif s.kind==:m10_residual
            c = only(r for r in data["records"] if r["residual_line"]==s.line)
            d,perp = n==5 ? (3,4) : (1,36)
            a_need(c["e1_divisibility"]==d &&
                c["e1_orthogonal_determinant"]==perp &&
                divisibility(c["ambient_lattice"],c["e1_in_ambient"])==d,
                "No. $n M10 residual-line criterion changed")
            return a_identity_result(c,n),(),Dict{String,Any}(
                "primitive_embedding"=>c,"M10_residual_line"=>s.line)
        elseif s.kind==:standard_record
            rec = data["records"][s.key]
            a_need(rec.provenance.family==n && rec.provenance.search_complete==false,
                "No. 127 constructive witness scope changed")
            return rec.data,(),Dict{String,Any}(
                "source_witness_scope"=>"constructive, not exhaustive",
                "search_complete"=>false)
        end
    elseif kind==:no105
        no97 = joinpath(a_repo,"remark","catalogue",
            "restriction_97_100_from_74.verified.mrdi")
        enumeration = joinpath(a_repo,"remark","catalogue","no105",
            "no105_T_enumeration.mrdi")
        a_need(data["family_number"]==105 &&
            data["counts"]["retained"]==1 && data["counts"]["extensions"]==20 &&
            data["counts"]["wrong_S_character"]==18 &&
            data["counts"]["roots"]==1 &&
            data["numbered_assignment_claimed"]==false &&
            data["source_no97_sha256"]==a_sha(no97) &&
            data["T_enumeration_sha256"]==a_sha(enumeration),
            "No. 105 extension counts changed")
        r = only(data["results"])
        a_need(r.group_gap_id==(24,13) && r.roots_verified &&
            r.symplectic_saturation_verified && !r.numbered_assignment_claimed,
            "No. 105 retained extension changed")
        return r,(),Dict{String,Any}("T_search_input"=>data["T_input"],
            "numbering_basis"=>"separate Fermat-to-listed-coordinate GAP character certificate")
    elseif kind==:paths
        paths = data["paths"][a_key(n)]
        a_need(!isempty(paths),"No. $n cyclic parent paths absent")
        chosen = paths[a_key(s.parent)]
        a_need(chosen.provenance.family_number==n &&
            chosen.provenance.parent_number==s.parent &&
            chosen.provenance.containment_status==
                "embedded; direct verified matrix-group comparison",
            "No. $n containment record changed")
        return chosen.data,(),Dict{String,Any}(
            "cyclic_power_paths"=>paths,"selected_cyclic_power_parent"=>s.parent)
    elseif kind==:rank0_result
        if n==143
            a_need(data.child_number==143 && data.candidate_parent_classes==(1,2,3) &&
                data.identical_geometric_character_for_all_three,
                "No. 143 spectrum record changed")
            return data.result,(),Dict{String,Any}()
        end
        rec = only(r for r in data.results if r.child_number==n &&
            r.parent_number==s.parent && r.parent_class_number==s.class)
        a_need(rec.character_matches==[n],"No. $n character match changed")
        return rec.restriction,(),Dict{String,Any}()
    end
    error("No. $n unsupported adapter $kind")
end

function a_attach!(row,n,item,r,candidates,extras)
    a_need(r isa NamedTuple,"No. $n source is not a named result")
    n in a_rank0 || a_need(all(hasproperty(r,f) for f in a_core),
        "No. $n lacks a standard ambient field")
    ord = a_get(r,:order,a_get(r,:quotient_order))
    if ord===nothing && n in a_rank0
        A = a_get(r,:Lambda0)
        a_need(A!==nothing,"No. $n rank-zero source has no ambient action")
        ord = order_of_isometry(A)
    end
    a_need(ord!==nothing && Int(ord)==row["index"] &&
        Int(r.dimension)==row["dimension"],
        "No. $n order/dimension differs from GAP numbering")
    S,T = a_get(r,:S_in_Lambda0),a_get(r,:T_in_Lambda0)
    if S!==nothing
        a_need(rank(a_plain(S))==row["rank_S"],"No. $n S rank differs")
        row["S_input"] = a_plain(S)
    end
    if T!==nothing
        a_need(rank(a_plain(T))==22-row["rank_S"],"No. $n T rank differs")
        row["T_input"] = a_plain(T)
    end
    action = a_get(r,:T_action)
    action===nothing && row["rank_S"]==0 && (action=a_get(r,:Lambda0))
    a_need(action!==nothing && order_of_isometry(action)==row["index"],
        "No. $n T action has wrong exact order")
    row["T_input"]===nothing && (row["T_input"]=a_plain(action))
    if n==105
        # The enumeration input and the retained integral T basis differ.
        row["T_input"] = a_plain(r.T_action)
    end
    row["T_in_ambient"] = T===nothing ? a_get(r,:Lambda0) : T
    row["T_extra_action"] = action
    row["saved_result"] = r
    length(candidates)>1 && item.adapter in (:results,:oscar_case) &&
        (row["candidate_saved_results"]=candidates)
    merge!(row,extras)
    row["status"] = n==127 ? "constructed_maximal_witness_not_exhaustive" :
        "assembled_from_independent_saved_source"
    row["source"] = (item.source_relpath,item.evidence...)
    if n==105
        row["source"] = (row["source"]...,
            "remark/catalogue/no105/no105_T_enumeration.mrdi",
            "remark/catalogue/no105/verify_no104_no105_character.g")
    end
    row["note"] = n==105 ?
        "Saved extension was unnumbered; separate Fermat-to-listed-coordinate character certificate identifies No. 105." :
        "Selected saved integral action; no enumeration rerun."
    return row
end

function a_special_checks!(rows)
    for (n,diag) in ((13,(-2,-28)),(14,(-4,-14)))
        r = rows[a_key(n)]["saved_result"]
        a_need(length(rows[a_key(n)]["candidate_saved_results"])==2,
            "No. $n alternatives not retained")
        expected = integer_lattice(;gram=matrix(ZZ,2,2,[diag[1],0,0,diag[2]]))
        a_need(is_isometric(lattice(coinvariant_lattice(r.T_action)),expected),
            "No. $n negative eigensublattice differs")
    end
    path = joinpath(a_repo,"remark","catalogue","a33_case23",
        "case23_full_coset_comparison.mrdi")
    cert = load(path)
    a_need(cert.method=="complete primitive-index-six coset character comparison" &&
        cert.source_sha256==a_sha(joinpath(a_repo,"oscar","oscar_script_data.mrdi")) &&
        cert.unique_assignment && length(cert.results)==2,
        "No. 56/57 coset certificate changed")
    for (n,ri) in ((56,1),(57,2))
        r = rows[a_key(n)]["saved_result"]
        c = cert.results[ri]
        a_need(c.saved_result==ri && c.matching_family_numbers==[n] &&
            c.group_gap_id==r.group_gap_id==(108,38) &&
            length(rows[a_key(n)]["candidate_saved_results"])==2,
            "No. $n case-23 assignment changed")
    end
    a_need(rows["002"]["no2_integral_orbit_count"]==1 &&
        rows["005"]["M10_residual_line"]==1 &&
        rows["006"]["M10_residual_line"]==2 &&
        rows["055"]["selected_parent_class"]==56,
        "No. 2/M10/55 anchor changed")
    for (n,count) in ((121,3),(124,2))
        a_need(length(rows[a_key(n)]["verified_parent_paths"])==count,
            "No. $n alternatives not retained")
    end
    return true
end

function a_build()
    rows = a_table_rows()
    hashes = Dict{String,Any}(
        "remark/input/family_numbering.md"=>a_sha(a_table),
        "remark/catalogue/assembly/manifest.jl"=>
            a_sha(joinpath(@__DIR__,"manifest.jl")))
    no105_sources = ("remark/catalogue/no105/no105_T_enumeration.mrdi",
        "remark/catalogue/no105/verify_no104_no105_character.g")
    for rel in no105_sources
        hashes[rel] = a_sha(joinpath(a_repo,rel))
    end
    for n in 1:156
        item = SELECTED_SOURCES[n]
        data = a_source(item)
        r,candidates,extras = a_select(data,item,n)
        a_attach!(rows[a_key(n)],n,item,r,candidates,extras)
        hashes[item.source_relpath] = a_sha(joinpath(a_repo,item.source_relpath))
        for evidence in item.evidence
            path = joinpath(a_repo,evidence)
            isfile(path) && (hashes[evidence]=a_sha(path))
        end
        println("Assembled ",n,"/156: ",item.adapter)
        flush(stdout)
    end
    a_special_checks!(rows)
    a_need(all(rows[a_key(n)]["saved_result"]!==nothing for n in 1:156),
        "An assembled row is absent")
    return Dict{String,Any}(
        "format_version"=>1,
        "description"=>"Numbered ambient actions from independent saved sources; 12 rank-zero records await mechanical normalization",
        "julia_version"=>string(VERSION),"oscar_version"=>string(pkgversion(Oscar)),
        "number_order"=>Tuple(1:156),"rows"=>rows,
        "unassigned_search_outputs"=>String[],"source_sha256"=>hashes)
end

function a_main()
    if ARGS==["--smoke"]
        a_build()
        println("SMOKE PASS: 156 direct-source selections")
        return
    end
    length(ARGS)==2 || error("Usage: build_156.jl --smoke | RAW.mrdi STANDARD.mrdi")
    raw,standard = abspath.(ARGS)
    a_need(raw!=standard,"Raw and standard paths must differ")
    for p in (raw,standard,raw*".building.mrdi")
        a_need(!ispath(p),"Refusing to overwrite $p")
    end
    data = a_build()
    stage = raw*".building.mrdi"
    save(stage,data)
    check = load(stage)
    a_need(check["number_order"]==Tuple(1:156) &&
        all(check["rows"][a_key(n)]["number"]==n for n in 1:156),
        "Reload of raw direct-source catalogue failed")
    mv(stage,raw)
    println("Saved direct-source raw catalogue: $raw")
    # Exponent-one expansion checks each extant legacy action/P/K field.
    include(joinpath(a_repo,"remark","catalogue","ambient_completion",
        "sources","normalize_rank0_ambient_fields.jl"))
    Base.invokelatest(nr_main,raw,standard)
    println("Saved mechanically standardized catalogue: $standard")
end

if abspath(PROGRAM_FILE)==abspath(@__FILE__)
    a_main()
end
