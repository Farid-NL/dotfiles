#!/usr/bin/env bash

local_bin_dir="${HOME}/.local/bin"

[ -d "${local_bin_dir}" ] || mkdir -p "${local_bin_dir}"

if [ -f "${local_bin_dir}/bw" ] && [ -f "${local_bin_dir}/bws" ]; then
  echo -e "Bitwarden CLI and Bitwarden Secrets CLI already installed\n"
  exit
fi

# Bitwarden CLI
if [ -f "${local_bin_dir}/bw" ]; then
  echo -e "Bitwarden CLI already installed\n"
else
  bw_url="https://vault.bitwarden.com/download/?app=cli&platform=linux"

  echo -e "Downloading Bitwarden CLI from:\n${bw_url}\n"

  curl -LsS "${bw_url}" -o "${local_bin_dir}/bw.zip"
  unzip -oq "${local_bin_dir}/bw.zip" -d "${local_bin_dir}"
  rm "${local_bin_dir}/bw.zip"

  echo -e "Bitwarden CLI installed\n"
fi

# Bitwarden Secrets CLI
if [ -f "${local_bin_dir}/bws" ]; then
  echo -e "Bitwarden Secrets CLI already installed\n"
else
  bws_api_url="https://api.github.com/repos/bitwarden/sdk/releases/latest"

  bws_version=$(curl -sS "${bws_api_url}" | jq -r ".tag_name" | grep -oP "\d+\.?\d*\.?\d*")
  bws_url="https://github.com/bitwarden/sdk/releases/download/bws-v${bws_version}/bws-x86_64-unknown-linux-gnu-${bws_version}.zip"

  echo -e "Downloading Bitwarden Secrets CLI from:\n${bws_url}\n"

  curl -LsS "${bws_url}" -o "${local_bin_dir}/bws.zip"
  unzip -oq "${local_bin_dir}/bws.zip" -d "${local_bin_dir}"
  rm "${local_bin_dir}/bws.zip"

  echo -e "Bitwarden Secrets CLI installed\n"
fi
