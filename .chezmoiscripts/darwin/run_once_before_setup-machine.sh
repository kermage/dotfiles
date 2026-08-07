#!/bin/bash

has() {
  command -v "$1" 1>/dev/null 2>&1
}

if ! has brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
fi

if ! has mise; then
  curl https://mise.run | sh
else
	mise self-update --yes
fi

if ! has atuin; then
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive
else
  atuin update
fi

if ! has pnpm; then
  curl -fsSL https://get.pnpm.io/install.sh | sh -
else
  pnpm self-update
fi
