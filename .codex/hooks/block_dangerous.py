#!/usr/bin/env python3
"""Pre-tool hook: refuse destructive shell commands. Exit 2 = block."""
import json
import re
import sys

PATTERNS = [
    (r"\baz\b[^|;&]*\bdelete\b", "Azure delete commands"),
    (r"\bterraform\s+destroy\b", "terraform destroy"),
    (r"\bterraform\s+apply\b[^|;&]*-destroy\b", "terraform apply -destroy"),
    (r"\bgit\s+push\b[^|;&]*(--force\b|-f\b|--force-with-lease\b)", "git force-push"),
    (r"\brm\s+-[a-z]*r[a-z]*f?[a-z]*\s+(/|~|\$HOME)(\s|$|/\*)", "rm -rf on root/home"),
    (r"\bkubectl\s+delete\s+(ns|namespace)\b", "deleting Kubernetes namespaces"),
    (r"\bgit\s+(commit|push)\b[^|;&]*--no-verify\b", "skipping git hooks with --no-verify"),
    (r"\b(curl|wget)\b[^|;&]*\|\s*(sudo\s+)?(ba|z)?sh\b", "piping a download into a shell"),
    (r"\bDROP\s+(DATABASE|SCHEMA)\b", "dropping a database"),
]


def command_from(payload):
    ti = payload.get("tool_input", payload)
    cmd = ti.get("command", "") if isinstance(ti, dict) else ti
    return " ".join(cmd) if isinstance(cmd, list) else str(cmd)


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0
    cmd = command_from(payload)
    for pat, why in PATTERNS:
        if re.search(pat, cmd, re.IGNORECASE):
            print(f"Blocked by policy: {why}. Ask a human to run it.", file=sys.stderr)
            return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
