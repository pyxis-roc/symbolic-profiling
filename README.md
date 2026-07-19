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
podman build --tag symbolic-image -f Containerfile .
```

All dependencies are built into the image. To run benchmarks, run the image and run benchmark script:

```
podman run --replace --rm --userns=keep-id -it --name symbolic-image symbolic-image /bin/bash
./run-all.sh
```

This will recreate the figures used in our paper. To rerun the benchmark for overhead (it will take a long time), run `./scripts/run_overhead_and_draw.sh`.

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

## Reproduce paper figures

The checked-in paper data lives in `raw-data/`:

- `raw-data/overhead_full_with_instance.csv`
- `raw-data/characterize.csv`

To draw the paper figures from those CSV files, run this inside the container:

```
./scripts/draw_figures.sh
```

By default, this writes generated figures to `figures/paper/`. The script also accepts an alternate overhead CSV and output directory:

```
./scripts/draw_figures.sh raw-data/overhead_full_with_instance.csv figures/paper
```

The characterization file is always `raw-data/characterize.csv`; users do not need to regenerate it.

## Run overhead experiment and draw new figures

To run the overhead experiment and draw figures from the newly generated data, run this inside the container:

```
./scripts/run_overhead_and_draw.sh
```

By default, this runs the full overhead experiment, writes user-generated data to `raw-data/user-overhead-full-with-instance.csv`, and writes figures to `figures/user-run/`.

For a faster validation run:

```
./scripts/run_overhead_and_draw.sh smoke
```

This writes `raw-data/user-overhead-smoke-with-instance.csv` and redraws figures in `figures/user-run/`.
