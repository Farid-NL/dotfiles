#!/usr/bin/env bash

install_bitwarden_cli() {
  if [ -f "${local_bin_dir}/bw" ]; then
    echo "Bitwarden CLI already installed"
    return
  fi

  bw_url="https://vault.bitwarden.com/download/?app=cli&platform=linux"

  echo -e "Downloading Bitwarden CLI from:\n${bw_url}\n"

  curl -LsS "${bw_url}" -o "${local_bin_dir}/bw.zip"
  unzip -oq "${local_bin_dir}/bw.zip" -d "${local_bin_dir}"
  rm "${local_bin_dir}/bw.zip"

  echo "Bitwarden CLI installed"
}

install_bitwarden_secrets_cli() {
  if [ -f "${local_bin_dir}/bws" ]; then
    echo "Bitwarden Secrets CLI already installed"
    return
  fi

  bws_api_url="https://api.github.com/repos/bitwarden/sdk/releases/latest"

  bws_version=$(curl -sS "${bws_api_url}" | jq -r ".tag_name" | grep -oP "\d+\.?\d*\.?\d*")
  bws_url="https://github.com/bitwarden/sdk/releases/download/bws-v${bws_version}/bws-x86_64-unknown-linux-gnu-${bws_version}.zip"

  echo -e "Downloading Bitwarden Secrets CLI from:\n${bws_url}\n"

  curl -LsS "${bws_url}" -o "${local_bin_dir}/bws.zip"
  unzip -oq "${local_bin_dir}/bws.zip" -d "${local_bin_dir}"
  rm "${local_bin_dir}/bws.zip"

  echo "Bitwarden Secrets CLI installed"
}

local_bin_dir="${HOME}/.local/bin"
mkdir -p "${local_bin_dir}"

install_bitwarden_cli

install_bitwarden_secrets_cli

bw login
export BW_SESSION
BW_SESSION=$(bw unlock --raw)
