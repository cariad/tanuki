#!/usr/bin/env bash

set -e

li="\033[1;34m↪\033[0m "  # List item
ok="\033[0;32m✔️\033[0m "  # OK

echo -e "${li:?}Updating..."
apt update --yes

echo -e "${li:?}Upgrading..."
apt upgrade --yes

echo -e "${li:?}Installing: avahi-daemon"
apt install avahi-daemon --yes

echo -e "${ok:?}Done!"
