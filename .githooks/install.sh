#!/usr/bin/env bash
set -e

root=$(git rev-parse --show-toplevel)

for hook in "$root/.githooks"/*; do
  name=$(basename "$hook")
  [ "$name" = "install" ] && continue
  ln -sf "../../.githooks/$name" "$root/.git/hooks/$name"
  echo "installed $name"
done
