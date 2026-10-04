#!/bin/bash

PATH="$HOME/.local/bin${PATH+:$PATH}"

mise install

pnpm runtime set --global node latest
pnpm install --global npm
