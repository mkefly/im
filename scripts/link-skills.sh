#!/usr/bin/env bash
# Link vendored skills (folders containing SKILL.md) into an agent's skills dir.
# Usage: scripts/link-skills.sh <target-dir> <repo-folder> [<repo-folder> ...]
#   scripts/link-skills.sh ~/.codex/skills  mattpocock__skills obra__superpowers
#   scripts/link-skills.sh ~/.claude/skills microsoft__azure-skills
#   scripts/link-skills.sh .github/skills   addyosmani__agent-skills
# Use 'all' as the repo folder to link every skill (thousands; not recommended).
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
target="$1"; shift
mkdir -p "$target"
[ "${1:-}" = all ] && set -- $(ls "$root/repos" | grep -v SOURCES.txt)
for repo in "$@"; do
  while IFS= read -r skill; do
    d="$(dirname "$skill")"; name="$(basename "$d")"
    link="$target/$name"
    [ -e "$link" ] && { echo "skip $name (exists)"; continue; }
    ln -s "$d" "$link" && echo "linked $repo/$name"
  done < <(find "$root/repos/$repo" -name SKILL.md -not -path '*/node_modules/*')
done
