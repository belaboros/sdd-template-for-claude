---
name: idea
description: Capture a new idea verbatim into docs/ideas/ with a Q&A log. Use when the user brings a new feature, product or research idea, or runs /idea.
argument-hint: <the idea, in your own words>
---

Capture this idea: $ARGUMENTS

1. Find the next free number `NNNN` in `docs/ideas/` (4 digits, zero-padded).
2. Pick a short kebab-case slug and create `docs/ideas/NNNN-slug.md` from `docs/templates/idea.md`.
3. Paste the user's text **verbatim** under `## Original idea`, as a block quote. Do not fix typos, summarise or reorder it. If the idea came over several messages, quote each one and date it.
4. Set `Status: captured` and today's date.
5. Add a row to the table in `docs/ideas/README.md`.
6. Do not ask clarifying questions here; that is what `/spec` is for. If you must ask something (for example, whether this duplicates an existing idea), log the question and the answer in the new file's `## Q&A log`.
7. Tell the user the file path and suggest running `/spec NNNN` in a fresh session.
