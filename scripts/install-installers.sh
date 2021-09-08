#!/bin/bash
#
# Run installers

set -e

source "${0%/*}/common/config.sh"
source "${0%/*}/common/constants.sh"
source "${0%/*}/common/install.sh"


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
  if [[ $DEBUG != "false" ]]; then
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
      src="${SCRIPT_DIR}/${rel_path}"
      unset rel_path

      install_one $src
      unset src
      exit 0
      ;;
    * )
      ;;
  esac
done

install_all
