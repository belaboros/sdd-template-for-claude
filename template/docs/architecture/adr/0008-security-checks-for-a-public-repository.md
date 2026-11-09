# ADR-0008: Layered security checks for a public repository

- **Status:** accepted
- **Date:** 2026-11-09
- **Origin:** foundation decision inherited from [sdd-template-for-claude](https://github.com/belaboros/sdd-template-for-claude); carries out the gitleaks follow-up of ADR-0007

## Context
The repository is public on GitHub, or may become public later. Session files (ADR-0007) are committed regularly and quote the user's requests verbatim, so a pasted credential would be published. Claude can also commit and push. Anything that reaches GitHub has to be assumed copied, even if it is deleted afterwards.

## Decision
We will use several layers of defence, so that no single missed check leaks a secret:

| Layer | When | What |
|-------|------|------|
| `.gitignore` | always | Common secret files (`.env*`, keys, credential JSON) are never staged |
| Claude permissions | every Claude read | `.claude/settings.json` denies reading `.env*`, `*.pem`, `*.key` and SSH keys, so secrets never enter a session transcript |
| **pre-commit** (`.pre-commit-config.yaml`) | every commit | **gitleaks** on the staged diff; `detect-private-key`; large files (> 500 KB); merge conflicts; JSON/YAML validity; **shellcheck** for scripts; **zizmor** for GitHub Actions security |
| **CI** (`.github/workflows/security.yml`) | push to main, PRs, weekly | gitleaks over the **full history** (checksum-verified binary), plus all pre-commit hooks |
| GitHub | every push | Secret scanning with push protection (enabled) |
| Supply chain | weekly | Actions pinned to commit SHAs; `permissions: {}` by default, read-only per job; `persist-credentials: false`; Dependabot with a 7-day cooldown |
| Disclosure | — | `SECURITY.md`: report privately; rotate first, then clean history |

`pre-commit install` is required after cloning (see `CLAUDE.md`). Each language added later brings its own dependency audit and static analysis through `/add-language` (see the playbook).

## Alternatives considered
| Option | Why not chosen |
|--------|----------------|
| GitHub secret scanning only | Runs after the push, which is too late for a public repo; it also doesn't cover generic secrets well |
| `gitleaks-action` | A third-party action that needs a token; a checksum-verified binary does the same with less trust |
| Husky / lefthook | `pre-commit` is language-neutral and also runs unchanged in CI |
| Relying on the repo being private | Private repos get published or forked later; a secret committed once stays in the history |

## Consequences
- **Positive:** a secret has to get past `.gitignore`, the local hook, CI and GitHub push protection before it is published.
- **Negative:** contributors need `gitleaks` and `pre-commit` installed locally. Hooks can be skipped with `--no-verify`, so CI and push protection remain the backstop.
- **Follow-up:** if a secret ever leaks, rotate it first; rewriting history alone isn't enough. Consider branch protection on `main` that requires the `security` workflow to pass.
