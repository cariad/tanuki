#!/usr/bin/env bash

set -e

echo -e "${li:?}Installing tools..."
sudo apt install --yes jq unzip
echo -e "${ok:?}Installed tools!"
