# Rollback and Troubleshooting

The installer performs package upgrades and package installation when confirmed;
those changes are not automatically reversed. Use a VM snapshot created before
testing for rollback. Do not treat a successful run as workstation or appliance
validation. Review the UTC log and report under `~/.local/state/mtaw/`, or the
directory supplied with `--report-dir`.
