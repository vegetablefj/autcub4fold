# Mechanical normalization, structural audit, and source table in one process.
# No lattice-action, group, root, gluing, or saturation enumeration is run.

const fs_here = @__DIR__
const fs_input = normpath(joinpath(fs_here,"..","lattice_156_complete_ambient_20261004.mrdi"))
const fs_output = normpath(joinpath(fs_here,"..","lattice_156_standard_ambient_20261004.mrdi"))
const fs_receipt = joinpath(fs_here,"complete_156_ambient_structural_v3_20261004")

include(joinpath(fs_here,"normalize_rank0_ambient_fields.jl"))
println("Normalizing legacy rank-zero fields without changing the saved actions")
flush(stdout)
nr_main(fs_input,fs_output)
GC.gc(true)

# The auditor's entry point reads ARGS. Include it only after the fresh
# normalized catalogue has passed its independent save/reload comparison.
empty!(ARGS)
append!(ARGS,[fs_output,fs_receipt])
include(joinpath(fs_here,"verify_complete_156_ambient.jl"))
GC.gc(true)

# Source-table generation is reached only after a successful 156-row audit.
empty!(ARGS)
append!(ARGS,[fs_output,joinpath(fs_here,"family_156_sources_current.md")])
include(joinpath(fs_here,"generate_family_sources.jl"))
println("PASS: standard 156-row catalogue, structural receipt, and source table")
flush(stdout)
