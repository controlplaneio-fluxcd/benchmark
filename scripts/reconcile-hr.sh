#!/usr/bin/env bash

# Copyright 2025 Stefan Prodan.
# SPDX-License-Identifier: AGPL-3.0

set -euo pipefail

OBJ_COUNT=$1

repo_root=$(git rev-parse --show-toplevel)
srcdir="$repo_root/kubernetes/benchmark"
start=$(date +%s)

info() {
    echo '[INFO] ' "$@"
}

fatal() {
    echo '[ERROR] ' "$@" >&2
    exit 1
}


info "Triggering the reconciliation of ${OBJ_COUNT} HelmReleases..."

for ((i=1; i<=OBJ_COUNT; i++)); do
  flux-operator -n benchmark reconcile resource HelmRelease/hrapp-$i --force > /dev/null || {
    fatal "Failed to reconcile HelmRelease hrapp-$i"
  }
done

info "Done in $(( $(date +%s) - $start ))sec"
