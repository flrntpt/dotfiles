#!/bin/sh
#
# Perform dotfiles installation

set -e

SCRIPT_PATH=`realpath $0`
SCRIPT_DIR=`dirname $SCRIPT_PATH`
DOTFILES_DIR=`dirname $SCRIPT_DIR`

source "$SCRIPT_DIR/base.sh"
source "$COMMON_DIR/install.sh"

DEBUG=true
DST_DIR=$HOME/${DEBUG_DIRECTORY} # Will be updated if debug is false
SYMLINK_FLAG_SUFFIX=".symlink"
BACKUP_PREFIX="dotfiles_backup"


function show_help {
  echo "Installer for dotfiles (run in debug by default):"
  echo " -d pick the directory, relative to \$HOME"
  echo " -f install a specific file relative to \$SCRIPT_DIR"
  echo " -g disable debug mode"
  echo " -h show help"
}


install_dotfiles () {
  info "Dotfiles will be linked to: $DST_DIR"
  mkdir -p $DST_DIR

  local skip_all=false backup_all=false overwrite_all=false

  for src in $(find -H "$DOTFILES_DIR" \
      -name "*${SYMLINK_FLAG_SUFFIX}" \
      -not -path '*.git*'
  )
  do
    recurse_install $src get_destination_path_for_dotfiles
  done
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
  echo $path
}


while getopts hgd:f:p flag
do
  case "${flag}" in
    h )
      show_help
      exit 0
      ;;
    d )
      custom_dir=${OPTARG}
      DST_DIR="${DST_DIR}/${custom_dir}"
      ;;
    g )
      DEBUG=false
      DST_DIR=$HOME
      ;;
    f )
      rel_path=${OPTARG}
      SRC="${SCRIPT_DIR}/${rel_path}"
      recurse_install $SRC
      exit 0
      ;;
    p )
      FORCE_PROMPT=true
      ;;
  esac
done

install_dotfiles
# TODO: maybe check return value of previous function?
success "Dotfiles successfully installed in '$DST_DIR'!"

