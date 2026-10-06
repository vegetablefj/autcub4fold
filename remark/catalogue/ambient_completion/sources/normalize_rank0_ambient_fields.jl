# Mechanical schema normalization of twelve existing S=0 ambient records.
# Usage: julia --project=<OSCAR project> normalize_rank0_ambient_fields.jl INPUT OUTPUT
# Functions only when included: nr_main(input, output), or nr_main() using ARGS.
# No O(S), root, saturation, T-action, gluing or family-identification search.

using Oscar
using SHA

const nr_catalogue_dir = normpath(joinpath(@__DIR__, "..", ".."))
const nr_restrict_path = joinpath(nr_catalogue_dir, "restrict_cyclic_power.jl")
const nr_comparison_path = joinpath(nr_catalogue_dir, "merge_no60_partial_catalogues_functions.jl")
const nr_restrict_pin = "26073e7213b3e517e7d808888a66ba1166ed6cae8a5d37639561173eaf143193"
const nr_comparison_pin = "bd7bcb5f66e5fc61bc8c4d7d3f887a9e4b089477b7055efc2e8b4591c47ba221"
const nr_targets = (134,136,140,141,142,143,149,150,152,154,155,156)
const nr_core_fields = (:order,:dimension,:S_in_Lambda0,:T_in_Lambda0,:T_action,
    :K_in_Lambda0,:P_in_Lambda0,:P_action,:Lambda0)

nr_sha(path) = bytes2hex(sha256(read(path)))
nr_key(n) = lpad(string(n),3,'0')
nr_require(ok,message) = ok || error(message)
nr_plain(A::ZZLatWithIsom) = lattice(A)
nr_plain(L::ZZLat) = L
nr_integral(M) = all(denominator(QQ(M[i,j])) == 1
    for i in 1:nrows(M) for j in 1:ncols(M))

nr_require(nr_sha(nr_restrict_path) == nr_restrict_pin,"Restriction helper hash changed")
nr_require(nr_sha(nr_comparison_path) == nr_comparison_pin,"Comparison helper hash changed")
isdefined(@__MODULE__,:restrict_cyclic_power) || include(nr_restrict_path)
isdefined(@__MODULE__,:cm_same) || include(nr_comparison_path)

function nr_exact_order(M,n)
    n = Int(n)
    n > 0 || return false
    I = identity_matrix(QQ,nrows(M))
    M^n == I || return false
    return all(M^div(n,Int(p)) != I for (p,_) in factor(ZZ(n)))
end

# Integral equality in the actual saved ambient coordinates, with no solver
# side convention and no assumption that an ambient basis is square.
function nr_transport(U,V,label)
    nr_require(rank(U) == rank(V),"$label ranks differ")
    nr_require(ncols(basis_matrix(U)) == ncols(basis_matrix(V)) &&
        gram_matrix(ambient_space(U)) == gram_matrix(ambient_space(V)),"$label ambient coordinates differ")
    nr_require(rank(vcat(basis_matrix(U),basis_matrix(V))) == rank(U),"$label rational rowspaces differ")
    rank(U) == 0 && return zero_matrix(QQ,0,0)
    C = basis_matrix(U)*gram_matrix(ambient_space(V))*transpose(basis_matrix(V))*inv(gram_matrix(V))
    nr_require(C*basis_matrix(V) == basis_matrix(U),"$label coordinate reconstruction failed")
    nr_require(nr_integral(C) && abs(det(C)) == 1,"$label is not an integral unimodular transport")
    nr_require(C*gram_matrix(V)*transpose(C) == gram_matrix(U),"$label Gram transport failed")
    return C
end

function nr_action_match(old,new,label; allow_full_model=false)
    nr_require(old isa ZZLatWithIsom && new isa ZZLatWithIsom,"$label has no saved action")
    U,V = lattice(old),lattice(new)
    nr_require(rank(U) == rank(V),"$label action ranks differ")
    if ncols(basis_matrix(U)) == ncols(basis_matrix(V)) &&
       gram_matrix(ambient_space(U)) == gram_matrix(ambient_space(V))
        C = nr_transport(U,V,label)
        nr_require(isometry(old)*C == C*isometry(new),"$label actions do not intertwine")
        return (criterion="exact embedded unimodular action transport",transport=C)
    end
    nr_require(allow_full_model && ncols(basis_matrix(U)) == rank(U),
        "$label is not a compatible embedded action or permitted full-rank T model")
    nr_require(gram_matrix(U) == gram_matrix(V) && isometry(old) == isometry(new),
        "$label full-rank model Gram/action differs")
    return (criterion="same Gram and lattice-basis action in a full-rank T model",
        transport=identity_matrix(QQ,rank(U)))
end

function nr_missing_fields(n)
    n in (134,136,140,141,143) && return Set((:S_in_Lambda0,))
    n in (142,149,150) && return Set((:order,:S_in_Lambda0))
    return Set((:order,:S_in_Lambda0,:T_in_Lambda0,:T_action,:K_in_Lambda0,:P_in_Lambda0))
end

function nr_input_report(row,field,U)
    original = get(row,field,nothing)
    original === nothing && return "absent; saved embedded lattice authoritative"
    V = nr_plain(original)
    nr_require(rank(V) == rank(U) && signature_tuple(V) == signature_tuple(U),
        "row $field rank/signature differs")
    return gram_matrix(V) == gram_matrix(U) ? "same Gram" :
        "Gram differs; no abstract isometry search; original input retained"
end

# This check is also called against independently reloaded output. Every
# extant old core field and every old P/K alias is checked, not just the fields
# that happen to be present in the standard nine-field schema.
function nr_check_legacy(row,legacy,core,n)
    nr_require(legacy isa NamedTuple,"No.$n legacy saved_result is not a NamedTuple")
    missing = Set(f for f in nr_core_fields if !hasproperty(legacy,f))
    nr_require(missing == nr_missing_fields(n),"No.$n unexpected legacy missing-field schema")
    nr_require(row["number"] == n && Int(row["rank_S"]) == 0,"No.$n row number/rank_S differs")
    m,d = Int(row["index"]),Int(row["dimension"])
    nr_require(core.order == m && core.dimension == d,"No.$n normalized order/dimension differs")
    nr_require(core.Lambda0 isa ZZLatWithIsom && legacy.Lambda0 isa ZZLatWithIsom,
        "No.$n full ambient action missing")
    nr_require(nr_exact_order(isometry(legacy.Lambda0),m) &&
        Int(order_of_isometry(legacy.Lambda0)) == m,"No.$n saved ambient action does not have exact index order")
    checks = Dict{String,Any}()
    checks["Lambda0"] = nr_action_match(legacy.Lambda0,core.Lambda0,"No.$n Lambda0")
    oldextra = get(row,"T_extra_action",nothing)
    nr_require(oldextra !== nothing,"No.$n row T_extra_action missing")
    checks["row_T_extra_action"] = nr_action_match(oldextra,core.T_action,
        "No.$n row T_extra_action";allow_full_model=true)
    oldT = get(row,"T_in_ambient",nothing)
    nr_require(oldT !== nothing,"No.$n row T_in_ambient missing")
    checks["row_T_in_ambient"] = nr_transport(nr_plain(oldT),lattice(core.T_in_Lambda0),
        "No.$n row T_in_ambient")
    if oldT isa ZZLatWithIsom
        checks["row_T_in_ambient_action"] = nr_action_match(oldT,core.T_in_Lambda0,"No.$n embedded row T action")
    end
    for field in (:order,:quotient_order,:dimension,:rank_S,:rank_T,:rank_P,:rank_K)
        hasproperty(legacy,field) || continue
        expected = field in (:order,:quotient_order) ? m : field == :dimension ? d :
            field == :rank_S ? 0 : field == :rank_T ? 22 :
            field == :rank_P ? rank(core.P_in_Lambda0) : rank(core.K_in_Lambda0)
        nr_require(Int(getproperty(legacy,field)) == expected,"No.$n legacy $field metadata differs")
    end
    for field in (:T_in_Lambda0,:T_action)
        hasproperty(legacy,field) || continue
        checks[string(field)] = nr_action_match(getproperty(legacy,field),getproperty(core,field),
            "No.$n legacy $field";allow_full_model=field == :T_action)
    end
    nr_require(hasproperty(legacy,:P_action),"No.$n legacy P_action missing")
    checks["P_action"] = nr_action_match(legacy.P_action,core.P_action,"No.$n legacy P_action")
    for (field,newfield) in ((:P_in_Lambda0,:P_in_Lambda0),(:P,:P_in_Lambda0),
                            (:K_in_Lambda0,:K_in_Lambda0),(:K,:K_in_Lambda0))
        hasproperty(legacy,field) || continue
        old = getproperty(legacy,field)
        checks[string(field)] = nr_transport(nr_plain(old),nr_plain(getproperty(core,newfield)),
            "No.$n legacy $field")
    end
    nr_require(any(hasproperty(legacy,f) for f in (:P_in_Lambda0,:P)) &&
        any(hasproperty(legacy,f) for f in (:K_in_Lambda0,:K)),"No.$n legacy P/K evidence missing")
    if get(row,"S_in_ambient",nothing) !== nothing
        checks["row_S_in_ambient"] = nr_transport(nr_plain(row["S_in_ambient"]),
            lattice(core.S_in_Lambda0),"No.$n row S_in_ambient")
    end
    checks["S_input"] = nr_input_report(row,"S_input",lattice(core.S_in_Lambda0))
    checks["T_input"] = nr_input_report(row,"T_input",lattice(core.T_in_Lambda0))
    return checks
end

function nr_normalize_row(old,n,hashes)
    nr_require(!haskey(old,"legacy_saved_result"),"No.$n already has legacy_saved_result")
    legacy = get(old,"saved_result",nothing)
    nr_require(legacy isa NamedTuple && hasproperty(legacy,:Lambda0),"No.$n saved Lambda0 missing")
    m = Int(old["index"])
    nr_require(Int(old["rank_S"]) == 0 && Int(order_of_isometry(legacy.Lambda0)) == m &&
        nr_exact_order(isometry(legacy.Lambda0),m),"No.$n is not an exact-order S=0 source")
    # m equals the saved order: this is exponent one, not a subgroup search.
    expanded = restrict_cyclic_power(legacy.Lambda0,m)
    nr_require(expanded.power_exponent == 1 && expanded.source_order == m,"No.$n unexpectedly changed the generator")
    core = NamedTuple{nr_core_fields}(Tuple(getproperty(expanded,f) for f in nr_core_fields))
    nr_require(rank(lattice(core.S_in_Lambda0)) == 0 && rank(lattice(core.T_in_Lambda0)) == 22,
        "No.$n normalized S/T ranks differ")
    checks = nr_check_legacy(old,legacy,core,n)
    row = copy(old)
    row["legacy_saved_result"] = legacy
    row["saved_result"] = merge(legacy,core)
    row["T_in_ambient"] = core.T_in_Lambda0
    row["T_extra_action"] = core.T_action
    row["pre_rank0_normalization_source"] = old["source"]
    oldsource = old["source"]
    sourceitems = oldsource isa Tuple || oldsource isa AbstractVector ? Tuple(oldsource) : (oldsource,)
    row["source"] = (sourceitems...,
        "ambient_completion/sources/normalize_rank0_ambient_fields.jl: exponent-one mechanical standard-field normalization of saved S=0 ambient action")
    row["pre_rank0_normalization_note"] = get(old,"note",nothing)
    row["note"] = string(get(old,"note",""),
        " Standard nine fields mechanically normalized from the existing exact-order ambient action, with S=0, T=Lambda0, P=ker(Phi_index), K=P-perpendicular. Every old T/P action and old embedded P/K (including raw P/K aliases) was checked by exact saved-coordinate transport. No enumeration, root/saturation recheck, geometric identification or uniqueness claim was added.")
    row["rank0_ambient_normalization_certificate"] = Dict{String,Any}(
        "number"=>n,"index"=>m,"dimension"=>core.dimension,
        "scope"=>"mechanical standard-field normalization of an existing identified S=0 ambient action",
        "power_exponent"=>1,"legacy_fields"=>Tuple(keys(legacy)),
        "filled_fields"=>Tuple(f for f in nr_core_fields if !hasproperty(legacy,f)),
        "source_sha256"=>copy(hashes),"legacy_compatibility_checks"=>checks,
        "new_enumeration"=>false,"family_assignment_reproved"=>false,
        "roots_retested"=>false,"symplectic_saturation_recomputed"=>false)
    return row
end

function nr_check_reload(baseline,expected,actual,hashes)
    cm_check_format(actual)
    nr_require(Set(keys(actual)) == Set(keys(baseline)),"Reloaded top-level keys changed")
    for field in keys(baseline)
        field in ("rows","source_sha256") && continue
        nr_require(cm_same(baseline[field],actual[field]),"Unrelated top-level $field changed")
    end
    nr_require(cm_same(expected["source_sha256"],actual["source_sha256"]),"Reloaded source pins differ")
    for n in 1:156
        old,row = baseline["rows"][nr_key(n)],actual["rows"][nr_key(n)]
        nr_require(cm_same(expected["rows"][nr_key(n)],row),"Reloaded row $n differs from its staged value")
        saved = get(row,"saved_result",nothing)
        nr_require(saved isa NamedTuple && all(hasproperty(saved,f) for f in nr_core_fields),
            "Reloaded row $n lacks standard nine fields")
        if n in nr_targets
            nr_require(cm_same(old["saved_result"],row["legacy_saved_result"]),"No.$n legacy result was altered")
            r = row["saved_result"]
            nr_require(all(hasproperty(r,f) for f in nr_core_fields),"No.$n still lacks standard fields")
            nr_require(cm_same(r,merge(old["saved_result"],NamedTuple{nr_core_fields}(
                Tuple(getproperty(r,f) for f in nr_core_fields)))),"No.$n legacy metadata changed")
            nr_check_legacy(old,row["legacy_saved_result"],r,n)
            nr_require(cm_same(row["T_in_ambient"],r.T_in_Lambda0) &&
                cm_same(row["T_extra_action"],r.T_action),"No.$n normalized row actions differ")
            nr_require(cm_same(row["rank0_ambient_normalization_certificate"]["source_sha256"],hashes),
                "No.$n certificate source pins differ")
            for field in keys(old)
                field in ("saved_result","T_in_ambient","T_extra_action","source","note") && continue
                nr_require(cm_same(old[field],row[field]),"No.$n unrelated field $field changed")
            end
        else
            nr_require(cm_same(old,row),"Unrelated row $n changed")
        end
    end
    return true
end

function nr_main(input::AbstractString,output::AbstractString)
    input,output = abspath(input),abspath(output)
    nr_require(input != output,"Input and output must differ")
    stage,receipt_path,text_path = output*".stage.mrdi",output*".receipt.mrdi",output*".receipt.txt"
    for path in (output,stage,receipt_path,text_path)
        ispath(path) && error("Refusing to overwrite $path")
    end
    paths = Dict("input_catalogue"=>input,"restrict_cyclic_power.jl"=>nr_restrict_path,
        "normalize_rank0_ambient_fields.jl"=>abspath(@__FILE__),
        "merge_no60_partial_catalogues_functions.jl"=>nr_comparison_path)
    hashes = Dict(name=>nr_sha(path) for (name,path) in paths)
    nr_require(hashes["restrict_cyclic_power.jl"] == nr_restrict_pin &&
        hashes["merge_no60_partial_catalogues_functions.jl"] == nr_comparison_pin,"Pinned helper changed")
    baseline = load(input)
    cm_check_format(baseline)
    result = copy(baseline)
    result["rows"] = copy(baseline["rows"])
    result["source_sha256"] = copy(baseline["source_sha256"])
    for (name,path) in paths
        key = name == "input_catalogue" ? basename(input) : name
        existing = get(result["source_sha256"],key,nothing)
        nr_require(existing === nothing || existing == hashes[name],"Conflicting source hash for $key")
        result["source_sha256"][key] = hashes[name]
    end
    lines = String["Mechanical S=0 standard-field normalization; no new enumeration or mathematical family identification.",
        "Input: $input", "Input SHA-256: $(hashes["input_catalogue"])", "Output: $output"]
    for n in nr_targets
        result["rows"][nr_key(n)] = nr_normalize_row(baseline["rows"][nr_key(n)],n,hashes)
        line = "PASS No.$n: old T/P actions and embedded P/K compatible; standard nine fields filled; exponent=1"
        push!(lines,line)
        println(line)
        flush(stdout)
    end
    nr_require(all(nr_sha(path) == hashes[name] for (name,path) in paths),"Input/source changed during normalization")
    save(stage,result)
    staged = load(stage)
    # Reload input independently as well; no object-identity equality is used.
    fresh_baseline = load(input)
    nr_check_reload(fresh_baseline,result,staged,hashes)
    nr_require(all(nr_sha(path) == hashes[name] for (name,path) in paths),"Input/source changed during reload check")
    mv(stage,output)
    final = load(output)
    nr_check_reload(fresh_baseline,result,final,hashes)
    nr_require(all(nr_sha(path) == hashes[name] for (name,path) in paths),"Input/source changed before receipt")
    receipt = Dict{String,Any}("format_version"=>1,"scope"=>"mechanical S=0 schema normalization only",
        "input_path"=>input,"output_path"=>output,"source_sha256"=>hashes,
        "output_sha256"=>nr_sha(output),"changed_rows"=>nr_targets,"unchanged_row_count"=>144,
        "legacy_records_preserved"=>true,"standard_nine_fields_complete"=>true,
        "stage_and_final_reload_checked"=>true,"input_unchanged"=>true,
        "new_enumeration"=>false,"family_assignment_reproved"=>false,
        "root_tests_repeated"=>false,"symplectic_saturation_recomputed"=>false)
    save(receipt_path,receipt)
    nr_require(cm_same(receipt,load(receipt_path)),"Receipt reload differs")
    push!(lines,"PASS: 12 normalized rows; 144 unrelated rows unchanged; legacy metadata retained; stage/final reload passed.")
    open(text_path,"w") do io
        for line in lines
            println(io,line)
        end
    end
    println(last(lines))
    println("Output: ",output)
    println("Receipt: ",receipt_path)
    return final
end

function nr_main()
    length(ARGS) == 2 || error("Usage: normalize_rank0_ambient_fields.jl INPUT OUTPUT")
    return nr_main(ARGS[1],ARGS[2])
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    nr_main()
end
