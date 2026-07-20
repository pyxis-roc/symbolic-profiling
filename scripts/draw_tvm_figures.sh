#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

if [[ -z "${VIRTUAL_ENV:-}" ]]; then
    [[ ! -e .venv ]] && uv venv --seed .venv
    source .venv/bin/activate
fi

DEFAULT_INPUT_DIR="raw-data/tvm-conv2d-512-c64-30seed-300trial-pop64-3methods"
INPUT_DIR="${1:-${DEFAULT_INPUT_DIR}}"
if [[ $# -gt 0 ]]; then
    shift
fi

OUTPUT_DIR="${1:-figures/paper/tvm-comparison}"
if [[ $# -gt 0 ]]; then
    shift
fi

mkdir -p "${OUTPUT_DIR}"

PYTHONPATH="${REPO_ROOT}/tvm-comparison${PYTHONPATH:+:${PYTHONPATH}}" \
python "${REPO_ROOT}/tvm-comparison/scripts/generate_artifact_figures.py" \
    --input "${INPUT_DIR}" \
    --output-dir "${OUTPUT_DIR}" \
    "$@"

echo "Generated TVM figures in ${OUTPUT_DIR}"
