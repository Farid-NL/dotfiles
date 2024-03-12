#!/usr/bin/env bash

install_ansible() {
  if dpkg --get-selections | grep -wq ansible; then
    echo "Ansible already installed"
    return
  fi

  echo "Installing Ansible"

  sudo add-apt-repository -y ppa:ansible/ansible
  sudo apt-get update -y
  sudo apt-get install -y ansible

  echo "Ansible installation complete"
}

install_ansible

ansible-playbook ~/.bootstrap/setup.ansible.yml --ask-become-pass
