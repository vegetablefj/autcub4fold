# Read-only diagnostic for the three basis conventions in the No. 105 file.
using Oscar

data = load(joinpath(@__DIR__, "no105_extensions.mrdi"))
record = only(data["results"])
S_search = data["S_input"]
T_search = data["T_input"]
S_embedded = lattice(record.S_in_Lambda0)
T_embedded = lattice(record.T_in_Lambda0)
T_action = lattice(record.T_action)

println("S search/embedded Gram equal: ",
    gram_matrix(S_search) == gram_matrix(S_embedded))
println("T search/action Gram equal: ",
    gram_matrix(T_search) == gram_matrix(T_action))
println("T search/embedded Gram equal: ",
    gram_matrix(T_search) == gram_matrix(T_embedded))
println("T action/embedded Gram equal: ",
    gram_matrix(T_action) == gram_matrix(T_embedded))
println("S discriminants: ", abs(det(S_search)), ", ",
    abs(det(S_embedded)))
println("T discriminants: ", abs(det(T_search)), ", ",
    abs(det(T_action)), ", ", abs(det(T_embedded)))
flush(stdout)

# The search input is embedded in a larger rational ambient space, whereas
# the enumerated action is full in its own rank-ten rational space. Hecke's
# indefinite-lattice isometry routine requires the full lattice first.
println("S search/embedded isometric: ", is_isometric(S_search, S_embedded))
flush(stdout)
println("T action/search isometric: ", is_isometric(T_action, T_search))
flush(stdout)
@assert gram_matrix(T_action) == gram_matrix(T_embedded)
