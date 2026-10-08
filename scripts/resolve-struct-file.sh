#!/usr/bin/env bash
# Resolve the StructKit configuration file.
# Usage: resolve-struct-file.sh [explicit-path]
# Prints the resolved path to stdout. When no explicit path is given,
# prefers .structkit.yaml, then legacy .struct.yaml.
set -euo pipefail

explicit="${1-}"

if [[ -n "${explicit}" ]]; then
  printf '%s\n' "${explicit}"
  exit 0
fi

if [[ -f ".structkit.yaml" ]]; then
  echo "Auto-detected struct file: .structkit.yaml" >&2
  printf '%s\n' ".structkit.yaml"
  exit 0
fi

if [[ -f ".struct.yaml" ]]; then
  echo "Auto-detected struct file: .struct.yaml (legacy)" >&2
  printf '%s\n' ".struct.yaml"
  exit 0
fi

echo "::error::No StructKit configuration file found. Looked for .structkit.yaml and .struct.yaml in the workspace root. Set the struct_file input to an explicit path, or add one of those files." >&2
exit 1
