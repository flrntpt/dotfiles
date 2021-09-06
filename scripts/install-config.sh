#!/bin/sh
#
# Install configuration

set -e

SCRIPT_PATH=`realpath $0`
SCRIPT_DIR=`dirname $SCRIPT_PATH`
DOTFILES_DIR=`dirname $SCRIPT_DIR`

source $SCRIPT_DIR/common.sh
source $FORMATTING_SCRIPT_PATH

DEBUG=true
DST_DIR="$HOME/$DEBUG_DIRECTORY"
CONFIG_DIRNAME=".config"
CONFIG_DIRECTORY="${DST_DIR}/${CONFIG_DIRNAME}"

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
    recurse_install $src
  done
}


recurse_install () {
  local src=$1

  if [[ -d $src ]]; then
    for element in $src/*
    do
      recurse_install $element
    done
  else
    install_one_config_file $src
  fi
}

get_destination_path_for_config () {
  local src=$1

  local valid_file_character="[a-zA-Z0-9\_\-\.]"
  local topic_regex="${DOTFILES_DIR}\/(${valid_file_character}+)\/config/(.*)"

  if [[ $src =~ $topic_regex ]]; then
    local topic=${BASH_REMATCH[1]}
    local dst="${CONFIG_DIRECTORY}/${topic}/${BASH_REMATCH[2]}"
  fi
  echo $dst
}


install_one_config_file () {
  install_one $1 get_destination_path_for_config
}


while getopts hgd:f: flag
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
      DST_DIR="${DST_DIR}/${custom_dir}"
      ;;
    f )
      rel_path=${OPTARG}
      SRC="${DOTFILES_DIR}/${rel_path}"
      install_config $SRC
      exit 0
      ;;
  esac
done

install_config_files
# TODO: maybe check return value of previous function?
success "Config files successfully installed in '$DST_DIR'!"
