#!/usr/bin/env zsh

_util:is_command() {
  if command -v "$1" &>/dev/null; then
    true
  else
    false
  fi
}

_util:is_file_exec() {
  if [[ -x "$1" ]];then
    true
  else
    false
  fi
}

_util:prompt_install() {
  software_name="$1"

  printf '%s is not installed\n' "${software_name}"

  if gum confirm 'Do you want to install it?'; then
    true
  else
    false
  fi
}

_util:pretty_text() {
  software_name="$1"

  echo
  gum style \
    --foreground 212 \
    --border rounded --border-foreground 212 \
    --align center --padding '0 1' --margin '0' \
    "${software_name}"
}

_update:bw() {
  _util:pretty_text 'Bitwarden'

  if ! _util:is_command bw; then
    _util:prompt_install 'Bitwarden' || return 0
  fi

  # Download
  bw_url='https://vault.bitwarden.com/download/?app=cli&platform=linux'
  gum spin --spinner minidot --title "Downloading..." --show-error -- wget -q "${bw_url}" -O '/tmp/bw.zip'
  gum style --foreground 212 'Archive downloaded'

  # Extract
  if ! sudo -n true 2> /dev/null; then
    local password
    while true; do
      password=$(gum input --password --placeholder="Type sudo password")
      if [[ -z "${password}" ]]; then
        gum style --foreground '#ed2939' '⚠️ no password was provided!'
      fi

      if sudo -S true 2> /dev/null <<< "${password}"; then
        break
      else
        gum style --foreground '#ed2939' '⚠️ sudo password provided is incorrect!'
      fi
    done
  fi

  gum spin --spinner minidot --title "Extracting..." --show-error -- \
      sudo unzip -oq '/tmp/bw.zip' -d '/usr/local/bin'
  gum style --foreground 212 'Binary extracted'

  # Completions
  gum spin --spinner minidot --title "Updating completions..." -- \
    bw completion --shell zsh > ~/.local/share/zsh/completions/_bw
  gum style --foreground 212 'Completions updated'
}

_update:chezmoi() {
  _util:pretty_text 'Chezmoi'

  # Update
  gum spin --spinner minidot --title "Updating binary..." -- \
    chezmoi upgrade
  gum style --foreground 212 'Binary updated'

  # Completions
  gum spin --spinner minidot --title "Updating completions..." -- \
    chezmoi completion zsh > ~/.local/share/zsh/completions/_chezmoi
  gum style --foreground 212 'Completions updated'
}

_update:volta() {
  _util:pretty_text 'Volta'

  local mode='Updat'
  if ! _util:is_command volta; then
    mode='Install'
    _util:prompt_install 'Volta' || return 0
  fi

  # Update/Install
  gum spin --spinner minidot --title "${mode}ing..." --show-error -- \
    curl -s "https://get.volta.sh" | bash -s -- --skip-setup
  gum style --foreground 212 "Volta ${mode}ed"

  # Completions
  gum spin --spinner minidot --title "Updating completions..." --show-error -- \
    volta completions -f --quiet -o ~/.local/share/zsh/completions/_volta zsh
  gum style --foreground 212 'Completions updated'
}

_update:rbenv() {
  _util:pretty_text 'rbenv'

  if ! _util:is_command rbenv; then
    _util:prompt_install 'rbenv' || return 0
  fi

  gum spin --spinner minidot --title "Updating..." --show-error -- \
    git -C "$(rbenv root)" pull --quiet
  gum style --foreground 212 'Repository pulled'

}

_update:conda() {
  _util:pretty_text 'conda'

  gum spin --spinner minidot --title "Updating completions..." --show-error -- \
    wget -q https://raw.githubusercontent.com/conda-incubator/conda-zsh-completion/master/_conda \
    -O ~/.local/share/zsh/completions/_conda
  gum style --foreground 212 'Completions updated'
}

_update:delta() {
  _util:pretty_text 'delta'

  delta --generate-completion zsh > ~/.local/share/zsh/completions/_delta
  gum style --foreground 212 'Completions updated'
}

_update:navi() {
  _util:pretty_text 'navi'

  if ! _util:is_command navi; then
    mode='Install'
    _util:prompt_install 'Volta' || return 0
    BIN_DIR="$HOME/.local/bin" bash <(curl -sSL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
    return
  fi

  rm "$(which navi)"
  BIN_DIR="$HOME/.local/bin" bash <(curl -sSL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
}

_update:bw
_update:chezmoi
_update:volta
_update:rbenv
_update:conda
_update:delta
_update:navi
