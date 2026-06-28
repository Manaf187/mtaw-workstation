#!/usr/bin/env bash
set -Eeuo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
failures=0
stages=(00-preflight 10-system-baseline 20-core-packages 30-python-environment 40-browsers 45-osint-core 50-workspace-templates 60-security-defaults 70-validation)

fail() { printf 'FAIL: %s\n' "$1" >&2; failures=$((failures + 1)); }

if ! command -v rg >/dev/null 2>&1; then
  printf 'FAIL: rg is required for guest installer contract checks\n' >&2
  exit 1
fi

make_validation_fixture() {
  local fixture_dir
  local command_name

  fixture_dir="$(mktemp -d)"
  mkdir -p "$fixture_dir/home/.local/bin" "$fixture_dir/home/.local/share/mtaw/venv/bin" "$fixture_dir/bin" "$fixture_dir/report/stages"
  printf '%s\n' 'ID=ubuntu' 'VERSION="Ubuntu 24.04.4 LTS"' >"$fixture_dir/os-release"
  printf '%s\n' 'inventory' >"$fixture_dir/report/lsblk-before.txt"
  printf '%s\n' 'inventory' >"$fixture_dir/report/lsblk-after.txt"

  for command_name in 00-preflight 10-system-baseline 20-core-packages 30-python-environment 40-browsers 45-osint-core 50-workspace-templates 60-security-defaults; do
    printf 'version=%s\nstage=%s\ncompleted=%s\n' "$(tr -d '\r\n' <"$root/VERSION")" "$command_name" '2026-06-24T00:00:00Z' >"$fixture_dir/report/stages/$command_name.state"
  done
  for command_name in cases evidence-register collection-logs notebooks; do
    mkdir -p "$fixture_dir/home/MTAW-Workspace/$command_name"
  done

  printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" "UTC"' >"$fixture_dir/bin/timedatectl"
  printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" "install ok installed"' >"$fixture_dir/bin/dpkg-query"
  printf '%s\n' '#!/usr/bin/env bash' 'case "${1:-}" in --version) printf "%s\\n" "Python 3.12.10";; -m) if [[ "${2:-}" == jupyterlab ]]; then printf "%s\\n" "4.2.1"; else printf "%s\\n" "pip 25.0"; fi;; -c) exit 0;; *) exit 0;; esac' >"$fixture_dir/home/.local/share/mtaw/venv/bin/python"
  printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" "pip 25.0"' >"$fixture_dir/home/.local/share/mtaw/venv/bin/pip"
  printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" "Mozilla Firefox 127.0"' >"$fixture_dir/bin/firefox"
  printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" "Chromium 126.0"' >"$fixture_dir/bin/chromium"
  printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" "ffmpeg version 6.1.1"' >"$fixture_dir/bin/ffmpeg"
  printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" "12.76"' >"$fixture_dir/bin/exiftool"
  printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" "Translate Shell 0.9.7.1"' >"$fixture_dir/bin/trans"
  for command_name in "$fixture_dir/bin/timedatectl" "$fixture_dir/bin/dpkg-query" "$fixture_dir/home/.local/share/mtaw/venv/bin/python" "$fixture_dir/home/.local/share/mtaw/venv/bin/pip" "$fixture_dir/bin/firefox" "$fixture_dir/bin/chromium" "$fixture_dir/bin/ffmpeg" "$fixture_dir/bin/exiftool" "$fixture_dir/bin/trans"; do
    chmod +x "$command_name"
  done
  cp "$root/guest/bin/mtaw-shell" "$fixture_dir/home/.local/bin/mtaw-shell"
  cp "$root/guest/bin/mtaw-jupyter" "$fixture_dir/home/.local/bin/mtaw-jupyter"
  chmod +x "$fixture_dir/home/.local/bin/mtaw-shell" "$fixture_dir/home/.local/bin/mtaw-jupyter"

  printf '%s' "$fixture_dir"
}

run_validation_fixture() {
  local fixture_dir="$1"

  MTAW_DRY_RUN=1 MTAW_STAGE_ROOT="$root" MTAW_REPORT_DIR="$fixture_dir/report" MTAW_OS_RELEASE_FILE="$fixture_dir/os-release" MTAW_ARCH=amd64 HOME="$fixture_dir/home" PATH="$fixture_dir/bin:$PATH" bash "$root/guest/install/stages/70-validation.sh"
}

make_dispatcher_dry_run_fixture() {
  local fixture_dir
  local command_name

  fixture_dir="$(mktemp -d)"
  mkdir -p "$fixture_dir/bin" "$fixture_dir/home" "$fixture_dir/report"
  printf '%s\n' 'ID=ubuntu' 'VERSION_ID="24.04"' 'VERSION="Ubuntu 24.04.4 LTS"' >"$fixture_dir/os-release"

  for command_name in sudo apt apt-get systemctl git lsblk python3.12 firefox chromium install mkdir timedatectl; do
    printf '%s\n' '#!/usr/bin/env bash' 'exit 0' >"$fixture_dir/bin/$command_name"
    chmod +x "$fixture_dir/bin/$command_name"
  done
  printf '%s\n' '#!/usr/bin/env bash' '[[ "${1:-}" == hosts ]] && exit 0' 'exit 0' >"$fixture_dir/bin/getent"
  chmod +x "$fixture_dir/bin/getent"

  printf '%s' "$fixture_dir"
}

make_dispatcher_preflight_fixture() {
  local fixture_dir
  local command_name

  fixture_dir="$(mktemp -d)"
  mkdir -p "$fixture_dir/bin" "$fixture_dir/home" "$fixture_dir/report"
  printf '%s\n' 'ID=ubuntu' 'VERSION_ID="24.04"' 'VERSION="Ubuntu 24.04.4 LTS"' >"$fixture_dir/os-release"

  for command_name in sudo apt systemctl git; do
    printf '%s\n' '#!/usr/bin/env bash' 'exit 0' >"$fixture_dir/bin/$command_name"
    chmod +x "$fixture_dir/bin/$command_name"
  done
  printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" "NAME TYPE SIZE FSTYPE MOUNTPOINTS"' >"$fixture_dir/bin/lsblk"
  printf '%s\n' '#!/usr/bin/env bash' '[[ "${1:-}" == hosts ]] && exit 0' 'exit 0' >"$fixture_dir/bin/getent"
  chmod +x "$fixture_dir/bin/lsblk" "$fixture_dir/bin/getent"

  printf '%s' "$fixture_dir"
}

test_dispatcher_dry_run_propagates_execution_context() {
  local fixture_dir
  local dry_run_output

  fixture_dir="$(make_dispatcher_dry_run_fixture)"
  if ! dry_run_output="$(MTAW_OS_RELEASE_FILE="$fixture_dir/os-release" MTAW_ARCH=amd64 HOME="$fixture_dir/home" PATH="$fixture_dir/bin:$PATH" bash "$root/guest/install/install.sh" --dry-run --stage 60-security-defaults --report-dir "$fixture_dir/report" 2>&1)"; then
    fail "dispatcher dry run should complete through non-validation stages"
  else
    grep -Fq 'options dry_run=1' <<<"$dry_run_output" || fail "dispatcher dry run did not report dry-run mode"
    grep -Fq 'completed stage: 60-security-defaults' <<<"$dry_run_output" || fail "dispatcher dry run did not reach the requested final stage"
    grep -Fq 'DRY RUN privileged:' <<<"$dry_run_output" || fail "dispatcher dry run did not propagate dry-run mode to privileged stage commands"
  fi
  [[ ! -e "$fixture_dir/report/install.log" ]] || fail "dispatcher dry run wrote an install log"
  [[ ! -e "$fixture_dir/report/report.txt" ]] || fail "dispatcher dry run wrote a report file"
  [[ ! -d "$fixture_dir/report/stages" ]] || fail "dispatcher dry run wrote stage state"

  # Remove only the temporary fixture created by this test.
  rm -rf "$fixture_dir"
}

test_dispatcher_preflight_records_named_inventories() {
  local fixture_dir
  local preflight_output

  fixture_dir="$(make_dispatcher_preflight_fixture)"
  if ! preflight_output="$(MTAW_OS_RELEASE_FILE="$fixture_dir/os-release" MTAW_ARCH=amd64 HOME="$fixture_dir/home" PATH="$fixture_dir/bin:$PATH" bash "$root/guest/install/install.sh" --stage 00-preflight --report-dir "$fixture_dir/report" 2>&1)"; then
    fail "dispatcher preflight should record named inventories without unbound variables"
    grep -Fq 'unbound variable' <<<"$preflight_output" && fail "dispatcher preflight hit an unbound inventory argument"
  else
    grep -Fq 'completed stage: 00-preflight' <<<"$preflight_output" || fail "dispatcher preflight did not complete"
  fi
  [[ -s "$fixture_dir/report/lsblk-before.txt" ]] || fail "dispatcher preflight did not write before inventory"
  [[ -s "$fixture_dir/report/lsblk-preflight.txt" ]] || fail "dispatcher preflight did not write preflight inventory"
  [[ -s "$fixture_dir/report/lsblk-after.txt" ]] || fail "dispatcher preflight did not write after inventory"
  [[ -s "$fixture_dir/report/stages/00-preflight.state" ]] || fail "dispatcher preflight did not write stage state"

  # Remove only the temporary fixture created by this test.
  rm -rf "$fixture_dir"
}

test_successful_validation_fixture() {
  local fixture_dir
  local validation_output
  local package_name

  fixture_dir="$(make_validation_fixture)"
  if ! validation_output="$(run_validation_fixture "$fixture_dir" 2>&1)"; then
    fail "validation stage should pass with a complete observed-state fixture"
  else
    for package_name in $(grep -Ev '^[[:space:]]*(#|$)' "$root/manifests/apt-packages.txt"); do
      grep -Fq "apt package: $package_name" <<<"$validation_output" || fail "validation fixture did not check apt package: $package_name"
    done
    for package_name in $(grep -Ev '^[[:space:]]*(#|$)' "$root/manifests/python-requirements.in"); do
      package_name="${package_name%%[<>=!~;]*}"
      [[ "$package_name" == beautifulsoup4 ]] && package_name=bs4
      grep -Fq "Python import: $package_name" <<<"$validation_output" || fail "validation fixture did not check Python import: $package_name"
    done
    for command_name in 'UTC timezone' 'venv Python' 'venv pip' 'JupyterLab major version 4' 'Firefox version' 'Chromium version' 'workspace directory: cases' 'workspace template: notebooks' 'mtaw-shell references intended venv' 'mtaw-jupyter binds to loopback' 'launchers do not disable authentication' 'stage state: 60-security-defaults' 'OSINT core manifest present' 'OSINT core command: ffmpeg' 'OSINT core command: exiftool' 'OSINT core command: trans' 'OSINT bookmark manifest present' 'no specialist OSINT tools installed in base profile' 'installer version' 'apt manifest SHA-256' 'Python requirements SHA-256' 'OSINT core manifest SHA-256' 'OSINT bookmark manifest SHA-256' 'block inventory before execution' 'block inventory after execution' 'block inventory comparison' 'scoped MTAW credential check'; do
      grep -Fq "$command_name" <<<"$validation_output" || fail "validation fixture did not report: $command_name"
    done
    grep -Fq 'Firefox version: Mozilla Firefox 127.0' <<<"$validation_output" || fail "validation fixture did not report the Firefox version"
    grep -Fq 'Chromium version: Chromium 126.0' <<<"$validation_output" || fail "validation fixture did not report the Chromium version"
    grep -Fq "installer version: $(tr -d '\r\n' <"$root/VERSION")" <<<"$validation_output" || fail "validation fixture did not report the installer version"
  fi

  # Remove only the temporary fixture created by this test.
  rm -rf "$fixture_dir"
}

test_mandatory_validation_failure_fixture() {
  local fixture_dir
  local validation_output

  fixture_dir="$(make_validation_fixture)"
  rm -f "$fixture_dir/home/.local/share/mtaw/venv/bin/pip"
  if validation_output="$(run_validation_fixture "$fixture_dir" 2>&1)"; then
    fail "validation stage accepted a fixture without the mandatory venv pip executable"
  else
    grep -Fq 'FAIL ' <<<"$validation_output" || fail "mandatory validation failure did not report FAIL"
    grep -Fq 'venv pip' <<<"$validation_output" || fail "mandatory validation failure did not identify venv pip"
  fi

  # Remove only the temporary fixture created by this test.
  rm -rf "$fixture_dir"
}

test_authentication_override_failure_fixture() {
  local fixture_dir
  local validation_output

  fixture_dir="$(make_validation_fixture)"
  printf '%s\n' 'exec jupyter lab --ServerApp.token=' >>"$fixture_dir/home/.local/bin/mtaw-jupyter"
  if validation_output="$(run_validation_fixture "$fixture_dir" 2>&1)"; then
    fail "validation stage accepted a launcher that disables Jupyter authentication"
  else
    grep -Fq 'launchers do not disable authentication' <<<"$validation_output" || fail "authentication override failure did not identify the launcher policy"
  fi

  # Remove only the temporary fixture created by this test.
  rm -rf "$fixture_dir"
}

test_osint_core_missing_command_failure_fixture() {
  local fixture_dir
  local validation_output

  fixture_dir="$(make_validation_fixture)"
  printf '%s\n' '#!/usr/bin/env bash' 'exit 127' >"$fixture_dir/bin/ffmpeg"
  chmod +x "$fixture_dir/bin/ffmpeg"
  if validation_output="$(run_validation_fixture "$fixture_dir" 2>&1)"; then
    fail "validation stage accepted a fixture without the mandatory OSINT core ffmpeg command"
  else
    grep -Fq 'FAIL ' <<<"$validation_output" || fail "OSINT core missing command did not report FAIL"
    grep -Fq 'OSINT core command: ffmpeg' <<<"$validation_output" || fail "OSINT core missing command did not identify ffmpeg"
  fi

  # Remove only the temporary fixture created by this test.
  rm -rf "$fixture_dir"
}

test_missing_chromium_is_deferred_warning() {
  local fixture_dir
  local validation_output

  fixture_dir="$(make_validation_fixture)"
  rm -f "$fixture_dir/bin/chromium"
  if ! validation_output="$(run_validation_fixture "$fixture_dir" 2>&1)"; then
    fail "validation stage should warn, not fail, when Chromium compatibility browser is deferred"
  else
    grep -Fq 'Chromium compatibility browser unavailable' <<<"$validation_output" || fail "missing Chromium did not produce the deferred compatibility-browser warning"
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
grep -Fq 'MTAW_STAGES=(' "$root/guest/install/lib/common.sh" || fail "missing shared stage list"
grep -Fq 'die()' "$root/guest/install/lib/common.sh" || fail "missing dispatcher error helper"
grep -Fq 'mtaw-shell' "$root/guest/install/stages/30-python-environment.sh" || fail "missing functional shell launcher"
grep -Fq 'libimage-exiftool-perl' "$root/manifests/apt-packages.txt" || fail "incorrect ExifTool package"
grep -Fq '45-osint-core' "$root/guest/install/lib/common.sh" || fail "missing OSINT core stage ordering"
grep -Fq 'osint-core-tools.yaml' "$root/guest/install/stages/45-osint-core.sh" || fail "OSINT core stage does not use the core manifest"
grep -Fq 'translate-shell' "$root/manifests/osint-core-tools.yaml" || fail "OSINT core manifest does not include translate-shell"
grep -Fq 'deferred' "$root/manifests/osint-core-tools.yaml" || fail "OSINT core manifest does not document deferred candidates"
grep -Fq 'account_required:' "$root/manifests/osint-bookmarks.yaml" || fail "OSINT bookmarks do not record account requirements"
grep -Fq 'license:' "$root/manifests/osint-core-tools.yaml" || fail "OSINT core manifest lacks license records"
grep -Fq 'license:' "$root/manifests/osint-specialist-tools.yaml" || fail "OSINT specialist manifest lacks license records"
if rg -n 'sudo[[:space:]]+DEBIAN_FRONTEND=' "$root/guest/install"; then fail "malformed privileged environment invocation"; fi
if rg -n '^[^#]*sudo[[:space:]]' "$root/guest/install/stages"/{10,20,30,40,45,50,60,70}-*.sh; then fail "stage invokes sudo directly"; fi
if rg -n 'curl[^\n|]*\|[[:space:]]*(bash|sh)' "$root/guest/install" "$root/docs"; then fail "installer or docs contain curl-pipe-shell pattern"; fi
if rg -n 'apt-get install --yes chromium-browser|apt install --yes chromium-browser' "$root/guest/install/stages/40-browsers.sh"; then
  fail "browser stage installs Chromium through the Ubuntu Snap transition package"
fi

if rg -n -i '\b(mkfs|fdisk|parted|cryptsetup|mount[[:space:]])\b' "$root/guest/install"; then
  fail "installer contains prohibited evidence-disk mutation command"
fi
if rg -n -i '(default password|password=|api[_-]?key=|token=)' "$root/guest/install"; then
  fail "installer contains credential-like default"
fi
if rg -n -i '(spiderfoot|maltego|phoneinfoga|instaloader)' "$root/guest/install/stages/45-osint-core.sh"; then
  fail "OSINT core stage installs specialist-profile tooling"
fi
if rg -n -i '(addons\.mozilla\.org|chrome\.google\.com/webstore|web-ext|install[^[:cntrl:]]*extension)' "$root/guest/install/stages/45-osint-core.sh"; then
  fail "OSINT core stage installs browser extensions"
fi

test_successful_validation_fixture
test_mandatory_validation_failure_fixture
test_authentication_override_failure_fixture
test_osint_core_missing_command_failure_fixture
test_missing_chromium_is_deferred_warning
test_dispatcher_dry_run_propagates_execution_context
test_dispatcher_preflight_records_named_inventories

if [[ "$failures" -gt 0 ]]; then
  exit 1
fi
printf 'PASS: guest installer contract\n'
