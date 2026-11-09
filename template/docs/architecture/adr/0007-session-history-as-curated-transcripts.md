# ADR-0007: Save session history as curated transcripts in `docs/sessions/`

- **Status:** accepted
- **Date:** 2026-11-09
- **Origin:** foundation decision inherited from [sdd-template-for-claude](https://github.com/belaboros/sdd-template-for-claude)

## Context
Claude Code chat history is to be stored in this repo regularly. A raw transcript (`~/.claude/projects/<project>/<session>.jsonl`) contains thinking, every tool call and its full output (file contents, command output, possible secrets), injected context and environment details. That makes it large, impossible to review in a diff, risky to publish, and confusing for later sessions that search the repo.

## Decision
We will save each session as `docs/sessions/YYYYMMDD-HHMMSS-<session-id-prefix>.md` (the time of the session's first request in UTC, plus the first 8 characters of the session id, e.g. `20261109-131159-daba91b7.md`). Files then sort chronologically, and two sessions on the same day are easy to tell apart. Each file contains only:
1. **Summary:** an informal summary of the session, at most 5 sentences (written by a separate `claude -p --model haiku` call).
2. **The user's requests,** verbatim, with injected IDE and system context stripped out. Slash commands are kept as `/name args`.
3. **Claude's replies:** the text blocks only.

Left out: Claude's thinking and process, tool calls, tool output, subagent (sidechain) messages.

`tools/sessions/save-session.sh` builds the file from the transcript using `jq`. That makes extraction deterministic: requests and replies are copied, never paraphrased. A `SessionEnd` hook runs it automatically, which also covers `/clear`. Running it again on a resumed session overwrites the file with the complete history. Files are written but not committed; committing stays a deliberate step.

## Alternatives considered
| Option | Why not chosen |
|--------|----------------|
| Commit raw JSONL | Secrets, size, unreviewable diffs |
| A summary written entirely by an LLM | Requests and replies could be paraphrased or lost; the user wants them as they were |
| Raw transcripts in a separate private repo | Not requested; can still be added later in a new ADR |

## Consequences
- **Positive:** readable, reviewable history of what was asked and answered, with no tool noise.
- **Negative:** replies can still quote things the user pasted in, so review `docs/sessions/` before pushing, especially if the repo is public. The summary needs a working `claude` CLI login. If it fails, the file says so and can be regenerated.
- **Follow-up:** add a `gitleaks` pre-commit hook covering `docs/sessions/` once `.pre-commit-config.yaml` exists. Session files are history, not the source of truth: specs, ADRs and idea files win.
