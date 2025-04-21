#!/bin/sh

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"
ICON_PADDING_RIGHT=8

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  100)
    ICON="󱊣"
    ICON_PADDING_RIGHT=0
    ;;
  [7-9][0-9])
    ICON="󱊣"
    ;;
  [4-6][0-9])
    ICON="󱊢"
    ;;
  [1-3][0-9])
    ICON="󱊡"
    ;;
  [1-9])
    ICON="󰂎"
    ;;
  *)
    ICON=""
    ICON_PADDING_RIGHT=18
esac

if [[ "$CHARGING" != "" ]]; then
  ICON="󰂄"
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" icon.padding_right=$ICON_PADDING_RIGHT label="${PERCENTAGE}%"
