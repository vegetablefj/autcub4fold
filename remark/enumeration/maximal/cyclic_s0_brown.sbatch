#!/usr/bin/env bash
#SBATCH --job-name=cyclic-s0
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=24:00:00
#SBATCH --output=cyclic-s0-%j.out
#SBATCH --error=cyclic-s0-%j.err

set -euo pipefail

case "${FAMILY:-}" in
    152) order=16 ;;
    154) order=24 ;;
    155) order=32 ;;
    156) order=48 ;;
    *) printf 'Submit with --export=ALL,FAMILY=152|154|155|156\n' >&2; exit 2 ;;
esac

bundle_root="${SLURM_SUBMIT_DIR:?Submit from the repository root}"
runner="$bundle_root/remark/enumeration/maximal/run_cyclic_s0_family.jl"
output_dir="$bundle_root/results/cyclic_s0/family_${FAMILY}/job_${SLURM_JOB_ID:-manual}"
project="${OSCAR_JULIA_PROJECT:-$HOME/oscar-julia-test}"
test -f "$runner" || { printf 'Missing runner: %s\n' "$runner" >&2; exit 2; }
test -f "$bundle_root/oscar/oscar_script.jl" || { printf 'Missing shared OSCAR functions\n' >&2; exit 2; }
test -f "$project/Project.toml" && test -f "$project/Manifest.toml" || {
    printf 'Missing Julia project or manifest in %s\n' "$project" >&2; exit 2;
}
test ! -e "$output_dir" || { printf 'Refusing existing output: %s\n' "$output_dir" >&2; exit 2; }
mkdir -p "$output_dir"
printf 'PENDING\n' > "$output_dir/postcheck.status.txt"

module load julia/1.12.4s-adme
export JULIA_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
export JULIA_NUM_PRECOMPILE_TASKS=1

printf 'family=%s job=%s host=%s started=%s\n' \
    "$FAMILY" "${SLURM_JOB_ID:-unknown}" "$(hostname)" "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
julia --startup-file=no --project="$project" \
    "$runner" --check-config
julia --startup-file=no --project="$project" \
    "$runner" "$FAMILY" "$output_dir"
python3 "$bundle_root/remark/enumeration/maximal/check_negative_eigenpairs.py" \
    "$output_dir/family_${FAMILY}_phi${order}_shared_oscar18.mrdi"
printf 'PASSED\n' > "$output_dir/postcheck.status.txt"
printf 'family=%s verified=%s output=%s\n' \
    "$FAMILY" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$output_dir"
