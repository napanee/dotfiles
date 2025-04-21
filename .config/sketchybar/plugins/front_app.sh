#!/bin/sh

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

case $INFO in
  "Code")
    ICON=
    ;;
  "iTerm2")
    ICON=
    ;;
  "Google Chrome")
    ICON=
    ;;
  "Microsoft Teams")
    ICON=󰊻
    ;;
  "Spark Desktop")
    ICON=
    ;;
  "Finder")
    ICON=󰀶
    ;;
  *)
    ICON=
    ;;
esac

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set $NAME icon=$ICON
  sketchybar --set $NAME.name label="$INFO"
fi
