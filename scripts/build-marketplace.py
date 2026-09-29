#!/usr/bin/env python3
"""Scan repos/ for plugin manifests (.codex-plugin or .claude-plugin plugin.json)
and write .agents/plugins/marketplace.json so Codex can install them locally:
    codex plugin marketplace add ./
    codex plugin add <name>@ai-agent-toolkit
"""
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
SKIP = ("node_modules", "/tests/", "/test/", "fixtures", "openai__codex/codex-rs")

plugins, seen = [], set()
for kind in (".codex-plugin", ".claude-plugin"):
    for manifest in sorted(ROOT.glob(f"repos/**/{kind}/plugin.json")):
        rel = manifest.parent.parent.relative_to(ROOT).as_posix()
        if any(s in f"/{rel}/" for s in SKIP) or rel in seen:
            continue
        try:
            data = json.loads(manifest.read_text(encoding="utf-8"))
        except Exception:
            continue
        name = data.get("name")
        if not name or name in {p["name"] for p in plugins}:
            continue
        seen.add(rel)
        iface = data.get("interface") or {}
        plugins.append({
            "name": name,
            "description": (data.get("description") or iface.get("shortDescription") or "")[:300],
            "source": {"source": "local", "path": f"./{rel}"},
            "policy": {"installation": "AVAILABLE", "authentication": "ON_USE"},
            "category": iface.get("category") or "Coding",
        })

plugins.sort(key=lambda p: p["name"])
out = {
    "name": "ai-agent-toolkit",
    "interface": {"displayName": "AI Agent Toolkit (vendored)"},
    "plugins": plugins,
}
path = ROOT / ".agents/plugins/marketplace.json"
path.write_text(json.dumps(out, indent=2) + "\n", encoding="utf-8")
print(f"wrote {len(plugins)} plugins to {path.relative_to(ROOT)}")
