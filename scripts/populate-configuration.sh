#!/usr/bin/env bash

set -e
echo -e "${li:?}Populating configuration..."
envsubst < data/.gitconfig   > data/.gitconfig.filled
envsubst < data/gpg-identity > data/gpg-identity.filled
echo -e "${ok:?}Populated configuration!"
set +e
