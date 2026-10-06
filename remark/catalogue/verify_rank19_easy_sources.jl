# Verify the rank-19 lattice inputs and the generic full-group actions that
# follow without another isometry enumeration.  This script does not write.

using Oscar

const r19_here = @__DIR__
const r19_oscar = normpath(joinpath(r19_here, "..", "..", "oscar"))

# The numbered Koike/Laza--Zheng reference list is kept separately from the
# 29 inputs of the ambient-lattice catalogue: its rank-19 entries #8 and #13 were omitted
# from that search because their generic indices already meet the bound.
function r19_reference_gram(path, label)
    lines = readlines(path)
    mark = findall(==("#$label"), strip.(lines))
    length(mark) == 1 || error("Reference label #$label is not unique")
    gram_line = strip(lines[only(mark) + 1])
    startswith(gram_line, "matrix(ZZ, 19, 19, [") ||
        error("Unexpected reference format at #$label")
    return Core.eval(@__MODULE__, Meta.parse(gram_line))
end

include(joinpath(r19_oscar, "input.jl"))
length(cases) == 29 || error("The OSCAR input order changed")

const r19_s11_gram = r19_reference_gram(joinpath(r19_oscar, "list_S.txt"), 8)
const r19_s20_gram = r19_reference_gram(joinpath(r19_oscar, "list_S.txt"), 13)
const r19_t11_gram = matrix(ZZ, 3, 3, [
    20, 0, 0,
     0,-2,-1,
     0,-1,-2,
])
const r19_t20_gram = matrix(ZZ, 3, 3, [
    -16,-8, 0,
     -8,-16,0,
      0, 0, 6,
])

function r19_smith_diagonal(G)
    nrows(G) == ncols(G) == 3 || error("Expected a ternary Gram matrix")
    d1 = gcd([abs(G[i,j]) for i in 1:3 for j in 1:3]...)
    minors = ZZRingElem[]
    for i in 1:2, j in (i+1):3, k in 1:2, l in (k+1):3
        push!(minors, abs(G[i,k]*G[j,l] - G[i,l]*G[j,k]))
    end
    d12 = gcd(minors...)
    d3 = abs(det(G))
    d12 % d1 == 0 && d3 % d12 == 0 || error("Invalid Smith divisibility")
    return (Int(d1), Int(div(d12,d1)), Int(div(d3,d12)))
end

function r19_dual_norm(G, v)
    V = matrix(QQ, 1, 3, v)
    return (V*inv(change_base_ring(QQ,G))*transpose(V))[1,1]
end

function r19_check_form11()
    G = r19_t11_gram
    T = integer_lattice(; gram=G)
    @assert rank(T) == 3 && signature_tuple(T) == (1,0,2)
    @assert iseven(T) && abs(det(G)) == 60
    @assert r19_smith_diagonal(G) == (1,1,60)
    # 2-part: order four, norm 5/4; the 4_5^{-1} symbol.
    @assert r19_dual_norm(G,[5,0,0]) == QQ(5//4)
    # 3-part: norm -2/3 has square-class + over F_3.
    @assert r19_dual_norm(G,[0,1,0]) == QQ(-2//3)
    # 5-part: norm 4/5 has square-class + over F_5.
    @assert r19_dual_norm(G,[4,0,0]) == QQ(4//5)
    @assert abs(det(r19_s11_gram)) == 180
    @assert abs(det(r19_s11_gram))*abs(det(G)) == 3*60^2
    # Here q_S = -(q_E6 + q_T) at every prime, with q_E6 = <4/3>.
    # The indicated index is for S + T inside Lambda_0.  Existence of the
    # geometric component still comes from Koike/Laza--Zheng.
    return T
end

function r19_check_form20()
    G = r19_t20_gram
    T = integer_lattice(; gram=G)
    @assert rank(T) == 3 && signature_tuple(T) == (1,0,2)
    @assert iseven(T) && abs(det(G)) == 1152
    @assert r19_smith_diagonal(G) == (2,24,24)
    # The order-two part of <6> has norm 3/2 = 7/2 modulo 2Z,
    # giving 2_7^{+1}.
    @assert r19_dual_norm(G,[0,0,3]) == QQ(3//2)
    # The 2-primary part of -8 A_2 has scale-eight even bilinear matrix
    # [-6 3; 3 -6], with determinant 27 = 3 mod 8: 8_II^{-2}.
    @assert r19_dual_norm(G,[3,0,0]) == QQ(-3//4)
    @assert r19_dual_norm(G,[0,3,0]) == QQ(-3//4)
    @assert r19_dual_norm(G,[3,3,0]) == QQ(-3//4)
    @assert (-6)*(-6) - 3*3 == 27 && 27 % 8 == 3
    # Two order-three generators have nonsquare coefficients 2 and 2;
    # their product is square, yielding 3^{+2}.
    @assert r19_dual_norm(G,[8,0,0]) == QQ(-16//3)
    @assert r19_dual_norm(G,[0,0,2]) == QQ(2//3)
    # In q_T + q_E6, the order-three element (8 e_1^*, u_E6) has
    # norm -16/3 + 4/3 = -4 and is isotropic.  Its orthogonal quotient
    # retains the independent <2/3> line, whose negative is the + type
    # of q_S at 3.  The 2-primary form is directly anti-isometric to q_S.
    @assert r19_dual_norm(G,[8,0,0]) + QQ(4//3) == -4
    @assert abs(det(r19_s20_gram)) == 384
    @assert abs(det(r19_s20_gram))*abs(det(G)) == 3*384^2
    return T
end

@assert r19_s11_gram == gram_matrix(cases[2][1])
@assert signature_tuple(integer_lattice(;gram=r19_s11_gram)) == (19,0,0)
@assert signature_tuple(integer_lattice(;gram=r19_s20_gram)) == (19,0,0)

T11, T20 = r19_check_form11(), r19_check_form20()

const r19_T = Dict(9=>cases[1][2], 11=>T11, 16=>cases[5][2],
                   19=>cases[7][2], 20=>T20)
const r19_S = Dict(9=>cases[1][1],
                   11=>integer_lattice(;gram=r19_s11_gram),
                   16=>cases[5][1], 19=>cases[7][1],
                   20=>integer_lattice(;gram=r19_s20_gram))
const r19_expected_det_T = Dict(9=>54, 11=>60, 16=>100,
                                19=>108, 20=>1152)

for n in (9,11,16,19,20)
    S,T = r19_S[n],r19_T[n]
    @assert rank(S) == 19 && signature_tuple(S) == (19,0,0)
    @assert rank(T) == 3 && signature_tuple(T) == (1,0,2)
    @assert abs(det(gram_matrix(T))) == r19_expected_det_T[n]
    idx = n == 20 ? 1 : 2
    if idx == 2
        @assert abs(det(gram_matrix(S))) ==
            3*abs(det(gram_matrix(T)))
    end
    M = idx == 1 ? identity_matrix(ZZ,3) : -identity_matrix(ZZ,3)
    @assert M*gram_matrix(T)*transpose(M) == gram_matrix(T)
    Tf = integer_lattice_with_isometry(T,change_base_ring(QQ,M);
        ambient_representation=false,check=true)
    @assert order_of_isometry(Tf) == idx
    action_label = idx == 1 ? "I" : "-I"
    println("No. $n: |det S|=$(abs(det(gram_matrix(S)))), ",
            "|det T|=$(abs(det(gram_matrix(T)))), ",
            "T action=$action_label")
end

println("Rank-19 source audit passed; no ambient extension or embedding was constructed")
