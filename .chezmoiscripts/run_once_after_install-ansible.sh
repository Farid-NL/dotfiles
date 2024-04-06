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

echo -e "\n\nRemoving 'bw' & 'bws' from '/usr/local/bin'"
sudo rm -f /usr/local/bin/bw
sudo rm -f /usr/local/bin/bws

install_ansible
ansible-pull -U https://github.com/Farid-NL/ansible-personal-setup --ask-become-pass
