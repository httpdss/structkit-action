#!/usr/bin/env bash
# Local tests for scripts/resolve-struct-file.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPT="${ROOT}/scripts/resolve-struct-file.sh"
FIXTURE_STRUCTKIT="${ROOT}/tests/fixtures/structkit-yaml/.structkit.yaml"
FIXTURE_LEGACY="${ROOT}/tests/fixtures/legacy-struct-yaml/.struct.yaml"

tmpdir="$(mktemp -d)"
trap 'rm -rf "${tmpdir}"' EXIT
cd "${tmpdir}"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_eq() {
  local expected="$1"
  local actual="$2"
  local label="$3"
  if [[ "${expected}" != "${actual}" ]]; then
    fail "${label}: expected '${expected}', got '${actual}'"
  fi
  echo "PASS: ${label}"
}

# Explicit path is returned unchanged, even if the file does not exist.
assert_eq "custom/path.structkit.yaml" \
  "$("${SCRIPT}" "custom/path.structkit.yaml")" \
  "explicit path is used as-is"

assert_eq "${FIXTURE_STRUCTKIT}" \
  "$("${SCRIPT}" "${FIXTURE_STRUCTKIT}")" \
  "explicit fixture path is used as-is"

# Neither default file exists.
if "${SCRIPT}" >/dev/null 2>"${tmpdir}/missing.err"; then
  fail "expected failure when neither default file exists"
fi
if ! grep -q "No StructKit configuration file found" "${tmpdir}/missing.err"; then
  fail "missing-file error should mention both default names"
fi
echo "PASS: missing both default files fails with a clear message"

# Legacy only.
cp "${FIXTURE_LEGACY}" .struct.yaml
assert_eq ".struct.yaml" "$("${SCRIPT}")" "legacy .struct.yaml is detected"

# Prefer .structkit.yaml when both exist.
cp "${FIXTURE_STRUCTKIT}" .structkit.yaml
assert_eq ".structkit.yaml" "$("${SCRIPT}")" "prefers .structkit.yaml when both exist"

# Current name only.
rm -f .struct.yaml
assert_eq ".structkit.yaml" "$("${SCRIPT}")" ".structkit.yaml is detected"

# Explicit value wins over auto-detect.
assert_eq ".struct.yaml" \
  "$("${SCRIPT}" ".struct.yaml")" \
  "explicit .struct.yaml is used even if .structkit.yaml exists"

echo "All resolve-struct-file tests passed."
