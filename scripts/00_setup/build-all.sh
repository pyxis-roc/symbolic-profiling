#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${VIRTUAL_ENV:-}" ]]; then
    [[ ! -e .venv ]] && uv venv --seed .venv
    source .venv/bin/activate
fi

./scripts/setup/build-z3.sh
./scripts/setup/build-tvm.sh
./scripts/setup/build-instrGen.sh
./scripts/setup/build-getBBCount.sh
./scripts/setup/build-trip_counter.sh