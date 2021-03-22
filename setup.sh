#!/usr/bin/env bash

set -e

li="\033[1;34m↪\033[0m "  # List item
ok="\033[0;32m✔️\033[0m "  # OK

# user="$(logname)"
# echo -e "${li:?} User:            ${user:?}"

# home="/home/${user:?}"
# echo -e "${li:?} Home:            ${home:?}"

# pyenv_dir="${home:?}/.pyenv"
# echo -e "${li:?} pyenv directory: ${pyenv_dir:?}"

echo -e "${li:?} Updating..."
sudo apt update --yes

echo -e "${li:?} Upgrading..."
sudo apt upgrade --yes


echo -e "${li:?} Installing auto-cpufreq..."
sudo snap install auto-cpufreq

echo -e "${li:?} Installing auto-cpufreq process..."
# auto-cpufreq --install


echo -e "${li:?} Installing Docker..."
sudo apt install build-essential \
                 docker.io       \
                 docker-compose --yes

echo -e "${li:?} Enabling Docker..."
sudo systemctl enable docker

echo -e "${li:?} Starting Docker..."
sudo systemctl start docker

echo -e "${li:?} Adding ${user:?} to Docker group..."
sudo gpasswd -a "${user:?}" docker


if [ -d ~/.pyenv ]; then
  echo -e "${li:?} Updating pyenv..."
  pushd ~/.pyenv
  git pull
  popd
else
  echo -e "${li:?} Installing pyenv..."
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
fi

pushd "${pyenv_dir:?}"
src/configure
make -C src
popd

tanukirc_line=". ~/.tanuki/data/bashrc.sh"

if ! grep -q "${tanukirc_line:?}" ~/.bashrc; then
  echo -e "${li:?} Referencing: ${tanukirc_line:?}"
  echo "${tanukirc_line:?}" >> ~/.bashrc
else
  echo -e "${li:?} tanukirc already referenced."
fi

# TODO: aws

echo -e "${ok:?}OK! Run \"sudo reboot\" now to complete the setup."
