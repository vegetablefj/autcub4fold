# Check the two L_2(7):2 lattice-action types without a new action search.

using Oscar

include(joinpath(@__DIR__, "..", "..", "oscar", "input.jl"))
S, T, _ = cases[3]
G = gram_matrix(T)
@assert rank(S) == 19 && abs(det(S)) == 196
@assert G == matrix(ZZ, 3, 3, [-2, 1, 0, 1, 10, 0, 0, 0, -28])
@assert abs(det(T)) == 588

# Unlike M_10, there is only one possible T-side glue subgroup.
DS = discriminant_group(S)
DT = discriminant_group(T)
index_three = collect(submodules(DT; index=3))
@assert length(index_three) == 1
HT, inclusion = only(index_three)
@assert order(DS) == order(HT) == 196
ok, phi = is_anti_isometric_with_anti_isometry(DS, HT)
@assert ok
L, iS, iT = Hecke.primitive_extension(compose(phi, inclusion))
@assert rank(L) == 22 && signature_tuple(L) == (20, 0, 2)
@assert iseven(L) && abs(det(L)) == 3
@assert is_primitive(L, iS(S)) && is_primitive(L, iT(T))
@assert is_isometric_with_isometry(
    discriminant_group(L), discriminant_group(root_lattice(:A, 2)))[1]
println("Unique T-side glue: order ", order(HT),
        "; ambient rank=", rank(L), ", |det|=", abs(det(L)))
flush(stdout)

# The +1 eigenline has norm 42 and divisibility 21 in both cases.
# For a row vector x, f_v(x) = (x,v)/21 * v - x.
function reflection_about_positive_line(T, coordinates)
    v = matrix(QQ, 1, 3, coordinates)
    B = gram_matrix(T)
    @assert (v * B * transpose(v))[1, 1] == 42
    @assert divisibility(T, v) == 21
    f = -identity_matrix(QQ, 3) + (B * transpose(v)) * v / 21
    @assert denominator(f) == 1
    @assert f^2 == identity_matrix(QQ, 3)
    @assert f * B * transpose(f) == B
    return f
end

models = (
    ("norm-2 branch", [1, 2, 0], matrix(ZZ, 2, 2, [-2, 0, 0, -28])),
    ("norm-4 branch", [7, -7, 3], matrix(ZZ, 2, 2, [-4, 0, 0, -14])),
)
for (label, v, expected_negative_gram) in models
    f = reflection_about_positive_line(T, v)
    Tf = integer_lattice_with_isometry(T, f;
        ambient_representation=false, check=true)
    positive = lattice(invariant_lattice(Tf))
    negative = lattice(coinvariant_lattice(Tf))
    @assert rank(positive) == 1 && gram_matrix(positive)[1, 1] == 42
    @assert rank(negative) == 2
    @assert is_isometric(negative,
        integer_lattice(; gram=expected_negative_gram))
    # Fixing the residual three-torsion is the extension criterion on T.
    residual = DT(matrix(QQ, 1, 3, [1, 2, 0]) / 3)
    @assert DT(matrix(QQ, 1, 3, [1, 2, 0]) * f / 3) == residual
    println(label, ": T_- isometric to ", expected_negative_gram,
            "; T_+ = <42>; residual 3-torsion fixed")
    flush(stdout)
end

println("PASS: one plain glue and two non-conjugate T actions satisfying the extension criterion.")

if "--check-saved" in ARGS
    saved = load(joinpath(@__DIR__, "..", "..", "oscar", "oscar_script_data.mrdi"))
    outputs = saved.cases[3].results
    @assert length(outputs) == 2
    for (i, result) in enumerate(outputs)
        N = lattice(coinvariant_lattice(result.T_action))
        expected = integer_lattice(; gram=models[i][3])
        @assert is_isometric(N, expected)
        Lambda = lattice(result.Lambda0)
        S_image = lattice(result.S_in_Lambda0)
        T_image = lattice(result.T_in_Lambda0)
        gamma, _, _ = glue_map(Lambda, S_image, T_image)
        @assert order(domain(gamma)) == order(codomain(gamma)) == 196
        @assert overlattice(gamma) == Lambda
        println("Saved output ", i, ": negative eigenlattice type ",
                models[i][1], "; glue order ", order(domain(gamma)))
        flush(stdout)
    end
    println("PASS: both saved ambient actions match the two lattice types.")
end
