#!/bin/bash

PROJECT_NAME="porg"
PROJECT_RELEASE_DATE="Jan 08 2021"
PROJECT_VERSION="0.1.0"

TC_GREEN=$'\e[32m'
TC_CLEAR=$'\e[39m'

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

while getopts "" option; do
  case $option in
  esac
done
