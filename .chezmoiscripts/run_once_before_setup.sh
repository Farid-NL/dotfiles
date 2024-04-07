#!/usr/bin/env bash

# If not logged in, log in.
if ! bw login --check > /dev/null 2>&1; then
  bw login
fi
