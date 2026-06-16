#!/usr/bin/env bash
set -euo pipefail

PREFIX=$PWD/.venv

[[ ! -e .venv ]] && uv venv --seed .venv
source .venv/bin/activate

pushd vendor/z3

git clean -fx src
[[ -d build ]] && rm -rf build
mkdir build
cmake -GNinja -DCMAKE_BUILD_TYPE=RelWithDebInfo --install-prefix "$PREFIX" -S . -B build
cmake --build build
cmake --install build
popd