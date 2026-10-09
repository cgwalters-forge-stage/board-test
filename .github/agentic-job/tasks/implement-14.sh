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
      "command": "mkdir -p tests && printf '#!/bin/sh\\n# Fails when the Containerfile has no CMD line.\\nset -eu\\ngrep -q \"^CMD\" ci/container/Containerfile\\n' > tests/containerfile.sh && sh tests/containerfile.sh"
    }
  },
  {
    "write": {
      "title": "Write",
      "path": "{home}/out/safe-outputs.jsonl",
      "content": "{\"type\":\"create_pull_request\",\"title\":\"tests: Check that the Containerfile ends in a CMD\",\"body\":\"Closes #14\"}\n"
    }
  },
  {
    "write": {
      "title": "Write",
      "path": "{home}/out/outcome.json",
      "content": "{\"summary\": \"tests: Check that the Containerfile ends in a CMD\", \"tests\": [], \"stopped_early\": null}\n"
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
