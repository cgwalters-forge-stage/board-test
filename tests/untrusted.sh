#!/bin/sh
set -eu
bash -n "$(dirname "$0")/../ci/untrusted.sh"
echo ok
