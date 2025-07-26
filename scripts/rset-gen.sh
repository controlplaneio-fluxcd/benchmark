#!/usr/bin/env bash

# Copyright 2025 Stefan Prodan.
# SPDX-License-Identifier: AGPL-3.0

set -euo pipefail

OBJ_COUNT=$1

repo_root=$(git rev-parse --show-toplevel)
srcdir="$repo_root/kubernetes/benchmark"
tmpdir="${repo_root}/bin/benchmark"
start=$(date +%s)

info() {
    echo '[INFO] ' "$@"
}

fatal() {
    echo '[ERROR] ' "$@" >&2
    exit 1
}

mkdir -p "${tmpdir}"

info "Applying namespace and RBAC to the cluster..."
cp -r "$srcdir"/* "$tmpdir/"
kubectl apply --server-side -f "$tmpdir/namespace.yaml" > /dev/null

info "Generating ResourceSets with $OBJ_COUNT objects..."
timestamp=$(date +%s)
sed "s/1000/$OBJ_COUNT/;s/benchmark-placeholder/$timestamp/" "$srcdir/input.yaml" > "$tmpdir/input.yaml"

info "Applying ResourceSets to the cluster..."
kubectl apply --server-side -f "$tmpdir/" > /dev/null

info "Waiting for ResourceSets to become ready..."
for rset in $(kubectl get rset -n benchmark -o name | cut -d/ -f2); do
  kubectl -n benchmark wait rset/$rset --for=condition=ready --timeout=10m
done

info "Cleaning up temporary files..."
rm -rf "$tmpdir"

info "ResourceSets successfully applied in $(( $(date +%s) - $start ))sec"
