#!/usr/bin/env python3
"""UserPromptSubmit hook: stop a prompt that contains a credential before it is
sent to the model. Exit 2 = block."""
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from protect_secrets import SECRET_VALUES  # noqa: E402


def main():
    try:
        prompt = str(json.load(sys.stdin).get("prompt", ""))
    except Exception:
        return 0
    for pat, what in SECRET_VALUES:
        if re.search(pat, prompt):
            print(f"Your prompt appears to contain {what}. Remove it and use an env var or Key Vault reference.", file=sys.stderr)
            return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
