# Guest Installation Framework

`install.sh` is a safe framework, not a complete installer. At this baseline
it only invokes the read-only preflight stage and makes no guest changes.

Future installation work must preserve strict error handling, UTC timestamps,
explicit privilege checks, rerun safety where practical, and documented
destructive operations.
