#!/bin/bash
#
# Install commons

set -e

. "$COMMON_DIR/formatting.sh"

DEBUG_DIRECTORY="DEBUG_INSTALL"
DST_DIR="$HOME/$DEBUG_DIRECTORY"  # Will be updated if debug is false
DATE_FORMAT="%Y_%m_%dT%H_%M_%S"
NOW=$(date +${DATE_FORMAT})
BACKUP_DIRNAME="backups"

FORCE_PROMPT=false

# Have to declare to avoid "unbound variable" errors
# But it's dangerous to declare globally without a lock
# TODO: improve
skip_all= backup_all= overwrite_all=


recurse_install () {
  local src=$1
  local get_destination_path=$2  # This is a function

  if [[ -d $src ]]; then
    for element in "$src"/*
    do
      recurse_install "$element" "$get_destination_path"
    done
  else
    install_one "$src" "$get_destination_path"
  fi
}


install_one () {
  local src=$1
  local get_destination_path=$2  # this is a function
  local dst; dst=$($get_destination_path "$src")
  info "Installing $src to $dst"
  
  local skip="" backup="" overwrite=""

  if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]; then

    if [[ $skip_all != "true" ]] && \
       [[ $backup_all != "true" ]] && \
       [[ $overwrite_all != "true" ]]; then

      # If FORCE_PROMPT is set to true
      # It will prompt even if symlink is the same
      if [[ $(readlink "$dst") == "$src" ]] && \
         [[ $FORCE_PROMPT != "true" ]]; then
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
    if [[ "$backup" == "true" ]]; then
      local backup=${dst/$DST_DIR/$(get_backup_dir)}
      backup_file "$dst" "$backup"
    fi
    [[ "$overwrite" == "true" ]] && remove_file "$dst"

    mkdir -p "$(dirname "$dst")"
    symlink "$src" "$dst"
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
  # /dev/tty required because we're called from a while read loop
  read -n 1 -s user_action 0</dev/tty

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
  local backup=$2

  # local backup=${file/$DST_DIR/$(get_backup_dir)}
  mkdir -p "$(dirname "$backup")"

  run_op "mv $file $backup"
  success "Moved $file to $backup"
}


remove_file () {
  local file=$1

  rm -rf "$file"
  success "Deleted $file"
}


run_op () {
  local op=$1
  [[ $DEBUG == "true" ]] && debug "$op"
  eval "$op"
}


get_backup_dir () {
  echo "${DST_DIR}/${BACKUP_DIRNAME}/${BACKUP_PREFIX}_${NOW}"
}
