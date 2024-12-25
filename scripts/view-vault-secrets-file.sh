#!/usr/bin/bash

set -e

vault_password="./ansible/vault_password"
script_dir=$(pwd)
echo "The script directory is: $script_dir"

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --file)
      file="$2"
      shift
      ;; # Get the value for --file
    *)
      echo "Unknown parameter passed: $1"
      exit 1
      ;;
  esac
  shift
done

if [[ -z "${file}" ]]; then
  echo "The file is not specified"
  echo "Usage: $0 --file <file>"
  exit 1
fi

# Construct the absolute path to the file
if [[ "$file" == /* ]]; then
  # $file is already an absolute path, use it as is
  absolute_file_path="$file"
elif [[ "$file" == ./.* || "$file" == ./* ]]; then
  # $fil starts with ./, make it relative to the script's directory
  absolute_file_path="$script_dir/${file#./}"
else
  # $file is a relative path, make it relative to the src directory
  absolute_file_path="$script_dir/$file"
fi

if [[ ! -e "${absolute_file_path}" ]]; then
  echo "The file ${absolute_file_path} does not exist"
  exit 1
fi

ansible-vault view --vault-password-file="${vault_password}" "${absolute_file_path}"
