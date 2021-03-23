#!/bin/bash -e

li="\033[1;34m↪\033[0m "  # List item
ok="\033[0;32m✔️\033[0m "  # OK

while IFS="" read -r file_path
do
  echo -e "${li:?}${file_path:?}"
  shellcheck --check-sourced --enable=all --severity style -x "${file_path:?}"
done < <(find . -name "*.sh" -not -path "./.venv/*")

echo -e "${ok:?}OK!"
