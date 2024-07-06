#!/usr/bin/bash

set -e

vault_password="./ansible/vault_password"
filename="./ansible/secrets.yml"

ansible-vault view --vault-password-file="${vault_password}" "${filename}"
