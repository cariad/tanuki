#!/usr/bin/env bash

# Create SSH key pair (for authenticating with GitLab, etc).

set -e

if [ -f ~/.ssh/id_ed25519 ]; then
  echo -e "${ok:?}SSH key pair (for egress) already exists."
  export generated_ssh=0
  exit
fi

echo -e "${li:?}Creating SSH key pair (for egress)..."

# The key intentionally has no passphrase because Visual Studio Code's remote
# SSH sessions can't/won't prompt for it (when cloning from GitLab, etc).
ssh-keygen -t ed25519 -C cariad@hey.com -f ~/.ssh/id_ed25519 -P

#  ssh-add -k ~/.ssh/id_ed25519
# likely: ssh-keyscan -t rsa gitlab.com  >> ~/.ssh/known_hosts
# not likely: ssh -T git@gitlab.com

export generated_ssh=1

echo -e "${ok:?}Created SSH key pair (for egress)!"
