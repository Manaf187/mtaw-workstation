# Windows Host and VirtualBox Controls

This directory documents host-side requirements only. The intended host is
Windows 11 Pro 64-bit with UEFI, Secure Boot, TPM 2.0, Microsoft Defender,
Windows Firewall, and BitLocker.

The intended hypervisor is Oracle VirtualBox 7.2 base package. The Extension
Pack is not required. Before a future guest build, verify host-side VM
configuration independently: NAT-only networking, no port forwarding,
bridging disabled unless approved, shared clipboard disabled, drag-and-drop
disabled, shared folders disabled, USB passthrough disabled, and host-drive
mapping disabled.

Ubuntu guest scripts cannot conclusively validate all of these controls.
