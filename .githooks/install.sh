#!/usr/bin/env bash
set -e

root=$(git rev-parse --show-toplevel)
hooks=$(git rev-parse --path-format=absolute --git-path hooks)

mkdir -p "$hooks"
for hook in "$root/.githooks"/*; do
  name=$(basename "$hook")
  [ "$name" = "install.sh" ] && continue
  ln -sf "$hook" "$hooks/$name"
  echo "installed $name"
done
