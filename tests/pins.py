"""Check repository action references without fetching actions or dependencies."""

import argparse
from pathlib import Path
import re
import sys


USES = re.compile(r"^\s*(?:-\s*)?(?:uses|'uses'|\"uses\")\s*:\s*(.*)$")
PINNED = re.compile(r"[^\s@]+@[0-9a-fA-F]{40}")


def reference(value):
    value = value.strip()
    if value.startswith(("'", '"')):
        quote = value[0]
        end = value.find(quote, 1)
        return value[1:end] if end != -1 else value
    return re.split(r"\s+#", value, maxsplit=1)[0].strip()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    args = parser.parse_args()
    if not args.directory.is_dir():
        parser.error(f"not a directory: {args.directory}")

    failed = False
    try:
        for path in sorted(args.directory.rglob("*.yml")):
            if not path.is_file():
                continue
            for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
                match = USES.match(line)
                if not match:
                    continue
                action = reference(match[1])
                if action.startswith(("./", "docker://")):
                    continue
                if not PINNED.fullmatch(action):
                    print(f"{path}:{number}: unpinned uses: {action}", file=sys.stderr)
                    failed = True
    except (OSError, UnicodeError) as error:
        print(f"pins: {error}", file=sys.stderr)
        return 1
    if not failed:
        print("ok")
    return int(failed)


if __name__ == "__main__":
    sys.exit(main())
