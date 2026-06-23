#!/usr/bin/env bash
set -Eeuo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
readonly REPOSITORY_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd -P)"
readonly SECRET_PATTERN='(AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{20,}|xox[baprs]-[A-Za-z0-9-]{20,}|-----BEGIN ([A-Z ]+ )?PRIVATE KEY-----)'

failures=0

timestamp() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

report() {
  local level="$1"
  shift
  printf '%s %s: %s\n' "$level" "$(timestamp)" "$*"
}

error_handler() {
  local exit_code="$1"
  local line_number="$2"
  report FAIL "unexpected error at line ${line_number} (exit ${exit_code})"
}

trap 'error_handler "$?" "$LINENO"' ERR

usage() {
  cat <<'EOF'
Usage: validate-repository.sh [--help]

Run repository-only validation checks. This command does not validate an MTAW
workstation, a VirtualBox host, an appliance, or operational suitability.
EOF
}

record_failure() {
  report FAIL "$1"
  failures=$((failures + 1))
}

require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    record_failure "required command unavailable: ${command_name}"
    return 1
  fi
}

run_bash_check() {
  local name="$1"
  local path="$2"

  if bash "$path"; then
    report PASS "$name"
  else
    record_failure "$name"
  fi
}

report_optional_tool() {
  local command_name="$1"
  local purpose="$2"

  if command -v "$command_name" >/dev/null 2>&1; then
    report WARN "${command_name} is available; run its dedicated command separately for ${purpose}"
  else
    report 'NOT TESTED' "${command_name} is unavailable for ${purpose}"
  fi
}

scan_secret_patterns() {
  local matches
  local scan_exit

  if matches="$(git -C "$REPOSITORY_ROOT" grep -nEI "$SECRET_PATTERN" -- .)"; then
    scan_exit=0
  else
    scan_exit=$?
  fi

  case "$scan_exit" in
    0)
      record_failure "secret-pattern scan found potential sensitive material:\n${matches}"
      ;;
    1)
      report WARN "secret-pattern scan found no matches; this limited pattern scan is detection-only and cannot prove that no secrets exist"
      ;;
    *)
      record_failure "secret-pattern scan could not complete (git grep exit ${scan_exit})"
      ;;
  esac
}

scan_prohibited_artifacts() {
  local path
  local lower_path
  local found=0

  while IFS= read -r -d '' path; do
    lower_path="${path,,}"
    case "$lower_path" in
      *.ova|*.ovf|*.vdi|*.vmdk|*.vhd|*.vhdx|*.iso|*.qcow2|*.sav|*.pcap|*.pcapng|*.cap|*.sqlite|*.sqlite3|*.db|*.sql)
        record_failure "prohibited tracked artifact: ${path}"
        found=1
        ;;
    esac
  done < <(git -C "$REPOSITORY_ROOT" ls-files -z)

  if [[ "$found" -eq 0 ]]; then
    report PASS "no prohibited tracked VM, capture, or database artifact extensions found"
  fi
}

main() {
  case "${1:-}" in
    "")
      ;;
    --help|-h)
      usage
      return 0
      ;;
    *)
      usage >&2
      return 2
      ;;
  esac

  if ! require_command bash; then
    return 1
  fi
  if ! require_command git; then
    return 1
  fi

  run_bash_check "repository layout test" "${REPOSITORY_ROOT}/tests/test-repository-layout.sh"
  run_bash_check "Bash syntax test" "${REPOSITORY_ROOT}/tests/test-shell-syntax.sh"
  scan_secret_patterns
  scan_prohibited_artifacts
  report_optional_tool shellcheck "ShellCheck analysis"
  report_optional_tool yamllint "YAML validation"
  report_optional_tool markdownlint-cli2 "Markdown validation"
  report_optional_tool gitleaks "secret scanning"

  if [[ "$failures" -gt 0 ]]; then
    report FAIL "repository validation completed with ${failures} failure(s)"
    return 1
  fi

  report PASS "repository validation completed without failing repository checks"
}

main "$@"
