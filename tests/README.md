# Repository Tests

These portable Bash tests validate the repository foundation only. They do not
build or validate an MTAW virtual machine.

- `test-repository-layout.sh` checks the required bootstrap layout and rejects
  a premature `LICENSE` file.
- `test-shell-syntax.sh` checks the Bash syntax of all required Bash scripts.

Run both from a Bash-capable environment:

```bash
bash tests/test-repository-layout.sh
bash tests/test-shell-syntax.sh
```
