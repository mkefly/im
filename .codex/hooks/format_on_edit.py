#!/usr/bin/env python3
"""PostToolUse hook for apply_patch: run the matching formatter on each file the
patch touched, if that formatter is installed. Never blocks."""
import json
import os
import re
import shutil
import subprocess
import sys

FORMATTERS = [
    ((".py",), [["ruff", "format", "-q"], ["black", "-q"]]),
    ((".js", ".jsx", ".ts", ".tsx", ".json", ".css", ".scss", ".md", ".yaml", ".yml", ".html"),
     [["prettier", "--write", "--log-level", "silent"]]),
    ((".tf", ".tfvars"), [["terraform", "fmt"]]),
    ((".bicep",), [["az", "bicep", "format", "--file"]]),
    ((".go",), [["gofmt", "-w"]]),
    ((".rs",), [["rustfmt", "--edition", "2021"]]),
    ((".sh",), [["shfmt", "-w"]]),
    ((".cs",), [["dotnet", "csharpier"]]),
]


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return
    patch = str(payload.get("tool_input", {}).get("command", ""))
    cwd = payload.get("cwd") or os.getcwd()
    paths = re.findall(r"^\*\*\* (?:Add|Update) File: (.+)$|^\*\*\* Move to: (.+)$", patch, re.MULTILINE)
    for path in {a or b for a, b in paths}:
        path = os.path.join(cwd, path.strip())
        if not os.path.isfile(path):
            continue
        for exts, cmds in FORMATTERS:
            if path.endswith(exts):
                for cmd in cmds:
                    if shutil.which(cmd[0]):
                        subprocess.run(cmd + [path], cwd=cwd, capture_output=True, timeout=60)
                        break
                break


if __name__ == "__main__":
    try:
        main()
    except Exception:
        pass
    sys.exit(0)
