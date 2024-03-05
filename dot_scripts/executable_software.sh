#!/usr/bin/env bash

#─ @name Software installer
#─ @brief Script that install software in Ubuntu based systems

#╔═══════════════════════════════════════════════════╗
#║ Variables                                         ║
#╚═══════════════════════════════════════════════════╝

error="$HOME/error.log"
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "$script_dir/include/software__variables.sh"

#╔═══════════════════════════════════════════════════╗
#║ Functions                                         ║
#╚═══════════════════════════════════════════════════╝

#─ Displays the final message or error log given the user's choice
#─
#─ @noargs
final_message() {
  local string
  string="  • Check how to install 'zsh'\nhttps://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH#install-and-set-up-zsh-as-default

  • Check how to install 'zsh4humans'
    https://github.com/romkatv/zsh4humans

  • Look for desktop files
    https://github.com/$github_username/dotfiles

  • You could need the thunderbird-menu-fix
    libdbusmenu-glib4 (Install)

  • Custom Grub themes
    https://github.com/vinceliuice/grub2-themes

  • Tile Window Manager
    https://github.com/Bismuth-Forge/bismuth

  • KDE settings
    https://github.com/$github_username/dotfiles

  Check possible errors in '$error'
  "

  if (whiptail --title "Goodbye!" --scrolltext --yesno "$string" --yes-button "Show error log" --no-button "Exit" --defaultno 15 80); then
    whiptail --title "Error log file" --scrolltext --textbox "$error" 15 80
  fi
}

#─ Displays the final message or error log given the user's choice
#─
#─ @arg $1 Name of the package
#─ @arg $2 Target file
log_separator() {
  echo -e "---------------$1---------------" >> "$2"
}

#─ Install package from default repository
#─
#─ @arg $1 Name of the package
#─ @arg $2 Human-readable name of the package
#─ @arg $3 Installed?
#─
#─ @example
#─     install_standard "yakuake" "Yakuake" "$is_installed_yakuake"
install_standard() {
  if $3; then return; fi

  if (! whiptail --title "🚀 $2 🚀" --yesno "Do you want to install '$2'?" --defaultno 9 60); then
    whiptail --title "❌ $2 ❌" --msgbox "Installation canceled" 9 60
    return
  fi

  log_separator "$1" "$error"

  TERM=ansi; whiptail --title "🔨 $2 🔨" --infobox "Installing $2 ..." 9 60; TERM=xterm-256color

  if sudo apt-get install "$1" -qq > /dev/null 2>> "$error"; then
    whiptail --title "✅ $2 ✅" --msgbox "Installation completed" 9 60
  else
    whiptail --title "❗ $2 ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
  fi
}

#─ Install the package from the downloaded DEB file
#─
#─ @arg $1 Name of the package
#─ @arg $2 Human-readable name of the package
#─ @arg $3 URL of DEB file
#─ @arg $4 Indicates if it needs to consider redirects
#─ @arg $5 Installed?
#─
#─ @example
#─     install_deb "google-chrome" "Google Chrome" "$chrome_url" false "$is_installed_chrome"
#─     install_deb "code" "VSCode (Editor)" "$code_url" true "$is_installed_code"
install_deb() {
  if $5; then return; fi

  if (! whiptail --title "🚀 $2 🚀" --yesno "Do you want to install '$2'?" --defaultno 9 60); then
    whiptail --title "❌ $2 ❌" --msgbox "Installation canceled" 9 60
    return
  fi

  log_separator "$1" "$error"

  local url

  # Handle redirects
  if $4; then
    url=$(curl -w "%{url_effective}\n" -I -L -s -S "$3" -o /dev/null)
  else
    url=$3
  fi

  # Download
  TERM=ansi; whiptail --title "🔨 $2 🔨" --infobox "Downloading $2 ..." 9 60; TERM=xterm-256color

  cd "/tmp" 2>> "$error" || return

  if ! curl -sSLO "$url" 2>> "$error"; then
    whiptail --title "❗ $2 ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
    cd "$init_dir" 2>> "$error" || return
    return
  fi

  # Installation
  TERM=ansi; whiptail --title "🔨 $2 🔨" --infobox "Installing $2 ..." 9 60; TERM=xterm-256color

  if sudo apt-get install "./$(basename "$url")" -qq > /dev/null 2>> "$error"; then
    whiptail --title "✅ $2 ✅" --msgbox "Installation completed" 9 60
  else
    whiptail --title "❗ $2 ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
  fi

  cd "$init_dir" 2>> "$error" || return
}

#─ Install package from PPA
#─
#─ @arg $1 Name of the package
#─ @arg $2 Human-readable name of the package
#─ @arg $3 PPA
#─ @arg $4 Installed?
#─
#─ @example
#─     install_PPA "git" "git" "ppa:git-core/ppa" "$is_installed_git"
install_PPA() {
  if $4; then return; fi

  if (! whiptail --title "🚀 $2 🚀" --yesno "Do you want to install '$2'?" --defaultno 9 60); then
    whiptail --title "❌ $2 ❌" --msgbox "Installation canceled" 9 60
    return
  fi

  log_separator "$1" "$error"

  # PPA set up
  TERM=ansi; whiptail --title "🔨 $2 🔨" --infobox "Setting PPA..." 9 60; TERM=xterm-256color

  if ! sudo add-apt-repository -y "$3" > /dev/null 2>> "$error"; then
    whiptail --title "❗ $2 ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
    return
  fi

  # Installation
  TERM=ansi; whiptail --title "🔨 $2 🔨" --infobox "Installing $2 ..." 9 60; TERM=xterm-256color

  if
    {
      sudo apt-get update -qq
      sudo apt-get install "$1" -qq
    } > /dev/null 2>> "$error"
  then
    whiptail --title "✅ $2 ✅" --msgbox "Installation completed" 9 60
  else
    whiptail --title "❗ $2 ❗" --msgbox "Installation failed\n\nCheck the error.log" 9 60
  fi
}

#─ Check if a package is installed
#─
#─ @arg $1 Name of the package
#─
#─ @example
#─     check_package curl
#─
#─ @exitcode 1 If package is not installed
#─ @exitcode 0 If package is installed
check_package() {
  if ! dpkg --get-selections | grep -wq "$1"; then
    false
  else
    true
  fi
}

#─ Check if file exists
#─
#─ @arg $1 File path
#─
#─ @example
#─     check_file "$HOME/path/to/file.txt"
#─
#─ @exitcode 1 If file is not found
#─ @exitcode 0 If file is found
check_file() {
  if [ ! -f "$1" ]; then
    false
  else
    true
  fi
}

#─ Check if directory exists
#─
#─ @arg $1 Directory path
#─
#─ @example
#─     check_directory "$HOME/path/to/directory"
#─
#─ @exitcode 1 If directory is not found
#─ @exitcode 0 If directory is found
check_directory() {
  if [ ! -d "$1" ]; then
    false
  else
    true
  fi
}

#─ Check if command exists
#─
#─ @arg $1 Name of command
#─
#─ @example
#─     check_command anki
#─
#─ @exitcode 1 If command does not exists
#─ @exitcode 0 If command exists
check_command() {
  if ! command -v "$1" > /dev/null; then
    false
  else
    true
  fi
}

#─ Check if font exists
#─
#─ @arg $1 Name of font
#─
#─ @example
#─     check_font 'JetBrains Mono'
#─
#─ @exitcode 1 If font does not exists
#─ @exitcode 0 If font exists
check_font() {
  if ! fc-list | grep -q "$1"; then
    false
  else
    true
  fi
}

#─ Check if prerequisites are installed and let the user decide if they want to install them or not.
#─
#─ @noargs
check_prerequisites() {
  local is_installed_curl
  local is_installed_zsh
  local is_zsh_login_shell
  local is_set_ssh_git

  # Cheking of prerequisites
  if check_package curl; then
    is_installed_curl=true
  else
    is_installed_curl=false
  fi

  if check_package zsh; then
    is_installed_zsh=true
  else
    is_installed_zsh=false
  fi

  if [ "$(grep "$(id -u)" /etc/passwd | awk -F: '{print $7}')" = "/usr/bin/zsh" ]; then
    is_zsh_login_shell=true
  else
    is_zsh_login_shell=false
  fi

  if [ -f "$HOME"/.ssh/id_ed25519_github ]; then
    is_set_ssh_git=true
  else
    is_set_ssh_git=false
  fi

  # Displaying of prerequisites statuses
  local string
  string="  $($is_installed_curl && echo ✅ || echo ❌) curl
  $($is_installed_zsh && echo ✅ || echo ❌) zsh
  $($is_zsh_login_shell && echo ✅ || echo ❌) zsh login
  $($is_set_ssh_git && echo ✅ || echo ❌) ssh git"

  # All prerequisites installed: Continue with the script or exit
  if $is_installed_curl && $is_installed_zsh && $is_zsh_login_shell && $is_set_ssh_git; then
    whiptail --title "Prerequisites" --yesno "$string" --yes-button "Continue" --no-button "Exit" 15 80
    return
  fi

  # Installation
  string+="\n\n──────────────────────────────────────────────────────\n\nDo you want to install the remaining prerequisites?"
  if (whiptail --title "Prerequisites" --yesno "$string" --yes-button "Continue" --no-button "Exit" --defaultno 15 80); then

    local prereq
    prereq=("$is_installed_curl" "$is_installed_zsh" "$is_zsh_login_shell" "$is_set_ssh_git")

    prereq_installation "${prereq[@]}"
    whiptail --title "Prerequisites" --msgbox "Prerequisites installed ✅" 9 60
    return 0
  else
    return 1
  fi
}

#─ Check what software are installed and store its status in global variables
#─
#─ @noargs
check_installs() {
  # Utilities
  is_installed_yakuake=$(check_package yakuake && echo "true" || echo "false")
  is_installed_brave=$(check_package brave-browser && echo "true" || echo "false")
  is_installed_chrome=$(check_package google-chrome && echo "true" || echo "false")
  is_installed_okular=$(check_package okular-extra-backends && echo "true" || echo "false")
  is_installed_make=$(check_package make && echo "true" || echo "false")
  is_installed_dolphin_plugins=$(check_package dolphin-plugins && echo "true" || echo "false")
  is_installed_neovim=$(check_package neovim && echo "true" || echo "false")
  is_installed_nvimplug=$(check_file "$vimplug_dir" && echo "true" || echo "false")
  is_installed_mvp=$(check_package mpv && echo "true" || echo "false")
  is_installed_adb=$(check_package adb && echo "true" || echo "false")
  is_installed_scrcpy=$(check_package scrcpy && echo "true" || echo "false")
  is_installed_netstat=$(check_package net-tools && echo "true" || echo "false")
  is_installed_ffmpeg=$(check_package ffmpeg && echo "true" || echo "false")
  is_installed_neofetch=$(check_package neofetch && echo "true" || echo "false")
  is_installed_gromit=$(check_package gromit-mpx && echo "true" || echo "false")
  is_installed_unrar=$(check_package unrar && echo "true" || echo "false")
  is_installed_pdfgrep=$(check_package pdfgrep && echo "true" || echo "false")
  is_installed_kcolor=$(check_package kcolorchooser && echo "true" || echo "false")
  is_installed_screenkey=$(check_directory "$screenkey_dir" && echo "true" || echo "false")

  # Development
  is_installed_code=$(check_package code && echo "true" || echo "false")
  is_installed_git=$(check_package git && echo "true" || echo "false")
  is_installed_nvm=$(check_directory "$nvm_dir" && echo "true" || echo "false")
  is_installed_gh=$(check_package gh && echo "true" || echo "false")
  is_installed_jetbrains_toolbox=$(check_file "$jetbrains_toolbox_dir" && echo "true" || echo "false")
  is_installed_docker=$(check_package docker-ce && echo "true" || echo "false")
  is_installed_mysql_dep1=$(check_package gnome-keyring && echo "true" || echo "false")
  is_installed_mysql_dep2=$(check_package libproj-dev && echo "true" || echo "false")
  is_installed_mysql=$(check_package mysql-server && echo "true" || echo "false")
  is_installed_mysql_workbench=$(check_package mysql-workbench-community && echo "true" || echo "false")
  is_installed_xampp=$(check_directory "$xampp_dir" && echo "true" || echo "false")

  # Others
  is_installed_veracrypt=$(check_package veracrypt && echo "true" || echo "false")
  is_installed_qbittorrent=$(check_package qbittorrent && echo "true" || echo "false")
  is_installed_obs=$(check_package obs-studio && echo "true" || echo "false")
  is_installed_pcloud=$(check_file "$pcloud_dir" && echo "true" || echo "false")
  is_installed_anki=$(check_command anki && echo "true" || echo "false")
  is_installed_droidcam=$(check_command droidcam && echo "true" || echo "false")
  is_installed_jetbrains_font=$(check_font 'JetBrains Mono' && echo "true" || echo "false")
  is_installed_jetbrains_nerd_font=$(check_font 'JetBrainsMono Nerd' && echo "true" || echo "false")
}

#─ Display installed packages with a ✅ and not installed with ❌
#─
#─ @noargs
show_installs() {

  #   ────────────────────────────────────────────────────────
  local string
  string="  Do you want to continue with the installation?

  ─────────────────────── Utilities ──────────────────────

  $($is_installed_yakuake && echo ✅ || echo ❌) Yakuake
  $($is_installed_brave && echo ✅ || echo ❌) Brave browser
  $($is_installed_chrome && echo ✅ || echo ❌) Google Chrome
  $($is_installed_okular && echo ✅ || echo ❌) Okular Backends
  $($is_installed_make && echo ✅ || echo ❌) make
  $($is_installed_dolphin_plugins && echo ✅ || echo ❌) Dolphin Plugins
  $($is_installed_neovim && echo ✅ || echo ❌) Neovim
  $($is_installed_nvimplug && echo ✅ || echo ❌) vim-plug
  $($is_installed_mvp && echo ✅ || echo ❌) mpv (Music Player)
  $($is_installed_adb && echo ✅ || echo ❌) adb (Android USB Debugging)
  $($is_installed_scrcpy && echo ✅ || echo ❌) scrcpy (Android on screen)
  $($is_installed_netstat && echo ✅ || echo ❌) netstat (XAMPP)
  $($is_installed_ffmpeg && echo ✅ || echo ❌) ffmpeg (Audio-Video libraries)
  $($is_installed_neofetch && echo ✅ || echo ❌) neofetch (System Info)
  $($is_installed_gromit && echo ✅ || echo ❌) Gromit MPX (Draw on screen)
  $($is_installed_unrar && echo ✅ || echo ❌) unrar
  $($is_installed_pdfgrep && echo ✅ || echo ❌) pdfgrep
  $($is_installed_kcolor && echo ✅ || echo ❌) KColorChooser
  $($is_installed_screenkey && echo ✅ || echo ❌) ScreenKey

  ───────────────────── Development ────────────────────

  $($is_installed_code && echo ✅ || echo ❌) VSCode (Editor)
  $($is_installed_git && echo ✅ || echo ❌) git
  $($is_installed_nvm && echo ✅ || echo ❌) nvm
  $($is_installed_gh && echo ✅ || echo ❌) GitHub CLI
  $($is_installed_jetbrains_toolbox && echo ✅ || echo ❌) Jetbrains Toolbox App
  $($is_installed_docker && echo ✅ || echo ❌) Docker
  $($is_installed_mysql_dep1 && echo ✅ || echo ❌) MySQL Dependencies (gnome-keyring)
  $($is_installed_mysql_dep2 && echo ✅ || echo ❌) MySQL Dependencies (libproj-dev)
  $($is_installed_mysql && echo ✅ || echo ❌) MySQL
  $($is_installed_mysql_workbench && echo ✅ || echo ❌) MySQL Workbench
  $($is_installed_xampp && echo ✅ || echo ❌) XAMPP

  ─────────────────────── Others ───────────────────────

  $($is_installed_veracrypt && echo ✅ || echo ❌) VeraCrypt
  $($is_installed_qbittorrent && echo ✅ || echo ❌) qBittorrent
  $($is_installed_obs && echo ✅ || echo ❌) OBS studio
  $($is_installed_pcloud && echo ✅ || echo ❌) PCloud
  $($is_installed_anki && echo ✅ || echo ❌) Anki
  $($is_installed_droidcam && echo ✅ || echo ❌) Droidcam
  $($is_installed_jetbrains_font && echo ✅ || echo ❌) JetBrains Mono (Font)
  $($is_installed_jetbrains_nerd_font && echo ✅ || echo ❌) JetBrainsMono Nerd (Font)

  ──────────────────────────────────────────────────────"

  whiptail --title "Installed software" --scrolltext --yesno "$string" --yes-button "Continue" --no-button "Exit" --defaultno 15 80
}

#─ Helper that display a prompt about a required manual installation
#─
#─ @arg $1 Name of package
#─ @arg $2 Installed?
#─ @arg $3 Message
#─ @arg $4 Scrollable <'--scrolltext'> || <>
#─
#─ @example
#─     show_manual_install "nvm" "$is_installed_nvm" "$msg"
#─     show_manual_install "MySQL" "$is_installed_mysql" "$msg" "--scrolltext"
show_manual_install(){
  if $2; then return; fi

  if [ -z "$4" ]; then
    whiptail --title "🔨 $1 🔨" --msgbox "$3" 11 60
  else
    whiptail --title "🔨 $1 🔨" "$4" --msgbox "$3" 11 60
  fi
}

#─ Install prerequisites if needed
#─
#─ @arg $1 curl status
#─ @arg $2 zsh status
#─ @arg $3 zsh_login status
#─ @arg $4 ssh_git status
prereq_installation() {

  # curl installation
  if ! $1; then
    log_separator 'curl' "$error"
    TERM=ansi; whiptail --title "Prerequisites 🔨" --infobox "Installing curl ..." 9 60; TERM=xterm-256color
    sudo apt-get install curl -qq > /dev/null 2>> "$error"
    whiptail --title "Prerequisites - curl" --msgbox "curl installed ✅" 9 60
  fi

  # zsh installation
  if ! $2; then
    log_separator 'zsh' "$error"
    TERM=ansi; whiptail --title "Prerequisites 🔨" --infobox "Installing zsh ..." 9 60; TERM=xterm-256color
    sudo apt-get install zsh -qq > /dev/null 2>> "$error"
    whiptail --title "Prerequisites - zsh" --msgbox "zsh installed ✅" 9 60
  fi

  # zsh as login shell set up
  if ! $3; then
    log_separator 'zsh_login' "$error"
    TERM=ansi; whiptail --title "Prerequisites 🔨" --infobox "Setting zsh as login shell..." 9 60; TERM=xterm-256color
    chsh -s "$(which zsh)"
    whiptail --title "Prerequisites - zsh-login" --msgbox "zsh is now your login shell ✅\n\nLog out and log back in again." 9 60
  fi

  # ssh for git set up
  if ! $4; then
    log_separator 'ssh_git' "$error"

    local bold
    local color_reset

    bold=$(tput bold)
    color_reset=$(tput sgr0)

    echo -e "Set the key name to ${bold}'$HOME/.ssh/id_ed25519_github'${color_reset}\n"
    ssh-keygen -t ed25519 -C "34426099+$github_username@users.noreply.github.com"
    eval "$(ssh-agent -s)"
    ssh-add "$HOME/.ssh/id_ed25519_github"

    mkdir -p "$HOME/.ssh" ; cd "$HOME/.ssh" 2>> "$error" || return
    curl -sSO "$ssh_config_file"
    cd "$init_dir" 2>> "$error" || return

    whiptail --title "Prerequisites - ssh-git" --scrolltext --msgbox "ssh-git setted up ✅\n\nVisit https://github.com/settings/keys and add your ssh public key: '$HOME/.ssh/id_ed25519_github.pub'" 9 60
  fi
}

#─ Install packages from 'Utilities' category
#─ @noargs
utilities() {
  # Brave
  install_brave "$is_installed_brave" "$error"

  # Yakuake
  install_standard "yakuake" "Yakuake" "$is_installed_yakuake"

  # Okular Backends (Format support)
  install_standard "okular-extra-backends" "Okular Backends (Format support)" "$is_installed_okular"

  # Google Chrome
  install_deb "google-chrome" "Google Chrome" "$chrome_url" false "$is_installed_chrome"

  # make (Compilation utility)
  install_standard "make" "make (Compilation utility)" "$is_installed_make"

  # Dolphin Plugins
  install_standard "dolphin-plugins" "Dolphin Plugins" "$is_installed_dolphin_plugins"

  # Neovim (Editor)
  install_standard "neovim" "Neovim (Editor)" "$is_installed_neovim"

  # vim-plug
  install_vimplug "$is_installed_nvimplug" "$error"

  # mpv (Music Player)
  install_standard "mpv" "mpv (Music Player)" "$is_installed_mvp"

  # adb (Android USB Debugging)
  install_standard "adb" "adb (Android USB Debugging)" "$is_installed_adb"

  # scrcpy (Android on screen)
  install_standard "scrcpy" "scrcpy (Android on screen)" "$is_installed_scrcpy"

  # netstat (XAMPP)
  install_standard "net-tools" "netstat (XAMPP)" "$is_installed_netstat"

  # ffmpeg (Audio-Video libraries)
  install_standard "ffmpeg" "ffmpeg (Audio-Video libraries)" "$is_installed_ffmpeg"

  # neofetch (System Info)
  install_standard "neofetch" "neofetch (System Info)" "$is_installed_neofetch"

  # gromit-mpx
  install_standard "gromit-mpx" "Gromit MPX (Draw on screen)" "$is_installed_gromit"

  # unrar
  install_standard "unrar" "unrar" "$is_installed_unrar"

  # pdfgrep
  install_standard "pdfgrep" "pdfgrep" "$is_installed_pdfgrep"

  # kcolorchooser
  install_standard "kcolorchooser" "kcolorchooser" "$is_installed_kcolor"

  # screenkey
  install_screenkey "$is_installed_screenkey" "$error"
}

#─ Install packages from 'Development' category
#─ @noargs
development() {
  local msg

  # VSCode
  install_deb "code" "VSCode (Editor)" "$code_url" true "$is_installed_code"

  # nvm
  msg="Manual installation required:\n\nhttps://github.com/nvm-sh/nvm#install--update-script"
  show_manual_install "nvm" "$is_installed_nvm" "$msg"

  # git
  install_PPA "git" "git" "ppa:git-core/ppa" "$is_installed_git"

  # GitHub CLI
  install_githubcli "$is_installed_gh" "$error"

  # Jetbrains Toolbox App
  install_jetbrains_toolbox "$is_installed_jetbrains_toolbox" "$error"

  # Docker
  install_docker "$is_installed_docker" "$error"

  # MySQL Dependencies (gnome-keyring)
  install_standard "gnome-keyring" "gnome-keyring (MySQL deps)" "$is_installed_mysql_dep1"

  # MySQL Dependencies (libproj-dev)
  install_standard "libproj-dev" "libproj-dev (MySQL deps)" "$is_installed_mysql_dep2"

  # MySQL
  msg="Manual installation required:"
  msg+="\n\nVisit: https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/#apt-repo-fresh-install"
  msg+="\nRun: sudo apt update"
  msg+="\nRun: sudo apt install mysql-server"
  show_manual_install "MySQL" "$is_installed_mysql" "$msg" "--scrolltext"

  # MySQL Workbench
  msg="Manual installation required:"
  msg+="\n\nVisit: https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/#apt-repo-fresh-install"
  msg+="\nRun: sudo apt update"
  msg+="\nRun: sudo apt install mysql-workbench-community"
  show_manual_install "MySQL Workbench" "$is_installed_mysql_workbench" "$msg" "--scrolltext"

  # XAMPP
  msg="Manual installation required:\n\nVisit: https://sourceforge.net/projects/xampp/files/latest/download"
  show_manual_install "XAMPP" "$is_installed_xampp" "$msg"
}

#─ Install packages from 'Others' category
#─ @noargs
others() {
  local msg

  # Veracrypt
  msg="Manual installation required:\n\nVisit: https://www.veracrypt.fr/en/Downloads.html"
  show_manual_install "VeraCrypt" "$is_installed_veracrypt" "$msg"

  # qBitorrent
  install_PPA "qbittorrent" "qBittorrent" "ppa:qbittorrent-team/qbittorrent-stable" "$is_installed_qbittorrent"

  # OBS Studio
  install_PPA "obs-studio" "OBS Studio" "ppa:obsproject/obs-studio" "$is_installed_obs"

  # Pcloud
  msg="Manual installation required:\n\nVisit: https://www.pcloud.com/how-to-install-pcloud-drive-linux.html?download=electron-64"
  show_manual_install "Pcloud" "$is_installed_pcloud" "$msg" "--scrolltext"

  #Anki
  install_anki "$is_installed_anki" "$error"

  # JetBrains Mono (Font)
  install_font_jetbrainsmono "$is_installed_jetbrains_font" "$error"

  # JetBrainsMono Nerd (Font)
  install_font_jetbrainsmono_nerd "$is_installed_jetbrains_nerd_font" "$error"
}

#╔═══════════════════════════════════════════════════╗
#║ Execution                                         ║
#╚═══════════════════════════════════════════════════╝

# Check if it's run as root
if [[ $EUID = 0 ]]; then
  echo "It is not recommended (nor necessary) to run this script as root."
  exit 1
fi

# Write the root password once
sudo echo ""

# New date for log
if [ ! -f "$error" ]; then
  echo -e "+++++++++++++++ $(date +'%x %X') +++++++++++++++" >> "$error"
else
  echo -e "\n+++++++++++++++ $(date +'%x %X') +++++++++++++++" >> "$error"
fi

# Set installation status of packages
check_installs

if ! show_installs; then
  final_message
  exit 0
fi

if ! check_prerequisites; then
  final_message
  exit 0
fi

# Option to backup dotfiles
if (whiptail --title "dotfiles" --yesno "Do you want to restore/backup your dot files ?" --defaultno 15 80); then
  bash <(curl -sS "$dotfiles_backup_url")
fi

# Menu
CATEGORY=$(whiptail --title "Installation" \
  --menu "What do you want to install?" --notags 15 80 4 \
  "UTL" "Utilities" \
  "DEV" "Development" \
  "OTH" "Others" \
  "ALL" "All" \
  3>&1 1<&2 2>&3)

case $CATEGORY in
  "UTL")
    utilities
  ;;
  "DEV")
    development
  ;;
  "OTH")
    others
  ;;
  "ALL")
    utilities
    development
    others
  ;;
  *)
    final_message
    exit 0
  ;;
esac

final_message
