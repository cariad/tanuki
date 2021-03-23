#!/usr/bin/env bash

set -e

. ../identity.sh

echo -e "${li:?}Importing AWS CLI key..."
envsubst < ./data/.gitconfig > ./data/.gitconfig.filled
envsubst < ./data/gpg-identity > ./data/gpg-identity.filled

echo -e "${ok:?}Installed AWS CLI!"
