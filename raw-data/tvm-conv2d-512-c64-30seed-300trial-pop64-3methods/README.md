# TVM Conv2D Symbolic Autotuning Raw Data

This directory contains the compact raw data used to draw the TVM comparison
figures for the paper artifact.

- Source repository: `tvm-comparison`
- Source commit: `a30d8e13975f15ca40154f65e451a243f5103b37`
- Source run: `runs/tvm_prod_conv2d_512_c64_20seed_300trial_iter16_pop64_3methods_symbolic_first_20260707_052903`
- Workload: `conv2d_nhwc_n1_h512_w512_ci64_co64_k3_s1_p1_d1_float32`
- Methods: `random`, `xgb-default`, `xgb-symbolic-only`
- Seeds: `0` through `29`
- Trials per run: `300`
- Population size: `64`
- Trials per iteration: `16`

The checked-in subset contains the files consumed by
`scripts/draw_tvm_figures.sh`: per-run `summary.json`, `trace.jsonl`, and
`feature_timings.jsonl` where available. Random runs do not produce feature
timing logs.
