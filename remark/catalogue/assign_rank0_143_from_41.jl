# Extract the pure-power C6 action from the complete No. 41 group search.
# The three same-character parent classes are not distinguished by this
# script. A separate geometric spectrum/connectedness proof is required
# before its result can be assigned to numbered No. 143.

using Oscar
using SHA

const here_143 = @__DIR__
const source_143 = joinpath(here_143, "rank0_cyclic_classes_from_41.mrdi")
const character_143 = joinpath(here_143, "..", "gap_checks",
    "cyclic_134_143", "primitive_cyclic_134_143_summary.tsv")
const output_143 = joinpath(here_143, "restriction_rank0_143_from_41.mrdi")

function geometric_histogram_143(path)
    histogram = Dict{Tuple{Int, Int}, Int}()
    for line in Iterators.drop(eachline(path), 1)
        isempty(strip(line)) && continue
        fields = split(line, '\t')
        @assert length(fields) == 4
        n, order, trace, count = parse.(Int, fields)
        n == 143 || continue
        @assert count > 0 && !haskey(histogram, (order, trace))
        histogram[(order, trace)] = count
    end
    @assert sum(values(histogram)) == 6
    return histogram
end

parent = load(source_143)
@assert parent.parent_number == 41
@assert parent.exhaustive_within_saved_parent_group
@assert parent.counts_by_order[6].parent_conjugacy_classes == 3
expected = geometric_histogram_143(character_143)
candidates = [r for r in parent.results if r.restriction.order == 6]
@assert length(candidates) == 3
@assert all(r.restriction.primitive_character_histogram == expected for r in candidates)
@assert all(r.restriction.dimension == 3 && r.restriction.rank_S == 0
            for r in candidates)
pure = only(r for r in candidates if r.kernel_element_index == 1)
@assert rank(lattice(pure.restriction.T_action)) == 22
@assert order_of_isometry(pure.restriction.T_action) == 6

save(output_143, (
    format_version=1,
    child_number=143,
    parent_number=41,
    candidate_parent_classes=Tuple(r.class_number for r in candidates),
    selected_pure_power_class=pure.class_number,
    identical_geometric_character_for_all_three=true,
    integral_equivalence_proof_file="cyclic_spectrum_equivalence_note.md",
    integral_equivalence_proof_scope="Requires the common smooth-parent realization supplied by the retained No. 41 stable fitting extension and the geometric spectrum/connectedness argument",
    geometric_character_sha256=bytes2hex(sha256(read(character_143))),
    exhaustive_parent_file_sha256=bytes2hex(sha256(read(source_143))),
    result=pure.restriction,
))
check = load(output_143)
@assert check.child_number == 143
@assert check.candidate_parent_classes == Tuple(r.class_number for r in candidates)
@assert order_of_isometry(check.result.T_action) == 6
println("Saved pure-power No. 143 candidate and reloaded it; theorem-level equivalence is separate")
