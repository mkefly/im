# Windows version of install-codex.sh.  Usage: .\scripts\install-codex.ps1 [-Global]
param([switch]$Global)
$ErrorActionPreference = "Continue"
$root = Split-Path -Parent $PSScriptRoot
if (-not (Get-Command codex -ErrorAction SilentlyContinue)) { throw "Install Codex first: npm i -g @openai/codex" }

$recommended = @(
  "superpowers","mattpocock-skills","andrej-karpathy-skills","agent-skills",
  "azure","azure-cost","microsoft-docs","microsoft-foundry","azure-sdk-python",
  "terraform","context7",
  "block-no-verify","comprehensive-review","tdd-workflows","error-debugging",
  "security-scanning","static-analysis","insecure-defaults","supply-chain-risk-auditor","differential-review"
)

codex plugin marketplace add $root
foreach ($p in $recommended) { codex plugin add "$p@ai-agent-toolkit" }

codex mcp add github --env "GITHUB_PERSONAL_ACCESS_TOKEN=$env:GITHUB_TOKEN" -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
codex mcp add playwright -- npx -y "@playwright/mcp@latest"
codex mcp add azure -- npx -y "@azure/mcp@latest" server start

if ($Global) {
  $dest = Join-Path $HOME ".codex\hooks"
  New-Item -ItemType Directory -Force $dest | Out-Null
  Copy-Item "$root\.codex\hooks\*" $dest -Force
  (Get-Content "$root\.codex\hooks.json" -Raw) `
    -replace '\$\(git rev-parse --show-toplevel\)/\.codex/hooks', ($dest -replace '\\','/') |
    Set-Content (Join-Path $HOME ".codex\hooks.json")
}
Write-Host "Done. Start codex, run /hooks to trust the hooks, and /plugins to browse all plugins."
