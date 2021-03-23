#!/usr/bin/env bash

set -e

li="\033[1;34m↪\033[0m "  # List item
ok="\033[0;32m✔️\033[0m "  # OK

echo -e "${li:?}Updating..."
sudo apt update --yes

echo -e "${li:?}Upgrading..."
sudo apt upgrade --yes

#
# Import environment variables. Do this early because some values are needed for
# builds and installations below.
#

tanukirc_line=". ~/.tanuki/home/bashrc.sh"

if ! grep -q "${tanukirc_line:?}" ~/.bashrc; then
  echo -e "${li:?}Referencing: ${tanukirc_line:?}"
  echo "${tanukirc_line:?}" >> ~/.bashrc
else
  echo -e "${li:?}tanukirc already referenced."
fi

echo -e "${li:?}Importing environment variables..."
eval "${tanukirc_line:?}"


#
# Create SSH key pair (for authenticating with GitLab, etc).
#

if [ -f ~/.ssh/id_ed25519 ]; then
  echo -e "${li:?}Skipping SSH key pair generation."
  generated_ssh=0
else
  echo
  ssh-keygen -t ed25519 -C cariad@hey.com -f ~/.ssh/id_ed25519
  echo

  eval "$(ssh-agent)"
  ssh-add -k ~/.ssh/id_ed25519
  kill "${SSH_AGENT_PID:?}"
  # likely: ssh-keyscan -t rsa gitlab.com  >> ~/.ssh/known_hosts
  # not likely: ssh -T git@gitlab.com

  generated_ssh=1
fi

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



echo -e "${li:?}Installing packages..."
sudo apt install --yes \
    build-essential    \
    docker.io          \
    docker-compose     \
    libbz2-dev         \
    libffi-dev \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
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
pyenv install "${PYENV_VERSION:?}" --skip-existing

#
# Install Python packages.
#

python -m pip install --upgrade pip pipenv

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
