# Bounded exact check of an explicit A=<4>^2 primitive embedding in Q_target.
# This constructs K=A^perp and compares its abstract lattice to
# K0=U+U(2)+D6(2). It then locates the genus of the displayed pure order-4
# J0 on K0 among the 19 local Hermitian symbols. A lattice isometry
# K ~= K0 does NOT by itself extend J0 over the A--K graph in Q.
# No N-side glue and no global Hermitian representative enumeration.
# Run one Julia thread with an external 6 GiB / 180 s hard cap.

using Oscar
using Dates

const exp_start127 = time()
const exp_prefix127 = joinpath(@__DIR__, "family_127_q_explicit_complement")
const exp_out127 = exp_prefix127 * ".out"
const exp_status127 = exp_prefix127 * ".status.txt"
@assert !isfile(exp_out127) "Output already exists: $exp_out127"
@assert !isfile(exp_status127) "Status already exists: $exp_status127"

function exp_note127(msg)
    line = "$(Dates.now()) | $msg | elapsed=$(round(time()-exp_start127;digits=1)) s"
    println(line)
    flush(stdout)
    open(exp_out127,"a") do io
        println(io,line)
    end
end

function exp_status_write127(value)
    open(exp_status127,"w") do io
        println(io,value)
        println(io,"updated=",Dates.now())
    end
end

function exp_block127(blocks)
    n = sum(nrows(X) for X in blocks)
    G = zero_matrix(QQ,n,n)
    k = 0
    for X in blocks
        for i in 1:nrows(X), j in 1:ncols(X)
            G[k+i,k+j] = QQ(X[i,j])
        end
        k += nrows(X)
    end
    return G
end

function exp_D6_action127()
    A = zero_matrix(ZZ,6,6)
    for i in 1:5
        A[i,i] = 1
        A[i,i+1] = -1
    end
    A[6,5] = 1
    A[6,6] = 1
    G6 = change_base_ring(QQ,2*A*transpose(A))
    R = matrix(QQ,2,2,[0 1; -1 0])
    AQ = change_base_ring(QQ,A)
    J6 = AQ*exp_block127([R,R,R])*inv(AQ)
    @assert all(denominator(J6[i,j])==1 for i in 1:6,j in 1:6)
    @assert J6*G6*transpose(J6)==G6
    return G6,J6,R
end

function exp_two_part_integral127(G)
    n = nrows(G)
    count_two = 0
    for v in 0:(2^n-1)
        dual = all(iseven(sum(((v >> (i-1)) & 1)*ZZ(G[i,j])
            for i in 1:n)) for j in 1:n)
        dual || continue
        count_two += 1
        qnum = sum(((v >> (i-1)) & 1)*ZZ(G[i,j])*
            ((v >> (j-1)) & 1) for i in 1:n,j in 1:n)
        mod(qnum,4)==0 || return count_two,false
    end
    return count_two,true
end

try
    exp_status_write127("RUNNING")
    exp_note127("START Julia=$VERSION OSCAR=$(pkgversion(Oscar)) threads=$(Threads.nthreads())")
    pkgversion(Oscar)==v"1.8.2" || error("Pinned to OSCAR 1.8.2")
    Threads.nthreads()==1 || error("Requires one Julia thread")

    U = matrix(QQ,2,2,[0 1; 1 0])
    E8 = 2*change_base_ring(QQ,gram_matrix(root_lattice(:E,8)))
    GQ = exp_block127([U,matrix(QQ,1,1,[2]),matrix(QQ,1,1,[-2]),E8])
    Q = integer_lattice(;gram=GQ)
    @assert signature_tuple(Q)==(10,0,2) && abs(det(GQ))==1024
    tj = findfirst(j -> abs(E8[1,j])==2, 2:8)
    tj === nothing && error("No E8 adjacent root found")
    tidx = (2:8)[tj]
    tsign = E8[1,tidx]==2 ? 1 : -1
    VA = zero_matrix(QQ,2,12)
    VA[1,5] = 1 # r
    VA[2,1] = 2 # 2e
    VA[2,2] = -2 # -2f
    VA[2,3] = 1 # p
    VA[2,4] = 1 # n
    VA[2,5] = -1 # -r
    VA[2,4+tidx] = 2*tsign # 2t, with r.t = 2
    @assert VA*GQ*transpose(VA)==4*identity_matrix(QQ,2)
    # The (p,r) minor is -1, hence A's embedding is primitive.
    @assert abs(VA[1,3]*VA[2,5]-VA[1,5]*VA[2,3])==1
    exp_note127("A_EMBEDDING_VERIFIED Gram=4I2 primitive=true E8_t_index=$tidx E8_t_sign=$tsign")

    exp_note127("ORTHOGONAL_COMPLEMENT_STARTED")
    Kcomp = orthogonal_submodule(Q,VA)
    GKcomp = gram_matrix(Kcomp)
    @assert rank(Kcomp)==10 && signature_tuple(Kcomp)==(8,0,2)
    @assert abs(det(GKcomp))==1024
    @assert all(denominator((4*inv(GKcomp))[i,j])==1 for i in 1:10,j in 1:10)
    @assert rank(change_base_ring(GF(2),GKcomp))==2
    count_two, integral_q_two = exp_two_part_integral127(GKcomp)
    @assert count_two==256 && integral_q_two
    exp_note127("ORTHOGONAL_COMPLEMENT_RETURNED rank=10 signature=(8,2) det=1024 A_K=(Z4)^2(Z2)^6 delta_K=0")

    G6,J6,R = exp_D6_action127()
    C = matrix(QQ,2,2,[1 1; -1 1])
    G4 = zero_matrix(QQ,4,4)
    for i in 1:2,j in 1:2
        G4[i,j+2] = C[i,j]
        G4[j+2,i] = C[i,j]
    end
    J4 = exp_block127([R,R])
    @assert J4*G4*transpose(J4)==G4
    G0 = exp_block127([G4,G6])
    J0 = exp_block127([J4,J6])
    K0 = integer_lattice(;gram=G0)
    @assert signature_tuple(K0)==(8,0,2) && abs(det(G0))==1024
    @assert J0^2 == -identity_matrix(QQ,10)
    @assert J0*G0*transpose(J0)==G0
    exp_note127("K0_J_VERIFIED K0=U+U(2)+D6(2), J0 integral and J0^2=-I")

    exp_note127("ISOMETRY_STARTED Kcomp vs K0")
    same_genus = genus(Kcomp)==genus(K0)
    exp_note127("ISOMETRY_GENUS_EQUAL=$same_genus")
    lattice_iso = same_genus && is_isometric(Kcomp,K0)
    exp_note127("ISOMETRY_RETURNED Kcomp_isometric_K0=$lattice_iso")

    Lf0 = integer_lattice_with_isometry(K0,J0; ambient_representation=false)
    exp_note127("HERMITIAN_STRUCTURE_STARTED for explicit J0 on K0")
    H0 = hermitian_structure(Lf0)
    Hgen0 = genus(H0)
    E = base_field(H0)
    OE = maximal_order(E)
    DE = different(OE)
    realps = real_places(base_field(E))
    @assert length(realps)==1
    signs = Dict(realps[1]=>1)
    detideal = fractional_ideal(OE,one(E))
    gene = hermitian_genera(E,5,signs,detideal;min_scale=inv(DE),max_scale=DE)
    unique!(gene)
    @assert length(gene)==19
    matches = findall(g -> g==Hgen0,gene)
    exp_note127("HERMITIAN_GENUS_MATCH indices=$matches among_19; zero_based=false")
    exp_note127("COMPLETED; abstract K isometry does not assert J0 extends to Q")
    exp_status_write127("COMPLETED")
catch err
    exp_note127("FAILED $(sprint(showerror,err))")
    exp_status_write127("FAILED")
    rethrow()
end
