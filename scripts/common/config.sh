#!/bin/bash
#
# Config

DEBUG_DIRECTORY="DEBUG_INSTALL"
# Will be updated in case debug is false
# TODO: we need a better way to manage this
DST_DIR="$HOME/$DEBUG_DIRECTORY"

unset DEBUG_DIRECTORY

FORCE_PROMPT=false
BACKUP_DIRNAME="backups"

DEBUG=true

export DST_DIR BACKUP_DIRNAME
export DEBUG FORCE_PROMPT
