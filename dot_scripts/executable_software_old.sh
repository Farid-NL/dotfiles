#!/usr/bin/env bash

##  ______            _      _
## |  ____|          (_)    | |
## | |__  __ _  _ __  _   __| |
## |  __|/ _` || '__|| | / _` |
## | |  | (_| || |   | || (_| |
## |_|   \__,_||_|   |_| \__,_|

## @author Carlos Farid Nogales López
## @version 1.6
## @since 2021-04-21
## @brief Script that install software in Ubuntu based systems

#-----------------------------------------------------
# Variables
#-----------------------------------------------------
BOLD=$(tput bold)
COLOR_RED=$(tput setaf 1)
COLOR_GREEN=$(tput setaf 2)
BG_YELLOW=$(tput setab 3)
BG_RED=$(tput setab 1)
COLOR_BLUE=$(tput setaf 4)
BG_GREEN=$(tput setab 2)
#BG_BLUE=$(tput setab 4)
BG_YELLOW_DIM=$(tput setab 11)
COLOR_RESET=$(tput sgr0)

DOWNLOADS="$HOME/Downloads"
INITDIR=$PWD
ERROR="$HOME/error.log"

#-----------------------------------------------------
# Methods
#-----------------------------------------------------

## Prints a blue logo
## @since 1.0
showLogo() {
  echo -e "${COLOR_BLUE}"
  echo -e "  _____          __  _                               "
  echo -e " / ____|        / _|| |                              "
  echo -e "| (___    ___  | |_ | |_ __      __ __ _  _ __  ___  "
  echo -e " \___ \  / _ \ |  _|| __|\ \ /\ / // _' || '__|/ _ \ "
  echo -e " ____) || (_) || |  | |_  \ V  V /| (_| || |  |  __/ "
  echo -e "|_____/  \___/ |_|   \__|  \_/\_/  \__,_||_|   \___| "
  echo -e ""
  echo -e "Farid's installer"
  echo -e "${COLOR_RESET}"
}

## Show the final message
## @since 1.5
finalMessage() {
  echo -e "\n${BOLD}${COLOR_BLUE}─────────────── Last steps! ───────────────${COLOR_RESET}"
  echo -e "\n- ${BOLD}${COLOR_GREEN}zsh${COLOR_RESET}                    : ${BOLD}https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH#install-and-set-up-zsh-as-default${COLOR_RESET}"
  echo -e "- ${BOLD}${COLOR_GREEN}zsh4humans${COLOR_RESET}             : ${BOLD}https://github.com/romkatv/zsh4humans${COLOR_RESET}"
  echo -e "- ${BOLD}${COLOR_GREEN}icons/desktop files${COLOR_RESET}    : ${BOLD}https://github.com/FaruNL/dotfiles${COLOR_RESET}"
  echo -e "- ${BOLD}${COLOR_GREEN}menu fix (thunderbird)${COLOR_RESET} : ${BOLD}libdbusmenu-glib4${COLOR_RESET}"
  echo -e "- ${BOLD}${COLOR_GREEN}grub2-themes${COLOR_RESET}           : ${BOLD}https://github.com/vinceliuice/grub2-themes${COLOR_RESET}"
  echo -e "- ${BOLD}${COLOR_GREEN}bismuth${COLOR_RESET}              : ${BOLD}https://github.com/Bismuth-Forge/bismuth${COLOR_RESET}"
  echo -e "- ${BOLD}${COLOR_GREEN}KDE settings${COLOR_RESET}           : ${BOLD}https://github.com/FaruNL/dotfiles${COLOR_RESET}"
  echo -e "\n Check possible ${BOLD}${COLOR_RED}errors${COLOR_RESET} in ${BOLD}$ERROR${COLOR_RESET}"
}

## Sepator for error log
## @arg $1 Name of the package
## @arg $2 Target file
## @since 1.6
logSeparator() {
  echo -e "---------------$1---------------" >> "$2"
}

## Installs package from default repository
## @arg $1 Name of the package
## @arg $2 Human-readable name of the package
## @arg $3 Installed? : boolean
## @since 1.5
installStandard() {
  if ! $3; then
    echo -n "  ${BOLD}   -> $2${COLOR_RESET}? [Y/n]: "
    read -r INSTALL

    if [ "$INSTALL" = "y" ] || [ "$INSTALL" = "Y" ] || [ "$INSTALL" = "" ]; then
      logSeparator "$1" "$ERROR"

      echo "        Installing..."
      sudo apt-get install "$1" -qq > /dev/null 2>> "$ERROR"

      [ $? -eq 0 ] && printf "  ${BOLD}${BG_GREEN}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "$2"
      [ $? -eq 1 ] && printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "${BOLD}${COLOR_RED}$2 *${COLOR_RESET}"
    else
      printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "$2"
    fi
  fi
}

## Installs package from downloaded DEB file
## @arg $1 Name of the package
## @arg $2 Human-readable name of the package
## @arg $3 URL of DEB file
## @arg $4 Indicates if it needs to consider redirects : boolean
## @arg $5 Installed? : boolean
## @since 1.0
installDEB() {
  local URL

  # Handle redirects
  if $4; then
    URL=$(curl -w "%{url_effective}\n" -I -L -s -S "$3" -o /dev/null)
  else
    URL=$3
  fi

  if ! $5; then
    echo -n "  ${BOLD}   -> $2${COLOR_RESET}? [Y/n]: "
    read -r INSTALL

    if [ "$INSTALL" = "y" ] || [ "$INSTALL" = "Y" ] || [ "$INSTALL" = "" ]; then
      logSeparator "$1" "$ERROR"

      echo "        Downloading..."
      cd "/tmp" 2>> "$ERROR" || exit
      curl -sSLO "$URL" 2>> "$ERROR"

      if [ $? -eq 0 ]; then
        echo "        Installing..."
        sudo apt-get install "./$(basename "$URL")" -qq > /dev/null 2>> "$ERROR"

        [ $? -eq 0 ] && printf "  ${BOLD}${BG_GREEN}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "$2"
        [ $? -eq 1 ] && printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "${BOLD}${COLOR_RED}$2 *${COLOR_RESET}"
      else
        printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "${COLOR_RED}$2 *${COLOR_RESET}"
      fi

      cd "$INITDIR" 2>> "$ERROR" || exit
    else
      printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "$2"
    fi

  fi
}

## Installs package from PPA
## @arg $1 Name of the package
## @arg $2 Human-readable name of the package
## @arg $3 PPA
## @arg $4 Installed? : boolean
## @since 1.0
installPPA() {
  if ! $4; then
    echo -n "  ${BOLD}   -> $2${COLOR_RESET}? [Y/n]: "
    read -r INSTALL

    if [ "$INSTALL" = "y" ] || [ "$INSTALL" = "Y" ] || [ "$INSTALL" = "" ]; then
      logSeparator "$1" "$ERROR"

      echo "        ${BOLD}Setting PPA...${COLOR_RESET}"
      sudo add-apt-repository -y "$3" > /dev/null 2>> "$ERROR"

      if [ $? -eq 0 ]; then
        echo "        Installing..."
        {
          sudo apt-get update -qq
          sudo apt-get install "$1" -qq
        } > /dev/null 2>> "$ERROR"

        [ $? -eq 0 ] && printf "  ${BOLD}${BG_GREEN}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "$2"
        [ $? -eq 1 ] && printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "${BOLD}${COLOR_RED}$2 *${COLOR_RESET}"
      else
        printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "${COLOR_RED}$2 *${COLOR_RESET}"
      fi

    else
      printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "$2"
    fi

  fi
}

## Check if a package is installed
## @arg $1 Name of the package
## @arg $2 Human-readable name of the software
## @return boolean
## @since 1.6
checkPackage() {
  if ! dpkg --get-selections | grep -wq "$1"; then
    echo -e "${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- $2${COLOR_RESET}"
    false
  else
    echo -e "${BOLD}${BG_YELLOW}  ${COLOR_RESET}${BOLD} <- $2${COLOR_RESET}"
    true
  fi
}

## Check if file exists
## @arg $1 Name of file
## @arg $2 Human-readable name of the software
## @return boolean
## @since 1.6
checkFile() {
  if [ ! -f "$1" ]; then
    echo -e "${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- $2${COLOR_RESET}"
    false
  else
    echo -e "${BOLD}${BG_YELLOW}  ${COLOR_RESET}${BOLD} <- $2${COLOR_RESET}"
    true
  fi
}

## Check if directory exists
## @arg $1 Name of directory
## @arg $2 Human-readable name of the software
## @return boolean
## @since 1.6
checkDirectory() {
  if [ ! -d "$1" ]; then
    echo -e "${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- $2${COLOR_RESET}"
    false
  else
    echo -e "${BOLD}${BG_YELLOW}  ${COLOR_RESET}${BOLD} <- $2${COLOR_RESET}"
    true
  fi
}

## Check if command exists
## @arg $1 Name of command
## @arg $2 Human-readable name of the software
## @return boolean
## @since 1.6
checkCommand() {
  if ! command -v "$1" > /dev/null; then
    echo -e "${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- $2${COLOR_RESET}"
    false
  else
    echo -e "${BOLD}${BG_YELLOW}  ${COLOR_RESET}${BOLD} <- $2${COLOR_RESET}"
    true
  fi
}

## Check if font exists
## @arg $1 Name of font
## @arg $2 Human-readable name of the font
## @return boolean
## @since 1.6
checkFont() {
  if ! fc-list | grep -q "$1"; then
    echo -e "${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- $2${COLOR_RESET}"
    false
  else
    echo -e "${BOLD}${BG_YELLOW}  ${COLOR_RESET}${BOLD} <- $2${COLOR_RESET}"
    true
  fi
}

## Checks if the programs are installed and save a boolean value accordingly
## @since 1.5
checkInstalls() {
  #-> Utilities
  echo -e "${BOLD}${COLOR_BLUE}─────────────── Utilities ───────────────${COLOR_RESET}"
  # Yakuake
  checkPackage 'yakuake' 'Yakuake'
  I_YAKUAKE=$([ $? -eq 0 ] && echo "true" || echo "false")

  # Brave
  checkPackage 'brave-browser' 'Brave browser'
  I_BRAVE=$([ $? -eq 0 ] && echo "true" || echo "false")

  # Google Chrome
  checkPackage 'google-chrome' 'Google Chrome'
  I_CHROME=$([ $? -eq 0 ] && echo "true" || echo "false")

  # Okular Backends (Format support)
  checkPackage 'okular-extra-backends' 'Okular Backends (Format support)'
  I_OKULAR=$([ $? -eq 0 ] && echo "true" || echo "false")

  # make (Compilation utility)
  checkPackage 'make' 'make (Compilation utility)'
  I_MAKE=$([ $? -eq 0 ] && echo "true" || echo "false")

  # Dolphin Plugins
  checkPackage 'dolphin-plugins' 'Dolphin Plugins'
  I_DOLPHIN=$([ $? -eq 0 ] && echo "true" || echo "false")

  # Neovim (Editor)
  checkPackage 'neovim' 'Neovim (Editor)'
  I_NEOVIM=$([ $? -eq 0 ] && echo "true" || echo "false")

  # vim-plug
  local VIMPLUGDIR="$HOME/.local/share/nvim/site/autoload/plug.vim"
  checkFile "$VIMPLUGDIR" 'vim-plug'
  I_NVIMPLUG=$([ $? -eq 0 ] && echo "true" || echo "false")

  # mpv (Music Player)
  checkPackage 'mpv' 'mpv (Music Player)'
  I_MPV=$([ $? -eq 0 ] && echo "true" || echo "false")

  # adb (Android USB Debugging)
  checkPackage 'adb' 'adb (Android USB Debugging)'
  I_ADB=$([ $? -eq 0 ] && echo "true" || echo "false")

  # scrcpy (Android on screen)
  checkPackage 'scrcpy' 'scrcpy (Android on screen)'
  I_SCRCPY=$([ $? -eq 0 ] && echo "true" || echo "false")

  # netstat (XAMPP)
  checkPackage 'net-tools' 'netstat (XAMPP)'
  I_NETSTAT=$([ $? -eq 0 ] && echo "true" || echo "false")

  # ffmpeg (Audio-Video libraries)
  checkPackage 'ffmpeg' 'ffmpeg (Audio-Video libraries)'
  I_FFMPEG=$([ $? -eq 0 ] && echo "true" || echo "false")

  # neofetch (System Info)
  checkPackage 'neofetch' 'neofetch (System Info)'
  I_NEOFETCH=$([ $? -eq 0 ] && echo "true" || echo "false")

  # gromit-mpx
  checkPackage 'gromit-mpx' 'Gromit MPX (Draw on screen)'
  I_GROMIT=$([ $? -eq 0 ] && echo "true" || echo "false")

  # unrar
  checkPackage 'unrar' 'unrar'
  I_UNRAR=$([ $? -eq 0 ] && echo "true" || echo "false")

  # pdfgrep
  checkPackage 'pdfgrep' 'pdfgrep'
  I_PDFGREP=$([ $? -eq 0 ] && echo "true" || echo "false")

  # kcolorchooser
  checkPackage 'kcolorchooser' 'KColorChooser'
  I_KCOLOR=$([ $? -eq 0 ] && echo "true" || echo "false")

  # screenkey
  local SCREENKEYDIR="$HOME/Applications/screenkey"
  checkDirectory "$SCREENKEYDIR" 'ScreenKey'
  I_SCREENKEY=$([ $? -eq 0 ] && echo "true" || echo "false")

  #-> Development
  echo -e "\n${BOLD}${COLOR_BLUE}─────────────── Development ───────────────${COLOR_RESET}"
  # VSCode
  checkPackage 'code' 'VSCode (Editor)'
  I_CODE=$([ $? -eq 0 ] && echo "true" || echo "false")

  # git
  checkPackage 'git' 'git'
  I_GIT=$([ $? -eq 0 ] && echo "true" || echo "false")

  # nvm
  local NVM_DIR="$HOME/.config/nvm"
  checkDirectory "$NVM_DIR" 'nvm'
  I_NVM=$([ $? -eq 0 ] && echo "true" || echo "false")

  # GitHub CLI
  checkPackage 'gh' 'GitHub CLI'
  I_GH=$([ $? -eq 0 ] && echo "true" || echo "false")

  # JetBrains Toolbox App
  local TOOLDIR="$HOME/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox"
  checkFile "$TOOLDIR" 'Jetbrains Toolbox App'
  I_TOOLBOX=$([ $? -eq 0 ] && echo "true" || echo "false")

  # Docker
  checkPackage 'docker-ce' 'Docker'
  I_DOCKER=$([ $? -eq 0 ] && echo "true" || echo "false")

  # MySQL Dependencies (gnome-keyring)
  checkPackage 'gnome-keyring' 'MySQL Dependencies (gnome-keyring)'
  I_MYSQLDEP1=$([ $? -eq 0 ] && echo "true" || echo "false")

  # MySQL Dependencies (libproj-dev)
  checkPackage 'libproj-dev' 'MySQL Dependencies (libproj-dev)'
  I_MYSQLDEP2=$([ $? -eq 0 ] && echo "true" || echo "false")

  # MySQL
  checkPackage 'mysql-server' 'MySQL'
  I_MYSQL=$([ $? -eq 0 ] && echo "true" || echo "false")

  # MySQL Workbench
  checkPackage 'mysql-workbench-community' 'MySQL Workbench'
  I_MYSQLW=$([ $? -eq 0 ] && echo "true" || echo "false")

  # XAMPP
  local XAMPPDIR="/opt/lampp"
  checkDirectory $XAMPPDIR 'XAMPP'
  I_XAMPP=$([ $? -eq 0 ] && echo "true" || echo "false")

  #-> Others
  echo -e "\n${BOLD}${COLOR_BLUE}─────────────── Others ───────────────${COLOR_RESET}"
  # qBittorrent
  checkPackage 'qbittorrent' 'qBittorrent'
  I_QBTORR=$([ $? -eq 0 ] && echo "true" || echo "false")

  # OBS Studio
  checkPackage 'obs-studio' 'OBS Studio'
  I_OBS=$([ $? -eq 0 ] && echo "true" || echo "false")

  # PCloud
  local PCLOUDDIR="$HOME/Applications/pcloud"
  checkFile "$PCLOUDDIR" 'PCloud'
  I_PCLOUD=$([ $? -eq 0 ] && echo "true" || echo "false")

  # Anki
  checkCommand 'anki' 'Anki'
  I_ANKI=$([ $? -eq 0 ] && echo "true" || echo "false")

  # Joplin
  local JOPLINDIR="$HOME/.joplin/Joplin.AppImage"
  checkFile "$JOPLINDIR" 'Joplin'
  I_JOPLIN=$([ $? -eq 0 ] && echo "true" || echo "false")

  # Droidcam
  checkCommand 'droidcam' 'Droidcam'
  I_DROIDCAM=$([ $? -eq 0 ] && echo "true" || echo "false")

  # JetBrains Mono (Font)
  checkFont 'JetBrains Mono' 'JetBrains Mono (Font)'
  I_JBMONO=$([ $? -eq 0 ] && echo "true" || echo "false")

  # JetBrainsMono Nerd (Font)
  checkFont 'JetBrainsMono Nerd' 'JetBrainsMono Nerd (Font)'
  I_JBMONO_NERD=$([ $? -eq 0 ] && echo "true" || echo "false")
}

## Install all programs from Utilities category
## @since 1.0
utilities() {
  # Brave
  if ! $I_BRAVE; then
    echo -n "  ${BOLD}   -> brave-browser${COLOR_RESET}? [Y/n]: "
    read -r INSTALL

    if [ "$INSTALL" = "y" ] || [ "$INSTALL" = "Y" ] || [ "$INSTALL" = "" ]; then
      logSeparator 'brave-browser' "$ERROR"

      echo "        Installing..."
      {
        sudo apt-get install apt-transport-https -qq
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        sudo apt-get update -qq
        sudo apt-get install brave-browser -qq
      } > /dev/null 2>> "$ERROR"

      [ $? -eq 0 ] && printf "  ${BOLD}${BG_GREEN}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "brave-browser"
      [ $? -eq 1 ] && printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "${BOLD}${COLOR_RED}brave-browser *${COLOR_RESET}"

    else
      printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "brave-browser"
    fi

  fi

  # Yakuake
  installStandard "yakuake" "Yakuake" "$I_YAKUAKE"

  # Okular Backends (Format support)
  installStandard "okular-extra-backends" "Okular Backends (Format support)" "$I_OKULAR"

  # Google Chrome
  installDEB "google-chrome" "Google Chrome" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" false "$I_CHROME"

  # make (Compilation utility)
  installStandard "make" "make (Compilation utility)" "$I_MAKE"

  # Dolphin Plugins
  installStandard "dolphin-plugins" "Dolphin Plugins" "$I_DOLPHIN"

  # Neovim (Editor)
  installStandard "neovim" "Neovim (Editor)" "$I_NEOVIM"

  # vim-plug
  if ! $I_NVIMPLUG; then
    echo -n "  ${BOLD}   -> vim-plug${COLOR_RESET}? [Y/n]: "
    read -r INSTALL

    if [ "$INSTALL" = "y" ] || [ "$INSTALL" = "Y" ] || [ "$INSTALL" = "" ]; then
      logSeparator 'vim-plug' "$ERROR"

      echo "        Installing..."
      sh -c 'curl -fsSLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' 2>> "$ERROR"

      [ $? -eq 0 ] && printf "  ${BOLD}${BG_GREEN}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "vim-plug"
      [ $? -eq 1 ] && printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "${BOLD}${COLOR_RED}vim-plug *${COLOR_RESET}"
    else
      printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "vim-plug"
    fi

  fi

  # mpv (Music Player)
  installStandard "mpv" "mpv (Music Player)" "$I_MPV"

  # adb (Android USB Debugging)
  installStandard "adb" "adb (Android USB Debugging)" "$I_ADB"

  # scrcpy (Android on screen)
  installStandard "scrcpy" "scrcpy (Android on screen)" "$I_SCRCPY"

  # netstat (XAMPP)
  installStandard "net-tools" "netstat (XAMPP)" "$I_NETSTAT"

  # ffmpeg (Audio-Video libraries)
  installStandard "ffmpeg" "ffmpeg (Audio-Video libraries)" "$I_FFMPEG"

  # neofetch (System Info)
  installStandard "neofetch" "neofetch (System Info)" "$I_NEOFETCH"

  # gromit-mpx
  installStandard "gromit-mpx" "Gromit MPX (Draw on screen)" "$I_GROMIT"

  # unrar
  installStandard "unrar" "unrar" "$I_UNRAR"

  # pdfgrep
  installStandard "pdfgrep" "pdfgrep" "$I_PDFGREP"

  # kcolorchooser
  installStandard "kcolorchooser" "kcolorchooser" "$I_KCOLOR"

  # screenkey
  local SCRKEY_FILE ; SCRKEY_FILE=$(curl -sS https://www.thregr.org/~wavexx/software/screenkey/releases/ | grep -owP "screenkey-\d*\.\d*\.tar\.gz" | tail -1)
  if ! $I_SCREENKEY; then
    echo -n "  ${BOLD}   -> screenkey${COLOR_RESET}? [Y/n]: "
    read -r INSTALL

    if [ "$INSTALL" = "y" ] || [ "$INSTALL" = "Y" ] || [ "$INSTALL" = "" ]; then
      logSeparator 'screenkey' "$ERROR"

      sudo apt-get install slop -qq > /dev/null 2>> "$ERROR"

      echo "        Downloading..."
      curl -sS "https://www.thregr.org/~wavexx/software/screenkey/releases/$SCRKEY_FILE" -o /tmp/"$SCRKEY_FILE" 2>> "$ERROR"

      echo "        Installing..."
      {
        mkdir -p "$HOME/Applications/screenkey"
        tar -xzf "/tmp/$SCRKEY_FILE" -C "$HOME/Applications/screenkey" --strip-components=1
      } > /dev/null 2>> "$ERROR"

      [ $? -eq 0 ] && printf "  ${BOLD}${BG_GREEN}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "screenkey"
      [ $? -eq 1 ] && printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "${BOLD}${COLOR_RED}screenkey *${COLOR_RESET}"
    else
      printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "screenkey"
    fi

  fi
}

## Install all programs from Development category
## @since 1.0
development() {
  # VSCode
  installDEB "code" "VSCode (Editor)" "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" true "$I_CODE"

  # nvm
  if ! $I_NVM; then
    printf "  ${BOLD}${BG_YELLOW_DIM}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "nvm"
    echo "        ${BOLD}Run:${COLOR_RESET} curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash"
  fi


  # git
  installPPA "git" "git" "ppa:git-core/ppa" "$I_GIT"

  # GitHub CLI
  if ! $I_GH; then
    echo -n "  ${BOLD}   -> GitHub CLI${COLOR_RESET}? [Y/n]: "
    read -r INSTALL

    if [ "$INSTALL" = "y" ] || [ "$INSTALL" = "Y" ] || [ "$INSTALL" = "" ]; then
      logSeparator 'GitHub CLI' "$ERROR"

      echo "        Installing..."
      {
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list
        sudo apt-get update -qq
        sudo apt-get install gh -qq
      } > /dev/null 2>> "$ERROR"

      [ $? -eq 0 ] && printf "  ${BOLD}${BG_GREEN}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "GitHub CLI"
      [ $? -eq 1 ] && printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "${BOLD}${COLOR_RED}GitHub CLI *${COLOR_RESET}"
    else
      printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "GitHub CLI"
    fi

  fi

  # Jetbrains Toolbox App
  if ! $I_TOOLBOX; then
    echo -n "  ${BOLD}   -> Jetbrains Toolbox App${COLOR_RESET}? [Y/n]: "
    read -r INSTALL

    if [ "$INSTALL" = "y" ] || [ "$INSTALL" = "Y" ] || [ "$INSTALL" = "" ]; then
      logSeparator 'Jetbrains Toolbox App' "$ERROR"

      local TOOLURL ; TOOLURL=$(curl -sS 'https://data.services.jetbrains.com//products/releases?code=TBA&latest=true&type=release' | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}' | sed 's/[", ]//g')
      local TOOLDEST ; TOOLDEST="/tmp/$(basename "$TOOLURL")"
      local TOOLDIR ; TOOLDIR="/opt/jetbrains-toolbox"

      echo "        Downloading..."
      curl -sSL "$TOOLURL" -o "$TOOLDEST" 2>> "$ERROR"

      echo "        Jetbrains Toolbox App will be installed in '$TOOLDIR'"
      sudo mkdir -p "$TOOLDIR" && sudo tar -xzf "$TOOLDEST" -C "$TOOLDIR" --strip-components=1 > /dev/null 2>> "$ERROR"

      [ $? -eq 0 ] && printf "  ${BOLD}${BG_GREEN}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "Jetbrains Toolbox App"
      [ $? -eq 1 ] && printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "${BOLD}${COLOR_RED}Jetbrains Toolbox App *${COLOR_RESET}"
    else
      printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "Jetbrains Toolbox App"
    fi

  fi

  # Docker
  if ! $I_DOCKER; then
    echo -n "  ${BOLD}   -> Docker${COLOR_RESET}? [Y/n]: "
    read -r INSTALL

    if [ "$INSTALL" = "y" ] || [ "$INSTALL" = "Y" ] || [ "$INSTALL" = "" ]; then
      logSeparator 'Docker' "$ERROR"

      echo "        Installing..."
      {
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
        sudo apt-get update -qq
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -qq
        sudo usermod -aG docker "$USER"
      } > /dev/null 2>> "$ERROR"

      [ $? -eq 0 ] && printf "  ${BOLD}${BG_GREEN}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "Docker"
      [ $? -eq 0 ] && echo -e "  ${BOLD}Log out and log back in${COLOR_RESET} so that your group membership is re-evaluated.\n"
      [ $? -eq 1 ] && printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "${BOLD}${COLOR_RED}Docker *${COLOR_RESET}"
    else
      printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "Docker"
    fi

  fi

  # MySQL Dependencies (gnome-keyring)
  installStandard "gnome-keyring" "MySQL Dependencies (gnome-keyring)" "$I_MYSQLDEP1"

  # MySQL Dependencies (libproj-dev)
  installStandard "libproj-dev" "MySQL Dependencies (libproj-dev)" "$I_MYSQLDEP2"

  # MySQL
  if ! $I_MYSQL; then
    printf "  ${BOLD}${BG_YELLOW_DIM}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "MySQL"
    echo "        ${BOLD}Visit:${COLOR_RESET} https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/#apt-repo-fresh-install"
    echo "        ${BOLD}Run:${COLOR_RESET} sudo apt update"
    echo "        ${BOLD}Run:${COLOR_RESET} sudo apt install mysql-server"
  fi

  # MySQL Workbench
  if ! $I_MYSQLW; then
    printf "  ${BOLD}${BG_YELLOW_DIM}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "MySQL Workbench"
    echo "        ${BOLD}Visit:${COLOR_RESET} https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/#apt-repo-fresh-install"
    echo "        ${BOLD}Run:${COLOR_RESET} sudo apt update"
    echo "        ${BOLD}Run:${COLOR_RESET} sudo apt install mysql-workbench-community"
  fi

  # XAMPP
  if ! $I_XAMPP; then
    printf "  ${BOLD}${BG_YELLOW_DIM}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "XAMPP"
    echo "        ${BOLD}Visit:${COLOR_RESET} https://sourceforge.net/projects/xampp/files/latest/download"
  fi
}

## Install all programs from Others category
## @since 1.0
others() {
  # qBitorrent
  installPPA "qbittorrent" "qBittorrent" "ppa:qbittorrent-team/qbittorrent-stable" "$I_QBTORR"

  # OBS Studio
  installPPA "obs-studio" "OBS Studio" "ppa:obsproject/obs-studio" "$I_OBS"

  # Pcloud
  if ! $I_PCLOUD; then
    printf "  ${BOLD}${BG_YELLOW_DIM}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "Pcloud"
    echo "        ${BOLD}Visit:${COLOR_RESET} https://www.pcloud.com/how-to-install-pcloud-drive-linux.html?download=electron-64"
    echo "        ${BOLD}Info:${COLOR_RESET} Remember to move it into \"$HOME/Applications/pcloud\""
  fi

  #Anki
  if ! $I_ANKI; then
    echo -n "  ${BOLD}   -> Anki${COLOR_RESET}? [Y/n]: "
    read -r INSTALL

    if [ "$INSTALL" = "y" ] || [ "$INSTALL" = "Y" ] || [ "$INSTALL" = "" ]; then
      logSeparator 'Anki' "$ERROR"

      local ANKI_VERSION ; ANKI_VERSION=$(curl -sS https://api.github.com/repos/ankitects/anki/releases/latest | grep tag_name | grep -oP "\d+\.?\d*\.?\d*")
      local ANKI_URL="https://github.com/ankitects/anki/releases/download/$ANKI_VERSION/anki-$ANKI_VERSION-linux-qt6.tar.zst"

      echo "        Downloading..."
      cd "/tmp" 2>> "$ERROR" || exit
      {
        curl -sSLO "$ANKI_URL"
        mkdir -p "/tmp/anki"
        tar xaf "/tmp/$(basename "$ANKI_URL")" -C "/tmp/anki" --strip-components=1
      } > /dev/null 2>> "$ERROR"

      echo "        Installing..."
      [ -f "/tmp/anki/install.sh" ] && (cd anki 2>> "$ERROR" || exit ; sudo ./install.sh > /dev/null 2>> "$ERROR")

      [ $? -eq 0 ] && printf "  ${BOLD}${BG_GREEN}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "Anki"
      [ $? -eq 1 ] && printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "${BOLD}${COLOR_RED}Anki *${COLOR_RESET}"

      cd "$INITDIR" 2>> "$ERROR" || exit
    else
      printf "  ${BOLD}${BG_RED}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "Anki"
    fi

  fi

  # Joplin
  if ! $I_JOPLIN; then
    printf "  ${BOLD}${BG_YELLOW_DIM}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "Joplin"
    echo "        ${BOLD}Run:${COLOR_RESET} wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash"
  fi

  # Droidcam
  if ! $I_DROIDCAM; then
    printf "  ${BOLD}${BG_YELLOW_DIM}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "Droidcam"
    echo "        ${BOLD}Visit:${COLOR_RESET} https://www.dev47apps.com/droidcam/linux/"
  fi

  # JetBrains Mono (Font)
  if ! $I_JBMONO; then
    local JBMONO_VERSION ; JBMONO_VERSION=$(curl -sS https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest | grep tag_name | grep -oP "\d+\.?\d*\.?\d*")
    local JBMONO_URL ; JBMONO_URL="https://github.com/JetBrains/JetBrainsMono/releases/download/v$JBMONO_VERSION/JetBrainsMono-$JBMONO_VERSION.zip"
    printf "  ${BOLD}${BG_YELLOW_DIM}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "JetBrains Mono (Font)"

    echo "        Downloading..."
    cd "/tmp" 2>> "$ERROR" || exit;curl -sSLO "$JBMONO_URL"
    mkdir -p "$DOWNLOADS/fonts/JetBrains Mono" && unzip -oqj "$(basename "$JBMONO_URL")" 'fonts/ttf/*' -d "$DOWNLOADS/fonts/JetBrains Mono"
    find "$DOWNLOADS/fonts/JetBrains Mono" -type f -name "*.ttf" | grep -P "NL" | xargs -I {} rm {}

    echo "        ${BOLD}Info:${COLOR_RESET} JetBrains Mono Fonts downloded in '$DOWNLOADS/fonts/JetBrains Mono'"
    echo "        ${BOLD}Info:${COLOR_RESET} Install the fonts with the ${COLOR_BLUE}Font Manager${COLOR_RESET}"
    cd "$INITDIR" 2>> "$ERROR" || exit

  fi

  # JetBrainsMono Nerd (Font)
  if ! $I_JBMONO_NERD; then
    printf "  ${BOLD}${BG_YELLOW_DIM}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "JetBrainsMono Nerd (Font)"
    echo "        ${BOLD}Visit:${COLOR_RESET} https://downgit.github.io/#/home?url=https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono/Ligatures"
    echo "        ${BOLD}Download:${COLOR_RESET} In '/tmp'"
    echo "        ${BOLD}Run:${COLOR_RESET} cd /tmp;unzip -oq Ligatures.zip${COLOR_RESET}"
    echo "        ${BOLD}Run:${COLOR_RESET} mkdir -p '$DOWNLOADS/fonts/JetBrainsMono Nerd'${COLOR_RESET}"
    echo "        ${BOLD}Run:${COLOR_RESET} find Ligatures -type f -name \"*.ttf\" | grep -P \"JetBrains Mono[ \\w]+ Complete Mono\\.ttf\" | xargs -I {} cp {} \"$DOWNLOADS/fonts/JetBrainsMono Nerd\"${COLOR_RESET}"
    echo "        ${BOLD}Info:${COLOR_RESET} Install the fonts with the ${COLOR_BLUE}Font Manager${COLOR_RESET}"
  fi
}

zshConfig() {
  logSeparator 'zsh config' "$ERROR"

  if ! dpkg --get-selections | grep -wq zsh; then
    echo "Checking prerequisites: ${BOLD}zsh ❌${COLOR_RESET}"
    sudo apt-get install zsh -qq > /dev/null 2>> "$ERROR"
  else
    echo "Checking prerequisites: ${BOLD}zsh ✅${COLOR_RESET}"
  fi

  if [ ! "$(grep "$(id -u)" /etc/passwd | awk -F: '{print $7}')" = "/usr/bin/zsh" ]; then
    echo "Checking prerequisites: ${BOLD}zsh as login shell ❌${COLOR_RESET}"
    chsh -s "$(which zsh)"
    echo "Log out and log back in again to use your new default shell."
  else
    echo "Checking prerequisites: ${BOLD}zsh as login shell ✅${COLOR_RESET}"
  fi
}

sshConfig() {
  if [ ! -f "$HOME"/.ssh/id_ed25519_github ]; then
    logSeparator 'ssh config' "$ERROR"

    echo -e " ❌\n"

    echo -e "Set the key name to ${BOLD}'$HOME/.ssh/id_ed25519_github'${COLOR_RESET}\n"
    ssh-keygen -t ed25519 -C 34426099+FaruNL@users.noreply.github.com
    eval "$(ssh-agent -s)"
    ssh-add /home/farid/.ssh/id_ed25519_github

    mkdir -p "$HOME/.ssh" ; cd "$HOME/.ssh" 2>> "$ERROR" || exit
    curl -sSO https://gist.githubusercontent.com/FaruNL/a5cab28b95918c53ebb115fb36935689/raw/config
    cd "$INITDIR" 2>> "$ERROR" || exit

    echo -e "Visit https://github.com/settings/keys and add your ssh public key: ${BOLD}'$HOME/.ssh/id_ed25519_github.pub'${COLOR_RESET}\n"

  else
    echo " ✅"
  fi
}

#-----------------------------------------------------
# Execution
#-----------------------------------------------------

# Check if it's run as root
if [[ $EUID = 0 ]]; then
  echo "It is not recommended (nor necessary) to run this script as root."
  exit 1
fi

# Write the root password once
sudo echo ""

# New date for log
if [ ! -f "$ERROR" ]; then
  echo -e "+++++++++++++++ $(date +'%x %X') +++++++++++++++" >> "$ERROR"
else
  echo -e "\n+++++++++++++++ $(date +'%x %X') +++++++++++++++" >> "$ERROR"
fi

showLogo

echo -e "┌─────────┐"
echo -e "│${BOLD}Checking:${COLOR_RESET}│"
echo -e "└─────────┘"

echo -e "${BG_YELLOW}  ${COLOR_RESET} Already installed  \
${BG_RED}  ${COLOR_RESET} Not installed\n"

checkInstalls

echo -en "\nDo you want to continue with the installation? [Y/n]: "
read -r CONTINUE

if [ "$CONTINUE" = "N" ] || [ "$CONTINUE" = "n" ]; then
  finalMessage
  exit 0
fi

echo -e "┌───────────┐"
echo -e "│${BOLD}Installing:${COLOR_RESET}│"
echo -e "└───────────┘"

echo -e "${BG_GREEN}  ${COLOR_RESET} Installed  \
${BG_YELLOW_DIM}  ${COLOR_RESET} Manual installation  \
${BG_RED}  ${COLOR_RESET} Not installed  \
${BG_RED}  ${COLOR_RESET} ${BOLD}${COLOR_RED}Error *${COLOR_RESET}\n"

# Configure `zsh`
zshConfig

# Install `curl` if necessary
echo -n "Checking prerequisites: ${BOLD}curl${COLOR_RESET}"

if dpkg --get-selections | grep -wq curl; then
  echo " ✅"
else
  echo " ❌"
  echo "Installing ${BOLD}curl${COLOR_RESET}..."
  sudo apt-get install curl -qq > /dev/null
  printf "${BOLD}${BG_GREEN}  ${COLOR_RESET}${BOLD} <- %s${COLOR_RESET}\n" "curl"
fi

# Configure `ssh for git` if necessary
echo -n "Checking prerequisites: ${BOLD}ssh-git${COLOR_RESET}"
sshConfig

# Offer to backup and restore dot files
echo -e "\nIf you want to ${BOLD}restore/backup your dot files${COLOR_RESET} run the following command:"
echo "bash <(curl -sS https://gist.githubusercontent.com/FaruNL/4975e2918d1e10c65844b428b59b18ad/raw/dot-files.sh)"

# Install all or certain category of software
echo -e "\nWhat do you want to install?"
echo -n "(1. Utilities, 2. Development, 3. Others, 4. All, ${BOLD}${COLOR_RED}*. Stop${COLOR_RESET}): "
read -r CATEGORY

case $CATEGORY in
  "1")
    echo -e "\nYou chose: ${BOLD}${COLOR_GREEN}Utilities${COLOR_RESET}\n"
    utilities
  ;;
  "2")
    echo -e "\nYou chose ${BOLD}${COLOR_GREEN}Development${COLOR_RESET}\n"
    development
  ;;
  "3")
    echo  -e "\nYou chose ${BOLD}${COLOR_GREEN}Others${COLOR_RESET}\n"
    others
  ;;
  "4")
    echo -e "\nYou chose ${BOLD}${COLOR_GREEN}All${COLOR_RESET}\n"
    utilities
    development
    others
  ;;
  *)
    echo -e "\nScript ${BOLD}${COLOR_RED}stopped${COLOR_RESET}"
    finalMessage
    exit 0
  ;;
esac

finalMessage
