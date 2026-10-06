# Put the six low-rank maximal examples into the lattice-data field scheme of
# the ambient-lattice catalogue. Read existing results only; no isometry search is run.

using Oscar
using SHA

const catalogue_dir = @__DIR__
const maximal_dir = normpath(joinpath(catalogue_dir, "..", "low_rank", "maximal_cases"))
const output_path = isempty(ARGS) ? joinpath(catalogue_dir, "maximal_six_standard.mrdi") : abspath(ARGS[1])
const index_path = joinpath(maximal_dir, "maximal_lattice_action_index.json")
const index_json = Oscar.JSON.parse(read(index_path, String))
@assert index_json["schema"] == "maximal-lattice-action-index-v1"
const indexed_families = Dict(item["number"] => item for item in index_json["families"])

include(joinpath(catalogue_dir, "..", "..", "oscar", "oscar_script.jl"))
include(joinpath(catalogue_dir, "normalize_lattice_096.jl"))
include(joinpath(catalogue_dir, "normalize_lattice_127.jl"))
include(joinpath(catalogue_dir, "normalize_trivial_symplectic_maximal.jl"))

const source_paths = Dict(
    96 => "family_096_phi24_oscar18.mrdi",
    152 => "brown_results/family_152_phi16_brown_oscar18.mrdi",
    154 => "brown_results/family_154_phi24_brown_oscar18.mrdi",
    155 => "family_155_phi32_oscar18.mrdi",
    156 => "brown_results/family_156_phi48_brown_oscar18.mrdi",
)
const expectations = Dict(
    96 => (rank_S=14, index=24, dimension=0, rank_P=8),
    127 => (rank_S=8, index=4, dimension=4, rank_P=10),
    152 => (rank_S=0, index=16, dimension=1, rank_P=16),
    154 => (rank_S=0, index=24, dimension=1, rank_P=16),
    155 => (rank_S=0, index=32, dimension=0, rank_P=16),
    156 => (rank_S=0, index=48, dimension=0, rank_P=16),
)
const number_order = (96, 127, 152, 154, 155, 156)
key(n) = lpad(string(n), 3, '0')
digest(path) = bytes2hex(sha256(read(path)))

function check_source(number, rel, path, snapshot, selected)
    indexed = indexed_families[number]
    @assert indexed["mrdi"] == rel
    @assert digest(path) == indexed["mrdi_sha256"]
    @assert indexed["selected_output"] == selected
    @assert snapshot.family_number == number
    @assert snapshot.number_of_results == indexed["retained_outputs"] == length(snapshot.results)
    @assert (number == 96 ? snapshot.tested_order : snapshot.order) == expectations[number].index
    @assert snapshot.characteristic_polynomial == Dict(
        96 => "Phi24",
        152 => "Phi1^2 Phi2^2 Phi4 Phi16^2",
        154 => "Phi3 Phi12 Phi24^2",
        155 => "Phi1 Phi2 Phi8 Phi32",
        156 => "Phi3 Phi12 Phi48",
    )[number]
    return true
end

function validate_record(number, record)
    expected = expectations[number]
    data = record.data
    @assert data.order == expected.index
    @assert data.dimension == expected.dimension
    @assert rank(lattice(data.Lambda0)) == 22
    @assert rank(lattice(data.S_in_Lambda0)) == expected.rank_S
    @assert rank(lattice(data.T_in_Lambda0)) == 22 - expected.rank_S
    @assert rank(lattice(data.T_action)) == 22 - expected.rank_S
    @assert order_of_isometry(data.Lambda0) == expected.index
    @assert order_of_isometry(data.T_action) == expected.index
    @assert rank(data.P_in_Lambda0) == expected.rank_P
    @assert rank(data.K_in_Lambda0) == 22 - expected.rank_P
    @assert order_of_isometry(data.P_action) == expected.index
    @assert signature_tuple(lattice(data.Lambda0)) == (20, 0, 2)
    @assert abs(det(gram_matrix(lattice(data.Lambda0)))) == 3
    return true
end

records = Dict{String, Any}()
source_hashes = Dict{String, String}()

println("Reading No. 96 exact-character output")
flush(stdout)
path96 = joinpath(maximal_dir, source_paths[96])
snapshot96 = load(path96)
@assert check_source(96, source_paths[96], path96, snapshot96, 1)
records[key(96)] = Maximal096Normalization.normalize_maximal_096(snapshot96)
source_hashes[source_paths[96]] = digest(path96)

println("Reconstructing No. 127 from its saved full-lattice witness")
flush(stdout)
records[key(127)] = Maximal127Normalization.normalize_maximal_127()
source_hashes[Maximal127Normalization.SOURCE_RELATIVE_PATH] =
    Maximal127Normalization.SOURCE_SHA256

for number in (152, 154, 155, 156)
    rel = source_paths[number]
    println("Reading No. $number selected exact-character output")
    flush(stdout)
    path = joinpath(maximal_dir, rel)
    snapshot = load(path)
    selected = trivial_symplectic_maximal_source(number).source_result_index
    @assert check_source(number, rel, path, snapshot, selected)
    @assert 1 <= selected <= length(snapshot.results)
    records[key(number)] = normalize_trivial_symplectic_maximal(
        snapshot.results[selected], number,
    )
    source_hashes[rel] = digest(path)
end

for number in number_order
    @assert validate_record(number, records[key(number)])
end

catalogue = Dict{String, Any}(
    "format_version" => 1,
    "description" => "Six low-rank maximal lattice actions in the standard ambient data scheme",
    "julia_version" => string(VERSION),
    "oscar_version" => string(pkgversion(Oscar)),
    "number_order" => number_order,
    "records" => records,
    "source_sha256" => source_hashes,
    "source_index_sha256" => digest(index_path),
    "scope" => "Five completed exact-character searches and one constructive No. 127 witness; no new enumeration",
)

isfile(output_path) && error("Output already exists: $output_path")
staging = output_path * ".building.mrdi"
isfile(staging) && error("Staging file already exists: $staging")
println("Saving normalized data")
flush(stdout)
save(staging, catalogue)
reloaded = load(staging)
@assert reloaded["number_order"] == number_order
@assert length(reloaded["records"]) == 6
for number in number_order
    @assert validate_record(number, reloaded["records"][key(number)])
end
mv(staging, output_path; force=false)
println("Saved and reloaded: $output_path")
