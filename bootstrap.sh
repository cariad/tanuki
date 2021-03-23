#!/usr/bin/env bash

set -e

. ./scripts/style.sh
./scripts/update.sh

echo -e "${li:?}Installing: avahi-daemon"
sudo apt install avahi-daemon --yes

echo -e "${ok:?}Bootstrap complete!"
echo
echo "Please connect via SSH ($(whoami)@$(hostname).local) to run \"setup.sh\"."
echo
