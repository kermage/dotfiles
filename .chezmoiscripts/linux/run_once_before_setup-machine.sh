#!/bin/bash

has() {
  command -v "$1" 1>/dev/null 2>&1
}

SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

$SUDO apt-get update -q
$SUDO apt-get install -y curl ca-certificates git file

if ! has mise; then
  curl https://mise.run | sh
fi

if ! has atuin; then
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi
