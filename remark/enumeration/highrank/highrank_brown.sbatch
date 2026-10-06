#!/usr/bin/env bash
# Submit from the repository root with
# sbatch --export=ALL,HIGH_NUMBER=9 remark/enumeration/highrank/highrank_brown.sbatch
# One numbered case per job; no old MRDI is opened for writing.
#SBATCH --job-name=highrank-ambient
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=24:00:00
#SBATCH --output=highrank-%j.out
#SBATCH --error=highrank-%j.err

set -euo pipefail

case "${HIGH_NUMBER:-}" in
    1|3|4|7|8|9|11|16|19|34) ;;
    *) printf 'Set HIGH_NUMBER to 1,3,4,7,8,9,11,16,19, or 34.\n' >&2; exit 2 ;;
esac

bundle_root="${SLURM_SUBMIT_DIR:?Submit from the repository root}"
stage="$bundle_root/remark/enumeration/highrank"
runner="$stage/run_prescribed_ambient.jl"
verifier="$stage/verify_prescribed_ambient.jl"
key="$(printf '%03d' "$HIGH_NUMBER")"
output="$bundle_root/results/highrank/job_${SLURM_JOB_ID:-manual}/family_${key}.mrdi"
project="${OSCAR_JULIA_PROJECT:-$HOME/oscar-julia-test}"

for required in "$runner" "$verifier" "$stage/specs.jl" \
    "$stage/cached_plain_side_groups.jl" \
    "$bundle_root/oscar/oscar_script.jl" "$bundle_root/oscar/input.jl" \
    "$bundle_root/oscar/list_S.txt" \
    "$bundle_root/remark/input/family_numbering.md" \
    "$project/Project.toml" "$project/Manifest.toml"; do
    test -f "$required" || { printf 'Missing input: %s\n' "$required" >&2; exit 2; }
done
test ! -e "$output" || { printf 'Refusing existing output: %s\n' "$output" >&2; exit 2; }
mkdir -p "$(dirname "$output")"
printf 'PENDING\n' > "$(dirname "$output")/postcheck.status.txt"

module load julia/1.12.4s-adme
export JULIA_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
export JULIA_NUM_PRECOMPILE_TASKS=1

printf 'family=%s job=%s host=%s started=%s\n' \
    "$HIGH_NUMBER" "${SLURM_JOB_ID:-unknown}" "$(hostname)" \
    "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
julia --startup-file=no --project="$project" \
    "$runner" "$HIGH_NUMBER" --check-config
julia --startup-file=no --project="$project" \
    "$runner" "$HIGH_NUMBER" "$output"
julia --startup-file=no --project="$project" \
    "$verifier" "$HIGH_NUMBER" "$output"
printf 'PASSED\n' > "$(dirname "$output")/postcheck.status.txt"
printf 'family=%s verified=%s output=%s\n' \
    "$HIGH_NUMBER" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$output"
