#!/usr/bin/env bash

# Configures git. This must run BEFORE setting up the signing key.

set -e

echo -e "${li:?}Configuring git..."
ln ../data/.gitconfig ~/.gitconfig
echo -e "${ok:?}Configured git!"
