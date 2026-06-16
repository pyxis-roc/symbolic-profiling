#!/usr/bin/env bash
set -euo pipefail

[[ ! -e .venv ]] && uv venv --seed .venv
source .venv/bin/activate

./scripts/build-z3.sh
./scripts/build-tvm.sh
./scripts/build-trip_counter.sh