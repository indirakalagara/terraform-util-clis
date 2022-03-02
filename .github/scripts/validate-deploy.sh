#!/usr/bin/env bash

BIN_DIR=$(cat .bin_dir)

ls -l "${BIN_DIR}"

if [[ ! -f "${BIN_DIR}/jq" ]]; then
  echo "jq not found"
  exit 1
else
  echo "jq cli found"
fi

if [[ ! -f "${BIN_DIR}/yq3" ]]; then
  echo "yq3 not found"
  exit 1
else
  echo "yq3 cli found"
fi

if [[ ! -f "${BIN_DIR}/yq4" ]]; then
  echo "yq4 not found"
  exit 1
else
  echo "yq4 cli found"
fi

if [[ ! -f "${BIN_DIR}/igc" ]]; then
  echo "igc not found"
  exit 1
else
  echo "igc cli found"
fi

if [[ ! -f "${BIN_DIR}/helm" ]] || ! "${BIN_DIR}/helm" version --short; then
  echo "helm not found"
  exit 1
else
  echo "helm cli found"
fi

if [[ ! -f "${BIN_DIR}/argocd" ]]; then
  echo "argocd not found"
  exit 1
else
  echo "argocd cli found"
fi

if ! "${BIN_DIR}/rosa" version; then
  echo "rosa cli not configured properly"
  exit 1
else
  echo "rosa cli configured properly"
fi

if ! "${BIN_DIR}/gh" version; then
  echo "gh cli not configured properly"
  exit 1
else
  echo "gh cli configured properly"
fi

if ! "${BIN_DIR}/glab" version; then
  echo "glab cli not configured properly"
  exit 1
else
  echo "glab cli configured properly"
fi

if ! "${BIN_DIR}/kubeseal" --version; then
  echo "kubeseal cli not configured properly"
  exit 1
else
  echo "kubeseal cli configured properly"
fi

if ! "${BIN_DIR}/oc" version; then
  echo "oc cli not configured properly"
  exit 1
else
  echo "oc cli configured properly"
fi

if ! "${BIN_DIR}/kubectl" version; then
  echo "kubectl cli not configured properly"
  exit 1
else
  echo "kubectl cli configured properly"
fi
