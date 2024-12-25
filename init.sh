#!/usr/bin/bash

set -e

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

if [[ -z "${nodes}" ]]; then
  echo "The number of nodes is not specified"
  echo "Usage: $0 --nodes <number>"
  exit 1
fi

echo "Initialize the control workstation"
./scripts/init-control-workstation.sh

echo "Initialize the host and ${nodes} Proxmox node(s)"
./scripts/generate-vault-password-file.sh
./scripts/create-vault-secrets-file.sh --nodes "${nodes}"

ansible-playbook -i ansible/hosts.ini ansible/main.yml \
  --vault-password-file=ansible/vault_password
