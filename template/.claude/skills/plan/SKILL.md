---
name: plan
description: Produce plan.md and tasks.md for an approved spec. Use when the user runs /plan.
argument-hint: <spec number, e.g. 0001>
disable-model-invocation: true
---

Create the technical plan for spec `$ARGUMENTS`.

1. Read `docs/specs/$ARGUMENTS-*/spec.md` and its idea file (including the Q&A log). If the spec is not `approved`, stop and say so.
2. Explore the codebase before you design anything; use an Explore subagent for wide searches. Do not write code in this stage.
3. Write `plan.md` from `docs/templates/plan.md`. Compare at least two approaches when the choice is not obvious. Fill in the **Verification map** so that every acceptance criterion has a concrete test or command.
4. Write `tasks.md` from `docs/templates/tasks.md`: small, ordered tasks, each tagged with the acceptance criteria it covers and the check that proves it.
5. If a design choice really belongs to the user, ask with AskUserQuestion and log each question and answer in the idea file's `## Q&A log` (stage `plan`).
6. If planning shows the spec is wrong or incomplete, propose the spec change, ask, log it, and update `spec.md` before you continue.
7. **Architecture.** Read `docs/architecture/architecture.md`, `components.json` and the ADRs. In the plan:
   - Place every new piece of code in an existing component, or add a new component with a one-sentence responsibility (if you need "and", split it). Keep dependencies acyclic and pointing towards more stable components.
   - Update `components.json` (paths, `mayDependOn`, `public`) and the context and component diagrams in `architecture.md`.
   - Record every architecturally significant decision with `/adr`, and link the ADRs from `plan.md`.
   - If the plan needs a language that isn't in `tools/quality/languages.json`, make the first task `/add-language <lang>`.
8. If this plan picks the tech stack or the build/test commands, add them to the Conventions section of `CLAUDE.md`.
9. Ask the user to approve the plan (log it). Then set the plan to `approved`, the idea to `planned`, update `docs/ideas/README.md`, and suggest `/implement NNNN` in a fresh session.
