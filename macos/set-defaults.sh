#!/bin/bash
#
# Settings for MacOS


# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Enable 'Automatically hide and show the Dock'
defaults write com.apple.dock autohide -bool true

# Prevent Time Machine from prompting to use newly connected storage as backup volumes.
defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool "true"

# Hide Desktop Icons Completely
defaults write com.apple.finder CreateDesktop -bool false

# Hide recent apps from Dock
defaults write com.apple.dock "show-recents" -bool "false"

# Hot-corners

# Top-Right (tr) shows mission-control
defaults write com.apple.dock wvous-tr-corner -int 2

# Bottom-Right (br) shows the Desktop
defaults write com.apple.dock wvous-br-corner -int 4

# Bottom-Left (bl) starts Screen Saver
defaults write com.apple.dock wvous-bl-corner -int 5

# Disable ApplePressAndHold for specific apps
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write com.jetbrains.pycharm ApplePressAndHoldEnabled -bool false
defaults delete -g ApplePressAndHoldEnabled  # If necessary, reset global default

# killall
killall Finder
killall Dock

