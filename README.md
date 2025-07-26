# Flux Operator Benchmark

Mean Time To Production benchmark for Flux Operator and the enterprise distribution.

Running the benchmark requires a Kubernetes cluster with Flux Operator installed and configured.

Generate 1K HelmReleases and 1K Kustomizations in the benchmark namespace:

```shell
COUNT=1000 make benchmark
```

To remove the benchmark resources, run:

```shell
make clean
```
