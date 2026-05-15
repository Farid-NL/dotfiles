#!/usr/bin/env bash
source="${CHEZMOI_SOURCE_DIR}/root_etc/dnf/libdnf5.conf.d/50-kernel-retention.conf"
target="/etc/dnf/libdnf5.conf.d/50-kernel-retention.conf"

# Exit if the target already exists and is identical to the source.
if [ -f "$target" ]; then
  echo "Kernel retention policy already installed"
  exit 0
fi

# Install or update the file.
sudo install -Dm644 "${source}" "${target}"

echo "Kernel retention policy installed"
