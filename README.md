# Flux Operator Benchmark

Mean Time To Production benchmark for [Flux Operator](https://github.com/controlplaneio-fluxcd/flux-operator) and the enterprise distribution.

## Prerequisites

Running the benchmark requires an EKS Auto Mode cluster with a dedicated node pool for Flux:

- [Karpenter NodePool](kubernetes/karpenter/flux-node-pool.yaml)
- [Flux Operator configuration](kubernetes/flux-system/flux-operator.yaml)
- [Flux Instance configuration](kubernetes/flux-system/flux-instance.yaml)

The benchmark measurements are taken with kube-prometheus-stack.
The Grafana dashboards are available at:

- [Monitoring configuration](kubernetes/monitoring/)

The following CLI tools are required to run the benchmark:

- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [flux-operator](https://fluxcd.control-plane.io/operator/cli/)

## Running the Benchmark

Generate 1K HelmReleases and 1K Kustomizations in the benchmark namespace:

```shell
COUNT=1000 make benchmark
```

> Rerunning the benchmark will trigger an update of all existing HelmReleases and Kustomizations.

To trigger an update of the first 50 HelmReleases and Kustomizations via OCIRepository semver change, run:

```shell
VER=6.9.1 make set-version
```

To generate load on the Kubernetes API server, create CRDs with:

```shell
CRD_COUNT=100 make crds
```

To remove the generated CRDs, run:

```shell
make clean-crds
```

To remove the benchmark resources, run:

```shell
make clean
```
