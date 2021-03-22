#!/usr/bin/env bash

set -e

li="\033[1;34m↪\033[0m "  # List item
ok="\033[0;32m✔️\033[0m "  # OK

echo -e "${li:?}Updating..."
sudo apt update --yes

echo -e "${li:?}Upgrading..."
sudo apt upgrade --yes

echo -e "${li:?}Installing: avahi-daemon"
sudo apt install avahi-daemon --yes

echo -e "${ok:?}Done!"
