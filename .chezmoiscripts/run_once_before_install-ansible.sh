#!/usr/bin/env bash

if dpkg --get-selections | grep -wq ansible; then
  echo -e "Ansible already installed"
  exit
fi

sudo apt-get update
sudo apt-get install -y ansible

echo "Ansible installation complete"
