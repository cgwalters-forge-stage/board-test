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
      "command": "mkdir -p tests && printf '#!/bin/sh\\nset -eu\\nbash -n \"$(dirname \"$0\")/../ci/untrusted.sh\"\\necho ok\\n' > tests/untrusted.sh && sh tests/untrusted.sh"
    }
  },
  {
    "write": {
      "title": "Write",
      "path": "{home}/out/safe-outputs.jsonl",
      "content": "{\"type\":\"create_pull_request\",\"title\":\"tests: Check that ci/untrusted.sh parses\",\"body\":\"Closes #7\"}\n{\"type\":\"add_comment\",\"item_number\":7,\"body\":\"Proposed a change for this: tests: Check that ci/untrusted.sh parses\"}\n"
    }
  },
  {
    "write": {
      "title": "Write",
      "path": "{home}/out/outcome.json",
      "content": "{\"summary\":\"tests: Check that ci/untrusted.sh parses\",\"tests\":[],\"stopped_early\":null}\n"
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
