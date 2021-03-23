#!/usr/bin/env bash

set -e

echo -e "${li:?}Installing Python build dependencies..."
sudo apt install --yes \
    build-essential    \
    libbz2-dev         \
    libffi-dev         \
    liblzma-dev        \
    libncurses5-dev    \
    libncursesw5-dev   \
    libreadline-dev    \
    libsqlite3-dev     \
    libssl-dev         \
    llvm               \
    tk-dev             \
    zlib1g-dev         \
    xz-utils

echo -e "${ok:?}Installed Python build dependencies!"
