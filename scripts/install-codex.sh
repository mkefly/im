#!/usr/bin/env bash
# Set up Codex from this repo: local plugin marketplace, recommended plugins,
# MCP servers and (optionally) the safety hooks for every project.
#   scripts/install-codex.sh            # plugins + MCP servers
#   scripts/install-codex.sh --global   # also install hooks into ~/.codex
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
command -v codex >/dev/null || { echo "Install Codex first: npm i -g @openai/codex"; exit 1; }

RECOMMENDED=(
  superpowers mattpocock-skills andrej-karpathy-skills agent-skills   # engineering workflow
  azure azure-cost microsoft-docs microsoft-foundry azure-sdk-python   # Azure
  terraform context7                                                   # IaC + live library docs
  block-no-verify comprehensive-review tdd-workflows error-debugging   # quality
  security-scanning static-analysis insecure-defaults supply-chain-risk-auditor differential-review  # security
)

echo "==> Registering local marketplace 'ai-agent-toolkit'"
codex plugin marketplace add "$root" || true

echo "==> Installing recommended plugins"
for p in "${RECOMMENDED[@]}"; do
  codex plugin add "$p@ai-agent-toolkit" || echo "   (skipped $p)"
done

echo "==> Adding MCP servers"
codex mcp add github --env GITHUB_PERSONAL_ACCESS_TOKEN="${GITHUB_TOKEN:-}" -- \
  docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server || true
codex mcp add playwright -- npx -y @playwright/mcp@latest || true
codex mcp add azure -- npx -y @azure/mcp@latest server start || true

if [ "${1:-}" = "--global" ]; then
  echo "==> Installing hooks globally into ~/.codex"
  mkdir -p ~/.codex/hooks
  cp "$root"/.codex/hooks/* ~/.codex/hooks/
  sed 's#$(git rev-parse --show-toplevel)/.codex/hooks#'"$HOME"'/.codex/hooks#g' \
    "$root/.codex/hooks.json" > ~/.codex/hooks.json
fi

echo "Done. Start codex, run /hooks to trust the hooks, and /plugins to browse all 158 plugins."
