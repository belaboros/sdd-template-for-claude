---
name: review-spec
description: Independently verify an implementation against its spec's acceptance criteria using the spec-reviewer subagent. Use when the user runs /review-spec or after /implement finishes.
argument-hint: <spec number, e.g. 0001>
---

Verify spec `$ARGUMENTS`.

1. Launch the `spec-reviewer` subagent with only the spec folder path `docs/specs/$ARGUMENTS-*/`. Do not pass it your own conclusions, so its review stays independent.
2. Relay its findings to the user: each acceptance criterion marked pass, fail or unverified, with evidence.
3. Run `/arch-metrics` to store a snapshot, and relay the result and the change since the previous snapshot. A `fail` result (a cycle, a boundary violation, CC > 15) counts as a failed review. Check that `architecture.md` and `components.json` describe what was built.
4. If everything passes: set the spec to `implemented` and the idea to `done`, and update `docs/ideas/README.md`.
5. If anything fails: add follow-up tasks to `tasks.md`. If a fix needs a decision from the user, ask, and log the question and answer in the idea file (stage `review`).
