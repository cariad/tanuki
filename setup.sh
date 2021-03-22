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

echo -e "${li:?}Updating..."
sudo apt update --yes

echo -e "${li:?}Upgrading..."
sudo apt upgrade --yes


echo -e "${li:?}Installing auto-cpufreq..."
sudo snap install auto-cpufreq

echo -e "${li:?}Installing auto-cpufreq process..."
# auto-cpufreq --install




if [ -f private.key ]; then
  echo -e "${li:?}Importing private key..."
  gpg --import private.key
  rm -f        private.key
else
  echo -e "${li:?}No private key to import."
fi

if [ -f ~/.gitconfig ]; then
  echo -e "${li:?}Backing-up .gitconfig..."
  rm -f ~/.gitconfig.old
  mv ~/.gitconfig ~/.gitconfig.old
fi

echo -e "${li:?}Discovering private key..."
key_id="$(gpg --with-colons --list-secret-keys | awk -F: '$1 == "fpr" {print $10;}' | head --lines 1)"

echo -e "${li:?}Configuring git..."
ln home/.gitconfig ~/.gitconfig
git config --global user.signingkey "${key_id:?}"



echo -e "${li:?}Installing Docker..."
sudo apt install build-essential \
                 docker.io       \
                 docker-compose --yes

echo -e "${li:?}Enabling Docker..."
sudo systemctl enable docker

echo -e "${li:?}Starting Docker..."
sudo systemctl start docker

user="$(whoami)"
echo -e "${li:?}Adding ${user:?} to Docker group..."
sudo gpasswd -a "${user:?}" docker


if [ -d ~/.pyenv ]; then
  echo -e "${li:?}Updating pyenv..."
  pushd ~/.pyenv
  git pull --ff-only
  popd
else
  echo -e "${li:?}Installing pyenv..."
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
fi

pushd ~/.pyenv
src/configure
make -C src
popd

tanukirc_line=". ~/.tanuki/home/bashrc.sh"

if ! grep -q "${tanukirc_line:?}" ~/.bashrc; then
  echo -e "${li:?}Referencing: ${tanukirc_line:?}"
  echo "${tanukirc_line:?}" >> ~/.bashrc
else
  echo -e "${li:?}tanukirc already referenced."
fi

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
unzip /tmp/aws.zip -d /tmp

echo -e "${li:?}Installing AWS CLI..."
sudo /tmp/aws/install
aws --version

echo -e "${li:?}Cleaning-up after AWS CLI installation..."
rm -rf /tmp/aws.zip
rm -rf /tmp/aws





echo -e "${ok:?}OK! Run \"sudo reboot\" now to complete the setup."
