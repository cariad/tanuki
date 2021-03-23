#!/usr/bin/env bash

set -e

echo -e "${li:?}Updating..."
sudo apt update --yes
echo -e "${ok:?}Updated!"

echo -e "${li:?}Upgrading..."
sudo apt upgrade --yes
echo -e "${ok:?}Upgraded!"
set +e
