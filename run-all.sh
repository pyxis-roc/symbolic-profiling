#!/usr/bin/env bash
set -euo pipefail

./scripts/99_benchmark/run_all.sh
./scripts/draw_figures.sh
./scripts/draw_tvm_figures.sh
