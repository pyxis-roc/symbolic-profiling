#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${VIRTUAL_ENV:-}" ]]; then
    [[ ! -e .venv ]] && uv venv --seed .venv
    source .venv/bin/activate
fi

TVM_OPS="${PWD}/symb_form_tests/tvm-ops"

WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/symbolic-benchmark.XXXXXX")"
trap 'rm -rf "${WORK_DIR}"' EXIT

pushd "${WORK_DIR}" >/dev/null
python "$TVM_OPS/benchmark.py"
popd >/dev/null
