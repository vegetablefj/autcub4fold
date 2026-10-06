# Identify the two A_{3,3} index-six actions using the complete primitive
# quotient coset, rather than the trace of one arbitrarily chosen generator.
# This reads the frozen OSCAR search output and does not rerun its enumeration.

using Oscar
using SHA
using Dates

const source_file = normpath(joinpath(@__DIR__, "..", "..", "..", "oscar",
    "oscar_script_data.mrdi"))
const source_sha256 =
    "c5278c3aeb5b2f7ed3574030d75d48680bba276302e035603531fa701bcf976b"
const output_file = joinpath(@__DIR__, "case23_full_coset_comparison.mrdi")

note(msg) = (println(Dates.format(now(), dateformat"yyyy-mm-ddTHH:MM:SS"),
    " | ", msg); flush(stdout))
digest(path) = bytes2hex(sha256(read(path)))

function matrix_trace(M)
    return Int(sum(M[i, i] for i in 1:nrows(M)))
end

function sorted_histogram(counts::Dict{Tuple{Int,Int},Int})
    return sort([(key[1], key[2], count) for (key, count) in counts];
        by=x -> (x[1], x[2]))
end

# Counts are for one of the two primitive quotient cosets in the projective
# full group. They come from the form-fixing linear actions in the final
# Koike-aligned No. 56/57 presentation, divided by the central mu_3.
const geometric_histograms = Dict(
    56 => sorted_histogram(Dict(
        (-1, 7) => 3, (2, -2) => 6, (5, -11) => 6, (5, 7) => 3,
    )),
    57 => sorted_histogram(Dict(
        (2, -2) => 12, (5, -11) => 6,
    )),
)

isfile(source_file) || error("Missing frozen search output: $source_file")
digest(source_file) == source_sha256 ||
    error("The frozen OSCAR search output has changed")
note("Julia $(VERSION); OSCAR $(pkgversion(Oscar)); frozen input hash checked")

source = load(source_file)
source.format_version == 3 || error("Unexpected source format")
length(source.cases) == 29 || error("Expected 29 OSCAR cases")
records = source.cases[23].results
length(records) == 2 || error("Expected exactly two case-23 outputs")

if get(ENV, "A33_CASE23_PREFLIGHT", "0") == "1"
    for (i, r) in enumerate(records)
        r.order == 6 && r.dimension == 2 && r.group_gap_id == (108, 38) ||
            error("Unexpected metadata in case-23 output $i")
        rank(lattice(r.S_in_Lambda0)) == 16 || error("Wrong S rank")
        rank(lattice(r.T_in_Lambda0)) == 6 || error("Wrong T rank")
    end
    note("Preflight passed; no automorphism group was computed and no file was written")
    exit()
end

ispath(output_file) && error("Preserve the existing result; refusing to overwrite $output_file")
results = NamedTuple[]

for (i, r) in enumerate(records)
    r.order == 6 && r.dimension == 2 && r.group_gap_id == (108, 38) ||
        error("Unexpected metadata in case-23 output $i")
    Sf = r.S_in_Lambda0
    S = lattice(Sf)
    rank(S) == 16 || error("Wrong S rank in output $i")
    rank(lattice(r.T_in_Lambda0)) == 6 || error("Wrong T rank in output $i")
    t = isometry(r.T_action)
    t_trace = matrix_trace(t)
    t_square_trace = matrix_trace(t^2)
    (t_trace, t_square_trace) == (3, -3) ||
        error("Unexpected T-action traces in output $i")

    note("Output $i: computing O(S) generators")
    O = matrix_group(automorphism_group_generators(
        S; ambient_representation=false,
    ))
    f = O(isometry(Sf))
    note("Output $i: computing the discriminant representation")
    rho = discriminant_representation(
        S, O; ambient_representation=false, full=false, check=true,
    )
    K, inclusion = kernel(rho)
    Int(order(K)) == 18 || error("Expected symplectic kernel of order 18")
    H, _ = sub(O, vcat([inclusion(g) for g in gens(K)], [f]))
    Int(order(H)) == 108 || error("Expected full projective group of order 108")

    counts = Dict{Tuple{Int,Int},Int}()
    for u in elements(K)
        a = f * inclusion(u)
        key = (matrix_trace(matrix(a)) + t_trace,
            matrix_trace(matrix(a^2)) + t_square_trace)
        counts[key] = get(counts, key, 0) + 1
    end
    sum(values(counts)) == 18 || error("Incomplete primitive coset")
    histogram = sorted_histogram(counts)
    matches = sort([n for n in keys(geometric_histograms)
        if histogram == geometric_histograms[n]])
    note("Output $i: primitive-coset histogram = $histogram; geometric matches = $matches")
    push!(results, (
        saved_result=i,
        order=Int(r.order),
        dimension=Int(r.dimension),
        group_gap_id=(108, 38),
        symplectic_kernel_order=Int(order(K)),
        full_group_order=Int(order(H)),
        selected_H4_traces=(matrix_trace(isometry(Sf)) + t_trace,
            matrix_trace(isometry(Sf)^2) + t_square_trace),
        primitive_coset_histogram=histogram,
        matching_family_numbers=matches,
    ))
end

assignment = [length(r.matching_family_numbers) == 1 ?
    only(r.matching_family_numbers) : 0 for r in results]
unique_assignment = sort(assignment) == [56, 57]
payload = (
    format_version=1,
    method="complete primitive-index-six coset character comparison",
    source_basename=basename(source_file),
    source_sha256=source_sha256,
    julia_version=string(VERSION),
    oscar_version=string(pkgversion(Oscar)),
    geometric_histograms=(
        family_56=geometric_histograms[56],
        family_57=geometric_histograms[57],
    ),
    results=Tuple(results),
    unique_assignment=unique_assignment,
)

staging_file = output_file * ".part"
ispath(staging_file) && error("Preserve the existing partial result: $staging_file")
save(staging_file, payload)
reloaded = load(staging_file)
reloaded.format_version == 1 && reloaded.source_sha256 == source_sha256 &&
    reloaded.results == Tuple(results) || error("MRDI reload check failed")
mv(staging_file, output_file; force=false)
note("MRDI saved and reloaded: $output_file")
note("Unique numbered assignment = $unique_assignment; assignments = $assignment")
unique_assignment || error("Character comparison did not uniquely assign Nos. 56 and 57")
