# Guest and Repository Validation

`validate-repository.sh` validates repository controls only. It does not
validate a workstation, host configuration, VM hardware profile, appliance,
or operational capability. Run it from a Bash-capable environment:

```bash
bash guest/validation/validate-repository.sh
```

The command emits `PASS`, `FAIL`, `WARN`, and `NOT TESTED`. Optional tools
that are unavailable locally remain `NOT TESTED`.

The installer's `70-validation` stage is separate: it records observed
guest-side prerequisites after the preceding stages. Its output does not
replace this repository validation command and does not validate the host or
an appliance.
