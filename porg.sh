#!/bin/bash

PROJECT_NAME="porg"
PROJECT_CONFIG_FOLDER="$HOME/.$PROJECT_NAME"
PROJECT_CONFIG_FILE="$PROJECT_CONFIG_FOLDER/config"
PROJECT_RAW_PATH="https://raw.githubusercontent.com/inigochoa/$PROJECT_NAME"
PROJECT_RELEASE_DATE="Jan 09 2021"
PROJECT_VERSION="0.2.0"
LATEST_VERSION=""

declare -A BASE
declare -A PROJECTS

BC_CLEAR=$'\e[49m'
BC_RED=$'\e[101m'
BC_YELLOW=$'\e[103m'
EOL_CL=$'\x1B[K'
TC_BLACK=$'\e[30m'
TC_GREEN=$'\e[32m'
TC_CLEAR=$'\e[39m'
TC_YELLOW=$'\e[33m'

__error_message() {
  echo
  echo "$BC_RED$EOL_CL"
  echo -e " >>> $1$EOL_CL"
  echo "$EOL_CL$BC_CLEAR"
}

__file_exists() {
  if [[ -f "$1" ]]; then
    return 1
  else
    return 0
  fi
}

__folder_exists() {
  if [[ -d "$1" ]]; then
    return 1
  else
    return 0
  fi
}

__get_latest_version() {
  local appversion_file
  appversion_file="$PROJECT_RAW_PATH/main/APPVERSION?$(date +%s)"

  LATEST_VERSION="$(curl --connect-timeout 5 -s "$appversion_file")"
}

__help() {
  echo
  echo "Usage: $PROJECT_NAME [-h]"
  echo
  echo "Options:"
  echo "h     Print this help message"
}

__info_message() {
  echo
  echo -e "$BC_YELLOW$EOL_CL"

  for line in "$@"; do
    echo -e "$TC_BLACK >>> $line$TC_CLEAR$EOL_CL"
  done

  echo -e "$EOL_CL$BC_CLEAR"
}

__is_update_available() {
  __get_latest_version

  if [[ ! $LATEST_VERSION ]]; then
    return
  fi

  if [ "$PROJECT_VERSION" = "$LATEST_VERSION" ]; then
    return
  fi

  if [ "$PROJECT_VERSION" = "`echo -e "$PROJECT_VERSION\n$LATEST_VERSION" | sort -V | head -n1`" ]; then
    __info_message "Version $LATEST_VERSION of $PROJECT_NAME is available. Please, run the following command to update:" "curl -s $PROJECT_RAW_PATH/master/installer.sh | sudo bash"
  fi
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

__write_config() {
  printf "[BASE]\n" > "$PROJECT_CONFIG_FILE"

  for index in "${!BASE[@]}"; do
    printf "%s=%s\n" "$index" "${BASE[$index]}" >> "$PROJECT_CONFIG_FILE"
  done

  printf "\n" >> "$PROJECT_CONFIG_FILE"
  printf "[PROJECTS]\n" >> "$PROJECT_CONFIG_FILE"

  for index in "${!PROJECTS[@]}"; do
    printf "%s=%s\n" "$index" "${PROJECTS[$index]}" >> "$PROJECT_CONFIG_FILE"
  done
}

__logo
__version
__is_update_available

__folder_exists "$PROJECT_CONFIG_FOLDER"
if [[ 0 -eq $? ]]; then
  mkdir -p "$PROJECT_CONFIG_FOLDER"
fi

__file_exists "$PROJECT_CONFIG_FILE"
if [[ 0 -eq $? ]]; then
  __write_config
fi

while read line; do
  if [[ $line =~ ^"["(.+)"]"$ ]]; then
    arrname=${BASH_REMATCH[1]}
    declare -A $arrname
  elif [[ $line =~ ^(.*)"="(.*) ]]; then
    declare $arrname["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
  fi
done < "$PROJECT_CONFIG_FILE"

while getopts ":h" option; do
  case $option in
    h) __help && exit ;;
    \?) __error_message "Unknown option $@" && __help && exit ;;
  esac
done
