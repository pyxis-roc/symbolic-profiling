#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

if [[ -z "${VIRTUAL_ENV:-}" ]]; then
    [[ ! -e .venv ]] && uv venv --seed .venv
    source .venv/bin/activate
fi

OUTPUT_CSV="${1:-raw-data/user-characterize.csv}"
TVM_OPS="${REPO_ROOT}/symb_form_tests/tvm-ops"
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/symbolic-characterize.XXXXXX")"
trap 'rm -rf "${WORK_DIR}"' EXIT

mkdir -p "$(dirname "${OUTPUT_CSV}")"

PYTHONPATH="${TVM_OPS}:${TVM_OPS}/../script-link${PYTHONPATH:+:${PYTHONPATH}}" \
python - "${WORK_DIR}/optimized" <<'PY'
import os
import sys

from benchmark_simple import SpecCollection

base_dir = sys.argv[1]
for spec in SpecCollection(base_dir).get_specs():
    os.makedirs(spec.get_directory(), exist_ok=True)
    spec.generate_kernel()
PY

python "${TVM_OPS}/characterize.py" \
    "${WORK_DIR}/optimized" \
    --output_csv "${OUTPUT_CSV}"

echo "Generated characterization data at ${OUTPUT_CSV}"
