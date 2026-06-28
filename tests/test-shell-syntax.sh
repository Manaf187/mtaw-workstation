#!/usr/bin/env bash
set -Eeuo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
readonly REPOSITORY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

mapfile -t shell_scripts < <(cd "$REPOSITORY_ROOT" && { find guest tests -type f -name '*.sh' -print; printf '%s\n' setup-mtaw.sh; } | sort)

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
