#!/usr/bin/bash

set -e

echo "Creating ansible vault secrets file"

vault_password="./ansible/vault_password"

nodes="1"

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --nodes)
      nodes="$2"
      shift
      ;; # Get the value for --nodes
    *)
      echo "Unknown parameter passed: $1"
      exit 1
      ;;
  esac
  shift
done

for ((i = 1; i <= $((nodes)); i++)); do
  directory="./ansible/host_vars/pve_${i}"
  [[ -d "${directory}" ]] || mkdir -p "${directory}"

  filename="${directory}/vault.yml"

  if [[ ! -e "${filename}" ]]; then
    pve_root_password=$(pwgen --secure --capitalize --numerals --symbols 16 1)
    {
      echo "root_password: ${pve_root_password}"
      echo "root_password_hash: $(echo "${pve_root_password}" | mkpasswd --stdin --method=sha-512)"
    } >>"${filename}"

    ansible-vault encrypt --vault-password-file="${vault_password}" "${filename}"
    echo "The vault secrets is saved in ${filename}"
  else
    echo "The file ${filename} exists"
  fi
done

directory="./ansible/host_vars/localhost"
[[ -d "${directory}" ]] || mkdir -p "${directory}"

filename="${directory}/vault.yml"

if [[ ! -e "${filename}" ]]; then
  ssh_key_passphrase=$(pwgen --secure --capitalize --numerals --symbols 16 1)
  {
    echo "ssh_key_passphrase: ${ssh_key_passphrase}"
  } >>"${filename}"

  ansible-vault encrypt --vault-password-file="${vault_password}" "${filename}"
  echo "The vault secrets is saved in ${filename}"
else
  echo "The file ${filename} exists"
fi
