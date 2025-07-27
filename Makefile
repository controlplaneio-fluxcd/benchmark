# Copyright 2025 Stefan Prodan.
# SPDX-License-Identifier: AGPL-3.0

# Makefile for running the Flux Operator benchmarks.

SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

##@ Provisioning

# Number of objects to generate for the benchmark.
COUNT ?= 100

# Timeout for the benchmark operations.
TIMEOUT ?= 10m

.PHONY: benchmark
benchmark: ## Generate and apply resources in the benchmark namespace.
	./scripts/rset-gen.sh $(COUNT) $(TIMEOUT)

.PHONY: clean
clean: ## Delete all generated resources in the benchmark namespace.
	kubectl -n benchmark delete rset -l app.kubernetes.io/component=benchmark

###@ Reconciliation

.PHONY: reconcile-ks
reconcile-ks: ## Reconcile Kustomizations in the benchmark namespace.
	./scripts/ks-reconcile.sh $(COUNT)

.PHONY: reconcile-hr
reconcile-hr: ## Reconcile HelmReleases in the benchmark namespace.
	./scripts/hr-reconcile.sh $(COUNT)

##@ Provisioning CRDs

# Number of CRDs to generate for the benchmarks.
CRD_COUNT ?= 100

.PHONY: gen-crds
gen-crds: ## Generate and apply CRDs for the benchmarks.
	./scripts/crd-gen.sh $(CRD_COUNT)

.PHONY: del-crds
del-crds: ## Delete all generated CRDs.
	kubectl delete crd -l app.kubernetes.io/component=benchmark

##@ General

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
