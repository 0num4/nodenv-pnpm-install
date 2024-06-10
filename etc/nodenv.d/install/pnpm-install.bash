#!/usr/bin/env bash

echo "Running nodenv-pnpm-install plugin..."
set -e
[ -n "$NODENV_DEBUG" ] && set -x

if declare -Ff after_install > /dev/null; then
  after_install run_after_install
else
  echo "nodenv: nodenv-pnpm-install plugin requires node-build" >&2
fi

run_after_install() {
  echo "Running after_install..."
  local node_version
  local pnpm_status
  local pnpm_version

  echo "Running after_install...2"
  # Only if successfully installed Node.
  [ "$STATUS" = "0" ] || return 0
  echo "Installing pnpm..."

  node_version=$(NODENV_VERSION="$DEFINITION" nodenv-exec node -v)
  if [[ "$node_version" =~ ^v[0-3]\. ]]; then
    echo "Node version ${node_version/v/} is not supported, please use Node.js 4.0 or higher." >&2
    return 0
  fi

  pnpm_status=0
  NODENV_VERSION="$DEFINITION" nodenv-exec npm install pnpm -g || pnpm_status="$?"

  if [ "$pnpm_status" == "0" ]; then
    pnpm_version=$(NODENV_VERSION="$DEFINITION" nodenv-exec pnpm --version)
    echo "Installed pnpm $pnpm_version"
  fi
}
