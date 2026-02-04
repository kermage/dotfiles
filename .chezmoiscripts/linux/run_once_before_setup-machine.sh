#!/bin/bash

curl -Ssf https://pkgx.sh | sh
pkgx dev integrate
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
