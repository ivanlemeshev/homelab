#!/usr/bin/bash

set -e

echo "Update the system and installing the required packages"

sudo apt update
sudo apt upgrade -y
sudo apt install -y git ansible sshpass pwgen whois
