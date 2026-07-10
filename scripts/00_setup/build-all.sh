#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${VIRTUAL_ENV:-}" ]]; then
    [[ ! -e .venv ]] && uv venv --seed .venv
    source .venv/bin/activate
fi

uv pip install matplotlib mizani pandas plotnine polars pyarrow

./scripts/00_setup/build-z3.sh
./scripts/00_setup/build-tvm.sh
./scripts/00_setup/build-instrGen.sh
./scripts/00_setup/build-getBBCount.sh
./scripts/00_setup/build-trip_counter.sh
