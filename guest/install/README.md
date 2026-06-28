# Guest Installation Framework

`install.sh` is a staged Ubuntu development-VM installer. Ubuntu Desktop
24.04.4 LTS amd64 is the reference baseline. Another Ubuntu 24.04 amd64 point
release is permitted only as a development-test candidate; it is not a
compatibility or workstation validation result.

Run a non-modifying review first:

```bash
bash guest/install/install.sh --dry-run
```

For an authorized guest-only installation, run the command interactively and
type `INSTALL`, or use `--yes` only in an explicitly authorized noninteractive
process. `--report-dir PATH` changes the default per-user report location of
`~/.local/state/mtaw/`. `--stage NAME` runs prerequisites through `NAME`, and
`--from-stage NAME` selects a contiguous range. An unsafe range is rejected.
`--allow-unsupported-platform` records an explicit override; it cannot make an
unsupported platform validated.

The stages run in this order: preflight, system baseline, core packages,
Python environment, browsers, OSINT core, workspace templates, security
defaults, and observed-state validation. Package stages can change the
timezone and install or upgrade packages. The Python stage creates or reuses
`~/.local/share/mtaw/venv` and installs the `mtaw-shell` and `mtaw-jupyter`
launchers in `~/.local/bin`.

The OSINT core stage installs only reviewed Ubuntu APT packages from
`manifests/osint-core-tools.yaml`; it does not install specialist OSINT tools,
browser extensions, credentials, or browser profile data.

The browser stage records an existing Chromium-compatible browser when one is
present. It does not install Ubuntu's `chromium-browser` Snap transition
package automatically; a missing compatibility browser is reported as a
deferred manual review item.

The installer does not partition, format, mount, encrypt, or identify an
evidence disk. It does not enable SSH, configure host integration, create
backups, export an OVA, sign, publish, reboot automatically, or create a
credential. Package changes are not automatically reversible; use a VM
snapshot made before an authorized run for rollback.

The final stage records observed `PASS`, `FAIL`, `WARN`, `NOT TESTED`, and
`NOT APPLICABLE` findings. An observed-run report is not clean-VM
reproducibility, host-control, workstation, appliance, OVA, or operational
validation.
