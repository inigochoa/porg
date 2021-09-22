#!/bin/bash

set -u

PROJECT_NAME="porg"
PROJECT_RAW_PATH="https://raw.githubusercontent.com/inigochoa/$PROJECT_NAME"
DESTINATION_FOLDER="/usr/local/bin/"

BC_CLEAR=$'\e[49m'
BC_RED=$'\e[101m'
BC_YELLOW=$'\e[103m'
EOL_CL=$'\x1B[K'
TC_BLACK=$'\e[30m'
TC_BLUE=$'\e[34m'
TC_CLEAR=$'\e[39m'
TC_GREEN=$'\e[32m'

__error_message() {
  echo
  echo -e "$BC_RED$EOL_CL"
  echo -e " >>> $1$EOL_CL"
  echo -e "$EOL_CL$BC_CLEAR"
}

__exit_abnormal() {
  __error_message "$1"

  exit 1
}

__get_latest_version() {
  local version_file
  version_file="$PROJECT_RAW_PATH/main/APPVERSION?$(date +%s)"

  LATEST_VERSION="$(curl -s "$version_file")"

  if [[ "" == "$LATEST_VERSION" ]]; then
    __exit_abnormal "Could not find latest $PROJECT_NAME version"
  fi

  if [[ "404: Not Found" == "$LATEST_VERSION" ]]; then
    __exit_abnormal "Could not find latest $PROJECT_NAME version"
  fi

  echo "$TC_GREEN[1]$TC_CLEAR Found version $LATEST_VERSION"
}

__install() {
  local binary_file
  binary_file="$PROJECT_RAW_PATH/v$LATEST_VERSION/$PROJECT_NAME.sh?$(date +%s)"

  local output_file
  output_file="$DESTINATION_FOLDER$PROJECT_NAME"

  curl -s "$binary_file" -o "$output_file"
  echo "$TC_GREEN[2]$TC_CLEAR Downloaded $PROJECT_NAME $LATEST_VERSION binary"

  chmod +x "$output_file"
  echo "$TC_GREEN[3]$TC_CLEAR $PROJECT_NAME is now installed. To start using it, type $TC_BLUE$PROJECT_NAME$TC_CLEAR on a command shell"
}

__get_latest_version
__install
