#!/bin/bash
set -euo pipefail

export PNPM_HOME="${PNPM_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/pnpm}"
PATH="$PNPM_HOME/bin:$HOME/.local/bin${PATH+:$PATH}"

mise install

pnpm runtime set --global node latest
pnpm install --global npm

npm config set prefix "$HOME/.local"
