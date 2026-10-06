# Normalize the saved No. 127 rank-22 witness to the ambient-lattice catalogue's lattice-data
# shape. This is a single constructive witness, not a completed search.

module Maximal127Normalization

using Oscar
using SHA

include(joinpath(@__DIR__, "..", "..", "oscar", "oscar_script.jl"))

export normalize_maximal_127

const SOURCE_RELATIVE_PATH =
    "remark/low_rank/maximal_cases/family_127_g13_full_finite_glue_preflight.json"
const SOURCE_FILE = normpath(joinpath(
    @__DIR__, "..", "low_rank", "maximal_cases",
    "family_127_g13_full_finite_glue_preflight.json",
))
const SOURCE_SHA256 =
    "43f385e222bda664e485d88ea3a8c83981793e4f2fbda2be8df184c29d886567"

function matrix22(rows)
    @assert length(rows) == 22 && all(length(row) == 22 for row in rows)
    M = zero_matrix(QQ, 22, 22)
    for i in 1:22, j in 1:22
        M[i, j] = QQ(rows[i][j])
    end
    return M
end

"""
    normalize_maximal_127()

Read the saved No. 127 full-lattice witness and return `(data, provenance)`.
`data` has the nine lattice-data fields of `lattice_data_for_T_action` in
`oscar_script.jl`. No search multiplicity or group identification is inferred.
The function does not write a file or run an enumeration.
"""
function normalize_maximal_127()
    raw = read(SOURCE_FILE)
    digest = bytes2hex(sha256(raw))
    @assert digest == SOURCE_SHA256
    source = Oscar.JSON.parse(String(raw))
    @assert source["family"] == 127 && source["search_complete"] === false
    witness = source["first_witness"]
    @assert witness["stable_on_discriminant"] === true

    G = matrix22(witness["gram"])
    g = matrix22(witness["g"])
    s = matrix22(witness["s"])
    I22 = identity_matrix(QQ, 22)
    @assert G == transpose(G)
    @assert g^4 == I22 && s^2 == I22 && g * s == s * g
    @assert g * G * transpose(g) == G
    @assert s * G * transpose(s) == G

    L = integer_lattice(; gram=G)
    @assert rank(L) == 22 && signature_tuple(L) == (20, 0, 2)
    @assert abs(det(G)) == 3
    Lambda0 = integer_lattice_with_isometry(
        L, g; ambient_representation=false, check=true,
    )
    m = Int(order_of_isometry(Lambda0))
    @assert m == 4
    @assert trivial_action_on_discriminant(Lambda0)

    symplectic_action = integer_lattice_with_isometry(
        L, s; ambient_representation=false, check=true,
    )
    S = lattice(coinvariant_lattice(symplectic_action))
    T = lattice(invariant_lattice(symplectic_action))
    @assert rank(S) == 8 && signature_tuple(S) == (8, 0, 0)
    @assert rank(T) == 14 && signature_tuple(T) == (12, 0, 2)
    @assert basis_matrix(S) * gram_matrix(ambient_space(L)) *
        transpose(basis_matrix(T)) == zero_matrix(QQ, 8, 14)

    Simg = lattice_in_same_ambient_space(
        Lambda0, basis_matrix(S); check=true,
    )
    Timg = lattice_in_same_ambient_space(
        Lambda0, basis_matrix(T); check=true,
    )
    @assert rank(lattice(Simg)) == 8 && rank(lattice(Timg)) == 14
    Taction = full_rank_model(Timg)
    @assert order_of_isometry(Taction) == m

    pk = embedded_PK_data(Lambda0, Timg, m)
    P = pk.P_lattice
    K = pk.K_lattice
    @assert rank(P) == 10 && signature_tuple(P) == (8, 0, 2)
    @assert rank(K) == 12 && signature_tuple(K) == (12, 0, 0)
    dimension = period_dimension(P, m)
    @assert dimension == 4

    data = (
        order=m,
        dimension=dimension,
        S_in_Lambda0=Simg,
        T_in_Lambda0=Timg,
        T_action=Taction,
        K_in_Lambda0=K,
        P_in_Lambda0=P,
        P_action=pk.P_with_isometry,
        Lambda0=Lambda0,
    )
    provenance = (
        family=127,
        source=SOURCE_RELATIVE_PATH,
        source_sha256=digest,
        source_stage=source["stage"],
        witness_status="constructive_witness",
        search_complete=false,
        direct_H4_conjugacy_to_equation_status="unproved",
        symplectic_involution=s,
    )
    return (data=data, provenance=provenance)
end

end # module Maximal127Normalization
