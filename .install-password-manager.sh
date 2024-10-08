#!/usr/bin/env bash

# Exit immediately if Bitwarden is already in $PATH
type bw > /dev/null 2>&1 && exit

bw_url='https://vault.bitwarden.com/download/?app=cli&platform=linux'

echo -e '\nInstalling Bitwarden CLI'
wget -q --show-progress "${bw_url}" -O '/tmp/bw.zip'

sudo unzip -oq '/tmp/bw.zip' -d '/usr/local/bin'
sudo chmod +x /usr/local/bin/bw
echo -e 'Bitwarden CLI installed\n'
