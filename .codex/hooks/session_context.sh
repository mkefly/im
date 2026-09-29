#!/usr/bin/env bash
# SessionStart hook: plain stdout is added to the model's context.
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 0
if git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Repository: $(basename "$PWD")  branch: $(git branch --show-current 2>/dev/null)"
  changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  echo "Uncommitted changes: $changes file(s)"
  echo "Recent commits:"; git log --oneline -5 2>/dev/null | sed 's/^/  /'
fi
if command -v az >/dev/null 2>&1; then
  sub=$(az account show --query name -o tsv 2>/dev/null) && echo "Active Azure subscription: $sub (confirm before deploying)"
fi
echo "Follow AGENTS.md. Destructive commands and secret edits are blocked by hooks."
exit 0
