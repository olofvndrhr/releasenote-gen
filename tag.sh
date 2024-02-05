#!/usr/bin/env bash

set -euo pipefail

TAG="${1}"

if ! [[ "${TAG}" =~ v[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    echo "invalid tag"
    exit 1
fi

echo "tagging full: ${TAG}"
git tag "${TAG}" -m "${TAG}" --force

echo "tagging minor: ${TAG%.*}"
git tag "${TAG%.*}" -m "${TAG%.*}" --force

echo "tagging major: ${TAG%%.*}"
git tag "${TAG%%.*}" -m "${TAG%%.*}" --force
