#!/bin/bash

PROJECT_NAME="porg"
PROJECT_RELEASE_DATE="Jan 08 2021"
PROJECT_VERSION="0.1.0"

BC_CLEAR=$'\e[49m'
BC_RED=$'\e[101m'
EOL_CL=$'\x1B[K'
TC_GREEN=$'\e[32m'
TC_CLEAR=$'\e[39m'

__error_message() {
  echo
  echo "$BC_RED$EOL_CL"
  echo -e " >>> $1$EOL_CL"
  echo "$EOL_CL$BC_CLEAR"
}

__help() {
  echo
  echo "Usage: $PROJECT_NAME [-h]"
  echo
  echo "Options:"
  echo "h     Print this help message"
}

__logo() {
  echo -e "$TC_GREEN"
  echo -e "  _____    ____   _____    _____  "
  echo -e " |  __ \  / __ \ |  __ \  / ____| "
  echo -e " | |__) || |  | || |__) || |  __  "
  echo -e " |  ___/ | |  | ||  _  / | | |_ | "
  echo -e " | |     | |__| || | \ \ | |__| | "
  echo -e " |_|      \____/ |_|  \_\ \_____| "
  echo -e "$TC_CLEAR"
}

__version() {
  echo
  echo "$PROJECT_NAME $PROJECT_VERSION built on $PROJECT_RELEASE_DATE"
}

__logo
__version

while getopts ":h" option; do
  case $option in
    h) __help && exit ;;
    \?) __error_message "Unknown option $@" && __help && exit ;;
  esac
done
