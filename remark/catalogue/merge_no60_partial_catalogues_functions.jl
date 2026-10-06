# Shared, read-only checks for merging three side-by-side No. 60 restrictions.
# This file does not run an OSCAR search or write any result.

using Oscar
using SHA

const cm_here = @__DIR__
const cm_base = joinpath(cm_here, "lattice_156_with_131_20261003.mrdi")
const cm_107 = joinpath(cm_here,
    "lattice_156_with_131_no107_candidates_20261004.mrdi")
const cm_8485 = joinpath(cm_here,
    "lattice_156_with_131_no84_85_candidates_20261004.mrdi")
const cm_input_hashes = Dict(
    basename(cm_base) =>
        "4ba9d259cfe934b8f293e23ed12514dfc5b76b9b6c511070e02cdb940a0762f7",
    basename(cm_107) =>
        "5970237bfb72ac0c5310e088685bcef73c510df4190ae87cbd910181515e38dc",
    basename(cm_8485) =>
        "d53f36a802d9731a4a9437381838c8aefeb8c67db0483504004d9b799f498b9d",
)

cm_sha(path) = bytes2hex(sha256(read(path)))
cm_key(n) = lpad(string(n), 3, '0')

function cm_check_input_files()
    for path in (cm_base, cm_107, cm_8485)
        isfile(path) || error("Missing frozen catalogue: $path")
        cm_sha(path) == cm_input_hashes[basename(path)] ||
            error("Frozen catalogue SHA-256 changed: $path")
    end
end

# Equality here means equality in the saved coordinate models, not merely
# abstract lattice isometry.  A weaker abstract test cannot authorize a
# numbered embedded S/T entry.
function cm_same(a, b)
    (a === nothing || b === nothing) && return a === b
    if a isa ZZLatWithIsom && b isa ZZLatWithIsom
        return cm_same(lattice(a), lattice(b)) &&
            isometry(a) == isometry(b)
    elseif a isa ZZLat && b isa ZZLat
        return rank(a) == rank(b) &&
            basis_matrix(a) == basis_matrix(b) &&
            gram_matrix(a) == gram_matrix(b) &&
            gram_matrix(ambient_space(a)) == gram_matrix(ambient_space(b))
    elseif a isa NamedTuple && b isa NamedTuple
        return keys(a) == keys(b) &&
            all(cm_same(getproperty(a, key), getproperty(b, key))
                for key in keys(a))
    elseif a isa AbstractDict && b isa AbstractDict
        return Set(keys(a)) == Set(keys(b)) &&
            all(cm_same(a[key], b[key]) for key in keys(a))
    elseif a isa Tuple && b isa Tuple
        return length(a) == length(b) &&
            all(cm_same(a[i], b[i]) for i in eachindex(a))
    elseif a isa AbstractArray && b isa AbstractArray
        return size(a) == size(b) &&
            all(cm_same(a[i], b[i]) for i in eachindex(a))
    else
        return a == b
    end
end

function cm_stage_paths(target)
    if target == :no107
        stem = "restriction_107_from_60"
    elseif target == :no8485
        stem = "restriction_84_85_from_60"
    else
        error("Unknown partial-catalogue target: $target")
    end
    return (joinpath(cm_here, stem * ".groups.mrdi"),
            joinpath(cm_here, stem * ".lattices.mrdi"),
            joinpath(cm_here, stem * ".verified.mrdi"))
end

function cm_source_paths(target)
    common = (
        joinpath(cm_here, "source_60_full_lattice_group.mrdi"),
        joinpath(cm_here, "..", "..", "oscar", "oscar_script_data.mrdi"),
        joinpath(cm_here, "..", "input", "family_numbering.md"),
        joinpath(cm_here, "..", "..", "gap_classification",
            "gap_fourfold_cross_dimension", "result",
            "gap_fourfold_cross_dimension_all_pairs.tsv"),
        joinpath(cm_here, "..", "..", "gap_classification",
            "gap_fourfold_cross_dimension", "input", "fourfold_156.g"),
        joinpath(cm_here, "..", "..", "gap_classification",
            "gap_fourfold_cross_dimension", "result",
            "gap_fourfold_cross_dimension_positive_edges.g"),
    )
    tail = (
        joinpath(cm_here, "prepare_no60_full_lattice_group.jl"),
        joinpath(cm_here, "enumerate_restrictions_94_95_direct.jl"),
        joinpath(cm_here, "restriction_functions.jl"),
        joinpath(cm_here, "..", "..", "oscar", "oscar_script.jl"),
    )
    if target == :no107
        special = (
            joinpath(cm_here, "restriction_107_geometric_character.g"),
            joinpath(cm_here, "restriction_107_geometric_character.tsv"),
            joinpath(cm_here, "restriction_107_from_60.jl"),
        )
        builder = joinpath(cm_here,
            "build_lattice_156_with_107_candidates.jl")
    elseif target == :no8485
        special = (
            joinpath(cm_here, "restriction_84_85_geometric_characters.g"),
            joinpath(cm_here, "restriction_84_85_geometric_characters.tsv"),
            joinpath(cm_here, "restriction_84_85_from_60.jl"),
        )
        builder = joinpath(cm_here,
            "build_lattice_156_with_84_85_candidates.jl")
    else
        error("Unknown partial-catalogue target: $target")
    end
    return (cm_base, cm_stage_paths(target)...,
            common..., special..., tail..., builder)
end

function cm_check_format(catalogue)
    catalogue["format_version"] == 1 || error("Wrong catalogue format")
    catalogue["number_order"] == Tuple(1:156) ||
        error("Wrong catalogue number order")
    rows = catalogue["rows"]
    length(rows) == 156 || error("Expected 156 numbered rows")
    Set(keys(rows)) == Set(cm_key(n) for n in 1:156) ||
        error("Wrong numbered-row keys")
end

function cm_check_partial(baseline, partial, target)
    cm_check_format(baseline)
    cm_check_format(partial)
    expected_targets = target == :no107 ? Set((107,)) : Set((84,85))
    source_paths = cm_source_paths(target)
    original_hashes = baseline["source_sha256"]
    partial_hashes = partial["source_sha256"]
    expected_names = union(Set(keys(original_hashes)),
                           Set(basename(p) for p in source_paths))
    Set(keys(partial_hashes)) == expected_names ||
        error("The $target partial has missing or unexpected source hashes")
    for (name, hash) in original_hashes
        partial_hashes[name] == hash ||
            error("A baseline source hash changed in $target: $name")
    end
    for path in source_paths
        isfile(path) || error("Missing $target source: $path")
        partial_hashes[basename(path)] == cm_sha(path) ||
            error("A $target source no longer matches its recorded hash: $path")
    end

    Set(keys(baseline)) == Set(keys(partial)) ||
        error("Unexpected top-level catalogue keys in $target")
    for key in keys(baseline)
        key in ("rows", "source_sha256") && continue
        cm_same(baseline[key], partial[key]) ||
            error("Top-level $key changed in $target")
    end
    for n in 1:156
        n in expected_targets && continue
        key = cm_key(n)
        cm_same(baseline["rows"][key], partial["rows"][key]) ||
            error("Unrelated row $n changed in $target")
    end
    for n in expected_targets
        cm_check_candidate_row(baseline["rows"][cm_key(n)],
                               partial["rows"][cm_key(n)], n)
    end
end

function cm_check_candidate_row(old, entry, n)
    old["number"] == entry["number"] == n || error("Wrong row number $n")
    old["status"] == "pending_lattice_data" ||
        error("Baseline row $n is not pending")
    for field in ("S_input", "T_input", "T_in_ambient",
                  "T_extra_action", "saved_result", "candidate_saved_results")
        get(old, field, nothing) === nothing ||
            error("Baseline row $n already has $field")
    end
    if n == 107
        entry["status"] ==
            "partial_common_ST_two_no60_candidates_unassigned" ||
            error("Unexpected No. 107 partial status")
        (entry["rank_S"], entry["dimension"], entry["index"]) ==
            (12,4,2) || error("Wrong No. 107 invariants")
    else
        entry["status"] == "partial_two_no60_candidates_unassigned" ||
            error("Unexpected No. $n partial status")
        (entry["rank_S"], entry["dimension"], entry["index"]) ==
            (14,3,2) || error("Wrong No. $n invariants")
    end
    entry["generic_index"] == 1 || error("Wrong generic index in $n")
    for field in ("T_in_ambient", "T_extra_action", "saved_result",
                  "selected_no60_parent_class")
        get(entry, field, nothing) === nothing ||
            error("No. $n already has an assigned $field")
    end
    paths = entry["no60_parent_paths"]
    results = entry["candidate_saved_results"]
    length(paths) == length(results) == 2 ||
        error("No. $n must retain both complete candidates")
    paths[1].class_number != paths[2].class_number ||
        error("No. $n duplicated a parent class")
    for i in 1:2
        path, result = paths[i], results[i]
        path.roots_verified || error("No. $n path $i lacks a root check")
        cm_same(path.result, result) ||
            error("No. $n full candidate $i differs from its verification path")
        result.parent_number == 60 || error("Wrong parent for No. $n")
        result.order == order_of_isometry(result.T_action) == 2 ||
            error("Wrong extra-action order for No. $n")
        rank(lattice(result.S_in_Lambda0)) == entry["rank_S"] ||
            error("Wrong S rank for No. $n")
        rank(lattice(result.T_in_Lambda0)) == 22-entry["rank_S"] ||
            error("Wrong T rank for No. $n")
    end
    if n == 107
        first_result, second_result = results
        cm_same(entry["S_input"], lattice(first_result.S_in_Lambda0)) &&
            cm_same(entry["S_input"], lattice(second_result.S_in_Lambda0)) ||
            error("No. 107 has no verified common embedded S")
        cm_same(entry["T_input"], lattice(first_result.T_in_Lambda0)) &&
            cm_same(entry["T_input"], lattice(second_result.T_in_Lambda0)) ||
            error("No. 107 has no verified common embedded T")
    else
        get(entry, "S_input", nothing) === nothing &&
            get(entry, "T_input", nothing) === nothing ||
            error("No. $n side-by-side source unexpectedly assigns S/T")
    end
end

function cm_common_embedded_ST(entry)
    a, b = entry["candidate_saved_results"]
    same_S = cm_same(lattice(a.S_in_Lambda0), lattice(b.S_in_Lambda0))
    same_T = cm_same(lattice(a.T_in_Lambda0), lattice(b.T_in_Lambda0))
    return same_S && same_T
end

function cm_merged_target_row(partial_row, n)
    row = copy(partial_row)
    n == 107 && return row
    if cm_common_embedded_ST(row)
        first_result = row["candidate_saved_results"][1]
        row["S_input"] = lattice(first_result.S_in_Lambda0)
        row["T_input"] = lattice(first_result.T_in_Lambda0)
        row["status"] =
            "partial_common_ST_two_no60_candidates_unassigned"
        row["note"] = "Both exact-character, root-free No. 60 paths have identical saved embedded S/T lattices. Both complete candidates are retained. Their T actions remain unassigned to this numbered row; no global integral uniqueness or independent symplectic saturation is inferred from the subgroup search."
    end
    return row
end

function cm_expected_source_map(baseline, no107, no8485, builder_path)
    result = copy(baseline["source_sha256"])
    for partial in (no107, no8485)
        for (name, hash) in partial["source_sha256"]
            if haskey(result, name)
                result[name] == hash ||
                    error("Conflicting source hash for $name")
            else
                result[name] = hash
            end
        end
    end
    for path in (cm_base, cm_107, cm_8485,
                 joinpath(cm_here, "merge_no60_partial_catalogues_functions.jl"),
                 builder_path)
        isfile(path) || error("Missing merged-catalogue source: $path")
        name, hash = basename(path), cm_sha(path)
        if haskey(result, name)
            result[name] == hash ||
                error("Conflicting merged-catalogue source hash for $name")
        else
            result[name] = hash
        end
    end
    return result
end

function cm_check_merged(baseline, no107, no8485, merged, builder_path)
    cm_check_format(merged)
    Set(keys(merged)) == Set(keys(baseline)) ||
        error("Merged catalogue has unexpected top-level keys")
    for key in keys(baseline)
        key in ("rows", "source_sha256") && continue
        cm_same(baseline[key], merged[key]) ||
            error("Merged top-level $key changed")
    end
    cm_same(merged["source_sha256"],
            cm_expected_source_map(baseline, no107, no8485, builder_path)) ||
        error("Merged source-hash map is incomplete or incorrect")
    for n in 1:156
        key = cm_key(n)
        expected = n == 107 ? no107["rows"][key] :
                   n in (84,85) ? cm_merged_target_row(no8485["rows"][key], n) :
                   baseline["rows"][key]
        cm_same(expected, merged["rows"][key]) ||
            error("Merged row $n differs from its unique authorized source")
        if n in (84,85,107)
            row = merged["rows"][key]
            length(row["candidate_saved_results"]) == 2 ||
                error("A full No. $n candidate was lost")
            all(get(row, field, nothing) === nothing for field in
                ("T_in_ambient", "T_extra_action", "saved_result",
                 "selected_no60_parent_class")) ||
                error("No. $n acquired an unproved row-wise action")
        end
    end
    known_T = count(n -> get(merged["rows"][cm_key(n)], "T_input",
                              nothing) !== nothing, 1:156)
    known_actions = count(n -> get(merged["rows"][cm_key(n)],
                                    "T_extra_action", nothing) !== nothing,
                          1:156)
    pending = count(n -> merged["rows"][cm_key(n)]["status"] ==
                         "pending_lattice_data", 1:156)
    common_8485 = count(n -> cm_common_embedded_ST(no8485["rows"][cm_key(n)]),
                        (84,85))
    known_T == 140 + common_8485 || error("Unexpected known-T count")
    known_actions == 126 || error("Unexpected assigned-action count")
    pending == 14 || error("Unexpected pending-row count")
    return (known_T=known_T, known_actions=known_actions,
            pending=pending, common_8485=common_8485)
end
