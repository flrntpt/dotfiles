#!/bin/sh
#
# Commons

set -e

SCRIPT_PATH=`realpath $0`
SCRIPT_DIR=`dirname $SCRIPT_PATH`
DOTFILES_DIR=`dirname $SCRIPT_DIR`
FORMATTING_SCRIPT_PATH="$SCRIPT_DIR/formatting.sh"

source $FORMATTING_SCRIPT_PATH

DEBUG_DIRECTORY="DEBUG_INSTALL"

DATE_FORMAT="%Y_%m_%dT%H_%M_%S"
NOW=$(date +${DATE_FORMAT})
BACKUP_DIRNAME="backups"


recurse_install () {
  local src=$1
  local get_destination_path=$2  # This is a function

  if [[ -d $src ]]; then
    for element in $src/*
    do
      recurse_install $element $get_destination_path
    done
  else
    install_one $src $get_destination_path
  fi
}


install_one () {
  local src=$1
  local get_destination_path=$2  # this is a function
  local dst=$($get_destination_path $src)
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


symlink () {
  local src=$1
  local dst=$2

  action "Symlinking $src to $dst"
  run_op "ln -s $src $dst"
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


run_op () {
  local op=$1
  [[ $DEBUG == "true" ]] && debug "$op"
  eval $op
}


get_backup_dir () {
  echo "${DST_DIR}/${BACKUP_DIRNAME}/${BACKUP_PREFIX}_${NOW}"
}

