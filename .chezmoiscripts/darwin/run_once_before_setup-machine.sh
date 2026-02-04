#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
curl -fsSL https://get.pnpm.io/install.sh | sh -
