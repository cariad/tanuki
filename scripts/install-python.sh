#!/usr/bin/env bash

set -e

echo -e "${li:?}Installing Python ${PYENV_VERSION:?}..."
pyenv install "${PYENV_VERSION:?}" --skip-existing
echo -e "${ok:?}Installed Python ${PYENV_VERSION:?}!"

echo -e "${li:?}Installing Python packages..."
python -m pip install --upgrade pip pipenv
echo -e "${ok:?}Installed Python packages!"
set +e
