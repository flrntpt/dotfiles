#!/bin/sh
#
# Commons

set -e

SCRIPT_PATH=`realpath $0`
SCRIPT_DIR=`dirname $SCRIPT_PATH`
DOTFILES_DIR=`dirname $SCRIPT_DIR`
FORMATTING_SCRIPT_PATH="$SCRIPT_DIR/formatting.sh"

DEBUG_DIRECTORY="DEBUG_INSTALL"


run_op () {
  local op=$1
  [[ $DEBUG == "true" ]] && debug "$op"
  eval $op
}

