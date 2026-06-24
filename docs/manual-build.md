# Manual Guest Build

Run `guest/install/install.sh --dry-run` first. For an authorized development
VM, run the installer interactively and type `INSTALL`, or use `--yes` only in
an explicitly authorized noninteractive process. Ubuntu 24.04.4 amd64 is the
reference baseline; another 24.04 point release is development-compatible but
not validated.

The installer does not configure the evidence disk, host integration features,
backups, an OVA, or a release.
