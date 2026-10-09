#!/bin/bash
set -euo pipefail

pnpm runtime set --global node latest
pnpm install --global npm

npm config set prefix "$HOME/.local"
