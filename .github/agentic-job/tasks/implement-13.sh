#!/bin/sh
# The scripted agent's session for this task: what a model would do, written down.
set -eu
mkdir -p "$HOME/.config/fake-agent"
cat > "$HOME/.config/fake-agent/demo.json" <<'JSON'
[
  {
    "say": "Scripted task run."
  },
  {
    "execute": {
      "title": "Bash",
      "command": "printf 'fake secret: gh%s_%s\\n' p FAKEREDACTIONCANARY0123456789abcdef"
    }
  },
  {
    "execute": {
      "title": "Bash",
      "command": "sed -i 's/recieve/receive/' docs/notes.md"
    }
  },
  {
    "write": {
      "title": "Write",
      "path": "{home}/out/safe-outputs.jsonl",
      "content": "{\"type\":\"create_pull_request\",\"title\":\"docs: Fix a typo in the notes\",\"body\":\"Closes #13\"}\n"
    }
  },
  {
    "write": {
      "title": "Write",
      "path": "{home}/out/outcome.json",
      "content": "{\"summary\": \"docs: Fix a typo in the notes\", \"tests\": [], \"stopped_early\": null}\n"
    }
  },
  {
    "cost": {
      "usd": 0.01
    }
  },
  {
    "say": "Done."
  }
]
JSON
