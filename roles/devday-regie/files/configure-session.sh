#!/bin/sh

gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.mate.Marco.general mouse-button-modifier '<Super>'
gsettings set org.mate.peripherals-keyboard-xkb.kbd layouts "['de']"
gsettings set org.mate.screensaver idle-activation-enabled false
gsettings set org.mate.screensaver lock-enabled false
xset s off
xset -dpms
