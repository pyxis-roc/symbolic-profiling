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
git submodule update --init --recursive
podman build -t symbolic-image
```

Then to run the image:

```
podman run -it --rm -v `pwd`:/workspaces/symbolic-profiling:U symbolic-image /bin/bash
```

Note that `podman run` _might_ change the owner and group IDs on the
files depending on how it is set up. The following command, executed
outside the stopped container, in the `symbolic-profiling` directory
should restore permissions:

```
podman unshare chown -R 0:0 .
```

## Build and run from VSCode

First, open this project in VSCode, and use `Dev Containers: Reopen in Container` to open in container.
This will build a Debian-based container that includes all dependencies and set up LLVM correctly.


## Inside the container

Once a container has been setup using either podman or VSCode, run the following commands inside it.

```
./run-all.sh
```

Alternatively, run `scripts/00_setup/build-all.sh` to build all additional dependencies only.
Run `scripts/99_benchmark/run_all.sh` to run benchmarks.
