#!/bin/sh
# Fails when the Containerfile has no CMD line.
set -eu
grep -q "^CMD" ci/container/Containerfile
