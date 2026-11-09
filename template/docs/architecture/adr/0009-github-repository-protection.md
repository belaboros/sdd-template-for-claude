# ADR-0009: Protect `main` and enable GitHub's security features

- **Status:** accepted
- **Date:** 2026-11-09
- **Origin:** foundation decision inherited from [sdd-template-for-claude](https://github.com/belaboros/sdd-template-for-claude); carries out the branch-protection follow-up of ADR-0008

## Context
ADR-0008 put the security checks in pre-commit and CI. Local hooks can be skipped (`--no-verify`), and CI only blocks anything if a failing result actually prevents a merge. Claude also has permission to push, so `main` needs a protection that doesn't depend on anyone remembering the rules.

## Decision
`tools/bootstrap-github.sh` applies these GitHub repository settings through the API (run it once, after the first push):

| Setting | Value | Why |
|---------|-------|-----|
| Branch protection on `main` | every change goes through a PR; checks `Secret scan (full history)` and `Pre-commit hooks (all files)` must pass on an up-to-date branch; conversations must be resolved | Nothing reaches `main` without passing the security workflow |
| Required approvals | 0 | There is a single maintainer; the checks are the gate, not a reviewer |
| Enforce for admins | on | The rule also applies to the owner, and so to Claude acting with the owner's credentials |
| Force pushes and branch deletion | blocked | History on `main` can't be rewritten or removed by accident |
| Secret scanning and push protection | on | Already enabled; GitHub blocks known token formats at push time |
| Private vulnerability reporting | on | `SECURITY.md` points reporters to it |
| Dependabot alerts and security updates | on | Vulnerable dependencies are flagged and fixed automatically |
| Secret scanning for generic patterns and validity checks | requested | On free plans GitHub may leave them disabled (they need the paid GitHub Secret Protection add-on); gitleaks covers generic secrets either way |

## Alternatives considered
| Option | Why not chosen |
|--------|----------------|
| Rulesets instead of classic branch protection | Equivalent for a single branch; classic protection is simpler to read back with `gh api` |
| Require 1 approval | Blocks a solo maintainer from merging at all |
| Admins may bypass | Turns the protection into a suggestion for the only person who pushes |

## Consequences
- **Positive:** `main` only changes through PRs that passed the full-history secret scan and every hook.
- **Negative:** every change, even a typo fix, needs a branch and a PR. In an emergency an admin has to turn off "enforce for admins" temporarily (and should record that).
- **Follow-up:** if a check's job name in `security.yml` changes, update the required checks or merges will block. Revisit the generic secret patterns if the plan changes.
