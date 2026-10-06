# Bounded OSCAR postcheck of the SAVED V=10 finite N witness.
# Reads JSON only; does not enumerate graph maps or Hermitian genera.
# Checks the abstract N isometry to U^2+D4^3 and the s eigensublattices.
# Run one Julia thread with external MemoryHigh=4G, MemoryMax=6G,
# MemorySwapMax=0 and RuntimeMaxSec=300s. No result files are overwritten.

using Oscar
using Dates
using SHA

const post_start127=time()
const post_prefix127=joinpath(@__DIR__,"family_127_g13_n_oscar_postcheck")
const post_out127=post_prefix127*".out"
const post_status127=post_prefix127*".status.txt"
const post_input127=joinpath(@__DIR__,"family_127_g13_n_finite_full_v10.json")
@assert !isfile(post_out127) && !isfile(post_status127)
@assert isfile(post_input127)

function post_note127(msg)
    line="$(Dates.now()) | $msg | elapsed=$(round(time()-post_start127;digits=1)) s"
    println(line)
    flush(stdout)
    open(post_out127,"a") do io
        println(io,line)
    end
end
function post_status_write127(value)
    open(post_status127,"w") do io
        println(io,value)
        println(io,"updated=",Dates.now())
    end
end
function post_matrix127(rows)
    n=length(rows)
    @assert all(length(row)==n for row in rows)
    M=zero_matrix(QQ,n,n)
    for i in 1:n,j in 1:n
        M[i,j]=QQ(rows[i][j])
    end
    return M
end
function post_block127(blocks)
    n=sum(nrows(X) for X in blocks)
    G=zero_matrix(QQ,n,n)
    k=0
    for X in blocks
        for i in 1:nrows(X),j in 1:ncols(X)
            G[k+i,k+j]=QQ(X[i,j])
        end
        k+=nrows(X)
    end
    return G
end

try
    post_status_write127("RUNNING")
    post_note127("START Julia=$VERSION OSCAR=$(pkgversion(Oscar)) threads=$(Threads.nthreads())")
    @assert pkgversion(Oscar)==v"1.8.2" && Threads.nthreads()==1
    raw=read(post_input127)
    inputhash=bytes2hex(sha256(raw))
    data=Oscar.JSON.parse(String(raw))
    @assert data["family"]==127 && data["v_start"]==10 && data["v_end"]==10
    @assert data["selected_range_complete"]==true && data["global_complete"]==false
    w=data["first_witness"]
    @assert w["v_index"]==10
    G=post_matrix127(w["gram"])
    g=post_matrix127(w["g"])
    s=post_matrix127(w["s"])
    @assert nrows(G)==16 && abs(det(G))==64
    @assert g^2==-identity_matrix(QQ,16) && s^2==identity_matrix(QQ,16)
    @assert g*s==s*g && g*G*transpose(g)==G && s*G*transpose(s)==G
    N=integer_lattice(;gram=G)
    @assert rank(N)==16 && signature_tuple(N)==(14,0,2) && iseven(N)
    post_note127("WITNESS_LOADED source_sha256=$inputhash N_rank16_sig(14,2)_det64=true")

    U=matrix(QQ,2,2,[0 1;1 0])
    D4=change_base_ring(QQ,gram_matrix(root_lattice(:D,4)))
    target=integer_lattice(;gram=post_block127([U,U,D4,D4,D4]))
    @assert rank(target)==16 && signature_tuple(target)==(14,0,2)
    @assert abs(det(gram_matrix(target)))==64
    post_note127("TARGET_READY U^2+D4^3")
    gen=genus(N)==genus(target)
    post_note127("N_TARGET_GENUS_EQUAL=$gen")
    post_note127("N_TARGET_ISOMETRY_STARTED")
    iso=gen && is_isometric(N,target)
    post_note127("N_TARGET_ISOMETRIC=$iso")

    sf=integer_lattice_with_isometry(N,s;ambient_representation=false)
    post_note127("S_EIGENLATTICES_STARTED")
    anti=coinvariant_lattice(sf)
    fix=invariant_lattice(sf)
    M=lattice(anti)
    K=lattice(fix)
    @assert rank(M)==6 && rank(K)==10
    @assert signature_tuple(M)==(6,0,0)
    @assert signature_tuple(K)==(8,0,2)
    @assert abs(det(gram_matrix(M)))==256
    @assert abs(det(gram_matrix(K)))==1024
    post_note127("S_EIGENLATTICES_RETURNED anti_rank6_det256 fixed_rank10_det1024")
    D6=integer_lattice(;gram=2*change_base_ring(QQ,gram_matrix(root_lattice(:D,6))))
    anti_gen=genus(M)==genus(D6)
    post_note127("S_ANTI_D6_2_GENUS_EQUAL=$anti_gen")
    anti_iso=anti_gen && is_isometric(M,D6)
    post_note127("S_ANTI_D6_2_ISOMETRIC=$anti_iso")
    post_note127("COMPLETED postcheck only; no full cubic-lattice extension or geometric action conjugacy")
    post_status_write127("COMPLETED")
catch err
    post_note127("FAILED $(sprint(showerror,err))")
    post_status_write127("FAILED")
    rethrow()
end
