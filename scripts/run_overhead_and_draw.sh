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

DEFAULT_OVERHEAD_CSV="raw-data/user-overhead-${MODE}-with-instance.csv"
OVERHEAD_CSV="${1:-${DEFAULT_OVERHEAD_CSV}}"
if [[ $# -gt 0 ]]; then
    shift
fi

OUTPUT_DIR="${1:-figures/user-run}"
if [[ $# -gt 0 ]]; then
    shift
fi

TVM_OPS="${REPO_ROOT}/symb_form_tests/tvm-ops"
mkdir -p "$(dirname "${OVERHEAD_CSV}")"

if [[ "${OVERHEAD_CSV}" = /* ]]; then
    OVERHEAD_OUTPUT="${OVERHEAD_CSV}"
else
    OVERHEAD_OUTPUT="${REPO_ROOT}/${OVERHEAD_CSV}"
fi

pushd "${TVM_OPS}" >/dev/null
python overhead.py "${MODE}" --output "${OVERHEAD_OUTPUT}" "$@"
popd >/dev/null

"${SCRIPT_DIR}/draw_figures.sh" "${OVERHEAD_CSV}" "${OUTPUT_DIR}"

echo "Generated user overhead data at ${OVERHEAD_CSV}"
echo "Generated user figures in ${OUTPUT_DIR}"
