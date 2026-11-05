#!/usr/bin/env python3
"""Safely unpack CODEV source while preserving repository-owned docs and workflows."""
from __future__ import annotations
import shutil
import sys
import tempfile
import zipfile
from pathlib import Path

ROOT = Path.cwd()
ARCHIVE = Path(sys.argv[1] if len(sys.argv) > 1 else "source/Codev-Desktop-v16.20.6-R11-FULL-SOURCE.zip")
PRESERVE = {
    ".github", ".git", "docs", "patches", "source", "node_modules", "release",
    ".visual-smoke-home", "README.md", "readme.md", "CONTRIBUTING.md",
    "CHANGELOG.md", "PLUGIN-CREDENTIALS-VI.md",
}
REQUIRED = (
    "package.json", "VERSION.txt", "worker.js",
    "desktop/electron/main.mjs", "desktop/electron/electron-builder.config.cjs",
    "cli/go.mod", "cli/cmd/codev/main.go",
)

def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)

if not ARCHIVE.is_file():
    fail(f"Missing {ARCHIVE}. Upload the full R11 source ZIP to this path in the repository.")

with tempfile.TemporaryDirectory(prefix="codev-source-") as temp:
    temp_root = Path(temp).resolve()
    with zipfile.ZipFile(ARCHIVE) as bundle:
        for info in bundle.infolist():
            target = (temp_root / info.filename).resolve()
            if target != temp_root and temp_root not in target.parents:
                fail(f"Unsafe path in source archive: {info.filename}")
        bundle.extractall(temp_root)

    source_root = None
    for package_file in temp_root.rglob("package.json"):
        candidate = package_file.parent
        if all((candidate / item).is_file() for item in REQUIRED):
            source_root = candidate
            break
    if source_root is None:
        fail("Archive does not contain the complete CODEV Desktop/Worker/CLI source tree.")

    for item in source_root.iterdir():
        if item.name in PRESERVE:
            continue
        destination = ROOT / item.name
        if item.is_dir():
            shutil.copytree(item, destination, dirs_exist_ok=True)
        else:
            shutil.copy2(item, destination)

for required in REQUIRED:
    if not (ROOT / required).is_file():
        fail(f"Source import did not provide {required}.")

version = (ROOT / "VERSION.txt").read_text(encoding="utf-8").strip()
print(f"Imported CODEV source version {version} from {ARCHIVE}")
print("Preserved repository docs, patches, and GitHub workflows.")
