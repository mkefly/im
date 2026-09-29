#!/usr/bin/env bash
# Re-download the latest version of every vendored repo into repos/
# and record the pinned commit in repos/SOURCES.txt.
# Usage: scripts/update-repos.sh [owner/repo ...]   (default: all in SOURCES.txt)
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
sources="$root/repos/SOURCES.txt"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

if [ $# -gt 0 ]; then list=("$@"); else mapfile -t list < <(awk '{print $2}' "$sources"); fi

for r in "${list[@]}"; do
  dir="$root/repos/${r/\//__}"
  echo "==> $r"
  git clone -q --depth 1 "https://github.com/$r" "$tmp/src"
  sha="$(git -C "$tmp/src" rev-parse HEAD)"
  rm -rf "$tmp/src/.git" "$dir"
  mv "$tmp/src" "$dir"
  grep -v " $r\$" "$sources" > "$tmp/s" || true
  echo "$sha $r" >> "$tmp/s"
  sort -k2 "$tmp/s" > "$sources"
done
echo "Done. Review with 'git status', then: git add -A -f repos && git commit -m 'Update vendored repos'"
