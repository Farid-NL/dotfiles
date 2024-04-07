#!/usr/bin/env bash

install_ansible() {
  if dpkg --get-selections | grep -wq ansible; then
    echo -e '\nAnsible already installed\n'
    return
  fi

  echo -e '\nInstalling Ansible...'

  sudo add-apt-repository -y ppa:ansible/ansible
  sudo apt-get update -y
  sudo apt-get install -y ansible

  echo -e 'Ansible installed\n'
}

install_ansible
ansible-pull -U https://github.com/Farid-NL/ansible-personal-setup --ask-become-pass
