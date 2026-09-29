#!/usr/bin/env python3
"""PreToolUse hook for apply_patch: refuse edits to secret files and patches
that add credentials. Exit 2 = block (stderr is shown to the agent)."""
import json
import re
import sys

SECRET_PATHS = re.compile(
    r"(^|/)(\.env(\.[\w-]+)?|id_(rsa|ed25519|ecdsa)|[^/]*\.(pem|key|pfx|p12)|"
    r"secrets?\.(json|ya?ml|toml)|credentials(\.json)?|\.npmrc|\.pypirc|terraform\.tfstate(\.backup)?)$",
    re.IGNORECASE,
)
ALLOWED = re.compile(r"\.(example|sample|template)$|\.env\.(example|sample|template)$", re.IGNORECASE)

SECRET_VALUES = [
    (r"-----BEGIN (RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----", "a private key"),
    (r"\bAKIA[0-9A-Z]{16}\b", "an AWS access key"),
    (r"\bgh[pousr]_[A-Za-z0-9]{36,}\b", "a GitHub token"),
    (r"\bgithub_pat_[A-Za-z0-9_]{60,}\b", "a GitHub token"),
    (r"\bsk-(proj-)?[A-Za-z0-9_-]{32,}\b", "an OpenAI-style API key"),
    (r"\bsk-ant-[A-Za-z0-9_-]{32,}\b", "an Anthropic API key"),
    (r"\bxox[baprs]-[A-Za-z0-9-]{10,}\b", "a Slack token"),
    (r"AccountKey=[A-Za-z0-9+/=]{40,}", "an Azure storage account key"),
    (r"\bSharedAccessKey=[A-Za-z0-9+/=]{20,}", "an Azure SAS/Service Bus key"),
]


def block(msg):
    print(f"Blocked by policy: {msg}. Use a secret store / env var instead.", file=sys.stderr)
    sys.exit(2)


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return
    patch = str(payload.get("tool_input", {}).get("command", ""))
    for m in re.finditer(r"^\*\*\* (?:Add|Update|Delete) File: (.+)$", patch, re.MULTILINE):
        path = m.group(1).strip()
        if SECRET_PATHS.search(path) and not ALLOWED.search(path):
            block(f"editing secret file '{path}'")
    added = "\n".join(l[1:] for l in patch.splitlines() if l.startswith("+"))
    for pat, what in SECRET_VALUES:
        if re.search(pat, added):
            block(f"the patch adds {what}")


if __name__ == "__main__":
    main()
