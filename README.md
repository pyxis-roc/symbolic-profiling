# Symbolic Profiling Top Level Repo

This repository is the top-level repository for the Symbolic Profiling project.
It is self-contained with all code required to setup environment and reproduce the symbolic profiling results.

The authors' code in this artifact is distributed under the [MIT License](LICENSE).
Third-party components retain their own licenses.

The prepared container artifact targets Linux on the AMD64 architecture. On
other architectures, use a remote AMD64 machine or an AMD64 virtual machine.

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

This will recreate the figures used in our paper with data checked into this repository.
To rerun the benchmark for overhead (it will take 2-3h), run `./scripts/run_overhead_and_draw.sh`.

Note that `podman run` _might_ change the owner and group IDs on the
files depending on how it is set up. The following command, executed
outside the stopped container, in the `symbolic-profiling` directory
should restore permissions:

```
podman unshare chown -R 0:0 .
```

## Build a container image using Docker

Make sure your temporary directory and Docker storage directory have plenty of
space. This repository's build context is large because it includes the vendored
submodules.

```
cd symbolic-profiling
git submodule update --init --recursive
docker build --network=host \
  --build-arg USER_UID="$(id -u)" \
  --build-arg USER_GID="$(id -g)" \
  --tag symbolic-image -f Containerfile .
```

The complete build-and-package command used for the downloadable artifact is
also provided as a script. It builds the image, verifies its architecture,
exports a gzip-compressed image archive, and writes its SHA-256 checksum:

```
./scripts/build_docker_artifact.sh
```

The default outputs are `symbolic-image-linux-amd64.tar.gz` and
`symbolic-image-linux-amd64.tar.gz.sha256`. Optional image-tag and archive-path
arguments may be passed in that order.

The `--network=host` option is not part of the Podman command, but it is useful
on Docker installations where bridge networking is unavailable or restricted
during image builds. If Docker bridge networking works on your machine, the same
build can be run without `--network=host`.

All dependencies are built into the image. To run the artifact validation script
directly:

```
docker run --rm --network=host symbolic-image ./run-all.sh
```

To start an interactive shell instead:

```
docker rm -f symbolic-container 2>/dev/null || true
docker run --rm --network=host -it --name symbolic-container symbolic-image /bin/bash
./run-all.sh
```

Docker does not have Podman's `--replace` option; remove any old named container
with `docker rm -f symbolic-container` before reusing the same name.

## Run on a CloudLab AMD64 machine

If a local Linux AMD64 machine is unavailable, create a one-node CloudLab
experiment using the `small-lan` profile, Ubuntu 24.04, and an AMD64 physical
node such as Emulab `d430`. In Advanced Options, mount a 200 GB temporary file
system at `/mydata`. After connecting over SSH:

```
df -h /mydata
sudo chmod 1777 /mydata
sudo apt update
sudo apt install -y podman
mkdir -p /mydata/tmp
cd /mydata
TMPDIR=/mydata/tmp podman load -i symbolic-image-linux-amd64.tar.gz
podman run --rm --network=host symbolic-image ./run-all.sh
```

The separate volume is important because importing the image may temporarily
consume up to 90 GB. Reserve enough experiment time for both the image import
and the selected evaluation workflow.

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
- `raw-data/tvm-conv2d-512-c64-30seed-300trial-pop64-3methods/`

To draw the paper figures from the checked-in data, run this inside the container:

```
./scripts/draw_figures.sh
./scripts/draw_tvm_figures.sh
```

By default, this writes generated figures to `figures/paper/`. The script also accepts an alternate overhead CSV and output directory:

```
./scripts/draw_figures.sh raw-data/overhead_full_with_instance.csv figures/paper
```

The characterization file is always `raw-data/characterize.csv`; users do not need to regenerate it.

To regenerate the characterization statistics used for Table 2 and Table 3
(Appendix), run:

```
./scripts/regenerate_characterize.sh
```

By default, this writes `raw-data/user-characterize.csv`. To replace the
checked-in characterization CSV explicitly, pass the output path:

```
./scripts/regenerate_characterize.sh raw-data/characterize.csv
```

The generated columns include the data-dependent-block (`DD`) and non-affine
condition (`NAC`) classifications shown in Table 2.

The TVM figure script writes to `figures/paper/tvm-comparison/` by default. It also accepts an alternate TVM raw-data directory and output directory:

```
./scripts/draw_tvm_figures.sh raw-data/tvm-conv2d-512-c64-30seed-300trial-pop64-3methods figures/paper/tvm-comparison
```

## Run experiments and draw new figures

To run the overhead experiment and draw figures from the newly generated data, run this inside the container:

```
./scripts/run_overhead_and_draw.sh
```

By default, this runs the full overhead experiment, writes user-generated data to `raw-data/user-overhead-full-with-instance.csv`, and writes figures to `figures/user-run/`.

The output CSV is resumable: an interrupted rerun skips completed operator/size
pairs already present in that file. Delete the user output CSV to start over.
The full schedule limits `batch_norm` to sizes 64, 128, 256, and 512 because
larger cases can exhaust system memory.

For a faster validation run:

```
./scripts/run_overhead_and_draw.sh smoke
```

This writes `raw-data/user-overhead-smoke-with-instance.csv` and redraws figures in `figures/user-run/`.

To run the TVM comparison experiment and draw figures from the newly generated data:

```
./scripts/run_tvm_and_draw.sh full
```

By default, this runs the 300-trial TVM comparison for `random`, `xgb-default`, and `xgb-symbolic-only`, writes user-generated data to `raw-data/user-tvm-full-conv2d-512-c64-3methods/`, and writes figures to `figures/user-run/tvm-comparison/`.

For a faster TVM validation run:

```
./scripts/run_tvm_and_draw.sh smoke
```

This writes `raw-data/user-tvm-smoke-conv2d-512-c64-3methods/` and redraws TVM figures in `figures/user-run/tvm-comparison/`.

## Reuse with another operator

Operator benchmark definitions live in
`symb_form_tests/tvm-ops/benchmark_adhoc.py`. Add the corresponding benchmark
class to `SpecCollection` in `symb_form_tests/tvm-ops/benchmark_simple.py` so
the validation, overhead, and characterization drivers discover it. The
generic TVM operator base class is in
`symb_form_tests/tvm-ops/benchmark_spec.py`. Plot labels or selections may also
need extending because the paper plotting scripts target the archived operator
set.
