#!/usr/bin/env bash
# Saves a Claude Code session as docs/sessions/YYYYMMDD-HHMMSS-<id8>.md (ADR-0007; time = first request, UTC).
# Kept: a short summary, the user's requests, and Claude's text replies.
# Left out: thinking, tool calls, tool output, injected context.
#
# Usage:
#   as a SessionEnd hook: reads {"transcript_path": ...} from stdin
#   manually:             save-session.sh [transcript.jsonl]   (default: newest session of this project)
set -uo pipefail

[ "${RA_SESSION_SUMMARY_CHILD:-}" = 1 ] && exit 0   # don't recurse from the summariser run

root="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
outdir="$root/docs/sessions"

resolve_transcript() {
  if [ -n "${1:-}" ]; then echo "$1"; return; fi
  if [ ! -t 0 ]; then
    local p; p=$(jq -r '.transcript_path // empty' 2>/dev/null)
    [ -n "$p" ] && { echo "$p"; return; }
  fi
  local proj; proj="$HOME/.claude/projects/$(printf '%s' "$root" | sed 's/[^a-zA-Z0-9]/-/g')"
  # newest transcript by modification time (session ids are UUIDs, so ls is safe here)
  # shellcheck disable=SC2012
  ls -t "$proj"/*.jsonl 2>/dev/null | head -1
}

# Emits the turns as JSON: [{ts, request, responses:[...]}]
extract_turns() {
  jq -s '
    def unwrap_command:
      if test("<command-name>") then
        ((capture("<command-name>(?<n>[^<]*)</command-name>").n // "")
         + " " + ((capture("<command-args>(?<a>[\\s\\S]*?)</command-args>").a) // ""))
      else . end;
    def strip_injected: gsub("<(?<t>[a-z][a-z_-]*)>[\\s\\S]*?</\\k<t>>"; "");
    def clean: unwrap_command | strip_injected | gsub("^\\s+|\\s+$"; "");
    def texts: if type == "string" then [.] else [.[]? | select(.type == "text") | .text] end;

    [ .[] | select((.isSidechain | not) and (.isMeta | not))
      | if .type == "user" then
          (.message.content | texts | map(clean) | map(select(length > 0)) | join("\n\n")) as $t
          | select($t | length > 0) | {role: "user", ts: .timestamp, text: $t}
        elif .type == "assistant" then
          (.message.content | texts | join("\n\n")) as $t
          | select($t | length > 0) | {role: "assistant", text: $t}
        else empty end ]
    | reduce .[] as $m ([];
        if $m.role == "user" then . + [{ts: $m.ts, request: $m.text, responses: []}]
        elif length > 0 then .[-1].responses += [$m.text]
        else . end)
  ' "$1"
}

render_conversation() {
  jq -r '
    to_entries[] |
    "## \(.key + 1) · \(.value.ts[11:16]) UTC\n\n### Request\n\n"
    + (.value.request | split("\n") | map("> " + .) | join("\n"))
    + "\n\n### Response\n\n"
    + (if (.value.responses | length) > 0 then (.value.responses | join("\n\n")) else "_No text reply._" end)
    + "\n"
  ' <<<"$1"
}

summarise() {
  local prompt="Below is a conversation between a user and Claude Code. Write an informal summary of what happened in the session, at most 5 sentences. Output only the summary."
  ( cd "${TMPDIR:-/tmp}" && printf '%s\n\n%s' "$prompt" "$1" \
      | RA_SESSION_SUMMARY_CHILD=1 CLAUDECODE='' timeout 120 claude -p --model haiku --no-session-persistence 2>/dev/null )
}

write_file() {   # $1 file, $2 title, $3 date, $4 session id, $5 summary, $6 conversation
  cat >"$1" <<EOF
# Session $3 · $2

- **Session:** \`$4\`
- **Saved:** $(date -u +%Y-%m-%dT%H:%MZ)

## Summary

$5

---

$6
EOF
}

main() {
  local transcript; transcript=$(resolve_transcript "${1:-}")
  [ -f "$transcript" ] || { echo "save-session: no transcript found" >&2; exit 0; }

  local turns; turns=$(extract_turns "$transcript")
  [ "$(jq length <<<"$turns")" -gt 0 ] || exit 0

  local id date stamp title conv file
  id=$(basename "$transcript" .jsonl)
  date=$(jq -r '.[0].ts[0:10]' <<<"$turns")
  stamp=$(jq -r '.[0].ts | gsub("[-:]"; "") | .[0:8] + "-" + .[9:15]' <<<"$turns")
  title=$(jq -r 'select(.type == "ai-title") | .aiTitle' "$transcript" | tail -1)
  [ -n "$title" ] || title="Untitled session"
  conv=$(render_conversation "$turns")
  mkdir -p "$outdir"
  file="$outdir/$stamp-${id:0:8}.md"

  write_file "$file" "$title" "$date" "$id" "_Summary is being generated…_" "$conv"
  # The summary takes a model call; run it detached so the session can close straight away.
  ( summary=$(summarise "$conv"); [ -n "$summary" ] || summary="_Summary could not be generated; run tools/sessions/save-session.sh again._"
    write_file "$file" "$title" "$date" "$id" "$summary" "$conv" ) </dev/null >/dev/null 2>&1 &
  disown 2>/dev/null || true
  echo "save-session: wrote ${file#"$root"/}"
}

main "$@"
