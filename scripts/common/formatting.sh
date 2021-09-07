#!/bin/bash
#
# Formatting utilities

set -e


YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[0;31m'
GREY='\033[1;30m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
NC='\033[0m'

DEFAULT_INDENT=2


debug () {
  printf "\r[ \033[00;34mDEBUG\033[0m ] %s\n" "$1"
}


info () {
  printf "\r[ \033[00;34m..\033[0m ] %s\n" "$1"
}


user () {
  printf "\r[ \033[0;33m??\033[0m ] %s\n" "$1"
}


success () {
  printf "\r\033[2K[ \033[00;32mOK\033[0m ] %s\n" "$1"
}


error () {
  printf "\r\033[2K[\033[0;31mERROR\033[0m] %s\n" "$1"
  echo ''
  exit
}


action () {
  printf "${BLUE}==> ${PURPLE}%s${NC}" "$1"
}


warning () {
  printf "${YELLOW}--> %s${NC}" "$1"
}

print () {
  msg=$1
  level=${2:-0}
  local indentation
  indentation=$(expr "$level" \* $DEFAULT_INDENT)
  printf "%*s%s\n" "$indentation" "" "$msg"
}
