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
      "command": "{ id -un; podman info --format 'rootless={{.Host.Security.Rootless}} driver={{.Store.GraphDriverName}}'; ls -l /dev/kvm; } > container-report.txt 2>&1; true"
    }
  },
  {
    "execute": {
      "title": "Bash",
      "command": "{ echo '## plain build and run'; podman build -t hello ci/container && podman run --rm hello; echo \"exit=$?\"; } >> container-report.txt 2>&1; true"
    }
  },
  {
    "execute": {
      "title": "Bash",
      "command": "{ echo '## build with a network step'; podman build -t net -f ci/container/Containerfile.net ci/container && podman run --rm net; echo \"exit=$?\"; } 2>&1 | tail -25 >> container-report.txt; true"
    }
  },
  {
    "execute": {
      "title": "Bash",
      "command": "{ echo '## the same with --network=host'; podman build --network=host -t net2 -f ci/container/Containerfile.net ci/container && podman run --rm net2; echo \"exit=$?\"; } 2>&1 | tail -25 >> container-report.txt; true"
    }
  },
  {
    "write": {
      "title": "Write",
      "path": "{home}/out/safe-outputs.jsonl",
      "content": "{\"type\":\"create_pull_request\",\"title\":\"ci: Report of a container build inside an agent run\",\"body\":\"What rootless podman did as the sandbox user of an agent run.\"}\n"
    }
  },
  {
    "write": {
      "title": "Write",
      "path": "{home}/out/outcome.json",
      "content": "{\"summary\":\"ci: Report of a container build inside an agent run\",\"tests\":[],\"stopped_early\":null}\n"
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
