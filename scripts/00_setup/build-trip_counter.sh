#!/usr/bin/env bash
set -euo pipefail

PREFIX="$PWD/.venv"

if [[ -z "${VIRTUAL_ENV:-}" ]]; then
    [[ ! -e .venv ]] && uv venv --seed .venv
    source .venv/bin/activate
fi

pushd trip_counter

rm -rf build && mkdir -pv build
cmake -GNinja -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLLVM_DIR="$(llvm-config-22 --cmakedir)" -S . -B build
cmake --build build
cmake --install build --prefix "$PREFIX"

popd