#!/usr/bin/env bash
set -Eeuo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
failures=0
stages=(00-preflight 10-system-baseline 20-core-packages 30-python-environment 40-browsers 50-workspace-templates 60-security-defaults 70-validation)

fail() { printf 'FAIL: %s\n' "$1" >&2; failures=$((failures + 1)); }

test_validation_stage() {
  local fixture_dir
  local fixture_home
  local fixture_bin
  local os_release
  local command_name
  local validation_output

  fixture_dir="$(mktemp -d)"
  fixture_home="$fixture_dir/home"
  fixture_bin="$fixture_dir/bin"
  os_release="$fixture_dir/os-release"
  mkdir -p "$fixture_home/.local/bin" "$fixture_home/.local/share/mtaw/venv/bin" "$fixture_bin"
  printf '%s\n' 'ID=ubuntu' 'VERSION="Ubuntu 24.04.4 LTS"' >"$os_release"

  for command_name in python3.12 git curl wget jq rg file exiftool sqlite3 tmux tree; do
    printf '%s\n' '#!/usr/bin/env bash' 'exit 0' >"$fixture_bin/$command_name"
    chmod +x "$fixture_bin/$command_name"
  done
  for command_name in "$fixture_home/.local/share/mtaw/venv/bin/python" "$fixture_home/.local/bin/mtaw-shell" "$fixture_home/.local/bin/mtaw-jupyter"; do
    printf '%s\n' '#!/usr/bin/env bash' 'exit 0' >"$command_name"
    chmod +x "$command_name"
  done

  if ! validation_output="$(MTAW_DRY_RUN=1 MTAW_REPORT_DIR="$fixture_dir/report" MTAW_OS_RELEASE_FILE="$os_release" MTAW_ARCH=amd64 HOME="$fixture_home" PATH="$fixture_bin:$PATH" bash "$root/guest/install/stages/70-validation.sh" 2>&1)"; then
    fail "validation stage should pass with an observed reference-baseline fixture"
  else
    grep -Fq 'PASS ' <<<"$validation_output" || fail "validation stage did not emit PASS results"
    grep -Fq 'Ubuntu family' <<<"$validation_output" || fail "validation stage did not check the Ubuntu family"
    grep -Fq 'NOT TESTED' <<<"$validation_output" || fail "validation stage did not distinguish untested controls"
    grep -Fq 'NOT APPLICABLE' <<<"$validation_output" || fail "validation stage did not record excluded controls"
  fi

  # Remove only the temporary fixture created by this test.
  rm -rf "$fixture_dir"
}

for stage in "${stages[@]}"; do
  [[ -f "$root/guest/install/stages/${stage}.sh" ]] || fail "missing stage: ${stage}"
done
[[ -f "$root/guest/install/lib/common.sh" ]] || fail "missing shared library"

for option in --dry-run --stage --from-stage --report-dir --yes --allow-unsupported-platform; do
  grep -Fq -- "$option" "$root/guest/install/install.sh" || fail "missing option: ${option}"
done

grep -Fq 'finalize_run' "$root/guest/install/lib/common.sh" || fail "missing EXIT report finalization"
grep -Fq 'record_stage_success' "$root/guest/install/lib/common.sh" || fail "missing atomic stage state recording"
grep -Fq 'validate_dependencies' "$root/guest/install/lib/common.sh" || fail "missing dependency validation"
grep -Fq 'run_privileged' "$root/guest/install/lib/common.sh" || fail "missing privileged command gate"
grep -Fq 'compare_inventories' "$root/guest/install/lib/common.sh" || fail "missing inventory comparison"
grep -Fq 'mtaw-shell' "$root/guest/install/stages/30-python-environment.sh" || fail "missing functional shell launcher"
grep -Fq 'libimage-exiftool-perl' "$root/manifests/apt-packages.txt" || fail "incorrect ExifTool package"
if rg -n 'sudo[[:space:]]+DEBIAN_FRONTEND=' "$root/guest/install"; then fail "malformed privileged environment invocation"; fi
if rg -n '^[^#]*sudo[[:space:]]' "$root/guest/install/stages"/{10,20,30,40,50,60,70}-*.sh; then fail "stage invokes sudo directly"; fi

if rg -n -i '\b(mkfs|fdisk|parted|cryptsetup|mount[[:space:]])\b' "$root/guest/install"; then
  fail "installer contains prohibited evidence-disk mutation command"
fi
if rg -n -i '(default password|password=|api[_-]?key=|token=)' "$root/guest/install"; then
  fail "installer contains credential-like default"
fi

test_validation_stage

if [[ "$failures" -gt 0 ]]; then
  exit 1
fi
printf 'PASS: guest installer contract\n'
