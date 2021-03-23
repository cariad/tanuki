#!/usr/bin/env bash

set -e

pushd scripts
. ./style.sh
popd

echo -e "${li:?}Updating..."
sudo apt update --yes

echo -e "${li:?}Upgrading..."
sudo apt upgrade --yes


pushd scripts
# Do this early because some values are needed for builds and installations below.
. ./configure-bashrc.sh
. ./configure-egress-ssh.sh
popd

#
# Install auto-cpufreq to enable CPU boosting.
#

echo -e "${li:?}Installing auto-cpufreq..."
# TODO: sudo snap install auto-cpufreq

echo -e "${li:?}Installing auto-cpufreq process..."

# TODO: Enable this for real deployments.
# auto-cpufreq --install

pushd scripts
# git must be configured before importing the GPG key.
./configure-git.sh
# The import script will add the signing key to the git configuration.
./import-gpg-key.sh
./configure-known-hosts.sh
popd

echo -e "${li:?}Installing packages..."
sudo apt install --yes \
    build-essential    \
    docker.io          \
    docker-compose     \
    libbz2-dev         \
    libffi-dev         \
    liblzma-dev        \
    libncurses5-dev    \
    libncursesw5-dev   \
    libreadline-dev    \
    libsqlite3-dev     \
    libssl-dev \
    llvm \
    tk-dev \
    unzip              \
    xz-utils \
    zlib1g-dev

echo -e "${li:?}Enabling Docker..."
sudo systemctl enable docker

echo -e "${li:?}Starting Docker..."
sudo systemctl start docker

user="$(whoami)"
echo -e "${li:?}Adding ${user:?} to Docker group..."
sudo gpasswd -a "${user:?}" docker

#
# Install pyenv.
#

if [ -d ~/.pyenv ]; then
  echo -e "${li:?}Updating pyenv..."
  pushd ~/.pyenv
  git pull --ff-only
  popd
else
  echo -e "${li:?}Installing pyenv..."
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
fi

eval "$(pyenv init -)"

pushd ~/.pyenv
src/configure
make -C src
popd

#
# Install Python.
#

echo -e "${li:?}Installing Python ${PYENV_VERSION:?}..."
# TODO: pyenv install "${PYENV_VERSION:?}" --skip-existing

#
# Install Python packages.
#

# TODO: python -m pip install --upgrade pip pipenv

#
# Install AWS CLI.
#

echo -e "${li:?}Importing AWS CLI Team key..."
gpg --import keys/aws-cli.pub

echo -e "${li:?}Downloading AWS CLI..."
curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip     -o /tmp/aws.zip

echo -e "${li:?}Downloading AWS CLI signature..."
curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig -o /tmp/aws.zip.sig

echo -e "${li:?}Verifying AWS CLI signature..."
gpg --verify /tmp/aws.zip.sig /tmp/aws.zip
rm -rf /tmp/aws.zip.sig

echo -e "${li:?}Unpacking AWS CLI..."
unzip -q /tmp/aws.zip -d /tmp

echo -e "${li:?}Installing AWS CLI..."
sudo /tmp/aws/install --update
aws --version

echo -e "${li:?}Cleaning-up after AWS CLI installation..."
rm -rf /tmp/aws.zip
rm -rf /tmp/aws


echo
echo
echo -e "${ok:?}Nearly done!"

if [ "${generated_ssh:?}" == "1" ]; then
  echo -e "${ok:?}Your public key is: $(cat ~/.ssh/id_ed25519.pub)"
  echo -e "${li:?}To add this key to GitHub: https://github.com/settings/ssh/new"
  echo -e "${li:?}To add this key to GitLab: https://gitlab.com/-/profile/keys"
fi

echo -e "${ok:?}Run \"sudo reboot\" now to complete the setup."
