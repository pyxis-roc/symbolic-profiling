# Symbolic Profiling Top Level Repo

This repository is the top-level repository for the Symbolic Profiling project.
It is self-contained with all code required to setup environment and reproduce the symbolic profiling results.

## Checkout this repository

```
git clone https://github.com/pyxis-roc/symbolic-profiling
```

## Build a container image using Podman

Alternatively, you can also use VSCode, see below. Make sure your
temporary directory has plenty of space.

```
cd symbolic-profiling
podman build -t symbolic-image
```

TODO: Instructions for running the image.

## Build and run from VSCode

First, open this project in VSCode, and use `Dev Containers: Reopen in Container` to open in container.
This will build a Debian-based container that includes all dependencies and set up LLVM correctly.


## Inside the container

Once a container has been setup using either podman or VSCode, run the following commands inside it.

`git submodule update --init --recursive`

Use `./run-all.sh` to build all dependencies and run benchmarks.

Alternatively, run `scripts/00_setup/build-all.sh` to build all additional dependencies only.
Run `scripts/99_benchmark/run_all.sh` to run benchmarks.
