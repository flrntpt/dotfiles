#!/bin/bash
#
# Commons

set -e
set -o errexit
set -o nounset
set -o pipefail

SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

COMMON_DIR="${SCRIPT_DIR}/common"
DOTFILES_DIR=$(dirname "$SCRIPT_DIR")

export COMMON_DIR
export DOTFILES_DIR

