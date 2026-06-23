#!/usr/bin/env bash
set -Eeuo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
readonly REPOSITORY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

shell_scripts=(
  "guest/install/install.sh"
  "guest/install/stages/00-preflight.sh"
  "guest/validation/validate-repository.sh"
  "tests/test-repository-layout.sh"
  "tests/test-shell-syntax.sh"
)

failures=0

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  failures=$((failures + 1))
}

main() {
  local script_path

  if ! command -v bash >/dev/null 2>&1; then
    fail "bash is required to check shell syntax"
  fi

  for script_path in "${shell_scripts[@]}"; do
    if [[ ! -f "${REPOSITORY_ROOT}/${script_path}" ]]; then
      fail "missing required Bash script: ${script_path}"
      continue
    fi

    if ! bash -n "${REPOSITORY_ROOT}/${script_path}"; then
      fail "Bash syntax check failed: ${script_path}"
    fi
  done

  if [[ ${failures} -gt 0 ]]; then
    printf '%s: %d syntax check(s) failed\n' "$SCRIPT_NAME" "$failures" >&2
    return 1
  fi

  printf 'PASS: Bash syntax is valid\n'
}

main "$@"
