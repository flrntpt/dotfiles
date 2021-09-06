#!/bin/sh
#
# Install configuration

set -e


SCRIPT_PATH=$(realpath $0)
SCRIPT_DIR=$(dirname $SCRIPT_PATH)

source $SCRIPT_DIR/base.sh
source $COMMON_DIR/install.sh

DEBUG=true
DST_DIR="$HOME/$DEBUG_DIRECTORY"  # Will be updated if debug is false
CONFIG_DIRNAME=".config"
BACKUP_PREFIX="config_backup"


function show_help {
  echo "Installer for config (run in debug by default):"
  echo " -d pick the directory, relative to \$HOME"
  echo " -f install a specific file relative to \$SCRIPT_DIR"
  echo " -g disable debug mode"
  echo " -h show help"
}


install_config_files () {
  for src in $(
    find -H "$DOTFILES_DIR" \
    -path "*/config" \
    -not -path "*.git*"
  )
  do
    recurse_install $src get_destination_path_for_config
  done
}


get_destination_path_for_config () {
  local src=$1

  local valid_file_character="[a-zA-Z0-9\_\-\.]"
  local topic_regex="${DOTFILES_DIR}\/(${valid_file_character}+)\/config/(.*)"

  if [[ $src =~ $topic_regex ]]; then
    local topic=${BASH_REMATCH[1]}
    local rel_path=${BASH_REMATCH[2]}
    local dst="$(get_config_directory)/${topic}/${rel_path}"
  fi
  echo $dst
}


get_config_directory () {
  echo "${DST_DIR}/${CONFIG_DIRNAME}"
}


get_backup_path_for_config () {
  echo "${DST}/${BACKUP_DIRNAME}/${BACKUP_PREFIX}_${NOW}"
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
      DST_DIR="$HOME/.config"
      ;;
    d )
      custom_dir=${OPTARG}
      DST_DIR="$HOME/${custom_dir}"
      ;;
    f )
      rel_path=${OPTARG}
      SRC="${DOTFILES_DIR}/${rel_path}"
      install_config $SRC
      exit 0
      ;;
    p )
      FORCE_PROMPT=true
      ;;
  esac
done

install_config_files
# TODO: maybe check return value of previous function?
success "Config files successfully installed in '$DST_DIR'!"

