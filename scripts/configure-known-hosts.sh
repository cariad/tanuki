#!/usr/bin/env bash

set -e


if [ -f ~/.ssh/known_hosts ]; then
  echo -e "${ok:?}\"~/.ssh/known_hosts\" already exists."
  exit 0
fi

echo -e "${li:?}Configuring known_hosts..."
ln data/known_hosts ~/.ssh/known_hosts
echo -e "${ok:?}Configured known_hosts!"
