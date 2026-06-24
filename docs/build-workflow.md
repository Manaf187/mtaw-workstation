# Build Workflow

The guest installer workflow is implemented repository functionality, but it is
untested in an MTAW VM and does not establish compatibility, workstation, or
appliance validation.

1. Start from a clean Ubuntu VM that matches the host and VM prerequisites.
2. Run `bash guest/install/install.sh --dry-run`, then use the staged installer
   only for an authorized guest-side development-VM run.
3. Apply guest-side configuration only after host-side VirtualBox controls are
   independently configured and recorded.
4. Treat the installer report as observed state, then run planned functional
   and host-side validation independently.
5. Sanitize the VM using the planned checklist before any future appliance
   export.
6. Generate a future release record and, if authorized, export a derived OVA.

The installer can perform guest package installation after explicit
confirmation; it performs no host or VM-hardware configuration. Repository
checks are currently run manually; GitHub Actions CI is not configured. The
absence of CI does not establish workstation,
compatibility, appliance, or OVA validation.
