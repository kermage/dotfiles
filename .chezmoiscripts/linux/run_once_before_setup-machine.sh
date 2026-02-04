#!/bin/bash

has() {
  command -v "$1" 1>/dev/null 2>&1
}

if ! has pkgx; then
  curl -Ssf https://pkgx.sh | sh
fi

pkgx dev integrate

if ! has atuin; then
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi
