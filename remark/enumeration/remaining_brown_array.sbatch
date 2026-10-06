#!/usr/bin/env bash
# Submit once from the repository root. The two already submitted
# pilot cases (high-rank 9 and cyclic 155) are intentionally excluded.
# Each array element runs one of the existing checked per-family launchers.
#SBATCH --job-name=remark-rerun
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=24:00:00
#SBATCH --array=0-11%2
#SBATCH --output=remark-rerun-%A_%a.out
#SBATCH --error=remark-rerun-%A_%a.err

set -euo pipefail

bundle_root="${SLURM_SUBMIT_DIR:?Submit from the repository root}"
task="${SLURM_ARRAY_TASK_ID:?Submit as a Slurm array}"

case "$task" in
    0) kind=highrank; number=1 ;;
    1) kind=highrank; number=3 ;;
    2) kind=highrank; number=4 ;;
    3) kind=highrank; number=7 ;;
    4) kind=highrank; number=8 ;;
    5) kind=highrank; number=11 ;;
    6) kind=highrank; number=16 ;;
    7) kind=highrank; number=19 ;;
    8) kind=highrank; number=34 ;;
    9) kind=cyclic; number=152 ;;
    10) kind=cyclic; number=154 ;;
    11) kind=cyclic; number=156 ;;
    *) printf 'Unexpected array task: %s\n' "$task" >&2; exit 2 ;;
esac

printf 'array=%s task=%s kind=%s family=%s\n' \
    "${SLURM_ARRAY_JOB_ID:-unknown}" "$task" "$kind" "$number"

if [[ "${REMARK_ARRAY_DRY_RUN:-0}" == 1 ]]; then
    exit 0
fi

if [[ "$kind" == highrank ]]; then
    export HIGH_NUMBER="$number"
    source "$bundle_root/remark/enumeration/highrank/highrank_brown.sbatch"
else
    export FAMILY="$number"
    source "$bundle_root/remark/enumeration/maximal/cyclic_s0_brown.sbatch"
fi
