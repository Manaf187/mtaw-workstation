#!/usr/bin/env bash
set -Eeuo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
readonly REPOSITORY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

required_paths=(
  ".github/pull_request_template.md"
  "AGENTS.md"
  "README.md"
  "VERSION"
  "CHANGELOG.md"
  "CONTRIBUTING.md"
  "SECURITY.md"
  "setup-mtaw.sh"
  ".editorconfig"
  ".gitattributes"
  ".gitignore"
  "docs/architecture.md"
  "docs/security-baseline.md"
  "docs/build-workflow.md"
  "docs/import-guide.md"
  "docs/first-boot.md"
  "docs/validation-strategy.md"
  "docs/validation-runs/2026-06-28-observed-guest-install.md"
  "docs/validation-runs/2026-06-28-clean-vm-reproducibility.md"
  "docs/validation-runs/2026-06-28-guest-functional-smoke.md"
  "docs/release-model.md"
  "docs/release-validation-v0.1.0-rc1.md"
  "docs/first-boot-model.md"
  "docs/licensing-status.md"
  "docs/decisions/ADR-0001-repository-as-source-of-truth.md"
  "manifests/build-specification.yaml"
  "manifests/apt-packages.txt"
  "manifests/osint-bookmarks.yaml"
  "manifests/osint-core-tools.yaml"
  "manifests/osint-specialist-tools.yaml"
  "manifests/python-requirements.in"
  "manifests/README.md"
  "host/windows/README.md"
  "guest/install/install.sh"
  "guest/install/README.md"
  "guest/install/stages/00-preflight.sh"
  "guest/install/stages/45-osint-core.sh"
  "guest/validation/validate-repository.sh"
  "guest/validation/README.md"
  "guest/config/README.md"
  "guest/bin/README.md"
  "templates/case/README.md"
  "templates/evidence-register/README.md"
  "templates/collection-log/README.md"
  "templates/notebooks/README.md"
  "build/README.md"
  "build/sanitization-checklist.md"
  "build/release-manifest.example.yaml"
  "release/MTAW-Workstation-v0.1.0-rc1.manifest.yaml"
  "release/MTAW-Workstation-v0.1.0-Ubuntu24.04-amd64.sha256"
  "release/RELEASE_NOTES_v0.1.0-rc1.md"
  "tests/test-repository-layout.sh"
  "tests/test-shell-syntax.sh"
  "tests/README.md"
)

failures=0

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  failures=$((failures + 1))
}

main() {
  local path

  for path in "${required_paths[@]}"; do
    if [[ ! -f "${REPOSITORY_ROOT}/${path}" ]]; then
      fail "missing required file: ${path}"
    fi
  done

  if [[ -e "${REPOSITORY_ROOT}/LICENSE" ]]; then
    fail "LICENSE must not be added until an author approves a license"
  fi

  if [[ ${failures} -gt 0 ]]; then
    printf '%s: %d layout check(s) failed\n' "$SCRIPT_NAME" "$failures" >&2
    return 1
  fi

  printf 'PASS: repository layout requirements are present\n'
}

main "$@"
