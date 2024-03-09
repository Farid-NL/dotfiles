#!/usr/bin/env bash

if dpkg --get-selections | grep -wq ansible; then
  echo -e "Ansible already installed"

  echo "Running Ansible"
  ansible-playbook ~/.bootstrap/setup.ansible.yml --ask-become-pass
  echo "Ansible configuration done"

  exit
fi

echo "Installing Ansible"
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible
echo -e "Ansible installation complete\n\n"

echo "Running Ansible"
ansible-playbook ~/.bootstrap/setup.ansible.yml --ask-become-pass
echo "Ansible configuration done"
