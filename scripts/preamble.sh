#!/usr/bin/env bash

set -e

if [ "$(whoami)" == "root" ]; then
  echo -e "${nk:?}Run this script as your daily user account without sudo."
  exit 1
fi

echo
echo "Hello!"
echo
echo "This script is intended to be run on a fresh Ubuntu Server 20.10"
echo "installation, or an installation previously prepared by an earlier"
echo "version of this script."
echo
echo "Terrible things will happen if you run this on a machine you've already"
echo "hand-crafted."
echo
echo "Press Ctrl+C NOW if you're not certain you want to do this."
echo
echo "Are these personal details correct?"
echo
cat ../identity.sh
echo
echo "If not, press Ctrl+C NOW to stop and edit \"identity.sh\"."
echo
echo "Otherwise, you'll be prompted to enter your account password. Setup is"
echo "non-interactive beyond that and will take several minutes."
echo
echo "After you've authenticated, feel free to leave this running and grab a"
echo "coffee or kiwi fruit."
echo
read -r -p "Press Enter to start setup... "
