#!/usr/bin/env bash

set -e

if [ -f ~/.ssh/id_ed25519 ]; then
  echo -e "${ok:?}Egress SSH key pair already exists."
  export CREATED_SSH=0
else
  echo -e "${li:?}Creating egress SSH key pair..."
  ssh-keygen -t ed25519 -C cariad@hey.com -f ~/.ssh/id_ed25519 -P ""
  #  ssh-add -k ~/.ssh/id_ed25519
  # likely: ssh-keyscan -t rsa gitlab.com  >> ~/.ssh/known_hosts
  # not likely: ssh -T git@gitlab.com
  echo -e "${ok:?}Created egress SSH key pair!"
  export CREATED_SSH=1
fi

set +e
