# ADR-0006: Enforce modularity rules per language, gated at the language's introduction

- **Status:** accepted
- **Date:** 2026-11-09
- **Origin:** foundation decision inherited from [sdd-template-for-claude](https://github.com/belaboros/sdd-template-for-claude); ADR-0005

## Context
Metrics show problems after the fact. To *keep* cohesion high and coupling low, the rules must fail fast, while the code is being written. The project may add Python, JavaScript/TypeScript, Rust, Go or other languages over time, and each needs its own tools. The risk is that a new language arrives without any checks set up for it.

## Decision
1. **Registry.** `tools/quality/languages.json` lists every language that has a working quality gate.
2. **Gate.** A Claude Code `PreToolUse` hook (`tools/quality/check-language-registered.sh`) blocks Claude from writing a source file whose language is not registered, and points to `/add-language`.
3. **`/add-language`** sets up, for each new language: complexity linting at the thresholds from ADR-0005, boundary rules generated from `components.json` (which also forbid cycles), a metrics collector emitting the common snapshot schema, a `pre-commit` hook, a Claude `PostToolUse` lint hook, and a CI step. It then proves that the rules work by introducing a deliberate violation and checking that it is caught. The language-specific choices are recorded in a new ADR.
4. **Layers of enforcement:** the editor/Claude hook (seconds) → `pre-commit` (each commit) → CI (each push or PR) → `/review-spec` metrics snapshot (each spec).

## Alternatives considered
| Option | Why not chosen |
|--------|----------------|
| Set up tooling for every language up front | Unused configuration that rots; versions go stale |
| Rely on code review only | Inconsistent and slow; Claude doesn't reliably remember rules that aren't checked |
| Only CI checks | Feedback comes too late; Claude's edit loop wouldn't see it |

## Consequences
- **Positive:** no language can enter the codebase unchecked; Claude gets feedback while it edits.
- **Negative:** the first file in a new language requires a setup step. Writes through Bash bypass the Claude hook, so `pre-commit` and CI remain the backstop.
- **Follow-up:** the first `/add-language` run builds the shared snapshot renderer (latest.md plus the coupling diagram).
