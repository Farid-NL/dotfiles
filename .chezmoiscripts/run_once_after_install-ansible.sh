#!/usr/bin/env bash

if dpkg --get-selections | grep -wq ansible; then
  echo "Ansible already installed"
  ansible-playbook ~/.bootstrap/setup.ansible.yml --ask-become-pass
  exit
fi

echo "Installing Ansible"
sudo add-apt-repository -y ppa:ansible/ansible
sudo apt-get update -y
sudo apt-get install -y ansible
echo -e "Ansible installation complete\n\n"

ansible-playbook ~/.bootstrap/setup.ansible.yml --ask-become-pass
