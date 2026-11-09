#!/usr/bin/env bash
# Claude Code PreToolUse hook (ADR-0006).
# Blocks writing a source file whose language has no quality gate in languages.json.
set -uo pipefail

root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
registry="$root/tools/quality/languages.json"

file=$(jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' 2>/dev/null)
[ -z "$file" ] && exit 0

name=$(basename "$file")
[[ "$name" != *.* ]] && exit 0
ext=$(printf '%s' "${name##*.}" | tr '[:upper:]' '[:lower:]')

case "$ext" in
  py|pyi|ipynb)                    lang=python ;;
  js|jsx|mjs|cjs|ts|tsx|mts|cts)   lang=js-ts ;;
  rs)                              lang=rust ;;
  go)                              lang=go ;;
  java|kt|kts|scala)               lang=jvm ;;
  cs|fs)                           lang=dotnet ;;
  c|h|cc|cpp|cxx|hpp)              lang=c-cpp ;;
  rb)                              lang=ruby ;;
  php)                             lang=php ;;
  swift)                           lang=swift ;;
  *)                               exit 0 ;;   # docs, config, shell scripts: not gated
esac

if jq -e --arg l "$lang" '.languages[] | select(.name == $l)' "$registry" >/dev/null 2>&1; then
  exit 0
fi

cat >&2 <<EOF
Blocked: '$file' is $lang, which has no quality gate yet (not in tools/quality/languages.json).
Run /add-language $lang first. It sets up complexity and coupling linters, boundary rules from
docs/architecture/components.json, the metrics collector and hooks, and records an ADR (ADR-0006).
Do not write the file another way to get around this check.
EOF
exit 2
