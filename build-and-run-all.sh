#!/usr/bin/env bash
set -euo pipefail

./scripts/00_setup/build-all.sh
./scripts/99_benchmark/run_all.sh
./scripts/run_overhead_and_draw.sh
