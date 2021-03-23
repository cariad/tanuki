#!/usr/bin/env bash

set -e

echo -e "${li:?}Configuring known_hosts..."
ln data/known_hosts ~/.ssh/known_hosts
echo -e "${ok:?}Configured known_hosts!"
