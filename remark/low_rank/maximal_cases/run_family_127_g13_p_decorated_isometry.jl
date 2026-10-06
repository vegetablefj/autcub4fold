# Exact, bounded comparison of the saved full-L q-fixed lattice with the
# geometric Marquand plane-class lattice.  No action or genus enumeration.
# The installed Hecke multi-form isometry context permits a nonsymmetric
# second form, which encodes the order-four action exactly.

using Oscar
using Dates
using SHA

const start127p = time()
const here127p = @__DIR__
const input127p = joinpath(here127p, "family_127_g13_full_q_fixed_preflight.json")
const output127p = joinpath(here127p, "family_127_g13_p_decorated_isometry.out")
const status127p = joinpath(here127p, "family_127_g13_p_decorated_isometry.status.txt")
const certificate127p = joinpath(here127p, "family_127_g13_p_decorated_isometry.json")
@assert isfile(input127p)
@assert !isfile(output127p) && !isfile(status127p) && !isfile(certificate127p)

function note127p(message)
    line = "$(Dates.now()) | $message | elapsed=$(round(time()-start127p; digits=1)) s"
    println(line)
    flush(stdout)
    open(output127p, "a") do io
        println(io, line)
    end
end
function status_write127p(message)
    open(status127p, "w") do io
        println(io, message)
        println(io, "updated=", Dates.now())
    end
end
function rows127p(data)
    nr = length(data)
    nc = length(data[1])
    @assert all(length(row) == nc for row in data)
    m = zero_matrix(ZZ, nr, nc)
    for i in 1:nr, j in 1:nc
        m[i,j] = ZZ(data[i][j])
    end
    return m
end
function vector127p(data)
    m = zero_matrix(ZZ, 1, length(data))
    for i in eachindex(data)
        m[1,i] = ZZ(data[i])
    end
    return m
end
function forms127p(G, A, v)
    @assert nrows(G) == 10 && ncols(G) == 10
    @assert A * G * transpose(A) == G
    @assert v * A == v
    F = (G * transpose(v)) * (v * G)
    B = A * G  # intentionally nonsymmetric: exact A-intertwining
    return ZZMatrix[G, B, F]
end
function reduced_forms127p(forms)
    Gred, T = lll_gram_with_transform(forms[1])
    @assert T * forms[1] * transpose(T) == Gred
    return ZZMatrix[T * F * transpose(T) for F in forms], T
end
function exact_iso127p(source_forms, target_forms)
    source_reduced, Ts = reduced_forms127p(source_forms)
    target_reduced, Tt = reduced_forms127p(target_forms)
    fl, cs, ct = Hecke._try_iso_setup_small(source_reduced, target_reduced)
    if fl
        note127p("Multi-form small-integer context initialized")
    else
        note127p("Multi-form fallback context initializing")
        cs, ct = Hecke._iso_setup(source_reduced, target_reduced)
    end
    exists, U0 = Hecke.isometry(cs, ct)
    exists || return false, zero_matrix(QQ, 0, 0)
    Ured = matrix(ZZ, U0)
    U = inv(Ts) * Ured * Tt
    @assert all(denominator(U[i,j]) == 1 for i in 1:nrows(U), j in 1:ncols(U))
    @assert abs(det(U)) == 1
    @assert all(U * target_forms[i] * transpose(U) == source_forms[i]
                for i in eachindex(source_forms))
    return true, U
end

try
    status_write127p("RUNNING")
    note127p("START Julia=$VERSION OSCAR=$(pkgversion(Oscar)) threads=$(Threads.nthreads())")
    @assert pkgversion(Oscar) == v"1.8.2" && Threads.nthreads() == 1
    raw = read(input127p)
    source_hash = bytes2hex(sha256(raw))
    data = Oscar.JSON.parse(String(raw))
    @assert data["family"] == 127 && data["stage"] == "q_fixed_integer_preflight"
    Gw = rows127p(data["witness_gram"])
    Aw = rows127p(data["witness_g_row_action"])
    vw = vector127p(data["witness_projected_plane"])
    Gg = rows127p(data["geometric_gram"])
    Ag_push = rows127p(data["geometric_g_pushforward_row_action"])
    vg = vector127p(data["geometric_projected_plane"])
    @assert det(Gw) == det(Gg) == 3072
    @assert (vw * Gw * transpose(vw))[1,1] == 24
    @assert (vg * Gg * transpose(vg))[1,1] == 24
    note127p("Loaded exact rank-10 lattices and norm-24 projected plane classes; source_sha256=$source_hash")
    witness_forms = forms127p(Gw, Aw, vw)
    found = false
    convention = "none"
    certificate = zero_matrix(QQ, 0, 0)
    for (label, Ag) in (("geometric_pushforward", Ag_push),
                        ("cohomological_pullback_inverse", inv(Ag_push)))
        note127p("START multi-form exact isometry, convention=$label")
        geometry_forms = forms127p(Gg, Ag, vg)
        exists, T = exact_iso127p(witness_forms, geometry_forms)
        note127p("DONE multi-form exact isometry, convention=$label, exists=$exists")
        if !exists
            continue
        end
        @assert Aw * T == T * Ag
        @assert T * Gg * transpose(T) == Gw
        if vw * T == -vg
            T = -T
        end
        @assert vw * T == vg
        found = true
        convention = label
        certificate = T
        break
    end
    if found
        cert_rows = [[Int(certificate[i,j]) for j in 1:10] for i in 1:10]
        result = Dict(
            "family" => 127,
            "source_sha256" => source_hash,
            "convention" => convention,
            "isometry_witness_to_geometry_row_coordinates" => cert_rows,
            "checks" => Dict("integral_unimodular" => true,
                             "gram_isometry" => true,
                             "action_intertwining" => true,
                             "projected_plane_preserved" => true),
        )
        open(certificate127p, "w") do io
            Oscar.JSON.print(io, result)
            println(io)
        end
        note127p("CERTIFIED exact integral Gram/action/plane isometry; convention=$convention")
    else
        note127p("NO decorated isometry found for either action convention")
    end
    status_write127p("COMPLETED")
catch err
    note127p("FAILED $(sprint(showerror, err))")
    status_write127p("FAILED")
    rethrow()
end
