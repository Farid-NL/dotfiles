#!/usr/bin/env bash

if ! bw login --check > /dev/null 2>&1; then
  bw login
fi
