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
      "command": "printf '\\nA staging area for agentic-job and agent-board.\\n' >> README.md"
    }
  },
  {
    "write": {
      "title": "Write",
      "path": "{home}/out/safe-outputs.jsonl",
      "content": "{\"type\":\"create_pull_request\",\"title\":\"docs: Say what this repository is for\",\"body\":\"Closes #5\"}\n{\"type\":\"add_comment\",\"item_number\":5,\"body\":\"Proposed a change for this: docs: Say what this repository is for\"}\n"
    }
  },
  {
    "write": {
      "title": "Write",
      "path": "{home}/out/outcome.json",
      "content": "{\"summary\":\"docs: Say what this repository is for\",\"tests\":[],\"stopped_early\":null}\n"
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
