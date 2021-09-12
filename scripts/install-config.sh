#!/bin/bash
#
# Install configuration

set -e

source "${0%/*}/common/config.sh"
source "${0%/*}/common/install.sh"

CONFIG_DIRNAME=".config"
BACKUP_PREFIX="config_backup"

show_help () {
  echo "Installer for config (run in debug by default):"
  echo " -d pick the directory, relative to \$HOME"
  echo " -f install a specific file relative to \$SCRIPT_DIR"
  echo " -g disable debug mode"
  echo " -h show help"
  echo " -p force prompt"
}


install_config_files () {
  while IFS= read -r -d '' src
  do
    recurse_install "$src" get_destination_path_for_config
  done < <(
    find -H "$DOTFILES_DIR" -path "*/config" -not -path "*.git*" -print0
  )
}


get_destination_path_for_config () {
  local src=$1

  local valid_file_character="[a-zA-Z0-9\_\-\.]"
  local topic_regex="${DOTFILES_DIR}\/(${valid_file_character}+)\/config/(.*)"

  if [[ $src =~ $topic_regex ]]; then
    local topic=${BASH_REMATCH[1]}
    local rel_path=${BASH_REMATCH[2]}
    local dst
    dst="$(get_config_directory)/${topic}/${rel_path}"
  fi
  echo "$dst"
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
      DST_DIR="$HOME"
      ;;
    d )
      custom_dir=${OPTARG}
      DST_DIR="$HOME/${custom_dir}"
      ;;
    f )
      rel_path=${OPTARG}
      src="${DOTFILES_DIR}/${rel_path}"
      unset rel_path

      recurse_install $src get_destination_path_for_config
      unset src
      exit 0
      ;;
    p )
      FORCE_PROMPT=true
      ;;
    * )
      exit 1
      ;;
  esac
done

install_config_files
# TODO: maybe check return value of previous function?
success "Config files successfully installed in '$DST_DIR'!"
