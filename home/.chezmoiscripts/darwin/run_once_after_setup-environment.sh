#!/bin/bash

pnpm runtime set --global node latest
pnpm install --global npm

npm config set prefix "$HOME/.local"
