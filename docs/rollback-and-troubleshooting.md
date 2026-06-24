# Rollback and Troubleshooting

The installer performs package upgrades and package installation when confirmed;
those changes are not automatically reversed. Use a VM snapshot created before
testing for rollback. Do not treat a successful run as workstation or appliance
validation. Review the UTC log and report under `~/.local/state/mtaw/`, or the
directory supplied with `--report-dir`.

If a stage reports a failed dependency, rerun the full dependency chain after
resolving the reported guest-side issue. Do not use a later stage as evidence
that an earlier stage completed in a different run. `--dry-run` is the safe
first diagnostic step; it does not request sudo or modify guest state.
