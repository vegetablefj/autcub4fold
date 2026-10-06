# Independently check one saved high-rank prescribed-action sidecar.
# Usage: julia --project=... verify_prescribed_ambient.jl NUMBER [SIDECAR.mrdi]
# The default reads the historical sidecar; an explicit path may name a new
# unified-runner output. This verifier writes no files and enumerates no O(S).
# It verifies the integral action and saved finite kernel, not the external
# geometric uniqueness theorem that identifies a numbered family.

using Oscar
using SHA
include(joinpath(@__DIR__,"specs.jl"))
include(joinpath(hr_project,"oscar","oscar_script.jl"))

1 <= length(ARGS) <= 2 || error("Supply a family number and optional sidecar")
const hv_number = parse(Int,ARGS[1])
haskey(hr_specs,hv_number) || error("Unsupported family number")
const hv_spec = hr_specs[hv_number]
const hv_key = lpad(string(hv_number),3,'0')
const hv_old_dir = joinpath(hr_project,"remark","catalogue",
    "ambient_completion","rank20_19")
const hv_old_stem = hv_number in (9,11,16,19) ?
    "rank19_generic_$(hv_key)_20261004" :
    "remaining_classified_$(hv_key)_20261004"
const hv_path = length(ARGS) == 2 ? abspath(ARGS[2]) :
    joinpath(hv_old_dir,hv_old_stem*".mrdi")

hv_integral(M) = all(denominator(QQ(M[i,j])) == 1
    for i in 1:nrows(M) for j in 1:ncols(M))
hv_sha(path) = bytes2hex(sha256(read(path)))
hv_require(ok,message) = ok || error(message)

function hv_exact_order(M,advertised)
    n = Int(advertised)
    n > 0 || return false
    I = identity_matrix(QQ,nrows(M))
    M^n == I || return false
    return all(M^div(n,Int(p)) != I for (p,_) in factor(ZZ(n)))
end

function hv_stable(Lf)
    D,fD = discriminant_group(Lf)
    return all(fD(x) == x for x in gens(D))
end

function hv_same_primitive(L,U,V)
    gram_matrix(ambient_space(U)) == gram_matrix(ambient_space(V)) ==
        gram_matrix(ambient_space(L)) || return false
    rank(U) == rank(V) || return false
    is_primitive(L,U) && is_primitive(L,V) || return false
    return rank(vcat(basis_matrix(U),basis_matrix(V))) == rank(U)
end

function hv_root_obstruction(K,L)
    @assert is_positive_definite(K)
    G = gram_matrix(ambient_space(L))
    @assert gram_matrix(ambient_space(K)) == G
    any(norm == 2 for (_,norm) in short_vectors(K,2,2)) && return true
    pairings = basis_matrix(K)*G*transpose(basis_matrix(L))
    @assert hv_integral(pairings)
    integral_pairings = map_entries(ZZ,pairings)
    for (v,norm) in short_vectors(K,6,6)
        norm == 6 || continue
        row = matrix(ZZ,1,length(v),v)*integral_pairings
        d = ZZ(0)
        for j in 1:ncols(row)
            d = gcd(d,abs(row[1,j]))
            isone(d) && break
        end
        d == 3 && return true
    end
    return false
end

function hv_annihilated_by_phi(M,m)
    p = cyclotomic_polynomial(m)
    I = identity_matrix(QQ,nrows(M))
    value = zero_matrix(QQ,nrows(M),ncols(M))
    for j in degree(p):-1:0
        value = value*M + QQ(coeff(p,j))*I
    end
    return iszero(value)
end

# O(S) is finite because S is positive definite. Its mod-5 representation
# is faithful: the principal congruence kernel at an odd prime is torsion-free.
function hv_finite_group(S,matrices)
    @assert is_positive_definite(S)
    G = gram_matrix(S)
    for u in matrices
        @assert hv_integral(u) && abs(det(u)) == 1
        @assert u*G*transpose(u) == G
    end
    F = GF(5)
    return matrix_group([map_entries(F,u) for u in matrices])
end

function hv_kernel(S,cache)
    @assert cache.format_version == 1
    @assert cache.S_gram == gram_matrix(S)
    @assert cache.symplectic_order == hv_spec.symplectic_order
    @assert cache.orthogonal_order ==
        cache.symplectic_order*cache.discriminant_image_order
    N = cache.symplectic_generators_S
    isempty(N) && error("Saved stable-kernel generators are missing")
    G = gram_matrix(S)
    for u in N
        @assert hv_integral(u) && u*G*transpose(u) == G
        Su = integer_lattice_with_isometry(S,u;
            ambient_representation=false,check=true)
        @assert hv_stable(Su)
    end
    @assert Int(order(hv_finite_group(S,N))) == hv_spec.symplectic_order
    for u in cache.orthogonal_generators_S
        @assert hv_integral(u) && u*G*transpose(u) == G
    end
    return N
end

function hv_record(r,S0,T0,Tf0,cache,k)
    println("No. $hv_number output $k: checking embedded action and roots")
    flush(stdout)
    Lf,Sf,Tf = r.Lambda0,r.S_in_Lambda0,r.T_in_Lambda0
    L,S,T = lattice(Lf),lattice(Sf),lattice(Tf)
    P,K = r.P_in_Lambda0,r.K_in_Lambda0
    @assert rank(L) == 22 && signature_tuple(L) == (20,0,2)
    @assert iseven(L) && abs(det(gram_matrix(L))) == 3
    @assert rank(S) == rank(K) == hv_spec.rank_S
    @assert rank(T) == rank(P) == hv_spec.rank_T
    @assert signature_tuple(S) == (hv_spec.rank_S,0,0)
    @assert signature_tuple(T) == (hv_spec.rank_T-2,0,2)
    @assert gram_matrix(S) == gram_matrix(S0)
    @assert gram_matrix(T) == gram_matrix(T0)
    @assert is_primitive(L,S) && is_primitive(L,T)
    G = gram_matrix(ambient_space(L))
    BS,BT,BL = basis_matrix(S),basis_matrix(T),basis_matrix(L)
    @assert gram_matrix(ambient_space(S)) == gram_matrix(ambient_space(T)) == G
    @assert BS*G*transpose(BT) == zero_matrix(QQ,hv_spec.rank_S,hv_spec.rank_T)
    @assert nrows(BL) == ncols(BL) == 22
    embedding = vcat(BS,BT)*inv(BL)
    @assert hv_integral(embedding) && !iszero(det(embedding))
    glue_index = abs(det(embedding))
    @assert glue_index^2*3 ==
        abs(det(gram_matrix(S0)))*abs(det(gram_matrix(T0)))
    @assert is_isometric_with_isometry(discriminant_group(L),
        discriminant_group(root_lattice(:A,2)))[1]
    E,C = BS*inv(BL),BT*inv(BL)
    fS,fT,fL = isometry(Sf),isometry(Tf),isometry(Lf)
    fA = ambient_isometry(Lf)
    @assert hv_integral(fL) && fL*gram_matrix(L)*transpose(fL) == gram_matrix(L)
    @assert hv_integral(fS) && fS*gram_matrix(S)*transpose(fS) == gram_matrix(S)
    @assert hv_integral(fT) && fT*gram_matrix(T)*transpose(fT) == gram_matrix(T)
    @assert fS*E == E*fL && fT*C == C*fL
    @assert BL*fA == fL*BL && BS*fA == fS*BS && BT*fA == fT*BT
    @assert hv_stable(Lf)
    @assert fT == isometry(Tf0) == isometry(r.T_action)
    @assert gram_matrix(lattice(r.T_action)) == gram_matrix(T0)
    @assert hv_exact_order(fT,hv_spec.index)
    @assert Int(order_of_isometry(Tf)) ==
        Int(order_of_isometry(r.T_action)) == hv_spec.index
    ambient_order,s_order = Int(order_of_isometry(Lf)),Int(order_of_isometry(Sf))
    @assert ambient_order == r.actual_ambient_generator_order
    @assert s_order == r.actual_S_generator_order
    @assert ambient_order == lcm(s_order,hv_spec.index)
    @assert hv_exact_order(fL,ambient_order) && hv_exact_order(fS,s_order)
    @assert hv_same_primitive(L,P,T) && hv_same_primitive(L,K,S)
    @assert hv_same_primitive(L,lattice(r.P_action),P)
    @assert basis_matrix(P)*fA == isometry(r.P_action)*basis_matrix(P)
    @assert hv_annihilated_by_phi(isometry(r.P_action),hv_spec.index)
    @assert basis_matrix(K)*G*transpose(basis_matrix(P)) ==
        zero_matrix(QQ,hv_spec.rank_S,hv_spec.rank_T)
    phi = Int(euler_phi(hv_spec.index))
    @assert rank(P) % phi == 0
    dim = div(rank(P),phi) - (hv_spec.index <= 2 ? 2 : 1)
    @assert dim == r.dimension == hv_spec.dimension
    @assert r.source_family_number == hv_number
    @assert r.order == hv_spec.index && r.roots_verified
    # K=S was proved above; its root obstruction is checked independently.
    @assert !hv_root_obstruction(S,L)
    @assert r.symplectic_generators_S == cache.symplectic_generators_S
    if hasproperty(r,:orthogonal_generators_S)
        @assert r.orthogonal_generators_S == cache.orthogonal_generators_S
    end
    H = hv_finite_group(S,
        vcat(collect(cache.symplectic_generators_S),[fS]))
    full_order = Int(order(H))
    @assert full_order == hv_spec.symplectic_order*hv_spec.index
    if hasproperty(r,:full_group_order)
        @assert r.full_group_order == full_order
    end
    if hasproperty(r,:symplectic_order)
        @assert r.symplectic_order == hv_spec.symplectic_order
    end
    if hasproperty(r,:quotient_order)
        @assert r.quotient_order == hv_spec.index
    end
    if hv_spec.group_id !== nothing
        id = small_group_identification(H)
        @assert Tuple(Int.(id)) == hv_spec.group_id == Tuple(Int.(r.group_gap_id))
    else
        @assert r.group_gap_id == "order $full_order"
    end
    println("PASS No. $hv_number output $k: kernel $(hv_spec.symplectic_order), " *
        "full group $full_order, gluing $glue_index, dimension $dim")
    flush(stdout)
    return Int(glue_index)
end

function hv_check_new_hashes(data)
    get(data,"classification","") ==
        "first-fitting prescribed-action primitive-extension search" || return false
    hashes = data["source_sha256"]
    normalized = Dict(replace(String(relative),'\\'=>'/')=>digest
        for (relative,digest) in hashes)
    # Only these archived provenance entries changed during relocation.
    # The other recorded source digests and all mathematical checks stay strict.
    if haskey(normalized,"remark/oscar/highrank/run_prescribed_ambient.jl")
        historical = Dict(
            "remark/oscar/highrank/run_prescribed_ambient.jl" =>
                "9a0824a56599b953cd1ce8a85b57e3970beaaaf481bf519bb5629cb43c1c2b81",
            "remark/oscar/highrank/specs.jl" =>
                "244ffd24eb559c00675f63cfcd56d8ac04c1b9c140c94d3408038452c254e8ba",
            "gap_result/gap_family_numbering.md" =>
                "9998c6895033467fdfe42a66255799358a4fa99e201961409186a058ead927fc",
        )
        for (relative,digest) in normalized
            if haskey(historical,relative)
                @assert digest == historical[relative]
            else
                relocated = replace(relative,
                    "remark/oscar/highrank/" => "remark/enumeration/highrank/")
                path = normpath(joinpath(hr_project,split(relocated,'/')...))
                @assert isfile(path) && hv_sha(path) == digest
            end
        end
        @assert all(key->haskey(normalized,key),keys(historical))
        return false
    end
    haskey(normalized,"remark/enumeration/highrank/run_prescribed_ambient.jl") ||
        error("New sidecar lacks its runner source hash")
    for (relative,digest) in normalized
        path = normpath(joinpath(hr_project,split(relative,'/')...))
        @assert isfile(path) && hv_sha(path) == digest
    end
    return true
end

function hv_main()
    hr_check_numbering(hv_number,hv_spec)
    @assert isfile(hv_path)
    before = hv_sha(hv_path)
    data = load(hv_path)
    @assert data["format_version"] == 1 && data["family_number"] == hv_number
    @assert !isempty(data["results"])
    @assert get(data,"expected_group_id",nothing) == hv_spec.group_id
    if haskey(data,"expected_symplectic_order")
        @assert data["expected_symplectic_order"] == hv_spec.symplectic_order
    end
    new_hashes = hv_check_new_hashes(data)
    S0,T0,Tf0 = hr_inputs(hv_spec)
    @assert data["gluing_index"] == glue_order_to_disc3(S0,T0)
    @assert gram_matrix(data["S_input"]) == gram_matrix(S0)
    @assert gram_matrix(data["T_input"]) == gram_matrix(T0)
    @assert gram_matrix(lattice(data["prescribed_T_action"])) == gram_matrix(T0)
    @assert isometry(data["prescribed_T_action"]) == isometry(Tf0)
    cache = data["plain_side_matrix_cache"]
    hv_kernel(S0,cache)
    for (k,r) in enumerate(data["results"])
        @assert hv_record(r,S0,T0,Tf0,cache,k) == data["gluing_index"]
    end
    @assert hv_sha(hv_path) == before "Sidecar changed during verification"
    println("PASS No. $hv_number: $(length(data["results"])) saved outputs; " *
        (new_hashes ? "current source hashes matched" :
            "historical source hashes not revalidated in this checkout") *
        "; sidecar_sha256=$before")
end

hv_main()
