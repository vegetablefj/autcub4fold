# Two-graph Q-side test for the SAVED global genus-13 K action.
# Starts only from family_127_g13_global_preflight.mrdi (Gram/J); does not
# reconstruct its global Hermitian representative or enumerate classes.
# This tests the two equivariant index-4 graphs A=<4>^2 <-> 2A_K and
# compares resulting Q with Marquand's target. No N-side glue.
# Run one Julia thread, external memory/time guard, no pre-existing outputs.

using Oscar
using Dates
using SHA

const q13_start127 = time()
const q13_prefix127 = joinpath(@__DIR__,"family_127_g13_q_graph_preflight")
const q13_out127 = q13_prefix127 * ".out"
const q13_status127 = q13_prefix127 * ".status.txt"
const q13_mrdi127 = q13_prefix127 * ".mrdi"
const q13_json127 = q13_prefix127 * ".json"
const q13_input127 = joinpath(@__DIR__,"family_127_g13_global_preflight.mrdi")
@assert all(!isfile(p) for p in (q13_out127,q13_status127,q13_mrdi127,q13_json127))
@assert isfile(q13_input127) "Missing saved global K action"

function q13_note127(msg)
    line = "$(Dates.now()) | $msg | elapsed=$(round(time()-q13_start127;digits=1)) s"
    println(line)
    flush(stdout)
    open(q13_out127,"a") do io
        println(io,line)
    end
end
function q13_status_write127(value)
    open(q13_status127,"w") do io
        println(io,value)
        println(io,"updated=",Dates.now())
    end
end
function q13_block127(blocks)
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
function q13_action127(v::Int,J)
    n=nrows(J)
    ans=0
    for j in 1:n
        a=sum(((v>>(i-1))&1)*Int(ZZ(J[i,j])) for i in 1:n)
        ans |= (mod(a,2) << (j-1))
    end
    return ans
end
function q13_normnum127(v::Int,G)
    n=nrows(G)
    return sum(((v>>(i-1))&1)*ZZ(G[i,j])*((v>>(j-1))&1)
        for i in 1:n,j in 1:n)
end
function q13_dualhalf127(v::Int,G)
    n=nrows(G)
    return all(iseven(sum(((v>>(i-1))&1)*ZZ(G[i,j]) for i in 1:n))
        for j in 1:n)
end
function q13_twice_discriminant127(G)
    IG=4*inv(G)
    n=nrows(G)
    @assert all(denominator(IG[i,j])==1 for i in 1:n,j in 1:n)
    generators=Int[]
    for i in 1:n
        v=sum((mod(Int(ZZ(IG[i,j])),2) << (j-1)) for j in 1:n)
        push!(generators,v)
    end
    subgroup=Set{Int}([0])
    for v in generators
        subgroup=Set{Int}(xor(y,t) for y in subgroup for t in (0,v))
    end
    return sort!(collect(subgroup))
end
function q13_graph_basis127(a::Int,b::Int,swap::Bool)
    rows=zero_matrix(ZZ,14,12)
    for i in 1:12
        rows[i,i]=2
    end
    chosen=swap ? (b,a) : (a,b)
    for j in 1:2
        rows[12+j,j]=1
        for i in 1:10
            rows[12+j,2+i]=(chosen[j]>>(i-1))&1
        end
    end
    H=hnf(rows)
    nz=[i for i in 1:nrows(H) if any(H[i,j]!=0 for j in 1:12)]
    @assert length(nz)==12
    B=zero_matrix(QQ,12,12)
    for (i,r) in enumerate(nz),j in 1:12
        B[i,j]=QQ(H[r,j])/2
    end
    @assert abs(det(B))==1//4
    return B
end
function q13_fingerprint127(G,J)
    valid=[v for v in 0:(2^nrows(G)-1) if q13_dualhalf127(v,G)]
    @assert length(valid)==1024
    validset=Set(valid)
    seen=Set{Int}()
    counts=Dict{Tuple{Int,Int},Int}()
    for v in valid
        v in seen && continue
        orbit=Int[]
        w=v
        while !(w in orbit)
            @assert w in validset
            push!(orbit,w)
            w=q13_action127(w,J)
        end
        @assert w==v && length(orbit) in (1,2,4)
        foreach(x->push!(seen,x),orbit)
        qvalue=Int(mod(q13_normnum127(v,G),8))
        @assert all(Int(mod(q13_normnum127(x,G),8))==qvalue for x in orbit)
        key=(length(orbit),qvalue)
        counts[key]=get(counts,key,0)+1
    end
    return counts
end
function q13_matrix_json127(M)
    return "["*join(("["*join((string(Int(ZZ(M[i,j]))) for j in 1:ncols(M)),",")*"]"
        for i in 1:nrows(M)),",")*"]"
end

try
    q13_status_write127("RUNNING")
    hash=bytes2hex(sha256(read(@__FILE__)))
    q13_note127("START Julia=$VERSION OSCAR=$(pkgversion(Oscar)) threads=$(Threads.nthreads()) source_sha256=$hash")
    @assert pkgversion(Oscar)==v"1.8.2" && Threads.nthreads()==1
    saved=load(q13_input127)
    @assert saved.family==127 && saved.stage=="g13_global_representative"
    GK=saved.gram; JK=saved.action
    @assert nrows(GK)==10 && abs(det(GK))==1024
    @assert JK^2==-identity_matrix(QQ,10)
    @assert JK*GK*transpose(JK)==GK
    q13_note127("INPUT_LOADED source_sha256=$(saved.source_sha256) rank10 det1024")

    R=q13_twice_discriminant127(GK)
    @assert length(R)==4 && all(q13_dualhalf127(v,GK) for v in R)
    nonfixed=[v for v in R if v!=0 && q13_action127(v,JK)!=v]
    @assert length(nonfixed)==2
    a=nonfixed[1]; b=q13_action127(a,JK)
    @assert b==nonfixed[2] && q13_action127(b,JK)==a
    qvals=[(v,Int(mod(q13_normnum127(v,GK)÷4,2))) for v in R]
    @assert all(mod(q13_normnum127(v,GK),4)==0 for v in R)
    anti=(Int(mod(q13_normnum127(a,GK)÷4,2))==1 &&
          Int(mod(q13_normnum127(b,GK)÷4,2))==1 &&
          Int(mod(q13_normnum127(xor(a,b),GK)÷4,2))==0)
    q13_note127("R=2A_K masks=$R J_swap=($a,$b) q_mod2=$qvals anti_isometry_to_2A=$anti")
    @assert anti

    GE=4*identity_matrix(QQ,2)
    gE=matrix(QQ,2,2,[0 -1;-1 0])
    G0=q13_block127([GE,GK])
    g0=q13_block127([gE,JK])
    h0=q13_block127([identity_matrix(QQ,2),-identity_matrix(QQ,10)])
    s0=q13_block127([-identity_matrix(QQ,2),identity_matrix(QQ,10)])
    U=matrix(QQ,2,2,[0 1;1 0])
    Qtarget=integer_lattice(;gram=q13_block127([U,matrix(QQ,1,1,[2]),
        matrix(QQ,1,1,[-2]),2*change_base_ring(QQ,gram_matrix(root_lattice(:E,8)))]))
    expected=Dict((1,0)=>8,(1,4)=>24,(2,0)=>60,(2,4)=>52,
        (4,0)=>36,(4,2)=>64,(4,4)=>28,(4,6)=>64)

    records=Any[]
    for swap in (false,true)
        q13_note127("GRAPH_STARTED swap=$swap")
        B=q13_graph_basis127(a,b,swap)
        G=B*G0*transpose(B)
        g=B*g0*inv(B)
        h=B*h0*inv(B)
        s=B*s0*inv(B)
        @assert all(denominator(G[i,j])==1 && denominator(g[i,j])==1 &&
            denominator(h[i,j])==1 && denominator(s[i,j])==1
            for i in 1:12,j in 1:12)
        @assert all(iseven(ZZ(G[i,i])) for i in 1:12)
        @assert g*G*transpose(g)==G && h*G*transpose(h)==G && s*G*transpose(s)==G
        @assert g^2==h && h*s==-identity_matrix(QQ,12) && g*s==s*g
        @assert abs(det(G))==1024 && rank(change_base_ring(GF(2),G))==2
        @assert all(denominator((2*inv(G))[i,j])==1 for i in 1:12,j in 1:12)
        delta1=any(denominator(inv(G)[i,i])==2 for i in 1:12)
        @assert delta1
        fp=q13_fingerprint127(G,g)
        fp_match=fp==expected
        q13_note127("GRAPH_FINITE swap=$swap even=true integral_g_h_s=true A_Q=(Z2)^10 delta_Q=1 fingerprint_match=$fp_match fingerprint=$fp")
        Q=integer_lattice(;gram=G)
        gen=genus(Q)==genus(Qtarget)
        q13_note127("GRAPH_TARGET_GENUS swap=$swap equal=$gen")
        iso=gen && is_isometric(Q,Qtarget)
        q13_note127("GRAPH_TARGET_ISOMETRIC swap=$swap equal=$iso")
        push!(records,(;swap,B,G,g,h,s,delta1,fp_match,target_genus=gen,target_isometric=iso))
    end

    snapshot=(format_version=1,family=127,stage="g13_Q_side_two_graphs",
        source_sha256=hash,input_sha256=bytes2hex(sha256(read(q13_input127))),
        records=Tuple(records))
    tmp=q13_mrdi127*".$((getpid())).partial.mrdi"
    save(tmp,snapshot)
    loaded=load(tmp)
    @assert loaded.source_sha256==hash && length(loaded.records)==2
    @assert all(loaded.records[i].G==records[i].G && loaded.records[i].g==records[i].g for i in 1:2)
    mv(tmp,q13_mrdi127;force=false)
    q13_note127("MRDI_SAVED_RELOADED path=$q13_mrdi127")

    jsrecords=String[]
    for rec in records
        push!(jsrecords,"{\"swap\":"*string(rec.swap)*
            ",\"gram\":"*q13_matrix_json127(rec.G)*
            ",\"g\":"*q13_matrix_json127(rec.g)*
            ",\"h\":"*q13_matrix_json127(rec.h)*
            ",\"s\":"*q13_matrix_json127(rec.s)*"}")
    end
    jsondata="{\"family\":127,\"stage\":\"g13_Q_side_two_graphs\",\"records\":["*
        join(jsrecords,",")*"]}"
    jsontmp=q13_json127*".$((getpid())).partial.json"
    open(jsontmp,"w") do io
        write(io,jsondata)
    end
    @assert filesize(jsontmp)>0
    mv(jsontmp,q13_json127;force=false)
    q13_note127("JSON_SAVED path=$q13_json127")
    q13_note127("COMPLETED two fixed-action Q graphs; no N-side glue or full cubic extension")
    q13_status_write127("COMPLETED")
catch err
    q13_note127("FAILED $(sprint(showerror,err))")
    q13_status_write127("FAILED")
    rethrow()
end
