# Load one labelled lattice pair from the preserved numeric input.
# Only matrix entries and candidate orders are parsed; the source is not evaluated.

using Oscar

const source_input_file = joinpath(@__DIR__, "input_original.jl.txt")

function read_labelled_input(label::String)
    source = replace(read(source_input_file, String), "\r\n" => "\n")
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
        values = [parse(Int, strip(x)) for x in split(item.captures[3], ',') if !isempty(strip(x))]
        length(values) == n^2 || error("Wrong number of Gram entries")
        gram = matrix(ZZ, n, n, values)
        gram == transpose(gram) || error("Asymmetric Gram matrix in $label")
        all(i -> iseven(gram[i, i]), 1:n) || error("Non-even Gram matrix")
        integer_lattice(; gram)
    end

    orders_match = match(r"(?m)^\s*\[([\d,\s]+)\]\),?\s*$", block)
    orders_match === nothing && error("Candidate orders not found: $label")
    orders = [parse(Int, strip(x)) for x in split(orders_match.captures[1], ',')]
    return (label=label, S=lattices[1], T=lattices[2], candidate_orders=orders)
end

const s3_generic_index2_input = read_labelled_input("S_3 generic 2")

@assert rank(s3_generic_index2_input.S) == 14
@assert rank(s3_generic_index2_input.T) == 8
@assert det(gram_matrix(s3_generic_index2_input.S)) == 972
@assert det(gram_matrix(s3_generic_index2_input.T)) == 324
@assert is_positive_definite(s3_generic_index2_input.S)
@assert is_even(s3_generic_index2_input.T)
@assert s3_generic_index2_input.candidate_orders == [4, 6, 8, 12, 24]
