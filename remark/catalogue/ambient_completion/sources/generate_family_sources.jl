# Generate a numbered provenance audit from the verified v3 catalogue.
# This reads records only; it does not upgrade an abstract T action to an
# ambient-lattice certificate.

using Oscar
using SHA

const catalogue_dir = normpath(joinpath(@__DIR__, "..", ".."))
const default_catalogue_path = joinpath(catalogue_dir,
    "lattice_156_with_generic_actions_v3_20261004.mrdi")
const geometric_table_path = normpath(joinpath(catalogue_dir,
    "..", "input", "family_numbering.md"))
const default_output_path = joinpath(@__DIR__, "family_156_sources.md")
const base_hash = "5b401f2479dbe10145d3741e148c2dd3c5d925a2cd423fe0800c03005f4afbfb"
const external_candidates = Dict(
    2 => ("rank20_19/no2_index_one_gluings_20261004.mrdi",
          "03cf04383917d0b71ae4af50426bac856d461bba24797b053e822e2882ddbad3"),
    33 => ("rank18_16/crosspart_33.verified.mrdi",
           "9e1f4f7563d3b530f119d09906e1bb958da0a20fca5632ba8bb243405517a3ea"),
    47 => ("rank18_16/crosspart_47.verified.mrdi",
           "ca4ff96e45e6521962912c5995d5392c48ca8fd85dbd961c98f9e05270e897da"),
)
for (n, (relative, expected)) in external_candidates
    path = normpath(joinpath(@__DIR__, "..", relative))
    isfile(path) && bytes2hex(sha256(read(path))) == expected ||
        error("External No. $n candidate sidecar is missing or changed")
end
length(ARGS) <= 2 || error("Usage: generate_family_sources.jl [catalogue.mrdi [output.md]]")
const catalogue_path = isempty(ARGS) ? default_catalogue_path : abspath(ARGS[1])
const output_path = length(ARGS) < 2 ? default_output_path : abspath(ARGS[2])

actual_hash = bytes2hex(sha256(read(catalogue_path)))
if catalogue_path == default_catalogue_path
    actual_hash == base_hash || error("The audited v3 catalogue hash changed: $actual_hash")
end
data = load(catalogue_path)
rows = data["rows"]
length(rows) == 156 || error("Expected exactly 156 numbered rows")

geometric_sources = Dict{Int, String}()
for line in eachline(geometric_table_path)
    startswith(line, "|") || continue
    cells = strip.(split(line, '|'))
    length(cells) >= 9 || continue
    n = tryparse(Int, cells[2])
    n === nothing && continue
    1 <= n <= 156 || continue
    haskey(geometric_sources, n) && error("Duplicate geometric row $n")
    geometric_sources[n] = strip(cells[9], ['`', ' '])
end
length(geometric_sources) == 156 || error("Incomplete geometric source table")

nonempty(row, key) = haskey(row, key) && row[key] !== nothing
function markdown(s)
    text = replace(string(s), r"(?i)\s*\(?SHA-?256[: ]+`?[0-9a-f]{64}`?\)?" => "")
    # Translate historical provenance labels to current computational notes.
    # These are strings stored in the catalogue, not file dependencies.
    text = replace(text,
        "tex_work/lattice_remarks/main.tex Proposition c2c4" => "remark/low_rank/maximal_cases/family_127_g13_full_l_postcheck.md: stable root-free action and generic-period criterion",
        "remark/main.tex Proposition c2c4" => "remark/low_rank/maximal_cases/family_127_g13_full_l_postcheck.md: stable root-free action and generic-period criterion",
        "tex_work/lattice_remarks/main.tex" => "remark/catalogue/family_identification_script.md",
        "remark/main.tex" => "remark/catalogue/family_identification_script.md",
        "tex_work/paper1/main.tex" => "generic-period scalar-action criterion",
        "tex_work/paper2/main.tex" => "classified primitive-embedding equivalence and stable-fitting criterion",
        "first paper Lemma lem:pm1 and Proposition-Definition prop-def:generic2" => "generic-period scalar-action criterion",
        "second paper Proposition prop:ST-families and Lemma lem:stable-fitting-refinement" => "classified primitive-embedding equivalence and stable-fitting refinement",
        "second paper Proposition prop:ST-families" => "classified primitive-embedding equivalence",
        "second paper Proposition ST-families" => "classified primitive-embedding equivalence",
        "Propositions m10 and m10-identification" => "M10 primitive-gluing and real-pencil assignment",
        "Proposition l27" => "integral negative-eigenlattice and real-structure assignment",
        "Proposition c2c4" => "stable root-free action and generic-period criterion",
        "first-paper discriminant form" => "classified discriminant form",
        "first paper" => "generic-period classification",
        "second paper" => "integral-action classification",
        "oscar_lattice_catalogue/" => "remark/catalogue/",
        "oscar_low_rank/" => "remark/low_rank/",
        "gap_result/gap_family_numbering.md" => "remark/input/family_numbering.md",
        "gap_result/gap_family_generators.g" => "remark/input/family_generators.g",
        "gap_classification/gap_cross_symplectic_95/" => "remark/gap_checks/cross_symplectic_95/",
        "gap_classification/gap_cross_symplectic_cyclic_134_143/" => "remark/gap_checks/cyclic_134_143/",
        "gap_classification/gap_cross_symplectic_cyclic_141_150/" => "remark/gap_checks/cyclic_141_150/")
    return replace(text, "|" => "\\|", "\n" => " ")
end

function source_text(n, row)
    if n in (13, 14) && !nonempty(row,"saved_result") && nonempty(row, "candidate_saved_results")
        return "oscar/oscar_script_data.mrdi case 3 results 1-2 (unassigned to equation signs)"
    end
    raw = row["source"]
    items = raw isa Tuple || raw isa AbstractVector ? collect(raw) : [raw]
    text = join(unique(markdown.(items)), "<br>")
    if haskey(external_candidates, n)
        relative, _ = external_candidates[n]
        text *= "<br>ambient_completion/" * relative
    end
    return text
end

function evidence_text(n, row)
    if n in (13, 14) && !nonempty(row,"saved_result") && nonempty(row, "candidate_saved_results")
        return "two complete ambient candidates; row-wise action unassigned"
    elseif nonempty(row, "saved_result")
        return "saved ambient extension"
    elseif nonempty(row, "primitive_embedding")
        return "primitive embedding"
    elseif nonempty(row, "full_lattice_witness")
        return "full ambient witness; not exhaustive"
    elseif nonempty(row, "candidate_ambient_embeddings")
        return "complete ambient candidate(s); numbered assignment pending"
    elseif haskey(external_candidates, n)
        return "complete ambient candidate(s) in an external sidecar; numbered assignment pending"
    else
        return "abstract T action only; ambient data pending"
    end
end

function caution_text(n, row)
    notes = String[]
    if n in (13, 14)
        if nonempty(row,"saved_result") && haskey(row,"l27_assignment_certificate")
            push!(notes, "equation sign identified by the real-structure criterion and the integral negative eigenlattice; both complete candidates retained")
        else
            push!(notes, "the two case-3 outputs are not yet matched to the two equation signs")
        end
    elseif n == 2
        if nonempty(row, "primitive_embedding")
            push!(notes, "eight raw gluings form one root-free integral orbit; full symplectic A7 matrices are not saved")
        else
            push!(notes, "eight raw gluings are root-free; their integral orbits and the equation-labelled embedding remain unassigned")
        end
    elseif n in (33, 47)
        if nonempty(row, "saved_result")
            push!(notes, "unique eligible subgroup class and exact S/T isometry in the identified full parent; no independent global integral uniqueness claim")
        else
            push!(notes, "one character-matched root-free class in the saved full parent; geometric subgroup transport and exact high-rank S isometry remain to be audited")
        end
    elseif n in (35, 37)
        if nonempty(row, "saved_result")
            push!(notes, "the separate case-15 parent path is saved; equality across components is not asserted")
        else
            push!(notes, "component/embedding pairing remains to be checked")
        end
    elseif n == 55 && nonempty(row, "ambient_parent_paths")
        push!(notes, "both No. 56 and No. 57 ambient parent paths are retained; equality of labelled matrices is not asserted")
    elseif n in (10, 12, 15, 20) && nonempty(row,"candidate_ambient_embeddings")
        if nonempty(row,"saved_result") && haskey(row,"primitive_embedding_equivalence_source")
            push!(notes, "numbered representative assigned using classified primitive-embedding equivalence, not by candidate count; all raw representatives retained")
        else
            push!(notes, "the retained candidate count does not prove integral uniqueness or identify the geometric embedding")
        end
    elseif n in (84, 85, 107)
        push!(notes, "integral equivalence to the No. 60 representative is proved; saved class label is not the strict GAP witness label")
    elseif n == 102
        push!(notes, "assigned representative from No. 69; the alternative No. 67 path is retained without a cross-parent integral comparison")
    elseif n == 127
        if nonempty(row,"saved_result") && haskey(row,"ambient_normalization_certificate")
            push!(notes, "constructed action identified by the stable root-free action and generic-period criterion; not an exhaustive list of integral extensions; coordinate-generator conjugacy is not claimed")
        else
            push!(notes, "one verified witness, not an exhaustive list of extensions")
        end
    end
    if nonempty(row, "candidate_saved_results") && n ∉ (13, 14)
        push!(notes, "multiple complete candidate records retained")
    end
    return isempty(notes) ? "—" : markdown(join(notes, "; "))
end

counts = Dict("saved" => 0, "embedding" => 0, "witness" => 0,
    "candidate" => 0, "abstract" => 0)
open(output_path, "w") do io
    println(io, "# Provenance of the 156 numbered lattice records")
    println(io)
    println(io, "This is a mechanically generated audit of `$(basename(catalogue_path))`. The family number, rank, symplectic label, index, and geometric record follow `remark/input/family_numbering.md`. The lattice source column summarizes the saved source records and supporting sidecars for Nos. 2, 33, and 47; it is not an independent mathematical verification of every cited claim. The penultimate column distinguishes a complete ambient extension or primitive embedding from an abstract action on `T` alone.")
    println(io)
    println(io, "Family-assignment criteria are described in `remark/catalogue/family_identification_script.md` and, for No. 127, `remark/low_rank/maximal_cases/family_127_g13_full_l_postcheck.md`. Historical source labels are translated to the current computation paths; source MRDI files remain unchanged.")
    println(io)
    println(io, "In particular, an abstract `T_extra_action` does **not** determine the compatible `S` action or gluing in `Lambda_0`. To obtain a subfamily by powering a generator, power the saved ambient isometry and restrict both `S` and `T` actions together. For a changed symplectic subgroup, recompute its invariant and orthogonal lattices in the same ambient lattice.")
    println(io)
    println(io, "Here *saved ambient extension* means that the distinguished quotient generator has a compatible action on a saved primitive embedding in `Lambda_0`. It does not, by itself, mean that matrices for every symplectic group generator have been stored.")
    println(io)
    if all(n -> nonempty(rows[lpad(string(n),3,'0')],"saved_result") &&
            haskey(rows[lpad(string(n),3,'0')],"l27_assignment_certificate"),(13,14))
        println(io,"Nos. 13/14 are assigned using the real-structure criterion and an explicit integral negative-eigenlattice certificate. The two acted-on lattices differ despite their identical displayed action matrices; both full candidates remain stored.")
    else
        println(io,"The inherited No. 13/14 candidates are not assigned in this catalogue version. Their equation-sign pairing requires the real-structure criterion and a check of the integral negative eigenlattice, not just the displayed action matrix.")
    end
    println(io)
    println(io, "| No. | rank S | symplectic part | generic/full index | dim. | geometric record | recorded source of lattice/action | ambient evidence in this row | qualification |")
    println(io, "| ---: | ---: | :--- | :---: | ---: | :--- | :--- | :--- | :--- |")
    for n in 1:156
        key = lpad(string(n), 3, '0')
        haskey(rows, key) || error("Missing row $key")
        row = rows[key]
        row["number"] == n || error("Wrong row number in $key")
        nonempty(row, "T_input") || error("Missing T lattice in $key")
        (nonempty(row, "T_extra_action") ||
            n in (13, 14) && nonempty(row, "candidate_saved_results")) ||
            error("Missing T action or retained candidate pair in $key")
        kind = if n in (13, 14) && !nonempty(row,"saved_result") && nonempty(row, "candidate_saved_results")
            "candidate"
        elseif nonempty(row, "saved_result")
            "saved"
        elseif nonempty(row, "primitive_embedding")
            "embedding"
        elseif nonempty(row, "full_lattice_witness")
            "witness"
        elseif nonempty(row, "candidate_ambient_embeddings")
            "candidate"
        elseif haskey(external_candidates, n)
            "candidate"
        else
            "abstract"
        end
        counts[kind] += 1
        fields = [string(n), string(row["rank_S"]), markdown(row["symplectic_family"]),
            string(row["generic_index"], "/", row["index"]),
            string(row["dimension"]), markdown(geometric_sources[n]),
            source_text(n, row), evidence_text(n, row),
            caution_text(n, row)]
        println(io, "| ", join(fields, " | "), " |")
    end
    println(io)
    println(io, "Audit totals: $(counts["saved"]) rows with a saved ambient extension, $(counts["embedding"]) with an explicit primitive embedding, $(counts["witness"]) with another full ambient witness, $(counts["candidate"]) with unassigned complete ambient candidates, and $(counts["abstract"]) with only abstract `T`-action data. These categories describe saved evidence, not whether the corresponding geometric family is known to exist.")
end

println("Wrote ", output_path)
println("Evidence counts: ", counts)
