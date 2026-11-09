# Sessions

One file per Claude Code session (ADR-0007): a short summary, the user's requests word for word, and Claude's replies. Thinking, tool calls and tool output are left out.

- Written automatically when a session ends (`SessionEnd` hook → [tools/sessions/save-session.sh](../../tools/sessions/save-session.sh)).
- To save mid-session or regenerate a file: `tools/sessions/save-session.sh [path/to/transcript.jsonl]`. Without an argument it uses the newest session of this project.
- File name: `YYYYMMDD-HHMMSS-<first 8 characters of the session id>.md`; the time is the session's first request, in UTC.
- Review before committing. These files are history, not the source of truth: specs, ADRs and idea files take precedence.
