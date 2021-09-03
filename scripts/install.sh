#!/bin/sh
#
# Perform dotfiles installation

set -e

SCRIPT_PATH=`realpath $0`
SCRIPT_DIR=`dirname $SCRIPT_PATH`
DOTFILES_DIR=`dirname $SCRIPT_DIR`

source $SCRIPT_DIR/formatting.sh

DEBUG=true
DEBUG_DIRECTORY="dotfiles_debug"

DST_DIR=$HOME/${DEBUG_DIRECTORY}

SYMLINK_FLAG_SUFFIX=".symlink"

DATE_FORMAT="%Y_%m_%dT%H_%M_%S"
NOW=$(date +${DATE_FORMAT})
BACKUP_PREFIX="dotfiles_backup"


function show_help {
  echo "Installer for dotfiles:"
  echo " -d pick the directory, relative to \$HOME"
  echo " -f install a specific file relative to \$SCRIPT_DIR"
  echo " -g run in debug mode"
  echo " -h show help"
}


install_dotfiles () {
  info "Dotfiles will be linked to: $DST_DIR"
  mkdir -p $DST_DIR

  local skip_all=false backup_all=false overwrite_all=false
  echo $DOTFILES_DIR

  for src in $(find -H "$DOTFILES_DIR" \
      -name "*${SYMLINK_FLAG_SUFFIX}" \
      -not -path '*.git*'
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
    install_one $src
  fi
}


get_destination_path () {
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
  echo $path
}



install_one () {
  local src=$1
  local dst=$(get_destination_path $src)
  info "Installing $src to $dst"

  local skip= backup= overwrite=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]; then

    if [[ $skip_all != "true" ]] && \
       [[ $backup_all != "true" ]] && \
       [[ $overwrite_all != "true" ]]; then

      if [[ $(readlink $dst) == "$src" ]] && [[ $DEBUG != "true" ]]; then
        info "Symlink exist already for ${dst}: will be skipped."
        skip=true
      else
        prompt_user_for_action $src $dst
      fi
    fi
  fi

  backup=${backup:-$backup_all}
  overwrite=${overwrite:-$overwrite_all}
  skip=${skip:-$skip_all}

  if [[ "$skip" != "true" ]]; then
    [[ "$backup" == "true" ]] && backup_file $dst
    [[ "$overwrite" == "true" ]] && remove_file $dst

    mkdir -p $(dirname $dst)
    symlink $src $dst
  else
    success "Skipping $src"
  fi
}


prompt_user_for_action () {
  local src=$1
  local dst=$2

  user "File already exists: $dst ($(basename "$src"))\r
       What do you want to do?\n\
      [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
  read -n 1 -s user_action
  echo "\r"

  case "$user_action" in
    s )
      skip=true;;
    S )
      skip_all=true;;
    b )
      backup=true;;
    B )
      backup_all=true;;
    o )
      overwrite=true;;
    O )
      overwrite_all=true;;
    * )
      error "Unrecognized value, terminating..";;
  esac
}


run_op () {
  local op=$1
  [[ $DEBUG == "true" ]] && debug "$op"
  eval $op
}


get_backup_dir () {
  echo "${DST_DIR}/${BACKUP_PREFIX}_${NOW}"
}


backup_file () {
  local file=$1

  local backup=${file/$DST_DIR/$(get_backup_dir)}
  mkdir -p $(dirname $backup)

  run_op "mv $file $backup"
  success "Moved $file to $backup"
}


remove_file () {
  local file=$1

  rm -rf $file
  success "Deleted $dst"
}


symlink() {
  local src=$1
  local dst=$2

  action "Symlinking $src to $dst"
  run_op "ln -s $src $dst"
}


while getopts hvgd:f: flag
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
  esac
done


install_dotfiles

