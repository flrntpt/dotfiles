#!/bin/sh
#
# Homebrew installation script
#
# Uses a Brewfile located in the same directory

HOMEBREW_INSTALL_URL=(
  "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
)


install_homebrew () {
  echo "Installing Homebrew"
  sh -c $(curl -fsSL $HOMEBREW_INSTALL_URL)
}


run_brew_bundle () {
  echo "Running brew update..."
  sh -c $(brew update)
  echo "Running brew bundle..."
  sh -c $(brew bundle)
}


if [[ "$(uname)" = "Darwin" ]]; then
  if [[ ! $(which brew) ]]; then
    install_homebrew
  else
    echo "Homebrew already installed, skipping installation..."
  fi
  run_brew_bundle
else
  echo "Not a macOS system, skipping homebrew installation..."
fi

