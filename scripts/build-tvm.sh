#!/usr/bin/env bash
set -euo pipefail

PREFIX=$PWD/.venv

[[ ! -e .venv ]] && uv venv --seed .venv
source .venv/bin/activate

uv pip install pytest numpy cython tornado psutil 'xgboost>=1.1.0' cloudpickle

cmake -E rm -rf vendor/tvm/build
cmake -E make_directory vendor/tvm/build
cp vendor/tvm/cmake/config.cmake vendor/tvm/build/config.cmake
{
    printf 'set(CMAKE_BUILD_TYPE RelWithDebInfo)\n'
    printf 'set(USE_LLVM "llvm-config --ignore-libllvm --link-static")\n'
    printf 'set(HIDE_PRIVATE_SYMBOLS ON)\n'
    printf 'set(USE_CUDA   OFF)\n'
    printf 'set(USE_METAL   OFF)\n'
    printf 'set(USE_VULKAN   OFF)\n'
    printf 'set(USE_OPENCL   OFF)\n'
    printf 'set(USE_CUBLAS   OFF)\n'
    printf 'set(USE_CUDNN   OFF)\n'
    printf 'set(USE_CUTLASS   OFF)\n'
} >> vendor/tvm/build/config.cmake
cmake -S vendor/tvm -B vendor/tvm/build -GNinja
cmake --build vendor/tvm/build --parallel "$(nproc)"
pushd vendor/tvm/3rdparty/tvm-ffi; python3 -m pip install .; popd
pushd vendor/tvm; python3 -m pip install .; popd
