# Lattice inputs for the six low-rank action-maximal cases.
#
# The preserved 37-pair input is parsed as data rather than evaluated.  The
# six families use only three labelled pairs.  This file requires OSCAR.

using Oscar

const maximal_source_input_file = joinpath(@__DIR__, "..", "input_original.jl.txt")

function read_maximal_labelled_input(label::String)
    source = replace(read(maximal_source_input_file, String), "\r\n" => "\n")
    lines = split(source, '\n')
    first_line = findfirst(line -> strip(line) == "# " * label, lines)
    first_line === nothing && error("Input label not found: $label")
    last_line = first_line + 1
    while last_line <= length(lines) && !startswith(strip(lines[last_line]), "#")
        last_line += 1
    end
    block = join(lines[(first_line + 1):(last_line - 1)], "\n")
    matrices = collect(eachmatch(
        r"matrix\(ZZ,\s*(\d+),\s*(\d+),\s*\[([\d,\s-]*)\]\)",
        block,
    ))
    length(matrices) == 2 || error("Expected exactly two Gram matrices: $label")

    lattices = map(matrices) do item
        n = parse(Int, item.captures[1])
        n == parse(Int, item.captures[2]) || error("Gram matrix is not square")
        values = [
            parse(Int, strip(value)) for value in split(item.captures[3], ',')
            if !isempty(strip(value))
        ]
        length(values) == n^2 || error("Wrong number of Gram entries")
        gram = matrix(ZZ, n, n, values)
        gram == transpose(gram) || error("Asymmetric Gram matrix in $label")
        all(i -> iseven(gram[i, i]), 1:n) || error("Non-even Gram matrix")
        integer_lattice(; gram)
    end

    orders_match = match(r"(?m)^\s*\[([\d,\s]+)\]\),?\s*$", block)
    orders_match === nothing && error("Candidate orders not found: $label")
    orders = [parse(Int, strip(value)) for value in split(orders_match.captures[1], ',')]
    return (label = label, S = lattices[1], T = lattices[2], candidate_orders = orders)
end

const maximal_s3_input = read_maximal_labelled_input("S_3 generic 2")
const maximal_c2_input = read_maximal_labelled_input("2 generic 1")
const maximal_trivial_input = read_maximal_labelled_input("1 generic 1")

@assert rank(maximal_s3_input.S) == 14
@assert rank(maximal_s3_input.T) == 8
@assert det(gram_matrix(maximal_s3_input.S)) == 972
@assert det(gram_matrix(maximal_s3_input.T)) == 324
@assert 24 in maximal_s3_input.candidate_orders

@assert rank(maximal_c2_input.S) == 8
@assert rank(maximal_c2_input.T) == 14
@assert 4 in maximal_c2_input.candidate_orders

@assert rank(maximal_trivial_input.S) == 0
@assert rank(maximal_trivial_input.T) == 22
@assert all(order in maximal_trivial_input.candidate_orders for order in (16, 24, 32, 48))

const maximal_lattice_input_by_family = Dict(
    96 => maximal_s3_input,
    127 => maximal_c2_input,
    152 => maximal_trivial_input,
    154 => maximal_trivial_input,
    155 => maximal_trivial_input,
    156 => maximal_trivial_input,
)

const maximal_lattice_signature_by_family = Dict(
    96 => ((14, 0), (6, 2)),
    127 => ((8, 0), (12, 2)),
    152 => ((0, 0), (20, 2)),
    154 => ((0, 0), (20, 2)),
    155 => ((0, 0), (20, 2)),
    156 => ((0, 0), (20, 2)),
)

