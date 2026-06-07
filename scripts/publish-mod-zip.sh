#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INFO_JSON="$ROOT/info.json"

if [[ ! -f "$INFO_JSON" ]]; then
    echo "Missing mod metadata file: $INFO_JSON" >&2
    exit 2
fi

MOD_NAME="$(python3 - "$INFO_JSON" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as file:
    info = json.load(file)

value = info.get("name")
if not value:
    raise SystemExit("info.json is missing required field: name")
print(value)
PY
)"

VERSION="$(python3 - "$INFO_JSON" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as file:
    info = json.load(file)

value = info.get("version")
if not value:
    raise SystemExit("info.json is missing required field: version")
print(value)
PY
)"

PACKAGE_NAME="${MOD_NAME}_${VERSION}"
ZIP_PATH="${ZIP_PATH:-"$ROOT/../${PACKAGE_NAME}.zip"}"

mkdir -p "$(dirname "$ZIP_PATH")"
rm -f "$ZIP_PATH"

python3 - "$ROOT" "$ZIP_PATH" "$PACKAGE_NAME" <<'PY'
from pathlib import Path
import sys
import zipfile

root = Path(sys.argv[1]).resolve()
zip_path = Path(sys.argv[2]).resolve()
package_name = sys.argv[3]

excluded_dirs = {
    ".git",
    ".github",
    ".idea",
    ".vscode",
    "__pycache__",
    "scripts",
}
excluded_files = {
    ".DS_Store",
    ".gitattributes",
    ".gitignore",
}
excluded_suffixes = {
    ".bat",
    ".exe",
    ".ps1",
    ".py",
    ".pyc",
    ".sh",
    ".zip",
}

included = 0
skipped = []

with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
    for source in sorted(root.rglob("*")):
        relative = source.relative_to(root)

        if any(part in excluded_dirs for part in relative.parts):
            continue
        if source.is_dir() or source.resolve() == zip_path:
            continue
        if source.name in excluded_files or source.suffix.lower() in excluded_suffixes:
            skipped.append(str(relative))
            continue

        archive.write(source, Path(package_name) / relative)
        included += 1

if included == 0:
    zip_path.unlink(missing_ok=True)
    raise SystemExit("No mod files were found to package.")

if skipped:
    print("Excluded non-release/helper files:")
    for item in skipped:
        print(f"  {item}")
PY

if unzip -Z1 "$ZIP_PATH" | grep -Eiq '\.(exe|bat|ps1|sh|py|pyc)$'; then
    echo "Package validation failed: executable/helper files were included." >&2
    rm -f "$ZIP_PATH"
    exit 2
fi

echo "Created mod zip: $ZIP_PATH"
