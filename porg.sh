#!/bin/bash

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
  echo -e "                                  "
  echo -e "$TC_CLEAR"
}

__logo
