"""Reject plaintext leaves in the repository's encrypted secret documents."""

import sys
from pathlib import Path

import yaml


def encrypted_leaves(value):
    if isinstance(value, dict):
        return bool(value) and all(encrypted_leaves(v) for v in value.values())
    if isinstance(value, list):
        return bool(value) and all(encrypted_leaves(v) for v in value)
    return isinstance(value, str) and value.startswith("ENC[AES256_GCM,") and value.endswith("]")


def main(root):
    files = sorted(Path(root).rglob("*.yaml"))
    if not files:
        raise SystemExit("No encrypted secret documents found")
    for path in files:
        doc = yaml.safe_load(path.read_text())
        if not isinstance(doc, dict) or not isinstance(doc.get("sops"), dict):
            raise SystemExit(f"Missing SOPS metadata: {path.name}")
        payload = {key: value for key, value in doc.items() if key != "sops"}
        if not encrypted_leaves(payload):
            raise SystemExit(f"Unencrypted secret value: {path.name}")
    print(f"PASS: {len(files)} secret documents contain only encrypted values")


if __name__ == "__main__":
    main(sys.argv[1])
