#!/usr/bin/env bash

set -e

li="\033[1;34m↪\033[0m "  # List item
ok="\033[0;32m✔️\033[0m "  # OK

echo -e "${li:?} Updating..."
apt update --yes

echo -e "${li:?} Upgrading..."
apt upgrade --yes

echo -e "${li:?} Installing Docker..."
apt install docker.io docker-compose --yes

echo -e "${li:?} Enabling Docker..."
systemctl enable docker

echo -e "${li:?} Starting Docker..."
systemctl start docker

user="$(logname)"
echo -e "${li:?} Adding ${user:?} to Docker group..."
gpasswd -a "${user:?}" docker

echo -e "${li:?} Installing auto-cpufreq..."
snap install auto-cpufreq

echo -e "${li:?} Installing auto-cpufreq process..."
auto-cpufreq --install

echo -e "${li:?} Installing pyenv..."
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
cd ~/.pyenv && src/configure && make -C src

cat data/bashrc.sh >> ~/.bashrc

# TODO: aws

echo -e "${ok:?}OK! Run \"sudo reboot\" now to complete the setup."
