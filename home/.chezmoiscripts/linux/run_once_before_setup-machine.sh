#!/bin/bash
set -euo pipefail

has() {
	command -v "$1" 1>/dev/null 2>&1
}

SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

$SUDO apt-get update -q
$SUDO apt-get install -y curl ca-certificates git file

if ! has mise; then
	curl https://mise.run | sh
else
	mise self-update --yes || true
fi

if ! has atuin; then
	curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive
else
	atuin update || true
fi

if ! has pnpm; then
	curl -fsSL https://get.pnpm.io/install.sh | sh -
else
	pnpm self-update || true
fi
