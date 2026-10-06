# One bounded test of the saved full-L witness's symplectic saturation.
# Computes |ker(O(Kroot)->O(q_Kroot))| for positive rank-12
# Kroot = (ker Phi4(g|L^s))^perp_L.  This is one witness, not a full class scan.
# Use a foreground systemd-run --wait --pipe service, one Julia thread,
# MemoryHigh=4G, MemoryMax=6G, MemorySwapMax=0, RuntimeMaxSec=300s.
# A timeout or OOM is inconclusive and must not trigger an automatic retry.

using Oscar
using Dates
using SHA

const sat_start127=time()
const sat_prefix127=joinpath(@__DIR__,"family_127_g13_saturation_preflight")
const sat_out127=sat_prefix127*".out"
const sat_status127=sat_prefix127*".status.txt"
const sat_input127=joinpath(@__DIR__,"family_127_g13_full_finite_glue_preflight.json")
const sat_input_sha127="43f385e222bda664e485d88ea3a8c83981793e4f2fbda2be8df184c29d886567"
@assert !isfile(sat_out127) && !isfile(sat_status127)

function sat_note127(msg)
    line="$(Dates.now()) | $msg | elapsed=$(round(time()-sat_start127;digits=1)) s"
    println(line)
    flush(stdout)
    open(sat_out127,"a") do io
        println(io,line)
    end
end
function sat_status_write127(status)
    open(sat_status127,"w") do io
        println(io,status)
        println(io,"updated=",Dates.now())
    end
end
function sat_matrix127(rows)
    n=length(rows)
    @assert all(length(row)==n for row in rows)
    m=zero_matrix(QQ,n,n)
    for i in 1:n,j in 1:n
        m[i,j]=QQ(rows[i][j])
    end
    m
end
function sat_guard127()
    @assert Sys.islinux() && Threads.nthreads()==1
    line=only(filter(entry->startswith(entry,"0::"),readlines("/proc/self/cgroup")))
    relative=replace(split(line,':';limit=3)[3],r"^/+"=>"")
    directory=joinpath("/sys/fs/cgroup",relative)
    maxbytes=parse(Int,strip(read(joinpath(directory,"memory.max"),String)))
    highbytes=parse(Int,strip(read(joinpath(directory,"memory.high"),String)))
    swapbytes=strip(read(joinpath(directory,"memory.swap.max"),String))
    @assert maxbytes<=6*1024^3 && highbytes<=4*1024^3 && swapbytes=="0"
    return (highbytes,maxbytes,swapbytes)
end

try
    sat_status_write127("RUNNING")
    sat_note127("START Julia=$VERSION OSCAR=$(pkgversion(Oscar)) threads=$(Threads.nthreads())")
    @assert pkgversion(Oscar)==v"1.8.2"
    guard=sat_guard127()
    sat_note127("CGROUP_GUARD high=$(guard[1]) max=$(guard[2]) swap=$(guard[3])")
    raw=read(sat_input127)
    @assert bytes2hex(sha256(raw))==sat_input_sha127
    data=Oscar.JSON.parse(String(raw))
    @assert data["family"]==127 && data["search_complete"]==false
    w=data["first_witness"]
    gram=sat_matrix127(w["gram"])
    g=sat_matrix127(w["g"])
    s=sat_matrix127(w["s"])
    @assert g^4==identity_matrix(QQ,22) && s^2==identity_matrix(QQ,22)
    @assert g*s==s*g && g*gram*transpose(g)==gram && s*gram*transpose(s)==gram
    L=integer_lattice(;gram=gram)
    sf=integer_lattice_with_isometry(L,s;ambient_representation=false)
    S=lattice(coinvariant_lattice(sf))
    T=lattice(invariant_lattice(sf))
    @assert rank(S)==8 && abs(det(gram_matrix(S)))==256
    @assert rank(T)==14 && abs(det(gram_matrix(T)))==768
    B=basis_matrix(T)
    gT=B*g*gram*transpose(B)*inv(gram_matrix(T))
    @assert all(denominator(gT[i,j])==1 for i in 1:14,j in 1:14)
    @assert gT*B==B*g
    Tf=integer_lattice_with_isometry(T,gT;ambient_representation=false)
    P=lattice(kernel_lattice(Tf,4))
    K=orthogonal_submodule(L,basis_matrix(P))
    @assert rank(P)==10 && signature_tuple(P)==(8,0,2)
    @assert rank(K)==12 && signature_tuple(K)==(12,0,0)
    Gk=gram_matrix(K)
    dK=abs(det(Gk))
    ed=elementary_divisors(discriminant_group(K))
    sat_note127("KROOT_READY rank12 positive det=$dK elementary_divisors=$ed")

    # s fixes P pointwise and gives a known nonidentity element of tilde O(K).
    C=basis_matrix(K)
    sk=C*s*gram*transpose(C)*inv(Gk)
    idk=identity_matrix(QQ,12)
    @assert all(denominator(sk[i,j])==1 for i in 1:12,j in 1:12)
    @assert sk*C==C*s && sk^2==idk && sk!=idk
    @assert all(denominator(x)==1 for x in inv(Gk)*(sk-idk))
    sat_note127("KNOWN_STABLE_INVOLUTION_ON_K=true; kernel_order_at_least_2")

    sat_note127("ORTHOGONAL_GROUP_STARTED")
    Ok=orthogonal_group(K)
    ordOk=order(Ok)
    sat_note127("ORTHOGONAL_GROUP_ORDER=$ordOk")
    if ordOk==2
        sat_note127("DISCRIMINANT_KERNEL_ORDER=2 by known stable involution and |O(K)|=2")
        sat_note127("SYMPLECTIC_SATURATION=true compared with |tildeO(E8(2))|=2")
    else
        sat_note127("DISCRIMINANT_IMAGE_STARTED")
        img,_=image_in_Oq(K)
        ordImg=order(img)
        ordKer=divexact(ordOk,ordImg)
        sat_note127("DISCRIMINANT_IMAGE_ORDER=$ordImg")
        sat_note127("DISCRIMINANT_KERNEL_ORDER=$ordKer")
        @assert ordKer>=2
        sat_note127("SYMPLECTIC_SATURATION=$(ordKer==2) compared with |tildeO(E8(2))|=2")
    end
    sat_note127("COMPLETED single saved witness only")
    sat_status_write127("COMPLETED")
catch err
    sat_note127("FAILED $(sprint(showerror,err))")
    sat_status_write127("FAILED")
    rethrow()
end
