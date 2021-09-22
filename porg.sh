#!/bin/bash

PROJECT_NAME="porg"
PROJECT_CONFIG_FILE="$HOME/.${PROJECT_NAME}rc"
PROJECT_RAW_PATH="https://raw.githubusercontent.com/inigochoa/$PROJECT_NAME"
PROJECT_RELEASE_DATE="Sep 22 2021"
PROJECT_VERSION="0.0.1"
LATEST_VERSION=""

declare -A BASE
declare -A EDITORS
declare -A PROJECTS

BC_CLEAR=$'\e[49m'
BC_GREEN=$'\e[42m'
BC_RED=$'\e[101m'
BC_YELLOW=$'\e[103m'
EOL_CL=$'\x1B[K'
TC_BLACK=$'\e[30m'
TC_BLUE=$'\e[34m'
TC_GREEN=$'\e[32m'
TC_CLEAR=$'\e[39m'
TC_YELLOW=$'\e[33m'

__add() {
  local path="$(pwd)"

  echo
  echo "Adding path $TC_BLUE$path$TC_CLEAR to $PROJECT_NAME"

  while : ; do
    read -p "${TC_GREEN}Give the project a name: $TC_CLEAR" name

    if [[ -z "$name" ]]; then
      __error_message "Name cannot be empty"
    elif [[ -v "PROJECTS[$name]" ]]; then
      __error_message "Name $name already exists and points to ${PROJECTS[$name]}"
    else
      break
    fi
  done

  PROJECTS[$name]="$path"

  __write_config

  __success_message "$name has been added to $PROJECT_NAME"
}

__add_editor_if_available() {
  if [[ $(which "$1") ]]; then
    EDITORS["$2"]="$1"
  fi
}

__configure() {
  echo

  PS3="${TC_GREEN}Select the default editor: $TC_CLEAR"
  __select "${!EDITORS[@]}"

  BASE["editor"]="$option"

  __write_config

  __success_message "Successfully selected $option as the default editor"
}

__error_message() {
  echo
  echo "$BC_RED$EOL_CL"
  echo -e " >>> $1$EOL_CL"
  echo "$EOL_CL$BC_CLEAR"
}

__file_exists() {
  if [[ -f "$1" ]]; then
    return 1
  fi

  return 0
}

__folder_exists() {
  if [[ -d "$1" ]]; then
    return 1
  fi

  return 0
}

__get_latest_version() {
  local appversion_file
  appversion_file="$PROJECT_RAW_PATH/main/APPVERSION?$(date +%s)"

  LATEST_VERSION="$(curl --connect-timeout 5 -s "$appversion_file")"
}

__help() {
  echo
  echo "Usage: $PROJECT_NAME [-a|c|f|h|l|r]"
  echo
  echo "When no option is passed, $PROJECT_NAME will show the list of projects to choose which one to open in the selected editor."
  echo
  echo "Options:"
  echo "a     Add current path to $PROJECT_NAME as a project"
  echo "c     Configure $PROJECT_NAME"
  echo "f     Move to the folder of a project"
  echo "h     Print this help message"
  echo "l     List added projects"
  echo "r     Remove a project from $PROJECT_NAME"
}

__info_message() {
  echo
  echo -e "$BC_YELLOW$EOL_CL"

  for line in "$@"; do
    echo -e "$TC_BLACK >>> $line$TC_CLEAR$EOL_CL"
  done

  echo -e "$EOL_CL$BC_CLEAR"
}

__is_projects_empty() {
  if [ "0" == "${#PROJECTS[@]}" ]; then
    __error_message "There are no projects saved in $PROJECT_NAME"

    return 1
  fi

  return 0
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
    __info_message "Version $LATEST_VERSION of $PROJECT_NAME is available. Please, run the following command to update:" "curl -s $PROJECT_RAW_PATH/main/installer.sh | sudo bash"
  fi
}

__list() {
  local project_count=${#PROJECTS[@]}

  echo
  echo "You have $TC_BLUE$project_count$TC_CLEAR $(__plural "project" $project_count) saved in $PROJECT_NAME"

  for project in "${!PROJECTS[@]}"; do
    printf "%-8s\n" "${project}"
  done | column
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

__open() {
  __is_projects_empty
  if [[ 1 -eq $? ]]; then
    return
  fi

  echo
  PS3="${TC_GREEN}Select a project to open with $TC_YELLOW${BASE[editor]}$TC_CLEAR: $TC_CLEAR"
  __select "${!PROJECTS[@]}"

  echo
  echo "Opening $TC_BLUE$option$TC_CLEAR with $TC_YELLOW${BASE[editor]}$TC_CLEAR..."

  eval ${EDITORS[${BASE[editor]}]} ${PROJECTS[$option]}
}

__plural() {
  if [ $2 -eq 1 -o $2 -eq -1 ]; then
    echo ${1}
  else
    echo ${1}s
  fi
}

__remove() {
  __is_projects_empty
  if [[ 1 -eq $? ]]; then
    return
  fi

  echo
  PS3="${TC_GREEN}Select project to remove from $PROJECT_NAME: $TC_CLEAR"
  __select "${!PROJECTS[@]}"

  echo
  read -p "${TC_YELLOW}Do you confirm removing $option from $PROJECT_NAME?$TC_CLEAR (y/n) " -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    unset PROJECTS[$option]

    __write_config

    __success_message "$option removed from $PROJECT_NAME"
  fi
}

__select() {
  select option; do
    if [[ $REPLY == ?(-)+([0-9]) ]] && [ 1 -le "$REPLY" ] && [ "$REPLY" -le $# ]; then
      break
    else
      __error_message "Please select a number between 1 and $#"
    fi
  done
}

__set_editors() {
  __add_editor_if_available "atom" "Atom"
  __add_editor_if_available "subl" "Sublime text"
  __add_editor_if_available "vim" "Vim"
  __add_editor_if_available "code" "VS Code"
}

__success_message() {
  echo
  echo -e "$BC_GREEN$EOL_CL"

  for line in "$@"; do
    echo -e "$TC_BLACK >>> $line$TC_CLEAR$EOL_CL"
  done

  echo -e "$EOL_CL$BC_CLEAR"
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
__set_editors

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

OPTIND=1
while getopts ":achlr" option; do
  case $option in
    a) __add && exit 0 ;;
    c) __configure && exit 0 ;;
    h) __help && exit 0 ;;
    l) __list && exit 0 ;;
    r) __remove && exit 0 ;;
    \?) __error_message "Unknown option $@" && __help && exit 0 ;;
  esac
done

__open
