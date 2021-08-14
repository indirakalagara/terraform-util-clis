#!/usr/bin/env bash

BIN_DIR=$(cat .bin_dir)

ls -l "${BIN_DIR}"

if [[ ! -f "${BIN_DIR}/jq" ]]; then
  echo "jq not found"
  exit 1
fi

if [[ ! -f "${BIN_DIR}/yq3" ]]; then
  echo "yq3 not found"
  exit 1
fi

if [[ ! -f "${BIN_DIR}/yq4" ]]; then
  echo "yq4 not found"
  exit 1
fi

if [[ ! -f "${BIN_DIR}/igc" ]]; then
  echo "igc not found"
  exit 1
fi
