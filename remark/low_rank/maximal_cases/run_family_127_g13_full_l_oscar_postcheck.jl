# Bounded OSCAR postcheck of the saved full rank-22 No. 127 witness.
# No graph enumeration or genus representatives. External resource limits:
# one Julia thread, MemoryHigh=4G, MemoryMax=6G, MemorySwapMax=0,
# RuntimeMaxSec=300s. All results are written progressively; no overwrites.

using Oscar
using Dates
using SHA

const full_start127 = time()
const full_prefix127 = joinpath(@__DIR__, "family_127_g13_full_l_oscar_postcheck")
const full_out127 = full_prefix127 * ".out"
const full_status127 = full_prefix127 * ".status.txt"
const full_input127 = joinpath(@__DIR__, "family_127_g13_full_finite_glue_preflight.json")
const full_source_sha127 = "43f385e222bda664e485d88ea3a8c83981793e4f2fbda2be8df184c29d886567"
@assert !isfile(full_out127) && !isfile(full_status127)

function full_note127(msg)
    line = "$(Dates.now()) | $msg | elapsed=$(round(time()-full_start127;digits=1)) s"
    println(line)
    flush(stdout)
    open(full_out127, "a") do io
        println(io, line)
    end
end
function full_status_write127(status)
    open(full_status127, "w") do io
        println(io, status)
        println(io, "updated=", Dates.now())
    end
end
function full_matrix127(rows)
    n = length(rows)
    @assert all(length(row) == n for row in rows)
    m = zero_matrix(QQ, n, n)
    for i in 1:n, j in 1:n
        m[i,j] = QQ(rows[i][j])
    end
    m
end
function full_block127(blocks)
    n = sum(nrows(b) for b in blocks)
    m = zero_matrix(QQ, n, n)
    k = 0
    for b in blocks
        for i in 1:nrows(b), j in 1:ncols(b)
            m[k+i,k+j] = b[i,j]
        end
        k += nrows(b)
    end
    m
end
function full_sector127(projector, gram)
    r = rank(projector)
    basis = zero_matrix(QQ, 0, ncols(projector))
    for i in 1:nrows(projector)
        row = zero_matrix(QQ, 1, ncols(projector))
        for j in 1:ncols(projector)
            row[1,j] = 8 * projector[i,j]
        end
        newbasis = vcat(basis, row)
        if rank(newbasis) > nrows(basis)
            basis = newbasis
        end
        nrows(basis) == r && break
    end
    @assert nrows(basis) == r
    @assert all(denominator(basis[i,j]) == 1 for i in 1:r, j in 1:ncols(basis))
    sector = integer_lattice(;gram=basis * gram * transpose(basis))
    @assert rank(sector) == r
    return (r, signature_tuple(sector))
end

try
    full_status_write127("RUNNING")
    full_note127("START Julia=$VERSION OSCAR=$(pkgversion(Oscar)) threads=$(Threads.nthreads())")
    @assert pkgversion(Oscar) == v"1.8.2" && Threads.nthreads() == 1
    raw = read(full_input127)
    @assert bytes2hex(sha256(raw)) == full_source_sha127
    data = Oscar.JSON.parse(String(raw))
    @assert data["family"] == 127 && data["search_complete"] == false
    w = data["first_witness"]
    gram = full_matrix127(w["gram"])
    g = full_matrix127(w["g"])
    s = full_matrix127(w["s"])
    ii = identity_matrix(QQ, 22)
    g2 = g^2
    @assert gram == transpose(gram) && abs(det(gram)) == 3
    @assert g^4 == ii && g2 != ii && s^2 == ii && g*s == s*g
    @assert g*gram*transpose(g) == gram && s*gram*transpose(s) == gram
    L = integer_lattice(;gram=gram)
    @assert rank(L) == 22 && signature_tuple(L) == (20,0,2) && iseven(L)
    full_note127("L_LOADED sha256=$full_source_sha127 rank22_sig(20,2)_det3=true")

    # Independent No. 127 joint character and eigenspace-signature check.
    projections = Dict(
        "Phi1" => (ii+g+g2+g^3)/4,
        "Phi2" => (ii-g+g2-g^3)/4,
        "Phi4" => (ii-g2)/2,
    )
    ps = Dict("T" => (ii+s)/2, "S" => (ii-s)/2)
    expected = Dict(
        ("T","Phi1") => (1,(1,0,0)),
        ("T","Phi2") => (3,(3,0,0)),
        ("T","Phi4") => (10,(8,0,2)),
        ("S","Phi1") => (1,(1,0,0)),
        ("S","Phi2") => (1,(1,0,0)),
        ("S","Phi4") => (6,(6,0,0)),
    )
    for side in ("T","S"), factor in ("Phi1","Phi2","Phi4")
        got = full_sector127(ps[side]*projections[factor], gram)
        @assert got == expected[(side,factor)]
        full_note127("CHARACTER side=$side factor=$factor rank=$(got[1]) signature=$(got[2])")
    end
    full_note127("NO127_FULL_CHARACTER Phi1^2_Phi2^4_Phi4^8=true; S/T characters and signatures=true")

    sf = integer_lattice_with_isometry(L,s;ambient_representation=false)
    full_note127("S_T_EIGENLATTICES_STARTED")
    S = lattice(coinvariant_lattice(sf))
    T = lattice(invariant_lattice(sf))
    @assert rank(S) == 8 && signature_tuple(S) == (8,0,0) && abs(det(gram_matrix(S))) == 256
    @assert rank(T) == 14 && signature_tuple(T) == (12,0,2) && abs(det(gram_matrix(T))) == 768
    full_note127("S_T_EIGENLATTICES_RETURNED S_rank8_det256 T_rank14_det768")

    E8 = change_base_ring(QQ,gram_matrix(root_lattice(:E,8)))
    U = matrix(QQ,2,2,[0 1; 1 0])
    A2 = change_base_ring(QQ,gram_matrix(root_lattice(:A,2)))
    S_target = integer_lattice(;gram=2*E8)
    L_target = integer_lattice(;gram=full_block127([E8,E8,U,U,A2]))
    include(joinpath(@__DIR__,"input.jl"))
    T_target = maximal_c2_input.T
    @assert rank(L_target)==22 && signature_tuple(L_target)==(20,0,2) && abs(det(gram_matrix(L_target)))==3
    @assert rank(T_target)==14 && signature_tuple(T_target)==(12,0,2) && abs(det(gram_matrix(T_target)))==768
    full_note127("STANDARD_TARGETS_READY")

    for (name, source, target) in (("S_E8_2",S,S_target),
                                   ("T_ORIGINAL",T,T_target),
                                   ("L_CUBIC_PRIMITIVE",L,L_target))
        samegenus = genus(source)==genus(target)
        full_note127("$(name)_GENUS_EQUAL=$samegenus")
        @assert samegenus
    end
    # Nikulin's uniqueness criterion for an even indefinite lattice applies
    # to T (rank 14, |A|=2^8*3, hence l(A)<=8) and L (rank 22, |A|=3).
    full_note127("T_ORIGINAL_ISOMETRIC_BY_INDEFINITE_GENUS_UNIQUENESS=true")
    full_note127("L_CUBIC_PRIMITIVE_ISOMETRIC_BY_INDEFINITE_GENUS_UNIQUENESS=true")
    for (name, source, target) in (("S_E8_2",S,S_target),
                                   ("L_CUBIC_PRIMITIVE",L,L_target))
        full_note127("$(name)_ISOMETRY_STARTED")
        isometric = is_isometric(source,target)
        full_note127("$(name)_ISOMETRIC=$isometric")
        @assert isometric
    end
    full_note127("COMPLETED one saved witness only; no finite-glue uniqueness or geometric conjugacy")
    full_status_write127("COMPLETED")
catch err
    full_note127("FAILED $(sprint(showerror,err))")
    full_status_write127("FAILED")
    rethrow()
end
