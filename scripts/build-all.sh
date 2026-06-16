#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${VIRTUAL_ENV:-}" ]]; then
    [[ ! -e .venv ]] && uv venv --seed .venv
    source .venv/bin/activate
fi

./scripts/build-z3.sh
./scripts/build-tvm.sh
./scripts/build-trip_counter.sh