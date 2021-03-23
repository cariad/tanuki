#!/usr/bin/env bash

# Configures "~/.ssh/known_hosts".

set -e

li="\033[1;34m↪\033[0m "  # List item
ok="\033[0;32m✔️\033[0m "  # OK

echo -e "${li:?}Configuring known_hosts..."
ln ../data/known_hosts ~/.ssh/known_hosts
echo -e "${ok:?}Configured known_hosts!"
