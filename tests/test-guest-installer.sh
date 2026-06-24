#!/usr/bin/env bash
set -Eeuo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
failures=0
stages=(00-preflight 10-system-baseline 20-core-packages 30-python-environment 40-browsers 50-workspace-templates 60-security-defaults 70-validation)

fail() { printf 'FAIL: %s\n' "$1" >&2; failures=$((failures + 1)); }

for stage in "${stages[@]}"; do
  [[ -f "$root/guest/install/stages/${stage}.sh" ]] || fail "missing stage: ${stage}"
done
[[ -f "$root/guest/install/lib/common.sh" ]] || fail "missing shared library"

for option in --dry-run --stage --from-stage --report-dir --yes --allow-unsupported-platform; do
  grep -Fq -- "$option" "$root/guest/install/install.sh" || fail "missing option: ${option}"
done

if rg -n -i '\b(mkfs|fdisk|parted|cryptsetup|mount[[:space:]])\b' "$root/guest/install"; then
  fail "installer contains prohibited evidence-disk mutation command"
fi
if rg -n -i '(default password|password=|api[_-]?key=|token=)' "$root/guest/install"; then
  fail "installer contains credential-like default"
fi

if [[ "$failures" -gt 0 ]]; then
  exit 1
fi
printf 'PASS: guest installer contract\n'
