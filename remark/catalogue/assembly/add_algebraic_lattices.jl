# Recover generic algebraic lattices from the already assembled ambient actions.
# No isometry enumeration or family identification is performed here.
# Usage: julia --project=... add_algebraic_lattices.jl INPUT.mrdi OUTPUT.mrdi GRAMS.txt
#        julia --project=... add_algebraic_lattices.jl --smoke INPUT.mrdi
using Oscar
include(joinpath(@__DIR__, "..", "full_h4_lattice_functions.jl"))

al_plain(x::ZZLatWithIsom) = lattice(x)
al_plain(x::ZZLat) = x
al_key(n) = lpad(string(n), 3, '0')
al_require(ok, message) = ok || error(message)
al_det(L) = rank(L) == 0 ? ZZ(1) : abs(det(gram_matrix(L)))

function al_symbol_style(raw)
    s = replace(raw, r"\{([0-9]+)\}\^\{([0-9]+)\}" => s"\1^{+\2}")
    s = replace(s, r"\{([0-9]+)\}\^\{(-[0-9]+)\}" => s"\1^{\2}")
    al_require(!occursin(r"\{[0-9]+\}\^\{", s),
               "Unrecognized Conway-Sloane scale notation")
    return s
end

# Positive-scale Jordan blocks give the discriminant form; scale-zero
# unimodular blocks contribute nothing.  Canonicalization keeps the 2-adic
# type and oddity, which are not determined by the abstract group alone.
function al_discriminant_symbol(L)
    rank(L) == 0 && return "0"
    al_require(iseven(L), "A discriminant quadratic symbol requires an even lattice")
    d = ZZ(al_det(L))
    d == 1 && return "0"
    parts = String[]
    for p in sort(collect(prime_divisors(d)))
        local_genus = genus(L, p)
        blocks = [copy(block) for block in symbol(local_genus)
                  if block[1] > 0 && block[2] > 0]
        al_require(sum(block[1] * block[2] for block in blocks) ==
                   valuation(d, p),
                   "Incomplete discriminant symbol at prime $p")
        positive_genus = typeof(local_genus)(ZZ(p), blocks)
        push!(parts, al_symbol_style(canonical_symbol(positive_genus)))
    end
    return join(parts, " ")
end

function al_h2_coordinates(h2, A, H4)
    BA = change_base_ring(QQ, basis_matrix(A))
    GA = change_base_ring(QQ, gram_matrix(A))
    GH = change_base_ring(QQ, gram_matrix(H4))
    c = h2 * GH * transpose(BA) * inv(GA)
    al_require(c * BA == h2 &&
               all(denominator(c[1, i]) == 1 for i in 1:ncols(c)),
               "h^2 is not integral in the computed algebraic lattice")
    return c
end

function al_compute(row, n)
    al_require(row["number"] == n, "Numbering differs at No. $n")
    r = row["saved_result"]
    al_require(r isa NamedTuple &&
               all(hasproperty(r, name) for name in
                   (:Lambda0, :P_in_Lambda0, :K_in_Lambda0)),
               "No. $n has no complete primitive-lattice record")
    L0 = al_plain(r.Lambda0)
    P = al_plain(r.P_in_Lambda0)
    K = al_plain(r.K_in_Lambda0)
    al_require(rank(L0) == 22 && rank(P) + rank(K) == 22,
               "No. $n has incompatible primitive-lattice ranks")
    full = cubic_fourfold_generic_lattices(L0, P, K)
    A, H4 = full.A, full.H4
    j = Int(full.algebraic_index)
    al_require(rank(A) == rank(K) + 1 &&
               signature_tuple(A) == (rank(A), 0, 0) &&
               is_primitive(H4, A),
               "No. $n has an invalid generic algebraic lattice")
    al_require(j in (1, 3) &&
               Int(full.period_plus_h2_index) * j == 3 &&
               al_det(A) == al_det(P) &&
               ZZ(j)^2 * al_det(P) == 3 * al_det(K),
               "No. $n index-three gluing or determinant check failed")
    al_require(rank(H4) == 23 && det(gram_matrix(H4)) == 1 &&
               signature_tuple(H4) == (21, 0, 2) &&
               (full.h2 * gram_matrix(H4) * transpose(full.h2))[1, 1] == 3,
               "No. $n full cohomology lattice or h^2 is invalid")
    h2coords = al_h2_coordinates(full.h2, A, H4)
    return Dict{String,Any}(
        "A_gen_in_H4" => A,
        "H4" => H4,
        "h2_in_H4" => full.h2,
        "h2_in_A_gen" => h2coords,
        "glue_vector_in_Lambda0" => full.glue_vector,
        "algebraic_index" => j,
        "period_plus_h2_index" => Int(full.period_plus_h2_index),
        "P_gram" => gram_matrix(P),
        "K_gram" => gram_matrix(K),
        "q_P_symbol" => al_discriminant_symbol(P),
        "q_K_symbol" => al_discriminant_symbol(K),
        "A_gen_gram" => gram_matrix(A))
end

function al_print_matrix(io, M)
    nrows(M) == 0 && return println(io, "[]")
    println(io, "[")
    for i in 1:nrows(M)
        println(io, "  [", join((string(M[i, j]) for j in 1:ncols(M)), ", "),
                "]", i < nrows(M) ? "," : "")
    end
    println(io, "]")
end

function al_print_row(io, row, record)
    n = row["number"]
    j = record["algebraic_index"]
    GP, GK, GA = record["P_gram"], record["K_gram"], record["A_gen_gram"]
    println(io, "\nNo. ", n, " | rank(S)=", row["rank_S"],
            " | index=", row["index"], " | dimension=", row["dimension"])
    println(io, "P: rank ", nrows(GP), ", determinant ",
            nrows(GP) == 0 ? 1 : abs(det(GP)))
    println(io, "q_P = ", record["q_P_symbol"])
    print(io, "P_gram = ")
    al_print_matrix(io, GP)
    println(io, "K: rank ", nrows(GK), ", determinant ",
            nrows(GK) == 0 ? 1 : abs(det(GK)))
    println(io, "q_K = ", record["q_K_symbol"])
    print(io, "K_gram = ")
    al_print_matrix(io, GK)
    println(io, "A_gen: rank ", nrows(GA), ", determinant ", abs(det(GA)),
            "; [A_gen : <h^2> + K] = ", j, ".")
    if j == 1
        println(io, "A_gen = <3> orthogonal-sum K; no separate Gram matrix is needed.")
    else
        print(io, "A_gen_gram = ")
        al_print_matrix(io, GA)
    end
end

function al_main()
    smoke = length(ARGS) == 2 && ARGS[1] == "--smoke"
    al_require(smoke || length(ARGS) == 3,
               "Usage: add_algebraic_lattices.jl [--smoke INPUT] | INPUT OUTPUT GRAMS")
    input = abspath(smoke ? ARGS[2] : ARGS[1])
    al_require(isfile(input), "Missing input catalogue $input")
    if !smoke
        output, grams = abspath.(ARGS[2:3])
        al_require(length(Set((input, output, grams))) == 3,
                   "Input and outputs must be distinct paths")
        for path in (output, grams, output * ".building.mrdi",
                     grams * ".building.txt")
            al_require(!ispath(path), "Refusing to overwrite $path")
        end
    end
    data = load(input)
    al_require(data["format_version"] == 1 &&
               data["number_order"] == Tuple(1:156),
               "Input is not a standard 156-row catalogue")
    rows = data["rows"]
    numbers = smoke ? (2, 96, 105, 127, 132) : 1:156
    gram_records = Dict{Int,Any}()
    for n in numbers
        key = al_key(n)
        al_require(haskey(rows, key), "Missing family No. $n")
        record = al_compute(rows[key], n)
        gram_records[n] = record
        !smoke && (rows[key]["generic_algebraic_lattice"] = record)
        println("Algebraic lattice ", n, "/156: index ",
                record["algebraic_index"])
        flush(stdout)
    end
    if smoke
        println("SMOKE PASS: Nos. 2, 96, 105, 127, 132")
        return
    end
    data["algebraic_lattice_description"] =
        "A_gen = P-perpendicular in full odd H4, computed by index-three gluing"
    stage_output = output * ".building.mrdi"
    stage_grams = grams * ".building.txt"
    save(stage_output, data)
    check = load(stage_output)
    al_require(check["number_order"] == Tuple(1:156) &&
               all(haskey(check["rows"][al_key(n)],
                          "generic_algebraic_lattice") for n in 1:156),
               "Enriched MRDI reload failed")
    for n in 1:156
        original = gram_records[n]
        restored = check["rows"][al_key(n)]["generic_algebraic_lattice"]
        al_require(all(original[field] == restored[field] for field in
                       ("P_gram", "K_gram", "A_gen_gram", "h2_in_H4",
                        "h2_in_A_gen", "glue_vector_in_Lambda0",
                        "algebraic_index", "period_plus_h2_index",
                        "q_P_symbol", "q_K_symbol")) &&
                   gram_matrix(original["H4"]) == gram_matrix(restored["H4"]) &&
                   basis_matrix(original["A_gen_in_H4"]) ==
                   basis_matrix(restored["A_gen_in_H4"]),
                   "Enriched MRDI changed lattice data on reload at No. $n")
    end
    open(stage_grams, "w") do io
        println(io, "Generic cubic-fourfold lattices, in numbered family order")
        println(io, "H4 = H^4(X,Z), h^2 has square 3, and Lambda0 = (h^2)-perpendicular in H4.")
        println(io, "T = Lambda0 fixed by the symplectic automorphism group; S = T-perpendicular in Lambda0.")
        println(io, "A_gen = H4 intersect H^{2,2}(X) for a very general member of the family.")
        println(io, "K = A_gen intersect Lambda0; P = K-perpendicular in Lambda0, and A_gen = P-perpendicular in H4.")
        println(io, "For the general member of the containing connected symplectic family, P = T and K = S.")
        println(io, "Thus S and T for a row are the K and P of that symplectic family, respectively.")
        println(io, "Use the connected family, not merely the abstract isomorphism type of its symplectic group.")
        println(io, "The displayed bases are those in the saved integral records.")
        println(io, "q_L is the discriminant quadratic form on L^vee/L (values modulo 2Z).")
        println(io, "Its OSCAR Conway-Sloane symbol lists only positive-scale Jordan blocks;")
        println(io, "0 denotes the trivial discriminant form. Prime components are separated by spaces.")
        println(io, "Symbols use the customary 3^{+1} notation for OSCAR's {3}^{1}.")
        for n in 1:156
            al_print_row(io, rows[al_key(n)], gram_records[n])
        end
    end
    mv(stage_output, output)
    mv(stage_grams, grams)
    println("Saved ", output)
    println("Saved ", grams)
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    al_main()
end
