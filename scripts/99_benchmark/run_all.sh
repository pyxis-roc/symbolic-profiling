#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${VIRTUAL_ENV:-}" ]]; then
    [[ ! -e .venv ]] && uv venv --seed .venv
    source .venv/bin/activate
fi

TVM_OPS="${PWD}/symb_form_tests/tvm-ops"

mkdir -pv results
pushd results
python "$TVM_OPS/benchmark.py"
popd