#!/usr/bin/env python3
"""Check actual macOS cask availability without installing applications."""

import argparse
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("host", nargs="?", default="luna")
    args = parser.parse_args()
    root = Path(__file__).resolve().parent.parent
    names = json.loads(
        subprocess.check_output(
            [
                "nix",
                "eval",
                "--json",
                "--option",
                "allow-import-from-derivation",
                "false",
                f"{root}#darwinConfigurations.{args.host}.config.homebrew.casks",
                "--apply",
                "casks: map (c: c.name) casks",
            ],
            text=True,
        )
    )
    if not names:
        print(f"PASS: {args.host} declares no casks")
        return 0
    brew = shutil.which("brew")
    if brew is None:
        parser.error("Homebrew is required for macOS cask availability checks")
    env = os.environ | {"HOMEBREW_NO_AUTO_UPDATE": "1", "HOMEBREW_NO_ANALYTICS": "1"}
    result = json.loads(
        subprocess.check_output(
            [brew, "info", "--cask", "--json=v2", *names],
            env=env,
            text=True,
        )
    )
    disabled = [c for c in result["casks"] if c["disabled"]]
    for cask in disabled:
        print(f"DISABLED: {cask['token']}: {cask['disable_reason']}", file=sys.stderr)
    if disabled:
        return 1
    print(f"PASS: {len(names)} {args.host} casks are enabled on this Mac")
    return 0


if __name__ == "__main__":
    sys.exit(main())
