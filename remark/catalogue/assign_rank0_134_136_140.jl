# Assign three rank-zero cyclic actions by exact geometric character within
# complete, saved parent groups. The source-to-parent embeddings and cubic
# smoothness are independently certified in GAP/Singular.

using Oscar
using SHA

const here_rank0_assign = @__DIR__
const geometric_rank0_assign = joinpath(here_rank0_assign, "..",
    "gap_checks", "cyclic_134_143",
    "primitive_cyclic_134_143_summary.tsv")
const output_rank0_assign = joinpath(here_rank0_assign,
    "restriction_rank0_134_136_140_from_parents.mrdi")

function exact_histograms_rank0(path)
    expected = Dict(n => Dict{Tuple{Int, Int}, Int}() for n in (134, 136, 140))
    for line in Iterators.drop(eachline(path), 1)
        isempty(strip(line)) && continue
        fields = split(line, '\t')
        @assert length(fields) == 4
        n, order, trace, count = parse.(Int, fields)
        haskey(expected, n) || continue
        @assert count > 0
        expected[n][(order, trace)] = count
    end
    @assert [sum(values(expected[n])) for n in (134, 136, 140)] == [2, 3, 3]
    return expected
end

geometric = exact_histograms_rank0(geometric_rank0_assign)
parent_files = Dict(
    18 => joinpath(here_rank0_assign, "rank0_cyclic_classes_from_18.mrdi"),
    41 => joinpath(here_rank0_assign, "rank0_cyclic_classes_from_41.mrdi"),
    44 => joinpath(here_rank0_assign, "rank0_cyclic_classes_from_44.mrdi"),
)
parents = Dict(n => load(parent_files[n]) for n in (18, 41, 44))
for n in (18, 41, 44)
    @assert parents[n].parent_number == n
    @assert parents[n].exhaustive_within_saved_parent_group
    @assert parents[n].geometric_character_sha256 ==
        bytes2hex(sha256(read(geometric_rank0_assign)))
end

specs = ((number=134, parent=41, order=2, dimension=10, class=1),
         (number=136, parent=18, order=3, dimension=7, class=1),
         (number=140, parent=18, order=3, dimension=6, class=2))
assigned = NamedTuple[]
for spec in specs
    parent = parents[spec.parent]
    matching = [r for r in parent.results
        if r.restriction.order == spec.order &&
           r.restriction.primitive_character_histogram == geometric[spec.number]]
    @assert length(matching) == 1
    r = only(matching)
    @assert r.class_number == spec.class
    @assert r.restriction.dimension == spec.dimension
    @assert r.restriction.rank_S == 0
    @assert rank(lattice(r.restriction.T_action)) == 22
    @assert order_of_isometry(r.restriction.T_action) == spec.order
    push!(assigned, (
        child_number=spec.number,
        parent_number=spec.parent,
        parent_class_number=r.class_number,
        order=spec.order,
        dimension=spec.dimension,
        restriction=r.restriction,
        character_matches=r.geometric_character_matches,
    ))
    println("No. $(spec.number): parent $(spec.parent), unique class $(r.class_number), " *
        "period rank $(r.restriction.rank_P), dimension $(r.restriction.dimension)")
    flush(stdout)
end

# The No. 44 parent supplies a separate geometric route to No. 134. It has
# exactly one matching class; no unrecorded equality of its chosen basis with
# the No. 41 ambient basis is asserted.
matches44 = [r for r in parents[44].results
    if r.restriction.order == 2 &&
       r.restriction.primitive_character_histogram == geometric[134]]
@assert length(matches44) == 1
@assert only(matches44).restriction.dimension == 10

save(output_rank0_assign, (
    format_version=1,
    assigned_numbers=(134, 136, 140),
    results=Tuple(assigned),
    geometric_character_file=relpath(geometric_rank0_assign, here_rank0_assign),
    geometric_character_sha256=bytes2hex(sha256(read(geometric_rank0_assign))),
    parent_files=Dict(n => basename(parent_files[n]) for n in (18, 41, 44)),
    parent_file_sha256=Dict(n => bytes2hex(sha256(read(parent_files[n]))) for n in (18, 41, 44)),
    independent_no134_parent44_class=only(matches44).class_number,
))
check = load(output_rank0_assign)
@assert check.assigned_numbers == (134, 136, 140)
@assert [x.child_number for x in check.results] == [134, 136, 140]
println("Saved and reloaded three unique character-matched rank-zero actions")
