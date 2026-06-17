# Symbolic Profiling Top Level Repo

This repository is the top-level repository for the Symbolic Profiling project.
It is self-contained with all code required to setup environment and reproduce the symbolic profiling results.

## To Run (Development)

Currently, the following steps are necessary.

First, open this project in VSCode, and use `Dev Containers: Reopen in Container` to open in container.
This will build a Debian-based container that includes all dependencies and set up LLVM correctly.

Use `./run-all.sh` to build all dependencies and run benchmarks.

Alternatively, run `scripts/00_setup/build-all.sh` to build all additional dependencies only. 
Run `scripts/99_benchmark/run_all.sh` to run benchmarks.