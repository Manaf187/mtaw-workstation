# Build Workflow

The guest installer workflow is implemented repository functionality with one
observed Ubuntu 24.04.4 amd64 development-VM run, one reported clean-VM
reproducibility observation, one guest functional smoke test, and one
controlled RC1 OVA export record. Those records do not establish independent
OVA re-import acceptance, full workstation, host-control, or operational
validation.

1. Start from a clean Ubuntu VM that matches the host and VM prerequisites.
2. Run `bash guest/install/install.sh --dry-run`, then use the staged installer
   only for an authorized guest-side development-VM run. The dry run must
   remain non-modifying, including the OSINT core stage.
3. Apply guest-side configuration only after host-side VirtualBox controls are
   independently configured and recorded.
4. Treat the installer report as observed state, then run planned functional
   and host-side validation independently.
5. Sanitize the VM using the checklist before any appliance export.
6. Generate a release record and, if authorized, export a derived OVA.

The installer can perform guest package installation after explicit
confirmation; it performs no host or VM-hardware configuration. Repository
checks are currently run manually; GitHub Actions CI is not configured. The
absence of CI does not establish workstation, host-control, operational, or
independent OVA re-import validation.
