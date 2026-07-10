#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

if [[ -z "${VIRTUAL_ENV:-}" ]]; then
    [[ ! -e .venv ]] && uv venv --seed .venv
    source .venv/bin/activate
fi

TVM_OPS="${REPO_ROOT}/symb_form_tests/tvm-ops"
OVERHEAD_CSV="${1:-raw-data/overhead_full_with_instance.csv}"
OUTPUT_DIR="${2:-figures/paper}"
CHARACTERIZE_CSV="raw-data/characterize.csv"

mkdir -p "${OUTPUT_DIR}"

python "${TVM_OPS}/exec_overhead.py" \
    "${OVERHEAD_CSV}" \
    --characterize-file "${CHARACTERIZE_CSV}" \
    --output-base "${OUTPUT_DIR}/all-exec"

python "${TVM_OPS}/init_overhead.py" \
    "${OVERHEAD_CSV}" \
    "${CHARACTERIZE_CSV}" \
    --output "${OUTPUT_DIR}/all-init-with-line-matplotlib.pdf"

python "${TVM_OPS}/speedup_show.py" \
    "${OVERHEAD_CSV}" \
    --output "${OUTPUT_DIR}/speedup.pdf"

python "${TVM_OPS}/speedup_range.py" \
    "${OVERHEAD_CSV}" \
    --output "${OUTPUT_DIR}/speedup-range.txt"

echo "Generated figures in ${OUTPUT_DIR}"
