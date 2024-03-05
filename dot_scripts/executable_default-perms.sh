#!/usr/bin/env bash

##  ______            _      _
## |  ____|          (_)    | |
## | |__  __ _  _ __  _   __| |
## |  __|/ _` || '__|| | / _` |
## | |  | (_| || |   | || (_| |
## |_|   \__,_||_|   |_| \__,_|

## @author Carlos Farid Nogales López
## @version 1.6
## @brief Script that restore default permissions of files or subdirectories of a directory

BOLD=$(tput bold)
NORMAL=$(tput sgr0)

if [ -d "$1" ]; then

  if [ "$2" = f ]; then
    find "$1" -type "$2" -print0 | xargs -0 chmod 664
    echo "Files inside '$1' are corrected"
  elif [ "$2" = d ]; then
    find "$1" -type "$2" -print0 | xargs -0 chmod 775
    echo "'$1' and its subdirectories are corrected"
  else
    echo -e "2nd argument invalid:\nChoose just ${BOLD}f ${NORMAL}(files) or ${BOLD}d ${NORMAL}(directories).";exit 1
  fi

else
  echo "The specified directory does not exist";exit 1
fi
