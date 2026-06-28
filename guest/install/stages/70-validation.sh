#!/usr/bin/env bash
set -Eeuo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"

failures=0
stage_root="${MTAW_STAGE_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd -P)}"
apt_manifest="$stage_root/manifests/apt-packages.txt"
python_manifest="$stage_root/manifests/python-requirements.in"
osint_core_manifest="$stage_root/manifests/osint-core-tools.yaml"
osint_bookmark_manifest="$stage_root/manifests/osint-bookmarks.yaml"
installer_version=""

check() {
  local description="$1"
  shift

  if "$@"; then
    report PASS "$description"
  else
    report FAIL "$description"
    failures=$((failures + 1))
  fi
}

check_file_hash() {
  local description="$1"
  local path="$2"
  local hash

  if [[ ! -f "$path" ]]; then
    report FAIL "$description unavailable: $path"
    failures=$((failures + 1))
    return
  fi

  if ! hash="$(sha256sum "$path" 2>/dev/null)"; then
    report FAIL "$description could not be calculated"
    failures=$((failures + 1))
    return
  fi

  hash="${hash%% *}"
  if [[ "$hash" =~ ^[[:xdigit:]]{64}$ ]]; then
    report PASS "$description: $hash"
  else
    report FAIL "$description is not a SHA-256 digest"
    failures=$((failures + 1))
  fi
}

validate_architecture() {
  local detected_arch

  detected_arch="$(machine_arch)"
  case "$detected_arch" in
    x86_64|amd64)
      report PASS "supported architecture observed: $detected_arch"
      ;;
    *)
      report FAIL "unsupported architecture observed: $detected_arch"
      failures=$((failures + 1))
      ;;
  esac
}

utc_timezone() {
  local timezone

  if command -v timedatectl >/dev/null 2>&1; then
    timezone="$(timedatectl show --property=Timezone --value 2>/dev/null)" || return 1
  else
    timezone="$(date +%Z)" || return 1
  fi
  [[ "$timezone" == UTC ]]
}

apt_package_installed() {
  local package_name="$1"
  local package_status

  package_status="$(dpkg-query -W -f='${db:Status-Status}' "$package_name" 2>/dev/null)" || return 1
  [[ "$package_status" == *installed* ]]
}

venv_python_is_312() {
  local python_path="$HOME/.local/share/mtaw/venv/bin/python"
  local version

  [[ -x "$python_path" ]] || return 1
  version="$("$python_path" --version 2>&1)" || return 1
  [[ "$version" == "Python 3.12."* ]]
}

venv_pip_available() {
  local pip_path="$HOME/.local/share/mtaw/venv/bin/pip"

  [[ -x "$pip_path" ]] && "$pip_path" --version >/dev/null 2>&1
}

jupyterlab_major_four() {
  local python_path="$HOME/.local/share/mtaw/venv/bin/python"
  local version

  version="$("$python_path" -m jupyterlab --version 2>/dev/null)" || return 1
  [[ "$version" =~ ^4(\.|$) ]]
}

python_module_for_requirement() {
  case "$1" in
    beautifulsoup4)
      printf '%s' bs4
      ;;
    *)
      printf '%s' "$1"
      ;;
  esac
}

python_import_available() {
  local module_name="$1"
  local python_path="$HOME/.local/share/mtaw/venv/bin/python"

  "$python_path" -c "import $module_name" >/dev/null 2>&1
}

report_browser_version() {
  local description="$1"
  local browser_command="$2"
  local version

  if ! version="$("$browser_command" --version 2>/dev/null)" || [[ -z "$version" ]]; then
    report FAIL "$description unavailable"
    failures=$((failures + 1))
    return
  fi
  report PASS "$description: $version"
}

report_optional_browser_version() {
  local description="$1"
  local browser_command="$2"
  local version

  if ! command -v "$browser_command" >/dev/null 2>&1; then
    report WARN "$description unavailable; compatibility browser deferred"
    return
  fi
  if ! version="$("$browser_command" --version 2>/dev/null)" || [[ -z "$version" ]]; then
    report WARN "$description version unavailable"
    return
  fi
  report PASS "$description: $version"
}

report_command_version() {
  local description="$1"
  local command_name="$2"
  local version_args="$3"
  local command_path
  local version

  command_path="$(command -v "$command_name" 2>/dev/null)" || {
    report FAIL "$description"
    failures=$((failures + 1))
    return
  }
  if ! version="$("$command_name" $version_args 2>&1 | head -n 1)" || [[ -z "$version" ]]; then
    report FAIL "$description version unavailable at $command_path"
    failures=$((failures + 1))
    return
  fi
  report PASS "$description: $command_path; $version"
}

manifest_contains() {
  local manifest_path="$1"
  local pattern="$2"

  [[ -f "$manifest_path" ]] && grep -Fq "$pattern" "$manifest_path"
}

no_specialist_osint_tools_installed() {
  local command_name

  for command_name in spiderfoot maltego phoneinfoga instaloader; do
    if command -v "$command_name" >/dev/null 2>&1; then
      return 1
    fi
  done
}

osint_files_have_no_embedded_credentials() {
  local credential_pattern
  local osint_files=(
    "$stage_root/manifests/osint-core-tools.yaml"
    "$stage_root/manifests/osint-specialist-tools.yaml"
    "$stage_root/manifests/osint-bookmarks.yaml"
    "$stage_root/docs/osint-tool-selection.md"
    "$stage_root/docs/osint-tool-licensing.md"
  )

  credential_pattern="(pass"'word=|api[_-]?key=|to'"ken=|-----BEGIN ([A-Z ]+ )?PRIVATE KEY-----)"
  ! grep -nEI -- "$credential_pattern" "${osint_files[@]}" >/dev/null
}

osint_stage_avoids_browser_profiles() {
  ! grep -nEI -- '(mozilla/firefox|chromium/(Default|Profile)|google-chrome|Extensions|addons\.mozilla\.org|chrome\.google\.com/webstore)' "$stage_root/guest/install/stages/45-osint-core.sh" >/dev/null
}

launcher_references_venv() {
  grep -Fq '$HOME/.local/share/mtaw/venv' "$HOME/.local/bin/mtaw-shell"
}

jupyter_binds_to_loopback() {
  grep -Fq -- '--ip=127.0.0.1' "$HOME/.local/bin/mtaw-jupyter"
}

launchers_keep_authentication() {
  local credential_override_pattern

  credential_override_pattern="(--(ServerApp|NotebookApp|IdentityProvider)\\.(token|password)=|--(no-auth|disable-auth))"
  ! grep -Eq -- "$credential_override_pattern" "$HOME/.local/bin/mtaw-shell" "$HOME/.local/bin/mtaw-jupyter"
}

stage_state_is_valid() {
  local stage_name="$1"
  local state_file="$MTAW_STATE_DIR/$stage_name.state"

  [[ -f "$state_file" ]] && grep -Fxq "version=$installer_version" "$state_file" && grep -Fxq "stage=$stage_name" "$state_file" && grep -Eq '^completed=[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$' "$state_file"
}

scoped_mtaw_credential_check() {
  local credential_pattern
  local mtaw_files=(
    "$stage_root/guest/bin/mtaw-shell"
    "$stage_root/guest/bin/mtaw-jupyter"
    "$HOME/.local/bin/mtaw-shell"
    "$HOME/.local/bin/mtaw-jupyter"
  )
  local mtaw_file

  for mtaw_file in "${mtaw_files[@]}"; do
    [[ -f "$mtaw_file" ]] || return 1
  done
  credential_pattern="(pass"'word=|api[_-]?key=|to'"ken=|-----BEGIN ([A-Z ]+ )?PRIVATE KEY-----)"
  ! grep -nEI -- "$credential_pattern" "${mtaw_files[@]}" >/dev/null
}

main() {
  local package_name
  local requirement
  local package_base
  local module_name
  local workspace_directory
  local template_name
  local stage_name

  source "$(os_release_file)"
  check "Ubuntu family" test "${ID:-}" = ubuntu
  report PASS "detected release: ${VERSION:-unknown}"
  if is_reference_release; then
    report PASS "Ubuntu 24.04.4 reference baseline"
  else
    report WARN "permitted development-test candidate; compatibility and validation not established"
  fi
  validate_architecture

  check "UTC timezone" utc_timezone
  check "apt manifest present" test -f "$apt_manifest"
  if [[ -f "$apt_manifest" ]]; then
    while IFS= read -r package_name; do
      [[ "$package_name" =~ ^[[:space:]]*($|#) ]] && continue
      check "apt package: $package_name" apt_package_installed "$package_name"
    done <"$apt_manifest"
  fi

  check "venv Python" venv_python_is_312
  check "venv pip" venv_pip_available
  check "JupyterLab major version 4" jupyterlab_major_four
  check "Python requirements manifest present" test -f "$python_manifest"
  if [[ -f "$python_manifest" ]]; then
    while IFS= read -r requirement; do
      [[ "$requirement" =~ ^[[:space:]]*($|#) ]] && continue
      package_base="${requirement%%[<>=!~;]*}"
      module_name="$(python_module_for_requirement "$package_base")"
      check "Python import: $module_name" python_import_available "$module_name"
    done <"$python_manifest"
  fi

  report_browser_version "Firefox version" firefox
  if command -v chromium >/dev/null 2>&1; then
    report_optional_browser_version "Chromium version" chromium
  else
    report_optional_browser_version "Chromium compatibility browser" chromium-browser
  fi

  check "OSINT core manifest present" test -f "$osint_core_manifest"
  check "OSINT core manifest includes install policy" manifest_contains "$osint_core_manifest" "stage_install:"
  check "OSINT core license records present" manifest_contains "$osint_core_manifest" "license:"
  report_command_version "OSINT core command: ffmpeg" ffmpeg "-version"
  report_command_version "OSINT core command: exiftool" exiftool "-ver"
  report_command_version "OSINT core command: trans" trans "-V"
  check "OSINT bookmark manifest present" test -f "$osint_bookmark_manifest"
  check "OSINT bookmark manifest records account requirements" manifest_contains "$osint_bookmark_manifest" "account_required:"
  check "OSINT bookmark manifest records service cautions" manifest_contains "$osint_bookmark_manifest" "cautions:"
  check "OSINT files contain no embedded credentials" osint_files_have_no_embedded_credentials
  check "OSINT stage avoids browser profile changes" osint_stage_avoids_browser_profiles
  check "no specialist OSINT tools installed in base profile" no_specialist_osint_tools_installed

  for workspace_directory in cases evidence-register collection-logs notebooks; do
    check "workspace directory: $workspace_directory" test -d "$HOME/MTAW-Workspace/$workspace_directory"
  done
  for template_name in case evidence-register collection-log notebooks; do
    check "workspace template: $template_name" test -f "$stage_root/templates/$template_name/README.md"
  done

  check "mtaw-shell launcher executable" test -x "$HOME/.local/bin/mtaw-shell"
  check "mtaw-jupyter launcher executable" test -x "$HOME/.local/bin/mtaw-jupyter"
  check "mtaw-shell references intended venv" launcher_references_venv
  check "mtaw-jupyter binds to loopback" jupyter_binds_to_loopback
  check "launchers do not disable authentication" launchers_keep_authentication

  if [[ -f "$stage_root/VERSION" ]]; then
    installer_version="$(tr -d '\r\n' <"$stage_root/VERSION")"
  fi
  if [[ -n "$installer_version" ]]; then
    report PASS "installer version: $installer_version"
  else
    report FAIL "installer version unavailable"
    failures=$((failures + 1))
  fi
  for stage_name in 00-preflight 10-system-baseline 20-core-packages 30-python-environment 40-browsers 45-osint-core 50-workspace-templates 60-security-defaults; do
    check "stage state: $stage_name" stage_state_is_valid "$stage_name"
  done
  check_file_hash "apt manifest SHA-256" "$apt_manifest"
  check_file_hash "Python requirements SHA-256" "$python_manifest"
  check_file_hash "OSINT core manifest SHA-256" "$osint_core_manifest"
  check_file_hash "OSINT bookmark manifest SHA-256" "$osint_bookmark_manifest"

  check "block inventory before execution" test -s "$MTAW_REPORT_DIR/lsblk-before.txt"
  check "block inventory after execution" test -s "$MTAW_REPORT_DIR/lsblk-after.txt"
  if [[ -s "$MTAW_REPORT_DIR/lsblk-before.txt" && -s "$MTAW_REPORT_DIR/lsblk-after.txt" ]]; then
    if cmp -s "$MTAW_REPORT_DIR/lsblk-before.txt" "$MTAW_REPORT_DIR/lsblk-after.txt"; then
      report PASS "block inventory comparison unchanged"
    else
      report WARN "block inventory comparison changed; this does not prove forensic integrity"
    fi
  else
    report WARN "block inventory comparison unavailable"
  fi

  check "scoped MTAW credential check" scoped_mtaw_credential_check
  report 'NOT TESTED' "clean-VM reproducibility, host controls, and appliance validation are outside this observed guest run"
  report 'NOT APPLICABLE' "evidence-disk, SSH, backups, host integration, OVA, signing, publishing excluded"
  (( failures == 0 ))
}

main "$@"
