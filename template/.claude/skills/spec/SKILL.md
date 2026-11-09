---
name: spec
description: Interview the user about a captured idea and write docs/specs/NNNN-slug/spec.md. Use when the user runs /spec or asks to turn an idea into a specification.
argument-hint: <idea number, e.g. 0001>
disable-model-invocation: true
---

Turn idea `$ARGUMENTS` into an approved specification by interviewing the user.

## 1. Read
- Read `docs/ideas/$ARGUMENTS-*.md` in full, including the earlier Q&A log, so you never repeat a question that was already answered.
- Skim the repo and any existing specs that this might overlap with or depend on.
- Set the idea's status to `specifying`.

## 2. Interview
Use AskUserQuestion. Ask about things the user may not have thought through: the real users and their scenarios, scope and non-goals, edge cases and failure modes, data sources, constraints (cost, privacy, latency), what "done" looks like, and tradeoffs. Skip the obvious questions. Ask 1–4 related questions per round and keep going until the open questions are resolved or the user says stop.

**After every answer, before your next question,** append each question to the idea file's `## Q&A log` using the format in the template: date, stage `spec`, the question exactly as asked, the options offered, the user's answer verbatim, and its effect. That log is a permanent record and nothing in it gets removed.

## 3. Write
- Create `docs/specs/NNNN-slug/spec.md` from `docs/templates/spec.md`, using the same number and slug as the idea.
- Write behaviour, not implementation. Every acceptance criterion must be testable and must link to a requirement ID.
- Anything still unresolved goes under `## Open questions`.

## 4. Approve
Show the user a short summary (the goals, the must-have requirements and the open questions) and ask for approval. Log that question too. Once it is approved, set the spec to `approved` and the idea to `specified`, update `docs/ideas/README.md`, and suggest `/plan NNNN` in a fresh session.
