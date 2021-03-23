#!/usr/bin/env bash
set -e

if [ -f ~/.ssh/known_hosts ]; then
  echo -e "${ok:?}\"~/.ssh/known_hosts\" already exists."
else
  echo -e "${li:?}Configuring known_hosts..."
  ln data/known_hosts ~/.ssh/known_hosts
  echo -e "${ok:?}Configured known_hosts!"
fi

set +e
