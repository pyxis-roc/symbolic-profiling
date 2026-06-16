#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${VIRTUAL_ENV:-}" ]]; then
    [[ ! -e .venv ]] && uv venv --seed .venv
    source .venv/bin/activate
fi

pushd trip_counter

rm -rf build && mkdir -pv build
cmake -GNinja -DCMAKE_BUILD_TYPE=RelWithDebInfo -S . -B build
cmake --build build

popd