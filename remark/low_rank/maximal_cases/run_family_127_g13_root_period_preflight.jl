# Prepared, not launched: bounded root/period check for the saved full-L witness.
# Reuses the exact has_root predicate in oscar/oscar_script.jl, but does NOT
# call discriminant_kernel_order or any symplectic-saturation enumeration.
# Suggested external guard: one thread, MemoryHigh=4G, MemoryMax=6G,
# MemorySwapMax=0, RuntimeMaxSec=300s. A timeout is inconclusive.

using Oscar
using Dates
using SHA
include(joinpath(@__DIR__,"..","..","..","oscar","oscar_script.jl"))

const root_start127=time()
const root_prefix127=joinpath(@__DIR__,"family_127_g13_root_period_preflight")
const root_out127=root_prefix127*".out"
const root_status127=root_prefix127*".status.txt"
const root_input127=joinpath(@__DIR__,"family_127_g13_full_finite_glue_preflight.json")
const root_input_sha127="43f385e222bda664e485d88ea3a8c83981793e4f2fbda2be8df184c29d886567"
@assert !isfile(root_out127) && !isfile(root_status127)

function root_note127(msg)
    line="$(Dates.now()) | $msg | elapsed=$(round(time()-root_start127;digits=1)) s"
    println(line)
    flush(stdout)
    open(root_out127,"a") do io
        println(io,line)
    end
end
function root_status_write127(status)
    open(root_status127,"w") do io
        println(io,status)
        println(io,"updated=",Dates.now())
    end
end
function root_matrix127(rows)
    n=length(rows)
    @assert all(length(row)==n for row in rows)
    m=zero_matrix(QQ,n,n)
    for i in 1:n,j in 1:n
        m[i,j]=QQ(rows[i][j])
    end
    m
end

try
    root_status_write127("RUNNING")
    root_note127("START Julia=$VERSION OSCAR=$(pkgversion(Oscar)) threads=$(Threads.nthreads())")
    @assert pkgversion(Oscar)==v"1.8.2" && Threads.nthreads()==1
    raw=read(root_input127)
    @assert bytes2hex(sha256(raw))==root_input_sha127
    data=Oscar.JSON.parse(String(raw))
    @assert data["family"]==127 && data["search_complete"]==false
    w=data["first_witness"]
    G=root_matrix127(w["gram"])
    g=root_matrix127(w["g"])
    s=root_matrix127(w["s"])
    @assert g^4==identity_matrix(QQ,22) && s^2==identity_matrix(QQ,22)
    @assert g*s==s*g && g*G*transpose(g)==G && s*G*transpose(s)==G
    L=integer_lattice(;gram=G)
    @assert rank(L)==22 && signature_tuple(L)==(20,0,2) && abs(det(G))==3
    root_note127("FULL_WITNESS_LOADED sha256=$root_input_sha127")

    sf=integer_lattice_with_isometry(L,s;ambient_representation=false)
    T=lattice(invariant_lattice(sf))
    @assert rank(T)==14 && signature_tuple(T)==(12,0,2)
    B=basis_matrix(T)
    @assert ncols(B)==22
    gT=B*g*G*transpose(B)*inv(gram_matrix(T))
    @assert all(denominator(gT[i,j])==1 for i in 1:14,j in 1:14)
    @assert gT*B==B*g && gT^4==identity_matrix(QQ,14)
    Tf=integer_lattice_with_isometry(T,gT;ambient_representation=false)
    root_note127("T_WITH_RESTRICTED_G_READY rank14")

    # OSCAR's public kernel_lattice(Tf,4) is the saturated Phi4 kernel.
    Pf=kernel_lattice(Tf,4)
    P=lattice(Pf)
    @assert rank(P)==10 && signature_tuple(P)==(8,0,2)
    @assert (rank(P) ÷ 2)-1==4 # No.127 period-domain dimension.
    K=orthogonal_submodule(L,basis_matrix(P))
    @assert rank(K)==12 && signature_tuple(K)==(12,0,0)
    root_note127("PERIOD_P_RANK10_SIG8_2_DIM4=true; K_ORTHOGONAL_RANK12_POSITIVE=true")

    # Original project predicate: norm-2 roots, or norm-6 roots with ambient
    # divisibility 3. No tilde O(K) / discriminant-kernel-order call follows.
    root_note127("HAS_ROOT_STARTED")
    root_present=has_root(K,L)
    root_note127("HAS_ROOT=$root_present; ROOT_FREE=$(!root_present)")
    root_note127("COMPLETED root/period necessary check only; saturation not tested")
    root_status_write127("COMPLETED")
catch err
    root_note127("FAILED $(sprint(showerror,err))")
    root_status_write127("FAILED")
    rethrow()
end
