#!/bin/bash
#
# Run installers

set -e

SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
DOTFILES_DIR=$(dirname "$SCRIPT_DIR")

source "$SCRIPT_DIR/base.sh"
source "$COMMON_DIR/install.sh"

DEBUG=true


show_help () {
  echo "Run installers script:"
  echo " -f run a specific installer, relative to \$SCRIPT_DIR"
  echo " -g disable debug mode"
  echo " -h show help"
}


install_all () {
  while IFS= read -r -d '' installer
  do
    install_one "$installer"
  done < <(find "$DOTFILES_DIR" -name "install.sh" -print0)
}


install_one () {
  local src="$1"
  local op="sh -c "$src""
  if [[ $DEBUG == "true" ]]; then
    echo "$op"
  else
    eval "$op"
  fi
}


while getopts hgd:f:p flag
do
  case "$flag" in
    h )
      show_help
      exit 0
      ;;
    g )
      DEBUG=false
      ;;
    f )
      rel_path=${OPTARG}
      SRC="${SCRIPT_DIR}/${rel_path}"
      install_one $SRC
      exit 0
      ;;
    * )
      ;;
  esac
done

install_all
