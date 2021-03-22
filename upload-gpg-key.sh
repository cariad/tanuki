#!/usr/bin/env bash

set -e

li="\033[1;34m↪\033[0m "  # List item
nk="\033[0;31m⨯\033[0m "  # Not OK
ok="\033[0;32m✔️\033[0m "  # OK

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -host)      host="$2";      shift;;
    -host-user) host_user="$2"; shift;;
    -key)       key="$2";       shift;;
    *)          echo -e "${nk:?}Unhandled argument: $1"; exit 1;;
  esac
  shift
done

private=/tmp/private.key
rm -rf "${private:?}"

echo -e "${li:?}Exporting private GPG key: ${key:?}"
gpg --armor --output "${private:?}" --export-secret-key "${key:?}"

remote="${host_user:?}@${host:?}"

echo -e "${li:?}Copying to: ${remote:?}"
scp "${private:?}" "${remote:?}:~/.tanuki/"
rm -rf "${private:?}"

echo -e "${ok:?}Done!"
