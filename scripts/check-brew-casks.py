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
    config = json.loads(
        subprocess.check_output(
            [
                "nix",
                "eval",
                "--json",
                "--option",
                "allow-import-from-derivation",
                "false",
                f"{root}#darwinConfigurations.{args.host}.config",
                "--apply",
                "cfg: { names = map (c: c.name) cfg.homebrew.casks; "
                "taps = builtins.mapAttrs (_: tap: toString tap) cfg.nix-homebrew.taps; }",
            ],
            text=True,
        )
    )
    names = config["names"]
    if not names:
        print(f"PASS: {args.host} declares no casks")
        return 0
    brew = shutil.which("brew")
    if brew is None:
        parser.error("Homebrew is required for macOS cask availability checks")
    definitions = []
    for name in names:
        if "/" in name:
            owner, tap, token = name.split("/")
            tap_name = f"{owner}/homebrew-{tap}"
        else:
            token = name
            tap_name = "homebrew/homebrew-cask"
        source = Path(config["taps"][tap_name]) / "Casks"
        matches = list(source.rglob(f"{token}.rb"))
        if len(matches) != 1:
            parser.error(f"Expected one pinned cask for {name}, found {len(matches)}")
        definitions.append({"path": str(matches[0]), "tap": tap_name})

    # Evaluate the pinned Ruby DSL for this Mac without installing taps or apps.
    # Developer mode is process-local, so `brew ruby` does not enable it globally.
    env = os.environ | {
        "HOMEBREW_NO_AUTO_UPDATE": "1",
        "HOMEBREW_NO_ANALYTICS": "1",
        "HOMEBREW_DEVELOPER": "1",
    }
    ruby = """
require "cask/cask_loader"
result = JSON.parse(STDIN.read).map do |definition|
  cask = Cask::CaskLoader::FromContentLoader.new(
    File.read(definition.fetch("path")), tap: Tap.fetch(definition.fetch("tap"))
  ).load(config: nil)
  { token: cask.token, disabled: cask.disabled?, disable_reason: cask.disable_reason }
end
puts JSON.generate({ casks: result })
"""
    result = json.loads(
        subprocess.check_output(
            [brew, "ruby", "-e", ruby],
            input=json.dumps(definitions),
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
