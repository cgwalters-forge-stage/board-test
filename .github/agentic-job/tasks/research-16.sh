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
      "command": "git log --oneline -1"
    }
  },
  {
    "write": {
      "title": "Write",
      "path": "{home}/out/safe-outputs.jsonl",
      "content": "{\"type\":\"add_comment\",\"body\":\"Research: a build step that needs the network needs `--network=host` and the egress proxy CA bundle mounted read-only at the image trust-bundle path (docs/secure-host.md, Containers).\"}\n"
    }
  },
  {
    "write": {
      "title": "Write",
      "path": "{home}/out/outcome.json",
      "content": "{\"summary\": \"Researched the podman flags.\", \"tests\": [], \"stopped_early\": null}\n"
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
