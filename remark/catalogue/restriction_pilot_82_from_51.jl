# Trial of a restriction that changes the symplectic part: No. 51 (Q8) to
# No. 82 (C4).  This reads the saved No. 51 lattice extension; it does not
# rerun the original lattice enumeration or alter the 156-row catalogue.

using Oscar

const started_at = time()
function progress(message)
    println(round(time() - started_at; digits=1), " s | ", message)
    flush(stdout)
end

# The catalogue builder assigns source case 21, result 3 to No. 51.  Loading
# that smaller source file avoids deserializing all 156 catalogue rows.
const source_path = joinpath(@__DIR__, "..", "..", "oscar", "oscar_script_data.mrdi")
const source = load(source_path)
@assert source.cases[21].number_of_results >= 3
const saved = source.cases[21].results[3]
@assert saved.order == 4 && saved.dimension == 1

const L = lattice(saved.Lambda0)
const S = lattice(saved.S_in_Lambda0)
const T = lattice(saved.T_in_Lambda0)
@assert rank(L) == 22 && rank(S) == 17 && rank(T) == 5
progress("Loaded No. 51: S rank 17, T rank 5, extra action order $(order_of_isometry(saved.Lambda0))")

# Set RESTRICTION_PILOT_INPUT_ONLY=1 for a quick input and serialization check.
if get(ENV, "RESTRICTION_PILOT_INPUT_ONLY", "0") == "1"
    exit()
end

# These are precisely the routines used by practical_group_gap_id in
# oscar/oscar_script.jl.  They are the only potentially expensive step here.
progress("Computing O(S) generators")
O = matrix_group(automorphism_group_generators(S; ambient_representation=false))
progress("Computing the discriminant representation")
rho = discriminant_representation(S, O;
    ambient_representation=false, full=false, check=true)
K, inclusion = kernel(rho)
progress("Stable kernel order $(order(K)), ID $(small_group_identification(K))")
@assert order(K) == 8
@assert small_group_identification(K) == (8, 4) # Q8

# A stable S-isometry extends by the identity on T_Q.  Since it acts
# trivially on the discriminant form, it preserves the saved gluing in L.
lifted = typeof(isometry(saved.Lambda0))[]
for u in gens(K)
    Su = integer_lattice_with_isometry(S, matrix(inclusion(u));
        ambient_representation=false, check=true)
    Lu = integer_lattice_with_isometry(L, ambient_isometry(Su);
        ambient_representation=true, check=true)
    push!(lifted, isometry(Lu))
end
H = matrix_group(vcat(lifted, [isometry(saved.Lambda0)]))
N, _ = sub(H, [H(a) for a in lifted])
progress("Full No. 51 lattice group order $(order(H)), ID $(small_group_identification(H))")
@assert order(H) == 32 && small_group_identification(H) == (32, 11)
@assert order(N) == 8 && small_group_identification(N) == (8, 4)

# The finite group is small.  Search only for the unique [16,6] subgroup
# whose intersection with Q8 has order four.  This is not a same-S restriction.
elements_H = collect(elements(H))
candidate = nothing
for a in elements_H
    order(a) == 8 || continue
    for b in elements_H
        B, _ = sub(H, [a, b])
        order(B) == 16 || continue
        small_group_identification(B) == (16, 6) || continue
        overlap = [x for x in elements(B) if x in N]
        length(overlap) == 4 || continue
        global candidate = B
        break
    end
    candidate === nothing || break
end
@assert candidate !== nothing
overlap = [x for x in elements(candidate) if x in N]
c4 = first(x for x in overlap if order(x) == 4)
progress("Found No. 82 subgroup: order 16, ID [16,6], symplectic intersection C4")

# The fixed and coinvariant lattices of the C4 generator recover the new
# T and S in the *same* ambient cubic-fourfold lattice.
L_c4 = integer_lattice_with_isometry(L, matrix(c4);
    ambient_representation=false, check=true)
T82 = lattice(invariant_lattice(L_c4))
S82 = lattice(coinvariant_lattice(L_c4))
progress("Restricted lattices: rank(S)=$(rank(S82)), rank(T)=$(rank(T82))")
@assert rank(S82) == 14 && rank(T82) == 8

# Select a coset of order four in the quotient by C4.  It preserves T82.
C4, _ = sub(H, [c4])
extra = first(x for x in elements(candidate) if
    !(x in C4) && !(x^2 in C4) && (x^4 in C4))
L_extra = integer_lattice_with_isometry(L, matrix(extra);
    ambient_representation=false, check=true)
A = ambient_isometry(L_extra)
B = basis_matrix(T82)
G = gram_matrix(ambient_space(L))
fT = B * A * G * transpose(B) * inv(gram_matrix(T82))
@assert fT * B == B * A
T82_extra = integer_lattice_with_isometry(T82, fT;
    ambient_representation=false, check=true)
@assert order_of_isometry(T82_extra) == 4
@assert signature_tuple(T82) == (6, 0, 2)
phi4_rank = rank(T82) - rank(fT^2 + identity_matrix(QQ, rank(T82)))
@assert phi4_rank == 6 # Period dimension 6/2 - 1 = 2.
progress("No. 82 T: signature $(signature_tuple(T82)), determinant $(det(gram_matrix(T82)))")
progress("No. 82 T-action: order $(order_of_isometry(T82_extra)), characteristic polynomial $(characteristic_polynomial(T82_extra))")

result_file = joinpath(@__DIR__, "restriction_pilot_82_from_51.mrdi")
save(result_file, (
    parent_number=51,
    child_number=82,
    S=S82,
    T=T82,
    T_extra_action=T82_extra,
    symplectic_generator_in_parent=matrix(c4),
    extra_generator_in_parent=matrix(extra),
))
reloaded = load(result_file)
@assert rank(reloaded.S) == 14 && rank(reloaded.T) == 8
@assert order_of_isometry(reloaded.T_extra_action) == 4
progress("Saved and reloaded $(basename(result_file)); trial complete")
