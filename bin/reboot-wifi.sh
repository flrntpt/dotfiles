#!/bin/sh
#
# Reboot the wifi on macOS, useful when ???

sudo ifconfig en1 down
sudo route flush
sudo ifconfig en1 up

