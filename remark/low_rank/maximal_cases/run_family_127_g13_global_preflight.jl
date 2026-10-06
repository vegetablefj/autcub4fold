# Single-genus, bounded preflight for Hermitian genus #13 in family 127.
# This calls representative(g13) ONCE, not representatives_of_hermitian_type
# and not genus_representatives. If it returns, immediately save the trace
# Gram matrix and integral order-four action as a recoverable MRDI checkpoint.
# Only then compare the trace lattice with the explicit Q-side complement.
# No Q-equivariant glue and no N-side search. No claim of class completeness.
# This run used one Julia thread and external MemoryHigh=4 GiB,
# MemoryMax=6 GiB, MemorySwapMax=0, RuntimeMaxSec=300 s hard guards.

using Oscar
using Dates
using SHA

const g13_start127 = time()
const g13_prefix127 = joinpath(@__DIR__,"family_127_g13_global_preflight")
const g13_out127 = g13_prefix127 * ".out"
const g13_status127 = g13_prefix127 * ".status.txt"
const g13_mrdi127 = g13_prefix127 * ".mrdi"
@assert !isfile(g13_out127) && !isfile(g13_status127) && !isfile(g13_mrdi127)

function g13_note127(msg)
    line = "$(Dates.now()) | $msg | elapsed=$(round(time()-g13_start127;digits=1)) s"
    println(line)
    flush(stdout)
    open(g13_out127,"a") do io
        println(io,line)
    end
end
function g13_status_write127(value)
    open(g13_status127,"w") do io
        println(io,value)
        println(io,"updated=",Dates.now())
    end
end
function g13_block127(blocks)
    n = sum(nrows(X) for X in blocks)
    G = zero_matrix(QQ,n,n)
    k = 0
    for X in blocks
        for i in 1:nrows(X),j in 1:ncols(X)
            G[k+i,k+j] = QQ(X[i,j])
        end
        k += nrows(X)
    end
    return G
end
function g13_target127()
    U = matrix(QQ,2,2,[0 1;1 0])
    E8 = 2*change_base_ring(QQ,gram_matrix(root_lattice(:E,8)))
    GQ = g13_block127([U,matrix(QQ,1,1,[2]),matrix(QQ,1,1,[-2]),E8])
    Q = integer_lattice(;gram=GQ)
    tidx = first(j for j in 2:8 if abs(E8[1,j])==2)
    tsign = E8[1,tidx]==2 ? 1 : -1
    VA = zero_matrix(QQ,2,12)
    VA[1,5]=1
    VA[2,1]=2; VA[2,2]=-2
    VA[2,3]=1; VA[2,4]=1
    VA[2,5]=-1; VA[2,4+tidx]=2*tsign
    @assert VA*GQ*transpose(VA)==4*identity_matrix(QQ,2)
    return orthogonal_submodule(Q,VA)
end

try
    g13_status_write127("RUNNING")
    hash = bytes2hex(sha256(read(@__FILE__)))
    g13_note127("START Julia=$VERSION OSCAR=$(pkgversion(Oscar)) threads=$(Threads.nthreads()) source_sha256=$hash")
    @assert pkgversion(Oscar)==v"1.8.2" && Threads.nthreads()==1

    Ktarget = g13_target127()
    @assert rank(Ktarget)==10 && signature_tuple(Ktarget)==(8,0,2)
    @assert abs(det(gram_matrix(Ktarget)))==1024
    g13_note127("TARGET_READY K=A^perp in explicit Q, rank10 sig(8,2) det1024")

    E, _ = cyclotomic_field_as_cm_extension(4;cached=false)
    OE = maximal_order(E)
    DE = different(OE)
    F = base_field(E)
    gene = hermitian_genera(E,5,Dict(real_places(F)[1]=>1),
        fractional_ideal(OE,one(E)); min_scale=inv(DE),max_scale=DE)
    unique!(gene)
    @assert length(gene)==19
    p2 = prime_decomposition(maximal_order(F),ZZ(2))[1][1]
    h2 = gene[13][p2]
    @assert [(scale(h2,i),rank(h2,i),norm(h2,i),det(h2,i))
        for i in 1:length(h2)] == [(-1,2,0,1),(0,2,1,-1),(2,1,1,1)]
    H2 = representative(h2)
    @assert genus(H2,p2)==h2
    M2,_ = trace_lattice_with_isometry(H2)
    @assert genus(M2,2)==genus(Ktarget,2)
    g13_note127("GENUS13_READY; local blocks and trace 2-adic genus match explicit Ktarget")

    set_verbosity_level(:Lattice,1)
    g13_note127("GLOBAL_REPRESENTATIVE_STARTED g13 only")
    H = representative(gene[13])
    g13_note127("GLOBAL_REPRESENTATIVE_RETURNED")
    @assert genus(H)==gene[13]
    M,fM = trace_lattice_with_isometry(H)
    Lf = integer_lattice_with_isometry(M,fM)
    G = gram_matrix(M)
    J = isometry(Lf)
    @assert rank(M)==10 && signature_tuple(M)==(8,0,2)
    @assert abs(det(G))==1024 && J^2==-identity_matrix(QQ,10)
    @assert J*G*transpose(J)==G
    @assert all(denominator(J[i,j])==1 for i in 1:10,j in 1:10)
    g13_note127("TRACE_ACTION_VERIFIED even=$(iseven(M)) order=$(order_of_isometry(Lf))")

    checkpoint = (format_version=1,family=127,stage="g13_global_representative",
        source_sha256=hash, gram=G, action=J)
    tmp = g13_mrdi127 * ".$((getpid())).partial.mrdi"
    save(tmp,checkpoint)
    loaded = load(tmp)
    @assert loaded.source_sha256==hash && loaded.gram==G && loaded.action==J
    mv(tmp,g13_mrdi127;force=false)
    g13_note127("CHECKPOINT_SAVED path=$g13_mrdi127")

    g13_note127("TARGET_COMPARISON_STARTED")
    genus_equal = genus(M)==genus(Ktarget)
    g13_note127("TRACE_GENUS_EQUALS_TARGET=$genus_equal")
    exact_isometric = genus_equal && is_isometric(M,Ktarget)
    g13_note127("TRACE_IS_ISOMETRIC_TARGET=$exact_isometric")
    g13_note127("COMPLETED first global representative only; no Hermitian class enumeration or equivariant glue")
    g13_status_write127("COMPLETED")
catch err
    g13_note127("FAILED $(sprint(showerror,err))")
    g13_status_write127("FAILED")
    rethrow()
end
