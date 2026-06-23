# Security Baseline

The locked host baseline is Windows 11 Pro 64-bit with UEFI, Secure Boot, TPM
2.0, Microsoft Defender, Windows Firewall, and BitLocker. The planned
hypervisor is the Oracle VirtualBox 7.2 base package; the Extension Pack is
not required or assumed.

The planned primary VM is Ubuntu Desktop 24.04.4 LTS amd64 with 6 virtual
CPUs, 12 GiB RAM, a dynamically allocated 120 GiB system VDI, and a separate
250 GiB case/evidence VDI. Networking is NAT-only by default. Bridged
networking requires specific approval; port forwarding is disabled by default.

Shared clipboard, drag-and-drop, shared folders, USB passthrough, and
host-drive mapping are disabled by default. These host controls require
host-side validation and cannot all be confirmed from Ubuntu.

Planned analyst controls include UTC timestamps, ISO 8601-compatible names,
per-project Python virtual environments, encrypted case/evidence storage,
encrypted restic backups, and no reusable public default password.
