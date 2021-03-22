#!/usr/bin/env bash

export CFLAGS="-O2"

GPG_TTY="$(tty)"
export GPG_TTY

export PIPENV_VENV_IN_PROJECT=1

export PYENV_ROOT="${HOME:?}/.pyenv"
export PYENV_VERSION=3.9.2

export PATH="${PYENV_ROOT:?}/bin:${PATH:?}"

eval "$(pyenv init -)"
