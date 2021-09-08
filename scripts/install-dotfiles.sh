#!/bin/bash
#
# Perform dotfiles installation

set -e

source "${0%/*}/common/constants.sh"
source "${0%/*}/common/config.sh"
source "${0%/*}/common/install.sh"

SYMLINK_FLAG_SUFFIX=".symlink"
BACKUP_PREFIX="dotfiles_backup"


show_help () {
  echo "Installer for dotfiles (run in debug by default):"
  echo " -d pick the directory, relative to \$HOME"
  echo " -f install a specific file relative to \$SCRIPT_DIR"
  echo " -g disable debug mode"
  echo " -h show help"
}


install_dotfiles () {
  info "Dotfiles will be linked to: $DST_DIR"
  mkdir -p "$DST_DIR"

  while IFS= read -r -d '' src
  do
    recurse_install "$src" get_destination_path_for_dotfiles
  done < <(
    find -H "$DOTFILES_DIR" -name "*${SYMLINK_FLAG_SUFFIX}" \
    -not -path "*.git*" -print0
  )
}


get_destination_path_for_dotfiles () {
  local path=$1
  local valid_file_character="[a-zA-Z0-9\_\-\.]"

  # Replace SCRIPT_DIR/module with DST_DIR
  # Example: ~/dotfiles/tmux -> /destination/
  local dir_regex="${DOTFILES_DIR}\/$valid_file_character+(\/.*)"
  if [[ $path =~ $dir_regex ]]; then
    path=${DST_DIR}${BASH_REMATCH[1]}
  fi

  # Replace any occurence of file_or_dir.symlink with .file_or_dir
  local symlink_regex="(.*\/)?($valid_file_character+)\.symlink(.*)"
  while [[ $path =~ $symlink_regex ]] ; do
    path=${BASH_REMATCH[1]}.${BASH_REMATCH[2]}${BASH_REMATCH[3]}
  done
  # NOTE: if you want to debug, echo in the caller
  echo "$path"
}


while getopts hgd:f:p flag
do
  case "${flag}" in
    h )
      show_help
      exit 0
      ;;
    g )
      DEBUG=false
      DST_DIR=$HOME
      ;;
    d )
      custom_dir=${OPTARG}
      DST_DIR="${DST_DIR}/${custom_dir}"
      ;;
    f )
      rel_path=${OPTARG}
      src="${SCRIPT_DIR}/${rel_path}"
      unset rel_path

      recurse_install $src
      unset src
      exit 0
      ;;
    p )
      FORCE_PROMPT=true
      ;;
    * )
      ;;
  esac
done

install_dotfiles
# TODO: maybe check return value of previous function?
success "Dotfiles successfully installed in '$DST_DIR'!"

