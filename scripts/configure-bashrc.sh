#!/usr/bin/env bash

# Configures git. This must run BEFORE setting up the signing key.

set -e


tanukirc_line=". ~/.tanuki/data/bashrc.sh"

if ! grep -q "${tanukirc_line:?}" ~/.bashrc; then
  echo -e "${li:?}Configuring bashrc..."
  echo "${tanukirc_line:?}" >> ~/.bashrc
  echo -e "${ok:?}Configured bashrc!"
else
  echo -e "${ok:?}bashrc already configured."
fi

echo -e "${li:?}Importing bashrc..."
eval "${tanukirc_line:?}"
echo -e "${ok:?}Imported bashrc!"
