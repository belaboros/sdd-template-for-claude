---
name: implement
description: Implement the next open tasks of an approved plan, test-first. Use when the user runs /implement.
argument-hint: <spec number, e.g. 0001> [task id]
disable-model-invocation: true
---

Implement spec `$ARGUMENTS`.

1. Read `spec.md`, `plan.md` and `tasks.md` in `docs/specs/<number>-*/`. If the plan is not `approved`, stop.
2. Set the idea's status to `in-progress`.
3. Take the first unticked task, or the one named in the arguments. For each task:
   - Write or extend the test that proves its acceptance criteria first, and confirm that it fails.
   - Implement just enough to make it pass. Stay inside the plan.
   - Run the task's check plus the full test suite and the quality gate (lint, complexity, boundary check; see `CLAUDE.md` Conventions). Tick the box only when they pass.
   - Never silence a complexity or boundary finding. Refactor instead: extract a function, move code to the component that owns it, or depend on a public entry point. If the fix needs a new dependency between components, that is a plan change: ask, then update `components.json` and add an ADR.
   - Make one commit per task when the user has asked for commits, with a message that names the task, e.g. `T2 (spec 0001): …`.
4. **Deviation:** if a task cannot be done as specified, or the spec turns out to be wrong, stop. Explain, ask with AskUserQuestion, log the question and answer in the idea file's `## Q&A log` (stage `implement`), update spec/plan/tasks, then continue.
5. When every task is ticked, run `/review-spec <number>`.
