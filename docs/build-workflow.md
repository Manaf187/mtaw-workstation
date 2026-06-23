# Build Workflow

The build workflow is planned, not implemented.

1. Start from a clean Ubuntu VM that matches the host and VM prerequisites.
2. Select either the future automated installer or documented manual build.
3. Apply guest-side configuration only after host-side VirtualBox controls are
   independently configured and recorded.
4. Run planned functional and host-side validation.
5. Sanitize the VM using the planned checklist before any future appliance
   export.
6. Generate a future release record and, if authorized, export a derived OVA.

This bootstrap provides no package installation and performs no VM
configuration. CI may install temporary static-analysis tools in its
disposable runner; that is not a workstation build operation.
