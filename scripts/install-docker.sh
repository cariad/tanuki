#!/usr/bin/env bash

set -e

echo -e "${li:?}Installing Docker..."
sudo apt install -qq --yes docker.io docker-compose

echo -e "${li:?}Enabling Docker..."
sudo systemctl enable docker

echo -e "${li:?}Starting Docker..."
sudo systemctl start docker

user="$(whoami)"
echo -e "${li:?}Adding ${user:?} to Docker group..."
sudo gpasswd -a "${user:?}" docker

echo -e "${ok:?}Installed Docker!"
