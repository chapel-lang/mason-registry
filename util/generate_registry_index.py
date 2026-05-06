#!/usr/bin/env python3
"""Generate a JSON index of all packages in the Mason registry.

Reads every Bricks/<Package>/<X.Y.Z>.toml file and writes index.json at the
repo root with the shape:

    { [package: string]: Version[] }

where each Version contains the fields present in the [brick] table:
version, chplVersion, authors, license, source, copyrightYear.
Keys are omitted when not present in the TOML file.
"""

import json
import subprocess
import sys
from pathlib import Path

try:
    import tomllib
except ImportError:
    try:
        import tomli as tomllib  # type: ignore[no-redef]
    except ImportError:
        print(
            "Error: tomllib (Python 3.11+) or the 'tomli' package is required.",
            file=sys.stderr,
        )
        sys.exit(1)

REPO_ROOT = Path(__file__).parent.parent
BRICKS_DIR = REPO_ROOT / "Bricks"
OUTPUT_FILE = REPO_ROOT / "index.json"

OPTIONAL_KEYS = ("chplVersion", "authors", "license", "source", "copyrightYear", "type")


def semver_key(toml_path: Path) -> tuple[int, ...]:
    """Return an (X, Y, Z) tuple for semver-correct sorting of version filenames."""
    parts = toml_path.stem.split(".")
    try:
        return tuple(-int(p) for p in parts)
    except ValueError:
        return (0, 0, 0)


def normalize_authors(value: str | list[str]) -> list[str]:
    if isinstance(value, list):
        return value
    return [value]


def git_creation_date(path: Path) -> str | None:
    """Return the ISO 8601 date when the file was first committed, or None."""
    result = subprocess.run(
        [
            "git", "--no-pager", "log",
            "--follow", "--diff-filter=A", "--format=%aI",
            "--", str(path),
        ],
        capture_output=True,
        text=True,
    )
    date = result.stdout.strip()
    return date if date else None


def build_index() -> dict[str, list[dict]]:
    index: dict[str, list[dict]] = {}

    for pkg_dir in sorted(BRICKS_DIR.iterdir(), key=lambda x: str(x).lower()):
        if not pkg_dir.is_dir():
            continue

        if pkg_dir.name in ("_MasonTest1", "_MasonTest2"):
            continue

        versions: list[dict] = []
        for toml_file in sorted(pkg_dir.glob("*.toml"), key=semver_key):
            with open(toml_file, "rb") as f:
                data = tomllib.load(f)

            brick = data.get("brick", {})
            declared = brick.get("version")
            if declared != toml_file.stem:
                print(
                    f"Error: {toml_file}: filename '{toml_file.stem}' does not match "
                    f"declared version '{declared}'",
                    file=sys.stderr,
                )
                sys.exit(1)
            entry: dict = {"version": declared}

            created = git_creation_date(toml_file)
            if created is not None:
                entry["createdDate"] = created

            for key in OPTIONAL_KEYS:
                if key in brick:
                    value = brick[key]
                    if key == "authors":
                        value = normalize_authors(value)
                    entry[key] = value

            versions.append(entry)

        if versions:
            index[pkg_dir.name] = versions

    return index


def main() -> None:
    index = build_index()
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(index, f, indent=2)
        f.write("\n")
    print(f"Wrote {OUTPUT_FILE} ({len(index)} packages)")


if __name__ == "__main__":
    main()
