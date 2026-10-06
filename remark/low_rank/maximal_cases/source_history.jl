# Known source migration for verifying preserved snapshots.
# Historical fingerprints are accepted only for the exact retained source
# below at its pinned current normalized digest. New fingerprints match bytes.
using SHA

if !isdefined(@__MODULE__, :lowrank_saved_source_sha_matches)
    const lowrank_source_migrations = Dict(
        "maximal_family_data.jl" => (
            current = "7525326c23c1bfef84e9d2d1a4e23329b74652e001e464d811674269cf0cf887",
            recorded = ("5172183333cb889577bf83225317372c4e87136d9bb28ec7eabb56ea81458307", "f66f3886ab6e5273d77077381187058938499e32508bc2afdaaba0913985267e",),
        ),
        "oscar_1_8_public_extensions.jl" => (
            current = "c657edec062305a53bec564141799eaf005ae326b4bef34a22e49093891950e9",
            recorded = ("79b93447c8d5239760c4084188fab448dc67851aa9c4e50106fe5306af2182b5", "04758d6a2b3400ffc72b92a6f1018da768acd3be3a8fb456be1e0fef24ba175f",),
        ),
        "run_family_096_phi24.jl" => (
            current = "33319e73ce8a65acf7cef7f4edfe57ccf73821cdfd21b3597b4057f31b6ea8ec",
            recorded = ("1f1fb506e4608fa9907783c8cb33dd5e616fda2b82c801fdb97d3fcb3d2232a3", "6884cb624b85cfa3ab09b14cdee4c553533a82b205ee439b28f378ded978ca16",),
        ),
        "run_family_152_phi16_brown.jl" => (
            current = "b2b04698d603a05b3c7536eed7dcac89fa0b95bdff58f69e546014dee979be1d",
            recorded = ("6e4582ca68007463f8a8f933bb387d02a1840cbe31a1c412168da78057183e96", "a703785403e8df316e7a4eec184e03a313e443862ad8a8f97c46e8d13c782c9f",),
        ),
        "run_family_154_phi24_brown.jl" => (
            current = "8eda5e4e9566386166db04fa2aba7ab6fa7bd5c5697ad32b799ff3a886adfd05",
            recorded = ("62e50b091f5d7515e576e95ee24660c5d7a0fd45ae044f681d315726bd602759", "610d15f491dffd91c0fc53e9085fed9774b31f468a941c24b14855ce70d2da66",),
        ),
        "run_family_155_phi32.jl" => (
            current = "0f00015c433f4e4c02076d622627f8a7f11dd62d0a0a35078d253fdc6b42a4c1",
            recorded = ("5034722929c930c1a976f7aa53a7cc3ed44335b979dfd1915ae72b80d092b925", "4c45c82339ae20532c052e6b29610ae8f86022a99411c9a5a9c217582f4d90b6",),
        ),
        "run_family_156_phi48_brown.jl" => (
            current = "cd8ca569551b1bc6afa66339f1450d7f23e4a37416014d9f99e841bdb10866e4",
            recorded = ("e8177dcbc253fd120c3262d9c687f7fb9a61c3cc89f3994d7b90e031abebed3a", "9be7ae2becb3fb27292734cd69b622721fd59dbd2d90d678fcb869da5cc15a59",),
        ),
        "run_family_156_phi48.jl" => (
            current = "8d3f85eb0f7661be952ab9e7a39746329353f33dbae9c665d4d58215e8320e1e",
            recorded = ("78b2294494dc3ed66a35c62ff6e04594f58ee6704af22f0fb02cfd9fc9a53d05", "c6a8a1fe732fb7b31b6d7130651d6b70da62b6ad4290320cd43dddaacee5dd94",),
        ),
    )

    function lowrank_saved_source_sha_matches(recorded, path)
        raw = read(path)
        bytes2hex(sha256(raw)) == recorded && return true
        normalized_path = abspath(path)
        normalized_path == abspath(joinpath(@__DIR__, basename(path))) || return false
        migration = get(lowrank_source_migrations, basename(path), nothing)
        migration === nothing && return false
        recorded in migration.recorded || return false
        source = replace(String(raw), "\r\n" => "\n")
        return bytes2hex(sha256(Vector{UInt8}(codeunits(source)))) == migration.current
    end
end
