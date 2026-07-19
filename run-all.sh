#!/usr/bin/env bash
set -euo pipefail

./scripts/99_benchmark/run_all.sh
./scripts/draw_figures.sh
