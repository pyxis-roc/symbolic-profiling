#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

if [[ -z "${VIRTUAL_ENV:-}" ]]; then
    [[ ! -e .venv ]] && uv venv --seed .venv
    source .venv/bin/activate
fi

MODE="${1:-full}"
if [[ $# -gt 0 ]]; then
    shift
fi

if [[ "${MODE}" != "full" && "${MODE}" != "smoke" ]]; then
    echo "usage: $0 [full|smoke] [run_output_dir] [figure_output_dir] [extra run args...]" >&2
    exit 2
fi

DEFAULT_RUN_DIR="raw-data/user-tvm-${MODE}-conv2d-512-c64-3methods"
RUN_OUTPUT_DIR="${1:-${DEFAULT_RUN_DIR}}"
if [[ $# -gt 0 ]]; then
    shift
fi

FIGURE_OUTPUT_DIR="${1:-figures/user-run/tvm-comparison}"
if [[ $# -gt 0 ]]; then
    shift
fi

if [[ "${MODE}" == "smoke" ]]; then
    SEEDS="0"
    TRIALS="16"
else
    SEEDS="0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29"
    TRIALS="300"
fi

mkdir -p "${RUN_OUTPUT_DIR}" "${FIGURE_OUTPUT_DIR}"

PYTHONPATH="${REPO_ROOT}/tvm-comparison${PYTHONPATH:+:${PYTHONPATH}}" \
python -m tvm_symbolic_autotune.run_comparison \
    --mode "${MODE}" \
    --output-dir "${RUN_OUTPUT_DIR}" \
    --methods random,xgb-default,xgb-symbolic-only \
    --seeds "${SEEDS}" \
    --trials "${TRIALS}" \
    --num-trials-per-iter 16 \
    --population-size 64 \
    --target "llvm -mcpu=generic" \
    "$@"

"${SCRIPT_DIR}/draw_tvm_figures.sh" "${RUN_OUTPUT_DIR}" "${FIGURE_OUTPUT_DIR}"

echo "Generated user TVM data at ${RUN_OUTPUT_DIR}"
echo "Generated user TVM figures in ${FIGURE_OUTPUT_DIR}"
