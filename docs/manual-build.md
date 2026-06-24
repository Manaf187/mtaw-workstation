# Manual Guest Build

Run `bash guest/install/install.sh --dry-run` first. For an authorized
development VM, run the installer interactively and type `INSTALL`, or use
`--yes` only in an explicitly authorized noninteractive process. Ubuntu
24.04.4 amd64 is the reference baseline; another 24.04 point release is a
development-test candidate but not validated.

The installer runs stages in dependency order and writes UTC logs and reports
to `~/.local/state/mtaw/` unless `--report-dir` is supplied. It can change the
guest timezone, packages, browser availability, per-user Python environment,
and workspace structure. It never configures the host, selects an evidence
disk, or reboots automatically.

The installer does not configure the evidence disk, host integration features,
backups, an OVA, or a release.
