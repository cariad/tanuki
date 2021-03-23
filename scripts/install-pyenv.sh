#!/usr/bin/env bash

set -e

if [ -d ~/.pyenv ]; then
  echo -e "${li:?}Updating pyenv..."
  cd ~/.pyenv
  git pull --ff-only
else
  echo -e "${li:?}Downloading pyenv..."
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
  cd ~/.pyenv
fi

eval "$(pyenv init -)"

echo -e "${li:?}Building pyenv..."
src/configure
make -C src
cd ..

echo -e "${ok:?}Installed pyenv!"
