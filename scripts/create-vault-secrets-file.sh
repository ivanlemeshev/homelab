#!/usr/bin/bash

set -e

echo "Creating ansible vault secrets file"

vault_password="./ansible/vault_password"
filename="./ansible/secrets.yml"

if [[ ! -e "${filename}" ]]; then
    nodes="1"

    # Parse command-line arguments
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --nodes) nodes="$2"; shift ;;  # Get the value for --nodes
            *) echo "Unknown parameter passed: $1"; exit 1 ;;
        esac
        shift
    done

    for (( i=1; i<=$((nodes)); i++ )); do
        pve_root_password=$(pwgen --secure --capitalize --numerals --symbols 12 1)
        echo "pve_${i}_password: $pve_root_password" >> "${filename}"
        echo "pve_${i}_password_hash: $(echo "${pve_root_password}" | mkpasswd --stdin --method=sha-512)" >> "${filename}"
    done

    ansible-vault encrypt --vault-password-file="${vault_password}" "${filename}"
    echo "The vault secrets is saved in ${filename}"
else
    echo "The file ${filename} exists"
fi
