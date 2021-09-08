#!/bin/bash
#
# Constants

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
unset SCRIPT_DIR

export DOTFILES_DIR
