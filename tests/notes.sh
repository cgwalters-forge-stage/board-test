#!/bin/bash
set -eu
first_line=''
IFS= read -r first_line < docs/notes.md || true
if [[ ! $first_line =~ ^#[[:blank:]] ]]; then
    echo 'FAIL: docs/notes.md must start with a top-level Markdown heading (# followed by a space or tab).' >&2
    exit 1
fi
echo 'PASS: docs/notes.md starts with a top-level Markdown heading.'
