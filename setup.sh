#!/usr/bin/env bash

set -e

li="\033[1;34m↪\033[0m "  # List item
ok="\033[0;32m✔️\033[0m "  # OK

user="$(logname)"
echo -e "${li:?} User:            ${user:?}"

home="/home/${user:?}"
echo -e "${li:?} Home:            ${home:?}"

pyenv_dir="${home:?}/.pyenv"
echo -e "${li:?} pyenv directory: ${pyenv_dir:?}"

echo -e "${li:?} Updating..."
apt update --yes

echo -e "${li:?} Upgrading..."
apt upgrade --yes


echo -e "${li:?} Installing auto-cpufreq..."
snap install auto-cpufreq

echo -e "${li:?} Installing auto-cpufreq process..."
# auto-cpufreq --install


echo -e "${li:?} Installing Docker..."
apt install build-essential \
            docker.io \
            docker-compose --yes

echo -e "${li:?} Enabling Docker..."
systemctl enable docker

echo -e "${li:?} Starting Docker..."
systemctl start docker

echo -e "${li:?} Adding ${user:?} to Docker group..."
gpasswd -a "${user:?}" docker


if [ -d "${pyenv_dir:?}" ]
then
    echo "Directory /path/to/dir exists."
else
  echo -e "${li:?} Installing pyenv..."
  git clone https://github.com/pyenv/pyenv.git "${pyenv_dir:?}"
fi

pushd "${pyenv_dir:?}"
src/configure
make -C src
popd

tanukirc=". ${home:?}/tanuki/data/bashrc.sh"
bashrc_path="${home:?}/.bashrc"

if ! grep -q "${tanukirc:?}" "${bashrc_path:?}"; then
  echo -e "${li:?} Referencing: ${tanukirc:?}"
  echo "${tanukirc:?}" >> "${bashrc_path:?}"
else
  echo -e "${li:?} tanukirc already referenced."
fi

# TODO: aws

echo -e "${ok:?}OK! Run \"sudo reboot\" now to complete the setup."
