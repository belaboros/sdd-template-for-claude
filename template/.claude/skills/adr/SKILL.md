---
name: adr
description: Record an architecture decision as a new ADR in docs/architecture/adr/. Use when a plan or implementation makes an architecturally significant decision (structure, component boundaries, technology, external dependency, cross-cutting concern, quality thresholds), or when the user runs /adr.
argument-hint: <decision title> [supersedes NNNN]
---

Record the decision: $ARGUMENTS

1. Find the next free number in `docs/architecture/adr/` (4 digits).
2. Create `NNNN-slug.md` from `docs/templates/adr.md`. Write the Context so that an average engineer with no chat history understands why a decision was needed. List the real alternatives that were considered.
3. Status: `accepted` if the user has already agreed (log that question in the idea's Q&A log); otherwise `proposed`, and ask.
4. If it supersedes an earlier ADR, change **only** the old ADR's status line to `superseded by ADR-NNNN`. Never edit the rest of an accepted ADR.
5. Add a row to `docs/architecture/adr/README.md`.
6. Carry out the follow-ups the ADR lists: update `architecture.md`, `components.json`, the thresholds in `metrics/README.md`, or tooling, in the same change.
