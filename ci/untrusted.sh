#!/bin/bash
# Stands in for code this repository does not trust (a dependency's
# install hook, a pull request's build script). It tries to reach what
# the job holds and prints only whether each attempt worked, never what
# it read.
fail=0
try() { # try DESCRIPTION COMMAND...: the command is expected to fail
    local what=$1; shift
    if "$@" > /dev/null 2>&1; then echo "LEAK  $what"; fail=1; else echo "ok    $what: refused"; fi
}
echo "running as $(id -un) in $PWD"
for v in GITHUB_TOKEN GH_TOKEN ACTIONS_RUNTIME_TOKEN ACTIONS_ID_TOKEN_REQUEST_TOKEN ACTIONS_ID_TOKEN_REQUEST_URL GITHUB_WORKSPACE; do
    if [ -n "${!v:-}" ]; then echo "LEAK  \$$v is set"; fail=1; else echo "ok    \$$v: unset"; fi
done
ws=/home/runner/work/board-test/board-test
try "list the runner's home" ls /home/runner
try "read the checkout" cat "$ws/README.md"
try "read the checkout's git config (holds the token)" cat "$ws/.git/config"
try "list the runner's temp directory" ls /home/runner/work/_temp
try "sudo" sudo -n true
try "docker" docker info
try "cloud metadata" curl -sf -m 5 http://169.254.169.254/metadata/instance
try "POST to a host with no write rule" curl -sf -m 10 -X POST -d x https://example.com/
n=0
for e in /proc/[0-9]*/environ; do
    [ "$(stat -c %U "$e" 2> /dev/null)" = "$(id -un)" ] && continue
    if head -c 1 "$e" > /dev/null 2>&1; then n=$((n + 1)); fi
done
if [ "$n" -gt 0 ]; then echo "LEAK  $n other users' process environments are readable"; fail=1; else echo "ok    other users' process environments: refused"; fi
if curl -sf -m 20 -o /dev/null https://github.com/; then echo "ok    GET https://github.com/ works (through the proxy)"; else echo "note  GET https://github.com/ failed"; fi
exit $fail
