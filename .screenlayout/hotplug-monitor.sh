#!/bin/sh
#
# Wrapper für udev: Führt autoselect.sh als User martin mit Display-Zugriff aus.
# udev läuft als root ohne X-Session-Kontext, deshalb brauchen wir diesen Umweg.
#

USER="martin"
USER_ID=1000

# Kurz warten, damit xrandr die neuen Outputs erkennt
sleep 2

# autoselect.sh im Kontext des Users ausführen
export DISPLAY=":0"
export XAUTHORITY="/home/$USER/.Xauthority"
export HOME="/home/$USER"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"

su "$USER" -c "/home/$USER/.screenlayout/autoselect.sh"
