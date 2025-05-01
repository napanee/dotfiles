#!/bin/sh

source "$CONFIG_DIR/config/colors.sh"

RESULT=$(./node_modules/.bin/tsx --env-file=.env $CONFIG_DIR/plugins/gitlab.ts)
read -r APPROVED NOT_APPROVED OTHERS <<< $RESULT

sketchybar --set "$NAME".approved label=$APPROVED \
           --set "$NAME".notapproved label=$NOT_APPROVED \
           --set "$NAME".others label=$OTHERS
