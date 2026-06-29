# First-Boot Model

The first-boot model is planned and not implemented. An appliance must require
a unique local credential setup or an equivalent authorized process before
operational use; it must never expose a reusable public default password.

The planned first-boot process must avoid embedded credentials, tokens, API
keys, cookies, private certificates, browser profiles, and case data. It must
preserve the separation between the system disk and encrypted case/evidence
storage, use UTC, and provide clear failure reporting.

Automated first-boot credential provisioning is not included in v0.1.0-rc1.
