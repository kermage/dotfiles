#!/bin/bash
set -euo pipefail

export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"
PATH="$PNPM_HOME/bin${PATH+:$PATH}"

pnpm runtime set --global node latest
pnpm install --global npm

npm config set prefix "$HOME/.local"
