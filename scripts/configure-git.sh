#!/usr/bin/env bash

set -e

echo -e "${li:?}Configuring git..."
ln data/.gitconfig ~/.gitconfig
echo -e "${ok:?}Configured git!"
