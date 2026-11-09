---
name: add-language
description: Set up the quality gate (complexity and coupling linters, boundary rules, metrics collector, pre-commit, Claude hooks, CI) for a programming language before any code in it is written. Use when the user runs /add-language, or when the check-language-registered hook blocks a write.
argument-hint: <language, e.g. python | js-ts | rust | go>
disable-model-invocation: true
---

Introduce the language `$ARGUMENTS` with its quality gate (ADR-0006). The tool choices per language are in [playbook.md](playbook.md).

1. **Decide.** Read `playbook.md`, `docs/architecture/metrics/README.md` and `components.json`. Pick the tools, and pin the latest stable versions at setup time. Ask the user about anything that is genuinely their choice (for example the package manager), and log each question and answer in the related idea's Q&A log.
2. **ADR.** Run `/adr Introduce <language> and its quality gate`, recording the tools, the versions and why they were picked.
3. **Register.** Add `{name, extensions, added, adr, lint, metrics}` to `tools/quality/languages.json`. Use the same `name` that the case statement in `tools/quality/check-language-registered.sh` uses. This unblocks the write hook, so do it before creating any config file in that language.
4. **Complexity.** Configure the linter to warn above CC 10 and fail above 15 (or as close as the tool allows), plus limits on nesting depth and parameter count.
5. **Boundaries.** Generate the boundary-checker config **from `components.json`**: allowed dependencies only, no cycles, and only public entry points across components. If the format allows, add a small generator script so the config never has to be maintained by hand.
6. **Metrics collector.** Add a command that emits the snapshot JSON schema from `metrics/README.md`. If this is the first language, also build the shared merge/render step used by `/arch-metrics`.
7. **Hooks.**
   - `.pre-commit-config.yaml`: linter, boundary check, tests. Create the file if it doesn't exist.
   - `.claude/settings.json`: add a `PostToolUse` hook (matcher `Write|Edit|MultiEdit`) that lints the edited file, if it is in this language, and exits 2 with the findings on failure, so Claude fixes them straight away. Keep the existing `PreToolUse` gate.
   - CI workflow: run the full gate on push and PR, in a job of its own next to `.github/workflows/security.yml`. SHA-pin the actions and keep permissions read-only.
   - Security: add the language's dependency audit, static security analysis and Dependabot entry (playbook, "Security, for every language").
8. **Prove it works.** Temporarily add (a) a function with CC > 15, (b) an import that breaks a boundary and (c) a cycle. Confirm each one fails the gate, then remove them. Report the output.
9. **Document.** Add the build, test, lint and metrics commands to the Conventions section of `CLAUDE.md`. Run `/arch-metrics` to store the baseline snapshot.
