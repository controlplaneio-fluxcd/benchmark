# Flux Operator Benchmark

Mean Time To Production benchmark for Flux Operator and the enterprise distribution.

## Prerequisites

Running the benchmark requires an EKS Auto Mode cluster with a dedicated node pool for Flux:

- [Karpenter NodePool](kubernetes/karpenter/flux-node-pool.yaml)
- [Flux Operator configuration](kubernetes/flux-system/flux-operator.yaml)
- [Flux Instance configuration](kubernetes/flux-system/flux-instance.yaml)

The benchmark measurements are taken with kube-prometheus-stack.
The Grafana dashboards are available at:

- [Monitoring configuration](kubernetes/monitoring/)

## Running the Benchmark

Generate 1K HelmReleases and 1K Kustomizations in the benchmark namespace:

```shell
COUNT=1000 make benchmark
```

To trigger a reconciliation of the benchmark resources, run:

```shell
COUNT=100 make reconcile-ks reconcile-hr
```

To remove the benchmark resources, run:

```shell
make clean
```
