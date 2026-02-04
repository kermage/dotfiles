#!/bin/bash

has() {
  command -v "$1" 1>/dev/null 2>&1
}

if ! has brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
fi

if ! has atuin; then
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
else
  atuin update
fi

if ! has pnpm; then
  curl -fsSL https://get.pnpm.io/install.sh | sh -
else
  pnpm self-update
fi
