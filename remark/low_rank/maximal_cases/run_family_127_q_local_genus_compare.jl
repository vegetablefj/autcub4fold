# Bounded local-only comparison of Hermitian genera #13/#14 with the
# explicit primitive A=<4>^2 complement in Q_target and with K0.
# Uses representative(g[2]) for a 2-adic LOCAL genus only; never calls
# representative(g) or genus_representatives for a global Hermitian genus.
# No N-side or Q-side equivariant graph search.
# Run with one Julia thread, external 6 GiB / 180 s hard cap.

using Oscar
using Dates

const cmp_start127 = time()
const cmp_prefix127 = joinpath(@__DIR__,"family_127_q_local_genus_compare")
const cmp_out127 = cmp_prefix127 * ".out"
const cmp_status127 = cmp_prefix127 * ".status.txt"
@assert !isfile(cmp_out127)
@assert !isfile(cmp_status127)

function cmp_note127(msg)
    line = "$(Dates.now()) | $msg | elapsed=$(round(time()-cmp_start127;digits=1)) s"
    println(line)
    flush(stdout)
    open(cmp_out127,"a") do io
        println(io,line)
    end
end
function cmp_status_write127(value)
    open(cmp_status127,"w") do io
        println(io,value)
        println(io,"updated=",Dates.now())
    end
end
function cmp_block127(blocks)
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

try
    cmp_status_write127("RUNNING")
    cmp_note127("START Julia=$VERSION OSCAR=$(pkgversion(Oscar)) threads=$(Threads.nthreads())")
    @assert pkgversion(Oscar)==v"1.8.2" && Threads.nthreads()==1

    U = matrix(QQ,2,2,[0 1; 1 0])
    E8 = 2*change_base_ring(QQ,gram_matrix(root_lattice(:E,8)))
    GQ = cmp_block127([U,matrix(QQ,1,1,[2]),matrix(QQ,1,1,[-2]),E8])
    Q = integer_lattice(;gram=GQ)
    tidx = first(j for j in 2:8 if abs(E8[1,j])==2)
    tsign = E8[1,tidx]==2 ? 1 : -1
    VA = zero_matrix(QQ,2,12)
    VA[1,5] = 1
    VA[2,1] = 2; VA[2,2] = -2
    VA[2,3] = 1; VA[2,4] = 1
    VA[2,5] = -1; VA[2,4+tidx] = 2*tsign
    @assert VA*GQ*transpose(VA)==4*identity_matrix(QQ,2)
    Kcomp = orthogonal_submodule(Q,VA)
    cmp_note127("TARGET_KCOMP_READY rank=$(rank(Kcomp)) det=$(abs(det(gram_matrix(Kcomp))))")

    A = zero_matrix(ZZ,6,6)
    for i in 1:5
        A[i,i]=1; A[i,i+1]=-1
    end
    A[6,5]=1; A[6,6]=1
    G6 = change_base_ring(QQ,2*A*transpose(A))
    C = matrix(QQ,2,2,[1 1; -1 1])
    G4 = zero_matrix(QQ,4,4)
    for i in 1:2,j in 1:2
        G4[i,j+2]=C[i,j]; G4[j+2,i]=C[i,j]
    end
    K0 = integer_lattice(;gram=cmp_block127([G4,G6]))
    target2 = genus(Kcomp,2)
    seed2 = genus(K0,2)
    @assert target2 != seed2
    cmp_note127("TARGET_2ADIC_GENUS_DIFFERS_FROM_K0=true")

    E, _ = cyclotomic_field_as_cm_extension(4;cached=false)
    OE = maximal_order(E)
    DE = different(OE)
    F = base_field(E)
    signs = Dict(real_places(F)[1]=>1)
    dd = fractional_ideal(OE,one(E))
    gene = hermitian_genera(E,5,signs,dd;min_scale=inv(DE),max_scale=DE)
    unique!(gene)
    @assert length(gene)==19
    p2 = prime_decomposition(maximal_order(F),ZZ(2))[1][1]
    cmp_note127("GENERA_READY count=19; taking only local representatives #13/#14")

    for j in (13,14)
        h2 = gene[j][p2]
        cmp_note127("LOCAL_REP_STARTED genus=$j blocks=$(Tuple((scale(h2,i),rank(h2,i),norm(h2,i),det(h2,i)) for i in 1:length(h2)))")
        H2 = representative(h2)
        @assert genus(H2,p2)==h2
        M2,f2 = trace_lattice_with_isometry(H2)
        m2 = genus(M2,2)
        cmp_note127("LOCAL_REP_RETURNED genus=$j trace_even=$(iseven(M2)) det=$(abs(det(gram_matrix(M2)))) target_2adic=$(m2==target2) K0_2adic=$(m2==seed2)")
        Lf2 = integer_lattice_with_isometry(M2,f2)
        cmp_note127("LOCAL_ACTION_VERIFIED genus=$j order=$(order_of_isometry(Lf2))")
    end
    cmp_note127("COMPLETED local comparison only; no global representative or equivariant Q glue")
    cmp_status_write127("COMPLETED")
catch err
    cmp_note127("FAILED $(sprint(showerror,err))")
    cmp_status_write127("FAILED")
    rethrow()
end
