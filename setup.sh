#!/usr/bin/env bash

set -e

. ./scripts/style.sh
  ./scripts/preamble.sh

  ./scripts/update.sh
. ./scripts/configure-bashrc.sh
. ./scripts/install-tools.sh

. ./scripts/configure-egress-ssh.sh
  # TODO: ./scripts/install-auto-cpufreq.sh
. ./scripts/configure-git.sh
  ./scripts/configure-known-hosts.sh
  ./scripts/install-docker.sh
  ./scripts/install-pyenv-build-dependencies.sh
. ./scripts/install-pyenv.sh
  ./scripts/install-python.sh
  ./scripts/install-aws.sh

if [ -n "${GPG_KEY}" ]; then
  echo
  echo "A new GPG key was created:"
  echo
  gpg --armor --export "${GPG_KEY:?}"
  echo
  echo "    - To add this GPG key to GitHub: https://github.com/settings/gpg/new"
  echo "    - To add this GPG key to GitLab: https://gitlab.com/-/profile/gpg_keys"
fi

if [ "${CREATED_SSH:?}" == "1" ]; then
  echo
  echo "A new SSH key was created:"
  echo
  echo "    $(cat ~/.ssh/id_ed25519.pub)"
  echo
  echo "    - To add this SSH key to GitHub: https://github.com/settings/ssh/new"
  echo "    - To add this SSH key to GitLab: https://gitlab.com/-/profile/keys"
fi

echo
echo -e "${ok:?}Run \"sudo reboot\" to complete the setup."
