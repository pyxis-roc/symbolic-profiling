#!/usr/bin/env bash
set -euo pipefail

PREFIX=$PWD/.venv

if [[ -z "${VIRTUAL_ENV:-}" ]]; then
    [[ ! -e .venv ]] && uv venv --seed .venv
    source .venv/bin/activate
fi

uv pip install pytest numpy cython tornado psutil 'xgboost>=1.1.0' cloudpickle

cmake -E rm -rf vendor/tvm/build
cmake -E make_directory vendor/tvm/build
cp vendor/tvm/cmake/config.cmake vendor/tvm/build/config.cmake
cat >> vendor/tvm/build/config.cmake <<EOF
set(CMAKE_BUILD_TYPE RelWithDebInfo)
set(USE_LLVM "llvm-config --ignore-libllvm --link-static")
set(HIDE_PRIVATE_SYMBOLS ON)
set(USE_CUDA   OFF)
set(USE_METAL   OFF)
set(USE_VULKAN   OFF)
set(USE_OPENCL   OFF)
set(USE_CUBLAS   OFF)
set(USE_CUDNN   OFF)
set(USE_CUTLASS   OFF)
EOF
cmake -S vendor/tvm -B vendor/tvm/build -GNinja
cmake --build vendor/tvm/build --parallel "$(nproc)"
pushd vendor/tvm/3rdparty/tvm-ffi; uv pip install .; popd
pushd vendor/tvm; uv pip install .; popd
