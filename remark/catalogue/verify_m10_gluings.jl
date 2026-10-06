# Construct the two M10 primitive embeddings from their discriminant gluing.
# This is a finite-quadratic-module calculation, not a representation search.

using Oscar

const output_file = joinpath(@__DIR__, "m10_gluings.mrdi")

function check_saved(path)
    saved = load(path)
    println("Stored OSCAR version: ", saved["oscar_version"],
            "; current version: ", pkgversion(Oscar))
    records = saved["records"]
    @assert length(records) == 2
    @assert sort([r["e1_divisibility"] for r in records]) == [1, 3]
    for r in records
        L = r["ambient_lattice"]
        e = r["e1_in_ambient"]
        @assert rank(L) == 22 && signature_tuple(L) == (20, 0, 2)
        @assert iseven(L) && abs(det(L)) == 3
        @assert is_primitive(L, r["S_in_ambient"])
        @assert is_primitive(L, r["T_in_ambient"])
        @assert divisibility(L, e) == r["e1_divisibility"]
        @assert abs(det(orthogonal_submodule(L, e))) ==
                r["e1_orthogonal_determinant"]
    end
    println("Saved embeddings reloaded and checked: ", path)
end

if "--check-saved" in ARGS
    check_saved(output_file)
    exit()
end

# The catalogue builder assigns the fourth rank-20 reference matrix to both
# M10 rows. Reading that source avoids loading all 156 unrelated records.
const s_file = normpath(joinpath(@__DIR__, "..", "..", "oscar", "list_S.txt"))
const s_lines = filter(line -> startswith(line, "matrix(ZZ, 20, 20,"), readlines(s_file))
@assert length(s_lines) == 6
const S = integer_lattice(; gram=Core.eval(@__MODULE__, Meta.parse(s_lines[4])))
const T = integer_lattice(; gram=matrix(ZZ, 2, 2, [-12, 0, 0, -30]))

@assert rank(S) == 20 && abs(det(S)) == 120
@assert gram_matrix(T) == matrix(ZZ, 2, 2, [-12, 0, 0, -30])

DS = discriminant_group(S)
DT = discriminant_group(T)
DA2 = discriminant_group(root_lattice(:A, 2))
BT = basis_matrix(T)

println("OSCAR ", pkgversion(Oscar), "; M10 rows 005/006")
println("|A_S| = ", order(DS), ", |A_T| = ", order(DT))
flush(stdout)

# There are four index-three subgroups of A_T. Exactly two have the
# discriminant form required for gluing to S.
subgroup_count = 0
compatible_count = 0
for (U, _) in submodules(DT; index=3)
    global subgroup_count += 1
    yes, _ = is_anti_isometric_with_anti_isometry(DS, U)
    global compatible_count += Int(yes)
end
@assert subgroup_count == 4 && compatible_count == 2
println("Index-three subgroups of A_T: ", subgroup_count,
        "; anti-isometric to A_S: ", compatible_count)
flush(stdout)

results = NamedTuple[]
records = Dict{String, Any}[]
for j in 1:2
    # R is the residual order-three subgroup of A_L; the gluing subgroup
    # H_T = R^perp has order 120 and is anti-isometric to A_S.
    r = DT([BT[j, k] / 3 for k in 1:ncols(BT)])
    @assert order(r) == 3
    R, _ = sub(DT, [r])
    HT, inclusion = orthogonal_submodule(DT, R)
    @assert order(HT) == 120
    ok, phi = is_anti_isometric_with_anti_isometry(DS, HT)
    @assert ok
    gamma = compose(phi, inclusion)
    L, iS, iT = Hecke.primitive_extension(gamma)
    Si = iS(S)
    Ti = iT(T)
    e = BT[1:1, :] * matrix(iT)
    d = divisibility(L, e)
    eperp = orthogonal_submodule(L, e)

    @assert rank(L) == 22 && signature_tuple(L) == (20, 0, 2)
    @assert iseven(L) && abs(det(L)) == 3
    @assert is_isometric_with_isometry(discriminant_group(L), DA2)[1]
    @assert rank(Si) == 20 && rank(Ti) == 2
    @assert is_primitive(L, Si) && is_primitive(L, Ti)
    @assert basis_matrix(Si) * gram_matrix(ambient_space(L)) *
            transpose(basis_matrix(Ti)) == zero_matrix(QQ, 20, 2)
    @assert is_primitive(L, e)
    @assert d == (j == 1 ? 3 : 1)
    @assert abs(det(eperp)) * d^2 == 36

    push!(results, (residual_line=j, divisibility=d,
                    orthogonal_determinant=abs(det(eperp))))
    push!(records, Dict{String, Any}(
        "residual_line" => j,
        "ambient_lattice" => L,
        "S_in_ambient" => Si,
        "T_in_ambient" => Ti,
        "e1_in_ambient" => e,
        "e1_divisibility" => Int(d),
        "e1_orthogonal_determinant" => Int(abs(det(eperp))),
    ))
    println("R = <e", j, "/3>: rank(L)=", rank(L),
            ", signature=", signature_tuple(L),
            ", |det(L)|=", abs(det(L)),
            ", div_L(e1)=", d,
            ", |det(e1^perp)|=", abs(det(eperp)))
    flush(stdout)
end

@assert sort([x.divisibility for x in results]) == [1, 3]
println("PASS: the two explicit gluings have the expected divisibility split.")

if "--save" in ARGS
    @assert !isfile(output_file) "Refusing to overwrite $output_file"
    save(output_file, Dict{String, Any}(
        "source" => "M10 reference S in oscar/list_S.txt, entry 4",
        "T_gram" => gram_matrix(T),
        "oscar_version" => string(pkgversion(Oscar)),
        "records" => Tuple(records),
    ))
    check_saved(output_file)
end
