#!/usr/bin/env bash

# Configures git. This must run BEFORE setting up the signing key.

set -e

li="\033[1;34m↪\033[0m "  # List item
ok="\033[0;32m✔️\033[0m "  # OK

echo -e "${li:?}Configuring git..."
ln ../data/.gitconfig ~/.gitconfig
echo -e "${ok:?}Configured git!"
