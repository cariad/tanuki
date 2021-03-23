#!/usr/bin/env bash

set -e

key_path=../data/private.key

if [ ! -f "${key_path:?}" ]; then
  echo -e "${ok:?}No private GPG key to import."
  exit
fi

echo -e "${li:?}You'll be prompted to enter your private GPG key passphrase."
echo -e "${li:?}This is required in order to import your key."
echo -e "${li:?}Press return to continue... "
read -r
gpg --import "${key_path:?}"
rm -f        "${key_path:?}"

echo -e "${li:?}Configuring git signing key..."
key_id="$(gpg --with-colons --list-secret-keys |
          awk -F: '$1 == "fpr" {print $10;}'   |
          head --lines 1)"

git config --global user.signingkey "${key_id:?}"
echo -e "${ok:?}Configured git signing key!"
