#!/usr/bin/env bash

set -e

if git config --get user.signingkey; then
  echo -e "${ok:?}Commit signing key is already set."
  exit
fi

echo -e "${li:?}Creating commit signing key..."

GPG_KEY=$(gpg --batch --gen-key ../data/gpg-info.txt 2>&1 |
      awk 'NR==1 { print $3; }')

export GPG_KEY

git config user.signingkey "${GPG_KEY:?}"


echo -e "${ok:?}Created commit signing key!"
