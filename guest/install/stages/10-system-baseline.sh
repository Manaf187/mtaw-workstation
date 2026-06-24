#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/lib/common.sh"
require_command sudo; network_required; run sudo timedatectl set-timezone UTC; run sudo apt-get update; run sudo DEBIAN_FRONTEND=noninteractive apt-get --yes upgrade; report PASS "system baseline applied; no workstation applications installed"
