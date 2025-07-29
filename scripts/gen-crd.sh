#!/usr/bin/env bash

# Copyright 2025 Stefan Prodan.
# SPDX-License-Identifier: AGPL-3.0

set -euo pipefail

CRD_COUNT=$1

repo_root=$(git rev-parse --show-toplevel)
template_file="$repo_root/scripts/crd.template.yaml"
tmpdir="${repo_root}/bin/crds"

info() {
    echo '[INFO] ' "$@"
}

fatal() {
    echo '[ERROR] ' "$@" >&2
    exit 1
}

mkdir -p "${tmpdir}"

info "Generating $CRD_COUNT CRDs..."
for ((i=1; i<=$CRD_COUNT; i++))
do
  num="$i"
  sed "s/CRD_COUNT/$num/" $template_file > "$tmpdir/generated_crd_$i.yaml"
done

info "Applying $CRD_COUNT CRDs to the cluster..."
kubectl apply --server-side -f "$tmpdir/" > /dev/null || {
  fatal "Failed to apply CRDs. Please check the generated files in $tmpdir."
}

rm -rf "$tmpdir"

info "$CRD_COUNT CRDs successfully applied"
