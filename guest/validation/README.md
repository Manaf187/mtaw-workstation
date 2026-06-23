# Guest and Repository Validation

`validate-repository.sh` validates repository controls only. It does not
validate a workstation, host configuration, VM hardware profile, appliance,
or operational capability.

The command emits `PASS`, `FAIL`, `WARN`, and `NOT TESTED`. Optional tools
that are unavailable locally remain `NOT TESTED`.
