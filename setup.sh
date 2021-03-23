#!/usr/bin/env bash

set -e

. ./scripts/style.sh

echo -e "${li:?}Updating..."
sudo apt update --yes

echo -e "${li:?}Upgrading..."
sudo apt upgrade --yes


# Do this early because some values are needed for builds and installations below.
. ./scripts/configure-bashrc.sh

. ./scripts/configure-egress-ssh.sh

#
# Install auto-cpufreq to enable CPU boosting.
#

echo -e "${li:?}Installing auto-cpufreq..."
# TODO: sudo snap install auto-cpufreq

echo -e "${li:?}Installing auto-cpufreq process..."

# TODO: Enable this for real deployments.
# auto-cpufreq --install

# git must be configured before importing the GPG key.
./scripts/configure-git.sh
# The import script will add the signing key to the git configuration.
. ./scripts/configure-commit-signing-key.sh
  ./scripts/configure-known-hosts.sh
  ./scripts/install-docker.sh

echo -e "${li:?}Installing packages..."
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
    tk-dev \
    unzip              \
    xz-utils \
    zlib1g-dev

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

if [ -n "${GPG_KEY}" ]; then
  echo
  echo "A new GPG key was created:"
  echo
  echo "    $(gpg --armor --export "${GPG_KEY:?}")"
  echo
  echo "    - To add this GPG key to GitHub: https://github.com/settings/gpg/new"
  echo "    - To add this GPG key to GitLab: https://gitlab.com/-/profile/gpg_keys"
fi

if [ "${generated_ssh:?}" == "1" ]; then
  echo
  echo "A new SSH key was created:"
  echo
  echo "    $(cat ~/.ssh/id_ed25519.pub)"
  echo
  echo "    - To add this SSH key to GitHub: https://github.com/settings/ssh/new"
  echo "    - To add this SSH key to GitLab: https://gitlab.com/-/profile/keys"
fi

echo -e "${ok:?}Run \"sudo reboot\" to complete the setup."
