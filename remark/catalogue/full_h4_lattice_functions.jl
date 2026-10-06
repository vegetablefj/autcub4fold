# Recover the full odd cubic-fourfold cohomology lattice and its generic
# period/algebraic sublattices from embedded primitive-lattice data.
using Oscar

function _c4f_require(condition, message)
    condition || throw(ArgumentError(message))
end

function _c4f_integer(x)
    q = QQ(x)
    _c4f_require(denominator(q) == 1, "Expected an integral coordinate")
    return numerator(q)
end

function _c4f_glue_vector(G, given)
    n = nrows(G)
    if given === nothing
        # A nonzero row of 3G^(-1) represents the order-three class.
        candidates = 3 * inv(G)
        for i in 1:n
            row = candidates[i:i, :]
            if any(mod(_c4f_integer(row[1, j]), 3) != 0 for j in 1:n)
                return row
            end
        end
        error("No nonzero order-three discriminant class was found")
    end
    if given isa AbstractVector
        _c4f_require(length(given) == n, "Glue vector has the wrong length")
        return matrix(QQ, 1, n, [QQ(x) for x in given])
    end
    row = change_base_ring(QQ, given)
    _c4f_require(nrows(row) == 1 && ncols(row) == n,
                 "Glue vector must be one row in the Lambda0 basis")
    return row
end

"""
    cubic_fourfold_full_h4(L0; glue_vector=nothing)

Construct the odd unimodular `H4` from the cubic primitive lattice `L0`.
The optional integral `glue_vector` is expressed in the basis of `L0`;
`glue_vector/3` must generate its discriminant group. In the returned
`H4` basis `(w, L0 basis)`, `w = (h2 + glue_vector)/3`.
"""
function cubic_fourfold_full_h4(L0::ZZLat; glue_vector=nothing)
    n = rank(L0)
    G = change_base_ring(QQ, gram_matrix(L0))
    _c4f_require(n == 22 && nrows(G) == n && ncols(G) == n,
                 "L0 must have rank 22")
    _c4f_require(iseven(L0) && det(G) == 3 &&
                 signature_tuple(L0) == (20, 0, 2),
                 "L0 is not a cubic-fourfold primitive lattice")

    v = _c4f_glue_vector(G, glue_vector)
    for j in 1:n
        _c4f_integer(v[1, j])
    end
    _c4f_require(any(mod(_c4f_integer(v[1, j]), 3) != 0 for j in 1:n),
                 "glue_vector/3 is trivial in the discriminant group")
    vG = v * G
    _c4f_require(all(mod(_c4f_integer(vG[1, j]), 3) == 0 for j in 1:n),
                 "glue_vector/3 is not in the dual lattice")
    vnorm = _c4f_integer((vG * transpose(v))[1, 1])
    _c4f_require(mod(vnorm, 18) == 6,
                 "The order-three class has the wrong quadratic value")

    GH = zero_matrix(QQ, n + 1, n + 1)
    GH[1, 1] = QQ(3 + vnorm) / 9
    for i in 1:n
        GH[1, i + 1] = vG[1, i] / 3
        GH[i + 1, 1] = vG[1, i] / 3
        for j in 1:n
            GH[i + 1, j + 1] = G[i, j]
        end
    end
    H4 = integer_lattice(; gram=GH)
    h2 = zero_matrix(QQ, 1, n + 1)
    h2[1, 1] = 3
    for j in 1:n
        h2[1, j + 1] = -v[1, j]
    end
    L0rows = zero_matrix(QQ, n, n + 1)
    for i in 1:n
        L0rows[i, i + 1] = 1
    end
    L0inH4 = lattice_in_same_ambient_space(H4, L0rows)
    direct_sum = lattice_in_same_ambient_space(H4, vcat(h2, L0rows))
    hpair = h2 * GH
    _c4f_require(is_integral(H4) && !iseven(H4) && det(GH) == 1 &&
                 signature_tuple(H4) == (21, 0, 2),
                 "The constructed H4 is not odd unimodular of signature (21,2)")
    _c4f_require((h2 * GH * transpose(h2))[1, 1] == 3 &&
                 hpair[1, 1] == 1 && all(hpair[1, j] == 0 for j in 2:(n + 1)),
                 "h2 is not primitive of square 3 with complement L0")
    _c4f_require(all(mod(_c4f_integer(GH[i, i] - hpair[1, i]), 2) == 0
                     for i in 1:(n + 1)),
                 "h2 is not characteristic")
    _c4f_require(index(H4, direct_sum) == 3 &&
                 orthogonal_submodule(H4, h2) == L0inH4 &&
                 gram_matrix(L0inH4) == G,
                 "The index-three embedding of L0 and h2 failed")
    return (H4=H4, h2=h2, L0_in_H4=L0inH4,
            glue_vector=v, gram=GH)
end

function _c4f_lattice_coordinates(L0::ZZLat, N::ZZLat)
    BL = change_base_ring(QQ, basis_matrix(L0))
    BN = change_base_ring(QQ, basis_matrix(N))
    _c4f_require(ncols(BN) == ncols(BL) &&
                 gram_matrix(ambient_space(N)) ==
                     gram_matrix(ambient_space(L0)),
                 "Lattice bases do not share the same ambient quadratic space")
    # L0 may have a rectangular basis in a larger rational ambient space.
    # The nondegenerate Gram recovers exact coordinates in its row span.
    Gambient = change_base_ring(QQ, gram_matrix(ambient_space(L0)))
    C = BN * Gambient * transpose(BL) *
        inv(change_base_ring(QQ, gram_matrix(L0)))
    _c4f_require(C * BL == BN,
                 "Sublattice is outside the rational span of L0")
    for i in 1:nrows(C), j in 1:ncols(C)
        _c4f_integer(C[i, j])
    end
    _c4f_require(C * gram_matrix(L0) * transpose(C) == gram_matrix(N),
                 "Sublattice coordinates do not match the L0 Gram matrix")
    return C
end

"""
    cubic_fourfold_generic_lattices(L0, P, K; glue_vector=nothing)

For primitive orthogonal complements `P,K` embedded in `L0`, return the
generic algebraic lattice `A = P^perp` inside full `H4`, the usual
transcendental lattice `P`, and the primitive closure of `<h2> + P`.
"""
function cubic_fourfold_generic_lattices(L0::ZZLat, P::ZZLat, K::ZZLat;
                                         glue_vector=nothing)
    BP = _c4f_lattice_coordinates(L0, P)
    BK = _c4f_lattice_coordinates(L0, K)
    _c4f_require(rank(P) + rank(K) == 22 &&
                 iszero(BP * gram_matrix(L0) * transpose(BK)),
                 "P and K do not have complementary orthogonal rational spans")
    P0 = lattice_in_same_ambient_space(L0, basis_matrix(P))
    K0 = lattice_in_same_ambient_space(L0, basis_matrix(K))
    _c4f_require((rank(P0) == 0 || is_primitive(L0, P0)) &&
                 (rank(K0) == 0 || is_primitive(L0, K0)) &&
                 orthogonal_submodule(L0, basis_matrix(P0)) == K0,
                 "P and K are not primitive orthogonal complements in L0")

    full = cubic_fourfold_full_h4(L0; glue_vector=glue_vector)
    H4, h2 = full.H4, full.h2
    BP23 = hcat(zero_matrix(QQ, rank(P), 1), BP)
    BK23 = hcat(zero_matrix(QQ, rank(K), 1), BK)
    N_A = lattice_in_same_ambient_space(H4, vcat(h2, BK23))
    N_P = lattice_in_same_ambient_space(H4, vcat(h2, BP23))
    A = primitive_closure(H4, N_A)
    P_with_h2 = primitive_closure(H4, N_P)
    _c4f_require(A == orthogonal_submodule(H4, BP23) &&
                 P_with_h2 == orthogonal_submodule(H4, BK23),
                 "Primitive closures and orthogonal complements disagree")
    j_A, j_P = index(A, N_A), index(P_with_h2, N_P)
    _c4f_require(j_A in (1, 3) && j_P in (1, 3) && j_A * j_P == 3 &&
                 j_A^2 * abs(det(gram_matrix(P))) ==
                     3 * abs(det(gram_matrix(K))) &&
                 j_P^2 * abs(det(gram_matrix(K))) ==
                     3 * abs(det(gram_matrix(P))),
                 "Index-three gluing or determinant check failed")
    return merge(full, (P=P, K=K, A=A, P_with_h2=P_with_h2,
                        algebraic_index=j_A, period_plus_h2_index=j_P))
end
