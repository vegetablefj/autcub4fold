# Exact cyclic powers of the four complete rank-22 maximal actions.
#
# Usage, after coordinating the OSCAR run with other calculations:
#   julia --project=<OSCAR environment> derive_cyclic_maximal_powers.jl
#   julia --project=<OSCAR environment> derive_cyclic_maximal_powers.jl result.mrdi result.md
#
# This reads saved actions; it does not enumerate lattice isometries. It
# refuses to overwrite either output. A row with several containing maximal
# families retains every path separately. Equal cyclic characters are checked
# across those paths, but integral conjugacy is not inferred from them.

using Oscar
using SHA

include(joinpath(@__DIR__, "restrict_cyclic_power.jl"))
include(joinpath(@__DIR__, "normalize_trivial_symplectic_maximal.jl"))

const power_here = @__DIR__
const power_low = normpath(joinpath(power_here, "..", "low_rank", "maximal_cases"))
const power_index = joinpath(power_low, "maximal_lattice_action_index.json")
const power_numbering = normpath(joinpath(power_here, "..", "input", "family_numbering.md"))
const power_containment = normpath(joinpath(power_here, "..", "..", "gap_classification",
    "gap_fourfold_cross_dimension", "result", "gap_fourfold_cross_dimension_all_pairs.tsv"))
const power_pinned_hashes = Dict(
    power_index => "3997d95d58dc4e9c71497bc276f8a1fb6b24766c4c8b93b263d40dc180e452e5",
    power_numbering => "d784e69e28d23e9ca647a8a5ceeb0b1e4441a81fff06dc5e52a3346449684bd1",
    power_containment => "33450686babf1fc07d860a2f7ef15a40fb0bd8cf00f03a6d5fa275dee9d5017d",
)
const power_parents = (152, 154, 155, 156)
const power_parent_orders = Dict(152 => 16, 154 => 24, 155 => 32, 156 => 48)
const power_children = (132, 133, 135, 137, 138, 139, 144, 145, 146, 147, 148, 151, 153)

# These are the embedded pairs in the pinned, verified all-pairs table. The
# parser below independently recovers and checks this list before any MRDI
# source is loaded. All eligible non-embedded pairs are checked as well.
const power_expected_parents = Dict(
    132 => (152, 154, 155, 156),
    133 => (152, 154, 155, 156),
    135 => (154, 156),
    137 => (152, 155, 156),
    138 => (154,),
    139 => (154, 156),
    144 => (155, 156),
    145 => (152,),
    146 => (154,),
    147 => (156,),
    148 => (154,),
    151 => (155, 156),
    153 => (156,),
)

power_key(n) = lpad(string(n), 3, '0')
power_hash(path) = bytes2hex(sha256(read(path)))
power_note(s) = (println(s); flush(stdout))

function power_check_text_inputs()
    for (path, expected) in power_pinned_hashes
        isfile(path) || error("Missing input: $path")
        # No normalization: the checked bytes are the provenance evidence.
        power_hash(path) == expected ||
            error("Pinned SHA-256 changed: $path")
    end
end

function power_numbered_rows()
    rows = Dict{Int, NamedTuple}()
    for line in eachline(power_numbering)
        startswith(line, "|") || continue
        cells = strip.(split(line, '|'))
        length(cells) >= 8 || continue
        number = tryparse(Int, cells[2])
        number === nothing && continue
        1 <= number <= 156 || continue
        @assert !haskey(rows, number)
        rows[number] = (
            rank_S=parse(Int, cells[3]),
            index=parse(Int, cells[6]),
            dimension=parse(Int, match(r"\d+", cells[7]).match),
        )
    end
    @assert length(rows) == 156
    @assert sort(collect(keys(rows))) == collect(1:156)
    for parent in power_parents
        @assert rows[parent].rank_S == 0
        @assert rows[parent].index == power_parent_orders[parent]
    end
    for child in power_children
        @assert rows[child].rank_S == 0
        @assert rows[child].index >= 1
        @assert rows[child].dimension >= 0
    end
    return rows
end

function power_verified_paths(rows)
    relevant = Dict{Tuple{Int, Int}, Vector{String}}()
    lines = readlines(power_containment)
    header = split(chomp(first(lines)), '\t')
    @assert header == [
        "group_source_family", "group_target_family", "source_dimension",
        "target_dimension", "source_order", "target_order", "status",
        "classification", "direct", "via_family", "reason", "method",
    ]
    for line in lines[2:end]
        fields = String.(split(chomp(line), '\t'))
        @assert length(fields) == length(header)
        child = parse(Int, fields[1])
        parent = parse(Int, fields[2])
        child in power_children && parent in power_parents || continue
        pair = (child, parent)
        @assert !haskey(relevant, pair)
        relevant[pair] = fields
    end
    for child in power_children, parent in power_parents
        m, n = rows[child].index, rows[parent].index
        # Equal-dimensional/equal-order rows are not direct cyclic descendants.
        eligible = n % m == 0 && rows[child].dimension > rows[parent].dimension
        eligible || continue
        fields = get(relevant, (child, parent), nothing)
        fields === nothing && error("Missing checked containment pair $child -> $parent")
        @assert parse(Int, fields[3]) == rows[child].dimension
        @assert parse(Int, fields[4]) == rows[parent].dimension
        @assert parse(Int, fields[5]) == 3m
        @assert parse(Int, fields[6]) == 3n
        @assert fields[8] == "direct" && fields[9] == "true"
        embedded = fields[7] == "embedded"
        @assert embedded || fields[7] == "no_embedding"
        @assert embedded == (parent in power_expected_parents[child])
    end
    for child in power_children, parent in power_expected_parents[child]
        @assert haskey(relevant, (child, parent))
        @assert relevant[(child, parent)][7] == "embedded"
    end
    return power_expected_parents
end

function power_source_actions(rows, requested_parents=power_parents)
    index = Oscar.JSON.parse(read(power_index, String))
    @assert index["schema"] == "maximal-lattice-action-index-v1"
    items = Dict(item["number"] => item for item in index["families"])
    actions = Dict{Int, Any}()
    metadata = Dict{Int, Any}()
    for parent in requested_parents
        item = items[parent]
        @assert item["selected_output"] == trivial_symplectic_maximal_source(parent).source_result_index
        @assert item["selected_source_action"] == trivial_symplectic_maximal_source(parent).source_action_index
        @assert item["coprime_power_orbits"] == 1
        path = joinpath(power_low, item["mrdi"])
        @assert isfile(path) && power_hash(path) == item["mrdi_sha256"]
        snapshot = load(path)
        selected = item["selected_output"]
        @assert snapshot.family_number == parent
        @assert snapshot.order == power_parent_orders[parent]
        @assert snapshot.number_of_results == item["retained_outputs"] == length(snapshot.results)
        normalized = normalize_trivial_symplectic_maximal(snapshot.results[selected], parent)
        @assert normalized.data.order == rows[parent].index
        @assert normalized.data.dimension == rows[parent].dimension
        actions[parent] = normalized.data.Lambda0
        metadata[parent] = (
            source_file=item["mrdi"], source_sha256=item["mrdi_sha256"],
            selected_output=selected, source_action_index=item["selected_source_action"],
            source_search="complete exact-character integral-action search",
            coprime_power_orbits=item["coprime_power_orbits"],
            negative_pair_exponent_up_to_sign=item["selected_negative_pair_exponent_up_to_sign"],
            displayed_hodge_exponent=item["displayed_hodge_exponent"],
        )
        power_note("Checked saved No. $parent output $selected")
    end
    return actions, metadata
end

function power_identity_record(g)
    n = Int(order_of_isometry(g))
    L = lattice(g)
    Lf = integer_lattice_with_isometry(
        L, identity_matrix(QQ, 22); ambient_representation=false, check=true,
    )
    Z = orthogonal_submodule(L, basis_matrix(L))
    @assert rank(Z) == 0
    Zf = integer_lattice_with_isometry(
        Z, identity_matrix(QQ, 0); ambient_representation=false, check=true,
    )
    return (
        order=1, dimension=20,
        S_in_Lambda0=Zf,
        T_in_Lambda0=Lf, T_action=Lf,
        K_in_Lambda0=Z, P_in_Lambda0=L, P_action=Lf,
        Lambda0=Lf, source_order=n, power_exponent=n,
    )
end

function power_trace_histogram(A, m)
    @assert nrows(A) == ncols(A) == 22
    I = identity_matrix(QQ, 22)
    f = I
    histogram = Dict{Tuple{Int, Int}, Int}()
    for k in 0:m-1
        trace = sum(f[i, i] for i in 1:22)
        @assert denominator(trace) == 1
        element_order = k == 0 ? 1 : div(m, gcd(m, k))
        pair = (element_order, Int(numerator(trace)))
        histogram[pair] = get(histogram, pair, 0) + 1
        f *= A
    end
    @assert f == I && get(histogram, (1, 22), 0) == 1
    @assert sum(values(histogram)) == m
    return histogram
end

# The source search checks this for its generators; a power must retain it.
# This repeats the small check from oscar/oscar_script.jl without loading that
# search implementation or its input cases.
function power_trivial_discriminant_action(Lf)
    D, fD = discriminant_group(Lf)
    return all(fD(x) == x for x in gens(D))
end

function power_validate(data, source, child, parent, rows)
    m, n = rows[child].index, rows[parent].index
    L = lattice(data.Lambda0)
    P, K = data.P_in_Lambda0, data.K_in_Lambda0
    @assert data.order == m && data.dimension == rows[child].dimension
    @assert data.source_order == n && data.power_exponent == div(n, m)
    @assert rank(L) == 22 && signature_tuple(L) == (20, 0, 2)
    @assert abs(det(gram_matrix(L))) == 3
    @assert gram_matrix(L) == gram_matrix(lattice(source))
    @assert isometry(data.Lambda0) == isometry(source)^div(n, m)
    @assert Int(order_of_isometry(data.Lambda0)) == m
    @assert power_trivial_discriminant_action(data.Lambda0)
    @assert rank(lattice(data.S_in_Lambda0)) == 0
    @assert rank(lattice(data.T_in_Lambda0)) == 22
    @assert rank(lattice(data.T_action)) == 22
    @assert gram_matrix(lattice(data.T_in_Lambda0)) == gram_matrix(L)
    @assert isometry(data.T_in_Lambda0) == isometry(data.T_action) == isometry(data.Lambda0)
    @assert basis_matrix(lattice(data.P_action)) == basis_matrix(P)
    @assert Int(order_of_isometry(data.P_action)) == m
    @assert rank(P) + rank(K) == 22
    @assert signature_tuple(P) == (rank(P) - 2, 0, 2)
    @assert signature_tuple(K) == (rank(K), 0, 0)
    @assert basis_matrix(P) * gram_matrix(ambient_space(L)) * transpose(basis_matrix(K)) ==
        zero_matrix(QQ, rank(P), rank(K))
    phi = Int(euler_phi(m))
    expected_rank = phi * (rows[child].dimension + (m <= 2 ? 2 : 1))
    @assert rank(P) == expected_rank
    return true
end

function power_histogram_text(histogram)
    return join(["$(pair[1]):$(pair[2]) ($(histogram[pair]))"
                 for pair in sort(collect(keys(histogram)))], ", ")
end

function power_smoke()
    power_check_text_inputs()
    rows = power_numbered_rows()
    power_verified_paths(rows)
    actions, _ = power_source_actions(rows, (152,))
    child, parent = 145, 152
    data = restrict_cyclic_power(actions[parent], rows[child].index)
    power_validate(data, actions[parent], child, parent, rows)
    histogram = power_trace_histogram(isometry(data.Lambda0), rows[child].index)
    power_note("Smoke passed: No. 145 from No. 152^2, rank P $(rank(data.P_in_Lambda0)), " *
        "rank K $(rank(data.K_in_Lambda0)), character $(power_histogram_text(histogram))")
end

function power_report_lines(paths, rows, source_metadata)
    lines = String[
        "# Exact cyclic powers of maximal Nos. 152, 154, 155 and 156", "",
        "The four source actions are selected outputs of complete exact-character searches.",
        "Every parent path below is an embedded pair in the pinned verified containment table,",
        "and every saved full action passed exact order, lattice, period, and reload checks.",
        "No. 132 is the identity action and is constructed directly on each source lattice.",
        "Multiple paths are retained separately; matching cyclic characters do not alone prove integral conjugacy.", "",
        "| Child | Order | Dimension | Parent powers | rank P | rank K | Cyclic order:trace histogram |",
        "| ---: | ---: | ---: | --- | ---: | ---: | --- |",
    ]
    for child in power_children
        child_paths = paths[power_key(child)]
        parent_numbers = sort(parse.(Int, collect(keys(child_paths))))
        first_record = child_paths[power_key(first(parent_numbers))]
        powers = join(["$parent^$(child_paths[power_key(parent)].data.power_exponent)"
                       for parent in parent_numbers], ", ")
        push!(lines, "| $child | $(rows[child].index) | $(rows[child].dimension) | `$powers` | " *
            "$(rank(first_record.data.P_in_Lambda0)) | $(rank(first_record.data.K_in_Lambda0)) | " *
            "`$(power_histogram_text(first_record.provenance.cyclic_character_histogram))` |")
    end
    append!(lines, ["", "## Provenance", "",
        "- Numbered index and dimension: `remark/input/family_numbering.md`, SHA-256 `$(power_hash(power_numbering))`.",
        "- Verified direct containment: `gap_classification/gap_fourfold_cross_dimension/result/gap_fourfold_cross_dimension_all_pairs.tsv`, SHA-256 `$(power_hash(power_containment))`.",
        "- Selected-output index: `remark/low_rank/maximal_cases/maximal_lattice_action_index.json`, SHA-256 `$(power_hash(power_index))`.",
    ])
    for parent in power_parents
        meta = source_metadata[parent]
        push!(lines, "- No. $parent: `$(meta.source_file)`, SHA-256 `$(meta.source_sha256)`, output $(meta.selected_output), source action $(meta.source_action_index).")
    end
    append!(lines, ["",
        "The MRDI stores `paths[\"NNN\"][\"PPP\"].data` for every checked child/parent path,",
        "including `S_in_Lambda0`, `T_in_Lambda0`, `T_action`, `P_in_Lambda0`,",
        "`P_action`, `K_in_Lambda0`, and `Lambda0`. Each path also stores its source",
        "and containment provenance. The source's negative eigenvalue pair is known only",
        "up to inversion; this result does not choose an oriented Hodge line or prove",
        "integral conjugacy of actions obtained through different parents.",
    ])
    return lines
end

function power_main(args)
    if args == ["--preflight"]
        power_check_text_inputs()
        rows = power_numbered_rows()
        power_verified_paths(rows)
        power_note("Preflight passed: 13 numbered rows and 25 verified embedded parent paths")
        return
    elseif args == ["--smoke"]
        power_smoke()
        return
    end
    length(args) <= 2 || error("Usage: julia derive_cyclic_maximal_powers.jl [result.mrdi] [result.md]")
    output = isempty(args) ? joinpath(power_here, "cyclic_maximal_power_restrictions.mrdi") : abspath(args[1])
    report = length(args) < 2 ? joinpath(power_here, "cyclic_maximal_power_restrictions_result.md") : abspath(args[2])
    endswith(lowercase(output), ".mrdi") || error("The result must be an .mrdi file")
    endswith(lowercase(report), ".md") || error("The report must be a .md file")
    @assert normpath(output) != normpath(report)
    for path in (output, report, output * ".building.mrdi", report * ".building.md")
        ispath(path) && error("Refusing to overwrite $path")
    end

    power_check_text_inputs()
    rows = power_numbered_rows()
    verified_paths = power_verified_paths(rows)
    actions, source_metadata = power_source_actions(rows)
    paths = Dict{String, Any}()
    for child in power_children
        m = rows[child].index
        child_paths = Dict{String, Any}()
        reference_histogram = nothing
        for parent in verified_paths[child]
            n = rows[parent].index
            g = actions[parent]
            data = m == 1 ? power_identity_record(g) : restrict_cyclic_power(g, m)
            power_validate(data, g, child, parent, rows)
            histogram = power_trace_histogram(isometry(data.Lambda0), m)
            if reference_histogram !== nothing
                histogram == reference_histogram ||
                    error("Different cyclic characters for No. $child across parent paths")
            end
            reference_histogram = histogram
            child_paths[power_key(parent)] = (
                data=data,
                provenance=(
                    family_number=child, parent_number=parent,
                    construction=m == 1 ? "identity on the saved ambient lattice" :
                        "exact power of the saved full rank-22 action",
                    power_exponent=div(n, m),
                    containment_status="embedded; direct verified matrix-group comparison",
                    containment_table_sha256=power_hash(power_containment),
                    numbered_table_sha256=power_hash(power_numbering),
                    cyclic_character_histogram=histogram,
                    source=source_metadata[parent],
                    integral_cross_parent_conjugacy="not checked",
                    oriented_hodge_line="not fixed",
                ),
            )
            power_note("No. $child from No. $parent: order $m, exponent $(div(n,m)), " *
                "rank P $(rank(data.P_in_Lambda0)), rank K $(rank(data.K_in_Lambda0))")
        end
        @assert !isempty(child_paths)
        paths[power_key(child)] = child_paths
    end
    @assert length(paths) == 13
    @assert sum(length(values(paths[power_key(child)])) for child in power_children) == 25

    bundle = Dict{String, Any}(
        "format_version" => 1,
        "description" => "All verified direct cyclic power paths from maximal Nos. 152, 154, 155, 156 to 13 rank-S-zero families",
        "number_order" => power_children,
        "parent_order" => power_parents,
        "julia_version" => string(VERSION),
        "oscar_version" => string(pkgversion(Oscar)),
        "source_index_sha256" => power_hash(power_index),
        "numbering_sha256" => power_hash(power_numbering),
        "containment_sha256" => power_hash(power_containment),
        "source_metadata" => source_metadata,
        "paths" => paths,
        "cross_parent_check" => "same exact cyclic order/trace histogram; integral conjugacy not checked",
    )
    stage = output * ".building.mrdi"
    power_note("Saving derived full ambient records")
    save(stage, bundle)
    reloaded = load(stage)
    @assert reloaded["format_version"] == 1
    @assert reloaded["number_order"] == power_children
    @assert reloaded["parent_order"] == power_parents
    @assert length(reloaded["paths"]) == 13
    for child in power_children
        child_paths = reloaded["paths"][power_key(child)]
        @assert sort(parse.(Int, collect(keys(child_paths)))) == collect(verified_paths[child])
        for parent in verified_paths[child]
            record = child_paths[power_key(parent)]
            @assert record.provenance.family_number == child
            @assert record.provenance.parent_number == parent
            power_validate(record.data, actions[parent], child, parent, rows)
            @assert record.provenance.cyclic_character_histogram ==
                power_trace_histogram(isometry(record.data.Lambda0), rows[child].index)
        end
    end
    report_stage = report * ".building.md"
    open(report_stage, "w") do io
        for line in power_report_lines(reloaded["paths"], rows, source_metadata)
            println(io, line)
        end
    end
    mv(stage, output; force=false)
    mv(report_stage, report; force=false)
    power_note("Saved and reloaded: $output")
    power_note("Wrote result report: $report")
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    power_main(ARGS)
end
