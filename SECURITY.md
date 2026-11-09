# Security policy

## Reporting a vulnerability

Please **do not open a public issue** for security problems. Report them privately through GitHub's
[private vulnerability reporting](https://github.com/belaboros/sdd-template-for-claude/security/advisories/new).
You should get a response within 7 days.

## Leaked secrets

If you find a credential in this repository or its history, report it as above. The maintainer will revoke and rotate it first, then remove it from the history. Removing it from git alone is never enough.

## What protects this repository

See [ADR-0008](template/docs/architecture/adr/0008-security-checks-for-a-public-repository.md): gitleaks in pre-commit and CI, GitHub secret scanning with push protection, SHA-pinned and least-privilege GitHub Actions checked by zizmor, and Dependabot.
