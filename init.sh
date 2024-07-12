#!/usr/bin/bash

set -e

nodes="1"

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --nodes) nodes="$2"; shift ;;  # Get the value for --nodes
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo "Initialize the host and ${nodes} Proxmox node(s)"

./scripts/prepare-control-workstation.sh
./scripts/generate-vault-password-file.sh
./scripts/create-vault-secrets-file.sh --nodes "${nodes}"

ansible-playbook -i ansible/hosts.ini ansible/main.yml \
    --vault-password-file=ansible/vault_password
