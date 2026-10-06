# Independent structural audit of all 156 standard ambient records.
# Usage: julia --project=<OSCAR project> verify_complete_156_ambient.jl CATALOGUE [RECEIPT_STEM]
# This file performs no orthogonal-group, T-action, gluing, root, or saturation search.
# It writes new .txt/.mrdi receipts only. Geometric family assignments are not re-proved.

using Oscar
using SHA
using Dates

const sv_core = (:order,:dimension,:S_in_Lambda0,:T_in_Lambda0,:T_action,
    :K_in_Lambda0,:P_in_Lambda0,:P_action,:Lambda0)
sv_sha(path) = bytes2hex(sha256(read(path)))
sv_key(n) = lpad(string(n),3,'0')
sv_plain(A::ZZLatWithIsom) = lattice(A)
sv_plain(L::ZZLat) = L
sv_integral(M) = all(denominator(QQ(M[i,j])) == 1
    for i in 1:nrows(M) for j in 1:ncols(M))
sv_require(ok,message) = ok || error(message)

function sv_exact_order(M,n)
    n = Int(n)
    n > 0 || return false
    I = identity_matrix(QQ,nrows(M))
    M^n == I || return false
    return all(M^div(n,Int(p)) != I for (p,_) in factor(ZZ(n)))
end

function sv_phi_value(M,n)
    p = cyclotomic_polynomial(Int(n))
    I = identity_matrix(QQ,nrows(M))
    value = zero_matrix(QQ,nrows(M),ncols(M))
    for j in degree(p):-1:0
        value = value*M + QQ(coeff(p,j))*I
    end
    return value
end

function sv_shared_ambient(L,U,label)
    sv_require(ncols(basis_matrix(U)) == ncols(basis_matrix(L)),"$label ambient dimension differs")
    sv_require(gram_matrix(ambient_space(U)) == gram_matrix(ambient_space(L)),
        "$label is not in the same saved ambient coordinate space")
    sv_require(gram_matrix(U) == basis_matrix(U)*gram_matrix(ambient_space(L))*transpose(basis_matrix(U)),
        "$label Gram is inconsistent with its embedded basis")
end

function sv_lattice_coordinates(L,U,label)
    # Lambda0 can be rank 22 in a larger ambient rational space (No. 105).
    # Recover coordinates by its nondegenerate Gram, not by inverting a
    # possibly rectangular basis matrix. The residual equality proves that
    # U really lies in its rational span.
    B,BU,G = basis_matrix(L),basis_matrix(U),gram_matrix(ambient_space(L))
    C = BU*G*transpose(B)*inv(gram_matrix(L))
    sv_require(C*B == BU,"$label is outside the rational span of Lambda0")
    return C
end

function sv_primitive(L,U,label)
    sv_shared_ambient(L,U,label)
    # The zero sublattice is primitive; avoid order/signature sentinels for S=0.
    sv_require(rank(U) == 0 || is_primitive(L,U),"$label is not primitive")
    C = sv_lattice_coordinates(L,U,label)
    sv_require(sv_integral(C),"$label does not lie integrally in Lambda0")
end

function sv_same_rowspace(U,V)
    rank(U) == rank(V) || return false
    return rank(vcat(basis_matrix(U),basis_matrix(V))) == rank(U)
end

# Exact integral equality in one ambient coordinate space. The rowspace test
# is explicit and independent of a linear solver's default side convention.
function sv_basis_change(U,V,label)
    sv_require(gram_matrix(ambient_space(U)) == gram_matrix(ambient_space(V)),"$label ambient differs")
    sv_require(sv_same_rowspace(U,V),"$label rational rowspaces differ")
    rank(U) == 0 && return zero_matrix(QQ,0,0)
    C = basis_matrix(U)*gram_matrix(ambient_space(V))*transpose(basis_matrix(V))*inv(gram_matrix(V))
    sv_require(C*basis_matrix(V) == basis_matrix(U),"$label row-coordinate recovery failed")
    sv_require(sv_integral(C) && abs(det(C)) == 1,"$label integral lattices differ")
    return C
end

function sv_restriction(U,ambient_action)
    rank(U) == 0 && return zero_matrix(QQ,0,0)
    B,G = basis_matrix(U),gram_matrix(ambient_space(U))
    f = B*ambient_action*G*transpose(B)*inv(gram_matrix(U))
    sv_require(f*B == B*ambient_action,"embedded subspace is not invariant")
    sv_require(sv_integral(f),"restriction is not integral in its embedded basis")
    sv_require(f*gram_matrix(U)*transpose(f) == gram_matrix(U),"restriction does not preserve Gram")
    return f
end

function sv_embedded_action(A,U,ambient_action,label)
    sv_require(A isa ZZLatWithIsom,"$label is not a lattice with isometry")
    V = lattice(A)
    C = sv_basis_change(V,U,label)
    fU = sv_restriction(U,ambient_action)
    sv_require(isometry(A)*C == C*fU,"$label disagrees with the ambient restriction")
    return fU
end

function sv_model_action(A,U,fU,L,label)
    sv_require(A isa ZZLatWithIsom,"$label is not a lattice with isometry")
    V = lattice(A)
    sv_require(rank(V) == rank(U),"$label rank differs")
    if ncols(basis_matrix(V)) == ncols(basis_matrix(L)) &&
       gram_matrix(ambient_space(V)) == gram_matrix(ambient_space(L))
        C = sv_basis_change(V,U,label)
        sv_require(isometry(A)*C == C*fU,"$label embedded action disagrees")
        return "embedded basis checked"
    end
    # The standard full-rank model preserves the Gram and the lattice-basis
    # isometry. No unidentified integral isometry is inferred from a spectrum.
    sv_require(gram_matrix(V) == gram_matrix(U),"$label full-rank model Gram differs from its embedded lattice")
    sv_require(isometry(A) == fU,"$label full-rank model action differs in the stored basis")
    return "same Gram and lattice-basis action checked"
end

function sv_input_report(row,field,U)
    original = get(row,field,nothing)
    original === nothing && return "absent; embedded saved_result authoritative"
    V = sv_plain(original)
    sv_require(rank(V) == rank(U),"row $field rank differs")
    sv_require(signature_tuple(V) == signature_tuple(U),"row $field signature differs")
    return gram_matrix(V) == gram_matrix(U) ? "same Gram" :
        "Gram differs; no abstract isometry enumeration run; embedded saved_result authoritative"
end

function sv_row(row,n,qA2)
    sv_require(row["number"] == n,"row number differs")
    r = get(row,"saved_result",nothing)
    sv_require(r isa NamedTuple,"standard saved_result NamedTuple is missing")
    sv_require(all(hasproperty(r,field) for field in sv_core),"one or more standard nine fields are missing")
    sv_require(r.Lambda0 isa ZZLatWithIsom,"Lambda0 action is missing")
    L = lattice(r.Lambda0)
    S,T = sv_plain(r.S_in_Lambda0),sv_plain(r.T_in_Lambda0)
    K,P = sv_plain(r.K_in_Lambda0),sv_plain(r.P_in_Lambda0)
    m,d = Int(row["index"]),Int(row["dimension"])
    sv_require(Int(r.order) == m && Int(r.dimension) == d,"saved order/dimension differs from numbered row")
    sv_require(rank(L) == 22 && signature_tuple(L) == (20,0,2),"Lambda0 rank/signature differs")
    sv_require(iseven(L) && abs(det(L)) == 3,"Lambda0 is not even of determinant three")
    sv_require(is_isometric_with_isometry(discriminant_group(L),qA2)[1],"Lambda0 discriminant form is not q_A2")
    sv_require(rank(S) == Int(row["rank_S"]) && rank(S)+rank(T) == 22,"S/T ranks differ")
    sv_require(signature_tuple(S) == (rank(S),0,0),"S is not positive definite (or zero)")
    sv_require(signature_tuple(T) == (rank(T)-2,0,2),"T signature differs")
    sv_require(rank(P) >= 2 && rank(P)+rank(K) == 22,"P/K ranks differ")
    sv_require(signature_tuple(P) == (rank(P)-2,0,2),"P signature differs")
    sv_require(signature_tuple(K) == (rank(K),0,0),"K is not positive definite (or zero)")
    for (label,U) in (("S",S),("T",T),("P",P),("K",K))
        sv_primitive(L,U,label)
    end
    G,BL = gram_matrix(ambient_space(L)),basis_matrix(L)
    BS,BT,BP,BK = basis_matrix(S),basis_matrix(T),basis_matrix(P),basis_matrix(K)
    sv_require(iszero(BS*G*transpose(BT)),"S and T are not orthogonal")
    sv_require(iszero(BP*G*transpose(BK)),"P and K are not orthogonal")
    sv_require(rank(vcat(BS,BT)) == 22 && rank(vcat(BP,BK)) == 22,"orthogonal pairs do not span ambient rational space")
    sv_require(rank(vcat(BT,BP)) == rank(T),"P is not contained in T rationally")
    # Both spaces are primitive in L, so their integral inclusion/equality is
    # determined by the corresponding rational span; verify explicit complements.
    sv_basis_change(K,orthogonal_submodule(L,BP),"K = P-perpendicular")
    sv_basis_change(S,orthogonal_submodule(L,BT),"S = T-perpendicular")
    glue_index = abs(det(vcat(sv_lattice_coordinates(L,S,"S gluing"),
        sv_lattice_coordinates(L,T,"T gluing"))))
    sv_require(denominator(glue_index) == 1 && glue_index^2*3 == abs(det(S))*abs(det(T)),"S/T determinant gluing identity failed")
    fL = isometry(r.Lambda0)
    sv_require(sv_integral(fL) && fL*gram_matrix(L)*transpose(fL) == gram_matrix(L),"Lambda0 action is not an integral isometry")
    ambient_action = ambient_isometry(r.Lambda0)
    sv_require(nrows(ambient_action) == ncols(ambient_action) == ncols(BL),
        "ambient action dimension differs from the saved rational space")
    sv_require(BL*ambient_action == fL*BL,"ambient action coordinate recovery failed")
    fS = sv_embedded_action(r.S_in_Lambda0,S,ambient_action,"S action")
    fT = sv_embedded_action(r.T_in_Lambda0,T,ambient_action,"T action")
    sv_require(sv_exact_order(fT,m),"T action does not have the exact numbered quotient index")
    lambda_order = Int(order_of_isometry(r.Lambda0))
    sv_require(lambda_order > 0 && lambda_order % m == 0 && sv_exact_order(fL,lambda_order),"ambient lift order is incompatible")
    # A lift's order may exceed its quotient order through a symplectic power;
    # the exact non-symplectic index is the faithful order on T, not that lift order.
    D,fD = discriminant_group(r.Lambda0)
    sv_require(all(fD(x) == x for x in gens(D)),"ambient action is not stable on its discriminant")
    t_model = sv_model_action(r.T_action,T,fT,L,"saved T_action")
    row_extra = get(row,"T_extra_action",nothing)
    sv_require(row_extra !== nothing,"row T_extra_action is missing")
    row_t_model = sv_model_action(row_extra,T,fT,L,"row T_extra_action")
    row_t = get(row,"T_in_ambient",nothing)
    sv_require(row_t !== nothing,"row T_in_ambient is missing")
    sv_basis_change(sv_plain(row_t),T,"row T_in_ambient")
    row_t isa ZZLatWithIsom && sv_embedded_action(row_t,T,ambient_action,"row embedded T action")
    if haskey(row,"S_in_ambient") && row["S_in_ambient"] !== nothing
        sv_basis_change(sv_plain(row["S_in_ambient"]),S,"row S_in_ambient")
    end
    fP = sv_restriction(P,ambient_action)
    p_model = sv_model_action(r.P_action,P,fP,L,"P_action")
    sv_require(sv_exact_order(fP,m) && iszero(sv_phi_value(fP,m)),"P_action is not an exact primitive Phi_m action")
    phiT = sv_phi_value(fT,m)
    sv_require(rank(T)-rank(phiT) == rank(P),"P does not have the full Phi_m-kernel rank")
    CPT = BP*G*transpose(BT)*inv(gram_matrix(T))
    sv_require(CPT*BT == BP && iszero(CPT*phiT),"P is not the embedded Phi_m kernel in T")
    phi = Int(euler_phi(m))
    sv_require(rank(P) % phi == 0,"P rank is not divisible by phi(index)")
    calculated_dimension = div(rank(P),phi) - (m in (1,2) ? 2 : 1)
    sv_require(calculated_dimension == d,"period dimension formula differs from numbered row")
    return (number=n,rank_S=rank(S),rank_T=rank(T),rank_P=rank(P),rank_K=rank(K),
        index=m,dimension=d,ambient_lift_order=lambda_order,gluing_index=glue_index,
        S_input=sv_input_report(row,"S_input",S),T_input=sv_input_report(row,"T_input",T),
        T_action_basis_check=t_model,row_T_action_basis_check=row_t_model,
        P_action_basis_check=p_model,structural_checks_passed=true)
end

function sv_write_receipts(stem,receipt,lines)
    text_path,mrdi_path = stem*".txt",stem*".mrdi"
    ispath(text_path) || ispath(mrdi_path) ? error("Receipt output already exists") : nothing
    save(mrdi_path,receipt)
    check = load(mrdi_path)
    sv_require(check["catalogue_sha256"] == receipt["catalogue_sha256"] &&
        check["passed_row_count"] == receipt["passed_row_count"] &&
        check["complete"] == receipt["complete"] &&
        check["rows"] == receipt["rows"],"receipt reload failed")
    open(text_path,"w") do io
        for line in lines
            println(io,line)
        end
    end
    println("Receipt: ",text_path)
    println("Receipt data: ",mrdi_path)
end

function sv_main()
    1 <= length(ARGS) <= 2 || error("Usage: verify_complete_156_ambient.jl CATALOGUE [RECEIPT_STEM]")
    input = abspath(ARGS[1])
    stem = length(ARGS) == 2 ? abspath(ARGS[2]) :
        input*".structural_"*Dates.format(now(),"yyyymmddTHHMMSS")
    for path in (stem*".txt",stem*".mrdi")
        ispath(path) && error("Refusing to overwrite $path")
    end
    hash_before = sv_sha(input)
    println("Loading the saved 156-row catalogue for structural checks")
    flush(stdout)
    catalogue = load(input)
    sv_require(catalogue["format_version"] == 1 && catalogue["number_order"] == Tuple(1:156),"catalogue numbering/format differs")
    rows = catalogue["rows"]
    sv_require(Set(keys(rows)) == Set(sv_key(n) for n in 1:156),"catalogue lacks exactly 156 numbered rows")
    println("Loaded 156 numbered rows; no group or root enumeration will be run")
    flush(stdout)
    qA2 = discriminant_group(root_lattice(:A,2))
    lines = String["Structural audit only: primitive ambient lattices, compatible stable extra actions, cyclotomic periods and dimension formulas.",
        "No new family-identification, root, saturation, O(S), T-action or gluing enumeration checks.",
        "Catalogue: $input", "SHA-256: $hash_before"]
    results = Any[]
    failed_number,failure = 0,""
    for n in 1:156
        try
            result = sv_row(rows[sv_key(n)],n,qA2)
            push!(results,result)
            gram_note = startswith(result.S_input,"Gram differs") || startswith(result.T_input,"Gram differs") ? "; input Gram differs (recorded)" : ""
            line = "PASS No.$n: S=$(result.rank_S) T=$(result.rank_T) P=$(result.rank_P) K=$(result.rank_K) index=$(result.index) dim=$(result.dimension) lift_order=$(result.ambient_lift_order)$gram_note"
            push!(lines,line)
            println(line)
            flush(stdout)
        catch err
            failed_number,failure = n,sprint(showerror,err)
            line = "FAIL No.$n: $failure"
            push!(lines,line)
            println(line)
            flush(stdout)
            break
        end
    end
    unchanged = sv_sha(input) == hash_before
    complete = length(results) == 156 && unchanged
    push!(lines,"$(complete ? "PASS" : "INCOMPLETE"): $(length(results))/156 rows structurally checked; input unchanged=$unchanged")
    receipt = Dict{String,Any}(
        "format_version"=>1,"scope"=>"structural audit only; no family identification, roots, saturation or enumeration re-proof",
        "catalogue_path"=>input,"catalogue_sha256"=>hash_before,
        "verifier_sha256"=>sv_sha(@__FILE__),"created_at"=>string(now()),
        "passed_row_count"=>length(results),"complete"=>complete,"input_unchanged"=>unchanged,
        "failed_row"=>failed_number,"failure"=>failure,"rows"=>Tuple(results),
        "new_orthogonal_group_or_gluing_enumeration"=>false,
        "family_assignments_reverified"=>false,"root_tests_repeated"=>false,
        "symplectic_saturation_recomputed"=>false,
    )
    sv_write_receipts(stem,receipt,lines)
    complete || error("Structural verification incomplete; see the new receipt")
    println(last(lines))
end

sv_main()
