# Repository Tests

These portable Bash tests validate the repository foundation only. They do not
build or validate an MTAW virtual machine.

- `test-repository-layout.sh` checks the required bootstrap layout and rejects
  a premature `LICENSE` file.
- `test-shell-syntax.sh` checks the Bash syntax of all required Bash scripts.
- `test-guest-installer.sh` checks the staged-installer contract, OSINT core
  profile controls, dry-run behavior, and the validation stage against
  isolated, non-modifying fixtures.

Run both from a Bash-capable environment:

```bash
bash tests/test-repository-layout.sh
bash tests/test-shell-syntax.sh
bash tests/test-guest-installer.sh
```
