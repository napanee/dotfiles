#!/bin/sh

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
  ICON_PADDING_RIGHT=0

  case "$VOLUME" in
    100)
      ICON="󰕾"
      ;;
    [6-9][0-9])
      ICON="󰕾"
      ICON_PADDING_RIGHT=8
      ;;
    [3-5][0-9])
      ICON="󰖀"
      ICON_PADDING_RIGHT=8
      ;;
    [1-2][0-9])
      ICON="󰖀"
      ICON_PADDING_RIGHT=8
      ;;
    [1-9])
      ICON="󰖀"
      ICON_PADDING_RIGHT=16
      ;;
    *)
      ICON="󰖁"
      ICON_PADDING_RIGHT=16
  esac

  sketchybar --set "$NAME" icon="$ICON" icon.padding_right=$ICON_PADDING_RIGHT label="$VOLUME%"
fi
