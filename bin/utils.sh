#!/bin/bash

setbg() {
# From this link:
# https://maxmanders.co.uk/2017/04/15/iterm-tmux-vim-profile-switching.html
  local bg="$1"
  if egrep -q -i "light|dark" <(echo ${bg}); then
    vim -c ":set background=${bg}" +Tmuxline +qall
  fi
}
