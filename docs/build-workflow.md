# Build Workflow

The guest installer workflow is implemented repository functionality, but it is
untested in an MTAW VM and does not establish compatibility or appliance
validation.

1. Start from a clean Ubuntu VM that matches the host and VM prerequisites.
2. Select either the future automated installer or documented manual build.
3. Apply guest-side configuration only after host-side VirtualBox controls are
   independently configured and recorded.
4. Run planned functional and host-side validation.
5. Sanitize the VM using the planned checklist before any future appliance
   export.
6. Generate a future release record and, if authorized, export a derived OVA.

This bootstrap provides no package installation and performs no VM
configuration. Repository checks are currently run manually; GitHub Actions CI
is not configured. The absence of CI does not establish workstation,
compatibility, appliance, or OVA validation.
