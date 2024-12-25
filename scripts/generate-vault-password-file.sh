#!/usr/bin/bash

set -e

echo "Generating ansible vault password file"

filename="./ansible/vault_password"

if [[ ! -e "${filename}" ]]; then
  pwgen --secure --capitalize --numerals --symbols 16 1 >"${filename}"
  echo "The new vault password is saved in ${filename}"
else
  echo "The file ${filename} exists"
fi
