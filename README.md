# AI Agent Toolkit

Skills, plugins, hooks and MCP servers for **Codex**, **GitHub Copilot** and **Claude Code**. The code from all 22 source repositories is **stored in this repo** under [`repos/`](repos), so nothing has to be downloaded from the original repositories.

## Quick start (Codex)

```bash
git clone -b claude/ai-agent-toolkit-repo-550icz https://github.com/mkefly/im.git ai-agent-toolkit
cd ai-agent-toolkit
scripts/install-codex.sh --global      # Windows: .\scripts\install-codex.ps1 -Global
```

This does four things:

1. Registers this repo as a local Codex plugin marketplace (`.agents/plugins/marketplace.json`, **158 plugins** built from the stored repos).
2. Installs 20 recommended plugins: Superpowers, Matt Pocock, Karpathy guidelines, addyosmani agent-skills, Azure, Azure cost, Microsoft Docs, Foundry, Azure SDK (Python), Terraform, Context7, block-no-verify, comprehensive-review, TDD, error-debugging and Trail of Bits security plugins.
3. Adds the GitHub, Playwright and Azure MCP servers (set `GITHUB_TOKEN` first).
4. With `--global`, installs the hooks below into `~/.codex` so they apply to every project.

Then start `codex`, run **`/hooks`** once to trust the hooks, and use **`/plugins`** to browse or add more.

## Hooks (`.codex/hooks.json`)

| Event | Script | What it does |
|---|---|---|
| `SessionStart` | `session_context.sh` | Gives the agent the branch, uncommitted changes, recent commits and active Azure subscription. |
| `UserPromptSubmit` | `scan_prompt_secrets.py` | Stops a prompt that contains an API key, token or private key. |
| `PreToolUse` · `Bash` | `block_dangerous.py` | Blocks `az … delete`, `terraform destroy`, force-push, `--no-verify`, `rm -rf /` and `~`, `kubectl delete ns`, `curl … \| sh`, `DROP DATABASE`. |
| `PreToolUse` · `apply_patch` | `protect_secrets.py` | Blocks edits to `.env`, keys, `*.pem`, `tfstate`, credentials files, and patches that add AWS, GitHub, OpenAI, Anthropic, Slack or Azure keys. |
| `PostToolUse` · `apply_patch` | `format_on_edit.py` | Formats each edited file with ruff/black, prettier, `terraform fmt`, `az bicep format`, gofmt, rustfmt, shfmt or csharpier, when installed. |

Each hook works as a project hook when Codex is opened in this repo, or globally with `--global`.

## Using skills without plugins

```bash
scripts/link-skills.sh ~/.codex/skills  mattpocock__skills obra__superpowers microsoft__azure-skills
scripts/link-skills.sh ~/.claude/skills anthropics__skills
scripts/link-skills.sh .github/skills   addyosmani__agent-skills     # Copilot
```

## What's inside `repos/`

| Repo | What it is | SKILL.md files | Pinned commit |
|---|---|---:|---|
| [`mattpocock/skills`](repos/mattpocock__skills) | Matt Pocock's engineering skills: grilling, specs, TDD, code review | 37 | [d81f3a1](https://github.com/mattpocock/skills/tree/d81f3a183412e71a5b1e84ca21bc1a35eea03a60) |
| [`obra/superpowers`](repos/obra__superpowers) | Superpowers: brainstorm → plan → TDD → review workflow skills | 15 | [8ca22db](https://github.com/obra/superpowers/tree/8ca22dba9a94f28898bbce59f2537ff4d87c747d) |
| [`forrestchang/andrej-karpathy-skills`](repos/forrestchang__andrej-karpathy-skills) | Karpathy-derived guidelines against common LLM coding mistakes | 1 | [2c60614](https://github.com/forrestchang/andrej-karpathy-skills/tree/2c606141936f1eeef17fa3043a72095b4765b9c2) |
| [`addyosmani/agent-skills`](repos/addyosmani__agent-skills) | Addy Osmani's production engineering skills | 25 | [2686b62](https://github.com/addyosmani/agent-skills/tree/2686b620fc1fed2e8f60c704839c766b8594c6b6) |
| [`anthropics/skills`](repos/anthropics__skills) | Anthropic's official skills (docx, pdf, xlsx, pptx, skill-creator…) | 20 | [8a1541c](https://github.com/anthropics/skills/tree/8a1541c4a3ffa5a20a5a91de0dcf3f0bab1d1ef4) |
| [`openai/skills`](repos/openai__skills) | OpenAI's curated skills catalog for Codex | 44 | [49f948f](https://github.com/openai/skills/tree/49f948faa9258a0c61caceaf225e179651397431) |
| [`microsoft/azure-skills`](repos/microsoft__azure-skills) | Official Azure skills + Azure MCP plugin | 86 | [f07c053](https://github.com/microsoft/azure-skills/tree/f07c05364353925f7c8b0e474aa95afa291bce54) |
| [`microsoft/skills`](repos/microsoft__skills) | Large Microsoft/Azure SDK and Foundry skills catalog | 205 | [3495f50](https://github.com/microsoft/skills/tree/3495f50ae0d7b69dcb19c6922db9f80aab6cf79c) |
| [`github/awesome-copilot`](repos/github__awesome-copilot) | Community Copilot instructions, prompts, agents and skills | 443 | [997e95a](https://github.com/github/awesome-copilot/tree/997e95a6e42869c350f8ca6ec4c066287697c9f0) |
| [`hashicorp/agent-skills`](repos/hashicorp__agent-skills) | Terraform and Packer skills | 20 | [f706481](https://github.com/hashicorp/agent-skills/tree/f706481af9b8fedb66de909f6243ad29601afa0c) |
| [`vercel-labs/agent-skills`](repos/vercel-labs__agent-skills) | Vercel's React/Next.js and deployment skills | 9 | [063bee9](https://github.com/vercel-labs/agent-skills/tree/063bee94c3f4df8453406c830b0a7df0f2860278) |
| [`trailofbits/skills`](repos/trailofbits__skills) | Trail of Bits security auditing and review skills | 85 | [82fe822](https://github.com/trailofbits/skills/tree/82fe8226252622fa807643bdca1710901198553a) |
| [`wshobson/agents`](repos/wshobson__agents) | ~90 plugins of agents, commands and skills | 184 | [156b7a5](https://github.com/wshobson/agents/tree/156b7a5e7a8b93642628a339ee4039c925b34c7f) |
| [`ComposioHQ/awesome-claude-skills`](repos/ComposioHQ__awesome-claude-skills) | Curated community skills list (with many skills) | 864 | [be2a406](https://github.com/ComposioHQ/awesome-claude-skills/tree/be2a406907dbc61b73e6827ded415c96139d13a2) |
| [`VoltAgent/awesome-agent-skills`](repos/VoltAgent__awesome-agent-skills) | Curated index of agent skills | 0 | [af465bb](https://github.com/VoltAgent/awesome-agent-skills/tree/af465bbef5632ee23cf20a2291df31b29d3fd0c9) |
| [`github/github-mcp-server`](repos/github__github-mcp-server) | GitHub's official MCP server | 0 | [85598ba](https://github.com/github/github-mcp-server/tree/85598ba6e1256f7ebf4867b95d63b833c4549264) |
| [`MicrosoftDocs/mcp`](repos/MicrosoftDocs__mcp) | Microsoft Learn docs MCP server + plugin | 4 | [f8ffde1](https://github.com/MicrosoftDocs/mcp/tree/f8ffde185dfd232dbf5d187c22ce299eadc3d583) |
| [`upstash/context7`](repos/upstash__context7) | Context7: up-to-date library docs MCP | 9 | [83e972e](https://github.com/upstash/context7/tree/83e972e8b0fa2fb9dde78c451358d4209a9c0236) |
| [`microsoft/playwright-mcp`](repos/microsoft__playwright-mcp) | Playwright browser automation MCP | 0 | [f183dad](https://github.com/microsoft/playwright-mcp/tree/f183dad4a52965583e3cc1d59b88cdc279e2e57d) |
| [`microsoft/mcp`](repos/microsoft__mcp) | Azure MCP server and other Microsoft MCP servers | 6 | [c60a750](https://github.com/microsoft/mcp/tree/c60a750bd30d72d1df654d557c4d2862a59d6f6a) |
| [`microsoft/apm`](repos/microsoft__apm) | APM: agent package manager | 88 | [cd22403](https://github.com/microsoft/apm/tree/cd22403752cd14fad0fbee993629b0ae3a5d4094) |
| [`openai/codex`](repos/openai__codex) | Codex CLI source (reference for hooks, plugins, config) | 16 | [8ffd91e](https://github.com/openai/codex/tree/8ffd91e42aa001b7e897bea812b02f89264f9fa0) |

## Updating

```bash
scripts/update-repos.sh                         # all 22 repos
scripts/update-repos.sh obra/superpowers        # just one
python3 scripts/build-marketplace.py            # rebuild the plugin list
git add -A -f repos .agents && git commit -m "Update vendored repos"
```

`git add -f` is needed because some upstream repos have `.gitignore` rules that would skip files they themselves track.

## Licenses

Each folder in `repos/` keeps its original license. Some repos do not include a license file: `anthropics/skills` (licenses are per skill), `openai/skills`, `vercel-labs/agent-skills`, `ComposioHQ/awesome-claude-skills` and `forrestchang/andrej-karpathy-skills` (MIT stated in its plugin manifest). Check before making this repository public.
