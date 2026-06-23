# MTAW Repository Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create an auditable MTAW repository baseline with no workstation implementation or operational validation.

**Architecture:** Documentation and a machine-readable manifest preserve the locked baseline. Portable Bash tests and a repository validator enforce repository-only controls, while GitHub Actions runs corresponding static checks in a disposable runner.

**Tech Stack:** Git, Bash, GitHub Actions YAML, ShellCheck, yamllint, markdownlint-cli2, gitleaks.

---

### Task 1: Write layout and syntax tests first

**Files:**
- Create: `tests/test-repository-layout.sh`
- Create: `tests/test-shell-syntax.sh`
- Create: `tests/README.md`

- [ ] **Step 1: Write the failing layout test**

Create `tests/test-repository-layout.sh` to require every requested initial file, reject `LICENSE`, and reject tracked prohibited VM-artifact extensions.

- [ ] **Step 2: Run the layout test to verify it fails**

Run: `bash tests/test-repository-layout.sh`

Expected: `FAIL` because required repository files have not yet been created.

- [ ] **Step 3: Write the failing shell-syntax test**

Create `tests/test-shell-syntax.sh` to discover repository Bash files and run `bash -n` on each.

- [ ] **Step 4: Run the syntax test to verify it fails**

Run: `bash tests/test-shell-syntax.sh`

Expected: `FAIL` because no required Bash files have been created.

- [ ] **Step 5: Commit test foundation**

```bash
git add tests
git commit -m "test: add repository bootstrap checks"
```

### Task 2: Add repository policy, manifests, and documentation

**Files:**
- Create: root policy and metadata files listed in the approved design
- Create: `docs/`, `manifests/`, `host/`, `templates/`, and `build/` documentation files

- [ ] **Step 1: Add root policy and metadata files**

Create `AGENTS.md`, `README.md`, `VERSION`, `CHANGELOG.md`, `CONTRIBUTING.md`, `SECURITY.md`, `.editorconfig`, `.gitattributes`, and `.gitignore`. Set version `0.1.0-dev`; state that it is unvalidated and prevent secrets, evidence, large VM artifacts, local worktrees, and private material from being committed.

- [ ] **Step 2: Add machine-readable baseline and documentation**

Create `manifests/build-specification.yaml` with exact locked values and only `planned`, `not_implemented`, `not_tested`, or `not_validated` implementation status. Add conservative dependency placeholders and documentation covering architecture, security, build workflow, validation, release, first boot, licensing, host boundaries, templates, build sanitization, and the source-of-truth ADR.

- [ ] **Step 3: Run the layout test to verify remaining expected failures**

Run: `bash tests/test-repository-layout.sh`

Expected: `FAIL` only for the Bash scripts and CI workflow scheduled for later tasks.

### Task 3: Implement safe Bash frameworks and make tests green

**Files:**
- Create: `guest/install/install.sh`
- Create: `guest/install/stages/00-preflight.sh`
- Create: `guest/validation/validate-repository.sh`
- Create: companion README files

- [ ] **Step 1: Implement the installer and preflight framework**

Use `#!/usr/bin/env bash`, `set -Eeuo pipefail`, UTC log timestamps, dependency checks, explicit error traps, and `--help`. The installer dispatches only the read-only preflight stage; neither script changes the guest.

- [ ] **Step 2: Implement repository validation**

Implement a `--help` capable Bash command that runs layout and syntax tests, reports individual `PASS` or `FAIL` results, detects unavailable optional tools as `NOT TESTED`, reports a non-authoritative secret-pattern scan with explicit limitations, and rejects prohibited tracked artifacts.

- [ ] **Step 3: Run syntax and safe-framework checks**

Run: `bash tests/test-shell-syntax.sh && bash guest/install/install.sh --help && bash guest/install/stages/00-preflight.sh --help && bash guest/validation/validate-repository.sh --help`

Expected: all commands pass. The layout test remains expected to fail until the CI files are created in Task 4.

- [ ] **Step 4: Commit safe script framework**

```bash
git add guest tests
git commit -m "feat: add safe repository validation framework"
```

### Task 4: Add conservative GitHub Actions quality checks

**Files:**
- Create: `.github/workflows/ci.yml`
- Create: `.github/pull_request_template.md`

- [ ] **Step 1: Add the CI workflow**

Use `permissions: { contents: read }`, `actions/checkout@v4`, an Ubuntu runner, and disposable-runner installation of ShellCheck, yamllint, and markdownlint-cli2. Run layout, Bash syntax, YAML, Markdown, gitleaks, and prohibited-artifact checks. Do not configure deployment, releases, signing, credentials, artifact upload, or VM builds.

- [ ] **Step 2: Add a pull-request template**

Require confirmation of baseline preservation, no secrets or prohibited artifacts, checks run, planned-control labeling, and no unsupported validation claims.


- [ ] **Step 3: Run local static checks and inspect the tree**

Run `bash tests/test-repository-layout.sh`, `bash tests/test-shell-syntax.sh`, and `bash guest/validation/validate-repository.sh`, then run available local linters, `git diff --check`, `git ls-files`, a secret-pattern scan, and a prohibited binary/artifact scan. Record unavailable tools as `NOT TESTED`.

- [ ] **Step 4: Commit completed repository foundation**

```bash
git add .
git commit -m "feat: bootstrap MTAW repository foundation"
```

### Task 5: Publish the review branch without merging

**Files:**
- Modify: none

- [ ] **Step 1: Confirm branch and remote**

Run: `git branch --show-current && git remote -v`

Expected: `bootstrap/repository-foundation` and `https://github.com/Manaf187/mtaw-workstation.git` for both origin fetch and push.

- [ ] **Step 2: Push the feature branch**

Run: `git push --set-upstream origin bootstrap/repository-foundation`

Expected: branch pushed without modifying `main`.

- [ ] **Step 3: Create a draft pull request**

Create a draft pull request targeting `main`, with a scope-limited title and summary. Do not merge it.

- [ ] **Step 4: Confirm clean worktree**

Run: `git status --short --branch`

Expected: clean branch with an origin tracking relationship.
