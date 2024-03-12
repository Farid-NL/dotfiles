#!/usr/bin/env bash

#╔═══════════════════════════════════════════════════╗
#║ Variables                                         ║
#╚═══════════════════════════════════════════════════╝

# Utilities
init_dir="${PWD}"
github_username="Farid-NL"

# File and directory paths for checking installation status
firefox_dir="/opt/firefox"
vimplug_dir="${HOME}/.local/share/nvim/site/autoload/plug.vim"
screenkey_dir="${HOME}/Applications/screenkey"
nvm_dir="${HOME}/.config/nvm"
jetbrains_toolbox_dir="${HOME}/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox"
xampp_dir="/opt/lampp"
pcloud_dir="${HOME}/Applications/pcloud"

# ssh config file for prerequisite section
ssh_config_file="https://gist.githubusercontent.com/${github_username}/a5cab28b95918c53ebb115fb36935689/raw/config"

# URL for some package installations
firefox_url="https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
chrome_url="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
screenkey_url="https://www.thregr.org/wavexx/software/screenkey/releases"
code_url="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
jetbrains_toolbox_url="https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
anki_url="https://api.github.com/repos/ankitects/anki/releases/latest"
jetbrains_font_url="https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest"
dotfiles_backup_url="https://gist.githubusercontent.com/${github_username}/4975e2918d1e10c65844b428b59b18ad/raw/dot-files.sh"

#╔═══════════════════════════════════════════════════╗
#║ Custom installations                              ║
#╚═══════════════════════════════════════════════════╝

#─ Installs Firefox Browser
#─ @arg $1 Installed?
install_firefox(){
  if $1; then return; fi

  if (! whiptail --title "🚀 Firefox 🚀" --yesno "Do you want to install 'Firefox'?" --defaultno 9 60); then
    whiptail --title "❌ Firefox ❌" --msgbox "Installation canceled" 9 60
    return
  fi

  log_separator 'firefox'

  local url
  local tmp_dir
  local target_dir

  # Get URL
  url=$(curl -w "%{url_effective}\n" -ILsS "${firefox_url}" -o /dev/null)

  if [ -z "${url}" ];then
    whiptail --title "❗ Firefox ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
    echo "Something failed in the retrieving of the tar.gz file. Chek the base url" >> "${error}"
    return
  fi

  tmp_dir="/tmp/$(basename "${url}")"

  # Download
  TERM=ansi; whiptail --title "🔨 Firefox 🔨" --infobox "Downloading Firefox ..." 9 60; TERM=xterm-256color

  if curl -sSL "${url}" -o "${tmp_dir}" 2>> "${error}";then
    whiptail --title "❗ Firefox ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
    return
  fi

  # Decompression and installation
  TERM=ansi; whiptail --title "🔨 Firefox 🔨" --infobox "Decompressing & setting binary and desktop file" 9 60; TERM=xterm-256color

  if
    {
      tar xjf "${tmp_dir}" -C /tmp
      sudo mv /tmp/firefox /opt

      sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
      sudo wget -q https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop -P /usr/local/share/applications
    } > /dev/null 2>> "${error}"
  then
    whiptail --title "✅ Firefox ✅" --msgbox "Installation completed" 9 60
  else
    whiptail --title "❗ Firefox ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
  fi
}

#─ Installs vim-plug
#─ @arg $1 Installed?
install_vimplug(){
  if $1; then return; fi

  if (! whiptail --title "🚀 Vim Plug 🚀" --yesno "Do you want to install 'Vim Plug'?" --defaultno 9 60); then
    whiptail --title "❌ Vim Plug ❌" --msgbox "Installation canceled" 9 60
    return
  fi

  log_separator 'vim-plug'

  TERM=ansi; whiptail --title "🔨 Vim Plug 🔨" --infobox "Installing Vim Plug ..." 9 60; TERM=xterm-256color

  if sh -c 'curl -fsSLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' 2>> "${error}";then
    whiptail --title "✅ Vim Plug ✅" --msgbox "Installation completed" 9 60
  else
    whiptail --title "❗ Vim Plug ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
  fi
}

#─ Installs GitHub CLI
#─ @arg $1 Installed?
install_githubcli(){
  if $1; then return; fi

  if (! whiptail --title "🚀 GitHub CLI 🚀" --yesno "Do you want to install 'GitHub CLI'?" --defaultno 9 60); then
    whiptail --title "❌ GitHub CLI ❌" --msgbox "Installation canceled" 9 60
  fi

  log_separator 'GitHub CLI'

  TERM=ansi; whiptail --title "🔨 GitHub CLI 🔨" --infobox "Installing GitHub CLI ..." 9 60; TERM=xterm-256color

  if
    {
      sudo mkdir -p /etc/apt/keyrings
      wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg
      sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list
      sudo apt-get update -qq
      sudo apt-get install gh -qq
    } > /dev/null 2>> "${error}"
  then
    whiptail --title "✅ GitHub CLI ✅" --msgbox "Installation completed" 9 60
  else
    whiptail --title "❗ GitHub CLI ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
  fi
}

#─ Installs Jetbrains Toolbox
#─ @arg $1 Installed?
install_jetbrains_toolbox(){
  if $1; then return; fi

  if (! whiptail --title "🚀 Jetbrains Toolbox App 🚀" --yesno "Do you want to install 'Jetbrains Toolbox App'?" --defaultno 9 60); then
    whiptail --title "❌ Jetbrains Toolbox App ❌" --msgbox "Installation canceled" 9 60
  fi

  log_separator 'Jetbrains Toolbox App'

  local url
  local tmp_dir
  local target_dir

  # Get URL
  url=$(curl -w "%{url_effective}\n" -ILsS "${jetbrains_toolbox_url}" -o /dev/null)

  if [ -z "${url}" ];then
    whiptail --title "❗ Jetbrains Toolbox App ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
    echo "Something failed in the retrieving of the tar.gz file. Chek the base url" >> "${error}"
    return
  fi

  tmp_dir="/tmp/$(basename "${url}")"
  target_dir="${HOME}/Downloads"

  # Download
  TERM=ansi; whiptail --title "🔨 Jetbrains Toolbox App 🔨" --infobox "Downloading Jetbrains Toolbox App ..." 9 60; TERM=xterm-256color

  if curl -sSL "${url}" -o "${tmp_dir}" 2>> "${error}";then
    whiptail --title "❗ Jetbrains Toolbox App ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
    return
  fi

  # Decompression
  TERM=ansi; whiptail --title "🔨 Jetbrains Toolbox App 🔨" --infobox "Jetbrains Toolbox App will be decompressed in '${target_dir}'" 9 60; TERM=xterm-256color

  if tar -xzf "${tmp_dir}" -C "${target_dir}" --strip-components=1 > /dev/null 2>> "${error}"; then
    whiptail --title "✅ Jetbrains Toolbox App ✅" --msgbox "Installation completed\n\nGo to ${target_dir} and execute the program to finish installation" 9 60
  else
    whiptail --title "❗ Jetbrains Toolbox App ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
  fi
}

#─ Installs Docker
#─ @arg $1 Installed?
install_docker(){
  if $1; then return; fi

  if (whiptail --title "🚀 Docker 🚀" --yesno "Do you want to install 'Docker'?" --defaultno 9 60); then
    whiptail --title "❌ Docker ❌" --msgbox "Installation canceled" 9 60
  fi

  log_separator 'Docker'

  TERM=ansi; whiptail --title "🔨 Docker 🔨" --infobox "Installing Docker ..." 9 60; TERM=xterm-256color

  if
    {
      for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get purge "${pkg}" -qq; done

      sudo mkdir -p /etc/apt/keyrings
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${VERSION_CODENAME}") stable" | sudo tee /etc/apt/sources.list.d/docker.list

      sudo apt-get update -qq
      sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -qq

      sudo usermod -aG docker "${USER}"
      newgrp docker
    } > /dev/null 2>> "${error}"
  then
    whiptail --title "✅ Docker ✅" --msgbox "Installation completed" 9 60
  else
    whiptail --title "❗ Docker ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
  fi
}

#─ Installs Anki
#─ @arg $1 Installed?
install_anki(){
  if $1; then return; fi

  if (whiptail --title "🚀 Anki 🚀" --yesno "Do you want to install 'Anki'?" --defaultno 9 60); then
    whiptail --title "❌ Anki ❌" --msgbox "Installation canceled" 9 60
  fi

  log_separator 'Anki'

  local version
  local url

  # Get URL
  version=$(curl -sS "${anki_url}" | grep tag_name | grep -oP "\d+\.?\d*\.?\d*")

  if [ -z "${version}" ];then
    whiptail --title "❗ Anki ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
    echo "Something failed in the retrieving of the software version. Chek the base url or the piped commands" >> "${error}"
    return
  fi

  url="https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-linux-qt6.tar.zst"

  # Download
  TERM=ansi; whiptail --title "🔨 Anki 🔨" --infobox "Downloading Anki ..." 9 60; TERM=xterm-256color

  if
    {
      cd "/tmp" 2>> "${error}" || return
      curl -sSLO "${url}"
      mkdir -p "/tmp/anki"
      tar xaf "/tmp/$(basename "${url}")" -C "/tmp/anki" --strip-components=1
    } > /dev/null 2>> "${error}"
  then
    whiptail --title "❗ Anki ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
    return
  fi

  # Installation
  TERM=ansi; whiptail --title "🔨 Anki 🔨" --infobox "Installing Anki ..." 9 60; TERM=xterm-256color

  if [ ! -f "/tmp/anki/install.sh" ];then
    whiptail --title "❗ Anki ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
    echo "install.sh executable not found" >> "${error}"
    return
  fi

  if cd anki 2>> "${error}" || return ; sudo ./install.sh > /dev/null 2>> "${error}"; then
    whiptail --title "✅ Anki ✅" --msgbox "Installation completed" 9 60
  else
    whiptail --title "❗ Anki ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
  fi
}

#─ Show manual installation for JetBrains Mono Font
#─ @arg $1 Installed?
install_font_jetbrainsmono() {
  if $1; then return; fi

  local version
  local url

  version=$(curl -sS "${jetbrains_font_url}" | grep tag_name | grep -oP "\d+\.?\d*\.?\d*")
  url="https://github.com/JetBrains/JetBrainsMono/releases/download/v${version}/JetBrainsMono-${version}.zip"

  # Downlad
  whiptail --title "🔨 JetBrains Mono (Font) 🔨" --scrolltext --infobox "Manual installation required.\n\nDownloading font, wait a minute..." 11 60

  cd "/tmp" 2>> "${error}" || return; curl -sSLO "${url}" 2>> "${error}"
  mkdir -p "${HOME}/Downloads/fonts/JetBrains Mono" && unzip -oqj "$(basename "${url}")" 'fonts/ttf/*' -d "${HOME}/Downloads/fonts/JetBrains Mono" 2>> "${error}"
  find "${HOME}/Downloads/fonts/JetBrains Mono" -type f -name "*.ttf" | grep -P "NL" | xargs -I {} rm {} 2>> "${error}"
  cd "${init_dir}" 2>> "${error}" || return

  # Manual installation
  whiptail --title "🔨 JetBrains Mono (Font) 🔨" --scrolltext --msgbox "JetBrains Mono Fonts downloded in '${HOME}/Downloads/fonts/JetBrains Mono'\nInstall the fonts with the Font Manager" 11 60
}

#─ Show manual installation for JetBrainsMono Nerd Font
#─ @arg $1 Installed?
install_font_jetbrainsmono_nerd() {
  if $1; then return; fi

  local msg

  msg="Manual installation required:"
  msg+="\n• Visit: https://downgit.github.io/#/home?url=https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono/Ligatures"
  msg+="\n• Move it to '/tmp'"
  msg+="\n• Run: cd /tmp;unzip -oq Ligatures.zip"
  msg+="\n• Run: mkdir -p '${HOME}/Downloads/fonts/JetBrainsMono Nerd'"
  msg+="\n• Run: find Ligatures -type f -name \"*.ttf\" | grep -P \"JetBrains Mono[ \\w]+ Complete Mono\\.ttf\" | xargs -I {} cp {} \"${HOME}/Downloads/fonts/JetBrainsMono Nerd\""
  msg+="\n• Install the fonts with the Font Manager"

  whiptail --title "🔨 JetBrainsMono Nerd (Font) 🔨" --scrolltext --msgbox "${msg}" 11 60
}
